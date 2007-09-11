Return-Path: <linux-kernel-owner+w=401wt.eu-S965279AbXIKTGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965279AbXIKTGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964819AbXIKTCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:02:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933915AbXIKTCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:02:33 -0400
Date: Tue, 11 Sep 2007 15:02:12 -0400 (EDT)
Message-Id: <20070911.150212.52121578.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       mike.miller@hp.com, grant.likely@secretlab.ca
Cc: dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 17/27] blk_end_request: changing i2o_block (take 2)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
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

diff -rupN 16-viocd-caller-change/drivers/message/i2o/i2o_block.c 17-i2o-caller-change/drivers/message/i2o/i2o_block.c
--- 16-viocd-caller-change/drivers/message/i2o/i2o_block.c	2007-09-10 17:32:13.000000000 -0400
+++ 17-i2o-caller-change/drivers/message/i2o/i2o_block.c	2007-09-10 18:08:24.000000000 -0400
@@ -425,22 +425,18 @@ static void i2o_block_end_request(struct
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
