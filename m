Return-Path: <linux-kernel-owner+w=401wt.eu-S1764227AbXK3XeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764227AbXK3XeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764037AbXK3Xde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:33:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764016AbXK3Xdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:33:32 -0500
Date: Fri, 30 Nov 2007 18:32:43 -0500 (EST)
Message-Id: <20071130.183243.66055473.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 20/28] blk_end_request: changing ide-scsi (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
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

Index: 2.6.24-rc3-mm2/drivers/scsi/ide-scsi.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/scsi/ide-scsi.c
+++ 2.6.24-rc3-mm2/drivers/scsi/ide-scsi.c
@@ -918,8 +918,8 @@ static int idescsi_eh_reset (struct scsi
 	}
 
 	/* kill current request */
-	blkdev_dequeue_request(req);
-	end_that_request_last(req, 0);
+	if (__blk_end_request(req, 0, 0))
+		BUG();
 	if (blk_sense_request(req))
 		kfree(scsi->pc->buffer);
 	kfree(scsi->pc);
@@ -928,8 +928,8 @@ static int idescsi_eh_reset (struct scsi
 
 	/* now nuke the drive queue */
 	while ((req = elv_next_request(drive->queue))) {
-		blkdev_dequeue_request(req);
-		end_that_request_last(req, 0);
+		if (__blk_end_request(req, 0, 0))
+			BUG();
 	}
 
 	HWGROUP(drive)->rq = NULL;
