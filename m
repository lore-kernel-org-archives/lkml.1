Return-Path: <linux-kernel-owner+w=401wt.eu-S1762868AbXHWM1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762868AbXHWM1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 08:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758430AbXHWM1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 08:27:08 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52271 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760232AbXHWM1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 08:27:06 -0400
Date: Thu, 23 Aug 2007 14:28:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: 2.6.23-rc3-mm1
Message-ID: <20070823122825.GA29724@uranus.ravnborg.org>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46CC6FB2.1010801@csn.ul.ie> <20070822111029.46db0ab7.akpm@linux-foundation.org> <20070823120318.GA7506@shadowen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823120318.GA7506@shadowen.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 01:03:18PM +0100, Andy Whitcroft wrote:
> On Wed, Aug 22, 2007 at 11:10:29AM -0700, Andrew Morton wrote:
> [...]
> > >   CC      arch/x86_64/kernel/asm-offsets.s
> > > arch/x86_64/kernel/asm-offsets.c:1: error: -mpreferred-stack-boundary=3
> > > is not between 4 and 12
> > > make[1]: *** [arch/x86_64/kernel/asm-offsets.s] Error 1
> [...]
> > x86_64-mm-less-stack-alignment.patch has
> > 
> > cflags-y += $(call cc-option,-mpreferred-stack-boundary=3)
> > 
> > So we _should_ have detected that gcc didn't like =3, so it
> > should not have been used.
> > 
> > I am suspecting a kbuild glitch: asm-offsets.c tends to be handled
> > in special ways (ie: it's usually the thing which blows up first)
> > so perhaps it is somehow avoiding the above does-gcc-support-this test.
> > 
> > Suitable cc's added ;)
> 
> It seems that this is a problem caused by the way we check for
> compiler options in x86_64.  Each compiler flag is checked for
> individually and if available added to cflags-y, later that is
> added to CFLAGS.  However, this means that each flag is checked
> in total isolation.  On x86_64 (on this compiler at least) the
> -mpreferred-stack-boundary and -m{32,64} flags are actually mutually
> dependant, the alignment constraints vary based on the word size.
> This leads to the compile failure:
> 
>     # gcc -mpreferred-stack-boundary=3 -S -xc /dev/null  -o FOO
>     # echo $?
>     0
>     # gcc -m64 -mpreferred-stack-boundary=3 -S -xc /dev/null  -o FOO
>     /dev/null:1: error: -mpreferred-stack-boundary=3 is not between 4 and 12
>     # echo $?
>     1

Thats makes sense - good catch.

> 
> In the main Makefile we always add each flag directly to CFLAGS
> which means we check them all in combination, perhaps this is
> prudent here also?  Either way I suspect that changing the -m64
> check to add itself directly to CFLAGS will fix this us.

Something like this then:
[PATCH] x86_64: fix preferred-stack-boundary check

gcc has different interpretation of the -preferred-stack-boundary flag
dependent on the option -m64 is present or not as seen in the following:
     # gcc -mpreferred-stack-boundary=3 -S -xc /dev/null  -o FOO
     # echo $?
     0
     # gcc -m64 -mpreferred-stack-boundary=3 -S -xc /dev/null  -o FOO
     /dev/null:1: error: -mpreferred-stack-boundary=3 is not between 4 and 12
     # echo $?
     1

Adding the -m64 to CFLAGS let cc-option do the right thing.

Thanks to Andy Whitcroft <apw@shadowen.org> for spotting the root cause.

Cc: Andy Whitcroft <apw@shadowen.org> 
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
diff --git a/arch/x86_64/Makefile b/arch/x86_64/Makefile
index 128561d..5402c0a 100644
--- a/arch/x86_64/Makefile
+++ b/arch/x86_64/Makefile
@@ -25,6 +25,8 @@ LDFLAGS		:= -m elf_x86_64
 OBJCOPYFLAGS	:= -O binary -R .note -R .comment -S
 LDFLAGS_vmlinux :=
 CHECKFLAGS      += -D__x86_64__ -m64
+AFLAGS          += -m64
+CFLAGS          += -m64
 
 cflags-y	:=
 cflags-kernel-y	:=
@@ -36,7 +38,6 @@ cflags-$(CONFIG_MCORE2) += \
 	$(call cc-option,-march=core2,$(call cc-option,-mtune=generic))
 cflags-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mtune=generic)
 
-cflags-y += -m64
 cflags-y += -mno-red-zone
 cflags-y += -mcmodel=kernel
 cflags-y += -pipe
@@ -69,7 +70,6 @@ cflags-$(CONFIG_CC_STACKPROTECTOR_ALL) += $(shell $(CONFIG_SHELL) $(srctree)/scr
 
 CFLAGS += $(cflags-y)
 CFLAGS_KERNEL += $(cflags-kernel-y)
-AFLAGS += -m64
 
 head-y := arch/x86_64/kernel/head.o arch/x86_64/kernel/head64.o arch/x86_64/kernel/init_task.o
 
