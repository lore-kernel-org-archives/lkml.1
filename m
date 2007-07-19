Return-Path: <linux-kernel-owner+w=401wt.eu-S938607AbXGSK2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938607AbXGSK2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763348AbXGSJ4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:56:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:33145 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761232AbXGSJzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:55 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: bunk@stusta.de, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [58/58] x86: remove support for the Rise CPU
Message-Id: <20070719095545.8AB5914E06@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Adrian Bunk <bunk@stusta.de>

The Rise CPUs were only very short-lived, and there are no reports of
anyone both owning one and running Linux on it.

Googling for the printk string "CPU: Rise iDragon" didn't find any dmesg
available online.

If it turns out that against all expectations there are actually users
reverting this patch would be easy.

This patch will make the kernel images smaller by a few bytes for all
i386 users.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Dave Jones <davej@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/Makefile  |    1 
 arch/i386/kernel/cpu/common.c  |    2 -
 arch/i386/kernel/cpu/rise.c    |   52 -----------------------------------------
 include/asm-i386/processor.h   |    1 
 include/asm-x86_64/processor.h |    1 
 5 files changed, 57 deletions(-)

Index: linux/arch/i386/kernel/cpu/Makefile
===================================================================
--- linux.orig/arch/i386/kernel/cpu/Makefile
+++ linux/arch/i386/kernel/cpu/Makefile
@@ -9,7 +9,6 @@ obj-y	+=	cyrix.o
 obj-y	+=	centaur.o
 obj-y	+=	transmeta.o
 obj-y	+=	intel.o intel_cacheinfo.o addon_cpuid_features.o
-obj-y	+=	rise.o
 obj-y	+=	nexgen.o
 obj-y	+=	umc.o
 
Index: linux/arch/i386/kernel/cpu/common.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/common.c
+++ linux/arch/i386/kernel/cpu/common.c
@@ -606,7 +606,6 @@ extern int nsc_init_cpu(void);
 extern int amd_init_cpu(void);
 extern int centaur_init_cpu(void);
 extern int transmeta_init_cpu(void);
-extern int rise_init_cpu(void);
 extern int nexgen_init_cpu(void);
 extern int umc_init_cpu(void);
 
@@ -618,7 +617,6 @@ void __init early_cpu_init(void)
 	amd_init_cpu();
 	centaur_init_cpu();
 	transmeta_init_cpu();
-	rise_init_cpu();
 	nexgen_init_cpu();
 	umc_init_cpu();
 	early_cpu_detect();
Index: linux/arch/i386/kernel/cpu/rise.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/rise.c
+++ /dev/null
@@ -1,52 +0,0 @@
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/bitops.h>
-#include <asm/processor.h>
-
-#include "cpu.h"
-
-static void __cpuinit init_rise(struct cpuinfo_x86 *c)
-{
-	printk("CPU: Rise iDragon");
-	if (c->x86_model > 2)
-		printk(" II");
-	printk("\n");
-
-	/* Unhide possibly hidden capability flags
-	   The mp6 iDragon family don't have MSRs.
-	   We switch on extra features with this cpuid weirdness: */
-	__asm__ (
-		"movl $0x6363452a, %%eax\n\t"
-		"movl $0x3231206c, %%ecx\n\t"
-		"movl $0x2a32313a, %%edx\n\t"
-		"cpuid\n\t"
-		"movl $0x63634523, %%eax\n\t"
-		"movl $0x32315f6c, %%ecx\n\t"
-		"movl $0x2333313a, %%edx\n\t"
-		"cpuid\n\t" : : : "eax", "ebx", "ecx", "edx"
-	);
-	set_bit(X86_FEATURE_CX8, c->x86_capability);
-}
-
-static struct cpu_dev rise_cpu_dev __cpuinitdata = {
-	.c_vendor	= "Rise",
-	.c_ident	= { "RiseRiseRise" },
-	.c_models = {
-		{ .vendor = X86_VENDOR_RISE, .family = 5, .model_names = 
-		  { 
-			  [0] = "iDragon", 
-			  [2] = "iDragon", 
-			  [8] = "iDragon II", 
-			  [9] = "iDragon II"
-		  }
-		},
-	},
-	.c_init		= init_rise,
-};
-
-int __init rise_init_cpu(void)
-{
-	cpu_devs[X86_VENDOR_RISE] = &rise_cpu_dev;
-	return 0;
-}
-
Index: linux/include/asm-i386/processor.h
===================================================================
--- linux.orig/include/asm-i386/processor.h
+++ linux/include/asm-i386/processor.h
@@ -88,7 +88,6 @@ struct cpuinfo_x86 {
 #define X86_VENDOR_UMC 3
 #define X86_VENDOR_NEXGEN 4
 #define X86_VENDOR_CENTAUR 5
-#define X86_VENDOR_RISE 6
 #define X86_VENDOR_TRANSMETA 7
 #define X86_VENDOR_NSC 8
 #define X86_VENDOR_NUM 9
Index: linux/include/asm-x86_64/processor.h
===================================================================
--- linux.orig/include/asm-x86_64/processor.h
+++ linux/include/asm-x86_64/processor.h
@@ -83,7 +83,6 @@ struct cpuinfo_x86 {
 #define X86_VENDOR_UMC 3
 #define X86_VENDOR_NEXGEN 4
 #define X86_VENDOR_CENTAUR 5
-#define X86_VENDOR_RISE 6
 #define X86_VENDOR_TRANSMETA 7
 #define X86_VENDOR_NUM 8
 #define X86_VENDOR_UNKNOWN 0xff
