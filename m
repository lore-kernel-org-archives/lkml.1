Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbXDBFjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbXDBFjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 01:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbXDBFiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 01:38:54 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:37491 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbXDBFiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:38:51 -0400
Date: Mon, 2 Apr 2007 11:08:24 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       mingo@elte.hu, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: [PATCH 3/8] Use process freezer for cpu-hotplug
Message-ID: <20070402053824.GC12962@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070402053457.GA9076@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402053457.GA9076@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements process_freezer based cpu-hotplug
core. 
The sailent features are:
o No more (un)lock_cpu_hotplug.
o No more CPU_LOCK_ACQUIRE and CPU_LOCK_RELEASE. Hence no per-subsystem
  hotcpu mutexes.
o Calls freeze_process/thaw_processes at the beginning/end of
  the hotplug operation.

Lessons Learnt:
o CPU_UP_PREPARE has to be called with the processes frozen.
  If implemented otherwise, the kernel threads which we create
  during UP_PREPARE will never be frozen during freeze_processes
  since we them up only during CPU_ONLIN.

Points to ponder: 
o Can the SYSTEM_RUNNING hack in _cpu_up be avoided by some cleaner means.

Signed-off-by : Srivatsa Vaddagiri <vatsa@in.ibm.com>
Signed-off-by : Gautham R Shenoy   <ego@in.ibm.com>
Signed-off-by : Rafael J. Wysocki  <rjw@sisk.pl> 
--
 include/linux/freezer.h  |   10 ++++--
 include/linux/notifier.h |    2 -
 include/linux/sched.h    |    5 ++-
 kernel/cpu.c             |   70 ++++++++++++++++++-----------------------------
 kernel/sched.c           |   20 +------------
 kernel/softirq.c         |   13 ++++----
 kernel/softlockup.c      |    1 
 kernel/workqueue.c       |   33 ++++++++++------------
 mm/slab.c                |    6 ----
 9 files changed, 63 insertions(+), 97 deletions(-)

Index: linux-2.6.21-rc5/include/linux/sched.h
===================================================================
--- linux-2.6.21-rc5.orig/include/linux/sched.h
+++ linux-2.6.21-rc5/include/linux/sched.h
@@ -1195,10 +1195,13 @@ static inline void put_task_struct(struc
 #define PF_FE_KPROBES	0x00000010	/* This thread should not be frozen
 					 * for Kprobes
 					 */
+#define PF_FE_HOTPLUG_CPU 0x00000020	/* Thread should not be frozen for
+					 * cpu hotplug.
+					 */
 
 #define PF_FROZEN	0x00010000	/* frozen for system suspend */
 
-#define PF_FE_ALL	(PF_FE_SUSPEND | PF_FE_KPROBES)
+#define PF_FE_ALL	(PF_FE_SUSPEND | PF_FE_KPROBES | PF_FE_HOTPLUG_CPU)
 					/* Exempt from all kinds freeze chills*/
 
 #define PF_FSTRANS	0x00020000	/* inside a filesystem transaction */
Index: linux-2.6.21-rc5/include/linux/freezer.h
===================================================================
--- linux-2.6.21-rc5.orig/include/linux/freezer.h
+++ linux-2.6.21-rc5/include/linux/freezer.h
@@ -6,10 +6,12 @@
 					defined(CONFIG_KPROBES)
 
 /* These are the events which make use of the process freezer */
-#define FE_NONE		0
-#define FE_ALL		PF_FE_ALL
-#define FE_SUSPEND	PF_FE_SUSPEND
-#define FE_KPROBES	PF_FE_KPROBES
+#define FE_NONE			0
+#define FE_ALL			PF_FE_ALL
+#define FE_SUSPEND		PF_FE_SUSPEND
+#define FE_KPROBES		PF_FE_KPROBES
+#define FE_HOTPLUG_CPU		PF_FE_HOTPLUG_CPU
+#define FE_SUSPEND_KPROBES	PF_FE_SUSPEND | PF_FE_KPROBES
 
 /*
  * Exempt the current process from being frozen for a certain event
Index: linux-2.6.21-rc5/kernel/cpu.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/cpu.c
+++ linux-2.6.21-rc5/kernel/cpu.c
@@ -14,6 +14,7 @@
 #include <linux/kthread.h>
 #include <linux/stop_machine.h>
 #include <linux/mutex.h>
+#include <linux/freezer.h>
 
 /* This protects CPUs going up and down... */
 static DEFINE_MUTEX(cpu_add_remove_lock);
@@ -28,38 +29,15 @@ static int cpu_hotplug_disabled;
 
 #ifdef CONFIG_HOTPLUG_CPU
 
-/* Crappy recursive lock-takers in cpufreq! Complain loudly about idiots */
-static struct task_struct *recursive;
-static int recursive_depth;
-
 void lock_cpu_hotplug(void)
 {
-	struct task_struct *tsk = current;
-
-	if (tsk == recursive) {
-		static int warnings = 10;
-		if (warnings) {
-			printk(KERN_ERR "Lukewarm IQ detected in hotplug locking\n");
-			WARN_ON(1);
-			warnings--;
-		}
-		recursive_depth++;
-		return;
-	}
-	mutex_lock(&cpu_bitmask_lock);
-	recursive = tsk;
+	return;
 }
 EXPORT_SYMBOL_GPL(lock_cpu_hotplug);
 
 void unlock_cpu_hotplug(void)
 {
-	WARN_ON(recursive != current);
-	if (recursive_depth) {
-		recursive_depth--;
-		return;
-	}
-	recursive = NULL;
-	mutex_unlock(&cpu_bitmask_lock);
+	return;
 }
 EXPORT_SYMBOL_GPL(unlock_cpu_hotplug);
 
@@ -133,7 +111,11 @@ static int _cpu_down(unsigned int cpu)
 	if (!cpu_online(cpu))
 		return -EINVAL;
 
-	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_ACQUIRE, hcpu);
+	if (freeze_processes(FE_HOTPLUG_CPU)) {
+		thaw_processes(FE_HOTPLUG_CPU);
+		return -EBUSY;
+	}
+
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE,
 					hcpu, -1, &nr_calls);
 	if (err == NOTIFY_BAD) {
@@ -142,7 +124,7 @@ static int _cpu_down(unsigned int cpu)
 		printk("%s: attempt to take down CPU %u failed\n",
 				__FUNCTION__, cpu);
 		err = -EINVAL;
-		goto out_release;
+		goto out_thread;
 	}
 
 	/* Ensure that we are not runnable on dying cpu */
@@ -151,9 +133,7 @@ static int _cpu_down(unsigned int cpu)
 	cpu_clear(cpu, tmp);
 	set_cpus_allowed(current, tmp);
 
-	mutex_lock(&cpu_bitmask_lock);
 	p = __stop_machine_run(take_cpu_down, NULL, cpu);
-	mutex_unlock(&cpu_bitmask_lock);
 
 	if (IS_ERR(p) || cpu_online(cpu)) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
@@ -161,10 +141,13 @@ static int _cpu_down(unsigned int cpu)
 					    hcpu) == NOTIFY_BAD)
 			BUG();
 
-		if (IS_ERR(p)) {
+		set_cpus_allowed(current, old_allowed);
+
+		if (IS_ERR(p))
 			err = PTR_ERR(p);
-			goto out_allowed;
-		}
+		else
+			err = kthread_stop(p);
+
 		goto out_thread;
 	}
 
@@ -184,14 +167,11 @@ static int _cpu_down(unsigned int cpu)
 		BUG();
 
 	check_for_tasks(cpu);
+	set_cpus_allowed(current, old_allowed);
+	err = kthread_stop(p);
 
 out_thread:
-	err = kthread_stop(p);
-out_allowed:
-	set_cpus_allowed(current, old_allowed);
-out_release:
-	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_RELEASE,
-						(void *)(long)cpu);
+	thaw_processes(FE_HOTPLUG_CPU);
 	return err;
 }
 
@@ -219,7 +199,12 @@ static int __cpuinit _cpu_up(unsigned in
 	if (cpu_online(cpu) || !cpu_present(cpu))
 		return -EINVAL;
 
-	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_ACQUIRE, hcpu);
+	if (system_state == SYSTEM_RUNNING &&
+		freeze_processes(FE_HOTPLUG_CPU)) {
+		thaw_processes(FE_HOTPLUG_CPU);
+		return -EBUSY;
+	}
+
 	ret = __raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE, hcpu,
 							-1, &nr_calls);
 	if (ret == NOTIFY_BAD) {
@@ -229,10 +214,9 @@ static int __cpuinit _cpu_up(unsigned in
 		goto out_notify;
 	}
 
+
 	/* Arch-specific enabling code. */
-	mutex_lock(&cpu_bitmask_lock);
 	ret = __cpu_up(cpu);
-	mutex_unlock(&cpu_bitmask_lock);
 	if (ret != 0)
 		goto out_notify;
 	BUG_ON(!cpu_online(cpu));
@@ -244,7 +228,9 @@ out_notify:
 	if (ret != 0)
 		__raw_notifier_call_chain(&cpu_chain,
 				CPU_UP_CANCELED, hcpu, nr_calls, NULL);
-	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_RELEASE, hcpu);
+
+	if (system_state == SYSTEM_RUNNING)
+		thaw_processes(FE_HOTPLUG_CPU);
 
 	return ret;
 }
Index: linux-2.6.21-rc5/include/linux/notifier.h
===================================================================
--- linux-2.6.21-rc5.orig/include/linux/notifier.h
+++ linux-2.6.21-rc5/include/linux/notifier.h
@@ -194,8 +194,6 @@ extern int __srcu_notifier_call_chain(st
 #define CPU_DOWN_PREPARE	0x0005 /* CPU (unsigned)v going down */
 #define CPU_DOWN_FAILED		0x0006 /* CPU (unsigned)v NOT going down */
 #define CPU_DEAD		0x0007 /* CPU (unsigned)v dead */
-#define CPU_LOCK_ACQUIRE	0x0008 /* Acquire all hotcpu locks */
-#define CPU_LOCK_RELEASE	0x0009 /* Release all hotcpu locks */
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
Index: linux-2.6.21-rc5/kernel/softirq.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/softirq.c
+++ linux-2.6.21-rc5/kernel/softirq.c
@@ -490,12 +490,16 @@ void __init softirq_init(void)
 static int ksoftirqd(void * __bind_cpu)
 {
 	set_user_nice(current, 19);
-	freezer_exempt(FE_ALL);
+	freezer_exempt(FE_SUSPEND_KPROBES);
 
 	set_current_state(TASK_INTERRUPTIBLE);
 
 	while (!kthread_should_stop()) {
 		try_to_freeze();
+		/* When thawed, if cpu is no longer online, die */
+		if (cpu_is_offline((long)__bind_cpu))
+			goto wait_to_die;
+
 		preempt_disable();
 		if (!local_softirq_pending()) {
 			preempt_enable_no_resched();
@@ -506,11 +510,6 @@ static int ksoftirqd(void * __bind_cpu)
 		__set_current_state(TASK_RUNNING);
 
 		while (local_softirq_pending()) {
-			/* Preempt disable stops cpu going offline.
-			   If already offline, we'll be on wrong CPU:
-			   don't process */
-			if (cpu_is_offline((long)__bind_cpu))
-				goto wait_to_die;
 			do_softirq();
 			preempt_enable_no_resched();
 			cond_resched();
@@ -523,7 +522,6 @@ static int ksoftirqd(void * __bind_cpu)
 	return 0;
 
 wait_to_die:
-	preempt_enable();
 	/* Wait for kthread_stop */
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
@@ -616,6 +614,7 @@ static int __cpuinit cpu_callback(struct
 	case CPU_DEAD:
 		p = per_cpu(ksoftirqd, hotcpu);
 		per_cpu(ksoftirqd, hotcpu) = NULL;
+		thaw_process(p);
 		kthread_stop(p);
 		takeover_tasklets(hotcpu);
 		break;
Index: linux-2.6.21-rc5/kernel/sched.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/sched.c
+++ linux-2.6.21-rc5/kernel/sched.c
@@ -255,7 +255,6 @@ struct rq {
 };
 
 static DEFINE_PER_CPU(struct rq, runqueues);
-static DEFINE_MUTEX(sched_hotcpu_mutex);
 
 static inline int cpu_of(struct rq *rq)
 {
@@ -4400,13 +4399,11 @@ long sched_setaffinity(pid_t pid, cpumas
 	struct task_struct *p;
 	int retval;
 
-	mutex_lock(&sched_hotcpu_mutex);
 	read_lock(&tasklist_lock);
 
 	p = find_process_by_pid(pid);
 	if (!p) {
 		read_unlock(&tasklist_lock);
-		mutex_unlock(&sched_hotcpu_mutex);
 		return -ESRCH;
 	}
 
@@ -4433,7 +4430,6 @@ long sched_setaffinity(pid_t pid, cpumas
 
 out_unlock:
 	put_task_struct(p);
-	mutex_unlock(&sched_hotcpu_mutex);
 	return retval;
 }
 
@@ -4490,7 +4486,6 @@ long sched_getaffinity(pid_t pid, cpumas
 	struct task_struct *p;
 	int retval;
 
-	mutex_lock(&sched_hotcpu_mutex);
 	read_lock(&tasklist_lock);
 
 	retval = -ESRCH;
@@ -4506,7 +4501,6 @@ long sched_getaffinity(pid_t pid, cpumas
 
 out_unlock:
 	read_unlock(&tasklist_lock);
-	mutex_unlock(&sched_hotcpu_mutex);
 	if (retval)
 		return retval;
 
@@ -5400,9 +5394,6 @@ migration_call(struct notifier_block *nf
 	struct rq *rq;
 
 	switch (action) {
-	case CPU_LOCK_ACQUIRE:
-		mutex_lock(&sched_hotcpu_mutex);
-		break;
 
 	case CPU_UP_PREPARE:
 		p = kthread_create(migration_thread, hcpu, "migration/%d",cpu);
@@ -5435,6 +5426,7 @@ migration_call(struct notifier_block *nf
 	case CPU_DEAD:
 		migrate_live_tasks(cpu);
 		rq = cpu_rq(cpu);
+		thaw_process(rq->migration_thread);
 		kthread_stop(rq->migration_thread);
 		rq->migration_thread = NULL;
 		/* Idle task back to normal (off runqueue, low prio) */
@@ -5447,8 +5439,7 @@ migration_call(struct notifier_block *nf
 		migrate_nr_uninterruptible(rq);
 		BUG_ON(rq->nr_running != 0);
 
-		/* No need to migrate the tasks: it was best-effort if
-		 * they didn't take sched_hotcpu_mutex.  Just wake up
+		/* No need to migrate the tasks: Just wake up
 		 * the requestors. */
 		spin_lock_irq(&rq->lock);
 		while (!list_empty(&rq->migration_queue)) {
@@ -5462,9 +5453,6 @@ migration_call(struct notifier_block *nf
 		spin_unlock_irq(&rq->lock);
 		break;
 #endif
-	case CPU_LOCK_RELEASE:
-		mutex_unlock(&sched_hotcpu_mutex);
-		break;
 	}
 	return NOTIFY_OK;
 }
@@ -6813,10 +6801,8 @@ int arch_reinit_sched_domains(void)
 {
 	int err;
 
-	mutex_lock(&sched_hotcpu_mutex);
 	detach_destroy_domains(&cpu_online_map);
 	err = arch_init_sched_domains(&cpu_online_map);
-	mutex_unlock(&sched_hotcpu_mutex);
 
 	return err;
 }
@@ -6921,12 +6907,10 @@ void __init sched_init_smp(void)
 {
 	cpumask_t non_isolated_cpus;
 
-	mutex_lock(&sched_hotcpu_mutex);
 	arch_init_sched_domains(&cpu_online_map);
 	cpus_andnot(non_isolated_cpus, cpu_possible_map, cpu_isolated_map);
 	if (cpus_empty(non_isolated_cpus))
 		cpu_set(smp_processor_id(), non_isolated_cpus);
-	mutex_unlock(&sched_hotcpu_mutex);
 	/* XXX: Theoretical race here - CPU may be hotplugged now */
 	hotcpu_notifier(update_sched_domains, 0);
 
Index: linux-2.6.21-rc5/kernel/softlockup.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/softlockup.c
+++ linux-2.6.21-rc5/kernel/softlockup.c
@@ -147,6 +147,7 @@ cpu_callback(struct notifier_block *nfb,
 	case CPU_DEAD:
 		p = per_cpu(watchdog_task, hotcpu);
 		per_cpu(watchdog_task, hotcpu) = NULL;
+		thaw_process(p);
 		kthread_stop(p);
 		break;
 #endif /* CONFIG_HOTPLUG_CPU */
Index: linux-2.6.21-rc5/kernel/workqueue.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/workqueue.c
+++ linux-2.6.21-rc5/kernel/workqueue.c
@@ -47,7 +47,10 @@ struct cpu_workqueue_struct {
 
 	struct workqueue_struct *wq;
 	struct task_struct *thread;
-	int should_stop;
+	int status;
+	#define CWQ_RUNNING	0
+	#define CWQ_SHOULD_STOP	1
+	#define CWQ_STOPPED	2
 
 	int run_depth;		/* Detect run_workqueue() recursion depth */
 } ____cacheline_aligned;
@@ -272,13 +275,13 @@ static void run_workqueue(struct cpu_wor
  */
 static int cwq_should_stop(struct cpu_workqueue_struct *cwq)
 {
-	int should_stop = cwq->should_stop;
+	int should_stop = cwq->status;
 
-	if (unlikely(should_stop)) {
+	if (unlikely(should_stop == CWQ_SHOULD_STOP)) {
 		spin_lock_irq(&cwq->lock);
-		should_stop = cwq->should_stop && list_empty(&cwq->worklist);
+		should_stop = cwq->status && list_empty(&cwq->worklist);
 		if (should_stop)
-			cwq->thread = NULL;
+			cwq->status= CWQ_STOPPED;
 		spin_unlock_irq(&cwq->lock);
 	}
 
@@ -311,7 +314,7 @@ static int worker_thread(void *__cwq)
 			try_to_freeze();
 
 		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
-		if (!cwq->should_stop && list_empty(&cwq->worklist))
+		if (cwq->status == CWQ_RUNNING && list_empty(&cwq->worklist))
 			schedule();
 		finish_wait(&cwq->more_work, &wait);
 
@@ -643,7 +646,7 @@ static int create_workqueue_thread(struc
 		return PTR_ERR(p);
 
 	cwq->thread = p;
-	cwq->should_stop = 0;
+	cwq->status = CWQ_RUNNING;
 	if (!is_single_threaded(wq))
 		kthread_bind(p, cpu);
 
@@ -707,21 +710,23 @@ static void cleanup_workqueue_thread(str
 	spin_lock_irq(&cwq->lock);
 	if (cwq->thread != NULL) {
 		insert_wq_barrier(cwq, &barr, 1);
-		cwq->should_stop = 1;
+		cwq->status = CWQ_SHOULD_STOP;
 		alive = 1;
 	}
 	spin_unlock_irq(&cwq->lock);
 
 	if (alive) {
+		thaw_process(cwq->thread);
 		wait_for_completion(&barr.done);
 
-		while (unlikely(cwq->thread != NULL))
+		while (unlikely(cwq->status != CWQ_STOPPED))
 			cpu_relax();
 		/*
 		 * Wait until cwq->thread unlocks cwq->lock,
 		 * it won't touch *cwq after that.
 		 */
 		smp_rmb();
+		cwq->thread = NULL;
 		spin_unlock_wait(&cwq->lock);
 	}
 }
@@ -761,18 +766,11 @@ static int __devinit workqueue_cpu_callb
 	struct workqueue_struct *wq;
 
 	switch (action) {
-	case CPU_LOCK_ACQUIRE:
-		mutex_lock(&workqueue_mutex);
-		return NOTIFY_OK;
-
-	case CPU_LOCK_RELEASE:
-		mutex_unlock(&workqueue_mutex);
-		return NOTIFY_OK;
-
 	case CPU_UP_PREPARE:
 		cpu_set(cpu, cpu_populated_map);
 	}
 
+	mutex_lock(&workqueue_mutex);
 	list_for_each_entry(wq, &workqueues, list) {
 		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
 
@@ -795,6 +793,7 @@ static int __devinit workqueue_cpu_callb
 			break;
 		}
 	}
+	mutex_unlock(&workqueue_mutex);
 
 	return NOTIFY_OK;
 }
Index: linux-2.6.21-rc5/mm/slab.c
===================================================================
--- linux-2.6.21-rc5.orig/mm/slab.c
+++ linux-2.6.21-rc5/mm/slab.c
@@ -1186,9 +1186,6 @@ static int __cpuinit cpuup_callback(stru
 	int memsize = sizeof(struct kmem_list3);
 
 	switch (action) {
-	case CPU_LOCK_ACQUIRE:
-		mutex_lock(&cache_chain_mutex);
-		break;
 	case CPU_UP_PREPARE:
 		/*
 		 * We need to do this right in the beginning since
@@ -1364,9 +1361,6 @@ free_array_cache:
 			drain_freelist(cachep, l3, l3->free_objects);
 		}
 		break;
-	case CPU_LOCK_RELEASE:
-		mutex_unlock(&cache_chain_mutex);
-		break;
 	}
 	return NOTIFY_OK;
 bad:
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
