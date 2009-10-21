Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbZJUOsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbZJUOsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 10:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbZJUOr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 10:47:59 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54898 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbZJUOr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 10:47:58 -0400
Message-ID: <4ADF1F04.2070300@austin.ibm.com>
Date: Wed, 21 Oct 2009 09:47:32 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5 v4] Kernel Handling of cpu DLPAR
References: <4ADF1C49.2030201@austin.ibm.com>
In-Reply-To: <4ADF1C49.2030201@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the capability to DLPAR add and remove CPUs from the kernel. The
creates two new files /sys/devices/system/cpu/probe and 
/sys/devices/system/cpu/release to handle the DLPAR addition and removal of
CPUs respectively.

CPU DLPAR add is accomplished by writing the drc-index of the CPU to the
probe file, and removal is done by writing the device-tree path of the cpu
to the release file.

Signed-off-by: Nathan Fontenot <nfont at austin.ibm.com>
---
Index: powerpc/arch/powerpc/platforms/pseries/dlpar.c
===================================================================
--- powerpc.orig/arch/powerpc/platforms/pseries/dlpar.c	2009-10-19 11:59:43.000000000 -0500
+++ powerpc/arch/powerpc/platforms/pseries/dlpar.c	2009-10-19 11:59:48.000000000 -0500
@@ -1,11 +1,10 @@
 /*
- * dlpar.c - support for dynamic reconfiguration (including PCI
- * Hotplug and Dynamic Logical Partitioning on RPA platforms).
+ * Support for dynamic reconfiguration (including PCI, Memory, and CPU
+ * Hotplug and Dynamic Logical Partitioning on PAPR platforms).
  *
  * Copyright (C) 2009 Nathan Fontenot
  * Copyright (C) 2009 IBM Corporation
  *
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License version
  * 2 as published by the Free Software Foundation.
@@ -19,7 +18,7 @@
 #include <linux/memory_hotplug.h>
 #include <linux/sysdev.h>
 #include <linux/sysfs.h>
-
+#include <linux/cpu.h>
 
 #include <asm/prom.h>
 #include <asm/machdep.h>
@@ -408,6 +407,82 @@
 	return 0;
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+static ssize_t cpu_probe_store(struct class *class, const char *buf,
+			       size_t count)
+{
+	struct device_node *dn;
+	unsigned long drc_index;
+	char *cpu_name;
+	int rc;
+
+	rc = strict_strtoul(buf, 0, &drc_index);
+	if (rc)
+		return -EINVAL;
+
+	rc = acquire_drc(drc_index);
+	if (rc)
+		return -EINVAL;
+
+	dn = configure_connector(drc_index);
+	if (!dn) {
+		release_drc(drc_index);
+		return -EINVAL;
+	}
+
+	/* fixup dn name */
+	cpu_name = kzalloc(strlen(dn->full_name) + strlen("/cpus/") + 1,
+			   GFP_KERNEL);
+	if (!cpu_name) {
+		free_cc_nodes(dn);
+		release_drc(drc_index);
+		return -ENOMEM;
+	}
+
+	sprintf(cpu_name, "/cpus/%s", dn->full_name);
+	kfree(dn->full_name);
+	dn->full_name = cpu_name;
+
+	rc = add_device_tree_nodes(dn);
+	if (rc)
+		release_drc(drc_index);
+
+	return rc ? -EINVAL : count;
+}
+
+static ssize_t cpu_release_store(struct class *class, const char *buf,
+				 size_t count)
+{
+	struct device_node *dn;
+	const u32 *drc_index;
+	int rc;
+
+	dn = of_find_node_by_path(buf);
+	if (!dn)
+		return -EINVAL;
+
+	drc_index = of_get_property(dn, "ibm,my-drc-index", NULL);
+	if (!drc_index) {
+		of_node_put(dn);
+		return -EINVAL;
+	}
+
+	rc = release_drc(*drc_index);
+	if (rc) {
+		of_node_put(dn);
+		return -EINVAL;
+	}
+
+	rc = remove_device_tree_nodes(dn);
+	if (rc)
+		acquire_drc(*drc_index);
+
+	of_node_put(dn);
+	return rc ? -EINVAL : count;
+}
+
+#endif /* CONFIG_HOTPLUG_CPU */
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 
 static struct property *clone_property(struct property *old_prop)
@@ -574,6 +649,13 @@
 
 static struct class_attribute class_attr_mem_release =
 			__ATTR(release, S_IWUSR, NULL, memory_release_store);
+#endif /* CONFIG_MEMORY_HOTPLUG */
+
+#ifdef CONFIG_HOTPLUG_CPU
+static struct class_attribute class_attr_cpu_probe =
+			__ATTR(probe, S_IWUSR, NULL, cpu_probe_store);
+static struct class_attribute class_attr_cpu_release =
+			__ATTR(release, S_IWUSR, NULL, cpu_release_store);
 #endif
 
 static int pseries_dlpar_init(void)
@@ -588,6 +670,18 @@
 		       "release file\n");
 #endif
 
+#ifdef CONFIG_HOTPLUG_CPU
+	if (sysfs_create_file(&cpu_sysdev_class.kset.kobj,
+			      &class_attr_cpu_probe.attr))
+		printk(KERN_INFO "DLPAR: Could not create sysfs cpu "
+		       "probe file\n");
+
+	if (sysfs_create_file(&cpu_sysdev_class.kset.kobj,
+			      &class_attr_cpu_release.attr))
+		printk(KERN_INFO "DLPAR: Could not create sysfs cpu "
+		       "release file\n");
+#endif
+
 	return 0;
 }
 device_initcall(pseries_dlpar_init);

