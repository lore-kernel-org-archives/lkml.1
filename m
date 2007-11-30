Return-Path: <linux-kernel-owner+w=401wt.eu-S1764425AbXK3Xf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764425AbXK3Xf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932318AbXK3XfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:35:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310AbXK3Xe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:34:57 -0500
Date: Fri, 30 Nov 2007 18:33:21 -0500 (EST)
Message-Id: <20071130.183321.57154855.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 22/28] blk_end_request: changing cciss (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts cciss to use blk_end_request().

cciss is a little bit different from "normal" drivers.
cciss directly calls bio_endio() and disk_stat_add()
when completing request.  But those can be replaced with
__end_that_request_first().
After the replacement, request completion procedures of
those drivers become like the following:
    o end_that_request_first()
    o add_disk_randomness()
    o end_that_request_last()
This can be converted to blk_end_request() by following
the rule (a) mentioned in the patch subject
"[PATCH 01/28] blk_end_request: add new request completion interface".

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/cciss.c |   25 +++----------------------
 1 files changed, 3 insertions(+), 22 deletions(-)

Index: 2.6.24-rc3-mm2/drivers/block/cciss.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/block/cciss.c
+++ 2.6.24-rc3-mm2/drivers/block/cciss.c
@@ -1187,17 +1187,6 @@ static int cciss_ioctl(struct inode *ino
 	}
 }
 
-static inline void complete_buffers(struct bio *bio, int status)
-{
-	while (bio) {
-		struct bio *xbh = bio->bi_next;
-
-		bio->bi_next = NULL;
-		bio_endio(bio, status ? 0 : -EIO);
-		bio = xbh;
-	}
-}
-
 static void cciss_check_queues(ctlr_info_t *h)
 {
 	int start_queue = h->next_to_run;
@@ -1263,21 +1252,14 @@ static void cciss_softirq_done(struct re
 		pci_unmap_page(h->pdev, temp64.val, cmd->SG[i].Len, ddir);
 	}
 
-	complete_buffers(rq->bio, (rq->errors == 0));
-
-	if (blk_fs_request(rq)) {
-		const int rw = rq_data_dir(rq);
-
-		disk_stat_add(rq->rq_disk, sectors[rw], rq->nr_sectors);
-	}
-
 #ifdef CCISS_DEBUG
 	printk("Done with %p\n", rq);
 #endif				/* CCISS_DEBUG */
 
-	add_disk_randomness(rq->rq_disk);
+	if (blk_end_request(rq, (rq->errors == 0), blk_rq_bytes(rq)))
+		BUG();
+
 	spin_lock_irqsave(&h->lock, flags);
-	end_that_request_last(rq, (rq->errors == 0));
 	cmd_free(h, cmd, 1);
 	cciss_check_queues(h);
 	spin_unlock_irqrestore(&h->lock, flags);
@@ -2544,7 +2526,6 @@ after_error_processing:
 	}
 	cmd->rq->data_len = 0;
 	cmd->rq->completion_data = cmd;
-	blk_add_trace_rq(cmd->rq->q, cmd->rq, BLK_TA_COMPLETE);
 	blk_complete_request(cmd->rq);
 }
 
