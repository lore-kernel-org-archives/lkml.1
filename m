Return-Path: <linux-kernel-owner+w=401wt.eu-S1763378AbYD0UrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763378AbYD0UrZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 16:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbYD0UrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 16:47:13 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:46738 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbYD0UrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 16:47:12 -0400
Date: Sun, 27 Apr 2008 22:47:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 4/4] kconfig: add *_silentdefconfig feature for config targets
Message-ID: <20080427204744.GA444@uranus.ravnborg.org>
References: <20080425223530.10b9d50d@ephemeral>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080425223530.10b9d50d@ephemeral>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 10:35:30PM -0400, Andres Salomon wrote:
> 
> Being able to run 'silentoldconfig' with an existing .config has been
> immensely useful, especially for automated builds.  If the kernel code
> changes in an incompatible manner without the associated .config being
> updated, the build will fail and call attention to the need for an update.
> 
> AFAICT, there is nothing similar when using *_defconfig; one must copy
> a .config manually, and then run silentoldconfig.  Simply running the
> associated _defconfig will quietly update the config (which may silently
> drop config options).  This patch adds a *_silentdefconfig target, with
> semantics similar to silentoldconfig.  It will take the defconfig from
> arch/$(SRCARCH)/configs/$x_defconfig, check for changes, and if there are
> none, write out a .config.  If there have been changes and stdin is
> valid, it will prompt for updates.  If there have been changes and
> stdin is not valid, it will bail out with an error.

I like what you achieve by this patchset.
But I do not agree on the naming you chose.

We have today:
oldconfig	=> very chatty
silentoldconfig	=> Asks only relevant questions
defconfig	=> silent

[I plan one day to make oldconfig behave like
silentoldconfig and drop the chatty mode]

And I see why you went for the name *_silentdefconfig
But in reality what we want to say is that we want to
interactively apply the _defconfig.

So if we could come up with something where we told
that we want to interactively use i386_defconfig
then the users would hopefully be less confused.

I have considered a few way to do so:

a) make I=1 i386_defconfig
b) make i_i386_defconfig
c) make ii386_defconfig
d) make i386_config

And none of these are actually good.
Any better ideas here?

See a few comments below.

	Sam


> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> ---
>  Makefile                 |    4 ++++
>  scripts/kconfig/Makefile |    3 +++
>  scripts/kconfig/conf.c   |   13 +++++++++++--
>  3 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index e77149e..c264f7f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1225,6 +1225,10 @@ help:
>  		$(foreach b, $(boards), \
>  		printf "  %-24s - Build for %s\\n" $(b) $(subst _defconfig,,$(b));) \
>  		echo '')
> +	@$(if $(boards), \
> +		$(foreach b, $(boards), \
> +		printf "  %-24s - Quiet Build for %s\\n" $(subst _defconfig,_silentdefconfig,$(b)) $(subst _defconfig,,$(b));) \
> +		echo '')
This is the first time we use printf in the top-level Makefile.
Most likely because I never use printf in my shell scripts
so I guess this is not a problem.

>  
>  	@echo  '  make V=0|1 [targets] 0 => quiet build (default), 1 => verbose build'
>  	@echo  '  make V=2   [targets] 2 => give reason for rebuild of target'
> diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
> index ce7d754..19ba562 100644
> --- a/scripts/kconfig/Makefile
> +++ b/scripts/kconfig/Makefile
> @@ -72,6 +72,9 @@ endif
>  %_defconfig: $(obj)/conf
>  	$(Q)$< -d -D arch/$(SRCARCH)/configs/$@ $(Kconfig)
>  
> +%_silentdefconfig: $(obj)/conf
> +	$(Q)$< -s -o -D arch/$(SRCARCH)/configs/$(subst _silentdefconfig,_defconfig,$@) $(Kconfig)
> +
>  # Help text used by make help
>  help:
>  	@echo  '  config	  - Update current config utilising a line-oriented program'
> diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
> index 9a27638..264eee9 100644
> --- a/scripts/kconfig/conf.c
> +++ b/scripts/kconfig/conf.c
> @@ -558,7 +558,8 @@ int main(int ac, char **av)
>  		}
>  		break;
>  	case ask_new:
> -		if (silent_mode && stat(".config", &tmpstat)) {
> +		if (!defconfig_file && silent_mode &&
> +				stat(".config", &tmpstat)) {

This belong in a preparation patch. We should handle this
also if we do not do so from the Makefile.

>  			printf(_("***\n"
>  				"*** You have not yet configured your kernel!\n"
>  				"*** (missing kernel .config file)\n"
> @@ -570,7 +571,15 @@ int main(int ac, char **av)
>  		}
>  		/* fall through */
>  	case ask_all:
> -		conf_read(NULL);
> +		if (defconfig_file) {
> +			if (conf_read(defconfig_file)) {
> +				printf(_("***\n*** Can't find default "
> +					 "configuration \"%s\"!\n***\n"),
> +					 defconfig_file);
> +				exit(1);
> +			}
> +		} else
> +			conf_read(NULL);

Does conf_read() fail if we use the NULL argument?
I assume not so the above code can be simplified and
should also be in the same preparational patch as the change above.

	Sam
