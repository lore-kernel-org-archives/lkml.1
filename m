Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400Ab0AEICo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab0AEICo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 03:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009Ab0AEICm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 03:02:42 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:38570 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab0AEICl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 03:02:41 -0500
Date: Tue, 5 Jan 2010 13:31:59 +0530
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
Subject: [RFC v5 PATCH 5/8] sched: Unthrottle the throttled tasks
Message-ID: <20100105080159.GJ27899@in.ibm.com>
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

sched: Unthrottle the throttled tasks.

From: Bharata B Rao <bharata@linux.vnet.ibm.com>

Refresh runtimes when group's period expires. Unthrottle any
throttled groups at that time. Refreshing runtimes is driven through
a periodic timer.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched.c      |   27 ++++++++++++++-----
 kernel/sched_fair.c |   71 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 89 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index c91158d..c4ab583 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -150,14 +150,7 @@ struct sched_bandwidth {
 static struct sched_bandwidth def_rt_bandwidth;
 
 static int do_sched_rt_period_timer(struct sched_bandwidth *sched_b, int overrun);
-
-/*
- * Nothing much to do now. Will be populated in subsequent hard limit patches.
- */
-static int do_sched_cfs_period_timer(struct sched_bandwidth *sched_b, int overrun)
-{
-	return 0;
-}
+static int do_sched_cfs_period_timer(struct sched_bandwidth *sched_b, int overrun);
 
 static enum hrtimer_restart sched_period_timer(struct hrtimer *timer, int rt)
 {
@@ -1911,6 +1904,24 @@ struct rt_rq *sched_rt_period_rt_rq(struct sched_bandwidth *rt_b, int cpu)
 
 #endif
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static inline
+struct cfs_rq *sched_cfs_period_cfs_rq(struct sched_bandwidth *cfs_b, int cpu)
+{
+	return container_of(cfs_b, struct task_group,
+			cfs_bandwidth)->cfs_rq[cpu];
+}
+
+#else
+
+static inline
+struct cfs_rq *sched_cfs_period_cfs_rq(struct sched_bandwidth *cfs_b, int cpu)
+{
+	return &cpu_rq(cpu)->cfs;
+}
+
+#endif
+
 #ifdef CONFIG_SMP
 
 void __disable_runtime(struct rq *rq, struct sched_bandwidth *sched_b,
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index d1ee88e..f791332 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -255,6 +255,66 @@ static inline void update_curr_group(struct sched_entity *curr,
 	sched_cfs_runtime_exceeded(curr, tsk_curr, delta_exec);
 }
 
+static void enqueue_entity(struct cfs_rq *cfs_rq,
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
+		enqueue_entity(cfs_rq_of(se), se, 0);
+	}
+}
+
+/*
+ * Refresh runtimes of all cfs_rqs in this group, i,e.,
+ * refresh runtimes of the representative cfs_rq of this
+ * tg on all cpus. Enqueue any throttled entity back.
+ */
+static int do_sched_cfs_period_timer(struct sched_bandwidth *cfs_b, int overrun)
+{
+	int i, idle = 1;
+	const struct cpumask *span;
+
+	if (cfs_b->runtime == RUNTIME_INF)
+		return 1;
+
+	span = sched_bw_period_mask();
+	for_each_cpu(i, span) {
+		int enqueue = 0;
+		struct rq *rq = cpu_rq(i);
+		struct cfs_rq *cfs_rq = sched_cfs_period_cfs_rq(cfs_b, i);
+		struct sched_entity *se = cfs_rq->tg->se[i];
+
+		raw_spin_lock(&rq->lock);
+		if (cfs_rq->rq_bandwidth.time) {
+			u64 runtime;
+
+			raw_spin_lock(&cfs_rq->rq_bandwidth.runtime_lock);
+			runtime = cfs_rq->rq_bandwidth.runtime;
+			cfs_rq->rq_bandwidth.time -= min(cfs_rq->rq_bandwidth.time, overrun*runtime);
+			if (cfs_rq_throttled(cfs_rq) &&
+					cfs_rq->rq_bandwidth.time < runtime) {
+				cfs_rq->rq_bandwidth.throttled = 0;
+				enqueue = 1;
+			}
+			if (cfs_rq->rq_bandwidth.time || cfs_rq->nr_running)
+				idle = 0;
+			raw_spin_unlock(&cfs_rq->rq_bandwidth.runtime_lock);
+		} else if (cfs_rq->nr_running)
+			idle = 0;
+
+		if (enqueue)
+			enqueue_throttled_entity(rq, se);
+		raw_spin_unlock(&rq->lock);
+	}
+	return idle;
+}
+
 #else
 
 static inline void update_curr_group(struct sched_entity *curr,
@@ -268,6 +328,11 @@ static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
 	return 0;
 }
 
+static int do_sched_cfs_period_timer(struct sched_bandwidth *cfs_b, int overrun)
+{
+	return 0;
+}
+
 #endif /* CONFIG_CFS_HARD_LIMITS */
 
 #else	/* CONFIG_FAIR_GROUP_SCHED */
@@ -346,8 +411,12 @@ static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
 	return 0;
 }
 
-#endif	/* CONFIG_FAIR_GROUP_SCHED */
+static int do_sched_cfs_period_timer(struct sched_bandwidth *cfs_b, int overrun)
+{
+	return 0;
+}
 
+#endif	/* CONFIG_FAIR_GROUP_SCHED */
 
 /**************************************************************
  * Scheduling class tree data structure manipulation methods:
