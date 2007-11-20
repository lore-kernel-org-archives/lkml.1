Return-Path: <linux-kernel-owner+w=401wt.eu-S1763458AbXKTVIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763458AbXKTVIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758742AbXKTVIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:08:37 -0500
Received: from outmail1.freedom2surf.net ([194.106.33.237]:41515 "EHLO
	outmail1.freedom2surf.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbXKTVIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:08:36 -0500
Subject: [patch] 1/4 Support for Toshiba TMIO multifunction devices
From: ian <spyro@f2s.com>
To: ARM Linux <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-obDbIuiVzW+uurG+mkVi"
Date: Tue, 20 Nov 2007 20:43:57 +0000
Message-Id: <1195591437.2329.56.camel@wirenth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-obDbIuiVzW+uurG+mkVi
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi guys.

This patchset contains support for three toshiba multifunction devices.

This patch introduces some useful library functions that handle common
features in this type of MFD - local memory and IRQ resources.

--=-obDbIuiVzW+uurG+mkVi
Content-Disposition: attachment; filename*0=0001-Reuseable-SOC-core-code-suitable-for-multifunction-c.pat; filename*1=ch
Content-Type: application/mbox; name=0001-Reuseable-SOC-core-code-suitable-for-multifunction-c.patch
Content-Transfer-Encoding: 7bit

>From fb782eebf5ff9ca7b519b6541d7dcebb01723529 Mon Sep 17 00:00:00 2001
From: Ian Molton <spyro@f2s.com>
Date: Tue, 20 Nov 2007 16:36:13 +0000
Subject: [PATCH] Reuseable SOC core code suitable for multifunction chips with
 built in IRQ multiplexing and local RAM.

---
 drivers/mfd/soc-core.c |  106 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/soc-core.h |   30 +++++++++++++
 include/linux/ioport.h |    3 +
 3 files changed, 139 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/soc-core.c
 create mode 100644 drivers/mfd/soc-core.h

diff --git a/drivers/mfd/soc-core.c b/drivers/mfd/soc-core.c
new file mode 100644
index 0000000..123c7eb
--- /dev/null
+++ b/drivers/mfd/soc-core.c
@@ -0,0 +1,106 @@
+/*
+ * drivers/soc/soc-core.c
+ *
+ * core SoC support
+ * Copyright (c) 2006 Ian Molton
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This file contains functionality used by many SoC type devices.
+ *
+ * Created: 2006-11-28
+ *
+ */
+
+#include <linux/ioport.h>
+#include <linux/slab.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include "soc-core.h"
+
+void soc_free_devices(struct platform_device *devices, int nr_devs)
+{
+	struct platform_device *dev = devices;
+	int i;
+
+	for (i = 0; i < nr_devs; i++) {
+		struct resource *res = dev->resource;
+		platform_device_unregister(dev++);
+		kfree(res);
+	}
+	kfree(devices);
+}
+EXPORT_SYMBOL_GPL(soc_free_devices);
+
+#define SIGNED_SHIFT(val, shift) ((shift) >= 0 ? ((val) << (shift)) : ((val) >> -(shift)))
+
+struct platform_device *soc_add_devices(struct platform_device *dev,
+					struct soc_device_data *soc, int nr_devs,
+					struct resource *mem,
+					int relative_addr_shift, int irq_base)
+{
+	struct platform_device *devices;
+	int i, r, base;
+
+	devices = kzalloc(nr_devs * sizeof(struct platform_device), GFP_KERNEL);
+	if (!devices)
+		return NULL;
+
+	for (i = 0; i < nr_devs; i++) {
+		struct platform_device *sdev = &devices[i];
+		struct soc_device_data *blk = &soc[i];
+		struct resource *res;
+
+		sdev->id = -1;
+		sdev->name = blk->name;
+
+		sdev->dev.parent = &dev->dev;
+		sdev->dev.platform_data = (void *)blk->hwconfig;
+		sdev->num_resources = blk->num_resources;
+
+		/* Allocate space for the subdevice resources */
+		res = kzalloc(blk->num_resources * sizeof (struct resource), GFP_KERNEL);
+		if (!res)
+			goto fail;
+
+		for (r = 0; r < blk->num_resources; r++) {
+			res[r].name = blk->res[r].name; // Fixme - should copy
+
+			/* Find out base to use */
+			base = 0;
+			if (blk->res[r].flags & IORESOURCE_MEM) {
+				base = mem->start;
+			} else if ((blk->res[r].flags & IORESOURCE_IRQ) &&
+				(blk->res[r].flags & IORESOURCE_IRQ_SOC_SUBDEVICE)) {
+				base = irq_base;
+			}
+
+			/* Adjust resource */
+			if (blk->res[r].flags & IORESOURCE_MEM) {
+				res[r].parent = mem;
+				res[r].start = base + SIGNED_SHIFT(blk->res[r].start, relative_addr_shift);
+				res[r].end   = base + SIGNED_SHIFT(blk->res[r].end,   relative_addr_shift);
+			} else {
+				res[r].start = base + blk->res[r].start;
+				res[r].end   = base + blk->res[r].end;
+			}
+			res[r].flags = blk->res[r].flags;
+		}
+
+		sdev->resource = res;
+		if (platform_device_register(sdev)) {
+			kfree(res);
+			goto fail;
+		}
+
+		printk(KERN_INFO "SoC: registering %s\n", blk->name);
+	}
+	return devices;
+
+fail:
+	soc_free_devices(devices, i + 1);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(soc_add_devices);
diff --git a/drivers/mfd/soc-core.h b/drivers/mfd/soc-core.h
new file mode 100644
index 0000000..8659f7e
--- /dev/null
+++ b/drivers/mfd/soc-core.h
@@ -0,0 +1,30 @@
+/*
+ * drivers/soc/soc-core.h
+ *
+ * core SoC support
+ * Copyright (c) 2006 Ian Molton
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This file contains prototypes for the functions in soc-core.c
+ *
+ * Created: 2006-11-28
+ *
+ */
+
+struct soc_device_data {
+	char *name;
+	struct resource *res;
+	int num_resources;
+	void *hwconfig; /* platform_data to pass to the subdevice */
+};
+
+struct platform_device *soc_add_devices(struct platform_device *dev,
+					struct soc_device_data *soc, int n_devs,
+					struct resource *mem,
+					int relative_addr_shift, int irq_base);
+
+void soc_free_devices(struct platform_device *devices, int nr_devs);
+
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 6187a85..8681708 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -57,6 +57,9 @@ struct resource_list {
 #define IORESOURCE_IRQ_LOWLEVEL		(1<<3)
 #define IORESOURCE_IRQ_SHAREABLE	(1<<4)
 
+/* SoC device IRQ specific bits (IORESOURCE_BITS) */
+#define IORESOURCE_IRQ_SOC_SUBDEVICE    (1<<5)
+
 /* ISA PnP DMA specific bits (IORESOURCE_BITS) */
 #define IORESOURCE_DMA_TYPE_MASK	(3<<0)
 #define IORESOURCE_DMA_8BIT		(0<<0)
-- 
1.5.3.5.737.gdee1b


--=-obDbIuiVzW+uurG+mkVi--

