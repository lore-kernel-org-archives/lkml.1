Return-Path: <linux-kernel-owner+w=401wt.eu-S933476AbZFOTH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476AbZFOTH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 15:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758996AbZFOTHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 15:07:48 -0400
Received: from ms01.sssup.it ([193.205.80.99]:58739 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755960AbZFOTHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 15:07:47 -0400
Date: Mon, 15 Jun 2009 21:08:50 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: mingo@elte.hu, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] Modify the curr/next priority tracking
Message-ID: <20090615190850.GP21741@gandalf.sssup.it>
References: <cover.1245092261.git.fabio@helm.retis>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1245092261.git.fabio@helm.retis>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Synchronize with the data structures used for EDF throttling the code
which tracks the highest and the second-highest priority in each group.
---
 kernel/sched_rt.c |   82 ++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 63 insertions(+), 19 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 5d2353f..f43ce7b 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -536,16 +536,57 @@ static inline struct sched_rt_entity *__rt_edf_next(struct sched_rt_entity *se)
 
 #if defined CONFIG_SMP
 
-static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu);
+static int is_task_rq(struct rt_rq *rt_rq)
+{
+	struct task_rt_group *rt_tg = rt_rq->rt_tg;
+	return rt_tg->tg == container_of(rt_tg, struct task_group,
+					 rt_task_group);
+}
 
-static inline int next_prio(struct rq *rq)
+static void find_highest_prios(struct rt_rq *rt_rq, int *curr, int *next)
 {
-	struct task_struct *next = pick_next_highest_task_rt(rq, rq->cpu);
+	struct sched_rt_entity *se, *next_se;
+	struct rt_rq *child;
+	struct rb_node *node;
+	int curp = MAX_RT_PRIO, nextp = MAX_RT_PRIO;
+
+	if (is_task_rq(rt_rq)) {
+		se = __rt_edf_first(&rt_rq->active);
+		if (se) {
+			curp = rt_task_of(se)->prio;
+			next_se = __rt_edf_next(se);
+			if (next_se)
+				nextp = rt_task_of(next_se)->prio;
+		}
+	} else {
+		for (node = rb_first(&rt_rq->active.rb_root);
+		     node; node = rb_next(node)) {
+			se = rb_entry(node, struct sched_rt_entity, rb_node);
+			child = group_rt_rq(se);
+
+			if (child->highest_prio.next < curp) {
+				curp = child->highest_prio.curr;
+				nextp = child->highest_prio.next;
+			} else if (child->highest_prio.curr < curp) {
+				nextp = curp;
+				curp = child->highest_prio.curr;
+				if (child->highest_prio.next < nextp)
+					nextp = child->highest_prio.next;
+			} else if (child->highest_prio.curr < nextp)
+				nextp = child->highest_prio.curr;
+		}
+	}
 
-	if (next && rt_prio(next->prio))
-		return next->prio;
-	else
-		return MAX_RT_PRIO;
+	*curr = curp;
+	*next = nextp;
+}
+
+static inline int next_prio(struct rt_rq *rt_rq)
+{
+	int curp, nextp;
+
+	find_highest_prios(rt_rq, &curp, &nextp);
+	return nextp;
 }
 
 static void
@@ -554,7 +595,6 @@ inc_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
 	struct rq *rq = rq_of_rt_rq(rt_rq);
 
 	if (prio < prev_prio) {
-
 		/*
 		 * If the new task is higher in priority than anything on the
 		 * run-queue, we know that the previous high becomes our
@@ -576,18 +616,22 @@ inc_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
 		/*
 		 * Otherwise, we need to recompute next-highest
 		 */
-		rt_rq->highest_prio.next = next_prio(rq);
+		rt_rq->highest_prio.next = next_prio(rt_rq);
 }
 
 static void
-dec_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
+dec_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prevp, int nextp)
 {
 	struct rq *rq = rq_of_rt_rq(rt_rq);
 
-	if (rt_rq->rt_nr_running && (prio <= rt_rq->highest_prio.next))
-		rt_rq->highest_prio.next = next_prio(rq);
+	if (rt_rq->rt_nr_running && (prio <= rt_rq->highest_prio.next)) {
+		if (nextp == -1)
+			rt_rq->highest_prio.next = next_prio(rt_rq);
+		else
+			rt_rq->highest_prio.next = nextp;
+	}
 
-	if (rq->online && rt_rq->highest_prio.curr != prev_prio)
+	if (rq->online && rt_rq->highest_prio.curr != prevp)
 		cpupri_set(&rq->rd->cpupri, rq->cpu, rt_rq->highest_prio.curr);
 }
 
@@ -596,7 +640,8 @@ dec_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio)
 static inline
 void inc_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio) {}
 static inline
-void dec_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio) {}
+void dec_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio,
+		     int next_prio) {}
 
 #endif /* CONFIG_SMP */
 
@@ -615,8 +660,7 @@ inc_rt_prio(struct rt_rq *rt_rq, int prio)
 static void
 dec_rt_prio(struct rt_rq *rt_rq, int prio)
 {
-	struct sched_rt_entity *rt_se;
-	int prev_prio = rt_rq->highest_prio.curr;
+	int prev_prio = rt_rq->highest_prio.curr, curr_prio, next_prio = -1;
 
 	if (rt_rq->rt_nr_running) {
 
@@ -627,14 +671,14 @@ dec_rt_prio(struct rt_rq *rt_rq, int prio)
 		 * we may have some recomputation to do
 		 */
 		if (prio == prev_prio) {
-			rt_se = __rt_edf_first(&rt_rq->active);
-			rt_rq->highest_prio.curr = rt_se_prio(rt_se);
+			find_highest_prios(rt_rq, &curr_prio, &next_prio);
+			rt_rq->highest_prio.curr = curr_prio;
 		}
 
 	} else
 		rt_rq->highest_prio.curr = MAX_RT_PRIO;
 
-	dec_rt_prio_smp(rt_rq, prio, prev_prio);
+	dec_rt_prio_smp(rt_rq, prio, prev_prio, next_prio);
 }
 
 #else
-- 
1.6.2.2

