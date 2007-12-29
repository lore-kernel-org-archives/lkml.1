Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbXL2JjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbXL2JjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 04:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbXL2JjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 04:39:08 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:56617 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbXL2JjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 04:39:07 -0500
Date: Sat, 29 Dec 2007 10:39:04 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: unify x86 Makefile(s)
Message-ID: <20071229093904.GA17390@uranus.ravnborg.org>
References: <20071228212341.GA6939@uranus.ravnborg.org> <20071228221324.GA9105@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071228221324.GA9105@does.not.exist>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2007 at 12:13:24AM +0200, Adrian Bunk wrote:
> On Fri, Dec 28, 2007 at 10:23:41PM +0100, Sam Ravnborg wrote:
> >...
> > Noteworthy remarks on the unification:
> >...
> > - -funit-at-a-time should be easy to unify but it looks like we have a bug
> >   in 32 bit. We only enable -funit-at-a-time for gcc less than 0400 if they
> >   support it
> 
> No, we _dis_able it on 32bit if a gcc < 4.0 supports it.
I have:
$ gcc --version
gcc (GCC) 4.1.2 20070925 (Red Hat 4.1.2-33)

And with the current code in arch/x86/Makefile_32 I do not
have -funit-at-a-time.

Sample gcc cammandline:
gcc -m32 -Wp,-MD,init/.do_mounts_rd.o.d  -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.1.2/include -D__KERNEL__ -Iinclude  -include include/linux/autoconf.h -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Os -pipe -msoft-float -mregparm=3 -freg-struct-return -mpreferred-stack-boundary=2  -march=i686 -mtune=pentium3 -mtune=generic -ffreestanding -maccumulate-outgoing-args -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -Iinclude/asm-x86/mach-generic -Iinclude/asm-x86/mach-default -fomit-frame-pointer  -fno-stack-protector -Wdeclaration-after-statement -Wno-pointer-sign     -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(do_mounts_rd)"  -D"KBUILD_MODNAME=KBUILD_STR(mounts)" -c -o init/do_mounts_rd.o init/do_mounts_rd.c


This is the relevant snippet from the Makefile:
KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0400 ] ; then echo $(call cc-option,-fno-unit-at-a-time); fi ;)

It reads:
If gcc version is less than 4.00 then enable -funit-at-a-time only for gcc that supports it.
-funit-at-a-time is NOT enabled for gcc >= 4.00

So it will enable -funit-at-a-time for gcc 3.4 as it is now.
Which was what we wanted to avoid..
So I see no reason not to enable it uncondintionally (if gcc supports it) as we have
used it for 3.4 for as long as we have introduced -funit-at-a-time.

	Sam
