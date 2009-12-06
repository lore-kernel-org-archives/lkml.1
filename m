Return-Path: <linux-kernel-owner+w=401wt.eu-S1757812AbZLFU2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbZLFU2N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 15:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757693AbZLFU2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 15:28:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:51932 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757543AbZLFU2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 15:28:09 -0500
Date: Sun, 6 Dec 2009 20:27:34 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix balance vs hotplug race
Message-ID: <tip-6ad4c18884e864cf4c77f9074d3d1816063f99cd@git.kernel.org>
Git-Commit-ID: 6ad4c18884e864cf4c77f9074d3d1816063f99cd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6ad4c18884e864cf4c77f9074d3d1816063f99cd
Gitweb:     http://git.kernel.org/tip/6ad4c18884e864cf4c77f9074d3d1816063f99cd
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 25 Nov 2009 13:31:39 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 6 Dec 2009 21:10:56 +0100

sched: Fix balance vs hotplug race

Since (e761b77: cpu hotplug, sched: Introduce cpu_active_map and redo
sched domain managment) we have cpu_active_mask which is suppose to rule
scheduler migration and load-balancing, except it never (fully) did.

The particular problem being solved here is a crash in try_to_wake_up()
where select_task_rq() ends up selecting an offline cpu because
select_task_rq_fair() trusts the sched_domain tree to reflect the
current state of affairs, similarly select_task_rq_rt() trusts the
root_domain.

However, the sched_domains are updated from CPU_DEAD, which is after the
cpu is taken offline and after stop_machine is done. Therefore it can
race perfectly well with code assuming the domains are right.

Cure this by building the domains from cpu_active_mask on
CPU_DOWN_PREPARE.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/cpumask.h |    2 ++
 kernel/cpu.c            |   18 +++++++++++++-----
 kernel/cpuset.c         |   16 +++++++++-------
 kernel/sched.c          |   32 +++++++++++++++++---------------
 4 files changed, 41 insertions(+), 27 deletions(-)

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
index 43fb7e8..ba401fa 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
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
index aa31244..281da29 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4134,7 +4134,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	unsigned long flags;
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
-	cpumask_copy(cpus, cpu_online_mask);
+	cpumask_copy(cpus, cpu_active_mask);
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -4297,7 +4297,7 @@ load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd)
 	int all_pinned = 0;
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
-	cpumask_copy(cpus, cpu_online_mask);
+	cpumask_copy(cpus, cpu_active_mask);
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -4694,7 +4694,7 @@ int select_nohz_load_balancer(int stop_tick)
 		cpumask_set_cpu(cpu, nohz.cpu_mask);
 
 		/* time for ilb owner also to sleep */
-		if (cpumask_weight(nohz.cpu_mask) == num_online_cpus()) {
+		if (cpumask_weight(nohz.cpu_mask) == num_active_cpus()) {
 			if (atomic_read(&nohz.load_balancer) == cpu)
 				atomic_set(&nohz.load_balancer, -1);
 			return 0;
@@ -7093,7 +7093,7 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 	int ret = 0;
 
 	rq = task_rq_lock(p, &flags);
-	if (!cpumask_intersects(new_mask, cpu_online_mask)) {
+	if (!cpumask_intersects(new_mask, cpu_active_mask)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -7115,7 +7115,7 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 	if (cpumask_test_cpu(task_cpu(p), new_mask))
 		goto out;
 
-	if (migrate_task(p, cpumask_any_and(cpu_online_mask, new_mask), &req)) {
+	if (migrate_task(p, cpumask_any_and(cpu_active_mask, new_mask), &req)) {
 		/* Need help from migration thread: drop lock and wait. */
 		struct task_struct *mt = rq->migration_thread;
 
@@ -7269,19 +7269,19 @@ static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 
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
@@ -7310,7 +7310,7 @@ move:
  */
 static void migrate_nr_uninterruptible(struct rq *rq_src)
 {
-	struct rq *rq_dest = cpu_rq(cpumask_any(cpu_online_mask));
+	struct rq *rq_dest = cpu_rq(cpumask_any(cpu_active_mask));
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -7564,7 +7564,7 @@ static ctl_table *sd_alloc_ctl_cpu_table(int cpu)
 static struct ctl_table_header *sd_sysctl_header;
 static void register_sched_domain_sysctl(void)
 {
-	int i, cpu_num = num_online_cpus();
+	int i, cpu_num = num_possible_cpus();
 	struct ctl_table *entry = sd_alloc_ctl_entry(cpu_num + 1);
 	char buf[32];
 
@@ -7574,7 +7574,7 @@ static void register_sched_domain_sysctl(void)
 	if (entry == NULL)
 		return;
 
-	for_each_online_cpu(i) {
+	for_each_possible_cpu(i) {
 		snprintf(buf, 32, "cpu%d", i);
 		entry->procname = kstrdup(buf, GFP_KERNEL);
 		entry->mode = 0555;
@@ -9100,7 +9100,7 @@ match1:
 	if (doms_new == NULL) {
 		ndoms_cur = 0;
 		doms_new = &fallback_doms;
-		cpumask_andnot(doms_new[0], cpu_online_mask, cpu_isolated_map);
+		cpumask_andnot(doms_new[0], cpu_active_mask, cpu_isolated_map);
 		WARN_ON_ONCE(dattr_new);
 	}
 
@@ -9231,8 +9231,10 @@ static int update_sched_domains(struct notifier_block *nfb,
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
 
@@ -9279,7 +9281,7 @@ void __init sched_init_smp(void)
 #endif
 	get_online_cpus();
 	mutex_lock(&sched_domains_mutex);
-	arch_init_sched_domains(cpu_online_mask);
+	arch_init_sched_domains(cpu_active_mask);
 	cpumask_andnot(non_isolated_cpus, cpu_possible_mask, cpu_isolated_map);
 	if (cpumask_empty(non_isolated_cpus))
 		cpumask_set_cpu(smp_processor_id(), non_isolated_cpus);
