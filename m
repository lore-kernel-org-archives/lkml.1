Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596Ab0AVP7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab0AVP7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 10:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570Ab0AVP7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 10:59:44 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41707 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab0AVP7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 10:59:42 -0500
Message-Id: <20100122155535.887853503@chello.nl>
References: <20100122155044.391857484@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 22 Jan 2010 16:50:52 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@google.com, fweisbec@gmail.com, paulus@samba.org, mingo@elte.hu,
       davem@davemloft.net, robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 08/10] perf_event: Optimize the constraint searching bits
Content-Disposition: inline; filename=perf-opt-constraint.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of copying bitmasks around, pass pointers to the constraint structure.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/x86/kernel/cpu/perf_event.c |   81 ++++++++++++++++++---------------------
 1 file changed, 38 insertions(+), 43 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -135,12 +138,14 @@ struct x86_pmu {
 	u64		intel_ctrl;
 	void		(*enable_bts)(u64 config);
 	void		(*disable_bts)(void);
-	void		(*get_event_constraints)(struct cpu_hw_events *cpuc,
-						 struct perf_event *event,
-						 unsigned long *idxmsk);
+
+	struct event_constraint *
+			(*get_event_constraints)(struct cpu_hw_events *cpuc,
+						 struct perf_event *event);
+
 	void		(*put_event_constraints)(struct cpu_hw_events *cpuc,
 						 struct perf_event *event);
-	const struct event_constraint *event_constraints;
+	struct event_constraint *event_constraints;
 };
 
 static struct x86_pmu x86_pmu __read_mostly;
@@ -1244,18 +1249,16 @@ static inline int is_x86_event(struct pe
 static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 {
 	int i, j , w, num;
-	int weight, wmax;
-	unsigned long *c;
-	unsigned long constraints[X86_PMC_IDX_MAX][BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	int weight, wmax;
+	struct event_constraint *c, *constraints[X86_PMC_IDX_MAX];
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	struct hw_perf_event *hwc;
 
 	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
 
 	for (i = 0; i < n; i++) {
-		x86_pmu.get_event_constraints(cpuc,
-					      cpuc->event_list[i],
-					      constraints[i]);
+		constraints[i] =
+		  x86_pmu.get_event_constraints(cpuc, cpuc->event_list[i]);
 	}
 
 	/*
@@ -1270,7 +1273,7 @@ static int x86_schedule_events(struct cp
 			break;
 
 		/* constraint still honored */
-		if (!test_bit(hwc->idx, c))
+		if (!test_bit(hwc->idx, c->idxmsk))
 			break;
 
 		/* not already used */
@@ -1323,11 +1326,11 @@ static int x86_schedule_events(struct cp
 			c = constraints[i];
 			hwc = &cpuc->event_list[i]->hw;
 
-			weight = bitmap_weight(c, X86_PMC_IDX_MAX);
+			weight = bitmap_weight(c->idxmsk, X86_PMC_IDX_MAX);
 			if (weight != w)
 				continue;
 
-			for_each_bit(j, c, X86_PMC_IDX_MAX) {
+			for_each_bit(j, c->idxmsk, X86_PMC_IDX_MAX) {
 				if (!test_bit(j, used_mask))
 					break;
 			}
@@ -2165,11 +2167,13 @@ perf_event_nmi_handler(struct notifier_b
 	return NOTIFY_STOP;
 }
 
+static struct event_constraint unconstrained;
+
 static struct event_constraint bts_constraint =
 	EVENT_CONSTRAINT(0, 1ULL << X86_PMC_IDX_FIXED_BTS, 0);
 
-static int intel_special_constraints(struct perf_event *event,
-				     unsigned long *idxmsk)
+static struct event_constraint *
+intel_special_constraints(struct perf_event *event)
 {
 	unsigned int hw_event;
 
@@ -2179,46 +2183,34 @@ static int intel_special_constraints(str
 		      x86_pmu.event_map(PERF_COUNT_HW_BRANCH_INSTRUCTIONS)) &&
 		     (event->hw.sample_period == 1))) {
 
-		bitmap_copy((unsigned long *)idxmsk,
-			    (unsigned long *)bts_constraint.idxmsk,
-			    X86_PMC_IDX_MAX);
-		return 1;
+		return &bts_constraint;
 	}
-	return 0;
+	return NULL;
 }
 
-static void intel_get_event_constraints(struct cpu_hw_events *cpuc,
-					struct perf_event *event,
-					unsigned long *idxmsk)
+static struct event_constraint *
+intel_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
-	const struct event_constraint *c;
+	struct event_constraint *c;
 
-	/*
-	 * cleanup bitmask
-	 */
-	bitmap_zero(idxmsk, X86_PMC_IDX_MAX);
-
-	if (intel_special_constraints(event, idxmsk))
-		return;
+	c = intel_special_constraints(event);
+	if (c)
+		return c;
 
 	if (x86_pmu.event_constraints) {
 		for_each_event_constraint(c, x86_pmu.event_constraints) {
-			if ((event->hw.config & c->cmask) == c->code) {
-				bitmap_copy(idxmsk, c->idxmsk, X86_PMC_IDX_MAX);
-				return;
-			}
+			if ((event->hw.config & c->cmask) == c->code)
+				return c;
 		}
 	}
-	/* no constraints, means supports all generic counters */
-	bitmap_fill((unsigned long *)idxmsk, x86_pmu.num_events);
+
+	return &unconstrained;
 }
 
-static void amd_get_event_constraints(struct cpu_hw_events *cpuc,
-				      struct perf_event *event,
-				      unsigned long *idxmsk)
+static struct event_constraint *
+amd_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
 {
-	/* no constraints, means supports all generic counters */
-	bitmap_fill(idxmsk, x86_pmu.num_events);
+	return &unconstrained;
 }
 
 static int x86_event_sched_in(struct perf_event *event,
@@ -2586,6 +2578,9 @@ void __init init_hw_perf_events(void)
 	perf_events_lapic_init();
 	register_die_notifier(&perf_event_nmi_notifier);
 
+	unconstrained = (struct event_constraint)
+		EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_events) - 1, 0);
+
 	pr_info("... version:                %d\n",     x86_pmu.version);
 	pr_info("... bit width:              %d\n",     x86_pmu.event_bits);
 	pr_info("... generic registers:      %d\n",     x86_pmu.num_events);

-- 

