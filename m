Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbZIUNF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbZIUNF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 09:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755971AbZIUNF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 09:05:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55464 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755960AbZIUNF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 09:05:56 -0400
Date: Mon, 21 Sep 2009 15:05:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20090921130548.GA30410@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

( There's one non-fix commit included as well: "sched: Simplify
  sys_sched_rr_get_interval() system call" is a cleanup. )

 Thanks,

	Ingo

------------------>
Andrew Morton (1):
      sched: Fix raciness in runqueue_is_locked()

Mike Galbraith (2):
      sched: Remove unneeded indentation in sched_fair.c::place_entity()
      sched: Re-add lost cpu_allowed check to sched_fair.c::select_task_rq_fair()

Peter Williams (1):
      sched: Simplify sys_sched_rr_get_interval() system call

Yong Zhang (1):
      sched: Fix potential NULL derference of doms_cur


 include/linux/sched.h   |    4 ++-
 kernel/sched.c          |   29 +++------------------
 kernel/sched_fair.c     |   65 ++++++++++++++++++++++++++++++----------------
 kernel/sched_idletask.c |    7 +++++
 kernel/sched_rt.c       |   13 +++++++++
 kernel/trace/trace.c    |    8 +++++-
 6 files changed, 76 insertions(+), 50 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8af3d24..239c8e0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -257,7 +257,7 @@ extern asmlinkage void schedule_tail(struct task_struct *prev);
 extern void init_idle(struct task_struct *idle, int cpu);
 extern void init_idle_bootup_task(struct task_struct *idle);
 
-extern int runqueue_is_locked(void);
+extern int runqueue_is_locked(int cpu);
 extern void task_rq_unlock_wait(struct task_struct *p);
 
 extern cpumask_var_t nohz_cpu_mask;
@@ -1075,6 +1075,8 @@ struct sched_class {
 	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
 			     int oldprio, int running);
 
+	unsigned int (*get_rr_interval) (struct task_struct *task);
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	void (*moved_group) (struct task_struct *p);
 #endif
diff --git a/kernel/sched.c b/kernel/sched.c
index faf4d46..830967e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -681,15 +681,9 @@ inline void update_rq_clock(struct rq *rq)
  * This interface allows printk to be called with the runqueue lock
  * held and know whether or not it is OK to wake up the klogd.
  */
-int runqueue_is_locked(void)
+int runqueue_is_locked(int cpu)
 {
-	int cpu = get_cpu();
-	struct rq *rq = cpu_rq(cpu);
-	int ret;
-
-	ret = spin_is_locked(&rq->lock);
-	put_cpu();
-	return ret;
+	return spin_is_locked(&cpu_rq(cpu)->lock);
 }
 
 /*
@@ -6825,23 +6819,8 @@ SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
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
@@ -9171,6 +9150,7 @@ void __init sched_init_smp(void)
 	cpumask_var_t non_isolated_cpus;
 
 	alloc_cpumask_var(&non_isolated_cpus, GFP_KERNEL);
+	alloc_cpumask_var(&fallback_doms, GFP_KERNEL);
 
 #if defined(CONFIG_NUMA)
 	sched_group_nodes_bycpu = kzalloc(nr_cpu_ids * sizeof(void **),
@@ -9202,7 +9182,6 @@ void __init sched_init_smp(void)
 	sched_init_granularity();
 	free_cpumask_var(non_isolated_cpus);
 
-	alloc_cpumask_var(&fallback_doms, GFP_KERNEL);
 	init_sched_rt_class();
 }
 #else
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 10d218a..cd73738 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -709,31 +709,28 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 	if (initial && sched_feat(START_DEBIT))
 		vruntime += sched_vslice(cfs_rq, se);
 
-	if (!initial) {
-		/* sleeps upto a single latency don't count. */
-		if (sched_feat(FAIR_SLEEPERS)) {
-			unsigned long thresh = sysctl_sched_latency;
+	/* sleeps up to a single latency don't count. */
+	if (!initial && sched_feat(FAIR_SLEEPERS)) {
+		unsigned long thresh = sysctl_sched_latency;
 
-			/*
-			 * Convert the sleeper threshold into virtual time.
-			 * SCHED_IDLE is a special sub-class.  We care about
-			 * fairness only relative to other SCHED_IDLE tasks,
-			 * all of which have the same weight.
-			 */
-			if (sched_feat(NORMALIZED_SLEEPER) &&
-					(!entity_is_task(se) ||
-					 task_of(se)->policy != SCHED_IDLE))
-				thresh = calc_delta_fair(thresh, se);
+		/*
+		 * Convert the sleeper threshold into virtual time.
+		 * SCHED_IDLE is a special sub-class.  We care about
+		 * fairness only relative to other SCHED_IDLE tasks,
+		 * all of which have the same weight.
+		 */
+		if (sched_feat(NORMALIZED_SLEEPER) && (!entity_is_task(se) ||
+				 task_of(se)->policy != SCHED_IDLE))
+			thresh = calc_delta_fair(thresh, se);
 
-			/*
-			 * Halve their sleep time's effect, to allow
-			 * for a gentler effect of sleepers:
-			 */
-			if (sched_feat(GENTLE_FAIR_SLEEPERS))
-				thresh >>= 1;
+		/*
+		 * Halve their sleep time's effect, to allow
+		 * for a gentler effect of sleepers:
+		 */
+		if (sched_feat(GENTLE_FAIR_SLEEPERS))
+			thresh >>= 1;
 
-			vruntime -= thresh;
-		}
+		vruntime -= thresh;
 	}
 
 	/* ensure we never gain time by being placed backwards. */
@@ -1342,7 +1339,8 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 	int sync = wake_flags & WF_SYNC;
 
 	if (sd_flag & SD_BALANCE_WAKE) {
-		if (sched_feat(AFFINE_WAKEUPS))
+		if (sched_feat(AFFINE_WAKEUPS) &&
+		    cpumask_test_cpu(cpu, &p->cpus_allowed))
 			want_affine = 1;
 		new_cpu = prev_cpu;
 	}
@@ -1940,6 +1938,25 @@ static void moved_group_fair(struct task_struct *p)
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
@@ -1968,6 +1985,8 @@ static const struct sched_class fair_sched_class = {
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
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index fd52a19..420232a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -275,12 +275,18 @@ static DEFINE_SPINLOCK(tracing_start_lock);
  */
 void trace_wake_up(void)
 {
+	int cpu;
+
+	if (trace_flags & TRACE_ITER_BLOCK)
+		return;
 	/*
 	 * The runqueue_is_locked() can fail, but this is the best we
 	 * have for now:
 	 */
-	if (!(trace_flags & TRACE_ITER_BLOCK) && !runqueue_is_locked())
+	cpu = get_cpu();
+	if (!runqueue_is_locked(cpu))
 		wake_up(&trace_wait);
+	put_cpu();
 }
 
 static int __init set_buf_size(char *str)
