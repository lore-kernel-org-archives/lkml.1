Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500Ab0CJFHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 00:07:46 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44738 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab0CJFHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 00:07:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ercpbPMuiyzwZez6VfUnMDAwGIXLBOxhBGZav8hlv4h7nYJgtQtEKW7vLthySBF+Q+
         lv/tN3Q7Qn2pndklGNEQGHygggLhi8LURc7e3G88AJIc2fs1VCSeUdXj+i4r1fyv2zzN
         A7FtfhgN5B77jyzSwIuMP0O9gw5j/d4sCA7pc=
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
To: mingo@elte.hu, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Lucas De Marchi <lucas.de.marchi@gmail.com>
Subject: [PATCH] Group scheduler statistics in one struct
Date: Wed, 10 Mar 2010 02:07:40 -0300
Message-Id: <1268197660-14016-1-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lucas De Marchi <lucas.de.marchi@gmail.com>

Put all statistic fields of sched_entity in one struct, sched_statistics,
and embed it into sched_entity.

This change allows to memset the sched_statistics to 0 when needed (for
instance when forking), avoiding bugs of non initialized fields.

Signed-off-by: Lucas De Marchi <lucas.de.marchi@gmail.com>
---
 include/linux/sched.h |   54 ++++++++++++--------------
 kernel/sched.c        |   47 ++++------------------
 kernel/sched_debug.c  |  101 ++++++++++++++++++------------------------------
 kernel/sched_fair.c   |   65 ++++++++++++++++---------------
 kernel/sched_rt.c     |    2 +-
 5 files changed, 106 insertions(+), 163 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 46c6f8d..909e630 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1073,36 +1073,8 @@ struct load_weight {
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
@@ -1134,6 +1106,30 @@ struct sched_entity {
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
index 150b698..35c6b8a 100644
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
@@ -7914,9 +7885,9 @@ void normalize_rt_tasks(void)
 
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
index 67f95aa..f6e8ed6 100644
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
+	PN(se->statistiscs.wait_start);
+	PN(se->statistiscs.sleep_start);
+	PN(se->statistiscs.block_start);
+	PN(se->statistiscs.sleep_max);
+	PN(se->statistiscs.block_max);
+	PN(se->statistiscs.exec_max);
+	PN(se->statistiscs.slice_max);
+	PN(se->statistiscs.wait_max);
+	PN(se->statistiscs.wait_sum);
+	P(se->statistiscs.wait_count);
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
+	PN(se.statistiscs.wait_start);
+	PN(se.statistiscs.sleep_start);
+	PN(se.statistiscs.block_start);
+	PN(se.statistiscs.sleep_max);
+	PN(se.statistiscs.block_max);
+	PN(se.statistiscs.exec_max);
+	PN(se.statistiscs.slice_max);
+	PN(se.statistiscs.wait_max);
+	PN(se.statistiscs.wait_sum);
+	P(se.statistiscs.wait_count);
+	PN(se.statistiscs.iowait_sum);
+	P(se.statistiscs.iowait_count);
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
+	P(se.statistiscs.nr_migrations_cold);
+	P(se.statistiscs.nr_failed_migrations_affine);
+	P(se.statistiscs.nr_failed_migrations_running);
+	P(se.statistiscs.nr_failed_migrations_hot);
+	P(se.statistiscs.nr_forced_migrations);
+	P(se.statistiscs.nr_wakeups);
+	P(se.statistiscs.nr_wakeups_sync);
+	P(se.statistiscs.nr_wakeups_migrate);
+	P(se.statistiscs.nr_wakeups_local);
+	P(se.statistiscs.nr_wakeups_remote);
+	P(se.statistiscs.nr_wakeups_affine);
+	P(se.statistiscs.nr_wakeups_affine_attempts);
+	P(se.statistiscs.nr_wakeups_passive);
+	P(se.statistiscs.nr_wakeups_idle);
 
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
index 5a6ed1f..47a121d 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -613,7 +613,7 @@ static void update_curr_rt(struct rq *rq)
 	if (unlikely((s64)delta_exec < 0))
 		delta_exec = 0;
 
-	schedstat_set(curr->se.exec_max, max(curr->se.exec_max, delta_exec));
+	schedstat_set(curr->se.statistics.exec_max, max(curr->se.statistics.exec_max, delta_exec));
 
 	curr->se.sum_exec_runtime += delta_exec;
 	account_group_exec_runtime(curr, delta_exec);
-- 
1.7.0.2

