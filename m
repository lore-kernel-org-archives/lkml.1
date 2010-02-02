Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab0BBQ4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 11:56:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:38797 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab0BBQ4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 11:56:42 -0500
Subject: [RFC][PATCH] perf_events, x86: PEBS support
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       "David S. Miller" <davem@davemloft.net>,
       Jamie Iles <jamie.iles@picochip.com>, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Feb 2010 17:56:12 +0100
Message-ID: <1265129772.24455.329.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Totally uncompiled and untested, but it looks to be about mostly there
so I thought I'd post it.

One of the things that is missing is keeping the count value sane while
using PEBS -- another is dealing with auto frequency things, I thought
about single shot PEBS assist for that.

After this we can do something like PERF_SAMPLE_REGS, but for that we
need to think about how to expose pt_regs to userspace or something (or
maybe it already is, I haven't checked).

Also, initially I'll go through all the other hw perf implementations
(powerpc, sparc, arm, sh) and make then refuse to create attr.precise
counters -- precise meaning the reported IP is not influenced by OoO
artefacts.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_event.c |  354 ++++++++++++++++++++++++++++++++++-----
 include/linux/perf_event.h       |    4 
 2 files changed, 314 insertions(+), 44 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -38,11 +38,28 @@ static u64 perf_event_mask __read_mostly
 #define BTS_RECORD_SIZE		24
 
 /* The size of a per-cpu BTS buffer in bytes: */
-#define BTS_BUFFER_SIZE		(BTS_RECORD_SIZE * 2048)
+#define BTS_BUFFER_SIZE		(PAGE_SIZE << 4)
 
-/* The BTS overflow threshold in bytes from the end of the buffer: */
-#define BTS_OVFL_TH		(BTS_RECORD_SIZE * 128)
+#define PEBS_BUFFER_SIZE	(PAGE_SIZE << 4)
 
+struct pebs_record_core {
+	u64 eflags, eip;
+	u64 eax, ebc, ecx, edx;
+	u64 esi, edi, ebp, esp;
+	u64 r8,  r9,  r10, r11;
+	u64 r12, r13, r14, r15;
+}; /* size: 0x90 bytes */
+
+struct pebs_record_nhm {
+	u64 eflags, eip;
+	u64 eax, ebc, ecx, edx;
+	u64 esi, edi, ebp, esp;
+	u64 r8,  r9,  r10, r11;
+	u64 r12, r13, r14, r15;
+	u64 status, dla, dse, lat;
+}; /* size: 0xB0 bytes */
+
+static int pebs_record_size;
 
 /*
  * Bits in the debugctlmsr controlling branch tracing.
@@ -104,12 +121,24 @@ struct cpu_hw_events {
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
 	EVENT_CONSTRAINT(c, n, INTEL_ARCH_FIXED_MASK)
 
+/*
+ * Constraint on the Event code + UMask
+ */
+#define PEBS_EVENT_CONSTRAINT(c, n)	\
+	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
+
 #define EVENT_CONSTRAINT_END		\
 	EVENT_CONSTRAINT(0, 0, 0)
 
@@ -136,11 +165,12 @@ struct x86_pmu {
 	int		num_events_fixed;
 	int		event_bits;
 	u64		event_mask;
-	int		apic;
+	int		apic, bts, pebs;
 	u64		max_period;
 	u64		intel_ctrl;
-	void		(*enable_bts)(u64 config);
-	void		(*disable_bts)(void);
+
+	void		(*drain_pebs)(struct cpu_hw_events *cpuc);
+	struct event_constraint *pebs_constraints;
 
 	struct event_constraint *
 			(*get_event_constraints)(struct cpu_hw_events *cpuc,
@@ -303,6 +333,32 @@ static struct event_constraint intel_gen
 	EVENT_CONSTRAINT_END
 };
 
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
 static u64 intel_pmu_event_map(int hw_event)
 {
 	return intel_perfmon_event_map[hw_event];
@@ -937,11 +993,6 @@ static void release_pmc_hardware(void)
 #endif
 }
 
-static inline bool bts_available(void)
-{
-	return x86_pmu.enable_bts != NULL;
-}
-
 static inline void init_debug_store_on_cpu(int cpu)
 {
 	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
@@ -962,11 +1013,11 @@ static inline void fini_debug_store_on_c
 	wrmsr_on_cpu(cpu, MSR_IA32_DS_AREA, 0, 0);
 }
 
-static void release_bts_hardware(void)
+static void release_ds_buffers(void)
 {
 	int cpu;
 
-	if (!bts_available())
+	if (!x86_pmu.bts && !x86_pmu.pebs)
 		return;
 
 	get_online_cpus();
@@ -982,6 +1033,7 @@ static void release_bts_hardware(void)
 
 		per_cpu(cpu_hw_events, cpu).ds = NULL;
 
+		kfree((void *)(unsigned long)ds->pebs_buffer_base);
 		kfree((void *)(unsigned long)ds->bts_buffer_base);
 		kfree(ds);
 	}
@@ -989,43 +1041,65 @@ static void release_bts_hardware(void)
 	put_online_cpus();
 }
 
-static int reserve_bts_hardware(void)
+static int reserve_ds_buffers(void)
 {
 	int cpu, err = 0;
 
-	if (!bts_available())
-		return 0;
+	if (!x86_pmu.bts && !x86_pmu.pebs)
+		return;
 
 	get_online_cpus();
 
 	for_each_possible_cpu(cpu) {
 		struct debug_store *ds;
 		void *buffer;
+		int max, thresh;
 
 		err = -ENOMEM;
-		buffer = kzalloc(BTS_BUFFER_SIZE, GFP_KERNEL);
-		if (unlikely(!buffer))
-			break;
-
 		ds = kzalloc(sizeof(*ds), GFP_KERNEL);
 		if (unlikely(!ds)) {
 			kfree(buffer);
 			break;
 		}
 
-		ds->bts_buffer_base = (u64)(unsigned long)buffer;
-		ds->bts_index = ds->bts_buffer_base;
-		ds->bts_absolute_maximum =
-			ds->bts_buffer_base + BTS_BUFFER_SIZE;
-		ds->bts_interrupt_threshold =
-			ds->bts_absolute_maximum - BTS_OVFL_TH;
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
 
-		per_cpu(cpu_hw_events, cpu).ds = ds;
+			max = PEBS_BUFFER_SIZE / pebs_record_size;
+			thresh = max / 16;
+
+			ds->pebs_buffer_base = (u64)(unsigned long)buffer;
+			ds->pebs_index = ds->pebs_buffer_base;
+			ds->pebs_absolute_maximum = ds->pebs_buffer_base +
+				max * pebs_record_size;
+			ds->pebs_interrupt_threshold = ds->pebs_absolute_maximum -
+				thresh * pebs_record_size;
+
+			per_cpu(cpu_hw_events, cpu).ds = ds;
+		}
 		err = 0;
 	}
 
 	if (err)
-		release_bts_hardware();
+		release_ds_buffers();
 	else {
 		for_each_online_cpu(cpu)
 			init_debug_store_on_cpu(cpu);
@@ -1040,7 +1114,7 @@ static void hw_perf_event_destroy(struct
 {
 	if (atomic_dec_and_mutex_lock(&active_events, &pmc_reserve_mutex)) {
 		release_pmc_hardware();
-		release_bts_hardware();
+		release_ds_buffers();
 		mutex_unlock(&pmc_reserve_mutex);
 	}
 }
@@ -1119,6 +1193,37 @@ static void intel_pmu_disable_bts(void)
 	update_debugctlmsr(debugctlmsr);
 }
 
+static void intel_pmu_pebs_enable(struct hw_perf_event *hwc)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int idx = hwc->idx;
+	u64 left;
+	u64 val;
+
+	left = min(hwc->sample_period, x86_pmu.max_period);
+	left = (u64)(-left) & x86_pmu.event_mask;
+
+	cpuc->ds->pebs_event_reset[idx] = left;
+	hwc->config &= ~ARCH_PERFMON_EVENTSEL_INT;
+
+	rdmsrl(MSR_IA32_PEBS_ENABLE, val);
+	val |= 1ULL << idx;
+	wrmsrl(MSR_IA32_PEBS_ENABLE, val);
+}
+
+static void intel_pmu_pebs_disable(struct hw_perf_event *hwc)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int idx = hwc->idx;
+	u64 val;
+
+	rdmsrl(MSR_IA32_PEBS_ENABLE, val);
+	val &= ~(1ULL << idx);
+	wrmsrl(MSR_IA32_PEBS_ENABLE, val);
+
+	hwc->config |= ARCH_PERFMON_EVENTSEL_INT;
+}
+
 /*
  * Setup the hardware configuration for a given attr_type
  */
@@ -1139,7 +1244,7 @@ static int __hw_perf_event_init(struct p
 			if (!reserve_pmc_hardware())
 				err = -EBUSY;
 			else
-				err = reserve_bts_hardware();
+				err = reserve_ds_buffers();
 		}
 		if (!err)
 			atomic_inc(&active_events);
@@ -1214,7 +1319,7 @@ static int __hw_perf_event_init(struct p
 	if ((attr->config == PERF_COUNT_HW_BRANCH_INSTRUCTIONS) &&
 	    (hwc->sample_period == 1)) {
 		/* BTS is not supported by this architecture. */
-		if (!bts_available())
+		if (!x86_pmu.bts)
 			return -EOPNOTSUPP;
 
 		/* BTS is currently only allowed for user-mode. */
@@ -1646,6 +1751,9 @@ intel_pmu_disable_event(struct hw_perf_e
 	}
 
 	x86_pmu_disable_event(hwc, idx);
+
+	if (unlikely(hwc->pebs))
+		intel_pmu_pebs_disable(hwc);
 }
 
 static DEFINE_PER_CPU(u64 [X86_PMC_IDX_MAX], pmc_prev_left);
@@ -1767,6 +1875,9 @@ static void intel_pmu_enable_event(struc
 		return;
 	}
 
+	if (unlikely(hwc->pebs))
+		intel_pmu_pebs_enable(hwc);
+
 	__x86_pmu_enable_event(hwc, idx);
 }
 
@@ -1920,8 +2031,7 @@ static void intel_pmu_drain_bts_buffer(s
 	 */
 	perf_prepare_sample(&header, &data, event, &regs);
 
-	if (perf_output_begin(&handle, event,
-			      header.size * (top - at), 1, 1))
+	if (perf_output_begin(&handle, event, header.size * (top - at), 1, 1))
 		return;
 
 	for (; at < top; at++) {
@@ -1938,6 +2048,106 @@ static void intel_pmu_drain_bts_buffer(s
 	event->pending_kill = POLL_IN;
 }
 
+static void intel_pmu_drain_pebs_core(struct cpu_hw_events *cpuc)
+{
+	struct debug_store *ds = cpuc->ds;
+	struct perf_event *event = cpuc->events[0]; /* PMC0 only */
+	struct pebs_record_core *at, *top;
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
+	at  = (struct pebs_record_core *)(unsigned long)ds->pebs_buffer_base;
+	top = (struct pebs_record_core *)(unsigned long)ds->pebs_index;
+
+	if (top <= at)
+		return;
+
+	ds->pebs_index = ds->pebs_buffer_base;
+
+	data.period	= event->hw.last_period;
+	data.addr	= 0;
+	data.raw	= NULL;
+	regs.ip		= 0;
+
+	perf_prepare_sample(&header, &data, event, &regs);
+
+	if (perf_output_begin(&handle, event, header.size * (top - at), 1, 1))
+		return;
+
+	for (; at < top; at++) {
+		data.ip = at->eip;
+
+		perf_output_sample(&handle, &header, &data, event);
+	}
+
+	perf_output_end(&handle);
+
+	event->hw.interrupts++;
+	event->pending_kill = POLL_IN;
+}
+
+static void intel_pmu_drain_pebs_nhm(struct cpu_hw_events *cpuc)
+{
+	struct debug_store *ds = cpuc->ds;
+	struct pebs_record_core *at, *top;
+	struct perf_output_handle handle;
+	struct perf_event_header header;
+	struct perf_sample_data data;
+	struct perf_event *event;
+	struct pt_regs regs;
+
+	if (!ds)
+		return;
+
+	at  = (struct pebs_record_core *)(unsigned long)ds->pebs_buffer_base;
+	top = (struct pebs_record_core *)(unsigned long)ds->pebs_index;
+
+	if (top <= at)
+		return;
+
+	ds->pebs_index = ds->pebs_buffer_base;
+
+	for (; at < top; at++) {
+		for (i = 0; i < x86_pmu.num_events; i++) {
+			event = cpuc->events[i];
+
+			if (!event || !event->attr.precise)
+				continue;
+
+			if (!(at->status & (1ULL << i)))
+				continue;
+
+			break;
+		}
+		if (i == x86_pmu.num_events)
+			continue;
+
+		data.period	= event->hw.last_period;
+		data.addr	= 0;
+		data.raw	= NULL;
+		regs.ip		= at->eip;
+
+		perf_prepare_sample(&header, &data, event, &regs);
+
+		if (perf_output_begin(&handle, event, header.size, 1, 1))
+			continue;
+
+		perf_output_sample(&handle, &header, &data, event);
+		perf_output_end(&handle);
+
+		event->hw.interrupts++;
+		event->pending_kill = POLL_IN;
+	}
+}
+
 static void __x86_pmu_disable(struct perf_event *event, struct cpu_hw_events *cpuc)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -2209,8 +2419,8 @@ perf_event_nmi_handler(struct notifier_b
 	return NOTIFY_STOP;
 }
 
-static struct event_constraint unconstrained;
-
+static struct event_constraint unconstrained;	/* can schedule */
+static struct event_constraint null_constraint; /* can't schedule */
 static struct event_constraint bts_constraint =
 	EVENT_CONSTRAINT(0, 1ULL << X86_PMC_IDX_FIXED_BTS, 0);
 
@@ -2233,20 +2443,28 @@ intel_special_constraints(struct perf_ev
 static struct event_constraint *
 intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
-	struct event_constraint *c;
+	struct event_constraint *constraints = x86_pmu.event_constraints;
+	struct event_constraint *i, *c = &unconstrained;
 
 	c = intel_special_constraints(event);
 	if (c)
 		return c;
 
-	if (x86_pmu.event_constraints) {
-		for_each_event_constraint(c, x86_pmu.event_constraints) {
-			if ((event->hw.config & c->cmask) == c->code)
-				return c;
+	if (event->attr.precise) {
+		constraints = x86_pmu.pebs_constraints;
+		c = &null_constraint;
+	}
+
+	if (constraints) {
+		for_each_event_constraint(i, constraints) {
+			if ((event->hw.config & i->cmask) == i->code) {
+				c = i;
+				break;
+			}
 		}
 	}
 
-	return &unconstrained;
+	return c;
 }
 
 static struct event_constraint *
@@ -2442,8 +2660,6 @@ static __initconst struct x86_pmu intel_
 	 * the generic event period:
 	 */
 	.max_period		= (1ULL << 31) - 1,
-	.enable_bts		= intel_pmu_enable_bts,
-	.disable_bts		= intel_pmu_disable_bts,
 	.get_event_constraints	= intel_get_event_constraints
 };
 
@@ -2500,6 +2716,7 @@ static __init int intel_pmu_init(void)
 	unsigned int unused;
 	unsigned int ebx;
 	int version;
+	u64 capabilities;
 
 	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
 		/* check for P6 processor family */
@@ -2536,6 +2753,42 @@ static __init int intel_pmu_init(void)
 	if (version > 1)
 		x86_pmu.num_events_fixed = max((int)edx.split.num_events_fixed, 3);
 
+	if (!boot_cpu_has(X86_FEATURE_DTES64))
+		goto no_datastore;
+
+	x86_pmu.bts  = boot_cpu_has(X86_FEATURE_BTS);
+	x86_pmu.pebs = boot_cpu_has(X86_FEATURE_PEBS);
+	if (x86_pmu.pebs) {
+		int format = 0;
+
+		if (version > 1) {
+			/*
+			 * v2+ has a PEBS format field
+			 */
+			rdmsrl(MSR_IA32_PERF_CAPABILITIES, capabilities);
+			format = (capabilities >> 8) & 0xf;
+		}
+
+		switch (format) {
+		case 0:
+			pebs_record_size = sizeof(pebs_record_core);
+			x86_pmu.drain_pebs = intel_pmu_drain_pebs_core;
+			x86_pmu.pebs_constraints = intel_core_pebs_events;
+			break;
+
+		case 1:
+			pebs_record_size = sizeof(pebs_record_nhm);
+			x86_pmu.drain_pebs = intel_pmu_drain_pebs_nhm;
+			x86_pmu.pebs_constraints = intel_nehalem_pebs_events;
+			break;
+
+		default:
+			x86_pmu.pebs = 0;
+			break;
+		}
+	}
+no_datastore:
+
 	/*
 	 * Install the hw-cache-events table:
 	 */
@@ -2695,6 +2948,19 @@ static const struct pmu pmu = {
 };
 
 /*
+ * validate that we can schedule this event
+ */
+static int validate_event(struct perf_event *event)
+{
+	struct event_constraint *c = x86_pmu.get_event_constraints(event);
+
+	if (!c || !c->weight)
+		return -ENOSPC;
+
+	return 0;
+}
+
+/*
  * validate a single event group
  *
  * validation include:
@@ -2759,6 +3025,8 @@ const struct pmu *hw_perf_event_init(str
 
 		if (event->group_leader != event)
 			err = validate_group(event);
+		else
+			err = validate_event(event);
 
 		event->pmu = tmp;
 	}
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -203,8 +203,9 @@ struct perf_event_attr {
 				enable_on_exec :  1, /* next exec enables     */
 				task           :  1, /* trace fork/exit       */
 				watermark      :  1, /* wakeup_watermark      */
+				precise        :  1,
 
-				__reserved_1   : 49;
+				__reserved_1   : 48;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -483,6 +484,7 @@ struct hw_perf_event {
 			unsigned long	event_base;
 			int		idx;
 			int		last_cpu;
+			int		pebs;
 		};
 		struct { /* software */
 			s64		remaining;


