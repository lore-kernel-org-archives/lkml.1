Return-Path: <linux-kernel-owner+w=401wt.eu-S1758703AbXLKWsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbXLKWsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757147AbXLKWsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:48:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758596AbXLKWsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:48:22 -0500
Date: Tue, 11 Dec 2007 17:48:09 -0500 (EST)
Message-Id: <20071211.174809.91447619.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com, Markus.Lidel@shadowconnect.com
Subject: [PATCH 16/30] blk_end_request: changing i2o_block (take 4)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts i2o_block to use blk_end_request interfaces.
Related 'uptodate' arguments are converted to 'error'.

As a result, the interface of internal function, i2o_block_end_request(),
is changed.

Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/message/i2o/i2o_block.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

Index: 2.6.24-rc4/drivers/message/i2o/i2o_block.c
===================================================================
--- 2.6.24-rc4.orig/drivers/message/i2o/i2o_block.c
+++ 2.6.24-rc4/drivers/message/i2o/i2o_block.c
@@ -412,13 +412,13 @@ static void i2o_block_delayed_request_fn
 /**
  *	i2o_block_end_request - Post-processing of completed commands
  *	@req: request which should be completed
- *	@uptodate: 1 for success, 0 for I/O error, < 0 for specific error
+ *	@error: 0 for success, < 0 for error
  *	@nr_bytes: number of bytes to complete
  *
  *	Mark the request as complete. The lock must not be held when entering.
  *
  */
-static void i2o_block_end_request(struct request *req, int uptodate,
+static void i2o_block_end_request(struct request *req, int error,
 				  int nr_bytes)
 {
 	struct i2o_block_request *ireq = req->special;
@@ -426,22 +426,18 @@ static void i2o_block_end_request(struct
 	struct request_queue *q = req->q;
 	unsigned long flags;
 
-	if (end_that_request_chunk(req, uptodate, nr_bytes)) {
+	if (blk_end_request(req, error, nr_bytes)) {
 		int leftover = (req->hard_nr_sectors << KERNEL_SECTOR_SHIFT);
 
 		if (blk_pc_request(req))
 			leftover = req->data_len;
 
-		if (end_io_error(uptodate))
-			end_that_request_chunk(req, 0, leftover);
+		if (error)
+			blk_end_request(req, -EIO, leftover);
 	}
 
-	add_disk_randomness(req->rq_disk);
-
 	spin_lock_irqsave(q->queue_lock, flags);
 
-	end_that_request_last(req, uptodate);
-
 	if (likely(dev)) {
 		dev->open_queue_depth--;
 		list_del(&ireq->queue);
@@ -468,7 +464,7 @@ static int i2o_block_reply(struct i2o_co
 			   struct i2o_message *msg)
 {
 	struct request *req;
-	int uptodate = 1;
+	int error = 0;
 
 	req = i2o_cntxt_list_get(c, le32_to_cpu(msg->u.s.tcntxt));
 	if (unlikely(!req)) {
@@ -501,10 +497,10 @@ static int i2o_block_reply(struct i2o_co
 
 		req->errors++;
 
-		uptodate = 0;
+		error = -EIO;
 	}
 
-	i2o_block_end_request(req, uptodate, le32_to_cpu(msg->body[1]));
+	i2o_block_end_request(req, error, le32_to_cpu(msg->body[1]));
 
 	return 1;
 };
