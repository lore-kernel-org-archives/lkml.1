Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbZLIG2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbZLIG2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 01:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755503AbZLIG2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 01:28:11 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:39597 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbZLIG2J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 01:28:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=sJXBN3h07rxyOSeY+DqoBEfkUaCs1EsjG8OwhZDKBioevD84fYikry3t9BGQYDZ6QB
         vQ7YRf+1O+F1EXzhx45uoZ7GpS3bwOb1JjImqKbXn4xQuTH309jIMR1RDwACgALlj4lc
         cXGcE4Dq/hlsDsXkacP8QmVBPoCZEZLDAUzz4=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Nir Tzachar <nir.tzachar@gmail.com>
Subject: Re: [PATCH] MAINTAINERS: new kbuild maintainer
Date: Wed, 9 Dec 2009 07:28:10 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32-03931-g6035ccd-dirty; KDE/4.3.4; x86_64; ; )
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
References: <1260276751-19501-1-git-send-email-mmarek@suse.cz> <4B1EB5E9.3010506@suse.cz> <9b2db90b0912082222x5287d452pf9e55d6ff44e511c@mail.gmail.com>
In-Reply-To: <9b2db90b0912082222x5287d452pf9e55d6ff44e511c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912090728.10135.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 of December 2009, Nir Tzachar wrote:
> Hello.
> 
> On Tue, Dec 8, 2009 at 10:24 PM, Michal Marek <mmarek@suse.cz> wrote:
> > Arkadiusz Miskiewicz napsal(a):
> >> On Tuesday 08 of December 2009, Michal Marek wrote:
> >>> Arkadiusz Miskiewicz napsal(a):
> >>>> Maybe we can get colors back in menuconfig then? ;-)
> >>>> http://bugzilla.kernel.org/show_bug.cgi?id=13677
> >>>
> >>> Does it also happen with Nir's nconfig
> >>> (http://lkml.org/lkml/2009/11/25/119)?
> >>
> >> Yes, it does happen, I have non-color menus. That's because nconfig also
> >> mixes wide ncurses library with non wide ncurses headers.
> >>
> >>   gcc -Wp,-MD,scripts/kconfig/.nconf.o.d -Wall -Wmissing-prototypes
> >> -Wstrict- prototypes -O2 -fomit-frame-pointer   -I/usr/include/ncurses -
> >> DCURSES_LOC="<ncurses.h>" -DLOCALE   -c -o scripts/kconfig/nconf.o
> >> scripts/kconfig/nconf.c
> >>
> >> /usr/include/ncurses is non wide version of ncurses headers (but on
> >> other distros it could be done differently aka /usr/include/ncures being
> >> wide version)
> >>
> >>   gcc  -o scripts/kconfig/nconf scripts/kconfig/nconf.o
> >> scripts/kconfig/zconf.tab.o scripts/kconfig/nconf.gui.o -lncursesw
> >> -lmenu - lpanel -lncurses
> >>
> >> and here it's linked to non wide version of library (also to wide, too
> >> due to scripts/kconfig/lxdialog/check-lxdialog.sh putting it here)
> >>
> >> Anyway way to solve this is:
> >> - detect if ncurses header is wide or non-wide
> >> - link with proper ncurses library based on detected header
> >
> > Nir, you surely know ncurses better than me :). Could you look into
> > this?   Arkadiusz, which distribution are you using?
> >
> > Michal
> 
> Well, I see the problem, but it does not manifest on my machines.
> The thing is that lxdialog/check-lxdialog.sh always adds ncursesw to
> the library path, even if the narrow version exists. I believe this is
> set so that if there is only an installation of ncursesw everything
> will work fine. However, it does not take into account that on most
> systems (at least those I have seen) both of the versions are
> installed.
> 
> As nconfig does not use any wide version function, and I believe
> lxdialog does not also, I think we can remove ncursesw from the
> libraries.
> 
> Arkadiusz, do the patch below help?
> 
> diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh
> b/scripts/kconfig/lxdialog/check-lxdialog.sh
> index fcef0f5..5596d0c 100644
> --- a/scripts/kconfig/lxdialog/check-lxdialog.sh
> +++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
> @@ -5,7 +5,7 @@
>  ldflags()
>  {
>         for ext in so a dylib ; do
> -               for lib in ncursesw ncurses curses ; do
> +               for lib in ncurses curses ; do
>                         $cc -print-file-name=lib${lib}.${ext} | grep -q /
>                         if [ $? -eq 0 ]; then
>                                 echo "-l${lib}"
> 

On my disto it works but it won't on a distro where /usr/include/ncurses 
contains wide version of headers.

> 
> Moreover, currently nconfig does not use this check.

I was testing on linus git and this flags from this check were used in nconfig 
build, too (that's why there were ncurses and ncursesw at the same time in 
linking command).

> It should be made
> common to both mconf and nconf, and we need to make sure adding the
> appropriate libraries only to the targets which need them (currently,
> -lncurses is added to all targets in scripts/kbuild ...) Below is a
> very hackish patch which does this. However, having a proper Makefile
> for lxdialog would be much better.
> 
> diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
> index 6d69c7c..e0c7714 100644
> --- a/scripts/kconfig/Makefile
> +++ b/scripts/kconfig/Makefile
> @@ -23,6 +23,9 @@ menuconfig: $(obj)/mconf
>  config: $(obj)/conf
>  	$< $(Kconfig)
> 
> +nconfig: $(obj)/nconf
> +	$< $(Kconfig)
> +
>  oldconfig: $(obj)/conf
>  	$< -o $(Kconfig)
> 
> @@ -109,6 +112,7 @@ endif
>  # Help text used by make help
>  help:
>  	@echo  '  config	  - Update current config utilising a line-oriented
>  program' +	@echo  '  nconfig         - Update current config utilising a
> ncurses menu based program'
>  	@echo  '  menuconfig	  - Update current config utilising a menu based
>  program' @echo  '  xconfig	  - Update current config utilising a QT based
>  front-end' @echo  '  gconfig	  - Update current config utilising a GTK
>  based front-end' @@ -127,8 +131,8 @@ check-lxdialog  :=
> $(srctree)/$(src)/lxdialog/check-lxdialog.sh
> 
>  # Use recursively expanded variables so we do not call gcc unless
>  # we really need to do so. (Do not call gcc as part of make mrproper)
> -HOST_EXTRACFLAGS = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ccflags)
> -HOST_LOADLIBES   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags
> $(HOSTCC))
> +NCURSESCFLAGS = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ccflags)
> +NCURSESLIBS   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags
>  $(HOSTCC))
> 
>  HOST_EXTRACFLAGS += -DLOCALE
> 
> @@ -136,6 +140,8 @@ HOST_EXTRACFLAGS += -DLOCALE
>  #
>  ==========================================================================
> = # Shared Makefile for the various kconfig executables:
>  # conf:	  Used for defconfig, oldconfig and related targets
> +# nconf:  Used for the nconfig target.
> +#         Utilizes ncurses
>  # mconf:  Used for the menuconfig target
>  #         Utilizes the lxdialog package
>  # qconf:  Used for the xconfig target
> @@ -147,12 +153,30 @@ HOST_EXTRACFLAGS += -DLOCALE
>  lxdialog := lxdialog/checklist.o lxdialog/util.o lxdialog/inputbox.o
>  lxdialog += lxdialog/textbox.o lxdialog/yesno.o lxdialog/menubox.o
> 
> +HOSTCFLAGS_checklist.o = $(NCURSESCFLAGS)
> +HOSTCFLAGS_util.o = $(NCURSESCFLAGS)
> +HOSTCFLAGS_inputbox.o = $(NCURSESCFLAGS)
> +HOSTCFLAGS_textbox.o = $(NCURSESCFLAGS)
> +HOSTCFLAGS_yesno.o  = $(NCURSESCFLAGS)
> +HOSTCFLAGS_menubox.o = $(NCURSESCFLAGS)
> +HOSTCFLAGS_mconf.o = $(NCURSESCFLAGS)
> +
> +HOSTCFLAGS_nconf.gui.o = $(NCURSESCFLAGS)
> +HOSTCFLAGS_nconf.o = $(NCURSESCFLAGS)
> +
> +HOSTLOADLIBES_mconf = $(NCURSESLIBS)
> +
>  conf-objs	:= conf.o  zconf.tab.o
> -mconf-objs	:= mconf.o zconf.tab.o $(lxdialog)
> +mconf-objs     := mconf.o zconf.tab.o $(lxdialog)
> +nconf-objs     := nconf.o zconf.tab.o nconf.gui.o
>  kxgettext-objs	:= kxgettext.o zconf.tab.o
> 
>  hostprogs-y := conf qconf gconf kxgettext
> 
> +ifeq ($(MAKECMDGOALS),nconfig)
> +	hostprogs-y += nconf
> +endif
> +
>  ifeq ($(MAKECMDGOALS),menuconfig)
>  	hostprogs-y += mconf
>  endif
> @@ -176,14 +200,14 @@ endif
> 
>  clean-files	:= lkc_defs.h qconf.moc .tmp_qtcheck \
>  		   .tmp_gtkcheck zconf.tab.c lex.zconf.c zconf.hash.c gconf.glade.h
> -clean-files     += mconf qconf gconf
> +clean-files     += mconf qconf gconf nconf
>  clean-files     += config.pot linux.pot
> 
>  # Check that we have the required ncurses stuff installed for
> lxdialog (menuconfig)
>  PHONY += $(obj)/dochecklxdialog
>  $(addprefix $(obj)/,$(lxdialog)): $(obj)/dochecklxdialog
>  $(obj)/dochecklxdialog:
> -	$(Q)$(CONFIG_SHELL) $(check-lxdialog) -check $(HOSTCC)
> $(HOST_EXTRACFLAGS) $(HOST_LOADLIBES)
> +	$(Q)$(CONFIG_SHELL) $(check-lxdialog) -check $(HOSTCC)
> $(HOST_EXTRACFLAGS) $(HOST_LOADLIBES) $(NCURSESCFLAGS) $(NCURSESLIBS)
> 
>  always := dochecklxdialog
> 
> @@ -201,6 +225,7 @@ HOSTLOADLIBES_gconf	= `pkg-config --libs gtk+-2.0
> gmodule-2.0 libglade-2.0`
>  HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0
>  libglade-2.0` \ -D LKC_DIRECT_LINK
> 
> +HOSTLOADLIBES_nconf	= -lmenu -lpanel $(NCURSESLIBS)
>  $(obj)/qconf.o: $(obj)/.tmp_qtcheck
> 
>  ifeq ($(qconf-target),1)
> 


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
