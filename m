Return-Path: <linux-kernel-owner+w=401wt.eu-S1753929AbZLIJxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbZLIJxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbZLIJxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:53:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:45026 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700AbZLIJxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:53:33 -0500
Date: Wed, 9 Dec 2009 09:53:07 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <alpine.LFD.2.00.0912090930120.3089@localhost.localdomain>
References: <alpine.LFD.2.00.0912090930120.3089@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Protect sched_rr_get_param() access to task->sched_class
Message-ID: <tip-dba091b9e3522b9d32fc9975e48d3b69633b45f0@git.kernel.org>
Git-Commit-ID: dba091b9e3522b9d32fc9975e48d3b69633b45f0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dba091b9e3522b9d32fc9975e48d3b69633b45f0
Gitweb:     http://git.kernel.org/tip/dba091b9e3522b9d32fc9975e48d3b69633b45f0
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 9 Dec 2009 09:32:03 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 10:01:07 +0100

sched: Protect sched_rr_get_param() access to task->sched_class

sched_rr_get_param calls
task->sched_class->get_rr_interval(task) without protection
against a concurrent sched_setscheduler() call which modifies
task->sched_class.

Serialize the access with task_rq_lock(task) and hand the rq
pointer into get_rr_interval() as it's needed at least in the
sched_fair implementation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <alpine.LFD.2.00.0912090930120.3089@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h   |    3 ++-
 kernel/sched.c          |    6 +++++-
 kernel/sched_fair.c     |    6 +-----
 kernel/sched_idletask.c |    2 +-
 kernel/sched_rt.c       |    2 +-
 5 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 89115ec..9b24027 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1111,7 +1111,8 @@ struct sched_class {
 	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
 			     int oldprio, int running);
 
-	unsigned int (*get_rr_interval) (struct task_struct *task);
+	unsigned int (*get_rr_interval) (struct rq *rq,
+					 struct task_struct *task);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	void (*moved_group) (struct task_struct *p);
diff --git a/kernel/sched.c b/kernel/sched.c
index c4635f7..68db5a2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6887,6 +6887,8 @@ SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
 {
 	struct task_struct *p;
 	unsigned int time_slice;
+	unsigned long flags;
+	struct rq *rq;
 	int retval;
 	struct timespec t;
 
@@ -6903,7 +6905,9 @@ SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
 	if (retval)
 		goto out_unlock;
 
-	time_slice = p->sched_class->get_rr_interval(p);
+	rq = task_rq_lock(p, &flags);
+	time_slice = p->sched_class->get_rr_interval(rq, p);
+	task_rq_unlock(rq, &flags);
 
 	read_unlock(&tasklist_lock);
 	jiffies_to_timespec(time_slice, &t);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index f61837a..613c1c7 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2014,21 +2014,17 @@ static void moved_group_fair(struct task_struct *p)
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
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index b133a28..33d5384 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -97,7 +97,7 @@ static void prio_changed_idle(struct rq *rq, struct task_struct *p,
 		check_preempt_curr(rq, p, 0);
 }
 
-unsigned int get_rr_interval_idle(struct task_struct *task)
+unsigned int get_rr_interval_idle(struct rq *rq, struct task_struct *task)
 {
 	return 0;
 }
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 5c5fef3..aecbd9c 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1721,7 +1721,7 @@ static void set_curr_task_rt(struct rq *rq)
 	dequeue_pushable_task(rq, p);
 }
 
-unsigned int get_rr_interval_rt(struct task_struct *task)
+unsigned int get_rr_interval_rt(struct rq *rq, struct task_struct *task)
 {
 	/*
 	 * Time slice is 0 for SCHED_FIFO tasks
