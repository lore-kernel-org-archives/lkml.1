Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbZHYJvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbZHYJvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZHYJvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:51:12 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:38475 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbZHYJvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:51:11 -0400
Date: Tue, 25 Aug 2009 15:21:18 +0530
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
Subject: [RFC v1 PATCH 5/7] sched: Unthrottle the throttled tasks
Message-ID: <20090825095118.GU3663@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090825094729.GP3663@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825094729.GP3663@in.ibm.com>
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
 kernel/sched.c      |    8 +++++
 kernel/sched_fair.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 87 insertions(+)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1815,6 +1815,7 @@ static inline u64 global_cfs_runtime(voi
 }
 
 int task_group_throttled(struct task_group *tg, int cpu);
+void do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b);
 
 static inline int cfs_bandwidth_enabled(struct task_group *tg)
 {
@@ -1830,6 +1831,7 @@ static enum hrtimer_restart sched_cfs_pe
 	struct cfs_bandwidth *cfs_b =
 		container_of(timer, struct cfs_bandwidth, cfs_period_timer);
 
+	do_sched_cfs_period_timer(cfs_b);
 	hrtimer_add_expires_ns(timer, ktime_to_ns(cfs_b->cfs_period));
 	return HRTIMER_RESTART;
 }
@@ -10536,6 +10538,12 @@ int tg_set_hard_limit_enabled(struct tas
 		start_cfs_bandwidth(tg);
 	} else {
 		destroy_cfs_bandwidth(tg);
+		/*
+		 * Hard limiting is being disabled for this group.
+		 * Refresh runtimes and put the throttled entities
+		 * of the group back onto runqueue.
+		 */
+		do_sched_cfs_period_timer(&tg->cfs_bandwidth);
 		tg->hard_limit_enabled = 0;
 	}
 	spin_unlock_irq(&tg->cfs_bandwidth.cfs_runtime_lock);
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -249,6 +249,78 @@ int task_group_throttled(struct task_gro
 	return 0;
 }
 
+static void
+enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup);
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
+		enqueue_entity(cfs_rq_of(se), se, 0);
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
+		cfs_rq->cfs_time = 0;
+		if (cfs_rq_throttled(cfs_rq)) {
+			cfs_rq->cfs_throttled = 0;
+			enqueue_throttled_entity(rq, se);
+		}
+		spin_unlock_irqrestore(&rq->lock, flags);
+	}
+}
+
 #else
 
 static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
@@ -343,6 +415,13 @@ static void add_cfs_rq_tasks_running(str
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
