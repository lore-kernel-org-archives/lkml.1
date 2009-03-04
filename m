Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbZCDMSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbZCDMSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 07:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZCDMSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 07:18:30 -0500
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:44416 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZCDMS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 07:18:29 -0500
Date: Wed, 4 Mar 2009 17:48:13 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com, Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: [v2 PATCH 3/4] timers: sysfs hook to enable timer migration
Message-ID: <20090304121813.GD9855@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090304121249.GA9855@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090304121249.GA9855@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-03-04 17:42:49]:

This patch creates the necessary sysfs interface for timer migration.

The interface is located at
/sys/devices/system/cpu/enable_timer_migration

This enables timer migration.

        echo 1 > /sys/devices/system/cpu/enable_timer_migration

similarly,

	echo 0 > /sys/devices/system/cpu/enable_timer_migration

disables timer migration.


Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |   28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

Index: linux.trees.git/include/linux/sched.h
===================================================================
--- linux.trees.git.orig/include/linux/sched.h
+++ linux.trees.git/include/linux/sched.h
@@ -803,6 +803,7 @@ enum powersavings_balance_level {
 };
 
 extern int sched_mc_power_savings, sched_smt_power_savings;
+extern int enable_timer_migration;
 
 static inline int sd_balance_for_mc_power(void)
 {
Index: linux.trees.git/kernel/sched.c
===================================================================
--- linux.trees.git.orig/kernel/sched.c
+++ linux.trees.git/kernel/sched.c
@@ -7445,6 +7445,7 @@ static void sched_domain_node_span(int n
 #endif /* CONFIG_NUMA */
 
 int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
+int enable_timer_migration;
 
 /*
  * The cpus mask in sched_group and sched_domain hangs off the end.
@@ -8317,6 +8318,29 @@ static SYSDEV_CLASS_ATTR(sched_smt_power
 		   sched_smt_power_savings_store);
 #endif
 
+static ssize_t timer_migration_show(struct sysdev_class *class,
+					   char *page)
+{
+	return sprintf(page, "%u\n", enable_timer_migration);
+}
+static ssize_t timer_migration_store(struct sysdev_class *class,
+					    const char *buf, size_t count)
+{
+	unsigned int level = 0;
+
+	if (sscanf(buf, "%u", &level) != 1)
+		return -EINVAL;
+
+	if (level > 1)
+		return -EINVAL;
+
+	enable_timer_migration = level;
+
+	return count;
+}
+static SYSDEV_CLASS_ATTR(enable_timer_migration, 0644,
+			 timer_migration_show,
+			 timer_migration_store);
 int __init sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
 {
 	int err = 0;
@@ -8331,6 +8355,10 @@ int __init sched_create_sysfs_power_savi
 		err = sysfs_create_file(&cls->kset.kobj,
 					&attr_sched_mc_power_savings.attr);
 #endif
+	if (!err)
+		err = sysfs_create_file(&cls->kset.kobj,
+					&attr_enable_timer_migration.attr);
+
 	return err;
 }
 #endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
