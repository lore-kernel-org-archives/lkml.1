Return-Path: <linux-kernel-owner+w=401wt.eu-S1756442AbYACTO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbYACTO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 14:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbYACTOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 14:14:17 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:16036 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbYACTOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 14:14:14 -0500
X-SourceIP: 80.56.237.116
Message-Id: <20080103191415.056891000@chello.nl>
References: <20080103191300.658221000@chello.nl>
User-Agent: quilt/0.45-1
Date: Thu, 03 Jan 2008 20:13:01 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/2] sched: rt throttling vs no_hz
Content-Disposition: inline; filename=sched-rt-group-update.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to teach no_hz about the rt throttling because its tick driven.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h    |    2 ++
 kernel/sched.c           |   23 ++++++++++++++++++++++-
 kernel/sched_rt.c        |   30 ++++++++++++++++--------------
 kernel/time/tick-sched.c |    5 +++++
 4 files changed, 45 insertions(+), 15 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -230,6 +230,8 @@ static inline int select_nohz_load_balan
 }
 #endif
 
+extern unsigned long rt_needs_cpu(int cpu);
+
 /*
  * Only dump TASK_* tasks. (0 for all tasks)
  */
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -442,6 +442,7 @@ struct rq {
 	struct cfs_rq cfs;
 	struct rt_rq rt;
 	u64 rt_period_expire;
+	int rt_throttled;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* list of leaf cfs_rq on this cpu: */
@@ -594,6 +595,23 @@ static void update_rq_clock(struct rq *r
 #define task_rq(p)		cpu_rq(task_cpu(p))
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 
+unsigned long rt_needs_cpu(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	u64 delta;
+
+	if (!rq->rt_throttled)
+		return 0;
+
+	if (rq->clock > rq->rt_period_expire)
+		return 1;
+
+	delta = rq->rt_period_expire - rq->clock;
+	do_div(delta, NSEC_PER_SEC / HZ);
+
+	return (unsigned long)delta;
+}
+
 /*
  * Tunables that become constants when CONFIG_SCHED_DEBUG is off:
  */
@@ -7099,9 +7117,11 @@ static void init_rt_rq(struct rt_rq *rt_
 	/* delimiter for bitsearch: */
 	__set_bit(MAX_RT_PRIO, array->bitmap);
 
+#if defined CONFIG_SMP || defined CONFIG_FAIR_GROUP_SCHED
+	rt_rq->highest_prio = MAX_RT_PRIO;
+#endif
 #ifdef CONFIG_SMP
 	rt_rq->rt_nr_migratory = 0;
-	rt_rq->highest_prio = MAX_RT_PRIO;
 	rt_rq->overloaded = 0;
 #endif
 
@@ -7186,6 +7206,7 @@ void __init sched_init(void)
 		list_add(&init_task_group.list, &task_groups);
 #endif
 		rq->rt_period_expire = 0;
+		rq->rt_throttled = 0;
 
 		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
 			rq->cpu_load[j] = 0;
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -175,7 +175,11 @@ static int sched_rt_ratio_exceeded(struc
 	ratio = (period * rt_ratio) >> SCHED_RT_FRAC_SHIFT;
 
 	if (rt_rq->rt_time > ratio) {
+		struct rq *rq = rq_of_rt_rq(rt_rq);
+
+		rq->rt_throttled = 1;
 		rt_rq->rt_throttled = 1;
+
 		sched_rt_ratio_dequeue(rt_rq);
 		return 1;
 	}
@@ -183,18 +187,6 @@ static int sched_rt_ratio_exceeded(struc
 	return 0;
 }
 
-static void __update_sched_rt_period(struct rt_rq *rt_rq, u64 period)
-{
-	unsigned long rt_ratio = sched_rt_ratio(rt_rq);
-	u64 ratio = (period * rt_ratio) >> SCHED_RT_FRAC_SHIFT;
-
-	rt_rq->rt_time -= min(rt_rq->rt_time, ratio);
-	if (rt_rq->rt_throttled) {
-		rt_rq->rt_throttled = 0;
-		sched_rt_ratio_enqueue(rt_rq);
-	}
-}
-
 static void update_sched_rt_period(struct rq *rq)
 {
 	struct rt_rq *rt_rq;
@@ -204,8 +196,18 @@ static void update_sched_rt_period(struc
 		period = (u64)sysctl_sched_rt_period * NSEC_PER_MSEC;
 		rq->rt_period_expire += period;
 
-		for_each_leaf_rt_rq(rt_rq, rq)
-			__update_sched_rt_period(rt_rq, period);
+		for_each_leaf_rt_rq(rt_rq, rq) {
+			unsigned long rt_ratio = sched_rt_ratio(rt_rq);
+			u64 ratio = (period * rt_ratio) >> SCHED_RT_FRAC_SHIFT;
+
+			rt_rq->rt_time -= min(rt_rq->rt_time, ratio);
+			if (rt_rq->rt_throttled) {
+				rt_rq->rt_throttled = 0;
+				sched_rt_ratio_enqueue(rt_rq);
+			}
+		}
+
+		rq->rt_throttled = 0;
 	}
 }
 
Index: linux-2.6/kernel/time/tick-sched.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-sched.c
+++ linux-2.6/kernel/time/tick-sched.c
@@ -153,6 +153,7 @@ void tick_nohz_update_jiffies(void)
 void tick_nohz_stop_sched_tick(void)
 {
 	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies, flags;
+	unsigned long rt_jiffies;
 	struct tick_sched *ts;
 	ktime_t last_update, expires, now, delta;
 	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
@@ -216,6 +217,10 @@ void tick_nohz_stop_sched_tick(void)
 	next_jiffies = get_next_timer_interrupt(last_jiffies);
 	delta_jiffies = next_jiffies - last_jiffies;
 
+	rt_jiffies = rt_needs_cpu(cpu);
+	if (rt_jiffies && rt_jiffies < delta_jiffies)
+		delta_jiffies = rt_jiffies;
+
 	if (rcu_needs_cpu(cpu))
 		delta_jiffies = 1;
 	/*

--

