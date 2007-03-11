Return-Path: <linux-kernel-owner+w=401wt.eu-S964807AbXCKXqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964807AbXCKXqt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 19:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964810AbXCKXqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 19:46:49 -0400
Received: from mail13.syd.optusnet.com.au ([211.29.132.194]:57878 "EHLO
	mail13.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964807AbXCKXqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 19:46:48 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>
Subject: [PATCH] [RSDL] sched: rsdl accounting fixes
Date: Mon, 12 Mar 2007 10:46:28 +1100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703121046.29137.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew the following patch can be rolled into the
sched-implement-rsdl-cpu-scheduler.patch file or added separately if
that's easier. All the oopses and bitmap errors of previous versions of rsdl
were fixed by v0.29 so I think RSDL is ready for another round in -mm.

Thanks.
---
Higher priority tasks should always preempt lower priority tasks if they
are queued higher than their static priority as non-rt tasks. Fix it.

The deadline mechanism can be triggered before tasks' quota ever gets added
to the runqueue priority level's quota. Add 1 to the quota in anticipation
of this.

The deadline mechanism should only be triggered if the quota is overrun
instead of as soon as the quota is expired allowing some aliasing errors in
scheduler_tick accounting. Fix that 

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 kernel/sched.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

Index: linux-2.6.21-rc3-mm2/kernel/sched.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/kernel/sched.c	2007-03-12 08:47:43.000000000 +1100
+++ linux-2.6.21-rc3-mm2/kernel/sched.c	2007-03-12 09:10:33.000000000 +1100
@@ -96,10 +96,9 @@ unsigned long long __attribute__((weak))
  * provided it is not a realtime comparison.
  */
 #define TASK_PREEMPTS_CURR(p, curr) \
-	(((p)->prio < (curr)->prio) || (((p)->prio == (curr)->prio) && \
+	(((p)->prio < (curr)->prio) || (!rt_task(p) && \
 		((p)->static_prio < (curr)->static_prio && \
-			((curr)->static_prio > (curr)->prio)) && \
-				!rt_task(p)))
+			((curr)->static_prio > (curr)->prio))))
 
 /*
  * This is the time all tasks within the same priority round robin.
@@ -3323,7 +3322,7 @@ static inline void major_prio_rotation(s
  */
 static inline void rotate_runqueue_priority(struct rq *rq)
 {
-	int new_prio_level, remaining_quota;
+	int new_prio_level;
 	struct prio_array *array;
 
 	/*
@@ -3334,7 +3333,6 @@ static inline void rotate_runqueue_prior
 	if (unlikely(sched_find_first_bit(rq->dyn_bitmap) < rq->prio_level))
 		return;
 
-	remaining_quota = rq_quota(rq, rq->prio_level);
 	array = rq->active;
 	if (rq->prio_level > MAX_PRIO - 2) {
 		/* Major rotation required */
@@ -3368,10 +3366,11 @@ static inline void rotate_runqueue_prior
 	}
 	rq->prio_level = new_prio_level;
 	/*
-	 * While we usually rotate with the rq quota being 0, it is possible
-	 * to be negative so we subtract any deficit from the new level.
+	 * As we are merging to a prio_level that may not have anything in
+	 * its quota we add 1 to ensure the tasks get to run in schedule() to
+	 * add their quota to it.
 	 */
-	rq_quota(rq, new_prio_level) += remaining_quota;
+	rq_quota(rq, new_prio_level) += 1;
 }
 
 static void task_running_tick(struct rq *rq, struct task_struct *p)
@@ -3397,12 +3396,11 @@ static void task_running_tick(struct rq 
 	if (!--p->time_slice)
 		task_expired_entitlement(rq, p);
 	/*
-	 * The rq quota can become negative due to a task being queued in
-	 * scheduler without any quota left at that priority level. It is
-	 * cheaper to allow it to run till this scheduler tick and then
-	 * subtract it from the quota of the merged queues.
+	 * We only employ the deadline mechanism if we run over the quota.
+	 * It allows aliasing problems around the scheduler_tick to be
+	 * less harmful.
 	 */
-	if (!rt_task(p) && --rq_quota(rq, rq->prio_level) <= 0) {
+	if (!rt_task(p) && --rq_quota(rq, rq->prio_level) < 0) {
 		if (unlikely(p->first_time_slice))
 			p->first_time_slice = 0;
 		rotate_runqueue_priority(rq);


-- 
-ck
