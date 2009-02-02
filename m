Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbZBBQBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbZBBQBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 11:01:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZBBQB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 11:01:26 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:50183 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbZBBQBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 11:01:25 -0500
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: linux-mips@linux-mips.org
Cc: ralf@linux-mips.org, linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] MTD: RBTX4939 map driver (v2)
Date: Tue,  3 Feb 2009 01:01:28 +0900
Message-Id: <1233590488-5165-2-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a map driver for NOR flash chips on RBTX4939 board.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
Changes since v1:
* fix wrong free of mtd_partition parsed by cmdlinepart.

 drivers/mtd/maps/Kconfig          |    6 +
 drivers/mtd/maps/Makefile         |    1 +
 drivers/mtd/maps/rbtx4939-flash.c |  208 +++++++++++++++++++++++++++++++++++++
 3 files changed, 215 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mtd/maps/rbtx4939-flash.c

diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index 0225cbb..162f32b 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -542,6 +542,12 @@ config MTD_INTEL_VR_NOR
 	  Map driver for a NOR flash bank located on the Expansion Bus of the
 	  Intel Vermilion Range chipset.
 
+config MTD_RBTX4939
+	tristate "Map driver for RBTX4939 board"
+	depends on TOSHIBA_RBTX4939 && MTD_CFI && MTD_COMPLEX_MAPPINGS
+	help
+	  Map driver for NOR flash chips on RBTX4939 board.
+
 config MTD_PLATRAM
 	tristate "Map driver for platform device RAM (mtd-ram)"
 	select MTD_RAM
diff --git a/drivers/mtd/maps/Makefile b/drivers/mtd/maps/Makefile
index 6d9ba35..f53a7dc 100644
--- a/drivers/mtd/maps/Makefile
+++ b/drivers/mtd/maps/Makefile
@@ -61,3 +61,4 @@ obj-$(CONFIG_MTD_PLATRAM)	+= plat-ram.o
 obj-$(CONFIG_MTD_OMAP_NOR)	+= omap_nor.o
 obj-$(CONFIG_MTD_INTEL_VR_NOR)	+= intel_vr_nor.o
 obj-$(CONFIG_MTD_BFIN_ASYNC)	+= bfin-async-flash.o
+obj-$(CONFIG_MTD_RBTX4939)	+= rbtx4939-flash.o
diff --git a/drivers/mtd/maps/rbtx4939-flash.c b/drivers/mtd/maps/rbtx4939-flash.c
new file mode 100644
index 0000000..d39f0ad
--- /dev/null
+++ b/drivers/mtd/maps/rbtx4939-flash.c
@@ -0,0 +1,208 @@
+/*
+ * rbtx4939-flash (based on physmap.c)
+ *
+ * This is a simplified physmap driver with map_init callback function.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Copyright (C) 2009 Atsushi Nemoto <anemo@mba.ocn.ne.jp>
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/map.h>
+#include <linux/mtd/partitions.h>
+#include <asm/txx9/rbtx4939.h>
+
+struct rbtx4939_flash_info {
+	struct mtd_info *mtd;
+	struct map_info map;
+#ifdef CONFIG_MTD_PARTITIONS
+	int nr_parts;
+	struct mtd_partition *parts;
+#endif
+};
+
+static int rbtx4939_flash_remove(struct platform_device *dev)
+{
+	struct rbtx4939_flash_info *info;
+
+	info = platform_get_drvdata(dev);
+	if (!info)
+		return 0;
+	platform_set_drvdata(dev, NULL);
+
+	if (info->mtd) {
+#ifdef CONFIG_MTD_PARTITIONS
+		struct rbtx4939_flash_data *pdata = dev->dev.platform_data;
+
+		if (info->nr_parts) {
+			del_mtd_partitions(info->mtd);
+			kfree(info->parts);
+		} else if (pdata->nr_parts)
+			del_mtd_partitions(info->mtd);
+		else
+			del_mtd_device(info->mtd);
+#else
+		del_mtd_device(info->mtd);
+#endif
+		map_destroy(info->mtd);
+	}
+	return 0;
+}
+
+static const char *rom_probe_types[] = { "cfi_probe", "jedec_probe", NULL };
+#ifdef CONFIG_MTD_PARTITIONS
+static const char *part_probe_types[] = { "cmdlinepart", NULL };
+#endif
+
+static int rbtx4939_flash_probe(struct platform_device *dev)
+{
+	struct rbtx4939_flash_data *pdata;
+	struct rbtx4939_flash_info *info;
+	struct resource *res;
+	const char **probe_type;
+	int err = 0;
+	unsigned long size;
+
+	pdata = dev->dev.platform_data;
+	if (!pdata)
+		return -ENODEV;
+
+	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+	info = devm_kzalloc(&dev->dev, sizeof(struct rbtx4939_flash_info),
+			    GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	platform_set_drvdata(dev, info);
+
+	size = resource_size(res);
+	pr_notice("rbtx4939 platform flash device: %pR\n", res);
+
+	if (!devm_request_mem_region(&dev->dev, res->start, size,
+				     dev_name(&dev->dev)))
+		return -EBUSY;
+
+	info->map.name = dev_name(&dev->dev);
+	info->map.phys = res->start;
+	info->map.size = size;
+	info->map.bankwidth = pdata->width;
+
+	info->map.virt = devm_ioremap(&dev->dev, info->map.phys, size);
+	if (!info->map.virt)
+		return -EBUSY;
+
+	if (pdata->map_init)
+		(*pdata->map_init)(&info->map);
+	else
+		simple_map_init(&info->map);
+
+	probe_type = rom_probe_types;
+	for (; !info->mtd && *probe_type; probe_type++)
+		info->mtd = do_map_probe(*probe_type, &info->map);
+	if (!info->mtd) {
+		dev_err(&dev->dev, "map_probe failed\n");
+		err = -ENXIO;
+		goto err_out;
+	}
+	info->mtd->owner = THIS_MODULE;
+	if (err)
+		goto err_out;
+
+#ifdef CONFIG_MTD_PARTITIONS
+	err = parse_mtd_partitions(info->mtd, part_probe_types,
+				&info->parts, 0);
+	if (err > 0) {
+		add_mtd_partitions(info->mtd, info->parts, err);
+		info->nr_parts = err;
+		return 0;
+	}
+
+	if (pdata->nr_parts) {
+		pr_notice("Using rbtx4939 partition information\n");
+		add_mtd_partitions(info->mtd, pdata->parts, pdata->nr_parts);
+		return 0;
+	}
+#endif
+
+	add_mtd_device(info->mtd);
+	return 0;
+
+err_out:
+	rbtx4939_flash_remove(dev);
+	return err;
+}
+
+#ifdef CONFIG_PM
+static int rbtx4939_flash_suspend(struct platform_device *dev,
+				  pm_message_t state)
+{
+	struct rbtx4939_flash_info *info = platform_get_drvdata(dev);
+
+	if (info->mtd->suspend)
+		return info->mtd->suspend(info->mtd);
+	return 0;
+}
+
+static int rbtx4939_flash_resume(struct platform_device *dev)
+{
+	struct rbtx4939_flash_info *info = platform_get_drvdata(dev);
+
+	if (info->mtd->resume)
+		info->mtd->resume(info->mtd);
+	return 0;
+}
+
+static void rbtx4939_flash_shutdown(struct platform_device *dev)
+{
+	struct rbtx4939_flash_info *info = platform_get_drvdata(dev);
+
+	if (info->mtd->suspend && info->mtd->resume)
+		if (info->mtd->suspend(info->mtd) == 0)
+			info->mtd->resume(info->mtd);
+}
+#else
+#define rbtx4939_flash_suspend NULL
+#define rbtx4939_flash_resume NULL
+#define rbtx4939_flash_shutdown NULL
+#endif
+
+static struct platform_driver rbtx4939_flash_driver = {
+	.probe		= rbtx4939_flash_probe,
+	.remove		= rbtx4939_flash_remove,
+	.suspend	= rbtx4939_flash_suspend,
+	.resume		= rbtx4939_flash_resume,
+	.shutdown	= rbtx4939_flash_shutdown,
+	.driver		= {
+		.name	= "rbtx4939-flash",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init rbtx4939_flash_init(void)
+{
+	return platform_driver_register(&rbtx4939_flash_driver);
+}
+
+static void __exit rbtx4939_flash_exit(void)
+{
+	platform_driver_unregister(&rbtx4939_flash_driver);
+}
+
+module_init(rbtx4939_flash_init);
+module_exit(rbtx4939_flash_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("RBTX4939 MTD map driver");
+MODULE_ALIAS("platform:rbtx4939-flash");
-- 
1.5.6.3

