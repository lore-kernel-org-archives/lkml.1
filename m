Return-Path: <linux-kernel-owner+w=401wt.eu-S941490AbXGaCbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941490AbXGaCbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966967AbXGaCWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:22:45 -0400
Received: from mail.suse.de ([195.135.220.2]:53146 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966930AbXGaCWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:22:43 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:22:29 +1000
Message-Id: <1070731022229.26247@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 027 of 35] Remove bi_*_segments and related code.
References: <20070731122125.25792.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


__make_request now handles bios with too many segments, and it tracks
segment counts in 'struct request' so we no longer need to track
the counts in each bio, or to check the counts when adding a page
to a bio.
So bi_phys_segments, bi_hw_segments, blk_recount_segments(),
BIO_SEG_VALID, bio_phys_segments and bio_hw_segments can all go.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./Documentation/block/biodoc.txt |    2 -
 ./block/ll_rw_blk.c              |   18 --------------
 ./drivers/md/dm.c                |    1 
 ./drivers/md/raid1.c             |    5 ----
 ./drivers/md/raid10.c            |    5 ----
 ./drivers/md/raid5.c             |    5 ----
 ./drivers/scsi/scsi_lib.c        |    1 
 ./fs/bio.c                       |   47 ---------------------------------------
 ./include/linux/bio.h            |   14 -----------
 ./include/linux/blkdev.h         |    1 
 10 files changed, 1 insertion(+), 98 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-07-31 11:21:20.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-07-31 11:21:22.000000000 +1000
@@ -1193,19 +1193,6 @@ void blk_dump_rq_flags(struct request *r
 
 EXPORT_SYMBOL(blk_dump_rq_flags);
 
-void blk_recount_segments(struct request_queue *q, struct bio *bio)
-{
-	struct request rq;
-	rq.q = q;
-	rq.bio = rq.biotail = bio;
-	rq.first_offset = 0;
-	blk_recalc_rq_segments(&rq);
-	bio->bi_phys_segments = rq.nr_phys_segments;
-	bio->bi_hw_segments = rq.nr_hw_segments;
-	bio->bi_flags |= (1 << BIO_SEG_VALID);
-}
-EXPORT_SYMBOL(blk_recount_segments);
-
 static void blk_recalc_rq_segments(struct request *rq)
 {
 	int nr_phys_segs;
@@ -1326,11 +1313,6 @@ static int blk_phys_contig_segment(struc
 static int blk_hw_contig_segment(struct request_queue *q, struct request *req,
 				 struct request *nxt)
 {
-	if (unlikely(!bio_flagged(req->biotail, BIO_SEG_VALID)))
-		blk_recount_segments(q, req->biotail);
-	if (unlikely(!bio_flagged(nxt->bio, BIO_SEG_VALID)))
-		blk_recount_segments(q, nxt->bio);
-
 	if (!rq_virt_mergeable(req, nxt) ||
 	    BIOVEC_VIRT_OVERSIZE(req->hw_back_size +
 				 nxt->hw_front_size))

diff .prev/Documentation/block/biodoc.txt ./Documentation/block/biodoc.txt
--- .prev/Documentation/block/biodoc.txt	2007-07-31 11:21:06.000000000 +1000
+++ ./Documentation/block/biodoc.txt	2007-07-31 11:21:22.000000000 +1000
@@ -456,8 +456,6 @@ struct bio {
        unsigned int	bi_idx;		/* current index into bio_vec array */
 
        unsigned int	bi_size;     /* total size in bytes */
-       unsigned short 	bi_phys_segments; /* segments after physaddr coalesce*/
-       unsigned short	bi_hw_segments; /* segments after DMA remapping */
        unsigned int	bi_max;	     /* max bio_vecs we can hold
                                         used as index into pool */
        struct bio_vec   *bi_io_vec;  /* the actual vec list */

diff .prev/drivers/md/dm.c ./drivers/md/dm.c
--- .prev/drivers/md/dm.c	2007-07-31 11:21:03.000000000 +1000
+++ ./drivers/md/dm.c	2007-07-31 11:21:22.000000000 +1000
@@ -660,7 +660,6 @@ static struct bio *clone_bio(struct bio 
 	clone->bi_io_vec += idx;
 	clone->bi_vcnt = bv_count;
 	clone->bi_size = to_bytes(len);
-	clone->bi_flags &= ~(1 << BIO_SEG_VALID);
 
 	return clone;
 }

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2007-07-31 11:21:07.000000000 +1000
+++ ./drivers/md/raid10.c	2007-07-31 11:21:22.000000000 +1000
@@ -1277,8 +1277,6 @@ static void sync_request_write(mddev_t *
 		 */
 		tbio->bi_vcnt = vcnt;
 		tbio->bi_size = r10_bio->sectors << 9;
-		tbio->bi_phys_segments = 0;
-		tbio->bi_hw_segments = 0;
 		tbio->bi_flags &= ~(BIO_POOL_MASK - 1);
 		tbio->bi_flags |= 1 << BIO_UPTODATE;
 		tbio->bi_next = NULL;
@@ -1883,8 +1881,6 @@ static sector_t sync_request(mddev_t *md
 		if (bio->bi_end_io)
 			bio->bi_flags |= 1 << BIO_UPTODATE;
 		bio->bi_vcnt = 0;
-		bio->bi_phys_segments = 0;
-		bio->bi_hw_segments = 0;
 		bio->bi_size = 0;
 	}
 
@@ -1909,7 +1905,6 @@ static sector_t sync_request(mddev_t *md
 					/* remove last page from this bio */
 					bio2->bi_vcnt--;
 					bio2->bi_size -= len;
-					bio2->bi_flags &= ~(1<< BIO_SEG_VALID);
 				}
 				goto bio_full;
 			}

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2007-07-31 11:21:06.000000000 +1000
+++ ./drivers/md/raid1.c	2007-07-31 11:21:22.000000000 +1000
@@ -1242,8 +1242,6 @@ static void sync_request_write(mddev_t *
 					/* fixup the bio for reuse */
 					sbio->bi_vcnt = vcnt;
 					sbio->bi_size = r1_bio->sectors << 9;
-					sbio->bi_phys_segments = 0;
-					sbio->bi_hw_segments = 0;
 					sbio->bi_flags &= ~(BIO_POOL_MASK - 1);
 					sbio->bi_flags |= 1 << BIO_UPTODATE;
 					sbio->bi_next = NULL;
@@ -1733,8 +1731,6 @@ static sector_t sync_request(mddev_t *md
 		bio->bi_flags |= 1 << BIO_UPTODATE;
 		bio->bi_rw = READ;
 		bio->bi_vcnt = 0;
-		bio->bi_phys_segments = 0;
-		bio->bi_hw_segments = 0;
 		bio->bi_size = 0;
 		bio->bi_end_io = NULL;
 		bio->bi_private = NULL;
@@ -1820,7 +1816,6 @@ static sector_t sync_request(mddev_t *md
 						/* remove last page from this bio */
 						bio->bi_vcnt--;
 						bio->bi_size -= len;
-						bio->bi_flags &= ~(1<< BIO_SEG_VALID);
 					}
 					goto bio_full;
 				}

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-07-31 11:21:06.000000000 +1000
+++ ./drivers/md/raid5.c	2007-07-31 11:21:22.000000000 +1000
@@ -3920,10 +3920,6 @@ static int bio_fits_rdev(struct bio *bi)
 
 	if ((bi->bi_size>>9) > q->max_sectors)
 		return 0;
-	blk_recount_segments(q, bi);
-	if (bi->bi_phys_segments > q->max_phys_segments ||
-	    bi->bi_hw_segments > q->max_hw_segments)
-		return 0;
 
 	if (q->merge_bvec_fn)
 		/* it's too hard to apply the merge_bvec_fn at this stage,
@@ -3978,7 +3974,6 @@ static int chunk_aligned_read(struct req
 		rcu_read_unlock();
 		raid_bio->bi_next = (void*)rdev;
 		align_bi->bi_bdev =  rdev->bdev;
-		align_bi->bi_flags &= ~(1 << BIO_SEG_VALID);
 		align_bi->bi_sector += rdev->data_offset;
 
 		if (!bio_fits_rdev(align_bi)) {

diff .prev/drivers/scsi/scsi_lib.c ./drivers/scsi/scsi_lib.c
--- .prev/drivers/scsi/scsi_lib.c	2007-07-31 11:20:55.000000000 +1000
+++ ./drivers/scsi/scsi_lib.c	2007-07-31 11:21:22.000000000 +1000
@@ -258,7 +258,6 @@ static int scsi_merge_bio(struct request
 {
 	struct request_queue *q = rq->q;
 
-	bio->bi_flags &= ~(1 << BIO_SEG_VALID);
 	if (rq_data_dir(rq) == WRITE)
 		bio->bi_rw |= (1 << BIO_RW);
 	blk_queue_bounce(q, &bio);

diff .prev/fs/bio.c ./fs/bio.c
--- .prev/fs/bio.c	2007-07-31 11:21:07.000000000 +1000
+++ ./fs/bio.c	2007-07-31 11:21:22.000000000 +1000
@@ -132,8 +132,6 @@ void bio_init(struct bio *bio)
 	bio->bi_flags = 1 << BIO_UPTODATE;
 	bio->bi_rw = 0;
 	bio->bi_vcnt = 0;
-	bio->bi_phys_segments = 0;
-	bio->bi_hw_segments = 0;
 	bio->bi_offset = 0;
 	bio->bi_size = 0;
 	bio->bi_max_vecs = 0;
@@ -229,22 +227,6 @@ void bio_put(struct bio *bio)
 	}
 }
 
-inline int bio_phys_segments(struct request_queue *q, struct bio *bio)
-{
-	if (unlikely(!bio_flagged(bio, BIO_SEG_VALID)))
-		blk_recount_segments(q, bio);
-
-	return bio->bi_phys_segments;
-}
-
-inline int bio_hw_segments(struct request_queue *q, struct bio *bio)
-{
-	if (unlikely(!bio_flagged(bio, BIO_SEG_VALID)))
-		blk_recount_segments(q, bio);
-
-	return bio->bi_hw_segments;
-}
-
 /**
  * 	__bio_clone	-	clone a bio
  * 	@bio: destination bio
@@ -256,8 +238,6 @@ inline int bio_hw_segments(struct reques
  */
 void __bio_clone(struct bio *bio, struct bio *bio_src)
 {
-	struct request_queue *q = bdev_get_queue(bio_src->bi_bdev);
-
 	memcpy(bio->bi_io_vec, bio_src->bi_io_vec,
 		bio_src->bi_max_vecs * sizeof(struct bio_vec));
 
@@ -268,8 +248,6 @@ void __bio_clone(struct bio *bio, struct
 	bio->bi_vcnt = bio_src->bi_vcnt;
 	bio->bi_size = bio_src->bi_size;
 	bio->bi_offset = bio_src->bi_offset;
-	bio_phys_segments(q, bio);
-	bio_hw_segments(q, bio);
 }
 
 /**
@@ -318,7 +296,6 @@ static int __bio_add_page(struct request
 			  *page, unsigned int len, unsigned int offset,
 			  unsigned short max_sectors)
 {
-	int retried_segments = 0;
 	struct bio_vec *bvec;
 
 	/*
@@ -355,22 +332,6 @@ static int __bio_add_page(struct request
 		return 0;
 
 	/*
-	 * we might lose a segment or two here, but rather that than
-	 * make this too complex.
-	 */
-
-	while (bio->bi_phys_segments >= q->max_phys_segments
-	       || bio->bi_hw_segments >= q->max_hw_segments
-	       || BIOVEC_VIRT_OVERSIZE(bio->bi_size)) {
-
-		if (retried_segments)
-			return 0;
-
-		retried_segments = 1;
-		blk_recount_segments(q, bio);
-	}
-
-	/*
 	 * setup the new entry, we might clear it again later if we
 	 * cannot add the page
 	 */
@@ -397,13 +358,7 @@ static int __bio_add_page(struct request
 		}
 	}
 
-	/* If we may be able to merge these biovecs, force a recount */
-	/* NOTE: This looks inefficient, but will go away */
-	bio->bi_flags &= ~(1 << BIO_SEG_VALID);
-
 	bio->bi_vcnt++;
-	bio->bi_phys_segments++;
-	bio->bi_hw_segments++;
  done:
 	bio->bi_size += len;
 	return len;
@@ -1195,8 +1150,6 @@ EXPORT_SYMBOL(bio_endio);
 EXPORT_SYMBOL(bio_init);
 EXPORT_SYMBOL(__bio_clone);
 EXPORT_SYMBOL(bio_clone);
-EXPORT_SYMBOL(bio_phys_segments);
-EXPORT_SYMBOL(bio_hw_segments);
 EXPORT_SYMBOL(bio_add_page);
 EXPORT_SYMBOL(bio_add_pc_page);
 EXPORT_SYMBOL(bio_get_nr_vecs);

diff .prev/include/linux/bio.h ./include/linux/bio.h
--- .prev/include/linux/bio.h	2007-07-31 11:21:15.000000000 +1000
+++ ./include/linux/bio.h	2007-07-31 11:21:22.000000000 +1000
@@ -81,16 +81,6 @@ struct bio {
 
 	unsigned short		bi_vcnt;	/* how many bio_vec's */
 
-	/* Number of segments in this BIO after
-	 * physical address coalescing is performed.
-	 */
-	unsigned short		bi_phys_segments;
-
-	/* Number of segments after physical and DMA remapping
-	 * hardware coalescing is performed.
-	 */
-	unsigned short		bi_hw_segments;
-
 	/* This bio only refers to part of the data in bi_io_vec.
 	 * The first bi_offset bytes are not included, and anything after
 	 * the bi_size bytes beyond there are also ignored.
@@ -120,7 +110,7 @@ struct bio {
 #define BIO_UPTODATE	0	/* ok after I/O completion */
 #define BIO_RW_BLOCK	1	/* RW_AHEAD set, and read/write would block */
 #define BIO_EOF		2	/* out-out-bounds error */
-#define BIO_SEG_VALID	3	/* nr_hw_seg valid */
+
 #define BIO_CLONED	4	/* doesn't own data */
 #define BIO_BOUNCED	5	/* bio is a bounce bio */
 #define BIO_USER_MAPPED 6	/* contains user pages */
@@ -301,8 +291,6 @@ extern void bio_free(struct bio *, struc
 
 extern void bio_endio(struct bio *, int);
 struct request_queue;
-extern int bio_phys_segments(struct request_queue *, struct bio *);
-extern int bio_hw_segments(struct request_queue *, struct bio *);
 
 extern void __bio_clone(struct bio *, struct bio *);
 extern struct bio *bio_clone(struct bio *, gfp_t);

diff .prev/include/linux/blkdev.h ./include/linux/blkdev.h
--- .prev/include/linux/blkdev.h	2007-07-31 11:21:20.000000000 +1000
+++ ./include/linux/blkdev.h	2007-07-31 11:21:22.000000000 +1000
@@ -689,7 +689,6 @@ extern void blk_insert_request(struct re
 extern void blk_requeue_request(struct request_queue *, struct request *);
 extern void blk_plug_device(struct request_queue *);
 extern int blk_remove_plug(struct request_queue *);
-extern void blk_recount_segments(struct request_queue *, struct bio *);
 extern int scsi_cmd_ioctl(struct file *, struct request_queue *,
 			  struct gendisk *, unsigned int, void __user *);
 extern int sg_scsi_ioctl(struct file *, struct request_queue *,
