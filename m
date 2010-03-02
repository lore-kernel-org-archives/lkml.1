Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab0CBX7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:59:35 -0500
Received: from kroah.org ([198.145.64.141]:38512 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129Ab0CBX3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:14 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/62] sysdev: Convert node driver
Date: Tue,  2 Mar 2010 15:28:09 -0800
Message-Id: <1267572541-410-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>

Use sysdev_class attribute arrays in node driver

Convert the node driver to sysdev_class attribute arrays. This
greatly cleans up the code and remove a lot of code.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/cpu.c |   57 +++++++++++++++------------------------------------
 1 files changed, 17 insertions(+), 40 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index b04ecfc..fb456b7 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -13,8 +13,11 @@
 
 #include "base.h"
 
+static struct sysdev_class_attribute *cpu_sysdev_class_attrs[];
+
 struct sysdev_class cpu_sysdev_class = {
 	.name = "cpu",
+	.attrs = cpu_sysdev_class_attrs,
 };
 EXPORT_SYMBOL(cpu_sysdev_class);
 
@@ -90,20 +93,6 @@ static ssize_t cpu_release_store(struct class *class, const char *buf,
 
 static CLASS_ATTR(probe, S_IWUSR, NULL, cpu_probe_store);
 static CLASS_ATTR(release, S_IWUSR, NULL, cpu_release_store);
-
-int __init cpu_probe_release_init(void)
-{
-	int rc;
-
-	rc = sysfs_create_file(&cpu_sysdev_class.kset.kobj,
-			       &class_attr_probe.attr);
-	if (!rc)
-		rc = sysfs_create_file(&cpu_sysdev_class.kset.kobj,
-				       &class_attr_release.attr);
-
-	return rc;
-}
-device_initcall(cpu_probe_release_init);
 #endif /* CONFIG_ARCH_CPU_PROBE_RELEASE */
 
 #else /* ... !CONFIG_HOTPLUG_CPU */
@@ -162,6 +151,7 @@ static ssize_t show_cpus_attr(struct sysdev_class *class,
 #define _CPU_ATTR(name, map)						\
 	{ _SYSDEV_CLASS_ATTR(name, 0444, show_cpus_attr, NULL), map }
 
+/* Keep in sync with cpu_sysdev_class_attrs */
 static struct cpu_attr cpu_attrs[] = {
 	_CPU_ATTR(online, &cpu_online_mask),
 	_CPU_ATTR(possible, &cpu_possible_mask),
@@ -212,29 +202,6 @@ static ssize_t print_cpus_offline(struct sysdev_class *class,
 }
 static SYSDEV_CLASS_ATTR(offline, 0444, print_cpus_offline, NULL);
 
-static struct sysdev_class_attribute *cpu_state_attr[] = {
-	&cpu_attrs[0].attr,
-	&cpu_attrs[1].attr,
-	&cpu_attrs[2].attr,
-	&attr_kernel_max,
-	&attr_offline,
-};
-
-static int cpu_states_init(void)
-{
-	int i;
-	int err = 0;
-
-	for (i = 0;  i < ARRAY_SIZE(cpu_state_attr); i++) {
-		int ret;
-		ret = sysdev_class_create_file(&cpu_sysdev_class,
-						cpu_state_attr[i]);
-		if (!err)
-			err = ret;
-	}
-	return err;
-}
-
 /*
  * register_cpu - Setup a sysfs device for a CPU.
  * @cpu - cpu->hotpluggable field set to 1 will generate a control file in
@@ -280,9 +247,6 @@ int __init cpu_dev_init(void)
 	int err;
 
 	err = sysdev_class_register(&cpu_sysdev_class);
-	if (!err)
-		err = cpu_states_init();
-
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
 	if (!err)
 		err = sched_create_sysfs_power_savings_entries(&cpu_sysdev_class);
@@ -290,3 +254,16 @@ int __init cpu_dev_init(void)
 
 	return err;
 }
+
+static struct sysdev_class_attribute *cpu_sysdev_class_attrs[] = {
+#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
+	&class_attr_probe.attr,
+	&class_attr_release.attr,
+#endif
+	&cpu_attrs[0].attr,
+	&cpu_attrs[1].attr,
+	&cpu_attrs[2].attr,
+	&attr_kernel_max,
+	&attr_offline,
+	NULL
+};
-- 
1.7.0.1

