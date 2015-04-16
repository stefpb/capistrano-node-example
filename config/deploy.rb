# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'my-static-page'
set :repo_url, 'ssh://git@gitlab.baun.de:2211/stefaan/my-static-page.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/stefaan/my-static-page'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

	desc 'Install npm and bower dependencies'
	task :npm_bower do
		on roles(:app), in: :sequence do
			within release_path do
				execute :npm, 'install --production'
#				execute :bower, 'install --silent'
			end
		end
	end

	# Change the restart function to run "forever"
	desc 'Restart application'  
	task :restart do  
	  on roles(:app), in: :sequence, wait: 5 do
	    execute "forever stopall"
	    execute "forever start #{release_path.join('server.js')}"
	  end
	end

	after :updated, :npm_bower
	after :publishing, :restart

end
