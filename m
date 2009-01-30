Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbZA3XKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbZA3XKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 18:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbZA3XJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 18:09:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47215 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbZA3XJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 18:09:51 -0500
Date: Sat, 31 Jan 2009 00:09:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fixes
Message-ID: <20090130230936.GA7549@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Alexey Zaytsev (1):
      x86: set the initial softirq preempt count to SOFTIRQ_OFFSET

Ingo Molnar (1):
      sched: re-enable sync wakeups again

Miao Xie (1):
      cpuset: fix possible deadlock in async_rebuild_sched_domains

Mike Galbraith (1):
      sched: clear buddies more aggressively

Nick Piggin (1):
      sched: improve preempt debugging

Peter Zijlstra (3):
      sched: disable sync wakeups
      sched: symmetric sync vs avg_overlap
      sched: fix buddie group latency


 arch/x86/kernel/irq_32.c |    2 +-
 kernel/cpuset.c          |   13 ++++++++++++-
 kernel/sched.c           |   12 +++++++++++-
 kernel/sched_fair.c      |   32 +++++++++++++++++++++-----------
 4 files changed, 45 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 74b9ff7..8d99de6 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -141,7 +141,7 @@ void __cpuinit irq_ctx_init(int cpu)
 	irqctx->tinfo.task		= NULL;
 	irqctx->tinfo.exec_domain	= NULL;
 	irqctx->tinfo.cpu		= cpu;
-	irqctx->tinfo.preempt_count	= 0;
+	irqctx->tinfo.preempt_count	= SOFTIRQ_OFFSET;
 	irqctx->tinfo.addr_limit	= MAKE_MM_SEG(0);
 
 	softirq_ctx[cpu] = irqctx;
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index a856788..f76db9d 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -61,6 +61,14 @@
 #include <linux/cgroup.h>
 
 /*
+ * Workqueue for cpuset related tasks.
+ *
+ * Using kevent workqueue may cause deadlock when memory_migrate
+ * is set. So we create a separate workqueue thread for cpuset.
+ */
+static struct workqueue_struct *cpuset_wq;
+
+/*
  * Tracks how many cpusets are currently defined in system.
  * When there is only one cpuset (the root cpuset) we can
  * short circuit some hooks.
@@ -831,7 +839,7 @@ static DECLARE_WORK(rebuild_sched_domains_work, do_rebuild_sched_domains);
  */
 static void async_rebuild_sched_domains(void)
 {
-	schedule_work(&rebuild_sched_domains_work);
+	queue_work(cpuset_wq, &rebuild_sched_domains_work);
 }
 
 /*
@@ -2111,6 +2119,9 @@ void __init cpuset_init_smp(void)
 
 	hotcpu_notifier(cpuset_track_online_cpus, 0);
 	hotplug_memory_notifier(cpuset_track_online_nodes, 10);
+
+	cpuset_wq = create_singlethread_workqueue("cpuset");
+	BUG_ON(!cpuset_wq);
 }
 
 /**
diff --git a/kernel/sched.c b/kernel/sched.c
index 52bbf1c..5686bb5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2266,6 +2266,16 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 	if (!sched_feat(SYNC_WAKEUPS))
 		sync = 0;
 
+	if (!sync) {
+		if (current->se.avg_overlap < sysctl_sched_migration_cost &&
+			  p->se.avg_overlap < sysctl_sched_migration_cost)
+			sync = 1;
+	} else {
+		if (current->se.avg_overlap >= sysctl_sched_migration_cost ||
+			  p->se.avg_overlap >= sysctl_sched_migration_cost)
+			sync = 0;
+	}
+
 #ifdef CONFIG_SMP
 	if (sched_feat(LB_WAKEUP_UPDATE)) {
 		struct sched_domain *sd;
@@ -4440,7 +4450,7 @@ void __kprobes sub_preempt_count(int val)
 	/*
 	 * Underflow?
 	 */
-	if (DEBUG_LOCKS_WARN_ON(val > preempt_count()))
+       if (DEBUG_LOCKS_WARN_ON(val > preempt_count() - (!!kernel_locked())))
 		return;
 	/*
 	 * Is the spinlock portion underflowing?
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5cc1c16..a7e50ba 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -719,7 +719,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
 		__enqueue_entity(cfs_rq, se);
 }
 
-static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static void __clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	if (cfs_rq->last == se)
 		cfs_rq->last = NULL;
@@ -728,6 +728,12 @@ static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		cfs_rq->next = NULL;
 }
 
+static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	for_each_sched_entity(se)
+		__clear_buddies(cfs_rq_of(se), se);
+}
+
 static void
 dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 {
@@ -768,8 +774,14 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 
 	ideal_runtime = sched_slice(cfs_rq, curr);
 	delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
-	if (delta_exec > ideal_runtime)
+	if (delta_exec > ideal_runtime) {
 		resched_task(rq_of(cfs_rq)->curr);
+		/*
+		 * The current task ran long enough, ensure it doesn't get
+		 * re-elected due to buddy favours.
+		 */
+		clear_buddies(cfs_rq, curr);
+	}
 }
 
 static void
@@ -1179,20 +1191,15 @@ wake_affine(struct sched_domain *this_sd, struct rq *this_rq,
 	    int idx, unsigned long load, unsigned long this_load,
 	    unsigned int imbalance)
 {
-	struct task_struct *curr = this_rq->curr;
-	struct task_group *tg;
 	unsigned long tl = this_load;
 	unsigned long tl_per_task;
+	struct task_group *tg;
 	unsigned long weight;
 	int balanced;
 
 	if (!(this_sd->flags & SD_WAKE_AFFINE) || !sched_feat(AFFINE_WAKEUPS))
 		return 0;
 
-	if (sync && (curr->se.avg_overlap > sysctl_sched_migration_cost ||
-			p->se.avg_overlap > sysctl_sched_migration_cost))
-		sync = 0;
-
 	/*
 	 * If sync wakeup then subtract the (maximum possible)
 	 * effect of the currently running task from the load
@@ -1419,9 +1426,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
-	if (sched_feat(WAKEUP_OVERLAP) && (sync ||
-			(se->avg_overlap < sysctl_sched_migration_cost &&
-			 pse->avg_overlap < sysctl_sched_migration_cost))) {
+	if (sched_feat(WAKEUP_OVERLAP) && sync) {
 		resched_task(curr);
 		return;
 	}
@@ -1452,6 +1457,11 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
 
 	do {
 		se = pick_next_entity(cfs_rq);
+		/*
+		 * If se was a buddy, clear it so that it will have to earn
+		 * the favour again.
+		 */
+		__clear_buddies(cfs_rq, se);
 		set_next_entity(cfs_rq, se);
 		cfs_rq = group_cfs_rq(se);
 	} while (cfs_rq);
