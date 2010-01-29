Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483Ab0A2J1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab0A2J1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593Ab0A2J1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:27:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:57376 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754675Ab0A2J1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:27:33 -0500
Date: Fri, 29 Jan 2010 09:26:46 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4b588464.1818d00a.4456.383b@mx.google.com>
References: <4b588464.1818d00a.4456.383b@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Add fast-path to the rescheduling code
Message-ID: <tip-8113070d6639d2245c6c79afb8df42cedab30540@git.kernel.org>
Git-Commit-ID: 8113070d6639d2245c6c79afb8df42cedab30540
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:26:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8113070d6639d2245c6c79afb8df42cedab30540
Gitweb:     http://git.kernel.org/tip/8113070d6639d2245c6c79afb8df42cedab30540
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 21 Jan 2010 17:39:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Jan 2010 09:01:34 +0100

perf_events: Add fast-path to the rescheduling code

Implement correct fastpath scheduling, i.e., reuse previous assignment.

Signed-off-by: Stephane Eranian <eranian@google.com>
[ split from larger patch]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4b588464.1818d00a.4456.383b@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   91 +++++++++++++++++++++++++------------
 1 files changed, 61 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 995ac4a..0bd23d0 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1245,6 +1245,46 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
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
@@ -1263,10 +1303,9 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
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
 
@@ -1274,28 +1313,6 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
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
@@ -1303,22 +1320,23 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 
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
@@ -1357,7 +1375,7 @@ static int collect_events(struct cpu_hw_events *cpuc, struct perf_event *leader,
 
 	list_for_each_entry(event, &leader->sibling_list, group_entry) {
 		if (!is_x86_event(event) ||
-		    event->state == PERF_EVENT_STATE_OFF)
+		    event->state <= PERF_EVENT_STATE_OFF)
 			continue;
 
 		if (n >= max_count)
@@ -2184,6 +2202,8 @@ static void amd_get_event_constraints(struct cpu_hw_events *cpuc,
 				      struct perf_event *event,
 				      u64 *idxmsk)
 {
+	/* no constraints, means supports all generic counters */
+	bitmap_fill((unsigned long *)idxmsk, x86_pmu.num_events);
 }
 
 static int x86_event_sched_in(struct perf_event *event,
@@ -2258,7 +2278,7 @@ int hw_perf_group_sched_in(struct perf_event *leader,
 
 	n1 = 1;
 	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
-		if (sub->state != PERF_EVENT_STATE_OFF) {
+		if (sub->state > PERF_EVENT_STATE_OFF) {
 			ret = x86_event_sched_in(sub, cpuctx, cpu);
 			if (ret)
 				goto undo;
@@ -2613,12 +2633,23 @@ static int validate_group(struct perf_event *event)
 
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
