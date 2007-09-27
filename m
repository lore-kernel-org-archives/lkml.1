Return-Path: <linux-kernel-owner+w=401wt.eu-S1755614AbXI0HVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbXI0HVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 03:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbXI0HUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 03:20:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:52466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731AbXI0HUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 03:20:25 -0400
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 27 Sep 2007 17:20:18 +1000
Message-Id: <1070927072018.4205@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 003 of 4] Don't decrement bi_size in bio_endio.
References: <20070927171111.3251.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The only caller of bio_endio that does not pass the full bi_size
is end_that_request_first.  Also, no ->bi_end_io method is really
interested in bi_size being decremented.

So move the decrement and related code into ll_rw_blk and merge it
with order_bio_endio to form req_bio_endio which does endio functionality
specific to request completion.

As some ->bi_end_io methods do check bi_size of 0, we set it thus for
now, but that will go in the next patch.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c |   42 +++++++++++++++++++++++++++---------------
 ./fs/bio.c          |   23 +++++++++++------------
 2 files changed, 38 insertions(+), 27 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-09-27 16:42:31.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-09-27 16:42:50.000000000 +1000
@@ -524,22 +524,36 @@ int blk_do_ordered(struct request_queue 
 	return 1;
 }
 
-static int ordered_bio_endio(struct request *rq, struct bio *bio,
-			     unsigned int nbytes, int error)
+static void req_bio_endio(struct request *rq, struct bio *bio,
+			  unsigned int nbytes, int error)
 {
 	struct request_queue *q = rq->q;
 
-	if (&q->bar_rq != rq)
-		return 0;
+	if (&q->bar_rq != rq) {
+		if (error)
+			clear_bit(BIO_UPTODATE, &bio->bi_flags);
+		else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
+			error = -EIO;
+
+		if (unlikely(nbytes > bio->bi_size)) {
+			printk("%s: want %u bytes done, only %u left\n",
+			       __FUNCTION__, nbytes, bio->bi_size);
+			nbytes = bio->bi_size;
+		}
 
-	/*
-	 * Okay, this is the barrier request in progress, just
-	 * record the error;
-	 */
-	if (error && !q->orderr)
-		q->orderr = error;
+		bio->bi_size -= nbytes;
+		bio->bi_sector += (nbytes >> 9);
+		if (bio->bi_size == 0)
+			bio_endio(bio, bio->bi_size, error);
+	} else {
 
-	return 1;
+		/*
+		 * Okay, this is the barrier request in progress, just
+		 * record the error;
+		 */
+		if (error && !q->orderr)
+			q->orderr = error;
+	}
 }
 
 /**
@@ -3407,8 +3421,7 @@ static int __end_that_request_first(stru
 		if (nr_bytes >= bio->bi_size) {
 			req->bio = bio->bi_next;
 			nbytes = bio->bi_size;
-			if (!ordered_bio_endio(req, bio, nbytes, error))
-				bio_endio(bio, nbytes, error);
+			req_bio_endio(req, bio, nbytes, error);
 			next_idx = 0;
 			bio_nbytes = 0;
 		} else {
@@ -3463,8 +3476,7 @@ static int __end_that_request_first(stru
 	 * if the request wasn't completed, update state
 	 */
 	if (bio_nbytes) {
-		if (!ordered_bio_endio(req, bio, bio_nbytes, error))
-			bio_endio(bio, bio_nbytes, error);
+		req_bio_endio(req, bio, bio_nbytes, error);
 		bio->bi_idx += next_idx;
 		bio_iovec(bio)->bv_offset += nr_bytes;
 		bio_iovec(bio)->bv_len -= nr_bytes;

diff .prev/fs/bio.c ./fs/bio.c
--- .prev/fs/bio.c	2007-09-27 16:39:02.000000000 +1000
+++ ./fs/bio.c	2007-09-27 16:42:50.000000000 +1000
@@ -1006,13 +1006,14 @@ void bio_check_pages_dirty(struct bio *b
  * @error:	error, if any
  *
  * Description:
- *   bio_endio() will end I/O on @bytes_done number of bytes. This may be
- *   just a partial part of the bio, or it may be the whole bio. bio_endio()
- *   is the preferred way to end I/O on a bio, it takes care of decrementing
- *   bi_size and clearing BIO_UPTODATE on error. @error is 0 on success, and
- *   and one of the established -Exxxx (-EIO, for instance) error values in
- *   case something went wrong. Noone should call bi_end_io() directly on
- *   a bio unless they own it and thus know that it has an end_io function.
+ *   bio_endio() will end I/O on @bytes_done number of bytes. This
+ *   must always be the whole (remaining) bio. bio_endio() is the
+ *   preferred way to end I/O on a bio, it takes care of clearing
+ *   BIO_UPTODATE on error. @error is 0 on success, and and one of the
+ *   established -Exxxx (-EIO, for instance) error values in case
+ *   something went wrong. Noone should call bi_end_io() directly on a
+ *   bio unless they own it and thus know that it has an end_io
+ *   function.
  **/
 void bio_endio(struct bio *bio, unsigned int bytes_done, int error)
 {
@@ -1021,16 +1022,14 @@ void bio_endio(struct bio *bio, unsigned
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
 
-	if (unlikely(bytes_done > bio->bi_size)) {
+	if (unlikely(bytes_done != bio->bi_size)) {
 		printk("%s: want %u bytes done, only %u left\n", __FUNCTION__,
 						bytes_done, bio->bi_size);
 		bytes_done = bio->bi_size;
 	}
 
-	bio->bi_size -= bytes_done;
-	bio->bi_sector += (bytes_done >> 9);
-
-	if (bio->bi_size && bio->bi_end_io)
+	bio->bi_size = 0; /* expected by some callees - will be removed */
+	if (bio->bi_end_io)
 		bio->bi_end_io(bio, bytes_done, error);
 }
 
