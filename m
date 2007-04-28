Return-Path: <linux-kernel-owner+w=401wt.eu-S1163328AbXD1Rxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163328AbXD1Rxq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163306AbXD1Rxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:53:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38683 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163325AbXD1RxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:53:01 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [34/35] x86_64: fix cpu MHz reporting on constant_tsc cpus
Message-Id: <20070428175300.3EC6C151D1@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:53:00 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Joerg Roedel <joerg.roedel@amd.com>

This patch fixes the reporting of cpu_mhz in /proc/cpuinfo on CPUs with
a constant TSC rate and a kernel with disabled cpufreq.

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Andi Kleen <ak@suse.de>

 arch/x86_64/kernel/apic.c     |    2 -
 arch/x86_64/kernel/time.c     |   58 +++++++++++++++++++++++++++++++++++++++---
 arch/x86_64/kernel/tsc.c      |   12 +++++---
 arch/x86_64/kernel/tsc_sync.c |    2 -
 include/asm-x86_64/proto.h    |    1 
 5 files changed, 65 insertions(+), 10 deletions(-)

Index: linux/arch/x86_64/kernel/apic.c
===================================================================
--- linux.orig/arch/x86_64/kernel/apic.c
+++ linux/arch/x86_64/kernel/apic.c
@@ -843,7 +843,7 @@ static int __init calibrate_APIC_clock(v
 		} while ((tsc - tsc_start) < TICK_COUNT &&
 				(apic - apic_start) < TICK_COUNT);
 
-		result = (apic_start - apic) * 1000L * cpu_khz /
+		result = (apic_start - apic) * 1000L * tsc_khz /
 					(tsc - tsc_start);
 	}
 	printk("result %d\n", result);
Index: linux/arch/x86_64/kernel/time.c
===================================================================
--- linux.orig/arch/x86_64/kernel/time.c
+++ linux/arch/x86_64/kernel/time.c
@@ -43,6 +43,7 @@
 #include <asm/apic.h>
 #include <asm/hpet.h>
 #include <asm/mpspec.h>
+#include <asm/nmi.h>
 
 static char *timename = NULL;
 
@@ -249,6 +250,51 @@ static unsigned long get_cmos_time(void)
 	return mktime(year, mon, day, hour, min, sec);
 }
 
+/* calibrate_cpu is used on systems with fixed rate TSCs to determine
+ * processor frequency */
+#define TICK_COUNT 100000000
+static unsigned int __init tsc_calibrate_cpu_khz(void)
+{
+       int tsc_start, tsc_now;
+       int i, no_ctr_free;
+       unsigned long evntsel3 = 0, pmc3 = 0, pmc_now = 0;
+       unsigned long flags;
+
+       for (i = 0; i < 4; i++)
+               if (avail_to_resrv_perfctr_nmi_bit(i))
+                       break;
+       no_ctr_free = (i == 4);
+       if (no_ctr_free) {
+               i = 3;
+               rdmsrl(MSR_K7_EVNTSEL3, evntsel3);
+               wrmsrl(MSR_K7_EVNTSEL3, 0);
+               rdmsrl(MSR_K7_PERFCTR3, pmc3);
+       } else {
+               reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+               reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
+       }
+       local_irq_save(flags);
+       /* start meauring cycles, incrementing from 0 */
+       wrmsrl(MSR_K7_PERFCTR0 + i, 0);
+       wrmsrl(MSR_K7_EVNTSEL0 + i, 1 << 22 | 3 << 16 | 0x76);
+       rdtscl(tsc_start);
+       do {
+               rdmsrl(MSR_K7_PERFCTR0 + i, pmc_now);
+               tsc_now = get_cycles_sync();
+       } while ((tsc_now - tsc_start) < TICK_COUNT);
+
+       local_irq_restore(flags);
+       if (no_ctr_free) {
+               wrmsrl(MSR_K7_EVNTSEL3, 0);
+               wrmsrl(MSR_K7_PERFCTR3, pmc3);
+               wrmsrl(MSR_K7_EVNTSEL3, evntsel3);
+       } else {
+               release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+               release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
+       }
+
+       return pmc_now * tsc_khz / (tsc_now - tsc_start);
+}
 
 /*
  * pit_calibrate_tsc() uses the speaker output (channel 2) of
@@ -336,14 +382,20 @@ void __init time_init(void)
 	if (hpet_use_timer) {
 		/* set tick_nsec to use the proper rate for HPET */
 	  	tick_nsec = TICK_NSEC_HPET;
-		cpu_khz = hpet_calibrate_tsc();
+		tsc_khz = hpet_calibrate_tsc();
 		timename = "HPET";
 	} else {
 		pit_init();
-		cpu_khz = pit_calibrate_tsc();
+		tsc_khz = pit_calibrate_tsc();
 		timename = "PIT";
 	}
 
+	cpu_khz = tsc_khz;
+	if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
+		boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
+		boot_cpu_data.x86 == 16)
+		cpu_khz = tsc_calibrate_cpu_khz();
+
 	if (unsynchronized_tsc())
 		mark_tsc_unstable();
 
@@ -352,7 +404,7 @@ void __init time_init(void)
 	else
 		vgetcpu_mode = VGETCPU_LSL;
 
-	set_cyc2ns_scale(cpu_khz);
+	set_cyc2ns_scale(tsc_khz);
 	printk(KERN_INFO "time.c: Detected %d.%03d MHz processor.\n",
 		cpu_khz / 1000, cpu_khz % 1000);
 	init_tsc_clocksource();
Index: linux/arch/x86_64/kernel/tsc.c
===================================================================
--- linux.orig/arch/x86_64/kernel/tsc.c
+++ linux/arch/x86_64/kernel/tsc.c
@@ -13,6 +13,8 @@ static int notsc __initdata = 0;
 
 unsigned int cpu_khz;		/* TSC clocks / usec, not used here */
 EXPORT_SYMBOL(cpu_khz);
+unsigned int tsc_khz;
+EXPORT_SYMBOL(tsc_khz);
 
 static unsigned int cyc2ns_scale __read_mostly;
 
@@ -77,7 +79,7 @@ static void handle_cpufreq_delayed_get(s
 static unsigned int  ref_freq = 0;
 static unsigned long loops_per_jiffy_ref = 0;
 
-static unsigned long cpu_khz_ref = 0;
+static unsigned long tsc_khz_ref = 0;
 
 static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 				 void *data)
@@ -99,7 +101,7 @@ static int time_cpufreq_notifier(struct 
 	if (!ref_freq) {
 		ref_freq = freq->old;
 		loops_per_jiffy_ref = *lpj;
-		cpu_khz_ref = cpu_khz;
+		tsc_khz_ref = tsc_khz;
 	}
 	if ((val == CPUFREQ_PRECHANGE  && freq->old < freq->new) ||
 		(val == CPUFREQ_POSTCHANGE && freq->old > freq->new) ||
@@ -107,12 +109,12 @@ static int time_cpufreq_notifier(struct 
 		*lpj =
 		cpufreq_scale(loops_per_jiffy_ref, ref_freq, freq->new);
 
-		cpu_khz = cpufreq_scale(cpu_khz_ref, ref_freq, freq->new);
+		tsc_khz = cpufreq_scale(tsc_khz_ref, ref_freq, freq->new);
 		if (!(freq->flags & CPUFREQ_CONST_LOOPS))
 			mark_tsc_unstable();
 	}
 
-	set_cyc2ns_scale(cpu_khz_ref);
+	set_cyc2ns_scale(tsc_khz_ref);
 
 	return 0;
 }
@@ -213,7 +215,7 @@ EXPORT_SYMBOL_GPL(mark_tsc_unstable);
 void __init init_tsc_clocksource(void)
 {
 	if (!notsc) {
-		clocksource_tsc.mult = clocksource_khz2mult(cpu_khz,
+		clocksource_tsc.mult = clocksource_khz2mult(tsc_khz,
 							clocksource_tsc.shift);
 		if (check_tsc_unstable())
 			clocksource_tsc.rating = 0;
Index: linux/arch/x86_64/kernel/tsc_sync.c
===================================================================
--- linux.orig/arch/x86_64/kernel/tsc_sync.c
+++ linux/arch/x86_64/kernel/tsc_sync.c
@@ -50,7 +50,7 @@ static __cpuinit void check_tsc_warp(voi
 	/*
 	 * The measurement runs for 20 msecs:
 	 */
-	end = start + cpu_khz * 20ULL;
+	end = start + tsc_khz * 20ULL;
 	now = start;
 
 	for (i = 0; ; i++) {
Index: linux/include/asm-x86_64/proto.h
===================================================================
--- linux.orig/include/asm-x86_64/proto.h
+++ linux/include/asm-x86_64/proto.h
@@ -92,6 +92,7 @@ extern unsigned long table_start, table_
 
 extern int exception_trace;
 extern unsigned cpu_khz;
+extern unsigned tsc_khz;
 
 extern void no_iommu_init(void);
 extern int force_iommu, no_iommu;
