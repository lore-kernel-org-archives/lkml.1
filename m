Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbYKXQJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbYKXQJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 11:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbYKXQJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 11:09:14 -0500
Received: from ozlabs.org ([203.10.76.45]:60417 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbYKXQJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 11:09:09 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PULL] cpumask conversion patches for sched
Date: Tue, 25 Nov 2008 02:38:53 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811250238.53883.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

   Keeping track of sched.c changes without breaking linux-next has
proven impossible, so I've split the sched patches out for you, split
them nicely, and rebased against your linux-2.6-sched.  Please pull.

   Works for me (with and without CONFIG_CPUMASK_OFFSTACK), but
there are a large number of config variations possible that I might
have broken.  Not to mention outright bugs.

The following changes since commit b27fef5b222564b6e7ae71f7110c233b2fb45a38:
  Ingo Molnar (1):
        Merge branch 'x86/defconfig'

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-ingo.git master

Mike Travis (1):
      sched: Reduce stack size requirements in kernel/sched.c

Rusty Russell (20):
      sched: convert sched.c from for_each_cpu_mask to for_each_cpu.
      sched: get rid of boutique sched.c allocations, use cpumask_var_t.
      sched: remove any_online_cpu()
      sched: wrap sched_group and sched_domain cpumask accesses.
      sched: convert struct sched_group/sched_domain cpumask_ts to variable bitmaps
      sched: convert nohz_cpu_mask to cpumask_var_t.
      sched: convert struct root_domain to cpumask_var_t.
      sched: convert nohz struct to cpumask_var_t.
      sched: convert idle_balance() to cpumask_var_t.
      sched: convert rebalance_domains() to cpumask_var_t.
      sched: convert sys_sched_getaffinity() to cpumask_var_t.
      sched: avoid stack var in move_task_off_dead_cpu
      sched: convert struct (sys_)sched_setaffinity() to cpumask_var_t.
      sched: convert sched_domain_debug to cpumask_var_t.
      sched: convert cpu_isolated_map to cpumask_var_t.
      sched: convert falback_doms to cpumask_var_t.
      sched: convert struct cpupri_vec cpumask_var_t.
      sched: convert check_preempt_equal_prio to cpumask_var_t.
      sched: convert local_cpu_mask to cpumask_var_t.
      sched: convert remaining old-style cpumask operators

 include/linux/sched.h    |   35 ++-
 kernel/rcuclassic.c      |    2 +-
 kernel/sched.c           |  885 +++++++++++++++++++++++++---------------------
 kernel/sched_cpupri.c    |   39 ++-
 kernel/sched_cpupri.h    |    5 +-
 kernel/sched_fair.c      |   14 +-
 kernel/sched_rt.c        |   73 +++--
 kernel/sched_stats.h     |    3 +-
 kernel/time/tick-sched.c |   10 +-
 9 files changed, 589 insertions(+), 477 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e22cb72..e51da83 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -249,7 +249,7 @@ extern void init_idle_bootup_task(struct task_struct *idle);
 extern int runqueue_is_locked(void);
 extern void task_rq_unlock_wait(struct task_struct *p);
 
-extern cpumask_t nohz_cpu_mask;
+extern cpumask_var_t nohz_cpu_mask;
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
 extern int select_nohz_load_balancer(int cpu);
 #else
@@ -771,7 +771,6 @@ enum cpu_idle_type {
 
 struct sched_group {
 	struct sched_group *next;	/* Must be a circular list */
-	cpumask_t cpumask;
 
 	/*
 	 * CPU power of this group, SCHED_LOAD_SCALE being max power for a
@@ -784,8 +783,15 @@ struct sched_group {
 	 * (see include/linux/reciprocal_div.h)
 	 */
 	u32 reciprocal_cpu_power;
+
+	unsigned long cpumask[];
 };
 
+static inline struct cpumask *sched_group_cpus(struct sched_group *sg)
+{
+	return to_cpumask(sg->cpumask);
+}
+
 enum sched_domain_level {
 	SD_LV_NONE = 0,
 	SD_LV_SIBLING,
@@ -809,7 +815,6 @@ struct sched_domain {
 	struct sched_domain *parent;	/* top domain must be null terminated */
 	struct sched_domain *child;	/* bottom domain must be null terminated */
 	struct sched_group *groups;	/* the balancing groups of the domain */
-	cpumask_t span;			/* span of all CPUs in this domain */
 	unsigned long min_interval;	/* Minimum balance interval ms */
 	unsigned long max_interval;	/* Maximum balance interval ms */
 	unsigned int busy_factor;	/* less balancing by factor if busy */
@@ -864,9 +869,17 @@ struct sched_domain {
 #ifdef CONFIG_SCHED_DEBUG
 	char *name;
 #endif
+
+	/* span of all CPUs in this domain */
+	unsigned long span[];
 };
 
-extern void partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
+static inline struct cpumask *sched_domain_span(struct sched_domain *sd)
+{
+	return to_cpumask(sd->span);
+}
+
+extern void partition_sched_domains(int ndoms_new, struct cpumask *doms_new,
 				    struct sched_domain_attr *dattr_new);
 extern int arch_reinit_sched_domains(void);
 
@@ -875,7 +888,7 @@ extern int arch_reinit_sched_domains(void);
 struct sched_domain_attr;
 
 static inline void
-partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
+partition_sched_domains(int ndoms_new, struct cpumask *doms_new,
 			struct sched_domain_attr *dattr_new)
 {
 }
@@ -957,7 +970,7 @@ struct sched_class {
 	void (*task_wake_up) (struct rq *this_rq, struct task_struct *task);
 
 	void (*set_cpus_allowed)(struct task_struct *p,
-				 const cpumask_t *newmask);
+				 const struct cpumask *newmask);
 
 	void (*rq_online)(struct rq *rq);
 	void (*rq_offline)(struct rq *rq);
@@ -1598,12 +1611,12 @@ extern cputime_t task_gtime(struct task_struct *p);
 
 #ifdef CONFIG_SMP
 extern int set_cpus_allowed_ptr(struct task_struct *p,
-				const cpumask_t *new_mask);
+				const struct cpumask *new_mask);
 #else
 static inline int set_cpus_allowed_ptr(struct task_struct *p,
-				       const cpumask_t *new_mask)
+				       const struct cpumask *new_mask)
 {
-	if (!cpu_isset(0, *new_mask))
+	if (!cpumask_test_cpu(0, new_mask))
 		return -EINVAL;
 	return 0;
 }
@@ -2229,8 +2242,8 @@ __trace_special(void *__tr, void *__data,
 }
 #endif
 
-extern long sched_setaffinity(pid_t pid, const cpumask_t *new_mask);
-extern long sched_getaffinity(pid_t pid, cpumask_t *mask);
+extern long sched_setaffinity(pid_t pid, const struct cpumask *new_mask);
+extern long sched_getaffinity(pid_t pid, struct cpumask *mask);
 
 extern int sched_mc_power_savings, sched_smt_power_savings;
 
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index e503a00..c03ca3e 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -393,7 +393,7 @@ static void rcu_start_batch(struct rcu_ctrlblk *rcp)
 		 * unnecessarily.
 		 */
 		smp_mb();
-		cpus_andnot(rcp->cpumask, cpu_online_map, nohz_cpu_mask);
+		cpumask_andnot(&rcp->cpumask, cpu_online_mask, nohz_cpu_mask);
 
 		rcp->signaled = 0;
 	}
diff --git a/kernel/sched.c b/kernel/sched.c
index f6d6ea3..92a35c0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -487,14 +487,14 @@ struct rt_rq {
  */
 struct root_domain {
 	atomic_t refcount;
-	cpumask_t span;
-	cpumask_t online;
+	cpumask_var_t span;
+	cpumask_var_t online;
 
 	/*
 	 * The "RT overload" flag: it gets set if a CPU has more than
 	 * one runnable RT task.
 	 */
-	cpumask_t rto_mask;
+	cpumask_var_t rto_mask;
 	atomic_t rto_count;
 #ifdef CONFIG_SMP
 	struct cpupri cpupri;
@@ -1501,7 +1501,7 @@ static int tg_shares_up(struct task_group *tg, void *data)
 	struct sched_domain *sd = data;
 	int i;
 
-	for_each_cpu_mask(i, sd->span) {
+	for_each_cpu(i, sched_domain_span(sd)) {
 		/*
 		 * If there are currently no tasks on the cpu pretend there
 		 * is one of average load so that when a new task gets to
@@ -1522,7 +1522,7 @@ static int tg_shares_up(struct task_group *tg, void *data)
 	if (!sd->parent || !(sd->parent->flags & SD_LOAD_BALANCE))
 		shares = tg->shares;
 
-	for_each_cpu_mask(i, sd->span)
+	for_each_cpu(i, sched_domain_span(sd))
 		update_group_shares_cpu(tg, i, shares, rq_weight);
 
 	return 0;
@@ -2053,15 +2053,17 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int 
this_cpu)
 		int i;
 
 		/* Skip over this group if it has no CPUs allowed */
-		if (!cpus_intersects(group->cpumask, p->cpus_allowed))
+		if (!cpumask_intersects(sched_group_cpus(group),
+					&p->cpus_allowed))
 			continue;
 
-		local_group = cpu_isset(this_cpu, group->cpumask);
+		local_group = cpumask_test_cpu(this_cpu,
+					       sched_group_cpus(group));
 
 		/* Tally up the load of all CPUs in the group */
 		avg_load = 0;
 
-		for_each_cpu_mask_nr(i, group->cpumask) {
+		for_each_cpu(i, sched_group_cpus(group)) {
 			/* Bias balancing toward cpus of our domain */
 			if (local_group)
 				load = source_load(i, load_idx);
@@ -2093,17 +2095,14 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int 
this_cpu)
  * find_idlest_cpu - find the idlest cpu among the cpus in group.
  */
 static int
-find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu,
-		cpumask_t *tmp)
+find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 {
 	unsigned long load, min_load = ULONG_MAX;
 	int idlest = -1;
 	int i;
 
 	/* Traverse only the allowed CPUs */
-	cpus_and(*tmp, group->cpumask, p->cpus_allowed);
-
-	for_each_cpu_mask_nr(i, *tmp) {
+	for_each_cpu_and(i, sched_group_cpus(group), &p->cpus_allowed) {
 		load = weighted_cpuload(i);
 
 		if (load < min_load || (load == min_load && i == this_cpu)) {
@@ -2145,7 +2144,6 @@ static int sched_balance_self(int cpu, int flag)
 		update_shares(sd);
 
 	while (sd) {
-		cpumask_t span, tmpmask;
 		struct sched_group *group;
 		int new_cpu, weight;
 
@@ -2154,14 +2152,13 @@ static int sched_balance_self(int cpu, int flag)
 			continue;
 		}
 
-		span = sd->span;
 		group = find_idlest_group(sd, t, cpu);
 		if (!group) {
 			sd = sd->child;
 			continue;
 		}
 
-		new_cpu = find_idlest_cpu(group, t, cpu, &tmpmask);
+		new_cpu = find_idlest_cpu(group, t, cpu);
 		if (new_cpu == -1 || new_cpu == cpu) {
 			/* Now try balancing at a lower domain level of cpu */
 			sd = sd->child;
@@ -2170,10 +2167,10 @@ static int sched_balance_self(int cpu, int flag)
 
 		/* Now try balancing at a lower domain level of new_cpu */
 		cpu = new_cpu;
+		weight = cpumask_weight(sched_domain_span(sd));
 		sd = NULL;
-		weight = cpus_weight(span);
 		for_each_domain(cpu, tmp) {
-			if (weight <= cpus_weight(tmp->span))
+			if (weight <= cpumask_weight(sched_domain_span(tmp)))
 				break;
 			if (tmp->flags & flag)
 				sd = tmp;
@@ -2218,7 +2215,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, 
int sync)
 		cpu = task_cpu(p);
 
 		for_each_domain(this_cpu, sd) {
-			if (cpu_isset(cpu, sd->span)) {
+			if (cpumask_test_cpu(cpu, sched_domain_span(sd))) {
 				update_shares(sd);
 				break;
 			}
@@ -2266,7 +2263,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, 
int sync)
 	else {
 		struct sched_domain *sd;
 		for_each_domain(this_cpu, sd) {
-			if (cpu_isset(cpu, sd->span)) {
+			if (cpumask_test_cpu(cpu, sched_domain_span(sd))) {
 				schedstat_inc(sd, ttwu_wake_remote);
 				break;
 			}
@@ -2832,7 +2829,7 @@ static void sched_migrate_task(struct task_struct *p, int dest_cpu)
 	struct rq *rq;
 
 	rq = task_rq_lock(p, &flags);
-	if (!cpu_isset(dest_cpu, p->cpus_allowed)
+	if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed)
 	    || unlikely(!cpu_active(dest_cpu)))
 		goto out;
 
@@ -2898,7 +2895,7 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int 
this_cpu,
 	 * 2) cannot be migrated to this CPU due to cpus_allowed, or
 	 * 3) are cache-hot on their current CPU.
 	 */
-	if (!cpu_isset(this_cpu, p->cpus_allowed)) {
+	if (!cpumask_test_cpu(this_cpu, &p->cpus_allowed)) {
 		schedstat_inc(p, se.nr_failed_migrations_affine);
 		return 0;
 	}
@@ -3073,7 +3070,7 @@ static int move_one_task(struct rq *this_rq, int this_cpu, struct rq 
*busiest,
 static struct sched_group *
 find_busiest_group(struct sched_domain *sd, int this_cpu,
 		   unsigned long *imbalance, enum cpu_idle_type idle,
-		   int *sd_idle, const cpumask_t *cpus, int *balance)
+		   int *sd_idle, const struct cpumask *cpus, int *balance)
 {
 	struct sched_group *busiest = NULL, *this = NULL, *group = sd->groups;
 	unsigned long max_load, avg_load, total_load, this_load, total_pwr;
@@ -3109,10 +3106,11 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		unsigned long sum_avg_load_per_task;
 		unsigned long avg_load_per_task;
 
-		local_group = cpu_isset(this_cpu, group->cpumask);
+		local_group = cpumask_test_cpu(this_cpu,
+					       sched_group_cpus(group));
 
 		if (local_group)
-			balance_cpu = first_cpu(group->cpumask);
+			balance_cpu = cpumask_first(sched_group_cpus(group));
 
 		/* Tally up the load of all CPUs in the group */
 		sum_weighted_load = sum_nr_running = avg_load = 0;
@@ -3121,13 +3119,8 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		max_cpu_load = 0;
 		min_cpu_load = ~0UL;
 
-		for_each_cpu_mask_nr(i, group->cpumask) {
-			struct rq *rq;
-
-			if (!cpu_isset(i, *cpus))
-				continue;
-
-			rq = cpu_rq(i);
+		for_each_cpu_and(i, sched_group_cpus(group), cpus) {
+			struct rq *rq = cpu_rq(i);
 
 			if (*sd_idle && rq->nr_running)
 				*sd_idle = 0;
@@ -3238,8 +3231,8 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		 */
 		if ((sum_nr_running < min_nr_running) ||
 		    (sum_nr_running == min_nr_running &&
-		     first_cpu(group->cpumask) <
-		     first_cpu(group_min->cpumask))) {
+		     cpumask_first(sched_group_cpus(group)) <
+		     cpumask_first(sched_group_cpus(group_min)))) {
 			group_min = group;
 			min_nr_running = sum_nr_running;
 			min_load_per_task = sum_weighted_load /
@@ -3254,8 +3247,8 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		if (sum_nr_running <= group_capacity - 1) {
 			if (sum_nr_running > leader_nr_running ||
 			    (sum_nr_running == leader_nr_running &&
-			     first_cpu(group->cpumask) >
-			      first_cpu(group_leader->cpumask))) {
+			     cpumask_first(sched_group_cpus(group)) >
+			     cpumask_first(sched_group_cpus(group_leader)))) {
 				group_leader = group;
 				leader_nr_running = sum_nr_running;
 			}
@@ -3394,16 +3387,16 @@ ret:
  */
 static struct rq *
 find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
-		   unsigned long imbalance, const cpumask_t *cpus)
+		   unsigned long imbalance, const struct cpumask *cpus)
 {
 	struct rq *busiest = NULL, *rq;
 	unsigned long max_load = 0;
 	int i;
 
-	for_each_cpu_mask_nr(i, group->cpumask) {
+	for_each_cpu(i, sched_group_cpus(group)) {
 		unsigned long wl;
 
-		if (!cpu_isset(i, *cpus))
+		if (!cpumask_test_cpu(i, cpus))
 			continue;
 
 		rq = cpu_rq(i);
@@ -3433,7 +3426,7 @@ find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
  */
 static int load_balance(int this_cpu, struct rq *this_rq,
 			struct sched_domain *sd, enum cpu_idle_type idle,
-			int *balance, cpumask_t *cpus)
+			int *balance, struct cpumask *cpus)
 {
 	int ld_moved, all_pinned = 0, active_balance = 0, sd_idle = 0;
 	struct sched_group *group;
@@ -3441,7 +3434,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	struct rq *busiest;
 	unsigned long flags;
 
-	cpus_setall(*cpus);
+	cpumask_setall(cpus);
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -3501,8 +3494,8 @@ redo:
 
 		/* All tasks on this runqueue were pinned by CPU affinity */
 		if (unlikely(all_pinned)) {
-			cpu_clear(cpu_of(busiest), *cpus);
-			if (!cpus_empty(*cpus))
+			cpumask_clear_cpu(cpu_of(busiest), cpus);
+			if (!cpumask_empty(cpus))
 				goto redo;
 			goto out_balanced;
 		}
@@ -3519,7 +3512,8 @@ redo:
 			/* don't kick the migration_thread, if the curr
 			 * task on busiest cpu can't be moved to this_cpu
 			 */
-			if (!cpu_isset(this_cpu, busiest->curr->cpus_allowed)) {
+			if (!cpumask_test_cpu(this_cpu,
+					      &busiest->curr->cpus_allowed)) {
 				spin_unlock_irqrestore(&busiest->lock, flags);
 				all_pinned = 1;
 				goto out_one_pinned;
@@ -3594,7 +3588,7 @@ out:
  */
 static int
 load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd,
-			cpumask_t *cpus)
+			struct cpumask *cpus)
 {
 	struct sched_group *group;
 	struct rq *busiest = NULL;
@@ -3603,7 +3597,7 @@ load_balance_newidle(int this_cpu, struct rq *this_rq, struct 
sched_domain *sd,
 	int sd_idle = 0;
 	int all_pinned = 0;
 
-	cpus_setall(*cpus);
+	cpumask_setall(cpus);
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -3647,8 +3641,8 @@ redo:
 		double_unlock_balance(this_rq, busiest);
 
 		if (unlikely(all_pinned)) {
-			cpu_clear(cpu_of(busiest), *cpus);
-			if (!cpus_empty(*cpus))
+			cpumask_clear_cpu(cpu_of(busiest), cpus);
+			if (!cpumask_empty(cpus))
 				goto redo;
 		}
 	}
@@ -3683,7 +3677,10 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 	struct sched_domain *sd;
 	int pulled_task = -1;
 	unsigned long next_balance = jiffies + HZ;
-	cpumask_t tmpmask;
+	cpumask_var_t tmpmask;
+
+	if (!alloc_cpumask_var(&tmpmask, GFP_ATOMIC))
+		return;
 
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
@@ -3694,7 +3691,7 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 		if (sd->flags & SD_BALANCE_NEWIDLE)
 			/* If we've pulled tasks over stop searching: */
 			pulled_task = load_balance_newidle(this_cpu, this_rq,
-							   sd, &tmpmask);
+							   sd, tmpmask);
 
 		interval = msecs_to_jiffies(sd->balance_interval);
 		if (time_after(next_balance, sd->last_balance + interval))
@@ -3709,6 +3706,7 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 		 */
 		this_rq->next_balance = next_balance;
 	}
+	free_cpumask_var(tmpmask);
 }
 
 /*
@@ -3746,7 +3744,7 @@ static void active_load_balance(struct rq *busiest_rq, int busiest_cpu)
 	/* Search for an sd spanning us and the target CPU. */
 	for_each_domain(target_cpu, sd) {
 		if ((sd->flags & SD_LOAD_BALANCE) &&
-		    cpu_isset(busiest_cpu, sd->span))
+		    cpumask_test_cpu(busiest_cpu, sched_domain_span(sd)))
 				break;
 	}
 
@@ -3765,10 +3763,9 @@ static void active_load_balance(struct rq *busiest_rq, int 
busiest_cpu)
 #ifdef CONFIG_NO_HZ
 static struct {
 	atomic_t load_balancer;
-	cpumask_t cpu_mask;
+	cpumask_var_t cpu_mask;
 } nohz ____cacheline_aligned = {
 	.load_balancer = ATOMIC_INIT(-1),
-	.cpu_mask = CPU_MASK_NONE,
 };
 
 /*
@@ -3796,7 +3793,7 @@ int select_nohz_load_balancer(int stop_tick)
 	int cpu = smp_processor_id();
 
 	if (stop_tick) {
-		cpu_set(cpu, nohz.cpu_mask);
+		cpumask_set_cpu(cpu, nohz.cpu_mask);
 		cpu_rq(cpu)->in_nohz_recently = 1;
 
 		/*
@@ -3810,7 +3807,7 @@ int select_nohz_load_balancer(int stop_tick)
 		}
 
 		/* time for ilb owner also to sleep */
-		if (cpus_weight(nohz.cpu_mask) == num_online_cpus()) {
+		if (cpumask_weight(nohz.cpu_mask) == num_online_cpus()) {
 			if (atomic_read(&nohz.load_balancer) == cpu)
 				atomic_set(&nohz.load_balancer, -1);
 			return 0;
@@ -3823,10 +3820,10 @@ int select_nohz_load_balancer(int stop_tick)
 		} else if (atomic_read(&nohz.load_balancer) == cpu)
 			return 1;
 	} else {
-		if (!cpu_isset(cpu, nohz.cpu_mask))
+		if (!cpumask_test_cpu(cpu, nohz.cpu_mask))
 			return 0;
 
-		cpu_clear(cpu, nohz.cpu_mask);
+		cpumask_clear_cpu(cpu, nohz.cpu_mask);
 
 		if (atomic_read(&nohz.load_balancer) == cpu)
 			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
@@ -3854,7 +3851,11 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 	unsigned long next_balance = jiffies + 60*HZ;
 	int update_next_balance = 0;
 	int need_serialize;
-	cpumask_t tmp;
+	cpumask_var_t tmp;
+
+	/* Fails alloc?  Rebalancing probably not a priority right now. */
+	if (!alloc_cpumask_var(&tmp, GFP_ATOMIC))
+		return;
 
 	for_each_domain(cpu, sd) {
 		if (!(sd->flags & SD_LOAD_BALANCE))
@@ -3879,7 +3880,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 		}
 
 		if (time_after_eq(jiffies, sd->last_balance + interval)) {
-			if (load_balance(cpu, rq, sd, idle, &balance, &tmp)) {
+			if (load_balance(cpu, rq, sd, idle, &balance, tmp)) {
 				/*
 				 * We've pulled tasks over so either we're no
 				 * longer idle, or one of our SMT siblings is
@@ -3913,6 +3914,8 @@ out:
 	 */
 	if (likely(update_next_balance))
 		rq->next_balance = next_balance;
+
+	free_cpumask_var(tmp);
 }
 
 /*
@@ -3937,12 +3940,13 @@ static void run_rebalance_domains(struct softirq_action *h)
 	 */
 	if (this_rq->idle_at_tick &&
 	    atomic_read(&nohz.load_balancer) == this_cpu) {
-		cpumask_t cpus = nohz.cpu_mask;
 		struct rq *rq;
 		int balance_cpu;
 
-		cpu_clear(this_cpu, cpus);
-		for_each_cpu_mask_nr(balance_cpu, cpus) {
+		for_each_cpu(balance_cpu, nohz.cpu_mask) {
+			if (balance_cpu == this_cpu)
+				continue;
+
 			/*
 			 * If this cpu gets work to do, stop the load balancing
 			 * work being done for other cpus. Next load
@@ -3980,7 +3984,7 @@ static inline void trigger_load_balance(struct rq *rq, int cpu)
 		rq->in_nohz_recently = 0;
 
 		if (atomic_read(&nohz.load_balancer) == cpu) {
-			cpu_clear(cpu, nohz.cpu_mask);
+			cpumask_clear_cpu(cpu, nohz.cpu_mask);
 			atomic_set(&nohz.load_balancer, -1);
 		}
 
@@ -3993,7 +3997,7 @@ static inline void trigger_load_balance(struct rq *rq, int cpu)
 			 * TBD: Traverse the sched domains and nominate
 			 * the nearest cpu in the nohz.cpu_mask.
 			 */
-			int ilb = first_cpu(nohz.cpu_mask);
+			int ilb = cpumask_first(nohz.cpu_mask);
 
 			if (ilb < nr_cpu_ids)
 				resched_cpu(ilb);
@@ -4005,7 +4009,7 @@ static inline void trigger_load_balance(struct rq *rq, int cpu)
 	 * cpus with ticks stopped, is it time for that to stop?
 	 */
 	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) == cpu &&
-	    cpus_weight(nohz.cpu_mask) == num_online_cpus()) {
+	    cpumask_weight(nohz.cpu_mask) == num_online_cpus()) {
 		resched_cpu(cpu);
 		return;
 	}
@@ -4015,7 +4019,7 @@ static inline void trigger_load_balance(struct rq *rq, int cpu)
 	 * someone else, then no need raise the SCHED_SOFTIRQ
 	 */
 	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) != cpu &&
-	    cpu_isset(cpu, nohz.cpu_mask))
+	    cpumask_test_cpu(cpu, nohz.cpu_mask))
 		return;
 #endif
 	if (time_after_eq(jiffies, rq->next_balance))
@@ -5373,10 +5377,9 @@ out_unlock:
 	return retval;
 }
 
-long sched_setaffinity(pid_t pid, const cpumask_t *in_mask)
+long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 {
-	cpumask_t cpus_allowed;
-	cpumask_t new_mask = *in_mask;
+	cpumask_var_t cpus_allowed, new_mask;
 	struct task_struct *p;
 	int retval;
 
@@ -5398,6 +5401,14 @@ long sched_setaffinity(pid_t pid, const cpumask_t *in_mask)
 	get_task_struct(p);
 	read_unlock(&tasklist_lock);
 
+	if (!alloc_cpumask_var(&cpus_allowed, GFP_KERNEL)) {
+		retval = -ENOMEM;
+		goto out_put_task;
+	}
+	if (!alloc_cpumask_var(&new_mask, GFP_KERNEL)) {
+		retval = -ENOMEM;
+		goto out_free_cpus_allowed;
+	}
 	retval = -EPERM;
 	if ((current->euid != p->euid) && (current->euid != p->uid) &&
 			!capable(CAP_SYS_NICE))
@@ -5407,37 +5418,41 @@ long sched_setaffinity(pid_t pid, const cpumask_t *in_mask)
 	if (retval)
 		goto out_unlock;
 
-	cpuset_cpus_allowed(p, &cpus_allowed);
-	cpus_and(new_mask, new_mask, cpus_allowed);
+	cpuset_cpus_allowed(p, cpus_allowed);
+	cpumask_and(new_mask, in_mask, cpus_allowed);
  again:
-	retval = set_cpus_allowed_ptr(p, &new_mask);
+	retval = set_cpus_allowed_ptr(p, new_mask);
 
 	if (!retval) {
-		cpuset_cpus_allowed(p, &cpus_allowed);
-		if (!cpus_subset(new_mask, cpus_allowed)) {
+		cpuset_cpus_allowed(p, cpus_allowed);
+		if (!cpumask_subset(new_mask, cpus_allowed)) {
 			/*
 			 * We must have raced with a concurrent cpuset
 			 * update. Just reset the cpus_allowed to the
 			 * cpuset's cpus_allowed
 			 */
-			new_mask = cpus_allowed;
+			cpumask_copy(new_mask, cpus_allowed);
 			goto again;
 		}
 	}
 out_unlock:
+	free_cpumask_var(new_mask);
+out_free_cpus_allowed:
+	free_cpumask_var(cpus_allowed);
+out_put_task:
 	put_task_struct(p);
 	put_online_cpus();
 	return retval;
 }
 
 static int get_user_cpu_mask(unsigned long __user *user_mask_ptr, unsigned len,
-			     cpumask_t *new_mask)
+			     struct cpumask *new_mask)
 {
-	if (len < sizeof(cpumask_t)) {
-		memset(new_mask, 0, sizeof(cpumask_t));
-	} else if (len > sizeof(cpumask_t)) {
-		len = sizeof(cpumask_t);
-	}
+	if (len < cpumask_size())
+		cpumask_clear(new_mask);
+	else if (len > cpumask_size())
+		len = cpumask_size();
+
 	return copy_from_user(new_mask, user_mask_ptr, len) ? -EFAULT : 0;
 }
 
@@ -5450,17 +5465,20 @@ static int get_user_cpu_mask(unsigned long __user *user_mask_ptr, 
unsigned len,
 asmlinkage long sys_sched_setaffinity(pid_t pid, unsigned int len,
 				      unsigned long __user *user_mask_ptr)
 {
-	cpumask_t new_mask;
+	cpumask_var_t new_mask;
 	int retval;
 
-	retval = get_user_cpu_mask(user_mask_ptr, len, &new_mask);
-	if (retval)
-		return retval;
+	if (!alloc_cpumask_var(&new_mask, GFP_KERNEL))
+		return -ENOMEM;
 
-	return sched_setaffinity(pid, &new_mask);
+	retval = get_user_cpu_mask(user_mask_ptr, len, new_mask);
+	if (retval == 0)
+		retval = sched_setaffinity(pid, new_mask);
+	free_cpumask_var(new_mask);
+	return retval;
 }
 
-long sched_getaffinity(pid_t pid, cpumask_t *mask)
+long sched_getaffinity(pid_t pid, struct cpumask *mask)
 {
 	struct task_struct *p;
 	int retval;
@@ -5477,7 +5495,7 @@ long sched_getaffinity(pid_t pid, cpumask_t *mask)
 	if (retval)
 		goto out_unlock;
 
-	cpus_and(*mask, p->cpus_allowed, cpu_online_map);
+	cpumask_and(mask, &p->cpus_allowed, cpu_online_mask);
 
 out_unlock:
 	read_unlock(&tasklist_lock);
@@ -5496,19 +5514,24 @@ asmlinkage long sys_sched_getaffinity(pid_t pid, unsigned int len,
 				      unsigned long __user *user_mask_ptr)
 {
 	int ret;
-	cpumask_t mask;
+	cpumask_var_t mask;
 
-	if (len < sizeof(cpumask_t))
+	if (len < cpumask_size())
 		return -EINVAL;
 
-	ret = sched_getaffinity(pid, &mask);
-	if (ret < 0)
-		return ret;
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+		return -ENOMEM;
 
-	if (copy_to_user(user_mask_ptr, &mask, sizeof(cpumask_t)))
-		return -EFAULT;
+	ret = sched_getaffinity(pid, mask);
+	if (ret == 0) {
+		if (copy_to_user(user_mask_ptr, mask, cpumask_size()))
+			ret = -EFAULT;
+		else
+			ret = cpumask_size();
+	}
+	free_cpumask_var(mask);
 
-	return sizeof(cpumask_t);
+	return ret;
 }
 
 /**
@@ -5845,7 +5868,7 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	idle->se.exec_start = sched_clock();
 
 	idle->prio = idle->normal_prio = MAX_PRIO;
-	idle->cpus_allowed = cpumask_of_cpu(cpu);
+	cpumask_copy(&idle->cpus_allowed, cpumask_of(cpu));
 	__set_task_cpu(idle, cpu);
 
 	rq->curr = rq->idle = idle;
@@ -5872,9 +5895,9 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
  * indicates which cpus entered this state. This is used
  * in the rcu update to wait only for active cpus. For system
  * which do not switch off the HZ timer nohz_cpu_mask should
- * always be CPU_MASK_NONE.
+ * always be CPU_BITS_NONE.
  */
-cpumask_t nohz_cpu_mask = CPU_MASK_NONE;
+cpumask_var_t nohz_cpu_mask;
 
 /*
  * Increase the granularity value when there are more CPUs,
@@ -5929,7 +5952,7 @@ static inline void sched_init_granularity(void)
  * task must not exit() & deallocate itself prematurely. The
  * call is not atomic; no spinlocks may be held.
  */
-int set_cpus_allowed_ptr(struct task_struct *p, const cpumask_t *new_mask)
+int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 {
 	struct migration_req req;
 	unsigned long flags;
@@ -5937,13 +5960,13 @@ int set_cpus_allowed_ptr(struct task_struct *p, const cpumask_t 
*new_mask)
 	int ret = 0;
 
 	rq = task_rq_lock(p, &flags);
-	if (!cpus_intersects(*new_mask, cpu_online_map)) {
+	if (!cpumask_intersects(new_mask, cpu_online_mask)) {
 		ret = -EINVAL;
 		goto out;
 	}
 
 	if (unlikely((p->flags & PF_THREAD_BOUND) && p != current &&
-		     !cpus_equal(p->cpus_allowed, *new_mask))) {
+		     !cpumask_equal(&p->cpus_allowed, new_mask))) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -5951,15 +5974,15 @@ int set_cpus_allowed_ptr(struct task_struct *p, const cpumask_t 
*new_mask)
 	if (p->sched_class->set_cpus_allowed)
 		p->sched_class->set_cpus_allowed(p, new_mask);
 	else {
-		p->cpus_allowed = *new_mask;
-		p->rt.nr_cpus_allowed = cpus_weight(*new_mask);
+		cpumask_copy(&p->cpus_allowed, new_mask);
+		p->rt.nr_cpus_allowed = cpumask_weight(new_mask);
 	}
 
 	/* Can the task run on the task's current CPU? If so, we're done */
-	if (cpu_isset(task_cpu(p), *new_mask))
+	if (cpumask_test_cpu(task_cpu(p), new_mask))
 		goto out;
 
-	if (migrate_task(p, any_online_cpu(*new_mask), &req)) {
+	if (migrate_task(p, cpumask_any_and(cpu_online_mask, new_mask), &req)) {
 		/* Need help from migration thread: drop lock and wait. */
 		task_rq_unlock(rq, &flags);
 		wake_up_process(rq->migration_thread);
@@ -6001,7 +6024,7 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int 
dest_cpu)
 	if (task_cpu(p) != src_cpu)
 		goto done;
 	/* Affinity changed (again). */
-	if (!cpu_isset(dest_cpu, p->cpus_allowed))
+	if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
 		goto fail;
 
 	on_rq = p->se.on_rq;
@@ -6099,49 +6122,46 @@ static int __migrate_task_irq(struct task_struct *p, int src_cpu, int 
dest_cpu)
 static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 {
 	unsigned long flags;
-	cpumask_t mask;
 	struct rq *rq;
 	int dest_cpu;
+	/* FIXME: Use cpumask_of_node here. */
+	cpumask_t _nodemask = node_to_cpumask(cpu_to_node(dead_cpu));
+	const struct cpumask *nodemask = &_nodemask;
+
+again:
+	/* Look for allowed, online CPU in same node. */
+	for_each_cpu_and(dest_cpu, nodemask, cpu_online_mask)
+		if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
+			goto move;
+
+	/* Any allowed, online CPU? */
+	dest_cpu = cpumask_any_and(&p->cpus_allowed, cpu_online_mask);
+	if (dest_cpu < nr_cpu_ids)
+		goto move;
+
+	/* No more Mr. Nice Guy. */
+	if (dest_cpu >= nr_cpu_ids) {
+		rq = task_rq_lock(p, &flags);
+		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
+		dest_cpu = cpumask_any_and(cpu_online_mask, &p->cpus_allowed);
+		task_rq_unlock(rq, &flags);
 
-	do {
-		/* On same node? */
-		mask = node_to_cpumask(cpu_to_node(dead_cpu));
-		cpus_and(mask, mask, p->cpus_allowed);
-		dest_cpu = any_online_cpu(mask);
-
-		/* On any allowed CPU? */
-		if (dest_cpu >= nr_cpu_ids)
-			dest_cpu = any_online_cpu(p->cpus_allowed);
-
-		/* No more Mr. Nice Guy. */
-		if (dest_cpu >= nr_cpu_ids) {
-			cpumask_t cpus_allowed;
-
-			cpuset_cpus_allowed_locked(p, &cpus_allowed);
-			/*
-			 * Try to stay on the same cpuset, where the
-			 * current cpuset may be a subset of all cpus.
-			 * The cpuset_cpus_allowed_locked() variant of
-			 * cpuset_cpus_allowed() will not block. It must be
-			 * called within calls to cpuset_lock/cpuset_unlock.
-			 */
-			rq = task_rq_lock(p, &flags);
-			p->cpus_allowed = cpus_allowed;
-			dest_cpu = any_online_cpu(p->cpus_allowed);
-			task_rq_unlock(rq, &flags);
-
-			/*
-			 * Don't tell them about moving exiting tasks or
-			 * kernel threads (both mm NULL), since they never
-			 * leave kernel.
-			 */
-			if (p->mm && printk_ratelimit()) {
-				printk(KERN_INFO "process %d (%s) no "
-				       "longer affine to cpu%d\n",
-					task_pid_nr(p), p->comm, dead_cpu);
-			}
+		/*
+		 * Don't tell them about moving exiting tasks or
+		 * kernel threads (both mm NULL), since they never
+		 * leave kernel.
+		 */
+		if (p->mm && printk_ratelimit()) {
+			printk(KERN_INFO "process %d (%s) no "
+			       "longer affine to cpu%d\n",
+			       task_pid_nr(p), p->comm, dead_cpu);
 		}
-	} while (!__migrate_task_irq(p, dead_cpu, dest_cpu));
+	}
+
+move:
+	/* It can have affinity changed while we were choosing. */
+	if (unlikely(!__migrate_task_irq(p, dead_cpu, dest_cpu)))
+		goto again;
 }
 
 /*
@@ -6153,7 +6173,7 @@ static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
  */
 static void migrate_nr_uninterruptible(struct rq *rq_src)
 {
-	struct rq *rq_dest = cpu_rq(any_online_cpu(*CPU_MASK_ALL_PTR));
+	struct rq *rq_dest = cpu_rq(cpumask_any(cpu_online_mask));
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -6443,7 +6463,7 @@ static void set_rq_online(struct rq *rq)
 	if (!rq->online) {
 		const struct sched_class *class;
 
-		cpu_set(rq->cpu, rq->rd->online);
+		cpumask_set_cpu(rq->cpu, rq->rd->online);
 		rq->online = 1;
 
 		for_each_class(class) {
@@ -6463,7 +6483,7 @@ static void set_rq_offline(struct rq *rq)
 				class->rq_offline(rq);
 		}
 
-		cpu_clear(rq->cpu, rq->rd->online);
+		cpumask_clear_cpu(rq->cpu, rq->rd->online);
 		rq->online = 0;
 	}
 }
@@ -6504,7 +6524,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void 
*hcpu)
 		rq = cpu_rq(cpu);
 		spin_lock_irqsave(&rq->lock, flags);
 		if (rq->rd) {
-			BUG_ON(!cpu_isset(cpu, rq->rd->span));
+			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
 
 			set_rq_online(rq);
 		}
@@ -6518,7 +6538,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void 
*hcpu)
 			break;
 		/* Unbind it from offline cpu so it can run. Fall thru. */
 		kthread_bind(cpu_rq(cpu)->migration_thread,
-			     any_online_cpu(cpu_online_map));
+			     cpumask_any(cpu_online_mask));
 		kthread_stop(cpu_rq(cpu)->migration_thread);
 		cpu_rq(cpu)->migration_thread = NULL;
 		break;
@@ -6566,7 +6586,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void 
*hcpu)
 		rq = cpu_rq(cpu);
 		spin_lock_irqsave(&rq->lock, flags);
 		if (rq->rd) {
-			BUG_ON(!cpu_isset(cpu, rq->rd->span));
+			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
 			set_rq_offline(rq);
 		}
 		spin_unlock_irqrestore(&rq->lock, flags);
@@ -6605,13 +6625,13 @@ early_initcall(migration_init);
 #ifdef CONFIG_SCHED_DEBUG
 
 static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
-				  cpumask_t *groupmask)
+				  struct cpumask *groupmask)
 {
 	struct sched_group *group = sd->groups;
 	char str[256];
 
-	cpulist_scnprintf(str, sizeof(str), sd->span);
-	cpus_clear(*groupmask);
+	cpulist_scnprintf(str, sizeof(str), *sched_domain_span(sd));
+	cpumask_clear(groupmask);
 
 	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
 
@@ -6625,11 +6645,11 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, 
int level,
 
 	printk(KERN_CONT "span %s level %s\n", str, sd->name);
 
-	if (!cpu_isset(cpu, sd->span)) {
+	if (!cpumask_test_cpu(cpu, sched_domain_span(sd))) {
 		printk(KERN_ERR "ERROR: domain->span does not contain "
 				"CPU%d\n", cpu);
 	}
-	if (!cpu_isset(cpu, group->cpumask)) {
+	if (!cpumask_test_cpu(cpu, sched_group_cpus(group))) {
 		printk(KERN_ERR "ERROR: domain->groups does not contain"
 				" CPU%d\n", cpu);
 	}
@@ -6649,31 +6669,32 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, 
int level,
 			break;
 		}
 
-		if (!cpus_weight(group->cpumask)) {
+		if (!cpumask_weight(sched_group_cpus(group))) {
 			printk(KERN_CONT "\n");
 			printk(KERN_ERR "ERROR: empty group\n");
 			break;
 		}
 
-		if (cpus_intersects(*groupmask, group->cpumask)) {
+		if (cpumask_intersects(groupmask, sched_group_cpus(group))) {
 			printk(KERN_CONT "\n");
 			printk(KERN_ERR "ERROR: repeated CPUs\n");
 			break;
 		}
 
-		cpus_or(*groupmask, *groupmask, group->cpumask);
+		cpumask_or(groupmask, groupmask, sched_group_cpus(group));
 
-		cpulist_scnprintf(str, sizeof(str), group->cpumask);
+		cpulist_scnprintf(str, sizeof(str), *sched_group_cpus(group));
 		printk(KERN_CONT " %s", str);
 
 		group = group->next;
 	} while (group != sd->groups);
 	printk(KERN_CONT "\n");
 
-	if (!cpus_equal(sd->span, *groupmask))
+	if (!cpumask_equal(sched_domain_span(sd), groupmask))
 		printk(KERN_ERR "ERROR: groups don't span domain->span\n");
 
-	if (sd->parent && !cpus_subset(*groupmask, sd->parent->span))
+	if (sd->parent &&
+	    !cpumask_subset(groupmask, sched_domain_span(sd->parent)))
 		printk(KERN_ERR "ERROR: parent span is not a superset "
 			"of domain->span\n");
 	return 0;
@@ -6681,7 +6702,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int 
level,
 
 static void sched_domain_debug(struct sched_domain *sd, int cpu)
 {
-	cpumask_t *groupmask;
+	cpumask_var_t groupmask;
 	int level = 0;
 
 	if (!sd) {
@@ -6691,8 +6712,7 @@ static void sched_domain_debug(struct sched_domain *sd, int cpu)
 
 	printk(KERN_DEBUG "CPU%d attaching sched-domain:\n", cpu);
 
-	groupmask = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
-	if (!groupmask) {
+	if (!alloc_cpumask_var(&groupmask, GFP_KERNEL)) {
 		printk(KERN_DEBUG "Cannot load-balance (out of memory)\n");
 		return;
 	}
@@ -6705,7 +6725,7 @@ static void sched_domain_debug(struct sched_domain *sd, int cpu)
 		if (!sd)
 			break;
 	}
-	kfree(groupmask);
+	free_cpumask_var(groupmask);
 }
 #else /* !CONFIG_SCHED_DEBUG */
 # define sched_domain_debug(sd, cpu) do { } while (0)
@@ -6713,7 +6733,7 @@ static void sched_domain_debug(struct sched_domain *sd, int cpu)
 
 static int sd_degenerate(struct sched_domain *sd)
 {
-	if (cpus_weight(sd->span) == 1)
+	if (cpumask_weight(sched_domain_span(sd)) == 1)
 		return 1;
 
 	/* Following flags need at least 2 groups */
@@ -6744,7 +6764,7 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain 
*parent)
 	if (sd_degenerate(parent))
 		return 1;
 
-	if (!cpus_equal(sd->span, parent->span))
+	if (!cpumask_equal(sched_domain_span(sd), sched_domain_span(parent)))
 		return 0;
 
 	/* Does parent contain flags not in child? */
@@ -6766,6 +6786,16 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain 
*parent)
 	return 1;
 }
 
+static void free_rootdomain(struct root_domain *rd)
+{
+	cpupri_cleanup(&rd->cpupri);
+
+	free_cpumask_var(rd->rto_mask);
+	free_cpumask_var(rd->online);
+	free_cpumask_var(rd->span);
+	kfree(rd);
+}
+
 static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 {
 	unsigned long flags;
@@ -6775,38 +6805,63 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 	if (rq->rd) {
 		struct root_domain *old_rd = rq->rd;
 
-		if (cpu_isset(rq->cpu, old_rd->online))
+		if (cpumask_test_cpu(rq->cpu, old_rd->online))
 			set_rq_offline(rq);
 
-		cpu_clear(rq->cpu, old_rd->span);
+		cpumask_clear_cpu(rq->cpu, old_rd->span);
 
 		if (atomic_dec_and_test(&old_rd->refcount))
-			kfree(old_rd);
+			free_rootdomain(old_rd);
 	}
 
 	atomic_inc(&rd->refcount);
 	rq->rd = rd;
 
-	cpu_set(rq->cpu, rd->span);
-	if (cpu_isset(rq->cpu, cpu_online_map))
+	cpumask_set_cpu(rq->cpu, rd->span);
+	if (cpumask_test_cpu(rq->cpu, cpu_online_mask))
 		set_rq_online(rq);
 
 	spin_unlock_irqrestore(&rq->lock, flags);
 }
 
-static void init_rootdomain(struct root_domain *rd)
+static int init_rootdomain(struct root_domain *rd, bool bootmem)
 {
 	memset(rd, 0, sizeof(*rd));
 
-	cpus_clear(rd->span);
-	cpus_clear(rd->online);
+	if (bootmem) {
+		alloc_bootmem_cpumask_var(&def_root_domain.span);
+		alloc_bootmem_cpumask_var(&def_root_domain.online);
+		alloc_bootmem_cpumask_var(&def_root_domain.rto_mask);
+		cpupri_init(&rd->cpupri, true);
+		return 0;
+	}
+
+	if (!alloc_cpumask_var(&rd->span, GFP_KERNEL))
+		goto free_rd;
+	if (!alloc_cpumask_var(&rd->online, GFP_KERNEL))
+		goto free_span;
+	if (!alloc_cpumask_var(&rd->rto_mask, GFP_KERNEL))
+		goto free_online;
+
+	if (cpupri_init(&rd->cpupri, false) != 0)
+		goto free_rto_mask;
+	return 0;
 
-	cpupri_init(&rd->cpupri);
+free_rto_mask:
+	free_cpumask_var(rd->rto_mask);
+free_online:
+	free_cpumask_var(rd->online);
+free_span:
+	free_cpumask_var(rd->span);
+free_rd:
+	kfree(rd);
+	return -ENOMEM;
 }
 
 static void init_defrootdomain(void)
 {
-	init_rootdomain(&def_root_domain);
+	init_rootdomain(&def_root_domain, true);
+
 	atomic_set(&def_root_domain.refcount, 1);
 }
 
@@ -6818,7 +6873,10 @@ static struct root_domain *alloc_rootdomain(void)
 	if (!rd)
 		return NULL;
 
-	init_rootdomain(rd);
+	if (init_rootdomain(rd, false) != 0) {
+		kfree(rd);
+		return NULL;
+	}
 
 	return rd;
 }
@@ -6860,19 +6918,12 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, 
int cpu)
 }
 
 /* cpus with isolated domains */
-static cpumask_t cpu_isolated_map = CPU_MASK_NONE;
+static cpumask_var_t cpu_isolated_map;
 
 /* Setup the mask of cpus configured for isolated domains */
 static int __init isolated_cpu_setup(char *str)
 {
-	static int __initdata ints[NR_CPUS];
-	int i;
-
-	str = get_options(str, ARRAY_SIZE(ints), ints);
-	cpus_clear(cpu_isolated_map);
-	for (i = 1; i <= ints[0]; i++)
-		if (ints[i] < NR_CPUS)
-			cpu_set(ints[i], cpu_isolated_map);
+	cpulist_parse(str, *cpu_isolated_map);
 	return 1;
 }
 
@@ -6881,42 +6932,43 @@ __setup("isolcpus=", isolated_cpu_setup);
 /*
  * init_sched_build_groups takes the cpumask we wish to span, and a pointer
  * to a function which identifies what group(along with sched group) a CPU
- * belongs to. The return value of group_fn must be a >= 0 and < NR_CPUS
- * (due to the fact that we keep track of groups covered with a cpumask_t).
+ * belongs to. The return value of group_fn must be a >= 0 and < nr_cpu_ids
+ * (due to the fact that we keep track of groups covered with a struct cpumask).
  *
  * init_sched_build_groups will build a circular linked list of the groups
  * covered by the given span, and will set each group's ->cpumask correctly,
  * and ->cpu_power to 0.
  */
 static void
-init_sched_build_groups(const cpumask_t *span, const cpumask_t *cpu_map,
-			int (*group_fn)(int cpu, const cpumask_t *cpu_map,
+init_sched_build_groups(const struct cpumask *span,
+			const struct cpumask *cpu_map,
+			int (*group_fn)(int cpu, const struct cpumask *cpu_map,
 					struct sched_group **sg,
-					cpumask_t *tmpmask),
-			cpumask_t *covered, cpumask_t *tmpmask)
+					struct cpumask *tmpmask),
+			struct cpumask *covered, struct cpumask *tmpmask)
 {
 	struct sched_group *first = NULL, *last = NULL;
 	int i;
 
-	cpus_clear(*covered);
+	cpumask_clear(covered);
 
-	for_each_cpu_mask_nr(i, *span) {
+	for_each_cpu(i, span) {
 		struct sched_group *sg;
 		int group = group_fn(i, cpu_map, &sg, tmpmask);
 		int j;
 
-		if (cpu_isset(i, *covered))
+		if (cpumask_test_cpu(i, covered))
 			continue;
 
-		cpus_clear(sg->cpumask);
+		cpumask_clear(sched_group_cpus(sg));
 		sg->__cpu_power = 0;
 
-		for_each_cpu_mask_nr(j, *span) {
+		for_each_cpu(j, span) {
 			if (group_fn(j, cpu_map, NULL, tmpmask) != group)
 				continue;
 
-			cpu_set(j, *covered);
-			cpu_set(j, sg->cpumask);
+			cpumask_set_cpu(j, covered);
+			cpumask_set_cpu(j, sched_group_cpus(sg));
 		}
 		if (!first)
 			first = sg;
@@ -6980,9 +7032,10 @@ static int find_next_best_node(int node, nodemask_t *used_nodes)
  * should be one that prevents unnecessary balancing, but also spreads tasks
  * out optimally.
  */
-static void sched_domain_node_span(int node, cpumask_t *span)
+static void sched_domain_node_span(int node, struct cpumask *span)
 {
 	nodemask_t used_nodes;
+	/* FIXME: use cpumask_of_node() */
 	node_to_cpumask_ptr(nodemask, node);
 	int i;
 
@@ -7004,18 +7057,33 @@ static void sched_domain_node_span(int node, cpumask_t *span)
 int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
 
 /*
+ * The cpus mask in sched_group and sched_domain hangs off the end.
+ * FIXME: use cpumask_var_t or dynamic percpu alloc to avoid wasting space
+ * for nr_cpu_ids < CONFIG_NR_CPUS.
+ */
+struct static_sched_group {
+	struct sched_group sg;
+	DECLARE_BITMAP(cpus, CONFIG_NR_CPUS);
+};
+
+struct static_sched_domain {
+	struct sched_domain sd;
+	DECLARE_BITMAP(span, CONFIG_NR_CPUS);
+};
+
+/*
  * SMT sched-domains:
  */
 #ifdef CONFIG_SCHED_SMT
-static DEFINE_PER_CPU(struct sched_domain, cpu_domains);
-static DEFINE_PER_CPU(struct sched_group, sched_group_cpus);
+static DEFINE_PER_CPU(struct static_sched_domain, cpu_domains);
+static DEFINE_PER_CPU(struct static_sched_group, sched_group_cpus);
 
 static int
-cpu_to_cpu_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg,
-		 cpumask_t *unused)
+cpu_to_cpu_group(int cpu, const struct cpumask *cpu_map,
+		 struct sched_group **sg, struct cpumask *unused)
 {
 	if (sg)
-		*sg = &per_cpu(sched_group_cpus, cpu);
+		*sg = &per_cpu(sched_group_cpus, cpu).sg;
 	return cpu;
 }
 #endif /* CONFIG_SCHED_SMT */
@@ -7024,56 +7092,55 @@ cpu_to_cpu_group(int cpu, const cpumask_t *cpu_map, struct 
sched_group **sg,
  * multi-core sched-domains:
  */
 #ifdef CONFIG_SCHED_MC
-static DEFINE_PER_CPU(struct sched_domain, core_domains);
-static DEFINE_PER_CPU(struct sched_group, sched_group_core);
+static DEFINE_PER_CPU(struct static_sched_domain, core_domains);
+static DEFINE_PER_CPU(struct static_sched_group, sched_group_core);
 #endif /* CONFIG_SCHED_MC */
 
 #if defined(CONFIG_SCHED_MC) && defined(CONFIG_SCHED_SMT)
 static int
-cpu_to_core_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg,
-		  cpumask_t *mask)
+cpu_to_core_group(int cpu, const struct cpumask *cpu_map,
+		  struct sched_group **sg, struct cpumask *mask)
 {
 	int group;
 
-	*mask = per_cpu(cpu_sibling_map, cpu);
-	cpus_and(*mask, *mask, *cpu_map);
-	group = first_cpu(*mask);
+	cpumask_and(mask, &per_cpu(cpu_sibling_map, cpu), cpu_map);
+	group = cpumask_first(mask);
 	if (sg)
-		*sg = &per_cpu(sched_group_core, group);
+		*sg = &per_cpu(sched_group_core, group).sg;
 	return group;
 }
 #elif defined(CONFIG_SCHED_MC)
 static int
-cpu_to_core_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg,
-		  cpumask_t *unused)
+cpu_to_core_group(int cpu, const struct cpumask *cpu_map,
+		  struct sched_group **sg, struct cpumask *unused)
 {
 	if (sg)
-		*sg = &per_cpu(sched_group_core, cpu);
+		*sg = &per_cpu(sched_group_core, cpu).sg;
 	return cpu;
 }
 #endif
 
-static DEFINE_PER_CPU(struct sched_domain, phys_domains);
-static DEFINE_PER_CPU(struct sched_group, sched_group_phys);
+static DEFINE_PER_CPU(struct static_sched_domain, phys_domains);
+static DEFINE_PER_CPU(struct static_sched_group, sched_group_phys);
 
 static int
-cpu_to_phys_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg,
-		  cpumask_t *mask)
+cpu_to_phys_group(int cpu, const struct cpumask *cpu_map,
+		  struct sched_group **sg, struct cpumask *mask)
 {
 	int group;
 #ifdef CONFIG_SCHED_MC
+	/* FIXME: Use cpu_coregroup_mask. */
 	*mask = cpu_coregroup_map(cpu);
 	cpus_and(*mask, *mask, *cpu_map);
-	group = first_cpu(*mask);
+	group = cpumask_first(mask);
 #elif defined(CONFIG_SCHED_SMT)
-	*mask = per_cpu(cpu_sibling_map, cpu);
-	cpus_and(*mask, *mask, *cpu_map);
-	group = first_cpu(*mask);
+	cpumask_and(mask, &per_cpu(cpu_sibling_map, cpu), cpu_map);
+	group = cpumask_first(mask);
 #else
 	group = cpu;
 #endif
 	if (sg)
-		*sg = &per_cpu(sched_group_phys, group);
+		*sg = &per_cpu(sched_group_phys, group).sg;
 	return group;
 }
 
@@ -7087,19 +7154,21 @@ static DEFINE_PER_CPU(struct sched_domain, node_domains);
 static struct sched_group ***sched_group_nodes_bycpu;
 
 static DEFINE_PER_CPU(struct sched_domain, allnodes_domains);
-static DEFINE_PER_CPU(struct sched_group, sched_group_allnodes);
+static DEFINE_PER_CPU(struct static_sched_group, sched_group_allnodes);
 
-static int cpu_to_allnodes_group(int cpu, const cpumask_t *cpu_map,
-				 struct sched_group **sg, cpumask_t *nodemask)
+static int cpu_to_allnodes_group(int cpu, const struct cpumask *cpu_map,
+				 struct sched_group **sg,
+				 struct cpumask *nodemask)
 {
 	int group;
+	/* FIXME: use cpumask_of_node */
+	node_to_cpumask_ptr(pnodemask, cpu_to_node(cpu));
 
-	*nodemask = node_to_cpumask(cpu_to_node(cpu));
-	cpus_and(*nodemask, *nodemask, *cpu_map);
-	group = first_cpu(*nodemask);
+	cpumask_and(nodemask, pnodemask, cpu_map);
+	group = cpumask_first(nodemask);
 
 	if (sg)
-		*sg = &per_cpu(sched_group_allnodes, group);
+		*sg = &per_cpu(sched_group_allnodes, group).sg;
 	return group;
 }
 
@@ -7111,11 +7180,11 @@ static void init_numa_sched_groups_power(struct sched_group 
*group_head)
 	if (!sg)
 		return;
 	do {
-		for_each_cpu_mask_nr(j, sg->cpumask) {
+		for_each_cpu(j, sched_group_cpus(sg)) {
 			struct sched_domain *sd;
 
-			sd = &per_cpu(phys_domains, j);
-			if (j != first_cpu(sd->groups->cpumask)) {
+			sd = &per_cpu(phys_domains, j).sd;
+			if (j != cpumask_first(sched_group_cpus(sd->groups))) {
 				/*
 				 * Only add "power" once for each
 				 * physical package.
@@ -7132,11 +7201,12 @@ static void init_numa_sched_groups_power(struct sched_group 
*group_head)
 
 #ifdef CONFIG_NUMA
 /* Free memory allocated for various sched_group structures */
-static void free_sched_groups(const cpumask_t *cpu_map, cpumask_t *nodemask)
+static void free_sched_groups(const struct cpumask *cpu_map,
+			      struct cpumask *nodemask)
 {
 	int cpu, i;
 
-	for_each_cpu_mask_nr(cpu, *cpu_map) {
+	for_each_cpu(cpu, cpu_map) {
 		struct sched_group **sched_group_nodes
 			= sched_group_nodes_bycpu[cpu];
 
@@ -7145,10 +7215,11 @@ static void free_sched_groups(const cpumask_t *cpu_map, cpumask_t 
*nodemask)
 
 		for (i = 0; i < nr_node_ids; i++) {
 			struct sched_group *oldsg, *sg = sched_group_nodes[i];
+			/* FIXME: Use cpumask_of_node */
+			node_to_cpumask_ptr(pnodemask, i);
 
-			*nodemask = node_to_cpumask(i);
-			cpus_and(*nodemask, *nodemask, *cpu_map);
-			if (cpus_empty(*nodemask))
+			cpus_and(*nodemask, *pnodemask, *cpu_map);
+			if (cpumask_empty(nodemask))
 				continue;
 
 			if (sg == NULL)
@@ -7166,7 +7237,8 @@ next_sg:
 	}
 }
 #else /* !CONFIG_NUMA */
-static void free_sched_groups(const cpumask_t *cpu_map, cpumask_t *nodemask)
+static void free_sched_groups(const struct cpumask *cpu_map,
+			      struct cpumask *nodemask)
 {
 }
 #endif /* CONFIG_NUMA */
@@ -7192,7 +7264,7 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 
 	WARN_ON(!sd || !sd->groups);
 
-	if (cpu != first_cpu(sd->groups->cpumask))
+	if (cpu != cpumask_first(sched_group_cpus(sd->groups)))
 		return;
 
 	child = sd->child;
@@ -7257,48 +7329,6 @@ SD_INIT_FUNC(CPU)
  SD_INIT_FUNC(MC)
 #endif
 
-/*
- * To minimize stack usage kmalloc room for cpumasks and share the
- * space as the usage in build_sched_domains() dictates.  Used only
- * if the amount of space is significant.
- */
-struct allmasks {
-	cpumask_t tmpmask;			/* make this one first */
-	union {
-		cpumask_t nodemask;
-		cpumask_t this_sibling_map;
-		cpumask_t this_core_map;
-	};
-	cpumask_t send_covered;
-
-#ifdef CONFIG_NUMA
-	cpumask_t domainspan;
-	cpumask_t covered;
-	cpumask_t notcovered;
-#endif
-};
-
-#if	NR_CPUS > 128
-#define SCHED_CPUMASK_DECLARE(v)	struct allmasks *v
-static inline void sched_cpumask_alloc(struct allmasks **masks)
-{
-	*masks = kmalloc(sizeof(**masks), GFP_KERNEL);
-}
-static inline void sched_cpumask_free(struct allmasks *masks)
-{
-	kfree(masks);
-}
-#else
-#define SCHED_CPUMASK_DECLARE(v)	struct allmasks _v, *v = &_v
-static inline void sched_cpumask_alloc(struct allmasks **masks)
-{ }
-static inline void sched_cpumask_free(struct allmasks *masks)
-{ }
-#endif
-
-#define	SCHED_CPUMASK_VAR(v, a) 	cpumask_t *v = (cpumask_t *) \
-			((unsigned long)(a) + offsetof(struct allmasks, v))
-
 static int default_relax_domain_level = -1;
 
 static int __init setup_relax_domain_level(char *str)
@@ -7338,17 +7368,38 @@ static void set_domain_attribute(struct sched_domain *sd,
  * Build sched domains for a given set of cpus and attach the sched domains
  * to the individual cpus
  */
-static int __build_sched_domains(const cpumask_t *cpu_map,
+static int __build_sched_domains(const struct cpumask *cpu_map,
 				 struct sched_domain_attr *attr)
 {
-	int i;
+	int i, err = -ENOMEM;
 	struct root_domain *rd;
-	SCHED_CPUMASK_DECLARE(allmasks);
-	cpumask_t *tmpmask;
+	cpumask_var_t nodemask, this_sibling_map, this_core_map, send_covered,
+		tmpmask;
 #ifdef CONFIG_NUMA
+	cpumask_var_t domainspan, covered, notcovered;
 	struct sched_group **sched_group_nodes = NULL;
 	int sd_allnodes = 0;
 
+	if (!alloc_cpumask_var(&domainspan, GFP_KERNEL))
+		goto out;
+	if (!alloc_cpumask_var(&covered, GFP_KERNEL))
+		goto free_domainspan;
+	if (!alloc_cpumask_var(&notcovered, GFP_KERNEL))
+		goto free_covered;
+#endif
+
+	if (!alloc_cpumask_var(&nodemask, GFP_KERNEL))
+		goto free_notcovered;
+	if (!alloc_cpumask_var(&this_sibling_map, GFP_KERNEL))
+		goto free_nodemask;
+	if (!alloc_cpumask_var(&this_core_map, GFP_KERNEL))
+		goto free_this_sibling_map;
+	if (!alloc_cpumask_var(&send_covered, GFP_KERNEL))
+		goto free_this_core_map;
+	if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL))
+		goto free_send_covered;
+
+#ifdef CONFIG_NUMA
 	/*
 	 * Allocate the per-node list of sched groups
 	 */
@@ -7356,54 +7407,37 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 				    GFP_KERNEL);
 	if (!sched_group_nodes) {
 		printk(KERN_WARNING "Can not alloc sched group node list\n");
-		return -ENOMEM;
+		goto free_tmpmask;
 	}
 #endif
 
 	rd = alloc_rootdomain();
 	if (!rd) {
 		printk(KERN_WARNING "Cannot alloc root domain\n");
-#ifdef CONFIG_NUMA
-		kfree(sched_group_nodes);
-#endif
-		return -ENOMEM;
+		goto free_sched_groups;
 	}
 
-	/* get space for all scratch cpumask variables */
-	sched_cpumask_alloc(&allmasks);
-	if (!allmasks) {
-		printk(KERN_WARNING "Cannot alloc cpumask array\n");
-		kfree(rd);
 #ifdef CONFIG_NUMA
-		kfree(sched_group_nodes);
-#endif
-		return -ENOMEM;
-	}
-
-	tmpmask = (cpumask_t *)allmasks;
-
-
-#ifdef CONFIG_NUMA
-	sched_group_nodes_bycpu[first_cpu(*cpu_map)] = sched_group_nodes;
+	sched_group_nodes_bycpu[cpumask_first(cpu_map)] = sched_group_nodes;
 #endif
 
 	/*
 	 * Set up domains for cpus specified by the cpu_map.
 	 */
-	for_each_cpu_mask_nr(i, *cpu_map) {
+	for_each_cpu(i, cpu_map) {
 		struct sched_domain *sd = NULL, *p;
-		SCHED_CPUMASK_VAR(nodemask, allmasks);
 
+		/* FIXME: use cpumask_of_node */
 		*nodemask = node_to_cpumask(cpu_to_node(i));
 		cpus_and(*nodemask, *nodemask, *cpu_map);
 
 #ifdef CONFIG_NUMA
-		if (cpus_weight(*cpu_map) >
-				SD_NODES_PER_DOMAIN*cpus_weight(*nodemask)) {
+		if (cpumask_weight(cpu_map) >
+				SD_NODES_PER_DOMAIN*cpumask_weight(nodemask)) {
 			sd = &per_cpu(allnodes_domains, i);
 			SD_INIT(sd, ALLNODES);
 			set_domain_attribute(sd, attr);
-			sd->span = *cpu_map;
+			cpumask_copy(sched_domain_span(sd), cpu_map);
 			cpu_to_allnodes_group(i, cpu_map, &sd->groups, tmpmask);
 			p = sd;
 			sd_allnodes = 1;
@@ -7413,18 +7447,19 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 		sd = &per_cpu(node_domains, i);
 		SD_INIT(sd, NODE);
 		set_domain_attribute(sd, attr);
-		sched_domain_node_span(cpu_to_node(i), &sd->span);
+		sched_domain_node_span(cpu_to_node(i), sched_domain_span(sd));
 		sd->parent = p;
 		if (p)
 			p->child = sd;
-		cpus_and(sd->span, sd->span, *cpu_map);
+		cpumask_and(sched_domain_span(sd),
+			    sched_domain_span(sd), cpu_map);
 #endif
 
 		p = sd;
-		sd = &per_cpu(phys_domains, i);
+		sd = &per_cpu(phys_domains, i).sd;
 		SD_INIT(sd, CPU);
 		set_domain_attribute(sd, attr);
-		sd->span = *nodemask;
+		cpumask_copy(sched_domain_span(sd), nodemask);
 		sd->parent = p;
 		if (p)
 			p->child = sd;
@@ -7432,11 +7467,12 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 
 #ifdef CONFIG_SCHED_MC
 		p = sd;
-		sd = &per_cpu(core_domains, i);
+		sd = &per_cpu(core_domains, i).sd;
 		SD_INIT(sd, MC);
 		set_domain_attribute(sd, attr);
-		sd->span = cpu_coregroup_map(i);
-		cpus_and(sd->span, sd->span, *cpu_map);
+		*sched_domain_span(sd) = cpu_coregroup_map(i);
+		cpumask_and(sched_domain_span(sd),
+			    sched_domain_span(sd), cpu_map);
 		sd->parent = p;
 		p->child = sd;
 		cpu_to_core_group(i, cpu_map, &sd->groups, tmpmask);
@@ -7444,11 +7480,11 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 
 #ifdef CONFIG_SCHED_SMT
 		p = sd;
-		sd = &per_cpu(cpu_domains, i);
+		sd = &per_cpu(cpu_domains, i).sd;
 		SD_INIT(sd, SIBLING);
 		set_domain_attribute(sd, attr);
-		sd->span = per_cpu(cpu_sibling_map, i);
-		cpus_and(sd->span, sd->span, *cpu_map);
+		cpumask_and(sched_domain_span(sd),
+			    &per_cpu(cpu_sibling_map, i), cpu_map);
 		sd->parent = p;
 		p->child = sd;
 		cpu_to_cpu_group(i, cpu_map, &sd->groups, tmpmask);
@@ -7457,13 +7493,10 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 
 #ifdef CONFIG_SCHED_SMT
 	/* Set up CPU (sibling) groups */
-	for_each_cpu_mask_nr(i, *cpu_map) {
-		SCHED_CPUMASK_VAR(this_sibling_map, allmasks);
-		SCHED_CPUMASK_VAR(send_covered, allmasks);
-
-		*this_sibling_map = per_cpu(cpu_sibling_map, i);
-		cpus_and(*this_sibling_map, *this_sibling_map, *cpu_map);
-		if (i != first_cpu(*this_sibling_map))
+	for_each_cpu(i, cpu_map) {
+		cpumask_and(this_sibling_map,
+			    &per_cpu(cpu_sibling_map, i), cpu_map);
+		if (i != cpumask_first(this_sibling_map))
 			continue;
 
 		init_sched_build_groups(this_sibling_map, cpu_map,
@@ -7474,13 +7507,11 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 
 #ifdef CONFIG_SCHED_MC
 	/* Set up multi-core groups */
-	for_each_cpu_mask_nr(i, *cpu_map) {
-		SCHED_CPUMASK_VAR(this_core_map, allmasks);
-		SCHED_CPUMASK_VAR(send_covered, allmasks);
-
+	for_each_cpu(i, cpu_map) {
+		/* FIXME: Use cpu_coregroup_mask */
 		*this_core_map = cpu_coregroup_map(i);
 		cpus_and(*this_core_map, *this_core_map, *cpu_map);
-		if (i != first_cpu(*this_core_map))
+		if (i != cpumask_first(this_core_map))
 			continue;
 
 		init_sched_build_groups(this_core_map, cpu_map,
@@ -7491,12 +7522,10 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 
 	/* Set up physical groups */
 	for (i = 0; i < nr_node_ids; i++) {
-		SCHED_CPUMASK_VAR(nodemask, allmasks);
-		SCHED_CPUMASK_VAR(send_covered, allmasks);
-
+		/* FIXME: Use cpumask_of_node */
 		*nodemask = node_to_cpumask(i);
 		cpus_and(*nodemask, *nodemask, *cpu_map);
-		if (cpus_empty(*nodemask))
+		if (cpumask_empty(nodemask))
 			continue;
 
 		init_sched_build_groups(nodemask, cpu_map,
@@ -7507,8 +7536,6 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 #ifdef CONFIG_NUMA
 	/* Set up node groups */
 	if (sd_allnodes) {
-		SCHED_CPUMASK_VAR(send_covered, allmasks);
-
 		init_sched_build_groups(cpu_map, cpu_map,
 					&cpu_to_allnodes_group,
 					send_covered, tmpmask);
@@ -7517,58 +7544,58 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 	for (i = 0; i < nr_node_ids; i++) {
 		/* Set up node groups */
 		struct sched_group *sg, *prev;
-		SCHED_CPUMASK_VAR(nodemask, allmasks);
-		SCHED_CPUMASK_VAR(domainspan, allmasks);
-		SCHED_CPUMASK_VAR(covered, allmasks);
 		int j;
 
+		/* FIXME: Use cpumask_of_node */
 		*nodemask = node_to_cpumask(i);
-		cpus_clear(*covered);
+		cpumask_clear(covered);
 
 		cpus_and(*nodemask, *nodemask, *cpu_map);
-		if (cpus_empty(*nodemask)) {
+		if (cpumask_empty(nodemask)) {
 			sched_group_nodes[i] = NULL;
 			continue;
 		}
 
 		sched_domain_node_span(i, domainspan);
-		cpus_and(*domainspan, *domainspan, *cpu_map);
+		cpumask_and(domainspan, domainspan, cpu_map);
 
-		sg = kmalloc_node(sizeof(struct sched_group), GFP_KERNEL, i);
+		sg = kmalloc_node(sizeof(struct sched_group) + cpumask_size(),
+				  GFP_KERNEL, i);
 		if (!sg) {
 			printk(KERN_WARNING "Can not alloc domain group for "
 				"node %d\n", i);
 			goto error;
 		}
 		sched_group_nodes[i] = sg;
-		for_each_cpu_mask_nr(j, *nodemask) {
+		for_each_cpu(j, nodemask) {
 			struct sched_domain *sd;
 
 			sd = &per_cpu(node_domains, j);
 			sd->groups = sg;
 		}
 		sg->__cpu_power = 0;
-		sg->cpumask = *nodemask;
+		cpumask_copy(sched_group_cpus(sg), nodemask);
 		sg->next = sg;
-		cpus_or(*covered, *covered, *nodemask);
+		cpumask_or(covered, covered, nodemask);
 		prev = sg;
 
 		for (j = 0; j < nr_node_ids; j++) {
-			SCHED_CPUMASK_VAR(notcovered, allmasks);
 			int n = (i + j) % nr_node_ids;
+			/* FIXME: Use cpumask_of_node */
 			node_to_cpumask_ptr(pnodemask, n);
 
-			cpus_complement(*notcovered, *covered);
-			cpus_and(*tmpmask, *notcovered, *cpu_map);
-			cpus_and(*tmpmask, *tmpmask, *domainspan);
-			if (cpus_empty(*tmpmask))
+			cpumask_complement(notcovered, covered);
+			cpumask_and(tmpmask, notcovered, cpu_map);
+			cpumask_and(tmpmask, tmpmask, domainspan);
+			if (cpumask_empty(tmpmask))
 				break;
 
-			cpus_and(*tmpmask, *tmpmask, *pnodemask);
-			if (cpus_empty(*tmpmask))
+			cpumask_and(tmpmask, tmpmask, pnodemask);
+			if (cpumask_empty(tmpmask))
 				continue;
 
-			sg = kmalloc_node(sizeof(struct sched_group),
+			sg = kmalloc_node(sizeof(struct sched_group) +
+					  cpumask_size(),
 					  GFP_KERNEL, i);
 			if (!sg) {
 				printk(KERN_WARNING
@@ -7576,9 +7603,9 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 				goto error;
 			}
 			sg->__cpu_power = 0;
-			sg->cpumask = *tmpmask;
+			cpumask_copy(sched_group_cpus(sg), tmpmask);
 			sg->next = prev->next;
-			cpus_or(*covered, *covered, *tmpmask);
+			cpumask_or(covered, covered, tmpmask);
 			prev->next = sg;
 			prev = sg;
 		}
@@ -7587,22 +7614,22 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 
 	/* Calculate CPU power for physical packages and nodes */
 #ifdef CONFIG_SCHED_SMT
-	for_each_cpu_mask_nr(i, *cpu_map) {
-		struct sched_domain *sd = &per_cpu(cpu_domains, i);
+	for_each_cpu(i, cpu_map) {
+		struct sched_domain *sd = &per_cpu(cpu_domains, i).sd;
 
 		init_sched_groups_power(i, sd);
 	}
 #endif
 #ifdef CONFIG_SCHED_MC
-	for_each_cpu_mask_nr(i, *cpu_map) {
-		struct sched_domain *sd = &per_cpu(core_domains, i);
+	for_each_cpu(i, cpu_map) {
+		struct sched_domain *sd = &per_cpu(core_domains, i).sd;
 
 		init_sched_groups_power(i, sd);
 	}
 #endif
 
-	for_each_cpu_mask_nr(i, *cpu_map) {
-		struct sched_domain *sd = &per_cpu(phys_domains, i);
+	for_each_cpu(i, cpu_map) {
+		struct sched_domain *sd = &per_cpu(phys_domains, i).sd;
 
 		init_sched_groups_power(i, sd);
 	}
@@ -7614,53 +7641,78 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 	if (sd_allnodes) {
 		struct sched_group *sg;
 
-		cpu_to_allnodes_group(first_cpu(*cpu_map), cpu_map, &sg,
+		cpu_to_allnodes_group(cpumask_first(cpu_map), cpu_map, &sg,
 								tmpmask);
 		init_numa_sched_groups_power(sg);
 	}
 #endif
 
 	/* Attach the domains */
-	for_each_cpu_mask_nr(i, *cpu_map) {
+	for_each_cpu(i, cpu_map) {
 		struct sched_domain *sd;
 #ifdef CONFIG_SCHED_SMT
-		sd = &per_cpu(cpu_domains, i);
+		sd = &per_cpu(cpu_domains, i).sd;
 #elif defined(CONFIG_SCHED_MC)
-		sd = &per_cpu(core_domains, i);
+		sd = &per_cpu(core_domains, i).sd;
 #else
-		sd = &per_cpu(phys_domains, i);
+		sd = &per_cpu(phys_domains, i).sd;
 #endif
 		cpu_attach_domain(sd, rd, i);
 	}
 
-	sched_cpumask_free(allmasks);
-	return 0;
+	err = 0;
+
+free_tmpmask:
+	free_cpumask_var(tmpmask);
+free_send_covered:
+	free_cpumask_var(send_covered);
+free_this_core_map:
+	free_cpumask_var(this_core_map);
+free_this_sibling_map:
+	free_cpumask_var(this_sibling_map);
+free_nodemask:
+	free_cpumask_var(nodemask);
+free_notcovered:
+#ifdef CONFIG_NUMA
+	free_cpumask_var(notcovered);
+free_covered:
+	free_cpumask_var(covered);
+free_domainspan:
+	free_cpumask_var(domainspan);
+out:
+#endif
+	return err;
+
+free_sched_groups:
+#ifdef CONFIG_NUMA
+	kfree(sched_group_nodes);
+#endif
+	goto free_tmpmask;
 
 #ifdef CONFIG_NUMA
 error:
 	free_sched_groups(cpu_map, tmpmask);
-	sched_cpumask_free(allmasks);
-	kfree(rd);
-	return -ENOMEM;
+	free_rootdomain(rd);
+	goto free_tmpmask;
 #endif
 }
 
-static int build_sched_domains(const cpumask_t *cpu_map)
+static int build_sched_domains(const struct cpumask *cpu_map)
 {
 	return __build_sched_domains(cpu_map, NULL);
 }
 
-static cpumask_t *doms_cur;	/* current sched domains */
+static struct cpumask *doms_cur;	/* current sched domains */
 static int ndoms_cur;		/* number of sched domains in 'doms_cur' */
 static struct sched_domain_attr *dattr_cur;
 				/* attribues of custom domains in 'doms_cur' */
 
 /*
  * Special case: If a kmalloc of a doms_cur partition (array of
- * cpumask_t) fails, then fallback to a single sched domain,
- * as determined by the single cpumask_t fallback_doms.
+ * cpumask) fails, then fallback to a single sched domain,
+ * as determined by the single cpumask fallback_doms.
  */
-static cpumask_t fallback_doms;
+static cpumask_var_t fallback_doms;
 
 void __attribute__((weak)) arch_update_cpu_topology(void)
 {
@@ -7671,16 +7723,16 @@ void __attribute__((weak)) arch_update_cpu_topology(void)
  * For now this just excludes isolated cpus, but could be used to
  * exclude other special cases in the future.
  */
-static int arch_init_sched_domains(const cpumask_t *cpu_map)
+static int arch_init_sched_domains(const struct cpumask *cpu_map)
 {
 	int err;
 
 	arch_update_cpu_topology();
 	ndoms_cur = 1;
-	doms_cur = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
+	doms_cur = kmalloc(cpumask_size(), GFP_KERNEL);
 	if (!doms_cur)
-		doms_cur = &fallback_doms;
-	cpus_andnot(*doms_cur, *cpu_map, cpu_isolated_map);
+		doms_cur = fallback_doms;
+	cpumask_andnot(doms_cur, cpu_map, cpu_isolated_map);
 	dattr_cur = NULL;
 	err = build_sched_domains(doms_cur);
 	register_sched_domain_sysctl();
@@ -7688,8 +7740,8 @@ static int arch_init_sched_domains(const cpumask_t *cpu_map)
 	return err;
 }
 
-static void arch_destroy_sched_domains(const cpumask_t *cpu_map,
-				       cpumask_t *tmpmask)
+static void arch_destroy_sched_domains(const struct cpumask *cpu_map,
+				       struct cpumask *tmpmask)
 {
 	free_sched_groups(cpu_map, tmpmask);
 }
@@ -7698,15 +7750,16 @@ static void arch_destroy_sched_domains(const cpumask_t *cpu_map,
  * Detach sched domains from a group of cpus specified in cpu_map
  * These cpus will now be attached to the NULL domain
  */
-static void detach_destroy_domains(const cpumask_t *cpu_map)
+static void detach_destroy_domains(const struct cpumask *cpu_map)
 {
-	cpumask_t tmpmask;
+	/* Save because hotplug lock held. */
+	static DECLARE_BITMAP(tmpmask, CONFIG_NR_CPUS);
 	int i;
 
-	for_each_cpu_mask_nr(i, *cpu_map)
+	for_each_cpu(i, cpu_map)
 		cpu_attach_domain(NULL, &def_root_domain, i);
 	synchronize_sched();
-	arch_destroy_sched_domains(cpu_map, &tmpmask);
+	arch_destroy_sched_domains(cpu_map, to_cpumask(tmpmask));
 }
 
 /* handle null as "default" */
@@ -7731,7 +7784,7 @@ static int dattrs_equal(struct sched_domain_attr *cur, int idx_cur,
  * doms_new[] to the current sched domain partitioning, doms_cur[].
  * It destroys each deleted domain and builds each new domain.
  *
- * 'doms_new' is an array of cpumask_t's of length 'ndoms_new'.
+ * 'doms_new' is an array of cpumask's of length 'ndoms_new'.
  * The masks don't intersect (don't overlap.) We should setup one
  * sched domain for each mask. CPUs not in any of the cpumasks will
  * not be load balanced. If the same cpumask appears both in the
@@ -7745,13 +7798,14 @@ static int dattrs_equal(struct sched_domain_attr *cur, int idx_cur,
  * the single partition 'fallback_doms', it also forces the domains
  * to be rebuilt.
  *
- * If doms_new == NULL it will be replaced with cpu_online_map.
+ * If doms_new == NULL it will be replaced with cpu_online_mask.
  * ndoms_new == 0 is a special case for destroying existing domains,
  * and it will not create the default domain.
  *
  * Call with hotplug lock held
  */
-void partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
+/* FIXME: Change to struct cpumask *doms_new[] */
+void partition_sched_domains(int ndoms_new, struct cpumask *doms_new,
 			     struct sched_domain_attr *dattr_new)
 {
 	int i, j, n;
@@ -7766,7 +7820,7 @@ void partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
 	/* Destroy deleted domains */
 	for (i = 0; i < ndoms_cur; i++) {
 		for (j = 0; j < n; j++) {
-			if (cpus_equal(doms_cur[i], doms_new[j])
+			if (cpumask_equal(&doms_cur[i], &doms_new[j])
 			    && dattrs_equal(dattr_cur, i, dattr_new, j))
 				goto match1;
 		}
@@ -7778,15 +7832,15 @@ match1:
 
 	if (doms_new == NULL) {
 		ndoms_cur = 0;
-		doms_new = &fallback_doms;
-		cpus_andnot(doms_new[0], cpu_online_map, cpu_isolated_map);
+		doms_new = fallback_doms;
+		cpumask_andnot(&doms_new[0], cpu_online_mask, cpu_isolated_map);
 		WARN_ON_ONCE(dattr_new);
 	}
 
 	/* Build new domains */
 	for (i = 0; i < ndoms_new; i++) {
 		for (j = 0; j < ndoms_cur; j++) {
-			if (cpus_equal(doms_new[i], doms_cur[j])
+			if (cpumask_equal(&doms_new[i], &doms_cur[j])
 			    && dattrs_equal(dattr_new, i, dattr_cur, j))
 				goto match2;
 		}
@@ -7798,7 +7852,7 @@ match2:
 	}
 
 	/* Remember the new sched domains */
-	if (doms_cur != &fallback_doms)
+	if (doms_cur != fallback_doms)
 		kfree(doms_cur);
 	kfree(dattr_cur);	/* kfree(NULL) is safe */
 	doms_cur = doms_new;
@@ -7938,7 +7992,9 @@ static int update_runtime(struct notifier_block *nfb,
 
 void __init sched_init_smp(void)
 {
-	cpumask_t non_isolated_cpus;
+	cpumask_var_t non_isolated_cpus;
+
+	alloc_cpumask_var(&non_isolated_cpus, GFP_KERNEL);
 
 #if defined(CONFIG_NUMA)
 	sched_group_nodes_bycpu = kzalloc(nr_cpu_ids * sizeof(void **),
@@ -7947,10 +8003,10 @@ void __init sched_init_smp(void)
 #endif
 	get_online_cpus();
 	mutex_lock(&sched_domains_mutex);
-	arch_init_sched_domains(&cpu_online_map);
-	cpus_andnot(non_isolated_cpus, cpu_possible_map, cpu_isolated_map);
-	if (cpus_empty(non_isolated_cpus))
-		cpu_set(smp_processor_id(), non_isolated_cpus);
+	arch_init_sched_domains(cpu_online_mask);
+	cpumask_andnot(non_isolated_cpus, cpu_possible_mask, cpu_isolated_map);
+	if (cpumask_empty(non_isolated_cpus))
+		cpumask_set_cpu(smp_processor_id(), non_isolated_cpus);
 	mutex_unlock(&sched_domains_mutex);
 	put_online_cpus();
 
@@ -7965,9 +8021,13 @@ void __init sched_init_smp(void)
 	init_hrtick();
 
 	/* Move init over to a non-isolated CPU */
-	if (set_cpus_allowed_ptr(current, &non_isolated_cpus) < 0)
+	if (set_cpus_allowed_ptr(current, non_isolated_cpus) < 0)
 		BUG();
 	sched_init_granularity();
+	free_cpumask_var(non_isolated_cpus);
+
+	alloc_cpumask_var(&fallback_doms, GFP_KERNEL);
+	init_sched_rt_class();
 }
 #else
 void __init sched_init_smp(void)
@@ -8282,6 +8342,13 @@ void __init sched_init(void)
 	 */
 	current->sched_class = &fair_sched_class;
 
+	/* Allocate the nohz_cpu_mask if CONFIG_CPUMASK_OFFSTACK */
+	alloc_bootmem_cpumask_var(&nohz_cpu_mask);
+#ifdef CONFIG_NO_HZ
+	alloc_bootmem_cpumask_var(&nohz.cpu_mask);
+#endif
+	alloc_bootmem_cpumask_var(&cpu_isolated_map);
+
 	scheduler_running = 1;
 }
 
diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index 52154fe..018b7be 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -67,24 +67,21 @@ static int convert_prio(int prio)
  * Returns: (int)bool - CPUs were found
  */
 int cpupri_find(struct cpupri *cp, struct task_struct *p,
-		cpumask_t *lowest_mask)
+		struct cpumask *lowest_mask)
 {
 	int                  idx      = 0;
 	int                  task_pri = convert_prio(p->prio);
 
 	for_each_cpupri_active(cp->pri_active, idx) {
 		struct cpupri_vec *vec  = &cp->pri_to_cpu[idx];
-		cpumask_t mask;
 
 		if (idx >= task_pri)
 			break;
 
-		cpus_and(mask, p->cpus_allowed, vec->mask);
-
-		if (cpus_empty(mask))
+		if (cpumask_any_and(&p->cpus_allowed, vec->mask) >= nr_cpu_ids)
 			continue;
 
-		*lowest_mask = mask;
+		cpumask_and(lowest_mask, &p->cpus_allowed, vec->mask);
 		return 1;
 	}
 
@@ -126,7 +123,7 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
 		vec->count--;
 		if (!vec->count)
 			clear_bit(oldpri, cp->pri_active);
-		cpu_clear(cpu, vec->mask);
+		cpumask_clear_cpu(cpu, vec->mask);
 
 		spin_unlock_irqrestore(&vec->lock, flags);
 	}
@@ -136,7 +133,7 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
 
 		spin_lock_irqsave(&vec->lock, flags);
 
-		cpu_set(cpu, vec->mask);
+		cpumask_set_cpu(cpu, vec->mask);
 		vec->count++;
 		if (vec->count == 1)
 			set_bit(newpri, cp->pri_active);
@@ -150,10 +147,11 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
 /**
  * cpupri_init - initialize the cpupri structure
  * @cp: The cpupri context
+ * @bootmem: true if allocations need to use bootmem
  *
- * Returns: (void)
+ * Returns: -ENOMEM if memory fails.
  */
-void cpupri_init(struct cpupri *cp)
+int cpupri_init(struct cpupri *cp, bool bootmem)
 {
 	int i;
 
@@ -164,11 +162,30 @@ void cpupri_init(struct cpupri *cp)
 
 		spin_lock_init(&vec->lock);
 		vec->count = 0;
-		cpus_clear(vec->mask);
+		if (bootmem)
+			alloc_bootmem_cpumask_var(&vec->mask);
+		else if (!alloc_cpumask_var(&vec->mask, GFP_KERNEL))
+			goto cleanup;
 	}
 
 	for_each_possible_cpu(i)
 		cp->cpu_to_pri[i] = CPUPRI_INVALID;
+	return 0;
+
+cleanup:
+	for (i--; i >= 0; i--)
+		free_cpumask_var(cp->pri_to_cpu[i].mask);
+	return -ENOMEM;
 }
 
+/**
+ * cpupri_cleanup - clean up the cpupri structure
+ * @cp: The cpupri context
+ */
+void cpupri_cleanup(struct cpupri *cp)
+{
+	int i;
 
+	for (i = 0; i < CPUPRI_NR_PRIORITIES; i++)
+		free_cpumask_var(cp->pri_to_cpu[i].mask);
+}
diff --git a/kernel/sched_cpupri.h b/kernel/sched_cpupri.h
index f25811b..642a94e 100644
--- a/kernel/sched_cpupri.h
+++ b/kernel/sched_cpupri.h
@@ -14,7 +14,7 @@
 struct cpupri_vec {
 	spinlock_t lock;
 	int        count;
-	cpumask_t  mask;
+	cpumask_var_t mask;
 };
 
 struct cpupri {
@@ -27,7 +27,8 @@ struct cpupri {
 int  cpupri_find(struct cpupri *cp,
 		 struct task_struct *p, cpumask_t *lowest_mask);
 void cpupri_set(struct cpupri *cp, int cpu, int pri);
-void cpupri_init(struct cpupri *cp);
+int cpupri_init(struct cpupri *cp, bool bootmem);
+void cpupri_cleanup(struct cpupri *cp);
 #else
 #define cpupri_set(cp, cpu, pri) do { } while (0)
 #define cpupri_init() do { } while (0)
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 98345e4..08ffffd 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1017,14 +1017,13 @@ static void yield_task_fair(struct rq *rq)
  * search starts with cpus closest then further out as needed,
  * so we always favor a closer, idle cpu.
  * Domains may include CPUs that are not usable for migration,
- * hence we need to mask them out (cpu_active_map)
+ * hence we need to mask them out (cpu_active_mask)
  *
  * Returns the CPU we should wake onto.
  */
 #if defined(ARCH_HAS_SCHED_WAKE_IDLE)
 static int wake_idle(int cpu, struct task_struct *p)
 {
-	cpumask_t tmp;
 	struct sched_domain *sd;
 	int i;
 
@@ -1044,10 +1043,9 @@ static int wake_idle(int cpu, struct task_struct *p)
 		if ((sd->flags & SD_WAKE_IDLE)
 		    || ((sd->flags & SD_WAKE_IDLE_FAR)
 			&& !task_hot(p, task_rq(p)->clock, sd))) {
-			cpus_and(tmp, sd->span, p->cpus_allowed);
-			cpus_and(tmp, tmp, cpu_active_map);
-			for_each_cpu_mask_nr(i, tmp) {
-				if (idle_cpu(i)) {
+			for_each_cpu_and(i, sched_domain_span(sd),
+					 &p->cpus_allowed) {
+				if (cpu_active(i) && idle_cpu(i)) {
 					if (i != task_cpu(p)) {
 						schedstat_inc(p,
 						       se.nr_wakeups_idle);
@@ -1240,13 +1238,13 @@ static int select_task_rq_fair(struct task_struct *p, int sync)
 	 * this_cpu and prev_cpu are present in:
 	 */
 	for_each_domain(this_cpu, sd) {
-		if (cpu_isset(prev_cpu, sd->span)) {
+		if (cpumask_test_cpu(prev_cpu, sched_domain_span(sd))) {
 			this_sd = sd;
 			break;
 		}
 	}
 
-	if (unlikely(!cpu_isset(this_cpu, p->cpus_allowed)))
+	if (unlikely(!cpumask_test_cpu(this_cpu, &p->cpus_allowed)))
 		goto out;
 
 	/*
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 2bdd444..fb39645 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -15,7 +15,7 @@ static inline void rt_set_overload(struct rq *rq)
 	if (!rq->online)
 		return;
 
-	cpu_set(rq->cpu, rq->rd->rto_mask);
+	cpumask_set_cpu(rq->cpu, rq->rd->rto_mask);
 	/*
 	 * Make sure the mask is visible before we set
 	 * the overload count. That is checked to determine
@@ -34,7 +34,7 @@ static inline void rt_clear_overload(struct rq *rq)
 
 	/* the order here really doesn't matter */
 	atomic_dec(&rq->rd->rto_count);
-	cpu_clear(rq->cpu, rq->rd->rto_mask);
+	cpumask_clear_cpu(rq->cpu, rq->rd->rto_mask);
 }
 
 static void update_rt_migration(struct rq *rq)
@@ -139,14 +139,14 @@ static int rt_se_boosted(struct sched_rt_entity *rt_se)
 }
 
 #ifdef CONFIG_SMP
-static inline cpumask_t sched_rt_period_mask(void)
+static inline const struct cpumask *sched_rt_period_mask(void)
 {
 	return cpu_rq(smp_processor_id())->rd->span;
 }
 #else
-static inline cpumask_t sched_rt_period_mask(void)
+static inline const struct cpumask *sched_rt_period_mask(void)
 {
-	return cpu_online_map;
+	return cpu_online_mask;
 }
 #endif
 
@@ -212,9 +212,9 @@ static inline int rt_rq_throttled(struct rt_rq *rt_rq)
 	return rt_rq->rt_throttled;
 }
 
-static inline cpumask_t sched_rt_period_mask(void)
+static inline const struct cpumask *sched_rt_period_mask(void)
 {
-	return cpu_online_map;
+	return cpu_online_mask;
 }
 
 static inline
@@ -241,11 +241,11 @@ static int do_balance_runtime(struct rt_rq *rt_rq)
 	int i, weight, more = 0;
 	u64 rt_period;
 
-	weight = cpus_weight(rd->span);
+	weight = cpumask_weight(rd->span);
 
 	spin_lock(&rt_b->rt_runtime_lock);
 	rt_period = ktime_to_ns(rt_b->rt_period);
-	for_each_cpu_mask_nr(i, rd->span) {
+	for_each_cpu(i, rd->span) {
 		struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
 		s64 diff;
 
@@ -324,7 +324,7 @@ static void __disable_runtime(struct rq *rq)
 		/*
 		 * Greedy reclaim, take back as much as we can.
 		 */
-		for_each_cpu_mask(i, rd->span) {
+		for_each_cpu(i, rd->span) {
 			struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
 			s64 diff;
 
@@ -429,13 +429,13 @@ static inline int balance_runtime(struct rt_rq *rt_rq)
 static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 {
 	int i, idle = 1;
-	cpumask_t span;
+	const struct cpumask *span;
 
 	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
 		return 1;
 
 	span = sched_rt_period_mask();
-	for_each_cpu_mask(i, span) {
+	for_each_cpu(i, span) {
 		int enqueue = 0;
 		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);
 		struct rq *rq = rq_of_rt_rq(rt_rq);
@@ -805,17 +805,20 @@ static int select_task_rq_rt(struct task_struct *p, int sync)
 
 static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 {
-	cpumask_t mask;
+	cpumask_var_t mask;
 
 	if (rq->curr->rt.nr_cpus_allowed == 1)
 		return;
 
-	if (p->rt.nr_cpus_allowed != 1
-	    && cpupri_find(&rq->rd->cpupri, p, &mask))
+	if (!alloc_cpumask_var(&mask, GFP_ATOMIC))
 		return;
 
-	if (!cpupri_find(&rq->rd->cpupri, rq->curr, &mask))
-		return;
+	if (p->rt.nr_cpus_allowed != 1
+	    && cpupri_find(&rq->rd->cpupri, p, mask))
+		goto free;
+
+	if (!cpupri_find(&rq->rd->cpupri, rq->curr, mask))
+		goto free;
 
 	/*
 	 * There appears to be other cpus that can accept
@@ -824,6 +827,8 @@ static void check_preempt_equal_prio(struct rq *rq, struct task_struct 
*p)
 	 */
 	requeue_task_rt(rq, p, 1);
 	resched_task(rq->curr);
+free:
+	free_cpumask_var(mask);
 }
 
 #endif /* CONFIG_SMP */
@@ -918,7 +923,7 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int 
sleep);
 static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
 {
 	if (!task_running(rq, p) &&
-	    (cpu < 0 || cpu_isset(cpu, p->cpus_allowed)) &&
+	    (cpu < 0 || cpumask_test_cpu(cpu, &p->cpus_allowed)) &&
 	    (p->rt.nr_cpus_allowed > 1))
 		return 1;
 	return 0;
@@ -957,7 +962,7 @@ static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int 
cpu)
 	return next;
 }
 
-static DEFINE_PER_CPU(cpumask_t, local_cpu_mask);
+static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);
 
 static inline int pick_optimal_cpu(int this_cpu, cpumask_t *mask)
 {
@@ -977,7 +982,7 @@ static inline int pick_optimal_cpu(int this_cpu, cpumask_t *mask)
 static int find_lowest_rq(struct task_struct *task)
 {
 	struct sched_domain *sd;
-	cpumask_t *lowest_mask = &__get_cpu_var(local_cpu_mask);
+	struct cpumask *lowest_mask = __get_cpu_var(local_cpu_mask);
 	int this_cpu = smp_processor_id();
 	int cpu      = task_cpu(task);
 
@@ -992,7 +997,7 @@ static int find_lowest_rq(struct task_struct *task)
 	 * I guess we might want to change cpupri_find() to ignore those
 	 * in the first place.
 	 */
-	cpus_and(*lowest_mask, *lowest_mask, cpu_active_map);
+	cpumask_and(lowest_mask, lowest_mask, cpu_active_mask);
 
 	/*
 	 * At this point we have built a mask of cpus representing the
@@ -1002,7 +1007,7 @@ static int find_lowest_rq(struct task_struct *task)
 	 * We prioritize the last cpu that the task executed on since
 	 * it is most likely cache-hot in that location.
 	 */
-	if (cpu_isset(cpu, *lowest_mask))
+	if (cpumask_test_cpu(cpu, lowest_mask))
 		return cpu;
 
 	/*
@@ -1017,7 +1022,8 @@ static int find_lowest_rq(struct task_struct *task)
 			cpumask_t domain_mask;
 			int       best_cpu;
 
-			cpus_and(domain_mask, sd->span, *lowest_mask);
+			cpumask_and(&domain_mask, sched_domain_span(sd),
+				    lowest_mask);
 
 			best_cpu = pick_optimal_cpu(this_cpu,
 						    &domain_mask);
@@ -1058,8 +1064,8 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct 
rq *rq)
 			 * Also make sure that it wasn't scheduled on its rq.
 			 */
 			if (unlikely(task_rq(task) != rq ||
-				     !cpu_isset(lowest_rq->cpu,
-						task->cpus_allowed) ||
+				     !cpumask_test_cpu(lowest_rq->cpu,
+						       &task->cpus_allowed) ||
 				     task_running(rq, task) ||
 				     !task->se.on_rq)) {
 
@@ -1180,7 +1186,7 @@ static int pull_rt_task(struct rq *this_rq)
 
 	next = pick_next_task_rt(this_rq);
 
-	for_each_cpu_mask_nr(cpu, this_rq->rd->rto_mask) {
+	for_each_cpu(cpu, this_rq->rd->rto_mask) {
 		if (this_cpu == cpu)
 			continue;
 
@@ -1309,9 +1315,9 @@ move_one_task_rt(struct rq *this_rq, int this_cpu, struct rq *busiest,
 }
 
 static void set_cpus_allowed_rt(struct task_struct *p,
-				const cpumask_t *new_mask)
+				const struct cpumask *new_mask)
 {
-	int weight = cpus_weight(*new_mask);
+	int weight = cpumask_weight(new_mask);
 
 	BUG_ON(!rt_task(p));
 
@@ -1332,7 +1338,7 @@ static void set_cpus_allowed_rt(struct task_struct *p,
 		update_rt_migration(rq);
 	}
 
-	p->cpus_allowed    = *new_mask;
+	cpumask_copy(&p->cpus_allowed, new_mask);
 	p->rt.nr_cpus_allowed = weight;
 }
 
@@ -1545,3 +1551,12 @@ static void print_rt_stats(struct seq_file *m, int cpu)
 	rcu_read_unlock();
 }
 #endif /* CONFIG_SCHED_DEBUG */
+
+/* Note that this is never called for !SMP, but that's OK. */
+static inline void init_sched_rt_class(void)
+{
+	unsigned int i;
+
+	for_each_possible_cpu(i)
+		alloc_cpumask_var(&per_cpu(local_cpu_mask, i), GFP_KERNEL);
+}
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 7dbf72a..ce34083 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -42,7 +42,8 @@ static int show_schedstat(struct seq_file *seq, void *v)
 		for_each_domain(cpu, sd) {
 			enum cpu_idle_type itype;
 
-			cpumask_scnprintf(mask_str, mask_len, sd->span);
+			cpumask_scnprintf(mask_str, mask_len,
+					  *sched_domain_span(sd));
 			seq_printf(seq, "domain%d %s", dcount++, mask_str);
 			for (itype = CPU_IDLE; itype < CPU_MAX_IDLE_TYPES;
 					itype++) {
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 342fc9c..70f872c 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -144,7 +144,7 @@ void tick_nohz_update_jiffies(void)
 	if (!ts->tick_stopped)
 		return;
 
-	cpu_clear(cpu, nohz_cpu_mask);
+	cpumask_clear_cpu(cpu, nohz_cpu_mask);
 	now = ktime_get();
 	ts->idle_waketime = now;
 
@@ -283,7 +283,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 	if ((long)delta_jiffies >= 1) {
 
 		if (delta_jiffies > 1)
-			cpu_set(cpu, nohz_cpu_mask);
+			cpumask_set_cpu(cpu, nohz_cpu_mask);
 		/*
 		 * nohz_stop_sched_tick can be called several times before
 		 * the nohz_restart_sched_tick is called. This happens when
@@ -296,7 +296,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 				/*
 				 * sched tick not stopped!
 				 */
-				cpu_clear(cpu, nohz_cpu_mask);
+				cpumask_clear_cpu(cpu, nohz_cpu_mask);
 				goto out;
 			}
 
@@ -354,7 +354,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 		 * softirq.
 		 */
 		tick_do_update_jiffies64(ktime_get());
-		cpu_clear(cpu, nohz_cpu_mask);
+		cpumask_clear_cpu(cpu, nohz_cpu_mask);
 	}
 	raise_softirq_irqoff(TIMER_SOFTIRQ);
 out:
@@ -432,7 +432,7 @@ void tick_nohz_restart_sched_tick(void)
 	select_nohz_load_balancer(0);
 	now = ktime_get();
 	tick_do_update_jiffies64(now);
-	cpu_clear(cpu, nohz_cpu_mask);
+	cpumask_clear_cpu(cpu, nohz_cpu_mask);
 
 	/*
 	 * We stopped the tick in idle. Update process times would miss the

