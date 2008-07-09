Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbYGIKu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbYGIKu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 06:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbYGIKtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 06:49:39 -0400
Received: from hull.simtec.co.uk ([78.105.113.97]:42486 "EHLO
	ivanova.local.simtec.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752116AbYGIKtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 06:49:36 -0400
Message-Id: <20080709104933.101610936@fluff.org>
References: <20080709104916.200210922@fluff.org>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 11:49:20 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Cc: sameo@openedhand.com, dbaryshkov@gmail.com,
       Ben Dooks <ben-linux@fluff.org>
Subject: [patch 4/4] MFD: Change mfd platform device usage to wrapper platform_device
Content-Disposition: inline; filename=mfd-dont-use-platform-device-data-to-store-mfd.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the mfd core behaviour to wrapper the platform_device
it creates in an struct mfd_device which contains the information
about the cell that was created.

1) The creation of the resource list and then passing it to the
   platform_device_add_resources() causes the allocation of a
   large array on the stack as well as copying the source data
   twice (it is copied from the mfd_cell to the temporary array
   and then copied into the newly allocated array)

2) We can wrapper the platform_device into an mfd_device and use
   that to do the platform_device and resource allocation in one
   go to reduce the failiure.

Note, is there actually any reason to pass the sub devices any
information about the cell they are created from? The mfd core
already makes the appropriate resource adjustments and anything
else like clocks should be exported by the clock drivers?

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-rc9-next20080709/include/linux/mfd/core.h
===================================================================
--- linux-2.6.26-rc9-next20080709.orig/include/linux/mfd/core.h	2008-07-09 10:46:23.000000000 +0100
+++ linux-2.6.26-rc9-next20080709/include/linux/mfd/core.h	2008-07-09 11:14:55.000000000 +0100
@@ -18,8 +18,6 @@
 
 /*
  * This struct describes the MFD part ("cell").
- * After registration the copy of this structure will become the platform data
- * of the resulting platform_device
  */
 struct mfd_cell {
 	const char		*name;
@@ -33,9 +31,21 @@ struct mfd_cell {
 	const struct resource	*resources;
 };
 
+struct mfd_device {
+	struct platform_device	pdev;
+	struct mfd_cell		*cell;
+	struct resource		resources[0];
+};
+
+static inline struct mfd_device *to_mfd_device(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	return container_of(pdev, struct mfd_device, pdev);
+}
+
 static inline struct mfd_cell *mfd_get_cell(struct platform_device *pdev)
 {
-	return (struct mfd_cell *)pdev->dev.platform_data;
+	return container_of(pdev, struct mfd_device, pdev)->cell;
 }
 
 extern int mfd_add_devices(struct platform_device *parent,
Index: linux-2.6.26-rc9-next20080709/drivers/mfd/mfd-core.c
===================================================================
--- linux-2.6.26-rc9-next20080709.orig/drivers/mfd/mfd-core.c	2008-07-09 10:59:54.000000000 +0100
+++ linux-2.6.26-rc9-next20080709/drivers/mfd/mfd-core.c	2008-07-09 11:09:59.000000000 +0100
@@ -15,28 +15,41 @@
 #include <linux/platform_device.h>
 #include <linux/mfd/core.h>
 
+static void mfd_dev_release(struct device *dev)
+{
+	struct mfd_device *mdev = to_mfd_device(dev);
+
+	kfree(mdev);
+}
+
 static int mfd_add_device(struct platform_device *parent,
 			  const struct mfd_cell *cell,
 			  struct resource *mem_base,
 			  int irq_base)
 {
-	struct resource res[cell->num_resources];
+	struct resource *res;
+	struct mfd_device *mdev;
 	struct platform_device *pdev;
 	int ret = -ENOMEM;
 	int r;
 
-	pdev = platform_device_alloc(cell->name, parent->id);
-	if (!pdev)
+	mdev = kzalloc(sizeof(struct mfd_device) +
+		       sizeof(struct resource) * cell->num_resources,
+		       GFP_KERNEL);
+	if (!mdev)
 		goto fail_alloc;
 
-	pdev->dev.parent = &parent->dev;
+	mdev->cell = cell;
+	mdev->pdev.dev.parent = &parent->dev;
 
-	ret = platform_device_add_data(pdev,
-			cell, sizeof(struct mfd_cell));
-	if (ret)
-		goto fail_device;
+	pdev = &mdev->pdev;
+	res = &mdev->resources;
+
+	device_initialise(&pdev->dev);
+	pdev->id = parent->id;
+	pdev->name = cell->name;
+	pdev->release = mfd_device_release;
 
-	memzero(res, sizeof(res));
 	for (r = 0; r < cell->num_resources; r++) {
 		res[r].name = cell->resources[r].name;
 		res[r].flags = cell->resources[r].flags;

-- 
