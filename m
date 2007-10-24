Return-Path: <linux-kernel-owner+w=401wt.eu-S1756934AbXJXFbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934AbXJXFbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 01:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbXJXFbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 01:31:06 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:39654 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbXJXFbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 01:31:04 -0400
Date: Wed, 24 Oct 2007 11:00:57 +0530
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
       Nathan Lynch <ntl@pobox.com>, David Miller <davem@davemloft.net>,
       Paul Jackson <pj@sgi.com>, Josh Triplett <josh@freedesktop.org>,
       Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: [RFC PATCH 1/5] Refcount Based Cpu Hotplug implementation
Message-ID: <20071024053057.GA27074@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071024052931.GA22722@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024052931.GA22722@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a Refcount + Waitqueue based model for
cpu-hotplug. 

Now, a thread which wants to prevent cpu-hotplug, will bump up a 
global refcount and the thread which wants to perform a cpu-hotplug
operation will block till the global refcount goes to zero.

The readers, if any, during an ongoing cpu-hotplug operation are blocked
until the cpu-hotplug operation is over.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Paul Jackson <pj@sgi.com> [For !CONFIG_HOTPLUG_CPU ]
---
 include/linux/cpu.h |    3 +
 init/main.c         |    1 
 kernel/cpu.c        |  152 +++++++++++++++++++++++++++++++++++++---------------
 3 files changed, 115 insertions(+), 41 deletions(-)

Index: linux-2.6.23/init/main.c
===================================================================
--- linux-2.6.23.orig/init/main.c
+++ linux-2.6.23/init/main.c
@@ -614,6 +614,7 @@ asmlinkage void __init start_kernel(void
 	vfs_caches_init_early();
 	cpuset_init_early();
 	mem_init();
+	cpu_hotplug_init();
 	kmem_cache_init();
 	setup_per_cpu_pageset();
 	numa_policy_init();
Index: linux-2.6.23/include/linux/cpu.h
===================================================================
--- linux-2.6.23.orig/include/linux/cpu.h
+++ linux-2.6.23/include/linux/cpu.h
@@ -83,6 +83,9 @@ static inline void unregister_cpu_notifi
 
 #endif /* CONFIG_SMP */
 extern struct sysdev_class cpu_sysdev_class;
+extern void cpu_hotplug_init(void);
+extern void cpu_maps_update_begin(void);
+extern void cpu_maps_update_done(void);
 
 #ifdef CONFIG_HOTPLUG_CPU
 /* Stop CPUs going up and down. */
Index: linux-2.6.23/kernel/cpu.c
===================================================================
--- linux-2.6.23.orig/kernel/cpu.c
+++ linux-2.6.23/kernel/cpu.c
@@ -15,9 +15,8 @@
 #include <linux/stop_machine.h>
 #include <linux/mutex.h>
 
-/* This protects CPUs going up and down... */
+/* Serializes the updates to cpu_online_map, cpu_present_map */
 static DEFINE_MUTEX(cpu_add_remove_lock);
-static DEFINE_MUTEX(cpu_bitmask_lock);
 
 static __cpuinitdata RAW_NOTIFIER_HEAD(cpu_chain);
 
@@ -26,52 +25,123 @@ static __cpuinitdata RAW_NOTIFIER_HEAD(c
  */
 static int cpu_hotplug_disabled;
 
-#ifdef CONFIG_HOTPLUG_CPU
+static struct {
+	struct task_struct *active_writer;
+	struct mutex lock; /* Synchronizes accesses to refcount, */
+	/*
+	 * Also blocks the new readers during
+	 * an ongoing cpu hotplug operation.
+	 */
+	int refcount;
+	wait_queue_head_t writer_queue;
+} cpu_hotplug;
+
+#define writer_exists() (cpu_hotplug.active_writer != NULL)
+
+void __init cpu_hotplug_init(void)
+{
+	cpu_hotplug.active_writer = NULL;
+	mutex_init(&cpu_hotplug.lock);
+	cpu_hotplug.refcount = 0;
+	init_waitqueue_head(&cpu_hotplug.writer_queue);
+}
 
-/* Crappy recursive lock-takers in cpufreq! Complain loudly about idiots */
-static struct task_struct *recursive;
-static int recursive_depth;
+#ifdef CONFIG_HOTPLUG_CPU
 
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
+	might_sleep();
+	if (cpu_hotplug.active_writer == current)
 		return;
-	}
-	mutex_lock(&cpu_bitmask_lock);
-	recursive = tsk;
+	mutex_lock(&cpu_hotplug.lock);
+	cpu_hotplug.refcount++;
+	mutex_unlock(&cpu_hotplug.lock);
+
 }
 EXPORT_SYMBOL_GPL(lock_cpu_hotplug);
 
 void unlock_cpu_hotplug(void)
 {
-	WARN_ON(recursive != current);
-	if (recursive_depth) {
-		recursive_depth--;
+	if (cpu_hotplug.active_writer == current)
 		return;
-	}
-	recursive = NULL;
-	mutex_unlock(&cpu_bitmask_lock);
+	mutex_lock(&cpu_hotplug.lock);
+	cpu_hotplug.refcount--;
+
+	if (unlikely(writer_exists()) && !cpu_hotplug.refcount)
+		wake_up(&cpu_hotplug.writer_queue);
+
+	mutex_unlock(&cpu_hotplug.lock);
+
 }
 EXPORT_SYMBOL_GPL(unlock_cpu_hotplug);
 
 #endif	/* CONFIG_HOTPLUG_CPU */
 
+/*
+ * The following two API's must be used when attempting
+ * to serialize the updates to cpu_online_map, cpu_present_map.
+ */
+void cpu_maps_update_begin(void)
+{
+	mutex_lock(&cpu_add_remove_lock);
+}
+
+void cpu_maps_update_done(void)
+{
+	mutex_unlock(&cpu_add_remove_lock);
+}
+
+/*
+ * This ensures that the hotplug operation can begin only when the
+ * refcount goes to zero.
+ *
+ * Note that during a cpu-hotplug operation, the new readers, if any,
+ * will be blocked by the cpu_hotplug.lock
+ *
+ * Since cpu_maps_update_begin is always called after invoking
+ * cpu_maps_update_begin, we can be sure that only one writer is active.
+ *
+ * Note that theoretically, there is a possibility of a livelock:
+ * - Refcount goes to zero, last reader wakes up the sleeping
+ *   writer.
+ * - Last reader unlocks the cpu_hotplug.lock.
+ * - A new reader arrives at this moment, bumps up the refcount.
+ * - The writer acquires the cpu_hotplug.lock finds the refcount
+ *   non zero and goes to sleep again.
+ *
+ * However, this is very difficult to achieve in practice since
+ * lock_cpu_hotplug() not an api which is called all that often.
+ *
+ */
+static void cpu_hotplug_begin(void)
+{
+	DECLARE_WAITQUEUE(wait, current);
+
+	mutex_lock(&cpu_hotplug.lock);
+
+	cpu_hotplug.active_writer = current;
+	add_wait_queue_exclusive(&cpu_hotplug.writer_queue, &wait);
+	while (cpu_hotplug.refcount) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		mutex_unlock(&cpu_hotplug.lock);
+		schedule();
+		mutex_lock(&cpu_hotplug.lock);
+	}
+	remove_wait_queue_locked(&cpu_hotplug.writer_queue, &wait);
+}
+
+static void cpu_hotplug_done(void)
+{
+	cpu_hotplug.active_writer = NULL;
+	mutex_unlock(&cpu_hotplug.lock);
+}
 /* Need to know about CPUs going up/down? */
 int __cpuinit register_cpu_notifier(struct notifier_block *nb)
 {
 	int ret;
-	mutex_lock(&cpu_add_remove_lock);
+	cpu_maps_update_begin();
 	ret = raw_notifier_chain_register(&cpu_chain, nb);
-	mutex_unlock(&cpu_add_remove_lock);
+	cpu_maps_update_done();
 	return ret;
 }
 
@@ -81,9 +151,9 @@ EXPORT_SYMBOL(register_cpu_notifier);
 
 void unregister_cpu_notifier(struct notifier_block *nb)
 {
-	mutex_lock(&cpu_add_remove_lock);
+	cpu_maps_update_begin();
 	raw_notifier_chain_unregister(&cpu_chain, nb);
-	mutex_unlock(&cpu_add_remove_lock);
+	cpu_maps_update_done();
 }
 EXPORT_SYMBOL(unregister_cpu_notifier);
 
@@ -147,6 +217,7 @@ static int _cpu_down(unsigned int cpu, i
 	if (!cpu_online(cpu))
 		return -EINVAL;
 
+	cpu_hotplug_begin();
 	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_ACQUIRE, hcpu);
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
 					hcpu, -1, &nr_calls);
@@ -166,9 +237,7 @@ static int _cpu_down(unsigned int cpu, i
 	cpu_clear(cpu, tmp);
 	set_cpus_allowed(current, tmp);
 
-	mutex_lock(&cpu_bitmask_lock);
 	p = __stop_machine_run(take_cpu_down, &tcd_param, cpu);
-	mutex_unlock(&cpu_bitmask_lock);
 
 	if (IS_ERR(p) || cpu_online(cpu)) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
@@ -203,6 +272,7 @@ out_allowed:
 	set_cpus_allowed(current, old_allowed);
 out_release:
 	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_RELEASE, hcpu);
+	cpu_hotplug_done();
 	return err;
 }
 
@@ -210,13 +280,13 @@ int cpu_down(unsigned int cpu)
 {
 	int err = 0;
 
-	mutex_lock(&cpu_add_remove_lock);
+	cpu_maps_update_begin();
 	if (cpu_hotplug_disabled)
 		err = -EBUSY;
 	else
 		err = _cpu_down(cpu, 0);
 
-	mutex_unlock(&cpu_add_remove_lock);
+	cpu_maps_update_done();
 	return err;
 }
 #endif /*CONFIG_HOTPLUG_CPU*/
@@ -231,6 +301,7 @@ static int __cpuinit _cpu_up(unsigned in
 	if (cpu_online(cpu) || !cpu_present(cpu))
 		return -EINVAL;
 
+	cpu_hotplug_begin();
 	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_ACQUIRE, hcpu);
 	ret = __raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE | mod, hcpu,
 							-1, &nr_calls);
@@ -243,9 +314,7 @@ static int __cpuinit _cpu_up(unsigned in
 	}
 
 	/* Arch-specific enabling code. */
-	mutex_lock(&cpu_bitmask_lock);
 	ret = __cpu_up(cpu);
-	mutex_unlock(&cpu_bitmask_lock);
 	if (ret != 0)
 		goto out_notify;
 	BUG_ON(!cpu_online(cpu));
@@ -258,6 +327,7 @@ out_notify:
 		__raw_notifier_call_chain(&cpu_chain,
 				CPU_UP_CANCELED | mod, hcpu, nr_calls, NULL);
 	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_RELEASE, hcpu);
+	cpu_hotplug_done();
 
 	return ret;
 }
@@ -275,13 +345,13 @@ int __cpuinit cpu_up(unsigned int cpu)
 		return -EINVAL;
 	}
 
-	mutex_lock(&cpu_add_remove_lock);
+	cpu_maps_update_begin();
 	if (cpu_hotplug_disabled)
 		err = -EBUSY;
 	else
 		err = _cpu_up(cpu, 0);
 
-	mutex_unlock(&cpu_add_remove_lock);
+	cpu_maps_update_done();
 	return err;
 }
 
@@ -292,7 +362,7 @@ int disable_nonboot_cpus(void)
 {
 	int cpu, first_cpu, error = 0;
 
-	mutex_lock(&cpu_add_remove_lock);
+	cpu_maps_update_begin();
 	first_cpu = first_cpu(cpu_online_map);
 	/* We take down all of the non-boot CPUs in one shot to avoid races
 	 * with the userspace trying to use the CPU hotplug at the same time
@@ -319,7 +389,7 @@ int disable_nonboot_cpus(void)
 	} else {
 		printk(KERN_ERR "Non-boot CPUs are not disabled\n");
 	}
-	mutex_unlock(&cpu_add_remove_lock);
+	cpu_maps_update_done();
 	return error;
 }
 
@@ -328,7 +398,7 @@ void enable_nonboot_cpus(void)
 	int cpu, error;
 
 	/* Allow everyone to use the CPU hotplug again */
-	mutex_lock(&cpu_add_remove_lock);
+	cpu_maps_update_begin();
 	cpu_hotplug_disabled = 0;
 	if (cpus_empty(frozen_cpus))
 		goto out;
@@ -344,6 +414,6 @@ void enable_nonboot_cpus(void)
 	}
 	cpus_clear(frozen_cpus);
 out:
-	mutex_unlock(&cpu_add_remove_lock);
+	cpu_maps_update_done();
 }
 #endif /* CONFIG_PM_SLEEP_SMP */
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
