Return-Path: <linux-kernel-owner+w=401wt.eu-S941010AbXGaCXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941010AbXGaCXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940104AbXGaCRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:17:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:52794 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940412AbXGaCRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:17:35 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:17:21 +1000
Message-Id: <1070731021721.25347@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 018 of 35] Remove bi_idx
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It is almost always set to zero.  The one case where it isn't
is in dm.c when splitting a bio.  In this case we can simply offset
bi_io_vec rather than storing the offset in bi_idx.

bio_to_phys, bio_iovec, bio_page, bio_offset, bio_segments all depend
on bi_idx, so they go too.

Also __bio_for_each_segment can go as it is now only called with start_idx
of 0, and that is what bio_for_each_segment uses.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c          |    2 +-
 ./drivers/block/floppy.c     |    1 -
 ./drivers/block/pktcdvd.c    |    3 +--
 ./drivers/block/umem.c       |    4 ++--
 ./drivers/ide/ide-cd.c       |    3 ++-
 ./drivers/md/dm-bio-record.h |    3 ---
 ./drivers/md/dm-crypt.c      |   11 +++++------
 ./drivers/md/dm-raid1.c      |    2 +-
 ./drivers/md/dm.c            |    6 +++---
 ./drivers/md/raid0.c         |    3 +--
 ./drivers/md/raid1.c         |   13 ++-----------
 ./drivers/md/raid10.c        |    5 +----
 ./drivers/md/raid5.c         |    2 --
 ./fs/bio.c                   |    7 ++-----
 ./fs/buffer.c                |    1 -
 ./fs/jfs/jfs_logmgr.c        |    2 --
 ./fs/reiser4/page_cache.c    |    1 -
 ./include/asm-arm/memory.h   |    2 +-
 ./include/asm-arm26/memory.h |    2 +-
 ./include/linux/bio.h        |   21 ++++-----------------
 ./include/linux/blkdev.h     |    2 +-
 ./mm/bounce.c                |    7 +++----
 ./mm/page_io.c               |    1 -
 23 files changed, 31 insertions(+), 73 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-07-31 11:21:01.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-07-31 11:21:03.000000000 +1000
@@ -3404,7 +3404,7 @@ static int __end_that_request_first(stru
 			next_idx = 0;
 			bio_nbytes = 0;
 		} else {
-			int idx = bio->bi_idx + next_idx;
+			int idx = next_idx;
 
 			if (unlikely(idx >= bio->bi_vcnt)) {
 				blk_dump_rq_flags(req, "__end_that");

diff .prev/drivers/block/floppy.c ./drivers/block/floppy.c
--- .prev/drivers/block/floppy.c	2007-07-31 11:20:51.000000000 +1000
+++ ./drivers/block/floppy.c	2007-07-31 11:21:03.000000000 +1000
@@ -3842,7 +3842,6 @@ static int __floppy_read_block_0(struct 
 	bio_vec.bv_len = size;
 	bio_vec.bv_offset = 0;
 	bio.bi_vcnt = 1;
-	bio.bi_idx = 0;
 	bio.bi_size = size;
 	bio.bi_bdev = bdev;
 	bio.bi_sector = 0;

diff .prev/drivers/block/pktcdvd.c ./drivers/block/pktcdvd.c
--- .prev/drivers/block/pktcdvd.c	2007-07-31 11:20:51.000000000 +1000
+++ ./drivers/block/pktcdvd.c	2007-07-31 11:21:03.000000000 +1000
@@ -1236,7 +1236,6 @@ static int pkt_start_recovery(struct pac
 	pkt->bio->bi_sector = new_sector;
 	pkt->bio->bi_next = NULL;
 	pkt->bio->bi_flags = 1 << BIO_UPTODATE;
-	pkt->bio->bi_idx = 0;
 
 	BUG_ON(pkt->bio->bi_rw != (1 << BIO_RW));
 	BUG_ON(pkt->bio->bi_vcnt != pkt->frames);
@@ -1391,7 +1390,7 @@ static void pkt_start_write(struct pktcd
 	frames_write = 0;
 	spin_lock(&pkt->lock);
 	for (bio = pkt->orig_bios; bio; bio = bio->bi_next) {
-		int segment = bio->bi_idx;
+		int segment = 0;
 		int src_offs = 0;
 		int first_frame = (bio->bi_sector - pkt->sector) / (CD_FRAMESIZE >> 9);
 		int num_frames = bio->bi_size / CD_FRAMESIZE;

diff .prev/drivers/block/umem.c ./drivers/block/umem.c
--- .prev/drivers/block/umem.c	2007-07-31 11:21:02.000000000 +1000
+++ ./drivers/block/umem.c	2007-07-31 11:21:03.000000000 +1000
@@ -391,7 +391,7 @@ static int add_bio(struct cardinfo *card
 	bio = card->currentbio;
 	if (!bio && card->bio) {
 		card->currentbio = card->bio;
-		card->current_idx = card->bio->bi_idx;
+		card->current_idx = 0;
 		card->current_sector = card->bio->bi_sector;
 		card->bio = card->bio->bi_next;
 		if (card->bio == NULL)
@@ -489,7 +489,7 @@ static void process_page(unsigned long d
 		page->idx++;
 		if (page->idx >= bio->bi_vcnt) {
 			page->bio = bio->bi_next;
-			page->idx = page->bio->bi_idx;
+			page->idx = 0;
 		}
 
 		pci_unmap_page(card->dev, desc->data_dma_handle, 

diff .prev/drivers/ide/ide-cd.c ./drivers/ide/ide-cd.c
--- .prev/drivers/ide/ide-cd.c	2007-07-31 11:20:43.000000000 +1000
+++ ./drivers/ide/ide-cd.c	2007-07-31 11:21:03.000000000 +1000
@@ -1991,7 +1991,8 @@ static ide_startstop_t cdrom_do_block_pc
 	 */
 	if (rq->bio) {
 		int mask = drive->queue->dma_alignment;
-		unsigned long addr = (unsigned long) page_address(bio_page(rq->bio));
+		unsigned long addr = (unsigned long)
+			page_address(rq->bio->bi_io_vec[0].bv_page);
 
 		info->dma = drive->using_dma;
 

diff .prev/drivers/md/dm-bio-record.h ./drivers/md/dm-bio-record.h
--- .prev/drivers/md/dm-bio-record.h	2007-07-31 11:20:06.000000000 +1000
+++ ./drivers/md/dm-bio-record.h	2007-07-31 11:21:03.000000000 +1000
@@ -20,7 +20,6 @@ struct dm_bio_details {
 	sector_t bi_sector;
 	struct block_device *bi_bdev;
 	unsigned int bi_size;
-	unsigned short bi_idx;
 	unsigned long bi_flags;
 };
 
@@ -29,7 +28,6 @@ static inline void dm_bio_record(struct 
 	bd->bi_sector = bio->bi_sector;
 	bd->bi_bdev = bio->bi_bdev;
 	bd->bi_size = bio->bi_size;
-	bd->bi_idx = bio->bi_idx;
 	bd->bi_flags = bio->bi_flags;
 }
 
@@ -38,7 +36,6 @@ static inline void dm_bio_restore(struct
 	bio->bi_sector = bd->bi_sector;
 	bio->bi_bdev = bd->bi_bdev;
 	bio->bi_size = bd->bi_size;
-	bio->bi_idx = bd->bi_idx;
 	bio->bi_flags = bd->bi_flags;
 }
 

diff .prev/drivers/md/dm.c ./drivers/md/dm.c
--- .prev/drivers/md/dm.c	2007-07-31 11:20:51.000000000 +1000
+++ ./drivers/md/dm.c	2007-07-31 11:21:03.000000000 +1000
@@ -657,8 +657,8 @@ static struct bio *clone_bio(struct bio 
 	__bio_clone(clone, bio);
 	clone->bi_destructor = dm_bio_destructor;
 	clone->bi_sector = sector;
-	clone->bi_idx = idx;
-	clone->bi_vcnt = idx + bv_count;
+	clone->bi_io_vec += idx;
+	clone->bi_vcnt = bv_count;
 	clone->bi_size = to_bytes(len);
 	clone->bi_flags &= ~(1 << BIO_SEG_VALID);
 
@@ -776,7 +776,7 @@ static void __split_bio(struct mapped_de
 	ci.io->md = md;
 	ci.sector = bio->bi_sector;
 	ci.sector_count = bio_sectors(bio);
-	ci.idx = bio->bi_idx;
+	ci.idx = 0;
 
 	start_io_acct(ci.io);
 	while (ci.sector_count)

diff .prev/drivers/md/dm-crypt.c ./drivers/md/dm-crypt.c
--- .prev/drivers/md/dm-crypt.c	2007-07-31 11:20:51.000000000 +1000
+++ ./drivers/md/dm-crypt.c	2007-07-31 11:21:03.000000000 +1000
@@ -328,8 +328,8 @@ crypt_convert_init(struct crypt_config *
 	ctx->bio_out = bio_out;
 	ctx->offset_in = 0;
 	ctx->offset_out = 0;
-	ctx->idx_in = bio_in ? bio_in->bi_idx : 0;
-	ctx->idx_out = bio_out ? bio_out->bi_idx : 0;
+	ctx->idx_in = 0;
+	ctx->idx_out = 0;
 	ctx->sector = sector + cc->iv_offset;
 	ctx->write = write;
 }
@@ -563,18 +563,17 @@ static void process_read(struct dm_crypt
 	 * copy the required bvecs because we need the original
 	 * one in order to decrypt the whole bio data *afterwards*.
 	 */
-	clone = bio_alloc_bioset(GFP_NOIO, bio_segments(base_bio), cc->bs);
+	clone = bio_alloc_bioset(GFP_NOIO, base_bio->bi_vcnt, cc->bs);
 	if (unlikely(!clone)) {
 		dec_pending(io, -ENOMEM);
 		return;
 	}
 
 	clone_init(io, clone);
-	clone->bi_idx = 0;
-	clone->bi_vcnt = bio_segments(base_bio);
+	clone->bi_vcnt = base_bio->bi_vcnt;
 	clone->bi_size = base_bio->bi_size;
 	clone->bi_sector = cc->start + sector;
-	memcpy(clone->bi_io_vec, bio_iovec(base_bio),
+	memcpy(clone->bi_io_vec, base_bio->bi_io_vec,
 	       sizeof(struct bio_vec) * clone->bi_vcnt);
 
 	generic_make_request(clone);

diff .prev/drivers/md/dm-raid1.c ./drivers/md/dm-raid1.c
--- .prev/drivers/md/dm-raid1.c	2007-07-31 11:20:51.000000000 +1000
+++ ./drivers/md/dm-raid1.c	2007-07-31 11:21:03.000000000 +1000
@@ -831,7 +831,7 @@ static void do_write(struct mirror_set *
 	struct dm_io_request io_req = {
 		.bi_rw = WRITE,
 		.mem.type = DM_IO_BVEC,
-		.mem.ptr.bvec = bio->bi_io_vec + bio->bi_idx,
+		.mem.ptr.bvec = bio->bi_io_vec,
 		.notify.fn = write_callback,
 		.notify.context = bio,
 		.client = ms->io_client,

diff .prev/drivers/md/raid0.c ./drivers/md/raid0.c
--- .prev/drivers/md/raid0.c	2007-07-31 11:20:51.000000000 +1000
+++ ./drivers/md/raid0.c	2007-07-31 11:21:03.000000000 +1000
@@ -436,8 +436,7 @@ static int raid0_make_request (struct re
 	if (unlikely(chunk_sects < (bio->bi_sector & (chunk_sects - 1)) + (bio->bi_size >> 9))) {
 		struct bio_pair *bp;
 		/* Sanity check -- queue functions should prevent this happening */
-		if (bio->bi_vcnt != 1 ||
-		    bio->bi_idx != 0)
+		if (bio->bi_vcnt != 1)
 			goto bad_map;
 		/* This is a one page bio that upper layers
 		 * refuse to split for us, so we need to split it.

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2007-07-31 11:21:00.000000000 +1000
+++ ./drivers/md/raid10.c	2007-07-31 11:21:03.000000000 +1000
@@ -792,8 +792,7 @@ static int make_request(struct request_q
 		    conf->near_copies < conf->raid_disks)) {
 		struct bio_pair *bp;
 		/* Sanity check -- queue functions should prevent this happening */
-		if (bio->bi_vcnt != 1 ||
-		    bio->bi_idx != 0)
+		if (bio->bi_vcnt != 1)
 			goto bad_map;
 		/* This is a one page bio that upper layers
 		 * refuse to split for us, so we need to split it.
@@ -1278,7 +1277,6 @@ static void sync_request_write(mddev_t *
 		 */
 		tbio->bi_vcnt = vcnt;
 		tbio->bi_size = r10_bio->sectors << 9;
-		tbio->bi_idx = 0;
 		tbio->bi_phys_segments = 0;
 		tbio->bi_hw_segments = 0;
 		tbio->bi_flags &= ~(BIO_POOL_MASK - 1);
@@ -1884,7 +1882,6 @@ static sector_t sync_request(mddev_t *md
 		if (bio->bi_end_io)
 			bio->bi_flags |= 1 << BIO_UPTODATE;
 		bio->bi_vcnt = 0;
-		bio->bi_idx = 0;
 		bio->bi_phys_segments = 0;
 		bio->bi_hw_segments = 0;
 		bio->bi_size = 0;

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2007-07-31 11:21:00.000000000 +1000
+++ ./drivers/md/raid1.c	2007-07-31 11:21:03.000000000 +1000
@@ -910,14 +910,7 @@ static int make_request(struct request_q
 			struct bio_vec *bvec;
 			int j;
 
-			/* Yes, I really want the '__' version so that
-			 * we clear any unused pointer in the io_vec, rather
-			 * than leave them unchanged.  This is important
-			 * because when we come to free the pages, we won't
-			 * know the originial bi_idx, so we just free
-			 * them all
-			 */
-			__bio_for_each_segment(bvec, mbio, j, 0)
+			bio_for_each_segment(bvec, mbio, j)
 				bvec->bv_page = behind_pages[j];
 			if (test_bit(WriteMostly, &conf->mirrors[i].rdev->flags))
 				atomic_inc(&r1_bio->behind_remaining);
@@ -1251,7 +1244,6 @@ static void sync_request_write(mddev_t *
 					/* fixup the bio for reuse */
 					sbio->bi_vcnt = vcnt;
 					sbio->bi_size = r1_bio->sectors << 9;
-					sbio->bi_idx = 0;
 					sbio->bi_phys_segments = 0;
 					sbio->bi_hw_segments = 0;
 					sbio->bi_flags &= ~(BIO_POOL_MASK - 1);
@@ -1556,7 +1548,7 @@ static void raid1d(mddev_t *mddev)
 					bio = bio_clone(r1_bio->master_bio, GFP_NOIO);
 					/* copy pages from the failed bio, as
 					 * this might be a write-behind device */
-					__bio_for_each_segment(bvec, bio, j, 0)
+					bio_for_each_segment(bvec, bio, j)
 						bvec->bv_page = bio_iovec_idx(r1_bio->bios[i], j)->bv_page;
 					bio_put(r1_bio->bios[i]);
 					bio->bi_sector = r1_bio->sector +
@@ -1741,7 +1733,6 @@ static sector_t sync_request(mddev_t *md
 		bio->bi_flags |= 1 << BIO_UPTODATE;
 		bio->bi_rw = READ;
 		bio->bi_vcnt = 0;
-		bio->bi_idx = 0;
 		bio->bi_phys_segments = 0;
 		bio->bi_hw_segments = 0;
 		bio->bi_size = 0;

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-07-31 11:20:53.000000000 +1000
+++ ./drivers/md/raid5.c	2007-07-31 11:21:03.000000000 +1000
@@ -740,7 +740,6 @@ static void ops_run_io(struct stripe_hea
 			bi->bi_flags = 1 << BIO_UPTODATE;
 			bi->bi_vcnt = 1;
 			bi->bi_max_vecs = 1;
-			bi->bi_idx = 0;
 			bi->bi_io_vec = &sh->dev[i].vec;
 			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			bi->bi_io_vec[0].bv_offset = 0;
@@ -3611,7 +3610,6 @@ static void handle_stripe6(struct stripe
 			bi->bi_flags = 1 << BIO_UPTODATE;
 			bi->bi_vcnt = 1;
 			bi->bi_max_vecs = 1;
-			bi->bi_idx = 0;
 			bi->bi_io_vec = &sh->dev[i].vec;
 			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			bi->bi_io_vec[0].bv_offset = 0;

diff .prev/fs/bio.c ./fs/bio.c
--- .prev/fs/bio.c	2007-07-31 11:21:00.000000000 +1000
+++ ./fs/bio.c	2007-07-31 11:21:03.000000000 +1000
@@ -132,7 +132,6 @@ void bio_init(struct bio *bio)
 	bio->bi_flags = 1 << BIO_UPTODATE;
 	bio->bi_rw = 0;
 	bio->bi_vcnt = 0;
-	bio->bi_idx = 0;
 	bio->bi_phys_segments = 0;
 	bio->bi_hw_segments = 0;
 	bio->bi_size = 0;
@@ -267,7 +266,6 @@ void __bio_clone(struct bio *bio, struct
 	bio->bi_rw = bio_src->bi_rw;
 	bio->bi_vcnt = bio_src->bi_vcnt;
 	bio->bi_size = bio_src->bi_size;
-	bio->bi_idx = bio_src->bi_idx;
 	bio_phys_segments(q, bio);
 	bio_hw_segments(q, bio);
 }
@@ -496,7 +494,7 @@ int bio_uncopy_user(struct bio *bio)
 	struct bio_vec *bvec;
 	int i, ret = 0;
 
-	__bio_for_each_segment(bvec, bio, i, 0) {
+	bio_for_each_segment(bvec, bio, i) {
 		char *addr = page_address(bvec->bv_page);
 		unsigned int len = bmd->iovecs[i].bv_len;
 
@@ -772,7 +770,7 @@ static void __bio_unmap_user(struct bio 
 	/*
 	 * make sure we dirty pages we wrote to
 	 */
-	__bio_for_each_segment(bvec, bio, i, 0) {
+	bio_for_each_segment(bvec, bio, i) {
 		if (bio_data_dir(bio) == READ)
 			set_page_dirty_lock(bvec->bv_page);
 
@@ -1062,7 +1060,6 @@ struct bio_pair *bio_split(struct bio *b
 				bi->bi_sector + first_sectors);
 
 	BUG_ON(bi->bi_vcnt != 1);
-	BUG_ON(bi->bi_idx != 0);
 	atomic_set(&bp->cnt, 3);
 	bp->error = 0;
 	bp->bio1 = *bi;

diff .prev/fs/buffer.c ./fs/buffer.c
--- .prev/fs/buffer.c	2007-07-31 11:20:51.000000000 +1000
+++ ./fs/buffer.c	2007-07-31 11:21:03.000000000 +1000
@@ -2802,7 +2802,6 @@ int submit_bh(int rw, struct buffer_head
 	bio->bi_io_vec[0].bv_offset = bh_offset(bh);
 
 	bio->bi_vcnt = 1;
-	bio->bi_idx = 0;
 	bio->bi_size = bh->b_size;
 
 	bio->bi_end_io = end_bio_bh_io_sync;

diff .prev/fs/jfs/jfs_logmgr.c ./fs/jfs/jfs_logmgr.c
--- .prev/fs/jfs/jfs_logmgr.c	2007-07-31 11:20:51.000000000 +1000
+++ ./fs/jfs/jfs_logmgr.c	2007-07-31 11:21:03.000000000 +1000
@@ -2012,7 +2012,6 @@ static int lbmRead(struct jfs_log * log,
 	bio->bi_io_vec[0].bv_offset = bp->l_offset;
 
 	bio->bi_vcnt = 1;
-	bio->bi_idx = 0;
 	bio->bi_size = LOGPSIZE;
 
 	bio->bi_end_io = lbmIODone;
@@ -2153,7 +2152,6 @@ static void lbmStartIO(struct lbuf * bp)
 	bio->bi_io_vec[0].bv_offset = bp->l_offset;
 
 	bio->bi_vcnt = 1;
-	bio->bi_idx = 0;
 	bio->bi_size = LOGPSIZE;
 
 	bio->bi_end_io = lbmIODone;

diff .prev/fs/reiser4/page_cache.c ./fs/reiser4/page_cache.c
--- .prev/fs/reiser4/page_cache.c	2007-07-31 11:20:51.000000000 +1000
+++ ./fs/reiser4/page_cache.c	2007-07-31 11:21:03.000000000 +1000
@@ -451,7 +451,6 @@ static struct bio *page_bio(struct page 
 			return ERR_PTR(RETERR(-EINVAL));
 		}
 
-		/* bio -> bi_idx is filled by bio_init() */
 		bio->bi_end_io = (rw == READ) ?
 		    end_bio_single_page_read : end_bio_single_page_write;
 

diff .prev/include/asm-arm26/memory.h ./include/asm-arm26/memory.h
--- .prev/include/asm-arm26/memory.h	2007-07-31 11:20:06.000000000 +1000
+++ ./include/asm-arm26/memory.h	2007-07-31 11:21:03.000000000 +1000
@@ -88,7 +88,7 @@ static inline void *phys_to_virt(unsigne
 #define virt_addr_valid(kaddr)	((int)(kaddr) >= PAGE_OFFSET && (int)(kaddr) < (unsigned long)high_memory)
 
 /*
- * For BIO.  "will die".  Kill me when bio_to_phys() and bvec_to_phys() die.
+ * For BIO.  "will die".  Kill me when bvec_to_phys() dies.
  */
 #define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)
 

diff .prev/include/asm-arm/memory.h ./include/asm-arm/memory.h
--- .prev/include/asm-arm/memory.h	2007-07-31 11:20:06.000000000 +1000
+++ ./include/asm-arm/memory.h	2007-07-31 11:21:03.000000000 +1000
@@ -298,7 +298,7 @@ static inline __deprecated void *bus_to_
 #endif /* !CONFIG_DISCONTIGMEM */
 
 /*
- * For BIO.  "will die".  Kill me when bio_to_phys() and bvec_to_phys() die.
+ * For BIO.  "will die".  Kill me when bvec_to_phys() dies.
  */
 #define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)
 

diff .prev/include/linux/bio.h ./include/linux/bio.h
--- .prev/include/linux/bio.h	2007-07-31 11:21:00.000000000 +1000
+++ ./include/linux/bio.h	2007-07-31 11:21:03.000000000 +1000
@@ -80,7 +80,6 @@ struct bio {
 						 */
 
 	unsigned short		bi_vcnt;	/* how many bio_vec's */
-	unsigned short		bi_idx;		/* current index into bvl_vec */
 
 	/* Number of segments in this BIO after
 	 * physical address coalescing is performed.
@@ -163,10 +162,6 @@ struct bio {
  * various member access
  */
 #define bio_iovec_idx(bio, idx)	(&((bio)->bi_io_vec[(idx)]))
-#define bio_iovec(bio)		bio_iovec_idx((bio), (bio)->bi_idx)
-#define bio_page(bio)		bio_iovec((bio))->bv_page
-#define bio_offset(bio)		bio_iovec((bio))->bv_offset
-#define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_idx)
 #define bio_sectors(bio)	((bio)->bi_size >> 9)
 #define bio_barrier(bio)	((bio)->bi_rw & (1 << BIO_RW_BARRIER))
 #define bio_sync(bio)		((bio)->bi_rw & (1 << BIO_RW_SYNC))
@@ -177,7 +172,6 @@ struct bio {
 /*
  * will die
  */
-#define bio_to_phys(bio)	(page_to_phys(bio_page((bio))) + (unsigned long) bio_offset((bio)))
 #define bvec_to_phys(bv)	(page_to_phys((bv)->bv_page) + (unsigned long) (bv)->bv_offset)
 
 /*
@@ -197,7 +191,7 @@ struct bio {
  */
 
 #define __BVEC_END(bio)		bio_iovec_idx((bio), (bio)->bi_vcnt - 1)
-#define __BVEC_START(bio)	bio_iovec_idx((bio), (bio)->bi_idx)
+#define __BVEC_START(bio)	bio_iovec_idx((bio), 0)
 
 /*
  * allow arch override, for eg virtualized architectures (put in asm/io.h)
@@ -218,18 +212,11 @@ struct bio {
 
 #define bio_io_error(bio) bio_endio((bio), -EIO)
 
-/*
- * drivers should not use the __ version unless they _really_ want to
- * run through the entire bio and not just pending pieces
- */
-#define __bio_for_each_segment(bvl, bio, i, start_idx)			\
-	for (bvl = bio_iovec_idx((bio), (start_idx)), i = (start_idx);	\
+#define bio_for_each_segment(bvl, bio, i)				\
+	for (bvl = bio_iovec_idx((bio), 0), i = 0;			\
 	     i < (bio)->bi_vcnt;					\
 	     bvl++, i++)
 
-#define bio_for_each_segment(bvl, bio, i)				\
-	__bio_for_each_segment(bvl, bio, i, (bio)->bi_idx)
-
 /*
  * get a reference to a bio, so it won't disappear. the intended use is
  * something like:
@@ -350,7 +337,7 @@ static inline char *__bio_kmap_irq(struc
 #define __bio_kunmap_irq(buf, flags)	bvec_kunmap_irq(buf, flags)
 
 #define bio_kmap_irq(bio, flags) \
-	__bio_kmap_irq((bio), (bio)->bi_idx, (flags))
+	__bio_kmap_irq((bio), 0, (flags))
 #define bio_kunmap_irq(buf,flags)	__bio_kunmap_irq(buf, flags)
 
 #endif /* __LINUX_BIO_H */

diff .prev/include/linux/blkdev.h ./include/linux/blkdev.h
--- .prev/include/linux/blkdev.h	2007-07-31 11:21:00.000000000 +1000
+++ ./include/linux/blkdev.h	2007-07-31 11:21:03.000000000 +1000
@@ -655,7 +655,7 @@ struct req_iterator {
 	for (_iter.bio = (rq)->bio, _iter.offset = (rq)->first_offset;	       \
 	     _iter.bio;							       \
 	     _iter.bio = _iter.bio->bi_next, _iter.offset = 0) 		       \
-		for (_iter.i = _iter.bio->bi_idx; 			       \
+		for (_iter.i = 0;		 			       \
 		     _iter.i < _iter.bio->bi_vcnt;			       \
 		     _iter.i++						       \
 		)							       \

diff .prev/mm/bounce.c ./mm/bounce.c
--- .prev/mm/bounce.c	2007-07-31 11:20:51.000000000 +1000
+++ ./mm/bounce.c	2007-07-31 11:21:03.000000000 +1000
@@ -98,7 +98,7 @@ static void copy_to_high_bio_irq(struct 
 	struct bio_vec *tovec, *fromvec;
 	int i;
 
-	__bio_for_each_segment(tovec, to, i, 0) {
+	bio_for_each_segment(tovec, to, i) {
 		fromvec = from->bi_io_vec + i;
 
 		/*
@@ -131,7 +131,7 @@ static void bounce_end_io(struct bio *bi
 	/*
 	 * free up bounce indirect pages used
 	 */
-	__bio_for_each_segment(bvec, bio, i, 0) {
+	bio_for_each_segment(bvec, bio, i) {
 		org_vec = bio_orig->bi_io_vec + i;
 		if (bvec->bv_page == org_vec->bv_page)
 			continue;
@@ -228,7 +228,7 @@ static void __blk_queue_bounce(struct re
 	 * at least one page was bounced, fill in possible non-highmem
 	 * pages
 	 */
-	__bio_for_each_segment(from, *bio_orig, i, 0) {
+	bio_for_each_segment(from, *bio_orig, i) {
 		to = bio_iovec_idx(bio, i);
 		if (!to->bv_page) {
 			to->bv_page = from->bv_page;
@@ -243,7 +243,6 @@ static void __blk_queue_bounce(struct re
 	bio->bi_rw = (*bio_orig)->bi_rw;
 
 	bio->bi_vcnt = (*bio_orig)->bi_vcnt;
-	bio->bi_idx = (*bio_orig)->bi_idx;
 	bio->bi_size = (*bio_orig)->bi_size;
 
 	if (pool == page_pool) {

diff .prev/mm/page_io.c ./mm/page_io.c
--- .prev/mm/page_io.c	2007-07-31 11:20:51.000000000 +1000
+++ ./mm/page_io.c	2007-07-31 11:21:03.000000000 +1000
@@ -38,7 +38,6 @@ static struct bio *get_swap_bio(gfp_t gf
 		bio->bi_io_vec[0].bv_len = PAGE_SIZE;
 		bio->bi_io_vec[0].bv_offset = 0;
 		bio->bi_vcnt = 1;
-		bio->bi_idx = 0;
 		bio->bi_size = PAGE_SIZE;
 		bio->bi_end_io = end_io;
 	}
