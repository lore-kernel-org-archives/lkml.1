Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbZIUCDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbZIUCDB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 22:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbZIUCDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 22:03:01 -0400
Received: from nschwqsrv03p.mx.bigpond.com ([61.9.189.237]:60831 "EHLO
	nschwqsrv03p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753932AbZIUCDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 22:03:00 -0400
X-Greylist: delayed 1867 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Sep 2009 22:02:59 EDT
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH] sched: Simplify sys_sched_rr_get_interval() system call
X-Mercurial-Node: 06d1b89ee15a0eef82d7b9e8ed1ac20e6cf43661
Message-Id: <06d1b89ee15a0eef82d7.1253496713@mudlark.pw.nest>
User-Agent: Mercurial-patchbomb/1.3
Date: Mon, 21 Sep 2009 01:31:53 -0000
From: Peter Williams <pwil3058@bigpond.net.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing <linux-kernel@vger.kernel.org>
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at nschwotgx03p.mx.bigpond.com from [124.185.86.236] using ID pwil3058@bigpond.net.au at Mon, 21 Sep 2009 01:31:54 +0000
X-RPD-ScanID: Class unknown; VirusThreatLevel unknown, RefID str=0001.0A150201.4AB6D78B.0060,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Peter Williams <pwil3058@bigpond.net.au>
# Date 1253495380 -36000
# Node ID 06d1b89ee15a0eef82d7b9e8ed1ac20e6cf43661
# Parent  067982df9f80206a7b49780f2235bde3b3249631
sched: Simplify sys_sched_rr_get_interval() system call
by removing the need for it to know details of scheduling classes.

Signed-off-by: Peter Williams <pwil3058@bigpond.net.au>

diff -r 067982df9f80 -r 06d1b89ee15a include/linux/sched.h
--- a/include/linux/sched.h	Wed Sep 09 15:13:59 2009 -0700
+++ b/include/linux/sched.h	Mon Sep 21 11:09:40 2009 +1000
@@ -1067,6 +1067,8 @@ struct sched_class {
 	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
 			     int oldprio, int running);
 
+	unsigned int (*get_rr_interval) (struct task_struct *task);
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	void (*moved_group) (struct task_struct *p);
 #endif
diff -r 067982df9f80 -r 06d1b89ee15a kernel/sched.c
--- a/kernel/sched.c	Wed Sep 09 15:13:59 2009 -0700
+++ b/kernel/sched.c	Mon Sep 21 11:09:40 2009 +1000
@@ -6759,23 +6759,8 @@ SYSCALL_DEFINE2(sched_rr_get_interval, p
 	if (retval)
 		goto out_unlock;
 
-	/*
-	 * Time slice is 0 for SCHED_FIFO tasks and for SCHED_OTHER
-	 * tasks that are on an otherwise idle runqueue:
-	 */
-	time_slice = 0;
-	if (p->policy == SCHED_RR) {
-		time_slice = DEF_TIMESLICE;
-	} else if (p->policy != SCHED_FIFO) {
-		struct sched_entity *se = &p->se;
-		unsigned long flags;
-		struct rq *rq;
-
-		rq = task_rq_lock(p, &flags);
-		if (rq->cfs.load.weight)
-			time_slice = NS_TO_JIFFIES(sched_slice(&rq->cfs, se));
-		task_rq_unlock(rq, &flags);
-	}
+	time_slice = p->sched_class->get_rr_interval(p);
+
 	read_unlock(&tasklist_lock);
 	jiffies_to_timespec(time_slice, &t);
 	retval = copy_to_user(interval, &t, sizeof(t)) ? -EFAULT : 0;
diff -r 067982df9f80 -r 06d1b89ee15a kernel/sched_fair.c
--- a/kernel/sched_fair.c	Wed Sep 09 15:13:59 2009 -0700
+++ b/kernel/sched_fair.c	Mon Sep 21 11:09:40 2009 +1000
@@ -1796,6 +1796,25 @@ static void moved_group_fair(struct task
 }
 #endif
 
+unsigned int get_rr_interval_fair(struct task_struct *task)
+{
+	struct sched_entity *se = &task->se;
+	unsigned long flags;
+	struct rq *rq;
+	unsigned int rr_interval = 0;
+
+	/*
+	 * Time slice is 0 for SCHED_OTHER tasks that are on an otherwise
+	 * idle runqueue:
+	 */
+	rq = task_rq_lock(task, &flags);
+	if (rq->cfs.load.weight)
+		rr_interval = NS_TO_JIFFIES(sched_slice(&rq->cfs, se));
+	task_rq_unlock(rq, &flags);
+
+	return rr_interval;
+}
+
 /*
  * All the scheduling class methods:
  */
@@ -1824,6 +1843,8 @@ static const struct sched_class fair_sch
 	.prio_changed		= prio_changed_fair,
 	.switched_to		= switched_to_fair,
 
+	.get_rr_interval	= get_rr_interval_fair,
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	.moved_group		= moved_group_fair,
 #endif
diff -r 067982df9f80 -r 06d1b89ee15a kernel/sched_idletask.c
--- a/kernel/sched_idletask.c	Wed Sep 09 15:13:59 2009 -0700
+++ b/kernel/sched_idletask.c	Mon Sep 21 11:09:40 2009 +1000
@@ -97,6 +97,11 @@ static void prio_changed_idle(struct rq 
 		check_preempt_curr(rq, p, 0);
 }
 
+unsigned int get_rr_interval_idle(struct task_struct *task)
+{
+	return 0;
+}
+
 /*
  * Simple, special scheduling class for the per-CPU idle tasks:
  */
@@ -122,6 +127,8 @@ static const struct sched_class idle_sch
 	.set_curr_task          = set_curr_task_idle,
 	.task_tick		= task_tick_idle,
 
+	.get_rr_interval	= get_rr_interval_idle,
+
 	.prio_changed		= prio_changed_idle,
 	.switched_to		= switched_to_idle,
 
diff -r 067982df9f80 -r 06d1b89ee15a kernel/sched_rt.c
--- a/kernel/sched_rt.c	Wed Sep 09 15:13:59 2009 -0700
+++ b/kernel/sched_rt.c	Mon Sep 21 11:09:40 2009 +1000
@@ -1738,6 +1738,17 @@ static void set_curr_task_rt(struct rq *
 	dequeue_pushable_task(rq, p);
 }
 
+unsigned int get_rr_interval_rt(struct task_struct *task)
+{
+	/*
+	 * Time slice is 0 for SCHED_FIFO tasks
+	 */
+	if (task->policy == SCHED_RR)
+		return DEF_TIMESLICE;
+	else
+		return 0;
+}
+
 static const struct sched_class rt_sched_class = {
 	.next			= &fair_sched_class,
 	.enqueue_task		= enqueue_task_rt,
@@ -1767,6 +1778,8 @@ static const struct sched_class rt_sched
 	.set_curr_task          = set_curr_task_rt,
 	.task_tick		= task_tick_rt,
 
+	.get_rr_interval	= get_rr_interval_rt,
+
 	.prio_changed		= prio_changed_rt,
 	.switched_to		= switched_to_rt,
 };
