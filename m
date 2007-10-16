Return-Path: <linux-kernel-owner+w=401wt.eu-S933697AbXJPKfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933697AbXJPKfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 06:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933140AbXJPKfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 06:35:17 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:42121 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210AbXJPKfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 06:35:12 -0400
Date: Tue, 16 Oct 2007 16:05:06 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Rusty Russel <rusty@rustcorp.com.au>,
       Dipankar Sarma <dipankar@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Paul E McKenney <paulmck@us.ibm.com>
Subject: [RFC PATCH 2/4] Rename lock_cpu_hotplug to get_online_cpus
Message-ID: <20071016103506.GB16570@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071016103308.GA9907@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016103308.GA9907@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace all lock_cpu_hotplug/unlock_cpu_hotplug from the kernel and use 
get_online_cpus and put_online_cpus instead as it highlights
the refcount semantics in these operations.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---
 arch/i386/kernel/cpu/mtrr/main.c             |    8 ++++----
 arch/i386/kernel/microcode.c                 |   16 ++++++++--------
 arch/mips/kernel/mips-mt-fpaff.c             |   10 +++++-----
 arch/powerpc/platforms/pseries/hotplug-cpu.c |    8 ++++----
 arch/powerpc/platforms/pseries/rtasd.c       |    8 ++++----
 drivers/lguest/core.c                        |    8 ++++----
 drivers/s390/char/sclp_config.c              |    4 ++--
 include/linux/cpu.h                          |   10 +++++-----
 kernel/cpu.c                                 |    8 ++++----
 kernel/cpuset.c                              |   14 +++++++-------
 kernel/rcutorture.c                          |    6 +++---
 kernel/stop_machine.c                        |    4 ++--
 net/core/flow.c                              |    4 ++--
 13 files changed, 54 insertions(+), 54 deletions(-)

Index: linux-2.6.23/include/linux/cpu.h
===================================================================
--- linux-2.6.23.orig/include/linux/cpu.h
+++ linux-2.6.23/include/linux/cpu.h
@@ -98,8 +98,8 @@ static inline void cpuhotplug_mutex_unlo
 }
 
 extern void cpu_hotplug_init(void);
-extern void lock_cpu_hotplug(void);
-extern void unlock_cpu_hotplug(void);
+extern void get_online_cpus(void);
+extern void put_online_cpus(void);
 #define hotcpu_notifier(fn, pri) {				\
 	static struct notifier_block fn##_nb =			\
 		{ .notifier_call = fn, .priority = pri };	\
@@ -117,9 +117,9 @@ static inline void cpuhotplug_mutex_lock
 static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
 { }
 
-#define cpu_hotplug_init()     do { } while (0)
-#define lock_cpu_hotplug()	do { } while (0)
-#define unlock_cpu_hotplug()	do { } while (0)
+#define cpu_hotplug_init()		do { } while (0)
+#define get_online_cpus()		do { } while (0)
+#define put_online_cpus()		do { } while (0)
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 /* These aren't inline functions due to a GCC bug. */
 #define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
Index: linux-2.6.23/kernel/cpu.c
===================================================================
--- linux-2.6.23.orig/kernel/cpu.c
+++ linux-2.6.23/kernel/cpu.c
@@ -48,7 +48,7 @@ void __init cpu_hotplug_init(void)
 	init_completion(&cpu_hotplug.readers_done);
 }
 
-void lock_cpu_hotplug(void)
+void get_online_cpus(void)
 {
 	might_sleep();
 	if (cpu_hotplug.active_writer == current)
@@ -58,9 +58,9 @@ void lock_cpu_hotplug(void)
 	mutex_unlock(&cpu_hotplug.lock);
 
 }
-EXPORT_SYMBOL_GPL(lock_cpu_hotplug);
+EXPORT_SYMBOL_GPL(get_online_cpus);
 
-void unlock_cpu_hotplug(void)
+void put_online_cpus(void)
 {
 	if (cpu_hotplug.active_writer == current)
 		return;
@@ -73,7 +73,7 @@ void unlock_cpu_hotplug(void)
 	mutex_unlock(&cpu_hotplug.lock);
 
 }
-EXPORT_SYMBOL_GPL(unlock_cpu_hotplug);
+EXPORT_SYMBOL_GPL(put_online_cpus);
 
 #endif	/* CONFIG_HOTPLUG_CPU */
 
Index: linux-2.6.23/kernel/stop_machine.c
===================================================================
--- linux-2.6.23.orig/kernel/stop_machine.c
+++ linux-2.6.23/kernel/stop_machine.c
@@ -203,13 +203,13 @@ int stop_machine_run(int (*fn)(void *), 
 	int ret;
 
 	/* No CPUs can come up or down during this. */
-	lock_cpu_hotplug();
+	get_online_cpus();
 	p = __stop_machine_run(fn, data, cpu);
 	if (!IS_ERR(p))
 		ret = kthread_stop(p);
 	else
 		ret = PTR_ERR(p);
-	unlock_cpu_hotplug();
+	put_online_cpus();
 
 	return ret;
 }
Index: linux-2.6.23/arch/i386/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.23.orig/arch/i386/kernel/cpu/mtrr/main.c
+++ linux-2.6.23/arch/i386/kernel/cpu/mtrr/main.c
@@ -351,7 +351,7 @@ int mtrr_add_page(unsigned long base, un
 	replace = -1;
 
 	/* No CPU hotplug when we change MTRR entries */
-	lock_cpu_hotplug();
+	get_online_cpus();
 	/*  Search for existing MTRR  */
 	mutex_lock(&mtrr_mutex);
 	for (i = 0; i < num_var_ranges; ++i) {
@@ -407,7 +407,7 @@ int mtrr_add_page(unsigned long base, un
 	error = i;
  out:
 	mutex_unlock(&mtrr_mutex);
-	unlock_cpu_hotplug();
+	put_online_cpus();
 	return error;
 }
 
@@ -497,7 +497,7 @@ int mtrr_del_page(int reg, unsigned long
 
 	max = num_var_ranges;
 	/* No CPU hotplug when we change MTRR entries */
-	lock_cpu_hotplug();
+	get_online_cpus();
 	mutex_lock(&mtrr_mutex);
 	if (reg < 0) {
 		/*  Search for existing MTRR  */
@@ -538,7 +538,7 @@ int mtrr_del_page(int reg, unsigned long
 	error = reg;
  out:
 	mutex_unlock(&mtrr_mutex);
-	unlock_cpu_hotplug();
+	put_online_cpus();
 	return error;
 }
 /**
Index: linux-2.6.23/arch/i386/kernel/microcode.c
===================================================================
--- linux-2.6.23.orig/arch/i386/kernel/microcode.c
+++ linux-2.6.23/arch/i386/kernel/microcode.c
@@ -436,7 +436,7 @@ static ssize_t microcode_write (struct f
 		return -EINVAL;
 	}
 
-	lock_cpu_hotplug();
+	get_online_cpus();
 	mutex_lock(&microcode_mutex);
 
 	user_buffer = (void __user *) buf;
@@ -447,7 +447,7 @@ static ssize_t microcode_write (struct f
 		ret = (ssize_t)len;
 
 	mutex_unlock(&microcode_mutex);
-	unlock_cpu_hotplug();
+	put_online_cpus();
 
 	return ret;
 }
@@ -658,14 +658,14 @@ static ssize_t reload_store(struct sys_d
 
 		old = current->cpus_allowed;
 
-		lock_cpu_hotplug();
+		get_online_cpus();
 		set_cpus_allowed(current, cpumask_of_cpu(cpu));
 
 		mutex_lock(&microcode_mutex);
 		if (uci->valid)
 			err = cpu_request_microcode(cpu);
 		mutex_unlock(&microcode_mutex);
-		unlock_cpu_hotplug();
+		put_online_cpus();
 		set_cpus_allowed(current, old);
 	}
 	if (err)
@@ -817,9 +817,9 @@ static int __init microcode_init (void)
 		return PTR_ERR(microcode_pdev);
 	}
 
-	lock_cpu_hotplug();
+	get_online_cpus();
 	error = sysdev_driver_register(&cpu_sysdev_class, &mc_sysdev_driver);
-	unlock_cpu_hotplug();
+	put_online_cpus();
 	if (error) {
 		microcode_dev_exit();
 		platform_device_unregister(microcode_pdev);
@@ -839,9 +839,9 @@ static void __exit microcode_exit (void)
 
 	unregister_hotcpu_notifier(&mc_cpu_notifier);
 
-	lock_cpu_hotplug();
+	get_online_cpus();
 	sysdev_driver_unregister(&cpu_sysdev_class, &mc_sysdev_driver);
-	unlock_cpu_hotplug();
+	put_online_cpus();
 
 	platform_device_unregister(microcode_pdev);
 }
Index: linux-2.6.23/arch/powerpc/platforms/pseries/hotplug-cpu.c
===================================================================
--- linux-2.6.23.orig/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ linux-2.6.23/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -151,7 +151,7 @@ static int pseries_add_processor(struct 
 	for (i = 0; i < nthreads; i++)
 		cpu_set(i, tmp);
 
-	lock_cpu_hotplug();
+	get_online_cpus();
 
 	BUG_ON(!cpus_subset(cpu_present_map, cpu_possible_map));
 
@@ -188,7 +188,7 @@ static int pseries_add_processor(struct 
 	}
 	err = 0;
 out_unlock:
-	unlock_cpu_hotplug();
+	put_online_cpus();
 	return err;
 }
 
@@ -209,7 +209,7 @@ static void pseries_remove_processor(str
 
 	nthreads = len / sizeof(u32);
 
-	lock_cpu_hotplug();
+	get_online_cpus();
 	for (i = 0; i < nthreads; i++) {
 		for_each_present_cpu(cpu) {
 			if (get_hard_smp_processor_id(cpu) != intserv[i])
@@ -223,7 +223,7 @@ static void pseries_remove_processor(str
 			printk(KERN_WARNING "Could not find cpu to remove "
 			       "with physical id 0x%x\n", intserv[i]);
 	}
-	unlock_cpu_hotplug();
+	put_online_cpus();
 }
 
 static int pseries_smp_notifier(struct notifier_block *nb,
Index: linux-2.6.23/arch/powerpc/platforms/pseries/rtasd.c
===================================================================
--- linux-2.6.23.orig/arch/powerpc/platforms/pseries/rtasd.c
+++ linux-2.6.23/arch/powerpc/platforms/pseries/rtasd.c
@@ -382,7 +382,7 @@ static void do_event_scan_all_cpus(long 
 {
 	int cpu;
 
-	lock_cpu_hotplug();
+	get_online_cpus();
 	cpu = first_cpu(cpu_online_map);
 	for (;;) {
 		set_cpus_allowed(current, cpumask_of_cpu(cpu));
@@ -390,15 +390,15 @@ static void do_event_scan_all_cpus(long 
 		set_cpus_allowed(current, CPU_MASK_ALL);
 
 		/* Drop hotplug lock, and sleep for the specified delay */
-		unlock_cpu_hotplug();
+		put_online_cpus();
 		msleep_interruptible(delay);
-		lock_cpu_hotplug();
+		get_online_cpus();
 
 		cpu = next_cpu(cpu, cpu_online_map);
 		if (cpu == NR_CPUS)
 			break;
 	}
-	unlock_cpu_hotplug();
+	put_online_cpus();
 }
 
 static int rtasd(void *unused)
Index: linux-2.6.23/drivers/s390/char/sclp_config.c
===================================================================
--- linux-2.6.23.orig/drivers/s390/char/sclp_config.c
+++ linux-2.6.23/drivers/s390/char/sclp_config.c
@@ -29,12 +29,12 @@ static void sclp_cpu_capability_notify(s
 	struct sys_device *sysdev;
 
 	printk(KERN_WARNING TAG "cpu capability changed.\n");
-	lock_cpu_hotplug();
+	get_online_cpus();
 	for_each_online_cpu(cpu) {
 		sysdev = get_cpu_sysdev(cpu);
 		kobject_uevent(&sysdev->kobj, KOBJ_CHANGE);
 	}
-	unlock_cpu_hotplug();
+	put_online_cpus();
 }
 
 static void sclp_conf_receiver_fn(struct evbuf_header *evbuf)
Index: linux-2.6.23/kernel/rcutorture.c
===================================================================
--- linux-2.6.23.orig/kernel/rcutorture.c
+++ linux-2.6.23/kernel/rcutorture.c
@@ -726,11 +726,11 @@ static void rcu_torture_shuffle_tasks(vo
 	cpumask_t tmp_mask = CPU_MASK_ALL;
 	int i;
 
-	lock_cpu_hotplug();
+	get_online_cpus();
 
 	/* No point in shuffling if there is only one online CPU (ex: UP) */
 	if (num_online_cpus() == 1) {
-		unlock_cpu_hotplug();
+		put_online_cpus();
 		return;
 	}
 
@@ -762,7 +762,7 @@ static void rcu_torture_shuffle_tasks(vo
 	else
 		rcu_idle_cpu--;
 
-	unlock_cpu_hotplug();
+	put_online_cpus();
 }
 
 /* Shuffle tasks across CPUs, with the intent of allowing each CPU in the
Index: linux-2.6.23/net/core/flow.c
===================================================================
--- linux-2.6.23.orig/net/core/flow.c
+++ linux-2.6.23/net/core/flow.c
@@ -296,7 +296,7 @@ void flow_cache_flush(void)
 	static DEFINE_MUTEX(flow_flush_sem);
 
 	/* Don't want cpus going down or up during this. */
-	lock_cpu_hotplug();
+	get_online_cpus();
 	mutex_lock(&flow_flush_sem);
 	atomic_set(&info.cpuleft, num_online_cpus());
 	init_completion(&info.completion);
@@ -308,7 +308,7 @@ void flow_cache_flush(void)
 
 	wait_for_completion(&info.completion);
 	mutex_unlock(&flow_flush_sem);
-	unlock_cpu_hotplug();
+	put_online_cpus();
 }
 
 static void __devinit flow_cache_cpu_prepare(int cpu)
Index: linux-2.6.23/arch/mips/kernel/mips-mt-fpaff.c
===================================================================
--- linux-2.6.23.orig/arch/mips/kernel/mips-mt-fpaff.c
+++ linux-2.6.23/arch/mips/kernel/mips-mt-fpaff.c
@@ -58,13 +58,13 @@ asmlinkage long mipsmt_sys_sched_setaffi
 	if (copy_from_user(&new_mask, user_mask_ptr, sizeof(new_mask)))
 		return -EFAULT;
 
-	lock_cpu_hotplug();
+	get_online_cpus();
 	read_lock(&tasklist_lock);
 
 	p = find_process_by_pid(pid);
 	if (!p) {
 		read_unlock(&tasklist_lock);
-		unlock_cpu_hotplug();
+		put_online_cpus();
 		return -ESRCH;
 	}
 
@@ -106,7 +106,7 @@ asmlinkage long mipsmt_sys_sched_setaffi
 
 out_unlock:
 	put_task_struct(p);
-	unlock_cpu_hotplug();
+	put_online_cpus();
 	return retval;
 }
 
@@ -125,7 +125,7 @@ asmlinkage long mipsmt_sys_sched_getaffi
 	if (len < real_len)
 		return -EINVAL;
 
-	lock_cpu_hotplug();
+	get_online_cpus();
 	read_lock(&tasklist_lock);
 
 	retval = -ESRCH;
@@ -140,7 +140,7 @@ asmlinkage long mipsmt_sys_sched_getaffi
 
 out_unlock:
 	read_unlock(&tasklist_lock);
-	unlock_cpu_hotplug();
+	put_online_cpus();
 	if (retval)
 		return retval;
 	if (copy_to_user(user_mask_ptr, &mask, real_len))
Index: linux-2.6.23/drivers/lguest/core.c
===================================================================
--- linux-2.6.23.orig/drivers/lguest/core.c
+++ linux-2.6.23/drivers/lguest/core.c
@@ -735,7 +735,7 @@ static int __init init(void)
 
 	/* We don't need the complexity of CPUs coming and going while we're
 	 * doing this. */
-	lock_cpu_hotplug();
+	get_online_cpus();
 	if (cpu_has_pge) { /* We have a broader idea of "global". */
 		/* Remember that this was originally set (for cleanup). */
 		cpu_had_pge = 1;
@@ -745,7 +745,7 @@ static int __init init(void)
 		/* Turn off the feature in the global feature set. */
 		clear_bit(X86_FEATURE_PGE, boot_cpu_data.x86_capability);
 	}
-	unlock_cpu_hotplug();
+	put_online_cpus();
 
 	/* All good! */
 	return 0;
@@ -759,13 +759,13 @@ static void __exit fini(void)
 	unmap_switcher();
 
 	/* If we had PGE before we started, turn it back on now. */
-	lock_cpu_hotplug();
+	get_online_cpus();
 	if (cpu_had_pge) {
 		set_bit(X86_FEATURE_PGE, boot_cpu_data.x86_capability);
 		/* adjust_pge's argument "1" means set PGE. */
 		on_each_cpu(adjust_pge, (void *)1, 0, 1);
 	}
-	unlock_cpu_hotplug();
+	put_online_cpus();
 }
 
 /* The Host side of lguest can be a module.  This is a nice way for people to
Index: linux-2.6.23/kernel/cpuset.c
===================================================================
--- linux-2.6.23.orig/kernel/cpuset.c
+++ linux-2.6.23/kernel/cpuset.c
@@ -536,10 +536,10 @@ static int cpusets_overlap(struct cpuset
  *
  * Call with cgroup_mutex held.  May take callback_mutex during
  * call due to the kfifo_alloc() and kmalloc() calls.  May nest
- * a call to the lock_cpu_hotplug()/unlock_cpu_hotplug() pair.
+ * a call to the get_online_cpus()/put_online_cpus() pair.
  * Must not be called holding callback_mutex, because we must not
- * call lock_cpu_hotplug() while holding callback_mutex.  Elsewhere
- * the kernel nests callback_mutex inside lock_cpu_hotplug() calls.
+ * call get_online_cpus() while holding callback_mutex.  Elsewhere
+ * the kernel nests callback_mutex inside get_online_cpus() calls.
  * So the reverse nesting would risk an ABBA deadlock.
  *
  * The three key local variables below are:
@@ -673,9 +673,9 @@ restart:
 
 rebuild:
 	/* Have scheduler rebuild sched domains */
-	lock_cpu_hotplug();
+	get_online_cpus();
 	partition_sched_domains(ndoms, doms);
-	unlock_cpu_hotplug();
+	put_online_cpus();
 
 done:
 	if (q && !IS_ERR(q))
@@ -1503,10 +1503,10 @@ static struct cgroup_subsys_state *cpuse
  *
  * If the cpuset being removed has its flag 'sched_load_balance'
  * enabled, then simulate turning sched_load_balance off, which
- * will call rebuild_sched_domains().  The lock_cpu_hotplug()
+ * will call rebuild_sched_domains().  The get_online_cpus()
  * call in rebuild_sched_domains() must not be made while holding
  * callback_mutex.  Elsewhere the kernel nests callback_mutex inside
- * lock_cpu_hotplug() calls.  So the reverse nesting would risk an
+ * get_online_cpus() calls.  So the reverse nesting would risk an
  * ABBA deadlock.
  */
 
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
