Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbZKTRvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbZKTRvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbZKTRvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:51:42 -0500
Received: from mail.atheros.com ([12.36.123.2]:43930 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbZKTRvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:51:42 -0500
Date: Fri, 20 Nov 2009 09:51:42 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "sam@ravnborg.org" <sam@ravnborg.org>,
       "greg@kroah.com" <greg@kroah.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mcgrof@gmail.com" <mcgrof@gmail.com>
Subject: Re: [PATCH 4/4] kconfig: streamline_config.pl: let users specify
	the list of desired modules
Message-ID: <20091120175142.GD13136@tux>
References: <1258732254-15573-1-git-send-email-alan-jenkins@tuffmail.co.uk> <1258732254-15573-2-git-send-email-alan-jenkins@tuffmail.co.uk> <1258732254-15573-3-git-send-email-alan-jenkins@tuffmail.co.uk> <1258732254-15573-4-git-send-email-alan-jenkins@tuffmail.co.uk> <1258732254-15573-5-git-send-email-alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1258732254-15573-5-git-send-email-alan-jenkins@tuffmail.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 07:50:54AM -0800, Alan Jenkins wrote:
> This allows "make localmodconfig MODULES_LIST=lsmod.out",
> where "lsmod.out" may have been created on a different system.
> 
> You can also use this with a manually editted file which
> simply lists the desired modules.

The current localmodconfig is designed to be run on your own system,
not an external system. The changes outlined here give no guidelines
to users what they should do if they want to use this on another system
and a novice user may just assume an old distribution config file
can be used here along with an lsmod output. If this is the case
it should be documented as such but I don't think this is the case.
Consider the case of someone trying to build a kernel for a single
processor ARM or x86 netbook/nettop on a beefy quad core x86_64.

Think this is definitely better than my approach though, that's for sure :)

Thanks for working on it :)

> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> ---
>  README                               |    8 ++++++++
>  scripts/kconfig/Makefile             |    3 ++-
>  scripts/kconfig/streamline_config.pl |   17 ++++++++++++++---
>  3 files changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/README b/README
> index 737838f..9481dd5 100644
> --- a/README
> +++ b/README
> @@ -175,6 +175,14 @@ CONFIGURING the kernel:
>                            Like above, but avoids cluttering the screen
>                            with questions already answered.
>                            Additionally updates the dependencies.
> +
> +       "make localmodconfig"
> +                          Minimize your existing ./.config file, based
> +                          on the kernel modules currently loaded on your
> +                          system.  You can also specify the list of
> +                          modules manually by appending an option
> +                          "MODULES_LIST=lsmod.out".

Best to add a plain entry for localmodconfig separately and then just
add the new stuff for MODULES_LIST on another patch.

> +
>         "make defconfig"   Create a ./.config file by using the default
>                            symbol values from either arch/$ARCH/defconfig
>                            or arch/$ARCH/configs/${PLATFORM}_defconfig,
> diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
> index 6d69c7c..6a1e41d 100644
> --- a/scripts/kconfig/Makefile
> +++ b/scripts/kconfig/Makefile
> @@ -30,7 +30,7 @@ silentoldconfig: $(obj)/conf
>         $< -s $(Kconfig)
> 
>  localmodconfig: $(obj)/streamline_config.pl $(obj)/conf
> -       $(Q)perl $< $(Kconfig) > .tmp.config
> +       $(Q)perl $< $(Kconfig) $(MODULES_LIST) > .tmp.config
>         $(Q)if [ -f .config ]; then                             \
>                         cmp -s .tmp.config .config ||           \
>                         (mv -f .config .config.old.1;           \
> @@ -114,6 +114,7 @@ help:
>         @echo  '  gconfig         - Update current config utilising a GTK based front-end'
>         @echo  '  oldconfig       - Update current config utilising a provided .config as base'
>         @echo  '  localmodconfig  - Update current config disabling modules not loaded'
> +       @echo  '                    (or modules not listed in the file MODULES_LIST)'
>         @echo  '  localyesconfig  - Update current config converting local mods to core'
>         @echo  '  silentoldconfig - Same as oldconfig, but quietly, additionally update deps'
>         @echo  '  randconfig      - New config with random answer to all options'
> diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
> index f5b44c1..9fde7fd 100644
> --- a/scripts/kconfig/streamline_config.pl
> +++ b/scripts/kconfig/streamline_config.pl
> @@ -40,7 +40,7 @@ use warnings;
>  #
>  #    cd /usr/src/linux-2.6.10
>  #    cp /boot/config-2.6.10-1-686-smp .config
> -#    ~/bin/streamline_config > config_strip
> +#    ~/bin/streamline_config arch/x86/Kconfig > config_strip

Why was x86 added here?

>  #    mv .config config_sav
>  #    mv config_strip .config
>  #    make oldconfig
> @@ -122,9 +122,15 @@ my %objects;
>  my $var;
>  my $cont = 0;
> 
> +if ($#ARGV < 0 || $#ARGV > 1) {
> +    die "usage: streamline_config.pl <Kconfig> [<modules.list>]"
> +}
> +
>  # Get the top level Kconfig file (passed in)
>  my $kconfig = $ARGV[0];
> 
> +my $modules_list = $ARGV[1];
> +
>  # prevent recursion
>  my %read_kconfigs;
> 
> @@ -251,8 +257,13 @@ foreach my $makefile (@makefiles) {
> 
>  my %modules;
> 
> -# see what modules are loaded on this system
> -open(LIN,"/sbin/lsmod|") || die "Cant lsmod";
> +# see what modules are loaded
> +if ($modules_list) {
> +    open(LIN,$modules_list) || die "Can't open $modules_list";
> +} else {
> +    open(LIN,"/sbin/lsmod|") || die "Can't lsmod";
> +}
> +
>  while (<LIN>) {
>         next if (/^Module/);  # Skip the first line.
>         if (/^(\S+)/) {
> --
> 1.6.3.3
> 
