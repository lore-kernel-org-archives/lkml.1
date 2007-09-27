Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbXI0HUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbXI0HUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 03:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbXI0HUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 03:20:15 -0400
Received: from ns.suse.de ([195.135.220.2]:60400 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbXI0HUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 03:20:14 -0400
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 27 Sep 2007 17:20:07 +1000
Message-Id: <1070927072007.4155@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 001 of 4] Remove flush_dry_bio_endio
References: <20070927171111.3251.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The entire function of flush_dry_bio_endio is to undo the effects
of bio_endio (when called on a barrier request).  So remove the 
function and the call to bio_endio.

This allows us to remove "bi_size" from "struct request_queue".

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c      |   39 ++-------------------------------------
 ./include/linux/blkdev.h |    1 -
 2 files changed, 2 insertions(+), 38 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-09-27 16:36:53.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-09-27 16:37:38.000000000 +1000
@@ -428,7 +428,6 @@ static void queue_flush(struct request_q
 static inline struct request *start_ordered(struct request_queue *q,
 					    struct request *rq)
 {
-	q->bi_size = 0;
 	q->orderr = 0;
 	q->ordered = q->next_ordered;
 	q->ordseq |= QUEUE_ORDSEQ_STARTED;
@@ -525,55 +524,21 @@ int blk_do_ordered(struct request_queue 
 	return 1;
 }
 
-static int flush_dry_bio_endio(struct bio *bio, unsigned int bytes, int error)
-{
-	struct request_queue *q = bio->bi_private;
-
-	/*
-	 * This is dry run, restore bio_sector and size.  We'll finish
-	 * this request again with the original bi_end_io after an
-	 * error occurs or post flush is complete.
-	 */
-	q->bi_size += bytes;
-
-	if (bio->bi_size)
-		return 1;
-
-	/* Reset bio */
-	set_bit(BIO_UPTODATE, &bio->bi_flags);
-	bio->bi_size = q->bi_size;
-	bio->bi_sector -= (q->bi_size >> 9);
-	q->bi_size = 0;
-
-	return 0;
-}
-
 static int ordered_bio_endio(struct request *rq, struct bio *bio,
 			     unsigned int nbytes, int error)
 {
 	struct request_queue *q = rq->q;
-	bio_end_io_t *endio;
-	void *private;
 
 	if (&q->bar_rq != rq)
 		return 0;
 
 	/*
-	 * Okay, this is the barrier request in progress, dry finish it.
+	 * Okay, this is the barrier request in progress, just
+	 * record the error;
 	 */
 	if (error && !q->orderr)
 		q->orderr = error;
 
-	endio = bio->bi_end_io;
-	private = bio->bi_private;
-	bio->bi_end_io = flush_dry_bio_endio;
-	bio->bi_private = q;
-
-	bio_endio(bio, nbytes, error);
-
-	bio->bi_end_io = endio;
-	bio->bi_private = private;
-
 	return 1;
 }
 

diff .prev/include/linux/blkdev.h ./include/linux/blkdev.h
--- .prev/include/linux/blkdev.h	2007-09-27 16:36:53.000000000 +1000
+++ ./include/linux/blkdev.h	2007-09-27 16:37:38.000000000 +1000
@@ -471,7 +471,6 @@ struct request_queue
 	int			orderr, ordcolor;
 	struct request		pre_flush_rq, bar_rq, post_flush_rq;
 	struct request		*orig_bar_rq;
-	unsigned int		bi_size;
 
 	struct mutex		sysfs_lock;
 
