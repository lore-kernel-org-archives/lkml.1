Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab0CKScP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:32:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:40821 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755957Ab0CKSbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:31:51 -0500
Date: Thu, 11 Mar 2010 18:31:12 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1268301121.6785.30.camel@marge.simson.net>
References: <1268301121.6785.30.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove avg_overlap
Message-ID: <tip-e12f31d3e5d36328c7fbd0fce40a95e70b59152c@git.kernel.org>
Git-Commit-ID: e12f31d3e5d36328c7fbd0fce40a95e70b59152c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 18:31:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e12f31d3e5d36328c7fbd0fce40a95e70b59152c
Gitweb:     http://git.kernel.org/tip/e12f31d3e5d36328c7fbd0fce40a95e70b59152c
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 11 Mar 2010 17:15:51 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 18:32:50 +0100

sched: Remove avg_overlap

Both avg_overlap and avg_wakeup had an inherent problem in that their accuracy
was detrimentally affected by cross-cpu wakeups, this because we are missing
the necessary call to update_curr().  This can't be fixed without increasing
overhead in our already too fat fastpath.

Additionally, with recent load balancing changes making us prefer to place tasks
in an idle cache domain (which is good for compute bound loads), communicating
tasks suffer when a sync wakeup, which would enable affine placement, is turned
into a non-sync wakeup by SYNC_LESS.  With one task on the runqueue, wake_affine()
rejects the affine wakeup request, leaving the unfortunate where placed, taking
frequent cache misses.

Remove it, and recover some fastpath cycles.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1268301121.6785.30.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h   |    3 ---
 kernel/sched.c          |   33 ---------------------------------
 kernel/sched_debug.c    |    1 -
 kernel/sched_fair.c     |   18 ------------------
 kernel/sched_features.h |   16 ----------------
 5 files changed, 0 insertions(+), 71 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 70c560f..8604884 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1180,9 +1180,6 @@ struct sched_entity {
 	u64			vruntime;
 	u64			prev_sum_exec_runtime;
 
-	u64			last_wakeup;
-	u64			avg_overlap;
-
 	u64			nr_migrations;
 
 #ifdef CONFIG_SCHEDSTATS
diff --git a/kernel/sched.c b/kernel/sched.c
index 35a8626..68ed6f4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1887,11 +1887,6 @@ enqueue_task(struct rq *rq, struct task_struct *p, int wakeup, bool head)
 
 static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
 {
-	if (sleep && p->se.last_wakeup) {
-		update_avg(&p->se.avg_overlap,
-			p->se.sum_exec_runtime - p->se.last_wakeup);
-		p->se.last_wakeup = 0;
-	}
 	sched_info_dequeued(p);
 	p->sched_class->dequeue_task(rq, p, sleep);
 	p->se.on_rq = 0;
@@ -2452,15 +2447,6 @@ out_activate:
 	activate_task(rq, p, 1);
 	success = 1;
 
-	/*
-	 * Only attribute actual wakeups done by this task.
-	 */
-	if (!in_interrupt()) {
-		struct sched_entity *se = &current->se;
-
-		se->last_wakeup = se->sum_exec_runtime;
-	}
-
 out_running:
 	trace_sched_wakeup(rq, p, success);
 	check_preempt_curr(rq, p, wake_flags);
@@ -2522,8 +2508,6 @@ static void __sched_fork(struct task_struct *p)
 	p->se.sum_exec_runtime		= 0;
 	p->se.prev_sum_exec_runtime	= 0;
 	p->se.nr_migrations		= 0;
-	p->se.last_wakeup		= 0;
-	p->se.avg_overlap		= 0;
 
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
@@ -3594,23 +3578,6 @@ static inline void schedule_debug(struct task_struct *prev)
 
 static void put_prev_task(struct rq *rq, struct task_struct *prev)
 {
-	if (prev->state == TASK_RUNNING) {
-		u64 runtime = prev->se.sum_exec_runtime;
-
-		runtime -= prev->se.prev_sum_exec_runtime;
-		runtime = min_t(u64, runtime, 2*sysctl_sched_migration_cost);
-
-		/*
-		 * In order to avoid avg_overlap growing stale when we are
-		 * indeed overlapping and hence not getting put to sleep, grow
-		 * the avg_overlap on preemption.
-		 *
-		 * We use the average preemption runtime because that
-		 * correlates to the amount of cache footprint a task can
-		 * build up.
-		 */
-		update_avg(&prev->se.avg_overlap, runtime);
-	}
 	prev->sched_class->put_prev_task(rq, prev);
 }
 
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 20b95a4..8a46a71 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -407,7 +407,6 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	PN(se.exec_start);
 	PN(se.vruntime);
 	PN(se.sum_exec_runtime);
-	PN(se.avg_overlap);
 
 	nr_switches = p->nvcsw + p->nivcsw;
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 6fc6285..c3b69d4 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1241,7 +1241,6 @@ static inline unsigned long effective_load(struct task_group *tg, int cpu,
 
 static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 {
-	struct task_struct *curr = current;
 	unsigned long this_load, load;
 	int idx, this_cpu, prev_cpu;
 	unsigned long tl_per_task;
@@ -1256,18 +1255,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	load	  = source_load(prev_cpu, idx);
 	this_load = target_load(this_cpu, idx);
 
-	if (sync) {
-	       if (sched_feat(SYNC_LESS) &&
-		   (curr->se.avg_overlap > sysctl_sched_migration_cost ||
-		    p->se.avg_overlap > sysctl_sched_migration_cost))
-		       sync = 0;
-	} else {
-		if (sched_feat(SYNC_MORE) &&
-		    (curr->se.avg_overlap < sysctl_sched_migration_cost &&
-		     p->se.avg_overlap < sysctl_sched_migration_cost))
-			sync = 1;
-	}
-
 	/*
 	 * If sync wakeup then subtract the (maximum possible)
 	 * effect of the currently running task from the load
@@ -1711,11 +1698,6 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	if (sched_feat(WAKEUP_SYNC) && sync)
 		goto preempt;
 
-	if (sched_feat(WAKEUP_OVERLAP) &&
-			se->avg_overlap < sysctl_sched_migration_cost &&
-			pse->avg_overlap < sysctl_sched_migration_cost)
-		goto preempt;
-
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 96ef5db..c545e04 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -42,12 +42,6 @@ SCHED_FEAT(ASYM_GRAN, 1)
 SCHED_FEAT(WAKEUP_SYNC, 0)
 
 /*
- * Wakeup preempt based on task behaviour. Tasks that do not overlap
- * don't get preempted.
- */
-SCHED_FEAT(WAKEUP_OVERLAP, 0)
-
-/*
  * Use the SYNC wakeup hint, pipes and the likes use this to indicate
  * the remote end is likely to consume the data we just wrote, and
  * therefore has cache benefit from being placed on the same cpu, see
@@ -64,16 +58,6 @@ SCHED_FEAT(SYNC_WAKEUPS, 1)
 SCHED_FEAT(AFFINE_WAKEUPS, 1)
 
 /*
- * Weaken SYNC hint based on overlap
- */
-SCHED_FEAT(SYNC_LESS, 1)
-
-/*
- * Add SYNC hint based on overlap
- */
-SCHED_FEAT(SYNC_MORE, 0)
-
-/*
  * Prefer to schedule the task we woke last (assuming it failed
  * wakeup-preemption), since its likely going to consume data we
  * touched, increases cache locality.
