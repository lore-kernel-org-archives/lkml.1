Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112Ab0ATU7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab0ATU7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690Ab0ATU7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:59:44 -0500
Received: from www.tglx.de ([62.245.132.106]:42998 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab0ATU7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:59:44 -0500
Message-Id: <20100120171629.734886007@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 20 Jan 2010 20:58:57 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Carsten Emde <cbe@osadl.org>,
       Mathias Weber <mathias.weber.mw1@roche.com>
Subject: [patch 1/3] sched: Extend enqueue_task to allow head queueing
References: <20100120171231.922420383@linutronix.de>
Content-Disposition: inline;
	filename=sched-extend-enqueue-task-to-allow-head-queueing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ability of enqueueing a task to the head of a SCHED_FIFO priority
list is required to fix some violations of POSIX scheduling policy.

Extend the related functions with a "head" argument.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched.h |    3 ++-
 kernel/sched.c        |   13 +++++++------
 kernel/sched_fair.c   |    3 ++-
 kernel/sched_rt.c     |    3 ++-
 4 files changed, 13 insertions(+), 9 deletions(-)

Index: linux-2.6-tip/include/linux/sched.h
===================================================================
--- linux-2.6-tip.orig/include/linux/sched.h
+++ linux-2.6-tip/include/linux/sched.h
@@ -1075,7 +1075,8 @@ struct sched_domain;
 struct sched_class {
 	const struct sched_class *next;
 
-	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
+	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup,
+			      bool head);
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
 	void (*yield_task) (struct rq *rq);
 
Index: linux-2.6-tip/kernel/sched.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched.c
+++ linux-2.6-tip/kernel/sched.c
@@ -1883,13 +1883,14 @@ static void update_avg(u64 *avg, u64 sam
 	*avg += diff >> 3;
 }
 
-static void enqueue_task(struct rq *rq, struct task_struct *p, int wakeup)
+static void
+enqueue_task(struct rq *rq, struct task_struct *p, int wakeup, bool head)
 {
 	if (wakeup)
 		p->se.start_runtime = p->se.sum_exec_runtime;
 
 	sched_info_queued(p);
-	p->sched_class->enqueue_task(rq, p, wakeup);
+	p->sched_class->enqueue_task(rq, p, wakeup, head);
 	p->se.on_rq = 1;
 }
 
@@ -1965,7 +1966,7 @@ static void activate_task(struct rq *rq,
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible--;
 
-	enqueue_task(rq, p, wakeup);
+	enqueue_task(rq, p, wakeup, false);
 	inc_nr_running(rq);
 }
 
@@ -6065,7 +6066,7 @@ void rt_mutex_setprio(struct task_struct
 	if (running)
 		p->sched_class->set_curr_task(rq);
 	if (on_rq) {
-		enqueue_task(rq, p, 0);
+		enqueue_task(rq, p, 0, false);
 
 		check_class_changed(rq, p, prev_class, oldprio, running);
 	}
@@ -6109,7 +6110,7 @@ void set_user_nice(struct task_struct *p
 	delta = p->prio - old_prio;
 
 	if (on_rq) {
-		enqueue_task(rq, p, 0);
+		enqueue_task(rq, p, 0, false);
 		/*
 		 * If the task increased its priority or is running and
 		 * lowered its priority, then reschedule its CPU:
@@ -10110,7 +10111,7 @@ void sched_move_task(struct task_struct 
 	if (unlikely(running))
 		tsk->sched_class->set_curr_task(rq);
 	if (on_rq)
-		enqueue_task(rq, tsk, 0);
+		enqueue_task(rq, tsk, 0, false);
 
 	task_rq_unlock(rq, &flags);
 }
Index: linux-2.6-tip/kernel/sched_fair.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched_fair.c
+++ linux-2.6-tip/kernel/sched_fair.c
@@ -1053,7 +1053,8 @@ static inline void hrtick_update(struct 
  * increased. Here we update the fair scheduling stats and
  * then put the task into the rbtree:
  */
-static void enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup)
+static void
+enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup, bool head)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
Index: linux-2.6-tip/kernel/sched_rt.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched_rt.c
+++ linux-2.6-tip/kernel/sched_rt.c
@@ -878,7 +878,8 @@ static void dequeue_rt_entity(struct sch
 /*
  * Adding/removing a task to/from a priority array:
  */
-static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)
+static void
+enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup, bool head)
 {
 	struct sched_rt_entity *rt_se = &p->rt;
 


