Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbYKLO5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbYKLO5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 09:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbYKLO5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 09:57:30 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:55399 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbYKLO53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 09:57:29 -0500
Date: Wed, 12 Nov 2008 23:57:33 +0900 (JST)
Message-Id: <20081112.235733.01917391.anemo@mba.ocn.ne.jp>
To: linux-mtd@lists.infradead.org
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] physmap: Fix leak of memory returned by
 parse_mtd_partitions
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

The mtd partition parser returns an allocated pointer array of
mtd_partition.  The caller must free it.  The array is used only for
add_mtd_partitions(), so free it just after the call.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/mtd/maps/physmap.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
index 7ca048d..cc26b41 100644
--- a/drivers/mtd/maps/physmap.c
+++ b/drivers/mtd/maps/physmap.c
@@ -29,7 +29,6 @@ struct physmap_flash_info {
 	struct map_info		map[MAX_RESOURCES];
 #ifdef CONFIG_MTD_PARTITIONS
 	int			nr_parts;
-	struct mtd_partition	*parts;
 #endif
 };
 
@@ -56,14 +55,10 @@ static int physmap_flash_remove(struct platform_device *dev)
 	for (i = 0; i < MAX_RESOURCES; i++) {
 		if (info->mtd[i] != NULL) {
 #ifdef CONFIG_MTD_PARTITIONS
-			if (info->nr_parts) {
+			if (info->nr_parts || physmap_data->nr_parts)
 				del_mtd_partitions(info->mtd[i]);
-				kfree(info->parts);
-			} else if (physmap_data->nr_parts) {
-				del_mtd_partitions(info->mtd[i]);
-			} else {
+			else
 				del_mtd_device(info->mtd[i]);
-			}
 #else
 			del_mtd_device(info->mtd[i]);
 #endif
@@ -86,6 +81,9 @@ static int physmap_flash_probe(struct platform_device *dev)
 	int err = 0;
 	int i;
 	int devices_found = 0;
+#ifdef CONFIG_MTD_PARTITIONS
+	struct mtd_partition *parts;
+#endif
 
 	physmap_data = dev->dev.platform_data;
 	if (physmap_data == NULL)
@@ -166,9 +164,10 @@ static int physmap_flash_probe(struct platform_device *dev)
 		goto err_out;
 
 #ifdef CONFIG_MTD_PARTITIONS
-	err = parse_mtd_partitions(info->cmtd, part_probe_types, &info->parts, 0);
+	err = parse_mtd_partitions(info->cmtd, part_probe_types, &parts, 0);
 	if (err > 0) {
-		add_mtd_partitions(info->cmtd, info->parts, err);
+		add_mtd_partitions(info->cmtd, parts, err);
+		kfree(parts);
 		return 0;
 	}
 
-- 
1.5.6.3
