class UsersController < ApplicationController
  before_filter :authenticate, :only  => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  
  def destroy
     @user.destroy    
    redirect_to users_path, :flash => {:success => "User destroyed."}
  end  
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  
  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def create
     
     @user = User.new(params[:user])
     if @user.save
       sign_in @user
       redirect_to @user, :flash => { :success  =>  "Welcome to the Sample App!" }
       # Handle a successful save
     else
      @title = "Sign up"
      render 'new'
    end
  end
  
  def edit
    @title = "Edit user"
  end
  
  def update
    if @user.update_attributes(params[:user])
      #it worked
       flash[:success]= "Profile updated"
       redirect_to @user
    else
      
      @title = "Edit user"
      render 'edit'
  end
end
  
  private
  
  def authenticate
    deny_access unless signed_in?
  end
  
  def deny_access
    redirect_to signin_path, :notice  => "Please sign in to access this page."
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
  
  def admin_user
    @user = User.find(params[:id])
    redirect_to(root_path) if !current_user.admin? || current_user?(@user)
  end
end
