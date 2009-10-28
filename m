Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794AbZJ1U7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbZJ1U7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 16:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbZJ1U7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 16:59:44 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:47139 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969AbZJ1U7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 16:59:44 -0400
Message-ID: <4AE8B0B1.4020102@austin.ibm.com>
Date: Wed, 28 Oct 2009 15:59:29 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6 v5] CPU DLPAR Handling
References: <4AE8ADCF.6090104@austin.ibm.com>
In-Reply-To: <4AE8ADCF.6090104@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register the pseries specific handler for the powerpc architecture handlers
for the cpu probe and release files.  This also implements the cpu DLPAR
addition and removal of CPUS from the system.

Signed-off-by: Nathan Fontenot <nfont at asutin.ibm.com>
---

Index: powerpc/arch/powerpc/platforms/pseries/dlpar.c
===================================================================
--- powerpc.orig/arch/powerpc/platforms/pseries/dlpar.c	2009-10-28 15:21:49.000000000 -0500
+++ powerpc/arch/powerpc/platforms/pseries/dlpar.c	2009-10-28 15:21:56.000000000 -0500
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
@@ -408,6 +407,80 @@
 	return 0;
 }
 
+#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
+static ssize_t cpu_probe(const char *buf, size_t count)
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
+static ssize_t cpu_release(const char *buf, size_t count)
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
+#endif /* CONFIG_ARCH_CPU_PROBE_RELEASE */
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 
 static struct property *clone_property(struct property *old_prop)
@@ -591,6 +664,11 @@
 	ppc_md.memory_probe = memory_probe;
 #endif
 
+#ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
+	ppc_md.cpu_release = cpu_release;
+	ppc_md.cpu_probe = cpu_probe;
+#endif
+
 	return 0;
 }
 device_initcall(pseries_dlpar_init);
