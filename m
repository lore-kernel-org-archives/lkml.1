Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbZLLGR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbZLLGR1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 01:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbZLLGR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 01:17:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34806 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbZLLGRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 01:17:24 -0500
Date: Sat, 12 Dec 2009 07:15:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20091212061521.GA8516@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Christian Ehrhardt (3):
      sched: Fix missing sched tunable recalculation on cpu add/remove
      sched: Make tunable scaling style configurable
      sched: Update normalized values on user updates via proc

Geert Uytterhoeven (1):
      cpumask: Fix generate_sched_domains() for UP

Ingo Molnar (1):
      sched: Remove forced2_migrations stats

Jupyung Lee (1):
      sched: Move update_curr() in check_preempt_wakeup() to avoid redundant call

Mike Galbraith (1):
      sched: Fix build warning in get_update_sysctl_factor()

Peter Zijlstra (11):
      sched: Fix balance vs hotplug race
      sched: Remove sysctl.sched_features
      sched: Consolidate select_task_rq() callers
      sched: Remove rq->clock coupling from set_task_cpu()
      sched: Clean up ttwu() rq locking
      sched: Sanitize fork() handling
      sched: Clean up check_preempt_wakeup()
      sched: Discard some old bits
      sched: Remove unnecessary RCU exclusion
      sched: cgroup: Implement different treatment for idle shares
      sched: Fix task priority bug

Phil Carmody (1):
      sched: Fix memory leak in two error corner cases

Thomas Gleixner (2):
      sched: Protect task->cpus_allowed access in sched_getaffinity()
      sched: Protect sched_rr_get_param() access to task->sched_class


 include/linux/cpumask.h |    2 +
 include/linux/sched.h   |   20 +++--
 kernel/cpu.c            |   18 +++-
 kernel/cpuset.c         |   18 ++--
 kernel/sched.c          |  218 ++++++++++++++++++++++++----------------------
 kernel/sched_debug.c    |   13 ++-
 kernel/sched_fair.c     |  155 +++++++++++++++++++--------------
 kernel/sched_features.h |    5 -
 kernel/sched_idletask.c |    2 +-
 kernel/sched_rt.c       |    2 +-
 kernel/sysctl.c         |   34 +++++---
 11 files changed, 274 insertions(+), 213 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 789cf5f..d77b547 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -84,6 +84,7 @@ extern const struct cpumask *const cpu_active_mask;
 #define num_online_cpus()	cpumask_weight(cpu_online_mask)
 #define num_possible_cpus()	cpumask_weight(cpu_possible_mask)
 #define num_present_cpus()	cpumask_weight(cpu_present_mask)
+#define num_active_cpus()	cpumask_weight(cpu_active_mask)
 #define cpu_online(cpu)		cpumask_test_cpu((cpu), cpu_online_mask)
 #define cpu_possible(cpu)	cpumask_test_cpu((cpu), cpu_possible_mask)
 #define cpu_present(cpu)	cpumask_test_cpu((cpu), cpu_present_mask)
@@ -92,6 +93,7 @@ extern const struct cpumask *const cpu_active_mask;
 #define num_online_cpus()	1
 #define num_possible_cpus()	1
 #define num_present_cpus()	1
+#define num_active_cpus()	1
 #define cpu_online(cpu)		((cpu) == 0)
 #define cpu_possible(cpu)	((cpu) == 0)
 #define cpu_present(cpu)	((cpu) == 0)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 89115ec..87b89a8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1102,7 +1102,7 @@ struct sched_class {
 
 	void (*set_curr_task) (struct rq *rq);
 	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
-	void (*task_new) (struct rq *rq, struct task_struct *p);
+	void (*task_fork) (struct task_struct *p);
 
 	void (*switched_from) (struct rq *this_rq, struct task_struct *task,
 			       int running);
@@ -1111,7 +1111,8 @@ struct sched_class {
 	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
 			     int oldprio, int running);
 
-	unsigned int (*get_rr_interval) (struct task_struct *task);
+	unsigned int (*get_rr_interval) (struct rq *rq,
+					 struct task_struct *task);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	void (*moved_group) (struct task_struct *p);
@@ -1151,8 +1152,6 @@ struct sched_entity {
 	u64			start_runtime;
 	u64			avg_wakeup;
 
-	u64			avg_running;
-
 #ifdef CONFIG_SCHEDSTATS
 	u64			wait_start;
 	u64			wait_max;
@@ -1175,7 +1174,6 @@ struct sched_entity {
 	u64			nr_failed_migrations_running;
 	u64			nr_failed_migrations_hot;
 	u64			nr_forced_migrations;
-	u64			nr_forced2_migrations;
 
 	u64			nr_wakeups;
 	u64			nr_wakeups_sync;
@@ -1903,14 +1901,22 @@ extern unsigned int sysctl_sched_wakeup_granularity;
 extern unsigned int sysctl_sched_shares_ratelimit;
 extern unsigned int sysctl_sched_shares_thresh;
 extern unsigned int sysctl_sched_child_runs_first;
+
+enum sched_tunable_scaling {
+	SCHED_TUNABLESCALING_NONE,
+	SCHED_TUNABLESCALING_LOG,
+	SCHED_TUNABLESCALING_LINEAR,
+	SCHED_TUNABLESCALING_END,
+};
+extern enum sched_tunable_scaling sysctl_sched_tunable_scaling;
+
 #ifdef CONFIG_SCHED_DEBUG
-extern unsigned int sysctl_sched_features;
 extern unsigned int sysctl_sched_migration_cost;
 extern unsigned int sysctl_sched_nr_migrate;
 extern unsigned int sysctl_sched_time_avg;
 extern unsigned int sysctl_timer_migration;
 
-int sched_nr_latency_handler(struct ctl_table *table, int write,
+int sched_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *length,
 		loff_t *ppos);
 #endif
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 6ba0f1e..b216886 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -212,6 +212,8 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
 					hcpu, -1, &nr_calls);
 	if (err == NOTIFY_BAD) {
+		set_cpu_active(cpu, true);
+
 		nr_calls--;
 		__raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
 					  hcpu, nr_calls, NULL);
@@ -223,11 +225,11 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 
 	/* Ensure that we are not runnable on dying cpu */
 	cpumask_copy(old_allowed, &current->cpus_allowed);
-	set_cpus_allowed_ptr(current,
-			     cpumask_of(cpumask_any_but(cpu_online_mask, cpu)));
+	set_cpus_allowed_ptr(current, cpu_active_mask);
 
 	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
 	if (err) {
+		set_cpu_active(cpu, true);
 		/* CPU didn't die: tell everyone.  Can't complain. */
 		if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
 					    hcpu) == NOTIFY_BAD)
@@ -292,9 +294,6 @@ int __ref cpu_down(unsigned int cpu)
 
 	err = _cpu_down(cpu, 0);
 
-	if (cpu_online(cpu))
-		set_cpu_active(cpu, true);
-
 out:
 	cpu_maps_update_done();
 	stop_machine_destroy();
@@ -387,6 +386,15 @@ int disable_nonboot_cpus(void)
 	 * with the userspace trying to use the CPU hotplug at the same time
 	 */
 	cpumask_clear(frozen_cpus);
+
+	for_each_online_cpu(cpu) {
+		if (cpu == first_cpu)
+			continue;
+		set_cpu_active(cpu, false);
+	}
+
+	synchronize_sched();
+
 	printk("Disabling non-boot CPUs ...\n");
 	for_each_online_cpu(cpu) {
 		if (cpu == first_cpu)
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3cf2183..ba401fa 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -737,7 +737,7 @@ static void do_rebuild_sched_domains(struct work_struct *unused)
 {
 }
 
-static int generate_sched_domains(struct cpumask **domains,
+static int generate_sched_domains(cpumask_var_t **domains,
 			struct sched_domain_attr **attributes)
 {
 	*domains = NULL;
@@ -872,7 +872,7 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 		if (retval < 0)
 			return retval;
 
-		if (!cpumask_subset(trialcs->cpus_allowed, cpu_online_mask))
+		if (!cpumask_subset(trialcs->cpus_allowed, cpu_active_mask))
 			return -EINVAL;
 	}
 	retval = validate_change(cs, trialcs);
@@ -2010,7 +2010,7 @@ static void scan_for_empty_cpusets(struct cpuset *root)
 		}
 
 		/* Continue past cpusets with all cpus, mems online */
-		if (cpumask_subset(cp->cpus_allowed, cpu_online_mask) &&
+		if (cpumask_subset(cp->cpus_allowed, cpu_active_mask) &&
 		    nodes_subset(cp->mems_allowed, node_states[N_HIGH_MEMORY]))
 			continue;
 
@@ -2019,7 +2019,7 @@ static void scan_for_empty_cpusets(struct cpuset *root)
 		/* Remove offline cpus and mems from this cpuset. */
 		mutex_lock(&callback_mutex);
 		cpumask_and(cp->cpus_allowed, cp->cpus_allowed,
-			    cpu_online_mask);
+			    cpu_active_mask);
 		nodes_and(cp->mems_allowed, cp->mems_allowed,
 						node_states[N_HIGH_MEMORY]);
 		mutex_unlock(&callback_mutex);
@@ -2057,8 +2057,10 @@ static int cpuset_track_online_cpus(struct notifier_block *unused_nb,
 	switch (phase) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
 		break;
 
 	default:
@@ -2067,7 +2069,7 @@ static int cpuset_track_online_cpus(struct notifier_block *unused_nb,
 
 	cgroup_lock();
 	mutex_lock(&callback_mutex);
-	cpumask_copy(top_cpuset.cpus_allowed, cpu_online_mask);
+	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
 	mutex_unlock(&callback_mutex);
 	scan_for_empty_cpusets(&top_cpuset);
 	ndoms = generate_sched_domains(&doms, &attr);
@@ -2114,7 +2116,7 @@ static int cpuset_track_online_nodes(struct notifier_block *self,
 
 void __init cpuset_init_smp(void)
 {
-	cpumask_copy(top_cpuset.cpus_allowed, cpu_online_mask);
+	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
 	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
 
 	hotcpu_notifier(cpuset_track_online_cpus, 0);
diff --git a/kernel/sched.c b/kernel/sched.c
index aa31244..bc68037 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -814,6 +814,7 @@ const_debug unsigned int sysctl_sched_nr_migrate = 32;
  * default: 0.25ms
  */
 unsigned int sysctl_sched_shares_ratelimit = 250000;
+unsigned int normalized_sysctl_sched_shares_ratelimit = 250000;
 
 /*
  * Inject some fuzzyness into changing the per-cpu group shares
@@ -1614,7 +1615,7 @@ static void update_group_shares_cpu(struct task_group *tg, int cpu,
  */
 static int tg_shares_up(struct task_group *tg, void *data)
 {
-	unsigned long weight, rq_weight = 0, shares = 0;
+	unsigned long weight, rq_weight = 0, sum_weight = 0, shares = 0;
 	unsigned long *usd_rq_weight;
 	struct sched_domain *sd = data;
 	unsigned long flags;
@@ -1630,6 +1631,7 @@ static int tg_shares_up(struct task_group *tg, void *data)
 		weight = tg->cfs_rq[i]->load.weight;
 		usd_rq_weight[i] = weight;
 
+		rq_weight += weight;
 		/*
 		 * If there are currently no tasks on the cpu pretend there
 		 * is one of average load so that when a new task gets to
@@ -1638,10 +1640,13 @@ static int tg_shares_up(struct task_group *tg, void *data)
 		if (!weight)
 			weight = NICE_0_LOAD;
 
-		rq_weight += weight;
+		sum_weight += weight;
 		shares += tg->cfs_rq[i]->shares;
 	}
 
+	if (!rq_weight)
+		rq_weight = sum_weight;
+
 	if ((!shares && rq_weight) || shares > tg->shares)
 		shares = tg->shares;
 
@@ -1810,6 +1815,22 @@ static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
 #endif
 
 static void calc_load_account_active(struct rq *this_rq);
+static void update_sysctl(void);
+static int get_update_sysctl_factor(void);
+
+static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
+{
+	set_task_rq(p, cpu);
+#ifdef CONFIG_SMP
+	/*
+	 * After ->cpu is set up to a new value, task_rq_lock(p, ...) can be
+	 * successfuly executed on another CPU. We must ensure that updates of
+	 * per-task data have been completed by this moment.
+	 */
+	smp_wmb();
+	task_thread_info(p)->cpu = cpu;
+#endif
+}
 
 #include "sched_stats.h"
 #include "sched_idletask.c"
@@ -1967,20 +1988,6 @@ inline int task_curr(const struct task_struct *p)
 	return cpu_curr(task_cpu(p)) == p;
 }
 
-static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
-{
-	set_task_rq(p, cpu);
-#ifdef CONFIG_SMP
-	/*
-	 * After ->cpu is set up to a new value, task_rq_lock(p, ...) can be
-	 * successfuly executed on another CPU. We must ensure that updates of
-	 * per-task data have been completed by this moment.
-	 */
-	smp_wmb();
-	task_thread_info(p)->cpu = cpu;
-#endif
-}
-
 static inline void check_class_changed(struct rq *rq, struct task_struct *p,
 				       const struct sched_class *prev_class,
 				       int oldprio, int running)
@@ -2060,29 +2067,13 @@ task_hot(struct task_struct *p, u64 now, struct sched_domain *sd)
 void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 {
 	int old_cpu = task_cpu(p);
-	struct rq *old_rq = cpu_rq(old_cpu), *new_rq = cpu_rq(new_cpu);
 	struct cfs_rq *old_cfsrq = task_cfs_rq(p),
 		      *new_cfsrq = cpu_cfs_rq(old_cfsrq, new_cpu);
-	u64 clock_offset;
-
-	clock_offset = old_rq->clock - new_rq->clock;
 
 	trace_sched_migrate_task(p, new_cpu);
 
-#ifdef CONFIG_SCHEDSTATS
-	if (p->se.wait_start)
-		p->se.wait_start -= clock_offset;
-	if (p->se.sleep_start)
-		p->se.sleep_start -= clock_offset;
-	if (p->se.block_start)
-		p->se.block_start -= clock_offset;
-#endif
 	if (old_cpu != new_cpu) {
 		p->se.nr_migrations++;
-#ifdef CONFIG_SCHEDSTATS
-		if (task_hot(p, old_rq->clock, NULL))
-			schedstat_inc(p, se.nr_forced2_migrations);
-#endif
 		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS,
 				     1, 1, NULL, 0);
 	}
@@ -2323,6 +2314,14 @@ void task_oncpu_function_call(struct task_struct *p,
 	preempt_enable();
 }
 
+#ifdef CONFIG_SMP
+static inline
+int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
+{
+	return p->sched_class->select_task_rq(p, sd_flags, wake_flags);
+}
+#endif
+
 /***
  * try_to_wake_up - wake up a thread
  * @p: the to-be-woken-up thread
@@ -2374,17 +2373,14 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible--;
 	p->state = TASK_WAKING;
-	task_rq_unlock(rq, &flags);
+	__task_rq_unlock(rq);
 
-	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
-	if (cpu != orig_cpu) {
-		local_irq_save(flags);
-		rq = cpu_rq(cpu);
-		update_rq_clock(rq);
+	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
+	if (cpu != orig_cpu)
 		set_task_cpu(p, cpu);
-		local_irq_restore(flags);
-	}
-	rq = task_rq_lock(p, &flags);
+
+	rq = __task_rq_lock(p);
+	update_rq_clock(rq);
 
 	WARN_ON(p->state != TASK_WAKING);
 	cpu = task_cpu(p);
@@ -2499,7 +2495,6 @@ static void __sched_fork(struct task_struct *p)
 	p->se.avg_overlap		= 0;
 	p->se.start_runtime		= 0;
 	p->se.avg_wakeup		= sysctl_sched_wakeup_granularity;
-	p->se.avg_running		= 0;
 
 #ifdef CONFIG_SCHEDSTATS
 	p->se.wait_start			= 0;
@@ -2521,7 +2516,6 @@ static void __sched_fork(struct task_struct *p)
 	p->se.nr_failed_migrations_running	= 0;
 	p->se.nr_failed_migrations_hot		= 0;
 	p->se.nr_forced_migrations		= 0;
-	p->se.nr_forced2_migrations		= 0;
 
 	p->se.nr_wakeups			= 0;
 	p->se.nr_wakeups_sync			= 0;
@@ -2558,7 +2552,6 @@ static void __sched_fork(struct task_struct *p)
 void sched_fork(struct task_struct *p, int clone_flags)
 {
 	int cpu = get_cpu();
-	unsigned long flags;
 
 	__sched_fork(p);
 
@@ -2592,13 +2585,13 @@ void sched_fork(struct task_struct *p, int clone_flags)
 	if (!rt_prio(p->prio))
 		p->sched_class = &fair_sched_class;
 
+	if (p->sched_class->task_fork)
+		p->sched_class->task_fork(p);
+
 #ifdef CONFIG_SMP
-	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_FORK, 0);
+	cpu = select_task_rq(p, SD_BALANCE_FORK, 0);
 #endif
-	local_irq_save(flags);
-	update_rq_clock(cpu_rq(cpu));
 	set_task_cpu(p, cpu);
-	local_irq_restore(flags);
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	if (likely(sched_info_on()))
@@ -2631,17 +2624,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 	rq = task_rq_lock(p, &flags);
 	BUG_ON(p->state != TASK_RUNNING);
 	update_rq_clock(rq);
-
-	if (!p->sched_class->task_new || !current->se.on_rq) {
-		activate_task(rq, p, 0);
-	} else {
-		/*
-		 * Let the scheduling class do new task startup
-		 * management (if any):
-		 */
-		p->sched_class->task_new(rq, p);
-		inc_nr_running(rq);
-	}
+	activate_task(rq, p, 0);
 	trace_sched_wakeup_new(rq, p, 1);
 	check_preempt_curr(rq, p, WF_FORK);
 #ifdef CONFIG_SMP
@@ -3156,7 +3139,7 @@ out:
 void sched_exec(void)
 {
 	int new_cpu, this_cpu = get_cpu();
-	new_cpu = current->sched_class->select_task_rq(current, SD_BALANCE_EXEC, 0);
+	new_cpu = select_task_rq(current, SD_BALANCE_EXEC, 0);
 	put_cpu();
 	if (new_cpu != this_cpu)
 		sched_migrate_task(current, new_cpu);
@@ -3172,10 +3155,6 @@ static void pull_task(struct rq *src_rq, struct task_struct *p,
 	deactivate_task(src_rq, p, 0);
 	set_task_cpu(p, this_cpu);
 	activate_task(this_rq, p, 0);
-	/*
-	 * Note that idle threads have a prio of MAX_PRIO, for this test
-	 * to be always true for them.
-	 */
 	check_preempt_curr(this_rq, p, 0);
 }
 
@@ -4134,7 +4113,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	unsigned long flags;
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
-	cpumask_copy(cpus, cpu_online_mask);
+	cpumask_copy(cpus, cpu_active_mask);
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -4297,7 +4276,7 @@ load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd)
 	int all_pinned = 0;
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
-	cpumask_copy(cpus, cpu_online_mask);
+	cpumask_copy(cpus, cpu_active_mask);
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -4694,7 +4673,7 @@ int select_nohz_load_balancer(int stop_tick)
 		cpumask_set_cpu(cpu, nohz.cpu_mask);
 
 		/* time for ilb owner also to sleep */
-		if (cpumask_weight(nohz.cpu_mask) == num_online_cpus()) {
+		if (cpumask_weight(nohz.cpu_mask) == num_active_cpus()) {
 			if (atomic_read(&nohz.load_balancer) == cpu)
 				atomic_set(&nohz.load_balancer, -1);
 			return 0;
@@ -5396,13 +5375,14 @@ static inline void schedule_debug(struct task_struct *prev)
 #endif
 }
 
-static void put_prev_task(struct rq *rq, struct task_struct *p)
+static void put_prev_task(struct rq *rq, struct task_struct *prev)
 {
-	u64 runtime = p->se.sum_exec_runtime - p->se.prev_sum_exec_runtime;
+	if (prev->state == TASK_RUNNING) {
+		u64 runtime = prev->se.sum_exec_runtime;
 
-	update_avg(&p->se.avg_running, runtime);
+		runtime -= prev->se.prev_sum_exec_runtime;
+		runtime = min_t(u64, runtime, 2*sysctl_sched_migration_cost);
 
-	if (p->state == TASK_RUNNING) {
 		/*
 		 * In order to avoid avg_overlap growing stale when we are
 		 * indeed overlapping and hence not getting put to sleep, grow
@@ -5412,12 +5392,9 @@ static void put_prev_task(struct rq *rq, struct task_struct *p)
 		 * correlates to the amount of cache footprint a task can
 		 * build up.
 		 */
-		runtime = min_t(u64, runtime, 2*sysctl_sched_migration_cost);
-		update_avg(&p->se.avg_overlap, runtime);
-	} else {
-		update_avg(&p->se.avg_running, 0);
+		update_avg(&prev->se.avg_overlap, runtime);
 	}
-	p->sched_class->put_prev_task(rq, p);
+	prev->sched_class->put_prev_task(rq, prev);
 }
 
 /*
@@ -6631,6 +6608,8 @@ SYSCALL_DEFINE3(sched_setaffinity, pid_t, pid, unsigned int, len,
 long sched_getaffinity(pid_t pid, struct cpumask *mask)
 {
 	struct task_struct *p;
+	unsigned long flags;
+	struct rq *rq;
 	int retval;
 
 	get_online_cpus();
@@ -6645,7 +6624,9 @@ long sched_getaffinity(pid_t pid, struct cpumask *mask)
 	if (retval)
 		goto out_unlock;
 
+	rq = task_rq_lock(p, &flags);
 	cpumask_and(mask, &p->cpus_allowed, cpu_online_mask);
+	task_rq_unlock(rq, &flags);
 
 out_unlock:
 	read_unlock(&tasklist_lock);
@@ -6883,6 +6864,8 @@ SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
 {
 	struct task_struct *p;
 	unsigned int time_slice;
+	unsigned long flags;
+	struct rq *rq;
 	int retval;
 	struct timespec t;
 
@@ -6899,7 +6882,9 @@ SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
 	if (retval)
 		goto out_unlock;
 
-	time_slice = p->sched_class->get_rr_interval(p);
+	rq = task_rq_lock(p, &flags);
+	time_slice = p->sched_class->get_rr_interval(rq, p);
+	task_rq_unlock(rq, &flags);
 
 	read_unlock(&tasklist_lock);
 	jiffies_to_timespec(time_slice, &t);
@@ -7000,7 +6985,6 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	__sched_fork(idle);
 	idle->se.exec_start = sched_clock();
 
-	idle->prio = idle->normal_prio = MAX_PRIO;
 	cpumask_copy(&idle->cpus_allowed, cpumask_of(cpu));
 	__set_task_cpu(idle, cpu);
 
@@ -7041,22 +7025,43 @@ cpumask_var_t nohz_cpu_mask;
  *
  * This idea comes from the SD scheduler of Con Kolivas:
  */
-static inline void sched_init_granularity(void)
+static int get_update_sysctl_factor(void)
 {
-	unsigned int factor = 1 + ilog2(num_online_cpus());
-	const unsigned long limit = 200000000;
+	unsigned int cpus = min_t(int, num_online_cpus(), 8);
+	unsigned int factor;
+
+	switch (sysctl_sched_tunable_scaling) {
+	case SCHED_TUNABLESCALING_NONE:
+		factor = 1;
+		break;
+	case SCHED_TUNABLESCALING_LINEAR:
+		factor = cpus;
+		break;
+	case SCHED_TUNABLESCALING_LOG:
+	default:
+		factor = 1 + ilog2(cpus);
+		break;
+	}
 
-	sysctl_sched_min_granularity *= factor;
-	if (sysctl_sched_min_granularity > limit)
-		sysctl_sched_min_granularity = limit;
+	return factor;
+}
 
-	sysctl_sched_latency *= factor;
-	if (sysctl_sched_latency > limit)
-		sysctl_sched_latency = limit;
+static void update_sysctl(void)
+{
+	unsigned int factor = get_update_sysctl_factor();
 
-	sysctl_sched_wakeup_granularity *= factor;
+#define SET_SYSCTL(name) \
+	(sysctl_##name = (factor) * normalized_sysctl_##name)
+	SET_SYSCTL(sched_min_granularity);
+	SET_SYSCTL(sched_latency);
+	SET_SYSCTL(sched_wakeup_granularity);
+	SET_SYSCTL(sched_shares_ratelimit);
+#undef SET_SYSCTL
+}
 
-	sysctl_sched_shares_ratelimit *= factor;
+static inline void sched_init_granularity(void)
+{
+	update_sysctl();
 }
 
 #ifdef CONFIG_SMP
@@ -7093,7 +7098,7 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 	int ret = 0;
 
 	rq = task_rq_lock(p, &flags);
-	if (!cpumask_intersects(new_mask, cpu_online_mask)) {
+	if (!cpumask_intersects(new_mask, cpu_active_mask)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -7115,7 +7120,7 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 	if (cpumask_test_cpu(task_cpu(p), new_mask))
 		goto out;
 
-	if (migrate_task(p, cpumask_any_and(cpu_online_mask, new_mask), &req)) {
+	if (migrate_task(p, cpumask_any_and(cpu_active_mask, new_mask), &req)) {
 		/* Need help from migration thread: drop lock and wait. */
 		struct task_struct *mt = rq->migration_thread;
 
@@ -7269,19 +7274,19 @@ static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 
 again:
 	/* Look for allowed, online CPU in same node. */
-	for_each_cpu_and(dest_cpu, nodemask, cpu_online_mask)
+	for_each_cpu_and(dest_cpu, nodemask, cpu_active_mask)
 		if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
 			goto move;
 
 	/* Any allowed, online CPU? */
-	dest_cpu = cpumask_any_and(&p->cpus_allowed, cpu_online_mask);
+	dest_cpu = cpumask_any_and(&p->cpus_allowed, cpu_active_mask);
 	if (dest_cpu < nr_cpu_ids)
 		goto move;
 
 	/* No more Mr. Nice Guy. */
 	if (dest_cpu >= nr_cpu_ids) {
 		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
-		dest_cpu = cpumask_any_and(cpu_online_mask, &p->cpus_allowed);
+		dest_cpu = cpumask_any_and(cpu_active_mask, &p->cpus_allowed);
 
 		/*
 		 * Don't tell them about moving exiting tasks or
@@ -7310,7 +7315,7 @@ move:
  */
 static void migrate_nr_uninterruptible(struct rq *rq_src)
 {
-	struct rq *rq_dest = cpu_rq(cpumask_any(cpu_online_mask));
+	struct rq *rq_dest = cpu_rq(cpumask_any(cpu_active_mask));
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -7564,7 +7569,7 @@ static ctl_table *sd_alloc_ctl_cpu_table(int cpu)
 static struct ctl_table_header *sd_sysctl_header;
 static void register_sched_domain_sysctl(void)
 {
-	int i, cpu_num = num_online_cpus();
+	int i, cpu_num = num_possible_cpus();
 	struct ctl_table *entry = sd_alloc_ctl_entry(cpu_num + 1);
 	char buf[32];
 
@@ -7574,7 +7579,7 @@ static void register_sched_domain_sysctl(void)
 	if (entry == NULL)
 		return;
 
-	for_each_online_cpu(i) {
+	for_each_possible_cpu(i) {
 		snprintf(buf, 32, "cpu%d", i);
 		entry->procname = kstrdup(buf, GFP_KERNEL);
 		entry->mode = 0555;
@@ -7704,7 +7709,6 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		spin_lock_irq(&rq->lock);
 		update_rq_clock(rq);
 		deactivate_task(rq, rq->idle, 0);
-		rq->idle->static_prio = MAX_PRIO;
 		__setscheduler(rq, rq->idle, SCHED_NORMAL, 0);
 		rq->idle->sched_class = &idle_sched_class;
 		migrate_dead_tasks(cpu);
@@ -9100,7 +9104,7 @@ match1:
 	if (doms_new == NULL) {
 		ndoms_cur = 0;
 		doms_new = &fallback_doms;
-		cpumask_andnot(doms_new[0], cpu_online_mask, cpu_isolated_map);
+		cpumask_andnot(doms_new[0], cpu_active_mask, cpu_isolated_map);
 		WARN_ON_ONCE(dattr_new);
 	}
 
@@ -9231,8 +9235,10 @@ static int update_sched_domains(struct notifier_block *nfb,
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
 		partition_sched_domains(1, NULL, NULL);
 		return NOTIFY_OK;
 
@@ -9279,7 +9285,7 @@ void __init sched_init_smp(void)
 #endif
 	get_online_cpus();
 	mutex_lock(&sched_domains_mutex);
-	arch_init_sched_domains(cpu_online_mask);
+	arch_init_sched_domains(cpu_active_mask);
 	cpumask_andnot(non_isolated_cpus, cpu_possible_mask, cpu_isolated_map);
 	if (cpumask_empty(non_isolated_cpus))
 		cpumask_set_cpu(smp_processor_id(), non_isolated_cpus);
@@ -9843,13 +9849,15 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 		se = kzalloc_node(sizeof(struct sched_entity),
 				  GFP_KERNEL, cpu_to_node(i));
 		if (!se)
-			goto err;
+			goto err_free_rq;
 
 		init_tg_cfs_entry(tg, cfs_rq, se, i, 0, parent->se[i]);
 	}
 
 	return 1;
 
+ err_free_rq:
+	kfree(cfs_rq);
  err:
 	return 0;
 }
@@ -9931,13 +9939,15 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 		rt_se = kzalloc_node(sizeof(struct sched_rt_entity),
 				     GFP_KERNEL, cpu_to_node(i));
 		if (!rt_se)
-			goto err;
+			goto err_free_rq;
 
 		init_tg_rt_entry(tg, rt_rq, rt_se, i, 0, parent->rt_se[i]);
 	}
 
 	return 1;
 
+ err_free_rq:
+	kfree(rt_rq);
  err:
 	return 0;
 }
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 6988cf0..5ae24fc 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -309,6 +309,12 @@ static void print_cpu(struct seq_file *m, int cpu)
 	print_rq(m, rq, cpu);
 }
 
+static const char *sched_tunable_scaling_names[] = {
+	"none",
+	"logaritmic",
+	"linear"
+};
+
 static int sched_debug_show(struct seq_file *m, void *v)
 {
 	u64 now = ktime_to_ns(ktime_get());
@@ -334,6 +340,10 @@ static int sched_debug_show(struct seq_file *m, void *v)
 #undef PN
 #undef P
 
+	SEQ_printf(m, "  .%-40s: %d (%s)\n", "sysctl_sched_tunable_scaling",
+		sysctl_sched_tunable_scaling,
+		sched_tunable_scaling_names[sysctl_sched_tunable_scaling]);
+
 	for_each_online_cpu(cpu)
 		print_cpu(m, cpu);
 
@@ -399,7 +409,6 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	PN(se.sum_exec_runtime);
 	PN(se.avg_overlap);
 	PN(se.avg_wakeup);
-	PN(se.avg_running);
 
 	nr_switches = p->nvcsw + p->nivcsw;
 
@@ -423,7 +432,6 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	P(se.nr_failed_migrations_running);
 	P(se.nr_failed_migrations_hot);
 	P(se.nr_forced_migrations);
-	P(se.nr_forced2_migrations);
 	P(se.nr_wakeups);
 	P(se.nr_wakeups_sync);
 	P(se.nr_wakeups_migrate);
@@ -499,7 +507,6 @@ void proc_sched_set_task(struct task_struct *p)
 	p->se.nr_failed_migrations_running	= 0;
 	p->se.nr_failed_migrations_hot		= 0;
 	p->se.nr_forced_migrations		= 0;
-	p->se.nr_forced2_migrations		= 0;
 	p->se.nr_wakeups			= 0;
 	p->se.nr_wakeups_sync			= 0;
 	p->se.nr_wakeups_migrate		= 0;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index f61837a..804a411 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -21,6 +21,7 @@
  */
 
 #include <linux/latencytop.h>
+#include <linux/sched.h>
 
 /*
  * Targeted preemption latency for CPU-bound tasks:
@@ -35,12 +36,26 @@
  *  run vmstat and monitor the context-switches (cs) field)
  */
 unsigned int sysctl_sched_latency = 5000000ULL;
+unsigned int normalized_sysctl_sched_latency = 5000000ULL;
+
+/*
+ * The initial- and re-scaling of tunables is configurable
+ * (default SCHED_TUNABLESCALING_LOG = *(1+ilog(ncpus))
+ *
+ * Options are:
+ * SCHED_TUNABLESCALING_NONE - unscaled, always *1
+ * SCHED_TUNABLESCALING_LOG - scaled logarithmical, *1+ilog(ncpus)
+ * SCHED_TUNABLESCALING_LINEAR - scaled linear, *ncpus
+ */
+enum sched_tunable_scaling sysctl_sched_tunable_scaling
+	= SCHED_TUNABLESCALING_LOG;
 
 /*
  * Minimal preemption granularity for CPU-bound tasks:
  * (default: 1 msec * (1 + ilog(ncpus)), units: nanoseconds)
  */
 unsigned int sysctl_sched_min_granularity = 1000000ULL;
+unsigned int normalized_sysctl_sched_min_granularity = 1000000ULL;
 
 /*
  * is kept at sysctl_sched_latency / sysctl_sched_min_granularity
@@ -70,6 +85,7 @@ unsigned int __read_mostly sysctl_sched_compat_yield;
  * have immediate wakeup/sleep latencies.
  */
 unsigned int sysctl_sched_wakeup_granularity = 1000000UL;
+unsigned int normalized_sysctl_sched_wakeup_granularity = 1000000UL;
 
 const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
 
@@ -383,11 +399,12 @@ static struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
  */
 
 #ifdef CONFIG_SCHED_DEBUG
-int sched_nr_latency_handler(struct ctl_table *table, int write,
+int sched_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos)
 {
 	int ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	int factor = get_update_sysctl_factor();
 
 	if (ret || !write)
 		return ret;
@@ -395,6 +412,14 @@ int sched_nr_latency_handler(struct ctl_table *table, int write,
 	sched_nr_latency = DIV_ROUND_UP(sysctl_sched_latency,
 					sysctl_sched_min_granularity);
 
+#define WRT_SYSCTL(name) \
+	(normalized_sysctl_##name = sysctl_##name / (factor))
+	WRT_SYSCTL(sched_min_granularity);
+	WRT_SYSCTL(sched_latency);
+	WRT_SYSCTL(sched_wakeup_granularity);
+	WRT_SYSCTL(sched_shares_ratelimit);
+#undef WRT_SYSCTL
+
 	return 0;
 }
 #endif
@@ -1403,7 +1428,6 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 		new_cpu = prev_cpu;
 	}
 
-	rcu_read_lock();
 	for_each_domain(cpu, tmp) {
 		/*
 		 * If power savings logic is enabled for a domain, see if we
@@ -1484,10 +1508,8 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 			update_shares(tmp);
 	}
 
-	if (affine_sd && wake_affine(affine_sd, p, sync)) {
-		new_cpu = cpu;
-		goto out;
-	}
+	if (affine_sd && wake_affine(affine_sd, p, sync))
+		return cpu;
 
 	while (sd) {
 		int load_idx = sd->forkexec_idx;
@@ -1528,8 +1550,6 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 		/* while loop will break here if sd == NULL */
 	}
 
-out:
-	rcu_read_unlock();
 	return new_cpu;
 }
 #endif /* CONFIG_SMP */
@@ -1651,12 +1671,8 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	int sync = wake_flags & WF_SYNC;
 	int scale = cfs_rq->nr_running >= sched_nr_latency;
 
-	update_curr(cfs_rq);
-
-	if (unlikely(rt_prio(p->prio))) {
-		resched_task(curr);
-		return;
-	}
+	if (unlikely(rt_prio(p->prio)))
+		goto preempt;
 
 	if (unlikely(p->sched_class != &fair_sched_class))
 		return;
@@ -1682,50 +1698,44 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 		return;
 
 	/* Idle tasks are by definition preempted by everybody. */
-	if (unlikely(curr->policy == SCHED_IDLE)) {
-		resched_task(curr);
-		return;
-	}
+	if (unlikely(curr->policy == SCHED_IDLE))
+		goto preempt;
 
-	if ((sched_feat(WAKEUP_SYNC) && sync) ||
-	    (sched_feat(WAKEUP_OVERLAP) &&
-	     (se->avg_overlap < sysctl_sched_migration_cost &&
-	      pse->avg_overlap < sysctl_sched_migration_cost))) {
-		resched_task(curr);
-		return;
-	}
+	if (sched_feat(WAKEUP_SYNC) && sync)
+		goto preempt;
 
-	if (sched_feat(WAKEUP_RUNNING)) {
-		if (pse->avg_running < se->avg_running) {
-			set_next_buddy(pse);
-			resched_task(curr);
-			return;
-		}
-	}
+	if (sched_feat(WAKEUP_OVERLAP) &&
+			se->avg_overlap < sysctl_sched_migration_cost &&
+			pse->avg_overlap < sysctl_sched_migration_cost)
+		goto preempt;
 
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
+	update_curr(cfs_rq);
 	find_matching_se(&se, &pse);
-
 	BUG_ON(!pse);
+	if (wakeup_preempt_entity(se, pse) == 1)
+		goto preempt;
 
-	if (wakeup_preempt_entity(se, pse) == 1) {
-		resched_task(curr);
-		/*
-		 * Only set the backward buddy when the current task is still
-		 * on the rq. This can happen when a wakeup gets interleaved
-		 * with schedule on the ->pre_schedule() or idle_balance()
-		 * point, either of which can * drop the rq lock.
-		 *
-		 * Also, during early boot the idle thread is in the fair class,
-		 * for obvious reasons its a bad idea to schedule back to it.
-		 */
-		if (unlikely(!se->on_rq || curr == rq->idle))
-			return;
-		if (sched_feat(LAST_BUDDY) && scale && entity_is_task(se))
-			set_last_buddy(se);
-	}
+	return;
+
+preempt:
+	resched_task(curr);
+	/*
+	 * Only set the backward buddy when the current task is still
+	 * on the rq. This can happen when a wakeup gets interleaved
+	 * with schedule on the ->pre_schedule() or idle_balance()
+	 * point, either of which can * drop the rq lock.
+	 *
+	 * Also, during early boot the idle thread is in the fair class,
+	 * for obvious reasons its a bad idea to schedule back to it.
+	 */
+	if (unlikely(!se->on_rq || curr == rq->idle))
+		return;
+
+	if (sched_feat(LAST_BUDDY) && scale && entity_is_task(se))
+		set_last_buddy(se);
 }
 
 static struct task_struct *pick_next_task_fair(struct rq *rq)
@@ -1905,6 +1915,17 @@ move_one_task_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 
 	return 0;
 }
+
+static void rq_online_fair(struct rq *rq)
+{
+	update_sysctl();
+}
+
+static void rq_offline_fair(struct rq *rq)
+{
+	update_sysctl();
+}
+
 #endif /* CONFIG_SMP */
 
 /*
@@ -1922,28 +1943,30 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 }
 
 /*
- * Share the fairness runtime between parent and child, thus the
- * total amount of pressure for CPU stays equal - new tasks
- * get a chance to run but frequent forkers are not allowed to
- * monopolize the CPU. Note: the parent runqueue is locked,
- * the child is not running yet.
+ * called on fork with the child task as argument from the parent's context
+ *  - child not yet on the tasklist
+ *  - preemption disabled
  */
-static void task_new_fair(struct rq *rq, struct task_struct *p)
+static void task_fork_fair(struct task_struct *p)
 {
-	struct cfs_rq *cfs_rq = task_cfs_rq(p);
+	struct cfs_rq *cfs_rq = task_cfs_rq(current);
 	struct sched_entity *se = &p->se, *curr = cfs_rq->curr;
 	int this_cpu = smp_processor_id();
+	struct rq *rq = this_rq();
+	unsigned long flags;
+
+	spin_lock_irqsave(&rq->lock, flags);
 
-	sched_info_queued(p);
+	if (unlikely(task_cpu(p) != this_cpu))
+		__set_task_cpu(p, this_cpu);
 
 	update_curr(cfs_rq);
+
 	if (curr)
 		se->vruntime = curr->vruntime;
 	place_entity(cfs_rq, se, 1);
 
-	/* 'curr' will be NULL if the child belongs to a different group */
-	if (sysctl_sched_child_runs_first && this_cpu == task_cpu(p) &&
-			curr && entity_before(curr, se)) {
+	if (sysctl_sched_child_runs_first && curr && entity_before(curr, se)) {
 		/*
 		 * Upon rescheduling, sched_class::put_prev_task() will place
 		 * 'current' within the tree based on its new key value.
@@ -1952,7 +1975,7 @@ static void task_new_fair(struct rq *rq, struct task_struct *p)
 		resched_task(rq->curr);
 	}
 
-	enqueue_task_fair(rq, p, 0);
+	spin_unlock_irqrestore(&rq->lock, flags);
 }
 
 /*
@@ -2014,21 +2037,17 @@ static void moved_group_fair(struct task_struct *p)
 }
 #endif
 
-unsigned int get_rr_interval_fair(struct task_struct *task)
+unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task)
 {
 	struct sched_entity *se = &task->se;
-	unsigned long flags;
-	struct rq *rq;
 	unsigned int rr_interval = 0;
 
 	/*
 	 * Time slice is 0 for SCHED_OTHER tasks that are on an otherwise
 	 * idle runqueue:
 	 */
-	rq = task_rq_lock(task, &flags);
 	if (rq->cfs.load.weight)
 		rr_interval = NS_TO_JIFFIES(sched_slice(&rq->cfs, se));
-	task_rq_unlock(rq, &flags);
 
 	return rr_interval;
 }
@@ -2052,11 +2071,13 @@ static const struct sched_class fair_sched_class = {
 
 	.load_balance		= load_balance_fair,
 	.move_one_task		= move_one_task_fair,
+	.rq_online		= rq_online_fair,
+	.rq_offline		= rq_offline_fair,
 #endif
 
 	.set_curr_task          = set_curr_task_fair,
 	.task_tick		= task_tick_fair,
-	.task_new		= task_new_fair,
+	.task_fork		= task_fork_fair,
 
 	.prio_changed		= prio_changed_fair,
 	.switched_to		= switched_to_fair,
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 0d94083..d5059fd 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -54,11 +54,6 @@ SCHED_FEAT(WAKEUP_SYNC, 0)
 SCHED_FEAT(WAKEUP_OVERLAP, 0)
 
 /*
- * Wakeup preemption towards tasks that run short
- */
-SCHED_FEAT(WAKEUP_RUNNING, 0)
-
-/*
  * Use the SYNC wakeup hint, pipes and the likes use this to indicate
  * the remote end is likely to consume the data we just wrote, and
  * therefore has cache benefit from being placed on the same cpu, see
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index b133a28..33d5384 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -97,7 +97,7 @@ static void prio_changed_idle(struct rq *rq, struct task_struct *p,
 		check_preempt_curr(rq, p, 0);
 }
 
-unsigned int get_rr_interval_idle(struct task_struct *task)
+unsigned int get_rr_interval_idle(struct rq *rq, struct task_struct *task)
 {
 	return 0;
 }
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 5c5fef3..aecbd9c 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1721,7 +1721,7 @@ static void set_curr_task_rt(struct rq *rq)
 	dequeue_pushable_task(rq, p);
 }
 
-unsigned int get_rr_interval_rt(struct task_struct *task)
+unsigned int get_rr_interval_rt(struct rq *rq, struct task_struct *task)
 {
 	/*
 	 * Time slice is 0 for SCHED_FIFO tasks
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4dbf93a..b9e5a45 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -251,6 +251,10 @@ static int min_sched_granularity_ns = 100000;		/* 100 usecs */
 static int max_sched_granularity_ns = NSEC_PER_SEC;	/* 1 second */
 static int min_wakeup_granularity_ns;			/* 0 usecs */
 static int max_wakeup_granularity_ns = NSEC_PER_SEC;	/* 1 second */
+static int min_sched_tunable_scaling = SCHED_TUNABLESCALING_NONE;
+static int max_sched_tunable_scaling = SCHED_TUNABLESCALING_END-1;
+static int min_sched_shares_ratelimit = 100000; /* 100 usec */
+static int max_sched_shares_ratelimit = NSEC_PER_SEC; /* 1 second */
 #endif
 
 static struct ctl_table kern_table[] = {
@@ -269,7 +273,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_min_granularity,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &sched_nr_latency_handler,
+		.proc_handler	= &sched_proc_update_handler,
 		.strategy	= &sysctl_intvec,
 		.extra1		= &min_sched_granularity_ns,
 		.extra2		= &max_sched_granularity_ns,
@@ -280,7 +284,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_latency,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &sched_nr_latency_handler,
+		.proc_handler	= &sched_proc_update_handler,
 		.strategy	= &sysctl_intvec,
 		.extra1		= &min_sched_granularity_ns,
 		.extra2		= &max_sched_granularity_ns,
@@ -291,7 +295,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_wakeup_granularity,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= &sched_proc_update_handler,
 		.strategy	= &sysctl_intvec,
 		.extra1		= &min_wakeup_granularity_ns,
 		.extra2		= &max_wakeup_granularity_ns,
@@ -302,25 +306,31 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_shares_ratelimit,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= &sched_proc_update_handler,
+		.extra1		= &min_sched_shares_ratelimit,
+		.extra2		= &max_sched_shares_ratelimit,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_shares_thresh",
-		.data		= &sysctl_sched_shares_thresh,
-		.maxlen		= sizeof(unsigned int),
+		.procname	= "sched_tunable_scaling",
+		.data		= &sysctl_sched_tunable_scaling,
+		.maxlen		= sizeof(enum sched_tunable_scaling),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= &sched_proc_update_handler,
 		.strategy	= &sysctl_intvec,
-		.extra1		= &zero,
+		.extra1		= &min_sched_tunable_scaling,
+		.extra2		= &max_sched_tunable_scaling,
 	},
+
 	{
 		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_features",
-		.data		= &sysctl_sched_features,
+		.procname	= "sched_shares_thresh",
+		.data		= &sysctl_sched_shares_thresh,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
