Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbYGASoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbYGASoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 14:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757329AbYGASnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 14:43:33 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:49465 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757252AbYGASnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 14:43:32 -0400
Subject: [PATCH 03/05] x86: Merge cpu-freq
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>
Cc: Dan Hecht <dhecht@vmware.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 01 Jul 2008 11:43:31 -0700
Message-Id: <1214937811.20191.32.camel@promb-2n-dhcp368.eng.vmware.com>
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

Unify the cpufreq code.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Signed-off-by: Dan Hecht <dhecht@vmware.com>

---

 arch/x86/kernel/tsc.c    |  114 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/tsc_32.c |  113 ----------------------------------------------
 arch/x86/kernel/tsc_64.c |  114 ----------------------------------------------
 3 files changed, 114 insertions(+), 227 deletions(-)


diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index e6ee145..595f78a 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -4,6 +4,7 @@
 #include <linux/module.h>
 #include <linux/timer.h>
 #include <linux/acpi_pmtmr.h>
+#include <linux/cpufreq.h>
 
 #include <asm/hpet.h>
 
@@ -215,3 +216,116 @@ int recalibrate_cpu_khz(void)
 EXPORT_SYMBOL(recalibrate_cpu_khz);
 
 #endif /* CONFIG_X86_32 */
+
+/* Accelerators for sched_clock()
+ * convert from cycles(64bits) => nanoseconds (64bits)
+ *  basic equation:
+ *              ns = cycles / (freq / ns_per_sec)
+ *              ns = cycles * (ns_per_sec / freq)
+ *              ns = cycles * (10^9 / (cpu_khz * 10^3))
+ *              ns = cycles * (10^6 / cpu_khz)
+ *
+ *      Then we use scaling math (suggested by george@mvista.com) to get:
+ *              ns = cycles * (10^6 * SC / cpu_khz) / SC
+ *              ns = cycles * cyc2ns_scale / SC
+ *
+ *      And since SC is a constant power of two, we can convert the div
+ *  into a shift.
+ *
+ *  We can use khz divisor instead of mhz to keep a better precision, since
+ *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
+ *  (mathieu.desnoyers@polymtl.ca)
+ *
+ *                      -johnstul@us.ibm.com "math is hard, lets go shopping!"
+ */
+
+DEFINE_PER_CPU(unsigned long, cyc2ns);
+
+void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
+{
+	unsigned long long tsc_now, ns_now;
+	unsigned long flags, *scale;
+
+	local_irq_save(flags);
+	sched_clock_idle_sleep_event();
+
+	scale = &per_cpu(cyc2ns, cpu);
+
+	rdtscll(tsc_now);
+	ns_now = __cycles_2_ns(tsc_now);
+
+	if (cpu_khz)
+		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
+
+	sched_clock_idle_wakeup_event(0);
+	local_irq_restore(flags);
+}
+
+#ifdef CONFIG_CPU_FREQ
+
+/* Frequency scaling support. Adjust the TSC based timer when the cpu frequency
+ * changes.
+ *
+ * RED-PEN: On SMP we assume all CPUs run with the same frequency.  It's
+ * not that important because current Opteron setups do not support
+ * scaling on SMP anyroads.
+ *
+ * Should fix up last_tsc too. Currently gettimeofday in the
+ * first tick after the change will be slightly wrong.
+ */
+
+static unsigned int  ref_freq;
+static unsigned long loops_per_jiffy_ref;
+static unsigned long tsc_khz_ref;
+
+static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
+				void *data)
+{
+	struct cpufreq_freqs *freq = data;
+	unsigned long *lpj, dummy;
+
+	if (cpu_has(&cpu_data(freq->cpu), X86_FEATURE_CONSTANT_TSC))
+		return 0;
+
+	lpj = &dummy;
+	if (!(freq->flags & CPUFREQ_CONST_LOOPS))
+#ifdef CONFIG_SMP
+		lpj = &cpu_data(freq->cpu).loops_per_jiffy;
+#else
+	lpj = &boot_cpu_data.loops_per_jiffy;
+#endif
+
+	if (!ref_freq) {
+		ref_freq = freq->old;
+		loops_per_jiffy_ref = *lpj;
+		tsc_khz_ref = tsc_khz;
+	}
+	if ((val == CPUFREQ_PRECHANGE  && freq->old < freq->new) ||
+			(val == CPUFREQ_POSTCHANGE && freq->old > freq->new) ||
+			(val == CPUFREQ_RESUMECHANGE)) {
+		*lpj = 	cpufreq_scale(loops_per_jiffy_ref, ref_freq, freq->new);
+
+		tsc_khz = cpufreq_scale(tsc_khz_ref, ref_freq, freq->new);
+		if (!(freq->flags & CPUFREQ_CONST_LOOPS))
+			mark_tsc_unstable("cpufreq changes");
+	}
+
+	set_cyc2ns_scale(tsc_khz_ref, freq->cpu);
+
+	return 0;
+}
+
+static struct notifier_block time_cpufreq_notifier_block = {
+	.notifier_call  = time_cpufreq_notifier
+};
+
+static int __init cpufreq_tsc(void)
+{
+	cpufreq_register_notifier(&time_cpufreq_notifier_block,
+				CPUFREQ_TRANSITION_NOTIFIER);
+	return 0;
+}
+
+core_initcall(cpufreq_tsc);
+
+#endif /* CONFIG_CPU_FREQ */
diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
index 40c0aaf..bbc153d 100644
--- a/arch/x86/kernel/tsc_32.c
+++ b/arch/x86/kernel/tsc_32.c
@@ -18,119 +18,6 @@
 extern int tsc_unstable;
 extern int tsc_disabled;
 
-/* Accelerators for sched_clock()
- * convert from cycles(64bits) => nanoseconds (64bits)
- *  basic equation:
- *		ns = cycles / (freq / ns_per_sec)
- *		ns = cycles * (ns_per_sec / freq)
- *		ns = cycles * (10^9 / (cpu_khz * 10^3))
- *		ns = cycles * (10^6 / cpu_khz)
- *
- *	Then we use scaling math (suggested by george@mvista.com) to get:
- *		ns = cycles * (10^6 * SC / cpu_khz) / SC
- *		ns = cycles * cyc2ns_scale / SC
- *
- *	And since SC is a constant power of two, we can convert the div
- *  into a shift.
- *
- *  We can use khz divisor instead of mhz to keep a better precision, since
- *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
- *  (mathieu.desnoyers@polymtl.ca)
- *
- *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
- */
-
-DEFINE_PER_CPU(unsigned long, cyc2ns);
-
-void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
-{
-	unsigned long long tsc_now, ns_now;
-	unsigned long flags, *scale;
-
-	local_irq_save(flags);
-	sched_clock_idle_sleep_event();
-
-	scale = &per_cpu(cyc2ns, cpu);
-
-	rdtscll(tsc_now);
-	ns_now = __cycles_2_ns(tsc_now);
-
-	if (cpu_khz)
-		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
-
-	/*
-	 * Start smoothly with the new frequency:
-	 */
-	sched_clock_idle_wakeup_event(0);
-	local_irq_restore(flags);
-}
-
-#ifdef CONFIG_CPU_FREQ
-
-/*
- * if the CPU frequency is scaled, TSC-based delays will need a different
- * loops_per_jiffy value to function properly.
- */
-static unsigned int ref_freq;
-static unsigned long loops_per_jiffy_ref;
-static unsigned long cpu_khz_ref;
-
-static int
-time_cpufreq_notifier(struct notifier_block *nb, unsigned long val, void *data)
-{
-	struct cpufreq_freqs *freq = data;
-
-	if (!ref_freq) {
-		if (!freq->old){
-			ref_freq = freq->new;
-			return 0;
-		}
-		ref_freq = freq->old;
-		loops_per_jiffy_ref = cpu_data(freq->cpu).loops_per_jiffy;
-		cpu_khz_ref = cpu_khz;
-	}
-
-	if ((val == CPUFREQ_PRECHANGE  && freq->old < freq->new) ||
-	    (val == CPUFREQ_POSTCHANGE && freq->old > freq->new) ||
-	    (val == CPUFREQ_RESUMECHANGE)) {
-		if (!(freq->flags & CPUFREQ_CONST_LOOPS))
-			cpu_data(freq->cpu).loops_per_jiffy =
-				cpufreq_scale(loops_per_jiffy_ref,
-						ref_freq, freq->new);
-
-		if (cpu_khz) {
-
-			if (num_online_cpus() == 1)
-				cpu_khz = cpufreq_scale(cpu_khz_ref,
-						ref_freq, freq->new);
-			if (!(freq->flags & CPUFREQ_CONST_LOOPS)) {
-				tsc_khz = cpu_khz;
-				set_cyc2ns_scale(cpu_khz, freq->cpu);
-				/*
-				 * TSC based sched_clock turns
-				 * to junk w/ cpufreq
-				 */
-				mark_tsc_unstable("cpufreq changes");
-			}
-		}
-	}
-
-	return 0;
-}
-
-static struct notifier_block time_cpufreq_notifier_block = {
-	.notifier_call	= time_cpufreq_notifier
-};
-
-static int __init cpufreq_tsc(void)
-{
-	return cpufreq_register_notifier(&time_cpufreq_notifier_block,
-					 CPUFREQ_TRANSITION_NOTIFIER);
-}
-core_initcall(cpufreq_tsc);
-
-#endif
-
 /* clock source code */
 
 static struct clocksource clocksource_tsc;
diff --git a/arch/x86/kernel/tsc_64.c b/arch/x86/kernel/tsc_64.c
index c852ff9..80a274b 100644
--- a/arch/x86/kernel/tsc_64.c
+++ b/arch/x86/kernel/tsc_64.c
@@ -16,120 +16,6 @@
 extern int tsc_unstable;
 extern int tsc_disabled;
 
-/* Accelerators for sched_clock()
- * convert from cycles(64bits) => nanoseconds (64bits)
- *  basic equation:
- *		ns = cycles / (freq / ns_per_sec)
- *		ns = cycles * (ns_per_sec / freq)
- *		ns = cycles * (10^9 / (cpu_khz * 10^3))
- *		ns = cycles * (10^6 / cpu_khz)
- *
- *	Then we use scaling math (suggested by george@mvista.com) to get:
- *		ns = cycles * (10^6 * SC / cpu_khz) / SC
- *		ns = cycles * cyc2ns_scale / SC
- *
- *	And since SC is a constant power of two, we can convert the div
- *  into a shift.
- *
- *  We can use khz divisor instead of mhz to keep a better precision, since
- *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
- *  (mathieu.desnoyers@polymtl.ca)
- *
- *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
- */
-
-DEFINE_PER_CPU(unsigned long, cyc2ns);
-
-void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
-{
-	unsigned long long tsc_now, ns_now;
-	unsigned long flags, *scale;
-
-	local_irq_save(flags);
-	sched_clock_idle_sleep_event();
-
-	scale = &per_cpu(cyc2ns, cpu);
-
-	rdtscll(tsc_now);
-	ns_now = __cycles_2_ns(tsc_now);
-
-	if (cpu_khz)
-		*scale = (NSEC_PER_MSEC << CYC2NS_SCALE_FACTOR)/cpu_khz;
-
-	sched_clock_idle_wakeup_event(0);
-	local_irq_restore(flags);
-}
-
-#ifdef CONFIG_CPU_FREQ
-
-/* Frequency scaling support. Adjust the TSC based timer when the cpu frequency
- * changes.
- *
- * RED-PEN: On SMP we assume all CPUs run with the same frequency.  It's
- * not that important because current Opteron setups do not support
- * scaling on SMP anyroads.
- *
- * Should fix up last_tsc too. Currently gettimeofday in the
- * first tick after the change will be slightly wrong.
- */
-
-static unsigned int  ref_freq;
-static unsigned long loops_per_jiffy_ref;
-static unsigned long tsc_khz_ref;
-
-static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
-				 void *data)
-{
-	struct cpufreq_freqs *freq = data;
-	unsigned long *lpj, dummy;
-
-	if (cpu_has(&cpu_data(freq->cpu), X86_FEATURE_CONSTANT_TSC))
-		return 0;
-
-	lpj = &dummy;
-	if (!(freq->flags & CPUFREQ_CONST_LOOPS))
-#ifdef CONFIG_SMP
-		lpj = &cpu_data(freq->cpu).loops_per_jiffy;
-#else
-		lpj = &boot_cpu_data.loops_per_jiffy;
-#endif
-
-	if (!ref_freq) {
-		ref_freq = freq->old;
-		loops_per_jiffy_ref = *lpj;
-		tsc_khz_ref = tsc_khz;
-	}
-	if ((val == CPUFREQ_PRECHANGE  && freq->old < freq->new) ||
-		(val == CPUFREQ_POSTCHANGE && freq->old > freq->new) ||
-		(val == CPUFREQ_RESUMECHANGE)) {
-		*lpj =
-		cpufreq_scale(loops_per_jiffy_ref, ref_freq, freq->new);
-
-		tsc_khz = cpufreq_scale(tsc_khz_ref, ref_freq, freq->new);
-		if (!(freq->flags & CPUFREQ_CONST_LOOPS))
-			mark_tsc_unstable("cpufreq changes");
-	}
-
-	set_cyc2ns_scale(tsc_khz_ref, freq->cpu);
-
-	return 0;
-}
-
-static struct notifier_block time_cpufreq_notifier_block = {
-	.notifier_call  = time_cpufreq_notifier
-};
-
-static int __init cpufreq_tsc(void)
-{
-	cpufreq_register_notifier(&time_cpufreq_notifier_block,
-				  CPUFREQ_TRANSITION_NOTIFIER);
-	return 0;
-}
-
-core_initcall(cpufreq_tsc);
-
-#endif
-
 /*
  * Make an educated guess if the TSC is trustworthy and synchronized
  * over all CPUs.


