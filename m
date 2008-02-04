Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbYBDVRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbYBDVRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbYBDVRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:17:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46905 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025AbYBDVRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:17:08 -0500
Message-Id: <20080204211836.724399000@chello.nl>
References: <20080204210258.118479000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 04 Feb 2008 22:03:00 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: tong.n.li@intel.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/8] sched: rt-group: deal with PI
Content-Disposition: inline; filename=sched-rt-group-pi.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven mentioned the fun case where a lock holding task will be throttled.

Simple fix: allow groups that have boosted tasks to run anyway.

If a runnable task in a throttled group gets boosted the dequeue/enqueue
done by rt_mutex_setprio() is enough to unthrottle the group.

This is ofcourse not quite correct. Two possible ways forward are:
  - second prio array for boosted tasks
  - boost to a prio ceiling (this would also work for deadline scheduling)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c    |    3 +++
 kernel/sched_rt.c |   43 ++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 41 insertions(+), 5 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -374,6 +374,8 @@ struct rt_rq {
 	u64 rt_time;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
+	unsigned long rt_nr_boosted;
+
 	struct rq *rq;
 	struct list_head leaf_rt_rq_list;
 	struct task_group *tg;
@@ -7116,6 +7118,7 @@ static void init_rt_rq(struct rt_rq *rt_
 	rt_rq->rt_throttled = 0;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
+	rt_rq->rt_nr_boosted = 0;
 	rt_rq->rq = rq;
 #endif
 }
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -110,6 +110,23 @@ static void sched_rt_ratio_dequeue(struc
 		dequeue_rt_entity(rt_se);
 }
 
+static inline int rt_rq_throttled(struct rt_rq *rt_rq)
+{
+	return rt_rq->rt_throttled && !rt_rq->rt_nr_boosted;
+}
+
+static int rt_se_boosted(struct sched_rt_entity *rt_se)
+{
+	struct rt_rq *rt_rq = group_rt_rq(rt_se);
+	struct task_struct *p;
+
+	if (rt_rq)
+		return !!rt_rq->rt_nr_boosted;
+
+	p = rt_task_of(rt_se);
+	return p->prio != p->normal_prio;
+}
+
 #else
 
 static inline unsigned int sched_rt_ratio(struct rt_rq *rt_rq)
@@ -149,6 +166,10 @@ static inline void sched_rt_ratio_dequeu
 {
 }
 
+static inline int rt_rq_throttled(struct rt_rq *rt_rq)
+{
+	return rt_rq->rt_throttled;
+}
 #endif
 
 static inline int rt_se_prio(struct sched_rt_entity *rt_se)
@@ -172,7 +193,7 @@ static int sched_rt_ratio_exceeded(struc
 		return 0;
 
 	if (rt_rq->rt_throttled)
-		return 1;
+		return rt_rq_throttled(rt_rq);
 
 	period = (u64)sysctl_sched_rt_period * NSEC_PER_MSEC;
 	ratio = (period * rt_ratio) >> SCHED_RT_FRAC_SHIFT;
@@ -183,8 +204,10 @@ static int sched_rt_ratio_exceeded(struc
 		rq->rt_throttled = 1;
 		rt_rq->rt_throttled = 1;
 
-		sched_rt_ratio_dequeue(rt_rq);
-		return 1;
+		if (rt_rq_throttled(rt_rq)) {
+			sched_rt_ratio_dequeue(rt_rq);
+			return 1;
+		}
 	}
 
 	return 0;
@@ -265,6 +288,10 @@ void inc_rt_tasks(struct sched_rt_entity
 
 	update_rt_migration(rq_of_rt_rq(rt_rq));
 #endif
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	if (rt_se_boosted(rt_se))
+		rt_rq->rt_nr_boosted++;
+#endif
 }
 
 static inline
@@ -295,6 +322,12 @@ void dec_rt_tasks(struct sched_rt_entity
 
 	update_rt_migration(rq_of_rt_rq(rt_rq));
 #endif /* CONFIG_SMP */
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	if (rt_se_boosted(rt_se))
+		rt_rq->rt_nr_boosted--;
+
+	WARN_ON(!rt_rq->rt_nr_running && rt_rq->rt_nr_boosted);
+#endif
 }
 
 static void enqueue_rt_entity(struct sched_rt_entity *rt_se)
@@ -303,7 +336,7 @@ static void enqueue_rt_entity(struct sch
 	struct rt_prio_array *array = &rt_rq->active;
 	struct rt_rq *group_rq = group_rt_rq(rt_se);
 
-	if (group_rq && group_rq->rt_throttled)
+	if (group_rq && rt_rq_throttled(group_rq))
 		return;
 
 	list_add_tail(&rt_se->run_list, array->queue + rt_se_prio(rt_se));
@@ -496,7 +529,7 @@ static struct task_struct *pick_next_tas
 	if (unlikely(!rt_rq->rt_nr_running))
 		return NULL;
 
-	if (sched_rt_ratio_exceeded(rt_rq))
+	if (rt_rq_throttled(rt_rq))
 		return NULL;
 
 	do {

--

