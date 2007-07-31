Return-Path: <linux-kernel-owner+w=401wt.eu-S941199AbXGaC11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941199AbXGaC11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932504AbXGaCSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:18:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:36088 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764356AbXGaCSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:18:12 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:17:59 +1000
Message-Id: <1070731021759.25484@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 025 of 35] Treat rq->hard_nr_sectors as setting an overriding limit in the size of the request
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


For a request to be able to refer to part of a bio, we need to be able
to impose a size limit at the request level.  So allow hard_nr_sectors
to be less than the size of the bios (and bio_vecs) and interpret it
such that anything in the last bio beyond that limit is ignored.

As some bios can be less than one sector - as happens when a SCSI
sense command is being submitted - we need to set hard_nr_sectors to
bi_size rounded up in blk_rq_bio_prep, and we need to abort the
rq_for_each_segment loop if _iter.bio becomes NULL even if _iter.size
is still non-zero

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c      |   11 +++++------
 ./include/linux/bio.h    |    9 +++++----
 ./include/linux/blkdev.h |   11 +++++++----
 3 files changed, 17 insertions(+), 14 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-07-31 11:21:14.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-07-31 11:21:15.000000000 +1000
@@ -3364,12 +3364,10 @@ static void blk_recalc_rq_sectors(struct
 
 		/*
 		 * if total number of sectors is less than the first segment
-		 * size, something has gone terribly wrong
+		 * size, then we have hit an early end-of-request.
 		 */
-		if (rq->nr_sectors < rq->current_nr_sectors) {
-			printk("blk: request botched\n");
-			rq->nr_sectors = rq->current_nr_sectors;
-		}
+		if (rq->nr_sectors < rq->current_nr_sectors)
+			rq->current_nr_sectors = rq->nr_sectors;
 	}
 }
 
@@ -3661,7 +3659,8 @@ static void blk_rq_bio_prep(struct reque
 	/* first two bits are identical in rq->cmd_flags and bio->bi_rw */
 	rq->cmd_flags |= (bio->bi_rw & 3);
 
-	rq->hard_nr_sectors = rq->nr_sectors = bio_sectors(bio);
+	rq->hard_nr_sectors = rq->nr_sectors
+		= DIV_ROUND_UP(bio->bi_size, 512);
 	rq->data_len = bio->bi_size;
 
 	rq->first_offset = 0;

diff .prev/include/linux/bio.h ./include/linux/bio.h
--- .prev/include/linux/bio.h	2007-07-31 11:21:07.000000000 +1000
+++ ./include/linux/bio.h	2007-07-31 11:21:15.000000000 +1000
@@ -222,7 +222,8 @@ struct bio_iterator {
 
 /* This macro probably need some explanation...
  * Its purpose is to find all the effective segments in a bio
- * missing the first 'offs' bytes.  We need to be sure to honour
+ * missing the first 'offs' bytes and only covering the next _size
+ * bytes.   We need to be sure to honour
  * bi_offset which can cause us to skip part of the firs segment,
  * and bi_size which may cause us to stop before the end of bi_io_vec.
  * The 'for' loop iterates through the segments in bi_io_vec until
@@ -233,9 +234,9 @@ struct bio_iterator {
  * follows this macro) if the size would be zero.
  * It also keeps 'offset' and 'size' (in the iterator) up to date.
  */
-#define bio_for_each_segment_offset(bv, bio, _i, offs)			\
+#define bio_for_each_segment_offset(bv, bio, _i, offs, _size)		\
 	for (_i.i = 0, _i.offset = (bio)->bi_offset + offs,		\
-		 _i.size = (bio)->bi_size - offs;			\
+		 _i.size = min_t(int, _size, (bio)->bi_size - offs);   	\
 	     _i.i < (bio)->bi_vcnt && _i.size > 0;			\
 	     _i.i++)							\
 		if (bv = *bio_iovec_idx((bio), _i.i),			\
@@ -251,7 +252,7 @@ struct bio_iterator {
 			  bv.bv_len > 0)))
 
 #define bio_for_each_segment(bv, bio, __i)				\
-		bio_for_each_segment_offset(bv, bio, __i, 0)
+		bio_for_each_segment_offset(bv, bio, __i, 0, (bio)->bi_size)
 /*
  * get a reference to a bio, so it won't disappear. the intended use is
  * something like:

diff .prev/include/linux/blkdev.h ./include/linux/blkdev.h
--- .prev/include/linux/blkdev.h	2007-07-31 11:21:14.000000000 +1000
+++ ./include/linux/blkdev.h	2007-07-31 11:21:15.000000000 +1000
@@ -657,13 +657,16 @@ struct req_iterator {
 	struct bio_iterator i;
 	struct bio *bio;
 	int offset;
+	int size;
 };
 #define rq_for_each_segment(rq, _iter, bvec)	\
-	for (_iter.bio = (rq)->bio, _iter.offset = (rq)->first_offset;	       \
-	     _iter.bio && _iter.bio != rq->biotail->bi_next;		       \
-	     _iter.bio = _iter.bio->bi_next, _iter.offset = 0) 		       \
+	for (_iter.bio = (rq)->bio, _iter.offset = (rq)->first_offset,	       \
+		_iter.size = (rq)->hard_nr_sectors << 9;		       \
+	     _iter.size && _iter.bio;					       \
+	     _iter.size -= (_iter.bio->bi_size - _iter.offset),		       \
+	       _iter.bio = _iter.bio->bi_next, _iter.offset = 0) 	       \
 		bio_for_each_segment_offset(bvec, _iter.bio, _iter.i,	       \
-			_iter.offset)
+			_iter.offset, _iter.size)
 
 #define rq_iter_last(rq, _iter) ((_iter.bio->bi_next == NULL ||		\
 				  _iter.bio == rq->biotail) &&		\
