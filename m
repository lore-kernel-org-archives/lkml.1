Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbZKIJKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbZKIJKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbZKIJKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:10:41 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47320 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777AbZKIJKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:10:38 -0500
Date: Mon, 9 Nov 2009 14:40:38 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: [RFC v3 PATCH 3/7] sched: Enforce hard limits by throttling
Message-ID: <20091109091038.GG23472@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20091109090838.GD23472@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109090838.GD23472@in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: Enforce hard limits by throttling.

From: Bharata B Rao <bharata@linux.vnet.ibm.com>

Throttle the task-groups which exceed the runtime allocated to them.
Throttled group entities are removed from the run queue.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched.c      |   13 ++++
 kernel/sched_fair.c |  164 +++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 163 insertions(+), 14 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 1d46fdc..5d2e5e5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1631,6 +1631,7 @@ static void update_group_shares_cpu(struct task_group *tg, int cpu,
 	}
 }
 
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq);
 /*
  * Re-compute the task group their per cpu shares over the given domain.
  * This needs to be done in a bottom-up fashion because the rq weight of a
@@ -1658,8 +1659,10 @@ static int tg_shares_up(struct task_group *tg, void *data)
 		 * If there are currently no tasks on the cpu pretend there
 		 * is one of average load so that when a new task gets to
 		 * run here it will not get delayed by group starvation.
+		 * Also if the group is throttled on this cpu, pretend that
+		 * it has no tasks.
 		 */
-		if (!weight)
+		if (!weight || cfs_rq_throttled(tg->cfs_rq[i]))
 			weight = NICE_0_LOAD;
 
 		rq_weight += weight;
@@ -1684,6 +1687,7 @@ static int tg_shares_up(struct task_group *tg, void *data)
  * Compute the cpu's hierarchical load factor for each task group.
  * This needs to be done in a top-down fashion because the load of a child
  * group is a fraction of its parents load.
+ * A throttled group's h_load is set to 0.
  */
 static int tg_load_down(struct task_group *tg, void *data)
 {
@@ -1692,6 +1696,8 @@ static int tg_load_down(struct task_group *tg, void *data)
 
 	if (!tg->parent) {
 		load = cpu_rq(cpu)->load.weight;
+	} else if (cfs_rq_throttled(tg->cfs_rq[cpu])) {
+		load = 0;
 	} else {
 		load = tg->parent->cfs_rq[cpu]->h_load;
 		load *= tg->cfs_rq[cpu]->shares;
@@ -1994,6 +2000,11 @@ static inline void cfs_rq_runtime_unlock(struct cfs_rq *cfs_rq)
 	return;
 }
 
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
+{
+	return 0;
+}
+
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #include "sched_stats.h"
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c32c3e6..b83ff7d 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -189,7 +189,54 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 	}
 }
 
-#else	/* !CONFIG_FAIR_GROUP_SCHED */
+#ifdef CONFIG_CFS_HARD_LIMITS
+
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
+{
+	return cfs_rq->cfs_throttled;
+}
+
+/*
+ * Check if group entity exceeded its runtime. If so, mark the cfs_rq as
+ * throttled mark the current task for reschedling.
+ */
+static void sched_cfs_runtime_exceeded(struct sched_entity *se,
+	struct task_struct *tsk_curr, unsigned long delta_exec)
+{
+	struct cfs_rq *cfs_rq;
+
+	cfs_rq = group_cfs_rq(se);
+
+	if (cfs_rq->cfs_runtime == RUNTIME_INF)
+		return;
+
+	cfs_rq->cfs_time += delta_exec;
+
+	if (cfs_rq_throttled(cfs_rq))
+		return;
+
+	if (cfs_rq->cfs_time > cfs_rq->cfs_runtime) {
+		cfs_rq->cfs_throttled = 1;
+		resched_task(tsk_curr);
+	}
+}
+
+#else
+
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
+{
+	return 0;
+}
+
+static void sched_cfs_runtime_exceeded(struct sched_entity *se,
+	struct task_struct *tsk_curr, unsigned long delta_exec)
+{
+	return;
+}
+
+#endif /* CONFIG_CFS_HARD_LIMITS */
+
+#else	/* CONFIG_FAIR_GROUP_SCHED */
 
 static inline struct task_struct *task_of(struct sched_entity *se)
 {
@@ -249,6 +296,12 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 {
 }
 
+static void sched_cfs_runtime_exceeded(struct sched_entity *se,
+	struct task_struct *tsk_curr, unsigned long delta_exec)
+{
+	return;
+}
+
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
 
@@ -489,10 +542,12 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 	update_min_vruntime(cfs_rq);
 }
 
-static void update_curr(struct cfs_rq *cfs_rq)
+static void update_curr_common(struct cfs_rq *cfs_rq, int locked)
 {
 	struct sched_entity *curr = cfs_rq->curr;
-	u64 now = rq_of(cfs_rq)->clock;
+	struct rq *rq = rq_of(cfs_rq);
+	struct task_struct *tsk_curr = rq->curr;
+	u64 now = rq->clock;
 	unsigned long delta_exec;
 
 	if (unlikely(!curr))
@@ -516,9 +571,26 @@ static void update_curr(struct cfs_rq *cfs_rq)
 		trace_sched_stat_runtime(curtask, delta_exec, curr->vruntime);
 		cpuacct_charge(curtask, delta_exec);
 		account_group_exec_runtime(curtask, delta_exec);
+	} else {
+		 /* TODO: (Un)locking this way is ugly, find an alterntive. */
+		if (!locked)
+			cfs_rq_runtime_lock(group_cfs_rq(curr));
+		sched_cfs_runtime_exceeded(curr, tsk_curr, delta_exec);
+		if (!locked)
+			cfs_rq_runtime_unlock(group_cfs_rq(curr));
 	}
 }
 
+static inline void update_curr(struct cfs_rq *cfs_rq)
+{
+	update_curr_common(cfs_rq, 0);
+}
+
+static inline void update_curr_locked(struct cfs_rq *cfs_rq)
+{
+	update_curr_common(cfs_rq, 1);
+}
+
 static inline void
 update_stats_wait_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
@@ -740,13 +812,9 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 	se->vruntime = vruntime;
 }
 
-static void
-enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
+static void enqueue_entity_common(struct cfs_rq *cfs_rq,
+		struct sched_entity *se, int wakeup)
 {
-	/*
-	 * Update run-time statistics of the 'current'.
-	 */
-	update_curr(cfs_rq);
 	account_entity_enqueue(cfs_rq, se);
 
 	if (wakeup) {
@@ -760,6 +828,26 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
 		__enqueue_entity(cfs_rq, se);
 }
 
+static void enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
+		int wakeup)
+{
+	/*
+	 * Update run-time statistics of the 'current'.
+	 */
+	update_curr(cfs_rq);
+	enqueue_entity_common(cfs_rq, se, wakeup);
+}
+
+static void enqueue_entity_locked(struct cfs_rq *cfs_rq,
+		struct sched_entity *se, int wakeup)
+{
+	/*
+	 * Update run-time statistics of the 'current'.
+	 */
+	update_curr_locked(cfs_rq);
+	enqueue_entity_common(cfs_rq, se, wakeup);
+}
+
 static void __clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	if (!se || cfs_rq->last == se)
@@ -880,6 +968,32 @@ static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 	return se;
 }
 
+/*
+ * Called from put_prev_entity()
+ * If a group entity (@se) is found to be throttled, it will not be put back
+ * on @cfs_rq, which is equivalent to dequeing it.
+ */
+static int dequeue_throttled_entity(struct cfs_rq *cfs_rq,
+		struct sched_entity *se)
+{
+	struct cfs_rq *gcfs_rq = group_cfs_rq(se);
+
+	if (entity_is_task(se))
+		return 0;
+
+	cfs_rq_runtime_lock(gcfs_rq);
+	if (!cfs_rq_throttled(gcfs_rq) && gcfs_rq->nr_running) {
+		cfs_rq_runtime_unlock(gcfs_rq);
+		return 0;
+	}
+
+	__clear_buddies(cfs_rq, se);
+	account_entity_dequeue(cfs_rq, se);
+	cfs_rq->curr = NULL;
+	cfs_rq_runtime_unlock(gcfs_rq);
+	return 1;
+}
+
 static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 {
 	/*
@@ -891,6 +1005,8 @@ static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 
 	check_spread(cfs_rq, prev);
 	if (prev->on_rq) {
+		if (dequeue_throttled_entity(cfs_rq, prev))
+			return;
 		update_stats_wait_start(cfs_rq, prev);
 		/* Put 'current' back into the tree. */
 		__enqueue_entity(cfs_rq, prev);
@@ -987,10 +1103,28 @@ static inline void hrtick_update(struct rq *rq)
 }
 #endif
 
+static int enqueue_group_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
+		 int wakeup)
+{
+	struct cfs_rq *gcfs_rq = group_cfs_rq(se);
+	int ret = 0;
+
+	cfs_rq_runtime_lock(gcfs_rq);
+	if (cfs_rq_throttled(gcfs_rq)) {
+		ret = 1;
+		goto out;
+	}
+	enqueue_entity_locked(cfs_rq, se, wakeup);
+out:
+	cfs_rq_runtime_unlock(gcfs_rq);
+	return ret;
+}
+
 /*
  * The enqueue_task method is called before nr_running is
  * increased. Here we update the fair scheduling stats and
  * then put the task into the rbtree:
+ * Don't enqueue a throttled entity further into the hierarchy.
  */
 static void enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup)
 {
@@ -1000,11 +1134,15 @@ static void enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup)
 	for_each_sched_entity(se) {
 		if (se->on_rq)
 			break;
+
 		cfs_rq = cfs_rq_of(se);
-		enqueue_entity(cfs_rq, se, wakeup);
+		if (entity_is_task(se))
+			enqueue_entity(cfs_rq, se, wakeup);
+		else
+			if (enqueue_group_entity(cfs_rq, se, wakeup))
+				break;
 		wakeup = 1;
 	}
-
 	hrtick_update(rq);
 }
 
@@ -1767,9 +1905,9 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		u64 rem_load, moved_load;
 
 		/*
-		 * empty group
+		 * empty group or a group with no h_load (throttled)
 		 */
-		if (!busiest_cfs_rq->task_weight)
+		if (!busiest_cfs_rq->task_weight || !busiest_h_load)
 			continue;
 
 		rem_load = (u64)rem_load_move * busiest_weight;
