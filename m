Return-Path: <linux-kernel-owner+w=401wt.eu-S940587AbXGaCTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940587AbXGaCTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966058AbXGaCQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:16:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965996AbXGaCQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:16:30 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:16:17 +1000
Message-Id: <1070731021617.25162@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 006 of 35] Only call bi_end_io once for any bio.
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Current bi_end_io can be called multiple times as sub-requests complete.
However no ->bi_end_io function wants to know about that.  So
only call when the bio is complete.

Note that bi_sector and bi_size are now not updated when subrequests
complete.  This does not appear to be a problem as they are not
used (any longer) once a bio has been attached to a request,
except where bi_size is offset by rq->first_offset.

This allows us to remove q->bi_size as it is no longer needed.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c      |   20 +++-----------------
 ./include/linux/blkdev.h |    1 -
 2 files changed, 3 insertions(+), 18 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-07-31 11:20:46.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-07-31 11:20:47.000000000 +1000
@@ -430,7 +430,6 @@ static void queue_flush(struct request_q
 static inline struct request *start_ordered(struct request_queue *q,
 					    struct request *rq)
 {
-	q->bi_size = 0;
 	q->orderr = 0;
 	q->ordered = q->next_ordered;
 	q->ordseq |= QUEUE_ORDSEQ_STARTED;
@@ -530,23 +529,17 @@ int blk_do_ordered(struct request_queue 
 
 static int flush_dry_bio_endio(struct bio *bio, unsigned int bytes, int error)
 {
-	struct request_queue *q = bio->bi_private;
 
 	/*
 	 * This is dry run, restore bio_sector and size.  We'll finish
 	 * this request again with the original bi_end_io after an
 	 * error occurs or post flush is complete.
 	 */
-	q->bi_size += bytes;
-
-	if (bio->bi_size)
-		return 1;
 
 	/* Reset bio */
 	set_bit(BIO_UPTODATE, &bio->bi_flags);
-	bio->bi_size = q->bi_size;
-	bio->bi_sector -= (q->bi_size >> 9);
-	q->bi_size = 0;
+	bio->bi_size = bytes;
+	bio->bi_sector -= (bytes >> 9);
 
 	return 0;
 }
@@ -3473,14 +3466,7 @@ static int __end_that_request_first(stru
 	if (!req->bio)
 		return 0;
 
-	/*
-	 * if the request wasn't completed, update state
-	 */
-	if (bio_nbytes) {
-		if (!ordered_bio_endio(req, bio, bio_nbytes, error))
-			bio_endio(bio, bio_nbytes, error);
-		req->first_offset = bio_nbytes;
-	}
+	req->first_offset = bio_nbytes;
 
 	blk_recalc_rq_sectors(req, total_bytes >> 9);
 	blk_recalc_rq_segments(req);

diff .prev/include/linux/blkdev.h ./include/linux/blkdev.h
--- .prev/include/linux/blkdev.h	2007-07-31 11:20:46.000000000 +1000
+++ ./include/linux/blkdev.h	2007-07-31 11:20:47.000000000 +1000
@@ -472,7 +472,6 @@ struct request_queue
 	int			orderr, ordcolor;
 	struct request		pre_flush_rq, bar_rq, post_flush_rq;
 	struct request		*orig_bar_rq;
-	unsigned int		bi_size;
 
 	struct mutex		sysfs_lock;
 
