Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbXLROis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbXLROis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 09:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbXLROij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 09:38:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59357 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbXLROii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 09:38:38 -0500
Date: Tue, 18 Dec 2007 15:38:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [git pull] scheduler fixes
Message-ID: <20071218143825.GA30325@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

Thanks,

	Ingo

------------------>
Dmitry Adamushko (1):
      sched: fix crash on ia64, introduce task_current()

Eric Dumazet (1):
      sched: sysctl, proc_dointvec_minmax() expects int values for

Ingo Molnar (2):
      sched: touch softlockup watchdog after idling
      sched: do not hurt SCHED_BATCH on wakeup

Livio Soares (1):
      sched: mark rwsem functions as __sched for wchan/profiling

 kernel/rwsem.c      |    5 +++--
 kernel/sched.c      |   18 ++++++++++++------
 kernel/sched_fair.c |    3 +--
 kernel/sysctl.c     |    8 ++++----
 lib/rwsem.c         |    2 +-
 5 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/kernel/rwsem.c b/kernel/rwsem.c
index 1ec620c..cae050b 100644
--- a/kernel/rwsem.c
+++ b/kernel/rwsem.c
@@ -6,6 +6,7 @@
 
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/rwsem.h>
 
@@ -15,7 +16,7 @@
 /*
  * lock for reading
  */
-void down_read(struct rw_semaphore *sem)
+void __sched down_read(struct rw_semaphore *sem)
 {
 	might_sleep();
 	rwsem_acquire_read(&sem->dep_map, 0, 0, _RET_IP_);
@@ -42,7 +43,7 @@ EXPORT_SYMBOL(down_read_trylock);
 /*
  * lock for writing
  */
-void down_write(struct rw_semaphore *sem)
+void __sched down_write(struct rw_semaphore *sem)
 {
 	might_sleep();
 	rwsem_acquire(&sem->dep_map, 0, 0, _RET_IP_);
diff --git a/kernel/sched.c b/kernel/sched.c
index c6e551d..3df84ea 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -508,10 +508,15 @@ EXPORT_SYMBOL_GPL(cpu_clock);
 # define finish_arch_switch(prev)	do { } while (0)
 #endif
 
+static inline int task_current(struct rq *rq, struct task_struct *p)
+{
+	return rq->curr == p;
+}
+
 #ifndef __ARCH_WANT_UNLOCKED_CTXSW
 static inline int task_running(struct rq *rq, struct task_struct *p)
 {
-	return rq->curr == p;
+	return task_current(rq, p);
 }
 
 static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
@@ -540,7 +545,7 @@ static inline int task_running(struct rq *rq, struct task_struct *p)
 #ifdef CONFIG_SMP
 	return p->oncpu;
 #else
-	return rq->curr == p;
+	return task_current(rq, p);
 #endif
 }
 
@@ -663,6 +668,7 @@ void sched_clock_idle_wakeup_event(u64 delta_ns)
 	struct rq *rq = cpu_rq(smp_processor_id());
 	u64 now = sched_clock();
 
+	touch_softlockup_watchdog();
 	rq->idle_clock += delta_ns;
 	/*
 	 * Override the previous timestamp and ignore all
@@ -3334,7 +3340,7 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 
 	rq = task_rq_lock(p, &flags);
 	ns = p->se.sum_exec_runtime;
-	if (rq->curr == p) {
+	if (task_current(rq, p)) {
 		update_rq_clock(rq);
 		delta_exec = rq->clock - p->se.exec_start;
 		if ((s64)delta_exec > 0)
@@ -4021,7 +4027,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 
 	oldprio = p->prio;
 	on_rq = p->se.on_rq;
-	running = task_running(rq, p);
+	running = task_current(rq, p);
 	if (on_rq) {
 		dequeue_task(rq, p, 0);
 		if (running)
@@ -4332,7 +4338,7 @@ recheck:
 	}
 	update_rq_clock(rq);
 	on_rq = p->se.on_rq;
-	running = task_running(rq, p);
+	running = task_current(rq, p);
 	if (on_rq) {
 		deactivate_task(rq, p, 0);
 		if (running)
@@ -7101,7 +7107,7 @@ void sched_move_task(struct task_struct *tsk)
 
 	update_rq_clock(rq);
 
-	running = task_running(rq, tsk);
+	running = task_current(rq, tsk);
 	on_rq = tsk->se.on_rq;
 
 	if (on_rq) {
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c33f0ce..da7c061 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -511,8 +511,7 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
-		if (sched_feat(NEW_FAIR_SLEEPERS) && entity_is_task(se) &&
-				task_of(se)->policy != SCHED_BATCH)
+		if (sched_feat(NEW_FAIR_SLEEPERS) && entity_is_task(se))
 			vruntime -= sysctl_sched_latency;
 
 		/* ensure we never gain time by being placed backwards. */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 1135de7..c68f68d 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -225,10 +225,10 @@ static struct ctl_table root_table[] = {
 };
 
 #ifdef CONFIG_SCHED_DEBUG
-static unsigned long min_sched_granularity_ns = 100000;		/* 100 usecs */
-static unsigned long max_sched_granularity_ns = NSEC_PER_SEC;	/* 1 second */
-static unsigned long min_wakeup_granularity_ns;			/* 0 usecs */
-static unsigned long max_wakeup_granularity_ns = NSEC_PER_SEC;	/* 1 second */
+static int min_sched_granularity_ns = 100000;		/* 100 usecs */
+static int max_sched_granularity_ns = NSEC_PER_SEC;	/* 1 second */
+static int min_wakeup_granularity_ns;			/* 0 usecs */
+static int max_wakeup_granularity_ns = NSEC_PER_SEC;	/* 1 second */
 #endif
 
 static struct ctl_table kern_table[] = {
diff --git a/lib/rwsem.c b/lib/rwsem.c
index cdb4e3d..7d02700 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -146,7 +146,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int downgrading)
 /*
  * wait for a lock to be granted
  */
-static struct rw_semaphore *
+static struct rw_semaphore __sched *
 rwsem_down_failed_common(struct rw_semaphore *sem,
 			struct rwsem_waiter *waiter, signed long adjustment)
 {
