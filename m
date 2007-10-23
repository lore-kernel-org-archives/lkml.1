Return-Path: <linux-kernel-owner+w=401wt.eu-S1752602AbXJWMJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbXJWMJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 08:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbXJWMJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 08:09:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbXJWMJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 08:09:07 -0400
Message-Id: <20071023120744.629752000@chello.nl>
References: <20071023120357.782284000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 23 Oct 2007 14:03:58 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Daniel Walker <dwalker@mvista.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 1/5] rt: rename rt_mutex_setprio to task_setprio
Content-Disposition: inline; filename=rt_mutex_setprio.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With there being multiple non-mutex users of this function its past time it
got renamed.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h     |    7 ++++++-
 kernel/rcupreempt-boost.c |    4 ++--
 kernel/sched.c            |    8 ++------
 3 files changed, 10 insertions(+), 9 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1655,9 +1655,14 @@ extern unsigned int sysctl_sched_compat_
 extern unsigned int sysctl_sched_child_runs_first;
 extern unsigned int sysctl_sched_features;
 
+extern void task_setprio(struct task_struct *p, int prio);
+
 #ifdef CONFIG_RT_MUTEXES
 extern int rt_mutex_getprio(struct task_struct *p);
-extern void rt_mutex_setprio(struct task_struct *p, int prio);
+static inline void rt_mutex_setprio(struct task_struct *p, int prio)
+{
+	task_setprio(p, prio);
+}
 extern void rt_mutex_adjust_pi(struct task_struct *p);
 #else
 static inline int rt_mutex_getprio(struct task_struct *p)
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4445,10 +4445,8 @@ long __sched sleep_on_timeout(wait_queue
 }
 EXPORT_SYMBOL(sleep_on_timeout);
 
-#ifdef CONFIG_RT_MUTEXES
-
 /*
- * rt_mutex_setprio - set the current priority of a task
+ * task_setprio - set the current priority of a task
  * @p: task
  * @prio: prio value (kernel-internal form)
  *
@@ -4457,7 +4455,7 @@ EXPORT_SYMBOL(sleep_on_timeout);
  *
  * Used by the rt_mutex code to implement priority inheritance logic.
  */
-void rt_mutex_setprio(struct task_struct *p, int prio)
+void task_setprio(struct task_struct *p, int prio)
 {
 	unsigned long flags;
 	int oldprio, prev_resched, on_rq;
@@ -4522,8 +4520,6 @@ out_unlock:
 	task_rq_unlock(rq, &flags);
 }
 
-#endif
-
 void set_user_nice(struct task_struct *p, long nice)
 {
 	int old_prio, delta, on_rq;
Index: linux-2.6/kernel/rcupreempt-boost.c
===================================================================
--- linux-2.6.orig/kernel/rcupreempt-boost.c
+++ linux-2.6/kernel/rcupreempt-boost.c
@@ -233,7 +233,7 @@ static void rcu_boost_task(struct task_s
 
 	if (task->rcu_prio < task->prio) {
 		rcu_trace_boost_task_boosted(RCU_BOOST_ME);
-		rt_mutex_setprio(task, task->rcu_prio);
+		task_setprio(task, task->rcu_prio);
 	}
 }
 
@@ -325,7 +325,7 @@ void __rcu_preempt_unboost(void)
 
 	spin_lock(&curr->pi_lock);
 	prio = rt_mutex_getprio(curr);
-	rt_mutex_setprio(curr, prio);
+	task_setprio(curr, prio);
 
 	curr->rcub_rbdp = NULL;
 

--

