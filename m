Return-Path: <linux-kernel-owner+w=401wt.eu-S933438AbXJPKem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438AbXJPKem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 06:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765586AbXJPKe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 06:34:27 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36138 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760083AbXJPKeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 06:34:25 -0400
Date: Tue, 16 Oct 2007 16:04:17 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Rusty Russel <rusty@rustcorp.com.au>,
       Dipankar Sarma <dipankar@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@us.ibm.com>
Subject: [RFC PATCH 1/4] Refcount Based Cpu-Hotplug Implementation
Message-ID: <20071016103417.GA16570@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071016103308.GA9907@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016103308.GA9907@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a Refcount + Waitqueue based model for
cpu-hotplug. 

A thread which wants to prevent cpu-hotplug, will now bump up a 
global refcount and the thread which wants to perform a cpu-hotplug
operation will block till the global refcount goes to zero.

The readers, if any, during an ongoing cpu-hotplug operation are blocked
until the cpu-hotplug operation is over.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---
 include/linux/cpu.h |    2 +
 init/main.c         |    1 
 kernel/cpu.c        |   91 ++++++++++++++++++++++++++++++++++++----------------
 3 files changed, 67 insertions(+), 27 deletions(-)

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
@@ -97,6 +97,7 @@ static inline void cpuhotplug_mutex_unlo
 	mutex_unlock(cpu_hp_mutex);
 }
 
+extern void cpu_hotplug_init(void);
 extern void lock_cpu_hotplug(void);
 extern void unlock_cpu_hotplug(void);
 #define hotcpu_notifier(fn, pri) {				\
@@ -116,6 +117,7 @@ static inline void cpuhotplug_mutex_lock
 static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
 { }
 
+#define cpu_hotplug_init()     do { } while (0)
 #define lock_cpu_hotplug()	do { } while (0)
 #define unlock_cpu_hotplug()	do { } while (0)
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
Index: linux-2.6.23/kernel/cpu.c
===================================================================
--- linux-2.6.23.orig/kernel/cpu.c
+++ linux-2.6.23/kernel/cpu.c
@@ -17,7 +17,6 @@
 
 /* This protects CPUs going up and down... */
 static DEFINE_MUTEX(cpu_add_remove_lock);
-static DEFINE_MUTEX(cpu_bitmask_lock);
 
 static __cpuinitdata RAW_NOTIFIER_HEAD(cpu_chain);
 
@@ -26,45 +25,83 @@ static __cpuinitdata RAW_NOTIFIER_HEAD(c
  */
 static int cpu_hotplug_disabled;
 
+static struct {
+	struct task_struct *active_writer;
+	struct mutex lock; /* Synchronizes accesses to refcount, */
+	/*
+	 * Also blocks the new readers during
+	 * an ongoing cpu hotplug operation.
+	 */
+	int refcount;
+	struct completion readers_done;
+} cpu_hotplug;
+
+#define writer_exists() (cpu_hotplug.active_writer != NULL)
+
 #ifdef CONFIG_HOTPLUG_CPU
 
-/* Crappy recursive lock-takers in cpufreq! Complain loudly about idiots */
-static struct task_struct *recursive;
-static int recursive_depth;
+void __init cpu_hotplug_init(void)
+{
+	cpu_hotplug.active_writer = NULL;
+	mutex_init(&cpu_hotplug.lock);
+	cpu_hotplug.refcount = 0;
+	init_completion(&cpu_hotplug.readers_done);
+}
 
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
+		complete(&cpu_hotplug.readers_done);
+
+	mutex_unlock(&cpu_hotplug.lock);
+
 }
 EXPORT_SYMBOL_GPL(unlock_cpu_hotplug);
 
 #endif	/* CONFIG_HOTPLUG_CPU */
 
+/*
+ * This ensures that the hotplug operation can begin only when the
+ * refcount goes to zero.
+ *
+ * Note that during a cpu-hotplug operation, the new readers, if any,
+ * will be blocked by the cpu_hotplug.lock
+ */
+static void cpu_hotplug_begin(void)
+{
+	mutex_lock(&cpu_hotplug.lock);
+	cpu_hotplug.active_writer = current;
+	while (cpu_hotplug.refcount) {
+		mutex_unlock(&cpu_hotplug.lock);
+		wait_for_completion(&cpu_hotplug.readers_done);
+		mutex_lock(&cpu_hotplug.lock);
+	}
+
+}
+
+static void cpu_hotplug_done(void)
+{
+	cpu_hotplug.active_writer = NULL;
+	mutex_unlock(&cpu_hotplug.lock);
+}
+
 /* Need to know about CPUs going up/down? */
 int __cpuinit register_cpu_notifier(struct notifier_block *nb)
 {
@@ -147,6 +184,7 @@ static int _cpu_down(unsigned int cpu, i
 	if (!cpu_online(cpu))
 		return -EINVAL;
 
+	cpu_hotplug_begin();
 	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_ACQUIRE, hcpu);
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
 					hcpu, -1, &nr_calls);
@@ -166,9 +204,7 @@ static int _cpu_down(unsigned int cpu, i
 	cpu_clear(cpu, tmp);
 	set_cpus_allowed(current, tmp);
 
-	mutex_lock(&cpu_bitmask_lock);
 	p = __stop_machine_run(take_cpu_down, &tcd_param, cpu);
-	mutex_unlock(&cpu_bitmask_lock);
 
 	if (IS_ERR(p) || cpu_online(cpu)) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
@@ -203,6 +239,7 @@ out_allowed:
 	set_cpus_allowed(current, old_allowed);
 out_release:
 	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_RELEASE, hcpu);
+	cpu_hotplug_done();
 	return err;
 }
 
@@ -231,6 +268,7 @@ static int __cpuinit _cpu_up(unsigned in
 	if (cpu_online(cpu) || !cpu_present(cpu))
 		return -EINVAL;
 
+	cpu_hotplug_begin();
 	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_ACQUIRE, hcpu);
 	ret = __raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE | mod, hcpu,
 							-1, &nr_calls);
@@ -243,9 +281,7 @@ static int __cpuinit _cpu_up(unsigned in
 	}
 
 	/* Arch-specific enabling code. */
-	mutex_lock(&cpu_bitmask_lock);
 	ret = __cpu_up(cpu);
-	mutex_unlock(&cpu_bitmask_lock);
 	if (ret != 0)
 		goto out_notify;
 	BUG_ON(!cpu_online(cpu));
@@ -258,6 +294,7 @@ out_notify:
 		__raw_notifier_call_chain(&cpu_chain,
 				CPU_UP_CANCELED | mod, hcpu, nr_calls, NULL);
 	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_RELEASE, hcpu);
+	cpu_hotplug_done();
 
 	return ret;
 }
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
