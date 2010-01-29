Return-Path: <linux-kernel-owner+w=401wt.eu-S932219Ab0A2J26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab0A2J26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767Ab0A2J2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:28:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:57437 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288Ab0A2J2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:28:54 -0500
Date: Fri, 29 Jan 2010 09:28:19 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100122155535.887853503@chello.nl>
References: <20100122155535.887853503@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_event: x86: Optimize the constraint searching bits
Message-ID: <tip-63b146490befc027a7e0923e333269e68b20d380@git.kernel.org>
Git-Commit-ID: 63b146490befc027a7e0923e333269e68b20d380
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:28:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  63b146490befc027a7e0923e333269e68b20d380
Gitweb:     http://git.kernel.org/tip/63b146490befc027a7e0923e333269e68b20d380
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 22 Jan 2010 16:32:17 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Jan 2010 09:01:40 +0100

perf_event: x86: Optimize the constraint searching bits

Instead of copying bitmasks around, pass pointers to the constraint
structure.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <20100122155535.887853503@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   75 +++++++++++++++++---------------------
 1 files changed, 34 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4d1ed10..092ad56 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -134,12 +134,14 @@ struct x86_pmu {
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
@@ -1242,17 +1244,15 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 {
 	int i, j , w, num;
 	int weight, wmax;
-	unsigned long *c;
-	unsigned long constraints[X86_PMC_IDX_MAX][BITS_TO_LONGS(X86_PMC_IDX_MAX)];
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
@@ -1267,7 +1267,7 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 			break;
 
 		/* constraint still honored */
-		if (!test_bit(hwc->idx, c))
+		if (!test_bit(hwc->idx, c->idxmsk))
 			break;
 
 		/* not already used */
@@ -1320,11 +1320,11 @@ static int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
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
@@ -2155,11 +2155,13 @@ perf_event_nmi_handler(struct notifier_block *self,
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
 
@@ -2169,46 +2171,34 @@ static int intel_special_constraints(struct perf_event *event,
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
@@ -2576,6 +2566,9 @@ void __init init_hw_perf_events(void)
 	perf_events_lapic_init();
 	register_die_notifier(&perf_event_nmi_notifier);
 
+	unconstrained = (struct event_constraint)
+		EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_events) - 1, 0);
+
 	pr_info("... version:                %d\n",     x86_pmu.version);
 	pr_info("... bit width:              %d\n",     x86_pmu.event_bits);
 	pr_info("... generic registers:      %d\n",     x86_pmu.num_events);
