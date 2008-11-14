Return-Path: <linux-kernel-owner+w=401wt.eu-S1751618AbYKNMXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbYKNMXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 07:23:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYKNMWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 07:22:51 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:52810 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbYKNMWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 07:22:50 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: [PATCH v2] mtd/physmap: use parse_mtd()
Date: Fri, 14 Nov 2008 07:22:48 -0500
Message-Id: <1226665369-20248-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1226665351-20226-1-git-send-email-vapier@gentoo.org>
References: <1226665351-20226-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call parse_mtd() to handle partition/device registration rather than doing
it all ourself.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v2:
	- call unparse_mtd()
	- delete local nr_parts/parts in physmap_flash_info

 drivers/mtd/maps/physmap.c |   39 +++------------------------------------
 1 files changed, 3 insertions(+), 36 deletions(-)

diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
index 42d844f..d0e11b5 100644
--- a/drivers/mtd/maps/physmap.c
+++ b/drivers/mtd/maps/physmap.c
@@ -28,10 +28,6 @@ struct physmap_flash_info {
 	struct mtd_info		*cmtd;
 	struct map_info		map[MAX_RESOURCES];
 	struct resource		*res;
-#ifdef CONFIG_MTD_PARTITIONS
-	int			nr_parts;
-	struct mtd_partition	*parts;
-#endif
 };
 
 static int physmap_flash_remove(struct platform_device *dev)
@@ -56,18 +52,7 @@ static int physmap_flash_remove(struct platform_device *dev)
 
 	for (i = 0; i < MAX_RESOURCES; i++) {
 		if (info->mtd[i] != NULL) {
-#ifdef CONFIG_MTD_PARTITIONS
-			if (info->nr_parts) {
-				del_mtd_partitions(info->mtd[i]);
-				kfree(info->parts);
-			} else if (physmap_data->nr_parts) {
-				del_mtd_partitions(info->mtd[i]);
-			} else {
-				del_mtd_device(info->mtd[i]);
-			}
-#else
-			del_mtd_device(info->mtd[i]);
-#endif
+			unparse_mtd(info->mtd[i]);
 			map_destroy(info->mtd[i]);
 		}
 
@@ -84,9 +69,6 @@ static int physmap_flash_remove(struct platform_device *dev)
 }
 
 static const char *rom_probe_types[] = { "cfi_probe", "jedec_probe", "map_rom", NULL };
-#ifdef CONFIG_MTD_PARTITIONS
-static const char *part_probe_types[] = { "cmdlinepart", "RedBoot", NULL };
-#endif
 
 static int physmap_flash_probe(struct platform_device *dev)
 {
@@ -170,23 +152,8 @@ static int physmap_flash_probe(struct platform_device *dev)
 	if (err)
 		goto err_out;
 
-#ifdef CONFIG_MTD_PARTITIONS
-	err = parse_mtd_partitions(info->cmtd, part_probe_types, &info->parts, 0);
-	if (err > 0) {
-		add_mtd_partitions(info->cmtd, info->parts, err);
-		return 0;
-	}
-
-	if (physmap_data->nr_parts) {
-		printk(KERN_NOTICE "Using physmap partition information\n");
-		add_mtd_partitions(info->cmtd, physmap_data->parts,
-				   physmap_data->nr_parts);
-		return 0;
-	}
-#endif
-
-	add_mtd_device(info->cmtd);
-	return 0;
+	return parse_mtd(info->cmtd, NULL, physmap_data->parts,
+	                 physmap_data->nr_parts, false);
 
 err_out:
 	physmap_flash_remove(dev);
-- 
1.6.0.3

