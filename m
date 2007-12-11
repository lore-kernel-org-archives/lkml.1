Return-Path: <linux-kernel-owner+w=401wt.eu-S1758993AbXLKWxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758993AbXLKWxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758959AbXLKWvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:51:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759006AbXLKWva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:51:30 -0500
Date: Tue, 11 Dec 2007 17:51:23 -0500 (EST)
Message-Id: <20071211.175123.78387624.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com, bzolnier@gmail.com
Subject: [PATCH 25/30] blk_end_request: changing ide-cd (take 4)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts ide-cd (cdrom_newpc_intr()) to use blk_end_request
interfaces.  Related 'uptodate' arguments are converted to 'error'.

In PIO mode, ide-cd (cdrom_newpc_intr()) needs to defer
end_that_request_last() until the device clears DRQ_STAT and raises
an interrupt after end_that_request_first().
So blk_end_request() has to return without completing request
even if no leftover in the request.

ide-cd uses blk_end_request_callback() and a dummy callback function,
which just returns value '1', to tell blk_end_request_callback()
about that.

Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/ide/ide-cd.c |   49 +++++++++++++++++++++++++++++++++++--------------
 1 files changed, 35 insertions(+), 14 deletions(-)

Index: 2.6.24-rc4/drivers/ide/ide-cd.c
===================================================================
--- 2.6.24-rc4.orig/drivers/ide/ide-cd.c
+++ 2.6.24-rc4/drivers/ide/ide-cd.c
@@ -1650,6 +1650,17 @@ static int cdrom_write_check_ireason(ide
 	return 1;
 }
 
+/*
+ * Called from blk_end_request_callback() after the data of the request
+ * is completed and before the request is completed.
+ * By returning value '1', blk_end_request_callback() returns immediately
+ * without completing the request.
+ */
+static int cdrom_newpc_intr_dummy_cb(struct request *rq)
+{
+	return 1;
+}
+
 typedef void (xfer_func_t)(ide_drive_t *, void *, u32);
 
 /*
@@ -1688,9 +1699,13 @@ static ide_startstop_t cdrom_newpc_intr(
 			return ide_error(drive, "dma error", stat);
 		}
 
-		end_that_request_chunk(rq, 1, rq->data_len);
-		rq->data_len = 0;
-		goto end_request;
+		spin_lock_irqsave(&ide_lock, flags);
+		if (__blk_end_request(rq, 0, rq->data_len))
+			BUG();
+		HWGROUP(drive)->rq = NULL;
+		spin_unlock_irqrestore(&ide_lock, flags);
+
+		return ide_stopped;
 	}
 
 	/*
@@ -1708,8 +1723,15 @@ static ide_startstop_t cdrom_newpc_intr(
 	/*
 	 * If DRQ is clear, the command has completed.
 	 */
-	if ((stat & DRQ_STAT) == 0)
-		goto end_request;
+	if ((stat & DRQ_STAT) == 0) {
+		spin_lock_irqsave(&ide_lock, flags);
+		if (__blk_end_request(rq, 0, 0))
+			BUG();
+		HWGROUP(drive)->rq = NULL;
+		spin_unlock_irqrestore(&ide_lock, flags);
+
+		return ide_stopped;
+	}
 
 	/*
 	 * check which way to transfer data
@@ -1762,7 +1784,14 @@ static ide_startstop_t cdrom_newpc_intr(
 		rq->data_len -= blen;
 
 		if (rq->bio)
-			end_that_request_chunk(rq, 1, blen);
+			/*
+			 * The request can't be completed until DRQ is cleared.
+			 * So complete the data, but don't complete the request
+			 * using the dummy function for the callback feature
+			 * of blk_end_request_callback().
+			 */
+			blk_end_request_callback(rq, 0, blen,
+						 cdrom_newpc_intr_dummy_cb);
 		else
 			rq->data += blen;
 	}
@@ -1783,14 +1812,6 @@ static ide_startstop_t cdrom_newpc_intr(
 
 	ide_set_handler(drive, cdrom_newpc_intr, rq->timeout, NULL);
 	return ide_started;
-
-end_request:
-	spin_lock_irqsave(&ide_lock, flags);
-	blkdev_dequeue_request(rq);
-	end_that_request_last(rq, 1);
-	HWGROUP(drive)->rq = NULL;
-	spin_unlock_irqrestore(&ide_lock, flags);
-	return ide_stopped;
 }
 
 static ide_startstop_t cdrom_write_intr(ide_drive_t *drive)
