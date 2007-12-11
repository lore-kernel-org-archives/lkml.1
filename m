Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbXLKWoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbXLKWoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:44:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755382AbXLKWnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:43:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230AbXLKWnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:43:47 -0500
Date: Tue, 11 Dec 2007 17:43:40 -0500 (EST)
Message-Id: <20071211.174340.107680113.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 07/30] blk_end_request: changing floppy (take 4)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts floppy to use blk_end_request interfaces.
Related 'uptodate' arguments are converted to 'error'.

As a result, the interface of internal function, floppy_end_request(),
is changed.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/floppy.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

Index: 2.6.24-rc4/drivers/block/floppy.c
===================================================================
--- 2.6.24-rc4.orig/drivers/block/floppy.c
+++ 2.6.24-rc4/drivers/block/floppy.c
@@ -2287,21 +2287,19 @@ static int do_format(int drive, struct f
  * =============================
  */
 
-static void floppy_end_request(struct request *req, int uptodate)
+static void floppy_end_request(struct request *req, int error)
 {
 	unsigned int nr_sectors = current_count_sectors;
+	unsigned int drive = (unsigned int)req->rq_disk->private_data;
 
 	/* current_count_sectors can be zero if transfer failed */
-	if (!uptodate)
+	if (error)
 		nr_sectors = req->current_nr_sectors;
-	if (end_that_request_first(req, uptodate, nr_sectors))
+	if (__blk_end_request(req, error, nr_sectors << 9))
 		return;
-	add_disk_randomness(req->rq_disk);
-	floppy_off((long)req->rq_disk->private_data);
-	blkdev_dequeue_request(req);
-	end_that_request_last(req, uptodate);
 
 	/* We're done with the request */
+	floppy_off(drive);
 	current_req = NULL;
 }
 
@@ -2332,7 +2330,7 @@ static void request_done(int uptodate)
 
 		/* unlock chained buffers */
 		spin_lock_irqsave(q->queue_lock, flags);
-		floppy_end_request(req, 1);
+		floppy_end_request(req, 0);
 		spin_unlock_irqrestore(q->queue_lock, flags);
 	} else {
 		if (rq_data_dir(req) == WRITE) {
@@ -2346,7 +2344,7 @@ static void request_done(int uptodate)
 			DRWE->last_error_generation = DRS->generation;
 		}
 		spin_lock_irqsave(q->queue_lock, flags);
-		floppy_end_request(req, 0);
+		floppy_end_request(req, -EIO);
 		spin_unlock_irqrestore(q->queue_lock, flags);
 	}
 }
