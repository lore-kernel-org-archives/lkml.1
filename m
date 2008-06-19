Return-Path: <linux-kernel-owner+w=401wt.eu-S1759903AbYFSMh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903AbYFSMh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758532AbYFSMfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:35:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44116 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758247AbYFSMfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:35:33 -0400
Message-Id: <20080619123313.914028019@chello.nl>
References: <20080619122218.971447669@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 19 Jun 2008 14:22:21 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Daniel K." <dk@uw.no>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 03/10] sched: rt-group: heirarchy aware throttle
Content-Disposition: inline; filename=sched-rt-throttle-fix.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bandwidth throttle code dequeues a group when it runs out of quota, and
re-queues it once the period rolls over and the quota gets refreshed.

Sadly it failed to take the hierarchy into consideration. Share more of the
enqueue/dequeue code with regular task opterations.

Also, some operations like sched_setscheduler() can dequeue/enqueue tasks that
are in throttled runqueues, we should not inadvertly re-enqueue empty runqueues
so check for that.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Daniel K. <dk@uw.no>
---
 kernel/sched_rt.c |   59 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 26 deletions(-)

Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -449,13 +449,19 @@ void dec_rt_tasks(struct sched_rt_entity
 #endif
 }
 
-static void enqueue_rt_entity(struct sched_rt_entity *rt_se)
+static void __enqueue_rt_entity(struct sched_rt_entity *rt_se)
 {
 	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
 	struct rt_prio_array *array = &rt_rq->active;
 	struct rt_rq *group_rq = group_rt_rq(rt_se);
 
-	if (group_rq && rt_rq_throttled(group_rq))
+	/*
+	 * Don't enqueue the group if its throttled, or when empty.
+	 * The latter is a consequence of the former when a child group
+	 * get throttled and the current group doesn't have any other
+	 * active members.
+	 */
+	if (group_rq && (rt_rq_throttled(group_rq) || !group_rq->rt_nr_running))
 		return;
 
 	list_add_tail(&rt_se->run_list, array->queue + rt_se_prio(rt_se));
@@ -464,7 +470,7 @@ static void enqueue_rt_entity(struct sch
 	inc_rt_tasks(rt_se, rt_rq);
 }
 
-static void dequeue_rt_entity(struct sched_rt_entity *rt_se)
+static void __dequeue_rt_entity(struct sched_rt_entity *rt_se)
 {
 	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
 	struct rt_prio_array *array = &rt_rq->active;
@@ -480,11 +486,10 @@ static void dequeue_rt_entity(struct sch
  * Because the prio of an upper entry depends on the lower
  * entries, we must remove entries top - down.
  */
-static void dequeue_rt_stack(struct task_struct *p)
+static void dequeue_rt_stack(struct sched_rt_entity *rt_se)
 {
-	struct sched_rt_entity *rt_se, *back = NULL;
+	struct sched_rt_entity *back = NULL;
 
-	rt_se = &p->rt;
 	for_each_sched_rt_entity(rt_se) {
 		rt_se->back = back;
 		back = rt_se;
@@ -492,7 +497,26 @@ static void dequeue_rt_stack(struct task
 
 	for (rt_se = back; rt_se; rt_se = rt_se->back) {
 		if (on_rt_rq(rt_se))
-			dequeue_rt_entity(rt_se);
+			__dequeue_rt_entity(rt_se);
+	}
+}
+
+static void enqueue_rt_entity(struct sched_rt_entity *rt_se)
+{
+	dequeue_rt_stack(rt_se);
+	for_each_sched_rt_entity(rt_se)
+		__enqueue_rt_entity(rt_se);
+}
+
+static void dequeue_rt_entity(struct sched_rt_entity *rt_se)
+{
+	dequeue_rt_stack(rt_se);
+
+	for_each_sched_rt_entity(rt_se) {
+		struct rt_rq *rt_rq = group_rt_rq(rt_se);
+
+		if (rt_rq && rt_rq->rt_nr_running)
+			__enqueue_rt_entity(rt_se);
 	}
 }
 
@@ -506,32 +530,15 @@ static void enqueue_task_rt(struct rq *r
 	if (wakeup)
 		rt_se->timeout = 0;
 
-	dequeue_rt_stack(p);
-
-	/*
-	 * enqueue everybody, bottom - up.
-	 */
-	for_each_sched_rt_entity(rt_se)
-		enqueue_rt_entity(rt_se);
+	enqueue_rt_entity(rt_se);
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
 {
 	struct sched_rt_entity *rt_se = &p->rt;
-	struct rt_rq *rt_rq;
 
 	update_curr_rt(rq);
-
-	dequeue_rt_stack(p);
-
-	/*
-	 * re-enqueue all non-empty rt_rq entities.
-	 */
-	for_each_sched_rt_entity(rt_se) {
-		rt_rq = group_rt_rq(rt_se);
-		if (rt_rq && rt_rq->rt_nr_running)
-			enqueue_rt_entity(rt_se);
-	}
+	dequeue_rt_entity(rt_se);
 }
 
 /*

-- 

