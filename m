Return-Path: <linux-kernel-owner+w=401wt.eu-S1762895AbXK3Xcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762895AbXK3Xcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762185AbXK3Xcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:32:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761401AbXK3Xch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:32:37 -0500
Date: Fri, 30 Nov 2007 18:31:24 -0500 (EST)
Message-Id: <20071130.183124.78497067.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 16/28] blk_end_request: changing i2o_block (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts i2o_block to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/message/i2o/i2o_block.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

Index: 2.6.24-rc3-mm2/drivers/message/i2o/i2o_block.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/message/i2o/i2o_block.c
+++ 2.6.24-rc3-mm2/drivers/message/i2o/i2o_block.c
@@ -426,22 +426,18 @@ static void i2o_block_end_request(struct
 	struct request_queue *q = req->q;
 	unsigned long flags;
 
-	if (end_that_request_chunk(req, uptodate, nr_bytes)) {
+	if (blk_end_request(req, uptodate, nr_bytes)) {
 		int leftover = (req->hard_nr_sectors << KERNEL_SECTOR_SHIFT);
 
 		if (blk_pc_request(req))
 			leftover = req->data_len;
 
 		if (end_io_error(uptodate))
-			end_that_request_chunk(req, 0, leftover);
+			blk_end_request(req, 0, leftover);
 	}
 
-	add_disk_randomness(req->rq_disk);
-
 	spin_lock_irqsave(q->queue_lock, flags);
 
-	end_that_request_last(req, uptodate);
-
 	if (likely(dev)) {
 		dev->open_queue_depth--;
 		list_del(&ireq->queue);
