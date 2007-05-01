Return-Path: <linux-kernel-owner+w=401wt.eu-S1946575AbXEAFIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946575AbXEAFIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 01:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946593AbXEAFIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 01:08:31 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:42600 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946575AbXEAFI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 01:08:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:subject:mime-version:content-type:content-transfer-encoding;
        b=Wgoc7IV9RBVh75NcmGUcKyjXO/xj+fmlcJw5ercBHXnODxlLHCrTFtO0Dz0gJ50w2VcMKm2GxSmHFqr2oKEgfUNRNv1za12vqLGgdj1n6iXJST3VvTOILsxArkXUbrQCNBBsKFds3Z+hpctvrsH6PqxmxrQl1/1GRrjsMcjB0PY=
Date: Tue, 1 May 2007 08:08:27 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <181733600.20070501080827@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC, PATCH 1/4] SoC base drivers: SoC helper API
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello linux-kernel,

soc-core: Helper API for SoC base drivers to register/unregister
subdevices.

Signed-off-by: Paul Sokolovsky <pmiscml@gmail.com>


 arch/arm/Kconfig       |    2 +
 drivers/Makefile       |    1 +
 drivers/soc/soc-core.c |  106 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/soc/soc-core.h |   30 +++++++++++++
 include/linux/ioport.h |    3 +
 5 files changed, 142 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e7baca2..da7d318 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -997,6 +997,8 @@ source "drivers/mmc/Kconfig"
 
 source "drivers/rtc/Kconfig"
 
+source "drivers/soc/Kconfig"
+
 endmenu
 
 source "fs/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 920c975..3fb8cf1 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -80,3 +80,4 @@ obj-$(CONFIG_GENERIC_TIME)	+= clocksource/
 obj-$(CONFIG_DMA_ENGINE)	+= dma/
 obj-$(CONFIG_HID)		+= hid/
 obj-$(CONFIG_PPC_PS3)		+= ps3/
+obj-y				+= soc/
diff --git a/drivers/soc/soc-core.c b/drivers/soc/soc-core.c
new file mode 100644
index 0000000..24c654c
--- /dev/null
+++ b/drivers/soc/soc-core.c
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
+		res = kzalloc (blk->num_resources * sizeof (struct resource), GFP_KERNEL);
+		if (!res)
+			goto fail;
+
+		for (r = 0 ; r < blk->num_resources ; r++) {
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
diff --git a/drivers/soc/soc-core.h b/drivers/soc/soc-core.h
new file mode 100644
index 0000000..8659f7e
--- /dev/null
+++ b/drivers/soc/soc-core.h
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
index 6859a3b..65f0fcd 100644
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
Best regards,
 Paul                          mailto:pmiscml@gmail.com

