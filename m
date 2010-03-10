Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab0CJNTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:19:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:57393 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548Ab0CJNTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:19:22 -0500
Date: Wed, 10 Mar 2010 13:18:39 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       acme@infradead.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100304140100.392111285@chello.nl>
References: <20100304140100.392111285@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/pebs] perf, x86: Add PEBS infrastructure
Message-ID: <tip-ca037701a025334e724e5c61b3b1082940c8b981@git.kernel.org>
Git-Commit-ID: ca037701a025334e724e5c61b3b1082940c8b981
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:18:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca037701a025334e724e5c61b3b1082940c8b981
Gitweb:     http://git.kernel.org/tip/ca037701a025334e724e5c61b3b1082940c8b981
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 2 Mar 2010 19:52:12 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:23:31 +0100

perf, x86: Add PEBS infrastructure

This patch implements support for Intel Precise Event Based Sampling,
which is an alternative counter mode in which the counter triggers a
hardware assist to collect information on events. The hardware assist
takes a trap like snapshot of a subset of the machine registers.

This data is written to the Intel Debug-Store, which can be programmed
with a data threshold at which to raise a PMI.

With the PEBS hardware assist being trap like, the reported IP is always
one instruction after the actual instruction that triggered the event.

This implements a simple PEBS model that always takes a single PEBS event
at a time. This is done so that the interaction with the rest of the
system is as expected (freq adjust, period randomization, lbr,
callchains, etc.).

It adds an ABI element: perf_event_attr::precise, which indicates that we
wish to use this (constrained, but precise) mode.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
LKML-Reference: <20100304140100.392111285@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c          |  223 ++++--------
 arch/x86/kernel/cpu/perf_event_intel.c    |  150 ++------
 arch/x86/kernel/cpu/perf_event_intel_ds.c |  557 +++++++++++++++++++++++++++++
 include/linux/perf_event.h                |    3 +-
 4 files changed, 671 insertions(+), 262 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 1d665a0..0c03d5c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -31,45 +31,6 @@
 
 static u64 perf_event_mask __read_mostly;
 
-/* The maximal number of PEBS events: */
-#define MAX_PEBS_EVENTS	4
-
-/* The size of a BTS record in bytes: */
-#define BTS_RECORD_SIZE		24
-
-/* The size of a per-cpu BTS buffer in bytes: */
-#define BTS_BUFFER_SIZE		(BTS_RECORD_SIZE * 2048)
-
-/* The BTS overflow threshold in bytes from the end of the buffer: */
-#define BTS_OVFL_TH		(BTS_RECORD_SIZE * 128)
-
-
-/*
- * Bits in the debugctlmsr controlling branch tracing.
- */
-#define X86_DEBUGCTL_TR			(1 << 6)
-#define X86_DEBUGCTL_BTS		(1 << 7)
-#define X86_DEBUGCTL_BTINT		(1 << 8)
-#define X86_DEBUGCTL_BTS_OFF_OS		(1 << 9)
-#define X86_DEBUGCTL_BTS_OFF_USR	(1 << 10)
-
-/*
- * A debug store configuration.
- *
- * We only support architectures that use 64bit fields.
- */
-struct debug_store {
-	u64	bts_buffer_base;
-	u64	bts_index;
-	u64	bts_absolute_maximum;
-	u64	bts_interrupt_threshold;
-	u64	pebs_buffer_base;
-	u64	pebs_index;
-	u64	pebs_absolute_maximum;
-	u64	pebs_interrupt_threshold;
-	u64	pebs_event_reset[MAX_PEBS_EVENTS];
-};
-
 struct event_constraint {
 	union {
 		unsigned long	idxmsk[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
@@ -88,17 +49,29 @@ struct amd_nb {
 };
 
 struct cpu_hw_events {
+	/*
+	 * Generic x86 PMC bits
+	 */
 	struct perf_event	*events[X86_PMC_IDX_MAX]; /* in counter order */
 	unsigned long		active_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	unsigned long		interrupts;
 	int			enabled;
-	struct debug_store	*ds;
 
 	int			n_events;
 	int			n_added;
 	int			assign[X86_PMC_IDX_MAX]; /* event to counter assignment */
 	u64			tags[X86_PMC_IDX_MAX];
 	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
+
+	/*
+	 * Intel DebugStore bits
+	 */
+	struct debug_store	*ds;
+	u64			pebs_enabled;
+
+	/*
+	 * AMD specific bits
+	 */
 	struct amd_nb		*amd_nb;
 };
 
@@ -112,12 +85,24 @@ struct cpu_hw_events {
 #define EVENT_CONSTRAINT(c, n, m)	\
 	__EVENT_CONSTRAINT(c, n, m, HWEIGHT(n))
 
+/*
+ * Constraint on the Event code.
+ */
 #define INTEL_EVENT_CONSTRAINT(c, n)	\
 	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVTSEL_MASK)
 
+/*
+ * Constraint on the Event code + UMask + fixed-mask
+ */
 #define FIXED_EVENT_CONSTRAINT(c, n)	\
 	EVENT_CONSTRAINT(c, (1ULL << (32+n)), INTEL_ARCH_FIXED_MASK)
 
+/*
+ * Constraint on the Event code + UMask
+ */
+#define PEBS_EVENT_CONSTRAINT(c, n)	\
+	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
+
 #define EVENT_CONSTRAINT_END		\
 	EVENT_CONSTRAINT(0, 0, 0)
 
@@ -128,6 +113,9 @@ struct cpu_hw_events {
  * struct x86_pmu - generic x86 pmu
  */
 struct x86_pmu {
+	/*
+	 * Generic x86 PMC bits
+	 */
 	const char	*name;
 	int		version;
 	int		(*handle_irq)(struct pt_regs *);
@@ -146,10 +134,6 @@ struct x86_pmu {
 	u64		event_mask;
 	int		apic;
 	u64		max_period;
-	u64		intel_ctrl;
-	void		(*enable_bts)(u64 config);
-	void		(*disable_bts)(void);
-
 	struct event_constraint *
 			(*get_event_constraints)(struct cpu_hw_events *cpuc,
 						 struct perf_event *event);
@@ -162,6 +146,19 @@ struct x86_pmu {
 	void		(*cpu_starting)(int cpu);
 	void		(*cpu_dying)(int cpu);
 	void		(*cpu_dead)(int cpu);
+
+	/*
+	 * Intel Arch Perfmon v2+
+	 */
+	u64		intel_ctrl;
+
+	/*
+	 * Intel DebugStore bits
+	 */
+	int		bts, pebs;
+	int		pebs_record_size;
+	void		(*drain_pebs)(struct pt_regs *regs);
+	struct event_constraint *pebs_constraints;
 };
 
 static struct x86_pmu x86_pmu __read_mostly;
@@ -293,110 +290,14 @@ static void release_pmc_hardware(void)
 #endif
 }
 
-static inline bool bts_available(void)
-{
-	return x86_pmu.enable_bts != NULL;
-}
-
-static void init_debug_store_on_cpu(int cpu)
-{
-	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
-
-	if (!ds)
-		return;
-
-	wrmsr_on_cpu(cpu, MSR_IA32_DS_AREA,
-		     (u32)((u64)(unsigned long)ds),
-		     (u32)((u64)(unsigned long)ds >> 32));
-}
-
-static void fini_debug_store_on_cpu(int cpu)
-{
-	if (!per_cpu(cpu_hw_events, cpu).ds)
-		return;
-
-	wrmsr_on_cpu(cpu, MSR_IA32_DS_AREA, 0, 0);
-}
-
-static void release_bts_hardware(void)
-{
-	int cpu;
-
-	if (!bts_available())
-		return;
-
-	get_online_cpus();
-
-	for_each_online_cpu(cpu)
-		fini_debug_store_on_cpu(cpu);
-
-	for_each_possible_cpu(cpu) {
-		struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
-
-		if (!ds)
-			continue;
-
-		per_cpu(cpu_hw_events, cpu).ds = NULL;
-
-		kfree((void *)(unsigned long)ds->bts_buffer_base);
-		kfree(ds);
-	}
-
-	put_online_cpus();
-}
-
-static int reserve_bts_hardware(void)
-{
-	int cpu, err = 0;
-
-	if (!bts_available())
-		return 0;
-
-	get_online_cpus();
-
-	for_each_possible_cpu(cpu) {
-		struct debug_store *ds;
-		void *buffer;
-
-		err = -ENOMEM;
-		buffer = kzalloc(BTS_BUFFER_SIZE, GFP_KERNEL);
-		if (unlikely(!buffer))
-			break;
-
-		ds = kzalloc(sizeof(*ds), GFP_KERNEL);
-		if (unlikely(!ds)) {
-			kfree(buffer);
-			break;
-		}
-
-		ds->bts_buffer_base = (u64)(unsigned long)buffer;
-		ds->bts_index = ds->bts_buffer_base;
-		ds->bts_absolute_maximum =
-			ds->bts_buffer_base + BTS_BUFFER_SIZE;
-		ds->bts_interrupt_threshold =
-			ds->bts_absolute_maximum - BTS_OVFL_TH;
-
-		per_cpu(cpu_hw_events, cpu).ds = ds;
-		err = 0;
-	}
-
-	if (err)
-		release_bts_hardware();
-	else {
-		for_each_online_cpu(cpu)
-			init_debug_store_on_cpu(cpu);
-	}
-
-	put_online_cpus();
-
-	return err;
-}
+static int reserve_ds_buffers(void);
+static void release_ds_buffers(void);
 
 static void hw_perf_event_destroy(struct perf_event *event)
 {
 	if (atomic_dec_and_mutex_lock(&active_events, &pmc_reserve_mutex)) {
 		release_pmc_hardware();
-		release_bts_hardware();
+		release_ds_buffers();
 		mutex_unlock(&pmc_reserve_mutex);
 	}
 }
@@ -459,7 +360,7 @@ static int __hw_perf_event_init(struct perf_event *event)
 			if (!reserve_pmc_hardware())
 				err = -EBUSY;
 			else
-				err = reserve_bts_hardware();
+				err = reserve_ds_buffers();
 		}
 		if (!err)
 			atomic_inc(&active_events);
@@ -537,7 +438,7 @@ static int __hw_perf_event_init(struct perf_event *event)
 	if ((attr->config == PERF_COUNT_HW_BRANCH_INSTRUCTIONS) &&
 	    (hwc->sample_period == 1)) {
 		/* BTS is not supported by this architecture. */
-		if (!bts_available())
+		if (!x86_pmu.bts)
 			return -EOPNOTSUPP;
 
 		/* BTS is currently only allowed for user-mode. */
@@ -995,6 +896,7 @@ static void x86_pmu_unthrottle(struct perf_event *event)
 void perf_event_print_debug(void)
 {
 	u64 ctrl, status, overflow, pmc_ctrl, pmc_count, prev_left, fixed;
+	u64 pebs;
 	struct cpu_hw_events *cpuc;
 	unsigned long flags;
 	int cpu, idx;
@@ -1012,12 +914,14 @@ void perf_event_print_debug(void)
 		rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
 		rdmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, overflow);
 		rdmsrl(MSR_ARCH_PERFMON_FIXED_CTR_CTRL, fixed);
+		rdmsrl(MSR_IA32_PEBS_ENABLE, pebs);
 
 		pr_info("\n");
 		pr_info("CPU#%d: ctrl:       %016llx\n", cpu, ctrl);
 		pr_info("CPU#%d: status:     %016llx\n", cpu, status);
 		pr_info("CPU#%d: overflow:   %016llx\n", cpu, overflow);
 		pr_info("CPU#%d: fixed:      %016llx\n", cpu, fixed);
+		pr_info("CPU#%d: pebs:       %016llx\n", cpu, pebs);
 	}
 	pr_info("CPU#%d: active:       %016llx\n", cpu, *(u64 *)cpuc->active_mask);
 
@@ -1333,6 +1237,7 @@ undo:
 
 #include "perf_event_amd.c"
 #include "perf_event_p6.c"
+#include "perf_event_intel_ds.c"
 #include "perf_event_intel.c"
 
 static int __cpuinit
@@ -1465,6 +1370,32 @@ static const struct pmu pmu = {
 };
 
 /*
+ * validate that we can schedule this event
+ */
+static int validate_event(struct perf_event *event)
+{
+	struct cpu_hw_events *fake_cpuc;
+	struct event_constraint *c;
+	int ret = 0;
+
+	fake_cpuc = kmalloc(sizeof(*fake_cpuc), GFP_KERNEL | __GFP_ZERO);
+	if (!fake_cpuc)
+		return -ENOMEM;
+
+	c = x86_pmu.get_event_constraints(fake_cpuc, event);
+
+	if (!c || !c->weight)
+		ret = -ENOSPC;
+
+	if (x86_pmu.put_event_constraints)
+		x86_pmu.put_event_constraints(fake_cpuc, event);
+
+	kfree(fake_cpuc);
+
+	return ret;
+}
+
+/*
  * validate a single event group
  *
  * validation include:
@@ -1529,6 +1460,8 @@ const struct pmu *hw_perf_event_init(struct perf_event *event)
 
 		if (event->group_leader != event)
 			err = validate_group(event);
+		else
+			err = validate_event(event);
 
 		event->pmu = tmp;
 	}
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 84bfde6..1144641 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -470,42 +470,6 @@ static u64 intel_pmu_raw_event(u64 hw_event)
 	return hw_event & CORE_EVNTSEL_MASK;
 }
 
-static void intel_pmu_enable_bts(u64 config)
-{
-	unsigned long debugctlmsr;
-
-	debugctlmsr = get_debugctlmsr();
-
-	debugctlmsr |= X86_DEBUGCTL_TR;
-	debugctlmsr |= X86_DEBUGCTL_BTS;
-	debugctlmsr |= X86_DEBUGCTL_BTINT;
-
-	if (!(config & ARCH_PERFMON_EVENTSEL_OS))
-		debugctlmsr |= X86_DEBUGCTL_BTS_OFF_OS;
-
-	if (!(config & ARCH_PERFMON_EVENTSEL_USR))
-		debugctlmsr |= X86_DEBUGCTL_BTS_OFF_USR;
-
-	update_debugctlmsr(debugctlmsr);
-}
-
-static void intel_pmu_disable_bts(void)
-{
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	unsigned long debugctlmsr;
-
-	if (!cpuc->ds)
-		return;
-
-	debugctlmsr = get_debugctlmsr();
-
-	debugctlmsr &=
-		~(X86_DEBUGCTL_TR | X86_DEBUGCTL_BTS | X86_DEBUGCTL_BTINT |
-		  X86_DEBUGCTL_BTS_OFF_OS | X86_DEBUGCTL_BTS_OFF_USR);
-
-	update_debugctlmsr(debugctlmsr);
-}
-
 static void intel_pmu_disable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -514,6 +478,8 @@ static void intel_pmu_disable_all(void)
 
 	if (test_bit(X86_PMC_IDX_FIXED_BTS, cpuc->active_mask))
 		intel_pmu_disable_bts();
+
+	intel_pmu_pebs_disable_all();
 }
 
 static void intel_pmu_enable_all(void)
@@ -531,6 +497,8 @@ static void intel_pmu_enable_all(void)
 
 		intel_pmu_enable_bts(event->hw.config);
 	}
+
+	intel_pmu_pebs_enable_all();
 }
 
 static inline u64 intel_pmu_get_status(void)
@@ -547,8 +515,7 @@ static inline void intel_pmu_ack_status(u64 ack)
 	wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, ack);
 }
 
-static inline void
-intel_pmu_disable_fixed(struct hw_perf_event *hwc)
+static void intel_pmu_disable_fixed(struct hw_perf_event *hwc)
 {
 	int idx = hwc->idx - X86_PMC_IDX_FIXED;
 	u64 ctrl_val, mask;
@@ -560,68 +527,7 @@ intel_pmu_disable_fixed(struct hw_perf_event *hwc)
 	(void)checking_wrmsrl(hwc->config_base, ctrl_val);
 }
 
-static void intel_pmu_drain_bts_buffer(void)
-{
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct debug_store *ds = cpuc->ds;
-	struct bts_record {
-		u64	from;
-		u64	to;
-		u64	flags;
-	};
-	struct perf_event *event = cpuc->events[X86_PMC_IDX_FIXED_BTS];
-	struct bts_record *at, *top;
-	struct perf_output_handle handle;
-	struct perf_event_header header;
-	struct perf_sample_data data;
-	struct pt_regs regs;
-
-	if (!event)
-		return;
-
-	if (!ds)
-		return;
-
-	at  = (struct bts_record *)(unsigned long)ds->bts_buffer_base;
-	top = (struct bts_record *)(unsigned long)ds->bts_index;
-
-	if (top <= at)
-		return;
-
-	ds->bts_index = ds->bts_buffer_base;
-
-	perf_sample_data_init(&data, 0);
-
-	data.period	= event->hw.last_period;
-	regs.ip		= 0;
-
-	/*
-	 * Prepare a generic sample, i.e. fill in the invariant fields.
-	 * We will overwrite the from and to address before we output
-	 * the sample.
-	 */
-	perf_prepare_sample(&header, &data, event, &regs);
-
-	if (perf_output_begin(&handle, event,
-			      header.size * (top - at), 1, 1))
-		return;
-
-	for (; at < top; at++) {
-		data.ip		= at->from;
-		data.addr	= at->to;
-
-		perf_output_sample(&handle, &header, &data, event);
-	}
-
-	perf_output_end(&handle);
-
-	/* There's new data available. */
-	event->hw.interrupts++;
-	event->pending_kill = POLL_IN;
-}
-
-static inline void
-intel_pmu_disable_event(struct perf_event *event)
+static void intel_pmu_disable_event(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 
@@ -637,10 +543,12 @@ intel_pmu_disable_event(struct perf_event *event)
 	}
 
 	x86_pmu_disable_event(event);
+
+	if (unlikely(event->attr.precise))
+		intel_pmu_pebs_disable(hwc);
 }
 
-static inline void
-intel_pmu_enable_fixed(struct hw_perf_event *hwc)
+static void intel_pmu_enable_fixed(struct hw_perf_event *hwc)
 {
 	int idx = hwc->idx - X86_PMC_IDX_FIXED;
 	u64 ctrl_val, bits, mask;
@@ -689,6 +597,9 @@ static void intel_pmu_enable_event(struct perf_event *event)
 		return;
 	}
 
+	if (unlikely(event->attr.precise))
+		intel_pmu_pebs_enable(hwc);
+
 	__x86_pmu_enable_event(hwc);
 }
 
@@ -762,6 +673,13 @@ again:
 
 	inc_irq_stat(apic_perf_irqs);
 	ack = status;
+
+	/*
+	 * PEBS overflow sets bit 62 in the global status register
+	 */
+	if (__test_and_clear_bit(62, (unsigned long *)&status))
+		x86_pmu.drain_pebs(regs);
+
 	for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
 		struct perf_event *event = cpuc->events[bit];
 
@@ -791,22 +709,18 @@ done:
 	return 1;
 }
 
-static struct event_constraint bts_constraint =
-	EVENT_CONSTRAINT(0, 1ULL << X86_PMC_IDX_FIXED_BTS, 0);
-
 static struct event_constraint *
-intel_special_constraints(struct perf_event *event)
+intel_bts_constraints(struct perf_event *event)
 {
-	unsigned int hw_event;
-
-	hw_event = event->hw.config & INTEL_ARCH_EVENT_MASK;
+	struct hw_perf_event *hwc = &event->hw;
+	unsigned int hw_event, bts_event;
 
-	if (unlikely((hw_event ==
-		      x86_pmu.event_map(PERF_COUNT_HW_BRANCH_INSTRUCTIONS)) &&
-		     (event->hw.sample_period == 1))) {
+	hw_event = hwc->config & INTEL_ARCH_EVENT_MASK;
+	bts_event = x86_pmu.event_map(PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
 
+	if (unlikely(hw_event == bts_event && hwc->sample_period == 1))
 		return &bts_constraint;
-	}
+
 	return NULL;
 }
 
@@ -815,7 +729,11 @@ intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event
 {
 	struct event_constraint *c;
 
-	c = intel_special_constraints(event);
+	c = intel_bts_constraints(event);
+	if (c)
+		return c;
+
+	c = intel_pebs_constraints(event);
 	if (c)
 		return c;
 
@@ -864,8 +782,6 @@ static __initconst struct x86_pmu intel_pmu = {
 	 * the generic event period:
 	 */
 	.max_period		= (1ULL << 31) - 1,
-	.enable_bts		= intel_pmu_enable_bts,
-	.disable_bts		= intel_pmu_disable_bts,
 	.get_event_constraints	= intel_get_event_constraints,
 
 	.cpu_starting		= init_debug_store_on_cpu,
@@ -915,6 +831,8 @@ static __init int intel_pmu_init(void)
 	if (version > 1)
 		x86_pmu.num_events_fixed = max((int)edx.split.num_events_fixed, 3);
 
+	intel_ds_init();
+
 	/*
 	 * Install the hw-cache-events table:
 	 */
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
new file mode 100644
index 0000000..0d994ef
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -0,0 +1,557 @@
+#ifdef CONFIG_CPU_SUP_INTEL
+
+/* The maximal number of PEBS events: */
+#define MAX_PEBS_EVENTS		4
+
+/* The size of a BTS record in bytes: */
+#define BTS_RECORD_SIZE		24
+
+#define BTS_BUFFER_SIZE		(PAGE_SIZE << 4)
+#define PEBS_BUFFER_SIZE	PAGE_SIZE
+
+/*
+ * pebs_record_32 for p4 and core not supported
+
+struct pebs_record_32 {
+	u32 flags, ip;
+	u32 ax, bc, cx, dx;
+	u32 si, di, bp, sp;
+};
+
+ */
+
+struct pebs_record_core {
+	u64 flags, ip;
+	u64 ax, bx, cx, dx;
+	u64 si, di, bp, sp;
+	u64 r8,  r9,  r10, r11;
+	u64 r12, r13, r14, r15;
+};
+
+struct pebs_record_nhm {
+	u64 flags, ip;
+	u64 ax, bx, cx, dx;
+	u64 si, di, bp, sp;
+	u64 r8,  r9,  r10, r11;
+	u64 r12, r13, r14, r15;
+	u64 status, dla, dse, lat;
+};
+
+/*
+ * Bits in the debugctlmsr controlling branch tracing.
+ */
+#define X86_DEBUGCTL_TR			(1 << 6)
+#define X86_DEBUGCTL_BTS		(1 << 7)
+#define X86_DEBUGCTL_BTINT		(1 << 8)
+#define X86_DEBUGCTL_BTS_OFF_OS		(1 << 9)
+#define X86_DEBUGCTL_BTS_OFF_USR	(1 << 10)
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
+	u64	pebs_event_reset[MAX_PEBS_EVENTS];
+};
+
+static void init_debug_store_on_cpu(int cpu)
+{
+	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
+
+	if (!ds)
+		return;
+
+	wrmsr_on_cpu(cpu, MSR_IA32_DS_AREA,
+		     (u32)((u64)(unsigned long)ds),
+		     (u32)((u64)(unsigned long)ds >> 32));
+}
+
+static void fini_debug_store_on_cpu(int cpu)
+{
+	if (!per_cpu(cpu_hw_events, cpu).ds)
+		return;
+
+	wrmsr_on_cpu(cpu, MSR_IA32_DS_AREA, 0, 0);
+}
+
+static void release_ds_buffers(void)
+{
+	int cpu;
+
+	if (!x86_pmu.bts && !x86_pmu.pebs)
+		return;
+
+	get_online_cpus();
+
+	for_each_online_cpu(cpu)
+		fini_debug_store_on_cpu(cpu);
+
+	for_each_possible_cpu(cpu) {
+		struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
+
+		if (!ds)
+			continue;
+
+		per_cpu(cpu_hw_events, cpu).ds = NULL;
+
+		kfree((void *)(unsigned long)ds->pebs_buffer_base);
+		kfree((void *)(unsigned long)ds->bts_buffer_base);
+		kfree(ds);
+	}
+
+	put_online_cpus();
+}
+
+static int reserve_ds_buffers(void)
+{
+	int cpu, err = 0;
+
+	if (!x86_pmu.bts && !x86_pmu.pebs)
+		return 0;
+
+	get_online_cpus();
+
+	for_each_possible_cpu(cpu) {
+		struct debug_store *ds;
+		void *buffer;
+		int max, thresh;
+
+		err = -ENOMEM;
+		ds = kzalloc(sizeof(*ds), GFP_KERNEL);
+		if (unlikely(!ds)) {
+			kfree(buffer);
+			break;
+		}
+		per_cpu(cpu_hw_events, cpu).ds = ds;
+
+		if (x86_pmu.bts) {
+			buffer = kzalloc(BTS_BUFFER_SIZE, GFP_KERNEL);
+			if (unlikely(!buffer))
+				break;
+
+			max = BTS_BUFFER_SIZE / BTS_RECORD_SIZE;
+			thresh = max / 16;
+
+			ds->bts_buffer_base = (u64)(unsigned long)buffer;
+			ds->bts_index = ds->bts_buffer_base;
+			ds->bts_absolute_maximum = ds->bts_buffer_base +
+				max * BTS_RECORD_SIZE;
+			ds->bts_interrupt_threshold = ds->bts_absolute_maximum -
+				thresh * BTS_RECORD_SIZE;
+		}
+
+		if (x86_pmu.pebs) {
+			buffer = kzalloc(PEBS_BUFFER_SIZE, GFP_KERNEL);
+			if (unlikely(!buffer))
+				break;
+
+			max = PEBS_BUFFER_SIZE / x86_pmu.pebs_record_size;
+
+			ds->pebs_buffer_base = (u64)(unsigned long)buffer;
+			ds->pebs_index = ds->pebs_buffer_base;
+			ds->pebs_absolute_maximum = ds->pebs_buffer_base +
+				max * x86_pmu.pebs_record_size;
+			/*
+			 * Always use single record PEBS
+			 */
+			ds->pebs_interrupt_threshold = ds->pebs_buffer_base +
+				x86_pmu.pebs_record_size;
+		}
+
+		err = 0;
+	}
+
+	if (err)
+		release_ds_buffers();
+	else {
+		for_each_online_cpu(cpu)
+			init_debug_store_on_cpu(cpu);
+	}
+
+	put_online_cpus();
+
+	return err;
+}
+
+/*
+ * BTS
+ */
+
+static struct event_constraint bts_constraint =
+	EVENT_CONSTRAINT(0, 1ULL << X86_PMC_IDX_FIXED_BTS, 0);
+
+static void intel_pmu_enable_bts(u64 config)
+{
+	unsigned long debugctlmsr;
+
+	debugctlmsr = get_debugctlmsr();
+
+	debugctlmsr |= X86_DEBUGCTL_TR;
+	debugctlmsr |= X86_DEBUGCTL_BTS;
+	debugctlmsr |= X86_DEBUGCTL_BTINT;
+
+	if (!(config & ARCH_PERFMON_EVENTSEL_OS))
+		debugctlmsr |= X86_DEBUGCTL_BTS_OFF_OS;
+
+	if (!(config & ARCH_PERFMON_EVENTSEL_USR))
+		debugctlmsr |= X86_DEBUGCTL_BTS_OFF_USR;
+
+	update_debugctlmsr(debugctlmsr);
+}
+
+static void intel_pmu_disable_bts(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	unsigned long debugctlmsr;
+
+	if (!cpuc->ds)
+		return;
+
+	debugctlmsr = get_debugctlmsr();
+
+	debugctlmsr &=
+		~(X86_DEBUGCTL_TR | X86_DEBUGCTL_BTS | X86_DEBUGCTL_BTINT |
+		  X86_DEBUGCTL_BTS_OFF_OS | X86_DEBUGCTL_BTS_OFF_USR);
+
+	update_debugctlmsr(debugctlmsr);
+}
+
+static void intel_pmu_drain_bts_buffer(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct debug_store *ds = cpuc->ds;
+	struct bts_record {
+		u64	from;
+		u64	to;
+		u64	flags;
+	};
+	struct perf_event *event = cpuc->events[X86_PMC_IDX_FIXED_BTS];
+	struct bts_record *at, *top;
+	struct perf_output_handle handle;
+	struct perf_event_header header;
+	struct perf_sample_data data;
+	struct pt_regs regs;
+
+	if (!event)
+		return;
+
+	if (!ds)
+		return;
+
+	at  = (struct bts_record *)(unsigned long)ds->bts_buffer_base;
+	top = (struct bts_record *)(unsigned long)ds->bts_index;
+
+	if (top <= at)
+		return;
+
+	ds->bts_index = ds->bts_buffer_base;
+
+	perf_sample_data_init(&data, 0);
+	data.period = event->hw.last_period;
+	regs.ip     = 0;
+
+	/*
+	 * Prepare a generic sample, i.e. fill in the invariant fields.
+	 * We will overwrite the from and to address before we output
+	 * the sample.
+	 */
+	perf_prepare_sample(&header, &data, event, &regs);
+
+	if (perf_output_begin(&handle, event, header.size * (top - at), 1, 1))
+		return;
+
+	for (; at < top; at++) {
+		data.ip		= at->from;
+		data.addr	= at->to;
+
+		perf_output_sample(&handle, &header, &data, event);
+	}
+
+	perf_output_end(&handle);
+
+	/* There's new data available. */
+	event->hw.interrupts++;
+	event->pending_kill = POLL_IN;
+}
+
+/*
+ * PEBS
+ */
+
+static struct event_constraint intel_core_pebs_events[] = {
+	PEBS_EVENT_CONSTRAINT(0x00c0, 0x1), /* INSTR_RETIRED.ANY */
+	PEBS_EVENT_CONSTRAINT(0xfec1, 0x1), /* X87_OPS_RETIRED.ANY */
+	PEBS_EVENT_CONSTRAINT(0x00c5, 0x1), /* BR_INST_RETIRED.MISPRED */
+	PEBS_EVENT_CONSTRAINT(0x1fc7, 0x1), /* SIMD_INST_RETURED.ANY */
+	PEBS_EVENT_CONSTRAINT(0x01cb, 0x1), /* MEM_LOAD_RETIRED.L1D_MISS */
+	PEBS_EVENT_CONSTRAINT(0x02cb, 0x1), /* MEM_LOAD_RETIRED.L1D_LINE_MISS */
+	PEBS_EVENT_CONSTRAINT(0x04cb, 0x1), /* MEM_LOAD_RETIRED.L2_MISS */
+	PEBS_EVENT_CONSTRAINT(0x08cb, 0x1), /* MEM_LOAD_RETIRED.L2_LINE_MISS */
+	PEBS_EVENT_CONSTRAINT(0x10cb, 0x1), /* MEM_LOAD_RETIRED.DTLB_MISS */
+	EVENT_CONSTRAINT_END
+};
+
+static struct event_constraint intel_nehalem_pebs_events[] = {
+	PEBS_EVENT_CONSTRAINT(0x00c0, 0xf), /* INSTR_RETIRED.ANY */
+	PEBS_EVENT_CONSTRAINT(0xfec1, 0xf), /* X87_OPS_RETIRED.ANY */
+	PEBS_EVENT_CONSTRAINT(0x00c5, 0xf), /* BR_INST_RETIRED.MISPRED */
+	PEBS_EVENT_CONSTRAINT(0x1fc7, 0xf), /* SIMD_INST_RETURED.ANY */
+	PEBS_EVENT_CONSTRAINT(0x01cb, 0xf), /* MEM_LOAD_RETIRED.L1D_MISS */
+	PEBS_EVENT_CONSTRAINT(0x02cb, 0xf), /* MEM_LOAD_RETIRED.L1D_LINE_MISS */
+	PEBS_EVENT_CONSTRAINT(0x04cb, 0xf), /* MEM_LOAD_RETIRED.L2_MISS */
+	PEBS_EVENT_CONSTRAINT(0x08cb, 0xf), /* MEM_LOAD_RETIRED.L2_LINE_MISS */
+	PEBS_EVENT_CONSTRAINT(0x10cb, 0xf), /* MEM_LOAD_RETIRED.DTLB_MISS */
+	EVENT_CONSTRAINT_END
+};
+
+static struct event_constraint *
+intel_pebs_constraints(struct perf_event *event)
+{
+	struct event_constraint *c;
+
+	if (!event->attr.precise)
+		return NULL;
+
+	if (x86_pmu.pebs_constraints) {
+		for_each_event_constraint(c, x86_pmu.pebs_constraints) {
+			if ((event->hw.config & c->cmask) == c->code)
+				return c;
+		}
+	}
+
+	return &emptyconstraint;
+}
+
+static void intel_pmu_pebs_enable(struct hw_perf_event *hwc)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	u64 val = cpuc->pebs_enabled;
+
+	hwc->config &= ~ARCH_PERFMON_EVENTSEL_INT;
+
+	val |= 1ULL << hwc->idx;
+	wrmsrl(MSR_IA32_PEBS_ENABLE, val);
+}
+
+static void intel_pmu_pebs_disable(struct hw_perf_event *hwc)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	u64 val = cpuc->pebs_enabled;
+
+	val &= ~(1ULL << hwc->idx);
+	wrmsrl(MSR_IA32_PEBS_ENABLE, val);
+
+	hwc->config |= ARCH_PERFMON_EVENTSEL_INT;
+}
+
+static void intel_pmu_pebs_enable_all(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	if (cpuc->pebs_enabled)
+		wrmsrl(MSR_IA32_PEBS_ENABLE, cpuc->pebs_enabled);
+}
+
+static void intel_pmu_pebs_disable_all(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	if (cpuc->pebs_enabled)
+		wrmsrl(MSR_IA32_PEBS_ENABLE, 0);
+}
+
+static int intel_pmu_save_and_restart(struct perf_event *event);
+static void intel_pmu_disable_event(struct perf_event *event);
+
+static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct debug_store *ds = cpuc->ds;
+	struct perf_event *event = cpuc->events[0]; /* PMC0 only */
+	struct pebs_record_core *at, *top;
+	struct perf_sample_data data;
+	struct pt_regs regs;
+	int n;
+
+	if (!event || !ds || !x86_pmu.pebs)
+		return;
+
+	intel_pmu_pebs_disable_all();
+
+	at  = (struct pebs_record_core *)(unsigned long)ds->pebs_buffer_base;
+	top = (struct pebs_record_core *)(unsigned long)ds->pebs_index;
+
+	if (top <= at)
+		goto out;
+
+	ds->pebs_index = ds->pebs_buffer_base;
+
+	if (!intel_pmu_save_and_restart(event))
+		goto out;
+
+	perf_sample_data_init(&data, 0);
+	data.period = event->hw.last_period;
+
+	n = top - at;
+
+	/*
+	 * Should not happen, we program the threshold at 1 and do not
+	 * set a reset value.
+	 */
+	WARN_ON_ONCE(n > 1);
+
+	/*
+	 * We use the interrupt regs as a base because the PEBS record
+	 * does not contain a full regs set, specifically it seems to
+	 * lack segment descriptors, which get used by things like
+	 * user_mode().
+	 *
+	 * In the simple case fix up only the IP and BP,SP regs, for
+	 * PERF_SAMPLE_IP and PERF_SAMPLE_CALLCHAIN to function properly.
+	 * A possible PERF_SAMPLE_REGS will have to transfer all regs.
+	 */
+	regs = *iregs;
+	regs.ip = at->ip;
+	regs.bp = at->bp;
+	regs.sp = at->sp;
+
+	if (perf_event_overflow(event, 1, &data, &regs))
+		intel_pmu_disable_event(event);
+
+out:
+	intel_pmu_pebs_enable_all();
+}
+
+static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct debug_store *ds = cpuc->ds;
+	struct pebs_record_nhm *at, *top;
+	struct perf_sample_data data;
+	struct perf_event *event = NULL;
+	struct pt_regs regs;
+	int bit, n;
+
+	if (!ds || !x86_pmu.pebs)
+		return;
+
+	intel_pmu_pebs_disable_all();
+
+	at  = (struct pebs_record_nhm *)(unsigned long)ds->pebs_buffer_base;
+	top = (struct pebs_record_nhm *)(unsigned long)ds->pebs_index;
+
+	if (top <= at)
+		goto out;
+
+	ds->pebs_index = ds->pebs_buffer_base;
+
+	n = top - at;
+
+	/*
+	 * Should not happen, we program the threshold at 1 and do not
+	 * set a reset value.
+	 */
+	WARN_ON_ONCE(n > MAX_PEBS_EVENTS);
+
+	for ( ; at < top; at++) {
+		for_each_bit(bit, (unsigned long *)&at->status, MAX_PEBS_EVENTS) {
+			if (!cpuc->events[bit]->attr.precise)
+				continue;
+
+			event = cpuc->events[bit];
+		}
+
+		if (!event)
+			continue;
+
+		if (!intel_pmu_save_and_restart(event))
+			continue;
+
+		perf_sample_data_init(&data, 0);
+		data.period = event->hw.last_period;
+
+		/*
+		 * See the comment in intel_pmu_drain_pebs_core()
+		 */
+		regs = *iregs;
+		regs.ip = at->ip;
+		regs.bp = at->bp;
+		regs.sp = at->sp;
+
+		if (perf_event_overflow(event, 1, &data, &regs))
+			intel_pmu_disable_event(event);
+	}
+out:
+	intel_pmu_pebs_enable_all();
+}
+
+/*
+ * BTS, PEBS probe and setup
+ */
+
+static void intel_ds_init(void)
+{
+	/*
+	 * No support for 32bit formats
+	 */
+	if (!boot_cpu_has(X86_FEATURE_DTES64))
+		return;
+
+	x86_pmu.bts  = boot_cpu_has(X86_FEATURE_BTS);
+	x86_pmu.pebs = boot_cpu_has(X86_FEATURE_PEBS);
+	if (x86_pmu.pebs) {
+		int format = 0;
+
+		if (x86_pmu.version > 1) {
+			u64 capabilities;
+			/*
+			 * v2+ has a PEBS format field
+			 */
+			rdmsrl(MSR_IA32_PERF_CAPABILITIES, capabilities);
+			format = (capabilities >> 8) & 0xf;
+		}
+
+		switch (format) {
+		case 0:
+			printk(KERN_CONT "PEBS v0, ");
+			x86_pmu.pebs_record_size = sizeof(struct pebs_record_core);
+			x86_pmu.drain_pebs = intel_pmu_drain_pebs_core;
+			x86_pmu.pebs_constraints = intel_core_pebs_events;
+			break;
+
+		case 1:
+			printk(KERN_CONT "PEBS v1, ");
+			x86_pmu.pebs_record_size = sizeof(struct pebs_record_nhm);
+			x86_pmu.drain_pebs = intel_pmu_drain_pebs_nhm;
+			x86_pmu.pebs_constraints = intel_nehalem_pebs_events;
+			break;
+
+		default:
+			printk(KERN_CONT "PEBS unknown format: %d, ", format);
+			x86_pmu.pebs = 0;
+			break;
+		}
+	}
+}
+
+#else /* CONFIG_CPU_SUP_INTEL */
+
+static int reseve_ds_buffers(void)
+{
+	return 0;
+}
+
+static void release_ds_buffers(void)
+{
+}
+
+#endif /* CONFIG_CPU_SUP_INTEL */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 80acbf3..42307b5 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -203,8 +203,9 @@ struct perf_event_attr {
 				enable_on_exec :  1, /* next exec enables     */
 				task           :  1, /* trace fork/exit       */
 				watermark      :  1, /* wakeup_watermark      */
+				precise        :  1, /* OoO invariant counter */
 
-				__reserved_1   : 49;
+				__reserved_1   : 48;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
