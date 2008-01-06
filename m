Return-Path: <linux-kernel-owner+w=401wt.eu-S1752769AbYAFQXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbYAFQXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757248AbYAFQXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:23:18 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:14082 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756890AbYAFQXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:23:15 -0500
Message-Id: <20080106162124.660513000@chello.nl>
References: <20080106161128.152634000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sun, 06 Jan 2008 17:11:38 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 10/11] sched: rt-group: EDF
Content-Disposition: inline; filename=sched-rt-group-edf.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a simple Ealiest Deadline First implementation to schedule the realtime
groups.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    1 
 kernel/sched.c        |   13 +++++
 kernel/sched_rt.c     |  115 +++++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 124 insertions(+), 5 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -942,6 +942,7 @@ struct sched_rt_entity {
 	int nr_cpus_allowed;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
+	struct rb_node		run_node;
 	struct sched_rt_entity	*parent;
 	/* rq on which this entity is (to be) queued: */
 	struct rt_rq		*rt_rq;
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -360,6 +360,11 @@ struct cfs_rq {
 #endif
 };
 
+enum rt_rq_type {
+	RT_RQ_PRIO,
+	RT_RQ_EDF,
+};
+
 /* Real-Time classes' related field in a runqueue: */
 struct rt_rq {
 	struct rt_prio_array active;
@@ -376,6 +381,10 @@ struct rt_rq {
 	struct hrtimer rt_period_timer;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
+	enum rt_rq_type rt_rq_type;
+	struct rb_root deadlines;
+	struct rb_node *rb_leftmost;
+
 	unsigned long rt_nr_boosted;
 
 	struct rq *rq;
@@ -7127,6 +7136,9 @@ static void init_rt_rq(struct rt_rq *rt_
 	rt_rq->rt_period_timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
+	rt_rq->rt_rq_type = RT_RQ_PRIO;
+	rt_rq->deadlines = RB_ROOT;
+	rt_rq->rb_leftmost = NULL;
 	rt_rq->rt_nr_boosted = 0;
 	rt_rq->rq = rq;
 #endif
@@ -7196,6 +7208,7 @@ void __init sched_init(void)
 				&per_cpu(init_cfs_rq, i),
 				&per_cpu(init_sched_entity, i), i, 1);
 
+		rq->rt.rt_rq_type = RT_RQ_EDF;
 		init_task_group.rt_ratio = sysctl_sched_rt_ratio; /* XXX */
 		init_task_group.rt_period =
 			ns_to_ktime(sysctl_sched_rt_period * NSEC_PER_USEC);
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -138,6 +138,84 @@ static int rt_se_boosted(struct sched_rt
 	return p->prio != p->normal_prio;
 }
 
+static inline u64 rt_deadline(struct sched_rt_entity *rt_se)
+{
+	struct rt_rq *group_rq = group_rt_rq(rt_se);
+
+	BUG_ON(!group_rq);
+	return ktime_to_ns(group_rq->rt_period_timer.expires);
+}
+
+static void enqueue_rt_deadline(struct sched_rt_entity *rt_se)
+{
+	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
+	struct rb_node **link;
+	struct rb_node *parent;
+	struct sched_rt_entity *entry;
+	u64 deadline;
+	int leftmost = 1;
+
+	if (rt_rq->rt_rq_type != RT_RQ_EDF)
+		return;
+
+	link = &rt_rq->deadlines.rb_node;
+	parent = NULL;
+	deadline = rt_deadline(rt_se);
+
+	while (*link) {
+		parent = *link;
+		entry = rb_entry(parent, struct sched_rt_entity, run_node);
+
+		if (deadline < rt_deadline(entry)) {
+			link = &parent->rb_left;
+		} else {
+			link = &parent->rb_right;
+			leftmost = 0;
+		}
+	}
+
+	if (leftmost)
+		rt_rq->rb_leftmost = &rt_se->run_node;
+
+	rb_link_node(&rt_se->run_node, parent, link);
+	rb_insert_color(&rt_se->run_node, &rt_rq->deadlines);
+}
+
+static void dequeue_rt_deadline(struct sched_rt_entity *rt_se)
+{
+	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
+
+	if (rt_rq->rt_rq_type != RT_RQ_EDF)
+		return;
+
+	if (rt_rq->rb_leftmost == &rt_se->run_node)
+		rt_rq->rb_leftmost = rb_next(&rt_se->run_node);
+
+	rb_erase(&rt_se->run_node, &rt_rq->deadlines);
+}
+
+static void requeue_rt_deadline(struct rt_rq *rt_rq)
+{
+	struct sched_rt_entity *rt_se = rt_rq->rt_se;
+
+	BUG_ON(!rt_se);
+	if (on_rt_rq(rt_se)) {
+		dequeue_rt_deadline(rt_se);
+		enqueue_rt_deadline(rt_se);
+	}
+}
+
+static struct sched_rt_entity *next_rt_deadline(struct rt_rq *rt_rq)
+{
+	if (rt_rq->rt_rq_type != RT_RQ_EDF)
+		return NULL;
+
+	if (!rt_rq->rb_leftmost)
+		return NULL;
+
+	return rb_entry(rt_rq->rb_leftmost, struct sched_rt_entity, run_node);
+}
+
 #else
 
 static inline unsigned int sched_rt_ratio(struct rt_rq *rt_rq)
@@ -191,6 +269,23 @@ static inline int rt_rq_throttled(struct
 {
 	return rt_rq->rt_throttled;
 }
+
+static inline void enqueue_rt_deadline(struct sched_rt_entity *rt_se)
+{
+}
+
+static inline void dequeue_rt_deadline(struct sched_rt_entity *rt_se)
+{
+}
+
+static inline void requeue_rt_deadline(struct rt_rq *rt_rq)
+{
+}
+
+static inline struct sched_rt_entity *next_rt_deadline(struct rt_rq *rt_rq)
+{
+	return NULL;
+}
 #endif
 
 static inline int rt_se_prio(struct sched_rt_entity *rt_se)
@@ -254,12 +349,13 @@ static enum hrtimer_restart sched_rt_per
 	WARN_ON(smp_processor_id() != cpu_of(rq));
 	WARN_ON(!in_irq());
 
+	hrtimer_forward(timer, now, sched_rt_period(rt_rq));
+
 	spin_lock(&rq->lock);
+	requeue_rt_deadline(rt_rq);
 	update_sched_rt_period(rt_rq);
 	spin_unlock(&rq->lock);
 
-	hrtimer_forward(timer, now, sched_rt_period(rt_rq));
-
 	return HRTIMER_RESTART;
 }
 
@@ -283,6 +379,8 @@ static void sched_rt_period_start(struct
 		if (hrtimer_active(&rt_rq->rt_period_timer))
 			break;
 	}
+
+	requeue_rt_deadline(rt_rq);
 }
 
 static void sched_rt_period_stop(struct rt_rq *rt_rq)
@@ -393,6 +491,8 @@ static void enqueue_rt_entity(struct sch
 	list_add_tail(&rt_se->run_list, array->queue + rt_se_prio(rt_se));
 	__set_bit(rt_se_prio(rt_se), array->bitmap);
 
+	enqueue_rt_deadline(rt_se);
+
 	inc_rt_tasks(rt_se, rt_rq);
 }
 
@@ -405,6 +505,8 @@ static void dequeue_rt_entity(struct sch
 	if (list_empty(array->queue + rt_se_prio(rt_se)))
 		__clear_bit(rt_se_prio(rt_se), array->bitmap);
 
+	dequeue_rt_deadline(rt_se);
+
 	dec_rt_tasks(rt_se, rt_rq);
 }
 
@@ -552,8 +654,7 @@ static void check_preempt_curr_rt(struct
 		resched_task(rq->curr);
 }
 
-static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq,
-						   struct rt_rq *rt_rq)
+static struct sched_rt_entity *pick_next_rt_entity(struct rt_rq *rt_rq)
 {
 	struct rt_prio_array *array = &rt_rq->active;
 	struct sched_rt_entity *next = NULL;
@@ -563,6 +664,10 @@ static struct sched_rt_entity *pick_next
 	if (rt_rq_throttled(rt_rq))
 		goto out;
 
+	next = next_rt_deadline(rt_rq);
+	if (next)
+		goto out;
+
 	idx = sched_find_first_bit(array->bitmap);
 	BUG_ON(idx >= MAX_RT_PRIO);
 
@@ -588,7 +693,7 @@ static struct task_struct *pick_next_tas
 		return NULL;
 
 	do {
-		rt_se = pick_next_rt_entity(rq, rt_rq);
+		rt_se = pick_next_rt_entity(rt_rq);
 		if (unlikely(!rt_se))
 			goto retry;
 		rt_rq = group_rt_rq(rt_se);

--

