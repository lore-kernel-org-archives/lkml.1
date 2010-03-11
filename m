Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943Ab0CKOne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:43:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:43454 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932632Ab0CKOna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:43:30 -0500
Date: Thu, 11 Mar 2010 14:42:07 GMT
From: tip-bot for Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, lucas.de.marchi@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lucas.de.marchi@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1268275065-18542-1-git-send-email-lucas.de.marchi@gmail.com>
References: <1268275065-18542-1-git-send-email-lucas.de.marchi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Implement group scheduler statistics in one struct
Message-ID: <tip-41acab8851a0408c1d5ad6c21a07456f88b54d40@git.kernel.org>
Git-Commit-ID: 41acab8851a0408c1d5ad6c21a07456f88b54d40
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 14:42:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41acab8851a0408c1d5ad6c21a07456f88b54d40
Gitweb:     http://git.kernel.org/tip/41acab8851a0408c1d5ad6c21a07456f88b54d40
Author:     Lucas De Marchi <lucas.de.marchi@gmail.com>
AuthorDate: Wed, 10 Mar 2010 23:37:45 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 15:22:28 +0100

sched: Implement group scheduler statistics in one struct

Put all statistic fields of sched_entity in one struct, sched_statistics,
and embed it into sched_entity.

This change allows to memset the sched_statistics to 0 when needed (for
instance when forking), avoiding bugs of non initialized fields.

Signed-off-by: Lucas De Marchi <lucas.de.marchi@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1268275065-18542-1-git-send-email-lucas.de.marchi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |   54 ++++++++++++--------------
 kernel/sched.c        |   47 ++++------------------
 kernel/sched_debug.c  |  101 ++++++++++++++++++------------------------------
 kernel/sched_fair.c   |   65 ++++++++++++++++---------------
 kernel/sched_rt.c     |    2 +-
 5 files changed, 106 insertions(+), 163 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4b1753f..8cc863d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1127,36 +1127,8 @@ struct load_weight {
 	unsigned long weight, inv_weight;
 };
 
-/*
- * CFS stats for a schedulable entity (task, task-group etc)
- *
- * Current field usage histogram:
- *
- *     4 se->block_start
- *     4 se->run_node
- *     4 se->sleep_start
- *     6 se->load.weight
- */
-struct sched_entity {
-	struct load_weight	load;		/* for load-balancing */
-	struct rb_node		run_node;
-	struct list_head	group_node;
-	unsigned int		on_rq;
-
-	u64			exec_start;
-	u64			sum_exec_runtime;
-	u64			vruntime;
-	u64			prev_sum_exec_runtime;
-
-	u64			last_wakeup;
-	u64			avg_overlap;
-
-	u64			nr_migrations;
-
-	u64			start_runtime;
-	u64			avg_wakeup;
-
 #ifdef CONFIG_SCHEDSTATS
+struct sched_statistics {
 	u64			wait_start;
 	u64			wait_max;
 	u64			wait_count;
@@ -1188,6 +1160,30 @@ struct sched_entity {
 	u64			nr_wakeups_affine_attempts;
 	u64			nr_wakeups_passive;
 	u64			nr_wakeups_idle;
+};
+#endif
+
+struct sched_entity {
+	struct load_weight	load;		/* for load-balancing */
+	struct rb_node		run_node;
+	struct list_head	group_node;
+	unsigned int		on_rq;
+
+	u64			exec_start;
+	u64			sum_exec_runtime;
+	u64			vruntime;
+	u64			prev_sum_exec_runtime;
+
+	u64			last_wakeup;
+	u64			avg_overlap;
+
+	u64			nr_migrations;
+
+	u64			start_runtime;
+	u64			avg_wakeup;
+
+#ifdef CONFIG_SCHEDSTATS
+	struct sched_statistics statistics;
 #endif
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
diff --git a/kernel/sched.c b/kernel/sched.c
index 2c1db81..a4aa071 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2437,15 +2437,15 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 
 out_activate:
 #endif /* CONFIG_SMP */
-	schedstat_inc(p, se.nr_wakeups);
+	schedstat_inc(p, se.statistics.nr_wakeups);
 	if (wake_flags & WF_SYNC)
-		schedstat_inc(p, se.nr_wakeups_sync);
+		schedstat_inc(p, se.statistics.nr_wakeups_sync);
 	if (orig_cpu != cpu)
-		schedstat_inc(p, se.nr_wakeups_migrate);
+		schedstat_inc(p, se.statistics.nr_wakeups_migrate);
 	if (cpu == this_cpu)
-		schedstat_inc(p, se.nr_wakeups_local);
+		schedstat_inc(p, se.statistics.nr_wakeups_local);
 	else
-		schedstat_inc(p, se.nr_wakeups_remote);
+		schedstat_inc(p, se.statistics.nr_wakeups_remote);
 	activate_task(rq, p, 1);
 	success = 1;
 
@@ -2532,36 +2532,7 @@ static void __sched_fork(struct task_struct *p)
 	p->se.avg_wakeup		= sysctl_sched_wakeup_granularity;
 
 #ifdef CONFIG_SCHEDSTATS
-	p->se.wait_start			= 0;
-	p->se.wait_max				= 0;
-	p->se.wait_count			= 0;
-	p->se.wait_sum				= 0;
-
-	p->se.sleep_start			= 0;
-	p->se.sleep_max				= 0;
-	p->se.sum_sleep_runtime			= 0;
-
-	p->se.block_start			= 0;
-	p->se.block_max				= 0;
-	p->se.exec_max				= 0;
-	p->se.slice_max				= 0;
-
-	p->se.nr_migrations_cold		= 0;
-	p->se.nr_failed_migrations_affine	= 0;
-	p->se.nr_failed_migrations_running	= 0;
-	p->se.nr_failed_migrations_hot		= 0;
-	p->se.nr_forced_migrations		= 0;
-
-	p->se.nr_wakeups			= 0;
-	p->se.nr_wakeups_sync			= 0;
-	p->se.nr_wakeups_migrate		= 0;
-	p->se.nr_wakeups_local			= 0;
-	p->se.nr_wakeups_remote			= 0;
-	p->se.nr_wakeups_affine			= 0;
-	p->se.nr_wakeups_affine_attempts	= 0;
-	p->se.nr_wakeups_passive		= 0;
-	p->se.nr_wakeups_idle			= 0;
-
+	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
 #endif
 
 	INIT_LIST_HEAD(&p->rt.run_list);
@@ -7910,9 +7881,9 @@ void normalize_rt_tasks(void)
 
 		p->se.exec_start		= 0;
 #ifdef CONFIG_SCHEDSTATS
-		p->se.wait_start		= 0;
-		p->se.sleep_start		= 0;
-		p->se.block_start		= 0;
+		p->se.statistics.wait_start	= 0;
+		p->se.statistics.sleep_start	= 0;
+		p->se.statistics.block_start	= 0;
 #endif
 
 		if (!rt_task(p)) {
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 67f95aa..ad9df44 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -70,16 +70,16 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu,
 	PN(se->vruntime);
 	PN(se->sum_exec_runtime);
 #ifdef CONFIG_SCHEDSTATS
-	PN(se->wait_start);
-	PN(se->sleep_start);
-	PN(se->block_start);
-	PN(se->sleep_max);
-	PN(se->block_max);
-	PN(se->exec_max);
-	PN(se->slice_max);
-	PN(se->wait_max);
-	PN(se->wait_sum);
-	P(se->wait_count);
+	PN(se->statistics.wait_start);
+	PN(se->statistics.sleep_start);
+	PN(se->statistics.block_start);
+	PN(se->statistics.sleep_max);
+	PN(se->statistics.block_max);
+	PN(se->statistics.exec_max);
+	PN(se->statistics.slice_max);
+	PN(se->statistics.wait_max);
+	PN(se->statistics.wait_sum);
+	P(se->statistics.wait_count);
 #endif
 	P(se->load.weight);
 #undef PN
@@ -104,7 +104,7 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 	SEQ_printf(m, "%9Ld.%06ld %9Ld.%06ld %9Ld.%06ld",
 		SPLIT_NS(p->se.vruntime),
 		SPLIT_NS(p->se.sum_exec_runtime),
-		SPLIT_NS(p->se.sum_sleep_runtime));
+		SPLIT_NS(p->se.statistics.sum_sleep_runtime));
 #else
 	SEQ_printf(m, "%15Ld %15Ld %15Ld.%06ld %15Ld.%06ld %15Ld.%06ld",
 		0LL, 0LL, 0LL, 0L, 0LL, 0L, 0LL, 0L);
@@ -413,34 +413,34 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	nr_switches = p->nvcsw + p->nivcsw;
 
 #ifdef CONFIG_SCHEDSTATS
-	PN(se.wait_start);
-	PN(se.sleep_start);
-	PN(se.block_start);
-	PN(se.sleep_max);
-	PN(se.block_max);
-	PN(se.exec_max);
-	PN(se.slice_max);
-	PN(se.wait_max);
-	PN(se.wait_sum);
-	P(se.wait_count);
-	PN(se.iowait_sum);
-	P(se.iowait_count);
+	PN(se.statistics.wait_start);
+	PN(se.statistics.sleep_start);
+	PN(se.statistics.block_start);
+	PN(se.statistics.sleep_max);
+	PN(se.statistics.block_max);
+	PN(se.statistics.exec_max);
+	PN(se.statistics.slice_max);
+	PN(se.statistics.wait_max);
+	PN(se.statistics.wait_sum);
+	P(se.statistics.wait_count);
+	PN(se.statistics.iowait_sum);
+	P(se.statistics.iowait_count);
 	P(sched_info.bkl_count);
 	P(se.nr_migrations);
-	P(se.nr_migrations_cold);
-	P(se.nr_failed_migrations_affine);
-	P(se.nr_failed_migrations_running);
-	P(se.nr_failed_migrations_hot);
-	P(se.nr_forced_migrations);
-	P(se.nr_wakeups);
-	P(se.nr_wakeups_sync);
-	P(se.nr_wakeups_migrate);
-	P(se.nr_wakeups_local);
-	P(se.nr_wakeups_remote);
-	P(se.nr_wakeups_affine);
-	P(se.nr_wakeups_affine_attempts);
-	P(se.nr_wakeups_passive);
-	P(se.nr_wakeups_idle);
+	P(se.statistics.nr_migrations_cold);
+	P(se.statistics.nr_failed_migrations_affine);
+	P(se.statistics.nr_failed_migrations_running);
+	P(se.statistics.nr_failed_migrations_hot);
+	P(se.statistics.nr_forced_migrations);
+	P(se.statistics.nr_wakeups);
+	P(se.statistics.nr_wakeups_sync);
+	P(se.statistics.nr_wakeups_migrate);
+	P(se.statistics.nr_wakeups_local);
+	P(se.statistics.nr_wakeups_remote);
+	P(se.statistics.nr_wakeups_affine);
+	P(se.statistics.nr_wakeups_affine_attempts);
+	P(se.statistics.nr_wakeups_passive);
+	P(se.statistics.nr_wakeups_idle);
 
 	{
 		u64 avg_atom, avg_per_cpu;
@@ -491,32 +491,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 void proc_sched_set_task(struct task_struct *p)
 {
 #ifdef CONFIG_SCHEDSTATS
-	p->se.wait_max				= 0;
-	p->se.wait_sum				= 0;
-	p->se.wait_count			= 0;
-	p->se.iowait_sum			= 0;
-	p->se.iowait_count			= 0;
-	p->se.sleep_max				= 0;
-	p->se.sum_sleep_runtime			= 0;
-	p->se.block_max				= 0;
-	p->se.exec_max				= 0;
-	p->se.slice_max				= 0;
-	p->se.nr_migrations			= 0;
-	p->se.nr_migrations_cold		= 0;
-	p->se.nr_failed_migrations_affine	= 0;
-	p->se.nr_failed_migrations_running	= 0;
-	p->se.nr_failed_migrations_hot		= 0;
-	p->se.nr_forced_migrations		= 0;
-	p->se.nr_wakeups			= 0;
-	p->se.nr_wakeups_sync			= 0;
-	p->se.nr_wakeups_migrate		= 0;
-	p->se.nr_wakeups_local			= 0;
-	p->se.nr_wakeups_remote			= 0;
-	p->se.nr_wakeups_affine			= 0;
-	p->se.nr_wakeups_affine_attempts	= 0;
-	p->se.nr_wakeups_passive		= 0;
-	p->se.nr_wakeups_idle			= 0;
-	p->sched_info.bkl_count			= 0;
+	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
 #endif
 	p->se.sum_exec_runtime			= 0;
 	p->se.prev_sum_exec_runtime		= 0;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3e1fd96..8ad164b 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -505,7 +505,8 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 {
 	unsigned long delta_exec_weighted;
 
-	schedstat_set(curr->exec_max, max((u64)delta_exec, curr->exec_max));
+	schedstat_set(curr->statistics.exec_max,
+		      max((u64)delta_exec, curr->statistics.exec_max));
 
 	curr->sum_exec_runtime += delta_exec;
 	schedstat_add(cfs_rq, exec_clock, delta_exec);
@@ -548,7 +549,7 @@ static void update_curr(struct cfs_rq *cfs_rq)
 static inline void
 update_stats_wait_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	schedstat_set(se->wait_start, rq_of(cfs_rq)->clock);
+	schedstat_set(se->statistics.wait_start, rq_of(cfs_rq)->clock);
 }
 
 /*
@@ -567,18 +568,18 @@ static void update_stats_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 static void
 update_stats_wait_end(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	schedstat_set(se->wait_max, max(se->wait_max,
-			rq_of(cfs_rq)->clock - se->wait_start));
-	schedstat_set(se->wait_count, se->wait_count + 1);
-	schedstat_set(se->wait_sum, se->wait_sum +
-			rq_of(cfs_rq)->clock - se->wait_start);
+	schedstat_set(se->statistics.wait_max, max(se->statistics.wait_max,
+			rq_of(cfs_rq)->clock - se->statistics.wait_start));
+	schedstat_set(se->statistics.wait_count, se->statistics.wait_count + 1);
+	schedstat_set(se->statistics.wait_sum, se->statistics.wait_sum +
+			rq_of(cfs_rq)->clock - se->statistics.wait_start);
 #ifdef CONFIG_SCHEDSTATS
 	if (entity_is_task(se)) {
 		trace_sched_stat_wait(task_of(se),
-			rq_of(cfs_rq)->clock - se->wait_start);
+			rq_of(cfs_rq)->clock - se->statistics.wait_start);
 	}
 #endif
-	schedstat_set(se->wait_start, 0);
+	schedstat_set(se->statistics.wait_start, 0);
 }
 
 static inline void
@@ -657,39 +658,39 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	if (entity_is_task(se))
 		tsk = task_of(se);
 
-	if (se->sleep_start) {
-		u64 delta = rq_of(cfs_rq)->clock - se->sleep_start;
+	if (se->statistics.sleep_start) {
+		u64 delta = rq_of(cfs_rq)->clock - se->statistics.sleep_start;
 
 		if ((s64)delta < 0)
 			delta = 0;
 
-		if (unlikely(delta > se->sleep_max))
-			se->sleep_max = delta;
+		if (unlikely(delta > se->statistics.sleep_max))
+			se->statistics.sleep_max = delta;
 
-		se->sleep_start = 0;
-		se->sum_sleep_runtime += delta;
+		se->statistics.sleep_start = 0;
+		se->statistics.sum_sleep_runtime += delta;
 
 		if (tsk) {
 			account_scheduler_latency(tsk, delta >> 10, 1);
 			trace_sched_stat_sleep(tsk, delta);
 		}
 	}
-	if (se->block_start) {
-		u64 delta = rq_of(cfs_rq)->clock - se->block_start;
+	if (se->statistics.block_start) {
+		u64 delta = rq_of(cfs_rq)->clock - se->statistics.block_start;
 
 		if ((s64)delta < 0)
 			delta = 0;
 
-		if (unlikely(delta > se->block_max))
-			se->block_max = delta;
+		if (unlikely(delta > se->statistics.block_max))
+			se->statistics.block_max = delta;
 
-		se->block_start = 0;
-		se->sum_sleep_runtime += delta;
+		se->statistics.block_start = 0;
+		se->statistics.sum_sleep_runtime += delta;
 
 		if (tsk) {
 			if (tsk->in_iowait) {
-				se->iowait_sum += delta;
-				se->iowait_count++;
+				se->statistics.iowait_sum += delta;
+				se->statistics.iowait_count++;
 				trace_sched_stat_iowait(tsk, delta);
 			}
 
@@ -826,9 +827,9 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 			struct task_struct *tsk = task_of(se);
 
 			if (tsk->state & TASK_INTERRUPTIBLE)
-				se->sleep_start = rq_of(cfs_rq)->clock;
+				se->statistics.sleep_start = rq_of(cfs_rq)->clock;
 			if (tsk->state & TASK_UNINTERRUPTIBLE)
-				se->block_start = rq_of(cfs_rq)->clock;
+				se->statistics.block_start = rq_of(cfs_rq)->clock;
 		}
 #endif
 	}
@@ -912,7 +913,7 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	 * when there are only lesser-weight tasks around):
 	 */
 	if (rq_of(cfs_rq)->load.weight >= 2*se->load.weight) {
-		se->slice_max = max(se->slice_max,
+		se->statistics.slice_max = max(se->statistics.slice_max,
 			se->sum_exec_runtime - se->prev_sum_exec_runtime);
 	}
 #endif
@@ -1306,7 +1307,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	if (sync && balanced)
 		return 1;
 
-	schedstat_inc(p, se.nr_wakeups_affine_attempts);
+	schedstat_inc(p, se.statistics.nr_wakeups_affine_attempts);
 	tl_per_task = cpu_avg_load_per_task(this_cpu);
 
 	if (balanced ||
@@ -1318,7 +1319,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 		 * there is no bad imbalance.
 		 */
 		schedstat_inc(sd, ttwu_move_affine);
-		schedstat_inc(p, se.nr_wakeups_affine);
+		schedstat_inc(p, se.statistics.nr_wakeups_affine);
 
 		return 1;
 	}
@@ -1844,13 +1845,13 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 	 * 3) are cache-hot on their current CPU.
 	 */
 	if (!cpumask_test_cpu(this_cpu, &p->cpus_allowed)) {
-		schedstat_inc(p, se.nr_failed_migrations_affine);
+		schedstat_inc(p, se.statistics.nr_failed_migrations_affine);
 		return 0;
 	}
 	*all_pinned = 0;
 
 	if (task_running(rq, p)) {
-		schedstat_inc(p, se.nr_failed_migrations_running);
+		schedstat_inc(p, se.statistics.nr_failed_migrations_running);
 		return 0;
 	}
 
@@ -1866,14 +1867,14 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 #ifdef CONFIG_SCHEDSTATS
 		if (tsk_cache_hot) {
 			schedstat_inc(sd, lb_hot_gained[idle]);
-			schedstat_inc(p, se.nr_forced_migrations);
+			schedstat_inc(p, se.statistics.nr_forced_migrations);
 		}
 #endif
 		return 1;
 	}
 
 	if (tsk_cache_hot) {
-		schedstat_inc(p, se.nr_failed_migrations_hot);
+		schedstat_inc(p, se.statistics.nr_failed_migrations_hot);
 		return 0;
 	}
 	return 1;
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index c4fb42a..0335e87 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -613,7 +613,7 @@ static void update_curr_rt(struct rq *rq)
 	if (unlikely((s64)delta_exec < 0))
 		delta_exec = 0;
 
-	schedstat_set(curr->se.exec_max, max(curr->se.exec_max, delta_exec));
+	schedstat_set(curr->se.statistics.exec_max, max(curr->se.statistics.exec_max, delta_exec));
 
 	curr->se.sum_exec_runtime += delta_exec;
 	account_group_exec_runtime(curr, delta_exec);
