Return-Path: <linux-kernel-owner+w=401wt.eu-S932553AbXIKS5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553AbXIKS5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 14:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932501AbXIKS5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 14:57:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932360AbXIKS5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 14:57:11 -0400
Date: Tue, 11 Sep 2007 14:56:58 -0400 (EDT)
Message-Id: <20070911.145658.112978437.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       mike.miller@hp.com, grant.likely@secretlab.ca
Cc: dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 03/27] blk_end_request: changing block layer core (take 2)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts core parts of block layer to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/ll_rw_blk.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff -rupN 02-rq-size-macro/block/ll_rw_blk.c 03-blkcore-caller-change/block/ll_rw_blk.c
--- 02-rq-size-macro/block/ll_rw_blk.c	2007-09-10 17:42:56.000000000 -0400
+++ 03-blkcore-caller-change/block/ll_rw_blk.c	2007-09-10 17:57:59.000000000 -0400
@@ -365,8 +365,8 @@ void blk_ordered_complete_seq(struct req
 	q->ordseq = 0;
 	rq = q->orig_bar_rq;
 
-	end_that_request_first(rq, uptodate, rq->hard_nr_sectors);
-	end_that_request_last(rq, uptodate);
+	if (__blk_end_request(rq, uptodate, blk_rq_size(rq)))
+		BUG();
 }
 
 static void pre_flush_end_io(struct request *rq, int error)
@@ -484,9 +484,8 @@ int blk_do_ordered(struct request_queue 
 			 * ORDERED_NONE while this request is on it.
 			 */
 			blkdev_dequeue_request(rq);
-			end_that_request_first(rq, -EOPNOTSUPP,
-					       rq->hard_nr_sectors);
-			end_that_request_last(rq, -EOPNOTSUPP);
+			if (__blk_end_request(rq, -EOPNOTSUPP, blk_rq_size(rq)))
+				BUG();
 			*rqp = NULL;
 			return 0;
 		}
@@ -3720,11 +3719,7 @@ EXPORT_SYMBOL(end_that_request_last);
 static inline void __end_request(struct request *rq, int uptodate,
 				 unsigned int nr_bytes)
 {
-	if (!end_that_request_chunk(rq, uptodate, nr_bytes)) {
-		blkdev_dequeue_request(rq);
-		add_disk_randomness(rq->rq_disk);
-		end_that_request_last(rq, uptodate);
-	}
+	__blk_end_request(rq, uptodate, nr_bytes);
 }
 
 /**
