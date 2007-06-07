Return-Path: <linux-kernel-owner+w=401wt.eu-S966197AbXFGAiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966197AbXFGAiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 20:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757669AbXFGAiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 20:38:07 -0400
Received: from terminus.zytor.com ([192.83.249.54]:43113 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031AbXFGAiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 20:38:06 -0400
Message-Id: <200706070037.l570bXFH006998@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 6 Jun 2007 17:33:33 -0700
Subject: [PATCH] [x86] remove CONFIG_X86_TSC
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_X86_TSC makes the TSC mandatory, but since the TSC may be
unstable, we still have to be able to operate without it.
Furthermore, with CONFIG_X86_GENERIC we still compile in the RDTSC
instructions.

In the end, the only significant effect is has is that it makes the
"notsc" flag inoperable, which is silly if we have the code to run
without TSC anyway.

Thus, remove this flag and all its conditionals.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/Kconfig.cpu       |    5 -----
 arch/i386/defconfig         |    1 -
 arch/i386/kernel/cpu/bugs.c |    8 --------
 arch/i386/kernel/tsc.c      |    9 ---------
 arch/um/defconfig           |    1 -
 arch/x86_64/Kconfig         |    4 ----
 arch/x86_64/defconfig       |    1 -
 include/asm-i386/tsc.h      |    4 ----
 8 files changed, 0 insertions(+), 33 deletions(-)

diff --git a/arch/i386/Kconfig.cpu b/arch/i386/Kconfig.cpu
index d7f6fb0..14d7ee8 100644
--- a/arch/i386/Kconfig.cpu
+++ b/arch/i386/Kconfig.cpu
@@ -332,11 +332,6 @@ config X86_OOSTORE
 	depends on (MWINCHIP3D || MWINCHIP2 || MWINCHIPC6) && MTRR
 	default y
 
-config X86_TSC
-	bool
-	depends on (MWINCHIP3D || MWINCHIP2 || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2) && !X86_NUMAQ
-	default y
-
 # this should be set for all -march=.. options where the compiler
 # generates cmov.
 config X86_CMOV
diff --git a/arch/i386/defconfig b/arch/i386/defconfig
index 1a3a221..0c78cae 100644
--- a/arch/i386/defconfig
+++ b/arch/i386/defconfig
@@ -170,7 +170,6 @@ CONFIG_X86_CMPXCHG64=y
 CONFIG_X86_GOOD_APIC=y
 CONFIG_X86_INTEL_USERCOPY=y
 CONFIG_X86_USE_PPRO_CHECKSUM=y
-CONFIG_X86_TSC=y
 CONFIG_X86_CMOV=y
 CONFIG_X86_MINIMUM_CPU_FAMILY=4
 CONFIG_HPET_TIMER=y
diff --git a/arch/i386/kernel/cpu/bugs.c b/arch/i386/kernel/cpu/bugs.c
index 54428a2..665bcd4 100644
--- a/arch/i386/kernel/cpu/bugs.c
+++ b/arch/i386/kernel/cpu/bugs.c
@@ -151,14 +151,6 @@ static void __init check_config(void)
 #endif
 
 /*
- * If we configured ourselves for a TSC, we'd better have one!
- */
-#ifdef CONFIG_X86_TSC
-	if (!cpu_has_tsc && !tsc_disable)
-		panic("Kernel compiled for Pentium+, requires TSC feature!");
-#endif
-
-/*
  * If we were told we had a good local APIC, check for buggy Pentia,
  * i.e. all B steppings and the C2 stepping of P54C when using their
  * integrated APIC (see 11AP erratum in "Pentium Processor
diff --git a/arch/i386/kernel/tsc.c b/arch/i386/kernel/tsc.c
index f64b81f..fdad18c 100644
--- a/arch/i386/kernel/tsc.c
+++ b/arch/i386/kernel/tsc.c
@@ -29,14 +29,6 @@ unsigned int tsc_khz;
 
 int tsc_disable;
 
-#ifdef CONFIG_X86_TSC
-static int __init tsc_setup(char *str)
-{
-	printk(KERN_WARNING "notsc: Kernel compiled with CONFIG_X86_TSC, "
-				"cannot disable TSC.\n");
-	return 1;
-}
-#else
 /*
  * disable flag for tsc. Takes effect by clearing the TSC cpu flag
  * in cpu/common.c
@@ -47,7 +39,6 @@ static int __init tsc_setup(char *str)
 
 	return 1;
 }
-#endif
 
 __setup("notsc", tsc_setup);
 
diff --git a/arch/um/defconfig b/arch/um/defconfig
index a54d0ef..eeb627c 100644
--- a/arch/um/defconfig
+++ b/arch/um/defconfig
@@ -55,7 +55,6 @@ CONFIG_X86_POPAD_OK=y
 CONFIG_X86_CMPXCHG64=y
 CONFIG_X86_GOOD_APIC=y
 CONFIG_X86_USE_PPRO_CHECKSUM=y
-CONFIG_X86_TSC=y
 CONFIG_UML_X86=y
 # CONFIG_64BIT is not set
 CONFIG_SEMAPHORE_SLEEPERS=y
diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index 5ce9443..bf2227a 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -201,10 +201,6 @@ config X86_INTERNODE_CACHE_BYTES
 	default "4096" if X86_VSMP
 	default X86_L1_CACHE_BYTES if !X86_VSMP
 
-config X86_TSC
-	bool
-	default y
-
 config X86_GOOD_APIC
 	bool
 	default y
diff --git a/arch/x86_64/defconfig b/arch/x86_64/defconfig
index 40178e5..20d972d 100644
--- a/arch/x86_64/defconfig
+++ b/arch/x86_64/defconfig
@@ -129,7 +129,6 @@ CONFIG_GENERIC_CPU=y
 CONFIG_X86_L1_CACHE_BYTES=128
 CONFIG_X86_L1_CACHE_SHIFT=7
 CONFIG_X86_INTERNODE_CACHE_BYTES=128
-CONFIG_X86_TSC=y
 CONFIG_X86_GOOD_APIC=y
 # CONFIG_MICROCODE is not set
 CONFIG_X86_MSR=y
diff --git a/include/asm-i386/tsc.h b/include/asm-i386/tsc.h
index 62c091f..36629ac 100644
--- a/include/asm-i386/tsc.h
+++ b/include/asm-i386/tsc.h
@@ -20,14 +20,10 @@ static inline cycles_t get_cycles(void)
 {
 	unsigned long long ret = 0;
 
-#ifndef CONFIG_X86_TSC
 	if (!cpu_has_tsc)
 		return 0;
-#endif
 
-#if defined(CONFIG_X86_GENERIC) || defined(CONFIG_X86_TSC)
 	rdtscll(ret);
-#endif
 	return ret;
 }
 
-- 
1.5.2

