# >---------------------------------------------------------------------------<
#
#            _____       _ _
#           |  __ \     (_) |       /\
#           | |__) |__ _ _| |___   /  \   _ __  _ __  ___
#           |  _  // _` | | / __| / /\ \ | '_ \| '_ \/ __|
#           | | \ \ (_| | | \__ \/ ____ \| |_) | |_) \__ \
#           |_|  \_\__,_|_|_|___/_/    \_\ .__/| .__/|___/
#                                        | |   | |
#                                        |_|   |_|
#
#   Application template generated by the rails_apps_composer gem.
#   Restrain your impulse to make changes to this file; instead,
#   make changes to the recipes in the rails_apps_composer gem.
#
#   For more information, see:
#   https://github.com/RailsApps/rails_apps_composer/
#
#   Thank you to Michael Bleigh for leading the way with the RailsWizard gem.
#
# >---------------------------------------------------------------------------<

# >----------------------------[ Initial Setup ]------------------------------<

module Gemfile
  class GemInfo
    def initialize(name) @name=name; @group=[]; @opts={}; end
    attr_accessor :name, :version
    attr_reader :group, :opts

    def opts=(new_opts={})
      new_group = new_opts.delete(:group)
      if (new_group && self.group != new_group)
        @group = ([self.group].flatten + [new_group].flatten).compact.uniq.sort
      end
      @opts = (self.opts || {}).merge(new_opts)
    end

    def group_key() @group end

    def gem_args_string
      args = ["'#{@name}'"]
      args << "'#{@version}'" if @version
      @opts.each do |name,value|
        args << ":#{name}=>#{value.inspect}"
      end
      args.join(', ')
    end
  end

  @geminfo = {}

  class << self
    # add(name, version, opts={})
    def add(name, *args)
      name = name.to_s
      version = args.first && !args.first.is_a?(Hash) ? args.shift : nil
      opts = args.first && args.first.is_a?(Hash) ? args.shift : {}
      @geminfo[name] = (@geminfo[name] || GemInfo.new(name)).tap do |info|
        info.version = version if version
        info.opts = opts
      end
    end

    def write
      File.open('Gemfile', 'a') do |file|
        file.puts
        grouped_gem_names.sort.each do |group, gem_names|
          indent = ""
          unless group.empty?
            file.puts "group :#{group.join(', :')} do" unless group.empty?
            indent="  "
          end
          gem_names.sort.each do |gem_name|
            file.puts "#{indent}gem #{@geminfo[gem_name].gem_args_string}"
          end
          file.puts "end" unless group.empty?
          file.puts
        end
      end
    end

    private
    #returns {group=>[...gem names...]}, ie {[:development, :test]=>['rspec-rails', 'mocha'], :assets=>[], ...}
    def grouped_gem_names
      {}.tap do |_groups|
        @geminfo.each do |gem_name, geminfo|
          (_groups[geminfo.group_key] ||= []).push(gem_name)
        end
      end
    end
  end
end
def add_gem(*all) Gemfile.add(*all); end

@recipes = ["bin_scripts", "database", "devise_token_auth", "procfile", "performance_evaluation", "production_gems", "puma", "dotenv", "derailed", "rack_mini_profiler", "stackprof", "rack_canonical_host", "sass_setup", "bullet", "cors", "rollbar", "bourbon", "spring_commands_rspec"]
@prefs = {}
@gems = []
@diagnostics_recipes = [["example"], ["setup"], ["railsapps"], ["gems", "setup"], ["gems", "readme", "setup"], ["extras", "gems", "readme", "setup"], ["example", "git"], ["git", "setup"], ["git", "railsapps"], ["gems", "git", "setup"], ["gems", "git", "readme", "setup"], ["extras", "gems", "git", "readme", "setup"], ["email", "extras", "frontend", "gems", "git", "init", "railsapps", "readme", "setup", "testing"], ["core", "email", "extras", "frontend", "gems", "git", "init", "railsapps", "readme", "setup", "testing"], ["core", "email", "extras", "frontend", "gems", "git", "init", "railsapps", "readme", "setup", "testing"], ["core", "email", "extras", "frontend", "gems", "git", "init", "railsapps", "readme", "setup", "testing"], ["email", "example", "extras", "frontend", "gems", "git", "init", "railsapps", "readme", "setup", "testing"], ["email", "example", "extras", "frontend", "gems", "git", "init", "railsapps", "readme", "setup", "testing"], ["email", "example", "extras", "frontend", "gems", "git", "init", "railsapps", "readme", "setup", "testing"], ["apps4", "core", "email", "extras", "frontend", "gems", "git", "init", "railsapps", "readme", "setup", "testing"], ["apps4", "core", "email", "extras", "frontend", "gems", "git", "init", "railsapps", "readme", "setup", "tests"], ["apps4", "core", "deployment", "email", "extras", "frontend", "gems", "git", "init", "railsapps", "readme", "setup", "testing"], ["apps4", "core", "deployment", "email", "extras", "frontend", "gems", "git", "init", "railsapps", "readme", "setup", "tests"], ["apps4", "core", "deployment", "devise", "email", "extras", "frontend", "gems", "git", "init", "omniauth", "pundit", "railsapps", "readme", "setup", "tests"]]
@diagnostics_prefs = []
diagnostics = {}

# >-------------------------- templates/helpers.erb --------------------------start<
def recipes; @recipes end
def recipe?(name); @recipes.include?(name) end
def prefs; @prefs end
def prefer(key, value); @prefs[key].eql? value end
def gems; @gems end
def diagnostics_recipes; @diagnostics_recipes end
def diagnostics_prefs; @diagnostics_prefs end

def say_custom(tag, text); say "\033[1m\033[36m" + tag.to_s.rjust(10) + "\033[0m" + "  #{text}" end
def say_loud(tag, text); say "\033[1m\033[36m" + tag.to_s.rjust(10) + "  #{text}" + "\033[0m" end
def say_recipe(name); say "\033[1m\033[36m" + "recipe".rjust(10) + "\033[0m" + "  Running #{name} recipe..." end
def say_wizard(text); say_custom(@current_recipe || 'composer', text) end

def ask_wizard(question)
  ask "\033[1m\033[36m" + ("option").rjust(10) + "\033[1m\033[36m" + "  #{question}\033[0m"
end

def whisper_ask_wizard(question)
  ask "\033[1m\033[36m" + ("choose").rjust(10) + "\033[0m" + "  #{question}"
end

def yes_wizard?(question)
  answer = ask_wizard(question + " \033[33m(y/n)\033[0m")
  case answer.downcase
    when "yes", "y"
      true
    when "no", "n"
      false
    else
      yes_wizard?(question)
  end
end

def no_wizard?(question); !yes_wizard?(question) end

def multiple_choice(question, choices)
  say_custom('option', "\033[1m\033[36m" + "#{question}\033[0m")
  values = {}
  choices.each_with_index do |choice,i|
    values[(i + 1).to_s] = choice[1]
    say_custom( (i + 1).to_s + ')', choice[0] )
  end
  answer = whisper_ask_wizard("Enter your selection:") while !values.keys.include?(answer)
  values[answer]
end

@current_recipe = nil
@configs = {}

@after_blocks = []
def stage_two(&block); @after_blocks << [@current_recipe, block]; end
@stage_three_blocks = []
def stage_three(&block); @stage_three_blocks << [@current_recipe, block]; end
@stage_four_blocks = []
def stage_four(&block); @stage_four_blocks << [@current_recipe, block]; end
@before_configs = {}
def before_config(&block); @before_configs[@current_recipe] = block; end

def copy_from(source, destination)
  begin
    remove_file destination
    get source, destination
  rescue OpenURI::HTTPError
    say_wizard "Unable to obtain #{source}"
  end
end

def copy_from_repo(filename, opts = {})
  repo = 'https://raw.github.com/RailsApps/rails-composer/master/files/'
  repo = opts[:repo] unless opts[:repo].nil?
  if (!opts[:prefs].nil?) && (!prefs.has_value? opts[:prefs])
    return
  end
  source_filename = filename
  destination_filename = filename
  unless opts[:prefs].nil?
    if filename.include? opts[:prefs]
      destination_filename = filename.gsub(/\-#{opts[:prefs]}/, '')
    end
  end
  if (prefer :templates, 'haml') && (filename.include? 'views')
    remove_file destination_filename
    destination_filename = destination_filename.gsub(/.erb/, '.haml')
  end
  if (prefer :templates, 'slim') && (filename.include? 'views')
    remove_file destination_filename
    destination_filename = destination_filename.gsub(/.erb/, '.slim')
  end
  begin
    remove_file destination_filename
    if (prefer :templates, 'haml') && (filename.include? 'views')
      create_file destination_filename, html_to_haml(repo + source_filename)
    elsif (prefer :templates, 'slim') && (filename.include? 'views')
      create_file destination_filename, html_to_slim(repo + source_filename)
    else
      get repo + source_filename, destination_filename
    end
  rescue OpenURI::HTTPError
    say_wizard "Unable to obtain #{source_filename} from the repo #{repo}"
  end
end

def html_to_haml(source)
  begin
    html = open(source) {|input| input.binmode.read }
    Html2haml::HTML.new(html, :erb => true, :xhtml => true).render
  rescue RubyParser::SyntaxError
    say_wizard "Ignoring RubyParser::SyntaxError"
    # special case to accommodate https://github.com/RailsApps/rails-composer/issues/55
    html = open(source) {|input| input.binmode.read }
    say_wizard "applying patch" if html.include? 'card_month'
    say_wizard "applying patch" if html.include? 'card_year'
    html = html.gsub(/, {add_month_numbers: true}, {name: nil, id: "card_month"}/, '')
    html = html.gsub(/, {start_year: Date\.today\.year, end_year: Date\.today\.year\+10}, {name: nil, id: "card_year"}/, '')
    result = Html2haml::HTML.new(html, :erb => true, :xhtml => true).render
    result = result.gsub(/select_month nil/, "select_month nil, {add_month_numbers: true}, {name: nil, id: \"card_month\"}")
    result = result.gsub(/select_year nil/, "select_year nil, {start_year: Date.today.year, end_year: Date.today.year+10}, {name: nil, id: \"card_year\"}")
  end
end

def html_to_slim(source)
  html = open(source) {|input| input.binmode.read }
  haml = Html2haml::HTML.new(html, :erb => true, :xhtml => true).render
  Haml2Slim.convert!(haml)
end

# full credit to @mislav in this StackOverflow answer for the #which() method:
# - http://stackoverflow.com/a/5471032
def which(cmd)
  exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
  ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
    exts.each do |ext|
    exe = "#{path}#{File::SEPARATOR}#{cmd}#{ext}"
      return exe if File.executable? exe
    end
  end
  return nil
end
# >-------------------------- templates/helpers.erb --------------------------end<

say_wizard("\033[1m\033[36m" + "" + "\033[0m")

say_wizard("\033[1m\033[36m" + ' _____       _ _' + "\033[0m")
say_wizard("\033[1m\033[36m" + "|  __ \\     \(_\) |       /\\" + "\033[0m")
say_wizard("\033[1m\033[36m" + "| |__) |__ _ _| |___   /  \\   _ __  _ __  ___" + "\033[0m")
say_wizard("\033[1m\033[36m" + "|  _  /\/ _` | | / __| / /\\ \\ | \'_ \| \'_ \\/ __|" + "\033[0m")
say_wizard("\033[1m\033[36m" + "| | \\ \\ (_| | | \\__ \\/ ____ \\| |_) | |_) \\__ \\" + "\033[0m")
say_wizard("\033[1m\033[36m" + "|_|  \\_\\__,_|_|_|___/_/    \\_\\ .__/| .__/|___/" + "\033[0m")
say_wizard("\033[1m\033[36m" + "                             \| \|   \| \|" + "\033[0m")
say_wizard("\033[1m\033[36m" + "                             \| \|   \| \|" + "\033[0m")
say_wizard("\033[1m\033[36m" + '' + "\033[0m")
say_wizard("\033[1m\033[36m" + "Support the KICKSTARTER for Rails Composer" + "\033[0m")
say_wizard("\033[1m\033[36m" + "please act before June 4, 2017" + "\033[0m")
say_wizard("\033[1m\033[36m" + "https://www.kickstarter.com/projects/909377477/rails-composer-for-rails-51" + "\033[0m")
say_wizard("Need help? Ask on Stack Overflow with the tag \'railsapps.\'")
say_wizard("Your new application will contain diagnostics in its README file.")

if diagnostics_recipes.sort.include? recipes.sort
  diagnostics[:recipes] = 'success'
else
  diagnostics[:recipes] = 'fail'
end

# this application template only supports Rails version 4.1 and newer
case Rails::VERSION::MAJOR.to_s
when "5"
  say_wizard "You are using Rails version #{Rails::VERSION::STRING}. Please report any issues."
when "3"
  say_wizard "You are using Rails version #{Rails::VERSION::STRING} which is not supported. Use Rails 4.1 or newer."
  raise StandardError.new "Rails #{Rails::VERSION::STRING} is not supported. Use Rails 4.1 or newer."
when "4"
  case Rails::VERSION::MINOR.to_s
  when "0"
    say_wizard "You are using Rails version #{Rails::VERSION::STRING} which is not supported. Use Rails 4.1 or newer."
    raise StandardError.new "Rails #{Rails::VERSION::STRING} is not supported. Use Rails 4.1 or newer."
  end
else
  say_wizard "You are using Rails version #{Rails::VERSION::STRING} which is not supported. Use Rails 4.1 or newer."
  raise StandardError.new "Rails #{Rails::VERSION::STRING} is not supported. Use Rails 4.1 or newer."
end

# >---------------------------[ Autoload Modules/Classes ]-----------------------------<

inject_into_file 'config/application.rb', :after => 'config.autoload_paths += %W(#{config.root}/extras)' do <<-'RUBY'

    config.autoload_paths += %W(#{config.root}/lib)
RUBY
end

# >---------------------------------[ Recipes ]----------------------------------<

# >-------------------------- templates/recipe.erb ---------------------------start<
# >------------------------------[ bin_scripts ]------------------------------<
@current_recipe = "bin_scripts"
@before_configs["bin_scripts"].call if @before_configs["bin_scripts"]
say_recipe 'bin_scripts'
@configs[@current_recipe] = config
# >------------------------- recipes/bin_scripts.rb --------------------------start<

REPO = "https://raw.githubusercontent.com/verypossible/very-composer-recipes/master/files/".freeze

stage_two do
  %w(bin/init bin/up bin/down).each do |script|
    copy_from_repo script, repo: REPO
    chmod script, 0755
  end
end
# >------------------------- recipes/bin_scripts.rb --------------------------end<
# >-------------------------- templates/recipe.erb ---------------------------end<

# >-------------------------- templates/recipe.erb ---------------------------start<
# >-------------------------------[ database ]--------------------------------<
@current_recipe = "database"
@before_configs["database"].call if @before_configs["database"]
say_recipe 'database'
@configs[@current_recipe] = config
# >--------------------------- recipes/database.rb ---------------------------start<

REPO = "https://raw.githubusercontent.com/verypossible/very-composer-recipes/master/files/".freeze
gem "pg"

inject_into_file(
  "Gemfile",
  ", group: [:development, :test]",
  after: "gem 'sqlite3'"
)

stage_two do
  copy_from_repo "config/database.yml", repo: REPO
end
# >--------------------------- recipes/database.rb ---------------------------end<
# >-------------------------- templates/recipe.erb ---------------------------end<

# >-------------------------- templates/recipe.erb ---------------------------start<
# >---------------------------[ Devise Token Auth ]---------------------------<
@current_recipe = "devise_token_auth"
@before_configs["devise_token_auth"].call if @before_configs["devise_token_auth"]
say_recipe 'Devise Token Auth'
@configs[@current_recipe] = config
# >---------------------- recipes/Devise Token Auth.rb -----------------------start<

gem "devise_token_auth"

stage_three do
  run "bin/rails g devise_token_auth:install User api/auth"
  inject_into_file(
    "config/routes.rb",
    ", skip: [:omniauth_callbacks]",
    after: "at: 'api/auth'"
  )
  gsub_file(
    "app/models/user.rb",
    ", :omniauthable",
    ""
  )
  run "bin/rails db:migrate"
end
# >---------------------- recipes/Devise Token Auth.rb -----------------------end<
# >-------------------------- templates/recipe.erb ---------------------------end<

# >-------------------------- templates/recipe.erb ---------------------------start<
# >-------------------------------[ procfile ]--------------------------------<
@current_recipe = "procfile"
@before_configs["procfile"].call if @before_configs["procfile"]
say_recipe 'procfile'
@configs[@current_recipe] = config
# >--------------------------- recipes/procfile.rb ---------------------------start<

REPO = "https://raw.githubusercontent.com/verypossible/very-composer-recipes/master/files/".freeze

stage_two do
  copy_from_repo "Procfile", repo: REPO
end
# >--------------------------- recipes/procfile.rb ---------------------------end<
# >-------------------------- templates/recipe.erb ---------------------------end<

# >-------------------------- templates/recipe.erb ---------------------------start<
# >------------------------[ performance_evaluation ]-------------------------<
@current_recipe = "performance_evaluation"
@before_configs["performance_evaluation"].call if @before_configs["performance_evaluation"]
say_recipe 'performance_evaluation'
@configs[@current_recipe] = config
# >-------------------- recipes/performance_evaluation.rb --------------------start<


# >-------------------- recipes/performance_evaluation.rb --------------------end<
# >-------------------------- templates/recipe.erb ---------------------------end<

# >-------------------------- templates/recipe.erb ---------------------------start<
# >----------------------------[ production_gems ]----------------------------<
@current_recipe = "production_gems"
@before_configs["production_gems"].call if @before_configs["production_gems"]
say_recipe 'production_gems'
@configs[@current_recipe] = config
# >----------------------- recipes/production_gems.rb ------------------------start<

gem_group :production do
  gem "lograge"
  gem "newrelic_rpm"
  gem "rack-timeout"
  gem "rails_12factor"
end
# >----------------------- recipes/production_gems.rb ------------------------end<
# >-------------------------- templates/recipe.erb ---------------------------end<

# >-------------------------- templates/recipe.erb ---------------------------start<
# >---------------------------------[ puma ]----------------------------------<
@current_recipe = "puma"
@before_configs["puma"].call if @before_configs["puma"]
say_recipe 'puma'
@configs[@current_recipe] = config
# >----------------------------- recipes/puma.rb -----------------------------start<

REPO = "https://raw.githubusercontent.com/verypossible/very-composer-recipes/master/files/".freeze

stage_two do
  copy_from_repo "config/puma.rb", repo: REPO
end
# >----------------------------- recipes/puma.rb -----------------------------end<
# >-------------------------- templates/recipe.erb ---------------------------end<

# >-------------------------- templates/recipe.erb ---------------------------start<
# >--------------------------------[ dotenv ]---------------------------------<
@current_recipe = "dotenv"
@before_configs["dotenv"].call if @before_configs["dotenv"]
say_recipe 'dotenv'
@configs[@current_recipe] = config
# >---------------------------- recipes/dotenv.rb ----------------------------start<

REPO = "https://raw.githubusercontent.com/verypossible/very-composer-recipes/master/files/".freeze
gem "dotenv-rails", group: %i(development test)

stage_two do
  copy_from_repo ".env.example", repo: REPO
  get "#{REPO}/.env.example", ".env"
end
# >---------------------------- recipes/dotenv.rb ----------------------------end<
# >-------------------------- templates/recipe.erb ---------------------------end<

# >-------------------------- templates/recipe.erb ---------------------------start<
# >-------------------------------[ derailed ]--------------------------------<
@current_recipe = "derailed"
@before_configs["derailed"].call if @before_configs["derailed"]
say_recipe 'derailed'
@configs[@current_recipe] = config
# >--------------------------- recipes/derailed.rb ---------------------------start<

gem "derailed", group: :development
# >--------------------------- recipes/derailed.rb ---------------------------end<
# >-------------------------- templates/recipe.erb ---------------------------end<

# >-------------------------- templates/recipe.erb ---------------------------start<
# >--------------------------[ rack-mini-profiler ]---------------------------<
@current_recipe = "rack_mini_profiler"
@before_configs["rack_mini_profiler"].call if @before_configs["rack_mini_profiler"]
say_recipe 'rack-mini-profiler'
@configs[@current_recipe] = config
# >---------------------- recipes/rack-mini-profiler.rb ----------------------start<

gem "rack-mini-profiler", group: :development
# >---------------------- recipes/rack-mini-profiler.rb ----------------------end<
# >-------------------------- templates/recipe.erb ---------------------------end<

# >-------------------------- templates/recipe.erb ---------------------------start<
# >-------------------------------[ stackprof ]-------------------------------<
@current_recipe = "stackprof"
@before_configs["stackprof"].call if @before_configs["stackprof"]
say_recipe 'stackprof'
@configs[@current_recipe] = config
# >-------------------------- recipes/stackprof.rb ---------------------------start<

gem "stackprof", group: [:development, :test]
# >-------------------------- recipes/stackprof.rb ---------------------------end<
# >-------------------------- templates/recipe.erb ---------------------------end<

# >-------------------------- templates/recipe.erb ---------------------------start<
# >--------------------------[ rack-canonical-host ]--------------------------<
@current_recipe = "rack_canonical_host"
@before_configs["rack_canonical_host"].call if @before_configs["rack_canonical_host"]
say_recipe 'rack-canonical-host'
@configs[@current_recipe] = config
# >--------------------- recipes/rack-canonical-host.rb ----------------------start<

gem "rack-canonical-host"

middleware_setup = <<-TEXT

    config.application_host = ENV.fetch('APPLICATION_HOST')
    config.middleware.insert_after 0, Rack::CanonicalHost, config.application_host if Rails.env.production?
TEXT

inject_into_file(
  "config/application.rb",
  middleware_setup,
  after: "class Application < Rails::Application"
)

uncomment_lines(
  "config/environments/production.rb",
  "config.force_ssl = true"
)

inject_into_file(
  "config/environments/production.rb",
  "\n  config.ssl_options = { redirect: { host: config.application_host } }",
  after: "config.force_ssl = true"
)

mailer_host = <<-TEXT

  config.action_mailer.default_url_options = { host: config.application_host }
TEXT

%w(production development).each do |env|
  inject_into_file(
    "config/environments/#{env}.rb",
    mailer_host,
    after: "config.action_mailer.raise_delivery_errors = false"
  )
end
# >--------------------- recipes/rack-canonical-host.rb ----------------------end<
# >-------------------------- templates/recipe.erb ---------------------------end<

# >-------------------------- templates/recipe.erb ---------------------------start<
# >------------------------------[ sass_setup ]-------------------------------<
@current_recipe = "sass_setup"
@before_configs["sass_setup"].call if @before_configs["sass_setup"]
say_recipe 'sass_setup'
@configs[@current_recipe] = config
# >-------------------------- recipes/sass_setup.rb --------------------------start<

remove_file "app/assets/stylesheets/application.css"
create_file "app/assets/stylesheets/application.scss"
# >-------------------------- recipes/sass_setup.rb --------------------------end<
# >-------------------------- templates/recipe.erb ---------------------------end<

# >-------------------------- templates/recipe.erb ---------------------------start<
# >--------------------------------[ bullet ]---------------------------------<
@current_recipe = "bullet"
@before_configs["bullet"].call if @before_configs["bullet"]
say_recipe 'bullet'
@configs[@current_recipe] = config
# >---------------------------- recipes/bullet.rb ----------------------------start<

REPO = "https://raw.githubusercontent.com/verypossible/very-composer-recipes/master/files/".freeze
gem "bullet"

stage_two do
  copy_from_repo "config/initializers/bullet.rb", repo: REPO

  append_to_file ".env.example" do
    "BULLET_SHOW_ALERT=true\nBULLET_SHOW_FOOTER=true\n"
  end
end
# >---------------------------- recipes/bullet.rb ----------------------------end<
# >-------------------------- templates/recipe.erb ---------------------------end<

# >-------------------------- templates/recipe.erb ---------------------------start<
# >---------------------------------[ cors ]----------------------------------<
@current_recipe = "cors"
@before_configs["cors"].call if @before_configs["cors"]
say_recipe 'cors'
@configs[@current_recipe] = config
# >----------------------------- recipes/cors.rb -----------------------------start<

REPO = "https://raw.githubusercontent.com/verypossible/very-composer-recipes/master/files/".freeze
gem "rack-cors"

stage_two do
  copy_from_repo "config/initializers/cors.rb", repo: REPO

  append_to_file ".env.example" do
    "CORS_ORIGINS=localhost\n"
  end

  append_to_file ".env" do
    "CORS_ORIGINS=localhost\n"
  end
end
# >----------------------------- recipes/cors.rb -----------------------------end<
# >-------------------------- templates/recipe.erb ---------------------------end<

# >-------------------------- templates/recipe.erb ---------------------------start<
# >--------------------------------[ rollbar ]--------------------------------<
@current_recipe = "rollbar"
@before_configs["rollbar"].call if @before_configs["rollbar"]
say_recipe 'rollbar'
@configs[@current_recipe] = config
# >--------------------------- recipes/rollbar.rb ----------------------------start<

REPO = "https://raw.githubusercontent.com/verypossible/very-composer-recipes/master/files/".freeze
gem "rollbar"

stage_two do
  copy_from_repo "config/initializers/rollbar.rb", repo: REPO
  copy_from_repo "vendor/assets/javascripts/rollbar.js.erb", repo: REPO

  append_to_file ".env.example" do
    "ROLLBAR_CLIENT_ACCESS_TOKEN=''\nROLLBAR_SERVER_ACCESS_TOKEN=''\n"
  end
end
# >--------------------------- recipes/rollbar.rb ----------------------------end<
# >-------------------------- templates/recipe.erb ---------------------------end<

# >-------------------------- templates/recipe.erb ---------------------------start<
# >--------------------------------[ bourbon ]--------------------------------<
@current_recipe = "bourbon"
@before_configs["bourbon"].call if @before_configs["bourbon"]
say_recipe 'bourbon'
@configs[@current_recipe] = config
# >--------------------------- recipes/bourbon.rb ----------------------------start<

gem "bourbon"

stage_two do
  prepend_to_file "app/assets/stylesheets/application.scss",
                  "@import \"bourbon\";\n"
end
# >--------------------------- recipes/bourbon.rb ----------------------------end<
# >-------------------------- templates/recipe.erb ---------------------------end<

# >-------------------------- templates/recipe.erb ---------------------------start<
# >-------------------------[ spring-commands-rspec ]-------------------------<
@current_recipe = "spring_commands_rspec"
@before_configs["spring_commands_rspec"].call if @before_configs["spring_commands_rspec"]
say_recipe 'spring-commands-rspec'
@configs[@current_recipe] = config
# >-------------------- recipes/spring-commands-rspec.rb ---------------------start<

gem "spring-commands-rspec", group: :development
# >-------------------- recipes/spring-commands-rspec.rb ---------------------end<
# >-------------------------- templates/recipe.erb ---------------------------end<


# >-----------------------------[ Final Gemfile Write ]------------------------------<
Gemfile.write

# >---------------------------------[ Diagnostics ]----------------------------------<

# remove prefs which are diagnostically irrelevant
redacted_prefs = prefs.clone
redacted_prefs.delete(:ban_spiders)
redacted_prefs.delete(:better_errors)
redacted_prefs.delete(:pry)
redacted_prefs.delete(:dev_webserver)
redacted_prefs.delete(:git)
redacted_prefs.delete(:github)
redacted_prefs.delete(:jsruntime)
redacted_prefs.delete(:local_env_file)
redacted_prefs.delete(:main_branch)
redacted_prefs.delete(:prelaunch_branch)
redacted_prefs.delete(:prod_webserver)
redacted_prefs.delete(:rvmrc)
redacted_prefs.delete(:templates)

if diagnostics_prefs.include? redacted_prefs
  diagnostics[:prefs] = 'success'
else
  diagnostics[:prefs] = 'fail'
end

@current_recipe = nil

# >-----------------------------[ Run 'Bundle Install' ]-------------------------------<

say_wizard "Installing Bundler (in case it is not installed)."
run 'gem install bundler'
say_wizard "Installing gems. This will take a while."
run 'bundle install --without production'
say_wizard "Updating gem paths."
Gem.clear_paths
# >-----------------------------[ Run 'stage_two' Callbacks ]-------------------------------<

say_wizard "Stage Two (running recipe 'stage_two' callbacks)."
if prefer :templates, 'haml'
  say_wizard "importing html2haml conversion tool"
  require 'html2haml'
end
if prefer :templates, 'slim'
say_wizard "importing html2haml and haml2slim conversion tools"
  require 'html2haml'
  require 'haml2slim'
end
@after_blocks.each{|b| config = @configs[b[0]] || {}; @current_recipe = b[0]; puts @current_recipe; b[1].call}

# >-----------------------------[ Run 'stage_three' Callbacks ]-------------------------------<

@current_recipe = nil
say_wizard "Stage Three (running recipe 'stage_three' callbacks)."
@stage_three_blocks.each{|b| config = @configs[b[0]] || {}; @current_recipe = b[0]; puts @current_recipe; b[1].call}

# >-----------------------------[ Run 'stage_four' Callbacks ]-------------------------------<

@current_recipe = nil
say_wizard "Stage Four (running recipe 'stage_four' callbacks)."
@stage_four_blocks.each{|b| config = @configs[b[0]] || {}; @current_recipe = b[0]; puts @current_recipe; b[1].call}

@current_recipe = nil
say_wizard("Your new application will contain diagnostics in its README file.")
say_wizard("When reporting an issue on GitHub, include the README diagnostics.")
say_wizard "Finished running the rails_apps_composer app template."
say_wizard "Your new Rails app is ready. Time to run 'bundle install'."
