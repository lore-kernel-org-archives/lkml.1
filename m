Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbZCER2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbZCER2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 12:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbZCER2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 12:28:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:54192 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474AbZCER2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 12:28:13 -0500
Date: Thu, 5 Mar 2009 17:27:29 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, jaswinder@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       jaswinder@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1236273633.5187.286.camel@laptop>
References: <1236273633.5187.286.camel@laptop>
Subject: [tip:perfcounters/core] perfcounters: IRQ and NMI support on AMD CPUs
Message-ID: <tip-b0f3f28e0f14eb335f67bfaae33ce8b8d74fd58b@git.kernel.org>
Git-Commit-ID: b0f3f28e0f14eb335f67bfaae33ce8b8d74fd58b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 05 Mar 2009 17:27:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b0f3f28e0f14eb335f67bfaae33ce8b8d74fd58b
Gitweb:     http://git.kernel.org/tip/b0f3f28e0f14eb335f67bfaae33ce8b8d74fd58b
Author:     "Peter Zijlstra" <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 5 Mar 2009 18:08:27 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 5 Mar 2009 18:25:16 +0100

perfcounters: IRQ and NMI support on AMD CPUs

The below completes the K7+ performance counter support:

 - IRQ support
 - NMI support

KernelTop output works now as well.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1236273633.5187.286.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |  272 ++++++++++++++++++++++++++++++------
 1 files changed, 228 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 3b65f19..6ebe9ab 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -28,6 +28,7 @@ static bool perf_counters_initialized __read_mostly;
 static int nr_counters_generic __read_mostly;
 static u64 perf_counter_mask __read_mostly;
 static u64 counter_value_mask __read_mostly;
+static int counter_value_bits __read_mostly;
 
 static int nr_counters_fixed __read_mostly;
 
@@ -35,7 +36,9 @@ struct cpu_hw_counters {
 	struct perf_counter	*counters[X86_PMC_IDX_MAX];
 	unsigned long		used[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	unsigned long		interrupts;
-	u64			global_enable;
+	u64			throttle_ctrl;
+	u64			active_mask;
+	int			enabled;
 };
 
 /*
@@ -43,21 +46,28 @@ struct cpu_hw_counters {
  */
 struct pmc_x86_ops {
 	u64		(*save_disable_all)(void);
-	void		(*restore_all)(u64 ctrl);
+	void		(*restore_all)(u64);
+	u64		(*get_status)(u64);
+	void		(*ack_status)(u64);
+	void		(*enable)(int, u64);
+	void		(*disable)(int, u64);
 	unsigned	eventsel;
 	unsigned	perfctr;
-	int		(*event_map)(int event);
+	u64		(*event_map)(int);
+	u64		(*raw_event)(u64);
 	int		max_events;
 };
 
 static struct pmc_x86_ops *pmc_ops;
 
-static DEFINE_PER_CPU(struct cpu_hw_counters, cpu_hw_counters);
+static DEFINE_PER_CPU(struct cpu_hw_counters, cpu_hw_counters) = {
+	.enabled = 1,
+};
 
 /*
  * Intel PerfMon v3. Used on Core2 and later.
  */
-static const int intel_perfmon_event_map[] =
+static const u64 intel_perfmon_event_map[] =
 {
   [PERF_COUNT_CPU_CYCLES]		= 0x003c,
   [PERF_COUNT_INSTRUCTIONS]		= 0x00c0,
@@ -68,15 +78,29 @@ static const int intel_perfmon_event_map[] =
   [PERF_COUNT_BUS_CYCLES]		= 0x013c,
 };
 
-static int pmc_intel_event_map(int event)
+static u64 pmc_intel_event_map(int event)
 {
 	return intel_perfmon_event_map[event];
 }
 
+static u64 pmc_intel_raw_event(u64 event)
+{
+#define CORE_EVNTSEL_EVENT_MASK		0x000000FF
+#define CORE_EVNTSEL_UNIT_MASK		0x0000FF00
+#define CORE_EVNTSEL_COUNTER_MASK	0xFF000000
+
+#define CORE_EVNTSEL_MASK 		\
+	(CORE_EVNTSEL_EVENT_MASK |	\
+	 CORE_EVNTSEL_UNIT_MASK  |	\
+	 CORE_EVNTSEL_COUNTER_MASK)
+
+	return event & CORE_EVNTSEL_MASK;
+}
+
 /*
  * AMD Performance Monitor K7 and later.
  */
-static const int amd_perfmon_event_map[] =
+static const u64 amd_perfmon_event_map[] =
 {
   [PERF_COUNT_CPU_CYCLES]		= 0x0076,
   [PERF_COUNT_INSTRUCTIONS]		= 0x00c0,
@@ -86,11 +110,25 @@ static const int amd_perfmon_event_map[] =
   [PERF_COUNT_BRANCH_MISSES]		= 0x00c5,
 };
 
-static int pmc_amd_event_map(int event)
+static u64 pmc_amd_event_map(int event)
 {
 	return amd_perfmon_event_map[event];
 }
 
+static u64 pmc_amd_raw_event(u64 event)
+{
+#define K7_EVNTSEL_EVENT_MASK	0x7000000FF
+#define K7_EVNTSEL_UNIT_MASK	0x00000FF00
+#define K7_EVNTSEL_COUNTER_MASK	0x0FF000000
+
+#define K7_EVNTSEL_MASK			\
+	(K7_EVNTSEL_EVENT_MASK |	\
+	 K7_EVNTSEL_UNIT_MASK  |	\
+	 K7_EVNTSEL_COUNTER_MASK)
+
+	return event & K7_EVNTSEL_MASK;
+}
+
 /*
  * Propagate counter elapsed time into the generic counter.
  * Can only be executed on the CPU where the counter is active.
@@ -179,7 +217,7 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	 * Raw event type provide the config in the event structure
 	 */
 	if (hw_event->raw) {
-		hwc->config |= hw_event->type;
+		hwc->config |= pmc_ops->raw_event(hw_event->type);
 	} else {
 		if (hw_event->type >= pmc_ops->max_events)
 			return -EINVAL;
@@ -205,18 +243,24 @@ static u64 pmc_intel_save_disable_all(void)
 
 static u64 pmc_amd_save_disable_all(void)
 {
-	int idx;
-	u64 val, ctrl = 0;
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+	int enabled, idx;
+
+	enabled = cpuc->enabled;
+	cpuc->enabled = 0;
+	barrier();
 
 	for (idx = 0; idx < nr_counters_generic; idx++) {
+		u64 val;
+
 		rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
-		if (val & ARCH_PERFMON_EVENTSEL0_ENABLE)
-			ctrl |= (1 << idx);
-		val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
-		wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
+		if (val & ARCH_PERFMON_EVENTSEL0_ENABLE) {
+			val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
+			wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
+		}
 	}
 
-	return ctrl;
+	return enabled;
 }
 
 u64 hw_perf_save_disable(void)
@@ -226,6 +270,9 @@ u64 hw_perf_save_disable(void)
 
 	return pmc_ops->save_disable_all();
 }
+/*
+ * Exported because of ACPI idle
+ */
 EXPORT_SYMBOL_GPL(hw_perf_save_disable);
 
 static void pmc_intel_restore_all(u64 ctrl)
@@ -235,11 +282,18 @@ static void pmc_intel_restore_all(u64 ctrl)
 
 static void pmc_amd_restore_all(u64 ctrl)
 {
-	u64 val;
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
 	int idx;
 
+	cpuc->enabled = ctrl;
+	barrier();
+	if (!ctrl)
+		return;
+
 	for (idx = 0; idx < nr_counters_generic; idx++) {
-		if (ctrl & (1 << idx)) {
+		if (test_bit(idx, (unsigned long *)&cpuc->active_mask)) {
+			u64 val;
+
 			rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
 			val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
 			wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
@@ -254,8 +308,112 @@ void hw_perf_restore(u64 ctrl)
 
 	pmc_ops->restore_all(ctrl);
 }
+/*
+ * Exported because of ACPI idle
+ */
 EXPORT_SYMBOL_GPL(hw_perf_restore);
 
+static u64 pmc_intel_get_status(u64 mask)
+{
+	u64 status;
+
+	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
+
+	return status;
+}
+
+static u64 pmc_amd_get_status(u64 mask)
+{
+	u64 status = 0;
+	int idx;
+
+	for (idx = 0; idx < nr_counters_generic; idx++) {
+		s64 val;
+
+		if (!(mask & (1 << idx)))
+			continue;
+
+		rdmsrl(MSR_K7_PERFCTR0 + idx, val);
+		val <<= (64 - counter_value_bits);
+		if (val >= 0)
+			status |= (1 << idx);
+	}
+
+	return status;
+}
+
+static u64 hw_perf_get_status(u64 mask)
+{
+	if (unlikely(!perf_counters_initialized))
+		return 0;
+
+	return pmc_ops->get_status(mask);
+}
+
+static void pmc_intel_ack_status(u64 ack)
+{
+	wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, ack);
+}
+
+static void pmc_amd_ack_status(u64 ack)
+{
+}
+
+static void hw_perf_ack_status(u64 ack)
+{
+	if (unlikely(!perf_counters_initialized))
+		return;
+
+	pmc_ops->ack_status(ack);
+}
+
+static void pmc_intel_enable(int idx, u64 config)
+{
+	wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + idx,
+			config | ARCH_PERFMON_EVENTSEL0_ENABLE);
+}
+
+static void pmc_amd_enable(int idx, u64 config)
+{
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+
+	set_bit(idx, (unsigned long *)&cpuc->active_mask);
+	if (cpuc->enabled)
+		config |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+
+	wrmsrl(MSR_K7_EVNTSEL0 + idx, config);
+}
+
+static void hw_perf_enable(int idx, u64 config)
+{
+	if (unlikely(!perf_counters_initialized))
+		return;
+
+	pmc_ops->enable(idx, config);
+}
+
+static void pmc_intel_disable(int idx, u64 config)
+{
+	wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + idx, config);
+}
+
+static void pmc_amd_disable(int idx, u64 config)
+{
+	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
+
+	clear_bit(idx, (unsigned long *)&cpuc->active_mask);
+	wrmsrl(MSR_K7_EVNTSEL0 + idx, config);
+
+}
+
+static void hw_perf_disable(int idx, u64 config)
+{
+	if (unlikely(!perf_counters_initialized))
+		return;
+
+	pmc_ops->disable(idx, config);
+}
+
 static inline void
 __pmc_fixed_disable(struct perf_counter *counter,
 		    struct hw_perf_counter *hwc, unsigned int __idx)
@@ -278,7 +436,7 @@ __pmc_generic_disable(struct perf_counter *counter,
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL))
 		__pmc_fixed_disable(counter, hwc, idx);
 	else
-		wrmsr_safe(hwc->config_base + idx, hwc->config, 0);
+		hw_perf_disable(idx, hwc->config);
 }
 
 static DEFINE_PER_CPU(u64, prev_left[X86_PMC_IDX_MAX]);
@@ -354,8 +512,7 @@ __pmc_generic_enable(struct perf_counter *counter,
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL))
 		__pmc_fixed_enable(counter, hwc, idx);
 	else
-		wrmsr(hwc->config_base + idx,
-		      hwc->config | ARCH_PERFMON_EVENTSEL0_ENABLE, 0);
+		hw_perf_enable(idx, hwc->config);
 }
 
 static int
@@ -567,22 +724,20 @@ perf_handle_group(struct perf_counter *sibling, u64 *status, u64 *overflown)
  * This handler is triggered by the local APIC, so the APIC IRQ handling
  * rules apply:
  */
-static void __smp_perf_counter_interrupt(struct pt_regs *regs, int nmi)
+static int __smp_perf_counter_interrupt(struct pt_regs *regs, int nmi)
 {
 	int bit, cpu = smp_processor_id();
 	u64 ack, status;
 	struct cpu_hw_counters *cpuc = &per_cpu(cpu_hw_counters, cpu);
+	int ret = 0;
 
-	rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, cpuc->global_enable);
-
-	/* Disable counters globally */
-	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
-	ack_APIC_irq();
+	cpuc->throttle_ctrl = hw_perf_save_disable();
 
-	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
+	status = hw_perf_get_status(cpuc->throttle_ctrl);
 	if (!status)
 		goto out;
 
+	ret = 1;
 again:
 	inc_irq_stat(apic_perf_irqs);
 	ack = status;
@@ -618,12 +773,12 @@ again:
 		}
 	}
 
-	wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, ack);
+	hw_perf_ack_status(ack);
 
 	/*
 	 * Repeat if there is more work to be done:
 	 */
-	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
+	status = hw_perf_get_status(cpuc->throttle_ctrl);
 	if (status)
 		goto again;
 out:
@@ -631,32 +786,27 @@ out:
 	 * Restore - do not reenable when global enable is off or throttled:
 	 */
 	if (++cpuc->interrupts < PERFMON_MAX_INTERRUPTS)
-		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, cpuc->global_enable);
+		hw_perf_restore(cpuc->throttle_ctrl);
+
+	return ret;
 }
 
 void perf_counter_unthrottle(void)
 {
 	struct cpu_hw_counters *cpuc;
-	u64 global_enable;
 
 	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
 		return;
 
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
-		return;
-
 	if (unlikely(!perf_counters_initialized))
 		return;
 
-	cpuc = &per_cpu(cpu_hw_counters, smp_processor_id());
+	cpuc = &__get_cpu_var(cpu_hw_counters);
 	if (cpuc->interrupts >= PERFMON_MAX_INTERRUPTS) {
 		if (printk_ratelimit())
 			printk(KERN_WARNING "PERFMON: max interrupts exceeded!\n");
-		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, cpuc->global_enable);
+		hw_perf_restore(cpuc->throttle_ctrl);
 	}
-	rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, global_enable);
-	if (unlikely(cpuc->global_enable && !global_enable))
-		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, cpuc->global_enable);
 	cpuc->interrupts = 0;
 }
 
@@ -664,8 +814,8 @@ void smp_perf_counter_interrupt(struct pt_regs *regs)
 {
 	irq_enter();
 	apic_write(APIC_LVTPC, LOCAL_PERF_VECTOR);
+	ack_APIC_irq();
 	__smp_perf_counter_interrupt(regs, 0);
-
 	irq_exit();
 }
 
@@ -722,16 +872,23 @@ perf_counter_nmi_handler(struct notifier_block *self,
 {
 	struct die_args *args = __args;
 	struct pt_regs *regs;
+	int ret;
+
+	switch (cmd) {
+	case DIE_NMI:
+	case DIE_NMI_IPI:
+		break;
 
-	if (likely(cmd != DIE_NMI_IPI))
+	default:
 		return NOTIFY_DONE;
+	}
 
 	regs = args->regs;
 
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
-	__smp_perf_counter_interrupt(regs, 1);
+	ret = __smp_perf_counter_interrupt(regs, 1);
 
-	return NOTIFY_STOP;
+	return ret ? NOTIFY_STOP : NOTIFY_OK;
 }
 
 static __read_mostly struct notifier_block perf_counter_nmi_notifier = {
@@ -743,18 +900,28 @@ static __read_mostly struct notifier_block perf_counter_nmi_notifier = {
 static struct pmc_x86_ops pmc_intel_ops = {
 	.save_disable_all	= pmc_intel_save_disable_all,
 	.restore_all		= pmc_intel_restore_all,
+	.get_status		= pmc_intel_get_status,
+	.ack_status		= pmc_intel_ack_status,
+	.enable			= pmc_intel_enable,
+	.disable		= pmc_intel_disable,
 	.eventsel		= MSR_ARCH_PERFMON_EVENTSEL0,
 	.perfctr		= MSR_ARCH_PERFMON_PERFCTR0,
 	.event_map		= pmc_intel_event_map,
+	.raw_event		= pmc_intel_raw_event,
 	.max_events		= ARRAY_SIZE(intel_perfmon_event_map),
 };
 
 static struct pmc_x86_ops pmc_amd_ops = {
 	.save_disable_all	= pmc_amd_save_disable_all,
 	.restore_all		= pmc_amd_restore_all,
+	.get_status		= pmc_amd_get_status,
+	.ack_status		= pmc_amd_ack_status,
+	.enable			= pmc_amd_enable,
+	.disable		= pmc_amd_disable,
 	.eventsel		= MSR_K7_EVNTSEL0,
 	.perfctr		= MSR_K7_PERFCTR0,
 	.event_map		= pmc_amd_event_map,
+	.raw_event		= pmc_amd_raw_event,
 	.max_events		= ARRAY_SIZE(amd_perfmon_event_map),
 };
 
@@ -787,8 +954,25 @@ static struct pmc_x86_ops *pmc_intel_init(void)
 
 static struct pmc_x86_ops *pmc_amd_init(void)
 {
+	u64 old;
+	int bits;
+
 	nr_counters_generic = 4;
 	nr_counters_fixed = 0;
+	counter_value_mask = ~0ULL;
+
+	rdmsrl(MSR_K7_PERFCTR0, old);
+	wrmsrl(MSR_K7_PERFCTR0, counter_value_mask);
+	/*
+	 * read the truncated mask
+	 */
+	rdmsrl(MSR_K7_PERFCTR0, counter_value_mask);
+	wrmsrl(MSR_K7_PERFCTR0, old);
+
+	bits = 32 + fls(counter_value_mask >> 32);
+	if (bits == 32)
+		bits = fls((u32)counter_value_mask);
+	counter_value_bits = bits;
 
 	pr_info("AMD Performance Monitoring support detected.\n");
 
