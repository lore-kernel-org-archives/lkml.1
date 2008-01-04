Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbYADN6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbYADN6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 08:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYADN4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 08:56:35 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:57427 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753862AbYADN4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 08:56:33 -0500
Message-Id: <20080104135653.410531000@chello.nl>
References: <20080104135457.336761000@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 04 Jan 2008 14:55:04 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 7/7] sched: rt-group: deal with PI
Content-Disposition: inline; filename=sched-rt-group-pi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven mentioned the fun case where a lock holding task will be throttled.

Simple fix: allow groups that have boosted tasks to run anyway.
This is ofcourse not quite correct. Needs more tricks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c    |    3 +++
 kernel/sched_rt.c |   50 ++++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 45 insertions(+), 8 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -376,6 +376,8 @@ struct rt_rq {
 	struct hrtimer rt_period_timer;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
+	unsigned long rt_nr_boosted;
+
 	struct rq *rq;
 	struct list_head leaf_rt_rq_list;
 	struct task_group *tg;
@@ -7273,6 +7275,7 @@ static void init_rt_rq(struct rt_rq *rt_
 	rt_rq->rt_period_timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
+	rt_rq->rt_nr_boosted = 0;
 	rt_rq->rq = rq;
 #endif
 }
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -121,6 +121,11 @@ static void sched_rt_ratio_dequeue(struc
 		dequeue_rt_entity(rt_se);
 }
 
+static inline int rt_rq_throttled(struct rt_rq *rt_rq)
+{
+	return rt_rq->rt_throttled && !rt_rq->rt_nr_boosted;
+}
+
 #else
 
 static inline unsigned int sched_rt_ratio(struct rt_rq *rt_rq)
@@ -170,6 +175,10 @@ static inline void sched_rt_ratio_dequeu
 {
 }
 
+static inline int rt_rq_throttled(struct rt_rq *rt_rq)
+{
+	return rt_rq->rt_throttled;
+}
 #endif
 
 static inline int rt_se_prio(struct sched_rt_entity *rt_se)
@@ -184,27 +193,42 @@ static inline int rt_se_prio(struct sche
 	return rt_task_of(rt_se)->prio;
 }
 
+static int rt_se_boosted(struct sched_rt_entity *rt_se)
+{
+	struct task_struct *p;
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	struct rt_rq *rt_rq = group_rt_rq(rt_se);
+
+	if (rt_rq)
+		return !!rt_rq->rt_nr_boosted;
+#endif
+
+	p = rt_task_of(rt_se);
+	return p->prio != p->normal_prio;
+}
+
 static int sched_rt_ratio_exceeded(struct rt_rq *rt_rq)
 {
 	unsigned int rt_ratio = sched_rt_ratio(rt_rq);
 	u64 period, ratio;
 
 	if (rt_ratio == SCHED_RT_FRAC)
-		return 0;
+		goto out;
 
 	if (rt_rq->rt_throttled)
-		return 1;
+		goto out;
 
 	period = sched_rt_period_ns(rt_rq);
 	ratio = (period * rt_ratio) >> SCHED_RT_FRAC_SHIFT;
 
 	if (rt_rq->rt_time > ratio) {
 		rt_rq->rt_throttled = 1;
-		sched_rt_ratio_dequeue(rt_rq);
-		return 1;
+		if (rt_rq_throttled(rt_rq))
+			sched_rt_ratio_dequeue(rt_rq);
 	}
 
-	return 0;
+out:
+	return rt_rq_throttled(rt_rq);
 }
 
 static void update_sched_rt_period(struct rt_rq *rt_rq)
@@ -265,6 +289,10 @@ void inc_rt_tasks(struct sched_rt_entity
 
 	update_rt_migration(rq_of_rt_rq(rt_rq));
 #endif
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	if (rt_se_boosted(rt_se))
+		rt_rq->rt_nr_boosted++;
+#endif
 }
 
 static inline
@@ -295,6 +323,12 @@ void dec_rt_tasks(struct sched_rt_entity
 
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
@@ -303,7 +337,7 @@ static void enqueue_rt_entity(struct sch
 	struct rt_prio_array *array = &rt_rq->active;
 	struct rt_rq *group_rq = group_rt_rq(rt_se);
 
-	if (group_rq && group_rq->rt_throttled)
+	if (group_rq && rt_rq_throttled(group_rq))
 		return;
 
 	list_add_tail(&rt_se->run_list, array->queue + rt_se_prio(rt_se));
@@ -476,7 +510,7 @@ static struct sched_rt_entity *pick_next
 	struct list_head *queue;
 	int idx;
 
-	if (sched_rt_ratio_exceeded(rt_rq))
+	if (rt_rq_throttled(rt_rq))
 		goto out;
 
 	idx = sched_find_first_bit(array->bitmap);
@@ -500,7 +534,7 @@ static struct task_struct *pick_next_tas
 	if (unlikely(!rt_rq->rt_nr_running))
 		return NULL;
 
-	if (sched_rt_ratio_exceeded(rt_rq))
+	if (rt_rq_throttled(rt_rq))
 		return NULL;
 
 	do {

--

