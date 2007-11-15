Return-Path: <linux-kernel-owner+w=401wt.eu-S1762081AbXKONx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762081AbXKONx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 08:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758293AbXKONxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 08:53:03 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:56142 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953AbXKONw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 08:52:58 -0500
Date: Thu, 15 Nov 2007 19:22:02 +0530
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
Subject: [RFC PATCH 2/3] cpu-hotplug: Replace lock_cpu_hotplug() with
	get_online_cpus()
Message-ID: <20071115135202.GB15462@in.ibm.com>
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
Subject: [PATCH 2/3] cpu-hotplug: Replace lock_cpu_hotplug() with get_online_cpus()

Replace all lock_cpu_hotplug/unlock_cpu_hotplug from the kernel and use
get_online_cpus and put_online_cpus instead as it highlights
the refcount semantics in these operations.

The new API guarantees protection against the cpu-hotplug operation,
but it doesn't guarantee serialized access to any of the local data
structures. Hence the changes needs to be reviewed.

In case of pseries_add_processor/pseries_remove_processor, use
cpu_maps_update_begin()/cpu_maps_update_done() as we're modifying the
cpu_present_map there.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---
 Documentation/cpu-hotplug.txt                |   11 ++++++-----
 arch/mips/kernel/mips-mt-fpaff.c             |   10 +++++-----
 arch/powerpc/platforms/pseries/hotplug-cpu.c |    8 ++++----
 arch/powerpc/platforms/pseries/rtasd.c       |    8 ++++----
 arch/x86/kernel/cpu/mtrr/main.c              |    8 ++++----
 arch/x86/kernel/microcode.c                  |   16 ++++++++--------
 drivers/lguest/x86/core.c                    |    8 ++++----
 drivers/s390/char/sclp_config.c              |    4 ++--
 include/linux/cpu.h                          |    8 ++++----
 kernel/cpu.c                                 |   10 +++++-----
 kernel/cpuset.c                              |   14 +++++++-------
 kernel/rcutorture.c                          |    6 +++---
 kernel/stop_machine.c                        |    4 ++--
 net/core/flow.c                              |    4 ++--
 14 files changed, 60 insertions(+), 59 deletions(-)

diff --git a/Documentation/cpu-hotplug.txt b/Documentation/cpu-hotplug.txt
index a741f65..fb94f5a 100644
--- a/Documentation/cpu-hotplug.txt
+++ b/Documentation/cpu-hotplug.txt
@@ -109,12 +109,13 @@ Never use anything other than cpumask_t to represent bitmap of CPUs.
 	for_each_cpu_mask(x,mask) - Iterate over some random collection of cpu mask.
 
 	#include <linux/cpu.h>
-	lock_cpu_hotplug() and unlock_cpu_hotplug():
+	get_online_cpus() and put_online_cpus():
 
-The above calls are used to inhibit cpu hotplug operations. While holding the
-cpucontrol mutex, cpu_online_map will not change. If you merely need to avoid
-cpus going away, you could also use preempt_disable() and preempt_enable()
-for those sections. Just remember the critical section cannot call any
+The above calls are used to inhibit cpu hotplug operations. While the
+cpu_hotplug.refcount is non zero, the cpu_online_map will not change.
+If you merely need to avoid cpus going away, you could also use
+preempt_disable() and preempt_enable() for those sections.
+Just remember the critical section cannot call any
 function that can sleep or schedule this process away. The preempt_disable()
 will work as long as stop_machine_run() is used to take a cpu down.
 
diff --git a/arch/mips/kernel/mips-mt-fpaff.c b/arch/mips/kernel/mips-mt-fpaff.c
index 892665b..bb4f00c 100644
--- a/arch/mips/kernel/mips-mt-fpaff.c
+++ b/arch/mips/kernel/mips-mt-fpaff.c
@@ -58,13 +58,13 @@ asmlinkage long mipsmt_sys_sched_setaffinity(pid_t pid, unsigned int len,
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
 
@@ -106,7 +106,7 @@ asmlinkage long mipsmt_sys_sched_setaffinity(pid_t pid, unsigned int len,
 
 out_unlock:
 	put_task_struct(p);
-	unlock_cpu_hotplug();
+	put_online_cpus();
 	return retval;
 }
 
@@ -125,7 +125,7 @@ asmlinkage long mipsmt_sys_sched_getaffinity(pid_t pid, unsigned int len,
 	if (len < real_len)
 		return -EINVAL;
 
-	lock_cpu_hotplug();
+	get_online_cpus();
 	read_lock(&tasklist_lock);
 
 	retval = -ESRCH;
@@ -140,7 +140,7 @@ asmlinkage long mipsmt_sys_sched_getaffinity(pid_t pid, unsigned int len,
 
 out_unlock:
 	read_unlock(&tasklist_lock);
-	unlock_cpu_hotplug();
+	put_online_cpus();
 	if (retval)
 		return retval;
 	if (copy_to_user(user_mask_ptr, &mask, real_len))
diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index fc48b96..67b8016 100644
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -151,7 +151,7 @@ static int pseries_add_processor(struct device_node *np)
 	for (i = 0; i < nthreads; i++)
 		cpu_set(i, tmp);
 
-	lock_cpu_hotplug();
+	cpu_maps_update_begin();
 
 	BUG_ON(!cpus_subset(cpu_present_map, cpu_possible_map));
 
@@ -188,7 +188,7 @@ static int pseries_add_processor(struct device_node *np)
 	}
 	err = 0;
 out_unlock:
-	unlock_cpu_hotplug();
+	cpu_maps_update_done();
 	return err;
 }
 
@@ -209,7 +209,7 @@ static void pseries_remove_processor(struct device_node *np)
 
 	nthreads = len / sizeof(u32);
 
-	lock_cpu_hotplug();
+	cpu_maps_update_begin();
 	for (i = 0; i < nthreads; i++) {
 		for_each_present_cpu(cpu) {
 			if (get_hard_smp_processor_id(cpu) != intserv[i])
@@ -223,7 +223,7 @@ static void pseries_remove_processor(struct device_node *np)
 			printk(KERN_WARNING "Could not find cpu to remove "
 			       "with physical id 0x%x\n", intserv[i]);
 	}
-	unlock_cpu_hotplug();
+	cpu_maps_update_done();
 }
 
 static int pseries_smp_notifier(struct notifier_block *nb,
diff --git a/arch/powerpc/platforms/pseries/rtasd.c b/arch/powerpc/platforms/pseries/rtasd.c
index 73401c8..e3078ce 100644
--- a/arch/powerpc/platforms/pseries/rtasd.c
+++ b/arch/powerpc/platforms/pseries/rtasd.c
@@ -382,7 +382,7 @@ static void do_event_scan_all_cpus(long delay)
 {
 	int cpu;
 
-	lock_cpu_hotplug();
+	get_online_cpus();
 	cpu = first_cpu(cpu_online_map);
 	for (;;) {
 		set_cpus_allowed(current, cpumask_of_cpu(cpu));
@@ -390,15 +390,15 @@ static void do_event_scan_all_cpus(long delay)
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
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 9abbdf7..6aa0fbc 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -351,7 +351,7 @@ int mtrr_add_page(unsigned long base, unsigned long size,
 	replace = -1;
 
 	/* No CPU hotplug when we change MTRR entries */
-	lock_cpu_hotplug();
+	get_online_cpus();
 	/*  Search for existing MTRR  */
 	mutex_lock(&mtrr_mutex);
 	for (i = 0; i < num_var_ranges; ++i) {
@@ -407,7 +407,7 @@ int mtrr_add_page(unsigned long base, unsigned long size,
 	error = i;
  out:
 	mutex_unlock(&mtrr_mutex);
-	unlock_cpu_hotplug();
+	put_online_cpus();
 	return error;
 }
 
@@ -497,7 +497,7 @@ int mtrr_del_page(int reg, unsigned long base, unsigned long size)
 
 	max = num_var_ranges;
 	/* No CPU hotplug when we change MTRR entries */
-	lock_cpu_hotplug();
+	get_online_cpus();
 	mutex_lock(&mtrr_mutex);
 	if (reg < 0) {
 		/*  Search for existing MTRR  */
@@ -538,7 +538,7 @@ int mtrr_del_page(int reg, unsigned long base, unsigned long size)
 	error = reg;
  out:
 	mutex_unlock(&mtrr_mutex);
-	unlock_cpu_hotplug();
+	put_online_cpus();
 	return error;
 }
 /**
diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
index 09c3152..40cfd54 100644
--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -436,7 +436,7 @@ static ssize_t microcode_write (struct file *file, const char __user *buf, size_
 		return -EINVAL;
 	}
 
-	lock_cpu_hotplug();
+	get_online_cpus();
 	mutex_lock(&microcode_mutex);
 
 	user_buffer = (void __user *) buf;
@@ -447,7 +447,7 @@ static ssize_t microcode_write (struct file *file, const char __user *buf, size_
 		ret = (ssize_t)len;
 
 	mutex_unlock(&microcode_mutex);
-	unlock_cpu_hotplug();
+	put_online_cpus();
 
 	return ret;
 }
@@ -658,14 +658,14 @@ static ssize_t reload_store(struct sys_device *dev, const char *buf, size_t sz)
 
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
diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index 482aec2..96d0fd0 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -459,7 +459,7 @@ void __init lguest_arch_host_init(void)
 
 	/* We don't need the complexity of CPUs coming and going while we're
 	 * doing this. */
-	lock_cpu_hotplug();
+	get_online_cpus();
 	if (cpu_has_pge) { /* We have a broader idea of "global". */
 		/* Remember that this was originally set (for cleanup). */
 		cpu_had_pge = 1;
@@ -469,20 +469,20 @@ void __init lguest_arch_host_init(void)
 		/* Turn off the feature in the global feature set. */
 		clear_bit(X86_FEATURE_PGE, boot_cpu_data.x86_capability);
 	}
-	unlock_cpu_hotplug();
+	put_online_cpus();
 };
 /*:*/
 
 void __exit lguest_arch_host_fini(void)
 {
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
 
 
diff --git a/drivers/s390/char/sclp_config.c b/drivers/s390/char/sclp_config.c
index 5322e5e..9dc77f1 100644
--- a/drivers/s390/char/sclp_config.c
+++ b/drivers/s390/char/sclp_config.c
@@ -29,12 +29,12 @@ static void sclp_cpu_capability_notify(struct work_struct *work)
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
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index d1676dd..9b80c1a 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -100,8 +100,8 @@ static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
 	mutex_unlock(cpu_hp_mutex);
 }
 
-extern void lock_cpu_hotplug(void);
-extern void unlock_cpu_hotplug(void);
+extern void get_online_cpus(void);
+extern void put_online_cpus(void);
 #define hotcpu_notifier(fn, pri) {				\
 	static struct notifier_block fn##_nb =			\
 		{ .notifier_call = fn, .priority = pri };	\
@@ -119,8 +119,8 @@ static inline void cpuhotplug_mutex_lock(struct mutex *cpu_hp_mutex)
 static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
 { }
 
-#define lock_cpu_hotplug()	do { } while (0)
-#define unlock_cpu_hotplug()	do { } while (0)
+#define get_online_cpus()	do { } while (0)
+#define put_online_cpus()	do { } while (0)
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
 /* These aren't inline functions due to a GCC bug. */
 #define register_hotcpu_notifier(nb)	({ (void)(nb); 0; })
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 656dc3f..b0c4152 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -48,7 +48,7 @@ void __init cpu_hotplug_init(void)
 
 #ifdef CONFIG_HOTPLUG_CPU
 
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
 
@@ -110,7 +110,7 @@ void cpu_maps_update_done(void)
  *   non zero and goes to sleep again.
  *
  * However, this is very difficult to achieve in practice since
- * lock_cpu_hotplug() not an api which is called all that often.
+ * get_online_cpus() not an api which is called all that often.
  *
  */
 static void cpu_hotplug_begin(void)
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 50f5dc4..cfaf641 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -537,10 +537,10 @@ static int cpusets_overlap(struct cpuset *a, struct cpuset *b)
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
@@ -691,9 +691,9 @@ restart:
 
 rebuild:
 	/* Have scheduler rebuild sched domains */
-	lock_cpu_hotplug();
+	get_online_cpus();
 	partition_sched_domains(ndoms, doms);
-	unlock_cpu_hotplug();
+	put_online_cpus();
 
 done:
 	if (q && !IS_ERR(q))
@@ -1617,10 +1617,10 @@ static struct cgroup_subsys_state *cpuset_create(
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
 
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index c3e165c..fd59982 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -726,11 +726,11 @@ static void rcu_torture_shuffle_tasks(void)
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
 
@@ -762,7 +762,7 @@ static void rcu_torture_shuffle_tasks(void)
 	else
 		rcu_idle_cpu--;
 
-	unlock_cpu_hotplug();
+	put_online_cpus();
 }
 
 /* Shuffle tasks across CPUs, with the intent of allowing each CPU in the
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 319821e..51b5ee5 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -203,13 +203,13 @@ int stop_machine_run(int (*fn)(void *), void *data, unsigned int cpu)
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
diff --git a/net/core/flow.c b/net/core/flow.c
index 3ed2b4b..6489f4e 100644
--- a/net/core/flow.c
+++ b/net/core/flow.c
@@ -293,7 +293,7 @@ void flow_cache_flush(void)
 	static DEFINE_MUTEX(flow_flush_sem);
 
 	/* Don't want cpus going down or up during this. */
-	lock_cpu_hotplug();
+	get_online_cpus();
 	mutex_lock(&flow_flush_sem);
 	atomic_set(&info.cpuleft, num_online_cpus());
 	init_completion(&info.completion);
@@ -305,7 +305,7 @@ void flow_cache_flush(void)
 
 	wait_for_completion(&info.completion);
 	mutex_unlock(&flow_flush_sem);
-	unlock_cpu_hotplug();
+	put_online_cpus();
 }
 
 static void __devinit flow_cache_cpu_prepare(int cpu)
-- 
1.5.2.5

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
