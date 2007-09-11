Return-Path: <linux-kernel-owner+w=401wt.eu-S965799AbXIKTJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965799AbXIKTJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933985AbXIKTDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:03:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761738AbXIKTDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:03:49 -0400
Date: Tue, 11 Sep 2007 15:03:19 -0400 (EDT)
Message-Id: <20070911.150319.91214042.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       mike.miller@hp.com, grant.likely@secretlab.ca
Cc: dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 21/27] blk_end_request: changing ide-scsi (take 2)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts ide-scsi to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/scsi/ide-scsi.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -rupN 20-scsi-mid-caller-change/drivers/scsi/ide-scsi.c 21-ide-scsi-caller-change/drivers/scsi/ide-scsi.c
--- 20-scsi-mid-caller-change/drivers/scsi/ide-scsi.c	2007-09-10 17:32:15.000000000 -0400
+++ 21-ide-scsi-caller-change/drivers/scsi/ide-scsi.c	2007-09-10 18:13:51.000000000 -0400
@@ -1042,8 +1042,8 @@ static int idescsi_eh_reset (struct scsi
 	}
 
 	/* kill current request */
-	blkdev_dequeue_request(req);
-	end_that_request_last(req, 0);
+	if (__blk_end_request(req, 0, 0))
+		BUG();
 	if (blk_sense_request(req))
 		kfree(scsi->pc->buffer);
 	kfree(scsi->pc);
@@ -1052,8 +1052,8 @@ static int idescsi_eh_reset (struct scsi
 
 	/* now nuke the drive queue */
 	while ((req = elv_next_request(drive->queue))) {
-		blkdev_dequeue_request(req);
-		end_that_request_last(req, 0);
+		if (__blk_end_request(req, 0, 0))
+			BUG();
 	}
 
 	HWGROUP(drive)->rq = NULL;
