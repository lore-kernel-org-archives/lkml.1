Return-Path: <linux-kernel-owner+w=401wt.eu-S932343AbXKOUJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbXKOUJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 15:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759131AbXKOUJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 15:09:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43655 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbXKOUJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:09:11 -0500
Date: Thu, 15 Nov 2007 21:09:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] scheduler fixes
Message-ID: <20071115200904.GA23186@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

it includes 3 fixes and 3 cleanups. Build and boot tested on 64-bit and 
32-bit x86. Thanks,

	Ingo

------------------>
Adrian Bunk (1):
      sched: make sched_nr_latency static

Christian Borntraeger (1):
      sched: fix accounting of interrupts during guest execution on s390

Dmitry Adamushko (2):
      sched: fix __set_task_cpu() SMP race
      sched: remove activate_idle_task()

Ingo Molnar (1):
      sched: reorder SCHED_FEAT_ bits

Oleg Nesterov (1):
      sched: fix SCHED_FIFO tasks & FAIR_GROUP_SCHED

 sched.c      |   62 +++++++++++++++++++++++++----------------------------------
 sched_fair.c |    2 -
 2 files changed, 28 insertions(+), 36 deletions(-)

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -216,15 +216,15 @@ static inline struct task_group *task_gr
 }
 
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
-static inline void set_task_cfs_rq(struct task_struct *p)
+static inline void set_task_cfs_rq(struct task_struct *p, unsigned int cpu)
 {
-	p->se.cfs_rq = task_group(p)->cfs_rq[task_cpu(p)];
-	p->se.parent = task_group(p)->se[task_cpu(p)];
+	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
+	p->se.parent = task_group(p)->se[cpu];
 }
 
 #else
 
-static inline void set_task_cfs_rq(struct task_struct *p) { }
+static inline void set_task_cfs_rq(struct task_struct *p, unsigned int cpu) { }
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
@@ -455,18 +455,18 @@ static void update_rq_clock(struct rq *r
  */
 enum {
 	SCHED_FEAT_NEW_FAIR_SLEEPERS	= 1,
-	SCHED_FEAT_START_DEBIT		= 2,
-	SCHED_FEAT_TREE_AVG             = 4,
-	SCHED_FEAT_APPROX_AVG           = 8,
-	SCHED_FEAT_WAKEUP_PREEMPT	= 16,
+	SCHED_FEAT_WAKEUP_PREEMPT	= 2,
+	SCHED_FEAT_START_DEBIT		= 4,
+	SCHED_FEAT_TREE_AVG             = 8,
+	SCHED_FEAT_APPROX_AVG           = 16,
 };
 
 const_debug unsigned int sysctl_sched_features =
 		SCHED_FEAT_NEW_FAIR_SLEEPERS	* 1 |
+		SCHED_FEAT_WAKEUP_PREEMPT	* 1 |
 		SCHED_FEAT_START_DEBIT		* 1 |
 		SCHED_FEAT_TREE_AVG		* 0 |
-		SCHED_FEAT_APPROX_AVG		* 0 |
-		SCHED_FEAT_WAKEUP_PREEMPT	* 1;
+		SCHED_FEAT_APPROX_AVG		* 0;
 
 #define sched_feat(x) (sysctl_sched_features & SCHED_FEAT_##x)
 
@@ -1022,10 +1022,16 @@ unsigned long weighted_cpuload(const int
 
 static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 {
+	set_task_cfs_rq(p, cpu);
 #ifdef CONFIG_SMP
+	/*
+	 * After ->cpu is set up to a new value, task_rq_lock(p, ...) can be
+	 * successfuly executed on another CPU. We must ensure that updates of
+	 * per-task data have been completed by this moment.
+	 */
+	smp_wmb();
 	task_thread_info(p)->cpu = cpu;
 #endif
-	set_task_cfs_rq(p);
 }
 
 #ifdef CONFIG_SMP
@@ -3390,10 +3396,8 @@ void account_system_time(struct task_str
 	struct rq *rq = this_rq();
 	cputime64_t tmp;
 
-	if (p->flags & PF_VCPU) {
-		account_guest_time(p, cputime);
-		return;
-	}
+	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0))
+		return account_guest_time(p, cputime);
 
 	p->stime = cputime_add(p->stime, cputime);
 
@@ -5278,23 +5282,9 @@ static void migrate_live_tasks(int src_c
 }
 
 /*
- * activate_idle_task - move idle task to the _front_ of runqueue.
- */
-static void activate_idle_task(struct task_struct *p, struct rq *rq)
-{
-	update_rq_clock(rq);
-
-	if (p->state == TASK_UNINTERRUPTIBLE)
-		rq->nr_uninterruptible--;
-
-	enqueue_task(rq, p, 0);
-	inc_nr_running(p, rq);
-}
-
-/*
  * Schedules idle task to be the next runnable task on current CPU.
- * It does so by boosting its priority to highest possible and adding it to
- * the _front_ of the runqueue. Used by CPU offline code.
+ * It does so by boosting its priority to highest possible.
+ * Used by CPU offline code.
  */
 void sched_idle_next(void)
 {
@@ -5314,8 +5304,8 @@ void sched_idle_next(void)
 
 	__setscheduler(rq, p, SCHED_FIFO, MAX_RT_PRIO-1);
 
-	/* Add idle task to the _front_ of its priority queue: */
-	activate_idle_task(p, rq);
+	update_rq_clock(rq);
+	activate_task(rq, p, 0);
 
 	spin_unlock_irqrestore(&rq->lock, flags);
 }
@@ -7089,8 +7079,10 @@ void sched_move_task(struct task_struct 
 
 	rq = task_rq_lock(tsk, &flags);
 
-	if (tsk->sched_class != &fair_sched_class)
+	if (tsk->sched_class != &fair_sched_class) {
+		set_task_cfs_rq(tsk, task_cpu(tsk));
 		goto done;
+	}
 
 	update_rq_clock(rq);
 
@@ -7103,7 +7095,7 @@ void sched_move_task(struct task_struct 
 			tsk->sched_class->put_prev_task(rq, tsk);
 	}
 
-	set_task_cfs_rq(tsk);
+	set_task_cfs_rq(tsk, task_cpu(tsk));
 
 	if (on_rq) {
 		if (unlikely(running))
Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -43,7 +43,7 @@ unsigned int sysctl_sched_min_granularit
 /*
  * is kept at sysctl_sched_latency / sysctl_sched_min_granularity
  */
-unsigned int sched_nr_latency = 20;
+static unsigned int sched_nr_latency = 20;
 
 /*
  * After fork, child runs first. (default) If set to 0 then
