Return-Path: <linux-kernel-owner+w=401wt.eu-S1760764AbXH0Vnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760764AbXH0Vnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932589AbXH0Va2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:30:28 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:58891 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932749AbXH0VaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:30:04 -0400
Date: Mon, 27 Aug 2007 23:30:02 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mike Miller <mike.miller@hp.com>, Jens Axboe <jens.axboe@oracle.com>
Cc: iss_storagedev@hp.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/block/cciss.c: fix check-after-use
Message-ID: <20070827213002.GL26410@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted that we have already oops'ed if "disk"
was NULL.

Since "disk" being NULL seems impossible at this point this patch 
removes the NULL check.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Mike Miller <mike.miller@hp.com>

---

This patch has been sent on:
- 31 Jul 2007

 drivers/block/cciss.c |   56 ++++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 29 deletions(-)

--- linux-2.6.23-rc1-mm1/drivers/block/cciss.c.old	2007-07-30 02:27:15.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/block/cciss.c	2007-07-30 02:28:28.000000000 +0200
@@ -1569,66 +1569,64 @@ static int deregister_disk(struct gendis
 	ctlr_info_t *h = get_host(disk);
 
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
 	/* make sure logical volume is NOT is use */
 	if (clear_all || (h->gendisk[0] == disk)) {
 		if (drv->usage_count > 1)
 			return -EBUSY;
 	} else if (drv->usage_count > 0)
 		return -EBUSY;
 
 	/* invalidate the devices and deregister the disk.  If it is disk
 	 * zero do not deregister it but just zero out it's values.  This
 	 * allows us to delete disk zero but keep the controller registered.
 	 */
 	if (h->gendisk[0] != disk) {
-		if (disk) {
-			struct request_queue *q = disk->queue;
-			if (disk->flags & GENHD_FL_UP)
-				del_gendisk(disk);
-			if (q) {
-				blk_cleanup_queue(q);
-				/* Set drv->queue to NULL so that we do not try
-				 * to call blk_start_queue on this queue in the
-				 * interrupt handler
-				 */
-				drv->queue = NULL;
-			}
-			/* If clear_all is set then we are deleting the logical
-			 * drive, not just refreshing its info.  For drives
-			 * other than disk 0 we will call put_disk.  We do not
-			 * do this for disk 0 as we need it to be able to
-			 * configure the controller.
+		struct request_queue *q = disk->queue;
+		if (disk->flags & GENHD_FL_UP)
+			del_gendisk(disk);
+		if (q) {
+			blk_cleanup_queue(q);
+			/* Set drv->queue to NULL so that we do not try
+			 * to call blk_start_queue on this queue in the
+			 * interrupt handler
+			 */
+			drv->queue = NULL;
+		}
+		/* If clear_all is set then we are deleting the logical
+		 * drive, not just refreshing its info.  For drives
+		 * other than disk 0 we will call put_disk.  We do not
+		 * do this for disk 0 as we need it to be able to
+		 * configure the controller.
+		*/
+		if (clear_all){
+			/* This isn't pretty, but we need to find the
+			 * disk in our array and NULL our the pointer.
+			 * This is so that we will call alloc_disk if
+			 * this index is used again later.
 			*/
-			if (clear_all){
-				/* This isn't pretty, but we need to find the
-				 * disk in our array and NULL our the pointer.
-				 * This is so that we will call alloc_disk if
-				 * this index is used again later.
-				*/
-				for (i=0; i < CISS_MAX_LUN; i++){
-					if(h->gendisk[i] == disk){
-						h->gendisk[i] = NULL;
-						break;
-					}
+			for (i=0; i < CISS_MAX_LUN; i++){
+				if(h->gendisk[i] == disk){
+					h->gendisk[i] = NULL;
+					break;
 				}
-				put_disk(disk);
 			}
+			put_disk(disk);
 		}
 	} else {
 		set_capacity(disk, 0);
 	}
 
 	--h->num_luns;
 	/* zero out the disk size info */
 	drv->nr_blocks = 0;
 	drv->block_size = 0;
 	drv->heads = 0;
 	drv->sectors = 0;
 	drv->cylinders = 0;
 	drv->raid_level = -1;	/* This can be used as a flag variable to
 				 * indicate that this element of the drive
 				 * array is free.
 				 */
 


