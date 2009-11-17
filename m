Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbZKQOgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbZKQOgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 09:36:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbZKQOgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 09:36:04 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46030 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907AbZKQOgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 09:36:01 -0500
Date: Tue, 17 Nov 2009 20:05:57 +0530
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
Subject: [RFC v4 PATCH 4/7] sched: Unthrottle the throttled tasks
Message-ID: <20091117143557.GO17335@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20091117143306.GK17335@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117143306.GK17335@in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: Unthrottle the throttled tasks.

From: Bharata B Rao <bharata@linux.vnet.ibm.com>

Refresh runtimes when group's period expires. Unthrottle any
throttled groups at that time. Refreshing runtimes is driven through
a periodic timer.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched.c      |    3 +++
 kernel/sched_fair.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 53 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 19069d3..dd56c72 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1886,6 +1886,8 @@ static inline u64 global_cfs_runtime(void)
 	return RUNTIME_INF;
 }
 
+void do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b);
+
 static inline void cfs_rq_runtime_lock(struct cfs_rq *cfs_rq)
 {
 	spin_lock(&cfs_rq->cfs_runtime_lock);
@@ -1905,6 +1907,7 @@ static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
 	struct cfs_bandwidth *cfs_b =
 		container_of(timer, struct cfs_bandwidth, cfs_period_timer);
 
+	do_sched_cfs_period_timer(cfs_b);
 	hrtimer_add_expires_ns(timer, ktime_to_ns(cfs_b->cfs_period));
 	return HRTIMER_RESTART;
 }
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index ea7468c..3d0f006 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -191,6 +191,13 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 
 #ifdef CONFIG_CFS_HARD_LIMITS
 
+static inline
+struct cfs_rq *sched_cfs_period_cfs_rq(struct cfs_bandwidth *cfs_b, int cpu)
+{
+	return container_of(cfs_b, struct task_group,
+			cfs_bandwidth)->cfs_rq[cpu];
+}
+
 static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
 {
 	return cfs_rq->cfs_throttled;
@@ -227,6 +234,49 @@ static inline void update_curr_group(struct sched_entity *curr,
 	sched_cfs_runtime_exceeded(curr, tsk_curr, delta_exec);
 }
 
+static void enqueue_entity_locked(struct cfs_rq *cfs_rq,
+		struct sched_entity *se, int wakeup);
+
+static void enqueue_throttled_entity(struct rq *rq, struct sched_entity *se)
+{
+	for_each_sched_entity(se) {
+		struct cfs_rq *gcfs_rq = group_cfs_rq(se);
+
+		if (se->on_rq || cfs_rq_throttled(gcfs_rq) ||
+				!gcfs_rq->nr_running)
+			break;
+		enqueue_entity_locked(cfs_rq_of(se), se, 0);
+	}
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
+	unsigned long flags;
+
+	for_each_cpu(i, span) {
+		struct rq *rq = cpu_rq(i);
+		struct cfs_rq *cfs_rq = sched_cfs_period_cfs_rq(cfs_b, i);
+		struct sched_entity *se = cfs_rq->tg->se[i];
+
+		spin_lock_irqsave(&rq->lock, flags);
+		cfs_rq_runtime_lock(cfs_rq);
+		cfs_rq->cfs_time = 0;
+		if (cfs_rq_throttled(cfs_rq)) {
+			cfs_rq->cfs_throttled = 0;
+			enqueue_throttled_entity(rq, se);
+		}
+		cfs_rq_runtime_unlock(cfs_rq);
+		spin_unlock_irqrestore(&rq->lock, flags);
+	}
+}
+
 #else
 
 static inline void update_curr_group(struct sched_entity *curr,
@@ -310,7 +360,6 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
-
 /**************************************************************
  * Scheduling class tree data structure manipulation methods:
  */
