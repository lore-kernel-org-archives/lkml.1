Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbZKIJLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbZKIJLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbZKIJLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:11:54 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53266 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577AbZKIJLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:11:53 -0500
Date: Mon, 9 Nov 2009 14:41:54 +0530
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
Subject: [RFC v3 PATCH 5/7] sched: Add throttle time statistics to
	/proc/sched_debug
Message-ID: <20091109091154.GI23472@in.ibm.com>
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
index 75e6e60..b7f238c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1183,6 +1183,12 @@ struct sched_entity {
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
index efb8440..a8f24fb 100644
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
@@ -214,6 +219,16 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 #ifdef CONFIG_SMP
 	SEQ_printf(m, "  .%-30s: %lu\n", "shares", cfs_rq->shares);
 #endif
+#ifdef CONFIG_CFS_HARD_LIMITS
+	spin_lock_irqsave(&rq->lock, flags);
+	SEQ_printf(m, "  .%-30s: %d\n", "cfs_throttled",
+			cfs_rq->cfs_throttled);
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "cfs_time",
+			SPLIT_NS(cfs_rq->cfs_time));
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "cfs_runtime",
+			SPLIT_NS(cfs_rq->cfs_runtime));
+	spin_unlock_irqrestore(&rq->lock, flags);
+#endif /* CONFIG_CFS_HARD_LIMITS */
 	print_cfs_group_stats(m, cpu, cfs_rq->tg);
 #endif
 }
@@ -310,7 +325,7 @@ static int sched_debug_show(struct seq_file *m, void *v)
 	u64 now = ktime_to_ns(ktime_get());
 	int cpu;
 
-	SEQ_printf(m, "Sched Debug Version: v0.09, %s %.*s\n",
+	SEQ_printf(m, "Sched Debug Version: v0.10, %s %.*s\n",
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 557d30d..828d7e7 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -191,6 +191,23 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 
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
@@ -257,6 +275,8 @@ void do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b)
 		cfs_rq_runtime_lock(cfs_rq);
 		cfs_rq->cfs_time = 0;
 		if (cfs_rq_throttled(cfs_rq)) {
+			update_rq_clock(rq);
+			update_stats_throttle_end(cfs_rq, se);
 			cfs_rq->cfs_throttled = 0;
 			enqueue_throttled_entity(rq, se);
 		}
