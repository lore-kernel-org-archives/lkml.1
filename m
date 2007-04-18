Return-Path: <linux-kernel-owner+w=401wt.eu-S2993002AbXDRXsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993002AbXDRXsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 19:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993008AbXDRXsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 19:48:37 -0400
Received: from mail35.syd.optusnet.com.au ([211.29.133.51]:56834 "EHLO
	mail35.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993014AbXDRXsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 19:48:36 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] sched: implement staircase deadline scheduler further improvements
Date: Thu, 19 Apr 2007 09:48:36 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704190948.36649.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While the Staircase Deadline scheduler has not been completely killed off and 
is still in -mm I would like to fix some outstanding issues that I've found
since it still serves for comparison with all the upcoming schedulers.

While still in -mm can we queue this on top please?

A set of staircase-deadline v 0.41 patches will make their way into the usual
place for those willing to test it.

http://ck.kolivas.org/patches/staircase-deadline/
---
The prio_level was being inappropriately decreased if a higher priority
task was still using previous timeslice. Fix that.

Task expiration of higher priority tasks was not being taken into account
with allocating priority slots. Check the expired best_static_prio level
to facilitate that.

Explicitly check all better static priority prio_levels when deciding on
allocating slots for niced tasks.

These changes improve behaviour in many ways.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 kernel/sched.c |   61 ++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 41 insertions(+), 20 deletions(-)

Index: linux-2.6.21-rc7-sd/kernel/sched.c
===================================================================
--- linux-2.6.21-rc7-sd.orig/kernel/sched.c	2007-04-19 08:51:54.000000000 +1000
+++ linux-2.6.21-rc7-sd/kernel/sched.c	2007-04-19 09:30:39.000000000 +1000
@@ -145,6 +145,12 @@ struct prio_array {
 	 */
 	DECLARE_BITMAP(prio_bitmap, MAX_PRIO + 1);
 
+	/*
+	 * The best static priority (of the dynamic priority tasks) queued
+	 * this array.
+	 */
+	int best_static_prio;
+
 #ifdef CONFIG_SMP
 	/* For convenience looks back at rq */
 	struct rq *rq;
@@ -191,9 +197,9 @@ struct rq {
 
 	/*
 	 * The current dynamic priority level this runqueue is at per static
-	 * priority level, and the best static priority queued this rotation.
+	 * priority level.
 	 */
-	int prio_level[PRIO_RANGE], best_static_prio;
+	int prio_level[PRIO_RANGE];
 
 	/* How many times we have rotated the priority queue */
 	unsigned long prio_rotation;
@@ -669,7 +675,7 @@ static void task_new_array(struct task_s
 }
 
 /* Find the first slot from the relevant prio_matrix entry */
-static inline int first_prio_slot(struct task_struct *p)
+static int first_prio_slot(struct task_struct *p)
 {
 	if (unlikely(p->policy == SCHED_BATCH))
 		return p->static_prio;
@@ -682,11 +688,18 @@ static inline int first_prio_slot(struct
  * level. SCHED_BATCH tasks do not use the priority matrix. They only take
  * priority slots from their static_prio and above.
  */
-static inline int next_entitled_slot(struct task_struct *p, struct rq *rq)
+static int next_entitled_slot(struct task_struct *p, struct rq *rq)
 {
+	int search_prio = MAX_RT_PRIO, uprio = USER_PRIO(p->static_prio);
+	struct prio_array *array = rq->active;
 	DECLARE_BITMAP(tmp, PRIO_RANGE);
-	int search_prio, uprio = USER_PRIO(p->static_prio);
 
+	/*
+	 * Go straight to expiration if there are higher priority tasks
+	 * already expired.
+	 */
+	if (p->static_prio > rq->expired->best_static_prio)
+		return MAX_PRIO;
 	if (!rq->prio_level[uprio])
 		rq->prio_level[uprio] = MAX_RT_PRIO;
 	/*
@@ -694,15 +707,21 @@ static inline int next_entitled_slot(str
 	 * static_prio are acceptable, and only if it's not better than
 	 * a queued better static_prio's prio_level.
 	 */
-	if (p->static_prio < rq->best_static_prio) {
-		search_prio = MAX_RT_PRIO;
+	if (p->static_prio < array->best_static_prio) {
 		if (likely(p->policy != SCHED_BATCH))
-			rq->best_static_prio = p->static_prio;
-	} else if (p->static_prio == rq->best_static_prio)
+			array->best_static_prio = p->static_prio;
+	} else if (p->static_prio == array->best_static_prio) {
 		search_prio = rq->prio_level[uprio];
-	else {
+	} else {
+		int i;
+
+		/* A bound O(n) function, worst case n is 40 */
+		for (i = array->best_static_prio; i <= p->static_prio ; i++) {
+			if (!rq->prio_level[USER_PRIO(i)])
+				rq->prio_level[USER_PRIO(i)] = MAX_RT_PRIO;
 		search_prio = max(rq->prio_level[uprio],
-			rq->prio_level[USER_PRIO(rq->best_static_prio)]);
+			rq->prio_level[USER_PRIO(i)]);
+		}
 	}
 	if (unlikely(p->policy == SCHED_BATCH)) {
 		search_prio = max(search_prio, p->static_prio);
@@ -718,6 +737,8 @@ static void queue_expired(struct task_st
 {
 	task_new_array(p, rq, rq->expired);
 	p->prio = p->normal_prio = first_prio_slot(p);
+	if (p->static_prio < rq->expired->best_static_prio)
+		rq->expired->best_static_prio = p->static_prio;
 }
 
 #ifdef CONFIG_SMP
@@ -726,7 +747,7 @@ static void queue_expired(struct task_st
  * update its data appropriately. Note we may be reading data from src_rq->
  * outside of lock, but the occasional inaccurate result should be harmless.
  */
- static inline void update_if_moved(struct task_struct *p, struct rq *rq)
+ static void update_if_moved(struct task_struct *p, struct rq *rq)
 {
 	struct rq *src_rq = p->array->rq;
 
@@ -3217,8 +3238,10 @@ EXPORT_SYMBOL(sub_preempt_count);
 
 #endif
 
-static inline void reset_prio_levels(struct rq *rq)
+static void reset_prio_levels(struct rq *rq)
 {
+	rq->active->best_static_prio = MAX_PRIO - 1;
+	rq->expired->best_static_prio = MAX_PRIO - 1;
 	memset(rq->prio_level, 0, sizeof(int) * PRIO_RANGE);
 }
 
@@ -3239,7 +3262,6 @@ retry:
 		rq->active = array;
 		rq->exp_bitmap = rq->expired->prio_bitmap;
 		rq->dyn_bitmap = rq->active->prio_bitmap;
-		rq->best_static_prio = MAX_PRIO - 1;
 		rq->prio_rotation++;
 		idx = find_next_bit(rq->dyn_bitmap, MAX_PRIO, MAX_RT_PRIO);
 		reset_prio_levels(rq);
@@ -3261,9 +3283,10 @@ retry:
 	if (likely(next->policy != SCHED_BATCH)) {
 		int nstatic = next->static_prio;
 
-		if (nstatic < rq->best_static_prio)
-			rq->best_static_prio = nstatic;
-		rq->prio_level[USER_PRIO(nstatic)] = idx;
+		if (nstatic < array->best_static_prio)
+			array->best_static_prio = nstatic;
+		if (idx > rq->prio_level[USER_PRIO(nstatic)])
+			rq->prio_level[USER_PRIO(nstatic)] = idx;
 	}
 	return next;
 }
@@ -3348,7 +3371,6 @@ need_resched_nonpreemptible:
 	}
 switch_tasks:
 	if (next == rq->idle) {
-		rq->best_static_prio = MAX_PRIO - 1;
 		reset_prio_levels(rq);
 		rq->prio_rotation++;
 		schedstat_inc(rq, sched_goidle);
@@ -6671,10 +6693,9 @@ void __init sched_init(void)
 		lockdep_set_class(&rq->lock, &rq->rq_lock_key);
 		rq->nr_running = 0;
 		rq->prio_rotation = 0;
-		rq->best_static_prio = MAX_PRIO - 1;
-		reset_prio_levels(rq);
 		rq->active = rq->arrays;
 		rq->expired = rq->arrays + 1;
+		reset_prio_levels(rq);
 		rq->dyn_bitmap = rq->active->prio_bitmap;
 		rq->exp_bitmap = rq->expired->prio_bitmap;
 

-- 
-ck
