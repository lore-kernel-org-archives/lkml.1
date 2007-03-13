Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbXCMKBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbXCMKBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 06:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbXCMKBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 06:01:14 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:27687 "EHLO
	outbound3-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753206AbXCMKBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 06:01:10 -0400
X-BigFish: VP
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
Date: Tue, 13 Mar 2007 11:00:43 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: discuss@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64: fix cpu MHz reporting on constant_tsc cpus
Message-ID: <20070313100043.GC21463@amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 13 Mar 2007 10:00:53.0503 (UTC)
 FILETIME=[7C9438F0:01C76556]
X-WSS-ID: 69E8A9D32EG2645821-01-01
Content-Type: multipart/mixed;
 boundary=MfFXiAuoTsnnDAfZ
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--MfFXiAuoTsnnDAfZ
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

From: Mark Langsdorf <mark.langsdorf@amd.com>
From: Joerg Roedel <joerg.roedel@amd.com>

This patch fixes the reporting of cpu_mhz in /proc/cpuinfo on CPUs with
a constant TSC rate and a kernel with disabled cpufreq.

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG

--MfFXiAuoTsnnDAfZ
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: attachment;
 filename=gh-tsc-fix-2.6.21-rc3.patch
Content-Transfer-Encoding: 7bit

diff --git a/arch/x86_64/kernel/apic.c b/arch/x86_64/kernel/apic.c
index 723417d..5f291b2 100644
--- a/arch/x86_64/kernel/apic.c
+++ b/arch/x86_64/kernel/apic.c
@@ -839,7 +839,7 @@ static int __init calibrate_APIC_clock(void)
 		} while ((tsc - tsc_start) < TICK_COUNT &&
 				(apic - apic_start) < TICK_COUNT);
 
-		result = (apic_start - apic) * 1000L * cpu_khz /
+		result = (apic_start - apic) * 1000L * tsc_khz /
 					(tsc - tsc_start);
 	}
 	printk("result %d\n", result);
diff --git a/arch/x86_64/kernel/nmi.c b/arch/x86_64/kernel/nmi.c
index 486f4c6..0bbaeda 100644
--- a/arch/x86_64/kernel/nmi.c
+++ b/arch/x86_64/kernel/nmi.c
@@ -168,7 +168,7 @@ void release_evntsel_nmi(unsigned int msr)
 	clear_bit(counter, &__get_cpu_var(evntsel_nmi_owner));
 }
 
-static __cpuinit inline int nmi_known_cpu(void)
+__cpuinit inline int nmi_known_cpu(void)
 {
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
@@ -225,8 +225,8 @@ static unsigned int adjust_for_32bit_ctr(unsigned int hz)
 	 * 32nd bit should be 1, for 33.. to be 1.
 	 * Find the appropriate nmi_hz
 	 */
- 	if ((((u64)cpu_khz * 1000) / retval) > 0x7fffffffULL) {
-		retval = ((u64)cpu_khz * 1000) / 0x7fffffffUL + 1;
+ 	if ((((u64)tsc_khz * 1000) / retval) > 0x7fffffffULL) {
+		retval = ((u64)tsc_khz * 1000) / 0x7fffffffUL + 1;
 	}
 	return retval;
 }
@@ -493,7 +493,7 @@ static int setup_k7_watchdog(void)
 
 	/* setup the timer */
 	wrmsr(evntsel_msr, evntsel, 0);
-	wrmsrl(perfctr_msr, -((u64)cpu_khz * 1000 / nmi_hz));
+	wrmsrl(perfctr_msr, -((u64)tsc_khz * 1000 / nmi_hz));
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 	evntsel |= K7_EVNTSEL_ENABLE;
 	wrmsr(evntsel_msr, evntsel, 0);
@@ -601,7 +601,7 @@ static int setup_p4_watchdog(void)
 
 	wrmsr(evntsel_msr, evntsel, 0);
 	wrmsr(cccr_msr, cccr_val, 0);
-	wrmsrl(perfctr_msr, -((u64)cpu_khz * 1000 / nmi_hz));
+	wrmsrl(perfctr_msr, -((u64)tsc_khz * 1000 / nmi_hz));
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 	cccr_val |= P4_CCCR_ENABLE;
 	wrmsr(cccr_msr, cccr_val, 0);
@@ -671,7 +671,7 @@ static int setup_intel_arch_watchdog(void)
 	wrmsr(evntsel_msr, evntsel, 0);
 
 	nmi_hz = adjust_for_32bit_ctr(nmi_hz);
-	wrmsr(perfctr_msr, (u32)(-((u64)cpu_khz * 1000 / nmi_hz)), 0);
+	wrmsr(perfctr_msr, (u32)(-((u64)tsc_khz * 1000 / nmi_hz)), 0);
 
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 	evntsel |= ARCH_PERFMON_EVENTSEL0_ENABLE;
@@ -894,7 +894,7 @@ int __kprobes nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
 	 			apic_write(APIC_LVTPC, APIC_DM_NMI);
 				/* start the cycle over again */
 				wrmsrl(wd->perfctr_msr,
-				       -((u64)cpu_khz * 1000 / nmi_hz));
+				       -((u64)tsc_khz * 1000 / nmi_hz));
 	 		} else if (wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR0) {
 				/*
 				 * ArchPerfom/Core Duo needs to re-unmask
@@ -903,11 +903,11 @@ int __kprobes nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
 				apic_write(APIC_LVTPC, APIC_DM_NMI);
 				/* ARCH_PERFMON has 32 bit counter writes */
 				wrmsr(wd->perfctr_msr,
-				     (u32)(-((u64)cpu_khz * 1000 / nmi_hz)), 0);
+				     (u32)(-((u64)tsc_khz * 1000 / nmi_hz)), 0);
 			} else {
 				/* start the cycle over again */
 				wrmsrl(wd->perfctr_msr,
-				       -((u64)cpu_khz * 1000 / nmi_hz));
+				       -((u64)tsc_khz * 1000 / nmi_hz));
 			}
 			rc = 1;
 		} else 	if (nmi_watchdog == NMI_IO_APIC) {
@@ -1003,6 +1003,7 @@ void __trigger_all_cpu_backtrace(void)
 }
 
 EXPORT_SYMBOL(nmi_active);
+EXPORT_SYMBOL(nmi_known_cpu);
 EXPORT_SYMBOL(nmi_watchdog);
 EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi);
 EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi_bit);
diff --git a/arch/x86_64/kernel/setup.c b/arch/x86_64/kernel/setup.c
diff --git a/arch/x86_64/kernel/time.c b/arch/x86_64/kernel/time.c
index 75d73a9..52b5dc1 100644
--- a/arch/x86_64/kernel/time.c
+++ b/arch/x86_64/kernel/time.c
@@ -43,6 +43,7 @@
 #include <linux/hpet.h>
 #include <asm/apic.h>
 #include <asm/hpet.h>
+#include <asm/nmi.h>
 
 extern void i8254_timer_resume(void);
 extern int using_apic_timer;
@@ -252,6 +253,51 @@ static unsigned long get_cmos_time(void)
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
@@ -339,13 +385,19 @@ void __init time_init(void)
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
+	
+	cpu_khz = tsc_khz;
+	if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
+			nmi_known_cpu()) {
+		cpu_khz = tsc_calibrate_cpu_khz(); 
+	}
 
 	if (unsynchronized_tsc())
 		mark_tsc_unstable();
@@ -355,7 +407,7 @@ void __init time_init(void)
 	else
 		vgetcpu_mode = VGETCPU_LSL;
 
-	set_cyc2ns_scale(cpu_khz);
+	set_cyc2ns_scale(tsc_khz);
 	printk(KERN_INFO "time.c: Detected %d.%03d MHz processor.\n",
 		cpu_khz / 1000, cpu_khz % 1000);
 	init_tsc_clocksource();
diff --git a/arch/x86_64/kernel/tsc.c b/arch/x86_64/kernel/tsc.c
index 1a0edbb..5c84992 100644
--- a/arch/x86_64/kernel/tsc.c
+++ b/arch/x86_64/kernel/tsc.c
@@ -13,6 +13,8 @@ static int notsc __initdata = 0;
 
 unsigned int cpu_khz;		/* TSC clocks / usec, not used here */
 EXPORT_SYMBOL(cpu_khz);
+unsigned int tsc_khz;
+EXPORT_SYMBOL(tsc_khz);
 
 static unsigned int cyc2ns_scale __read_mostly;
 
@@ -77,7 +79,7 @@ static void handle_cpufreq_delayed_get(struct work_struct *v)
 static unsigned int  ref_freq = 0;
 static unsigned long loops_per_jiffy_ref = 0;
 
-static unsigned long cpu_khz_ref = 0;
+static unsigned long tsc_khz_ref = 0;
 
 static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 				 void *data)
@@ -99,7 +101,7 @@ static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 	if (!ref_freq) {
 		ref_freq = freq->old;
 		loops_per_jiffy_ref = *lpj;
-		cpu_khz_ref = cpu_khz;
+		tsc_khz_ref = tsc_khz;
 	}
 	if ((val == CPUFREQ_PRECHANGE  && freq->old < freq->new) ||
 		(val == CPUFREQ_POSTCHANGE && freq->old > freq->new) ||
@@ -107,12 +109,12 @@ static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
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
diff --git a/arch/x86_64/kernel/tsc_sync.c b/arch/x86_64/kernel/tsc_sync.c
index 014f0db..72d444d 100644
--- a/arch/x86_64/kernel/tsc_sync.c
+++ b/arch/x86_64/kernel/tsc_sync.c
@@ -50,7 +50,7 @@ static __cpuinit void check_tsc_warp(void)
 	/*
 	 * The measurement runs for 20 msecs:
 	 */
-	end = start + cpu_khz * 20ULL;
+	end = start + tsc_khz * 20ULL;
 	now = start;
 
 	for (i = 0; ; i++) {
diff --git a/include/asm-x86_64/nmi.h b/include/asm-x86_64/nmi.h
index ceb3d8d..6b7520c 100644
--- a/include/asm-x86_64/nmi.h
+++ b/include/asm-x86_64/nmi.h
@@ -46,6 +46,7 @@ extern int unknown_nmi_panic;
 extern int nmi_watchdog_enabled;
 
 extern int check_nmi_watchdog(void);
+extern int nmi_known_cpu(void);
 extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
 extern int avail_to_resrv_perfctr_nmi(unsigned int);
 extern int reserve_perfctr_nmi(unsigned int);
diff --git a/include/asm-x86_64/proto.h b/include/asm-x86_64/proto.h
index f54f3ab..e0b1fed 100644
--- a/include/asm-x86_64/proto.h
+++ b/include/asm-x86_64/proto.h
@@ -93,6 +93,7 @@ extern unsigned long table_start, table_end;
 
 extern int exception_trace;
 extern unsigned cpu_khz;
+extern unsigned tsc_khz;
 
 extern void no_iommu_init(void);
 extern int force_iommu, no_iommu;

--MfFXiAuoTsnnDAfZ--


