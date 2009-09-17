Return-Path: <linux-kernel-owner+w=401wt.eu-S1760011AbZIQSqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011AbZIQSqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759820AbZIQSqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:46:53 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:20580 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759215AbZIQSqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:46:50 -0400
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 06/20] cciss: Rearrange logical drive sysfs code to make the
	"changing a disk" path work.
To: akpm@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       andrew.patterson@hp.com, mikem@beardog.cce.hp.com,
       scameron@beardog.cce.hp.com
Date: Thu, 17 Sep 2009 13:47:19 -0500
Message-ID: <20090917184719.15105.55779.stgit@beardog.cce.hp.com>
In-Reply-To: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
References: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rearrange logical drive sysfs code to make the "changing a disk" path work.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/block/cciss.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 4f9ef49..557b958 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1915,9 +1915,10 @@ static int cciss_add_gendisk(ctlr_info_t *h, __u32 lunid, int controller_node)
 		}
 	}
 	h->drv[drv_index].LunID = lunid;
-	if (cciss_create_ld_sysfs_entry(h, drv_index))
-		goto err_free_disk;
-
+	if (h->drv[drv_index].dev == NULL) {
+		if (cciss_create_ld_sysfs_entry(h, drv_index))
+			goto err_free_disk;
+	}
 	/* Don't need to mark this busy because nobody */
 	/* else knows about this disk yet to contend */
 	/* for access to it. */
@@ -2144,8 +2145,10 @@ static int deregister_disk(ctlr_info_t *h, int drv_index,
 	 */
 	if (h->gendisk[0] != disk) {
 		struct request_queue *q = disk->queue;
-		if (disk->flags & GENHD_FL_UP)
+		if (disk->flags & GENHD_FL_UP) {
+			cciss_destroy_ld_sysfs_entry(h, drv_index);
 			del_gendisk(disk);
+		}
 		if (q) {
 			blk_cleanup_queue(q);
 			/* Set drv->queue to NULL so that we do not try
@@ -2189,7 +2192,6 @@ static int deregister_disk(ctlr_info_t *h, int drv_index,
 				 * indicate that this element of the drive
 				 * array is free.
 				 */
-	cciss_destroy_ld_sysfs_entry(h, drv_index);
 
 	if (clear_all) {
 		/* check to see if it was the last disk */
@@ -4307,15 +4309,13 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
 		if (disk) {
 			struct request_queue *q = disk->queue;
 
-			if (disk->flags & GENHD_FL_UP)
+			if (disk->flags & GENHD_FL_UP) {
+				cciss_destroy_ld_sysfs_entry(hba[i], j);
 				del_gendisk(disk);
+			}
 			if (q)
 				blk_cleanup_queue(q);
 		}
-		if (hba[i]->drv[j].dev != NULL &&
-			(j == 0 || hba[i]->drv[j].raid_level != -1))
-				cciss_destroy_ld_sysfs_entry(hba[i], j);
-
 	}
 
 #ifdef CONFIG_CISS_SCSI_TAPE

