Return-Path: <linux-kernel-owner+w=401wt.eu-S1030983AbXDPVYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030983AbXDPVYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 17:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030984AbXDPVYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 17:24:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58927 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030983AbXDPVY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 17:24:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Gautham Shenoy" <ego.lkml@gmail.com>
Subject: Re: [RFC][PATCH][EXPERIMENTAL] CPU hotplug with frozen tasks
Date: Mon, 16 Apr 2007 23:27:58 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Gautham R Shenoy" <ego@in.ibm.com>,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Oleg Nesterov" <oleg@tv-sign.ru>
References: <200704061732.32712.rjw@sisk.pl> <200704160027.58425.rjw@sisk.pl> <c03d1bd00704160250g158de0feqa0c7acd18673969f@mail.gmail.com>
In-Reply-To: <c03d1bd00704160250g158de0feqa0c7acd18673969f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704162327.59758.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 16 April 2007 11:50, Gautham Shenoy wrote:
> Hi Rafael,
> 
> On 4/15/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Hi,
> >
> > As I said before, we have a problem with using the CPU hotplug for suspending
> > because of the notifiers that are called from within cpu_up()/cpu_down() and
> > (sometimes) assume that the system is fully functional.
> >
> 
> Right. In order to use freezer for CPU hotplug, we need to perform
> that audit anyway.
> 
> > One obvious solution of this problem would be to make the notifiers behave
> > differently if tasks are frozen, but for this purpose we'd need to tell them
> > that this is the case.  In principle, we could do it in many different ways
> > (eg. by using a global variable, with the help of suspend notifiers etc.), but
> > IMO one of the cleanest methods woud be to use some special values for the
> > notifications occuring while tasks are frozen (eg. CPU_DEAD_FROZEN instead of
> > CPU_DEAD etc.).  In that case the notifiers could react in some special ways
> > to the "FROZEN" notfifications and that would allow us to simplify some code
> > paths (eg. in the microcode driver).
> >
> 
> Agreed.
> 
> > The appended patch introduces such "FROZEN" notfifications, modifies the CPU
> > hotplug core to use them and updates all of the users of CPU hotplug notifiers
> > to recognize them.  For now, they are treated in the same way as the
> > corresponding "normal" notifications, but I'm going to modify the microcode
> > driver to really use them and I believe that some other subsystems can benefit
> > from using them as well.
> >
> 
> Ok. A minor doubt.
> 
> When you say FROZEN, do you mean frozen due to suspend ?

Yes.

I have modified the patch to stress that in the documentation (and in the
comment in notifier.h).

> If yes, then it makes sense. Otherwise once cpu-hotplug starts using the freezer
> (hopefully it will someday soon :-)) won't this patch become redundant ?

Well, I'm not entirely sure.

> [Except of course fixing a few glitches 
> due to the assumption that the system is fully functional, when it's
> actually frozen.]
> 
> I am of the opinion that we should have notifications which help the
> cpu-hotplug aware
> subsystems differentiate between a normal cpu-hotplug  and a
> cpu-hotplug initiated by
> suspend. Thereby they can handle it accordingly and not destroy any
> percpu resources
> and reuse them instead during resume.

[Unless, of course, the CPU in question refuses to go online during the
resume.]

I agree.

Initially I thought the patch might cover some scenarios other than just the
suspend, but then I changed my mind.  For this reason I'm not sure if the
"_FROZEN" parts of the new constants names are exactly right, but I have
no better ideas anyway.

> Am I missing something?

No, I don't think so. :-)

Appended is the updated version of the patch (in addition to the changes
mentioned above I've eliminated the magic constant 0x0008 from cpu.c by
changing the new definitions in notifier.h).

Greetings,
Rafael

---
 Documentation/cpu-hotplug.txt             |    9 +++++++--
 arch/i386/kernel/cpu/intel_cacheinfo.c    |    2 ++
 arch/i386/kernel/cpu/mcheck/therm_throt.c |    2 ++
 arch/i386/kernel/cpuid.c                  |    2 ++
 arch/i386/kernel/microcode.c              |    3 +++
 arch/i386/kernel/msr.c                    |    2 ++
 arch/ia64/kernel/palinfo.c                |    2 ++
 arch/ia64/kernel/salinfo.c                |    2 ++
 arch/ia64/kernel/topology.c               |    2 ++
 arch/powerpc/kernel/sysfs.c               |    2 ++
 arch/powerpc/mm/numa.c                    |    3 +++
 arch/s390/appldata/appldata_base.c        |    2 ++
 arch/x86_64/kernel/mce.c                  |    2 ++
 arch/x86_64/kernel/mce_amd.c              |    2 ++
 arch/x86_64/kernel/vsyscall.c             |    2 +-
 block/ll_rw_blk.c                         |    2 +-
 drivers/base/topology.c                   |    3 +++
 drivers/cpufreq/cpufreq.c                 |    3 +++
 drivers/cpufreq/cpufreq_stats.c           |    2 ++
 drivers/infiniband/hw/ehca/ehca_irq.c     |    6 ++++++
 drivers/kvm/kvm_main.c                    |    3 +++
 fs/buffer.c                               |    2 +-
 fs/xfs/xfs_mount.c                        |    3 +++
 include/linux/notifier.h                  |   12 ++++++++++++
 kernel/cpu.c                              |   26 ++++++++++++++------------
 kernel/hrtimer.c                          |    2 ++
 kernel/profile.c                          |    4 ++++
 kernel/rcupdate.c                         |    2 ++
 kernel/relay.c                            |    2 ++
 kernel/sched.c                            |   10 ++++++++++
 kernel/softirq.c                          |    4 ++++
 kernel/softlockup.c                       |    4 ++++
 kernel/timer.c                            |    2 ++
 kernel/workqueue.c                        |    6 ++++++
 lib/radix-tree.c                          |    2 +-
 mm/page_alloc.c                           |    5 ++++-
 mm/slab.c                                 |    6 ++++++
 mm/swap.c                                 |    2 +-
 mm/vmscan.c                               |    2 +-
 mm/vmstat.c                               |    3 +++
 net/core/dev.c                            |    2 +-
 net/core/flow.c                           |    2 +-
 net/iucv/iucv.c                           |    6 ++++++
 43 files changed, 144 insertions(+), 23 deletions(-)

Index: linux-2.6.21-rc7/include/linux/notifier.h
===================================================================
--- linux-2.6.21-rc7.orig/include/linux/notifier.h	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/include/linux/notifier.h	2007-04-16 23:05:44.000000000 +0200
@@ -187,5 +187,17 @@ extern int srcu_notifier_call_chain(stru
 #define CPU_DOWN_FAILED		0x0006 /* CPU (unsigned)v NOT going down */
 #define CPU_DEAD		0x0007 /* CPU (unsigned)v dead */
 
+/* Used for CPU hotplug events occuring while tasks are frozen due to a suspend
+ * operation in progress
+ */
+#define CPU_TASKS_FROZEN	0x0008
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
Index: linux-2.6.21-rc7/kernel/cpu.c
===================================================================
--- linux-2.6.21-rc7.orig/kernel/cpu.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/kernel/cpu.c	2007-04-16 23:05:44.000000000 +0200
@@ -120,11 +120,12 @@ static int take_cpu_down(void *unused)
 }
 
 /* Requires cpu_add_remove_lock to be held */
-static int _cpu_down(unsigned int cpu)
+static int _cpu_down(unsigned int cpu, int tasks_frozen)
 {
 	int err;
 	struct task_struct *p;
 	cpumask_t old_allowed, tmp;
+	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 
 	if (num_online_cpus() == 1)
 		return -EBUSY;
@@ -132,7 +133,7 @@ static int _cpu_down(unsigned int cpu)
 	if (!cpu_online(cpu))
 		return -EINVAL;
 
-	err = raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE,
+	err = raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
 						(void *)(long)cpu);
 	if (err == NOTIFY_BAD) {
 		printk("%s: attempt to take down CPU %u failed\n",
@@ -152,7 +153,7 @@ static int _cpu_down(unsigned int cpu)
 
 	if (IS_ERR(p) || cpu_online(cpu)) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
-		if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED,
+		if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
 				(void *)(long)cpu) == NOTIFY_BAD)
 			BUG();
 
@@ -175,7 +176,7 @@ static int _cpu_down(unsigned int cpu)
 	put_cpu();
 
 	/* CPU is completely dead: tell everyone.  Too late to complain. */
-	if (raw_notifier_call_chain(&cpu_chain, CPU_DEAD,
+	if (raw_notifier_call_chain(&cpu_chain, CPU_DEAD | mod,
 			(void *)(long)cpu) == NOTIFY_BAD)
 		BUG();
 
@@ -196,7 +197,7 @@ int cpu_down(unsigned int cpu)
 	if (cpu_hotplug_disabled)
 		err = -EBUSY;
 	else
-		err = _cpu_down(cpu);
+		err = _cpu_down(cpu, 0);
 
 	mutex_unlock(&cpu_add_remove_lock);
 	return err;
@@ -204,15 +205,16 @@ int cpu_down(unsigned int cpu)
 #endif /*CONFIG_HOTPLUG_CPU*/
 
 /* Requires cpu_add_remove_lock to be held */
-static int __cpuinit _cpu_up(unsigned int cpu)
+static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 {
 	int ret;
 	void *hcpu = (void *)(long)cpu;
+	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 
 	if (cpu_online(cpu) || !cpu_present(cpu))
 		return -EINVAL;
 
-	ret = raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE, hcpu);
+	ret = raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE | mod, hcpu);
 	if (ret == NOTIFY_BAD) {
 		printk("%s: attempt to bring up CPU %u failed\n",
 				__FUNCTION__, cpu);
@@ -229,12 +231,12 @@ static int __cpuinit _cpu_up(unsigned in
 	BUG_ON(!cpu_online(cpu));
 
 	/* Now call notifier in preparation. */
-	raw_notifier_call_chain(&cpu_chain, CPU_ONLINE, hcpu);
+	raw_notifier_call_chain(&cpu_chain, CPU_ONLINE | mod, hcpu);
 
 out_notify:
 	if (ret != 0)
 		raw_notifier_call_chain(&cpu_chain,
-				CPU_UP_CANCELED, hcpu);
+				CPU_UP_CANCELED | mod, hcpu);
 
 	return ret;
 }
@@ -247,7 +249,7 @@ int __cpuinit cpu_up(unsigned int cpu)
 	if (cpu_hotplug_disabled)
 		err = -EBUSY;
 	else
-		err = _cpu_up(cpu);
+		err = _cpu_up(cpu, 0);
 
 	mutex_unlock(&cpu_add_remove_lock);
 	return err;
@@ -277,7 +279,7 @@ int disable_nonboot_cpus(void)
 	for_each_online_cpu(cpu) {
 		if (cpu == first_cpu)
 			continue;
-		error = _cpu_down(cpu);
+		error = _cpu_down(cpu, 1);
 		if (!error) {
 			cpu_set(cpu, frozen_cpus);
 			printk("CPU%d is down\n", cpu);
@@ -312,7 +314,7 @@ void enable_nonboot_cpus(void)
 	suspend_cpu_hotplug = 1;
 	printk("Enabling non-boot CPUs ...\n");
 	for_each_cpu_mask(cpu, frozen_cpus) {
-		error = _cpu_up(cpu);
+		error = _cpu_up(cpu, 1);
 		if (!error) {
 			printk("CPU%d is up\n", cpu);
 			continue;
Index: linux-2.6.21-rc7/arch/i386/kernel/cpu/intel_cacheinfo.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/i386/kernel/cpu/intel_cacheinfo.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/arch/i386/kernel/cpu/intel_cacheinfo.c	2007-04-16 23:05:45.000000000 +0200
@@ -733,9 +733,11 @@ static int __cpuinit cacheinfo_cpu_callb
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
Index: linux-2.6.21-rc7/arch/i386/kernel/cpu/mcheck/therm_throt.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/i386/kernel/cpu/mcheck/therm_throt.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/arch/i386/kernel/cpu/mcheck/therm_throt.c	2007-04-16 23:05:45.000000000 +0200
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
Index: linux-2.6.21-rc7/arch/i386/kernel/cpuid.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/i386/kernel/cpuid.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/arch/i386/kernel/cpuid.c	2007-04-16 23:05:45.000000000 +0200
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
Index: linux-2.6.21-rc7/arch/i386/kernel/microcode.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/i386/kernel/microcode.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/arch/i386/kernel/microcode.c	2007-04-16 23:05:45.000000000 +0200
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
Index: linux-2.6.21-rc7/arch/i386/kernel/msr.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/i386/kernel/msr.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/arch/i386/kernel/msr.c	2007-04-16 23:05:45.000000000 +0200
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
Index: linux-2.6.21-rc7/arch/ia64/kernel/palinfo.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ia64/kernel/palinfo.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/arch/ia64/kernel/palinfo.c	2007-04-16 23:05:45.000000000 +0200
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
Index: linux-2.6.21-rc7/arch/ia64/kernel/salinfo.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ia64/kernel/salinfo.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/arch/ia64/kernel/salinfo.c	2007-04-16 23:05:45.000000000 +0200
@@ -583,6 +583,7 @@ salinfo_cpu_callback(struct notifier_blo
 	struct salinfo_data *data;
 	switch (action) {
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		spin_lock_irqsave(&data_saved_lock, flags);
 		for (i = 0, data = salinfo_data;
 		     i < ARRAY_SIZE(salinfo_data);
@@ -593,6 +594,7 @@ salinfo_cpu_callback(struct notifier_blo
 		spin_unlock_irqrestore(&data_saved_lock, flags);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		spin_lock_irqsave(&data_saved_lock, flags);
 		for (i = 0, data = salinfo_data;
 		     i < ARRAY_SIZE(salinfo_data);
Index: linux-2.6.21-rc7/arch/ia64/kernel/topology.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/ia64/kernel/topology.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/arch/ia64/kernel/topology.c	2007-04-16 23:05:45.000000000 +0200
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
Index: linux-2.6.21-rc7/arch/powerpc/kernel/sysfs.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/powerpc/kernel/sysfs.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/arch/powerpc/kernel/sysfs.c	2007-04-16 23:05:45.000000000 +0200
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
Index: linux-2.6.21-rc7/arch/powerpc/mm/numa.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/powerpc/mm/numa.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/arch/powerpc/mm/numa.c	2007-04-16 23:05:45.000000000 +0200
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
Index: linux-2.6.21-rc7/arch/s390/appldata/appldata_base.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/s390/appldata/appldata_base.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/arch/s390/appldata/appldata_base.c	2007-04-16 23:05:45.000000000 +0200
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
Index: linux-2.6.21-rc7/arch/x86_64/kernel/mce.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/x86_64/kernel/mce.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/arch/x86_64/kernel/mce.c	2007-04-16 23:05:45.000000000 +0200
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
Index: linux-2.6.21-rc7/arch/x86_64/kernel/mce_amd.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/x86_64/kernel/mce_amd.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/arch/x86_64/kernel/mce_amd.c	2007-04-16 23:05:45.000000000 +0200
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
Index: linux-2.6.21-rc7/arch/x86_64/kernel/vsyscall.c
===================================================================
--- linux-2.6.21-rc7.orig/arch/x86_64/kernel/vsyscall.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/arch/x86_64/kernel/vsyscall.c	2007-04-16 23:05:45.000000000 +0200
@@ -301,7 +301,7 @@ static int __cpuinit
 cpu_vsyscall_notifier(struct notifier_block *n, unsigned long action, void *arg)
 {
 	long cpu = (long)arg;
-	if (action == CPU_ONLINE)
+	if (action == CPU_ONLINE || action == CPU_ONLINE_FROZEN)
 		smp_call_function_single(cpu, cpu_vsyscall_init, NULL, 0, 1);
 	return NOTIFY_DONE;
 }
Index: linux-2.6.21-rc7/block/ll_rw_blk.c
===================================================================
--- linux-2.6.21-rc7.orig/block/ll_rw_blk.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/block/ll_rw_blk.c	2007-04-16 23:05:45.000000000 +0200
@@ -3505,7 +3505,7 @@ static int blk_cpu_notify(struct notifie
 	 * If a CPU goes away, splice its entries to the current CPU
 	 * and trigger a run of the softirq
 	 */
-	if (action == CPU_DEAD) {
+	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
 		int cpu = (unsigned long) hcpu;
 
 		local_irq_disable();
Index: linux-2.6.21-rc7/drivers/base/topology.c
===================================================================
--- linux-2.6.21-rc7.orig/drivers/base/topology.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/drivers/base/topology.c	2007-04-16 23:05:45.000000000 +0200
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
Index: linux-2.6.21-rc7/drivers/cpufreq/cpufreq.c
===================================================================
--- linux-2.6.21-rc7.orig/drivers/cpufreq/cpufreq.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/drivers/cpufreq/cpufreq.c	2007-04-16 23:05:45.000000000 +0200
@@ -1716,9 +1716,11 @@ static int cpufreq_cpu_callback(struct n
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
 
@@ -1730,6 +1732,7 @@ static int cpufreq_cpu_callback(struct n
 			__cpufreq_remove_dev(sys_dev);
 			break;
 		case CPU_DOWN_FAILED:
+		case CPU_DOWN_FAILED_FROZEN:
 			cpufreq_add_dev(sys_dev);
 			break;
 		}
Index: linux-2.6.21-rc7/drivers/cpufreq/cpufreq_stats.c
===================================================================
--- linux-2.6.21-rc7.orig/drivers/cpufreq/cpufreq_stats.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/drivers/cpufreq/cpufreq_stats.c	2007-04-16 23:05:45.000000000 +0200
@@ -313,9 +313,11 @@ static int cpufreq_stat_cpu_callback(str
 
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
Index: linux-2.6.21-rc7/drivers/infiniband/hw/ehca/ehca_irq.c
===================================================================
--- linux-2.6.21-rc7.orig/drivers/infiniband/hw/ehca/ehca_irq.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/drivers/infiniband/hw/ehca/ehca_irq.c	2007-04-16 23:05:45.000000000 +0200
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
Index: linux-2.6.21-rc7/drivers/kvm/kvm_main.c
===================================================================
--- linux-2.6.21-rc7.orig/drivers/kvm/kvm_main.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/drivers/kvm/kvm_main.c	2007-04-16 23:05:45.000000000 +0200
@@ -2363,7 +2363,9 @@ static int kvm_cpu_hotplug(struct notifi
 
 	switch (val) {
 	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
 		       cpu);
 		decache_vcpus_on_cpu(cpu);
@@ -2371,6 +2373,7 @@ static int kvm_cpu_hotplug(struct notifi
 					 NULL, 0, 1);
 		break;
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
 		       cpu);
 		smp_call_function_single(cpu, kvm_arch_ops->hardware_enable,
Index: linux-2.6.21-rc7/fs/buffer.c
===================================================================
--- linux-2.6.21-rc7.orig/fs/buffer.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/fs/buffer.c	2007-04-16 23:05:45.000000000 +0200
@@ -2994,7 +2994,7 @@ static void buffer_exit_cpu(int cpu)
 static int buffer_cpu_notify(struct notifier_block *self,
 			      unsigned long action, void *hcpu)
 {
-	if (action == CPU_DEAD)
+	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN)
 		buffer_exit_cpu((unsigned long)hcpu);
 	return NOTIFY_OK;
 }
Index: linux-2.6.21-rc7/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6.21-rc7.orig/fs/xfs/xfs_mount.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/fs/xfs/xfs_mount.c	2007-04-16 23:05:45.000000000 +0200
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
Index: linux-2.6.21-rc7/kernel/hrtimer.c
===================================================================
--- linux-2.6.21-rc7.orig/kernel/hrtimer.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/kernel/hrtimer.c	2007-04-16 23:05:45.000000000 +0200
@@ -1407,11 +1407,13 @@ static int __cpuinit hrtimer_cpu_notify(
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
Index: linux-2.6.21-rc7/kernel/profile.c
===================================================================
--- linux-2.6.21-rc7.orig/kernel/profile.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/kernel/profile.c	2007-04-16 23:05:45.000000000 +0200
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
Index: linux-2.6.21-rc7/kernel/rcupdate.c
===================================================================
--- linux-2.6.21-rc7.orig/kernel/rcupdate.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/kernel/rcupdate.c	2007-04-16 23:05:45.000000000 +0200
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
Index: linux-2.6.21-rc7/kernel/relay.c
===================================================================
--- linux-2.6.21-rc7.orig/kernel/relay.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/kernel/relay.c	2007-04-16 23:05:45.000000000 +0200
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
Index: linux-2.6.21-rc7/kernel/sched.c
===================================================================
--- linux-2.6.21-rc7.orig/kernel/sched.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/kernel/sched.c	2007-04-16 23:05:45.000000000 +0200
@@ -5158,6 +5158,7 @@ migration_call(struct notifier_block *nf
 
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		p = kthread_create(migration_thread, hcpu, "migration/%d",cpu);
 		if (IS_ERR(p))
 			return NOTIFY_BAD;
@@ -5171,12 +5172,14 @@ migration_call(struct notifier_block *nf
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
@@ -5187,6 +5190,7 @@ migration_call(struct notifier_block *nf
 		break;
 
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		migrate_live_tasks(cpu);
 		rq = cpu_rq(cpu);
 		kthread_stop(rq->migration_thread);
@@ -6668,14 +6672,20 @@ static int update_sched_domains(struct n
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
Index: linux-2.6.21-rc7/kernel/softirq.c
===================================================================
--- linux-2.6.21-rc7.orig/kernel/softirq.c	2007-04-16 23:05:18.000000000 +0200
+++ linux-2.6.21-rc7/kernel/softirq.c	2007-04-16 23:05:45.000000000 +0200
@@ -593,6 +593,7 @@ static int __cpuinit cpu_callback(struct
 
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		p = kthread_create(ksoftirqd, hcpu, "ksoftirqd/%d", hotcpu);
 		if (IS_ERR(p)) {
 			printk("ksoftirqd for %i failed\n", hotcpu);
@@ -602,16 +603,19 @@ static int __cpuinit cpu_callback(struct
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
Index: linux-2.6.21-rc7/kernel/softlockup.c
===================================================================
--- linux-2.6.21-rc7.orig/kernel/softlockup.c	2007-04-16 23:05:18.000000000 +0200
+++ linux-2.6.21-rc7/kernel/softlockup.c	2007-04-16 23:05:45.000000000 +0200
@@ -112,6 +112,7 @@ cpu_callback(struct notifier_block *nfb,
 
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		BUG_ON(per_cpu(watchdog_task, hotcpu));
 		p = kthread_create(watchdog, hcpu, "watchdog/%d", hotcpu);
 		if (IS_ERR(p)) {
@@ -123,16 +124,19 @@ cpu_callback(struct notifier_block *nfb,
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
Index: linux-2.6.21-rc7/kernel/timer.c
===================================================================
--- linux-2.6.21-rc7.orig/kernel/timer.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/kernel/timer.c	2007-04-16 23:05:45.000000000 +0200
@@ -1699,11 +1699,13 @@ static int __cpuinit timer_cpu_notify(st
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
Index: linux-2.6.21-rc7/kernel/workqueue.c
===================================================================
--- linux-2.6.21-rc7.orig/kernel/workqueue.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/kernel/workqueue.c	2007-04-16 23:05:45.000000000 +0200
@@ -757,6 +757,7 @@ static int __devinit workqueue_cpu_callb
 
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		mutex_lock(&workqueue_mutex);
 		/* Create a new workqueue thread for it. */
 		list_for_each_entry(wq, &workqueues, list) {
@@ -768,6 +769,7 @@ static int __devinit workqueue_cpu_callb
 		break;
 
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		/* Kick off worker threads. */
 		list_for_each_entry(wq, &workqueues, list) {
 			struct cpu_workqueue_struct *cwq;
@@ -780,6 +782,7 @@ static int __devinit workqueue_cpu_callb
 		break;
 
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 		list_for_each_entry(wq, &workqueues, list) {
 			if (!per_cpu_ptr(wq->cpu_wq, hotcpu)->thread)
 				continue;
@@ -792,14 +795,17 @@ static int __devinit workqueue_cpu_callb
 		break;
 
 	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
 		mutex_lock(&workqueue_mutex);
 		break;
 
 	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
 		mutex_unlock(&workqueue_mutex);
 		break;
 
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		list_for_each_entry(wq, &workqueues, list)
 			cleanup_workqueue_thread(wq, hotcpu);
 		list_for_each_entry(wq, &workqueues, list)
Index: linux-2.6.21-rc7/lib/radix-tree.c
===================================================================
--- linux-2.6.21-rc7.orig/lib/radix-tree.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/lib/radix-tree.c	2007-04-16 23:05:45.000000000 +0200
@@ -1004,7 +1004,7 @@ static int radix_tree_callback(struct no
        struct radix_tree_preload *rtp;
 
        /* Free per-cpu pool of perloaded nodes */
-       if (action == CPU_DEAD) {
+       if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
                rtp = &per_cpu(radix_tree_preloads, cpu);
                while (rtp->nr) {
                        kmem_cache_free(radix_tree_node_cachep,
Index: linux-2.6.21-rc7/mm/page_alloc.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/page_alloc.c	2007-04-16 23:05:18.000000000 +0200
+++ linux-2.6.21-rc7/mm/page_alloc.c	2007-04-16 23:05:45.000000000 +0200
@@ -2143,11 +2143,14 @@ static int __cpuinit pageset_cpuup_callb
 
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
@@ -3007,7 +3010,7 @@ static int page_alloc_cpu_notify(struct 
 {
 	int cpu = (unsigned long)hcpu;
 
-	if (action == CPU_DEAD) {
+	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
 		local_irq_disable();
 		__drain_pages(cpu);
 		vm_events_fold_cpu(cpu);
Index: linux-2.6.21-rc7/mm/swap.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/swap.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/mm/swap.c	2007-04-16 23:05:45.000000000 +0200
@@ -488,7 +488,7 @@ static int cpu_swap_callback(struct noti
 	long *committed;
 
 	committed = &per_cpu(committed_space, (long)hcpu);
-	if (action == CPU_DEAD) {
+	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
 		atomic_add(*committed, &vm_committed_space);
 		*committed = 0;
 		__lru_add_drain((long)hcpu);
Index: linux-2.6.21-rc7/mm/vmscan.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/vmscan.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/mm/vmscan.c	2007-04-16 23:05:45.000000000 +0200
@@ -1527,7 +1527,7 @@ static int __devinit cpu_callback(struct
 	pg_data_t *pgdat;
 	cpumask_t mask;
 
-	if (action == CPU_ONLINE) {
+	if (action == CPU_ONLINE || action == CPU_ONLINE_FROZEN) {
 		for_each_online_pgdat(pgdat) {
 			mask = node_to_cpumask(pgdat->node_id);
 			if (any_online_cpu(mask) != NR_CPUS)
Index: linux-2.6.21-rc7/mm/vmstat.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/vmstat.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/mm/vmstat.c	2007-04-16 23:05:45.000000000 +0200
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
Index: linux-2.6.21-rc7/net/core/dev.c
===================================================================
--- linux-2.6.21-rc7.orig/net/core/dev.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/net/core/dev.c	2007-04-16 23:05:45.000000000 +0200
@@ -3344,7 +3344,7 @@ static int dev_cpu_callback(struct notif
 	unsigned int cpu, oldcpu = (unsigned long)ocpu;
 	struct softnet_data *sd, *oldsd;
 
-	if (action != CPU_DEAD)
+	if (action != CPU_DEAD && action != CPU_DEAD_FROZEN)
 		return NOTIFY_OK;
 
 	local_irq_disable();
Index: linux-2.6.21-rc7/net/core/flow.c
===================================================================
--- linux-2.6.21-rc7.orig/net/core/flow.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/net/core/flow.c	2007-04-16 23:05:45.000000000 +0200
@@ -338,7 +338,7 @@ static int flow_cache_cpu(struct notifie
 			  unsigned long action,
 			  void *hcpu)
 {
-	if (action == CPU_DEAD)
+	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN)
 		__flow_cache_shrink((unsigned long)hcpu, 0);
 	return NOTIFY_OK;
 }
Index: linux-2.6.21-rc7/net/iucv/iucv.c
===================================================================
--- linux-2.6.21-rc7.orig/net/iucv/iucv.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/net/iucv/iucv.c	2007-04-16 23:05:45.000000000 +0200
@@ -528,6 +528,7 @@ static int __cpuinit iucv_cpu_notify(str
 
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		if (!percpu_populate(iucv_irq_data,
 				     sizeof(struct iucv_irq_data),
 				     GFP_KERNEL|GFP_DMA, cpu))
@@ -539,15 +540,20 @@ static int __cpuinit iucv_cpu_notify(str
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
Index: linux-2.6.21-rc7/Documentation/cpu-hotplug.txt
===================================================================
--- linux-2.6.21-rc7.orig/Documentation/cpu-hotplug.txt	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/Documentation/cpu-hotplug.txt	2007-04-16 23:05:45.000000000 +0200
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
Index: linux-2.6.21-rc7/mm/slab.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/slab.c	2007-04-16 23:05:17.000000000 +0200
+++ linux-2.6.21-rc7/mm/slab.c	2007-04-16 23:05:45.000000000 +0200
@@ -1180,6 +1180,7 @@ static int __cpuinit cpuup_callback(stru
 
 	switch (action) {
 	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		mutex_lock(&cache_chain_mutex);
 		/*
 		 * We need to do this right in the beginning since
@@ -1266,17 +1267,21 @@ static int __cpuinit cpuup_callback(stru
 		}
 		break;
 	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
 		mutex_unlock(&cache_chain_mutex);
 		start_cpu_timer(cpu);
 		break;
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
 		mutex_lock(&cache_chain_mutex);
 		break;
 	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
 		mutex_unlock(&cache_chain_mutex);
 		break;
 	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
 		/*
 		 * Even if all the cpus of a node are down, we don't free the
 		 * kmem_list3 of any cache. This to avoid a race between
@@ -1288,6 +1293,7 @@ static int __cpuinit cpuup_callback(stru
 		/* fall thru */
 #endif
 	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 		list_for_each_entry(cachep, &cache_chain, next) {
 			struct array_cache *nc;
 			struct array_cache *shared;
