Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbXLKWrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbXLKWrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758407AbXLKWrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:47:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758370AbXLKWre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:47:34 -0500
Date: Tue, 11 Dec 2007 17:47:14 -0500 (EST)
Message-Id: <20071211.174714.42908160.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com, sfr@canb.auug.org.au
Subject: [PATCH 13/30] blk_end_request: changing viodasd (take 4)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts viodasd to use blk_end_request interfaces.
Related 'uptodate' arguments are converted to 'error'.

As a result, the interface of internal function, viodasd_end_request(),
is changed.

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/viodasd.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

Index: 2.6.24-rc4/drivers/block/viodasd.c
===================================================================
--- 2.6.24-rc4.orig/drivers/block/viodasd.c
+++ 2.6.24-rc4/drivers/block/viodasd.c
@@ -229,13 +229,10 @@ static struct block_device_operations vi
 /*
  * End a request
  */
-static void viodasd_end_request(struct request *req, int uptodate,
+static void viodasd_end_request(struct request *req, int error,
 		int num_sectors)
 {
-	if (end_that_request_first(req, uptodate, num_sectors))
-		return;
-	add_disk_randomness(req->rq_disk);
-	end_that_request_last(req, uptodate);
+	__blk_end_request(req, error, num_sectors << 9);
 }
 
 /*
@@ -374,12 +371,12 @@ static void do_viodasd_request(struct re
 		blkdev_dequeue_request(req);
 		/* check that request contains a valid command */
 		if (!blk_fs_request(req)) {
-			viodasd_end_request(req, 0, req->hard_nr_sectors);
+			viodasd_end_request(req, -EIO, req->hard_nr_sectors);
 			continue;
 		}
 		/* Try sending the request */
 		if (send_request(req) != 0)
-			viodasd_end_request(req, 0, req->hard_nr_sectors);
+			viodasd_end_request(req, -EIO, req->hard_nr_sectors);
 	}
 }
 
@@ -591,7 +588,7 @@ static int viodasd_handle_read_write(str
 	num_req_outstanding--;
 	spin_unlock_irqrestore(&viodasd_spinlock, irq_flags);
 
-	error = event->xRc != HvLpEvent_Rc_Good;
+	error = (event->xRc == HvLpEvent_Rc_Good) ? 0 : -EIO;
 	if (error) {
 		const struct vio_error_entry *err;
 		err = vio_lookup_rc(viodasd_err_table, bevent->sub_result);
@@ -601,7 +598,7 @@ static int viodasd_handle_read_write(str
 	}
 	qlock = req->q->queue_lock;
 	spin_lock_irqsave(qlock, irq_flags);
-	viodasd_end_request(req, !error, num_sect);
+	viodasd_end_request(req, error, num_sect);
 	spin_unlock_irqrestore(qlock, irq_flags);
 
 	/* Finally, try to get more requests off of this device's queue */
