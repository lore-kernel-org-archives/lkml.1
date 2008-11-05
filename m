Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbYKEO1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbYKEO1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 09:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbYKEO1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 09:27:07 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:58685 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbYKEO1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 09:27:06 -0500
Date: Wed, 05 Nov 2008 23:27:10 +0900 (JST)
Message-Id: <20081105.232710.95062153.anemo@mba.ocn.ne.jp>
To: linux-mtd@lists.infradead.org
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] physmap: Fix memory leak on physmap_flash_remove by using
 devres
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

physmap_flash_remove releases only last memory region.  This causes
memory leak if multiple resources were provided.

This patch fixes this leakage by using devm_ functions.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/mtd/maps/physmap.c |   26 +++++++++-----------------
 1 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
index 42d844f..dfbf3f2 100644
--- a/drivers/mtd/maps/physmap.c
+++ b/drivers/mtd/maps/physmap.c
@@ -19,7 +19,7 @@
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/physmap.h>
 #include <linux/mtd/concat.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 #define MAX_RESOURCES		4
 
@@ -27,7 +27,6 @@ struct physmap_flash_info {
 	struct mtd_info		*mtd[MAX_RESOURCES];
 	struct mtd_info		*cmtd;
 	struct map_info		map[MAX_RESOURCES];
-	struct resource		*res;
 #ifdef CONFIG_MTD_PARTITIONS
 	int			nr_parts;
 	struct mtd_partition	*parts;
@@ -70,16 +69,7 @@ static int physmap_flash_remove(struct platform_device *dev)
 #endif
 			map_destroy(info->mtd[i]);
 		}
-
-		if (info->map[i].virt != NULL)
-			iounmap(info->map[i].virt);
-	}
-
-	if (info->res != NULL) {
-		release_resource(info->res);
-		kfree(info->res);
 	}
-
 	return 0;
 }
 
@@ -101,7 +91,8 @@ static int physmap_flash_probe(struct platform_device *dev)
 	if (physmap_data == NULL)
 		return -ENODEV;
 
-	info = kzalloc(sizeof(struct physmap_flash_info), GFP_KERNEL);
+	info = devm_kzalloc(&dev->dev, sizeof(struct physmap_flash_info),
+			    GFP_KERNEL);
 	if (info == NULL) {
 		err = -ENOMEM;
 		goto err_out;
@@ -114,10 +105,10 @@ static int physmap_flash_probe(struct platform_device *dev)
 		       (unsigned long long)(dev->resource[i].end - dev->resource[i].start + 1),
 		       (unsigned long long)dev->resource[i].start);
 
-		info->res = request_mem_region(dev->resource[i].start,
-					       dev->resource[i].end - dev->resource[i].start + 1,
-					       dev->dev.bus_id);
-		if (info->res == NULL) {
+		if (!devm_request_mem_region(&dev->dev,
+			dev->resource[i].start,
+			dev->resource[i].end - dev->resource[i].start + 1,
+			dev->dev.bus_id)) {
 			dev_err(&dev->dev, "Could not reserve memory region\n");
 			err = -ENOMEM;
 			goto err_out;
@@ -129,7 +120,8 @@ static int physmap_flash_probe(struct platform_device *dev)
 		info->map[i].bankwidth = physmap_data->width;
 		info->map[i].set_vpp = physmap_data->set_vpp;
 
-		info->map[i].virt = ioremap(info->map[i].phys, info->map[i].size);
+		info->map[i].virt = devm_ioremap(&dev->dev, info->map[i].phys,
+						 info->map[i].size);
 		if (info->map[i].virt == NULL) {
 			dev_err(&dev->dev, "Failed to ioremap flash region\n");
 			err = EIO;
-- 
1.5.6.3

