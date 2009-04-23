Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbZDWQmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbZDWQmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 12:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757005AbZDWQma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 12:42:30 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:52876 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756908AbZDWQm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 12:42:28 -0400
Subject: [PATCH] Add armflash support for multiple blocks of flash
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Russell King <linux@arm.linux.org.uk>
Date: Thu, 23 Apr 2009 17:41:10 +0100
Message-ID: <20090423164110.31264.42300.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.369.gbbd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Apr 2009 16:41:54.0604 (UTC) FILETIME=[6903DEC0:01C9C432]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds MTD concatenation support to integrator-flash.c for
platforms with more than one block of flash memory (e.g. RealView
PB11MPCore). The implementation is based on the sa1100-flash.c one.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/mtd/maps/integrator-flash.c |  226 +++++++++++++++++++++++++----------
 1 files changed, 164 insertions(+), 62 deletions(-)

diff --git a/drivers/mtd/maps/integrator-flash.c b/drivers/mtd/maps/integrator-flash.c
index c9681a3..b08a798 100644
--- a/drivers/mtd/maps/integrator-flash.c
+++ b/drivers/mtd/maps/integrator-flash.c
@@ -36,27 +36,33 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/map.h>
 #include <linux/mtd/partitions.h>
+#include <linux/mtd/concat.h>
 
 #include <asm/mach/flash.h>
 #include <mach/hardware.h>
 #include <asm/system.h>
 
-#ifdef CONFIG_ARCH_P720T
-#define FLASH_BASE		(0x04000000)
-#define FLASH_SIZE		(64*1024*1024)
-#endif
+#define SUBDEV_NAME_SIZE	(BUS_ID_SIZE + 2)
 
-struct armflash_info {
+struct armflash_subdev_info {
+	char			name[SUBDEV_NAME_SIZE];
+	struct mtd_info		*mtd;
+	struct map_info		map;
 	struct flash_platform_data *plat;
+};
+
+struct armflash_info {
 	struct resource		*res;
 	struct mtd_partition	*parts;
 	struct mtd_info		*mtd;
-	struct map_info		map;
+	int			nr_subdev;
+	struct armflash_subdev_info subdev[0];
 };
 
 static void armflash_set_vpp(struct map_info *map, int on)
 {
-	struct armflash_info *info = container_of(map, struct armflash_info, map);
+	struct armflash_subdev_info *info =
+		container_of(map, struct armflash_subdev_info, map);
 
 	if (info->plat && info->plat->set_vpp)
 		info->plat->set_vpp(on);
@@ -64,32 +70,17 @@ static void armflash_set_vpp(struct map_info *map, int on)
 
 static const char *probes[] = { "cmdlinepart", "RedBoot", "afs", NULL };
 
-static int armflash_probe(struct platform_device *dev)
+static int armflash_subdev_probe(struct armflash_subdev_info *subdev,
+				 struct resource *res)
 {
-	struct flash_platform_data *plat = dev->dev.platform_data;
-	struct resource *res = dev->resource;
-	unsigned int size = res->end - res->start + 1;
-	struct armflash_info *info;
-	int err;
+	struct flash_platform_data *plat = subdev->plat;
+	resource_size_t size = res->end - res->start + 1;
 	void __iomem *base;
+	int err = 0;
 
-	info = kzalloc(sizeof(struct armflash_info), GFP_KERNEL);
-	if (!info) {
-		err = -ENOMEM;
-		goto out;
-	}
-
-	info->plat = plat;
-	if (plat && plat->init) {
-		err = plat->init();
-		if (err)
-			goto no_resource;
-	}
-
-	info->res = request_mem_region(res->start, size, "armflash");
-	if (!info->res) {
+	if (!request_mem_region(res->start, size, subdev->name)) {
 		err = -EBUSY;
-		goto no_resource;
+		goto out;
 	}
 
 	base = ioremap(res->start, size);
@@ -101,27 +92,132 @@ static int armflash_probe(struct platform_device *dev)
 	/*
 	 * look for CFI based flash parts fitted to this board
 	 */
-	info->map.size		= size;
-	info->map.bankwidth	= plat->width;
-	info->map.phys		= res->start;
-	info->map.virt		= base;
-	info->map.name		= dev_name(&dev->dev);
-	info->map.set_vpp	= armflash_set_vpp;
+	subdev->map.size	= size;
+	subdev->map.bankwidth	= plat->width;
+	subdev->map.phys	= res->start;
+	subdev->map.virt	= base;
+	subdev->map.name	= subdev->name;
+	subdev->map.set_vpp	= armflash_set_vpp;
 
-	simple_map_init(&info->map);
+	simple_map_init(&subdev->map);
 
 	/*
 	 * Also, the CFI layer automatically works out what size
 	 * of chips we have, and does the necessary identification
 	 * for us automatically.
 	 */
-	info->mtd = do_map_probe(plat->map_name, &info->map);
-	if (!info->mtd) {
+	subdev->mtd = do_map_probe(plat->map_name, &subdev->map);
+	if (!subdev->mtd) {
 		err = -ENXIO;
 		goto no_device;
 	}
 
-	info->mtd->owner = THIS_MODULE;
+	subdev->mtd->owner = THIS_MODULE;
+
+	/* Successful? */
+	if (err == 0)
+		return err;
+
+	if (subdev->mtd)
+		map_destroy(subdev->mtd);
+ no_device:
+	iounmap(base);
+ no_mem:
+	release_mem_region(res->start, size);
+ out:
+	return err;
+}
+
+static void armflash_subdev_remove(struct armflash_subdev_info *subdev)
+{
+	if (subdev->mtd)
+		map_destroy(subdev->mtd);
+	if (subdev->map.virt)
+		iounmap(subdev->map.virt);
+	release_mem_region(subdev->map.phys, subdev->map.size);
+}
+
+static int armflash_probe(struct platform_device *dev)
+{
+	struct flash_platform_data *plat = dev->dev.platform_data;
+	unsigned int size;
+	struct armflash_info *info;
+	int i, nr, err;
+
+	/* Count the number of devices */
+	for (nr = 0; ; nr++)
+		if (!platform_get_resource(dev, IORESOURCE_MEM, nr))
+			break;
+	if (nr == 0) {
+		err = -ENODEV;
+		goto out;
+	}
+
+	size = sizeof(struct armflash_info) +
+		sizeof(struct armflash_subdev_info) * nr;
+	info = kzalloc(size, GFP_KERNEL);
+	if (!info) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	if (plat && plat->init) {
+		err = plat->init();
+		if (err)
+			goto no_resource;
+	}
+
+	for (i = 0; i < nr; i++) {
+		struct armflash_subdev_info *subdev = &info->subdev[i];
+		struct resource *res;
+
+		res = platform_get_resource(dev, IORESOURCE_MEM, i);
+		if (!res)
+			break;
+
+		if (nr == 1)
+			/* No MTD concatenation, just use the default name */
+			snprintf(subdev->name, SUBDEV_NAME_SIZE, "%s",
+				 dev_name(&dev->dev));
+		else
+			snprintf(subdev->name, SUBDEV_NAME_SIZE, "%s-%d",
+				 dev_name(&dev->dev), i);
+		subdev->plat = plat;
+
+		err = armflash_subdev_probe(subdev, res);
+		if (err)
+			break;
+	}
+	info->nr_subdev = i;
+
+	if (err)
+		goto subdev_err;
+
+	if (info->nr_subdev == 1)
+		info->mtd = info->subdev[0].mtd;
+	else if (info->nr_subdev > 1) {
+#ifdef CONFIG_MTD_CONCAT
+		struct mtd_info *cdev[info->nr_subdev];
+
+		/*
+		 * We detected multiple devices.  Concatenate them together.
+		 */
+		for (i = 0; i < info->nr_subdev; i++)
+			cdev[i] = info->subdev[i].mtd;
+
+		info->mtd = mtd_concat_create(cdev, info->nr_subdev,
+					      dev_name(&dev->dev));
+		if (info->mtd == NULL)
+			err = -ENXIO;
+#else
+		printk(KERN_ERR "armflash: multiple devices found but "
+		       "MTD concat support disabled.\n");
+		err = -ENXIO;
+#endif
+	}
+
+	if (err < 0)
+		goto cleanup;
 
 	err = parse_mtd_partitions(info->mtd, probes, &info->parts, 0);
 	if (err > 0) {
@@ -131,28 +227,30 @@ static int armflash_probe(struct platform_device *dev)
 			       "mtd partition registration failed: %d\n", err);
 	}
 
-	if (err == 0)
+	if (err == 0) {
 		platform_set_drvdata(dev, info);
+		return err;
+	}
 
 	/*
-	 * If we got an error, free all resources.
+	 * We got an error, free all resources.
 	 */
-	if (err < 0) {
-		if (info->mtd) {
-			del_mtd_partitions(info->mtd);
-			map_destroy(info->mtd);
-		}
-		kfree(info->parts);
-
- no_device:
-		iounmap(base);
- no_mem:
-		release_mem_region(res->start, size);
- no_resource:
-		if (plat && plat->exit)
-			plat->exit();
-		kfree(info);
+ cleanup:
+	if (info->mtd) {
+		del_mtd_partitions(info->mtd);
+#ifdef CONFIG_MTD_CONCAT
+		if (info->mtd != info->subdev[0].mtd)
+			mtd_concat_destroy(info->mtd);
+#endif
 	}
+	kfree(info->parts);
+ subdev_err:
+	for (i = info->nr_subdev - 1; i >= 0; i--)
+		armflash_subdev_remove(&info->subdev[i]);
+ no_resource:
+	if (plat && plat->exit)
+		plat->exit();
+	kfree(info);
  out:
 	return err;
 }
@@ -160,22 +258,26 @@ static int armflash_probe(struct platform_device *dev)
 static int armflash_remove(struct platform_device *dev)
 {
 	struct armflash_info *info = platform_get_drvdata(dev);
+	struct flash_platform_data *plat = dev->dev.platform_data;
+	int i;
 
 	platform_set_drvdata(dev, NULL);
 
 	if (info) {
 		if (info->mtd) {
 			del_mtd_partitions(info->mtd);
-			map_destroy(info->mtd);
+#ifdef CONFIG_MTD_CONCAT
+			if (info->mtd != info->subdev[0].mtd)
+				mtd_concat_destroy(info->mtd);
+#endif
 		}
 		kfree(info->parts);
 
-		iounmap(info->map.virt);
-		release_resource(info->res);
-		kfree(info->res);
+		for (i = info->nr_subdev - 1; i >= 0; i--)
+			armflash_subdev_remove(&info->subdev[i]);
 
-		if (info->plat && info->plat->exit)
-			info->plat->exit();
+		if (plat && plat->exit)
+			plat->exit();
 
 		kfree(info);
 	}

