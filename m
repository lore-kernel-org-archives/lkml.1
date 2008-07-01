Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbYGASof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbYGASof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 14:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757442AbYGASni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 14:43:38 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:49486 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753424AbYGASnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 14:43:35 -0400
Subject: [PATCH 04/05] x86: Merge tsc_init and clocksource code
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>
Cc: Dan Hecht <dhecht@vmware.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 01 Jul 2008 11:43:34 -0700
Message-Id: <1214937814.20191.33.camel@promb-2n-dhcp368.eng.vmware.com>
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

Unify the clocksource code.
Unify the tsc_init code.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Signed-off-by: Dan Hecht <dhecht@vmware.com>

---

 arch/x86/kernel/Makefile  |    2 
 arch/x86/kernel/time_64.c |   32 -------
 arch/x86/kernel/tsc.c     |  212 ++++++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/tsc_32.c  |  188 ----------------------------------------
 arch/x86/kernel/tsc_64.c  |  106 -----------------------
 include/asm-x86/apic.h    |    7 +
 include/asm-x86/delay.h   |    4 +
 include/asm-x86/time.h    |    2 
 include/asm-x86/tsc.h     |    1 
 9 files changed, 224 insertions(+), 330 deletions(-)
 delete mode 100644 arch/x86/kernel/tsc_32.c
 delete mode 100644 arch/x86/kernel/tsc_64.c


diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 631141b..8f60218 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -34,7 +34,7 @@ obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o i8237.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o
-obj-y			+= tsc_$(BITS).o io_delay.o rtc.o tsc.o
+obj-y			+= tsc.o io_delay.o rtc.o
 
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
 obj-y				+= process.o
diff --git a/arch/x86/kernel/time_64.c b/arch/x86/kernel/time_64.c
index c6ac4da..e3d49c5 100644
--- a/arch/x86/kernel/time_64.c
+++ b/arch/x86/kernel/time_64.c
@@ -56,7 +56,7 @@ static irqreturn_t timer_event_interrupt(int irq, void *dev_id)
 /* calibrate_cpu is used on systems with fixed rate TSCs to determine
  * processor frequency */
 #define TICK_COUNT 100000000
-static unsigned long __init calibrate_cpu(void)
+unsigned long __init calibrate_cpu(void)
 {
 	int tsc_start, tsc_now;
 	int i, no_ctr_free;
@@ -114,41 +114,13 @@ void __init hpet_time_init(void)
 	setup_irq(0, &irq0);
 }
 
-extern void set_cyc2ns_scale(unsigned long cpu_khz, int cpu);
-
 void __init time_init(void)
 {
-	int cpu;
-
-	cpu_khz = calculate_cpu_khz();
-	tsc_khz = cpu_khz;
-
-	if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
-			(boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
-		cpu_khz = calibrate_cpu();
-
-	lpj_fine = ((unsigned long)tsc_khz * 1000)/HZ;
-
-	if (unsynchronized_tsc())
-		mark_tsc_unstable("TSCs unsynchronized");
-
+	tsc_init();
 	if (cpu_has(&boot_cpu_data, X86_FEATURE_RDTSCP))
 		vgetcpu_mode = VGETCPU_RDTSCP;
 	else
 		vgetcpu_mode = VGETCPU_LSL;
 
-	printk(KERN_INFO "time.c: Detected %d.%03d MHz processor.\n",
-			cpu_khz / 1000, cpu_khz % 1000);
-
-	/*
-	 * Secondary CPUs do not run through tsc_init(), so set up
-	 * all the scale factors for all CPUs, assuming the same
-	 * speed as the bootup CPU. (cpufreq notifiers will fix this
-	 * up if their speed diverges)
-	 */
-	for_each_possible_cpu(cpu)
-		set_cyc2ns_scale(cpu_khz, cpu);
-
-	init_tsc_clocksource();
 	late_time_init = choose_time_init();
 }
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 595f78a..94c16bd 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -5,8 +5,16 @@
 #include <linux/timer.h>
 #include <linux/acpi_pmtmr.h>
 #include <linux/cpufreq.h>
+#include <linux/dmi.h>
+#include <linux/delay.h>
+#include <linux/clocksource.h>
+#include <linux/percpu.h>
 
 #include <asm/hpet.h>
+#include <asm/timer.h>
+#include <asm/vgtod.h>
+#include <asm/time.h>
+#include <asm/delay.h>
 
 unsigned int cpu_khz;           /* TSC clocks / usec, not used here */
 EXPORT_SYMBOL(cpu_khz);
@@ -16,12 +24,12 @@ EXPORT_SYMBOL(tsc_khz);
 /*
  * TSC can be unstable due to cpufreq or due to unsynced TSCs
  */
-int tsc_unstable;
+static int tsc_unstable;
 
 /* native_sched_clock() is called before tsc_init(), so
    we must start with the TSC soft disabled to prevent
    erroneous rdtsc usage on !cpu_has_tsc processors */
-int tsc_disabled = -1;
+static int tsc_disabled = -1;
 
 /*
  * Scheduler clock - returns current time in nanosec units.
@@ -241,7 +249,7 @@ EXPORT_SYMBOL(recalibrate_cpu_khz);
 
 DEFINE_PER_CPU(unsigned long, cyc2ns);
 
-void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
+static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
 {
 	unsigned long long tsc_now, ns_now;
 	unsigned long flags, *scale;
@@ -329,3 +337,201 @@ static int __init cpufreq_tsc(void)
 core_initcall(cpufreq_tsc);
 
 #endif /* CONFIG_CPU_FREQ */
+
+/* clocksource code */
+
+static struct clocksource clocksource_tsc;
+
+/*
+ * We compare the TSC to the cycle_last value in the clocksource
+ * structure to avoid a nasty time-warp. This can be observed in a
+ * very small window right after one CPU updated cycle_last under
+ * xtime/vsyscall_gtod lock and the other CPU reads a TSC value which
+ * is smaller than the cycle_last reference value due to a TSC which
+ * is slighty behind. This delta is nowhere else observable, but in
+ * that case it results in a forward time jump in the range of hours
+ * due to the unsigned delta calculation of the time keeping core
+ * code, which is necessary to support wrapping clocksources like pm
+ * timer.
+ */
+static cycle_t read_tsc(void)
+{
+	cycle_t ret = (cycle_t)get_cycles();
+
+	return ret >= clocksource_tsc.cycle_last ?
+		ret : clocksource_tsc.cycle_last;
+}
+
+static cycle_t __vsyscall_fn vread_tsc(void)
+{
+	cycle_t ret = (cycle_t)vget_cycles();
+
+	return ret >= __vsyscall_gtod_data.clock.cycle_last ?
+		ret : __vsyscall_gtod_data.clock.cycle_last;
+}
+
+static struct clocksource clocksource_tsc = {
+	.name                   = "tsc",
+	.rating                 = 300,
+	.read                   = read_tsc,
+	.mask                   = CLOCKSOURCE_MASK(64),
+	.shift                  = 22,
+	.flags                  = CLOCK_SOURCE_IS_CONTINUOUS |
+				  CLOCK_SOURCE_MUST_VERIFY,
+#ifdef CONFIG_X86_64
+	.vread                  = vread_tsc,
+#endif
+};
+
+void mark_tsc_unstable(char *reason)
+{
+	if (!tsc_unstable) {
+		tsc_unstable = 1;
+		printk("Marking TSC unstable due to %s\n", reason);
+		/* Change only the rating, when not registered */
+		if (clocksource_tsc.mult)
+			clocksource_change_rating(&clocksource_tsc, 0);
+		else
+			clocksource_tsc.rating = 0;
+	}
+}
+
+EXPORT_SYMBOL_GPL(mark_tsc_unstable);
+
+static int __init dmi_mark_tsc_unstable(const struct dmi_system_id *d)
+{
+	printk(KERN_NOTICE "%s detected: marking TSC unstable.\n",
+			d->ident);
+	tsc_unstable = 1;
+	return 0;
+}
+
+/* List of systems that have known TSC problems */
+static struct dmi_system_id __initdata bad_tsc_dmi_table[] = {
+	{
+		.callback = dmi_mark_tsc_unstable,
+		.ident = "IBM Thinkpad 380XD",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "IBM"),
+			DMI_MATCH(DMI_BOARD_NAME, "2635FA0"),
+		},
+	},
+	{}
+};
+
+/*
+ * Geode_LX - the OLPC CPU has a possibly a very reliable TSC
+ */
+#ifdef CONFIG_MGEODE_LX
+/* RTSC counts during suspend */
+#define RTSC_SUSP 0x100
+
+static void __init check_geode_tsc_reliable(void)
+{
+	unsigned long res_low, res_high;
+
+	rdmsr_safe(MSR_GEODE_BUSCONT_CONF0, &res_low, &res_high);
+	if (res_low & RTSC_SUSP)
+		clocksource_tsc.flags &= ~CLOCK_SOURCE_MUST_VERIFY;
+}
+#else
+static inline void check_geode_tsc_reliable(void) { }
+#endif
+
+/*
+ * Make an educated guess if the TSC is trustworthy and synchronized
+ * over all CPUs.
+ */
+__cpuinit int unsynchronized_tsc(void)
+{
+	if (!cpu_has_tsc || tsc_unstable)
+		return 1;
+
+#ifdef CONFIG_SMP
+	if (apic_is_clustered_box())
+		return 1;
+#endif
+
+	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
+		return 0;
+	/*
+	 * Intel systems are normally all synchronized.
+	 * Exceptions must mark TSC as unstable:
+	 */
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL) {
+		/* assume multi socket systems are not synchronized: */
+		if (num_possible_cpus() > 1)
+			tsc_unstable = 1;
+	}
+
+	return tsc_unstable;
+}
+
+static void __init init_tsc_clocksource(void)
+{
+	clocksource_tsc.mult = clocksource_khz2mult(tsc_khz,
+			clocksource_tsc.shift);
+	/* lower the rating if we already know its unstable: */
+	if (check_tsc_unstable()) {
+		clocksource_tsc.rating = 0;
+		clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
+	}
+	clocksource_register(&clocksource_tsc);
+}
+
+void __init tsc_init(void)
+{
+	u64 lpj;
+	int cpu;
+
+	if (!cpu_has_tsc)
+		return;
+
+	cpu_khz = calculate_cpu_khz();
+	tsc_khz = cpu_khz;
+
+	if (!cpu_khz) {
+		mark_tsc_unstable("could not calculate TSC khz");
+		return;
+	}
+
+#ifdef CONFIG_X86_64
+	if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
+			(boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
+		cpu_khz = calibrate_cpu();
+#endif
+
+	lpj = ((u64)tsc_khz * 1000);
+	do_div(lpj, HZ);
+	lpj_fine = lpj;
+
+	printk("Detected %lu.%03lu MHz processor.\n",
+			(unsigned long)cpu_khz / 1000,
+			(unsigned long)cpu_khz % 1000);
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
+	if (tsc_disabled > 0)
+		return;
+
+	/* now allow native_sched_clock() to use rdtsc */
+	tsc_disabled = 0;
+
+	use_tsc_delay();
+	/* Check and install the TSC clocksource */
+	dmi_check_system(bad_tsc_dmi_table);
+
+	if (unsynchronized_tsc())
+		mark_tsc_unstable("TSCs unsynchronized");
+
+	check_geode_tsc_reliable();
+	init_tsc_clocksource();
+}
+
diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
deleted file mode 100644
index bbc153d..0000000
--- a/arch/x86/kernel/tsc_32.c
+++ /dev/null
@@ -1,188 +0,0 @@
-#include <linux/sched.h>
-#include <linux/clocksource.h>
-#include <linux/workqueue.h>
-#include <linux/delay.h>
-#include <linux/cpufreq.h>
-#include <linux/jiffies.h>
-#include <linux/init.h>
-#include <linux/dmi.h>
-#include <linux/percpu.h>
-
-#include <asm/delay.h>
-#include <asm/tsc.h>
-#include <asm/io.h>
-#include <asm/timer.h>
-
-#include "mach_timer.h"
-
-extern int tsc_unstable;
-extern int tsc_disabled;
-
-/* clock source code */
-
-static struct clocksource clocksource_tsc;
-
-/*
- * We compare the TSC to the cycle_last value in the clocksource
- * structure to avoid a nasty time-warp issue. This can be observed in
- * a very small window right after one CPU updated cycle_last under
- * xtime lock and the other CPU reads a TSC value which is smaller
- * than the cycle_last reference value due to a TSC which is slighty
- * behind. This delta is nowhere else observable, but in that case it
- * results in a forward time jump in the range of hours due to the
- * unsigned delta calculation of the time keeping core code, which is
- * necessary to support wrapping clocksources like pm timer.
- */
-static cycle_t read_tsc(void)
-{
-	cycle_t ret;
-
-	rdtscll(ret);
-
-	return ret >= clocksource_tsc.cycle_last ?
-		ret : clocksource_tsc.cycle_last;
-}
-
-static struct clocksource clocksource_tsc = {
-	.name			= "tsc",
-	.rating			= 300,
-	.read			= read_tsc,
-	.mask			= CLOCKSOURCE_MASK(64),
-	.mult			= 0, /* to be set */
-	.shift			= 22,
-	.flags			= CLOCK_SOURCE_IS_CONTINUOUS |
-				  CLOCK_SOURCE_MUST_VERIFY,
-};
-
-void mark_tsc_unstable(char *reason)
-{
-	if (!tsc_unstable) {
-		tsc_unstable = 1;
-		printk("Marking TSC unstable due to: %s.\n", reason);
-		/* Can be called before registration */
-		if (clocksource_tsc.mult)
-			clocksource_change_rating(&clocksource_tsc, 0);
-		else
-			clocksource_tsc.rating = 0;
-	}
-}
-EXPORT_SYMBOL_GPL(mark_tsc_unstable);
-
-static int __init dmi_mark_tsc_unstable(const struct dmi_system_id *d)
-{
-	printk(KERN_NOTICE "%s detected: marking TSC unstable.\n",
-	       d->ident);
-	tsc_unstable = 1;
-	return 0;
-}
-
-/* List of systems that have known TSC problems */
-static struct dmi_system_id __initdata bad_tsc_dmi_table[] = {
-	{
-	 .callback = dmi_mark_tsc_unstable,
-	 .ident = "IBM Thinkpad 380XD",
-	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "IBM"),
-		     DMI_MATCH(DMI_BOARD_NAME, "2635FA0"),
-		     },
-	 },
-	 {}
-};
-
-/*
- * Make an educated guess if the TSC is trustworthy and synchronized
- * over all CPUs.
- */
-__cpuinit int unsynchronized_tsc(void)
-{
-	if (!cpu_has_tsc || tsc_unstable)
-		return 1;
-
-	/* Anything with constant TSC should be synchronized */
-	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
-		return 0;
-
-	/*
-	 * Intel systems are normally all synchronized.
-	 * Exceptions must mark TSC as unstable:
-	 */
-	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL) {
-		/* assume multi socket systems are not synchronized: */
-		if (num_possible_cpus() > 1)
-			tsc_unstable = 1;
-	}
-	return tsc_unstable;
-}
-
-/*
- * Geode_LX - the OLPC CPU has a possibly a very reliable TSC
- */
-#ifdef CONFIG_MGEODE_LX
-/* RTSC counts during suspend */
-#define RTSC_SUSP 0x100
-
-static void __init check_geode_tsc_reliable(void)
-{
-	unsigned long res_low, res_high;
-
-	rdmsr_safe(MSR_GEODE_BUSCONT_CONF0, &res_low, &res_high);
-	if (res_low & RTSC_SUSP)
-		clocksource_tsc.flags &= ~CLOCK_SOURCE_MUST_VERIFY;
-}
-#else
-static inline void check_geode_tsc_reliable(void) { }
-#endif
-
-
-void __init tsc_init(void)
-{
-	int cpu;
-	u64 lpj;
-
-	if (!cpu_has_tsc || tsc_disabled > 0)
-		return;
-
-	cpu_khz = calculate_cpu_khz();
-	tsc_khz = cpu_khz;
-
-	if (!cpu_khz) {
-		mark_tsc_unstable("could not calculate TSC khz");
-		return;
-	}
-
-	lpj = ((u64)tsc_khz * 1000);
-	do_div(lpj, HZ);
-	lpj_fine = lpj;
-
-	/* now allow native_sched_clock() to use rdtsc */
-	tsc_disabled = 0;
-
-	printk("Detected %lu.%03lu MHz processor.\n",
-				(unsigned long)cpu_khz / 1000,
-				(unsigned long)cpu_khz % 1000);
-
-	/*
-	 * Secondary CPUs do not run through tsc_init(), so set up
-	 * all the scale factors for all CPUs, assuming the same
-	 * speed as the bootup CPU. (cpufreq notifiers will fix this
-	 * up if their speed diverges)
-	 */
-	for_each_possible_cpu(cpu)
-		set_cyc2ns_scale(cpu_khz, cpu);
-
-	use_tsc_delay();
-
-	/* Check and install the TSC clocksource */
-	dmi_check_system(bad_tsc_dmi_table);
-
-	unsynchronized_tsc();
-	check_geode_tsc_reliable();
-	clocksource_tsc.mult = clocksource_khz2mult(tsc_khz,
-						    clocksource_tsc.shift);
-	/* lower the rating if we already know its unstable: */
-	if (check_tsc_unstable()) {
-		clocksource_tsc.rating = 0;
-		clocksource_tsc.flags &= ~CLOCK_SOURCE_IS_CONTINUOUS;
-	}
-	clocksource_register(&clocksource_tsc);
-}
diff --git a/arch/x86/kernel/tsc_64.c b/arch/x86/kernel/tsc_64.c
deleted file mode 100644
index 80a274b..0000000
--- a/arch/x86/kernel/tsc_64.c
+++ /dev/null
@@ -1,106 +0,0 @@
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/interrupt.h>
-#include <linux/init.h>
-#include <linux/clocksource.h>
-#include <linux/time.h>
-#include <linux/acpi.h>
-#include <linux/cpufreq.h>
-#include <linux/acpi_pmtmr.h>
-
-#include <asm/hpet.h>
-#include <asm/timex.h>
-#include <asm/timer.h>
-#include <asm/vgtod.h>
-
-extern int tsc_unstable;
-extern int tsc_disabled;
-
-/*
- * Make an educated guess if the TSC is trustworthy and synchronized
- * over all CPUs.
- */
-__cpuinit int unsynchronized_tsc(void)
-{
-	if (tsc_unstable)
-		return 1;
-
-#ifdef CONFIG_SMP
-	if (apic_is_clustered_box())
-		return 1;
-#endif
-
-	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
-		return 0;
-
-	/* Assume multi socket systems are not synchronized */
-	return num_present_cpus() > 1;
-}
-
-static struct clocksource clocksource_tsc;
-
-/*
- * We compare the TSC to the cycle_last value in the clocksource
- * structure to avoid a nasty time-warp. This can be observed in a
- * very small window right after one CPU updated cycle_last under
- * xtime/vsyscall_gtod lock and the other CPU reads a TSC value which
- * is smaller than the cycle_last reference value due to a TSC which
- * is slighty behind. This delta is nowhere else observable, but in
- * that case it results in a forward time jump in the range of hours
- * due to the unsigned delta calculation of the time keeping core
- * code, which is necessary to support wrapping clocksources like pm
- * timer.
- */
-static cycle_t read_tsc(void)
-{
-	cycle_t ret = (cycle_t)get_cycles();
-
-	return ret >= clocksource_tsc.cycle_last ?
-		ret : clocksource_tsc.cycle_last;
-}
-
-static cycle_t __vsyscall_fn vread_tsc(void)
-{
-	cycle_t ret = (cycle_t)vget_cycles();
-
-	return ret >= __vsyscall_gtod_data.clock.cycle_last ?
-		ret : __vsyscall_gtod_data.clock.cycle_last;
-}
-
-static struct clocksource clocksource_tsc = {
-	.name			= "tsc",
-	.rating			= 300,
-	.read			= read_tsc,
-	.mask			= CLOCKSOURCE_MASK(64),
-	.shift			= 22,
-	.flags			= CLOCK_SOURCE_IS_CONTINUOUS |
-				  CLOCK_SOURCE_MUST_VERIFY,
-	.vread			= vread_tsc,
-};
-
-void mark_tsc_unstable(char *reason)
-{
-	if (!tsc_unstable) {
-		tsc_unstable = 1;
-		printk("Marking TSC unstable due to %s\n", reason);
-		/* Change only the rating, when not registered */
-		if (clocksource_tsc.mult)
-			clocksource_change_rating(&clocksource_tsc, 0);
-		else
-			clocksource_tsc.rating = 0;
-	}
-}
-EXPORT_SYMBOL_GPL(mark_tsc_unstable);
-
-void __init init_tsc_clocksource(void)
-{
-	if (tsc_disabled > 0)
-		return;
-
-	clocksource_tsc.mult = clocksource_khz2mult(tsc_khz,
-			clocksource_tsc.shift);
-	if (check_tsc_unstable())
-		clocksource_tsc.rating = 0;
-
-	clocksource_register(&clocksource_tsc);
-}
diff --git a/include/asm-x86/apic.h b/include/asm-x86/apic.h
index 9fe941c..99c3cfb 100644
--- a/include/asm-x86/apic.h
+++ b/include/asm-x86/apic.h
@@ -125,12 +125,17 @@ extern void enable_NMI_through_LVT0(void);
  */
 #ifdef CONFIG_X86_64
 extern void early_init_lapic_mapping(void);
+extern int apic_is_clustered_box(void);
+#else
+static inline int apic_is_clustered_box(void)
+{
+	return 0;
+}
 #endif
 
 extern u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask);
 extern u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask);
 
-extern int apic_is_clustered_box(void);
 
 #else /* !CONFIG_X86_LOCAL_APIC */
 static inline void lapic_shutdown(void) { }
diff --git a/include/asm-x86/delay.h b/include/asm-x86/delay.h
index 409a649..bb80880 100644
--- a/include/asm-x86/delay.h
+++ b/include/asm-x86/delay.h
@@ -26,6 +26,10 @@ extern void __delay(unsigned long loops);
 	((n) > 20000 ? __bad_ndelay() : __const_udelay((n) * 5ul)) : \
 	__ndelay(n))
 
+#ifdef CONFIG_X86_32
 void use_tsc_delay(void);
+#else
+#define use_tsc_delay() {}
+#endif
 
 #endif /* _ASM_X86_DELAY_H */
diff --git a/include/asm-x86/time.h b/include/asm-x86/time.h
index bce72d7..a17fa47 100644
--- a/include/asm-x86/time.h
+++ b/include/asm-x86/time.h
@@ -56,4 +56,6 @@ static inline int native_set_wallclock(unsigned long nowtime)
 
 #endif /* CONFIG_PARAVIRT */
 
+extern unsigned long __init calibrate_cpu(void);
+
 #endif
diff --git a/include/asm-x86/tsc.h b/include/asm-x86/tsc.h
index 761054d..cb6f6ee 100644
--- a/include/asm-x86/tsc.h
+++ b/include/asm-x86/tsc.h
@@ -48,7 +48,6 @@ static __always_inline cycles_t vget_cycles(void)
 extern void tsc_init(void);
 extern void mark_tsc_unstable(char *reason);
 extern int unsynchronized_tsc(void);
-extern void init_tsc_clocksource(void);
 int check_tsc_unstable(void);
 
 /*


