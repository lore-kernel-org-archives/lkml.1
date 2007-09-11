Return-Path: <linux-kernel-owner+w=401wt.eu-S933739AbXIKTIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933739AbXIKTIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964798AbXIKTDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:03:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933970AbXIKTDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:03:44 -0400
Date: Tue, 11 Sep 2007 15:03:04 -0400 (EDT)
Message-Id: <20070911.150304.03593612.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       mike.miller@hp.com, grant.likely@secretlab.ca
Cc: dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 20/27] blk_end_request: changing scsi (take 2)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts scsi mid-layer to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/scsi/scsi_lib.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff -rupN 19-s390-caller-change/drivers/scsi/scsi_lib.c 20-scsi-mid-caller-change/drivers/scsi/scsi_lib.c
--- 19-s390-caller-change/drivers/scsi/scsi_lib.c	2007-09-10 17:32:15.000000000 -0400
+++ 20-scsi-mid-caller-change/drivers/scsi/scsi_lib.c	2007-09-10 18:11:55.000000000 -0400
@@ -655,13 +655,12 @@ static struct scsi_cmnd *scsi_end_reques
 {
 	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
-	unsigned long flags;
 
 	/*
 	 * If there are blocks left over at the end, set up the command
 	 * to queue the remainder of them.
 	 */
-	if (end_that_request_chunk(req, uptodate, bytes)) {
+	if (blk_end_request(req, uptodate, bytes)) {
 		int leftover = (req->hard_nr_sectors << 9);
 
 		if (blk_pc_request(req))
@@ -669,7 +668,7 @@ static struct scsi_cmnd *scsi_end_reques
 
 		/* kill remainder if no retrys */
 		if (!uptodate && blk_noretry_request(req))
-			end_that_request_chunk(req, 0, leftover);
+			blk_end_request(req, 0, leftover);
 		else {
 			if (requeue) {
 				/*
@@ -684,14 +683,6 @@ static struct scsi_cmnd *scsi_end_reques
 		}
 	}
 
-	add_disk_randomness(req->rq_disk);
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	if (blk_rq_tagged(req))
-		blk_queue_end_tag(q, req);
-	end_that_request_last(req, uptodate);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
 	/*
 	 * This will goose the queue request function at the end, so we don't
 	 * need to worry about launching another command.
