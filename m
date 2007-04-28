Return-Path: <linux-kernel-owner+w=401wt.eu-S1163308AbXD1RxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163308AbXD1RxH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163327AbXD1RxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:53:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163318AbXD1Rw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:56 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: Simon Arlott <simon@arlott.org>, Andi Kleen <ak@suse.de>,
       Dave Jones <davej@codemonkey.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [16/35] i386: Add an option for the VIA C7 which sets appropriate L1 cache
Message-Id: <20070428175240.E6704151CA@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Simon Arlott <simon@arlott.org>

The VIA C7 is a 686 (with TSC) that supports MMX, SSE and SSE2, it also has
a cache line length of 64 according to
http://www.digit-life.com/articles2/cpu/rmma-via-c7.html.  This patch sets
gcc to -march=686 and select s the correct cache shift.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig.cpu     |   13 ++++++++++---
 arch/i386/Makefile.cpu    |    1 +
 arch/um/defconfig         |    1 +
 include/asm-i386/module.h |    2 ++
 4 files changed, 14 insertions(+), 3 deletions(-)

Index: linux/arch/i386/Kconfig.cpu
===================================================================
--- linux.orig/arch/i386/Kconfig.cpu
+++ linux/arch/i386/Kconfig.cpu
@@ -43,6 +43,7 @@ config M386
 	  - "Geode GX/LX" For AMD Geode GX and LX processors.
 	  - "CyrixIII/VIA C3" for VIA Cyrix III or VIA C3.
 	  - "VIA C3-2" for VIA C3-2 "Nehemiah" (model 9 and above).
+	  - "VIA C7" for VIA C7.
 
 	  If you don't know what to do, choose "386".
 
@@ -203,6 +204,12 @@ config MVIAC3_2
 	  of SSE and tells gcc to treat the CPU as a 686.
 	  Note, this kernel will not boot on older (pre model 9) C3s.
 
+config MVIAC7
+	bool "VIA C7"
+	help
+	  Select this for a VIA C7.  Selecting this uses the correct cache
+	  shift and tells gcc to treat the CPU as a 686.
+
 endchoice
 
 config X86_GENERIC
@@ -231,7 +238,7 @@ config X86_L1_CACHE_SHIFT
 	default "7" if MPENTIUM4 || X86_GENERIC
 	default "4" if X86_ELAN || M486 || M386 || MGEODEGX1
 	default "5" if MWINCHIP3D || MWINCHIP2 || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
-	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2
+	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MVIAC7
 
 config RWSEM_GENERIC_SPINLOCK
 	bool
@@ -297,7 +304,7 @@ config X86_ALIGNMENT_16
 
 config X86_GOOD_APIC
 	bool
-	depends on MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || MK8 || MEFFICEON || MCORE2
+	depends on MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || MK8 || MEFFICEON || MCORE2 || MVIAC7
 	default y
 
 config X86_INTEL_USERCOPY
@@ -322,5 +329,5 @@ config X86_OOSTORE
 
 config X86_TSC
 	bool
-	depends on (MWINCHIP3D || MWINCHIP2 || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MGEODEGX1 || MGEODE_LX || MCORE2) && !X86_NUMAQ
+	depends on (MWINCHIP3D || MWINCHIP2 || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2) && !X86_NUMAQ
 	default y
Index: linux/arch/i386/Makefile.cpu
===================================================================
--- linux.orig/arch/i386/Makefile.cpu
+++ linux/arch/i386/Makefile.cpu
@@ -32,6 +32,7 @@ cflags-$(CONFIG_MWINCHIP2)	+= $(call cc-
 cflags-$(CONFIG_MWINCHIP3D)	+= $(call cc-option,-march=winchip2,-march=i586)
 cflags-$(CONFIG_MCYRIXIII)	+= $(call cc-option,-march=c3,-march=i486) $(align)-functions=0 $(align)-jumps=0 $(align)-loops=0
 cflags-$(CONFIG_MVIAC3_2)	+= $(call cc-option,-march=c3-2,-march=i686)
+cflags-$(CONFIG_MVIAC7)		+= -march=i686
 cflags-$(CONFIG_MCORE2)		+= -march=i686 $(call cc-option,-mtune=core2,$(call cc-option,-mtune=generic,-mtune=i686))
 
 # AMD Elan support
Index: linux/arch/um/defconfig
===================================================================
--- linux.orig/arch/um/defconfig
+++ linux/arch/um/defconfig
@@ -41,6 +41,7 @@ CONFIG_M686=y
 # CONFIG_MGEODE_LX is not set
 # CONFIG_MCYRIXIII is not set
 # CONFIG_MVIAC3_2 is not set
+# CONFIG_MVIAC7 is not set
 # CONFIG_X86_GENERIC is not set
 CONFIG_X86_CMPXCHG=y
 CONFIG_X86_XADD=y
Index: linux/include/asm-i386/module.h
===================================================================
--- linux.orig/include/asm-i386/module.h
+++ linux/include/asm-i386/module.h
@@ -54,6 +54,8 @@ struct mod_arch_specific
 #define MODULE_PROC_FAMILY "CYRIXIII "
 #elif defined CONFIG_MVIAC3_2
 #define MODULE_PROC_FAMILY "VIAC3-2 "
+#elif defined CONFIG_MVIAC7
+#define MODULE_PROC_FAMILY "VIAC7 "
 #elif defined CONFIG_MGEODEGX1
 #define MODULE_PROC_FAMILY "GEODEGX1 "
 #elif defined CONFIG_MGEODE_LX
