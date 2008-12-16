Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYLPUYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYLPUYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758747AbYLPUTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:19:25 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:30368 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758735AbYLPUTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:19:23 -0500
Date: Tue, 16 Dec 2008 14:19:22 -0600
From: scameron@beardog.cca.cpqcorp.net
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, akpm@linux-foundation.org,
       mikem@roadking.cca.cpqcorp.net
Subject: [patch] cciss: Simplify parameters to deregister_disk function.
Message-ID: <20081216201922.GM1126@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Simplify parameters to deregister_disk function.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
---

 drivers/block/cciss.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/block/cciss.c~cciss_simplify_deregister_disk_params drivers/block/cciss.c
--- linux-2.6.28-rc8/drivers/block/cciss.c~cciss_simplify_deregister_disk_params	2008-12-16 14:01:51.000000000 -0600
+++ linux-2.6.28-rc8-root/drivers/block/cciss.c	2008-12-16 14:01:51.000000000 -0600
@@ -164,7 +164,7 @@ static int cciss_getgeo(struct block_dev
 
 static int cciss_revalidate(struct gendisk *disk);
 static int rebuild_lun_table(ctlr_info_t *h, int first_time);
-static int deregister_disk(struct gendisk *disk, drive_info_struct *drv,
+static int deregister_disk(ctlr_info_t *h, int drv_index,
 			   int clear_all);
 
 static void cciss_read_capacity(int ctlr, int logvol, int withirq,
@@ -1492,8 +1492,7 @@ static void cciss_update_drive_info(int 
 		 * which keeps the interrupt handler from starting
 		 * the queue.
 		 */
-		ret = deregister_disk(h->gendisk[drv_index],
-				      &h->drv[drv_index], 0);
+		ret = deregister_disk(h, drv_index, 0);
 		h->drv[drv_index].busy_configuring = 0;
 	}
 
@@ -1711,8 +1710,7 @@ static int rebuild_lun_table(ctlr_info_t
 			spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
 			h->drv[i].busy_configuring = 1;
 			spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
-			return_code = deregister_disk(h->gendisk[i],
-				&h->drv[i], 1);
+			return_code = deregister_disk(h, i, 1);
 			h->drv[i].busy_configuring = 0;
 		}
 	}
@@ -1782,15 +1780,19 @@ mem_msg:
  *             the highest_lun should be left unchanged and the LunID
  *             should not be cleared.
 */
-static int deregister_disk(struct gendisk *disk, drive_info_struct *drv,
+static int deregister_disk(ctlr_info_t *h, int drv_index,
 			   int clear_all)
 {
 	int i;
-	ctlr_info_t *h = get_host(disk);
+	struct gendisk *disk;
+	drive_info_struct *drv;
 
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
+	drv = &h->drv[drv_index];
+	disk = h->gendisk[drv_index];
+
 	/* make sure logical volume is NOT is use */
 	if (clear_all || (h->gendisk[0] == disk)) {
 		if (drv->usage_count > 1)
_
