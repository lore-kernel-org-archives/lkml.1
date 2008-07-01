Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbYGASnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbYGASnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 14:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756945AbYGASn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 14:43:26 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:49420 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756824AbYGASnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 14:43:24 -0400
Subject: [PATCH 02/05] x86: Merge tsc calibration
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>
Cc: Dan Hecht <dhecht@vmware.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 01 Jul 2008 11:43:24 -0700
Message-Id: <1214937804.20191.31.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[VMware, Inc. is providing the following patch to you under the terms of the
GPL version 2 and no later version. This patch is provided as is, with no
warranties or support. VMware disclaims all liability in connection with
the use/inability to use this patch. Any use of the attached is considered
acceptance of the above.]

From:  Alok N Kataria <akataria@vmware.com>

Merge the tsc calibration code for the 32bit and 64bit kernel.
The paravirtualized calculate_cpu_khz for 64bit now points to the correct
tsc_calibrate code as in 32bit.
Original native_calculate_cpu_khz for 64 bit is now called as calibrate_cpu.

Also moved the recalibrate_cpu_khz function in the common file.
Note that this function is called only from powernow K7 cpu freq driver.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Signed-off-by: Dan Hecht <dhecht@vmware.com>

---

 arch/x86/kernel/time_64.c |   26 +++++++--
 arch/x86/kernel/tsc.c     |  131 +++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/tsc_32.c  |   74 -------------------------
 arch/x86/kernel/tsc_64.c  |   94 --------------------------------
 include/asm-x86/hpet.h    |    2 -
 include/asm-x86/tsc.h     |    1 
 6 files changed, 154 insertions(+), 174 deletions(-)


diff --git a/arch/x86/kernel/time_64.c b/arch/x86/kernel/time_64.c
index 39ae851..c6ac4da 100644
--- a/arch/x86/kernel/time_64.c
+++ b/arch/x86/kernel/time_64.c
@@ -56,7 +56,7 @@ static irqreturn_t timer_event_interrupt(int irq, void *dev_id)
 /* calibrate_cpu is used on systems with fixed rate TSCs to determine
  * processor frequency */
 #define TICK_COUNT 100000000
-unsigned long __init native_calculate_cpu_khz(void)
+static unsigned long __init calibrate_cpu(void)
 {
 	int tsc_start, tsc_now;
 	int i, no_ctr_free;
@@ -114,14 +114,18 @@ void __init hpet_time_init(void)
 	setup_irq(0, &irq0);
 }
 
+extern void set_cyc2ns_scale(unsigned long cpu_khz, int cpu);
+
 void __init time_init(void)
 {
-	tsc_calibrate();
+	int cpu;
+
+	cpu_khz = calculate_cpu_khz();
+	tsc_khz = cpu_khz;
 
-	cpu_khz = tsc_khz;
 	if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
-		(boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
-		cpu_khz = calculate_cpu_khz();
+			(boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
+		cpu_khz = calibrate_cpu();
 
 	lpj_fine = ((unsigned long)tsc_khz * 1000)/HZ;
 
@@ -134,7 +138,17 @@ void __init time_init(void)
 		vgetcpu_mode = VGETCPU_LSL;
 
 	printk(KERN_INFO "time.c: Detected %d.%03d MHz processor.\n",
-		cpu_khz / 1000, cpu_khz % 1000);
+			cpu_khz / 1000, cpu_khz % 1000);
+
+	/*
+	 * Secondary CPUs do not run through tsc_init(), so set up
+	 * all the scale factors for all CPUs, assuming the same
+	 * speed as the bootup CPU. (cpufreq notifiers will fix this
+	 * up if their speed diverges)
+	 */
+	for_each_possible_cpu(cpu)
+		set_cyc2ns_scale(cpu_khz, cpu);
+
 	init_tsc_clocksource();
 	late_time_init = choose_time_init();
 }
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 5d0be77..e6ee145 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1,7 +1,11 @@
+#include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/timer.h>
+#include <linux/acpi_pmtmr.h>
+
+#include <asm/hpet.h>
 
 unsigned int cpu_khz;           /* TSC clocks / usec, not used here */
 EXPORT_SYMBOL(cpu_khz);
@@ -84,3 +88,130 @@ int __init notsc_setup(char *str)
 #endif
 
 __setup("notsc", notsc_setup);
+
+#define MAX_RETRIES     5
+#define SMI_TRESHOLD    50000
+
+/*
+ * Read TSC and the reference counters. Take care of SMI disturbance
+ */
+static u64 __init tsc_read_refs(u64 *pm, u64 *hpet)
+{
+	u64 t1, t2;
+	int i;
+
+	for (i = 0; i < MAX_RETRIES; i++) {
+		t1 = get_cycles();
+		if (hpet)
+			*hpet = hpet_readl(HPET_COUNTER) & 0xFFFFFFFF;
+		else
+			*pm = acpi_pm_read_early();
+		t2 = get_cycles();
+		if ((t2 - t1) < SMI_TRESHOLD)
+			return t2;
+	}
+	return ULLONG_MAX;
+}
+
+/**
+ * tsc_calibrate - calibrate the tsc on boot
+ */
+static unsigned int __init tsc_calibrate(void)
+{
+	unsigned long flags;
+	u64 tsc1, tsc2, tr1, tr2, delta, pm1, pm2, hpet1, hpet2;
+	int hpet = is_hpet_enabled();
+	unsigned int tsc_khz_val = 0;
+
+	local_irq_save(flags);
+
+	tsc1 = tsc_read_refs(&pm1, hpet ? &hpet1 : NULL);
+
+	outb((inb(0x61) & ~0x02) | 0x01, 0x61);
+
+	outb(0xb0, 0x43);
+	outb((CLOCK_TICK_RATE / (1000 / 50)) & 0xff, 0x42);
+	outb((CLOCK_TICK_RATE / (1000 / 50)) >> 8, 0x42);
+	tr1 = get_cycles();
+	while ((inb(0x61) & 0x20) == 0);
+	tr2 = get_cycles();
+
+	tsc2 = tsc_read_refs(&pm2, hpet ? &hpet2 : NULL);
+
+	local_irq_restore(flags);
+
+	/*
+	 * Preset the result with the raw and inaccurate PIT
+	 * calibration value
+	 */
+	delta = (tr2 - tr1);
+	do_div(delta, 50);
+	tsc_khz_val = delta;
+
+	/* hpet or pmtimer available ? */
+	if (!hpet && !pm1 && !pm2) {
+		printk(KERN_INFO "TSC calibrated against PIT\n");
+		goto out;
+	}
+
+	/* Check, whether the sampling was disturbed by an SMI */
+	if (tsc1 == ULLONG_MAX || tsc2 == ULLONG_MAX) {
+		printk(KERN_WARNING "TSC calibration disturbed by SMI, "
+				"using PIT calibration result\n");
+		goto out;
+	}
+
+	tsc2 = (tsc2 - tsc1) * 1000000LL;
+
+	if (hpet) {
+		printk(KERN_INFO "TSC calibrated against HPET\n");
+		if (hpet2 < hpet1)
+			hpet2 += 0x100000000ULL;
+		hpet2 -= hpet1;
+		tsc1 = ((u64)hpet2 * hpet_readl(HPET_PERIOD));
+		do_div(tsc1, 1000000);
+	} else {
+		printk(KERN_INFO "TSC calibrated against PM_TIMER\n");
+		if (pm2 < pm1)
+			pm2 += (u64)ACPI_PM_OVRRUN;
+		pm2 -= pm1;
+		tsc1 = pm2 * 1000000000LL;
+		do_div(tsc1, PMTMR_TICKS_PER_SEC);
+	}
+
+	do_div(tsc2, tsc1);
+	tsc_khz_val = tsc2;
+
+out:
+	return tsc_khz_val;
+}
+
+unsigned long native_calculate_cpu_khz(void)
+{
+	return tsc_calibrate();
+}
+
+#ifdef CONFIG_X86_32
+/* Only called from the Powernow K7 cpu freq driver */
+int recalibrate_cpu_khz(void)
+{
+#ifndef CONFIG_SMP
+	unsigned long cpu_khz_old = cpu_khz;
+
+	if (cpu_has_tsc) {
+		cpu_khz = calculate_cpu_khz();
+		tsc_khz = cpu_khz;
+		cpu_data(0).loops_per_jiffy =
+			cpufreq_scale(cpu_data(0).loops_per_jiffy,
+					cpu_khz_old, cpu_khz);
+		return 0;
+	} else
+		return -ENODEV;
+#else
+	return -ENODEV;
+#endif
+}
+
+EXPORT_SYMBOL(recalibrate_cpu_khz);
+
+#endif /* CONFIG_X86_32 */
diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
index dc89900..40c0aaf 100644
--- a/arch/x86/kernel/tsc_32.c
+++ b/arch/x86/kernel/tsc_32.c
@@ -42,7 +42,7 @@ extern int tsc_disabled;
 
 DEFINE_PER_CPU(unsigned long, cyc2ns);
 
-static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
+void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 {
 	unsigned long long tsc_now, ns_now;
 	unsigned long flags, *scale;
@@ -65,78 +65,6 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 	local_irq_restore(flags);
 }
 
-unsigned long native_calculate_cpu_khz(void)
-{
-	unsigned long long start, end;
-	unsigned long count;
-	u64 delta64 = (u64)ULLONG_MAX;
-	int i;
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	/* run 3 times to ensure the cache is warm and to get an accurate reading */
-	for (i = 0; i < 3; i++) {
-		mach_prepare_counter();
-		rdtscll(start);
-		mach_countup(&count);
-		rdtscll(end);
-
-		/*
-		 * Error: ECTCNEVERSET
-		 * The CTC wasn't reliable: we got a hit on the very first read,
-		 * or the CPU was so fast/slow that the quotient wouldn't fit in
-		 * 32 bits..
-		 */
-		if (count <= 1)
-			continue;
-
-		/* cpu freq too slow: */
-		if ((end - start) <= CALIBRATE_TIME_MSEC)
-			continue;
-
-		/*
-		 * We want the minimum time of all runs in case one of them
-		 * is inaccurate due to SMI or other delay
-		 */
-		delta64 = min(delta64, (end - start));
-	}
-
-	/* cpu freq too fast (or every run was bad): */
-	if (delta64 > (1ULL<<32))
-		goto err;
-
-	delta64 += CALIBRATE_TIME_MSEC/2; /* round for do_div */
-	do_div(delta64,CALIBRATE_TIME_MSEC);
-
-	local_irq_restore(flags);
-	return (unsigned long)delta64;
-err:
-	local_irq_restore(flags);
-	return 0;
-}
-
-int recalibrate_cpu_khz(void)
-{
-#ifndef CONFIG_SMP
-	unsigned long cpu_khz_old = cpu_khz;
-
-	if (cpu_has_tsc) {
-		cpu_khz = calculate_cpu_khz();
-		tsc_khz = cpu_khz;
-		cpu_data(0).loops_per_jiffy =
-			cpufreq_scale(cpu_data(0).loops_per_jiffy,
-					cpu_khz_old, cpu_khz);
-		return 0;
-	} else
-		return -ENODEV;
-#else
-	return -ENODEV;
-#endif
-}
-
-EXPORT_SYMBOL(recalibrate_cpu_khz);
-
 #ifdef CONFIG_CPU_FREQ
 
 /*
diff --git a/arch/x86/kernel/tsc_64.c b/arch/x86/kernel/tsc_64.c
index 69cbe4c..c852ff9 100644
--- a/arch/x86/kernel/tsc_64.c
+++ b/arch/x86/kernel/tsc_64.c
@@ -40,7 +40,7 @@ extern int tsc_disabled;
 
 DEFINE_PER_CPU(unsigned long, cyc2ns);
 
-static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
+void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 {
 	unsigned long long tsc_now, ns_now;
 	unsigned long flags, *scale;
@@ -130,98 +130,6 @@ core_initcall(cpufreq_tsc);
 
 #endif
 
-#define MAX_RETRIES	5
-#define SMI_TRESHOLD	50000
-
-/*
- * Read TSC and the reference counters. Take care of SMI disturbance
- */
-static unsigned long __init tsc_read_refs(unsigned long *pm,
-					  unsigned long *hpet)
-{
-	unsigned long t1, t2;
-	int i;
-
-	for (i = 0; i < MAX_RETRIES; i++) {
-		t1 = get_cycles();
-		if (hpet)
-			*hpet = hpet_readl(HPET_COUNTER) & 0xFFFFFFFF;
-		else
-			*pm = acpi_pm_read_early();
-		t2 = get_cycles();
-		if ((t2 - t1) < SMI_TRESHOLD)
-			return t2;
-	}
-	return ULONG_MAX;
-}
-
-/**
- * tsc_calibrate - calibrate the tsc on boot
- */
-void __init tsc_calibrate(void)
-{
-	unsigned long flags, tsc1, tsc2, tr1, tr2, pm1, pm2, hpet1, hpet2;
-	int hpet = is_hpet_enabled(), cpu;
-
-	local_irq_save(flags);
-
-	tsc1 = tsc_read_refs(&pm1, hpet ? &hpet1 : NULL);
-
-	outb((inb(0x61) & ~0x02) | 0x01, 0x61);
-
-	outb(0xb0, 0x43);
-	outb((CLOCK_TICK_RATE / (1000 / 50)) & 0xff, 0x42);
-	outb((CLOCK_TICK_RATE / (1000 / 50)) >> 8, 0x42);
-	tr1 = get_cycles();
-	while ((inb(0x61) & 0x20) == 0);
-	tr2 = get_cycles();
-
-	tsc2 = tsc_read_refs(&pm2, hpet ? &hpet2 : NULL);
-
-	local_irq_restore(flags);
-
-	/*
-	 * Preset the result with the raw and inaccurate PIT
-	 * calibration value
-	 */
-	tsc_khz = (tr2 - tr1) / 50;
-
-	/* hpet or pmtimer available ? */
-	if (!hpet && !pm1 && !pm2) {
-		printk(KERN_INFO "TSC calibrated against PIT\n");
-		goto out;
-	}
-
-	/* Check, whether the sampling was disturbed by an SMI */
-	if (tsc1 == ULONG_MAX || tsc2 == ULONG_MAX) {
-		printk(KERN_WARNING "TSC calibration disturbed by SMI, "
-		       "using PIT calibration result\n");
-		goto out;
-	}
-
-	tsc2 = (tsc2 - tsc1) * 1000000L;
-
-	if (hpet) {
-		printk(KERN_INFO "TSC calibrated against HPET\n");
-		if (hpet2 < hpet1)
-			hpet2 += 0x100000000UL;
-		hpet2 -= hpet1;
-		tsc1 = (hpet2 * hpet_readl(HPET_PERIOD)) / 1000000;
-	} else {
-		printk(KERN_INFO "TSC calibrated against PM_TIMER\n");
-		if (pm2 < pm1)
-			pm2 += ACPI_PM_OVRRUN;
-		pm2 -= pm1;
-		tsc1 = (pm2 * 1000000000) / PMTMR_TICKS_PER_SEC;
-	}
-
-	tsc_khz = tsc2 / tsc1;
-
-out:
-	for_each_possible_cpu(cpu)
-		set_cyc2ns_scale(tsc_khz, cpu);
-}
-
 /*
  * Make an educated guess if the TSC is trustworthy and synchronized
  * over all CPUs.
diff --git a/include/asm-x86/hpet.h b/include/asm-x86/hpet.h
index 6a9b4ac..82f1ac6 100644
--- a/include/asm-x86/hpet.h
+++ b/include/asm-x86/hpet.h
@@ -86,8 +86,8 @@ extern void hpet_unregister_irq_handler(rtc_irq_handler handler);
 #else /* CONFIG_HPET_TIMER */
 
 static inline int hpet_enable(void) { return 0; }
-static inline unsigned long hpet_readl(unsigned long a) { return 0; }
 static inline int is_hpet_enabled(void) { return 0; }
+#define hpet_readl(a) 0
 
 #endif
 #endif /* ASM_X86_HPET_H */
diff --git a/include/asm-x86/tsc.h b/include/asm-x86/tsc.h
index 548873a..761054d 100644
--- a/include/asm-x86/tsc.h
+++ b/include/asm-x86/tsc.h
@@ -58,7 +58,6 @@ int check_tsc_unstable(void);
 extern void check_tsc_sync_source(int cpu);
 extern void check_tsc_sync_target(void);
 
-extern void tsc_calibrate(void);
 extern int notsc_setup(char *);
 
 #endif


