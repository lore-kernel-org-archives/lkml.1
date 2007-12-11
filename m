Return-Path: <linux-kernel-owner+w=401wt.eu-S1755784AbXLKDQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784AbXLKDQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 22:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbXLKDQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 22:16:35 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:39719 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbXLKDQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 22:16:34 -0500
Message-Id: <20071211031458.413167005@goodmis.org>
References: <20071211030033.632581735@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 10 Dec 2007 22:00:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>, vatsa@linux.vnet.ibm.com,
       Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/4 v2] Replace hooks with pre/post schedule and wakeup methods
Content-Disposition: inline; filename=sched-pre-post-schedule-methods.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make the main sched.c code more agnostic to the schedule classes.
Instead of having specific hooks in the schedule code for the RT class
balancing. They are replaced with a pre_schedule, post_schedule
and task_wake_up methods. These methods may be used by any of the classes
but currently, only the sched_rt class implements them.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/sched.h |    3 +++
 kernel/sched.c        |   20 ++++++++++++++++----
 kernel/sched_rt.c     |   17 +++++++----------
 3 files changed, 26 insertions(+), 14 deletions(-)

Index: linux-sched/include/linux/sched.h
===================================================================
--- linux-sched.orig/include/linux/sched.h	2007-12-10 20:39:11.000000000 -0500
+++ linux-sched/include/linux/sched.h	2007-12-10 20:39:14.000000000 -0500
@@ -848,6 +848,9 @@ struct sched_class {
 	int (*move_one_task) (struct rq *this_rq, int this_cpu,
 			      struct rq *busiest, struct sched_domain *sd,
 			      enum cpu_idle_type idle);
+	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
+	void (*post_schedule) (struct rq *this_rq);
+	void (*task_wake_up) (struct rq *this_rq, struct task_struct *task);
 #endif
 
 	void (*set_curr_task) (struct rq *rq);
Index: linux-sched/kernel/sched.c
===================================================================
--- linux-sched.orig/kernel/sched.c	2007-12-10 20:39:11.000000000 -0500
+++ linux-sched/kernel/sched.c	2007-12-10 20:39:14.000000000 -0500
@@ -1620,7 +1620,10 @@ out_activate:
 
 out_running:
 	p->state = TASK_RUNNING;
-	wakeup_balance_rt(rq, p);
+#ifdef CONFIG_SMP
+	if (p->sched_class->task_wake_up)
+		p->sched_class->task_wake_up(rq, p);
+#endif
 out:
 	task_rq_unlock(rq, &flags);
 
@@ -1743,7 +1746,10 @@ void fastcall wake_up_new_task(struct ta
 		inc_nr_running(p, rq);
 	}
 	check_preempt_curr(rq, p);
-	wakeup_balance_rt(rq, p);
+#ifdef CONFIG_SMP
+	if (p->sched_class->task_wake_up)
+		p->sched_class->task_wake_up(rq, p);
+#endif
 	task_rq_unlock(rq, &flags);
 }
 
@@ -1864,7 +1870,10 @@ static void finish_task_switch(struct rq
 	prev_state = prev->state;
 	finish_arch_switch(prev);
 	finish_lock_switch(rq, prev);
-	schedule_tail_balance_rt(rq);
+#ifdef CONFIG_SMP
+	if (current->sched_class->post_schedule)
+		current->sched_class->post_schedule(rq);
+#endif
 
 	fire_sched_in_preempt_notifiers(current);
 	if (mm)
@@ -3633,7 +3642,10 @@ need_resched_nonpreemptible:
 		switch_count = &prev->nvcsw;
 	}
 
-	schedule_balance_rt(rq, prev);
+#ifdef CONFIG_SMP
+	if (prev->sched_class->pre_schedule)
+		prev->sched_class->pre_schedule(rq, prev);
+#endif
 
 	if (unlikely(!rq->nr_running))
 		idle_balance(cpu, rq);
Index: linux-sched/kernel/sched_rt.c
===================================================================
--- linux-sched.orig/kernel/sched_rt.c	2007-12-10 20:39:11.000000000 -0500
+++ linux-sched/kernel/sched_rt.c	2007-12-10 20:39:14.000000000 -0500
@@ -689,14 +689,14 @@ static int pull_rt_task(struct rq *this_
 	return ret;
 }
 
-static void schedule_balance_rt(struct rq *rq, struct task_struct *prev)
+static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
 {
 	/* Try to pull RT tasks here if we lower this rq's prio */
 	if (unlikely(rt_task(prev)) && rq->rt.highest_prio > prev->prio)
 		pull_rt_task(rq);
 }
 
-static void schedule_tail_balance_rt(struct rq *rq)
+static void post_schedule_rt(struct rq *rq)
 {
 	/*
 	 * If we have more than one rt_task queued, then
@@ -713,10 +713,9 @@ static void schedule_tail_balance_rt(str
 }
 
 
-static void wakeup_balance_rt(struct rq *rq, struct task_struct *p)
+static void task_wake_up_rt(struct rq *rq, struct task_struct *p)
 {
-	if (unlikely(rt_task(p)) &&
-	    !task_running(rq, p) &&
+	if (!task_running(rq, p) &&
 	    (p->prio >= rq->rt.highest_prio) &&
 	    rq->rt.overloaded)
 		push_rt_tasks(rq);
@@ -780,11 +779,6 @@ static void leave_domain_rt(struct rq *r
 	if (rq->rt.overloaded)
 		rt_clear_overload(rq);
 }
-
-#else /* CONFIG_SMP */
-# define schedule_tail_balance_rt(rq)	do { } while (0)
-# define schedule_balance_rt(rq, prev)	do { } while (0)
-# define wakeup_balance_rt(rq, p)	do { } while (0)
 #endif /* CONFIG_SMP */
 
 static void task_tick_rt(struct rq *rq, struct task_struct *p)
@@ -838,6 +832,9 @@ const struct sched_class rt_sched_class 
 	.set_cpus_allowed       = set_cpus_allowed_rt,
 	.join_domain            = join_domain_rt,
 	.leave_domain           = leave_domain_rt,
+	.pre_schedule		= pre_schedule_rt,
+	.post_schedule		= post_schedule_rt,
+	.task_wake_up		= task_wake_up_rt,
 #endif
 
 	.set_curr_task          = set_curr_task_rt,

-- 
