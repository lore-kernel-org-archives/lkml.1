Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab0CEPoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:44:14 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57542 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab0CEPnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:43:12 -0500
Message-Id: <20100305154128.736225361@chello.nl>
References: <20100305153926.639506880@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 05 Mar 2010 16:39:27 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: paulus@samba.org, eranian@google.com, robert.richter@amd.com,
       fweisbec@gmail.com, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 1/5] perf: Rework the arch CPU-hotplug hooks
Content-Disposition: inline; filename=perf-rework-cpuhotplug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the hw_perf_event_*() hotplug hooks in favour of per PMU hotplug
notifiers. This has the advantage of reducing the static weak interface
as well as exposing all hotplug actions to the PMU.

Use this to fix x86 hotplug usage where we did things in ONLINE which
should have been done in UP_PREPARE or STARTING.

CC: Paul Mackerras <paulus@samba.org>
CC: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/powerpc/kernel/perf_event.c          |   21 +++++++++
 arch/sh/kernel/perf_event.c               |   20 ++++++++-
 arch/x86/kernel/cpu/perf_event.c          |   66 ++++++++++++++++++------------
 arch/x86/kernel/cpu/perf_event_amd.c      |   60 +++++++++++----------------
 arch/x86/kernel/cpu/perf_event_intel.c    |    5 +-
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    4 -
 include/linux/perf_event.h                |   16 +++++++
 kernel/perf_event.c                       |   29 -------------
 8 files changed, 127 insertions(+), 94 deletions(-)

Index: linux-2.6/arch/powerpc/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/perf_event.c
+++ linux-2.6/arch/powerpc/kernel/perf_event.c
@@ -1287,7 +1287,7 @@ static void perf_event_interrupt(struct 
 		irq_exit();
 }
 
-void hw_perf_event_setup(int cpu)
+static void power_pmu_setup(int cpu)
 {
 	struct cpu_hw_events *cpuhw = &per_cpu(cpu_hw_events, cpu);
 
@@ -1297,6 +1297,23 @@ void hw_perf_event_setup(int cpu)
 	cpuhw->mmcr[0] = MMCR0_FC;
 }
 
+static int __cpuinit
+power_pmu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (long)hcpu;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_UP_PREPARE:
+		power_pmu_setup(cpu);
+		break;
+
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
 int register_power_pmu(struct power_pmu *pmu)
 {
 	if (ppmu)
@@ -1314,5 +1331,7 @@ int register_power_pmu(struct power_pmu 
 		freeze_events_kernel = MMCR0_FCHV;
 #endif /* CONFIG_PPC64 */
 
+	perf_cpu_notifier(power_pmu_notifier);
+
 	return 0;
 }
Index: linux-2.6/arch/sh/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/perf_event.c
+++ linux-2.6/arch/sh/kernel/perf_event.c
@@ -275,13 +275,30 @@ const struct pmu *hw_perf_event_init(str
 	return &pmu;
 }
 
-void hw_perf_event_setup(int cpu)
+static void sh_pmu_setup(int cpu)
 {
 	struct cpu_hw_events *cpuhw = &per_cpu(cpu_hw_events, cpu);
 
 	memset(cpuhw, 0, sizeof(struct cpu_hw_events));
 }
 
+static int __cpuinit
+sh_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (long)hcpu;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_UP_PREPARE:
+		sh_pmu_setup(cpu);
+		break;
+
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
 void hw_perf_enable(void)
 {
 	if (!sh_pmu_initialized())
@@ -308,5 +325,6 @@ int register_sh_pmu(struct sh_pmu *pmu)
 
 	WARN_ON(pmu->num_events > MAX_HWEVENTS);
 
+	perf_cpu_notifier(sh_pmu_notifier);
 	return 0;
 }
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -198,6 +198,11 @@ struct x86_pmu {
 						 struct perf_event *event);
 	struct event_constraint *event_constraints;
 
+	void		(*cpu_prepare)(int cpu);
+	void		(*cpu_starting)(int cpu);
+	void		(*cpu_dying)(int cpu);
+	void		(*cpu_dead)(int cpu);
+
 	/*
 	 * Intel Arch Perfmon v2+
 	 */
@@ -1306,6 +1311,39 @@ undo:
 #include "perf_event_intel_ds.c"
 #include "perf_event_intel.c"
 
+static int __cpuinit
+x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (long)hcpu;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_UP_PREPARE:
+		if (x86_pmu.cpu_prepare)
+			x86_pmu.cpu_prepare(cpu);
+		break;
+
+	case CPU_STARTING:
+		if (x86_pmu.cpu_starting)
+			x86_pmu.cpu_starting(cpu);
+		break;
+
+	case CPU_DYING:
+		if (x86_pmu.cpu_dying)
+			x86_pmu.cpu_dying(cpu);
+		break;
+
+	case CPU_DEAD:
+		if (x86_pmu.cpu_dead)
+			x86_pmu.cpu_dead(cpu);
+		break;
+
+	default:
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
 static void __init pmu_check_apic(void)
 {
 	if (cpu_has_apic)
@@ -1384,6 +1422,8 @@ void __init init_hw_perf_events(void)
 	pr_info("... max period:             %016Lx\n", x86_pmu.max_period);
 	pr_info("... fixed-purpose events:   %d\n",     x86_pmu.num_events_fixed);
 	pr_info("... event mask:             %016Lx\n", perf_event_mask);
+
+	perf_cpu_notifier(x86_pmu_notifier);
 }
 
 static inline void x86_pmu_read(struct perf_event *event)
@@ -1636,29 +1676,3 @@ struct perf_callchain_entry *perf_callch
 
 	return entry;
 }
-
-void hw_perf_event_setup_online(int cpu)
-{
-	init_debug_store_on_cpu(cpu);
-
-	switch (boot_cpu_data.x86_vendor) {
-	case X86_VENDOR_AMD:
-		amd_pmu_cpu_online(cpu);
-		break;
-	default:
-		return;
-	}
-}
-
-void hw_perf_event_setup_offline(int cpu)
-{
-	init_debug_store_on_cpu(cpu);
-
-	switch (boot_cpu_data.x86_vendor) {
-	case X86_VENDOR_AMD:
-		amd_pmu_cpu_offline(cpu);
-		break;
-	default:
-		return;
-	}
-}
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_amd.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_amd.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_amd.c
@@ -271,28 +271,6 @@ done:
 	return &emptyconstraint;
 }
 
-static __initconst struct x86_pmu amd_pmu = {
-	.name			= "AMD",
-	.handle_irq		= x86_pmu_handle_irq,
-	.disable_all		= x86_pmu_disable_all,
-	.enable_all		= x86_pmu_enable_all,
-	.enable			= x86_pmu_enable_event,
-	.disable		= x86_pmu_disable_event,
-	.eventsel		= MSR_K7_EVNTSEL0,
-	.perfctr		= MSR_K7_PERFCTR0,
-	.event_map		= amd_pmu_event_map,
-	.raw_event		= amd_pmu_raw_event,
-	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
-	.num_events		= 4,
-	.event_bits		= 48,
-	.event_mask		= (1ULL << 48) - 1,
-	.apic			= 1,
-	/* use highest bit to detect overflow */
-	.max_period		= (1ULL << 47) - 1,
-	.get_event_constraints	= amd_get_event_constraints,
-	.put_event_constraints	= amd_put_event_constraints
-};
-
 static struct amd_nb *amd_alloc_nb(int cpu, int nb_id)
 {
 	struct amd_nb *nb;
@@ -378,6 +356,31 @@ static void amd_pmu_cpu_offline(int cpu)
 	raw_spin_unlock(&amd_nb_lock);
 }
 
+static __initconst struct x86_pmu amd_pmu = {
+	.name			= "AMD",
+	.handle_irq		= x86_pmu_handle_irq,
+	.disable_all		= x86_pmu_disable_all,
+	.enable_all		= x86_pmu_enable_all,
+	.enable			= x86_pmu_enable_event,
+	.disable		= x86_pmu_disable_event,
+	.eventsel		= MSR_K7_EVNTSEL0,
+	.perfctr		= MSR_K7_PERFCTR0,
+	.event_map		= amd_pmu_event_map,
+	.raw_event		= amd_pmu_raw_event,
+	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
+	.num_events		= 4,
+	.event_bits		= 48,
+	.event_mask		= (1ULL << 48) - 1,
+	.apic			= 1,
+	/* use highest bit to detect overflow */
+	.max_period		= (1ULL << 47) - 1,
+	.get_event_constraints	= amd_get_event_constraints,
+	.put_event_constraints	= amd_put_event_constraints,
+
+	.cpu_prepare		= amd_pmu_cpu_online,
+	.cpu_dead		= amd_pmu_cpu_offline,
+};
+
 static __init int amd_pmu_init(void)
 {
 	/* Performance-monitoring supported from K7 and later: */
@@ -390,11 +393,6 @@ static __init int amd_pmu_init(void)
 	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
 	       sizeof(hw_cache_event_ids));
 
-	/*
-	 * explicitly initialize the boot cpu, other cpus will get
-	 * the cpu hotplug callbacks from smp_init()
-	 */
-	amd_pmu_cpu_online(smp_processor_id());
 	return 0;
 }
 
@@ -405,12 +403,4 @@ static int amd_pmu_init(void)
 	return 0;
 }
 
-static void amd_pmu_cpu_online(int cpu)
-{
-}
-
-static void amd_pmu_cpu_offline(int cpu)
-{
-}
-
 #endif
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -794,7 +794,10 @@ static __initconst struct x86_pmu intel_
 	 * the generic event period:
 	 */
 	.max_period		= (1ULL << 31) - 1,
-	.get_event_constraints	= intel_get_event_constraints
+	.get_event_constraints	= intel_get_event_constraints,
+
+	.cpu_starting		= init_debug_store_on_cpu,
+	.cpu_dying		= fini_debug_store_on_cpu,
 };
 
 static __init int intel_pmu_init(void)
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -63,7 +63,7 @@ struct debug_store {
 	u64	pebs_event_reset[MAX_PEBS_EVENTS];
 };
 
-static inline void init_debug_store_on_cpu(int cpu)
+static void init_debug_store_on_cpu(int cpu)
 {
 	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
 
@@ -75,7 +75,7 @@ static inline void init_debug_store_on_c
 		     (u32)((u64)(unsigned long)ds >> 32));
 }
 
-static inline void fini_debug_store_on_cpu(int cpu)
+static void fini_debug_store_on_cpu(int cpu)
 {
 	if (!per_cpu(cpu_hw_events, cpu).ds)
 		return;
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -961,5 +961,21 @@ static inline void perf_event_disable(st
 #define perf_output_put(handle, x) \
 	perf_output_copy((handle), &(x), sizeof(x))
 
+/*
+ * This has to have a higher priority than migration_notifier in sched.c.
+ */
+#define perf_cpu_notifier(fn) 					\
+do {								\
+	static struct notifier_block fn##_nb __cpuinitdata =	\
+		{ .notifier_call = fn, .priority = 20 };	\
+	fn(&fn##_nb, (unsigned long)CPU_UP_PREPARE,		\
+		(void *)(unsigned long)smp_processor_id());	\
+	fn(&fn##_nb, (unsigned long)CPU_STARTING,		\
+		(void *)(unsigned long)smp_processor_id());	\
+	fn(&fn##_nb, (unsigned long)CPU_ONLINE,			\
+		(void *)(unsigned long)smp_processor_id());	\
+	register_cpu_notifier(&fn##_nb);			\
+} while (0)
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_PERF_EVENT_H */
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -81,10 +81,6 @@ extern __weak const struct pmu *hw_perf_
 void __weak hw_perf_disable(void)		{ barrier(); }
 void __weak hw_perf_enable(void)		{ barrier(); }
 
-void __weak hw_perf_event_setup(int cpu)	{ barrier(); }
-void __weak hw_perf_event_setup_online(int cpu)	{ barrier(); }
-void __weak hw_perf_event_setup_offline(int cpu)	{ barrier(); }
-
 int __weak
 hw_perf_group_sched_in(struct perf_event *group_leader,
 	       struct perf_cpu_context *cpuctx,
@@ -5404,8 +5400,6 @@ static void __cpuinit perf_event_init_cp
 	spin_lock(&perf_resource_lock);
 	cpuctx->max_pertask = perf_max_events - perf_reserved_percpu;
 	spin_unlock(&perf_resource_lock);
-
-	hw_perf_event_setup(cpu);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -5445,20 +5439,11 @@ perf_cpu_notify(struct notifier_block *s
 		perf_event_init_cpu(cpu);
 		break;
 
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		hw_perf_event_setup_online(cpu);
-		break;
-
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
 		perf_event_exit_cpu(cpu);
 		break;
 
-	case CPU_DEAD:
-		hw_perf_event_setup_offline(cpu);
-		break;
-
 	default:
 		break;
 	}
@@ -5466,21 +5451,9 @@ perf_cpu_notify(struct notifier_block *s
 	return NOTIFY_OK;
 }
 
-/*
- * This has to have a higher priority than migration_notifier in sched.c.
- */
-static struct notifier_block __cpuinitdata perf_cpu_nb = {
-	.notifier_call		= perf_cpu_notify,
-	.priority		= 20,
-};
-
 void __init perf_event_init(void)
 {
-	perf_cpu_notify(&perf_cpu_nb, (unsigned long)CPU_UP_PREPARE,
-			(void *)(long)smp_processor_id());
-	perf_cpu_notify(&perf_cpu_nb, (unsigned long)CPU_ONLINE,
-			(void *)(long)smp_processor_id());
-	register_cpu_notifier(&perf_cpu_nb);
+	perf_cpu_notifier(perf_cpu_notify);
 }
 
 static ssize_t perf_show_reserve_percpu(struct sysdev_class *class, char *buf)

-- 

