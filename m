Return-Path: <linux-kernel-owner+w=401wt.eu-S941274AbXGaC2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941274AbXGaC2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940490AbXGaCSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:18:32 -0400
Received: from ns2.suse.de ([195.135.220.15]:36112 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940214AbXGaCS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:18:29 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:18:15 +1000
Message-Id: <1070731021815.25529@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 028 of 35] Split arbitrarily large requests to md/raid0 and md/linear
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


As bi_io_vec is now never modified, bio_clone does not need to
copy it any more.

Make a new bio_multi_split function which can be used to split a single
bio into mutliple other bios dependant on the one parent.

Use that in raid0 and linear to handle any arbitrary bios,
and remove mergeable_bvec functions.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/linear.c |   63 +++++++++----------------------------
 ./drivers/md/raid0.c  |   73 +++++++++---------------------------------
 ./drivers/md/raid1.c  |    5 ++
 ./fs/bio.c            |   85 ++++++++++++++++++++++++++++++++++++++++++++++----
 ./include/linux/bio.h |    2 +
 5 files changed, 117 insertions(+), 111 deletions(-)

diff .prev/drivers/md/linear.c ./drivers/md/linear.c
--- .prev/drivers/md/linear.c	2007-07-31 11:20:51.000000000 +1000
+++ ./drivers/md/linear.c	2007-07-31 11:21:23.000000000 +1000
@@ -47,38 +47,6 @@ static inline dev_info_t *which_dev(mdde
 	return hash;
 }
 
-/**
- *	linear_mergeable_bvec -- tell bio layer if two requests can be merged
- *	@q: request queue
- *	@bio: the buffer head that's been built up so far
- *	@biovec: the request that could be merged to it.
- *
- *	Return amount of bytes we can take at this offset
- */
-static int linear_mergeable_bvec(struct request_queue *q, struct bio *bio, struct bio_vec *biovec)
-{
-	mddev_t *mddev = q->queuedata;
-	dev_info_t *dev0;
-	unsigned long maxsectors, bio_sectors = bio->bi_size >> 9;
-	sector_t sector = bio->bi_sector + get_start_sect(bio->bi_bdev);
-
-	dev0 = which_dev(mddev, sector);
-	maxsectors = (dev0->size << 1) - (sector - (dev0->offset<<1));
-
-	if (maxsectors < bio_sectors)
-		maxsectors = 0;
-	else
-		maxsectors -= bio_sectors;
-
-	if (maxsectors <= (PAGE_SIZE >> 9 ) && bio_sectors == 0)
-		return biovec->bv_len;
-	/* The bytes available at this offset could be really big,
-	 * so we cap at 2^31 to avoid overflow */
-	if (maxsectors > (1 << (31-9)))
-		return 1<<31;
-	return maxsectors << 9;
-}
-
 static void linear_unplug(struct request_queue *q)
 {
 	mddev_t *mddev = q->queuedata;
@@ -277,7 +245,6 @@ static int linear_run (mddev_t *mddev)
 	mddev->private = conf;
 	mddev->array_size = conf->array_size;
 
-	blk_queue_merge_bvec(mddev->queue, linear_mergeable_bvec);
 	mddev->queue->unplug_fn = linear_unplug;
 	mddev->queue->issue_flush_fn = linear_issue_flush;
 	mddev->queue->backing_dev_info.congested_fn = linear_congested;
@@ -336,6 +303,7 @@ static int linear_make_request (struct r
 	mddev_t *mddev = q->queuedata;
 	dev_info_t *tmp_dev;
 	sector_t block;
+	struct bio *remainder = bio;
 
 	if (unlikely(bio_barrier(bio))) {
 		bio_endio(bio, -EOPNOTSUPP);
@@ -361,26 +329,27 @@ static int linear_make_request (struct r
 		bio_io_error(bio);
 		return 0;
 	}
-	if (unlikely(bio->bi_sector + (bio->bi_size >> 9) >
-		     (tmp_dev->offset + tmp_dev->size)<<1)) {
+
+	while (remainder->bi_sector + (remainder->bi_size >> 9) >
+	       (tmp_dev->offset + tmp_dev->size)<<1) {
 		/* This bio crosses a device boundary, so we have to
 		 * split it.
 		 */
-		struct bio_pair *bp;
-		bp = bio_split(bio, bio_split_pool,
-			       ((tmp_dev->offset + tmp_dev->size)<<1) - bio->bi_sector);
-		if (linear_make_request(q, &bp->bio1))
-			generic_make_request(&bp->bio1);
-		if (linear_make_request(q, &bp->bio2))
-			generic_make_request(&bp->bio2);
-		bio_pair_release(bp);
-		return 0;
+		struct bio *new =
+			bio_multi_split(bio,
+					((tmp_dev->offset + tmp_dev->size) << 1)
+					 - remainder->bi_sector,
+					&remainder);
+		linear_make_request(q, new);
+		tmp_dev = which_dev(mddev, remainder->bi_sector);
 	}
 		    
-	bio->bi_bdev = tmp_dev->rdev->bdev;
-	bio->bi_sector = bio->bi_sector - (tmp_dev->offset << 1) + tmp_dev->rdev->data_offset;
+	remainder->bi_bdev = tmp_dev->rdev->bdev;
+	remainder->bi_sector = remainder->bi_sector - (tmp_dev->offset << 1)
+		+ tmp_dev->rdev->data_offset;
 
-	return 1;
+	generic_make_request(remainder);
+	return 0;
 }
 
 static void linear_status (struct seq_file *seq, mddev_t *mddev)

diff .prev/drivers/md/raid0.c ./drivers/md/raid0.c
--- .prev/drivers/md/raid0.c	2007-07-31 11:21:03.000000000 +1000
+++ ./drivers/md/raid0.c	2007-07-31 11:21:23.000000000 +1000
@@ -260,30 +260,6 @@ static int create_strip_zones (mddev_t *
 	return 1;
 }
 
-/**
- *	raid0_mergeable_bvec -- tell bio layer if a two requests can be merged
- *	@q: request queue
- *	@bio: the buffer head that's been built up so far
- *	@biovec: the request that could be merged to it.
- *
- *	Return amount of bytes we can accept at this offset
- */
-static int raid0_mergeable_bvec(struct request_queue *q, struct bio *bio, struct bio_vec *biovec)
-{
-	mddev_t *mddev = q->queuedata;
-	sector_t sector = bio->bi_sector + get_start_sect(bio->bi_bdev);
-	int max;
-	unsigned int chunk_sectors = mddev->chunk_size >> 9;
-	unsigned int bio_sectors = bio->bi_size >> 9;
-
-	max =  (chunk_sectors - ((sector & (chunk_sectors - 1)) + bio_sectors)) << 9;
-	if (max < 0) max = 0; /* bio_add cannot handle a negative return */
-	if (max <= biovec->bv_len && bio_sectors == 0)
-		return biovec->bv_len;
-	else 
-		return max;
-}
-
 static int raid0_run (mddev_t *mddev)
 {
 	unsigned  cur=0, i=0, nb_zone;
@@ -380,8 +356,6 @@ static int raid0_run (mddev_t *mddev)
 			mddev->queue->backing_dev_info.ra_pages = 2* stripe;
 	}
 
-
-	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
 	return 0;
 
 out_free_conf:
@@ -418,40 +392,35 @@ static int raid0_make_request (struct re
 	sector_t chunk;
 	sector_t block, rsect;
 	const int rw = bio_data_dir(bio);
+	struct bio *remainder = bio;
 
 	if (unlikely(bio_barrier(bio))) {
 		bio_endio(bio, -EOPNOTSUPP);
 		return 0;
 	}
 
-	disk_stat_inc(mddev->gendisk, ios[rw]);
-	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
-
 	chunk_size = mddev->chunk_size >> 10;
 	chunk_sects = mddev->chunk_size >> 9;
 	chunksize_bits = ffz(~chunk_size);
-	block = bio->bi_sector >> 1;
 	
+	while (chunk_sects < ((remainder->bi_sector & (chunk_sects - 1))
+			      + (remainder->bi_size >> 9))) {
+		struct bio *new =
+			bio_multi_split(bio,
+					chunk_sects
+					- (remainder->bi_sector
+					   & (chunk_sects - 1)),
+					&remainder);
 
-	if (unlikely(chunk_sects < (bio->bi_sector & (chunk_sects - 1)) + (bio->bi_size >> 9))) {
-		struct bio_pair *bp;
-		/* Sanity check -- queue functions should prevent this happening */
-		if (bio->bi_vcnt != 1)
-			goto bad_map;
-		/* This is a one page bio that upper layers
-		 * refuse to split for us, so we need to split it.
-		 */
-		bp = bio_split(bio, bio_split_pool, chunk_sects - (bio->bi_sector & (chunk_sects - 1)) );
-		if (raid0_make_request(q, &bp->bio1))
-			generic_make_request(&bp->bio1);
-		if (raid0_make_request(q, &bp->bio2))
-			generic_make_request(&bp->bio2);
-
-		bio_pair_release(bp);
-		return 0;
+		raid0_make_request(q, new);
 	}
+	bio = remainder;
  
+	disk_stat_inc(mddev->gendisk, ios[rw]);
+	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+
 
+	block = bio->bi_sector >> 1;
 	{
 		sector_t x = block >> conf->preshift;
 		sector_div(x, (u32)conf->hash_spacing);
@@ -479,17 +448,7 @@ static int raid0_make_request (struct re
 	bio->bi_bdev = tmp_dev->bdev;
 	bio->bi_sector = rsect + tmp_dev->data_offset;
 
-	/*
-	 * Let the main block layer submit the IO and resolve recursion:
-	 */
-	return 1;
-
-bad_map:
-	printk("raid0_make_request bug: can't convert block across chunks"
-		" or bigger than %dk %llu %d\n", chunk_size, 
-		(unsigned long long)bio->bi_sector, bio->bi_size >> 10);
-
-	bio_io_error(bio);
+	generic_make_request(bio);
 	return 0;
 }
 			   

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2007-07-31 11:21:22.000000000 +1000
+++ ./drivers/md/raid1.c	2007-07-31 11:21:23.000000000 +1000
@@ -896,7 +896,10 @@ static int make_request(struct request_q
 		if (!r1_bio->bios[i])
 			continue;
 
-		mbio = bio_clone(bio, GFP_NOIO);
+		/* Need to allocate new bi_iovec for behind_pages */
+		mbio = bio_alloc(GFP_NOIO, bio->bi_max_vecs);
+		__bio_clone(mbio, bio);
+
 		r1_bio->bios[i] = mbio;
 
 		mbio->bi_sector	= r1_bio->sector + conf->mirrors[i].rdev->data_offset;

diff .prev/fs/bio.c ./fs/bio.c
--- .prev/fs/bio.c	2007-07-31 11:21:22.000000000 +1000
+++ ./fs/bio.c	2007-07-31 11:21:23.000000000 +1000
@@ -113,7 +113,8 @@ void bio_free(struct bio *bio, struct bi
 
 	BIO_BUG_ON(pool_idx >= BIOVEC_NR_POOLS);
 
-	mempool_free(bio->bi_io_vec, bio_set->bvec_pools[pool_idx]);
+	if (!(bio->bi_flags & (1 << BIO_CLONED)))
+		mempool_free(bio->bi_io_vec, bio_set->bvec_pools[pool_idx]);
 	mempool_free(bio, bio_set->bio_pool);
 }
 
@@ -238,12 +239,15 @@ void bio_put(struct bio *bio)
  */
 void __bio_clone(struct bio *bio, struct bio *bio_src)
 {
-	memcpy(bio->bi_io_vec, bio_src->bi_io_vec,
-		bio_src->bi_max_vecs * sizeof(struct bio_vec));
-
+	if (bio->bi_io_vec)
+		memcpy(bio->bi_io_vec, bio_src->bi_io_vec,
+		       bio_src->bi_max_vecs * sizeof(struct bio_vec));
+	else {
+		bio->bi_io_vec = bio_src->bi_io_vec;
+		bio->bi_flags |= 1 << BIO_CLONED;
+	}
 	bio->bi_sector = bio_src->bi_sector;
 	bio->bi_bdev = bio_src->bi_bdev;
-	bio->bi_flags |= 1 << BIO_CLONED;
 	bio->bi_rw = bio_src->bi_rw;
 	bio->bi_vcnt = bio_src->bi_vcnt;
 	bio->bi_size = bio_src->bi_size;
@@ -259,7 +263,7 @@ void __bio_clone(struct bio *bio, struct
  */
 struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
 {
-	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, fs_bio_set);
+	struct bio *b = bio_alloc_bioset(gfp_mask, 0, fs_bio_set);
 
 	if (b) {
 		b->bi_destructor = bio_fs_destructor;
@@ -1047,6 +1051,75 @@ struct bio_pair *bio_split(struct bio *b
 	return bp;
 }
 
+static void multi_split_endio(struct bio *bio, int err)
+{
+	struct bio *master = bio->bi_private;
+	bio_put(bio);
+	bio_endio(master, err);
+}
+
+/**
+ * bio_multi_split - split a bio into multiple components
+ * @master:         The bio to be split.
+ * @first_sectors:  The number of sectors to be split off the front.
+ * @remainder:      in/out bio which holds the remainder.
+ *
+ * Description:
+ *   bio_multi_split should be used when it is necessary to split a
+ *   bio, for example when different parts must be sent on to different
+ *   devices.
+ *
+ *   If @remainder points to %NULL or @master, then @master is first cloned
+ *   before any leading sectors are split off.  This cloned remainder will
+ *   be returned in @remainder, after leading sectors are removed.
+ *   If the @remainder would become empty, the remainder is returned,
+ *   and @remainder is set to NULL.  Otherwise a new clone of limited
+ *   size is returned.
+ *
+ *   bi_end_io and bi_private of clones are set, and bi_iocnt for master is
+ *   incremented, so that once bio_endio has been called on all clones,
+ *   the bi_end_io of the master will automatically be called.
+ *   If bi_end_io of the clones are changed, the new bi_end_io must ensure
+ *   to call bio_end_io on the master correctly, and must bio_put the clones.
+ */
+struct bio *bio_multi_split(struct bio *master, int first_sectors,
+			    struct bio **remainder)
+{
+	struct bio *new, *rem = *remainder;
+	if (!rem || rem == master) {
+		rem = bio_clone(master, GFP_NOIO);
+		rem->bi_private = master;
+		rem->bi_end_io = multi_split_endio;
+		*remainder = rem;
+	}
+
+	if (rem->bi_size <= (first_sectors << 9)) {
+		*remainder = NULL;
+		return rem;
+	}
+
+	new = bio_clone(rem, GFP_NOIO);
+	new->bi_private = master;
+	new->bi_end_io = multi_split_endio;
+	atomic_inc(&master->bi_iocnt);
+
+	new->bi_size = first_sectors << 9;
+
+	rem->bi_sector += first_sectors;
+	rem->bi_size -= new->bi_size;
+	rem->bi_offset += new->bi_size;
+	while (rem->bi_offset >= rem->bi_io_vec->bv_len) {
+		rem->bi_offset -= rem->bi_io_vec->bv_len;
+		rem->bi_io_vec++;
+		rem->bi_vcnt--;
+	}
+	new->bi_vcnt = rem->bi_io_vec - new->bi_io_vec;
+	if (rem->bi_offset > 0)
+		new->bi_vcnt++;
+
+	return new;
+}
+EXPORT_SYMBOL(bio_multi_split);
 
 /*
  * create memory pools for biovec's in a bio_set.

diff .prev/include/linux/bio.h ./include/linux/bio.h
--- .prev/include/linux/bio.h	2007-07-31 11:21:22.000000000 +1000
+++ ./include/linux/bio.h	2007-07-31 11:21:23.000000000 +1000
@@ -280,6 +280,8 @@ extern struct bio_pair *bio_split(struct
 				  int first_sectors);
 extern mempool_t *bio_split_pool;
 extern void bio_pair_release(struct bio_pair *dbio);
+extern struct bio *bio_multi_split(struct bio *master, int first_sectors,
+			    struct bio **remainder);
 
 extern struct bio_set *bioset_create(int, int);
 extern void bioset_free(struct bio_set *);
