Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab0CJNKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:10:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:59002 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082Ab0CJNKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:10:52 -0500
Date: Wed, 10 Mar 2010 13:10:03 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       acme@infradead.org, a.p.zijlstra@chello.nl, lethal@linux-sh.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, acme@infradead.org, tglx@linutronix.de,
       lethal@linux-sh.org, mingo@elte.hu
In-Reply-To: <20100305154128.736225361@chello.nl>
References: <20100305154128.736225361@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Rework and fix the arch CPU-hotplug hooks
Message-ID: <tip-3f6da3905398826d85731247e7fbcf53400c18bd@git.kernel.org>
Git-Commit-ID: 3f6da3905398826d85731247e7fbcf53400c18bd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:10:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f6da3905398826d85731247e7fbcf53400c18bd
Gitweb:     http://git.kernel.org/tip/3f6da3905398826d85731247e7fbcf53400c18bd
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 5 Mar 2010 13:01:18 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:22:24 +0100

perf: Rework and fix the arch CPU-hotplug hooks

Remove the hw_perf_event_*() hotplug hooks in favour of per PMU hotplug
notifiers. This has the advantage of reducing the static weak interface
as well as exposing all hotplug actions to the PMU.

Use this to fix x86 hotplug usage where we did things in ONLINE which
should have been done in UP_PREPARE or STARTING.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
LKML-Reference: <20100305154128.736225361@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/powerpc/kernel/perf_event.c       |   21 +++++++++-
 arch/sh/kernel/perf_event.c            |   20 +++++++++-
 arch/x86/kernel/cpu/perf_event.c       |   70 +++++++++++++++++++-------------
 arch/x86/kernel/cpu/perf_event_amd.c   |   60 +++++++++++----------------
 arch/x86/kernel/cpu/perf_event_intel.c |    5 ++-
 include/linux/perf_event.h             |   16 +++++++
 kernel/perf_event.c                    |   15 -------
 7 files changed, 126 insertions(+), 81 deletions(-)

diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index 5120bd4..fbe101d 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -1287,7 +1287,7 @@ static void perf_event_interrupt(struct pt_regs *regs)
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
@@ -1314,5 +1331,7 @@ int register_power_pmu(struct power_pmu *pmu)
 		freeze_events_kernel = MMCR0_FCHV;
 #endif /* CONFIG_PPC64 */
 
+	perf_cpu_notifier(power_pmu_notifier);
+
 	return 0;
 }
diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
index 7ff0943..9f253e9 100644
--- a/arch/sh/kernel/perf_event.c
+++ b/arch/sh/kernel/perf_event.c
@@ -275,13 +275,30 @@ const struct pmu *hw_perf_event_init(struct perf_event *event)
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
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 42aafd1..585d560 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -157,6 +157,11 @@ struct x86_pmu {
 	void		(*put_event_constraints)(struct cpu_hw_events *cpuc,
 						 struct perf_event *event);
 	struct event_constraint *event_constraints;
+
+	void		(*cpu_prepare)(int cpu);
+	void		(*cpu_starting)(int cpu);
+	void		(*cpu_dying)(int cpu);
+	void		(*cpu_dead)(int cpu);
 };
 
 static struct x86_pmu x86_pmu __read_mostly;
@@ -293,7 +298,7 @@ static inline bool bts_available(void)
 	return x86_pmu.enable_bts != NULL;
 }
 
-static inline void init_debug_store_on_cpu(int cpu)
+static void init_debug_store_on_cpu(int cpu)
 {
 	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
 
@@ -305,7 +310,7 @@ static inline void init_debug_store_on_cpu(int cpu)
 		     (u32)((u64)(unsigned long)ds >> 32));
 }
 
-static inline void fini_debug_store_on_cpu(int cpu)
+static void fini_debug_store_on_cpu(int cpu)
 {
 	if (!per_cpu(cpu_hw_events, cpu).ds)
 		return;
@@ -1337,6 +1342,39 @@ undo:
 #include "perf_event_p6.c"
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
@@ -1415,6 +1453,8 @@ void __init init_hw_perf_events(void)
 	pr_info("... max period:             %016Lx\n", x86_pmu.max_period);
 	pr_info("... fixed-purpose events:   %d\n",     x86_pmu.num_events_fixed);
 	pr_info("... event mask:             %016Lx\n", perf_event_mask);
+
+	perf_cpu_notifier(x86_pmu_notifier);
 }
 
 static inline void x86_pmu_read(struct perf_event *event)
@@ -1674,29 +1714,3 @@ struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 
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
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 8f3dbfd..014528b 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
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
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 44b60c8..12e811a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -870,7 +870,10 @@ static __initconst struct x86_pmu intel_pmu = {
 	.max_period		= (1ULL << 31) - 1,
 	.enable_bts		= intel_pmu_enable_bts,
 	.disable_bts		= intel_pmu_disable_bts,
-	.get_event_constraints	= intel_get_event_constraints
+	.get_event_constraints	= intel_get_event_constraints,
+
+	.cpu_starting		= init_debug_store_on_cpu,
+	.cpu_dying		= fini_debug_store_on_cpu,
 };
 
 static __init int intel_pmu_init(void)
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 6f8cd7d..80acbf3 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -936,5 +936,21 @@ static inline void perf_event_disable(struct perf_event *event)		{ }
 #define perf_output_put(handle, x) \
 	perf_output_copy((handle), &(x), sizeof(x))
 
+/*
+ * This has to have a higher priority than migration_notifier in sched.c.
+ */
+#define perf_cpu_notifier(fn)					\
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
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 4393b9e..73329de 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -81,10 +81,6 @@ extern __weak const struct pmu *hw_perf_event_init(struct perf_event *event)
 void __weak hw_perf_disable(void)		{ barrier(); }
 void __weak hw_perf_enable(void)		{ barrier(); }
 
-void __weak hw_perf_event_setup(int cpu)	{ barrier(); }
-void __weak hw_perf_event_setup_online(int cpu)	{ barrier(); }
-void __weak hw_perf_event_setup_offline(int cpu)	{ barrier(); }
-
 int __weak
 hw_perf_group_sched_in(struct perf_event *group_leader,
 	       struct perf_cpu_context *cpuctx,
@@ -5382,8 +5378,6 @@ static void __cpuinit perf_event_init_cpu(int cpu)
 	spin_lock(&perf_resource_lock);
 	cpuctx->max_pertask = perf_max_events - perf_reserved_percpu;
 	spin_unlock(&perf_resource_lock);
-
-	hw_perf_event_setup(cpu);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -5423,20 +5417,11 @@ perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
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
