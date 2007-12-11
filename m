Return-Path: <linux-kernel-owner+w=401wt.eu-S1758924AbXLKWu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924AbXLKWu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758381AbXLKWuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:50:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757806AbXLKWuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:50:13 -0500
Date: Tue, 11 Dec 2007 17:49:29 -0500 (EST)
Message-Id: <20071211.174929.129777486.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com, bzolnier@gmail.com
Subject: [PATCH 19/30] blk_end_request: changing ide-scsi (take 4)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts ide-scsi to use blk_end_request interfaces.
Related 'uptodate' arguments are converted to 'error'.

Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/scsi/ide-scsi.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

Index: 2.6.24-rc4/drivers/scsi/ide-scsi.c
===================================================================
--- 2.6.24-rc4.orig/drivers/scsi/ide-scsi.c
+++ 2.6.24-rc4/drivers/scsi/ide-scsi.c
@@ -921,8 +921,8 @@ static int idescsi_eh_reset (struct scsi
 	}
 
 	/* kill current request */
-	blkdev_dequeue_request(req);
-	end_that_request_last(req, 0);
+	if (__blk_end_request(req, -EIO, 0))
+		BUG();
 	if (blk_sense_request(req))
 		kfree(scsi->pc->buffer);
 	kfree(scsi->pc);
@@ -931,8 +931,8 @@ static int idescsi_eh_reset (struct scsi
 
 	/* now nuke the drive queue */
 	while ((req = elv_next_request(drive->queue))) {
-		blkdev_dequeue_request(req);
-		end_that_request_last(req, 0);
+		if (__blk_end_request(req, -EIO, 0))
+			BUG();
 	}
 
 	HWGROUP(drive)->rq = NULL;
