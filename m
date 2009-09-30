Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbZI3Mzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbZI3Mzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbZI3Mzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:55:54 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:33820 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbZI3Mzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:55:54 -0400
Date: Wed, 30 Sep 2009 18:24:18 +0530
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
Subject: [RFC v2 PATCH 6/8] sched: Add throttle time statistics to
	/proc/sched_debug
Message-ID: <20090930125418.GG19951@in.ibm.com>
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

sched: Add throttle time statistics to /proc/sched_debug

From: Bharata B Rao <bharata@linux.vnet.ibm.com>

With hard limits, provide stats about throttle time, throttle count
and max throttle time for group sched entities in /proc/sched_debug
Throttle stats are collected only for group entities.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 include/linux/sched.h |    6 ++++++
 kernel/sched_debug.c  |   17 ++++++++++++++++-
 kernel/sched_fair.c   |   20 ++++++++++++++++++++
 3 files changed, 42 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 77ace43..8c83a39 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1137,6 +1137,12 @@ struct sched_entity {
 	u64			nr_wakeups_affine_attempts;
 	u64			nr_wakeups_passive;
 	u64			nr_wakeups_idle;
+#ifdef CONFIG_CFS_HARD_LIMITS
+	u64			throttle_start;
+	u64			throttle_max;
+	u64			throttle_count;
+	u64			throttle_sum;
+#endif
 #endif
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 8ce525f..b15712d 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -80,6 +80,11 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu,
 	PN(se->wait_max);
 	PN(se->wait_sum);
 	P(se->wait_count);
+#ifdef CONFIG_CFS_HARD_LIMITS
+	PN(se->throttle_max);
+	PN(se->throttle_sum);
+	P(se->throttle_count);
+#endif
 #endif
 	P(se->load.weight);
 #undef PN
@@ -216,6 +221,16 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 #endif
 	SEQ_printf(m, "  .%-30s: %ld\n", "nr_tasks_running",
 			cfs_rq->nr_tasks_running);
+#ifdef CONFIG_CFS_HARD_LIMITS
+	spin_lock_irqsave(&rq->lock, flags);
+	SEQ_printf(m, "  .%-30s: %d\n", "cfs_throttled",
+			cfs_rq->cfs_throttled);
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "cfs_time",
+			SPLIT_NS(cfs_rq->cfs_time));
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "cfs_runtime",
+			SPLIT_NS(cfs_rq->cfs_runtime));
+	spin_unlock_irqrestore(&rq->lock, flags);
+#endif
 	print_cfs_group_stats(m, cpu, cfs_rq->tg);
 #endif
 }
@@ -312,7 +327,7 @@ static int sched_debug_show(struct seq_file *m, void *v)
 	u64 now = ktime_to_ns(ktime_get());
 	int cpu;
 
-	SEQ_printf(m, "Sched Debug Version: v0.09, %s %.*s\n",
+	SEQ_printf(m, "Sched Debug Version: v0.10, %s %.*s\n",
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 8c8b602..f4dec63 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -188,6 +188,23 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 
 #ifdef CONFIG_CFS_HARD_LIMITS
 
+static inline void update_stats_throttle_start(struct cfs_rq *cfs_rq,
+			struct sched_entity *se)
+{
+	schedstat_set(se->throttle_start, rq_of(cfs_rq)->clock);
+}
+
+static inline void update_stats_throttle_end(struct cfs_rq *cfs_rq,
+			struct sched_entity *se)
+{
+	schedstat_set(se->throttle_max, max(se->throttle_max,
+			rq_of(cfs_rq)->clock - se->throttle_start));
+	schedstat_set(se->throttle_count, se->throttle_count + 1);
+	schedstat_set(se->throttle_sum, se->throttle_sum +
+			rq_of(cfs_rq)->clock - se->throttle_start);
+	schedstat_set(se->throttle_start, 0);
+}
+
 static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
 {
 	return cfs_rq->cfs_throttled;
@@ -217,6 +234,7 @@ static void sched_cfs_runtime_exceeded(struct sched_entity *se,
 
 	if (cfs_rq->cfs_time > cfs_rq->cfs_runtime) {
 		cfs_rq->cfs_throttled = 1;
+		update_stats_throttle_start(cfs_rq, se);
 		resched_task(tsk_curr);
 	}
 }
@@ -315,6 +333,8 @@ void do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b)
 		rq_runtime_lock(rq);
 		cfs_rq->cfs_time = 0;
 		if (cfs_rq_throttled(cfs_rq)) {
+			update_rq_clock(rq);
+			update_stats_throttle_end(cfs_rq, se);
 			cfs_rq->cfs_throttled = 0;
 			enqueue_throttled_entity(rq, se);
 		}
