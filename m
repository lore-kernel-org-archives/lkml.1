Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbZB0Ris@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbZB0Ris (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 12:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbZB0Rik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 12:38:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:44529 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438AbZB0Rij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 12:38:39 -0500
Subject: [git-pull -tip] x86: Basic AMD Support for performance counters
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 23:07:58 +0530
Message-Id: <1235756278.3914.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

These patches added basic AMD (K7 and later) support for performance counters:

[jaswinder@hpdv5 linux-2.6-tip]$ perfstat -e 0,1,2,3,4,5,-1,-2,-3,-4,-5 ls -lR > /dev/null

 Performance counter stats for 'ls':

    2723.203821  task clock ticks     (msecs)

     1812527794  CPU cycles           (events)
     1121688997  instructions         (events)
      569836744  cache references     (events)
       15934598  cache misses         (events)
       57313261  branches             (events)
        4243201  branch misses        (events)
    2639.682866  cpu clock ticks      (msecs)
    2723.203821  task clock ticks     (msecs)
            647  pagefaults           (events)
           2401  context switches     (events)
              3  CPU migrations       (events)

 Wall-clock time elapsed:  6813.030975 msecs


The following changes since commit f39e09b3b2c11ad1b008518a05bc2b7c25eabc7d:
  Ingo Molnar (1):
        Merge branch 'tracing/ftrace'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master

Jaswinder Singh Rajput (2):
      x86: prepare perf_counter to add more cpus
      x86: AMD Support for perf_counter

 arch/x86/kernel/cpu/amd.c          |    4 +
 arch/x86/kernel/cpu/perf_counter.c |  189 ++++++++++++++++++++++++++++++------
 2 files changed, 163 insertions(+), 30 deletions(-)

Complete diff:
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 25423a5..edcde52 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -368,6 +368,10 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	if (c->x86 >= 6)
 		set_cpu_cap(c, X86_FEATURE_FXSAVE_LEAK);
 
+	/* Enable Performance counter for K7 and later */
+	if (c->x86 > 6 && c->x86 <= 0x11)
+		set_cpu_cap(c, X86_FEATURE_ARCH_PERFMON);
+
 	if (!c->x86_model_id[0]) {
 		switch (c->x86) {
 		case 0xf:
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 383d4c6..266618a 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -3,6 +3,7 @@
  *
  *  Copyright(C) 2008 Thomas Gleixner <tglx@linutronix.de>
  *  Copyright(C) 2008 Red Hat, Inc., Ingo Molnar
+ *  Copyright(C) 2009 Jaswinder Singh Rajput
  *
  *  For licencing details see kernel-base/COPYING
  */
@@ -38,10 +39,24 @@ struct cpu_hw_counters {
 };
 
 /*
- * Intel PerfMon v3. Used on Core2 and later.
+ * struct pmc_x86_ops - performance counter x86 ops
  */
+struct pmc_x86_ops {
+	u64 (*save_disable_all)		(void);
+	void (*restore_all)		(u64 ctrl);
+	unsigned eventsel;
+	unsigned perfctr;
+	int (*event_map)		(int event);
+	int max_events;
+};
+
+static struct pmc_x86_ops *pmc_ops;
+
 static DEFINE_PER_CPU(struct cpu_hw_counters, cpu_hw_counters);
 
+/*
+ * Intel PerfMon v3. Used on Core2 and later.
+ */
 static const int intel_perfmon_event_map[] =
 {
   [PERF_COUNT_CPU_CYCLES]		= 0x003c,
@@ -53,7 +68,28 @@ static const int intel_perfmon_event_map[] =
   [PERF_COUNT_BUS_CYCLES]		= 0x013c,
 };
 
-static const int max_intel_perfmon_events = ARRAY_SIZE(intel_perfmon_event_map);
+static int pmc_intel_event_map(int event)
+{
+	return intel_perfmon_event_map[event];
+}
+
+/*
+ * AMD Performance Monitor K7 and later.
+ */
+static const int amd_perfmon_event_map[] =
+{
+  [PERF_COUNT_CPU_CYCLES]		= 0x0076,
+  [PERF_COUNT_INSTRUCTIONS]		= 0x00c0,
+  [PERF_COUNT_CACHE_REFERENCES]		= 0x0080,
+  [PERF_COUNT_CACHE_MISSES]		= 0x0081,
+  [PERF_COUNT_BRANCH_INSTRUCTIONS]	= 0x00c4,
+  [PERF_COUNT_BRANCH_MISSES]		= 0x00c5,
+};
+
+static int pmc_amd_event_map(int event)
+{
+	return amd_perfmon_event_map[event];
+}
 
 /*
  * Propagate counter elapsed time into the generic counter.
@@ -133,8 +169,9 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	 * so we install an artificial 1<<31 period regardless of
 	 * the generic counter period:
 	 */
-	if ((s64)hwc->irq_period <= 0 || hwc->irq_period > 0x7FFFFFFF)
-		hwc->irq_period = 0x7FFFFFFF;
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
+		if ((s64)hwc->irq_period <= 0 || hwc->irq_period > 0x7FFFFFFF)
+			hwc->irq_period = 0x7FFFFFFF;
 
 	atomic64_set(&hwc->period_left, hwc->irq_period);
 
@@ -144,38 +181,78 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	if (hw_event->raw) {
 		hwc->config |= hw_event->type;
 	} else {
-		if (hw_event->type >= max_intel_perfmon_events)
+		if (hw_event->type >= pmc_ops->max_events)
 			return -EINVAL;
 		/*
 		 * The generic map:
 		 */
-		hwc->config |= intel_perfmon_event_map[hw_event->type];
+		hwc->config |= pmc_ops->event_map(hw_event->type);
 	}
 	counter->wakeup_pending = 0;
 
 	return 0;
 }
 
-u64 hw_perf_save_disable(void)
+static u64 pmc_intel_save_disable_all(void)
 {
 	u64 ctrl;
 
-	if (unlikely(!perf_counters_initialized))
-		return 0;
-
 	rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, ctrl);
 	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
 
 	return ctrl;
 }
+
+static u64 pmc_amd_save_disable_all(void)
+{
+	int idx;
+	u64 val, ctrl = 0;
+
+	for (idx = 0; idx < nr_counters_generic; idx++) {
+		rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
+		if (val & ARCH_PERFMON_EVENTSEL0_ENABLE)
+			ctrl |= (1 << idx);
+		val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
+		wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
+	}
+
+	return ctrl;
+}
+
+u64 hw_perf_save_disable(void)
+{
+	if (unlikely(!perf_counters_initialized))
+		return 0;
+
+	return pmc_ops->save_disable_all();
+}
 EXPORT_SYMBOL_GPL(hw_perf_save_disable);
 
+static void pmc_intel_restore_all(u64 ctrl)
+{
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, ctrl);
+}
+
+static void pmc_amd_restore_all(u64 ctrl)
+{
+	u64 val;
+	int idx;
+
+	for (idx = 0; idx < nr_counters_generic; idx++) {
+		if (ctrl & (1 << idx)) {
+			rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
+			val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+			wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
+		}
+	}
+}
+
 void hw_perf_restore(u64 ctrl)
 {
 	if (unlikely(!perf_counters_initialized))
 		return;
 
-	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, ctrl);
+	pmc_ops->restore_all(ctrl);
 }
 EXPORT_SYMBOL_GPL(hw_perf_restore);
 
@@ -286,16 +363,19 @@ fixed_mode_idx(struct perf_counter *counter, struct hw_perf_counter *hwc)
 {
 	unsigned int event;
 
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+		return -1;
+
 	if (unlikely(hwc->nmi))
 		return -1;
 
 	event = hwc->config & ARCH_PERFMON_EVENT_MASK;
 
-	if (unlikely(event == intel_perfmon_event_map[PERF_COUNT_INSTRUCTIONS]))
+	if (unlikely(event == pmc_ops->event_map(PERF_COUNT_INSTRUCTIONS)))
 		return X86_PMC_IDX_FIXED_INSTRUCTIONS;
-	if (unlikely(event == intel_perfmon_event_map[PERF_COUNT_CPU_CYCLES]))
+	if (unlikely(event == pmc_ops->event_map(PERF_COUNT_CPU_CYCLES)))
 		return X86_PMC_IDX_FIXED_CPU_CYCLES;
-	if (unlikely(event == intel_perfmon_event_map[PERF_COUNT_BUS_CYCLES]))
+	if (unlikely(event == pmc_ops->event_map(PERF_COUNT_BUS_CYCLES)))
 		return X86_PMC_IDX_FIXED_BUS_CYCLES;
 
 	return -1;
@@ -339,8 +419,8 @@ try_generic:
 			set_bit(idx, cpuc->used);
 			hwc->idx = idx;
 		}
-		hwc->config_base  = MSR_ARCH_PERFMON_EVENTSEL0;
-		hwc->counter_base = MSR_ARCH_PERFMON_PERFCTR0;
+		hwc->config_base  = pmc_ops->eventsel;
+		hwc->counter_base = pmc_ops->perfctr;
 	}
 
 	perf_counters_lapic_init(hwc->nmi);
@@ -373,6 +453,7 @@ void perf_counter_print_debug(void)
 	cpu = smp_processor_id();
 	cpuc = &per_cpu(cpu_hw_counters, cpu);
 
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) {
 	rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, ctrl);
 	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
 	rdmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, overflow);
@@ -383,11 +464,12 @@ void perf_counter_print_debug(void)
 	printk(KERN_INFO "CPU#%d: status:     %016llx\n", cpu, status);
 	printk(KERN_INFO "CPU#%d: overflow:   %016llx\n", cpu, overflow);
 	printk(KERN_INFO "CPU#%d: fixed:      %016llx\n", cpu, fixed);
+	}
 	printk(KERN_INFO "CPU#%d: used:       %016llx\n", cpu, *(u64 *)cpuc->used);
 
 	for (idx = 0; idx < nr_counters_generic; idx++) {
-		rdmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + idx, pmc_ctrl);
-		rdmsrl(MSR_ARCH_PERFMON_PERFCTR0  + idx, pmc_count);
+		rdmsrl(pmc_ops->eventsel + idx, pmc_ctrl);
+		rdmsrl(pmc_ops->perfctr  + idx, pmc_count);
 
 		prev_left = per_cpu(prev_left[idx], cpu);
 
@@ -560,6 +642,9 @@ void perf_counter_unthrottle(void)
 	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
 		return;
 
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+		return;
+
 	if (unlikely(!perf_counters_initialized))
 		return;
 
@@ -655,29 +740,78 @@ static __read_mostly struct notifier_block perf_counter_nmi_notifier = {
 	.priority		= 1
 };
 
-void __init init_hw_perf_counters(void)
+static struct pmc_x86_ops pmc_intel_ops = {
+	.save_disable_all	= pmc_intel_save_disable_all,
+	.restore_all		= pmc_intel_restore_all,
+	.eventsel		= MSR_ARCH_PERFMON_EVENTSEL0,
+	.perfctr		= MSR_ARCH_PERFMON_PERFCTR0,
+	.event_map		= pmc_intel_event_map,
+	.max_events		= ARRAY_SIZE(intel_perfmon_event_map),
+};
+
+static struct pmc_x86_ops pmc_amd_ops = {
+	.save_disable_all	= pmc_amd_save_disable_all,
+	.restore_all		= pmc_amd_restore_all,
+	.eventsel		= MSR_K7_EVNTSEL0,
+	.perfctr		= MSR_K7_PERFCTR0,
+	.event_map		= pmc_amd_event_map,
+	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
+};
+
+static struct pmc_x86_ops *pmc_intel_init(void)
 {
 	union cpuid10_eax eax;
 	unsigned int ebx;
 	unsigned int unused;
 	union cpuid10_edx edx;
 
-	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
-		return;
-
 	/*
 	 * Check whether the Architectural PerfMon supports
 	 * Branch Misses Retired Event or not.
 	 */
 	cpuid(10, &eax.full, &ebx, &unused, &edx.full);
 	if (eax.split.mask_length <= ARCH_PERFMON_BRANCH_MISSES_RETIRED)
-		return;
+		return NULL;
 
 	printk(KERN_INFO "Intel Performance Monitoring support detected.\n");
-
 	printk(KERN_INFO "... version:         %d\n", eax.split.version_id);
-	printk(KERN_INFO "... num counters:    %d\n", eax.split.num_counters);
+	printk(KERN_INFO "... bit width:       %d\n", eax.split.bit_width);
+	printk(KERN_INFO "... mask length:     %d\n", eax.split.mask_length);
+
 	nr_counters_generic = eax.split.num_counters;
+	nr_counters_fixed = edx.split.num_counters_fixed;
+	counter_value_mask = (1ULL << eax.split.bit_width) - 1;
+
+	return &pmc_intel_ops;
+}
+
+static struct pmc_x86_ops *pmc_amd_init(void)
+{
+	nr_counters_generic = 4;
+	nr_counters_fixed = 0;
+
+	printk(KERN_INFO "AMD Performance Monitoring support detected.\n");
+
+	return &pmc_amd_ops;
+}
+
+void __init init_hw_perf_counters(void)
+{
+	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
+		return;
+
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_INTEL:
+		pmc_ops = pmc_intel_init();
+		break;
+	case X86_VENDOR_AMD:
+		pmc_ops = pmc_amd_init();
+		break;
+	}
+	if (!pmc_ops)
+		return;
+
+	printk(KERN_INFO "... num counters:    %d\n", nr_counters_generic);
 	if (nr_counters_generic > X86_PMC_MAX_GENERIC) {
 		nr_counters_generic = X86_PMC_MAX_GENERIC;
 		WARN(1, KERN_ERR "hw perf counters %d > max(%d), clipping!",
@@ -686,13 +820,8 @@ void __init init_hw_perf_counters(void)
 	perf_counter_mask = (1 << nr_counters_generic) - 1;
 	perf_max_counters = nr_counters_generic;
 
-	printk(KERN_INFO "... bit width:       %d\n", eax.split.bit_width);
-	counter_value_mask = (1ULL << eax.split.bit_width) - 1;
 	printk(KERN_INFO "... value mask:      %016Lx\n", counter_value_mask);
 
-	printk(KERN_INFO "... mask length:     %d\n", eax.split.mask_length);
-
-	nr_counters_fixed = edx.split.num_counters_fixed;
 	if (nr_counters_fixed > X86_PMC_MAX_FIXED) {
 		nr_counters_fixed = X86_PMC_MAX_FIXED;
 		WARN(1, KERN_ERR "hw perf counters fixed %d > max(%d), clipping!",


