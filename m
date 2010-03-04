Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab0CDOET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 09:04:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:39705 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab0CDOB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 09:01:57 -0500
Message-Id: <20100304140100.998642700@chello.nl>
References: <20100304140046.596569763@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 04 Mar 2010 15:01:00 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: paulus@samba.org, eranian@google.com, robert.richter@amd.com,
       fweisbec@gmail.com, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 14/14] perf, x86: Implement PERF_SAMPLE_BRANCH_STACK
Content-Disposition: inline; filename=perf-sample-lbr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not for merging until there's a sensible use case implemented in
tools/perf as well.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/x86/kernel/cpu/perf_event.c           |    3 +-
 arch/x86/kernel/cpu/perf_event_intel.c     |   10 ++++++-
 arch/x86/kernel/cpu/perf_event_intel_ds.c  |   20 ++++++---------
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |    4 ++-
 include/linux/perf_event.h                 |   15 ++++++++---
 kernel/perf_event.c                        |   38 ++++++++++++++++++++++-------
 6 files changed, 62 insertions(+), 28 deletions(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -125,8 +125,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_PERIOD			= 1U << 8,
 	PERF_SAMPLE_STREAM_ID			= 1U << 9,
 	PERF_SAMPLE_RAW				= 1U << 10,
+	PERF_SAMPLE_BRANCH_STACK		= 1U << 11,
 
-	PERF_SAMPLE_MAX = 1U << 11,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 12,		/* non-ABI */
 };
 
 /*
@@ -399,9 +400,13 @@ enum perf_event_type {
 	 *
 	 *	{ struct read_format	values;	  } && PERF_SAMPLE_READ
 	 *
-	 *	{ u64			nr,
+	 *	{ u64			nr;
 	 *	  u64			ips[nr];  } && PERF_SAMPLE_CALLCHAIN
 	 *
+	 * 	{ u64			nr;
+	 * 	  { u64 from, to, flags;
+	 * 	  }			lbr[nr];  } && PERF_SAMPLE_BRANCH_STACK
+	 *
 	 *	#
 	 *	# The RAW record below is opaque data wrt the ABI
 	 *	#
@@ -817,13 +822,15 @@ struct perf_sample_data {
 	u64				period;
 	struct perf_callchain_entry	*callchain;
 	struct perf_raw_record		*raw;
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
@@ -3178,12 +3178,9 @@ void perf_output_sample(struct perf_outp
 
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
@@ -3192,6 +3189,20 @@ void perf_output_sample(struct perf_outp
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
@@ -3274,14 +3285,25 @@ void perf_prepare_sample(struct perf_eve
 		header->size += perf_event_read_size(event);
 
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
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -548,6 +548,9 @@ static void intel_pmu_disable_event(stru
 
 	if (unlikely(event->attr.precise))
 		intel_pmu_pebs_disable(event);
+
+	if (event->attr.sample_type & PERF_SAMPLE_BRANCH_STACK)
+		intel_pmu_lbr_disable(event);
 }
 
 static void intel_pmu_enable_fixed(struct hw_perf_event *hwc)
@@ -602,6 +605,9 @@ static void intel_pmu_enable_event(struc
 	if (unlikely(event->attr.precise))
 		intel_pmu_pebs_enable(event);
 
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
-		x86_pmu.drain_pebs(regs);
+		x86_pmu.drain_pebs(&data, regs);
 
 	for_each_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
 		struct perf_event *event = cpuc->events[bit];
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -448,13 +448,12 @@ static int intel_pmu_pebs_fixup_ip(struc
 static int intel_pmu_save_and_restart(struct perf_event *event);
 static void intel_pmu_disable_event(struct perf_event *event);
 
-static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
+static void intel_pmu_drain_pebs_core(struct perf_sample_data *data, struct pt_regs *iregs)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct debug_store *ds = cpuc->ds;
 	struct perf_event *event = cpuc->events[0]; /* PMC0 only */
 	struct pebs_record_core *at, *top;
-	struct perf_sample_data data;
 	struct perf_raw_record raw;
 	struct pt_regs regs;
 	int n;
@@ -475,8 +474,7 @@ static void intel_pmu_drain_pebs_core(st
 	if (!intel_pmu_save_and_restart(event))
 		goto out;
 
-	perf_sample_data_init(&data, 0);
-	data.period = event->hw.last_period;
+	data->period = event->hw.last_period;
 
 	n = top - at;
 
@@ -492,7 +490,7 @@ static void intel_pmu_drain_pebs_core(st
 	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
 		raw.size = x86_pmu.pebs_record_size;
 		raw.data = at;
-		data.raw = &raw;
+		data->raw = &raw;
 	}
 
 	/*
@@ -515,19 +513,18 @@ static void intel_pmu_drain_pebs_core(st
 	else
 		regs.flags &= ~PERF_EFLAGS_EXACT;
 
-	if (perf_event_overflow(event, 1, &data, &regs))
+	if (perf_event_overflow(event, 1, data, &regs))
 		intel_pmu_disable_event(event);
 
 out:
 	intel_pmu_pebs_enable_all();
 }
 
-static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
+static void intel_pmu_drain_pebs_nhm(struct perf_sample_data *data, struct pt_regs *iregs)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct debug_store *ds = cpuc->ds;
 	struct pebs_record_nhm *at, *top;
-	struct perf_sample_data data;
 	struct perf_event *event = NULL;
 	struct perf_raw_record raw;
 	struct pt_regs regs;
@@ -575,13 +572,12 @@ static void intel_pmu_drain_pebs_nhm(str
 		if (!intel_pmu_save_and_restart(event))
 			continue;
 
-		perf_sample_data_init(&data, 0);
-		data.period = event->hw.last_period;
+		data->period = event->hw.last_period;
 
 		if (event->attr.sample_type & PERF_SAMPLE_RAW) {
 			raw.size = x86_pmu.pebs_record_size;
 			raw.data = at;
-			data.raw = &raw;
+			data->raw = &raw;
 		}
 
 		/*
@@ -597,7 +593,7 @@ static void intel_pmu_drain_pebs_nhm(str
 		else
 			regs.flags &= ~PERF_EFLAGS_EXACT;
 
-		if (perf_event_overflow(event, 1, &data, &regs))
+		if (perf_event_overflow(event, 1, data, &regs))
 			intel_pmu_disable_event(event);
 	}
 out:
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -209,7 +209,8 @@ struct x86_pmu {
 	 */
 	int		bts, pebs;
 	int		pebs_record_size;
-	void		(*drain_pebs)(struct pt_regs *regs);
+	void		(*drain_pebs)(struct perf_sample_data *data,
+				      struct pt_regs *regs);
 	struct event_constraint *pebs_constraints;
 
 	/*
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_lbr.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -178,7 +178,7 @@ static void intel_pmu_lbr_read_64(struct
 	cpuc->lbr_stack.nr = i;
 }
 
-static void intel_pmu_lbr_read(void)
+static void intel_pmu_lbr_read(struct perf_sample_data *data)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
@@ -189,6 +189,8 @@ static void intel_pmu_lbr_read(void)
 		intel_pmu_lbr_read_32(cpuc);
 	else
 		intel_pmu_lbr_read_64(cpuc);
+
+	data->branches = &cpuc->lbr_stack;
 }
 
 static void intel_pmu_lbr_init_core(void)

-- 

