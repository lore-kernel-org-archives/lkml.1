Return-Path: <linux-kernel-owner+w=401wt.eu-S1754437Ab0AEID2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab0AEID2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 03:03:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194Ab0AEID1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 03:03:27 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:39309 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab0AEID0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 03:03:26 -0500
Date: Tue, 5 Jan 2010 13:32:53 +0530
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
Subject: [RFC v5 PATCH 6/8] sched: Add throttle time statistics to
	/proc/sched_debug
Message-ID: <20100105080253.GK27899@in.ibm.com>
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
index f2f842d..025a594 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1191,6 +1191,12 @@ struct sched_entity {
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
index 1b67698..c833aa2 100644
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
+	raw_spin_lock_irqsave(&rq->lock, flags);
+	SEQ_printf(m, "  .%-30s: %d\n", "rq_bandwidth.throttled",
+			cfs_rq->rq_bandwidth.throttled);
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "rq_bandwidth.time",
+			SPLIT_NS(cfs_rq->rq_bandwidth.time));
+	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "rq_bandwidth.runtime",
+			SPLIT_NS(cfs_rq->rq_bandwidth.runtime));
+	raw_spin_unlock_irqrestore(&rq->lock, flags);
+#endif /* CONFIG_CFS_HARD_LIMITS */
 	print_cfs_group_stats(m, cpu, cfs_rq->tg);
 #endif
 }
@@ -320,7 +335,7 @@ static int sched_debug_show(struct seq_file *m, void *v)
 	u64 now = ktime_to_ns(ktime_get());
 	int cpu;
 
-	SEQ_printf(m, "Sched Debug Version: v0.09, %s %.*s\n",
+	SEQ_printf(m, "Sched Debug Version: v0.10, %s %.*s\n",
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index f791332..16ed209 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -219,6 +219,23 @@ static inline void start_cfs_bandwidth(struct cfs_rq *cfs_rq)
 
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
 	return cfs_rq->rq_bandwidth.throttled;
@@ -245,6 +262,7 @@ static void sched_cfs_runtime_exceeded(struct sched_entity *se,
 
 	if (cfs_rq->rq_bandwidth.time > cfs_rq->rq_bandwidth.runtime) {
 		cfs_rq->rq_bandwidth.throttled = 1;
+		update_stats_throttle_start(cfs_rq, se);
 		resched_task(tsk_curr);
 	}
 }
@@ -300,6 +318,8 @@ static int do_sched_cfs_period_timer(struct sched_bandwidth *cfs_b, int overrun)
 			if (cfs_rq_throttled(cfs_rq) &&
 					cfs_rq->rq_bandwidth.time < runtime) {
 				cfs_rq->rq_bandwidth.throttled = 0;
+				update_rq_clock(rq);
+				update_stats_throttle_end(cfs_rq, se);
 				enqueue = 1;
 			}
 			if (cfs_rq->rq_bandwidth.time || cfs_rq->nr_running)
