Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999AbXDUVPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbXDUVPq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 17:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbXDUVPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 17:15:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54301 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999AbXDUVPm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 17:15:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 1/2] Add suspend-related notifications for CPU hotplug
Date: Sat, 21 Apr 2007 23:17:55 +0200
User-Agent: KMail/1.9.5
Cc: Gautham R Shenoy <ego@in.ibm.com>, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>
References: <200704212316.39381.rjw@sisk.pl>
In-Reply-To: <200704212316.39381.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704212317.56590.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Since nonboot CPUs are now disabled after tasks and devices have been frozen
and the CPU hotplug infrastructure is used for this purpose, we need special
CPU hotplug notifications that will help the CPU-hotplug-aware subsystems
distinguish normal CPU hotplug events from CPU hotplug events related to a
system-wide suspend or resume operation in progress.  This patch introduces
such notifications and causes them to be used during suspend and resume
transitions.  It also changes all of the CPU-hotplug-aware subsystems to take
these notifications into consideration (for now they are handled in the same
way as the corresponding "normal" ones).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/cpu-hotplug.txt             |    9 ++++++-
 arch/i386/kernel/cpu/intel_cacheinfo.c    |    2 +
 arch/i386/kernel/cpu/mcheck/therm_throt.c |    2 +
 arch/i386/kernel/cpuid.c                  |    2 +
 arch/i386/kernel/microcode.c              |    3 ++
 arch/i386/kernel/msr.c                    |    2 +
 arch/ia64/kernel/err_inject.c             |    2 +
 arch/ia64/kernel/palinfo.c                |    2 +
 arch/ia64/kernel/salinfo.c                |    2 +
 arch/ia64/kernel/topology.c               |    2 +
 arch/powerpc/kernel/sysfs.c               |    2 +
 arch/powerpc/mm/numa.c                    |    3 ++
 arch/s390/appldata/appldata_base.c        |    2 +
 arch/s390/kernel/smp.c                    |    2 +
 arch/x86_64/kernel/mce.c                  |    2 +
 arch/x86_64/kernel/mce_amd.c              |    2 +
 arch/x86_64/kernel/vsyscall.c             |    2 -
 block/ll_rw_blk.c                         |    2 -
 drivers/base/topology.c                   |    3 ++
 drivers/cpufreq/cpufreq.c                 |    3 ++
 drivers/cpufreq/cpufreq_stats.c           |    2 +
 drivers/cpuidle/cpuidle.c                 |    4 +++
 drivers/hwmon/coretemp.c                  |    2 +
 drivers/infiniband/hw/ehca/ehca_irq.c     |    6 +++++
 drivers/kvm/kvm_main.c                    |    3 ++
 fs/buffer.c                               |    2 -
 fs/xfs/xfs_mount.c                        |    3 ++
 include/linux/notifier.h                  |   12 ++++++++++
 kernel/cpu.c                              |   34 +++++++++++++++---------------
 kernel/hrtimer.c                          |    2 +
 kernel/profile.c                          |    4 +++
 kernel/rcupdate.c                         |    2 +
 kernel/relay.c                            |    2 +
 kernel/sched.c                            |   10 ++++++++
 kernel/softirq.c                          |    4 +++
 kernel/softlockup.c                       |    4 +++
 kernel/timer.c                            |    2 +
 kernel/workqueue.c                        |    5 ++++
 lib/radix-tree.c                          |    2 -
 lib/statistic.c                           |    3 ++
 mm/page_alloc.c                           |    5 +++-
 mm/slab.c                                 |    6 +++++
 mm/slub.c                                 |    2 +
 mm/swap.c                                 |    2 -
 mm/vmscan.c                               |    2 -
 mm/vmstat.c                               |    3 ++
 net/core/dev.c                            |    2 -
 net/core/flow.c                           |    2 -
 net/iucv/iucv.c                           |    6 +++++
 49 files changed, 162 insertions(+), 27 deletions(-)

Index: linux-2.6.21-rc6-mm1/include/linux/notifier.h
===================================================================
--- linux-2.6.21-rc6-mm1.orig/include/linux/notifier.h	2007-04-09 15:24:25.000000000 +0200
+++ linux-2.6.21-rc6-mm1/include/linux/notifier.h	2007-04-17 22:53:57.000000000 +0200
@@ -197,5 +197,17 @@ extern int __srcu_notifier_call_chain(st
 #define CPU_LOCK_ACQUIRE	0x0008 /* Acquire all hotcpu locks */
 #define CPU_LOCK_RELEASE	0x0009 /* Release all hotcpu locks */
 
+/* Used for CPU hotplug events occuring while tasks are frozen due to a suspend
+ * operation in progress
+ */
+#define CPU_TASKS_FROZEN	0x0010
+
+#define CPU_ONLINE_FROZEN	(CPU_ONLINE | CPU_TASKS_FROZEN)
+#define CPU_UP_PREPARE_FROZEN	(CPU_UP_PREPARE | CPU_TASKS_FROZEN)
+#define CPU_UP_CANCELED_FROZEN	(CPU_UP_CANCELED | CPU_TASKS_FROZEN)
+#define CPU_DOWN_PREPARE_FROZEN	(CPU_DOWN_PREPARE | CPU_TASKS_FROZEN)
+#define CPU_DOWN_FAILED_FROZEN	(CPU_DOWN_FAILED | CPU_TASKS_FROZEN)
+#define CPU_DEAD_FROZEN		(CPU_DEAD | CPU_TASKS_FROZEN)
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
Index: linux-2.6.21-rc6-mm1/kernel/cpu.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/kernel/cpu.c	2007-04-09 15:24:25.000000000 +0200
+++ linux-2.6.21-rc6-mm1/kernel/cpu.c	2007-04-17 22:55:02.000000000 +0200
@@ -120,12 +120,13 @@ static int take_cpu_down(void *unused)
 }
 
 /* Requires cpu_add_remove_lock to be held */
-static int _cpu_down(unsigned int cpu)
+static int _cpu_down(unsigned int cpu, int tasks_frozen)
 {
 	int err, nr_calls = 0;
 	struct task_struct *p;
 	cpumask_t old_allowed, tmp;
 	void *hcpu = (void *)(long)cpu;
+	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 
 	if (num_online_cpus() == 1)
 		return -EBUSY;
@@ -134,11 +135,11 @@ static int _cpu_down(unsigned int cpu)
 		return -EINVAL;
 
 	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_ACQUIRE, hcpu);
-	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE,
+	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
 					hcpu, -1, &nr_calls);
 	if (err == NOTIFY_BAD) {
-		__raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED, hcpu,
-					  nr_calls, NULL);
+		__raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
+					  hcpu, nr_calls, NULL);
 		printk("%s: attempt to take down CPU %u failed\n",
 				__FUNCTION__, cpu);
 		err = -EINVAL;
@@ -157,7 +158,7 @@ static int _cpu_down(unsigned int cpu)
 
 	if (IS_ERR(p) || cpu_online(cpu)) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
-		if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED,
+		if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
 					    hcpu) == NOTIFY_BAD)
 			BUG();
 
@@ -180,7 +181,8 @@ static int _cpu_down(unsigned int cpu)
 	put_cpu();
 
 	/* CPU is completely dead: tell everyone.  Too late to complain. */
-	if (raw_notifier_call_chain(&cpu_chain, CPU_DEAD, hcpu) == NOTIFY_BAD)
+	if (raw_notifier_call_chain(&cpu_chain, CPU_DEAD | mod,
+				    hcpu) == NOTIFY_BAD)
 		BUG();
 
 	check_for_tasks(cpu);
@@ -190,8 +192,7 @@ out_thread:
 out_allowed:
 	set_cpus_allowed(current, old_allowed);
 out_release:
-	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_RELEASE,
-						(void *)(long)cpu);
+	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_RELEASE, hcpu);
 	return err;
 }
 
@@ -203,7 +204,7 @@ int cpu_down(unsigned int cpu)
 	if (cpu_hotplug_disabled)
 		err = -EBUSY;
 	else
-		err = _cpu_down(cpu);
+		err = _cpu_down(cpu, 0);
 
 	mutex_unlock(&cpu_add_remove_lock);
 	return err;
@@ -211,16 +212,17 @@ int cpu_down(unsigned int cpu)
 #endif /*CONFIG_HOTPLUG_CPU*/
 
 /* Requires cpu_add_remove_lock to be held */
-static int __cpuinit _cpu_up(unsigned int cpu)
+static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 {
 	int ret, nr_calls = 0;
 	void *hcpu = (void *)(long)cpu;
+	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 
 	if (cpu_online(cpu) || !cpu_present(cpu))
 		return -EINVAL;
 
 	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_ACQUIRE, hcpu);
-	ret = __raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE, hcpu,
+	ret = __raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE | mod, hcpu,
 							-1, &nr_calls);
 	if (ret == NOTIFY_BAD) {
 		printk("%s: attempt to bring up CPU %u failed\n",
@@ -238,12 +240,12 @@ static int __cpuinit _cpu_up(unsigned in
 	BUG_ON(!cpu_online(cpu));
 
 	/* Now call notifier in preparation. */
-	raw_notifier_call_chain(&cpu_chain, CPU_ONLINE, hcpu);
+	raw_notifier_call_chain(&cpu_chain, CPU_ONLINE | mod, hcpu);
 
 out_notify:
 	if (ret != 0)
 		__raw_notifier_call_chain(&cpu_chain,
-				CPU_UP_CANCELED, hcpu, nr_calls, NULL);
+				CPU_UP_CANCELED | mod, hcpu, nr_calls, NULL);
 	raw_notifier_call_chain(&cpu_chain, CPU_LOCK_RELEASE, hcpu);
 
 	return ret;
@@ -257,7 +259,7 @@ int __cpuinit cpu_up(unsigned int cpu)
 	if (cpu_hotplug_disabled)
 		err = -EBUSY;
 	else
-		err = _cpu_up(cpu);
+		err = _cpu_up(cpu, 0);
 
 	mutex_unlock(&cpu_add_remove_lock);
 	return err;
@@ -287,7 +289,7 @@ int disable_nonboot_cpus(void)
 	for_each_online_cpu(cpu) {
 		if (cpu == first_cpu)
 			continue;
-		error = _cpu_down(cpu);
+		error = _cpu_down(cpu, 1);
 		if (!error) {
 			cpu_set(cpu, frozen_cpus);
 			printk("CPU%d is down\n", cpu);
@@ -322,7 +324,7 @@ void enable_nonboot_cpus(void)
 	suspend_cpu_hotplug = 1;
 	printk("Enabling non-boot CPUs ...\n");
 	for_each_cpu_mask(cpu, frozen_cpus) {
-		error = _cpu_up(cpu);
+		error = _cpu_up(cpu, 1);
 		if (!error) {
 			printk("CPU%d is up\n", cpu);
 			continue;
Index: linux-2.6.21-rc6-mm1/arch/i386/kernel/cpu/intel_cacheinfo.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/arch/i386/kernel/cpu/intel_cacheinfo.c	2007-04-09 15:24:14.000000000 +0200
+++ linux-2.6.21-rc6-mm1/arch/i386/kernel/cpu/intel_cacheinfo.c	2007-04-17 22:35:02.000000000 +0200
@@ -768,9 +768,11 @@ static int __cpuinit cacheinfo_cpu_callb
 	sys_dev = get_cpu_sysdev(cpu);
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		cache_add_dev(sys_dev);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		cache_remove_dev(sys_dev);
 		break;
 	}
Index: linux-2.6.21-rc6-mm1/arch/i386/kernel/cpu/mcheck/therm_throt.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/arch/i386/kernel/cpu/mcheck/therm_throt.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.21-rc6-mm1/arch/i386/kernel/cpu/mcheck/therm_throt.c	2007-04-17 22:35:02.000000000 +0200
@@ -137,10 +137,12 @@ static __cpuinit int thermal_throttle_cp
 	mutex_lock(&therm_cpu_lock);
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		err = thermal_throttle_add_dev(sys_dev);
 		WARN_ON(err);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		thermal_throttle_remove_dev(sys_dev);
 		break;
 	}
Index: linux-2.6.21-rc6-mm1/arch/i386/kernel/cpuid.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/arch/i386/kernel/cpuid.c	2007-04-09 15:23:33.000000000 +0200
+++ linux-2.6.21-rc6-mm1/arch/i386/kernel/cpuid.c	2007-04-17 22:35:02.000000000 +0200
@@ -169,9 +169,11 @@ static int cpuid_class_cpu_callback(stru
 
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		cpuid_device_create(cpu);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		device_destroy(cpuid_class, MKDEV(CPUID_MAJOR, cpu));
 		break;
 	}
Index: linux-2.6.21-rc6-mm1/arch/i386/kernel/microcode.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/arch/i386/kernel/microcode.c	2007-04-09 15:23:33.000000000 +0200
+++ linux-2.6.21-rc6-mm1/arch/i386/kernel/microcode.c	2007-04-17 22:35:02.000000000 +0200
@@ -775,10 +775,13 @@ mc_cpu_callback(struct notifier_block *n
 	sys_dev = get_cpu_sysdev(cpu);
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
 		mc_sysdev_add(sys_dev);
 		break;
 	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
 		mc_sysdev_remove(sys_dev);
 		break;
 	}
Index: linux-2.6.21-rc6-mm1/arch/i386/kernel/msr.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/arch/i386/kernel/msr.c	2007-04-09 15:23:33.000000000 +0200
+++ linux-2.6.21-rc6-mm1/arch/i386/kernel/msr.c	2007-04-17 22:35:02.000000000 +0200
@@ -251,9 +251,11 @@ static int msr_class_cpu_callback(struct
 
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		msr_device_create(cpu);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		device_destroy(msr_class, MKDEV(MSR_MAJOR, cpu));
 		break;
 	}
Index: linux-2.6.21-rc6-mm1/arch/ia64/kernel/palinfo.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/arch/ia64/kernel/palinfo.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.21-rc6-mm1/arch/ia64/kernel/palinfo.c	2007-04-17 22:35:02.000000000 +0200
@@ -975,9 +975,11 @@ static int palinfo_cpu_callback(struct n
 
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		create_palinfo_proc_entries(hotcpu);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		remove_palinfo_proc_entries(hotcpu);
 		break;
 	}
Index: linux-2.6.21-rc6-mm1/arch/ia64/kernel/salinfo.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/arch/ia64/kernel/salinfo.c	2007-04-09 15:24:14.000000000 +0200
+++ linux-2.6.21-rc6-mm1/arch/ia64/kernel/salinfo.c	2007-04-17 22:35:02.000000000 +0200
@@ -582,6 +582,7 @@ salinfo_cpu_callback(struct notifier_blo
 	struct salinfo_data *data;
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		spin_lock_irqsave(&data_saved_lock, flags);
 		for (i = 0, data = salinfo_data;
 		     i < ARRAY_SIZE(salinfo_data);
@@ -592,6 +593,7 @@ salinfo_cpu_callback(struct notifier_blo
 		spin_unlock_irqrestore(&data_saved_lock, flags);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		spin_lock_irqsave(&data_saved_lock, flags);
 		for (i = 0, data = salinfo_data;
 		     i < ARRAY_SIZE(salinfo_data);
Index: linux-2.6.21-rc6-mm1/arch/ia64/kernel/topology.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/arch/ia64/kernel/topology.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.21-rc6-mm1/arch/ia64/kernel/topology.c	2007-04-17 22:35:02.000000000 +0200
@@ -412,9 +412,11 @@ static int __cpuinit cache_cpu_callback(
 	sys_dev = get_cpu_sysdev(cpu);
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		cache_add_dev(sys_dev);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		cache_remove_dev(sys_dev);
 		break;
 	}
Index: linux-2.6.21-rc6-mm1/arch/powerpc/kernel/sysfs.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/arch/powerpc/kernel/sysfs.c	2007-04-09 15:23:33.000000000 +0200
+++ linux-2.6.21-rc6-mm1/arch/powerpc/kernel/sysfs.c	2007-04-17 22:35:02.000000000 +0200
@@ -341,10 +341,12 @@ static int __cpuinit sysfs_cpu_notify(st
 
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		register_cpu_online(cpu);
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		unregister_cpu_online(cpu);
 		break;
 #endif
Index: linux-2.6.21-rc6-mm1/arch/powerpc/mm/numa.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/arch/powerpc/mm/numa.c	2007-04-09 15:23:33.000000000 +0200
+++ linux-2.6.21-rc6-mm1/arch/powerpc/mm/numa.c	2007-04-17 22:35:02.000000000 +0200
@@ -252,12 +252,15 @@ static int __cpuinit cpu_numa_callback(s
 
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		numa_setup_cpu(lcpu);
 		ret = NOTIFY_OK;
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 		unmap_cpu_from_node(lcpu);
 		break;
 		ret = NOTIFY_OK;
Index: linux-2.6.21-rc6-mm1/arch/s390/appldata/appldata_base.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/arch/s390/appldata/appldata_base.c	2007-04-09 15:23:34.000000000 +0200
+++ linux-2.6.21-rc6-mm1/arch/s390/appldata/appldata_base.c	2007-04-17 22:35:02.000000000 +0200
@@ -567,9 +567,11 @@ appldata_cpu_notify(struct notifier_bloc
 {
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		appldata_online_cpu((long) hcpu);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		appldata_offline_cpu((long) hcpu);
 		break;
 	default:
Index: linux-2.6.21-rc6-mm1/arch/x86_64/kernel/mce.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/arch/x86_64/kernel/mce.c	2007-04-09 15:24:16.000000000 +0200
+++ linux-2.6.21-rc6-mm1/arch/x86_64/kernel/mce.c	2007-04-17 22:35:02.000000000 +0200
@@ -704,9 +704,11 @@ mce_cpu_callback(struct notifier_block *
 
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		mce_create_device(cpu);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		mce_remove_device(cpu);
 		break;
 	}
Index: linux-2.6.21-rc6-mm1/arch/x86_64/kernel/mce_amd.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/arch/x86_64/kernel/mce_amd.c	2007-04-09 15:23:34.000000000 +0200
+++ linux-2.6.21-rc6-mm1/arch/x86_64/kernel/mce_amd.c	2007-04-17 22:35:02.000000000 +0200
@@ -654,9 +654,11 @@ static int threshold_cpu_callback(struct
 
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		threshold_create_device(cpu);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		threshold_remove_device(cpu);
 		break;
 	default:
Index: linux-2.6.21-rc6-mm1/arch/x86_64/kernel/vsyscall.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/arch/x86_64/kernel/vsyscall.c	2007-04-09 15:24:16.000000000 +0200
+++ linux-2.6.21-rc6-mm1/arch/x86_64/kernel/vsyscall.c	2007-04-17 22:35:02.000000000 +0200
@@ -327,7 +327,7 @@ static int __cpuinit
 cpu_vsyscall_notifier(struct notifier_block *n, unsigned long action, void *arg)
 {
 	long cpu = (long)arg;
-	if (action == CPU_ONLINE)
+	if (action == CPU_ONLINE || action == CPU_ONLINE_FROZEN)
 		smp_call_function_single(cpu, cpu_vsyscall_init, NULL, 0, 1);
 	return NOTIFY_DONE;
 }
Index: linux-2.6.21-rc6-mm1/block/ll_rw_blk.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/block/ll_rw_blk.c	2007-04-09 15:24:16.000000000 +0200
+++ linux-2.6.21-rc6-mm1/block/ll_rw_blk.c	2007-04-17 22:35:02.000000000 +0200
@@ -3557,7 +3557,7 @@ static int blk_cpu_notify(struct notifie
 	 * If a CPU goes away, splice its entries to the current CPU
 	 * and trigger a run of the softirq
 	 */
-	if (action == CPU_DEAD) {
+	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
 		int cpu = (unsigned long) hcpu;
 
 		local_irq_disable();
Index: linux-2.6.21-rc6-mm1/drivers/base/topology.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/drivers/base/topology.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.21-rc6-mm1/drivers/base/topology.c	2007-04-17 22:35:02.000000000 +0200
@@ -126,10 +126,13 @@ static int __cpuinit topology_cpu_callba
 
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		rc = topology_add_dev(cpu);
 		break;
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		topology_remove_dev(cpu);
 		break;
 	}
Index: linux-2.6.21-rc6-mm1/drivers/cpufreq/cpufreq.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/drivers/cpufreq/cpufreq.c	2007-04-09 15:24:17.000000000 +0200
+++ linux-2.6.21-rc6-mm1/drivers/cpufreq/cpufreq.c	2007-04-17 22:35:02.000000000 +0200
@@ -1720,9 +1720,11 @@ static int cpufreq_cpu_callback(struct n
 	if (sys_dev) {
 		switch (action) {
 		case CPU_ONLINE:
+		case CPU_ONLINE_FROZEN:
 			cpufreq_add_dev(sys_dev);
 			break;
 		case CPU_DOWN_PREPARE:
+		case CPU_DOWN_PREPARE_FROZEN:
 			if (unlikely(lock_policy_rwsem_write(cpu)))
 				BUG();
 
@@ -1734,6 +1736,7 @@ static int cpufreq_cpu_callback(struct n
 			__cpufreq_remove_dev(sys_dev);
 			break;
 		case CPU_DOWN_FAILED:
+		case CPU_DOWN_FAILED_FROZEN:
 			cpufreq_add_dev(sys_dev);
 			break;
 		}
Index: linux-2.6.21-rc6-mm1/drivers/cpufreq/cpufreq_stats.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/drivers/cpufreq/cpufreq_stats.c	2007-04-09 15:24:17.000000000 +0200
+++ linux-2.6.21-rc6-mm1/drivers/cpufreq/cpufreq_stats.c	2007-04-17 22:35:02.000000000 +0200
@@ -318,9 +318,11 @@ static int cpufreq_stat_cpu_callback(str
 
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		cpufreq_update_policy(cpu);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		cpufreq_stats_free_table(cpu);
 		break;
 	}
Index: linux-2.6.21-rc6-mm1/drivers/infiniband/hw/ehca/ehca_irq.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/drivers/infiniband/hw/ehca/ehca_irq.c	2007-04-09 15:23:35.000000000 +0200
+++ linux-2.6.21-rc6-mm1/drivers/infiniband/hw/ehca/ehca_irq.c	2007-04-17 22:35:02.000000000 +0200
@@ -745,6 +745,7 @@ static int comp_pool_callback(struct not
 
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		ehca_gen_dbg("CPU: %x (CPU_PREPARE)", cpu);
 		if(!create_comp_task(pool, cpu)) {
 			ehca_gen_err("Can't create comp_task for cpu: %x", cpu);
@@ -752,24 +753,29 @@ static int comp_pool_callback(struct not
 		}
 		break;
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 		ehca_gen_dbg("CPU: %x (CPU_CANCELED)", cpu);
 		cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
 		kthread_bind(cct->task, any_online_cpu(cpu_online_map));
 		destroy_comp_task(pool, cpu);
 		break;
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		ehca_gen_dbg("CPU: %x (CPU_ONLINE)", cpu);
 		cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
 		kthread_bind(cct->task, cpu);
 		wake_up_process(cct->task);
 		break;
 	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
 		ehca_gen_dbg("CPU: %x (CPU_DOWN_PREPARE)", cpu);
 		break;
 	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
 		ehca_gen_dbg("CPU: %x (CPU_DOWN_FAILED)", cpu);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		ehca_gen_dbg("CPU: %x (CPU_DEAD)", cpu);
 		destroy_comp_task(pool, cpu);
 		take_over_work(pool, cpu);
Index: linux-2.6.21-rc6-mm1/drivers/kvm/kvm_main.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/drivers/kvm/kvm_main.c	2007-04-09 15:24:17.000000000 +0200
+++ linux-2.6.21-rc6-mm1/drivers/kvm/kvm_main.c	2007-04-17 22:35:02.000000000 +0200
@@ -2894,7 +2894,9 @@ static int kvm_cpu_hotplug(struct notifi
 
 	switch (val) {
 	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
 		       cpu);
 		decache_vcpus_on_cpu(cpu);
@@ -2902,6 +2904,7 @@ static int kvm_cpu_hotplug(struct notifi
 					 NULL, 0, 1);
 		break;
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
 		       cpu);
 		smp_call_function_single(cpu, kvm_arch_ops->hardware_enable,
Index: linux-2.6.21-rc6-mm1/fs/buffer.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/fs/buffer.c	2007-04-09 15:24:19.000000000 +0200
+++ linux-2.6.21-rc6-mm1/fs/buffer.c	2007-04-17 22:35:02.000000000 +0200
@@ -2996,7 +2996,7 @@ static void buffer_exit_cpu(int cpu)
 static int buffer_cpu_notify(struct notifier_block *self,
 			      unsigned long action, void *hcpu)
 {
-	if (action == CPU_DEAD)
+	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN)
 		buffer_exit_cpu((unsigned long)hcpu);
 	return NOTIFY_OK;
 }
Index: linux-2.6.21-rc6-mm1/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/fs/xfs/xfs_mount.c	2007-04-09 15:23:42.000000000 +0200
+++ linux-2.6.21-rc6-mm1/fs/xfs/xfs_mount.c	2007-04-17 22:35:02.000000000 +0200
@@ -1734,11 +1734,13 @@ xfs_icsb_cpu_notify(
 			per_cpu_ptr(mp->m_sb_cnts, (unsigned long)hcpu);
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		/* Easy Case - initialize the area and locks, and
 		 * then rebalance when online does everything else for us. */
 		memset(cntp, 0, sizeof(xfs_icsb_cnts_t));
 		break;
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		xfs_icsb_lock(mp);
 		xfs_icsb_balance_counter(mp, XFS_SBS_ICOUNT, 0, 0);
 		xfs_icsb_balance_counter(mp, XFS_SBS_IFREE, 0, 0);
@@ -1746,6 +1748,7 @@ xfs_icsb_cpu_notify(
 		xfs_icsb_unlock(mp);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		/* Disable all the counters, then fold the dead cpu's
 		 * count into the total on the global superblock and
 		 * re-enable the counters. */
Index: linux-2.6.21-rc6-mm1/kernel/hrtimer.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/kernel/hrtimer.c	2007-04-09 15:24:25.000000000 +0200
+++ linux-2.6.21-rc6-mm1/kernel/hrtimer.c	2007-04-17 22:35:02.000000000 +0200
@@ -1408,11 +1408,13 @@ static int __cpuinit hrtimer_cpu_notify(
 	switch (action) {
 
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		init_hrtimers_cpu(cpu);
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD, &cpu);
 		migrate_hrtimers(cpu);
 		break;
Index: linux-2.6.21-rc6-mm1/kernel/profile.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/kernel/profile.c	2007-04-09 15:23:48.000000000 +0200
+++ linux-2.6.21-rc6-mm1/kernel/profile.c	2007-04-17 22:35:02.000000000 +0200
@@ -340,6 +340,7 @@ static int __devinit profile_cpu_callbac
 
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		node = cpu_to_node(cpu);
 		per_cpu(cpu_profile_flip, cpu) = 0;
 		if (!per_cpu(cpu_profile_hits, cpu)[1]) {
@@ -365,10 +366,13 @@ static int __devinit profile_cpu_callbac
 		__free_page(page);
 		return NOTIFY_BAD;
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		cpu_set(cpu, prof_cpu_mask);
 		break;
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		cpu_clear(cpu, prof_cpu_mask);
 		if (per_cpu(cpu_profile_hits, cpu)[0]) {
 			page = virt_to_page(per_cpu(cpu_profile_hits, cpu)[0]);
Index: linux-2.6.21-rc6-mm1/kernel/rcupdate.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/kernel/rcupdate.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.21-rc6-mm1/kernel/rcupdate.c	2007-04-17 22:35:02.000000000 +0200
@@ -558,9 +558,11 @@ static int __cpuinit rcu_cpu_notify(stru
 	long cpu = (long)hcpu;
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		rcu_online_cpu(cpu);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		rcu_offline_cpu(cpu);
 		break;
 	default:
Index: linux-2.6.21-rc6-mm1/kernel/relay.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/kernel/relay.c	2007-04-09 15:24:25.000000000 +0200
+++ linux-2.6.21-rc6-mm1/kernel/relay.c	2007-04-17 22:35:02.000000000 +0200
@@ -490,6 +490,7 @@ static int __cpuinit relay_hotcpu_callba
 
 	switch(action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		mutex_lock(&relay_channels_mutex);
 		list_for_each_entry(chan, &relay_channels, list) {
 			if (chan->buf[hotcpu])
@@ -506,6 +507,7 @@ static int __cpuinit relay_hotcpu_callba
 		mutex_unlock(&relay_channels_mutex);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		/* No need to flush the cpu : will be flushed upon
 		 * final relay_flush() call. */
 		break;
Index: linux-2.6.21-rc6-mm1/kernel/sched.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/kernel/sched.c	2007-04-09 15:24:25.000000000 +0200
+++ linux-2.6.21-rc6-mm1/kernel/sched.c	2007-04-17 22:56:09.000000000 +0200
@@ -5427,6 +5427,7 @@ migration_call(struct notifier_block *nf
 		break;
 
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		p = kthread_create(migration_thread, hcpu, "migration/%d",cpu);
 		if (IS_ERR(p))
 			return NOTIFY_BAD;
@@ -5440,12 +5441,14 @@ migration_call(struct notifier_block *nf
 		break;
 
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		/* Strictly unneccessary, as first user will wake it. */
 		wake_up_process(cpu_rq(cpu)->migration_thread);
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 		if (!cpu_rq(cpu)->migration_thread)
 			break;
 		/* Unbind it from offline cpu so it can run.  Fall thru. */
@@ -5456,6 +5459,7 @@ migration_call(struct notifier_block *nf
 		break;
 
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		migrate_live_tasks(cpu);
 		rq = cpu_rq(cpu);
 		kthread_stop(rq->migration_thread);
@@ -6918,14 +6922,20 @@ static int update_sched_domains(struct n
 {
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
 		detach_destroy_domains(&cpu_online_map);
 		return NOTIFY_OK;
 
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		/*
 		 * Fall through and re-initialise the domains.
 		 */
Index: linux-2.6.21-rc6-mm1/kernel/softirq.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/kernel/softirq.c	2007-04-09 15:24:25.000000000 +0200
+++ linux-2.6.21-rc6-mm1/kernel/softirq.c	2007-04-17 22:35:02.000000000 +0200
@@ -595,6 +595,7 @@ static int __cpuinit cpu_callback(struct
 
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		p = kthread_create(ksoftirqd, hcpu, "ksoftirqd/%d", hotcpu);
 		if (IS_ERR(p)) {
 			printk("ksoftirqd for %i failed\n", hotcpu);
@@ -604,16 +605,19 @@ static int __cpuinit cpu_callback(struct
   		per_cpu(ksoftirqd, hotcpu) = p;
  		break;
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		wake_up_process(per_cpu(ksoftirqd, hotcpu));
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 		if (!per_cpu(ksoftirqd, hotcpu))
 			break;
 		/* Unbind so it can run.  Fall thru. */
 		kthread_bind(per_cpu(ksoftirqd, hotcpu),
 			     any_online_cpu(cpu_online_map));
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		p = per_cpu(ksoftirqd, hotcpu);
 		per_cpu(ksoftirqd, hotcpu) = NULL;
 		kthread_stop(p);
Index: linux-2.6.21-rc6-mm1/kernel/softlockup.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/kernel/softlockup.c	2007-04-09 15:24:25.000000000 +0200
+++ linux-2.6.21-rc6-mm1/kernel/softlockup.c	2007-04-17 22:35:02.000000000 +0200
@@ -148,6 +148,7 @@ cpu_callback(struct notifier_block *nfb,
 
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		BUG_ON(per_cpu(watchdog_task, hotcpu));
 		p = kthread_create(watchdog, hcpu, "watchdog/%d", hotcpu);
 		if (IS_ERR(p)) {
@@ -159,16 +160,19 @@ cpu_callback(struct notifier_block *nfb,
 		kthread_bind(p, hotcpu);
  		break;
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		wake_up_process(per_cpu(watchdog_task, hotcpu));
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 		if (!per_cpu(watchdog_task, hotcpu))
 			break;
 		/* Unbind so it can run.  Fall thru. */
 		kthread_bind(per_cpu(watchdog_task, hotcpu),
 			     any_online_cpu(cpu_online_map));
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		p = per_cpu(watchdog_task, hotcpu);
 		per_cpu(watchdog_task, hotcpu) = NULL;
 		kthread_stop(p);
Index: linux-2.6.21-rc6-mm1/kernel/timer.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/kernel/timer.c	2007-04-09 15:24:25.000000000 +0200
+++ linux-2.6.21-rc6-mm1/kernel/timer.c	2007-04-17 22:35:02.000000000 +0200
@@ -1291,11 +1291,13 @@ static int __cpuinit timer_cpu_notify(st
 	long cpu = (long)hcpu;
 	switch(action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		if (init_timers_cpu(cpu) < 0)
 			return NOTIFY_BAD;
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		migrate_timers(cpu);
 		break;
 #endif
Index: linux-2.6.21-rc6-mm1/lib/radix-tree.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/lib/radix-tree.c	2007-04-09 15:24:25.000000000 +0200
+++ linux-2.6.21-rc6-mm1/lib/radix-tree.c	2007-04-17 22:35:02.000000000 +0200
@@ -1100,7 +1100,7 @@ static int radix_tree_callback(struct no
        struct radix_tree_preload *rtp;
 
        /* Free per-cpu pool of perloaded nodes */
-       if (action == CPU_DEAD) {
+       if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
                rtp = &per_cpu(radix_tree_preloads, cpu);
                while (rtp->nr) {
                        kmem_cache_free(radix_tree_node_cachep,
Index: linux-2.6.21-rc6-mm1/mm/page_alloc.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/mm/page_alloc.c	2007-04-09 15:24:25.000000000 +0200
+++ linux-2.6.21-rc6-mm1/mm/page_alloc.c	2007-04-17 22:35:02.000000000 +0200
@@ -2647,11 +2647,14 @@ static int __cpuinit pageset_cpuup_callb
 
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		if (process_zones(cpu))
 			ret = NOTIFY_BAD;
 		break;
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		free_zone_pagesets(cpu);
 		break;
 	default:
@@ -3764,7 +3767,7 @@ static int page_alloc_cpu_notify(struct 
 {
 	int cpu = (unsigned long)hcpu;
 
-	if (action == CPU_DEAD) {
+	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
 		local_irq_disable();
 		__drain_pages(cpu);
 		vm_events_fold_cpu(cpu);
Index: linux-2.6.21-rc6-mm1/mm/swap.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/mm/swap.c	2007-04-09 15:24:25.000000000 +0200
+++ linux-2.6.21-rc6-mm1/mm/swap.c	2007-04-17 22:35:02.000000000 +0200
@@ -533,7 +533,7 @@ static int cpu_swap_callback(struct noti
 	long *committed;
 
 	committed = &per_cpu(committed_space, (long)hcpu);
-	if (action == CPU_DEAD) {
+	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
 		atomic_add(*committed, &vm_committed_space);
 		*committed = 0;
 		__lru_add_drain((long)hcpu);
Index: linux-2.6.21-rc6-mm1/mm/vmscan.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/mm/vmscan.c	2007-04-09 15:24:25.000000000 +0200
+++ linux-2.6.21-rc6-mm1/mm/vmscan.c	2007-04-17 22:35:02.000000000 +0200
@@ -1606,7 +1606,7 @@ static int __devinit cpu_callback(struct
 	pg_data_t *pgdat;
 	cpumask_t mask;
 
-	if (action == CPU_ONLINE) {
+	if (action == CPU_ONLINE || action == CPU_ONLINE_FROZEN) {
 		for_each_online_pgdat(pgdat) {
 			mask = node_to_cpumask(pgdat->node_id);
 			if (any_online_cpu(mask) != NR_CPUS)
Index: linux-2.6.21-rc6-mm1/mm/vmstat.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/mm/vmstat.c	2007-04-09 15:24:25.000000000 +0200
+++ linux-2.6.21-rc6-mm1/mm/vmstat.c	2007-04-17 22:35:02.000000000 +0200
@@ -650,8 +650,11 @@ static int __cpuinit vmstat_cpuup_callba
 {
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		refresh_zone_stat_thresholds();
 		break;
 	default:
Index: linux-2.6.21-rc6-mm1/net/core/dev.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/net/core/dev.c	2007-04-09 15:24:25.000000000 +0200
+++ linux-2.6.21-rc6-mm1/net/core/dev.c	2007-04-17 22:35:02.000000000 +0200
@@ -3462,7 +3462,7 @@ static int dev_cpu_callback(struct notif
 	unsigned int cpu, oldcpu = (unsigned long)ocpu;
 	struct softnet_data *sd, *oldsd;
 
-	if (action != CPU_DEAD)
+	if (action != CPU_DEAD && action != CPU_DEAD_FROZEN)
 		return NOTIFY_OK;
 
 	local_irq_disable();
Index: linux-2.6.21-rc6-mm1/net/core/flow.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/net/core/flow.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.21-rc6-mm1/net/core/flow.c	2007-04-17 22:35:02.000000000 +0200
@@ -338,7 +338,7 @@ static int flow_cache_cpu(struct notifie
 			  unsigned long action,
 			  void *hcpu)
 {
-	if (action == CPU_DEAD)
+	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN)
 		__flow_cache_shrink((unsigned long)hcpu, 0);
 	return NOTIFY_OK;
 }
Index: linux-2.6.21-rc6-mm1/net/iucv/iucv.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/net/iucv/iucv.c	2007-04-09 15:24:27.000000000 +0200
+++ linux-2.6.21-rc6-mm1/net/iucv/iucv.c	2007-04-17 22:35:02.000000000 +0200
@@ -527,6 +527,7 @@ static int __cpuinit iucv_cpu_notify(str
 
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		if (!percpu_populate(iucv_irq_data,
 				     sizeof(struct iucv_irq_data),
 				     GFP_KERNEL|GFP_DMA, cpu))
@@ -538,15 +539,20 @@ static int __cpuinit iucv_cpu_notify(str
 		}
 		break;
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		percpu_depopulate(iucv_param, cpu);
 		percpu_depopulate(iucv_irq_data, cpu);
 		break;
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
 		smp_call_function_on(iucv_declare_cpu, NULL, 0, 1, cpu);
 		break;
 	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
 		cpumask = iucv_buffer_cpumask;
 		cpu_clear(cpu, cpumask);
 		if (cpus_empty(cpumask))
Index: linux-2.6.21-rc6-mm1/Documentation/cpu-hotplug.txt
===================================================================
--- linux-2.6.21-rc6-mm1.orig/Documentation/cpu-hotplug.txt	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.21-rc6-mm1/Documentation/cpu-hotplug.txt	2007-04-17 22:35:02.000000000 +0200
@@ -217,14 +217,17 @@ Q: What happens when a CPU is being logi
 A: The following happen, listed in no particular order :-)
 
 - A notification is sent to in-kernel registered modules by sending an event
-  CPU_DOWN_PREPARE
+  CPU_DOWN_PREPARE or CPU_DOWN_PREPARE_FROZEN, depending on whether or not the
+  CPU is being offlined while tasks are frozen due to a suspend operation in
+  progress
 - All process is migrated away from this outgoing CPU to a new CPU
 - All interrupts targeted to this CPU is migrated to a new CPU
 - timers/bottom half/task lets are also migrated to a new CPU
 - Once all services are migrated, kernel calls an arch specific routine
   __cpu_disable() to perform arch specific cleanup.
 - Once this is successful, an event for successful cleanup is sent by an event
-  CPU_DEAD.
+  CPU_DEAD (or CPU_DEAD_FROZEN if tasks are frozen due to a suspend while the
+  CPU is being offlined).
 
   "It is expected that each service cleans up when the CPU_DOWN_PREPARE
   notifier is called, when CPU_DEAD is called its expected there is nothing
@@ -242,9 +245,11 @@ A: This is what you would need in your k
 
 		switch (action) {
 		case CPU_ONLINE:
+		case CPU_ONLINE_FROZEN:
 			foobar_online_action(cpu);
 			break;
 		case CPU_DEAD:
+		case CPU_DEAD_FROZEN:
 			foobar_dead_action(cpu);
 			break;
 		}
Index: linux-2.6.21-rc6-mm1/kernel/workqueue.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/kernel/workqueue.c	2007-04-09 15:24:25.000000000 +0200
+++ linux-2.6.21-rc6-mm1/kernel/workqueue.c	2007-04-17 22:55:37.000000000 +0200
@@ -770,6 +770,7 @@ static int __devinit workqueue_cpu_callb
 		return NOTIFY_OK;
 
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		cpu_set(cpu, cpu_populated_map);
 	}
 
@@ -778,19 +779,23 @@ static int __devinit workqueue_cpu_callb
 
 		switch (action) {
 		case CPU_UP_PREPARE:
+		case CPU_UP_PREPARE_FROZEN:
 			if (!create_workqueue_thread(cwq, cpu))
 				break;
 			printk(KERN_ERR "workqueue for %i failed\n", cpu);
 			return NOTIFY_BAD;
 
 		case CPU_ONLINE:
+		case CPU_ONLINE_FROZEN:
 			wake_up_process(cwq->thread);
 			break;
 
 		case CPU_UP_CANCELED:
+		case CPU_UP_CANCELED_FROZEN:
 			if (cwq->thread)
 				wake_up_process(cwq->thread);
 		case CPU_DEAD:
+		case CPU_DEAD_FROZEN:
 			cleanup_workqueue_thread(cwq, cpu);
 			break;
 		}
Index: linux-2.6.21-rc6-mm1/mm/slab.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/mm/slab.c	2007-04-09 15:24:25.000000000 +0200
+++ linux-2.6.21-rc6-mm1/mm/slab.c	2007-04-17 22:55:51.000000000 +0200
@@ -1187,6 +1187,7 @@ static int __cpuinit cpuup_callback(stru
 		mutex_lock(&cache_chain_mutex);
 		break;
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		/*
 		 * We need to do this right in the beginning since
 		 * alloc_arraycache's are going to use this list.
@@ -1273,10 +1274,12 @@ static int __cpuinit cpuup_callback(stru
 		}
 		break;
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		start_cpu_timer(cpu);
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
   	case CPU_DOWN_PREPARE:
+  	case CPU_DOWN_PREPARE_FROZEN:
 		/*
 		 * Shutdown cache reaper. Note that the cache_chain_mutex is
 		 * held so that if cache_reap() is invoked it cannot do
@@ -1288,9 +1291,11 @@ static int __cpuinit cpuup_callback(stru
 		per_cpu(reap_work, cpu).work.func = NULL;
   		break;
   	case CPU_DOWN_FAILED:
+  	case CPU_DOWN_FAILED_FROZEN:
 		start_cpu_timer(cpu);
   		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		/*
 		 * Even if all the cpus of a node are down, we don't free the
 		 * kmem_list3 of any cache. This to avoid a race between
@@ -1302,6 +1307,7 @@ static int __cpuinit cpuup_callback(stru
 		/* fall thru */
 #endif
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 		list_for_each_entry(cachep, &cache_chain, next) {
 			struct array_cache *nc;
 			struct array_cache *shared;
Index: linux-2.6.21-rc6-mm1/arch/ia64/kernel/err_inject.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/arch/ia64/kernel/err_inject.c	2007-04-09 15:24:14.000000000 +0200
+++ linux-2.6.21-rc6-mm1/arch/ia64/kernel/err_inject.c	2007-04-17 23:19:57.000000000 +0200
@@ -236,9 +236,11 @@ static int __cpuinit err_inject_cpu_call
 	sys_dev = get_cpu_sysdev(cpu);
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		err_inject_add_dev(sys_dev);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		err_inject_remove_dev(sys_dev);
 		break;
 	}
Index: linux-2.6.21-rc6-mm1/arch/s390/kernel/smp.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/arch/s390/kernel/smp.c	2007-04-09 15:24:14.000000000 +0200
+++ linux-2.6.21-rc6-mm1/arch/s390/kernel/smp.c	2007-04-17 23:22:24.000000000 +0200
@@ -841,10 +841,12 @@ static int __cpuinit smp_cpu_notify(stru
 
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		if (sysdev_create_file(s, &attr_capability))
 			return NOTIFY_BAD;
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		sysdev_remove_file(s, &attr_capability);
 		break;
 	}
Index: linux-2.6.21-rc6-mm1/drivers/cpuidle/cpuidle.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/drivers/cpuidle/cpuidle.c	2007-04-09 15:24:17.000000000 +0200
+++ linux-2.6.21-rc6-mm1/drivers/cpuidle/cpuidle.c	2007-04-17 23:26:35.000000000 +0200
@@ -210,16 +210,20 @@ static int cpuidle_cpu_callback(struct n
 
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		cpuidle_add_device(sys_dev);
 		break;
 	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
 		mutex_lock(&cpuidle_lock);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		__cpuidle_remove_device(sys_dev);
 		mutex_unlock(&cpuidle_lock);
 		break;
 	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
 		mutex_unlock(&cpuidle_lock);
 		break;
 	}
Index: linux-2.6.21-rc6-mm1/drivers/hwmon/coretemp.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/drivers/hwmon/coretemp.c	2007-04-09 15:24:17.000000000 +0200
+++ linux-2.6.21-rc6-mm1/drivers/hwmon/coretemp.c	2007-04-17 23:27:46.000000000 +0200
@@ -309,9 +309,11 @@ static int coretemp_cpu_callback(struct 
 
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		coretemp_device_add(cpu);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		coretemp_device_remove(cpu);
 		break;
 	}
Index: linux-2.6.21-rc6-mm1/lib/statistic.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/lib/statistic.c	2007-04-09 15:24:25.000000000 +0200
+++ linux-2.6.21-rc6-mm1/lib/statistic.c	2007-04-17 23:29:45.000000000 +0200
@@ -395,6 +395,7 @@ static int _statistic_hotcpu(struct stat
 		return NOTIFY_OK;
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		size = disc->size(stat);
 		dst = percpu_populate(stat->data, size, GFP_KERNEL, cpu);
 		if (!dst)
@@ -402,7 +403,9 @@ static int _statistic_hotcpu(struct stat
 		disc->reset(stat, dst);
 		break;
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		local_irq_save(flags);
 		dst = percpu_ptr(stat->data, smp_processor_id());
 		src = percpu_ptr(stat->data, cpu);
Index: linux-2.6.21-rc6-mm1/mm/slub.c
===================================================================
--- linux-2.6.21-rc6-mm1.orig/mm/slub.c	2007-04-09 15:24:25.000000000 +0200
+++ linux-2.6.21-rc6-mm1/mm/slub.c	2007-04-17 23:30:40.000000000 +0200
@@ -2128,7 +2128,9 @@ static int __cpuinit slab_cpuup_callback
 
 	switch (action) {
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		for_all_slabs(__flush_cpu_slab, cpu);
 		break;
 	default:

