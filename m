Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbZIVFgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbZIVFgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbZIVFgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:36:22 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:38721 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbZIVFgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:36:21 -0400
Date: Tue, 22 Sep 2009 11:06:11 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [v5 RFC PATCH 2/7]: cpuidle: implement a list based approach to
	register a set of idle routines.
Message-ID: <20090922053611.GC6417@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090922053314.GA6417@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090922053314.GA6417@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-09-22 11:03:14]:

Implement a list based registering mechanism for architectures which
have multiple sets of idle routines which are to be registered.

Currently, in x86 it is done by merely setting pm_idle = idle_routine
and managing this pm_idle pointer is messy.

To give an example of how this mechanism works:
In x86, initially, idle routine is selected from the set of poll/mwait/
c1e/default idle loops. So the selected idle loop is registered in cpuidle
as one idle state cpuidle devices. Once ACPI comes up, it registers
another set of idle states on top of this state. Again, suppose a module
registers another set of idle loops, it is added to this list.

This provides a clean way of registering and unregistering idle state
routines.

In the current implementation, pm_idle is set as the current idle routine
being used and the old idle routine has to be maintained and when a module
registers/unregisters an idle routine, confusion arises.


Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 drivers/cpuidle/cpuidle.c |   50 ++++++++++++++++++++++++++++++++++++++++++----
 include/linux/cpuidle.h   |    1 
 2 files changed, 47 insertions(+), 4 deletions(-)

Index: linux.trees.git/drivers/cpuidle/cpuidle.c
===================================================================
--- linux.trees.git.orig/drivers/cpuidle/cpuidle.c
+++ linux.trees.git/drivers/cpuidle/cpuidle.c
@@ -21,6 +21,7 @@
 #include "cpuidle.h"
 
 DEFINE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
+DEFINE_PER_CPU(struct list_head, cpuidle_devices_list);
 
 DEFINE_MUTEX(cpuidle_lock);
 LIST_HEAD(cpuidle_detected_devices);
@@ -100,6 +101,44 @@ void cpuidle_resume_and_unlock(void)
 
 EXPORT_SYMBOL_GPL(cpuidle_resume_and_unlock);
 
+int cpuidle_add_to_list(struct cpuidle_device *dev)
+{
+	int ret, cpu = dev->cpu;
+	struct cpuidle_device *old_dev;
+
+	if (!list_empty(&per_cpu(cpuidle_devices_list, cpu))) {
+		old_dev = list_first_entry(&per_cpu(cpuidle_devices_list, cpu),
+				struct cpuidle_device, percpu_list[cpu]);
+		cpuidle_remove_state_sysfs(old_dev);
+	}
+
+	list_add(&dev->percpu_list[cpu], &per_cpu(cpuidle_devices_list, cpu));
+	ret = cpuidle_add_state_sysfs(dev);
+	return ret;
+}
+
+void cpuidle_remove_from_list(struct cpuidle_device *dev)
+{
+	struct cpuidle_device *temp_dev;
+	struct list_head *pos;
+	int ret, cpu = dev->cpu;
+
+	list_for_each(pos, &per_cpu(cpuidle_devices_list, cpu)) {
+		temp_dev = container_of(pos, struct cpuidle_device,
+					percpu_list[cpu]);
+		if (dev == temp_dev) {
+			list_del(&temp_dev->percpu_list[cpu]);
+			cpuidle_remove_state_sysfs(temp_dev);
+		}
+	}
+
+	if (!list_empty(&per_cpu(cpuidle_devices_list, cpu))) {
+		temp_dev = list_first_entry(&per_cpu(cpuidle_devices_list, cpu),
+				struct cpuidle_device, percpu_list[cpu]);
+				ret = cpuidle_add_state_sysfs(temp_dev);
+	}
+}
+
 /**
  * cpuidle_enable_device - enables idle PM for a CPU
  * @dev: the CPU
@@ -124,7 +163,7 @@ int cpuidle_enable_device(struct cpuidle
 			return ret;
 	}
 
-	if ((ret = cpuidle_add_state_sysfs(dev)))
+	if ((cpuidle_add_to_list(dev)))
 		return ret;
 
 	if (cpuidle_curr_governor->enable &&
@@ -145,7 +184,7 @@ int cpuidle_enable_device(struct cpuidle
 	return 0;
 
 fail_sysfs:
-	cpuidle_remove_state_sysfs(dev);
+	cpuidle_remove_from_list(dev);
 
 	return ret;
 }
@@ -171,7 +210,7 @@ void cpuidle_disable_device(struct cpuid
 	if (cpuidle_curr_governor->disable)
 		cpuidle_curr_governor->disable(dev);
 
-	cpuidle_remove_state_sysfs(dev);
+	cpuidle_remove_from_list(dev);
 }
 
 EXPORT_SYMBOL_GPL(cpuidle_disable_device);
@@ -339,12 +378,15 @@ static inline void latency_notifier_init
  */
 static int __init cpuidle_init(void)
 {
-	int ret;
+	int ret, cpu;
 
 	ret = cpuidle_add_class_sysfs(&cpu_sysdev_class);
 	if (ret)
 		return ret;
 
+	for_each_possible_cpu(cpu)
+		INIT_LIST_HEAD(&per_cpu(cpuidle_devices_list, cpu));
+
 	latency_notifier_init(&cpuidle_latency_notifier);
 
 	return 0;
Index: linux.trees.git/include/linux/cpuidle.h
===================================================================
--- linux.trees.git.orig/include/linux/cpuidle.h
+++ linux.trees.git/include/linux/cpuidle.h
@@ -93,6 +93,7 @@ struct cpuidle_device {
 	struct cpuidle_state	*last_state;
 
 	struct list_head 	device_list;
+	struct list_head	percpu_list[NR_CPUS];
 	struct kobject		kobj;
 	struct completion	kobj_unregister;
 	void			*governor_data;
