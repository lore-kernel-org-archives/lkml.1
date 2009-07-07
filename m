Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbZGGUVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbZGGUVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 16:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbZGGUU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 16:20:58 -0400
Received: from smtpauth00.csee.onr.siteprotect.com ([64.26.60.144]:37115 "EHLO
	smtpauth00.csee.onr.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755930AbZGGUU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 16:20:57 -0400
Date: Tue, 7 Jul 2009 16:06:38 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: [patch] perf_counter: Add p6 PMU
Message-ID: <Pine.LNX.4.64.0907071559200.30742@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OK, so I lied, I found time to throw together a p6 PMU patch.
I've tested it on a Pentium III and it seems to be working.

I'm sure the patch still needs a lot of work.  I'm not sure how to 
implement p6_pmu_enable_all().  There is no support for the various 
cache-related counters.

The code is based on the info in the Intel Software Developer's Manual Vol 
3B, with some comments and code taken from the relevant perfmon2 patches.

There's a lot of overlap between the p6, intel, and amd methods.  Not sure 
if it would be wise to merge up some of the common code.

I do have Pentium Pro, PII, and PIII hardware to test this on.  I also 
have a Yonah-based laptop, but it might have architectural perfmon version 
1 despite being a p6-related core.

Let's hope this version of pine I am using doesn't do something stupid to 
the whitespace in the patch.

Signed-off-by: Vince Weaver <vince@deater.net>

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index d4cf4ce..8d972d5 100644
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
+  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0043,
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
+#define CORE_EVNTSEL_EVENT_MASK		0x000000FFULL
+#define CORE_EVNTSEL_UNIT_MASK		0x0000FF00ULL
+#define CORE_EVNTSEL_EDGE_MASK		0x00040000ULL
+#define CORE_EVNTSEL_INV_MASK		0x00800000ULL
+#define CORE_EVNTSEL_COUNTER_MASK	0xFF000000ULL
+
+#define CORE_EVNTSEL_MASK		\
+	(CORE_EVNTSEL_EVENT_MASK |	\
+	 CORE_EVNTSEL_UNIT_MASK  |	\
+	 CORE_EVNTSEL_EDGE_MASK  |	\
+	 CORE_EVNTSEL_INV_MASK  |	\
+	 CORE_EVNTSEL_COUNTER_MASK)
+
+	return event & CORE_EVNTSEL_MASK;
+}
+
+
+/*
  * Intel PerfMon v3. Used on Core2 and later.
  */
 static const u64 intel_perfmon_event_map[] =
@@ -726,6 +764,12 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	return 0;
 }
 
+static void p6_pmu_disable_all(void)
+{
+	/* p6 only has one enable register */
+	wrmsrl(MSR_P6_EVNTSEL0, 0);
+}
+
 static void intel_pmu_disable_all(void)
 {
 	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
@@ -767,6 +811,10 @@ void hw_perf_disable(void)
 	return x86_pmu.disable_all();
 }
 
+static void p6_pmu_enable_all(void)
+{
+}
+
 static void intel_pmu_enable_all(void)
 {
 	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, x86_pmu.intel_ctrl);
@@ -846,6 +894,12 @@ intel_pmu_disable_fixed(struct hw_perf_counter *hwc, int __idx)
 }
 
 static inline void
+p6_pmu_disable_counter(struct hw_perf_counter *hwc, int idx)
+{
+	x86_pmu_disable_counter(hwc, idx);
+}
+
+static inline void
 intel_pmu_disable_counter(struct hw_perf_counter *hwc, int idx)
 {
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
@@ -943,6 +997,17 @@ intel_pmu_enable_fixed(struct hw_perf_counter *hwc, int __idx)
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
@@ -1176,6 +1241,50 @@ static void intel_pmu_reset(void)
 	local_irq_restore(flags);
 }
 
+static int p6_pmu_handle_irq(struct pt_regs *regs)
+{
+	struct perf_sample_data data;
+	struct cpu_hw_counters *cpuc;
+	struct perf_counter *counter;
+	struct hw_perf_counter *hwc;
+	int cpu, idx, handled = 0;
+	u64 val;
+
+	data.regs = regs;
+	data.addr = 0;
+
+	cpu = smp_processor_id();
+	cpuc = &per_cpu(cpu_hw_counters, cpu);
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
@@ -1353,6 +1462,33 @@ static __read_mostly struct notifier_block perf_counter_nmi_notifier = {
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
+	 * effective width of a counter for P6-like PMU is 31 bits only.
+	 *
+	 *
+	 * See IA-32 Intel Architecture Software developer manual Vol 3B
+	 */
+	.counter_bits		= 31,
+	.counter_mask		= (1ULL << 31) - 1,
+};
+
 static struct x86_pmu intel_pmu = {
 	.name			= "Intel",
 	.handle_irq		= intel_pmu_handle_irq,
@@ -1392,6 +1528,37 @@ static struct x86_pmu amd_pmu = {
 	.max_period		= (1ULL << 47) - 1,
 };
 
+static int p6_pmu_init(void)
+{
+	int high, low;
+
+	switch (boot_cpu_data.x86_model) {
+	case 1: /* Pentium Pro */
+	case 3:
+	case 5: /* Pentium II Deschutes */
+	case 7 ... 11:
+		break;
+	case 13:
+		/* for Pentium M, we need to check if PMU exist */
+		rdmsr(MSR_IA32_MISC_ENABLE, low, high);
+		if (low & (1U << 7))
+			break;
+	default:
+		pr_cont("unsupported p6 CPU model %d ",
+			boot_cpu_data.x86_model);
+		return -1;
+	}
+
+	if (!cpu_has_apic) {
+		pr_info("no Local APIC, try rebooting with lapic");
+		return -1;
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
@@ -1400,6 +1567,12 @@ static int intel_pmu_init(void)
 	unsigned int ebx;
 	int version;
 
+	/* check for P6 processor family */
+	if (boot_cpu_data.x86 == 6) {
+		p6_pmu_init();
+		return 0;
+	}
+
 	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
 		return -ENODEV;
 
