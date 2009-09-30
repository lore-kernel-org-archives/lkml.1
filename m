Return-Path: <linux-kernel-owner+w=401wt.eu-S1752068AbZI3MzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbZI3MzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZI3MzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:55:17 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:42948 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbZI3MzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:55:15 -0400
Date: Wed, 30 Sep 2009 18:23:36 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: [RFC v2 PATCH 5/8] sched: Unthrottle the throttled tasks
Message-ID: <20090930125336.GF19951@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090930124919.GA19951@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930124919.GA19951@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: Unthrottle the throttled tasks.

From: Bharata B Rao <bharata@linux.vnet.ibm.com>

Refresh runtimes when group's bandwidth period expires. Unthrottle any
throttled groups at that time. Refreshing runtimes is driven through
a periodic timer.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched.c      |   15 ++++++++-
 kernel/sched_fair.c |   81 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 94 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 04c505f..ec302ac 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1820,6 +1820,7 @@ static inline u64 global_cfs_runtime(void)
 }
 
 int task_group_throttled(struct task_group *tg, int cpu);
+void do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b);
 
 static inline int cfs_bandwidth_enabled(struct task_group *tg)
 {
@@ -1845,6 +1846,7 @@ static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
 	struct cfs_bandwidth *cfs_b =
 		container_of(timer, struct cfs_bandwidth, cfs_period_timer);
 
+	do_sched_cfs_period_timer(cfs_b);
 	hrtimer_add_expires_ns(timer, ktime_to_ns(cfs_b->cfs_period));
 	return HRTIMER_RESTART;
 }
@@ -10588,15 +10590,24 @@ long tg_get_cfs_period(struct task_group *tg)
 
 int tg_set_hard_limit_enabled(struct task_group *tg, u64 val)
 {
-	spin_lock_irq(&tg->cfs_bandwidth.cfs_runtime_lock);
+	local_irq_disable();
+	spin_lock(&tg->cfs_bandwidth.cfs_runtime_lock);
 	if (val > 0) {
 		tg->hard_limit_enabled = 1;
 		start_cfs_bandwidth(tg);
+		spin_unlock(&tg->cfs_bandwidth.cfs_runtime_lock);
 	} else {
 		destroy_cfs_bandwidth(tg);
 		tg->hard_limit_enabled = 0;
+		spin_unlock(&tg->cfs_bandwidth.cfs_runtime_lock);
+		/*
+		 * Hard limiting is being disabled for this group.
+		 * Refresh runtimes and put the throttled entities
+		 * of the group back onto runqueue.
+		 */
+		do_sched_cfs_period_timer(&tg->cfs_bandwidth);
 	}
-	spin_unlock_irq(&tg->cfs_bandwidth.cfs_runtime_lock);
+	local_irq_enable();
 	return 0;
 }
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index f98c1c8..8c8b602 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -249,6 +249,80 @@ int task_group_throttled(struct task_group *tg, int cpu)
 	return 0;
 }
 
+static void enqueue_entity_locked(struct cfs_rq *cfs_rq,
+		struct sched_entity *se, int wakeup);
+static void add_cfs_rq_tasks_running(struct sched_entity *se,
+		unsigned long count);
+static void sub_cfs_rq_tasks_running(struct sched_entity *se,
+		unsigned long count);
+
+static void enqueue_throttled_entity(struct rq *rq, struct sched_entity *se)
+{
+	unsigned long nr_tasks = 0;
+	struct sched_entity *se_tmp = se;
+	int throttled = 0;
+
+	for_each_sched_entity(se) {
+		if (se->on_rq)
+			break;
+
+		if (entity_throttled(se)) {
+			throttled = 1;
+			break;
+		}
+
+		enqueue_entity_locked(cfs_rq_of(se), se, 0);
+		nr_tasks += group_cfs_rq(se)->nr_tasks_running;
+	}
+
+	if (!nr_tasks)
+		return;
+
+	/*
+	 * Add the number of tasks this entity has to
+	 * all of its parent entities.
+	 */
+	add_cfs_rq_tasks_running(se_tmp, nr_tasks);
+
+	/*
+	 * Add the number of tasks this entity has to
+	 * this cpu's rq only if the entity got enqueued all the
+	 * way up without any throttled entity in the hierarchy.
+	 */
+	if (!throttled)
+		rq->nr_running += nr_tasks;
+}
+
+/*
+ * Refresh runtimes of all cfs_rqs in this group, i,e.,
+ * refresh runtimes of the representative cfs_rq of this
+ * tg on all cpus. Enqueue any throttled entity back.
+ */
+void do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b)
+{
+	int i;
+	const struct cpumask *span = sched_bw_period_mask();
+	struct task_group *tg = container_of(cfs_b, struct task_group,
+					cfs_bandwidth);
+	unsigned long flags;
+
+	for_each_cpu(i, span) {
+		struct rq *rq = cpu_rq(i);
+		struct cfs_rq *cfs_rq = tg->cfs_rq[i];
+		struct sched_entity *se = tg->se[i];
+
+		spin_lock_irqsave(&rq->lock, flags);
+		rq_runtime_lock(rq);
+		cfs_rq->cfs_time = 0;
+		if (cfs_rq_throttled(cfs_rq)) {
+			cfs_rq->cfs_throttled = 0;
+			enqueue_throttled_entity(rq, se);
+		}
+		rq_runtime_unlock(rq);
+		spin_unlock_irqrestore(&rq->lock, flags);
+	}
+}
+
 #else
 
 static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
@@ -348,6 +422,13 @@ static void add_cfs_rq_tasks_running(struct sched_entity *se,
 	struct cfs_rq *cfs_rq;
 
 	for_each_sched_entity(se) {
+		/*
+		 * If any entity in the hierarchy is throttled, don't
+		 * propogate the tasks count up since this entity isn't
+		 * on rq yet.
+		 */
+		if (entity_throttled(se))
+			break;
 		cfs_rq = cfs_rq_of(se);
 		cfs_rq->nr_tasks_running += count;
 	}
