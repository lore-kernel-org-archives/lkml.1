Return-Path: <linux-kernel-owner+w=401wt.eu-S1762054AbZEOIqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762054AbZEOIqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 04:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761473AbZEOIoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 04:44:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:57228 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761031AbZEOIoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 04:44:09 -0400
Date: Fri, 15 May 2009 08:43:26 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Rework the perf counter disable/enable
Message-ID: <tip-9e35ad388bea89f7d6f375af4c0ae98803688666@git.kernel.org>
Git-Commit-ID: 9e35ad388bea89f7d6f375af4c0ae98803688666
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 08:43:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e35ad388bea89f7d6f375af4c0ae98803688666
Gitweb:     http://git.kernel.org/tip/9e35ad388bea89f7d6f375af4c0ae98803688666
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 13 May 2009 16:21:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 15 May 2009 09:47:02 +0200

perf_counter: Rework the perf counter disable/enable

The current disable/enable mechanism is:

	token = hw_perf_save_disable();
	...
	/* do bits */
	...
	hw_perf_restore(token);

This works well, provided that the use nests properly. Except we don't.

x86 NMI/INT throttling has non-nested use of this, breaking things. Therefore
provide a reference counter disable/enable interface, where the first disable
disables the hardware, and the last enable enables the hardware again.

[ Impact: refactor, simplify the PMU disable/enable logic ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/perf_counter.c |   24 ++++----
 arch/x86/kernel/cpu/perf_counter.c |  113 +++++++++++++----------------------
 drivers/acpi/processor_idle.c      |    6 +-
 include/linux/perf_counter.h       |   10 ++-
 kernel/perf_counter.c              |   76 +++++++++++++++---------
 5 files changed, 109 insertions(+), 120 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 15cdc8e..bb1b463 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -386,7 +386,7 @@ static void write_mmcr0(struct cpu_hw_counters *cpuhw, unsigned long mmcr0)
  * Disable all counters to prevent PMU interrupts and to allow
  * counters to be added or removed.
  */
-u64 hw_perf_save_disable(void)
+void hw_perf_disable(void)
 {
 	struct cpu_hw_counters *cpuhw;
 	unsigned long ret;
@@ -428,7 +428,6 @@ u64 hw_perf_save_disable(void)
 		mb();
 	}
 	local_irq_restore(flags);
-	return ret;
 }
 
 /*
@@ -436,7 +435,7 @@ u64 hw_perf_save_disable(void)
  * If we were previously disabled and counters were added, then
  * put the new config on the PMU.
  */
-void hw_perf_restore(u64 disable)
+void hw_perf_enable(void)
 {
 	struct perf_counter *counter;
 	struct cpu_hw_counters *cpuhw;
@@ -448,9 +447,12 @@ void hw_perf_restore(u64 disable)
 	int n_lim;
 	int idx;
 
-	if (disable)
-		return;
 	local_irq_save(flags);
+	if (!cpuhw->disabled) {
+		local_irq_restore(flags);
+		return;
+	}
+
 	cpuhw = &__get_cpu_var(cpu_hw_counters);
 	cpuhw->disabled = 0;
 
@@ -649,19 +651,18 @@ int hw_perf_group_sched_in(struct perf_counter *group_leader,
 /*
  * Add a counter to the PMU.
  * If all counters are not already frozen, then we disable and
- * re-enable the PMU in order to get hw_perf_restore to do the
+ * re-enable the PMU in order to get hw_perf_enable to do the
  * actual work of reconfiguring the PMU.
  */
 static int power_pmu_enable(struct perf_counter *counter)
 {
 	struct cpu_hw_counters *cpuhw;
 	unsigned long flags;
-	u64 pmudis;
 	int n0;
 	int ret = -EAGAIN;
 
 	local_irq_save(flags);
-	pmudis = hw_perf_save_disable();
+	perf_disable();
 
 	/*
 	 * Add the counter to the list (if there is room)
@@ -685,7 +686,7 @@ static int power_pmu_enable(struct perf_counter *counter)
 
 	ret = 0;
  out:
-	hw_perf_restore(pmudis);
+	perf_enable();
 	local_irq_restore(flags);
 	return ret;
 }
@@ -697,11 +698,10 @@ static void power_pmu_disable(struct perf_counter *counter)
 {
 	struct cpu_hw_counters *cpuhw;
 	long i;
-	u64 pmudis;
 	unsigned long flags;
 
 	local_irq_save(flags);
-	pmudis = hw_perf_save_disable();
+	perf_disable();
 
 	power_pmu_read(counter);
 
@@ -735,7 +735,7 @@ static void power_pmu_disable(struct perf_counter *counter)
 		cpuhw->mmcr[0] &= ~(MMCR0_PMXE | MMCR0_FCECE);
 	}
 
-	hw_perf_restore(pmudis);
+	perf_enable();
 	local_irq_restore(flags);
 }
 
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 7601c01..313638c 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -31,7 +31,6 @@ struct cpu_hw_counters {
 	unsigned long		used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	unsigned long		active_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	unsigned long		interrupts;
-	u64			throttle_ctrl;
 	int			enabled;
 };
 
@@ -42,8 +41,8 @@ struct x86_pmu {
 	const char	*name;
 	int		version;
 	int		(*handle_irq)(struct pt_regs *, int);
-	u64		(*save_disable_all)(void);
-	void		(*restore_all)(u64);
+	void		(*disable_all)(void);
+	void		(*enable_all)(void);
 	void		(*enable)(struct hw_perf_counter *, int);
 	void		(*disable)(struct hw_perf_counter *, int);
 	unsigned	eventsel;
@@ -56,6 +55,7 @@ struct x86_pmu {
 	int		counter_bits;
 	u64		counter_mask;
 	u64		max_period;
+	u64		intel_ctrl;
 };
 
 static struct x86_pmu x86_pmu __read_mostly;
@@ -311,22 +311,19 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	return 0;
 }
 
-static u64 intel_pmu_save_disable_all(void)
+static void intel_pmu_disable_all(void)
 {
-	u64 ctrl;
-
-	rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, ctrl);
 	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
-
-	return ctrl;
 }
 
-static u64 amd_pmu_save_disable_all(void)
+static void amd_pmu_disable_all(void)
 {
 	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
-	int enabled, idx;
+	int idx;
+
+	if (!cpuc->enabled)
+		return;
 
-	enabled = cpuc->enabled;
 	cpuc->enabled = 0;
 	/*
 	 * ensure we write the disable before we start disabling the
@@ -334,8 +331,6 @@ static u64 amd_pmu_save_disable_all(void)
 	 * right thing.
 	 */
 	barrier();
-	if (!enabled)
-		goto out;
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		u64 val;
@@ -348,37 +343,31 @@ static u64 amd_pmu_save_disable_all(void)
 		val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
 		wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
 	}
-
-out:
-	return enabled;
 }
 
-u64 hw_perf_save_disable(void)
+void hw_perf_disable(void)
 {
 	if (!x86_pmu_initialized())
-		return 0;
-	return x86_pmu.save_disable_all();
+		return;
+	return x86_pmu.disable_all();
 }
-/*
- * Exported because of ACPI idle
- */
-EXPORT_SYMBOL_GPL(hw_perf_save_disable);
 
-static void intel_pmu_restore_all(u64 ctrl)
+static void intel_pmu_enable_all(void)
 {
-	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, ctrl);
+	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, x86_pmu.intel_ctrl);
 }
 
-static void amd_pmu_restore_all(u64 ctrl)
+static void amd_pmu_enable_all(void)
 {
 	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
 	int idx;
 
-	cpuc->enabled = ctrl;
-	barrier();
-	if (!ctrl)
+	if (cpuc->enabled)
 		return;
 
+	cpuc->enabled = 1;
+	barrier();
+
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		u64 val;
 
@@ -392,16 +381,12 @@ static void amd_pmu_restore_all(u64 ctrl)
 	}
 }
 
-void hw_perf_restore(u64 ctrl)
+void hw_perf_enable(void)
 {
 	if (!x86_pmu_initialized())
 		return;
-	x86_pmu.restore_all(ctrl);
+	x86_pmu.enable_all();
 }
-/*
- * Exported because of ACPI idle
- */
-EXPORT_SYMBOL_GPL(hw_perf_restore);
 
 static inline u64 intel_pmu_get_status(void)
 {
@@ -735,15 +720,14 @@ static int intel_pmu_handle_irq(struct pt_regs *regs, int nmi)
 	int bit, cpu = smp_processor_id();
 	u64 ack, status;
 	struct cpu_hw_counters *cpuc = &per_cpu(cpu_hw_counters, cpu);
-	int ret = 0;
-
-	cpuc->throttle_ctrl = intel_pmu_save_disable_all();
 
+	perf_disable();
 	status = intel_pmu_get_status();
-	if (!status)
-		goto out;
+	if (!status) {
+		perf_enable();
+		return 0;
+	}
 
-	ret = 1;
 again:
 	inc_irq_stat(apic_perf_irqs);
 	ack = status;
@@ -767,19 +751,11 @@ again:
 	status = intel_pmu_get_status();
 	if (status)
 		goto again;
-out:
-	/*
-	 * Restore - do not reenable when global enable is off or throttled:
-	 */
-	if (cpuc->throttle_ctrl) {
-		if (++cpuc->interrupts < PERFMON_MAX_INTERRUPTS) {
-			intel_pmu_restore_all(cpuc->throttle_ctrl);
-		} else {
-			pr_info("CPU#%d: perfcounters: max interrupt rate exceeded! Throttle on.\n", smp_processor_id());
-		}
-	}
 
-	return ret;
+	if (++cpuc->interrupts != PERFMON_MAX_INTERRUPTS)
+		perf_enable();
+
+	return 1;
 }
 
 static int amd_pmu_handle_irq(struct pt_regs *regs, int nmi)
@@ -792,13 +768,11 @@ static int amd_pmu_handle_irq(struct pt_regs *regs, int nmi)
 	struct hw_perf_counter *hwc;
 	int idx, throttle = 0;
 
-	cpuc->throttle_ctrl = cpuc->enabled;
-	cpuc->enabled = 0;
-	barrier();
-
-	if (cpuc->throttle_ctrl) {
-		if (++cpuc->interrupts >= PERFMON_MAX_INTERRUPTS)
-			throttle = 1;
+	if (++cpuc->interrupts == PERFMON_MAX_INTERRUPTS) {
+		throttle = 1;
+		__perf_disable();
+		cpuc->enabled = 0;
+		barrier();
 	}
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
@@ -824,9 +798,6 @@ next:
 			amd_pmu_disable_counter(hwc, idx);
 	}
 
-	if (cpuc->throttle_ctrl && !throttle)
-		cpuc->enabled = 1;
-
 	return handled;
 }
 
@@ -839,13 +810,11 @@ void perf_counter_unthrottle(void)
 
 	cpuc = &__get_cpu_var(cpu_hw_counters);
 	if (cpuc->interrupts >= PERFMON_MAX_INTERRUPTS) {
-		pr_info("CPU#%d: perfcounters: throttle off.\n", smp_processor_id());
-
 		/*
 		 * Clear them before re-enabling irqs/NMIs again:
 		 */
 		cpuc->interrupts = 0;
-		hw_perf_restore(cpuc->throttle_ctrl);
+		perf_enable();
 	} else {
 		cpuc->interrupts = 0;
 	}
@@ -931,8 +900,8 @@ static __read_mostly struct notifier_block perf_counter_nmi_notifier = {
 static struct x86_pmu intel_pmu = {
 	.name			= "Intel",
 	.handle_irq		= intel_pmu_handle_irq,
-	.save_disable_all	= intel_pmu_save_disable_all,
-	.restore_all		= intel_pmu_restore_all,
+	.disable_all		= intel_pmu_disable_all,
+	.enable_all		= intel_pmu_enable_all,
 	.enable			= intel_pmu_enable_counter,
 	.disable		= intel_pmu_disable_counter,
 	.eventsel		= MSR_ARCH_PERFMON_EVENTSEL0,
@@ -951,8 +920,8 @@ static struct x86_pmu intel_pmu = {
 static struct x86_pmu amd_pmu = {
 	.name			= "AMD",
 	.handle_irq		= amd_pmu_handle_irq,
-	.save_disable_all	= amd_pmu_save_disable_all,
-	.restore_all		= amd_pmu_restore_all,
+	.disable_all		= amd_pmu_disable_all,
+	.enable_all		= amd_pmu_enable_all,
 	.enable			= amd_pmu_enable_counter,
 	.disable		= amd_pmu_disable_counter,
 	.eventsel		= MSR_K7_EVNTSEL0,
@@ -1003,6 +972,8 @@ static int intel_pmu_init(void)
 	x86_pmu.counter_bits = eax.split.bit_width;
 	x86_pmu.counter_mask = (1ULL << eax.split.bit_width) - 1;
 
+	rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, x86_pmu.intel_ctrl);
+
 	return 0;
 }
 
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index d2830f3..9645758 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -763,11 +763,9 @@ static int acpi_idle_bm_check(void)
  */
 static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
 {
-	u64 perf_flags;
-
 	/* Don't trace irqs off for idle */
 	stop_critical_timings();
-	perf_flags = hw_perf_save_disable();
+	perf_disable();
 	if (cx->entry_method == ACPI_CSTATE_FFH) {
 		/* Call into architectural FFH based C-state */
 		acpi_processor_ffh_cstate_enter(cx);
@@ -782,7 +780,7 @@ static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
 		   gets asserted in time to freeze execution properly. */
 		unused = inl(acpi_gbl_FADT.xpm_timer_block.address);
 	}
-	hw_perf_restore(perf_flags);
+	perf_enable();
 	start_critical_timings();
 }
 
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 614f921..e543ecc 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -544,8 +544,10 @@ extern void perf_counter_exit_task(struct task_struct *child);
 extern void perf_counter_do_pending(void);
 extern void perf_counter_print_debug(void);
 extern void perf_counter_unthrottle(void);
-extern u64 hw_perf_save_disable(void);
-extern void hw_perf_restore(u64 ctrl);
+extern void __perf_disable(void);
+extern bool __perf_enable(void);
+extern void perf_disable(void);
+extern void perf_enable(void);
 extern int perf_counter_task_disable(void);
 extern int perf_counter_task_enable(void);
 extern int hw_perf_group_sched_in(struct perf_counter *group_leader,
@@ -600,8 +602,8 @@ static inline void perf_counter_exit_task(struct task_struct *child)	{ }
 static inline void perf_counter_do_pending(void)			{ }
 static inline void perf_counter_print_debug(void)			{ }
 static inline void perf_counter_unthrottle(void)			{ }
-static inline void hw_perf_restore(u64 ctrl)				{ }
-static inline u64 hw_perf_save_disable(void)		      { return 0; }
+static inline void perf_disable(void)					{ }
+static inline void perf_enable(void)					{ }
 static inline int perf_counter_task_disable(void)	{ return -EINVAL; }
 static inline int perf_counter_task_enable(void)	{ return -EINVAL; }
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 985be0b..e814ff0 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -60,8 +60,9 @@ extern __weak const struct pmu *hw_perf_counter_init(struct perf_counter *counte
 	return NULL;
 }
 
-u64 __weak hw_perf_save_disable(void)		{ return 0; }
-void __weak hw_perf_restore(u64 ctrl)		{ barrier(); }
+void __weak hw_perf_disable(void)		{ barrier(); }
+void __weak hw_perf_enable(void)		{ barrier(); }
+
 void __weak hw_perf_counter_setup(int cpu)	{ barrier(); }
 int __weak hw_perf_group_sched_in(struct perf_counter *group_leader,
 	       struct perf_cpu_context *cpuctx,
@@ -72,6 +73,32 @@ int __weak hw_perf_group_sched_in(struct perf_counter *group_leader,
 
 void __weak perf_counter_print_debug(void)	{ }
 
+static DEFINE_PER_CPU(int, disable_count);
+
+void __perf_disable(void)
+{
+	__get_cpu_var(disable_count)++;
+}
+
+bool __perf_enable(void)
+{
+	return !--__get_cpu_var(disable_count);
+}
+
+void perf_disable(void)
+{
+	__perf_disable();
+	hw_perf_disable();
+}
+EXPORT_SYMBOL_GPL(perf_disable); /* ACPI idle */
+
+void perf_enable(void)
+{
+	if (__perf_enable())
+		hw_perf_enable();
+}
+EXPORT_SYMBOL_GPL(perf_enable); /* ACPI idle */
+
 static void
 list_add_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
 {
@@ -170,7 +197,6 @@ static void __perf_counter_remove_from_context(void *info)
 	struct perf_counter *counter = info;
 	struct perf_counter_context *ctx = counter->ctx;
 	unsigned long flags;
-	u64 perf_flags;
 
 	/*
 	 * If this is a task context, we need to check whether it is
@@ -191,9 +217,9 @@ static void __perf_counter_remove_from_context(void *info)
 	 * Protect the list operation against NMI by disabling the
 	 * counters on a global level. NOP for non NMI based counters.
 	 */
-	perf_flags = hw_perf_save_disable();
+	perf_disable();
 	list_del_counter(counter, ctx);
-	hw_perf_restore(perf_flags);
+	perf_enable();
 
 	if (!ctx->task) {
 		/*
@@ -538,7 +564,6 @@ static void __perf_install_in_context(void *info)
 	struct perf_counter *leader = counter->group_leader;
 	int cpu = smp_processor_id();
 	unsigned long flags;
-	u64 perf_flags;
 	int err;
 
 	/*
@@ -556,7 +581,7 @@ static void __perf_install_in_context(void *info)
 	 * Protect the list operation against NMI by disabling the
 	 * counters on a global level. NOP for non NMI based counters.
 	 */
-	perf_flags = hw_perf_save_disable();
+	perf_disable();
 
 	add_counter_to_ctx(counter, ctx);
 
@@ -596,7 +621,7 @@ static void __perf_install_in_context(void *info)
 		cpuctx->max_pertask--;
 
  unlock:
-	hw_perf_restore(perf_flags);
+	perf_enable();
 
 	spin_unlock_irqrestore(&ctx->lock, flags);
 }
@@ -663,7 +688,6 @@ static void __perf_counter_enable(void *info)
 	struct perf_cpu_context *cpuctx = &__get_cpu_var(perf_cpu_context);
 	struct perf_counter_context *ctx = counter->ctx;
 	struct perf_counter *leader = counter->group_leader;
-	unsigned long pmuflags;
 	unsigned long flags;
 	int err;
 
@@ -693,14 +717,14 @@ static void __perf_counter_enable(void *info)
 	if (!group_can_go_on(counter, cpuctx, 1)) {
 		err = -EEXIST;
 	} else {
-		pmuflags = hw_perf_save_disable();
+		perf_disable();
 		if (counter == leader)
 			err = group_sched_in(counter, cpuctx, ctx,
 					     smp_processor_id());
 		else
 			err = counter_sched_in(counter, cpuctx, ctx,
 					       smp_processor_id());
-		hw_perf_restore(pmuflags);
+		perf_enable();
 	}
 
 	if (err) {
@@ -795,7 +819,6 @@ void __perf_counter_sched_out(struct perf_counter_context *ctx,
 			      struct perf_cpu_context *cpuctx)
 {
 	struct perf_counter *counter;
-	u64 flags;
 
 	spin_lock(&ctx->lock);
 	ctx->is_active = 0;
@@ -803,12 +826,12 @@ void __perf_counter_sched_out(struct perf_counter_context *ctx,
 		goto out;
 	update_context_time(ctx);
 
-	flags = hw_perf_save_disable();
+	perf_disable();
 	if (ctx->nr_active) {
 		list_for_each_entry(counter, &ctx->counter_list, list_entry)
 			group_sched_out(counter, cpuctx, ctx);
 	}
-	hw_perf_restore(flags);
+	perf_enable();
  out:
 	spin_unlock(&ctx->lock);
 }
@@ -860,7 +883,6 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
 			struct perf_cpu_context *cpuctx, int cpu)
 {
 	struct perf_counter *counter;
-	u64 flags;
 	int can_add_hw = 1;
 
 	spin_lock(&ctx->lock);
@@ -870,7 +892,7 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
 
 	ctx->timestamp = perf_clock();
 
-	flags = hw_perf_save_disable();
+	perf_disable();
 
 	/*
 	 * First go through the list and put on any pinned groups
@@ -917,7 +939,7 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
 				can_add_hw = 0;
 		}
 	}
-	hw_perf_restore(flags);
+	perf_enable();
  out:
 	spin_unlock(&ctx->lock);
 }
@@ -955,7 +977,6 @@ int perf_counter_task_disable(void)
 	struct perf_counter_context *ctx = &curr->perf_counter_ctx;
 	struct perf_counter *counter;
 	unsigned long flags;
-	u64 perf_flags;
 
 	if (likely(!ctx->nr_counters))
 		return 0;
@@ -969,7 +990,7 @@ int perf_counter_task_disable(void)
 	/*
 	 * Disable all the counters:
 	 */
-	perf_flags = hw_perf_save_disable();
+	perf_disable();
 
 	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
 		if (counter->state != PERF_COUNTER_STATE_ERROR) {
@@ -978,7 +999,7 @@ int perf_counter_task_disable(void)
 		}
 	}
 
-	hw_perf_restore(perf_flags);
+	perf_enable();
 
 	spin_unlock_irqrestore(&ctx->lock, flags);
 
@@ -991,7 +1012,6 @@ int perf_counter_task_enable(void)
 	struct perf_counter_context *ctx = &curr->perf_counter_ctx;
 	struct perf_counter *counter;
 	unsigned long flags;
-	u64 perf_flags;
 	int cpu;
 
 	if (likely(!ctx->nr_counters))
@@ -1007,7 +1027,7 @@ int perf_counter_task_enable(void)
 	/*
 	 * Disable all the counters:
 	 */
-	perf_flags = hw_perf_save_disable();
+	perf_disable();
 
 	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
 		if (counter->state > PERF_COUNTER_STATE_OFF)
@@ -1017,7 +1037,7 @@ int perf_counter_task_enable(void)
 			ctx->time - counter->total_time_enabled;
 		counter->hw_event.disabled = 0;
 	}
-	hw_perf_restore(perf_flags);
+	perf_enable();
 
 	spin_unlock(&ctx->lock);
 
@@ -1034,7 +1054,6 @@ int perf_counter_task_enable(void)
 static void rotate_ctx(struct perf_counter_context *ctx)
 {
 	struct perf_counter *counter;
-	u64 perf_flags;
 
 	if (!ctx->nr_counters)
 		return;
@@ -1043,12 +1062,12 @@ static void rotate_ctx(struct perf_counter_context *ctx)
 	/*
 	 * Rotate the first entry last (works just fine for group counters too):
 	 */
-	perf_flags = hw_perf_save_disable();
+	perf_disable();
 	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
 		list_move_tail(&counter->list_entry, &ctx->counter_list);
 		break;
 	}
-	hw_perf_restore(perf_flags);
+	perf_enable();
 
 	spin_unlock(&ctx->lock);
 }
@@ -3194,7 +3213,6 @@ __perf_counter_exit_task(struct task_struct *child,
 	} else {
 		struct perf_cpu_context *cpuctx;
 		unsigned long flags;
-		u64 perf_flags;
 
 		/*
 		 * Disable and unlink this counter.
@@ -3203,7 +3221,7 @@ __perf_counter_exit_task(struct task_struct *child,
 		 * could still be processing it:
 		 */
 		local_irq_save(flags);
-		perf_flags = hw_perf_save_disable();
+		perf_disable();
 
 		cpuctx = &__get_cpu_var(perf_cpu_context);
 
@@ -3214,7 +3232,7 @@ __perf_counter_exit_task(struct task_struct *child,
 
 		child_ctx->nr_counters--;
 
-		hw_perf_restore(perf_flags);
+		perf_enable();
 		local_irq_restore(flags);
 	}
 
