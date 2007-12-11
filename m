Return-Path: <linux-kernel-owner+w=401wt.eu-S1758319AbXLKWtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbXLKWtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758130AbXLKWsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:48:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758644AbXLKWse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:48:34 -0500
Date: Tue, 11 Dec 2007 17:47:36 -0500 (EST)
Message-Id: <20071211.174736.88347027.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com, jeremy@xensource.com
Subject: [PATCH 14/30] blk_end_request: changing xen-blkfront (take 4)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts xen-blkfront to use blk_end_request interfaces.
Related 'uptodate' arguments are converted to 'error'.

Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/xen-blkfront.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

Index: 2.6.24-rc4/drivers/block/xen-blkfront.c
===================================================================
--- 2.6.24-rc4.orig/drivers/block/xen-blkfront.c
+++ 2.6.24-rc4/drivers/block/xen-blkfront.c
@@ -452,7 +452,7 @@ static irqreturn_t blkif_interrupt(int i
 	RING_IDX i, rp;
 	unsigned long flags;
 	struct blkfront_info *info = (struct blkfront_info *)dev_id;
-	int uptodate;
+	int error;
 
 	spin_lock_irqsave(&blkif_io_lock, flags);
 
@@ -477,13 +477,13 @@ static irqreturn_t blkif_interrupt(int i
 
 		add_id_to_freelist(info, id);
 
-		uptodate = (bret->status == BLKIF_RSP_OKAY);
+		error = (bret->status == BLKIF_RSP_OKAY) ? 0 : -EIO;
 		switch (bret->operation) {
 		case BLKIF_OP_WRITE_BARRIER:
 			if (unlikely(bret->status == BLKIF_RSP_EOPNOTSUPP)) {
 				printk(KERN_WARNING "blkfront: %s: write barrier op failed\n",
 				       info->gd->disk_name);
-				uptodate = -EOPNOTSUPP;
+				error = -EOPNOTSUPP;
 				info->feature_barrier = 0;
 				xlvbd_barrier(info);
 			}
@@ -494,10 +494,8 @@ static irqreturn_t blkif_interrupt(int i
 				dev_dbg(&info->xbdev->dev, "Bad return from blkdev data "
 					"request: %x\n", bret->status);
 
-			ret = end_that_request_first(req, uptodate,
-				req->hard_nr_sectors);
+			ret = __blk_end_request(req, error, blk_rq_bytes(req));
 			BUG_ON(ret);
-			end_that_request_last(req, uptodate);
 			break;
 		default:
 			BUG();
