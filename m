Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbYKLXjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbYKLXjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767AbYKLXeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:34:31 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:48557 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133AbYKLXe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:34:29 -0500
Message-Id: <20081112232300.185325542@polymtl.ca>
References: <20081112231551.473569400@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 18:16:03 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 12/17] x86 : remove arch-specific tsc_sync.c
Content-Disposition: inline; filename=x86-remove-arch-specific-tsc_sync.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed, 12 Nov 2008 23:33:02 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depends on the new arch. independent kernel/time/tsc-sync.c

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/Kconfig           |    2 
 arch/x86/include/asm/tsc.h |    8 +
 arch/x86/kernel/Makefile   |    4 
 arch/x86/kernel/tsc_sync.c |  189 ---------------------------------------------
 4 files changed, 11 insertions(+), 192 deletions(-)

Index: linux.trees.git/arch/x86/kernel/Makefile
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/Makefile	2008-11-12 18:14:22.000000000 -0500
+++ linux.trees.git/arch/x86/kernel/Makefile	2008-11-12 18:15:37.000000000 -0500
@@ -56,9 +56,9 @@ obj-$(CONFIG_PCI)		+= early-quirks.o
 apm-y				:= apm_32.o
 obj-$(CONFIG_APM)		+= apm.o
 obj-$(CONFIG_X86_SMP)		+= smp.o
-obj-$(CONFIG_X86_SMP)		+= smpboot.o tsc_sync.o ipi.o tlb_$(BITS).o
+obj-$(CONFIG_X86_SMP)		+= smpboot.o ipi.o tlb_$(BITS).o
 obj-$(CONFIG_X86_32_SMP)	+= smpcommon.o
-obj-$(CONFIG_X86_64_SMP)	+= tsc_sync.o smpcommon.o
+obj-$(CONFIG_X86_64_SMP)	+= smpcommon.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
 obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o nmi.o
Index: linux.trees.git/arch/x86/kernel/tsc_sync.c
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/tsc_sync.c	2008-11-12 18:14:22.000000000 -0500
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,189 +0,0 @@
-/*
- * check TSC synchronization.
- *
- * Copyright (C) 2006, Red Hat, Inc., Ingo Molnar
- *
- * We check whether all boot CPUs have their TSC's synchronized,
- * print a warning if not and turn off the TSC clock-source.
- *
- * The warp-check is point-to-point between two CPUs, the CPU
- * initiating the bootup is the 'source CPU', the freshly booting
- * CPU is the 'target CPU'.
- *
- * Only two CPUs may participate - they can enter in any order.
- * ( The serial nature of the boot logic and the CPU hotplug lock
- *   protects against more than 2 CPUs entering this code. )
- */
-#include <linux/spinlock.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/smp.h>
-#include <linux/nmi.h>
-#include <asm/tsc.h>
-
-/*
- * Entry/exit counters that make sure that both CPUs
- * run the measurement code at once:
- */
-static __cpuinitdata atomic_t start_count;
-static __cpuinitdata atomic_t stop_count;
-
-/*
- * We use a raw spinlock in this exceptional case, because
- * we want to have the fastest, inlined, non-debug version
- * of a critical section, to be able to prove TSC time-warps:
- */
-static __cpuinitdata raw_spinlock_t sync_lock = __RAW_SPIN_LOCK_UNLOCKED;
-static __cpuinitdata cycles_t last_tsc;
-static __cpuinitdata cycles_t max_warp;
-static __cpuinitdata int nr_warps;
-
-/*
- * TSC-warp measurement loop running on both CPUs:
- */
-static __cpuinit void check_tsc_warp(void)
-{
-	cycles_t start, now, prev, end;
-	int i;
-
-	start = get_cycles();
-	/*
-	 * The measurement runs for 20 msecs:
-	 */
-	end = start + tsc_khz * 20ULL;
-	now = start;
-
-	for (i = 0; ; i++) {
-		/*
-		 * We take the global lock, measure TSC, save the
-		 * previous TSC that was measured (possibly on
-		 * another CPU) and update the previous TSC timestamp.
-		 */
-		__raw_spin_lock(&sync_lock);
-		prev = last_tsc;
-		now = get_cycles();
-		last_tsc = now;
-		__raw_spin_unlock(&sync_lock);
-
-		/*
-		 * Be nice every now and then (and also check whether
-		 * measurement is done [we also insert a 10 million
-		 * loops safety exit, so we dont lock up in case the
-		 * TSC readout is totally broken]):
-		 */
-		if (unlikely(!(i & 7))) {
-			if (now > end || i > 10000000)
-				break;
-			cpu_relax();
-			touch_nmi_watchdog();
-		}
-		/*
-		 * Outside the critical section we can now see whether
-		 * we saw a time-warp of the TSC going backwards:
-		 */
-		if (unlikely(prev > now)) {
-			__raw_spin_lock(&sync_lock);
-			max_warp = max(max_warp, prev - now);
-			nr_warps++;
-			__raw_spin_unlock(&sync_lock);
-		}
-	}
-	WARN(!(now-start),
-		"Warning: zero tsc calibration delta: %Ld [max: %Ld]\n",
-			now-start, end-start);
-}
-
-/*
- * Source CPU calls into this - it waits for the freshly booted
- * target CPU to arrive and then starts the measurement:
- */
-void __cpuinit check_tsc_sync_source(int cpu)
-{
-	int cpus = 2;
-
-	/*
-	 * No need to check if we already know that the TSC is not
-	 * synchronized:
-	 */
-	if (unsynchronized_tsc())
-		return;
-
-	printk(KERN_INFO "checking TSC synchronization [CPU#%d -> CPU#%d]:",
-			  smp_processor_id(), cpu);
-
-	/*
-	 * Reset it - in case this is a second bootup:
-	 */
-	atomic_set(&stop_count, 0);
-
-	/*
-	 * Wait for the target to arrive:
-	 */
-	while (atomic_read(&start_count) != cpus-1)
-		cpu_relax();
-	/*
-	 * Trigger the target to continue into the measurement too:
-	 */
-	atomic_inc(&start_count);
-
-	check_tsc_warp();
-
-	while (atomic_read(&stop_count) != cpus-1)
-		cpu_relax();
-
-	if (nr_warps) {
-		printk("\n");
-		printk(KERN_WARNING "Measured %Ld cycles TSC warp between CPUs,"
-				    " turning off TSC clock.\n", max_warp);
-		mark_tsc_unstable("check_tsc_sync_source failed");
-	} else {
-		printk(" passed.\n");
-	}
-
-	/*
-	 * Reset it - just in case we boot another CPU later:
-	 */
-	atomic_set(&start_count, 0);
-	nr_warps = 0;
-	max_warp = 0;
-	last_tsc = 0;
-
-	/*
-	 * Let the target continue with the bootup:
-	 */
-	atomic_inc(&stop_count);
-}
-
-/*
- * Freshly booted CPUs call into this:
- */
-void __cpuinit check_tsc_sync_target(void)
-{
-	int cpus = 2;
-
-	if (unsynchronized_tsc())
-		return;
-
-	/*
-	 * Register this CPU's participation and wait for the
-	 * source CPU to start the measurement:
-	 */
-	atomic_inc(&start_count);
-	while (atomic_read(&start_count) != cpus)
-		cpu_relax();
-
-	check_tsc_warp();
-
-	/*
-	 * Ok, we are done:
-	 */
-	atomic_inc(&stop_count);
-
-	/*
-	 * Wait for the source CPU to print stuff:
-	 */
-	while (atomic_read(&stop_count) != cpus)
-		cpu_relax();
-}
-#undef NR_LOOPS
-
Index: linux.trees.git/arch/x86/Kconfig
===================================================================
--- linux.trees.git.orig/arch/x86/Kconfig	2008-11-12 18:15:28.000000000 -0500
+++ linux.trees.git/arch/x86/Kconfig	2008-11-12 18:15:37.000000000 -0500
@@ -169,6 +169,7 @@ config X86_SMP
 	bool
 	depends on SMP && ((X86_32 && !X86_VOYAGER) || X86_64)
 	select USE_GENERIC_SMP_HELPERS
+	select HAVE_UNSYNCHRONIZED_TSC
 	default y
 
 config X86_32_SMP
@@ -178,6 +179,7 @@ config X86_32_SMP
 config X86_64_SMP
 	def_bool y
 	depends on X86_64 && SMP
+	select HAVE_UNSYNCHRONIZED_TSC
 
 config X86_HT
 	bool
Index: linux.trees.git/arch/x86/include/asm/tsc.h
===================================================================
--- linux.trees.git.orig/arch/x86/include/asm/tsc.h	2008-11-12 18:15:28.000000000 -0500
+++ linux.trees.git/arch/x86/include/asm/tsc.h	2008-11-12 18:15:37.000000000 -0500
@@ -54,7 +54,7 @@ static __always_inline cycles_t vget_cyc
 extern void tsc_init(void);
 extern void mark_tsc_unstable(char *reason);
 extern int unsynchronized_tsc(void);
-int check_tsc_unstable(void);
+extern int check_tsc_unstable(void);
 
 static inline cycles_t get_cycles_rate(void)
 {
@@ -77,4 +77,10 @@ extern void check_tsc_sync_target(void);
 
 extern int notsc_setup(char *);
 
+extern int test_tsc_synchronization(void);
+extern int _tsc_is_sync;
+static inline int tsc_is_sync(void)
+{
+	return _tsc_is_sync;
+}
 #endif /* _ASM_X86_TSC_H */

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
