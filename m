Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbXEIKqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbXEIKqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbXEIKqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:46:31 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34121 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842AbXEIKqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:46:30 -0400
Date: Wed, 9 May 2007 13:46:26 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Jens Axboe <jens.axboe@oracle.com>
cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       rusty@rustcorp.com.au, ak@suse.de, Rene Herman <rene.herman@gmail.com>
Subject: Re: [patch 8/9] lguest: the block driver
In-Reply-To: <20070509102933.GR4163@kernel.dk>
Message-ID: <Pine.LNX.4.64.0705091345400.16351@sbz-30.cs.Helsinki.FI>
References: <200705090951.l499pdsc020409@shell0.pdx.osdl.net>
 <84144f020705090322jc37884drc31b97879648d09@mail.gmail.com>
 <20070509102933.GR4163@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Jens Axboe wrote:
> Lets do it after it is merged, as not to create a hold-up point for
> lguest. Once it's in, I'll fix it up.

Ok. Seems pointless, though, as it's only a matter of:

			Pekka

From: Jens Axboe <jens.axboe@oracle.com>

Add a new end_entire_request() function that ends the whole request,
not just the first segment.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 block/ll_rw_blk.c      |   11 +++++++++++
 include/linux/blkdev.h |    1 +
 2 files changed, 12 insertions(+)

Index: 2.6/block/ll_rw_blk.c
===================================================================
--- 2.6.orig/block/ll_rw_blk.c	2007-05-08 10:48:36.000000000 +0300
+++ 2.6/block/ll_rw_blk.c	2007-05-09 13:42:36.000000000 +0300
@@ -3606,6 +3606,17 @@ void end_request(struct request *req, in
 
 EXPORT_SYMBOL(end_request);
 
+void end_entire_request(struct request *req, int uptodate)
+{
+	if (end_that_request_first(req, uptodate, req->hard_nr_sectors))
+		BUG();
+	add_disk_randomness(req->rq_disk);
+	blkdev_dequeue_request(req);
+	end_that_request_last(req, uptodate);
+}
+
+EXPORT_SYMBOL(end_entire_request);
+
 void blk_rq_bio_prep(request_queue_t *q, struct request *rq, struct bio *bio)
 {
 	/* first two bits are identical in rq->cmd_flags and bio->bi_rw */
Index: 2.6/include/linux/blkdev.h
===================================================================
--- 2.6.orig/include/linux/blkdev.h	2007-05-04 09:19:25.000000000 +0300
+++ 2.6/include/linux/blkdev.h	2007-05-09 13:43:10.000000000 +0300
@@ -712,6 +712,7 @@ extern int end_that_request_first(struct
 extern int end_that_request_chunk(struct request *, int, int);
 extern void end_that_request_last(struct request *, int);
 extern void end_request(struct request *req, int uptodate);
+extern void end_entire_request(struct request *req, int uptodate);
 extern void blk_complete_request(struct request *);
 
 /*
