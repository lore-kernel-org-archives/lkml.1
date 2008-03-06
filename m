Return-Path: <linux-kernel-owner+w=401wt.eu-S934610AbYCFSyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934610AbYCFSyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 13:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbYCFSye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 13:54:34 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:35450 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107AbYCFSyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 13:54:33 -0500
Subject: [PATCH 3/5] [PPC] hotplug memory notifications for ppc
From: Badari Pulavarty <pbadari@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linuxppc-dev@ozlabs.org, paulus@samba.org,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1204829673.7939.59.camel@dyn9047017100.beaverton.ibm.com>
References: <1204829673.7939.59.camel@dyn9047017100.beaverton.ibm.com>
Content-Type: text/plain
Date: Thu, 06 Mar 2008 10:57:50 -0800
Message-Id: <1204829870.6272.0.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hotplug memory notifier for ppc64. This gets invoked by writing
the device-node that needs to be removed to /proc/ppc64/ofdt.
We need to adjust the sections and remove sysfs entries by
calling __remove_pages(). Then call arch specific code to
get rid of htab mappings for the section of memory.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Reviewed-by: Michael Ellerman <michael@ellerman.id.au>
---
 arch/powerpc/platforms/pseries/Makefile         |    1 
 arch/powerpc/platforms/pseries/hotplug-memory.c |   98 ++++++++++++++++++++++++
 2 files changed, 99 insertions(+)

Index: linux-2.6.25-rc2/arch/powerpc/platforms/pseries/hotplug-memory.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.25-rc2/arch/powerpc/platforms/pseries/hotplug-memory.c	2008-02-29 09:25:14.000000000 -0800
@@ -0,0 +1,98 @@
+/*
+ * pseries Memory Hotplug infrastructure.
+ *
+ * Copyright (C) 2008 Badari Pulavarty, IBM Corporation
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/of.h>
+#include <asm/firmware.h>
+#include <asm/machdep.h>
+#include <asm/pSeries_reconfig.h>
+
+static int pseries_remove_memory(struct device_node *np)
+{
+	const char *type;
+	const unsigned int *my_index;
+	const unsigned int *regs;
+	u64 start_pfn, start;
+	struct zone *zone;
+	int ret = -EINVAL;
+
+	/*
+	 * Check to see if we are actually removing memory
+	 */
+	type = of_get_property(np, "device_type", NULL);
+	if (type == NULL || strcmp(type, "memory") != 0)
+		return 0;
+
+	/*
+	 * Find the memory index and size of the removing section
+	 */
+	my_index = of_get_property(np, "ibm,my-drc-index", NULL);
+	if (!my_index)
+		return ret;
+
+	regs = of_get_property(np, "reg", NULL);
+	if (!regs)
+		return ret;
+
+	start_pfn = section_nr_to_pfn(*my_index & 0xffff);
+	zone = page_zone(pfn_to_page(start_pfn));
+
+	/*
+	 * Remove section mappings and sysfs entries for the
+	 * section of the memory we are removing.
+	 *
+	 * NOTE: Ideally, this should be done in generic code like
+	 * remove_memory(). But remove_memory() gets called by writing
+	 * to sysfs "state" file and we can't remove sysfs entries
+	 * while writing to it. So we have to defer it to here.
+	 */
+	ret = __remove_pages(zone, start_pfn, regs[3] >> PAGE_SHIFT);
+	if (ret)
+		return ret;
+
+	/*
+	 * Remove htab bolted mappings for this section of memory
+	 */
+ 	start = (unsigned long)__va(start_pfn << PAGE_SHIFT);
+ 	ret = remove_section_mapping(start, start + regs[3]);
+	return ret;
+}
+
+static int pseries_memory_notifier(struct notifier_block *nb,
+				unsigned long action, void *node)
+{
+	int err = NOTIFY_OK;
+
+	switch (action) {
+	case PSERIES_RECONFIG_ADD:
+		break;
+	case PSERIES_RECONFIG_REMOVE:
+		if (pseries_remove_memory(node))
+			err = NOTIFY_BAD;
+		break;
+	default:
+		err = NOTIFY_DONE;
+		break;
+	}
+	return err;
+}
+
+static struct notifier_block pseries_mem_nb = {
+	.notifier_call = pseries_memory_notifier,
+};
+
+static int __init pseries_memory_hotplug_init(void)
+{
+	if (firmware_has_feature(FW_FEATURE_LPAR))
+		pSeries_reconfig_notifier_register(&pseries_mem_nb);
+
+	return 0;
+}
+machine_device_initcall(pseries, pseries_memory_hotplug_init);
Index: linux-2.6.25-rc2/arch/powerpc/platforms/pseries/Makefile
===================================================================
--- linux-2.6.25-rc2.orig/arch/powerpc/platforms/pseries/Makefile	2008-02-28 08:15:53.000000000 -0800
+++ linux-2.6.25-rc2/arch/powerpc/platforms/pseries/Makefile	2008-02-28 08:17:57.000000000 -0800
@@ -14,6 +14,7 @@ obj-$(CONFIG_PCI)	+= pci.o pci_dlpar.o
 obj-$(CONFIG_PCI_MSI)	+= msi.o
 
 obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug-cpu.o
+obj-$(CONFIG_MEMORY_HOTPLUG)	+= hotplug-memory.o
 
 obj-$(CONFIG_HVC_CONSOLE)	+= hvconsole.o
 obj-$(CONFIG_HVCS)		+= hvcserver.o


