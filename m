Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbZBTM7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbZBTM7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 07:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbZBTM7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 07:59:11 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:47546 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbZBTM7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 07:59:09 -0500
Date: Fri, 20 Feb 2009 18:28:58 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de,
       mingo@elte.hu, andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org
Subject: [RFC PATCH 2/4] timers: sysfs hook to enable timer migration.
Message-ID: <20090220125858.GB19762@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
Mail-Followup-To: linux-kernel@vger.kernel.org,
	linux-pm@lists.linux-foundation.org, a.p.zijlstra@chello.nl,
	ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
	andi@firstfloor.org, venkatesh.pallipadi@intel.com,
	vatsa@linux.vnet.ibm.com, arjan@infradead.org
References: <20090220125516.GB10232@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090220125516.GB10232@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-02-20 18:25:16]:

This patch creates the necessary sysfs interface for timer migration.

The interface is located at
/sys/devices/system/cpu/cpuX/timer_migration

These sysfs entries are initialized to their respective cpu ids.
This represents the no timer migration state.
By echoing a target cpu number we can enable migration for that cpu.

Echo a target cpu number to the per-cpu sysfs entry and all timers
are migrated to that cpu, instead of choosing cpu0 by default.

e.g. echo 4 > /sys/devices/system/cpu/cpu1/timer_migration

this would move all regular and hrtimers from cpu1 to cpu4.



Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 drivers/base/cpu.c    |   44 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/timer.h |    2 ++
 2 files changed, 46 insertions(+)

Index: git-2.6/drivers/base/cpu.c
===================================================================
--- git-2.6.orig/drivers/base/cpu.c
+++ git-2.6/drivers/base/cpu.c
@@ -20,6 +20,45 @@ EXPORT_SYMBOL(cpu_sysdev_class);
 
 static DEFINE_PER_CPU(struct sys_device *, cpu_sys_devices);
 
+DEFINE_PER_CPU(int, enable_timer_migration);
+
+/*
+ * This function initializes sysfs entries for enabling timer migration.
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
+static ssize_t timer_migration_show(struct sys_device *dev,
+			struct sysdev_attribute *attr, char *buf)
+{
+	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
+	return sprintf(buf, "%u\n", per_cpu(enable_timer_migration,
+		cpu->sysdev.id));
+}
+static ssize_t
+timer_migration_store(struct sys_device *dev, struct sysdev_attribute *attr,
+			const char *buf, size_t count)
+{
+	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
+	ssize_t ret = -EINVAL;
+	int target_cpu;
+	if (sscanf(buf, "%d", &target_cpu) && cpu_online(target_cpu)) {
+		ret = count;
+		per_cpu(enable_timer_migration, cpu->sysdev.id) = target_cpu;
+	}
+
+	return ret;
+}
+static SYSDEV_ATTR(timer_migration, 0666,
+		timer_migration_show, timer_migration_store);
+
 #ifdef CONFIG_HOTPLUG_CPU
 static ssize_t show_online(struct sys_device *dev, struct sysdev_attribute *attr,
 			   char *buf)
@@ -221,6 +260,11 @@ int __cpuinit register_cpu(struct cpu *c
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
 
Index: git-2.6/include/linux/timer.h
===================================================================
--- git-2.6.orig/include/linux/timer.h
+++ git-2.6/include/linux/timer.h
@@ -192,3 +192,5 @@ unsigned long round_jiffies_up(unsigned 
 unsigned long round_jiffies_up_relative(unsigned long j);
 
 #endif
+
+DECLARE_PER_CPU(int, enable_timer_migration);
