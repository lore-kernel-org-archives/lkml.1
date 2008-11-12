Return-Path: <linux-kernel-owner+w=401wt.eu-S1757866AbYKLXmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866AbYKLXmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757382AbYKLXjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:39:52 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:58707 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757091AbYKLXju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:39:50 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mtd/physmap: use parse_mtd()
Date: Wed, 12 Nov 2008 18:39:48 -0500
Message-Id: <1226533189-8492-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1226533133-7405-1-git-send-email-vapier@gentoo.org>
References: <1226533133-7405-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call parse_mtd() to handle partition/device registration rather than doing
it all ourself.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/mtd/maps/physmap.c |   21 +--------------------
 1 files changed, 1 insertions(+), 20 deletions(-)

diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
index 42d844f..9b87fd8 100644
--- a/drivers/mtd/maps/physmap.c
+++ b/drivers/mtd/maps/physmap.c
@@ -84,9 +84,6 @@ static int physmap_flash_remove(struct platform_device *dev)
 }
 
 static const char *rom_probe_types[] = { "cfi_probe", "jedec_probe", "map_rom", NULL };
-#ifdef CONFIG_MTD_PARTITIONS
-static const char *part_probe_types[] = { "cmdlinepart", "RedBoot", NULL };
-#endif
 
 static int physmap_flash_probe(struct platform_device *dev)
 {
@@ -170,23 +167,7 @@ static int physmap_flash_probe(struct platform_device *dev)
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
+	return parse_mtd(info->cmtd, NULL, physmap_data->parts, physmap_data->nr_parts);
 
 err_out:
 	physmap_flash_remove(dev);
-- 
1.6.0.3

