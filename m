Return-Path: <linux-kernel-owner+w=401wt.eu-S933574AbXCKWMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574AbXCKWMW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 18:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933578AbXCKWMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 18:12:21 -0400
Received: from mail12.syd.optusnet.com.au ([211.29.132.193]:44517 "EHLO
	mail12.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933574AbXCKWMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 18:12:19 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Al Boldi <a1426z@gawab.com>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Date: Mon, 12 Mar 2007 09:12:23 +1100
User-Agent: KMail/1.9.5
Cc: ck list <ck@vds.kolivas.org>, linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <200703112111.38415.a1426z@gawab.com> <200703120852.05857.kernel@kolivas.org>
In-Reply-To: <200703120852.05857.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703120912.24156.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007 08:52, Con Kolivas wrote:
> And thank you! I think I know what's going on now. I think each rotation is
> followed by another rotation before the higher priority task is getting a
> look in in schedule() to even get quota and add it to the runqueue quota.
> I'll try a simple change to see if that helps. Patch coming up shortly.

Can you try the following patch and see if it helps. There's also one minor
preemption logic fix in there that I'm planning on including. Thanks!

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
