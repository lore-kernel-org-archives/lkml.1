Return-Path: <linux-kernel-owner+w=401wt.eu-S1751034Ab0AFFCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751034Ab0AFFCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 00:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795Ab0AFFCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 00:02:48 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56068 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787Ab0AFFCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 00:02:48 -0500
Date: Wed, 6 Jan 2010 10:32:26 +0530
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
Subject: Re: [RFC v5 PATCH 7/8] sched: CFS runtime borrowing
Message-ID: <20100106050226.GO27899@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20100105075703.GE27899@in.ibm.com> <20100105080346.GL27899@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105080346.GL27899@in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 01:33:46PM +0530, Bharata B Rao wrote:
> sched: CFS runtime borrowing
> 
>  static void enable_runtime(struct rq *rq)
>  {
>  	unsigned long flags;
>  
>  	raw_spin_lock_irqsave(&rq->lock, flags);
>  	enable_runtime_rt(rq);
> +#if defined(config_fair_group_sched) && defined(config_cfs_hard_limits)

Got the above config options wrong. Resending this patch again with correction.

Regards,
Bharata.

sched: CFS runtime borrowing

From: Bharata B Rao <bharata@linux.vnet.ibm.com>

Before throttling a group, try to borrow runtime from groups that have excess.

To start with, a group will get equal runtime on every cpu. If the group doesn't
have tasks on all cpus, it might get throttled on some cpus while it still has
runtime left on other cpus where it doesn't have any tasks to consume that
runtime. Hence there is a chance to borrow runtimes from such cpus/cfs_rqs to
cpus/cfs_rqs where it is required.

CHECK: RT seems to be handling runtime initialization/reclaim during hotplug
from multiple places (migration_call, update_runtime). Need to check if CFS
also needs to do the same.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched.c      |   13 +++++++++++++
 kernel/sched_fair.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index c4ab583..857e567 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1960,6 +1960,8 @@ void __disable_runtime(struct rq *rq, struct sched_bandwidth *sched_b,
 
 		if (rt)
 			iter = &(sched_rt_period_rt_rq(sched_b, i)->rq_bandwidth);
+		else
+			iter = &(sched_cfs_period_cfs_rq(sched_b, i)->rq_bandwidth);
 		/*
 		 * Can't reclaim from ourselves or disabled runqueues.
 		 */
@@ -1999,12 +2001,16 @@ balanced:
 }
 
 void disable_runtime_rt(struct rq *rq);
+void disable_runtime_cfs(struct rq *rq);
 static void disable_runtime(struct rq *rq)
 {
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&rq->lock, flags);
 	disable_runtime_rt(rq);
+#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_CFS_HARD_LIMITS)
+	disable_runtime_cfs(rq);
+#endif
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
@@ -2021,12 +2027,16 @@ void __enable_runtime(struct sched_bandwidth *sched_b,
 }
 
 void enable_runtime_rt(struct rq *rq);
+void enable_runtime_cfs(struct rq *rq);
 static void enable_runtime(struct rq *rq)
 {
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&rq->lock, flags);
 	enable_runtime_rt(rq);
+#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_CFS_HARD_LIMITS)
+	enable_runtime_cfs(rq);
+#endif
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
@@ -2050,6 +2060,9 @@ static void do_balance_runtime(struct rq_bandwidth *rq_b,
 
 		if (rt)
 			iter = &(sched_rt_period_rt_rq(sched_b, i)->rq_bandwidth);
+		else
+			iter = &(sched_cfs_period_cfs_rq(sched_b, i)->rq_bandwidth);
+
 		if (iter == rq_b)
 			continue;
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 16ed209..dcd093b 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -241,6 +241,41 @@ static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
 	return cfs_rq->rq_bandwidth.throttled;
 }
 
+#ifdef CONFIG_SMP
+/*
+ * Ensure this RQ takes back all the runtime it lend to its neighbours.
+ */
+void disable_runtime_cfs(struct rq *rq)
+{
+	struct cfs_rq *cfs_rq;
+
+	if (unlikely(!scheduler_running))
+		return;
+
+	for_each_leaf_cfs_rq(rq, cfs_rq) {
+		struct sched_bandwidth *sched_b = sched_cfs_bandwidth(cfs_rq);
+		__disable_runtime(rq, sched_b, &cfs_rq->rq_bandwidth, 0);
+	}
+}
+
+void enable_runtime_cfs(struct rq *rq)
+{
+	struct cfs_rq *cfs_rq;
+
+	if (unlikely(!scheduler_running))
+		return;
+
+	/*
+	 * Reset each runqueue's bandwidth settings
+	 */
+	for_each_leaf_cfs_rq(rq, cfs_rq) {
+		struct sched_bandwidth *sched_b = sched_cfs_bandwidth(cfs_rq);
+		__enable_runtime(sched_b, &cfs_rq->rq_bandwidth);
+	}
+}
+
+#endif /* CONFIG_SMP */
+
 /*
  * Check if group entity exceeded its runtime. If so, mark the cfs_rq as
  * throttled mark the current task for reschedling.
@@ -260,6 +295,10 @@ static void sched_cfs_runtime_exceeded(struct sched_entity *se,
 	if (cfs_rq_throttled(cfs_rq))
 		return;
 
+	if (cfs_rq->rq_bandwidth.time > cfs_rq->rq_bandwidth.runtime)
+		balance_runtime(&cfs_rq->rq_bandwidth,
+					sched_cfs_bandwidth(cfs_rq), 0);
+
 	if (cfs_rq->rq_bandwidth.time > cfs_rq->rq_bandwidth.runtime) {
 		cfs_rq->rq_bandwidth.throttled = 1;
 		update_stats_throttle_start(cfs_rq, se);
@@ -313,6 +352,9 @@ static int do_sched_cfs_period_timer(struct sched_bandwidth *cfs_b, int overrun)
 			u64 runtime;
 
 			raw_spin_lock(&cfs_rq->rq_bandwidth.runtime_lock);
+			if (cfs_rq_throttled(cfs_rq))
+				balance_runtime(&cfs_rq->rq_bandwidth,
+					sched_cfs_bandwidth(cfs_rq), 0);
 			runtime = cfs_rq->rq_bandwidth.runtime;
 			cfs_rq->rq_bandwidth.time -= min(cfs_rq->rq_bandwidth.time, overrun*runtime);
 			if (cfs_rq_throttled(cfs_rq) &&
