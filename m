Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbZJHJvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbZJHJvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 05:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756972AbZJHJvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 05:51:11 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:46933 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394AbZJHJvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 05:51:09 -0400
Date: Thu, 8 Oct 2009 15:20:27 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-arch@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [v8 PATCH 2/8]: cpuidle: implement a list based approach to
	register a set of idle routines.
Message-ID: <20091008095027.GC20595@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20091008094828.GA20595@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091008094828.GA20595@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-10-08 15:18:28]:

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
 drivers/cpuidle/cpuidle.c |   54 ++++++++++++++++++++++++++++++++++++++++------
 include/linux/cpuidle.h   |    1 
 2 files changed, 48 insertions(+), 7 deletions(-)

Index: linux.trees.git/drivers/cpuidle/cpuidle.c
===================================================================
--- linux.trees.git.orig/drivers/cpuidle/cpuidle.c
+++ linux.trees.git/drivers/cpuidle/cpuidle.c
@@ -22,6 +22,7 @@
 #include "cpuidle.h"
 
 DEFINE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
+DEFINE_PER_CPU(struct list_head, cpuidle_devices_list);
 
 DEFINE_MUTEX(cpuidle_lock);
 
@@ -112,6 +113,45 @@ void cpuidle_resume_and_unlock(void)
 
 EXPORT_SYMBOL_GPL(cpuidle_resume_and_unlock);
 
+int cpuidle_add_to_list(struct cpuidle_device *dev)
+{
+	int ret, cpu = dev->cpu;
+	struct cpuidle_device *old_dev;
+
+	if (!list_empty(&per_cpu(cpuidle_devices_list, cpu))) {
+		old_dev = list_first_entry(&per_cpu(cpuidle_devices_list, cpu),
+				struct cpuidle_device, idle_list);
+		cpuidle_remove_state_sysfs(old_dev);
+	}
+
+	list_add(&dev->idle_list, &per_cpu(cpuidle_devices_list, cpu));
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
+		temp_dev = container_of(pos, struct cpuidle_device, idle_list);
+		if (dev == temp_dev) {
+			list_del(&temp_dev->idle_list);
+			cpuidle_remove_state_sysfs(temp_dev);
+			break;
+		}
+	}
+
+	if (!list_empty(&per_cpu(cpuidle_devices_list, cpu))) {
+		temp_dev = list_first_entry(&per_cpu(cpuidle_devices_list, cpu),
+					struct cpuidle_device, idle_list);
+		ret = cpuidle_add_state_sysfs(temp_dev);
+	}
+	cpuidle_kick_cpus();
+}
+
 /**
  * cpuidle_enable_device - enables idle PM for a CPU
  * @dev: the CPU
@@ -136,9 +176,6 @@ int cpuidle_enable_device(struct cpuidle
 			return ret;
 	}
 
-	if ((ret = cpuidle_add_state_sysfs(dev)))
-		return ret;
-
 	if (cpuidle_curr_governor->enable &&
 	    (ret = cpuidle_curr_governor->enable(dev)))
 		goto fail_sysfs;
@@ -157,7 +194,7 @@ int cpuidle_enable_device(struct cpuidle
 	return 0;
 
 fail_sysfs:
-	cpuidle_remove_state_sysfs(dev);
+	cpuidle_remove_from_list(dev);
 
 	return ret;
 }
@@ -182,8 +219,6 @@ void cpuidle_disable_device(struct cpuid
 
 	if (cpuidle_curr_governor->disable)
 		cpuidle_curr_governor->disable(dev);
-
-	cpuidle_remove_state_sysfs(dev);
 }
 
 EXPORT_SYMBOL_GPL(cpuidle_disable_device);
@@ -267,6 +302,7 @@ int cpuidle_register_device(struct cpuid
 	}
 
 	cpuidle_enable_device(dev);
+	cpuidle_add_to_list(dev);
 
 	mutex_unlock(&cpuidle_lock);
 
@@ -288,6 +324,7 @@ void cpuidle_unregister_device(struct cp
 	cpuidle_pause_and_lock();
 
 	cpuidle_disable_device(dev);
+	cpuidle_remove_from_list(dev);
 
 	per_cpu(cpuidle_devices, dev->cpu) = NULL;
 
@@ -338,12 +375,15 @@ static inline void latency_notifier_init
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
@@ -92,6 +92,7 @@ struct cpuidle_device {
 	struct cpuidle_state_kobj *kobjs[CPUIDLE_STATE_MAX];
 	struct cpuidle_state	*last_state;
 
+	struct list_head	idle_list;
 	struct kobject		kobj;
 	struct completion	kobj_unregister;
 	void			*governor_data;
