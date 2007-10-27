Return-Path: <linux-kernel-owner+w=401wt.eu-S1752453AbXJ0HWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbXJ0HWV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 03:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbXJ0HWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 03:22:13 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52530 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbXJ0HWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 03:22:12 -0400
Date: Sat, 27 Oct 2007 09:23:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Check handling of kernel build output directory
Message-ID: <20071027072348.GA28566@uranus.ravnborg.org>
References: <fft89p$rko$1@ger.gmane.org> <20071026190500.GA23480@uranus.ravnborg.org> <ffteuq$n3b$1@ger.gmane.org> <20071026194727.GA23871@uranus.ravnborg.org> <ffuh39$d7b$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffuh39$d7b$1@ger.gmane.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus.

Please do not edit cc: and to: - it is easy to miss out a mail on lkml.

On Sat, Oct 27, 2007 at 07:07:55AM +0200, Markus Elfring wrote:
> > You did it in your output directory I assume.
> 
> No.
> 
> 
> > kbuild complains that the source directory is not clean - which
> > is what you need to clean up.
> 
> I am looking for the real reasons for the occuring error messages. Let us look at another
> test example ...
> 
> Sonne:~ # ls -ld /usr/src/linux
> lrwxrwxrwx 1 root root 23 Oct 13 10:11 /usr/src/linux -> /usr/src/linux-2.6.23.1
> Sonne:~ # cd /usr/src/linux-2.6.23.1
> Sonne:/usr/src/linux-2.6.23.1 # unset KBUILD_OUTPUT && make mrproper && cp -p
> /boot/config-2.6.23.1-0-adjusted .config && export
> KBUILD_OUTPUT=/usr/src/obj/linux/2.6.23.1/x86_64/adjusted && rm -rf $KBUILD_OUTPUT/*
>   CLEAN   .config
> Sonne:/usr/src/linux-2.6.23.1 # make oldconfig && date && echo
> XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX && make -j2 && echo
> YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY && make -j2 modules_install install && echo
> ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ && date
>   HOSTCC  scripts/basic/fixdep
>   HOSTCC  scripts/basic/docproc
>   GEN     /usr/src/obj/linux/2.6.23.1/x86_64/adjusted/Makefile
>   HOSTCC  scripts/kconfig/conf.o
>   HOSTCC  scripts/kconfig/kxgettext.o
>   SHIPPED scripts/kconfig/zconf.tab.c
>   SHIPPED scripts/kconfig/lex.zconf.c
>   SHIPPED scripts/kconfig/zconf.hash.c
>   HOSTCC  scripts/kconfig/zconf.tab.o
>   HOSTLD  scripts/kconfig/conf
> scripts/kconfig/conf -o arch/x86_64/Kconfig
> *
> * Linux Kernel Configuration
> *
> *
> * General setup
> *
> [...]
> #
> # configuration written to .config
> #
> Sat Oct 27 06:43:24 CEST 2007
> XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
>   GEN     /usr/src/obj/linux/2.6.23.1/x86_64/adjusted/Makefile
> scripts/kconfig/conf -s arch/x86_64/Kconfig
>   GEN     /usr/src/obj/linux/2.6.23.1/x86_64/adjusted/Makefile

>From the above we can see that two make's are running in parallel here
where only one should run.
I have seen this before but only in cases where you specified several targets
on the make commandline - which you do not do in the make invocation.
Just to check it you could do a:
$(warning CMD=$(MAKECMDFLAGS)) around the place where SUBARCH is assigned in the
top-level Makefile.

Does the issue by any chance go away if you refrain from the
command && command && command && command && command && command
way of doing things?

The shell _shall_ serialize it - but..



>   CHK     include/linux/version.h
>   UPD     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   UPD     include/linux/utsrelease.h
>   SYMLINK include/asm -> include/asm-x86_64
>   Using /usr/src/linux-2.6.23.1 as source for kernel
>   /usr/src/linux-2.6.23.1 is not clean, please run 'make mrproper'
>   in the '/usr/src/linux-2.6.23.1' directory.
> make[1]: *** [prepare3] Error 1
> make: *** [_all] Error 2
> make: INTERNAL: Exiting with 3 jobserver tokens available; should be 2!
> 
> 
> Which files are not clean in my situation after the command "make mrproper" was executed
> at the beginning?
If you look at the top-level Makefile you will see:

        @echo '  Using $(srctree) as source for kernel'
        $(Q)if [ -f $(srctree)/.config -o -d $(srctree)/include/config ]; then \
                echo "  $(srctree) is not clean, please run 'make mrproper'";\
                echo "  in the '$(srctree)' directory.";\
                /bin/false; \
        fi;

So you either a .config file or the config directory. Older kernels also tested
that the asm symlink in include/ was not present.
You should check that all these indeed are gone when you do "make mrproper" - you
can have been hit by a privilige issue too. But that should not be the case if
you copied the full tree to another place (and of course did not use cp -a).
You did this - yes? And the result?

> 
> Which results do you or other software developers get by such test runs on kernel releases
> since "2.6.22.9-0.4-default" like it is published by SUSE now?
> ( I can build the current Linux kernel into my source directory successfully.)
If you now say this is a SUSE specific problem then I suggest asking SUSE for help.
At least I have not built a distribution kernel the last year or more - and I
do not follow what kind of patches they apply.

	Sam
