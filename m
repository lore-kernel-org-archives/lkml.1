Return-Path: <linux-kernel-owner+w=401wt.eu-S1760583AbXKONyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583AbXKONyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 08:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756386AbXKONyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 08:54:13 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:46281 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356AbXKONyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 08:54:11 -0500
Date: Thu, 15 Nov 2007 19:23:36 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russel <rusty@rustcorp.com.au>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Paul E McKenney <paulmck@us.ibm.com>,
       Richard Gooch <rgooch@atnf.csiro.au>,
       Tigran Aivazian <tigran@aivazian.fs.co.uk>,
       Shoahua Li <shaohua.li@linux.com>, Ralf Baechle <ralf@linux-mips.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Nathan Lynch <ntl@pobox.com>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: [RFC PATCH 3/3] cpu-hotplug: Replace per-subsystem mutexes with
	get_online_cpus()
Message-ID: <20071115135336.GC15462@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071115134924.GA15282@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115134924.GA15282@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gautham R Shenoy <ego@in.ibm.com>
Date: Thu, 15 Nov 2007 18:14:29 +0530
Subject: [PATCH 3/3] cpu-hotplug: Replace per-subsystem mutexes with get_online_cpus()

This patch converts the known per-subsystem mutexes to get_online_cpus
put_online_cpus. It also eliminates the CPU_LOCK_ACQUIRE
and CPU_LOCK_RELEASE hotplug notification events.

Signed-off-by: Gautham  R Shenoy <ego@in.ibm.com>
---
 include/linux/notifier.h |    4 +---
 kernel/cpu.c             |    4 ----
 kernel/sched.c           |   25 +++++++++----------------
 kernel/workqueue.c       |   35 +++++++++++++++--------------------
 mm/slab.c                |   18 +++++++++++-------
 5 files changed, 36 insertions(+), 50 deletions(-)

diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index 0c40cc0..5dfbc68 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -207,9 +207,7 @@ static inline int notifier_to_errno(int ret)
 #define CPU_DOWN_PREPARE	0x0005 /* CPU (unsigned)v going down */
 #define CPU_DOWN_FAILED		0x0006 /* CPU (unsigned)v NOT going down */
 #define CPU_DEAD		0x0007 /* CPU (unsigned)v dead */
-#define CPU_LOCK_ACQUIRE	0x0008 /* Acquire all hotcpu locks */
-#define CPU_LOCK_RELEASE	0x0009 /* Release all hotcpu locks */
-#define CPU_DYING		0x000A /* CPU (unsigned)v not running any task,
+#define CPU_DYING		0x0008 /* CPU (unsigned)v not running any task,
 				        * not handling interrupts, soon dead */
 
 /* Used for CPU hotplug events occuring while tasks are frozen due to a suspend
diff --git a/kernel/cpu.c b/kernel/cpu.c
index b0c4152..e0d3a4f 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -218,7 +218,6 @@ static int _cpu_down(unsigned int cpu, int tasks_frozen)
 		return -EINVAL;
 
 	cpu_hotplug_begin();
-	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_ACQUIRE, hcpu);
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
 					hcpu, -1, &nr_calls);
 	if (err == NOTIFY_BAD) {
@@ -271,7 +270,6 @@ out_thread:
 out_allowed:
 	set_cpus_allowed(current, old_allowed);
 out_release:
-	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_RELEASE, hcpu);
 	cpu_hotplug_done();
 	return err;
 }
@@ -302,7 +300,6 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 		return -EINVAL;
 
 	cpu_hotplug_begin();
-	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_ACQUIRE, hcpu);
 	ret = __raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE | mod, hcpu,
 							-1, &nr_calls);
 	if (ret == NOTIFY_BAD) {
@@ -326,7 +323,6 @@ out_notify:
 	if (ret != 0)
 		__raw_notifier_call_chain(&cpu_chain,
 				CPU_UP_CANCELED | mod, hcpu, nr_calls, NULL);
-	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_RELEASE, hcpu);
 	cpu_hotplug_done();
 
 	return ret;
diff --git a/kernel/sched.c b/kernel/sched.c
index 3f6bd11..5c30adc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -364,7 +364,6 @@ struct rq {
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
-static DEFINE_MUTEX(sched_hotcpu_mutex);
 
 static inline void check_preempt_curr(struct rq *rq, struct task_struct *p)
 {
@@ -4474,13 +4473,13 @@ long sched_setaffinity(pid_t pid, cpumask_t new_mask)
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
 
@@ -4520,7 +4519,7 @@ long sched_setaffinity(pid_t pid, cpumask_t new_mask)
 	}
 out_unlock:
 	put_task_struct(p);
-	mutex_unlock(&sched_hotcpu_mutex);
+	put_online_cpus();
 	return retval;
 }
 
@@ -4577,7 +4576,7 @@ long sched_getaffinity(pid_t pid, cpumask_t *mask)
 	struct task_struct *p;
 	int retval;
 
-	mutex_lock(&sched_hotcpu_mutex);
+	get_online_cpus();
 	read_lock(&tasklist_lock);
 
 	retval = -ESRCH;
@@ -4593,7 +4592,7 @@ long sched_getaffinity(pid_t pid, cpumask_t *mask)
 
 out_unlock:
 	read_unlock(&tasklist_lock);
-	mutex_unlock(&sched_hotcpu_mutex);
+	put_online_cpus();
 
 	return retval;
 }
@@ -5536,9 +5535,6 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	struct rq *rq;
 
 	switch (action) {
-	case CPU_LOCK_ACQUIRE:
-		mutex_lock(&sched_hotcpu_mutex);
-		break;
 
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
@@ -5606,9 +5602,6 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		spin_unlock_irq(&rq->lock);
 		break;
 #endif
-	case CPU_LOCK_RELEASE:
-		mutex_unlock(&sched_hotcpu_mutex);
-		break;
 	}
 	return NOTIFY_OK;
 }
@@ -6562,10 +6555,10 @@ static int arch_reinit_sched_domains(void)
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
@@ -6676,12 +6669,12 @@ void __init sched_init_smp(void)
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
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 52d5e7c..1bddee3 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -67,9 +67,8 @@ struct workqueue_struct {
 #endif
 };
 
-/* All the per-cpu workqueues on the system, for hotplug cpu to add/remove
-   threads to each one as cpus come/go. */
-static DEFINE_MUTEX(workqueue_mutex);
+/* Serializes the accesses to the list of workqueues. */
+static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
 
 static int singlethread_cpu __read_mostly;
@@ -592,8 +591,6 @@ EXPORT_SYMBOL(schedule_delayed_work_on);
  * Returns zero on success.
  * Returns -ve errno on failure.
  *
- * Appears to be racy against CPU hotplug.
- *
  * schedule_on_each_cpu() is very slow.
  */
 int schedule_on_each_cpu(work_func_t func)
@@ -605,7 +602,7 @@ int schedule_on_each_cpu(work_func_t func)
 	if (!works)
 		return -ENOMEM;
 
-	preempt_disable();		/* CPU hotplug */
+	get_online_cpus();
 	for_each_online_cpu(cpu) {
 		struct work_struct *work = per_cpu_ptr(works, cpu);
 
@@ -613,8 +610,8 @@ int schedule_on_each_cpu(work_func_t func)
 		set_bit(WORK_STRUCT_PENDING, work_data_bits(work));
 		__queue_work(per_cpu_ptr(keventd_wq->cpu_wq, cpu), work);
 	}
-	preempt_enable();
 	flush_workqueue(keventd_wq);
+	put_online_cpus();
 	free_percpu(works);
 	return 0;
 }
@@ -749,8 +746,10 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 		err = create_workqueue_thread(cwq, singlethread_cpu);
 		start_workqueue_thread(cwq, -1);
 	} else {
-		mutex_lock(&workqueue_mutex);
+		get_online_cpus();
+		spin_lock(&workqueue_lock);
 		list_add(&wq->list, &workqueues);
+		spin_unlock(&workqueue_lock);
 
 		for_each_possible_cpu(cpu) {
 			cwq = init_cpu_workqueue(wq, cpu);
@@ -759,7 +758,7 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 			err = create_workqueue_thread(cwq, cpu);
 			start_workqueue_thread(cwq, cpu);
 		}
-		mutex_unlock(&workqueue_mutex);
+		put_online_cpus();
 	}
 
 	if (err) {
@@ -774,7 +773,7 @@ static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
 	/*
 	 * Our caller is either destroy_workqueue() or CPU_DEAD,
-	 * workqueue_mutex protects cwq->thread
+	 * get_online_cpus() protects cwq->thread.
 	 */
 	if (cwq->thread == NULL)
 		return;
@@ -809,9 +808,11 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	struct cpu_workqueue_struct *cwq;
 	int cpu;
 
-	mutex_lock(&workqueue_mutex);
+	get_online_cpus();
+	spin_lock(&workqueue_lock);
 	list_del(&wq->list);
-	mutex_unlock(&workqueue_mutex);
+	spin_unlock(&workqueue_lock);
+	put_online_cpus();
 
 	for_each_cpu_mask(cpu, *cpu_map) {
 		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
@@ -834,13 +835,6 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
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
@@ -853,7 +847,8 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 		case CPU_UP_PREPARE:
 			if (!create_workqueue_thread(cwq, cpu))
 				break;
-			printk(KERN_ERR "workqueue for %i failed\n", cpu);
+			printk(KERN_ERR "workqueue [%s] for %i failed\n",
+				wq->name, cpu);
 			return NOTIFY_BAD;
 
 		case CPU_ONLINE:
diff --git a/mm/slab.c b/mm/slab.c
index cfa6be4..c2333b8 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -730,8 +730,7 @@ static inline void init_lock_keys(void)
 #endif
 
 /*
- * 1. Guard access to the cache-chain.
- * 2. Protect sanity of cpu_online_map against cpu hotplug events
+ * Guard access to the cache-chain.
  */
 static DEFINE_MUTEX(cache_chain_mutex);
 static struct list_head cache_chain;
@@ -1331,12 +1330,11 @@ static int __cpuinit cpuup_callback(struct notifier_block *nfb,
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
@@ -1373,9 +1371,8 @@ static int __cpuinit cpuup_callback(struct notifier_block *nfb,
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
@@ -2170,6 +2167,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
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
@@ -2547,9 +2546,11 @@ int kmem_cache_shrink(struct kmem_cache *cachep)
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
@@ -2575,6 +2576,7 @@ void kmem_cache_destroy(struct kmem_cache *cachep)
 	BUG_ON(!cachep || in_interrupt());
 
 	/* Find the cache in the chain of caches. */
+	get_online_cpus();
 	mutex_lock(&cache_chain_mutex);
 	/*
 	 * the chain is never empty, cache_cache is never destroyed
@@ -2584,6 +2586,7 @@ void kmem_cache_destroy(struct kmem_cache *cachep)
 		slab_error(cachep, "Can't free all objects");
 		list_add(&cachep->next, &cache_chain);
 		mutex_unlock(&cache_chain_mutex);
+		put_online_cpus();
 		return;
 	}
 
@@ -2592,6 +2595,7 @@ void kmem_cache_destroy(struct kmem_cache *cachep)
 
 	__kmem_cache_destroy(cachep);
 	mutex_unlock(&cache_chain_mutex);
+	put_online_cpus();
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
 
-- 
1.5.2.5

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
