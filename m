Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbZIVL20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbZIVL20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 07:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080AbZIVL2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 07:28:24 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:46211 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083AbZIVL2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 07:28:22 -0400
Date: Tue, 22 Sep 2009 16:58:15 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Shaohua Li <shaohua.li@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [v6 PATCH 2/7]: cpuidle: implement a list based approach to
	register a set of idle routines.
Message-ID: <20090922112815.GC7788@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090922112526.GA7788@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090922112526.GA7788@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-09-22 16:55:27]:

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
 drivers/cpuidle/cpuidle.c |   51 ++++++++++++++++++++++++++++++++++++++++++----
 include/linux/cpuidle.h   |    1 
 2 files changed, 48 insertions(+), 4 deletions(-)

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
@@ -111,6 +112,45 @@ void cpuidle_resume_and_unlock(void)
 
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
@@ -135,7 +175,7 @@ int cpuidle_enable_device(struct cpuidle
 			return ret;
 	}
 
-	if ((ret = cpuidle_add_state_sysfs(dev)))
+	if ((cpuidle_add_to_list(dev)))
 		return ret;
 
 	if (cpuidle_curr_governor->enable &&
@@ -156,7 +196,7 @@ int cpuidle_enable_device(struct cpuidle
 	return 0;
 
 fail_sysfs:
-	cpuidle_remove_state_sysfs(dev);
+	cpuidle_remove_from_list(dev);
 
 	return ret;
 }
@@ -182,7 +222,7 @@ void cpuidle_disable_device(struct cpuid
 	if (cpuidle_curr_governor->disable)
 		cpuidle_curr_governor->disable(dev);
 
-	cpuidle_remove_state_sysfs(dev);
+	cpuidle_remove_from_list(dev);
 }
 
 EXPORT_SYMBOL_GPL(cpuidle_disable_device);
@@ -350,12 +390,15 @@ static inline void latency_notifier_init
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
+	struct list_head	idle_list;
 	struct kobject		kobj;
 	struct completion	kobj_unregister;
 	void			*governor_data;
