Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbZF3LKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbZF3LKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 07:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZF3LKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 07:10:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:34051 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbZF3LKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 07:10:37 -0400
Subject: Re: [PATCH] Don't override CONFIG_64BIT for ARCH={i386,x86_64}
 builds
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090212072644.GA10253@elte.hu>
References: <1234372298.3586.23.camel@macbook.infradead.org>
	 <20090211172258.GE13239@elte.hu>  <20090212072644.GA10253@elte.hu>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 12:10:21 +0100
Message-Id: <1246360221.3681.96.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-12 at 08:26 +0100, Ingo Molnar wrote:
> 
> i removed it again, because it regresses randconfig behavior:
> 
>  titan:~/tip> grep X86_32 .config; make ARCH=x86_64 randconfig; grep
> X86_32 .config
>  # CONFIG_X86_32 is not set
>  scripts/kconfig/conf -r arch/x86/Kconfig
>  #
>  # configuration written to .config
>  #
>  CONFIG_X86_32=y
>  CONFIG_X86_32_SMP=y
>  CONFIG_X86_32_LAZY_GS=y
>  CONFIG_X86_32_ALWAYS_ON=y
> 
> I dont mind the change you are after, but randconfig should work as
> expected too: if ARCH=x86_64 is passed it should generate a 64-bit
> randconfig, not a 50% 32-bit one.

I still think that's a crap argument -- randconfig is _supposed_ to give
you a random config -- it's not as if you're going to boot it anyway.

If you want to have a _partially_ random config you should do that with
something like 'make CONFIG_FOO=y randconfig'. I think we should drop
the historical baggage of 'ARCH=i386' and 'ARCH=x86_64' completely.

But I've just spent a few days testing the wrong damn kernel because
'make oldconfig' silently changed architectures on the config I was
given to test -- a bug which you seem to think is _less_ important than
the 'bug' that randconfig actually gives you what you asked for.

So I'll have another go at fixing it in a way that preserves your silly
'make ARCH=x86_64 almost-random-config', this time by letting $(ARCH)
default to x86.

I didn't do it this way before, because I wanted 'make defconfig' to
give you a config which matched the architecture you're running on. I've
achieved that a different way now though.

For those using 'make config' from scratch, I made it default to x86_64
instead of i386. That's probably a saner choice, these days. 

--------------
Subject: Don't silently override CONFIG_64BIT in 'make oldconfig'

It is a steaming great pain in the arse when the value of CONFIG_64BIT
explicitly written in my .config file is overridden by the value of
$ARCH inferred from the environment.

If I have a 32-bit .config and I happen to build it without remembering
to put 'ARCH=i386' on the make command line, it shouldn't force
CONFIG_64BIT=y and reconfigure.
 
This patch should fix that, while still allowing defconfig to work as it
currently does for both 32-bit and 64-bit environments.

The default when running 'make config' is no longer automatic -- it's
set to 64-bit. It wasn't possible to preserve this behaviour without
also breaking things for the strange people who want 'make randconfig'
not to actually be completely random.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

diff --git a/Makefile b/Makefile
index d1216fe..c944d6e 100644
--- a/Makefile
+++ b/Makefile
@@ -157,7 +157,8 @@ export srctree objtree VPATH TOPDIR
 # then ARCH is assigned, getting whatever value it gets normally, and 
 # SUBARCH is subsequently ignored.
 
-SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
+SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
+				  -e s/sun4u/sparc64/ \
 				  -e s/arm.*/arm/ -e s/sa110/arm/ \
 				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
 				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d1430ef..3f5bbfe 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -4,7 +4,7 @@ mainmenu "Linux Kernel Configuration for x86"
 # Select 32 or 64 bit
 config 64BIT
 	bool "64-bit kernel" if ARCH = "x86"
-	default ARCH = "x86_64"
+	default ARCH != "i386"
 	---help---
 	  Say yes to build a 64-bit kernel - formerly known as x86_64
 	  Say no to build a 32-bit kernel - formerly known as i386
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 1b68659..3c6c6ea 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -2,7 +2,11 @@
 
 # select defconfig based on actual architecture
 ifeq ($(ARCH),x86)
+  ifeq ($(shell uname -m),x86_64)
+        KBUILD_DEFCONFIG := x86_64_defconfig
+  else
         KBUILD_DEFCONFIG := i386_defconfig
+  endif
 else
         KBUILD_DEFCONFIG := $(ARCH)_defconfig
 endif

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

