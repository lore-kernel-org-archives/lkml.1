Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbZGUOhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbZGUOhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 10:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbZGUOhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 10:37:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:26300 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbZGUOhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 10:37:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,240,1246863600"; 
   d="scan'208";a="432035824"
Date: Tue, 21 Jul 2009 15:56:48 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: [patch] x86, perf_counter, bts: add bts to perf_counter
Message-ID: <20090721155648.A17047@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement a performance counter with:
    attr.type           = PERF_TYPE_HARDWARE
    attr.config         = PERF_COUNT_HW_BRANCH_INSTRUCTIONS
    attr.sample_period  = 1

using branch trace store (BTS) on x86 hardware, if available.

The from and to address for each branch can be sampled using:
    PERF_SAMPLE_IP      for the from address
    PERF_SAMPLE_ADDR    for the to address


CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/include/asm/perf_counter.h |   10 	10 +	0 -	0 !
 arch/x86/kernel/cpu/perf_counter.c  |  311 	305 +	6 -	0 !
 include/linux/perf_counter.h        |    2 	2 +	0 -	0 !
 kernel/perf_counter.c               |   10 	9 +	1 -	0 !
 4 files changed, 326 insertions(+), 7 deletions(-)

Index: b/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -6,6 +6,7 @@
  *  Copyright (C) 2009 Jaswinder Singh Rajput
  *  Copyright (C) 2009 Advanced Micro Devices, Inc., Robert Richter
  *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright (C) 2009 Intel Corporation, <markus.t.metzger@intel.com>
  *
  *  For licencing details see kernel-base/COPYING
  */
@@ -20,6 +21,7 @@
 #include <linux/sched.h>
 #include <linux/uaccess.h>
 #include <linux/highmem.h>
+#include <linux/cpu.h>
 
 #include <asm/apic.h>
 #include <asm/stacktrace.h>
@@ -27,12 +29,42 @@
 
 static u64 perf_counter_mask __read_mostly;
 
+/* The maximal number of PEBS counters: */
+#define MAX_PEBS_COUNTERS	4
+
+/* The size of a BTS record in bytes: */
+#define BTS_RECORD_SIZE		24
+
+/* The size of a per-cpu BTS buffer in bytes: */
+#define BTS_BUFFER_SIZE		(BTS_RECORD_SIZE * 1024)
+
+/* The BTS overflow threshold in bytes from the end of the buffer: */
+#define BTS_OVFL_TH		(BTS_RECORD_SIZE * 16)
+
+/*
+ * A debug store configuration.
+ *
+ * We only support architectures that use 64bit fields.
+ */
+struct debug_store {
+	u64	bts_buffer_base;
+	u64	bts_index;
+	u64	bts_absolute_maximum;
+	u64	bts_interrupt_threshold;
+	u64	pebs_buffer_base;
+	u64	pebs_index;
+	u64	pebs_absolute_maximum;
+	u64	pebs_interrupt_threshold;
+	u64	pebs_counter_reset[MAX_PEBS_COUNTERS];
+};
+
 struct cpu_hw_counters {
 	struct perf_counter	*counters[X86_PMC_IDX_MAX];
 	unsigned long		used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	unsigned long		active_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	unsigned long		interrupts;
 	int			enabled;
+	struct debug_store	*ds;
 };
 
 /*
@@ -57,6 +89,8 @@ struct x86_pmu {
 	u64		counter_mask;
 	u64		max_period;
 	u64		intel_ctrl;
+	void		(*enable_bts)(u64 config);
+	void		(*disable_bts)(void);
 };
 
 static struct x86_pmu x86_pmu __read_mostly;
@@ -576,6 +610,9 @@ x86_perf_counter_update(struct perf_coun
 	u64 prev_raw_count, new_raw_count;
 	s64 delta;
 
+	if (idx == X86_PMC_IDX_FIXED_BTS)
+		return 0;
+
 	/*
 	 * Careful: an NMI might modify the previous counter value.
 	 *
@@ -659,10 +696,108 @@ static void release_pmc_hardware(void)
 		enable_lapic_nmi_watchdog();
 }
 
+static inline bool bts_available(void)
+{
+	return x86_pmu.enable_bts != NULL;
+}
+
+static inline void init_debug_store_on_cpu(int cpu)
+{
+	struct debug_store *ds = per_cpu(cpu_hw_counters, cpu).ds;
+
+	if (!ds)
+		return;
+
+	wrmsr_on_cpu(cpu, MSR_IA32_DS_AREA,
+		     (u32)((u64)(long)ds), (u32)((u64)(long)ds >> 32));
+}
+
+static inline void fini_debug_store_on_cpu(int cpu)
+{
+	if (!per_cpu(cpu_hw_counters, cpu).ds)
+		return;
+
+	wrmsr_on_cpu(cpu, MSR_IA32_DS_AREA, 0, 0);
+}
+
+static void release_bts_hardware(void)
+{
+	int cpu;
+
+	if (!bts_available())
+		return;
+
+	get_online_cpus();
+
+	for_each_online_cpu(cpu)
+		fini_debug_store_on_cpu(cpu);
+
+	for_each_possible_cpu(cpu) {
+		struct debug_store *ds = per_cpu(cpu_hw_counters, cpu).ds;
+
+		if (!ds)
+			continue;
+
+		per_cpu(cpu_hw_counters, cpu).ds = NULL;
+
+		kfree((void *)(long)ds->bts_buffer_base);
+		kfree(ds);
+	}
+
+	put_online_cpus();
+}
+
+static int reserve_bts_hardware(void)
+{
+	int cpu, err = 0;
+
+	if (!bts_available())
+		return -EOPNOTSUPP;
+
+	get_online_cpus();
+
+	for_each_possible_cpu(cpu) {
+		struct debug_store *ds;
+		void *buffer;
+
+		err = -ENOMEM;
+		buffer = kzalloc(BTS_BUFFER_SIZE, GFP_KERNEL);
+		if (unlikely(!buffer))
+			break;
+
+		ds = kzalloc(sizeof(*ds), GFP_KERNEL);
+		if (unlikely(!ds)) {
+			kfree(buffer);
+			break;
+		}
+
+		ds->bts_buffer_base = (u64)(long)buffer;
+		ds->bts_index = ds->bts_buffer_base;
+		ds->bts_absolute_maximum =
+			ds->bts_buffer_base + BTS_BUFFER_SIZE;
+		ds->bts_interrupt_threshold =
+			ds->bts_absolute_maximum - BTS_OVFL_TH;
+
+		per_cpu(cpu_hw_counters, cpu).ds = ds;
+		err = 0;
+	}
+
+	if (err)
+		release_bts_hardware();
+	else
+		for_each_online_cpu(cpu)
+			init_debug_store_on_cpu(cpu);
+
+	put_online_cpus();
+
+	return err;
+}
+
 static void hw_perf_counter_destroy(struct perf_counter *counter)
 {
 	if (atomic_dec_and_mutex_lock(&active_counters, &pmc_reserve_mutex)) {
 		release_pmc_hardware();
+		release_bts_hardware();
 		mutex_unlock(&pmc_reserve_mutex);
 	}
 }
@@ -705,6 +840,42 @@ set_ext_hw_attr(struct hw_perf_counter *
 	return 0;
 }
 
+static void intel_pmu_enable_bts(u64 config)
+{
+	unsigned long debugctlmsr;
+
+	debugctlmsr = get_debugctlmsr();
+
+	debugctlmsr |= (1 << 6);
+	debugctlmsr |= (1 << 7);
+
+	if (!(config & ARCH_PERFMON_EVENTSEL_OS))
+		debugctlmsr |= (1 << 9);
+
+	if (!(config & ARCH_PERFMON_EVENTSEL_USR))
+		debugctlmsr |= (1 << 10);
+
+	update_debugctlmsr(debugctlmsr);
+}
+
+static void intel_pmu_disable_bts(void)
+{
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+	unsigned long debugctlmsr;
+
+	if (!cpuc->ds)
+		return;
+
+	debugctlmsr = get_debugctlmsr();
+
+	debugctlmsr &= ~(1 << 6);
+	debugctlmsr &= ~(1 << 7);
+	debugctlmsr &= ~(1 << 9);
+	debugctlmsr &= ~(1 << 10);
+
+	update_debugctlmsr(debugctlmsr);
+}
+
 /*
  * Setup the hardware configuration for a given attr_type
  */
@@ -721,9 +892,13 @@ static int __hw_perf_counter_init(struct
 	err = 0;
 	if (!atomic_inc_not_zero(&active_counters)) {
 		mutex_lock(&pmc_reserve_mutex);
-		if (atomic_read(&active_counters) == 0 && !reserve_pmc_hardware())
-			err = -EBUSY;
-		else
+		if (atomic_read(&active_counters) == 0) {
+			if (!reserve_pmc_hardware())
+				err = -EBUSY;
+			else
+				reserve_bts_hardware();
+		}
+		if (!err)
 			atomic_inc(&active_counters);
 		mutex_unlock(&pmc_reserve_mutex);
 	}
@@ -801,7 +976,18 @@ static void p6_pmu_disable_all(void)
 
 static void intel_pmu_disable_all(void)
 {
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+
+	if (!cpuc->enabled)
+		return;
+
+	cpuc->enabled = 0;
+	barrier();
+
 	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+
+	if (test_bit(X86_PMC_IDX_FIXED_BTS, cpuc->active_mask))
+		intel_pmu_disable_bts();
 }
 
 static void amd_pmu_disable_all(void)
@@ -859,7 +1045,25 @@ static void p6_pmu_enable_all(void)
 
 static void intel_pmu_enable_all(void)
 {
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+
+	if (cpuc->enabled)
+		return;
+
+	cpuc->enabled = 1;
+	barrier();
+
 	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, x86_pmu.intel_ctrl);
+
+	if (test_bit(X86_PMC_IDX_FIXED_BTS, cpuc->active_mask)) {
+		struct perf_counter *counter =
+			cpuc->counters[X86_PMC_IDX_FIXED_BTS];
+
+		if (WARN_ON_ONCE(!counter))
+			return;
+
+		intel_pmu_enable_bts(counter->hw.config);
+	}
 }
 
 static void amd_pmu_enable_all(void)
@@ -946,6 +1150,11 @@ p6_pmu_disable_counter(struct hw_perf_co
 static inline void
 intel_pmu_disable_counter(struct hw_perf_counter *hwc, int idx)
 {
+	if (unlikely(idx == X86_PMC_IDX_FIXED_BTS)) {
+		intel_pmu_disable_bts();
+		return;
+	}
+
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
 		intel_pmu_disable_fixed(hwc, idx);
 		return;
@@ -974,6 +1183,9 @@ x86_perf_counter_set_period(struct perf_
 	s64 period = hwc->sample_period;
 	int err, ret = 0;
 
+	if (idx == X86_PMC_IDX_FIXED_BTS)
+		return 0;
+
 	/*
 	 * If we are way outside a reasoable range then just skip forward:
 	 */
@@ -1056,6 +1268,14 @@ static void p6_pmu_enable_counter(struct
 
 static void intel_pmu_enable_counter(struct hw_perf_counter *hwc, int idx)
 {
+	if (unlikely(idx == X86_PMC_IDX_FIXED_BTS)) {
+		if (!__get_cpu_var(cpu_hw_counters).enabled)
+			return;
+
+		intel_pmu_enable_bts(hwc->config);
+		return;
+	}
+
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
 		intel_pmu_enable_fixed(hwc, idx);
 		return;
@@ -1077,11 +1297,16 @@ fixed_mode_idx(struct perf_counter *coun
 {
 	unsigned int event;
 
+	event = hwc->config & ARCH_PERFMON_EVENT_MASK;
+
+	if (unlikely((event ==
+		      x86_pmu.event_map(PERF_COUNT_HW_BRANCH_INSTRUCTIONS)) &&
+		     (hwc->sample_period == 1)))
+		return X86_PMC_IDX_FIXED_BTS;
+
 	if (!x86_pmu.num_counters_fixed)
 		return -1;
 
-	event = hwc->config & ARCH_PERFMON_EVENT_MASK;
-
 	if (unlikely(event == x86_pmu.event_map(PERF_COUNT_HW_INSTRUCTIONS)))
 		return X86_PMC_IDX_FIXED_INSTRUCTIONS;
 	if (unlikely(event == x86_pmu.event_map(PERF_COUNT_HW_CPU_CYCLES)))
@@ -1102,7 +1327,25 @@ static int x86_pmu_enable(struct perf_co
 	int idx;
 
 	idx = fixed_mode_idx(counter, hwc);
-	if (idx >= 0) {
+	if (idx == X86_PMC_IDX_FIXED_BTS) {
+		/*
+		 * Try to use BTS for branch tracing. If that is not
+		 * available, try to get a generic counter.
+		 */
+		if (unlikely(!cpuc->ds))
+			goto try_generic;
+
+		/*
+		 * Try to get the fixed counter, if that is already taken
+		 * then try to get a generic counter:
+		 */
+		if (test_and_set_bit(idx, cpuc->used_mask))
+			goto try_generic;
+
+		hwc->config_base	= 0;
+		hwc->counter_base	= 0;
+		hwc->idx		= idx;
+	} else if (idx >= 0) {
 		/*
 		 * Try to get the fixed counter, if that is already taken
 		 * then try to get a generic counter:
@@ -1213,6 +1456,42 @@ void perf_counter_print_debug(void)
 	local_irq_restore(flags);
 }
 
+static void intel_pmu_drain_bts_buffer(struct cpu_hw_counters *cpuc,
+				       struct perf_sample_data *data)
+{
+	struct debug_store *ds = cpuc->ds;
+	struct bts_record {
+		u64	from;
+		u64	to;
+		u64	flags;
+	};
+	struct perf_counter *counter = cpuc->counters[X86_PMC_IDX_FIXED_BTS];
+	unsigned long orig_ip = data->regs->ip;
+	u64 at;
+
+	if (!counter)
+		return;
+
+	if (!ds)
+		return;
+
+	for (at = ds->bts_buffer_base;
+	     at < ds->bts_index;
+	     at += sizeof(struct bts_record)) {
+		struct bts_record *rec = (struct bts_record *)(long)at;
+
+		data->regs->ip	= rec->from;
+		data->addr	= rec->to;
+
+		perf_counter_output(counter, 1, data);
+	}
+
+	ds->bts_index = ds->bts_buffer_base;
+
+	data->regs->ip	= orig_ip;
+	data->addr	= 0;
+}
+
 static void x86_pmu_disable(struct perf_counter *counter)
 {
 	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
@@ -1237,6 +1516,15 @@ static void x86_pmu_disable(struct perf_
 	 * that we are disabling:
 	 */
 	x86_perf_counter_update(counter, hwc, idx);
+
+	/* Drain the remaining BTS records. */
+	if (unlikely(idx == X86_PMC_IDX_FIXED_BTS)) {
+		struct perf_sample_data data;
+		struct pt_regs regs;
+
+		data.regs = &regs;
+		intel_pmu_drain_bts_buffer(cpuc, &data);
+	}
 	cpuc->counters[idx] = NULL;
 	clear_bit(idx, cpuc->used_mask);
 
@@ -1264,6 +1552,7 @@ static int intel_pmu_save_and_restart(st
 
 static void intel_pmu_reset(void)
 {
+	struct debug_store *ds = __get_cpu_var(cpu_hw_counters).ds;
 	unsigned long flags;
 	int idx;
 
@@ -1281,6 +1570,8 @@ static void intel_pmu_reset(void)
 	for (idx = 0; idx < x86_pmu.num_counters_fixed; idx++) {
 		checking_wrmsrl(MSR_ARCH_PERFMON_FIXED_CTR0 + idx, 0ull);
 	}
+	if (ds)
+		ds->bts_index = ds->bts_buffer_base;
 
 	local_irq_restore(flags);
 }
@@ -1346,6 +1637,7 @@ static int intel_pmu_handle_irq(struct p
 	cpuc = &__get_cpu_var(cpu_hw_counters);
 
 	perf_disable();
+	intel_pmu_drain_bts_buffer(cpuc, &data);
 	status = intel_pmu_get_status();
 	if (!status) {
 		perf_enable();
@@ -1547,6 +1839,8 @@ static struct x86_pmu intel_pmu = {
 	 * the generic counter period:
 	 */
 	.max_period		= (1ULL << 31) - 1,
+	.enable_bts		= intel_pmu_enable_bts,
+	.disable_bts		= intel_pmu_disable_bts,
 };
 
 static struct x86_pmu amd_pmu = {
@@ -1938,3 +2232,8 @@ struct perf_callchain_entry *perf_callch
 
 	return entry;
 }
+
+void hw_perf_counter_setup_online(int cpu)
+{
+	init_debug_store_on_cpu(cpu);
+}
Index: b/include/linux/perf_counter.h
===================================================================
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -681,6 +681,8 @@ struct perf_sample_data {
 
 extern int perf_counter_overflow(struct perf_counter *counter, int nmi,
 				 struct perf_sample_data *data);
+extern void perf_counter_output(struct perf_counter *counter, int nmi,
+				struct perf_sample_data *data);
 
 /*
  * Return 1 for a software counter, 0 for a hardware counter
Index: b/kernel/perf_counter.c
===================================================================
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -87,6 +87,7 @@ void __weak hw_perf_disable(void)		{ bar
 void __weak hw_perf_enable(void)		{ barrier(); }
 
 void __weak hw_perf_counter_setup(int cpu)	{ barrier(); }
+void __weak hw_perf_counter_setup_online(int cpu)	{ barrier(); }
 
 int __weak
 hw_perf_group_sched_in(struct perf_counter *group_leader,
@@ -2606,7 +2607,7 @@ static u32 perf_counter_tid(struct perf_
 	return task_pid_nr_ns(p, counter->ns);
 }
 
-static void perf_counter_output(struct perf_counter *counter, int nmi,
+void perf_counter_output(struct perf_counter *counter, int nmi,
 				struct perf_sample_data *data)
 {
 	int ret;
@@ -4491,6 +4492,11 @@ perf_cpu_notify(struct notifier_block *s
 		perf_counter_init_cpu(cpu);
 		break;
 
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		hw_perf_counter_setup_online(cpu);
+		break;
+
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
 		perf_counter_exit_cpu(cpu);
@@ -4515,6 +4521,8 @@ void __init perf_counter_init(void)
 {
 	perf_cpu_notify(&perf_cpu_nb, (unsigned long)CPU_UP_PREPARE,
 			(void *)(long)smp_processor_id());
+	perf_cpu_notify(&perf_cpu_nb, (unsigned long)CPU_ONLINE,
+			(void *)(long)smp_processor_id());
 	register_cpu_notifier(&perf_cpu_nb);
 }
 
Index: b/arch/x86/include/asm/perf_counter.h
===================================================================
--- a/arch/x86/include/asm/perf_counter.h
+++ b/arch/x86/include/asm/perf_counter.h
@@ -84,6 +84,16 @@ union cpuid10_edx {
 #define MSR_ARCH_PERFMON_FIXED_CTR2			0x30b
 #define X86_PMC_IDX_FIXED_BUS_CYCLES			(X86_PMC_IDX_FIXED + 2)
 
+/*
+ * We model BTS tracing as another fixed-mode PMC.
+ *
+ * We choose a value in the middle of the fixed counter range, since lower
+ * values are used by actual fixed counters and higher values are used
+ * to indicate other overflow conditions in the PERF_GLOBAL_STATUS msr.
+ */
+#define X86_PMC_IDX_FIXED_BTS				(X86_PMC_IDX_FIXED + 16)
+
+
 #ifdef CONFIG_PERF_COUNTERS
 extern void init_hw_perf_counters(void);
 extern void perf_counters_lapic_init(void);
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

