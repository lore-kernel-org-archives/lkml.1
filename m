Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680AbZIUJHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbZIUJHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 05:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755478AbZIUJHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 05:07:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:35104 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463AbZIUJHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 05:07:11 -0400
Date: Mon, 21 Sep 2009 09:06:38 GMT
From: tip-bot for Peter Williams <pwil3058@bigpond.net.au>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, pwil3058@bigpond.net.au,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       pwil3058@bigpond.net.au, mingo@elte.hu
In-Reply-To: <06d1b89ee15a0eef82d7.1253496713@mudlark.pw.nest>
References: <06d1b89ee15a0eef82d7.1253496713@mudlark.pw.nest>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Simplify sys_sched_rr_get_interval() system call
Message-ID: <tip-0d721ceadbeaa24d7f9dd41b3e5e29912327a7e1@git.kernel.org>
Git-Commit-ID: 0d721ceadbeaa24d7f9dd41b3e5e29912327a7e1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 21 Sep 2009 09:06:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d721ceadbeaa24d7f9dd41b3e5e29912327a7e1
Gitweb:     http://git.kernel.org/tip/0d721ceadbeaa24d7f9dd41b3e5e29912327a7e1
Author:     Peter Williams <pwil3058@bigpond.net.au>
AuthorDate: Mon, 21 Sep 2009 01:31:53 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 21 Sep 2009 09:53:55 +0200

sched: Simplify sys_sched_rr_get_interval() system call

By removing the need for it to know details of scheduling classes.

This allows PlugSched to define orthogonal scheduling classes.

Signed-off-by: Peter Williams <pwil3058@bigpond.net.au>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <06d1b89ee15a0eef82d7.1253496713@mudlark.pw.nest>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/sched.h   |    2 ++
 kernel/sched.c          |   17 +----------------
 kernel/sched_fair.c     |   21 +++++++++++++++++++++
 kernel/sched_idletask.c |    7 +++++++
 kernel/sched_rt.c       |   13 +++++++++++++
 5 files changed, 44 insertions(+), 16 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index cc37a3f..239c8e0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1075,6 +1075,8 @@ struct sched_class {
 	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
 			     int oldprio, int running);
 
+	unsigned int (*get_rr_interval) (struct task_struct *task);
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	void (*moved_group) (struct task_struct *p);
 #endif
diff --git a/kernel/sched.c b/kernel/sched.c
index 1b900fb..830967e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6819,23 +6819,8 @@ SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
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
+	time_slice = p->sched_class->get_rr_interval(p);
 
-		rq = task_rq_lock(p, &flags);
-		if (rq->cfs.load.weight)
-			time_slice = NS_TO_JIFFIES(sched_slice(&rq->cfs, se));
-		task_rq_unlock(rq, &flags);
-	}
 	read_unlock(&tasklist_lock);
 	jiffies_to_timespec(time_slice, &t);
 	retval = copy_to_user(interval, &t, sizeof(t)) ? -EFAULT : 0;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 566e3bb..cd73738 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1938,6 +1938,25 @@ static void moved_group_fair(struct task_struct *p)
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
@@ -1966,6 +1985,8 @@ static const struct sched_class fair_sched_class = {
 	.prio_changed		= prio_changed_fair,
 	.switched_to		= switched_to_fair,
 
+	.get_rr_interval	= get_rr_interval_fair,
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	.moved_group		= moved_group_fair,
 #endif
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index a8b448a..b133a28 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -97,6 +97,11 @@ static void prio_changed_idle(struct rq *rq, struct task_struct *p,
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
@@ -122,6 +127,8 @@ static const struct sched_class idle_sched_class = {
 	.set_curr_task          = set_curr_task_idle,
 	.task_tick		= task_tick_idle,
 
+	.get_rr_interval	= get_rr_interval_idle,
+
 	.prio_changed		= prio_changed_idle,
 	.switched_to		= switched_to_idle,
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 13de712..a4d790c 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1734,6 +1734,17 @@ static void set_curr_task_rt(struct rq *rq)
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
@@ -1762,6 +1773,8 @@ static const struct sched_class rt_sched_class = {
 	.set_curr_task          = set_curr_task_rt,
 	.task_tick		= task_tick_rt,
 
+	.get_rr_interval	= get_rr_interval_rt,
+
 	.prio_changed		= prio_changed_rt,
 	.switched_to		= switched_to_rt,
 };
