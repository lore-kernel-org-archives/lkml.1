Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbZBAPoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbZBAPoQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 10:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbZBAPoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 10:44:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54657 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbZBAPn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 10:43:59 -0500
Date: Sun, 1 Feb 2009 16:43:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fixes
Message-ID: <20090201154344.GA13109@elte.hu>
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

(This has the problematic BKL-debug patch left out.)

 Thanks,

	Ingo

------------------>
Miao Xie (1):
      cpuset: fix possible deadlock in async_rebuild_sched_domains

Mike Galbraith (1):
      sched: clear buddies more aggressively

Peter Zijlstra (3):
      sched: fix sync wakeups
      sched: symmetric sync vs avg_overlap
      sched: fix buddie group latency

Rusty Russell (1):
      sched_rt: don't use first_cpu on cpumask created with cpumask_and


 kernel/cpuset.c     |   13 ++++++++++++-
 kernel/sched.c      |   10 ++++++++++
 kernel/sched_fair.c |   32 +++++++++++++++++++++-----------
 kernel/sched_rt.c   |    4 ++--
 4 files changed, 45 insertions(+), 14 deletions(-)

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
index 52bbf1c..242d0d4 100644
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
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 954e1a8..bac1061 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -968,8 +968,8 @@ static inline int pick_optimal_cpu(int this_cpu, cpumask_t *mask)
 	if ((this_cpu != -1) && cpu_isset(this_cpu, *mask))
 		return this_cpu;
 
-	first = first_cpu(*mask);
-	if (first != NR_CPUS)
+	first = cpumask_first(mask);
+	if (first < nr_cpu_ids)
 		return first;
 
 	return -1;
