Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbZH2XLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbZH2XLd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 19:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbZH2XLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 19:11:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58941 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbZH2XLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 19:11:21 -0400
Message-Id: <20090829231121.562919508@bombadil.infradead.org>
User-Agent: quilt/0.47-1
Date: Sat, 29 Aug 2009 19:03:35 -0400
From: Christoph Hellwig <hch@infradead.org>
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: liml@rtr.ca, jens.axboe@oracle.com, matthew@wil.cx, dwmw2@infradead.org,
       Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 3/7] block: discard may need to allocate pages
References: <20090829230332.017137693@bombadil.infradead.org>
Content-Disposition: inline; filename=discard-add-payload
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SCSI and ATA both need to send data to the device.  In order to do this,
the BIO must be allocated with room for a page to be added, and the bio
needs to be passed to the discard prep function.  We also need to free
the page attached to the BIO before we free it.

init_request_from_bio() is not currently called from a context which
forbids sleeping, and to make sure it stays that was (so we don't have
to use GFP_ATOMIC), add a might_sleep() to it.

[hch: moved the might_sleep into the discard section, it can trigger
 easily for normal requests]

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

Index: linux-2.6/block/blk-barrier.c
===================================================================
--- linux-2.6.orig/block/blk-barrier.c	2009-08-29 19:19:47.351880578 -0300
+++ linux-2.6/block/blk-barrier.c	2009-08-29 19:19:58.087575976 -0300
@@ -383,7 +383,7 @@ int blkdev_issue_discard(struct block_de
 		return -EOPNOTSUPP;
 
 	while (nr_sects && !ret) {
-		struct bio *bio = bio_alloc(gfp_mask, 0);
+		struct bio *bio = bio_alloc(gfp_mask, 1);
 		if (!bio)
 			return -ENOMEM;
 
Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c	2009-08-29 18:16:52.427841223 -0300
+++ linux-2.6/block/blk-core.c	2009-08-29 19:19:28.639880676 -0300
@@ -1124,10 +1124,11 @@ void init_request_from_bio(struct reques
 		req->cmd_flags |= REQ_FAILFAST_DRIVER;
 
 	if (unlikely(bio_discard(bio))) {
+		might_sleep();
 		req->cmd_flags |= REQ_DISCARD;
 		if (bio_barrier(bio))
 			req->cmd_flags |= REQ_SOFTBARRIER;
-		req->q->prepare_discard_fn(req->q, req);
+		req->q->prepare_discard_fn(req->q, req, bio);
 	} else if (unlikely(bio_barrier(bio)))
 		req->cmd_flags |= REQ_HARDBARRIER;
 
Index: linux-2.6/drivers/mtd/mtd_blkdevs.c
===================================================================
--- linux-2.6.orig/drivers/mtd/mtd_blkdevs.c	2009-08-29 18:16:52.639841570 -0300
+++ linux-2.6/drivers/mtd/mtd_blkdevs.c	2009-08-29 18:17:22.799373769 -0300
@@ -33,7 +33,7 @@ struct mtd_blkcore_priv {
 };
 
 static int blktrans_discard_request(struct request_queue *q,
-				    struct request *req)
+				    struct request *req, struct bio *bio)
 {
 	req->cmd_type = REQ_TYPE_LINUX_BLOCK;
 	req->cmd[0] = REQ_LB_OP_DISCARD;
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2009-08-29 18:16:52.899841155 -0300
+++ linux-2.6/include/linux/blkdev.h	2009-08-29 18:17:22.803373020 -0300
@@ -255,7 +255,8 @@ typedef void (request_fn_proc) (struct r
 typedef int (make_request_fn) (struct request_queue *q, struct bio *bio);
 typedef int (prep_rq_fn) (struct request_queue *, struct request *);
 typedef void (unplug_fn) (struct request_queue *);
-typedef int (prepare_discard_fn) (struct request_queue *, struct request *);
+typedef int (prepare_discard_fn) (struct request_queue *, struct request *,
+				  struct bio *bio);
 
 struct bio_vec;
 struct bvec_merge_data {

