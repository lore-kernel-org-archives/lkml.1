Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbYJAHl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbYJAHl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 03:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbYJAHkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 03:40:19 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:22187 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbYJAHkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 03:40:18 -0400
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: jens.axboe@oracle.com, neilb@suse.de, agk@sourceware.org
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3/7] block: Switch blk_integrity_compare from bdev to gendisk
Date: Wed,  1 Oct 2008 03:38:39 -0400
Message-Id: <1222846723-18213-4-git-send-email-martin.petersen@oracle.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com>
References: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DM and MD integrity support now depends on being able to use
gendisks instead of block_devices when comparing integrity profiles.
Change function parameters accordingly.

Also update comparison logic so that two NULL profiles are a valid
configuration.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-integrity.c  |   28 ++++++++++++++--------------
 include/linux/blkdev.h |    2 +-
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index e3817a0..61a8e2f 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -108,51 +108,51 @@ new_segment:
 EXPORT_SYMBOL(blk_rq_map_integrity_sg);
 
 /**
- * blk_integrity_compare - Compare integrity profile of two block devices
- * @bd1:	Device to compare
- * @bd2:	Device to compare
+ * blk_integrity_compare - Compare integrity profile of two disks
+ * @gd1:	Disk to compare
+ * @gd2:	Disk to compare
  *
  * Description: Meta-devices like DM and MD need to verify that all
  * sub-devices use the same integrity format before advertising to
  * upper layers that they can send/receive integrity metadata.  This
- * function can be used to check whether two block devices have
+ * function can be used to check whether two gendisk devices have
  * compatible integrity formats.
  */
-int blk_integrity_compare(struct block_device *bd1, struct block_device *bd2)
+int blk_integrity_compare(struct gendisk *gd1, struct gendisk *gd2)
 {
-	struct blk_integrity *b1 = bd1->bd_disk->integrity;
-	struct blk_integrity *b2 = bd2->bd_disk->integrity;
+	struct blk_integrity *b1 = gd1->integrity;
+	struct blk_integrity *b2 = gd2->integrity;
 
-	BUG_ON(bd1->bd_disk == NULL);
-	BUG_ON(bd2->bd_disk == NULL);
+	if (!b1 && !b2)
+		return 0;
 
 	if (!b1 || !b2)
-		return 0;
+		return -1;
 
 	if (b1->sector_size != b2->sector_size) {
 		printk(KERN_ERR "%s: %s/%s sector sz %u != %u\n", __func__,
-		       bd1->bd_disk->disk_name, bd2->bd_disk->disk_name,
+		       gd1->disk_name, gd2->disk_name,
 		       b1->sector_size, b2->sector_size);
 		return -1;
 	}
 
 	if (b1->tuple_size != b2->tuple_size) {
 		printk(KERN_ERR "%s: %s/%s tuple sz %u != %u\n", __func__,
-		       bd1->bd_disk->disk_name, bd2->bd_disk->disk_name,
+		       gd1->disk_name, gd2->disk_name,
 		       b1->tuple_size, b2->tuple_size);
 		return -1;
 	}
 
 	if (b1->tag_size && b2->tag_size && (b1->tag_size != b2->tag_size)) {
 		printk(KERN_ERR "%s: %s/%s tag sz %u != %u\n", __func__,
-		       bd1->bd_disk->disk_name, bd2->bd_disk->disk_name,
+		       gd1->disk_name, gd2->disk_name,
 		       b1->tag_size, b2->tag_size);
 		return -1;
 	}
 
 	if (strcmp(b1->name, b2->name)) {
 		printk(KERN_ERR "%s: %s/%s type %s != %s\n", __func__,
-		       bd1->bd_disk->disk_name, bd2->bd_disk->disk_name,
+		       gd1->disk_name, gd2->disk_name,
 		       b1->name, b2->name);
 		return -1;
 	}
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 30c4292..eec0842 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1010,7 +1010,7 @@ struct blk_integrity {
 
 extern int blk_integrity_register(struct gendisk *, struct blk_integrity *);
 extern void blk_integrity_unregister(struct gendisk *);
-extern int blk_integrity_compare(struct block_device *, struct block_device *);
+extern int blk_integrity_compare(struct gendisk *, struct gendisk *);
 extern int blk_rq_map_integrity_sg(struct request *, struct scatterlist *);
 extern int blk_rq_count_integrity_sg(struct request *);
 
-- 
1.6.0.2

