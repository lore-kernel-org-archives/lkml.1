Return-Path: <linux-kernel-owner+w=401wt.eu-S1751889AbZLIIc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbZLIIc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 03:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbZLIIc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 03:32:28 -0500
Received: from www.tglx.de ([62.245.132.106]:53463 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbZLIIc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 03:32:27 -0500
Date: Wed, 9 Dec 2009 09:32:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [patch V2 sched: Protect sched_rr_get_param access to
 task->sched_class
In-Reply-To: <alpine.LFD.2.00.0912090905210.3089@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0912090930120.3089@localhost.localdomain>
References: <20091208202026.804386447@linutronix.de>  <1260345648.5489.65.camel@laptop> <1260345798.5489.70.camel@laptop> <alpine.LFD.2.00.0912090905210.3089@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched_rr_get_param calls task->sched_class->get_rr_interval(task)
without protection against a concurrent sched_setscheduler() call
which modifies task->sched_class.

Serialize the access with task_rq_lock(task) and hand the rq pointer
into get_rr_interval() as it's needed at least in the sched_fair
implementation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched.h   |    3 ++-
 kernel/sched.c          |    6 +++++-
 kernel/sched_fair.c     |    6 +-----
 kernel/sched_idletask.c |    2 +-
 kernel/sched_rt.c       |    2 +-
 5 files changed, 10 insertions(+), 9 deletions(-)

Index: linux-2.6-tip/include/linux/sched.h
===================================================================
--- linux-2.6-tip.orig/include/linux/sched.h
+++ linux-2.6-tip/include/linux/sched.h
@@ -1111,7 +1111,8 @@ struct sched_class {
 	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
 			     int oldprio, int running);
 
-	unsigned int (*get_rr_interval) (struct task_struct *task);
+	unsigned int (*get_rr_interval) (struct rq *rq,
+					 struct task_struct *task);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	void (*moved_group) (struct task_struct *p);
Index: linux-2.6-tip/kernel/sched.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched.c
+++ linux-2.6-tip/kernel/sched.c
@@ -6887,6 +6887,8 @@ SYSCALL_DEFINE2(sched_rr_get_interval, p
 {
 	struct task_struct *p;
 	unsigned int time_slice;
+	unsigned long flags;
+	struct rq *rq;
 	int retval;
 	struct timespec t;
 
@@ -6903,7 +6905,9 @@ SYSCALL_DEFINE2(sched_rr_get_interval, p
 	if (retval)
 		goto out_unlock;
 
-	time_slice = p->sched_class->get_rr_interval(p);
+	rq = task_rq_lock(p, &flags);
+	time_slice = p->sched_class->get_rr_interval(rq, p);
+	task_rq_unlock(rq, &flags);
 
 	read_unlock(&tasklist_lock);
 	jiffies_to_timespec(time_slice, &t);
Index: linux-2.6-tip/kernel/sched_fair.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched_fair.c
+++ linux-2.6-tip/kernel/sched_fair.c
@@ -2014,21 +2014,17 @@ static void moved_group_fair(struct task
 }
 #endif
 
-unsigned int get_rr_interval_fair(struct task_struct *task)
+unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task)
 {
 	struct sched_entity *se = &task->se;
-	unsigned long flags;
-	struct rq *rq;
 	unsigned int rr_interval = 0;
 
 	/*
 	 * Time slice is 0 for SCHED_OTHER tasks that are on an otherwise
 	 * idle runqueue:
 	 */
-	rq = task_rq_lock(task, &flags);
 	if (rq->cfs.load.weight)
 		rr_interval = NS_TO_JIFFIES(sched_slice(&rq->cfs, se));
-	task_rq_unlock(rq, &flags);
 
 	return rr_interval;
 }
Index: linux-2.6-tip/kernel/sched_idletask.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched_idletask.c
+++ linux-2.6-tip/kernel/sched_idletask.c
@@ -97,7 +97,7 @@ static void prio_changed_idle(struct rq 
 		check_preempt_curr(rq, p, 0);
 }
 
-unsigned int get_rr_interval_idle(struct task_struct *task)
+unsigned int get_rr_interval_idle(struct rq *rq, struct task_struct *task)
 {
 	return 0;
 }
Index: linux-2.6-tip/kernel/sched_rt.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched_rt.c
+++ linux-2.6-tip/kernel/sched_rt.c
@@ -1721,7 +1721,7 @@ static void set_curr_task_rt(struct rq *
 	dequeue_pushable_task(rq, p);
 }
 
-unsigned int get_rr_interval_rt(struct task_struct *task)
+unsigned int get_rr_interval_rt(struct rq *rq, struct task_struct *task)
 {
 	/*
 	 * Time slice is 0 for SCHED_FIFO tasks
