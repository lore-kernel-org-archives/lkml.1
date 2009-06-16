Return-Path: <linux-kernel-owner+w=401wt.eu-S935575AbZFPFjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935575AbZFPFjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934703AbZFPFi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:38:57 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:42159 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933663AbZFPFi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:38:56 -0400
Subject: [RFD PATCH 3/4] cpu: Define new functions cpu_down_mask and
	cpu_up_mask
To: linux-kernel@vger.kernel.org
From: Gautham R Shenoy <ego@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Balbir Singh <balbir@in.ibm.com>,
       Rusty Russel <rusty@rustcorp.com.au>,
       Paul E McKenney <paulmck@us.ibm.com>, Nathan Lynch <ntl@pobox.com>,
       Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Shoahua Li <shaohua.li@linux.com>
Date: Tue, 16 Jun 2009 11:08:54 +0530
Message-ID: <20090616053854.30891.16480.stgit@sofia.in.ibm.com>
In-Reply-To: <20090616053431.30891.18682.stgit@sofia.in.ibm.com>
References: <20090616053431.30891.18682.stgit@sofia.in.ibm.com>
User-Agent: StGit/0.14.3.384.g9ab0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently cpu-hotplug operation is carried out on a single processor at any
given time. We create two functions which will enable us to offline/online
multiple CPUs in a single go.

These functions are:
	int cpu_down_mask(cpumask_var_t cpus_to_offline);
	int cpu_up_mask(cpumask_var_t cpus_to_online);

In this patch, these functions serially invoke the  _cpu_down() and _cpu_up()
functions for each of the CPUs in the cpumask.

The idea is to make the CPU-hotplug notifiers work on cpumasks so that they
can optimize for hotplugging multiple CPUs.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---
 drivers/base/cpu.c  |    4 ++
 include/linux/cpu.h |    2 +
 kernel/cpu.c        |   92 +++++++++++++++++++++++++++++++++++++--------------
 3 files changed, 73 insertions(+), 25 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 7a15e7b..1a382da 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -154,6 +154,8 @@ static ssize_t store_cpus_online(struct sysdev_class *dev_class,
 
 	cpumask_copy(cpu_debug_online_mask, store_cpus_online_mask);
 
+	ret = cpu_up_mask(store_cpus_online_mask);
+
 out:
 	free_cpumask_var(store_cpus_online_mask);
 	if (ret >= 0)
@@ -221,6 +223,8 @@ static ssize_t store_cpus_offline(struct sysdev_class *dev_class,
 
 	cpumask_copy(cpu_debug_offline_mask, store_cpus_offline_mask);
 
+	ret = cpu_down_mask(store_cpus_offline_mask);
+
 out:
 	free_cpumask_var(store_cpus_offline_mask);
 	if (ret >= 0)
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 2643d84..4769ff6 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -68,6 +68,7 @@ static inline void unregister_cpu_notifier(struct notifier_block *nb)
 #endif
 
 int cpu_up(unsigned int cpu);
+int cpu_up_mask(const cpumask_var_t cpus_to_online);
 void notify_cpu_starting(unsigned int cpu);
 extern void cpu_hotplug_init(void);
 extern void cpu_maps_update_begin(void);
@@ -112,6 +113,7 @@ extern void put_online_cpus(void);
 #define register_hotcpu_notifier(nb)	register_cpu_notifier(nb)
 #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
 int cpu_down(unsigned int cpu);
+int cpu_down_mask(const cpumask_var_t cpus_to_offline);
 
 #else		/* CONFIG_HOTPLUG_CPU */
 
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 395b697..2b5d4e0 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -267,9 +267,10 @@ out_release:
 	return err;
 }
 
-int __ref cpu_down(unsigned int cpu)
+int __ref cpu_down_mask(const cpumask_var_t cpus_to_offline)
 {
 	int err;
+	unsigned int cpu;
 
 	err = stop_machine_create();
 	if (err)
@@ -281,28 +282,48 @@ int __ref cpu_down(unsigned int cpu)
 		goto out;
 	}
 
-	set_cpu_active(cpu, false);
+	for_each_cpu(cpu, cpus_to_offline) {
+		set_cpu_active(cpu, false);
 
-	/*
-	 * Make sure the all cpus did the reschedule and are not
-	 * using stale version of the cpu_active_mask.
-	 * This is not strictly necessary becuase stop_machine()
-	 * that we run down the line already provides the required
-	 * synchronization. But it's really a side effect and we do not
-	 * want to depend on the innards of the stop_machine here.
-	 */
-	synchronize_sched();
+		/*
+		 * Make sure the all cpus did the reschedule and are not
+		 * using stale version of the cpu_active_mask.
+		 * This is not strictly necessary becuase stop_machine()
+		 * that we run down the line already provides the required
+		 * synchronization. But it's really a side effect and we do not
+		 * want to depend on the innards of the stop_machine here.
+		 */
+		synchronize_sched();
 
-	err = _cpu_down(cpu, 0);
+		err = _cpu_down(cpu, 0);
 
-	if (cpu_online(cpu))
-		set_cpu_active(cpu, true);
+		if (cpu_online(cpu))
+			set_cpu_active(cpu, true);
+	}
 
 out:
 	cpu_maps_update_done();
 	stop_machine_destroy();
 	return err;
 }
+
+int __ref cpu_down(unsigned int cpu)
+{
+	int err;
+	cpumask_var_t cpus_to_offline;
+
+	if (!alloc_cpumask_var(&cpus_to_offline, GFP_KERNEL))
+		return -ENOMEM;
+
+	cpumask_clear(cpus_to_offline);
+	cpumask_set_cpu(cpu, cpus_to_offline);
+
+	err = cpu_down_mask(cpus_to_offline);
+
+	free_cpumask_var(cpus_to_offline);
+
+	return err;
+}
 EXPORT_SYMBOL(cpu_down);
 #endif /*CONFIG_HOTPLUG_CPU*/
 
@@ -347,33 +368,54 @@ out_notify:
 	return ret;
 }
 
-int __cpuinit cpu_up(unsigned int cpu)
+int __cpuinit cpu_up_mask(const cpumask_var_t cpus_to_online)
 {
 	int err = 0;
-	if (!cpu_possible(cpu)) {
-		printk(KERN_ERR "can't online cpu %d because it is not "
-			"configured as may-hotadd at boot time\n", cpu);
+	unsigned int cpu;
+
+	cpu_maps_update_begin();
+	for_each_cpu(cpu, cpus_to_online) {
+		if (!cpu_possible(cpu)) {
+			printk(KERN_ERR "can't online cpu %d because it is not"
+			" configured as may-hotadd at boot time\n", cpu);
 #if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
-		printk(KERN_ERR "please check additional_cpus= boot "
-				"parameter\n");
+			printk(KERN_ERR "please check additional_cpus= boot "
+					"parameter\n");
 #endif
-		return -EINVAL;
+			err = -EINVAL;
+			goto out;
+		}
 	}
 
-	cpu_maps_update_begin();
-
 	if (cpu_hotplug_disabled) {
 		err = -EBUSY;
 		goto out;
 	}
-
-	err = _cpu_up(cpu, 0);
+	for_each_cpu(cpu, cpus_to_online)
+		err = _cpu_up(cpu, 0);
 
 out:
 	cpu_maps_update_done();
 	return err;
 }
 
+int __cpuinit cpu_up(unsigned int cpu)
+{
+	int err = 0;
+	cpumask_var_t cpus_to_online;
+
+	if (!alloc_cpumask_var(&cpus_to_online, GFP_KERNEL))
+		return -ENOMEM;
+
+	cpumask_clear(cpus_to_online);
+	cpumask_set_cpu(cpu, cpus_to_online);
+
+	err = cpu_up_mask(cpus_to_online);
+
+	free_cpumask_var(cpus_to_online);
+
+	return err;
+}
 #ifdef CONFIG_PM_SLEEP_SMP
 static cpumask_var_t frozen_cpus;
 

