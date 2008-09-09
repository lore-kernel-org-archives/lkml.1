Return-Path: <linux-kernel-owner+w=401wt.eu-S1756364AbYIIBVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbYIIBVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 21:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755153AbYIIBUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 21:20:30 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38310 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940AbYIIBU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 21:20:28 -0400
Message-Id: <20080909005116.854758060@polymtl.ca>
References: <20080909003403.836661865@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 08 Sep 2008 20:34:08 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, Joe Perches <joe@perches.com>,
       Wei Weng <wweng@acedsl.com>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC PATCH 5/5] Priority Sifting Reader-Writer Lock Latency Trace
Content-Disposition: inline; filename=psrwlock-latency-trace.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue,  9 Sep 2008 00:55:59 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trace preempt/softirqs off/irqsoff latency in rwlock. Can be used to perform
precise measurement on the impact of these primitives without being lost in the
kernel noise.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
---
 include/linux/psrwlock-latency-trace.h |  104 +++++++++++
 lib/Kconfig.debug                      |    4 
 lib/psrwlock-latency-trace.c           |  288 +++++++++++++++++++++++++++++++++
 3 files changed, 396 insertions(+)

Index: linux-2.6-lttng/lib/Kconfig.debug
===================================================================
--- linux-2.6-lttng.orig/lib/Kconfig.debug	2008-09-06 18:02:21.000000000 -0400
+++ linux-2.6-lttng/lib/Kconfig.debug	2008-09-06 18:06:20.000000000 -0400
@@ -683,6 +683,10 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 config HAVE_PSRWLOCK_ASM_CALL
 	def_bool n
 
+config PSRWLOCK_LATENCY_TEST
+	boolean "Testing API for psrwlock latency test"
+	help
+
 config LATENCYTOP
 	bool "Latency measuring infrastructure"
 	select FRAME_POINTER if !MIPS
Index: linux-2.6-lttng/include/linux/psrwlock-latency-trace.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/linux/psrwlock-latency-trace.h	2008-09-06 18:06:20.000000000 -0400
@@ -0,0 +1,104 @@
+#ifndef _LINUX_PSRWLOCK_LATENCY_TRACE_H
+#define _LINUX_PSRWLOCK_LATENCY_TRACE_H
+
+/*
+ * Priority Sifting Reader-Writer Lock Latency Tracer
+ *
+ * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ * August 2008
+ */
+
+#include <linux/hardirq.h>
+
+#ifdef CONFIG_PSRWLOCK_LATENCY_TEST
+
+extern void psrwlock_profile_latency_reset(void);
+extern void psrwlock_profile_latency_print(void);
+
+extern void psrwlock_profile_irq_disable(void);
+extern void psrwlock_profile_irq_enable(void);
+extern void psrwlock_profile_bh_disable(void);
+extern void psrwlock_profile_bh_enable(void);
+
+#define psrwlock_irq_save(flags)				\
+do {								\
+	local_irq_save(flags);					\
+	if (!irqs_disabled_flags(flags))			\
+		psrwlock_profile_irq_disable();		\
+} while (0)
+
+#define psrwlock_irq_restore(flags)				\
+do {								\
+	if (irqs_disabled() && !irqs_disabled_flags(flags))	\
+		psrwlock_profile_irq_enable();		\
+	local_irq_restore(flags);				\
+} while (0)
+
+static inline void psrwlock_irq_disable(void)
+{
+	unsigned long flags;
+
+	local_save_flags(flags);
+	local_irq_disable();
+	if (!irqs_disabled_flags(flags))
+		psrwlock_profile_irq_disable();
+}
+static inline void psrwlock_irq_enable(void)
+{
+	if (irqs_disabled())
+		psrwlock_profile_irq_enable();
+	local_irq_enable();
+}
+static inline void psrwlock_bh_disable(void)
+{
+	local_bh_disable();
+	if (softirq_count() == SOFTIRQ_OFFSET)
+		psrwlock_profile_bh_disable();
+}
+static inline void psrwlock_bh_enable(void)
+{
+	if (softirq_count() == SOFTIRQ_OFFSET)
+		psrwlock_profile_bh_enable();
+	local_bh_enable();
+}
+static inline void psrwlock_bh_enable_ip(unsigned long ip)
+{
+	if (softirq_count() == SOFTIRQ_OFFSET)
+		psrwlock_profile_bh_enable();
+	local_bh_enable_ip(ip);
+}
+
+#ifdef CONFIG_PREEMPT
+extern void psrwlock_profile_preempt_disable(void);
+extern void psrwlock_profile_preempt_enable(void);
+
+static inline void psrwlock_preempt_disable(void)
+{
+	preempt_disable();
+	if (preempt_count() == PREEMPT_OFFSET)
+		psrwlock_profile_preempt_disable();
+}
+static inline void psrwlock_preempt_enable(void)
+{
+	if (preempt_count() == PREEMPT_OFFSET)
+		psrwlock_profile_preempt_enable();
+	preempt_enable();
+}
+static inline void psrwlock_preempt_enable_no_resched(void)
+{
+	/*
+	 * Not exactly true, since we really re-preempt at the next preempt
+	 * check, but gives a good idea (lower-bound).
+	 */
+	if (preempt_count() == PREEMPT_OFFSET)
+		psrwlock_profile_preempt_enable();
+	preempt_enable_no_resched();
+}
+#else
+#define psrwlock_preempt_disable()		preempt_disable()
+#define psrwlock_preempt_enable()		preempt_enable()
+#define psrwlock_preempt_enable_no_resched()	preempt_enable_no_resched()
+#endif
+
+#endif	/* CONFIG_PSRWLOCK_LATENCY_TEST */
+#endif	/* _LINUX_PSRWLOCK_LATENCY_TRACE_H */
Index: linux-2.6-lttng/lib/psrwlock-latency-trace.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/lib/psrwlock-latency-trace.c	2008-09-06 18:07:26.000000000 -0400
@@ -0,0 +1,288 @@
+/*
+ * Priority Sifting Reader-Writer Lock Latency Tracer
+ *
+ * Copyright 2008 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ */
+
+#include <linux/psrwlock.h>
+#include <linux/module.h>
+#include <linux/stop_machine.h>
+#include <linux/percpu.h>
+#include <linux/init.h>
+#include <linux/kallsyms.h>
+
+/*
+ * Use unsigned long, enough to represent cycle count diff, event on 32-bit
+ * arch.
+ */
+
+struct psrwlock_latency {
+	unsigned long last_disable_cycles, max_latency, min_latency, nr_enable;
+	cycles_t total_latency;
+	unsigned long max_latency_ip_disable,
+		max_latency_ip_enable,
+		last_ip_disable;
+};
+
+static DEFINE_PER_CPU(struct psrwlock_latency, irq_latency_info);
+static DEFINE_PER_CPU(struct psrwlock_latency, softirq_latency_info);
+static DEFINE_PER_CPU(struct psrwlock_latency, preempt_latency_info);
+
+static DEFINE_MUTEX(calibration_mutex);
+static unsigned long cycles_calibration_min,
+		cycles_calibration_avg,
+		cycles_calibration_max;
+
+/*
+ * Since we are taking the timestamps within the critical section,
+ * add the number of cycles it takes to take two consecutive
+ * cycles count reads to the total.
+ * Returns an unsigned long long for %llu print format.
+ */
+static unsigned long long calibrate_cycles(cycles_t cycles)
+{
+	return cycles + cycles_calibration_avg;
+}
+
+static void calibrate_get_cycles(void)
+{
+	int i;
+	cycles_t time1, time2;
+	unsigned long delay;
+
+	printk(KERN_INFO "** get_cycles calibration **\n");
+	cycles_calibration_min = ULLONG_MAX;
+	cycles_calibration_avg = 0;
+	cycles_calibration_max = 0;
+
+	local_irq_disable();
+	for (i = 0; i < 10; i++) {
+		rdtsc_barrier();
+		time1 = get_cycles();
+		rdtsc_barrier();
+		rdtsc_barrier();
+		time2 = get_cycles();
+		rdtsc_barrier();
+		delay = time2 - time1;
+		cycles_calibration_min = min(cycles_calibration_min, delay);
+		cycles_calibration_avg += delay;
+		cycles_calibration_max = max(cycles_calibration_max, delay);
+	}
+	cycles_calibration_avg /= 10;
+	local_irq_enable();
+
+	printk(KERN_INFO "get_cycles takes [min,avg,max] %lu,%lu,%lu "
+		"cycles, results calibrated on avg\n",
+		cycles_calibration_min,
+		cycles_calibration_avg,
+		cycles_calibration_max);
+	printk("\n");
+}
+
+static void reset_latency(struct psrwlock_latency *irql)
+{
+	irql->last_disable_cycles = 0;
+	irql->max_latency = 0;
+	irql->min_latency = ULONG_MAX;
+	irql->total_latency = 0;
+	irql->nr_enable = 0;
+	irql->max_latency_ip_disable = 0;
+	irql->max_latency_ip_enable = 0;
+	irql->last_ip_disable = 0;
+}
+
+/* can't be in irq disabled section in stop_machine */
+static int _psrwlock_profile_latency_reset(void *data)
+{
+	int cpu = smp_processor_id();
+
+	reset_latency(&per_cpu(irq_latency_info, cpu));
+	reset_latency(&per_cpu(softirq_latency_info, cpu));
+	reset_latency(&per_cpu(preempt_latency_info, cpu));
+	return 0;
+}
+
+
+void psrwlock_profile_latency_reset(void)
+{
+	mutex_lock(&calibration_mutex);
+	printk(KERN_INFO "Writer-biased rwlock latency profiling reset\n");
+	calibrate_get_cycles();
+	stop_machine(_psrwlock_profile_latency_reset,
+			NULL, &cpu_possible_map);
+	mutex_unlock(&calibration_mutex);
+}
+EXPORT_SYMBOL_GPL(psrwlock_profile_latency_reset);
+
+enum irq_latency_type {
+	IRQ_LATENCY,
+	SOFTIRQ_LATENCY,
+	PREEMPT_LATENCY,
+};
+
+/*
+ * total_irq_latency and nr_irq_enable reads are racy, but it's just an
+ * average. Off-by-one is not a big deal.
+ */
+static void print_latency(const char *typename, enum irq_latency_type type)
+{
+	struct psrwlock_latency *irql;
+	cycles_t avg;
+	unsigned long nr_enable;
+	int i;
+
+	for_each_online_cpu(i) {
+		if (type == IRQ_LATENCY)
+			irql = &per_cpu(irq_latency_info, i);
+		else if (type == SOFTIRQ_LATENCY)
+			irql = &per_cpu(softirq_latency_info, i);
+		else
+			irql = &per_cpu(preempt_latency_info, i);
+		nr_enable = irql->nr_enable;
+		if (!nr_enable)
+			continue;
+		avg = irql->total_latency / (cycles_t)nr_enable;
+		printk(KERN_INFO "%s latency for cpu %d "
+			"disabled %lu times, "
+			"[min,avg,max] %llu,%llu,%llu cycles\n",
+			typename, i, nr_enable,
+			calibrate_cycles(irql->min_latency),
+			calibrate_cycles(avg),
+			calibrate_cycles(irql->max_latency));
+		printk(KERN_INFO "Max %s latency caused by :\n", typename);
+		printk(KERN_INFO "disable : ");
+		print_ip_sym(irql->max_latency_ip_disable);
+		printk(KERN_INFO "enable : ");
+		print_ip_sym(irql->max_latency_ip_enable);
+	}
+}
+
+void psrwlock_profile_latency_print(void)
+{
+	mutex_lock(&calibration_mutex);
+	printk(KERN_INFO "Writer-biased rwlock latency profiling results\n");
+	printk(KERN_INFO "\n");
+	print_latency("IRQ", IRQ_LATENCY);
+	print_latency("SoftIRQ", SOFTIRQ_LATENCY);
+	print_latency("Preemption", PREEMPT_LATENCY);
+	printk(KERN_INFO "\n");
+	mutex_unlock(&calibration_mutex);
+}
+EXPORT_SYMBOL_GPL(psrwlock_profile_latency_print);
+
+void psrwlock_profile_irq_disable(void)
+{
+	struct psrwlock_latency *irql =
+		&per_cpu(irq_latency_info, smp_processor_id());
+
+	WARN_ON_ONCE(!irqs_disabled());
+	irql->last_ip_disable = _RET_IP_;
+	rdtsc_barrier();
+	irql->last_disable_cycles = get_cycles();
+	rdtsc_barrier();
+}
+EXPORT_SYMBOL_GPL(psrwlock_profile_irq_disable);
+
+void psrwlock_profile_irq_enable(void)
+{
+	struct psrwlock_latency *irql;
+	unsigned long cur_cycles, diff_cycles;
+
+	rdtsc_barrier();
+	cur_cycles = get_cycles();
+	rdtsc_barrier();
+	irql = &per_cpu(irq_latency_info, smp_processor_id());
+	WARN_ON_ONCE(!irqs_disabled());
+	if (!irql->last_disable_cycles)
+		return;
+	diff_cycles = cur_cycles - irql->last_disable_cycles;
+	if (diff_cycles > irql->max_latency) {
+		irql->max_latency = diff_cycles;
+		irql->max_latency_ip_enable = _RET_IP_;
+		irql->max_latency_ip_disable = irql->last_ip_disable;
+	}
+	irql->min_latency = min(irql->min_latency, diff_cycles);
+	irql->total_latency += diff_cycles;
+	irql->nr_enable++;
+}
+EXPORT_SYMBOL_GPL(psrwlock_profile_irq_enable);
+
+void psrwlock_profile_bh_disable(void)
+{
+	struct psrwlock_latency *irql =
+		&per_cpu(softirq_latency_info, smp_processor_id());
+
+	WARN_ON_ONCE(!in_softirq());
+	irql->last_ip_disable = _RET_IP_;
+	rdtsc_barrier();
+	irql->last_disable_cycles = get_cycles();
+	rdtsc_barrier();
+}
+EXPORT_SYMBOL_GPL(psrwlock_profile_bh_disable);
+
+void psrwlock_profile_bh_enable(void)
+{
+	struct psrwlock_latency *irql;
+	unsigned long cur_cycles, diff_cycles;
+
+	rdtsc_barrier();
+	cur_cycles = get_cycles();
+	rdtsc_barrier();
+	irql = &per_cpu(softirq_latency_info, smp_processor_id());
+	WARN_ON_ONCE(!in_softirq());
+	diff_cycles = cur_cycles - irql->last_disable_cycles;
+	if (diff_cycles > irql->max_latency) {
+		irql->max_latency = diff_cycles;
+		irql->max_latency_ip_enable = _RET_IP_;
+		irql->max_latency_ip_disable = irql->last_ip_disable;
+	}
+	irql->min_latency = min(irql->min_latency, diff_cycles);
+	irql->total_latency += diff_cycles;
+	irql->nr_enable++;
+}
+EXPORT_SYMBOL_GPL(psrwlock_profile_bh_enable);
+
+#ifdef CONFIG_PREEMPT
+void psrwlock_profile_preempt_disable(void)
+{
+	struct psrwlock_latency *irql =
+		&per_cpu(preempt_latency_info, smp_processor_id());
+
+	WARN_ON_ONCE(preemptible());
+	irql->last_ip_disable = _RET_IP_;
+	rdtsc_barrier();
+	irql->last_disable_cycles = get_cycles();
+	rdtsc_barrier();
+}
+EXPORT_SYMBOL_GPL(psrwlock_profile_preempt_disable);
+
+void psrwlock_profile_preempt_enable(void)
+{
+	struct psrwlock_latency *irql;
+	unsigned long cur_cycles, diff_cycles;
+
+	rdtsc_barrier();
+	cur_cycles = get_cycles();
+	rdtsc_barrier();
+	irql = &per_cpu(preempt_latency_info, smp_processor_id());
+	WARN_ON_ONCE(preemptible());
+	diff_cycles = cur_cycles - irql->last_disable_cycles;
+	if (diff_cycles > irql->max_latency) {
+		irql->max_latency = diff_cycles;
+		irql->max_latency_ip_enable = _RET_IP_;
+		irql->max_latency_ip_disable = irql->last_ip_disable;
+	}
+	irql->min_latency = min(irql->min_latency, diff_cycles);
+	irql->total_latency += diff_cycles;
+	irql->nr_enable++;
+}
+EXPORT_SYMBOL_GPL(psrwlock_profile_preempt_enable);
+#endif
+
+__init int psrwlock_init(void)
+{
+	printk(KERN_INFO "psrwlock latency profiling init\n");
+	calibrate_get_cycles();
+	return 0;
+}
+device_initcall(psrwlock_init);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
