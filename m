Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbZICNYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbZICNYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbZICNX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:23:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:52783 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbZICNXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:23:22 -0400
Message-Id: <20090903132212.601077313@chello.nl>
References: <20090903132145.482814810@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 03 Sep 2009 15:21:51 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 06/14] sched: scale down cpu_power due to RT tasks
Content-Disposition: inline; filename=sched-lb-5.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep an average on the amount of time spend on RT tasks and use that
fraction to scale down the cpu_power for regular tasks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    1 
 kernel/sched.c        |   64 +++++++++++++++++++++++++++++++++++++++++++++++---
 kernel/sched_rt.c     |    6 +---
 kernel/sysctl.c       |    8 ++++++
 4 files changed, 72 insertions(+), 7 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1863,6 +1863,7 @@ extern unsigned int sysctl_sched_child_r
 extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
+extern unsigned int sysctl_sched_time_avg;
 extern unsigned int sysctl_timer_migration;
 
 int sched_nr_latency_handler(struct ctl_table *table, int write,
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -627,6 +627,9 @@ struct rq {
 
 	struct task_struct *migration_thread;
 	struct list_head migration_queue;
+
+	u64 rt_avg;
+	u64 age_stamp;
 #endif
 
 	/* calc_load related fields */
@@ -863,6 +866,14 @@ unsigned int sysctl_sched_shares_ratelim
 unsigned int sysctl_sched_shares_thresh = 4;
 
 /*
+ * period over which we average the RT time consumption, measured
+ * in ms.
+ *
+ * default: 1s
+ */
+const_debug unsigned int sysctl_sched_time_avg = MSEC_PER_SEC;
+
+/*
  * period over which we measure -rt task cpu usage in us.
  * default: 1s
  */
@@ -1280,12 +1291,37 @@ void wake_up_idle_cpu(int cpu)
 }
 #endif /* CONFIG_NO_HZ */
 
+static u64 sched_avg_period(void)
+{
+	return (u64)sysctl_sched_time_avg * NSEC_PER_MSEC / 2;
+}
+
+static void sched_avg_update(struct rq *rq)
+{
+	s64 period = sched_avg_period();
+
+	while ((s64)(rq->clock - rq->age_stamp) > period) {
+		rq->age_stamp += period;
+		rq->rt_avg /= 2;
+	}
+}
+
+static void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
+{
+	rq->rt_avg += rt_delta;
+	sched_avg_update(rq);
+}
+
 #else /* !CONFIG_SMP */
 static void resched_task(struct task_struct *p)
 {
 	assert_spin_locked(&task_rq(p)->lock);
 	set_tsk_need_resched(p);
 }
+
+static void sched_rt_avg_update(struct rq *rq, u64 rt_delta)
+{
+}
 #endif /* CONFIG_SMP */
 
 #if BITS_PER_LONG == 32
@@ -3699,7 +3735,7 @@ static inline int check_power_save_busie
 }
 #endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
 
-unsigned long __weak arch_smt_gain(struct sched_domain *sd, int cpu)
+unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
 {
 	unsigned long weight = cpumask_weight(sched_domain_span(sd));
 	unsigned long smt_gain = sd->smt_gain;
@@ -3709,6 +3745,24 @@ unsigned long __weak arch_smt_gain(struc
 	return smt_gain;
 }
 
+unsigned long scale_rt_power(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	u64 total, available;
+
+	sched_avg_update(rq);
+
+	total = sched_avg_period() + (rq->clock - rq->age_stamp);
+	available = total - rq->rt_avg;
+
+	if (unlikely((s64)total < SCHED_LOAD_SCALE))
+		total = SCHED_LOAD_SCALE;
+
+	total >>= SCHED_LOAD_SHIFT;
+
+	return div_u64(available, total);
+}
+
 static void update_cpu_power(struct sched_domain *sd, int cpu)
 {
 	unsigned long weight = cpumask_weight(sched_domain_span(sd));
@@ -3719,11 +3773,15 @@ static void update_cpu_power(struct sche
 	/* here we could scale based on cpufreq */
 
 	if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
-		power *= arch_smt_gain(sd, cpu);
+		power *= arch_scale_smt_power(sd, cpu);
 		power >>= SCHED_LOAD_SHIFT;
 	}
 
-	/* here we could scale based on RT time */
+	power *= scale_rt_power(cpu);
+	power >>= SCHED_LOAD_SHIFT;
+
+	if (!power)
+		power = 1;
 
 	if (power != old) {
 		sdg->__cpu_power = power;
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -615,6 +615,8 @@ static void update_curr_rt(struct rq *rq
 	curr->se.exec_start = rq->clock;
 	cpuacct_charge(curr, delta_exec);
 
+	sched_rt_avg_update(rq, delta_exec);
+
 	if (!rt_bandwidth_enabled())
 		return;
 
@@ -887,8 +889,6 @@ static void enqueue_task_rt(struct rq *r
 
 	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
-
-	inc_cpu_load(rq, p->se.load.weight);
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
@@ -899,8 +899,6 @@ static void dequeue_task_rt(struct rq *r
 	dequeue_rt_entity(rt_se);
 
 	dequeue_pushable_task(rq, p);
-
-	dec_cpu_load(rq, p->se.load.weight);
 }
 
 /*
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -332,6 +332,14 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_time_avg",
+		.data		= &sysctl_sched_time_avg,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "timer_migration",
 		.data		= &sysctl_timer_migration,
 		.maxlen		= sizeof(unsigned int),

-- 

