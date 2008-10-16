Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbYJPLqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbYJPLqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 07:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbYJPLqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 07:46:17 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:60712 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbYJPLqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 07:46:16 -0400
Date: Thu, 16 Oct 2008 17:15:58 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org, arun@linux.vnet.ibm.com
Subject: [RFC PATCH 1/4] timers: Sysfs hook to enable timer migration
Message-ID: <20081016114558.GB7641@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
Mail-Followup-To: linux-kernel@vger.kernel.org,
	linux-pm@lists.linux-foundation.org, a.p.zijlstra@chello.nl,
	ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
	andi@firstfloor.org, venkatesh.pallipadi@intel.com,
	vatsa@linux.vnet.ibm.com, arjan@infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates the necessary sysfs interface for timer migration.

The interface is located at /sys/devices/system/cpu/cpuX/timer_migration

These sysfs entries are initialized to their respective cpu ids.
This represents the no timer migration state.
By echoing a target cpu number we can enable migration for that cpu.

Echo a target cpu number to the per-cpu sysfs entry and all timers
are migrated to that cpu, instead of choosing cpu0 by default.

e.g. echo 4 > /sys/devices/system/cpu/cpu1/timer_migration

this would move all regular and hrtimers from cpu1 to cpu4.


Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 drivers/base/cpu.c    |   42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/timer.h |    2 ++
 2 files changed, 44 insertions(+)

Index: linux-2.6.27/drivers/base/cpu.c
===================================================================
--- linux-2.6.27.orig/drivers/base/cpu.c
+++ linux-2.6.27/drivers/base/cpu.c
@@ -20,6 +20,43 @@ EXPORT_SYMBOL(cpu_sysdev_class);
 
 static DEFINE_PER_CPU(struct sys_device *, cpu_sys_devices);
 
+DEFINE_PER_CPU(int, enable_timer_migration);
+
+/* This function initializes sysfs entries for enabling timer migration.
+ * Each per_cpu enable_timer_migration is initialized to its cpu_id.
+ * By echo-ing a value other than its cpu_id will set that as the target cpu
+ * to which the timers are to be migrated to.
+ */
+void initialize_timer_migration_sysfs(void)
+{
+	int cpu;
+	for_each_possible_cpu(cpu)
+		per_cpu(enable_timer_migration, cpu) = cpu;
+}
+
+static ssize_t timer_migration_show(struct sys_device *dev, char *buf)
+{
+	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
+	return sprintf(buf, "%u\n", per_cpu(enable_timer_migration,
+		cpu->sysdev.id));
+}
+static ssize_t
+timer_migration_store(struct sys_device *dev, const char *buf, size_t count)
+{
+	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
+	ssize_t ret = -EINVAL;
+	int target_cpu;
+	sscanf(buf, "%d", &target_cpu);
+	if (cpu_online(target_cpu)) {
+		ret = count;
+		per_cpu(enable_timer_migration, cpu->sysdev.id) = target_cpu;
+	}
+
+	return ret;
+}
+static SYSDEV_ATTR(timer_migration, 0644,
+		timer_migration_show, timer_migration_store);
+
 #ifdef CONFIG_HOTPLUG_CPU
 static ssize_t show_online(struct sys_device *dev, struct sysdev_attribute *attr,
 			   char *buf)
@@ -177,6 +214,11 @@ int __cpuinit register_cpu(struct cpu *c
 	if (!error)
 		error = sysdev_create_file(&cpu->sysdev, &attr_crash_notes);
 #endif
+
+	if (!error) {
+		error = sysdev_create_file(&cpu->sysdev, &attr_timer_migration);
+		initialize_timer_migration_sysfs();
+	}
 	return error;
 }
 
Index: linux-2.6.27/include/linux/timer.h
===================================================================
--- linux-2.6.27.orig/include/linux/timer.h
+++ linux-2.6.27/include/linux/timer.h
@@ -187,3 +187,5 @@ unsigned long round_jiffies(unsigned lon
 unsigned long round_jiffies_relative(unsigned long j);
 
 #endif
+
+DECLARE_PER_CPU(int, enable_timer_migration);
