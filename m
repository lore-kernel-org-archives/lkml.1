Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbXLKDQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbXLKDQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 22:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbXLKDQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 22:16:19 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:39472 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbXLKDQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 22:16:18 -0500
Message-Id: <20071211031458.561198452@goodmis.org>
References: <20071211030033.632581735@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 10 Dec 2007 22:00:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>, vatsa@linux.vnet.ibm.com,
       Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/4 v2] added methods for sched_class changes
Content-Disposition: inline; filename=sched-handle-class-switch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko found that the current implementation of the RT
balancing code left out changes to the sched_setscheduler and rt_mutex_setprio.

This patch addresses this issue by adding methods to the schedule classes to
handle being switched out of (switched_from) and being switched into
(switched_to) a sched_class. Also a method for changing of priorities
is also added (prio_changed).

This patch also removes some duplicate logic between rt_mutex_setprio and
sched_setscheduler.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/sched.h   |    7 +++
 kernel/sched.c          |   42 ++++++++++------------
 kernel/sched_fair.c     |   39 +++++++++++++++++++++
 kernel/sched_idletask.c |   31 ++++++++++++++++
 kernel/sched_rt.c       |   89 ++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 186 insertions(+), 22 deletions(-)

Index: linux-sched/include/linux/sched.h
===================================================================
--- linux-sched.orig/include/linux/sched.h	2007-12-10 20:39:14.000000000 -0500
+++ linux-sched/include/linux/sched.h	2007-12-10 20:39:17.000000000 -0500
@@ -860,6 +860,13 @@ struct sched_class {
 
 	void (*join_domain)(struct rq *rq);
 	void (*leave_domain)(struct rq *rq);
+
+	void (*switched_from) (struct rq *this_rq, struct task_struct *task,
+			       int running);
+	void (*switched_to) (struct rq *this_rq, struct task_struct *task,
+			     int running);
+	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
+			     int oldprio, int running);
 };
 
 struct load_weight {
Index: linux-sched/kernel/sched.c
===================================================================
--- linux-sched.orig/kernel/sched.c	2007-12-10 20:39:14.000000000 -0500
+++ linux-sched/kernel/sched.c	2007-12-10 20:39:17.000000000 -0500
@@ -1147,6 +1147,18 @@ static inline void __set_task_cpu(struct
 #endif
 }
 
+static inline void check_class_changed(struct rq *rq, struct task_struct *p,
+				       const struct sched_class *prev_class,
+				       int oldprio, int running)
+{
+	if (prev_class != p->sched_class) {
+		if (prev_class->switched_from)
+			prev_class->switched_from(rq, p, running);
+		p->sched_class->switched_to(rq, p, running);
+	} else
+		p->sched_class->prio_changed(rq, p, oldprio, running);
+}
+
 #ifdef CONFIG_SMP
 
 /*
@@ -4012,6 +4024,7 @@ void rt_mutex_setprio(struct task_struct
 	unsigned long flags;
 	int oldprio, on_rq, running;
 	struct rq *rq;
+	const struct sched_class *prev_class = p->sched_class;
 
 	BUG_ON(prio < 0 || prio > MAX_PRIO);
 
@@ -4037,18 +4050,10 @@ void rt_mutex_setprio(struct task_struct
 	if (on_rq) {
 		if (running)
 			p->sched_class->set_curr_task(rq);
+
 		enqueue_task(rq, p, 0);
-		/*
-		 * Reschedule if we are currently running on this runqueue and
-		 * our priority decreased, or if we are not currently running on
-		 * this runqueue and our priority is higher than the current's
-		 */
-		if (running) {
-			if (p->prio > oldprio)
-				resched_task(rq->curr);
-		} else {
-			check_preempt_curr(rq, p);
-		}
+
+		check_class_changed(rq, p, prev_class, oldprio, running);
 	}
 	task_rq_unlock(rq, &flags);
 }
@@ -4248,6 +4253,7 @@ int sched_setscheduler(struct task_struc
 {
 	int retval, oldprio, oldpolicy = -1, on_rq, running;
 	unsigned long flags;
+	const struct sched_class *prev_class = p->sched_class;
 	struct rq *rq;
 
 	/* may grab non-irq protected spin_locks */
@@ -4341,18 +4347,10 @@ recheck:
 	if (on_rq) {
 		if (running)
 			p->sched_class->set_curr_task(rq);
+
 		activate_task(rq, p, 0);
-		/*
-		 * Reschedule if we are currently running on this runqueue and
-		 * our priority decreased, or if we are not currently running on
-		 * this runqueue and our priority is higher than the current's
-		 */
-		if (running) {
-			if (p->prio > oldprio)
-				resched_task(rq->curr);
-		} else {
-			check_preempt_curr(rq, p);
-		}
+
+		check_class_changed(rq, p, prev_class, oldprio, running);
 	}
 	__task_rq_unlock(rq);
 	spin_unlock_irqrestore(&p->pi_lock, flags);
Index: linux-sched/kernel/sched_fair.c
===================================================================
--- linux-sched.orig/kernel/sched_fair.c	2007-12-10 20:39:11.000000000 -0500
+++ linux-sched/kernel/sched_fair.c	2007-12-10 20:39:17.000000000 -0500
@@ -1280,6 +1280,42 @@ static void task_new_fair(struct rq *rq,
 	resched_task(rq->curr);
 }
 
+/*
+ * Priority of the task has changed. Check to see if we preempt
+ * the current task.
+ */
+static void prio_changed_fair(struct rq *rq, struct task_struct *p,
+			      int oldprio, int running)
+{
+	/*
+	 * Reschedule if we are currently running on this runqueue and
+	 * our priority decreased, or if we are not currently running on
+	 * this runqueue and our priority is higher than the current's
+	 */
+	if (running) {
+		if (p->prio > oldprio)
+			resched_task(rq->curr);
+	} else
+		check_preempt_curr(rq, p);
+}
+
+/*
+ * We switched to the sched_fair class.
+ */
+static void switched_to_fair(struct rq *rq, struct task_struct *p,
+			     int running)
+{
+	/*
+	 * We were most likely switched from sched_rt, so
+	 * kick off the schedule if running, otherwise just see
+	 * if we can still preempt the current task.
+	 */
+	if (running)
+		resched_task(rq->curr);
+	else
+		check_preempt_curr(rq, p);
+}
+
 /* Account for a task changing its policy or group.
  *
  * This routine is mostly called to set cfs_rq->curr field when a task
@@ -1318,6 +1354,9 @@ static const struct sched_class fair_sch
 	.set_curr_task          = set_curr_task_fair,
 	.task_tick		= task_tick_fair,
 	.task_new		= task_new_fair,
+
+	.prio_changed		= prio_changed_fair,
+	.switched_to		= switched_to_fair,
 };
 
 #ifdef CONFIG_SCHED_DEBUG
Index: linux-sched/kernel/sched_idletask.c
===================================================================
--- linux-sched.orig/kernel/sched_idletask.c	2007-12-10 20:39:11.000000000 -0500
+++ linux-sched/kernel/sched_idletask.c	2007-12-10 20:39:17.000000000 -0500
@@ -69,6 +69,33 @@ static void set_curr_task_idle(struct rq
 {
 }
 
+static void switched_to_idle(struct rq *rq, struct task_struct *p,
+			     int running)
+{
+	/* Can this actually happen?? */
+	if (running)
+		resched_task(rq->curr);
+	else
+		check_preempt_curr(rq, p);
+}
+
+static void prio_changed_idle(struct rq *rq, struct task_struct *p,
+			      int oldprio, int running)
+{
+	/* This can happen for hot plug CPUS */
+
+	/*
+	 * Reschedule if we are currently running on this runqueue and
+	 * our priority decreased, or if we are not currently running on
+	 * this runqueue and our priority is higher than the current's
+	 */
+	if (running) {
+		if (p->prio > oldprio)
+			resched_task(rq->curr);
+	} else
+		check_preempt_curr(rq, p);
+}
+
 /*
  * Simple, special scheduling class for the per-CPU idle tasks:
  */
@@ -94,5 +121,9 @@ const struct sched_class idle_sched_clas
 
 	.set_curr_task          = set_curr_task_idle,
 	.task_tick		= task_tick_idle,
+
+	.prio_changed		= prio_changed_idle,
+	.switched_to		= switched_to_idle,
+
 	/* no .task_new for idle tasks */
 };
Index: linux-sched/kernel/sched_rt.c
===================================================================
--- linux-sched.orig/kernel/sched_rt.c	2007-12-10 20:39:14.000000000 -0500
+++ linux-sched/kernel/sched_rt.c	2007-12-10 20:39:17.000000000 -0500
@@ -779,7 +779,92 @@ static void leave_domain_rt(struct rq *r
 	if (rq->rt.overloaded)
 		rt_clear_overload(rq);
 }
+
+/*
+ * When switch from the rt queue, we bring ourselves to a position
+ * that we might want to pull RT tasks from other runqueues.
+ */
+static void switched_from_rt(struct rq *rq, struct task_struct *p,
+			   int running)
+{
+	/*
+	 * If there are other RT tasks then we will reschedule
+	 * and the scheduling of the other RT tasks will handle
+	 * the balancing. But if we are the last RT task
+	 * we may need to handle the pulling of RT tasks
+	 * now.
+	 */
+	if (!rq->rt.rt_nr_running)
+		pull_rt_task(rq);
+}
+#endif /* CONFIG_SMP */
+
+/*
+ * When switching a task to RT, we may overload the runqueue
+ * with RT tasks. In this case we try to push them off to
+ * other runqueues.
+ */
+static void switched_to_rt(struct rq *rq, struct task_struct *p,
+			   int running)
+{
+	int check_resched = 1;
+
+	/*
+	 * If we are already running, then there's nothing
+	 * that needs to be done. But if we are not running
+	 * we may need to preempt the current running task.
+	 * If that current running task is also an RT task
+	 * then see if we can move to another run queue.
+	 */
+	if (!running) {
+#ifdef CONFIG_SMP
+		if (rq->rt.overloaded && push_rt_task(rq) &&
+		    /* Don't resched if we changed runqueues */
+		    rq != task_rq(p))
+			check_resched = 0;
 #endif /* CONFIG_SMP */
+		if (check_resched && p->prio < rq->curr->prio)
+			resched_task(rq->curr);
+	}
+}
+
+/*
+ * Priority of the task has changed. This may cause
+ * us to initiate a push or pull.
+ */
+static void prio_changed_rt(struct rq *rq, struct task_struct *p,
+			    int oldprio, int running)
+{
+	if (running) {
+#ifdef CONFIG_SMP
+		/*
+		 * If our priority decreases while running, we
+		 * may need to pull tasks to this runqueue.
+		 */
+		if (oldprio < p->prio)
+			pull_rt_task(rq);
+		/*
+		 * If there's a higher priority task waiting to run
+		 * then reschedule.
+		 */
+		if (p->prio > rq->rt.highest_prio)
+			resched_task(p);
+#else
+		/* For UP simply resched on drop of prio */
+		if (oldprio < p->prio)
+			resched_task(p);
+#endif /* CONFIG_SMP */
+	} else {
+		/*
+		 * This task is not running, but if it is
+		 * greater than the current running task
+		 * then reschedule.
+		 */
+		if (p->prio < rq->curr->prio)
+			resched_task(rq->curr);
+	}
+}
+
 
 static void task_tick_rt(struct rq *rq, struct task_struct *p)
 {
@@ -835,8 +920,12 @@ const struct sched_class rt_sched_class 
 	.pre_schedule		= pre_schedule_rt,
 	.post_schedule		= post_schedule_rt,
 	.task_wake_up		= task_wake_up_rt,
+	.switched_from		= switched_from_rt,
 #endif
 
 	.set_curr_task          = set_curr_task_rt,
 	.task_tick		= task_tick_rt,
+
+	.prio_changed		= prio_changed_rt,
+	.switched_to		= switched_to_rt,
 };

-- 
