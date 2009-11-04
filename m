Return-Path: <linux-kernel-owner+w=401wt.eu-S1756842AbZKDPyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbZKDPyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755975AbZKDPyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:54:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41185 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbZKDPyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:54:46 -0500
Date: Wed, 4 Nov 2009 16:54:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20091104155440.GA692@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

Two throughput regression fixes and two fixes.

 Thanks,

	Ingo

------------------>
Mike Galbraith (3):
      sched: Strengthen buddies and mitigate buddy induced latencies
      sched: Disable SD_PREFER_LOCAL at node level
      sched: Fix kthread_bind() by moving the body of kthread_bind() to sched.c

Rusty Russell (1):
      sched: Fix boot crash by zalloc()ing most of the cpu masks


 arch/x86/include/asm/topology.h |    2 +-
 kernel/kthread.c                |   23 ------------
 kernel/sched.c                  |   40 +++++++++++++++++++--
 kernel/sched_fair.c             |   73 +++++++++++++++++++++++++--------------
 4 files changed, 84 insertions(+), 54 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index d823c24..40e37b1 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -143,7 +143,7 @@ extern unsigned long node_remap_size[];
 				| 1*SD_BALANCE_FORK			\
 				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
-				| 1*SD_PREFER_LOCAL			\
+				| 0*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_POWERSAVINGS_BALANCE		\
 				| 0*SD_SHARE_PKG_RESOURCES		\
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 5fe7099..ab7ae57 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -150,29 +150,6 @@ struct task_struct *kthread_create(int (*threadfn)(void *data),
 EXPORT_SYMBOL(kthread_create);
 
 /**
- * kthread_bind - bind a just-created kthread to a cpu.
- * @k: thread created by kthread_create().
- * @cpu: cpu (might not be online, must be possible) for @k to run on.
- *
- * Description: This function is equivalent to set_cpus_allowed(),
- * except that @cpu doesn't need to be online, and the thread must be
- * stopped (i.e., just returned from kthread_create()).
- */
-void kthread_bind(struct task_struct *k, unsigned int cpu)
-{
-	/* Must have done schedule() in kthread() before we set_task_cpu */
-	if (!wait_task_inactive(k, TASK_UNINTERRUPTIBLE)) {
-		WARN_ON(1);
-		return;
-	}
-	set_task_cpu(k, cpu);
-	k->cpus_allowed = cpumask_of_cpu(cpu);
-	k->rt.nr_cpus_allowed = 1;
-	k->flags |= PF_THREAD_BOUND;
-}
-EXPORT_SYMBOL(kthread_bind);
-
-/**
  * kthread_stop - stop a thread created by kthread_create().
  * @k: thread created by kthread_create().
  *
diff --git a/kernel/sched.c b/kernel/sched.c
index 789001d..5cb7d63 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1996,6 +1996,38 @@ static inline void check_class_changed(struct rq *rq, struct task_struct *p,
 		p->sched_class->prio_changed(rq, p, oldprio, running);
 }
 
+/**
+ * kthread_bind - bind a just-created kthread to a cpu.
+ * @k: thread created by kthread_create().
+ * @cpu: cpu (might not be online, must be possible) for @k to run on.
+ *
+ * Description: This function is equivalent to set_cpus_allowed(),
+ * except that @cpu doesn't need to be online, and the thread must be
+ * stopped (i.e., just returned from kthread_create()).
+ *
+ * Function lives here instead of kthread.c because it messes with
+ * scheduler internals which require locking.
+ */
+void kthread_bind(struct task_struct *p, unsigned int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long flags;
+
+	/* Must have done schedule() in kthread() before we set_task_cpu */
+	if (!wait_task_inactive(p, TASK_UNINTERRUPTIBLE)) {
+		WARN_ON(1);
+		return;
+	}
+
+	spin_lock_irqsave(&rq->lock, flags);
+	set_task_cpu(p, cpu);
+	p->cpus_allowed = cpumask_of_cpu(cpu);
+	p->rt.nr_cpus_allowed = 1;
+	p->flags |= PF_THREAD_BOUND;
+	spin_unlock_irqrestore(&rq->lock, flags);
+}
+EXPORT_SYMBOL(kthread_bind);
+
 #ifdef CONFIG_SMP
 /*
  * Is this task likely cache-hot:
@@ -2008,7 +2040,7 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 	/*
 	 * Buddy candidates are cache hot:
 	 */
-	if (sched_feat(CACHE_HOT_BUDDY) &&
+	if (sched_feat(CACHE_HOT_BUDDY) && this_rq()->nr_running &&
 			(&p->se == cfs_rq_of(&p->se)->next ||
 			 &p->se == cfs_rq_of(&p->se)->last))
 		return 1;
@@ -9535,13 +9567,13 @@ void __init sched_init(void)
 	current->sched_class = &fair_sched_class;
 
 	/* Allocate the nohz_cpu_mask if CONFIG_CPUMASK_OFFSTACK */
-	alloc_cpumask_var(&nohz_cpu_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&nohz_cpu_mask, GFP_NOWAIT);
 #ifdef CONFIG_SMP
 #ifdef CONFIG_NO_HZ
-	alloc_cpumask_var(&nohz.cpu_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&nohz.cpu_mask, GFP_NOWAIT);
 	alloc_cpumask_var(&nohz.ilb_grp_nohz_mask, GFP_NOWAIT);
 #endif
-	alloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
+	zalloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
 #endif /* SMP */
 
 	perf_event_init();
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c32c3e6..37087a7 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -822,6 +822,26 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 		 * re-elected due to buddy favours.
 		 */
 		clear_buddies(cfs_rq, curr);
+		return;
+	}
+
+	/*
+	 * Ensure that a task that missed wakeup preemption by a
+	 * narrow margin doesn't have to wait for a full slice.
+	 * This also mitigates buddy induced latencies under load.
+	 */
+	if (!sched_feat(WAKEUP_PREEMPT))
+		return;
+
+	if (delta_exec < sysctl_sched_min_granularity)
+		return;
+
+	if (cfs_rq->nr_running > 1) {
+		struct sched_entity *se = __pick_next_entity(cfs_rq);
+		s64 delta = curr->vruntime - se->vruntime;
+
+		if (delta > ideal_runtime)
+			resched_task(rq_of(cfs_rq)->curr);
 	}
 }
 
@@ -861,21 +881,18 @@ wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
 static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *se = __pick_next_entity(cfs_rq);
-	struct sched_entity *buddy;
+	struct sched_entity *left = se;
 
-	if (cfs_rq->next) {
-		buddy = cfs_rq->next;
-		cfs_rq->next = NULL;
-		if (wakeup_preempt_entity(buddy, se) < 1)
-			return buddy;
-	}
+	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
+		se = cfs_rq->next;
 
-	if (cfs_rq->last) {
-		buddy = cfs_rq->last;
-		cfs_rq->last = NULL;
-		if (wakeup_preempt_entity(buddy, se) < 1)
-			return buddy;
-	}
+	/*
+	 * Prefer last buddy, try to return the CPU to a preempted task.
+	 */
+	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1)
+		se = cfs_rq->last;
+
+	clear_buddies(cfs_rq, se);
 
 	return se;
 }
@@ -1577,6 +1594,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	struct sched_entity *se = &curr->se, *pse = &p->se;
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
 	int sync = wake_flags & WF_SYNC;
+	int scale = cfs_rq->nr_running >= sched_nr_latency;
 
 	update_curr(cfs_rq);
 
@@ -1591,18 +1609,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	if (unlikely(se == pse))
 		return;
 
-	/*
-	 * Only set the backward buddy when the current task is still on the
-	 * rq. This can happen when a wakeup gets interleaved with schedule on
-	 * the ->pre_schedule() or idle_balance() point, either of which can
-	 * drop the rq lock.
-	 *
-	 * Also, during early boot the idle thread is in the fair class, for
-	 * obvious reasons its a bad idea to schedule back to the idle thread.
-	 */
-	if (sched_feat(LAST_BUDDY) && likely(se->on_rq && curr != rq->idle))
-		set_last_buddy(se);
-	if (sched_feat(NEXT_BUDDY) && !(wake_flags & WF_FORK))
+	if (sched_feat(NEXT_BUDDY) && scale && !(wake_flags & WF_FORK))
 		set_next_buddy(pse);
 
 	/*
@@ -1648,8 +1655,22 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 
 	BUG_ON(!pse);
 
-	if (wakeup_preempt_entity(se, pse) == 1)
+	if (wakeup_preempt_entity(se, pse) == 1) {
 		resched_task(curr);
+		/*
+		 * Only set the backward buddy when the current task is still
+		 * on the rq. This can happen when a wakeup gets interleaved
+		 * with schedule on the ->pre_schedule() or idle_balance()
+		 * point, either of which can * drop the rq lock.
+		 *
+		 * Also, during early boot the idle thread is in the fair class,
+		 * for obvious reasons its a bad idea to schedule back to it.
+		 */
+		if (unlikely(!se->on_rq || curr == rq->idle))
+			return;
+		if (sched_feat(LAST_BUDDY) && scale && entity_is_task(se))
+			set_last_buddy(se);
+	}
 }
 
 static struct task_struct *pick_next_task_fair(struct rq *rq)
