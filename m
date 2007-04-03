Return-Path: <linux-kernel-owner+w=401wt.eu-S933940AbXDCBEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933940AbXDCBEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 21:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933945AbXDCBEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 21:04:41 -0400
Received: from mail04.syd.optusnet.com.au ([211.29.132.185]:41777 "EHLO
	mail04.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933940AbXDCBEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 21:04:40 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       linux list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>,
       "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Subject: [PATCH] sched: staircase deadline improvements
Date: Tue, 3 Apr 2007 11:04:16 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704031104.17230.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Staircase Deadline improvements.

Nice is better distributed for waking tasks with a per-static-prio prio_level.

SCHED_RR tasks were not being requeued on expiration.

Tighten up accounting.

Fix comment style.

Microoptimisation courtesy of Dmitry Adamushko <dmitry.adamushko@gmail.com>

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 kernel/sched.c |   97 +++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 60 insertions(+), 37 deletions(-)

Index: linux-2.6.21-rc5-mm3/kernel/sched.c
===================================================================
--- linux-2.6.21-rc5-mm3.orig/kernel/sched.c	2007-04-02 10:37:07.000000000 +1000
+++ linux-2.6.21-rc5-mm3/kernel/sched.c	2007-04-03 10:40:48.000000000 +1000
@@ -132,20 +132,20 @@ struct rq;
  * These are the runqueue data structures:
  */
 struct prio_array {
-	struct list_head queue[MAX_PRIO];
 	/* Tasks queued at each priority */
+	struct list_head queue[MAX_PRIO];
 
-	DECLARE_BITMAP(prio_bitmap, MAX_PRIO + 1);
 	/*
 	 * The bitmap of priorities queued for this array. While the expired
 	 * array will never have realtime tasks on it, it is simpler to have
 	 * equal sized bitmaps for a cheap array swap. Include 1 bit for
 	 * delimiter.
 	 */
+	DECLARE_BITMAP(prio_bitmap, MAX_PRIO + 1);
 
 #ifdef CONFIG_SMP
-	struct rq *rq;
 	/* For convenience looks back at rq */
+	struct rq *rq;
 #endif
 };
 
@@ -212,14 +212,14 @@ struct rq {
 	struct prio_array *active, *expired, arrays[2];
 	unsigned long *dyn_bitmap, *exp_bitmap;
 
-	int prio_level, best_static_prio;
 	/*
-	 * The current dynamic priority level this runqueue is at, and the
-	 * best static priority queued this major rotation.
+	 * The current dynamic priority level this runqueue is at per static
+	 * priority level, and the best static priority queued this rotation.
 	 */
+	int prio_level[PRIO_RANGE], best_static_prio;
 
-	unsigned long prio_rotation;
 	/* How many times we have rotated the priority queue */
+	unsigned long prio_rotation;
 
 	atomic_t nr_iowait;
 
@@ -707,19 +707,29 @@ static inline int first_prio_slot(struct
 static inline int next_entitled_slot(struct task_struct *p, struct rq *rq)
 {
 	DECLARE_BITMAP(tmp, PRIO_RANGE);
-	int search_prio;
+	int search_prio, uprio = USER_PRIO(p->static_prio);
 
-	if (p->static_prio < rq->best_static_prio)
+	/*
+	 * Only priorities equal to the prio_level and above for their
+	 * static_prio are acceptable, and only if it's not better than
+	 * a queued better static_prio's prio_level.
+	 */
+	if (p->static_prio < rq->best_static_prio) {
 		search_prio = MAX_RT_PRIO;
-	else
-		search_prio = rq->prio_level;
+		if (likely(p->policy != SCHED_BATCH))
+			rq->best_static_prio = p->static_prio;
+	} else if (p->static_prio == rq->best_static_prio)
+		search_prio = rq->prio_level[uprio];
+	else {
+		search_prio = max(rq->prio_level[uprio],
+			rq->prio_level[USER_PRIO(rq->best_static_prio)]);
+	}
 	if (unlikely(p->policy == SCHED_BATCH)) {
 		search_prio = max(search_prio, p->static_prio);
 		return SCHED_PRIO(find_next_zero_bit(p->bitmap, PRIO_RANGE,
 				  USER_PRIO(search_prio)));
 	}
-	bitmap_or(tmp, p->bitmap, prio_matrix[USER_PRIO(p->static_prio)],
-		  PRIO_RANGE);
+	bitmap_or(tmp, p->bitmap, prio_matrix[uprio], PRIO_RANGE);
 	return SCHED_PRIO(find_next_zero_bit(tmp, PRIO_RANGE,
 		USER_PRIO(search_prio)));
 }
@@ -745,14 +755,18 @@ static void queue_expired(struct task_st
 
 	if (src_rq == rq)
 		return;
-	if (p->rotation == src_rq->prio_rotation)
+	/*
+	 * Only need to set p->array when p->rotation == rq->prio_rotation as
+	 * they will be set in recalc_task_prio when != rq->prio_rotation.
+	 */
+	if (p->rotation == src_rq->prio_rotation) {
 		p->rotation = rq->prio_rotation;
-	else
+		if (p->array == src_rq->expired)
+			p->array = rq->expired;
+		else
+			p->array = rq->active;
+	} else
 		p->rotation = 0;
-	if (p->array == src_rq->expired)
-		p->array = rq->expired;
-	else
-		p->array = rq->active;
 }
 #else
 static inline void update_if_moved(struct task_struct *p, struct rq *rq)
@@ -1671,16 +1685,16 @@ void fastcall sched_fork(struct task_str
 	 * total amount of pending timeslices in the system doesn't change,
 	 * resulting in more scheduling fairness.
 	 */
-	if (unlikely(p->time_slice < 2))
-		p->time_slice = 2;
-	p->time_slice = current->time_slice >> 1;
+	local_irq_disable();
+	current->time_slice >>= 1;
+	p->time_slice = current->time_slice;
 	/*
 	 * The remainder of the first timeslice might be recovered by
 	 * the parent if the child exits early enough.
 	 */
 	p->first_time_slice = 1;
-	current->time_slice >>= 1;
 	p->timestamp = sched_clock();
+	local_irq_enable();
 out:
 	put_cpu();
 }
@@ -3334,18 +3348,23 @@ void account_steal_time(struct task_stru
 static void task_expired_entitlement(struct rq *rq, struct task_struct *p)
 {
 	struct prio_array *old_array;
+	int overrun;
 	int old_prio;
 
 	if (unlikely(p->first_time_slice))
 		p->first_time_slice = 0;
 	if (rt_task(p)) {
 		p->time_slice = p->quota;
+		list_move_tail(&p->run_list, p->array->queue + p->prio);
 		return;
 	}
 	old_array = p->array;
 	old_prio = p->prio;
+	overrun = p->time_slice;
 	/* p->prio and p->array will be updated in recalc_task_prio */
 	recalc_task_prio(p, rq);
+	/* Subtract any extra time this task ran over its time_slice */
+	p->time_slice += overrun;
 	requeue_task(p, rq, old_array, old_prio);
 }
 
@@ -3355,16 +3374,11 @@ static void task_running_tick(struct rq 
 	/* SCHED_FIFO tasks never run out of timeslice. */
 	if (p->time_slice > 0 || p->policy == SCHED_FIFO)
 		return;
-	spin_lock(&rq->lock);
-	if (unlikely(!task_queued(p))) {
-		/* Task has expired but was not scheduled off yet */
-		set_tsk_need_resched(p);
-		goto out_unlock;
-	}
 	/* p->time_slice <= 0 */
-	task_expired_entitlement(rq, p);
+	spin_lock(&rq->lock);
+	if (likely(task_queued(p)))
+		task_expired_entitlement(rq, p);
 	set_tsk_need_resched(p);
-out_unlock:
 	spin_unlock(&rq->lock);
 }
 
@@ -3429,6 +3443,11 @@ EXPORT_SYMBOL(sub_preempt_count);
 
 #endif
 
+static inline void reset_prio_levels(struct rq *rq)
+{
+	memset(rq->prio_level, MAX_RT_PRIO, ARRAY_SIZE(rq->prio_level));
+}
+
 /*
  * next_dynamic_task finds the next suitable dynamic task.
  */
@@ -3449,6 +3468,7 @@ retry:
 		rq->best_static_prio = MAX_PRIO - 1;
 		rq->prio_rotation++;
 		idx = find_next_bit(rq->dyn_bitmap, MAX_PRIO, MAX_RT_PRIO);
+		reset_prio_levels(rq);
 	}
 	queue = array->queue + idx;
 	next = list_entry(queue->next, struct task_struct, run_list);
@@ -3463,11 +3483,14 @@ retry:
 		idx = find_next_bit(rq->dyn_bitmap, MAX_PRIO, MAX_RT_PRIO);
 		goto retry;
 	}
-	rq->prio_level = idx;
 	next->rotation = rq->prio_rotation;
-	if (next->static_prio < rq->best_static_prio &&
-	    next->policy != SCHED_BATCH)
-		rq->best_static_prio = next->static_prio;
+	if (likely(next->policy != SCHED_BATCH)) {
+		int nstatic = next->static_prio;
+
+		if (nstatic < rq->best_static_prio)
+			rq->best_static_prio = nstatic;
+		rq->prio_level[USER_PRIO(nstatic)] = idx;
+	}
 	return next;
 }
 
@@ -3552,7 +3575,7 @@ need_resched_nonpreemptible:
 switch_tasks:
 	if (next == rq->idle) {
 		rq->best_static_prio = MAX_PRIO - 1;
-		rq->prio_level = MAX_RT_PRIO;
+		reset_prio_levels(rq);
 		rq->prio_rotation++;
 		schedstat_inc(rq, sched_goidle);
 	}
@@ -7020,7 +7043,7 @@ void __init sched_init(void)
 		rq->nr_running = 0;
 		rq->prio_rotation = 0;
 		rq->best_static_prio = MAX_PRIO - 1;
-		rq->prio_level = MAX_RT_PRIO;
+		reset_prio_levels(rq);
 		rq->active = rq->arrays;
 		rq->expired = rq->arrays + 1;
 		rq->dyn_bitmap = rq->active->prio_bitmap;

-- 
-ck
