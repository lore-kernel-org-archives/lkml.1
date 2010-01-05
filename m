Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379Ab0AEIBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab0AEIBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 03:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225Ab0AEIBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 03:01:49 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:59599 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab0AEIBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 03:01:48 -0500
Date: Tue, 5 Jan 2010 13:31:10 +0530
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
Subject: [RFC v5 PATCH 4/8] sched: Enforce hard limits by throttling
Message-ID: <20100105080110.GI27899@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20100105075703.GE27899@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105075703.GE27899@in.ibm.com>
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
 kernel/sched.c      |    5 +
 kernel/sched_fair.c |  205 +++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 183 insertions(+), 27 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 48d5483..c91158d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1633,6 +1633,7 @@ static void update_group_shares_cpu(struct task_group *tg, int cpu,
 	}
 }
 
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq);
 /*
  * Re-compute the task group their per cpu shares over the given domain.
  * This needs to be done in a bottom-up fashion because the rq weight of a
@@ -1661,8 +1662,10 @@ static int tg_shares_up(struct task_group *tg, void *data)
 		 * If there are currently no tasks on the cpu pretend there
 		 * is one of average load so that when a new task gets to
 		 * run here it will not get delayed by group starvation.
+		 * Also if the group is throttled on this cpu, pretend that
+		 * it has no tasks.
 		 */
-		if (!weight)
+		if (!weight || cfs_rq_throttled(tg->cfs_rq[i]))
 			weight = NICE_0_LOAD;
 
 		sum_weight += weight;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0dfb7a5..d1ee88e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -217,7 +217,66 @@ static inline void start_cfs_bandwidth(struct cfs_rq *cfs_rq)
 	return;
 }
 
-#else	/* !CONFIG_FAIR_GROUP_SCHED */
+#ifdef CONFIG_CFS_HARD_LIMITS
+
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
+{
+	return cfs_rq->rq_bandwidth.throttled;
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
+	if (cfs_rq->rq_bandwidth.runtime == RUNTIME_INF)
+		return;
+
+	cfs_rq->rq_bandwidth.time += delta_exec;
+
+	if (cfs_rq_throttled(cfs_rq))
+		return;
+
+	if (cfs_rq->rq_bandwidth.time > cfs_rq->rq_bandwidth.runtime) {
+		cfs_rq->rq_bandwidth.throttled = 1;
+		resched_task(tsk_curr);
+	}
+}
+
+static inline void update_curr_group(struct sched_entity *curr,
+		unsigned long delta_exec, struct task_struct *tsk_curr)
+{
+	sched_cfs_runtime_exceeded(curr, tsk_curr, delta_exec);
+}
+
+#else
+
+static inline void update_curr_group(struct sched_entity *curr,
+		unsigned long delta_exec, struct task_struct *tsk_curr)
+{
+	return;
+}
+
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
+{
+	return 0;
+}
+
+#endif /* CONFIG_CFS_HARD_LIMITS */
+
+#else	/* CONFIG_FAIR_GROUP_SCHED */
+
+static inline void update_curr_group(struct sched_entity *curr,
+		unsigned long delta_exec, struct task_struct *tsk_curr)
+{
+	return;
+}
 
 static inline struct task_struct *task_of(struct sched_entity *se)
 {
@@ -282,6 +341,11 @@ static inline void start_cfs_bandwidth(struct cfs_rq *cfs_rq)
 	return;
 }
 
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
+{
+	return 0;
+}
+
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
 
@@ -533,14 +597,25 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 	update_min_vruntime(cfs_rq);
 }
 
-static void update_curr(struct cfs_rq *cfs_rq)
+static void update_curr_task(struct sched_entity *curr,
+		unsigned long delta_exec)
+{
+	struct task_struct *curtask = task_of(curr);
+
+	trace_sched_stat_runtime(curtask, delta_exec, curr->vruntime);
+	cpuacct_charge(curtask, delta_exec);
+	account_group_exec_runtime(curtask, delta_exec);
+}
+
+static int update_curr_common(struct cfs_rq *cfs_rq, unsigned long *delta)
 {
 	struct sched_entity *curr = cfs_rq->curr;
-	u64 now = rq_of(cfs_rq)->clock;
+	struct rq *rq = rq_of(cfs_rq);
+	u64 now = rq->clock;
 	unsigned long delta_exec;
 
 	if (unlikely(!curr))
-		return;
+		return 1;
 
 	/*
 	 * Get the amount of time the current task was running
@@ -549,17 +624,31 @@ static void update_curr(struct cfs_rq *cfs_rq)
 	 */
 	delta_exec = (unsigned long)(now - curr->exec_start);
 	if (!delta_exec)
-		return;
+		return 1;
 
 	__update_curr(cfs_rq, curr, delta_exec);
 	curr->exec_start = now;
+	*delta = delta_exec;
+	return 0;
+}
 
-	if (entity_is_task(curr)) {
-		struct task_struct *curtask = task_of(curr);
-
-		trace_sched_stat_runtime(curtask, delta_exec, curr->vruntime);
-		cpuacct_charge(curtask, delta_exec);
-		account_group_exec_runtime(curtask, delta_exec);
+static void update_curr(struct cfs_rq *cfs_rq)
+{
+	struct sched_entity *curr = cfs_rq->curr;
+	struct rq *rq = rq_of(cfs_rq);
+	unsigned long delta_exec;
+	struct rq_bandwidth *rq_b;
+
+	if (update_curr_common(cfs_rq, &delta_exec))
+		return ;
+
+	if (entity_is_task(curr))
+		update_curr_task(curr, delta_exec);
+	else {
+		rq_b = &group_cfs_rq(curr)->rq_bandwidth;
+		raw_spin_lock(&rq_b->runtime_lock);
+		update_curr_group(curr, delta_exec, rq->curr);
+		raw_spin_unlock(&rq_b->runtime_lock);
 	}
 }
 
@@ -787,6 +876,22 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 #define ENQUEUE_WAKEUP	1
 #define ENQUEUE_MIGRATE 2
 
+static void enqueue_entity_common(struct cfs_rq *cfs_rq,
+		struct sched_entity *se, int flags)
+{
+	account_entity_enqueue(cfs_rq, se);
+
+	if (flags & ENQUEUE_WAKEUP) {
+		place_entity(cfs_rq, se, 0);
+		enqueue_sleeper(cfs_rq, se);
+	}
+
+	update_stats_enqueue(cfs_rq, se);
+	check_spread(cfs_rq, se);
+	if (se != cfs_rq->curr)
+		__enqueue_entity(cfs_rq, se);
+}
+
 static void
 enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 {
@@ -801,17 +906,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	account_entity_enqueue(cfs_rq, se);
-
-	if (flags & ENQUEUE_WAKEUP) {
-		place_entity(cfs_rq, se, 0);
-		enqueue_sleeper(cfs_rq, se);
-	}
-
-	update_stats_enqueue(cfs_rq, se);
-	check_spread(cfs_rq, se);
-	if (se != cfs_rq->curr)
-		__enqueue_entity(cfs_rq, se);
+	enqueue_entity_common(cfs_rq, se, flags);
 }
 
 static void __clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
@@ -959,6 +1054,28 @@ static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
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
+	if (!cfs_rq_throttled(gcfs_rq) && gcfs_rq->nr_running)
+		return 0;
+
+	__clear_buddies(cfs_rq, se);
+	account_entity_dequeue(cfs_rq, se);
+	cfs_rq->curr = NULL;
+	return 1;
+}
+
 static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 {
 	/*
@@ -970,6 +1087,8 @@ static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 
 	check_spread(cfs_rq, prev);
 	if (prev->on_rq) {
+		if (dequeue_throttled_entity(cfs_rq, prev))
+			return;
 		update_stats_wait_start(cfs_rq, prev);
 		/* Put 'current' back into the tree. */
 		__enqueue_entity(cfs_rq, prev);
@@ -1066,10 +1185,26 @@ static inline void hrtick_update(struct rq *rq)
 }
 #endif
 
+static int enqueue_group_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
+		 int flags)
+{
+	struct cfs_rq *gcfs_rq = group_cfs_rq(se);
+	int ret = 0;
+
+	if (cfs_rq_throttled(gcfs_rq)) {
+		ret = 1;
+		goto out;
+	}
+	enqueue_entity(cfs_rq, se, flags);
+out:
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
@@ -1085,11 +1220,15 @@ static void enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup)
 	for_each_sched_entity(se) {
 		if (se->on_rq)
 			break;
+
 		cfs_rq = cfs_rq_of(se);
-		enqueue_entity(cfs_rq, se, flags);
+		if (entity_is_task(se))
+			enqueue_entity(cfs_rq, se, flags);
+		else
+			if (enqueue_group_entity(cfs_rq, se, flags))
+				break;
 		flags = ENQUEUE_WAKEUP;
 	}
-
 	hrtick_update(rq);
 }
 
@@ -1109,6 +1248,13 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int sleep)
 		/* Don't dequeue parent if it has other entities besides us */
 		if (cfs_rq->load.weight)
 			break;
+
+		/*
+		 * If this cfs_rq is throttled, then it is already
+		 * dequeued.
+		 */
+		if (cfs_rq_throttled(cfs_rq))
+			break;
 		sleep = 1;
 	}
 
@@ -1907,9 +2053,10 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		u64 rem_load, moved_load;
 
 		/*
-		 * empty group
+		 * empty group or throttled group
 		 */
-		if (!busiest_cfs_rq->task_weight)
+		if (!busiest_cfs_rq->task_weight ||
+				cfs_rq_throttled(busiest_cfs_rq))
 			continue;
 
 		rem_load = (u64)rem_load_move * busiest_weight;
@@ -1958,6 +2105,12 @@ move_one_task_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 
 	for_each_leaf_cfs_rq(busiest, busy_cfs_rq) {
 		/*
+		 * Don't move task from a throttled cfs_rq
+		 */
+		if (cfs_rq_throttled(busy_cfs_rq))
+			continue;
+
+		/*
 		 * pass busy_cfs_rq argument into
 		 * load_balance_[start|next]_fair iterators
 		 */
