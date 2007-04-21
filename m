Return-Path: <linux-kernel-owner+w=401wt.eu-S964932AbXDUHvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964932AbXDUHvm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 03:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965051AbXDUHvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 03:51:42 -0400
Received: from mail23.syd.optusnet.com.au ([211.29.133.164]:56402 "EHLO
	mail23.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964932AbXDUHvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 03:51:41 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Al Boldi <a1426z@gawab.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] sched: implement staircase scheduler yaf fix
Date: Sat, 21 Apr 2007 17:51:29 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704211751.29985.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While it annoys even me to keep posting fixes for SD, it is nice that fixing
these bugs improves the behaviour further. This change causes noticeable
improvements with loads that fork (ie make and friends).

Thanks Al!

Andrew please apply.
---
Management of time_slice sharing across fork was broken by changing
time_slice to a signed int.

first_time_slice was not being cleared anywhere near often enough. 

SCHED_BATCH tasks in the current implementation should advance prio_level
and best_static_prio.

Thanks Al Boldi <a1426z@gawab.com> for making me check the fork code.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 kernel/sched.c |   50 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 19 deletions(-)

Index: linux-2.6.21-rc7-sd/kernel/sched.c
===================================================================
--- linux-2.6.21-rc7-sd.orig/kernel/sched.c	2007-04-21 16:43:23.000000000 +1000
+++ linux-2.6.21-rc7-sd/kernel/sched.c	2007-04-21 17:31:12.000000000 +1000
@@ -661,6 +661,12 @@ static void dequeue_task(struct task_str
 		__clear_bit(p->prio, p->array->prio_bitmap);
 }
 
+static void reset_first_time_slice(struct task_struct *p)
+{
+	if (unlikely(p->first_time_slice))
+		p->first_time_slice = 0;
+}
+
 /*
  * The task is being queued on a fresh array so it has its entitlement
  * bitmap cleared.
@@ -672,6 +678,7 @@ static void task_new_array(struct task_s
 	p->rotation = rq->prio_rotation;
 	p->time_slice = p->quota;
 	p->array = array;
+	reset_first_time_slice(p);
 }
 
 /* Find the first slot from the relevant prio_matrix entry */
@@ -740,6 +747,7 @@ static void queue_expired(struct task_st
 	p->prio = p->normal_prio = first_prio_slot(p);
 	if (p->static_prio < rq->expired->best_static_prio)
 		rq->expired->best_static_prio = p->static_prio;
+	reset_first_time_slice(p);
 }
 
 #ifdef CONFIG_SMP
@@ -1661,13 +1669,20 @@ void fastcall sched_fork(struct task_str
 	 * resulting in more scheduling fairness.
 	 */
 	local_irq_disable();
-	current->time_slice >>= 1;
-	p->time_slice = current->time_slice;
-	/*
-	 * The remainder of the first timeslice might be recovered by
-	 * the parent if the child exits early enough.
-	 */
-	p->first_time_slice = 1;
+	if (current->time_slice > 0) {
+		current->time_slice /= 2;
+		if (current->time_slice)
+			p->time_slice = current->time_slice;
+		else
+			p->time_slice = 1;
+		/*
+		 * The remainder of the first timeslice might be recovered by
+		 * the parent if the child exits early enough.
+		 */
+		p->first_time_slice = 1;
+	} else
+		p->time_slice = 0;
+
 	p->timestamp = sched_clock();
 	local_irq_enable();
 out:
@@ -1748,7 +1763,7 @@ void fastcall sched_exit(struct task_str
 
 	parent = p->parent;
 	rq = task_rq_lock(parent, &flags);
-	if (p->first_time_slice && task_cpu(p) == task_cpu(parent)) {
+	if (p->first_time_slice > 0 && task_cpu(p) == task_cpu(parent)) {
 		parent->time_slice += p->time_slice;
 		if (unlikely(parent->time_slice > parent->quota))
 			parent->time_slice = parent->quota;
@@ -3148,8 +3163,7 @@ static void task_expired_entitlement(str
 	struct prio_array *old_array;
 	int overrun, old_prio;
 
-	if (unlikely(p->first_time_slice))
-		p->first_time_slice = 0;
+	reset_first_time_slice(p);
 	if (rt_task(p)) {
 		p->time_slice = p->quota;
 		list_move_tail(&p->run_list, p->array->queue + p->prio);
@@ -3251,9 +3265,10 @@ static void reset_prio_levels(struct rq 
  */
 static inline struct task_struct *next_dynamic_task(struct rq *rq, int idx)
 {
+	struct prio_array *array = rq->active;
 	struct task_struct *next;
 	struct list_head *queue;
-	struct prio_array *array = rq->active;
+	int nstatic;
 
 retry:
 	if (idx >= MAX_PRIO) {
@@ -3281,14 +3296,11 @@ retry:
 		goto retry;
 	}
 	next->rotation = rq->prio_rotation;
-	if (likely(next->policy != SCHED_BATCH)) {
-		int nstatic = next->static_prio;
-
-		if (nstatic < array->best_static_prio)
-			array->best_static_prio = nstatic;
-		if (idx > rq->prio_level[USER_PRIO(nstatic)])
-			rq->prio_level[USER_PRIO(nstatic)] = idx;
-	}
+	nstatic = next->static_prio;
+	if (nstatic < array->best_static_prio)
+		array->best_static_prio = nstatic;
+	if (idx > rq->prio_level[USER_PRIO(nstatic)])
+		rq->prio_level[USER_PRIO(nstatic)] = idx;
 	return next;
 }
 


-- 
-ck
