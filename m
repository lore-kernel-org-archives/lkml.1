Return-Path: <linux-kernel-owner+w=401wt.eu-S1756422AbYGOI6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422AbYGOI6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 04:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbYGOI6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 04:58:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55448 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbYGOI6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 04:58:09 -0400
Date: Tue, 15 Jul 2008 10:57:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
Message-ID: <20080715085738.GA6325@elte.hu>
References: <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org> <b647ffbd0807141538g2004f245m5f54ec962f475ba5@mail.gmail.com> <alpine.LFD.1.10.0807141602250.3017@woody.linux-foundation.org> <b647ffbd0807141700s20e54fbewafb3d3e296e57f53@mail.gmail.com> <alpine.LFD.1.10.0807141707410.3017@woody.linux-foundation.org> <b647ffbd0807141921n13ffa59x416fc024c734ef02@mail.gmail.com> <487C1374.8020404@qualcomm.com> <alpine.LFD.1.10.0807142104250.3017@woody.linux-foundation.org> <20080715083223.GA2600@elte.hu> <487C62FB.6030304@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487C62FB.6030304@qualcomm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Max Krasnyansky <maxk@qualcomm.com> wrote:

> Ingo Molnar wrote:
>> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>>> On Mon, 14 Jul 2008, Max Krasnyansky wrote:
>>>> Did you guys an updated patch ? Dmitry pointed out several things that Linus
>>>> missed in his original version. I guess I can go through the thread and
>>>> reconstruct that but if you have a patch I can try let me know.
>>> I didn't update it, and right now I'm just merging too much (and  
>>> discussing the merges) to have time.
>>>
>>> The patch really needs to have some scheduler person look at the use  
>>> fo cpu_active_map - I was kind of hoping that Ingo would.
>>
>> yeah - it's very high on our TODO list :-) Peter, Dmitry and me are  
>> looking into it.
>>
>> I didnt touch most of -tip in the past few days to get a rock solid QA  
>> track record for all items we have.
>
> I just sent you guys a patch. Please take a look. I've probably missed 
> something but it should close (I think). Also we'd probably at least 
> want the bits that streamline the domain reinitialization because it 
> helps with cpusets (ie uses same exact path for all cases).

thanks Max. Since upstream already has Dmitry's it conflicted with your 
patch - i fixed the interactions up, see it below. (completely untested)

It's not ready for inclusion yet though - these new
#ifdefs are quite ugly:

 +#if !defined(CONFIG_CPUSETS)
 +       partition_sched_domains(0, NULL, NULL);
 +#else
 +       rebuild_sched_domains();
 +#endif

we should just have a single method for refreshing sched domains 
hierarchy, and in the !CONFIG_CPUSETS case that should simply fall back 
to partition_sched_domains().

We can do that by making rebuild_sched_domains() the primary method that 
is called - and in the !CPUSETS case it's an inline that calls 
partition_sched_domains().

also, small nits:

use #ifdef CONFIG_CPUSETS instead of "#if !defined(CONFIG_CPUSETS)".

and while at it:

 +#if !defined(CONFIG_CPUSETS)
         /* XXX: Theoretical race here - CPU may be hotplugged now */
         hotcpu_notifier(update_sched_domains, 0);
 +#endif

that race should be closed now, hm?

	Ingo

------------------>
Subject: cpu hotplug, sched: introduce cpu_active_map and redo sched domain managment
From: Max Krasnyansky <maxk@qualcomm.com>
Date: Tue, 15 Jul 2008 01:40:10 -0700

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
Cc: ghaskins@novell.com
Cc: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: dmitry.adamushko@gmail.com
Cc: a.p.zijlstra@chello.nl
Cc: torvalds@linux-foundation.org
Cc: pj@sgi.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/cpumask.h |    6 ++
 init/main.c             |    7 +++
 kernel/cpu.c            |   30 +++++++++++---
 kernel/sched.c          |  100 ++++++++++++++----------------------------------
 kernel/sched_fair.c     |    2 
 kernel/sched_rt.c       |    5 ++
 6 files changed, 74 insertions(+), 76 deletions(-)

Index: tip/include/linux/cpumask.h
===================================================================
--- tip.orig/include/linux/cpumask.h
+++ tip/include/linux/cpumask.h
@@ -396,13 +396,14 @@ int __next_cpu_nr(int n, const cpumask_t
 
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
@@ -453,6 +454,7 @@ int __next_cpu_nr(int n, const cpumask_t
 extern cpumask_t cpu_possible_map;
 extern cpumask_t cpu_online_map;
 extern cpumask_t cpu_present_map;
+extern cpumask_t cpu_active_map;
 
 #if NR_CPUS > 1
 #define num_online_cpus()	cpus_weight_nr(cpu_online_map)
@@ -461,6 +463,7 @@ extern cpumask_t cpu_present_map;
 #define cpu_online(cpu)		cpu_isset((cpu), cpu_online_map)
 #define cpu_possible(cpu)	cpu_isset((cpu), cpu_possible_map)
 #define cpu_present(cpu)	cpu_isset((cpu), cpu_present_map)
+#define cpu_active(cpu)		cpu_isset((cpu), cpu_active_map)
 #else
 #define num_online_cpus()	1
 #define num_possible_cpus()	1
@@ -468,6 +471,7 @@ extern cpumask_t cpu_present_map;
 #define cpu_online(cpu)		((cpu) == 0)
 #define cpu_possible(cpu)	((cpu) == 0)
 #define cpu_present(cpu)	((cpu) == 0)
+#define cpu_active(cpu)		((cpu) == 0)
 #endif
 
 #define cpu_is_offline(cpu)	unlikely(!cpu_online(cpu))
Index: tip/init/main.c
===================================================================
--- tip.orig/init/main.c
+++ tip/init/main.c
@@ -417,6 +417,13 @@ static void __init smp_init(void)
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
Index: tip/kernel/cpu.c
===================================================================
--- tip.orig/kernel/cpu.c
+++ tip/kernel/cpu.c
@@ -64,6 +64,8 @@ void __init cpu_hotplug_init(void)
 	cpu_hotplug.refcount = 0;
 }
 
+cpumask_t cpu_active_map;
+
 #ifdef CONFIG_HOTPLUG_CPU
 
 void get_online_cpus(void)
@@ -291,11 +293,20 @@ int __ref cpu_down(unsigned int cpu)
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
@@ -354,11 +365,18 @@ int __cpuinit cpu_up(unsigned int cpu)
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
Index: tip/kernel/sched.c
===================================================================
--- tip.orig/kernel/sched.c
+++ tip/kernel/sched.c
@@ -2877,7 +2877,7 @@ static void sched_migrate_task(struct ta
 
 	rq = task_rq_lock(p, &flags);
 	if (!cpu_isset(dest_cpu, p->cpus_allowed)
-	    || unlikely(cpu_is_offline(dest_cpu)))
+	    || unlikely(!cpu_active(dest_cpu)))
 		goto out;
 
 	trace_kernel_sched_migrate_task(p, cpu_of(rq), dest_cpu);
@@ -3846,7 +3846,7 @@ int select_nohz_load_balancer(int stop_t
 		/*
 		 * If we are going offline and still the leader, give up!
 		 */
-		if (cpu_is_offline(cpu) &&
+		if (!cpu_active(cpu) &&
 		    atomic_read(&nohz.load_balancer) == cpu) {
 			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
 				BUG();
@@ -5868,7 +5868,7 @@ static int __migrate_task(struct task_st
 	struct rq *rq_dest, *rq_src;
 	int ret = 0, on_rq;
 
-	if (unlikely(cpu_is_offline(dest_cpu)))
+	if (unlikely(!cpu_active(dest_cpu)))
 		return ret;
 
 	rq_src = cpu_rq(src_cpu);
@@ -7545,18 +7545,6 @@ void __attribute__((weak)) arch_update_c
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
@@ -7634,7 +7622,7 @@ static int dattrs_equal(struct sched_dom
  * ownership of it and will kfree it when done with it. If the caller
  * failed the kmalloc call, then it can pass in doms_new == NULL,
  * and partition_sched_domains() will fallback to the single partition
- * 'fallback_doms'.
+ * 'fallback_doms', it also forces the domains to be rebuilt.
  *
  * Call with hotplug lock held
  */
@@ -7648,12 +7636,8 @@ void partition_sched_domains(int ndoms_n
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
@@ -7668,6 +7652,14 @@ match1:
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
@@ -7698,17 +7690,15 @@ match2:
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
@@ -7774,60 +7764,28 @@ int sched_create_sysfs_power_savings_ent
 }
 #endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
 
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
-	int cpu = (int)(long)hcpu;
-
 	switch (action) {
-	case CPU_DOWN_PREPARE:
-	case CPU_DOWN_PREPARE_FROZEN:
-		disable_runtime(cpu_rq(cpu));
-		/* fall-through */
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		detach_destroy_domains(&cpu_online_map);
-		free_sched_domains();
-		return NOTIFY_OK;
-
-
-	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		enable_runtime(cpu_rq(cpu));
-		/* fall-through */
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
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
+}
 #endif
 
-	return NOTIFY_OK;
-}
 
 void __init sched_init_smp(void)
 {
@@ -7846,8 +7804,12 @@ void __init sched_init_smp(void)
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
Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -1004,6 +1004,8 @@ static void yield_task_fair(struct rq *r
  * not idle and an idle cpu is available.  The span of cpus to
  * search starts with cpus closest then further out as needed,
  * so we always favor a closer, idle cpu.
+ * Domains may include CPUs that are not usable for migration,
+ * hence we need to mask them out (cpu_active_map)
  *
  * Returns the CPU we should wake onto.
  */
Index: tip/kernel/sched_rt.c
===================================================================
--- tip.orig/kernel/sched_rt.c
+++ tip/kernel/sched_rt.c
@@ -915,6 +915,11 @@ static int find_lowest_rq(struct task_st
 	int this_cpu = smp_processor_id();
 	int cpu      = task_cpu(task);
 
+	/*
+	 * Only consider CPUs that are usable for migration.
+	 */ 
+	cpus_and(*lowest_mask, *lowest_mask, cpu_active_map);
+
 	if (task->rt.nr_cpus_allowed == 1)
 		return -1; /* No other targets possible */
 

