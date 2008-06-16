Return-Path: <linux-kernel-owner+w=401wt.eu-S1757513AbYFPUXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbYFPUXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 16:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbYFPUWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 16:22:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40371 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbYFPUWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 16:22:54 -0400
Subject: [RFC][PATCH] fix SCHED_FIFO spec violation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 22:22:25 +0200
Message-Id: <1213647746.3223.73.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

It came to my attention that we violate the SCHED_FIFO spec when
un-boosting tasks in that we should move them to the head of the lower
priority queue instead of to the tail.

[1] http://www.opengroup.org/onlinepubs/009695399/functions/xsh_chap02_08.html#tag_02_08_04_01
[2] http://www.opengroup.org/onlinepubs/009695399/functions/pthread_mutexattr_setprotocol.html

Also, while doing this patch, I noticed that the rt-group code further
violates the spec by re-ordering the upper level entries. Any bright
ideas? - if not I'll probably attempt the brute force method.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/include/linux/sched.h b/include/linux/sched.h
index c5d3f84..0db49d5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -888,11 +888,16 @@ struct uts_namespace;
 struct rq;
 struct sched_domain;
 
+#define ENQUEUE_WAKEUP	0x01
+#define ENQUEUE_HEAD	0x02
+
+#define DEQUEUE_SLEEP	0x01
+
 struct sched_class {
 	const struct sched_class *next;
 
-	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
-	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
+	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int flags);
+	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int flags);
 	void (*yield_task) (struct rq *rq);
 	int  (*select_task_rq)(struct task_struct *p, int sync);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index eaf6751..f594f17 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1432,7 +1432,7 @@ static const u32 prio_to_wmult[40] = {
  /*  15 */ 119304647, 148102320, 186737708, 238609294, 286331153,
 };
 
-static void activate_task(struct rq *rq, struct task_struct *p, int wakeup);
+static void activate_task(struct rq *rq, struct task_struct *p, int flags);
 
 /*
  * runqueue iterator, to support SMP load-balancing between different
@@ -1542,16 +1542,16 @@ static void set_load_weight(struct task_struct *p)
 	p->se.load.inv_weight = prio_to_wmult[p->static_prio - MAX_RT_PRIO];
 }
 
-static void enqueue_task(struct rq *rq, struct task_struct *p, int wakeup)
+static void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	sched_info_queued(p);
-	p->sched_class->enqueue_task(rq, p, wakeup);
+	p->sched_class->enqueue_task(rq, p, flags);
 	p->se.on_rq = 1;
 }
 
-static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
+static void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
 {
-	p->sched_class->dequeue_task(rq, p, sleep);
+	p->sched_class->dequeue_task(rq, p, flags);
 	p->se.on_rq = 0;
 }
 
@@ -1604,24 +1604,24 @@ static int effective_prio(struct task_struct *p)
 /*
  * activate_task - move a task to the runqueue.
  */
-static void activate_task(struct rq *rq, struct task_struct *p, int wakeup)
+static void activate_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible--;
 
-	enqueue_task(rq, p, wakeup);
+	enqueue_task(rq, p, flags);
 	inc_nr_running(p, rq);
 }
 
 /*
  * deactivate_task - remove a task from the runqueue.
  */
-static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep)
+static void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
 {
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible++;
 
-	dequeue_task(rq, p, sleep);
+	dequeue_task(rq, p, flags);
 	dec_nr_running(p, rq);
 }
 
@@ -2143,7 +2143,7 @@ out_activate:
 	else
 		schedstat_inc(p, se.nr_wakeups_remote);
 	update_rq_clock(rq);
-	activate_task(rq, p, 1);
+	activate_task(rq, p, ENQUEUE_WAKEUP);
 	success = 1;
 
 out_running:
@@ -4170,7 +4170,7 @@ need_resched_nonpreemptible:
 		if (unlikely(signal_pending_state(prev->state, prev)))
 			prev->state = TASK_RUNNING;
 		else
-			deactivate_task(rq, prev, 1);
+			deactivate_task(rq, prev, DEQUEUE_SLEEP);
 		switch_count = &prev->nvcsw;
 	}
 
@@ -4525,7 +4525,7 @@ EXPORT_SYMBOL(sleep_on_timeout);
 void rt_mutex_setprio(struct task_struct *p, int prio)
 {
 	unsigned long flags;
-	int oldprio, on_rq, running;
+	int oldprio, on_rq, running, down;
 	struct rq *rq;
 	const struct sched_class *prev_class = p->sched_class;
 
@@ -4547,12 +4547,13 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	else
 		p->sched_class = &fair_sched_class;
 
+	down = (prio > p->prio) ? ENQUEUE_HEAD : 0;
 	p->prio = prio;
 
 	if (running)
 		p->sched_class->set_curr_task(rq);
 	if (on_rq) {
-		enqueue_task(rq, p, 0);
+		enqueue_task(rq, p, down);
 
 		check_class_changed(rq, p, prev_class, oldprio, running);
 	}
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 08ae848..b545eeb 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -847,10 +847,11 @@ hrtick_start_fair(struct rq *rq, struct task_struct *p)
  * increased. Here we update the fair scheduling stats and
  * then put the task into the rbtree:
  */
-static void enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup)
+static void enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
+	int wakeup = flags & ENQUEUE_WAKEUP;
 
 	for_each_sched_entity(se) {
 		if (se->on_rq)
@@ -868,10 +869,11 @@ static void enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup)
  * decreased. We remove the task from the rbtree and
  * update the fair scheduling stats:
  */
-static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int sleep)
+static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
+	int sleep = flags & DEQUEUE_SLEEP;
 
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 3a4f92d..0819086 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -31,7 +31,7 @@ static struct task_struct *pick_next_task_idle(struct rq *rq)
  * message if some code attempts to do it:
  */
 static void
-dequeue_task_idle(struct rq *rq, struct task_struct *p, int sleep)
+dequeue_task_idle(struct rq *rq, struct task_struct *p, int flags)
 {
 	spin_unlock_irq(&rq->lock);
 	printk(KERN_ERR "bad: scheduling from the idle thread!\n");
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 3432d57..0134f7c 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -91,7 +91,7 @@ static inline struct rt_rq *group_rt_rq(struct sched_rt_entity *rt_se)
 	return rt_se->my_q;
 }
 
-static void enqueue_rt_entity(struct sched_rt_entity *rt_se);
+static void enqueue_rt_entity(struct sched_rt_entity *rt_se, int flags);
 static void dequeue_rt_entity(struct sched_rt_entity *rt_se);
 
 static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
@@ -101,7 +101,7 @@ static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 	if (rt_se && !on_rt_rq(rt_se) && rt_rq->rt_nr_running) {
 		struct task_struct *curr = rq_of_rt_rq(rt_rq)->curr;
 
-		enqueue_rt_entity(rt_se);
+		enqueue_rt_entity(rt_se, 0);
 		if (rt_rq->highest_prio < curr->prio)
 			resched_task(curr);
 	}
@@ -449,16 +449,21 @@ void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 #endif
 }
 
-static void enqueue_rt_entity(struct sched_rt_entity *rt_se)
+static void enqueue_rt_entity(struct sched_rt_entity *rt_se, int flags)
 {
 	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
 	struct rt_prio_array *array = &rt_rq->active;
 	struct rt_rq *group_rq = group_rt_rq(rt_se);
+	struct list_head *queue = array->queue + rt_se_prio(rt_se);
 
 	if (group_rq && rt_rq_throttled(group_rq))
 		return;
 
-	list_add_tail(&rt_se->run_list, array->queue + rt_se_prio(rt_se));
+	if (unlikely(flags & ENQUEUE_HEAD))
+	 	list_add(&rt_se->run_list, queue);
+	else
+	 	list_add_tail(&rt_se->run_list, queue);
+
 	__set_bit(rt_se_prio(rt_se), array->bitmap);
 
 	inc_rt_tasks(rt_se, rt_rq);
@@ -499,29 +504,35 @@ static void dequeue_rt_stack(struct task_struct *p)
 /*
  * Adding/removing a task to/from a priority array:
  */
-static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)
+static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct sched_rt_entity *rt_se = &p->rt;
 
-	if (wakeup)
+	if (flags & ENQUEUE_WAKEUP)
 		rt_se->timeout = 0;
 
+	/*
+	 * XXX: destroys queue order, how to fix?
+	 */
 	dequeue_rt_stack(p);
 
 	/*
 	 * enqueue everybody, bottom - up.
 	 */
 	for_each_sched_rt_entity(rt_se)
-		enqueue_rt_entity(rt_se);
+		enqueue_rt_entity(rt_se, flags & ENQUEUE_HEAD);
 }
 
-static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
+static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct sched_rt_entity *rt_se = &p->rt;
 	struct rt_rq *rt_rq;
 
 	update_curr_rt(rq);
 
+	/*
+	 * XXX: destroys queue order, how to fix?
+	 */
 	dequeue_rt_stack(p);
 
 	/*
@@ -530,7 +541,7 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
 	for_each_sched_rt_entity(rt_se) {
 		rt_rq = group_rt_rq(rt_se);
 		if (rt_rq && rt_rq->rt_nr_running)
-			enqueue_rt_entity(rt_se);
+			enqueue_rt_entity(rt_se, 0);
 	}
 }
 


