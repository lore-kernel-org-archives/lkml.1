Return-Path: <linux-kernel-owner+w=401wt.eu-S1758004AbYGOIk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbYGOIk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 04:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbYGOIkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 04:40:17 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10139 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765AbYGOIkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 04:40:14 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5338"; a="4545851"
From: Max Krasnyansky <maxk@qualcomm.com>
To: mingo@elte.hu, dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, pj@sgi.com
Cc: ghaskins@novell.com, linux-kernel@vger.kernel.org,
       Max Krasnyanskiy <maxk@qualcomm.com>
Subject: [PATCH] cpu hotplug, sched: Introduce cpu_active_map and redo sched domain managment
Date: Tue, 15 Jul 2008 01:40:10 -0700
Message-Id: <1216111210-8318-1-git-send-email-maxk@qualcomm.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Max Krasnyanskiy <maxk@qualcomm.com>

This is based on Linus' idea of creating cpu_active_map that prevents
scheduler load balancer from migrating tasks to the cpu that is going
down.

It allows us to simplify domain management code and avoid unecessary
domain rebuilds during cpu hotplug event handling.

Please ignore the cpusets part for now. It needs some more work in order
to avoid crazy lock nesting. Although I did simplfy and unify domain
reinitialization logic. We now simply call partition_sched_domains() in
all the cases. This means that we're using exact same code paths as in
cpusets case and hence the test below cover cpusets too.

This not only boots but also easily handles
	while true; do make clean; make -j 8; done
and
	while true; do on-off-cpu 1; done
at the same time.
(on-off-cpu 1 simple does echo 0/1 > /sys/.../cpu1/online thing).

Suprising the box (dualcore Core2) is quite usable. In fact I'm typing
this on right now in gnome-terminal and things are moving just fine.

I beleive I addressed all of the Dmitry's comments for original Linus'
version. I changed both fair and rt balancer to mask out non-active cpus.
And replaced cpu_is_offline() with !cpu_active() in the main scheduler
code where it made sense (to me).

I've probably missed something but I'd dare to say consider for the
inclusion ;-)

Signed-off-by: Max Krasnyanskiy <maxk@qualcomm.com>
---
 include/linux/cpumask.h |    6 ++-
 init/main.c             |    7 +++
 kernel/cpu.c            |   30 ++++++++++++---
 kernel/sched.c          |   94 +++++++++++++++-------------------------------
 kernel/sched_fair.c     |    3 +
 kernel/sched_rt.c       |    5 ++
 6 files changed, 75 insertions(+), 70 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index c24875b..d614d24 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -359,13 +359,14 @@ static inline void __cpus_fold(cpumask_t *dstp, const cpumask_t *origp,
 
 /*
  * The following particular system cpumasks and operations manage
- * possible, present and online cpus.  Each of them is a fixed size
+ * possible, present, active and online cpus.  Each of them is a fixed size
  * bitmap of size NR_CPUS.
  *
  *  #ifdef CONFIG_HOTPLUG_CPU
  *     cpu_possible_map - has bit 'cpu' set iff cpu is populatable
  *     cpu_present_map  - has bit 'cpu' set iff cpu is populated
  *     cpu_online_map   - has bit 'cpu' set iff cpu available to scheduler
+ *     cpu_active_map   - has bit 'cpu' set iff cpu available to migration
  *  #else
  *     cpu_possible_map - has bit 'cpu' set iff cpu is populated
  *     cpu_present_map  - copy of cpu_possible_map
@@ -416,6 +417,7 @@ static inline void __cpus_fold(cpumask_t *dstp, const cpumask_t *origp,
 extern cpumask_t cpu_possible_map;
 extern cpumask_t cpu_online_map;
 extern cpumask_t cpu_present_map;
+extern cpumask_t cpu_active_map;
 
 #if NR_CPUS > 1
 #define num_online_cpus()	cpus_weight(cpu_online_map)
@@ -424,6 +426,7 @@ extern cpumask_t cpu_present_map;
 #define cpu_online(cpu)		cpu_isset((cpu), cpu_online_map)
 #define cpu_possible(cpu)	cpu_isset((cpu), cpu_possible_map)
 #define cpu_present(cpu)	cpu_isset((cpu), cpu_present_map)
+#define cpu_active(cpu)		cpu_isset((cpu), cpu_active_map)
 #else
 #define num_online_cpus()	1
 #define num_possible_cpus()	1
@@ -431,6 +434,7 @@ extern cpumask_t cpu_present_map;
 #define cpu_online(cpu)		((cpu) == 0)
 #define cpu_possible(cpu)	((cpu) == 0)
 #define cpu_present(cpu)	((cpu) == 0)
+#define cpu_active(cpu)		((cpu) == 0)
 #endif
 
 #define cpu_is_offline(cpu)	unlikely(!cpu_online(cpu))
diff --git a/init/main.c b/init/main.c
index f7fb200..bfccff6 100644
--- a/init/main.c
+++ b/init/main.c
@@ -414,6 +414,13 @@ static void __init smp_init(void)
 {
 	unsigned int cpu;
 
+	/*
+	 * Set up the current CPU as possible to migrate to.
+	 * The other ones will be done by cpu_up/cpu_down()
+	 */
+	cpu = smp_processor_id();
+	cpu_set(cpu, cpu_active_map);
+
 	/* FIXME: This should be done in userspace --RR */
 	for_each_present_cpu(cpu) {
 		if (num_online_cpus() >= setup_max_cpus)
diff --git a/kernel/cpu.c b/kernel/cpu.c
index c77bc3a..cc1f2bc 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -42,6 +42,8 @@ void __init cpu_hotplug_init(void)
 	cpu_hotplug.refcount = 0;
 }
 
+cpumask_t cpu_active_map;
+
 #ifdef CONFIG_HOTPLUG_CPU
 
 void get_online_cpus(void)
@@ -269,11 +271,20 @@ int __ref cpu_down(unsigned int cpu)
 	int err = 0;
 
 	cpu_maps_update_begin();
-	if (cpu_hotplug_disabled)
+
+	if (cpu_hotplug_disabled) {
 		err = -EBUSY;
-	else
-		err = _cpu_down(cpu, 0);
+		goto out;
+	}
+
+	cpu_clear(cpu, cpu_active_map);
+
+	err = _cpu_down(cpu, 0);
+
+	if (cpu_online(cpu))
+		cpu_set(cpu, cpu_active_map);
 
+out:
 	cpu_maps_update_done();
 	return err;
 }
@@ -332,11 +343,18 @@ int __cpuinit cpu_up(unsigned int cpu)
 	}
 
 	cpu_maps_update_begin();
-	if (cpu_hotplug_disabled)
+
+	if (cpu_hotplug_disabled) {
 		err = -EBUSY;
-	else
-		err = _cpu_up(cpu, 0);
+		goto out;
+	}
 
+	err = _cpu_up(cpu, 0);
+
+	if (cpu_online(cpu))
+		cpu_set(cpu, cpu_active_map);
+
+out:
 	cpu_maps_update_done();
 	return err;
 }
diff --git a/kernel/sched.c b/kernel/sched.c
index 4e2f603..6b42613 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2680,7 +2680,7 @@ static void sched_migrate_task(struct task_struct *p, int dest_cpu)
 
 	rq = task_rq_lock(p, &flags);
 	if (!cpu_isset(dest_cpu, p->cpus_allowed)
-	    || unlikely(cpu_is_offline(dest_cpu)))
+	    || unlikely(!cpu_active(dest_cpu)))
 		goto out;
 
 	/* force the process onto the specified CPU */
@@ -3621,7 +3621,7 @@ int select_nohz_load_balancer(int stop_tick)
 		/*
 		 * If we are going offline and still the leader, give up!
 		 */
-		if (cpu_is_offline(cpu) &&
+		if (!cpu_active(cpu) &&
 		    atomic_read(&nohz.load_balancer) == cpu) {
 			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
 				BUG();
@@ -5613,7 +5613,7 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 	struct rq *rq_dest, *rq_src;
 	int ret = 0, on_rq;
 
-	if (unlikely(cpu_is_offline(dest_cpu)))
+	if (unlikely(!cpu_active(dest_cpu)))
 		return ret;
 
 	rq_src = cpu_rq(src_cpu);
@@ -7243,18 +7243,6 @@ void __attribute__((weak)) arch_update_cpu_topology(void)
 }
 
 /*
- * Free current domain masks.
- * Called after all cpus are attached to NULL domain.
- */
-static void free_sched_domains(void)
-{
-	ndoms_cur = 0;
-	if (doms_cur != &fallback_doms)
-		kfree(doms_cur);
-	doms_cur = &fallback_doms;
-}
-
-/*
  * Set up scheduler domains and groups. Callers must hold the hotplug lock.
  * For now this just excludes isolated cpus, but could be used to
  * exclude other special cases in the future.
@@ -7332,7 +7320,7 @@ static int dattrs_equal(struct sched_domain_attr *cur, int idx_cur,
  * ownership of it and will kfree it when done with it. If the caller
  * failed the kmalloc call, then it can pass in doms_new == NULL,
  * and partition_sched_domains() will fallback to the single partition
- * 'fallback_doms'.
+ * 'fallback_doms', it also forces the domains to be rebuilt.
  *
  * Call with hotplug lock held
  */
@@ -7346,12 +7334,8 @@ void partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
 	/* always unregister in case we don't destroy any domains */
 	unregister_sched_domain_sysctl();
 
-	if (doms_new == NULL) {
-		ndoms_new = 1;
-		doms_new = &fallback_doms;
-		cpus_andnot(doms_new[0], cpu_online_map, cpu_isolated_map);
-		dattr_new = NULL;
-	}
+	if (doms_new == NULL)
+		ndoms_new = 0;
 
 	/* Destroy deleted domains */
 	for (i = 0; i < ndoms_cur; i++) {
@@ -7366,6 +7350,14 @@ match1:
 		;
 	}
 
+	if (doms_new == NULL) {
+		ndoms_cur = 0;
+		ndoms_new = 1;
+		doms_new = &fallback_doms;
+		cpus_andnot(doms_new[0], cpu_online_map, cpu_isolated_map);
+		dattr_new = NULL;
+	}
+
 	/* Build new domains */
 	for (i = 0; i < ndoms_new; i++) {
 		for (j = 0; j < ndoms_cur; j++) {
@@ -7396,17 +7388,15 @@ match2:
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
 int arch_reinit_sched_domains(void)
 {
-	int err;
-
 	get_online_cpus();
-	mutex_lock(&sched_domains_mutex);
-	detach_destroy_domains(&cpu_online_map);
-	free_sched_domains();
-	err = arch_init_sched_domains(&cpu_online_map);
-	mutex_unlock(&sched_domains_mutex);
+#if !defined(CONFIG_CPUSETS)
+	partition_sched_domains(0, NULL, NULL);
+#else
+	rebuild_sched_domains();
+#endif
 	put_online_cpus();
 
-	return err;
+	return 0;
 }
 
 static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
@@ -7472,53 +7462,27 @@ int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
 }
 #endif
 
+#if !defined(CONFIG_CPUSETS)
 /*
- * Force a reinitialization of the sched domains hierarchy. The domains
- * and groups cannot be updated in place without racing with the balancing
- * code, so we temporarily attach all running cpus to the NULL domain
- * which will prevent rebalancing while the sched domains are recalculated.
+ * Add online and remove offline CPUs from the scheduler domains.
+ * When CPUSETS are enabled they take over this function.
  */
 static int update_sched_domains(struct notifier_block *nfb,
 				unsigned long action, void *hcpu)
 {
 	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
-		detach_destroy_domains(&cpu_online_map);
-		free_sched_domains();
-		return NOTIFY_OK;
-
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		/*
-		 * Fall through and re-initialise the domains.
-		 */
-		break;
+		partition_sched_domains(0, NULL, NULL);
+		return NOTIFY_OK;
+
 	default:
 		return NOTIFY_DONE;
 	}
-
-#ifndef CONFIG_CPUSETS
-	/*
-	 * Create default domain partitioning if cpusets are disabled.
-	 * Otherwise we let cpusets rebuild the domains based on the
-	 * current setup.
-	 */
-
-	/* The hotplug lock is already held by cpu_up/cpu_down */
-	arch_init_sched_domains(&cpu_online_map);
-#endif
-
-	return NOTIFY_OK;
 }
+#endif
 
 void __init sched_init_smp(void)
 {
@@ -7537,8 +7501,12 @@ void __init sched_init_smp(void)
 		cpu_set(smp_processor_id(), non_isolated_cpus);
 	mutex_unlock(&sched_domains_mutex);
 	put_online_cpus();
+
+#if !defined(CONFIG_CPUSETS)
 	/* XXX: Theoretical race here - CPU may be hotplugged now */
 	hotcpu_notifier(update_sched_domains, 0);
+#endif
+
 	init_hrtick();
 
 	/* Move init over to a non-isolated CPU */
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 08ae848..729bc82 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -934,6 +934,8 @@ static void yield_task_fair(struct rq *rq)
  * not idle and an idle cpu is available.  The span of cpus to
  * search starts with cpus closest then further out as needed,
  * so we always favor a closer, idle cpu.
+ * Domains may include CPUs that are not usable for migration,
+ * hence we need to mask them out (cpu_active_map)
  *
  * Returns the CPU we should wake onto.
  */
@@ -961,6 +963,7 @@ static int wake_idle(int cpu, struct task_struct *p)
 		    || ((sd->flags & SD_WAKE_IDLE_FAR)
 			&& !task_hot(p, task_rq(p)->clock, sd))) {
 			cpus_and(tmp, sd->span, p->cpus_allowed);
+			cpus_and(tmp, tmp, cpu_active_map);
 			for_each_cpu_mask(i, tmp) {
 				if (idle_cpu(i)) {
 					if (i != task_cpu(p)) {
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 0f3c191..e2ee368 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -730,6 +730,11 @@ static int find_lowest_cpus(struct task_struct *task, cpumask_t *lowest_mask)
 	cpus_and(*lowest_mask, task_rq(task)->rd->online, task->cpus_allowed);
 
 	/*
+	 * Only consider CPUs that are usable for migration.
+	 */ 
+	cpus_and(*lowest_mask, *lowest_mask, cpu_active_map);
+
+	/*
 	 * Scan each rq for the lowest prio.
 	 */
 	for_each_cpu_mask(cpu, *lowest_mask) {
-- 
1.5.5.1

