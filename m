Return-Path: <linux-kernel-owner+w=401wt.eu-S939882AbXHIMqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939882AbXHIMqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939162AbXHIMli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:41:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:34966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939247AbXHIMlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:41:37 -0400
From: Andi Kleen <ak@suse.de>
References: <20070809241.425881000@suse.de>
In-Reply-To: <20070809241.425881000@suse.de>
To: tglx@linutronix.de, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [8/12] x86_64: Use global flag to disable broken local apic timer on AMD CPUs.
Message-Id: <20070809124136.00A6C14F3B@wotan.suse.de>
Date: Thu,  9 Aug 2007 14:41:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The Averatec 2370 and some other Turion laptop BIOS seems to program the 
ENABLE_C1E MSR inconsistently between cores. This confuses the lapic
use heuristics because when C1E is enabled anywhere it seems to affect
the complete chip.

Use a global flag instead of a per cpu flag to handle this.
If any CPU has C1E enabled disabled lapic use.

Thanks to Cal Peake for debugging.

Cc: tglx@linutronix.de
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/apic.c       |    8 +++-----
 arch/i386/kernel/cpu/amd.c    |    7 ++++++-
 include/asm-i386/apic.h       |    2 ++
 include/asm-i386/cpufeature.h |    2 +-
 4 files changed, 12 insertions(+), 7 deletions(-)

Index: linux/arch/i386/kernel/apic.c
===================================================================
--- linux.orig/arch/i386/kernel/apic.c
+++ linux/arch/i386/kernel/apic.c
@@ -61,8 +61,9 @@ static int enable_local_apic __initdata 
 
 /* Local APIC timer verification ok */
 static int local_apic_timer_verify_ok;
-/* Disable local APIC timer from the kernel commandline or via dmi quirk */
-static int local_apic_timer_disabled;
+/* Disable local APIC timer from the kernel commandline or via dmi quirk
+   or using CPU MSR check */
+int local_apic_timer_disabled;
 /* Local APIC timer works in C2 */
 int local_apic_timer_c2_ok;
 EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
@@ -370,9 +371,6 @@ void __init setup_boot_APIC_clock(void)
 	long delta, deltapm;
 	int pm_referenced = 0;
 
-	if (boot_cpu_has(X86_FEATURE_LAPIC_TIMER_BROKEN))
-		local_apic_timer_disabled = 1;
-
 	/*
 	 * The local apic timer can be disabled via the kernel
 	 * commandline or from the test above. Register the lapic
Index: linux/arch/i386/kernel/cpu/amd.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/amd.c
+++ linux/arch/i386/kernel/cpu/amd.c
@@ -3,6 +3,7 @@
 #include <linux/mm.h>
 #include <asm/io.h>
 #include <asm/processor.h>
+#include <asm/apic.h>
 
 #include "cpu.h"
 
@@ -22,6 +23,7 @@
 extern void vide(void);
 __asm__(".align 4\nvide: ret");
 
+#ifdef CONFIG_X86_LOCAL_APIC
 #define ENABLE_C1E_MASK         0x18000000
 #define CPUID_PROCESSOR_SIGNATURE       1
 #define CPUID_XFAM              0x0ff00000
@@ -52,6 +54,7 @@ static __cpuinit int amd_apic_timer_brok
         }
 	return 0;
 }
+#endif
 
 int force_mwait __cpuinitdata;
 
@@ -282,8 +285,10 @@ static void __cpuinit init_amd(struct cp
 			num_cache_leaves = 3;
 	}
 
+#ifdef CONFIG_X86_LOCAL_APIC
 	if (amd_apic_timer_broken())
-		set_bit(X86_FEATURE_LAPIC_TIMER_BROKEN, c->x86_capability);
+		local_apic_timer_disabled = 1;
+#endif
 
 	if (c->x86 == 0x10 && !force_mwait)
 		clear_bit(X86_FEATURE_MWAIT, c->x86_capability);
Index: linux/include/asm-i386/apic.h
===================================================================
--- linux.orig/include/asm-i386/apic.h
+++ linux/include/asm-i386/apic.h
@@ -116,6 +116,8 @@ extern void enable_NMI_through_LVT0 (voi
 extern int timer_over_8254;
 extern int local_apic_timer_c2_ok;
 
+extern int local_apic_timer_disabled;
+
 #else /* !CONFIG_X86_LOCAL_APIC */
 static inline void lapic_shutdown(void) { }
 
Index: linux/include/asm-i386/cpufeature.h
===================================================================
--- linux.orig/include/asm-i386/cpufeature.h
+++ linux/include/asm-i386/cpufeature.h
@@ -79,7 +79,7 @@
 #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
 #define X86_FEATURE_PEBS	(3*32+12)  /* Precise-Event Based Sampling */
 #define X86_FEATURE_BTS		(3*32+13)  /* Branch Trace Store */
-#define X86_FEATURE_LAPIC_TIMER_BROKEN (3*32+ 14) /* lapic timer broken in C1 */
+/* 14 free */
 #define X86_FEATURE_SYNC_RDTSC	(3*32+15)  /* RDTSC synchronizes the CPU */
 #define X86_FEATURE_REP_GOOD   (3*32+16) /* rep microcode works well on this CPU */
 
