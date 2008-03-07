Return-Path: <linux-kernel-owner+w=401wt.eu-S1759978AbYCGP41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759978AbYCGP41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 10:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756085AbYCGP4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 10:56:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48716 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755833AbYCGP4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 10:56:18 -0500
Date: Fri, 7 Mar 2008 16:56:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] scheduler fixes
Message-ID: <20080307155607.GA5915@elte.hu>
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


Linus, please pull the latest scheduler fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git for-linus

Thanks,

	Ingo

------------------>
Dhaval Giani (1):
      sched: don't allow rt_runtime_us to be zero for groups having rt tasks

Miao Xie (1):
      sched: fix the wrong time slice value for SCHED_FIFO tasks

Pavel Roskin (1):
      sched: export task_nice

Peter Zijlstra (2):
      sched: retain vruntime
      sched: rt-group: fixup schedulability constraints calculation

Steven Rostedt (1):
      sched: balance RT task resched only on runqueue

 include/linux/sched.h |    4 ++++
 kernel/sched.c        |   36 +++++++++++++++++++++++++++---------
 kernel/sched_fair.c   |   14 ++++++++++++++
 kernel/sched_rt.c     |    6 ++++--
 4 files changed, 49 insertions(+), 11 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9ae4030..11d8e9a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -899,6 +899,10 @@ struct sched_class {
 			     int running);
 	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
 			     int oldprio, int running);
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	void (*moved_group) (struct task_struct *p);
+#endif
 };
 
 struct load_weight {
diff --git a/kernel/sched.c b/kernel/sched.c
index dcd553c..52b9867 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4422,7 +4422,7 @@ int task_nice(const struct task_struct *p)
 {
 	return TASK_NICE(p);
 }
-EXPORT_SYMBOL_GPL(task_nice);
+EXPORT_SYMBOL(task_nice);
 
 /**
  * idle_cpu - is a given cpu idle currently?
@@ -5100,7 +5100,7 @@ long sys_sched_rr_get_interval(pid_t pid, struct timespec __user *interval)
 	time_slice = 0;
 	if (p->policy == SCHED_RR) {
 		time_slice = DEF_TIMESLICE;
-	} else {
+	} else if (p->policy != SCHED_FIFO) {
 		struct sched_entity *se = &p->se;
 		unsigned long flags;
 		struct rq *rq;
@@ -7625,6 +7625,11 @@ void sched_move_task(struct task_struct *tsk)
 
 	set_task_rq(tsk, task_cpu(tsk));
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	if (tsk->sched_class->moved_group)
+		tsk->sched_class->moved_group(tsk);
+#endif
+
 	if (on_rq) {
 		if (unlikely(running))
 			tsk->sched_class->set_curr_task(rq);
@@ -7721,9 +7726,7 @@ static unsigned long to_ratio(u64 period, u64 runtime)
 	if (runtime == RUNTIME_INF)
 		return 1ULL << 16;
 
-	runtime *= (1ULL << 16);
-	div64_64(runtime, period);
-	return runtime;
+	return div64_64(runtime << 16, period);
 }
 
 static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
@@ -7747,25 +7750,40 @@ static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
 	return total + to_ratio(period, runtime) < global_ratio;
 }
 
+/* Must be called with tasklist_lock held */
+static inline int tg_has_rt_tasks(struct task_group *tg)
+{
+	struct task_struct *g, *p;
+	do_each_thread(g, p) {
+		if (rt_task(p) && rt_rq_of_se(&p->rt)->tg == tg)
+			return 1;
+	} while_each_thread(g, p);
+	return 0;
+}
+
 int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
 {
 	u64 rt_runtime, rt_period;
 	int err = 0;
 
-	rt_period = sysctl_sched_rt_period * NSEC_PER_USEC;
+	rt_period = (u64)sysctl_sched_rt_period * NSEC_PER_USEC;
 	rt_runtime = (u64)rt_runtime_us * NSEC_PER_USEC;
 	if (rt_runtime_us == -1)
-		rt_runtime = rt_period;
+		rt_runtime = RUNTIME_INF;
 
 	mutex_lock(&rt_constraints_mutex);
+	read_lock(&tasklist_lock);
+	if (rt_runtime_us == 0 && tg_has_rt_tasks(tg)) {
+		err = -EBUSY;
+		goto unlock;
+	}
 	if (!__rt_schedulable(tg, rt_period, rt_runtime)) {
 		err = -EINVAL;
 		goto unlock;
 	}
-	if (rt_runtime_us == -1)
-		rt_runtime = RUNTIME_INF;
 	tg->rt_runtime = rt_runtime;
  unlock:
+	read_unlock(&tasklist_lock);
 	mutex_unlock(&rt_constraints_mutex);
 
 	return err;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3df4d46..e2a5305 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1353,6 +1353,16 @@ static void set_curr_task_fair(struct rq *rq)
 		set_next_entity(cfs_rq_of(se), se);
 }
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static void moved_group_fair(struct task_struct *p)
+{
+	struct cfs_rq *cfs_rq = task_cfs_rq(p);
+
+	update_curr(cfs_rq);
+	place_entity(cfs_rq, &p->se, 1);
+}
+#endif
+
 /*
  * All the scheduling class methods:
  */
@@ -1381,6 +1391,10 @@ static const struct sched_class fair_sched_class = {
 
 	.prio_changed		= prio_changed_fair,
 	.switched_to		= switched_to_fair,
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	.moved_group		= moved_group_fair,
+#endif
 };
 
 #ifdef CONFIG_SCHED_DEBUG
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 76e8285..0a6d2e5 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1107,9 +1107,11 @@ static void prio_changed_rt(struct rq *rq, struct task_struct *p,
 			pull_rt_task(rq);
 		/*
 		 * If there's a higher priority task waiting to run
-		 * then reschedule.
+		 * then reschedule. Note, the above pull_rt_task
+		 * can release the rq lock and p could migrate.
+		 * Only reschedule if p is still on the same runqueue.
 		 */
-		if (p->prio > rq->rt.highest_prio)
+		if (p->prio > rq->rt.highest_prio && rq->curr == p)
 			resched_task(p);
 #else
 		/* For UP simply resched on drop of prio */
