Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497Ab0AVP7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab0AVP7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 10:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463Ab0AVP7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 10:59:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:38262 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458Ab0AVP7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 10:59:32 -0500
Message-Id: <20100122155535.318710047@chello.nl>
References: <20100122155044.391857484@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 22 Jan 2010 16:50:46 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@google.com, fweisbec@gmail.com, paulus@samba.org, mingo@elte.hu,
       davem@davemloft.net, robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 02/10] perf_events: Add fast-path to the rescheduling code
Content-Disposition: inline; filename=stephane-perf_events-improve_x86_event_scheduling__v6_incremental.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 6th version does:
- implement correct fastpath scheduling, i.e., reuse previous assignment
- skip reprogramming counters in hw_perf_enable() with a generation number

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4b588464.1818d00a.4456.383b@mx.google.com>
---
 arch/x86/kernel/cpu/perf_event.c |  148 +++++++++++++++++++++++----------------
 include/linux/perf_event.h       |    2 
 2 files changed, 93 insertions(+), 57 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -87,6 +87,7 @@ struct cpu_hw_events {
 	int			n_events;
 	int			n_added;
 	int			assign[X86_PMC_IDX_MAX]; /* event to counter assignment */
+	u64			tags[X86_PMC_IDX_MAX];
 	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
 };
 
@@ -1013,6 +1014,8 @@ static int __hw_perf_event_init(struct p
 	hwc->config = ARCH_PERFMON_EVENTSEL_INT;
 
 	hwc->idx = -1;
+	hwc->last_cpu = -1;
+	hwc->last_tag = ~0ULL;
 
 	/*
 	 * Count user and OS events unless requested not to.
@@ -1245,6 +1248,46 @@ static int x86_schedule_events(struct cp
 	}
 
 	/*
+	 * fastpath, try to reuse previous register
+	 */
+	for (i = 0, num = n; i < n; i++, num--) {
+		hwc = &cpuc->event_list[i]->hw;
+		c = (unsigned long *)constraints[i];
+
+		/* never assigned */
+		if (hwc->idx == -1)
+			break;
+
+		/* constraint still honored */
+		if (!test_bit(hwc->idx, c))
+			break;
+
+		/* not already used */
+		if (test_bit(hwc->idx, used_mask))
+			break;
+
+#if 0
+		pr_debug("CPU%d fast config=0x%llx idx=%d assign=%c\n",
+			 smp_processor_id(),
+			 hwc->config,
+			 hwc->idx,
+			 assign ? 'y' : 'n');
+#endif
+
+		set_bit(hwc->idx, used_mask);
+		if (assign)
+			assign[i] = hwc->idx;
+	}
+	if (!num)
+		goto done;
+
+	/*
+	 * begin slow path
+	 */
+
+	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
+
+	/*
 	 * weight = number of possible counters
 	 *
 	 * 1    = most constrained, only works on one counter
@@ -1263,10 +1306,9 @@ static int x86_schedule_events(struct cp
 	if (x86_pmu.num_events_fixed)
 		wmax++;
 
-	num = n;
-	for (w = 1; num && w <= wmax; w++) {
+	for (w = 1, num = n; num && w <= wmax; w++) {
 		/* for each event */
-		for (i = 0; i < n; i++) {
+		for (i = 0; num && i < n; i++) {
 			c = (unsigned long *)constraints[i];
 			hwc = &cpuc->event_list[i]->hw;
 
@@ -1274,28 +1316,6 @@ static int x86_schedule_events(struct cp
 			if (weight != w)
 				continue;
 
-			/*
-			 * try to reuse previous assignment
-			 *
-			 * This is possible despite the fact that
-			 * events or events order may have changed.
-			 *
-			 * What matters is the level of constraints
-			 * of an event and this is constant for now.
-			 *
-			 * This is possible also because we always
-			 * scan from most to least constrained. Thus,
-			 * if a counter can be reused, it means no,
-			 * more constrained events, needed it. And
-			 * next events will either compete for it
-			 * (which cannot be solved anyway) or they
-			 * have fewer constraints, and they can use
-			 * another counter.
-			 */
-			j = hwc->idx;
-			if (j != -1 && !test_bit(j, used_mask))
-				goto skip;
-
 			for_each_bit(j, c, X86_PMC_IDX_MAX) {
 				if (!test_bit(j, used_mask))
 					break;
@@ -1303,22 +1323,23 @@ static int x86_schedule_events(struct cp
 
 			if (j == X86_PMC_IDX_MAX)
 				break;
-skip:
-			set_bit(j, used_mask);
 
 #if 0
-			pr_debug("CPU%d config=0x%llx idx=%d assign=%c\n",
+			pr_debug("CPU%d slow config=0x%llx idx=%d assign=%c\n",
 				smp_processor_id(),
 				hwc->config,
 				j,
 				assign ? 'y' : 'n');
 #endif
 
+			set_bit(j, used_mask);
+
 			if (assign)
 				assign[i] = j;
 			num--;
 		}
 	}
+done:
 	/*
 	 * scheduling failed or is just a simulation,
 	 * free resources if necessary
@@ -1357,7 +1378,7 @@ static int collect_events(struct cpu_hw_
 
 	list_for_each_entry(event, &leader->sibling_list, group_entry) {
 		if (!is_x86_event(event) ||
-		    event->state == PERF_EVENT_STATE_OFF)
+		    event->state <= PERF_EVENT_STATE_OFF)
 			continue;
 
 		if (n >= max_count)
@@ -1369,11 +1390,15 @@ static int collect_events(struct cpu_hw_
 	return n;
 }
 
-
 static inline void x86_assign_hw_event(struct perf_event *event,
-				struct hw_perf_event *hwc, int idx)
+				struct cpu_hw_events *cpuc,
+				int idx)
 {
+	struct hw_perf_event *hwc = &event->hw;
+
 	hwc->idx = idx;
+	hwc->last_cpu = smp_processor_id();
+	hwc->last_tag = ++cpuc->tags[idx];
 
 	if (hwc->idx == X86_PMC_IDX_FIXED_BTS) {
 		hwc->config_base = 0;
@@ -1392,6 +1417,14 @@ static inline void x86_assign_hw_event(s
 	}
 }
 
+static bool match_prev_assignment(struct hw_perf_event *hwc,
+				  struct cpu_hw_events *cpuc, int idx)
+{
+	return hwc->idx == cpuc->assign[idx] &&
+	       hwc->last_cpu == smp_processor_id() &&
+	       hwc->last_tag == cpuc->tags[idx];
+}
+
 void hw_perf_enable(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -1401,45 +1434,33 @@ void hw_perf_enable(void)
 
 	if (!x86_pmu_initialized())
 		return;
+
 	if (cpuc->n_added) {
 		/*
 		 * apply assignment obtained either from
 		 * hw_perf_group_sched_in() or x86_pmu_enable()
 		 *
-		 * step1: save events moving to new counters
-		 * step2: reprogram moved events into new counters
+		 * We either re-enable or re-program and re-enable.
+		 * All events are disabled by the time we come here.
+		 * That means their state has been saved already.
 		 */
 		for (i = 0; i < cpuc->n_events; i++) {
-
 			event = cpuc->event_list[i];
 			hwc = &event->hw;
 
-			if (hwc->idx == -1 || hwc->idx == cpuc->assign[i])
-				continue;
-
-			x86_pmu.disable(hwc, hwc->idx);
-
-			clear_bit(hwc->idx, cpuc->active_mask);
-			barrier();
-			cpuc->events[hwc->idx] = NULL;
-
-			x86_perf_event_update(event, hwc, hwc->idx);
-
-			hwc->idx = -1;
-		}
-
-		for (i = 0; i < cpuc->n_events; i++) {
-
-			event = cpuc->event_list[i];
-			hwc = &event->hw;
-
-			if (hwc->idx == -1) {
-				x86_assign_hw_event(event, hwc, cpuc->assign[i]);
+			/*
+			 * we can avoid reprogramming counter if:
+			 * - assigned same counter as last time
+			 * - running on same CPU as last time
+			 * - no other event has used the counter since
+			 */
+			if (!match_prev_assignment(hwc, cpuc, i)) {
+				x86_assign_hw_event(event, cpuc, cpuc->assign[i]);
 				x86_perf_event_set_period(event, hwc, hwc->idx);
 			}
 			/*
 			 * need to mark as active because x86_pmu_disable()
-			 * clear active_mask and eventsp[] yet it preserves
+			 * clear active_mask and events[] yet it preserves
 			 * idx
 			 */
 			set_bit(hwc->idx, cpuc->active_mask);
@@ -2191,6 +2212,8 @@ static void amd_get_event_constraints(st
 				      struct perf_event *event,
 				      u64 *idxmsk)
 {
+	/* no constraints, means supports all generic counters */
+	bitmap_fill((unsigned long *)idxmsk, x86_pmu.num_events);
 }
 
 static int x86_event_sched_in(struct perf_event *event,
@@ -2265,7 +2288,7 @@ int hw_perf_group_sched_in(struct perf_e
 
 	n1 = 1;
 	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
-		if (sub->state != PERF_EVENT_STATE_OFF) {
+		if (sub->state > PERF_EVENT_STATE_OFF) {
 			ret = x86_event_sched_in(sub, cpuctx, cpu);
 			if (ret)
 				goto undo;
@@ -2620,12 +2643,23 @@ static int validate_group(struct perf_ev
 
 const struct pmu *hw_perf_event_init(struct perf_event *event)
 {
+	const struct pmu *tmp;
 	int err;
 
 	err = __hw_perf_event_init(event);
 	if (!err) {
+		/*
+		 * we temporarily connect event to its pmu
+		 * such that validate_group() can classify
+		 * it as an x86 event using is_x86_event()
+		 */
+		tmp = event->pmu;
+		event->pmu = &pmu;
+
 		if (event->group_leader != event)
 			err = validate_group(event);
+
+		event->pmu = tmp;
 	}
 	if (err) {
 		if (event->destroy)
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -478,9 +478,11 @@ struct hw_perf_event {
 	union {
 		struct { /* hardware */
 			u64		config;
+			u64		last_tag;
 			unsigned long	config_base;
 			unsigned long	event_base;
 			int		idx;
+			int		last_cpu;
 		};
 		struct { /* software */
 			s64		remaining;

-- 

