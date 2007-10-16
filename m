Return-Path: <linux-kernel-owner+w=401wt.eu-S933635AbXJPKg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635AbXJPKg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 06:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932539AbXJPKgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 06:36:48 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:37671 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367AbXJPKgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 06:36:46 -0400
Date: Tue, 16 Oct 2007 16:06:37 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Rusty Russel <rusty@rustcorp.com.au>,
       Dipankar Sarma <dipankar@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@us.ibm.com>
Subject: [RFC PATCH 3/4] Replace per-subsystem mutexes with get_online_cpus
Message-ID: <20071016103637.GC16570@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071016103308.GA9907@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016103308.GA9907@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the known per-subsystem cpu_hotplug mutexes to 
get_online_cpus put_online_cpus. 
It also eliminates the CPU_LOCK_ACQUIRE and CPU_LOCK_RELEASE hotplug 
notification events.

Signed-off-by: Gautham  R Shenoy <ego@in.ibm.com>
---
 include/linux/notifier.h |    4 +---
 kernel/cpu.c             |    4 ----
 kernel/sched.c           |   27 ++++++++++-----------------
 kernel/workqueue.c       |   31 ++++++++++++++++---------------
 mm/slab.c                |   18 +++++++++++-------
 5 files changed, 38 insertions(+), 46 deletions(-)

Index: linux-2.6.23/kernel/sched.c
===================================================================
--- linux-2.6.23.orig/kernel/sched.c
+++ linux-2.6.23/kernel/sched.c
@@ -360,7 +360,6 @@ struct rq {
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
-static DEFINE_MUTEX(sched_hotcpu_mutex);
 
 static inline void check_preempt_curr(struct rq *rq, struct task_struct *p)
 {
@@ -4337,13 +4336,13 @@ long sched_setaffinity(pid_t pid, cpumas
 	struct task_struct *p;
 	int retval;
 
-	mutex_lock(&sched_hotcpu_mutex);
+	get_online_cpus();
 	read_lock(&tasklist_lock);
 
 	p = find_process_by_pid(pid);
 	if (!p) {
 		read_unlock(&tasklist_lock);
-		mutex_unlock(&sched_hotcpu_mutex);
+		put_online_cpus();
 		return -ESRCH;
 	}
 
@@ -4370,7 +4369,7 @@ long sched_setaffinity(pid_t pid, cpumas
 
 out_unlock:
 	put_task_struct(p);
-	mutex_unlock(&sched_hotcpu_mutex);
+	put_online_cpus();
 	return retval;
 }
 
@@ -4427,7 +4426,7 @@ long sched_getaffinity(pid_t pid, cpumas
 	struct task_struct *p;
 	int retval;
 
-	mutex_lock(&sched_hotcpu_mutex);
+	get_online_cpus();
 	read_lock(&tasklist_lock);
 
 	retval = -ESRCH;
@@ -4443,7 +4442,7 @@ long sched_getaffinity(pid_t pid, cpumas
 
 out_unlock:
 	read_unlock(&tasklist_lock);
-	mutex_unlock(&sched_hotcpu_mutex);
+	put_online_cpus();
 
 	return retval;
 }
@@ -5342,9 +5341,6 @@ migration_call(struct notifier_block *nf
 	struct rq *rq;
 
 	switch (action) {
-	case CPU_LOCK_ACQUIRE:
-		mutex_lock(&sched_hotcpu_mutex);
-		break;
 
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
@@ -5398,7 +5394,7 @@ migration_call(struct notifier_block *nf
 		BUG_ON(rq->nr_running != 0);
 
 		/* No need to migrate the tasks: it was best-effort if
-		 * they didn't take sched_hotcpu_mutex.  Just wake up
+		 * they didn't do a get_online_cpus().  Just wake up
 		 * the requestors. */
 		spin_lock_irq(&rq->lock);
 		while (!list_empty(&rq->migration_queue)) {
@@ -5412,9 +5408,6 @@ migration_call(struct notifier_block *nf
 		spin_unlock_irq(&rq->lock);
 		break;
 #endif
-	case CPU_LOCK_RELEASE:
-		mutex_unlock(&sched_hotcpu_mutex);
-		break;
 	}
 	return NOTIFY_OK;
 }
@@ -6338,10 +6331,10 @@ static int arch_reinit_sched_domains(voi
 {
 	int err;
 
-	mutex_lock(&sched_hotcpu_mutex);
+	get_online_cpus();
 	detach_destroy_domains(&cpu_online_map);
 	err = arch_init_sched_domains(&cpu_online_map);
-	mutex_unlock(&sched_hotcpu_mutex);
+	put_online_cpus();
 
 	return err;
 }
@@ -6452,12 +6445,12 @@ void __init sched_init_smp(void)
 {
 	cpumask_t non_isolated_cpus;
 
-	mutex_lock(&sched_hotcpu_mutex);
+	get_online_cpus();
 	arch_init_sched_domains(&cpu_online_map);
 	cpus_andnot(non_isolated_cpus, cpu_possible_map, cpu_isolated_map);
 	if (cpus_empty(non_isolated_cpus))
 		cpu_set(smp_processor_id(), non_isolated_cpus);
-	mutex_unlock(&sched_hotcpu_mutex);
+	put_online_cpus();
 	/* XXX: Theoretical race here - CPU may be hotplugged now */
 	hotcpu_notifier(update_sched_domains, 0);
 
Index: linux-2.6.23/mm/slab.c
===================================================================
--- linux-2.6.23.orig/mm/slab.c
+++ linux-2.6.23/mm/slab.c
@@ -730,8 +730,7 @@ static inline void init_lock_keys(void)
 #endif
 
 /*
- * 1. Guard access to the cache-chain.
- * 2. Protect sanity of cpu_online_map against cpu hotplug events
+ * Guard access to the cache-chain.
  */
 static DEFINE_MUTEX(cache_chain_mutex);
 static struct list_head cache_chain;
@@ -1331,12 +1330,11 @@ static int __cpuinit cpuup_callback(stru
 	int err = 0;
 
 	switch (action) {
-	case CPU_LOCK_ACQUIRE:
-		mutex_lock(&cache_chain_mutex);
-		break;
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
+		mutex_lock(&cache_chain_mutex);
 		err = cpuup_prepare(cpu);
+		mutex_unlock(&cache_chain_mutex);
 		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
@@ -1373,9 +1371,8 @@ static int __cpuinit cpuup_callback(stru
 #endif
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
+		mutex_lock(&cache_chain_mutex);
 		cpuup_canceled(cpu);
-		break;
-	case CPU_LOCK_RELEASE:
 		mutex_unlock(&cache_chain_mutex);
 		break;
 	}
@@ -2170,6 +2167,7 @@ kmem_cache_create (const char *name, siz
 	 * We use cache_chain_mutex to ensure a consistent view of
 	 * cpu_online_map as well.  Please see cpuup_callback
 	 */
+	get_online_cpus();
 	mutex_lock(&cache_chain_mutex);
 
 	list_for_each_entry(pc, &cache_chain, next) {
@@ -2396,6 +2394,7 @@ oops:
 		panic("kmem_cache_create(): failed to create slab `%s'\n",
 		      name);
 	mutex_unlock(&cache_chain_mutex);
+	put_online_cpus();
 	return cachep;
 }
 EXPORT_SYMBOL(kmem_cache_create);
@@ -2547,9 +2546,11 @@ int kmem_cache_shrink(struct kmem_cache 
 	int ret;
 	BUG_ON(!cachep || in_interrupt());
 
+	get_online_cpus();
 	mutex_lock(&cache_chain_mutex);
 	ret = __cache_shrink(cachep);
 	mutex_unlock(&cache_chain_mutex);
+	put_online_cpus();
 	return ret;
 }
 EXPORT_SYMBOL(kmem_cache_shrink);
@@ -2575,6 +2576,7 @@ void kmem_cache_destroy(struct kmem_cach
 	BUG_ON(!cachep || in_interrupt());
 
 	/* Find the cache in the chain of caches. */
+	get_online_cpus();
 	mutex_lock(&cache_chain_mutex);
 	/*
 	 * the chain is never empty, cache_cache is never destroyed
@@ -2584,6 +2586,7 @@ void kmem_cache_destroy(struct kmem_cach
 		slab_error(cachep, "Can't free all objects");
 		list_add(&cachep->next, &cache_chain);
 		mutex_unlock(&cache_chain_mutex);
+		put_online_cpus();
 		return;
 	}
 
@@ -2592,6 +2595,7 @@ void kmem_cache_destroy(struct kmem_cach
 
 	__kmem_cache_destroy(cachep);
 	mutex_unlock(&cache_chain_mutex);
+	put_online_cpus();
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
 
Index: linux-2.6.23/kernel/workqueue.c
===================================================================
--- linux-2.6.23.orig/kernel/workqueue.c
+++ linux-2.6.23/kernel/workqueue.c
@@ -592,8 +592,6 @@ EXPORT_SYMBOL(schedule_delayed_work_on);
  * Returns zero on success.
  * Returns -ve errno on failure.
  *
- * Appears to be racy against CPU hotplug.
- *
  * schedule_on_each_cpu() is very slow.
  */
 int schedule_on_each_cpu(work_func_t func)
@@ -605,7 +603,7 @@ int schedule_on_each_cpu(work_func_t fun
 	if (!works)
 		return -ENOMEM;
 
-	preempt_disable();		/* CPU hotplug */
+	get_online_cpus();		/* CPU hotplug */
 	for_each_online_cpu(cpu) {
 		struct work_struct *work = per_cpu_ptr(works, cpu);
 
@@ -613,7 +611,7 @@ int schedule_on_each_cpu(work_func_t fun
 		set_bit(WORK_STRUCT_PENDING, work_data_bits(work));
 		__queue_work(per_cpu_ptr(keventd_wq->cpu_wq, cpu), work);
 	}
-	preempt_enable();
+	put_online_cpus();
 	flush_workqueue(keventd_wq);
 	free_percpu(works);
 	return 0;
@@ -749,8 +747,10 @@ struct workqueue_struct *__create_workqu
 		err = create_workqueue_thread(cwq, singlethread_cpu);
 		start_workqueue_thread(cwq, -1);
 	} else {
+		get_online_cpus();
 		mutex_lock(&workqueue_mutex);
 		list_add(&wq->list, &workqueues);
+		mutex_unlock(&workqueue_mutex);
 
 		for_each_possible_cpu(cpu) {
 			cwq = init_cpu_workqueue(wq, cpu);
@@ -759,7 +759,7 @@ struct workqueue_struct *__create_workqu
 			err = create_workqueue_thread(cwq, cpu);
 			start_workqueue_thread(cwq, cpu);
 		}
-		mutex_unlock(&workqueue_mutex);
+		put_online_cpus();
 	}
 
 	if (err) {
@@ -809,6 +809,7 @@ void destroy_workqueue(struct workqueue_
 	struct cpu_workqueue_struct *cwq;
 	int cpu;
 
+	get_online_cpus();
 	mutex_lock(&workqueue_mutex);
 	list_del(&wq->list);
 	mutex_unlock(&workqueue_mutex);
@@ -817,6 +818,7 @@ void destroy_workqueue(struct workqueue_
 		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
 		cleanup_workqueue_thread(cwq, cpu);
 	}
+	put_online_cpus();
 
 	free_percpu(wq->cpu_wq);
 	kfree(wq);
@@ -830,22 +832,17 @@ static int __devinit workqueue_cpu_callb
 	unsigned int cpu = (unsigned long)hcpu;
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
+	int ret = NOTIFY_OK;
 
 	action &= ~CPU_TASKS_FROZEN;
 
 	switch (action) {
-	case CPU_LOCK_ACQUIRE:
-		mutex_lock(&workqueue_mutex);
-		return NOTIFY_OK;
-
-	case CPU_LOCK_RELEASE:
-		mutex_unlock(&workqueue_mutex);
-		return NOTIFY_OK;
 
 	case CPU_UP_PREPARE:
 		cpu_set(cpu, cpu_populated_map);
 	}
 
+	mutex_lock(&workqueue_mutex);
 	list_for_each_entry(wq, &workqueues, list) {
 		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
 
@@ -853,8 +850,10 @@ static int __devinit workqueue_cpu_callb
 		case CPU_UP_PREPARE:
 			if (!create_workqueue_thread(cwq, cpu))
 				break;
-			printk(KERN_ERR "workqueue for %i failed\n", cpu);
-			return NOTIFY_BAD;
+			printk(KERN_ERR "workqueue [%s] for %i failed\n",
+				wq->name, cpu);
+			ret = NOTIFY_BAD;
+			goto out_unlock;
 
 		case CPU_ONLINE:
 			start_workqueue_thread(cwq, cpu);
@@ -868,7 +867,9 @@ static int __devinit workqueue_cpu_callb
 		}
 	}
 
-	return NOTIFY_OK;
+out_unlock:
+	mutex_unlock(&workqueue_mutex);
+	return ret;
 }
 
 void __init init_workqueues(void)
Index: linux-2.6.23/kernel/cpu.c
===================================================================
--- linux-2.6.23.orig/kernel/cpu.c
+++ linux-2.6.23/kernel/cpu.c
@@ -185,7 +185,6 @@ static int _cpu_down(unsigned int cpu, i
 		return -EINVAL;
 
 	cpu_hotplug_begin();
-	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_ACQUIRE, hcpu);
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
 					hcpu, -1, &nr_calls);
 	if (err == NOTIFY_BAD) {
@@ -238,7 +237,6 @@ out_thread:
 out_allowed:
 	set_cpus_allowed(current, old_allowed);
 out_release:
-	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_RELEASE, hcpu);
 	cpu_hotplug_done();
 	return err;
 }
@@ -269,7 +267,6 @@ static int __cpuinit _cpu_up(unsigned in
 		return -EINVAL;
 
 	cpu_hotplug_begin();
-	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_ACQUIRE, hcpu);
 	ret = __raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE | mod, hcpu,
 							-1, &nr_calls);
 	if (ret == NOTIFY_BAD) {
@@ -293,7 +290,6 @@ out_notify:
 	if (ret != 0)
 		__raw_notifier_call_chain(&cpu_chain,
 				CPU_UP_CANCELED | mod, hcpu, nr_calls, NULL);
-	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_RELEASE, hcpu);
 	cpu_hotplug_done();
 
 	return ret;
Index: linux-2.6.23/include/linux/notifier.h
===================================================================
--- linux-2.6.23.orig/include/linux/notifier.h
+++ linux-2.6.23/include/linux/notifier.h
@@ -207,9 +207,7 @@ static inline int notifier_to_errno(int 
 #define CPU_DOWN_PREPARE	0x0005 /* CPU (unsigned)v going down */
 #define CPU_DOWN_FAILED		0x0006 /* CPU (unsigned)v NOT going down */
 #define CPU_DEAD		0x0007 /* CPU (unsigned)v dead */
-#define CPU_LOCK_ACQUIRE	0x0008 /* Acquire all hotcpu locks */
-#define CPU_LOCK_RELEASE	0x0009 /* Release all hotcpu locks */
-#define CPU_DYING		0x000A /* CPU (unsigned)v not running any task,
+#define CPU_DYING		0x0008 /* CPU (unsigned)v not running any task,
 				        * not handling interrupts, soon dead */
 
 /* Used for CPU hotplug events occuring while tasks are frozen due to a suspend
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
