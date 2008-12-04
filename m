Return-Path: <linux-kernel-owner+w=401wt.eu-S1758310AbYLDPl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310AbYLDPl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 10:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756756AbYLDPkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 10:40:11 -0500
Received: from 68-112-229-48.dhcp.oxfr.ma.charter.com ([68.112.229.48]:53204
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755173AbYLDPkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 10:40:08 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH v3 2/4] sched: track the next-highest priority on each runqueue
To: mingo@elte.hu
Cc: peterz@infradead.org, rostedt@goodmis.org, ghaskins@novell.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Date: Thu, 04 Dec 2008 10:43:46 -0500
Message-ID: <20081204154346.21712.52654.stgit@dev.haskins.net>
In-Reply-To: <20081204154100.21712.88806.stgit@dev.haskins.net>
References: <20081204154100.21712.88806.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will use this later in the series to reduce the amount of rq-lock
contention during a pull operation

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c    |    8 ++++-
 kernel/sched_rt.c |   81 ++++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 67 insertions(+), 22 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 6237b9b..24b11eb 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -463,7 +463,10 @@ struct rt_rq {
 	struct rt_prio_array active;
 	unsigned long rt_nr_running;
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
-	int highest_prio; /* highest queued rt task prio */
+	struct {
+		int curr; /* highest queued rt task prio */
+		int next; /* next highest */
+	} highest_prio;
 #endif
 #ifdef CONFIG_SMP
 	unsigned long rt_nr_migratory;
@@ -8073,7 +8076,8 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 	__set_bit(MAX_RT_PRIO, array->bitmap);
 
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
-	rt_rq->highest_prio = MAX_RT_PRIO;
+	rt_rq->highest_prio.curr = MAX_RT_PRIO;
+	rt_rq->highest_prio.next = MAX_RT_PRIO;
 #endif
 #ifdef CONFIG_SMP
 	rt_rq->rt_nr_migratory = 0;
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index fb1d4d7..7dad033 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -108,7 +108,7 @@ static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 	if (rt_rq->rt_nr_running) {
 		if (rt_se && !on_rt_rq(rt_se))
 			enqueue_rt_entity(rt_se);
-		if (rt_rq->highest_prio < curr->prio)
+		if (rt_rq->highest_prio.curr < curr->prio)
 			resched_task(curr);
 	}
 }
@@ -473,7 +473,7 @@ static inline int rt_se_prio(struct sched_rt_entity *rt_se)
 	struct rt_rq *rt_rq = group_rt_rq(rt_se);
 
 	if (rt_rq)
-		return rt_rq->highest_prio;
+		return rt_rq->highest_prio.curr;
 #endif
 
 	return rt_task_of(rt_se)->prio;
@@ -547,6 +547,21 @@ static void update_curr_rt(struct rq *rq)
 	}
 }
 
+#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
+
+static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu);
+
+static inline int next_prio(struct rq *rq)
+{
+	struct task_struct *next = pick_next_highest_task_rt(rq, rq->cpu);
+
+	if (next && rt_prio(next->prio))
+		return next->prio;
+	else
+		return MAX_RT_PRIO;
+}
+#endif
+
 static inline
 void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
@@ -560,14 +575,32 @@ void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 	WARN_ON(!rt_prio(prio));
 	rt_rq->rt_nr_running++;
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
-	if (prio < rt_rq->highest_prio) {
+	if (prio < rt_rq->highest_prio.curr) {
 
-		rt_rq->highest_prio = prio;
+		/*
+		 * If the new task is higher in priority than anything on the
+		 * run-queue, we have a new high that must be published to
+		 * the world.  We also know that the previous high becomes
+		 * our next-highest.
+		 */
+		rt_rq->highest_prio.next = rt_rq->highest_prio.curr;
+		rt_rq->highest_prio.curr = prio;
 #ifdef CONFIG_SMP
 		if (rq->online)
 			cpupri_set(&rq->rd->cpupri, rq->cpu, prio);
 #endif
-	}
+	} else if (prio == rt_rq->highest_prio.curr)
+		/*
+		 * If the next task is equal in priority to the highest on
+		 * the run-queue, then we implicitly know that the next highest
+		 * task cannot be any lower than current
+		 */
+		rt_rq->highest_prio.next = prio;
+	else if (prio < rt_rq->highest_prio.next)
+		/*
+		 * Otherwise, we need to recompute next-highest
+		 */
+		rt_rq->highest_prio.next = next_prio(rq);
 #endif
 #ifdef CONFIG_SMP
 	if (rt_se->nr_cpus_allowed > 1)
@@ -591,7 +624,7 @@ void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
 #ifdef CONFIG_SMP
 	struct rq *rq = rq_of_rt_rq(rt_rq);
-	int highest_prio = rt_rq->highest_prio;
+	int highest_prio = rt_rq->highest_prio.curr;
 #endif
 
 	WARN_ON(!rt_prio(rt_se_prio(rt_se)));
@@ -599,24 +632,32 @@ void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 	rt_rq->rt_nr_running--;
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	if (rt_rq->rt_nr_running) {
-		struct rt_prio_array *array;
+		int prio = rt_se_prio(rt_se);
+
+		WARN_ON(prio < rt_rq->highest_prio.curr);
 
-		WARN_ON(rt_se_prio(rt_se) < rt_rq->highest_prio);
-		if (rt_se_prio(rt_se) == rt_rq->highest_prio) {
-			/* recalculate */
-			array = &rt_rq->active;
-			rt_rq->highest_prio =
+		/*
+		 * This may have been our highest or next-highest priority
+		 * task and therefore we may have some recomputation to do
+		 */
+		if (prio == rt_rq->highest_prio.curr) {
+			struct rt_prio_array *array = &rt_rq->active;
+
+			rt_rq->highest_prio.curr =
 				sched_find_first_bit(array->bitmap);
-		} /* otherwise leave rq->highest prio alone */
+		}
+
+		if (prio <= rt_rq->highest_prio.next)
+			rt_rq->highest_prio.next = next_prio(rq);
 	} else
-		rt_rq->highest_prio = MAX_RT_PRIO;
+		rt_rq->highest_prio.curr = MAX_RT_PRIO;
 #endif
 #ifdef CONFIG_SMP
 	if (rt_se->nr_cpus_allowed > 1)
 		rq->rt.rt_nr_migratory--;
 
-	if (rq->online && rt_rq->highest_prio != highest_prio)
-		cpupri_set(&rq->rd->cpupri, rq->cpu, rt_rq->highest_prio);
+	if (rq->online && rt_rq->highest_prio.curr != highest_prio)
+		cpupri_set(&rq->rd->cpupri, rq->cpu, rt_rq->highest_prio.curr);
 
 	update_rt_migration(rq);
 #endif /* CONFIG_SMP */
@@ -1066,7 +1107,7 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
 		}
 
 		/* If this rq is still suitable use it. */
-		if (lowest_rq->rt.highest_prio > task->prio)
+		if (lowest_rq->rt.highest_prio.curr > task->prio)
 			break;
 
 		/* try again */
@@ -1254,7 +1295,7 @@ static int pull_rt_task(struct rq *this_rq)
 static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
 {
 	/* Try to pull RT tasks here if we lower this rq's prio */
-	if (unlikely(rt_task(prev)) && rq->rt.highest_prio > prev->prio)
+	if (unlikely(rt_task(prev)) && rq->rt.highest_prio.curr > prev->prio)
 		pull_rt_task(rq);
 }
 
@@ -1340,7 +1381,7 @@ static void rq_online_rt(struct rq *rq)
 
 	__enable_runtime(rq);
 
-	cpupri_set(&rq->rd->cpupri, rq->cpu, rq->rt.highest_prio);
+	cpupri_set(&rq->rd->cpupri, rq->cpu, rq->rt.highest_prio.curr);
 }
 
 /* Assumes rq->lock is held */
@@ -1431,7 +1472,7 @@ static void prio_changed_rt(struct rq *rq, struct task_struct *p,
 		 * can release the rq lock and p could migrate.
 		 * Only reschedule if p is still on the same runqueue.
 		 */
-		if (p->prio > rq->rt.highest_prio && rq->curr == p)
+		if (p->prio > rq->rt.highest_prio.curr && rq->curr == p)
 			resched_task(p);
 #else
 		/* For UP simply resched on drop of prio */

