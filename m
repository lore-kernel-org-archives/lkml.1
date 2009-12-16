Return-Path: <linux-kernel-owner+w=401wt.eu-S935252AbZLPSkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935252AbZLPSkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935246AbZLPSkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:40:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:53539 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935188AbZLPSj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:39:57 -0500
Date: Wed, 16 Dec 2009 18:39:09 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091216170518.191697025@chello.nl>
References: <20091216170518.191697025@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Remove the cfs_rq dependency from set_task_cpu()
Message-ID: <tip-88ec22d3edb72b261f8628226cd543589a6d5e1b@git.kernel.org>
Git-Commit-ID: 88ec22d3edb72b261f8628226cd543589a6d5e1b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  88ec22d3edb72b261f8628226cd543589a6d5e1b
Gitweb:     http://git.kernel.org/tip/88ec22d3edb72b261f8628226cd543589a6d5e1b
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 16 Dec 2009 18:04:41 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Dec 2009 19:01:58 +0100

sched: Remove the cfs_rq dependency from set_task_cpu()

In order to remove the cfs_rq dependency from set_task_cpu() we
need to ensure the task is cfs_rq invariant for all callsites.

The simple approach is to substract cfs_rq->min_vruntime from
se->vruntime on dequeue, and add cfs_rq->min_vruntime on
enqueue.

However, this has the downside of breaking FAIR_SLEEPERS since
we loose the old vruntime as we only maintain the relative
position.

To solve this, we observe that we only migrate runnable tasks,
we do this using deactivate_task(.sleep=0) and
activate_task(.wakeup=0), therefore we can restrain the
min_vruntime invariance to that state.

The only other case is wakeup balancing, since we want to
maintain the old vruntime we cannot make it relative on dequeue,
but since we don't migrate inactive tasks, we can do so right
before we activate it again.

This is where we need the new pre-wakeup hook, we need to call
this while still holding the old rq->lock. We could fold it into
->select_task_rq(), but since that has multiple callsites and
would obfuscate the locking requirements, that seems like a
fudge.

This leaves the fork() case, simply make sure that ->task_fork()
leaves the ->vruntime in a relative state.

This covers all cases where set_task_cpu() gets called, and
ensures it sees a relative vruntime.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091216170518.191697025@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    2 +-
 kernel/sched.c        |    6 +----
 kernel/sched_fair.c   |   50 +++++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 46 insertions(+), 12 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2c9fa1c..973b2b8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1116,7 +1116,7 @@ struct sched_class {
 					 struct task_struct *task);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	void (*moved_group) (struct task_struct *p);
+	void (*moved_group) (struct task_struct *p, int on_rq);
 #endif
 };
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 6c571bd..f92ce63 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2038,8 +2038,6 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 {
 	int old_cpu = task_cpu(p);
-	struct cfs_rq *old_cfsrq = task_cfs_rq(p),
-		      *new_cfsrq = cpu_cfs_rq(old_cfsrq, new_cpu);
 
 #ifdef CONFIG_SCHED_DEBUG
 	/*
@@ -2056,8 +2054,6 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS,
 				     1, 1, NULL, 0);
 	}
-	p->se.vruntime -= old_cfsrq->min_vruntime -
-					 new_cfsrq->min_vruntime;
 
 	__set_task_cpu(p, new_cpu);
 }
@@ -10102,7 +10098,7 @@ void sched_move_task(struct task_struct *tsk)
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	if (tsk->sched_class->moved_group)
-		tsk->sched_class->moved_group(tsk);
+		tsk->sched_class->moved_group(tsk, on_rq);
 #endif
 
 	if (unlikely(running))
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index ec1d271..42ac3c9 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -510,6 +510,7 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 	curr->sum_exec_runtime += delta_exec;
 	schedstat_add(cfs_rq, exec_clock, delta_exec);
 	delta_exec_weighted = calc_delta_fair(delta_exec, curr);
+
 	curr->vruntime += delta_exec_weighted;
 	update_min_vruntime(cfs_rq);
 }
@@ -765,16 +766,26 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 	se->vruntime = vruntime;
 }
 
+#define ENQUEUE_WAKEUP	1
+#define ENQUEUE_MIGRATE 2
+
 static void
-enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
+enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 {
 	/*
+	 * Update the normalized vruntime before updating min_vruntime
+	 * through callig update_curr().
+	 */
+	if (!(flags & ENQUEUE_WAKEUP) || (flags & ENQUEUE_MIGRATE))
+		se->vruntime += cfs_rq->min_vruntime;
+
+	/*
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
 	account_entity_enqueue(cfs_rq, se);
 
-	if (wakeup) {
+	if (flags & ENQUEUE_WAKEUP) {
 		place_entity(cfs_rq, se, 0);
 		enqueue_sleeper(cfs_rq, se);
 	}
@@ -828,6 +839,14 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 		__dequeue_entity(cfs_rq, se);
 	account_entity_dequeue(cfs_rq, se);
 	update_min_vruntime(cfs_rq);
+
+	/*
+	 * Normalize the entity after updating the min_vruntime because the
+	 * update can refer to the ->curr item and we need to reflect this
+	 * movement in our normalized position.
+	 */
+	if (!sleep)
+		se->vruntime -= cfs_rq->min_vruntime;
 }
 
 /*
@@ -1038,13 +1057,19 @@ static void enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
+	int flags = 0;
+
+	if (wakeup)
+		flags |= ENQUEUE_WAKEUP;
+	if (p->state == TASK_WAKING)
+		flags |= ENQUEUE_MIGRATE;
 
 	for_each_sched_entity(se) {
 		if (se->on_rq)
 			break;
 		cfs_rq = cfs_rq_of(se);
-		enqueue_entity(cfs_rq, se, wakeup);
-		wakeup = 1;
+		enqueue_entity(cfs_rq, se, flags);
+		flags = ENQUEUE_WAKEUP;
 	}
 
 	hrtick_update(rq);
@@ -1120,6 +1145,14 @@ static void yield_task_fair(struct rq *rq)
 
 #ifdef CONFIG_SMP
 
+static void task_waking_fair(struct rq *rq, struct task_struct *p)
+{
+	struct sched_entity *se = &p->se;
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+
+	se->vruntime -= cfs_rq->min_vruntime;
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 /*
  * effective_load() calculates the load change as seen from the root_task_group
@@ -1978,6 +2011,8 @@ static void task_fork_fair(struct task_struct *p)
 		resched_task(rq->curr);
 	}
 
+	se->vruntime -= cfs_rq->min_vruntime;
+
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
@@ -2031,12 +2066,13 @@ static void set_curr_task_fair(struct rq *rq)
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static void moved_group_fair(struct task_struct *p)
+static void moved_group_fair(struct task_struct *p, int on_rq)
 {
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
 
 	update_curr(cfs_rq);
-	place_entity(cfs_rq, &p->se, 1);
+	if (!on_rq)
+		place_entity(cfs_rq, &p->se, 1);
 }
 #endif
 
@@ -2076,6 +2112,8 @@ static const struct sched_class fair_sched_class = {
 	.move_one_task		= move_one_task_fair,
 	.rq_online		= rq_online_fair,
 	.rq_offline		= rq_offline_fair,
+
+	.task_waking		= task_waking_fair,
 #endif
 
 	.set_curr_task          = set_curr_task_fair,
