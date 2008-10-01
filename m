Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbYJAOQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbYJAOQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 10:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbYJAOQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 10:16:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42648 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423AbYJAOQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 10:16:07 -0400
Date: Wed, 01 Oct 2008 10:13:44 -0400 (EDT)
Message-Id: <20081001.101344.78703914.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: rusty@rustcorp.com.au, oakad@yahoo.com, adrian@mcmen.demon.co.uk,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 4/5] block: change elevator to use __blk_end_request()
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <20081001.100942.74754500.k-ueda@ct.jp.nec.com>
References: <20081001.100942.74754500.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts elevator to use __blk_end_request() directly
so that end_{queued|dequeued}_request() can be removed.
Related 'uptodate' arguments is converted to 'error'.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/elevator.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-block/block/elevator.c
===================================================================
--- linux-2.6-block.orig/block/elevator.c
+++ linux-2.6-block/block/elevator.c
@@ -754,7 +754,7 @@ struct request *elv_next_request(struct 
 		 * not ever see it.
 		 */
 		if (blk_empty_barrier(rq)) {
-			end_queued_request(rq, 1);
+			__blk_end_request(rq, 0, blk_rq_bytes(rq));
 			continue;
 		}
 		if (!(rq->cmd_flags & REQ_STARTED)) {
@@ -825,7 +825,7 @@ struct request *elv_next_request(struct 
 			break;
 		} else if (ret == BLKPREP_KILL) {
 			rq->cmd_flags |= REQ_QUIET;
-			end_queued_request(rq, 0);
+			__blk_end_request(rq, -EIO, blk_rq_bytes(rq));
 		} else {
 			printk(KERN_ERR "%s: bad return=%d\n", __func__, ret);
 			break;
@@ -922,7 +922,7 @@ void elv_abort_queue(struct request_queu
 		rq = list_entry_rq(q->queue_head.next);
 		rq->cmd_flags |= REQ_QUIET;
 		blk_add_trace_rq(q, rq, BLK_TA_ABORT);
-		end_queued_request(rq, 0);
+		__blk_end_request(rq, -EIO, blk_rq_bytes(rq));
 	}
 }
 EXPORT_SYMBOL(elv_abort_queue);
