Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938Ab0AVRNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab0AVRNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 12:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097Ab0AVRNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 12:13:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:41412 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754698Ab0AVRNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 12:13:44 -0500
Date: Fri, 22 Jan 2010 17:12:33 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, mathias.weber.mw1@roche.com, cbe@osadl.org,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, cbe@osadl.org, mathias.weber.mw1@roche.com,
       tglx@linutronix.de
In-Reply-To: <20100120171629.734886007@linutronix.de>
References: <20100120171629.734886007@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Extend enqueue_task to allow head queueing
Message-ID: <tip-ea87bb7853168434f4a82426dd1ea8421f9e604d@git.kernel.org>
Git-Commit-ID: ea87bb7853168434f4a82426dd1ea8421f9e604d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Jan 2010 17:12:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea87bb7853168434f4a82426dd1ea8421f9e604d
Gitweb:     http://git.kernel.org/tip/ea87bb7853168434f4a82426dd1ea8421f9e604d
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 20 Jan 2010 20:58:57 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 22 Jan 2010 18:09:59 +0100

sched: Extend enqueue_task to allow head queueing

The ability of enqueueing a task to the head of a SCHED_FIFO priority
list is required to fix some violations of POSIX scheduling policy.

Extend the related functions with a "head" argument.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Tested-by: Carsten Emde <cbe@osadl.org>
Tested-by: Mathias Weber <mathias.weber.mw1@roche.com>
LKML-Reference: <20100120171629.734886007@linutronix.de>

---
 include/linux/sched.h |    3 ++-
 kernel/sched.c        |   13 +++++++------
 kernel/sched_fair.c   |    3 ++-
 kernel/sched_rt.c     |    3 ++-
 4 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8b07973..b35c0c7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1067,7 +1067,8 @@ struct sched_domain;
 struct sched_class {
 	const struct sched_class *next;
 
-	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
+	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup,
+			      bool head);
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
 	void (*yield_task) (struct rq *rq);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 41e76d3..f47560f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1856,13 +1856,14 @@ static void update_avg(u64 *avg, u64 sample)
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
 
@@ -1892,7 +1893,7 @@ static void activate_task(struct rq *rq, struct task_struct *p, int wakeup)
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible--;
 
-	enqueue_task(rq, p, wakeup);
+	enqueue_task(rq, p, wakeup, false);
 	inc_nr_running(rq);
 }
 
@@ -4236,7 +4237,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	if (running)
 		p->sched_class->set_curr_task(rq);
 	if (on_rq) {
-		enqueue_task(rq, p, 0);
+		enqueue_task(rq, p, 0, false);
 
 		check_class_changed(rq, p, prev_class, oldprio, running);
 	}
@@ -4280,7 +4281,7 @@ void set_user_nice(struct task_struct *p, long nice)
 	delta = p->prio - old_prio;
 
 	if (on_rq) {
-		enqueue_task(rq, p, 0);
+		enqueue_task(rq, p, 0, false);
 		/*
 		 * If the task increased its priority or is running and
 		 * lowered its priority, then reschedule its CPU:
@@ -8230,7 +8231,7 @@ void sched_move_task(struct task_struct *tsk)
 	if (unlikely(running))
 		tsk->sched_class->set_curr_task(rq);
 	if (on_rq)
-		enqueue_task(rq, tsk, 0);
+		enqueue_task(rq, tsk, 0, false);
 
 	task_rq_unlock(rq, &flags);
 }
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 22231cc..0e7a7af 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1053,7 +1053,8 @@ static inline void hrtick_update(struct rq *rq)
  * increased. Here we update the fair scheduling stats and
  * then put the task into the rbtree:
  */
-static void enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup)
+static void
+enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup, bool head)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 502bb61..38076da 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -878,7 +878,8 @@ static void dequeue_rt_entity(struct sched_rt_entity *rt_se)
 /*
  * Adding/removing a task to/from a priority array:
  */
-static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)
+static void
+enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup, bool head)
 {
 	struct sched_rt_entity *rt_se = &p->rt;
 
