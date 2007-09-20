Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbXITNZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbXITNZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 09:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbXITNZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 09:25:16 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35609 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289AbXITNZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 09:25:15 -0400
Date: Thu, 20 Sep 2007 14:25:12 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       linuxppc-dev@ozlabs.org
Subject: Build failure on ppc64 drivers/block/ps3disk.c
Message-ID: <20070920132512.GF24105@skynet.ie>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070918011841.2381bd93.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

allmodconfig on ppc64 fails to build with the following error

drivers/block/ps3disk.c: In function `ps3disk_probe':
drivers/block/ps3disk.c:509: error: implicit declaration of function `blk_queue_issue_flush_fn'
make[2]: *** [drivers/block/ps3disk.o] Error 1
make[1]: *** [drivers/block] Error 2
make: *** [drivers] Error 2

The problem seems to be coming from git-block.patch. Jens, glancing through
the patch, the function blk_queue_issue_flush_fn() seems to be have been
made redundant. Based on that, this looks like the correct fix but it needs
a review. Thanks

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 drivers/block/ps3disk.c |   21 ---------------------
 1 file changed, 21 deletions(-)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.23-rc6-mm1-030_fix_ppc64_sata/drivers/block/ps3disk.c linux-2.6.23-rc6-mm1-035_fix_ppc64_ps3disk/drivers/block/ps3disk.c
--- linux-2.6.23-rc6-mm1-030_fix_ppc64_sata/drivers/block/ps3disk.c	2007-09-11 03:50:29.000000000 +0100
+++ linux-2.6.23-rc6-mm1-035_fix_ppc64_ps3disk/drivers/block/ps3disk.c	2007-09-20 14:17:43.000000000 +0100
@@ -414,26 +414,6 @@ static void ps3disk_prepare_flush(struct
 	req->cmd_type = REQ_TYPE_FLUSH;
 }
 
-static int ps3disk_issue_flush(struct request_queue *q, struct gendisk *gendisk,
-			       sector_t *sector)
-{
-	struct ps3_storage_device *dev = q->queuedata;
-	struct request *req;
-	int res;
-
-	dev_dbg(&dev->sbd.core, "%s:%u\n", __func__, __LINE__);
-
-	req = blk_get_request(q, WRITE, __GFP_WAIT);
-	ps3disk_prepare_flush(q, req);
-	res = blk_execute_rq(q, gendisk, req, 0);
-	if (res)
-		dev_err(&dev->sbd.core, "%s:%u: flush request failed %d\n",
-			__func__, __LINE__, res);
-	blk_put_request(req);
-	return res;
-}
-
-
 static unsigned long ps3disk_mask;
 
 static DEFINE_MUTEX(ps3disk_mask_mutex);
@@ -506,7 +486,6 @@ static int __devinit ps3disk_probe(struc
 	blk_queue_dma_alignment(queue, dev->blk_size-1);
 	blk_queue_hardsect_size(queue, dev->blk_size);
 
-	blk_queue_issue_flush_fn(queue, ps3disk_issue_flush);
 	blk_queue_ordered(queue, QUEUE_ORDERED_DRAIN_FLUSH,
 			  ps3disk_prepare_flush);
 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
