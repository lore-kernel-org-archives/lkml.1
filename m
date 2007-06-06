Return-Path: <linux-kernel-owner+w=401wt.eu-S936064AbXFFU6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936064AbXFFU6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935103AbXFFU6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:58:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:20050 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935077AbXFFU6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:58:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,390,1175497200"; 
   d="scan'208";a="251608327"
Date: Wed, 6 Jun 2007 13:54:51 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: Adam Belay <abelay@novell.com>, Len Brown <len.brown@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Shaohua Li <shaohua.li@intel.com>,
       linux-acpi@vger.kernel.org
Subject: [PATCH 6/8] cpuidle: make cpuidle sysfs driver/governor switch off by default
Message-ID: <20070606205451.GF23906@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Make default cpuidle sysfs to show current_governor and current_driver in
read-only mode. More elaborate available_governors and available_drivers with
writeable current_governor and current_driver interface only appear with
"cpuidle_sysfs_switch" boot parameter.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.22-rc-mm/drivers/cpuidle/cpuidle.c
===================================================================
--- linux-2.6.22-rc-mm.orig/drivers/cpuidle/cpuidle.c	2007-06-05 17:52:32.000000000 -0700
+++ linux-2.6.22-rc-mm/drivers/cpuidle/cpuidle.c	2007-06-06 10:57:41.000000000 -0700
@@ -25,7 +25,6 @@
 LIST_HEAD(cpuidle_detected_devices);
 static void (*pm_idle_old)(void);
 
-
 /**
  * cpuidle_idle_call - the main idle loop
  *
Index: linux-2.6.22-rc-mm/drivers/cpuidle/sysfs.c
===================================================================
--- linux-2.6.22-rc-mm.orig/drivers/cpuidle/sysfs.c	2007-06-05 17:52:56.000000000 -0700
+++ linux-2.6.22-rc-mm/drivers/cpuidle/sysfs.c	2007-06-06 11:29:50.000000000 -0700
@@ -13,6 +13,14 @@
 
 #include "cpuidle.h"
 
+static unsigned int sysfs_switch;
+static int __init cpuidle_sysfs_setup(char *unused)
+{
+	sysfs_switch = 1;
+	return 1;
+}
+__setup("cpuidle_sysfs_switch", cpuidle_sysfs_setup);
+
 static ssize_t show_available_drivers(struct sys_device *dev, char *buf)
 {
 	ssize_t i = 0;
@@ -127,6 +135,15 @@
 	return count;
 }
 
+static SYSDEV_ATTR(current_driver_ro, 0444, show_current_driver, NULL);
+static SYSDEV_ATTR(current_governor_ro, 0444, show_current_governor, NULL);
+
+static struct attribute *cpuclass_default_attrs[] = {
+	&attr_current_driver_ro.attr,
+	&attr_current_governor_ro.attr,
+	NULL
+};
+
 static SYSDEV_ATTR(available_drivers, 0444, show_available_drivers, NULL);
 static SYSDEV_ATTR(available_governors, 0444, show_available_governors, NULL);
 static SYSDEV_ATTR(current_driver, 0644, show_current_driver,
@@ -134,7 +151,7 @@
 static SYSDEV_ATTR(current_governor, 0644, show_current_governor,
 	store_current_governor);
 
-static struct attribute *cpuclass_default_attrs[] = {
+static struct attribute *cpuclass_switch_attrs[] = {
 	&attr_available_drivers.attr,
 	&attr_available_governors.attr,
 	&attr_current_driver.attr,
@@ -152,6 +169,9 @@
  */
 int cpuidle_add_class_sysfs(struct sysdev_class *cls)
 {
+	if (sysfs_switch)
+		cpuclass_attr_group.attrs = cpuclass_switch_attrs;
+
 	return sysfs_create_group(&cls->kset.kobj, &cpuclass_attr_group);
 }
 
