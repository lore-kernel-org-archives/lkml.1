Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab0CCQrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:47:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:46185 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab0CCQpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:45:23 -0500
Message-Id: <20100303164306.526626387@chello.nl>
References: <20100303163936.906011640@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 03 Mar 2010 17:39:45 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: paulus@samba.org, eranian@google.com, robert.richter@amd.com,
       fweisbec@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 09/11] perf, x86: Implement PERF_SAMPLE_BRANCH_STACK
Content-Disposition: inline; filename=perf-sample-lbr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_event.c           |   14 +++-------
 arch/x86/kernel/cpu/perf_event_intel.c     |   10 ++++++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c  |   16 ++++--------
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   20 ++++++++-------
 include/linux/perf_event.h                 |   27 +++++++++++++++++---
 kernel/perf_event.c                        |   38 ++++++++++++++++++++++-------
 6 files changed, 83 insertions(+), 42 deletions(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -126,8 +126,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_STREAM_ID			= 1U << 9,
 	PERF_SAMPLE_RAW				= 1U << 10,
 	PERF_SAMPLE_REGS			= 1U << 11,
+	PERF_SAMPLE_BRANCH_STACK		= 1U << 12,
 
-	PERF_SAMPLE_MAX = 1U << 12,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 13,		/* non-ABI */
 };
 
 /*
@@ -395,9 +396,14 @@ enum perf_event_type {
 	 *	{ struct read_format	values;	  } && PERF_SAMPLE_READ
 	 * 	{ struct pt_regs	regs;	  } && PERF_SAMPLE_REGS
 	 *
-	 *	{ u64			nr,
+	 *	{ u64			nr;
 	 *	  u64			ips[nr];  } && PERF_SAMPLE_CALLCHAIN
 	 *
+	 * 	{ u64			nr;
+	 * 	  { u64 from, to, flags;
+	 * 	  }			lbr[nr];  } && PERF_SAMPLE_BRANCH_STACK
+	 *
+	 *
 	 *	#
 	 *	# The RAW record below is opaque data wrt the ABI
 	 *	#
@@ -469,6 +475,17 @@ struct perf_raw_record {
 	void				*data;
 };
 
+struct perf_branch_entry {
+	__u64				from;
+	__u64				to;
+	__u64				flags;
+};
+
+struct perf_branch_stack {
+	__u64				nr;
+	struct perf_branch_entry	entries[0];
+};
+
 struct task_struct;
 
 /**
@@ -803,13 +820,15 @@ struct perf_sample_data {
 	struct perf_callchain_entry	*callchain;
 	struct perf_raw_record		*raw;
 	struct pt_regs			*regs;
+	struct perf_branch_stack	*branches;
 };
 
 static inline
 void perf_sample_data_init(struct perf_sample_data *data, u64 addr)
 {
-	data->addr = addr;
-	data->raw  = NULL;
+	data->addr     = addr;
+	data->raw      = NULL;
+	data->branches = NULL;
 }
 
 extern void perf_output_sample(struct perf_output_handle *handle,
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -3189,12 +3189,9 @@ void perf_output_sample(struct perf_outp
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		if (data->callchain) {
-			int size = 1;
+			int size = sizeof(u64);
 
-			if (data->callchain)
-				size += data->callchain->nr;
-
-			size *= sizeof(u64);
+			size += data->callchain->nr * sizeof(u64);
 
 			perf_output_copy(handle, data->callchain, size);
 		} else {
@@ -3203,6 +3200,20 @@ void perf_output_sample(struct perf_outp
 		}
 	}
 
+	if (sample_type & PERF_SAMPLE_BRANCH_STACK) {
+		if (data->branches) {
+			int size = sizeof(u64);
+
+			size += data->branches->nr *
+				sizeof(struct perf_branch_entry);
+
+			perf_output_copy(handle, data->branches, size);
+		} else {
+			u64 nr = 0;
+			perf_output_put(handle, nr);
+		}
+	}
+
 	if (sample_type & PERF_SAMPLE_RAW) {
 		if (data->raw) {
 			perf_output_put(handle, data->raw->size);
@@ -3291,14 +3302,25 @@ void perf_prepare_sample(struct perf_eve
 	}
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
-		int size = 1;
+		int size = sizeof(u64);
 
 		data->callchain = perf_callchain(regs);
 
 		if (data->callchain)
-			size += data->callchain->nr;
+			size += data->callchain->nr * sizeof(u64);
+
+		header->size += size;
+	}
 
-		header->size += size * sizeof(u64);
+	if (sample_type & PERF_SAMPLE_BRANCH_STACK) {
+		int size = sizeof(u64);
+
+		if (data->branches) {
+			size += data->branches->nr *
+				sizeof(struct perf_branch_entry);
+		}
+
+		header->size += size;
 	}
 
 	if (sample_type & PERF_SAMPLE_RAW) {
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -50,10 +50,6 @@ struct amd_nb {
 
 #define MAX_LBR_ENTRIES		16
 
-struct lbr_entry {
-	u64	from, to, flags;
-};
-
 struct cpu_hw_events {
 	/*
 	 * Generic x86 PMC bits
@@ -78,10 +74,10 @@ struct cpu_hw_events {
 	/*
 	 * Intel LBR bits
 	 */
-	int			lbr_users;
-	int			lbr_entries;
-	struct lbr_entry	lbr_stack[MAX_LBR_ENTRIES];
-	void			*lbr_context;
+	int				lbr_users;
+	void				*lbr_context;
+	struct perf_branch_stack	lbr_stack;
+	struct perf_branch_entry	lbr_entries[MAX_LBR_ENTRIES];
 
 	/*
 	 * AMD specific bits
@@ -166,7 +162,7 @@ struct x86_pmu {
 	 */
 	int		bts, pebs;
 	int		pebs_record_size;
-	void		(*drain_pebs)(void);
+	void		(*drain_pebs)(struct perf_sample_data *data);
 	struct event_constraint *pebs_constraints;
 
 	/*
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_lbr.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -138,11 +138,11 @@ static void intel_pmu_lbr_read_32(struct
 
 		rdmsrl(x86_pmu.lbr_from + lbr_idx, msr_lastbranch.lbr);
 
-		cpuc->lbr_stack[i].from  = msr_lastbranch.from;
-		cpuc->lbr_stack[i].to    = msr_lastbranch.to;
-		cpuc->lbr_stack[i].flags = 0;
+		cpuc->lbr_entries[i].from  = msr_lastbranch.from;
+		cpuc->lbr_entries[i].to    = msr_lastbranch.to;
+		cpuc->lbr_entries[i].flags = 0;
 	}
-	cpuc->lbr_entries = i;
+	cpuc->lbr_stack.nr = i;
 }
 
 #define LBR_FROM_FLAG_MISPRED  (1ULL << 63)
@@ -170,14 +170,14 @@ static void intel_pmu_lbr_read_64(struct
 			from = (u64)((((s64)from) << 1) >> 1);
 		}
 
-		cpuc->lbr_stack[i].from  = from;
-		cpuc->lbr_stack[i].to    = to;
-		cpuc->lbr_stack[i].flags = flags;
+		cpuc->lbr_entries[i].from  = from;
+		cpuc->lbr_entries[i].to    = to;
+		cpuc->lbr_entries[i].flags = flags;
 	}
-	cpuc->lbr_entries = i;
+	cpuc->lbr_stack.nr = i;
 }
 
-static void intel_pmu_lbr_read(void)
+static void intel_pmu_lbr_read(struct perf_sample_data *data)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -188,6 +188,8 @@ static void intel_pmu_lbr_read(void)
 		intel_pmu_lbr_read_32(cpuc);
 	else
 		intel_pmu_lbr_read_64(cpuc);
+
+	data->branches = &cpuc->lbr_stack;
 }
 
 static int intel_pmu_lbr_format(void)
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -548,6 +548,9 @@ static void intel_pmu_disable_event(stru
 
 	if (unlikely(event->attr.precise))
 		intel_pmu_pebs_disable(hwc);
+
+	if (event->attr.sample_type & PERF_SAMPLE_BRANCH_STACK)
+		intel_pmu_lbr_disable(event);
 }
 
 static void intel_pmu_enable_fixed(struct hw_perf_event *hwc)
@@ -602,6 +605,9 @@ static void intel_pmu_enable_event(struc
 	if (unlikely(event->attr.precise))
 		intel_pmu_pebs_enable(hwc);
 
+	if (event->attr.sample_type & PERF_SAMPLE_BRANCH_STACK)
+		intel_pmu_lbr_enable(event);
+
 	__x86_pmu_enable_event(hwc);
 }
 
@@ -677,13 +683,13 @@ again:
 	inc_irq_stat(apic_perf_irqs);
 	ack = status;
 
-	intel_pmu_lbr_read();
+	intel_pmu_lbr_read(&data);
 
 	/*
 	 * PEBS overflow sets bit 62 in the global status register
 	 */
 	if (__test_and_clear_bit(62, (unsigned long *)&status))
-		x86_pmu.drain_pebs();
+		x86_pmu.drain_pebs(&data);
 
 	for_each_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
 		struct perf_event *event = cpuc->events[bit];
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -418,13 +418,12 @@ do {						\
 static int intel_pmu_save_and_restart(struct perf_event *event);
 static void intel_pmu_disable_event(struct perf_event *event);
 
-static void intel_pmu_drain_pebs_core(void)
+static void intel_pmu_drain_pebs_core(struct perf_sample_data *data)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct debug_store *ds = cpuc->ds;
 	struct perf_event *event = cpuc->events[0]; /* PMC0 only */
 	struct pebs_record_core *at, *top;
-	struct perf_sample_data data;
 	struct pt_regs regs;
 	int n;
 
@@ -444,8 +443,7 @@ static void intel_pmu_drain_pebs_core(vo
 	if (!intel_pmu_save_and_restart(event))
 		goto out;
 
-	perf_sample_data_init(&data, 0);
-	data.period = event->hw.last_period;
+	data->period = event->hw.last_period;
 
 	n = top - at;
 
@@ -460,19 +458,18 @@ static void intel_pmu_drain_pebs_core(vo
 
 	PEBS_TO_REGS(at, &regs);
 
-	if (perf_event_overflow(event, 1, &data, &regs))
+	if (perf_event_overflow(event, 1, data, &regs))
 		intel_pmu_disable_event(event);
 
 out:
 	intel_pmu_pebs_enable_all();
 }
 
-static void intel_pmu_drain_pebs_nhm(void)
+static void intel_pmu_drain_pebs_nhm(struct perf_sample_data *data)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct debug_store *ds = cpuc->ds;
 	struct pebs_record_nhm *at, *top;
-	struct perf_sample_data data;
 	struct perf_event *event = NULL;
 	struct pt_regs regs;
 	int bit, n;
@@ -519,12 +516,11 @@ static void intel_pmu_drain_pebs_nhm(voi
 		if (!intel_pmu_save_and_restart(event))
 			continue;
 
-		perf_sample_data_init(&data, 0);
-		data.period = event->hw.last_period;
+		data->period = event->hw.last_period;
 
 		PEBS_TO_REGS(at, &regs);
 
-		if (perf_event_overflow(event, 1, &data, &regs))
+		if (perf_event_overflow(event, 1, data, &regs))
 			intel_pmu_disable_event(event);
 	}
 out:

-- 

