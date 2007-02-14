Return-Path: <linux-kernel-owner+w=401wt.eu-S932331AbXBNOoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbXBNOoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 09:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932335AbXBNOoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 09:44:39 -0500
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:46030 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932331AbXBNOoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 09:44:38 -0500
Date: Wed, 14 Feb 2007 20:14:34 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu
Cc: vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, oleg@tv-sign.ru, rjw@sisk.pl,
       kiran@scalex86.org
Subject: [RFC PATCH(Experimental) 4/4] Rip out lock_cpu_hotplug from linux.
Message-ID: <20070214144434.GD19789@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com> <20070214144305.GB19789@in.ibm.com> <20070214144350.GC19789@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214144350.GC19789@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch rips out lock_cpu_hotplug from the kernel.
Good Riddance!! (hopefully :) )

Signed-off-by : Gautham R Shenoy <ego@in.ibm.com>
--
 arch/i386/kernel/cpu/mtrr/main.c             |    6 ------
 arch/i386/kernel/microcode.c                 |    8 --------
 arch/mips/kernel/mips-mt.c                   |    5 -----
 arch/powerpc/platforms/pseries/hotplug-cpu.c |    5 -----
 arch/powerpc/platforms/pseries/rtasd.c       |    4 ----
 include/linux/cpu.h                          |   20 --------------------
 kernel/cpu.c                                 |   17 -----------------
 kernel/rcutorture.c                          |    3 ---
 kernel/stop_machine.c                        |    3 ---
 net/core/flow.c                              |    2 --
 10 files changed, 73 deletions(-)

Index: hotplug/include/linux/cpu.h
===================================================================
--- hotplug.orig/include/linux/cpu.h
+++ hotplug/include/linux/cpu.h
@@ -76,18 +76,6 @@ extern struct sysdev_class cpu_sysdev_cl
 #ifdef CONFIG_HOTPLUG_CPU
 /* Stop CPUs going up and down. */
 
-static inline void cpuhotplug_mutex_lock(struct mutex *cpu_hp_mutex)
-{
-	mutex_lock(cpu_hp_mutex);
-}
-
-static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
-{
-	mutex_unlock(cpu_hp_mutex);
-}
-
-extern void lock_cpu_hotplug(void);
-extern void unlock_cpu_hotplug(void);
 #define hotcpu_notifier(fn, pri) {				\
 	static struct notifier_block fn##_nb =			\
 		{ .notifier_call = fn, .priority = pri };	\
@@ -100,14 +88,6 @@ int cpu_down(unsigned int cpu);
 
 #else		/* CONFIG_HOTPLUG_CPU */
 
-static inline void cpuhotplug_mutex_lock(struct mutex *cpu_hp_mutex)
-{ }
-static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
-{ }
-
-#define lock_cpu_hotplug()	do { } while (0)
-#define unlock_cpu_hotplug()	do { } while (0)
-#define lock_cpu_hotplug_interruptible() 0
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 #define register_hotcpu_notifier(nb)	do { (void)(nb); } while (0)
 #define unregister_hotcpu_notifier(nb)	do { (void)(nb); } while (0)
Index: hotplug/kernel/cpu.c
===================================================================
--- hotplug.orig/kernel/cpu.c
+++ hotplug/kernel/cpu.c
@@ -18,7 +18,6 @@
 
 /* This protects CPUs going up and down... */
 static DEFINE_MUTEX(cpu_add_remove_lock);
-static DEFINE_MUTEX(cpu_bitmask_lock);
 
 static __cpuinitdata RAW_NOTIFIER_HEAD(cpu_chain);
 
@@ -27,22 +26,6 @@ static __cpuinitdata RAW_NOTIFIER_HEAD(c
  */
 static int cpu_hotplug_disabled;
 
-#ifdef CONFIG_HOTPLUG_CPU
-
-void lock_cpu_hotplug(void)
-{
-	return;
-}
-EXPORT_SYMBOL_GPL(lock_cpu_hotplug);
-
-void unlock_cpu_hotplug(void)
-{
-	return;
-}
-EXPORT_SYMBOL_GPL(unlock_cpu_hotplug);
-
-#endif	/* CONFIG_HOTPLUG_CPU */
-
 /* Need to know about CPUs going up/down? */
 int __cpuinit register_cpu_notifier(struct notifier_block *nb)
 {
Index: hotplug/arch/i386/kernel/cpu/mtrr/main.c
===================================================================
--- hotplug.orig/arch/i386/kernel/cpu/mtrr/main.c
+++ hotplug/arch/i386/kernel/cpu/mtrr/main.c
@@ -346,8 +346,6 @@ int mtrr_add_page(unsigned long base, un
 	error = -EINVAL;
 	replace = -1;
 
-	/* No CPU hotplug when we change MTRR entries */
-	lock_cpu_hotplug();
 	/*  Search for existing MTRR  */
 	mutex_lock(&mtrr_mutex);
 	for (i = 0; i < num_var_ranges; ++i) {
@@ -403,7 +401,6 @@ int mtrr_add_page(unsigned long base, un
 	error = i;
  out:
 	mutex_unlock(&mtrr_mutex);
-	unlock_cpu_hotplug();
 	return error;
 }
 
@@ -492,8 +489,6 @@ int mtrr_del_page(int reg, unsigned long
 		return -ENXIO;
 
 	max = num_var_ranges;
-	/* No CPU hotplug when we change MTRR entries */
-	lock_cpu_hotplug();
 	mutex_lock(&mtrr_mutex);
 	if (reg < 0) {
 		/*  Search for existing MTRR  */
@@ -534,7 +529,6 @@ int mtrr_del_page(int reg, unsigned long
 	error = reg;
  out:
 	mutex_unlock(&mtrr_mutex);
-	unlock_cpu_hotplug();
 	return error;
 }
 /**
Index: hotplug/arch/i386/kernel/microcode.c
===================================================================
--- hotplug.orig/arch/i386/kernel/microcode.c
+++ hotplug/arch/i386/kernel/microcode.c
@@ -435,7 +435,6 @@ static ssize_t microcode_write (struct f
 		return -EINVAL;
 	}
 
-	lock_cpu_hotplug();
 	mutex_lock(&microcode_mutex);
 
 	user_buffer = (void __user *) buf;
@@ -446,7 +445,6 @@ static ssize_t microcode_write (struct f
 		ret = (ssize_t)len;
 
 	mutex_unlock(&microcode_mutex);
-	unlock_cpu_hotplug();
 
 	return ret;
 }
@@ -609,14 +607,12 @@ static ssize_t reload_store(struct sys_d
 
 		old = current->cpus_allowed;
 
-		lock_cpu_hotplug();
 		set_cpus_allowed(current, cpumask_of_cpu(cpu));
 
 		mutex_lock(&microcode_mutex);
 		if (uci->valid)
 			err = cpu_request_microcode(cpu);
 		mutex_unlock(&microcode_mutex);
-		unlock_cpu_hotplug();
 		set_cpus_allowed(current, old);
 	}
 	if (err)
@@ -740,9 +736,7 @@ static int __init microcode_init (void)
 		return PTR_ERR(microcode_pdev);
 	}
 
-	lock_cpu_hotplug();
 	error = sysdev_driver_register(&cpu_sysdev_class, &mc_sysdev_driver);
-	unlock_cpu_hotplug();
 	if (error) {
 		microcode_dev_exit();
 		platform_device_unregister(microcode_pdev);
@@ -762,9 +756,7 @@ static void __exit microcode_exit (void)
 
 	unregister_hotcpu_notifier(&mc_cpu_notifier);
 
-	lock_cpu_hotplug();
 	sysdev_driver_unregister(&cpu_sysdev_class, &mc_sysdev_driver);
-	unlock_cpu_hotplug();
 
 	platform_device_unregister(microcode_pdev);
 }
Index: hotplug/arch/mips/kernel/mips-mt.c
===================================================================
--- hotplug.orig/arch/mips/kernel/mips-mt.c
+++ hotplug/arch/mips/kernel/mips-mt.c
@@ -71,13 +71,11 @@ asmlinkage long mipsmt_sys_sched_setaffi
 	if (copy_from_user(&new_mask, user_mask_ptr, sizeof(new_mask)))
 		return -EFAULT;
 
-	lock_cpu_hotplug();
 	read_lock(&tasklist_lock);
 
 	p = find_process_by_pid(pid);
 	if (!p) {
 		read_unlock(&tasklist_lock);
-		unlock_cpu_hotplug();
 		return -ESRCH;
 	}
 
@@ -115,7 +113,6 @@ asmlinkage long mipsmt_sys_sched_setaffi
 
 out_unlock:
 	put_task_struct(p);
-	unlock_cpu_hotplug();
 	return retval;
 }
 
@@ -134,7 +131,6 @@ asmlinkage long mipsmt_sys_sched_getaffi
 	if (len < real_len)
 		return -EINVAL;
 
-	lock_cpu_hotplug();
 	read_lock(&tasklist_lock);
 
 	retval = -ESRCH;
@@ -148,7 +144,6 @@ asmlinkage long mipsmt_sys_sched_getaffi
 
 out_unlock:
 	read_unlock(&tasklist_lock);
-	unlock_cpu_hotplug();
 	if (retval)
 		return retval;
 	if (copy_to_user(user_mask_ptr, &mask, real_len))
Index: hotplug/arch/powerpc/platforms/pseries/hotplug-cpu.c
===================================================================
--- hotplug.orig/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ hotplug/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -151,8 +151,6 @@ static int pseries_add_processor(struct 
 	for (i = 0; i < nthreads; i++)
 		cpu_set(i, tmp);
 
-	lock_cpu_hotplug();
-
 	BUG_ON(!cpus_subset(cpu_present_map, cpu_possible_map));
 
 	/* Get a bitmap of unoccupied slots. */
@@ -188,7 +186,6 @@ static int pseries_add_processor(struct 
 	}
 	err = 0;
 out_unlock:
-	unlock_cpu_hotplug();
 	return err;
 }
 
@@ -209,7 +206,6 @@ static void pseries_remove_processor(str
 
 	nthreads = len / sizeof(u32);
 
-	lock_cpu_hotplug();
 	for (i = 0; i < nthreads; i++) {
 		for_each_present_cpu(cpu) {
 			if (get_hard_smp_processor_id(cpu) != intserv[i])
@@ -223,7 +219,6 @@ static void pseries_remove_processor(str
 			printk(KERN_WARNING "Could not find cpu to remove "
 			       "with physical id 0x%x\n", intserv[i]);
 	}
-	unlock_cpu_hotplug();
 }
 
 static int pseries_smp_notifier(struct notifier_block *nb,
Index: hotplug/arch/powerpc/platforms/pseries/rtasd.c
===================================================================
--- hotplug.orig/arch/powerpc/platforms/pseries/rtasd.c
+++ hotplug/arch/powerpc/platforms/pseries/rtasd.c
@@ -404,7 +404,6 @@ static void do_event_scan_all_cpus(long 
 {
 	int cpu;
 
-	lock_cpu_hotplug();
 	cpu = first_cpu(cpu_online_map);
 	for (;;) {
 		set_cpus_allowed(current, cpumask_of_cpu(cpu));
@@ -412,15 +411,12 @@ static void do_event_scan_all_cpus(long 
 		set_cpus_allowed(current, CPU_MASK_ALL);
 
 		/* Drop hotplug lock, and sleep for the specified delay */
-		unlock_cpu_hotplug();
 		msleep_interruptible(delay);
-		lock_cpu_hotplug();
 
 		cpu = next_cpu(cpu, cpu_online_map);
 		if (cpu == NR_CPUS)
 			break;
 	}
-	unlock_cpu_hotplug();
 }
 
 static int rtasd(void *unused)
Index: hotplug/kernel/rcutorture.c
===================================================================
--- hotplug.orig/kernel/rcutorture.c
+++ hotplug/kernel/rcutorture.c
@@ -803,11 +803,9 @@ static void rcu_torture_shuffle_tasks(vo
 	cpumask_t tmp_mask = CPU_MASK_ALL;
 	int i;
 
-	lock_cpu_hotplug();
 
 	/* No point in shuffling if there is only one online CPU (ex: UP) */
 	if (num_online_cpus() == 1) {
-		unlock_cpu_hotplug();
 		return;
 	}
 
@@ -839,7 +837,6 @@ static void rcu_torture_shuffle_tasks(vo
 	else
 		rcu_idle_cpu--;
 
-	unlock_cpu_hotplug();
 }
 
 /* Shuffle tasks across CPUs, with the intent of allowing each CPU in the
Index: hotplug/kernel/stop_machine.c
===================================================================
--- hotplug.orig/kernel/stop_machine.c
+++ hotplug/kernel/stop_machine.c
@@ -197,14 +197,11 @@ int stop_machine_run(int (*fn)(void *), 
 	struct task_struct *p;
 	int ret;
 
-	/* No CPUs can come up or down during this. */
-	lock_cpu_hotplug();
 	p = __stop_machine_run(fn, data, cpu);
 	if (!IS_ERR(p))
 		ret = kthread_stop(p);
 	else
 		ret = PTR_ERR(p);
-	unlock_cpu_hotplug();
 
 	return ret;
 }
Index: hotplug/net/core/flow.c
===================================================================
--- hotplug.orig/net/core/flow.c
+++ hotplug/net/core/flow.c
@@ -296,7 +296,6 @@ void flow_cache_flush(void)
 	static DEFINE_MUTEX(flow_flush_sem);
 
 	/* Don't want cpus going down or up during this. */
-	lock_cpu_hotplug();
 	mutex_lock(&flow_flush_sem);
 	atomic_set(&info.cpuleft, num_online_cpus());
 	init_completion(&info.completion);
@@ -308,7 +307,6 @@ void flow_cache_flush(void)
 
 	wait_for_completion(&info.completion);
 	mutex_unlock(&flow_flush_sem);
-	unlock_cpu_hotplug();
 }
 
 static void __devinit flow_cache_cpu_prepare(int cpu)
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
