Return-Path: <linux-kernel-owner+w=401wt.eu-S932325AbXBNOmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbXBNOmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 09:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932331AbXBNOmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 09:42:35 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:35400 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325AbXBNOmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 09:42:33 -0500
Date: Wed, 14 Feb 2007 20:12:29 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu
Cc: vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, oleg@tv-sign.ru, rjw@sisk.pl
Subject: [RFC PATCH(Experimental) 1/4] freezer-cpu-hotplug core
Message-ID: <20070214144229.GA19789@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070214144031.GA15257@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214144031.GA15257@in.ibm.com>
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
o Splits CPU_DEAD into two events namely
  - CPU_DEAD: which will be handled while the processes are still
              frozen.

  - CPU_DEAD_KILL_THREADS: To be handled after we thaw_processes.

 This split is required because stopping of the per-cpu threads
 using kthread_stop cannot be done while the system is in the frozen
 state. Hence we need subsystems which have created per-cpu threads
 have to stop them once thaw_processes have been called.

o Handles CPU_DEAD and CPU_DEAD_KILL_THREADS for subsystems which
  create per-cpu threads.

Points to ponder: 
o Can calling CPU_DOWN_PREPARE/CPU_UP_PREPARE in the 
frozen context create any dirty dependencies in the future?

o Can the SYSTEM_RUNNING hack in _cpu_up be avoided by some cleaner means.

Signed-off-by : Srivatsa Vaddagiri <vatsa@in.ibm.com>
Signed-off-by : Gautham R Shenoy   <ego@in.ibm.com>
--
 include/linux/notifier.h |    3 --
 kernel/cpu.c             |   68 +++++++++++++++++++----------------------------
 kernel/sched.c           |    7 +++-
 kernel/softirq.c         |   10 ++++--
 kernel/softlockup.c      |    3 +-
 kernel/workqueue.c       |   16 ++++++++++-
 6 files changed, 58 insertions(+), 49 deletions(-)

Index: hotplug/kernel/cpu.c
===================================================================
--- hotplug.orig/kernel/cpu.c
+++ hotplug/kernel/cpu.c
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
+	if (freeze_processes()) {
+		thaw_processes();
+		return -EBUSY;
+	}
+
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE,
 					hcpu, -1, &nr_calls);
 	if (err == NOTIFY_BAD) {
@@ -141,8 +123,8 @@ static int _cpu_down(unsigned int cpu)
 					  nr_calls, NULL);
 		printk("%s: attempt to take down CPU %u failed\n",
 				__FUNCTION__, cpu);
-		err = -EINVAL;
-		goto out_release;
+		thaw_processes();
+		return -EINVAL;
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
@@ -161,9 +141,12 @@ static int _cpu_down(unsigned int cpu)
 					    hcpu) == NOTIFY_BAD)
 			BUG();
 
+		set_cpus_allowed(current, old_allowed);
+		thaw_processes();
+
 		if (IS_ERR(p)) {
 			err = PTR_ERR(p);
-			goto out_allowed;
+			return err;
 		}
 		goto out_thread;
 	}
@@ -185,13 +168,12 @@ static int _cpu_down(unsigned int cpu)
 
 	check_for_tasks(cpu);
 
+	thaw_processes();
+
+	if (raw_notifier_call_chain(&cpu_chain, CPU_DEAD_KILL_THREADS, hcpu) == NOTIFY_BAD)
+		BUG();
 out_thread:
 	err = kthread_stop(p);
-out_allowed:
-	set_cpus_allowed(current, old_allowed);
-out_release:
-	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_RELEASE,
-						(void *)(long)cpu);
 	return err;
 }
 
@@ -219,7 +201,12 @@ static int __cpuinit _cpu_up(unsigned in
 	if (cpu_online(cpu) || !cpu_present(cpu))
 		return -EINVAL;
 
-	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_ACQUIRE, hcpu);
+	if (system_state == SYSTEM_RUNNING && freeze_processes()) {
+		if (system_state == SYSTEM_RUNNING)
+			thaw_processes();
+		return -EBUSY;
+	}
+
 	ret = __raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE, hcpu,
 							-1, &nr_calls);
 	if (ret == NOTIFY_BAD) {
@@ -229,10 +216,9 @@ static int __cpuinit _cpu_up(unsigned in
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
@@ -241,10 +227,12 @@ static int __cpuinit _cpu_up(unsigned in
 	raw_notifier_call_chain(&cpu_chain, CPU_ONLINE, hcpu);
 
 out_notify:
+	if (system_state == SYSTEM_RUNNING)
+		thaw_processes();
+
 	if (ret != 0)
 		__raw_notifier_call_chain(&cpu_chain,
 				CPU_UP_CANCELED, hcpu, nr_calls, NULL);
-	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_RELEASE, hcpu);
 
 	return ret;
 }
Index: hotplug/kernel/softirq.c
===================================================================
--- hotplug.orig/kernel/softirq.c
+++ hotplug/kernel/softirq.c
@@ -18,6 +18,7 @@
 #include <linux/rcupdate.h>
 #include <linux/smp.h>
 #include <linux/tick.h>
+#include <linux/freezer.h>
 
 #include <asm/irq.h>
 /*
@@ -489,7 +490,6 @@ void __init softirq_init(void)
 static int ksoftirqd(void * __bind_cpu)
 {
 	set_user_nice(current, 19);
-	current->flags |= PF_NOFREEZE;
 
 	set_current_state(TASK_INTERRUPTIBLE);
 
@@ -515,6 +515,9 @@ static int ksoftirqd(void * __bind_cpu)
 			preempt_disable();
 		}
 		preempt_enable();
+		try_to_freeze();
+		if (cpu_is_offline((long)__bind_cpu))
+			goto wait_to_die;
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
 	__set_current_state(TASK_RUNNING);
@@ -612,11 +615,12 @@ static int __cpuinit cpu_callback(struct
 		kthread_bind(per_cpu(ksoftirqd, hotcpu),
 			     any_online_cpu(cpu_online_map));
 	case CPU_DEAD:
+		takeover_tasklets(hotcpu);
+		break;
+	case CPU_DEAD_KILL_THREADS:
 		p = per_cpu(ksoftirqd, hotcpu);
 		per_cpu(ksoftirqd, hotcpu) = NULL;
 		kthread_stop(p);
-		takeover_tasklets(hotcpu);
-		break;
 #endif /* CONFIG_HOTPLUG_CPU */
  	}
 	return NOTIFY_OK;
Index: hotplug/kernel/sched.c
===================================================================
--- hotplug.orig/kernel/sched.c
+++ hotplug/kernel/sched.c
@@ -5519,8 +5519,6 @@ migration_call(struct notifier_block *nf
 	case CPU_DEAD:
 		migrate_live_tasks(cpu);
 		rq = cpu_rq(cpu);
-		kthread_stop(rq->migration_thread);
-		rq->migration_thread = NULL;
 		/* Idle task back to normal (off runqueue, low prio) */
 		rq = task_rq_lock(rq->idle, &flags);
 		deactivate_task(rq->idle, rq);
@@ -5545,6 +5543,11 @@ migration_call(struct notifier_block *nf
 		}
 		spin_unlock_irq(&rq->lock);
 		break;
+	case CPU_DEAD_KILL_THREADS:
+		rq = cpu_rq(cpu);
+		kthread_stop(rq->migration_thread);
+		rq->migration_thread = NULL;
+		break;
 #endif
 	case CPU_LOCK_RELEASE:
 		mutex_unlock(&sched_hotcpu_mutex);
Index: hotplug/kernel/softlockup.c
===================================================================
--- hotplug.orig/kernel/softlockup.c
+++ hotplug/kernel/softlockup.c
@@ -13,6 +13,7 @@
 #include <linux/kthread.h>
 #include <linux/notifier.h>
 #include <linux/module.h>
+#include <linux/freezer.h>
 
 static DEFINE_SPINLOCK(print_lock);
 
@@ -132,7 +133,7 @@ cpu_callback(struct notifier_block *nfb,
 		/* Unbind so it can run.  Fall thru. */
 		kthread_bind(per_cpu(watchdog_task, hotcpu),
 			     any_online_cpu(cpu_online_map));
-	case CPU_DEAD:
+	case CPU_DEAD_KILL_THREADS:
 		p = per_cpu(watchdog_task, hotcpu);
 		per_cpu(watchdog_task, hotcpu) = NULL;
 		kthread_stop(p);
Index: hotplug/kernel/workqueue.c
===================================================================
--- hotplug.orig/kernel/workqueue.c
+++ hotplug/kernel/workqueue.c
@@ -368,6 +368,7 @@ static int worker_thread(void *__cwq)
 	DEFINE_WAIT(wait);
 	struct k_sigaction sa;
 	sigset_t blocked;
+	int bind_cpu = smp_processor_id();
 
 	if (!cwq->wq->freezeable)
 		current->flags |= PF_NOFREEZE;
@@ -392,8 +393,11 @@ static int worker_thread(void *__cwq)
 	do_sigaction(SIGCHLD, &sa, (struct k_sigaction *)0);
 
 	for (;;) {
-		if (cwq->wq->freezeable)
+		if (cwq->wq->freezeable) {
 			try_to_freeze();
+			if (cpu_is_offline(bind_cpu))
+				goto wait_to_die;
+		}
 
 		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
 		if (!cwq->should_stop && list_empty(&cwq->worklist))
@@ -407,6 +411,16 @@ static int worker_thread(void *__cwq)
 	}
 
 	return 0;
+
+wait_to_die:
+	/* Wait for kthread_stop */
+	set_current_state(TASK_INTERRUPTIBLE);
+	while (!kthread_should_stop()) {
+		schedule();
+		set_current_state(TASK_INTERRUPTIBLE);
+	}
+	__set_current_state(TASK_RUNNING);
+	return 0;
 }
 
 struct wq_barrier {
Index: hotplug/include/linux/notifier.h
===================================================================
--- hotplug.orig/include/linux/notifier.h
+++ hotplug/include/linux/notifier.h
@@ -194,8 +194,7 @@ extern int __srcu_notifier_call_chain(st
 #define CPU_DOWN_PREPARE	0x0005 /* CPU (unsigned)v going down */
 #define CPU_DOWN_FAILED		0x0006 /* CPU (unsigned)v NOT going down */
 #define CPU_DEAD		0x0007 /* CPU (unsigned)v dead */
-#define CPU_LOCK_ACQUIRE	0x0008 /* Acquire all hotcpu locks */
-#define CPU_LOCK_RELEASE	0x0009 /* Release all hotcpu locks */
+#define CPU_DEAD_KILL_THREADS	0x0008 /* Kill per-cpu threads after dead */
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
