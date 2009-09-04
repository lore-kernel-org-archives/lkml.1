Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbZIDI4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbZIDI4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 04:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756680AbZIDI4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 04:56:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:36685 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756737AbZIDI4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 04:56:38 -0400
Date: Fri, 4 Sep 2009 08:56:02 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, ego@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, andreas.herrmann3@amd.com, a.p.zijlstra@chello.nl,
       balbir@in.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: balbir@in.ibm.com, mingo@redhat.com, hpa@zytor.com, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090901083826.287778431@chello.nl>
References: <20090901083826.287778431@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/balancing] sched: Scale down cpu_power due to RT tasks
Message-ID: <tip-e9e9250bc78e7f6342517214c0178a529807964b@git.kernel.org>
Git-Commit-ID: e9e9250bc78e7f6342517214c0178a529807964b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 08:56:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9e9250bc78e7f6342517214c0178a529807964b
Gitweb:     http://git.kernel.org/tip/e9e9250bc78e7f6342517214c0178a529807964b
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 1 Sep 2009 10:34:37 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Sep 2009 10:09:55 +0200

sched: Scale down cpu_power due to RT tasks

Keep an average on the amount of time spend on RT tasks and use
that fraction to scale down the cpu_power for regular tasks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
LKML-Reference: <20090901083826.287778431@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/sched.h |    1 +
 kernel/sched.c        |   64 ++++++++++++++++++++++++++++++++++++++++++++++--
 kernel/sched_rt.c     |    6 +---
 kernel/sysctl.c       |    8 ++++++
 4 files changed, 72 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9c81c92..c67ddf3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1831,6 +1831,7 @@ extern unsigned int sysctl_sched_child_runs_first;
 extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
+extern unsigned int sysctl_sched_time_avg;
 extern unsigned int sysctl_timer_migration;
 
 int sched_nr_latency_handler(struct ctl_table *table, int write,
diff --git a/kernel/sched.c b/kernel/sched.c
index 036600f..ab532b5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -627,6 +627,9 @@ struct rq {
 
 	struct task_struct *migration_thread;
 	struct list_head migration_queue;
+
+	u64 rt_avg;
+	u64 age_stamp;
 #endif
 
 	/* calc_load related fields */
@@ -863,6 +866,14 @@ unsigned int sysctl_sched_shares_ratelimit = 250000;
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
@@ -3699,7 +3735,7 @@ static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
 }
 #endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
 
-unsigned long __weak arch_smt_gain(struct sched_domain *sd, int cpu)
+unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
 {
 	unsigned long weight = cpumask_weight(sched_domain_span(sd));
 	unsigned long smt_gain = sd->smt_gain;
@@ -3709,6 +3745,24 @@ unsigned long __weak arch_smt_gain(struct sched_domain *sd, int cpu)
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
@@ -3719,11 +3773,15 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
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
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 3d4020a..2eb4bd6 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -615,6 +615,8 @@ static void update_curr_rt(struct rq *rq)
 	curr->se.exec_start = rq->clock;
 	cpuacct_charge(curr, delta_exec);
 
+	sched_rt_avg_update(rq, delta_exec);
+
 	if (!rt_bandwidth_enabled())
 		return;
 
@@ -887,8 +889,6 @@ static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)
 
 	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
-
-	inc_cpu_load(rq, p->se.load.weight);
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
@@ -899,8 +899,6 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
 	dequeue_rt_entity(rt_se);
 
 	dequeue_pushable_task(rq, p);
-
-	dec_cpu_load(rq, p->se.load.weight);
 }
 
 /*
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 58be760..6c9836e 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
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
