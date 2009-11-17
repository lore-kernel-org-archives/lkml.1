Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbZKQOeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbZKQOeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 09:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbZKQOeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 09:34:15 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:48298 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbZKQOeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 09:34:14 -0500
Date: Tue, 17 Nov 2009 20:04:04 +0530
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
Subject: [RFC v4 PATCH 1/7] sched: Rename sched_rt_period_mask() and use it
	in CFS also
Message-ID: <20091117143404.GL17335@in.ibm.com>
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

sched: Rename sched_rt_period_mask() and use it in CFS also.

From: Bharata B Rao <bharata@linux.vnet.ibm.com>

sched_rt_period_mask() is needed in CFS also. Rename it to a generic name
and move it to kernel/sched.c. No functionality change in this patch.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 kernel/sched.c    |   23 +++++++++++++++++++++++
 kernel/sched_rt.c |   19 +------------------
 2 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index a455dca..1309e8d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1810,6 +1810,29 @@ static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
 
 static void calc_load_account_active(struct rq *this_rq);
 
+
+#if defined(CONFIG_RT_GROUP_SCHED) || defined(CONFIG_FAIR_GROUP_SCHED)
+
+#ifdef CONFIG_SMP
+static inline const struct cpumask *sched_bw_period_mask(void)
+{
+	return cpu_rq(smp_processor_id())->rd->span;
+}
+#else /* !CONFIG_SMP */
+static inline const struct cpumask *sched_bw_period_mask(void)
+{
+	return cpu_online_mask;
+}
+#endif /* CONFIG_SMP */
+
+#else
+static inline const struct cpumask *sched_bw_period_mask(void)
+{
+	return cpu_online_mask;
+}
+
+#endif
+
 #include "sched_stats.h"
 #include "sched_idletask.c"
 #include "sched_fair.c"
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index a4d790c..97067e1 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -235,18 +235,6 @@ static int rt_se_boosted(struct sched_rt_entity *rt_se)
 	return p->prio != p->normal_prio;
 }
 
-#ifdef CONFIG_SMP
-static inline const struct cpumask *sched_rt_period_mask(void)
-{
-	return cpu_rq(smp_processor_id())->rd->span;
-}
-#else
-static inline const struct cpumask *sched_rt_period_mask(void)
-{
-	return cpu_online_mask;
-}
-#endif
-
 static inline
 struct rt_rq *sched_rt_period_rt_rq(struct rt_bandwidth *rt_b, int cpu)
 {
@@ -296,11 +284,6 @@ static inline int rt_rq_throttled(struct rt_rq *rt_rq)
 	return rt_rq->rt_throttled;
 }
 
-static inline const struct cpumask *sched_rt_period_mask(void)
-{
-	return cpu_online_mask;
-}
-
 static inline
 struct rt_rq *sched_rt_period_rt_rq(struct rt_bandwidth *rt_b, int cpu)
 {
@@ -518,7 +501,7 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
 		return 1;
 
-	span = sched_rt_period_mask();
+	span = sched_bw_period_mask();
 	for_each_cpu(i, span) {
 		int enqueue = 0;
 		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);
