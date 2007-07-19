Return-Path: <linux-kernel-owner+w=401wt.eu-S1765511AbXGSKDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765511AbXGSKDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758885AbXGSJzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:33058 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757142AbXGSJzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:05 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [16/58] x86_64: Use new shared sched_clock in x86-64 too
Message-Id: <20070719095501.0722714E06@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:00 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/Makefile |    3 ++-
 arch/x86_64/kernel/time.c   |    1 -
 arch/x86_64/kernel/tsc.c    |   29 +----------------------------
 include/asm-x86_64/timer.h  |    5 +++++
 include/asm-x86_64/timex.h  |    1 -
 5 files changed, 8 insertions(+), 31 deletions(-)

Index: linux/arch/x86_64/kernel/tsc.c
===================================================================
--- linux.orig/arch/x86_64/kernel/tsc.c
+++ linux/arch/x86_64/kernel/tsc.c
@@ -8,6 +8,7 @@
 #include <linux/cpufreq.h>
 
 #include <asm/timex.h>
+#include <asm/tsc.h>
 
 static int notsc __initdata = 0;
 
@@ -16,32 +17,6 @@ EXPORT_SYMBOL(cpu_khz);
 unsigned int tsc_khz;
 EXPORT_SYMBOL(tsc_khz);
 
-static unsigned int cyc2ns_scale __read_mostly;
-
-void set_cyc2ns_scale(unsigned long khz)
-{
-	cyc2ns_scale = (NSEC_PER_MSEC << NS_SCALE) / khz;
-}
-
-static unsigned long long cycles_2_ns(unsigned long long cyc)
-{
-	return (cyc * cyc2ns_scale) >> NS_SCALE;
-}
-
-unsigned long long sched_clock(void)
-{
-	unsigned long a = 0;
-
-	/* Could do CPU core sync here. Opteron can execute rdtsc speculatively,
-	 * which means it is not completely exact and may not be monotonous
-	 * between CPUs. But the errors should be too small to matter for
-	 * scheduling purposes.
-	 */
-
-	rdtscll(a);
-	return cycles_2_ns(a);
-}
-
 static int tsc_unstable;
 
 static inline int check_tsc_unstable(void)
@@ -114,8 +89,6 @@ static int time_cpufreq_notifier(struct 
 			mark_tsc_unstable("cpufreq changes");
 	}
 
-	set_cyc2ns_scale(tsc_khz_ref);
-
 	return 0;
 }
 
Index: linux/arch/x86_64/kernel/time.c
===================================================================
--- linux.orig/arch/x86_64/kernel/time.c
+++ linux/arch/x86_64/kernel/time.c
@@ -408,7 +408,6 @@ void __init time_init(void)
 	else
 		vgetcpu_mode = VGETCPU_LSL;
 
-	set_cyc2ns_scale(tsc_khz);
 	printk(KERN_INFO "time.c: Detected %d.%03d MHz processor.\n",
 		cpu_khz / 1000, cpu_khz % 1000);
 	init_tsc_clocksource();
Index: linux/include/asm-x86_64/timex.h
===================================================================
--- linux.orig/include/asm-x86_64/timex.h
+++ linux/include/asm-x86_64/timex.h
@@ -28,5 +28,4 @@ extern int read_current_timer(unsigned l
 #define US_SCALE        32 /* 2^32, arbitralrily chosen */
 
 extern void mark_tsc_unstable(char *msg);
-extern void set_cyc2ns_scale(unsigned long khz);
 #endif
Index: linux/arch/x86_64/kernel/Makefile
===================================================================
--- linux.orig/arch/x86_64/kernel/Makefile
+++ linux/arch/x86_64/kernel/Makefile
@@ -9,7 +9,7 @@ obj-y	:= process.o signal.o entry.o trap
 		x8664_ksyms.o i387.o syscall.o vsyscall.o \
 		setup64.o bootflag.o e820.o reboot.o quirks.o i8237.o \
 		pci-dma.o pci-nommu.o alternative.o hpet.o tsc.o bugs.o \
-		perfctr-watchdog.o
+		perfctr-watchdog.o sched-clock.o
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_X86_MCE)		+= mce.o therm_throt.o
@@ -64,3 +64,4 @@ msr-$(subst m,y,$(CONFIG_X86_MSR))  += .
 alternative-y			+= ../../i386/kernel/alternative.o
 pcspeaker-y			+= ../../i386/kernel/pcspeaker.o
 perfctr-watchdog-y		+= ../../i386/kernel/cpu/perfctr-watchdog.o
+sched-clock-y			+= ../../i386/kernel/sched-clock.o
Index: linux/include/asm-x86_64/timer.h
===================================================================
--- /dev/null
+++ linux/include/asm-x86_64/timer.h
@@ -0,0 +1,5 @@
+#ifndef _ASM_TIMER_H
+#define _ASM_TIMER_H 1
+
+#endif
+
