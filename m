Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbYKJP6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbYKJP6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 10:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbYKJP6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 10:58:04 -0500
Received: from atlantis.8hz.com ([212.129.237.78]:60241 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbYKJP6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 10:58:02 -0500
Date: Mon, 10 Nov 2008 15:58:00 +0000
From: Sean Young <sean@mess.org>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/mtd/rfd_ftl.c: implement discard
Message-ID: <20081110155800.GA13908@atlantis.8hz.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that discard is supported implement it in RFD FTL. Also stop writing to
flash once an error has been detected and various other cleanups.

Signed-off-by: Sean Young <sean@mess.org>
--
diff --git a/drivers/mtd/rfd_ftl.c b/drivers/mtd/rfd_ftl.c
index e538c0a..0d028b5 100644
--- a/drivers/mtd/rfd_ftl.c
+++ b/drivers/mtd/rfd_ftl.c
@@ -1,7 +1,7 @@
 /*
  * rfd_ftl.c -- resident flash disk (flash translation layer)
  *
- * Copyright (C) 2005  Sean Young <sean@mess.org>
+ * Copyright (C) 2005, 2008  Sean Young <sean@mess.org>
  *
  * This type of flash translation layer (FTL) is used by the Embedded BIOS
  * by General Software. It is known as the Resident Flash Disk (RFD), see:
@@ -241,7 +241,7 @@ err:
 
 static int rfd_ftl_readsect(struct mtd_blktrans_dev *dev, u_long sector, char *buf)
 {
-	struct partition *part = (struct partition*)dev;
+	struct partition *part = container_of(dev, struct partition, mbd);
 	u_long addr;
 	size_t retlen;
 	int rc;
@@ -293,6 +293,7 @@ static void erase_callback(struct erase_info *erase)
 		part->blocks[i].used_sectors = 0;
 
 		kfree(erase);
+		part->errors++;
 
 		return;
 	}
@@ -317,6 +318,7 @@ static void erase_callback(struct erase_info *erase)
 				part->mbd.mtd->name,
 				part->blocks[i].offset);
 		part->blocks[i].state = BLOCK_FAILED;
+		part->errors++;
 	}
 	else
 		part->blocks[i].state = BLOCK_OK;
@@ -349,6 +351,7 @@ static int erase_block(struct partition *part, int block)
 				"failed\n", erase->addr, erase->len,
 				part->mbd.mtd->name);
 		kfree(erase);
+		part->errors++;
 	}
 
 err:
@@ -383,7 +386,7 @@ static int move_block_contents(struct partition *part, int block_no, u_long *old
 		printk(KERN_ERR PREFIX "error reading '%s' at "
 			"0x%lx\n", part->mbd.mtd->name,
 			part->blocks[block_no].offset);
-
+		part->errors++;
 		goto err;
 	}
 
@@ -423,7 +426,7 @@ static int move_block_contents(struct partition *part, int block_no, u_long *old
 			printk(KERN_ERR PREFIX "'%s': Unable to "
 				"read sector for relocation\n",
 				part->mbd.mtd->name);
-
+			part->errors++;
 			goto err;
 		}
 
@@ -604,9 +607,10 @@ static int mark_sector_deleted(struct partition *part, u_long old_addr)
 	if (rc) {
 		printk(KERN_ERR PREFIX "error writing '%s' at "
 			"0x%lx\n", part->mbd.mtd->name, addr);
-		if (rc)
-			goto err;
+		part->errors++;
+		goto err;
 	}
+
 	if (block == part->current_block)
 		part->header_cache[offset + HEADER_MAP_OFFSET] = del;
 
@@ -639,9 +643,10 @@ static int find_free_sector(const struct partition *part, const struct block *bl
 	return -1;
 }
 
-static int do_writesect(struct mtd_blktrans_dev *dev, u_long sector, char *buf, ulong *old_addr)
+static int do_writesect(struct mtd_blktrans_dev *dev, u_long sector, char *buf,
+							 u_long *old_addr)
 {
-	struct partition *part = (struct partition*)dev;
+	struct partition *part = container_of(dev, struct partition, mbd);
 	struct block *block;
 	u_long addr;
 	int i;
@@ -677,8 +682,8 @@ static int do_writesect(struct mtd_blktrans_dev *dev, u_long sector, char *buf,
 	if (rc) {
 		printk(KERN_ERR PREFIX "error writing '%s' at 0x%lx\n",
 				part->mbd.mtd->name, addr);
-		if (rc)
-			goto err;
+		part->errors++;
+		goto err;
 	}
 
 	part->sector_map[sector] = addr;
@@ -697,8 +702,8 @@ static int do_writesect(struct mtd_blktrans_dev *dev, u_long sector, char *buf,
 	if (rc) {
 		printk(KERN_ERR PREFIX "error writing '%s' at 0x%lx\n",
 				part->mbd.mtd->name, addr);
-		if (rc)
-			goto err;
+		part->errors++;
+		goto err;
 	}
 	block->used_sectors++;
 	block->free_sectors--;
@@ -709,14 +714,14 @@ err:
 
 static int rfd_ftl_writesect(struct mtd_blktrans_dev *dev, u_long sector, char *buf)
 {
-	struct partition *part = (struct partition*)dev;
+	struct partition *part = container_of(dev, struct partition, mbd);
 	u_long old_addr;
 	int i;
 	int rc = 0;
 
 	pr_debug("rfd_ftl_writesect(sector=0x%lx)\n", sector);
 
-	if (part->reserved_block == -1) {
+	if (part->reserved_block == -1 || part->errors) {
 		rc = -EACCES;
 		goto err;
 	}
@@ -750,7 +755,7 @@ err:
 
 static int rfd_ftl_getgeo(struct mtd_blktrans_dev *dev, struct hd_geometry *geo)
 {
-	struct partition *part = (struct partition*)dev;
+	struct partition *part = container_of(dev, struct partition, mbd);
 
 	geo->heads = 1;
 	geo->sectors = SECTORS_PER_TRACK;
@@ -759,6 +764,30 @@ static int rfd_ftl_getgeo(struct mtd_blktrans_dev *dev, struct hd_geometry *geo)
 	return 0;
 }
 
+static int rfd_ftl_discardsect(struct mtd_blktrans_dev *dev, u_long sector,
+								uint nr_sects)
+{
+	struct partition *part = container_of(dev, struct partition, mbd);
+	u_long addr;
+	int rc;
+
+	if (part->errors)
+		return -EACCES;
+
+	for (rc = 0; nr_sects && rc == 0; sector++, nr_sects--) {
+		if (sector >= part->sector_count)
+			return -EIO;
+
+		addr = part->sector_map[sector];
+		part->sector_map[sector] = -1;
+
+		if (addr != -1)
+			rc = mark_sector_deleted(part, addr);
+	}
+
+	return rc;
+}
+
 static void rfd_ftl_add_mtd(struct mtd_blktrans_ops *tr, struct mtd_info *mtd)
 {
 	struct partition *part;
@@ -806,7 +835,7 @@ out:
 
 static void rfd_ftl_remove_dev(struct mtd_blktrans_dev *dev)
 {
-	struct partition *part = (struct partition*)dev;
+	struct partition *part = container_of(dev, struct partition, mbd);
 	int i;
 
 	for (i=0; i<part->total_blocks; i++) {
@@ -829,6 +858,7 @@ static struct mtd_blktrans_ops rfd_ftl_tr = {
 
 	.readsect	= rfd_ftl_readsect,
 	.writesect	= rfd_ftl_writesect,
+	.discard	= rfd_ftl_discardsect,
 	.getgeo		= rfd_ftl_getgeo,
 	.add_mtd	= rfd_ftl_add_mtd,
 	.remove_dev	= rfd_ftl_remove_dev,
