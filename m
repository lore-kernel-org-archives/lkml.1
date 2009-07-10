Return-Path: <linux-kernel-owner+w=401wt.eu-S1754278AbZGJKlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbZGJKlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbZGJKk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:40:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:37720 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652AbZGJKk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:40:57 -0400
Date: Fri, 10 Jul 2009 10:40:11 GMT
From: tip-bot for Vince Weaver <vince@deater.net>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vince@deater.net, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, vince@deater.net,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <Pine.LNX.4.64.0907081718450.2715@pianoman.cluster.toy>
References: <Pine.LNX.4.64.0907081718450.2715@pianoman.cluster.toy>
Subject: [tip:perfcounters/core] perf_counter: Add P6 PMU support
Message-ID: <tip-11d1578f9454159c43499d1d8fe8a7d728c176a3@git.kernel.org>
Git-Commit-ID: 11d1578f9454159c43499d1d8fe8a7d728c176a3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Jul 2009 10:40:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11d1578f9454159c43499d1d8fe8a7d728c176a3
Gitweb:     http://git.kernel.org/tip/11d1578f9454159c43499d1d8fe8a7d728c176a3
Author:     Vince Weaver <vince@deater.net>
AuthorDate: Wed, 8 Jul 2009 17:46:14 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 10:28:26 +0200

perf_counter: Add P6 PMU support

Add basic P6 PMU support. The P6 uses the EVNTSEL0 EN bit to
enable/disable both its counters. We use this for the
global enable/disable, and clear all config bits (except EN)
to disable individual counters.

Actual ia32 hardware doesn't support lfence, so use a locked
op without side-effect to implement a full barrier.

perf stat and perf record seem to function correctly.

[a.p.zijlstra@chello.nl: cleanups and complete the enable/disable code]

Signed-off-by: Vince Weaver <vince@deater.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <Pine.LNX.4.64.0907081718450.2715@pianoman.cluster.toy>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |  227 +++++++++++++++++++++++++++++++++---
 tools/perf/perf.h                  |    8 +-
 2 files changed, 220 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 36c3dc7..1910f39 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -66,6 +66,44 @@ static DEFINE_PER_CPU(struct cpu_hw_counters, cpu_hw_counters) = {
 };
 
 /*
+ * Not sure about some of these
+ */
+static const u64 p6_perfmon_event_map[] =
+{
+  [PERF_COUNT_HW_CPU_CYCLES]		= 0x0079,
+  [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
+  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0000,
+  [PERF_COUNT_HW_CACHE_MISSES]		= 0x0000,
+  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
+  [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
+  [PERF_COUNT_HW_BUS_CYCLES]		= 0x0062,
+};
+
+static u64 p6_pmu_event_map(int event)
+{
+	return p6_perfmon_event_map[event];
+}
+
+static u64 p6_pmu_raw_event(u64 event)
+{
+#define P6_EVNTSEL_EVENT_MASK		0x000000FFULL
+#define P6_EVNTSEL_UNIT_MASK		0x0000FF00ULL
+#define P6_EVNTSEL_EDGE_MASK		0x00040000ULL
+#define P6_EVNTSEL_INV_MASK		0x00800000ULL
+#define P6_EVNTSEL_COUNTER_MASK		0xFF000000ULL
+
+#define P6_EVNTSEL_MASK			\
+	(P6_EVNTSEL_EVENT_MASK |	\
+	 P6_EVNTSEL_UNIT_MASK  |	\
+	 P6_EVNTSEL_EDGE_MASK  |	\
+	 P6_EVNTSEL_INV_MASK   |	\
+	 P6_EVNTSEL_COUNTER_MASK)
+
+	return event & P6_EVNTSEL_MASK;
+}
+
+
+/*
  * Intel PerfMon v3. Used on Core2 and later.
  */
 static const u64 intel_perfmon_event_map[] =
@@ -726,6 +764,23 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	return 0;
 }
 
+static void p6_pmu_disable_all(void)
+{
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+	unsigned long val;
+
+	if (!cpuc->enabled)
+		return;
+
+	cpuc->enabled = 0;
+	barrier();
+
+	/* p6 only has one enable register */
+	rdmsrl(MSR_P6_EVNTSEL0, val);
+	val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
+	wrmsrl(MSR_P6_EVNTSEL0, val);
+}
+
 static void intel_pmu_disable_all(void)
 {
 	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
@@ -767,6 +822,23 @@ void hw_perf_disable(void)
 	return x86_pmu.disable_all();
 }
 
+static void p6_pmu_enable_all(void)
+{
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+	unsigned long val;
+
+	if (cpuc->enabled)
+		return;
+
+	cpuc->enabled = 1;
+	barrier();
+
+	/* p6 only has one enable register */
+	rdmsrl(MSR_P6_EVNTSEL0, val);
+	val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+	wrmsrl(MSR_P6_EVNTSEL0, val);
+}
+
 static void intel_pmu_enable_all(void)
 {
 	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, x86_pmu.intel_ctrl);
@@ -819,16 +891,13 @@ static inline void intel_pmu_ack_status(u64 ack)
 
 static inline void x86_pmu_enable_counter(struct hw_perf_counter *hwc, int idx)
 {
-	int err;
-	err = checking_wrmsrl(hwc->config_base + idx,
+	(void)checking_wrmsrl(hwc->config_base + idx,
 			      hwc->config | ARCH_PERFMON_EVENTSEL0_ENABLE);
 }
 
 static inline void x86_pmu_disable_counter(struct hw_perf_counter *hwc, int idx)
 {
-	int err;
-	err = checking_wrmsrl(hwc->config_base + idx,
-			      hwc->config);
+	(void)checking_wrmsrl(hwc->config_base + idx, hwc->config);
 }
 
 static inline void
@@ -836,13 +905,24 @@ intel_pmu_disable_fixed(struct hw_perf_counter *hwc, int __idx)
 {
 	int idx = __idx - X86_PMC_IDX_FIXED;
 	u64 ctrl_val, mask;
-	int err;
 
 	mask = 0xfULL << (idx * 4);
 
 	rdmsrl(hwc->config_base, ctrl_val);
 	ctrl_val &= ~mask;
-	err = checking_wrmsrl(hwc->config_base, ctrl_val);
+	(void)checking_wrmsrl(hwc->config_base, ctrl_val);
+}
+
+static inline void
+p6_pmu_disable_counter(struct hw_perf_counter *hwc, int idx)
+{
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+	unsigned long val = ARCH_PERFMON_EVENTSEL0_ENABLE;
+
+	if (!cpuc->enabled)
+		val = 0;
+
+	(void)checking_wrmsrl(hwc->config_base + idx, val);
 }
 
 static inline void
@@ -943,6 +1023,17 @@ intel_pmu_enable_fixed(struct hw_perf_counter *hwc, int __idx)
 	err = checking_wrmsrl(hwc->config_base, ctrl_val);
 }
 
+static void p6_pmu_enable_counter(struct hw_perf_counter *hwc, int idx)
+{
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+
+	if (cpuc->enabled)
+		x86_pmu_enable_counter(hwc, idx);
+	else
+		x86_pmu_disable_counter(hwc, idx);
+}
+
+
 static void intel_pmu_enable_counter(struct hw_perf_counter *hwc, int idx)
 {
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
@@ -1176,6 +1267,49 @@ static void intel_pmu_reset(void)
 	local_irq_restore(flags);
 }
 
+static int p6_pmu_handle_irq(struct pt_regs *regs)
+{
+	struct perf_sample_data data;
+	struct cpu_hw_counters *cpuc;
+	struct perf_counter *counter;
+	struct hw_perf_counter *hwc;
+	int idx, handled = 0;
+	u64 val;
+
+	data.regs = regs;
+	data.addr = 0;
+
+	cpuc = &__get_cpu_var(cpu_hw_counters);
+
+	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
+		if (!test_bit(idx, cpuc->active_mask))
+			continue;
+
+		counter = cpuc->counters[idx];
+		hwc = &counter->hw;
+
+		val = x86_perf_counter_update(counter, hwc, idx);
+		if (val & (1ULL << (x86_pmu.counter_bits - 1)))
+			continue;
+
+		/*
+		 * counter overflow
+		 */
+		handled		= 1;
+		data.period	= counter->hw.last_period;
+
+		if (!x86_perf_counter_set_period(counter, hwc, idx))
+			continue;
+
+		if (perf_counter_overflow(counter, 1, &data))
+			p6_pmu_disable_counter(hwc, idx);
+	}
+
+	if (handled)
+		inc_irq_stat(apic_perf_irqs);
+
+	return handled;
+}
 
 /*
  * This handler is triggered by the local APIC, so the APIC IRQ handling
@@ -1185,14 +1319,13 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 {
 	struct perf_sample_data data;
 	struct cpu_hw_counters *cpuc;
-	int bit, cpu, loops;
+	int bit, loops;
 	u64 ack, status;
 
 	data.regs = regs;
 	data.addr = 0;
 
-	cpu = smp_processor_id();
-	cpuc = &per_cpu(cpu_hw_counters, cpu);
+	cpuc = &__get_cpu_var(cpu_hw_counters);
 
 	perf_disable();
 	status = intel_pmu_get_status();
@@ -1249,14 +1382,13 @@ static int amd_pmu_handle_irq(struct pt_regs *regs)
 	struct cpu_hw_counters *cpuc;
 	struct perf_counter *counter;
 	struct hw_perf_counter *hwc;
-	int cpu, idx, handled = 0;
+	int idx, handled = 0;
 	u64 val;
 
 	data.regs = regs;
 	data.addr = 0;
 
-	cpu = smp_processor_id();
-	cpuc = &per_cpu(cpu_hw_counters, cpu);
+	cpuc = &__get_cpu_var(cpu_hw_counters);
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		if (!test_bit(idx, cpuc->active_mask))
@@ -1353,6 +1485,32 @@ static __read_mostly struct notifier_block perf_counter_nmi_notifier = {
 	.priority		= 1
 };
 
+static struct x86_pmu p6_pmu = {
+	.name			= "p6",
+	.handle_irq		= p6_pmu_handle_irq,
+	.disable_all		= p6_pmu_disable_all,
+	.enable_all		= p6_pmu_enable_all,
+	.enable			= p6_pmu_enable_counter,
+	.disable		= p6_pmu_disable_counter,
+	.eventsel		= MSR_P6_EVNTSEL0,
+	.perfctr		= MSR_P6_PERFCTR0,
+	.event_map		= p6_pmu_event_map,
+	.raw_event		= p6_pmu_raw_event,
+	.max_events		= ARRAY_SIZE(p6_perfmon_event_map),
+	.max_period		= (1ULL << 31) - 1,
+	.version		= 0,
+	.num_counters		= 2,
+	/*
+	 * Counters have 40 bits implemented. However they are designed such
+	 * that bits [32-39] are sign extensions of bit 31. As such the
+	 * effective width of a counter for P6-like PMU is 32 bits only.
+	 *
+	 * See IA-32 Intel Architecture Software developer manual Vol 3B
+	 */
+	.counter_bits		= 32,
+	.counter_mask		= (1ULL << 32) - 1,
+};
+
 static struct x86_pmu intel_pmu = {
 	.name			= "Intel",
 	.handle_irq		= intel_pmu_handle_irq,
@@ -1392,6 +1550,41 @@ static struct x86_pmu amd_pmu = {
 	.max_period		= (1ULL << 47) - 1,
 };
 
+static int p6_pmu_init(void)
+{
+	int high, low;
+
+	switch (boot_cpu_data.x86_model) {
+	case 1:
+	case 3:  /* Pentium Pro */
+	case 5:
+	case 6:  /* Pentium II */
+	case 7:
+	case 8:
+	case 11: /* Pentium III */
+		break;
+	case 9:
+	case 13:
+		/* for Pentium M, we need to check if PMU exist */
+		rdmsr(MSR_IA32_MISC_ENABLE, low, high);
+		if (low & MSR_IA32_MISC_ENABLE_EMON)
+			break;
+	default:
+		pr_cont("unsupported p6 CPU model %d ",
+			boot_cpu_data.x86_model);
+		return -ENODEV;
+	}
+
+	if (!cpu_has_apic) {
+		pr_info("no Local APIC, try rebooting with lapic");
+		return -ENODEV;
+	}
+
+	x86_pmu				= p6_pmu;
+
+	return 0;
+}
+
 static int intel_pmu_init(void)
 {
 	union cpuid10_edx edx;
@@ -1400,8 +1593,14 @@ static int intel_pmu_init(void)
 	unsigned int ebx;
 	int version;
 
-	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
+	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
+		/* check for P6 processor family */
+	   if (boot_cpu_data.x86 == 6) {
+		return p6_pmu_init();
+	   } else {
 		return -ENODEV;
+	   }
+	}
 
 	/*
 	 * Check whether the Architectural PerfMon supports
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 27887c9..53bb955 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -1,7 +1,13 @@
 #ifndef _PERF_PERF_H
 #define _PERF_PERF_H
 
-#if defined(__x86_64__) || defined(__i386__)
+#if defined(__i386__)
+#include "../../arch/x86/include/asm/unistd.h"
+#define rmb()		asm volatile("lock; addl $0,0(%%esp)" ::: "memory")
+#define cpu_relax()	asm volatile("rep; nop" ::: "memory");
+#endif
+
+#if defined(__x86_64__)
 #include "../../arch/x86/include/asm/unistd.h"
 #define rmb()		asm volatile("lfence" ::: "memory")
 #define cpu_relax()	asm volatile("rep; nop" ::: "memory");
