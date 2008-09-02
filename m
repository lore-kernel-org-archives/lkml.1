Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbYIBTvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbYIBTvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 15:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbYIBTt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 15:49:58 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:14027 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbYIBTt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 15:49:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=epNTt82l+fkKJpBVYEm/Hda7CvQmkm1WkgyGf04vi2zkEJhTmvHGZd9+MN+XkzC4HU
         kKrHC+OgZj1w7tgw/GFvP2q+TnvGKvpEi3+eiSO/Ya/kHs31UODxkNLbxQl/IUuWJd0f
         s6/ck3unig9k08BY+lsGx9YlG/ojLpxtaMVII=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 02 Sep 2008 21:47:48 +0200
Message-Id: <20080902194748.14564.73545.sendpatchset@localhost.localdomain>
In-Reply-To: <20080902194711.14564.63625.sendpatchset@localhost.localdomain>
References: <20080902194711.14564.63625.sendpatchset@localhost.localdomain>
Subject: [PATCH 6/8] ide: cleanup ide_build_dmatable()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- use for_each_sg()
- move printing 'DMA table too small' message below use_pio_instead label
- merge '64KB bug' comment with function documentation
- fix intendation

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c |   71 ++++++++++++++++++++------------------------------
 1 file changed, 29 insertions(+), 42 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -153,8 +153,11 @@ EXPORT_SYMBOL_GPL(ide_build_sglist);
  *
  *	ide_build_dmatable() prepares a dma request. We map the command
  *	to get the pci bus addresses of the buffers and then build up
- *	the PRD table that the IDE layer wants to be fed. The code
- *	knows about the 64K wrap bug in the CS5530.
+ *	the PRD table that the IDE layer wants to be fed.
+ *
+ *	Most chipsets correctly interpret a length of 0x0000 as 64KB,
+ *	but at least one (e.g. CS5530) misinterprets it as zero (!).
+ *	So we break the 64KB entry into two 32KB entries instead.
  *
  *	Returns the number of built PRD entries if all went okay,
  *	returns 0 otherwise.
@@ -171,15 +174,12 @@ int ide_build_dmatable (ide_drive_t *dri
 	int i;
 	struct scatterlist *sg;
 
-	hwif->sg_nents = i = ide_build_sglist(drive, rq);
-
-	if (!i)
+	hwif->sg_nents = ide_build_sglist(drive, rq);
+	if (hwif->sg_nents == 0)
 		return 0;
 
-	sg = hwif->sg_table;
-	while (i) {
-		u32 cur_addr;
-		u32 cur_len;
+	for_each_sg(hwif->sg_table, sg, hwif->sg_nents, i) {
+		u32 cur_addr, cur_len, xcount, bcount;
 
 		cur_addr = sg_dma_address(sg);
 		cur_len = sg_dma_len(sg);
@@ -191,40 +191,27 @@ int ide_build_dmatable (ide_drive_t *dri
 		 */
 
 		while (cur_len) {
-			if (count++ >= PRD_ENTRIES) {
-				printk(KERN_ERR "%s: DMA table too small\n", drive->name);
+			if (count++ >= PRD_ENTRIES)
 				goto use_pio_instead;
-			} else {
-				u32 xcount, bcount = 0x10000 - (cur_addr & 0xffff);
 
-				if (bcount > cur_len)
-					bcount = cur_len;
-				*table++ = cpu_to_le32(cur_addr);
-				xcount = bcount & 0xffff;
-				if (is_trm290)
-					xcount = ((xcount >> 2) - 1) << 16;
-				if (xcount == 0x0000) {
-	/* 
-	 * Most chipsets correctly interpret a length of 0x0000 as 64KB,
-	 * but at least one (e.g. CS5530) misinterprets it as zero (!).
-	 * So here we break the 64KB entry into two 32KB entries instead.
-	 */
-					if (count++ >= PRD_ENTRIES) {
-						printk(KERN_ERR "%s: DMA table too small\n", drive->name);
-						goto use_pio_instead;
-					}
-					*table++ = cpu_to_le32(0x8000);
-					*table++ = cpu_to_le32(cur_addr + 0x8000);
-					xcount = 0x8000;
-				}
-				*table++ = cpu_to_le32(xcount);
-				cur_addr += bcount;
-				cur_len -= bcount;
+			bcount = 0x10000 - (cur_addr & 0xffff);
+			if (bcount > cur_len)
+				bcount = cur_len;
+			*table++ = cpu_to_le32(cur_addr);
+			xcount = bcount & 0xffff;
+			if (is_trm290)
+				xcount = ((xcount >> 2) - 1) << 16;
+			if (xcount == 0x0000) {
+				if (count++ >= PRD_ENTRIES)
+					goto use_pio_instead;
+				*table++ = cpu_to_le32(0x8000);
+				*table++ = cpu_to_le32(cur_addr + 0x8000);
+				xcount = 0x8000;
 			}
+			*table++ = cpu_to_le32(xcount);
+			cur_addr += bcount;
+			cur_len -= bcount;
 		}
-
-		sg = sg_next(sg);
-		i--;
 	}
 
 	if (count) {
@@ -233,14 +220,14 @@ int ide_build_dmatable (ide_drive_t *dri
 		return count;
 	}
 
-	printk(KERN_ERR "%s: empty DMA table?\n", drive->name);
-
 use_pio_instead:
+	printk(KERN_ERR "%s: %s\n", drive->name,
+		count ? "DMA table too small" : "empty DMA table?");
+
 	ide_destroy_dmatable(drive);
 
 	return 0; /* revert to PIO for this request */
 }
-
 EXPORT_SYMBOL_GPL(ide_build_dmatable);
 #endif
 
