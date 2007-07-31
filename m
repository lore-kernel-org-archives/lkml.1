Return-Path: <linux-kernel-owner+w=401wt.eu-S965994AbXGaCYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965994AbXGaCYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932273AbXGaCRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:17:44 -0400
Received: from ns1.suse.de ([195.135.220.2]:52799 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940457AbXGaCRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:17:41 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:17:27 +1000
Message-Id: <1070731021727.25362@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 019 of 35] Convert bio_for_each_segment to fill in a fresh bio_vec
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


i.e. instread of providing a pointer to each bio_vec, it provides
a copy of each bio_vec.

This allows a future patch to cause bio_for_each_segment to
provide bio_vecs that are not in the bi_io_vec list, thus allowing
for offsets and length restrictions.

We consequently remove the only call for bio_kmap_atomic,
and so remove that function as well.
Also remove bio_kmap_irq.  No-one uses it, and bvec_kmap_irq
is a much more usable interface.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./Documentation/block/biodoc.txt |    8 ++---
 ./block/ll_rw_blk.c              |    2 -
 ./drivers/block/loop.c           |   18 +++++++------
 ./drivers/block/rd.c             |    9 +++---
 ./drivers/md/raid1.c             |   22 ++++++++--------
 ./drivers/md/raid5.c             |   21 ++++++++-------
 ./drivers/s390/block/dcssblk.c   |   15 +++++------
 ./drivers/s390/block/xpram.c     |    8 ++---
 ./fs/bio.c                       |   42 ++++++++++++++++--------------
 ./include/linux/bio.h            |   37 ++++++++-------------------
 ./mm/bounce.c                    |   53 +++++++++++++++++++--------------------
 11 files changed, 114 insertions(+), 121 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-07-31 11:21:03.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-07-31 11:21:06.000000000 +1000
@@ -199,7 +199,7 @@ EXPORT_SYMBOL(blk_queue_softirq_done);
  * Caveat:
  *    The driver that does this *must* be able to deal appropriately
  *    with buffers in "highmemory". This can be accomplished by either calling
- *    __bio_kmap_atomic() to get a temporary kernel mapping, or by calling
+ *    bvec_kmap_irq() to get a temporary kernel mapping, or by calling
  *    blk_queue_bounce() to create a buffer in normal memory.
  **/
 void blk_queue_make_request(struct request_queue * q, make_request_fn * mfn)

diff .prev/Documentation/block/biodoc.txt ./Documentation/block/biodoc.txt
--- .prev/Documentation/block/biodoc.txt	2007-07-31 11:20:05.000000000 +1000
+++ ./Documentation/block/biodoc.txt	2007-07-31 11:21:06.000000000 +1000
@@ -216,8 +216,8 @@ may need to abort DMA operations and rev
 which case a virtual mapping of the page is required. For SCSI it is also
 done in some scenarios where the low level driver cannot be trusted to
 handle a single sg entry correctly. The driver is expected to perform the
-kmaps as needed on such occasions using the __bio_kmap_atomic and bio_kmap_irq
-routines as appropriate. A driver could also use the blk_queue_bounce()
+kmaps as needed on such occasions using the bvec_kmap_irq
+routine as appropriate. A driver could also use the blk_queue_bounce()
 routine on its own to bounce highmem i/o to low memory for specific requests
 if so desired.
 
@@ -1173,8 +1173,8 @@ use blk_rq_map_sg for scatter gather) to
 PIO drivers (or drivers that need to revert to PIO transfer once in a
 while (IDE for example)), where the CPU is doing the actual data
 transfer a virtual mapping is needed. If the driver supports highmem I/O,
-(Sec 1.1, (ii) ) it needs to use __bio_kmap_atomic and bio_kmap_irq to
-temporarily map a bio into the virtual address space.
+(Sec 1.1, (ii) ) it needs to use bvec_kmap_irq to temporarily map a
+bio into the virtual address space.
 
 
 8. Prior/Related/Impacted patches

diff .prev/drivers/block/loop.c ./drivers/block/loop.c
--- .prev/drivers/block/loop.c	2007-07-31 11:20:51.000000000 +1000
+++ ./drivers/block/loop.c	2007-07-31 11:21:06.000000000 +1000
@@ -343,9 +343,10 @@ static int lo_send(struct loop_device *l
 {
 	int (*do_lo_send)(struct loop_device *, struct bio_vec *, int, loff_t,
 			struct page *page);
-	struct bio_vec *bvec;
+	struct bio_vec bvec;
 	struct page *page = NULL;
-	int i, ret = 0;
+	int ret = 0;
+	struct bio_iterator i;
 
 	do_lo_send = do_lo_send_aops;
 	if (!(lo->lo_flags & LO_FLAGS_USE_AOPS)) {
@@ -359,10 +360,10 @@ static int lo_send(struct loop_device *l
 		}
 	}
 	bio_for_each_segment(bvec, bio, i) {
-		ret = do_lo_send(lo, bvec, bsize, pos, page);
+		ret = do_lo_send(lo, &bvec, bsize, pos, page);
 		if (ret < 0)
 			break;
-		pos += bvec->bv_len;
+		pos += bvec.bv_len;
 	}
 	if (page) {
 		kunmap(page);
@@ -456,14 +457,15 @@ do_lo_receive(struct loop_device *lo,
 static int
 lo_receive(struct loop_device *lo, struct bio *bio, int bsize, loff_t pos)
 {
-	struct bio_vec *bvec;
-	int i, ret = 0;
+	struct bio_vec bvec;
+	int ret = 0;
+	struct bio_iterator i;
 
 	bio_for_each_segment(bvec, bio, i) {
-		ret = do_lo_receive(lo, bvec, bsize, pos);
+		ret = do_lo_receive(lo, &bvec, bsize, pos);
 		if (ret < 0)
 			break;
-		pos += bvec->bv_len;
+		pos += bvec.bv_len;
 	}
 	return ret;
 }

diff .prev/drivers/block/rd.c ./drivers/block/rd.c
--- .prev/drivers/block/rd.c	2007-07-31 11:20:51.000000000 +1000
+++ ./drivers/block/rd.c	2007-07-31 11:21:06.000000000 +1000
@@ -271,8 +271,9 @@ static int rd_make_request(struct reques
 	sector_t sector = bio->bi_sector;
 	unsigned long len = bio->bi_size >> 9;
 	int rw = bio_data_dir(bio);
-	struct bio_vec *bvec;
-	int ret = 0, i;
+	struct bio_vec bvec;
+	int ret = 0;
+	struct bio_iterator i;
 
 	if (sector + len > get_capacity(bdev->bd_disk))
 		goto fail;
@@ -281,8 +282,8 @@ static int rd_make_request(struct reques
 		rw=READ;
 
 	bio_for_each_segment(bvec, bio, i) {
-		ret |= rd_blkdev_pagecache_IO(rw, bvec, sector, mapping);
-		sector += bvec->bv_len >> 9;
+		ret |= rd_blkdev_pagecache_IO(rw, &bvec, sector, mapping);
+		sector += bvec.bv_len >> 9;
 	}
 	if (ret)
 		goto fail;

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2007-07-31 11:21:03.000000000 +1000
+++ ./drivers/md/raid1.c	2007-07-31 11:21:06.000000000 +1000
@@ -730,20 +730,19 @@ static void unfreeze_array(conf_t *conf)
 static struct page **alloc_behind_pages(struct bio *bio)
 {
 	int i;
-	struct bio_vec *bvec;
 	struct page **pages = kzalloc(bio->bi_vcnt * sizeof(struct page *),
 					GFP_NOIO);
 	if (unlikely(!pages))
 		goto do_sync_io;
 
-	bio_for_each_segment(bvec, bio, i) {
+	for (i = 0; i < bio->bi_vcnt; i++) {
 		pages[i] = alloc_page(GFP_NOIO);
 		if (unlikely(!pages[i]))
 			goto do_sync_io;
-		memcpy(kmap(pages[i]) + bvec->bv_offset,
-			kmap(bvec->bv_page) + bvec->bv_offset, bvec->bv_len);
+		memcpy(kmap(pages[i]),
+		       kmap(bio->bi_io_vec[i].bv_page), PAGE_SIZE);
 		kunmap(pages[i]);
-		kunmap(bvec->bv_page);
+		kunmap(bio->bi_io_vec[i].bv_page);
 	}
 
 	return pages;
@@ -907,11 +906,10 @@ static int make_request(struct request_q
 		mbio->bi_private = r1_bio;
 
 		if (behind_pages) {
-			struct bio_vec *bvec;
 			int j;
 
-			bio_for_each_segment(bvec, mbio, j)
-				bvec->bv_page = behind_pages[j];
+			for (j = 0; j < mbio->bi_vcnt; j++)
+				mbio->bi_io_vec[j].bv_page = behind_pages[j];
 			if (test_bit(WriteMostly, &conf->mirrors[i].rdev->flags))
 				atomic_inc(&r1_bio->behind_remaining);
 		}
@@ -1542,14 +1540,16 @@ static void raid1d(mddev_t *mddev)
 					atomic_inc(&r1_bio->remaining);
 			for (i=0; i < conf->raid_disks; i++)
 				if (r1_bio->bios[i]) {
-					struct bio_vec *bvec;
 					int j;
 
 					bio = bio_clone(r1_bio->master_bio, GFP_NOIO);
 					/* copy pages from the failed bio, as
 					 * this might be a write-behind device */
-					bio_for_each_segment(bvec, bio, j)
-						bvec->bv_page = bio_iovec_idx(r1_bio->bios[i], j)->bv_page;
+					for (j = 0; j < bio->bi_vcnt ; j++)
+						bio->bi_io_vec[j].bv_page =
+							r1_bio->bios[i]->
+							  bi_io_vec[j].bv_page;
+
 					bio_put(r1_bio->bios[i]);
 					bio->bi_sector = r1_bio->sector +
 						conf->mirrors[i].rdev->data_offset;

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-07-31 11:21:03.000000000 +1000
+++ ./drivers/md/raid5.c	2007-07-31 11:21:06.000000000 +1000
@@ -765,9 +765,9 @@ static struct dma_async_tx_descriptor *
 async_copy_data(int frombio, struct bio *bio, struct page *page,
 	sector_t sector, struct dma_async_tx_descriptor *tx)
 {
-	struct bio_vec *bvl;
+	struct bio_vec bvl;
 	struct page *bio_page;
-	int i;
+	struct bio_iterator i;
 	int page_offset;
 
 	if (bio->bi_sector >= sector)
@@ -775,7 +775,7 @@ async_copy_data(int frombio, struct bio 
 	else
 		page_offset = (signed)(sector - bio->bi_sector) * -512;
 	bio_for_each_segment(bvl, bio, i) {
-		int len = bio_iovec_idx(bio, i)->bv_len;
+		int len = bvl.bv_len;
 		int clen;
 		int b_offset = 0;
 
@@ -791,8 +791,8 @@ async_copy_data(int frombio, struct bio 
 			clen = len;
 
 		if (clen > 0) {
-			b_offset += bio_iovec_idx(bio, i)->bv_offset;
-			bio_page = bio_iovec_idx(bio, i)->bv_page;
+			b_offset += bvl.bv_offset;
+			bio_page = bvl.bv_page;
 			if (frombio)
 				tx = async_memcpy(page, bio_page, page_offset,
 					b_offset, clen,
@@ -1948,8 +1948,8 @@ static void copy_data(int frombio, struc
 		     sector_t sector)
 {
 	char *pa = page_address(page);
-	struct bio_vec *bvl;
-	int i;
+	struct bio_vec bvl;
+	struct bio_iterator i;
 	int page_offset;
 
 	if (bio->bi_sector >= sector)
@@ -1957,7 +1957,7 @@ static void copy_data(int frombio, struc
 	else
 		page_offset = (signed)(sector - bio->bi_sector) * -512;
 	bio_for_each_segment(bvl, bio, i) {
-		int len = bio_iovec_idx(bio,i)->bv_len;
+		int len = bvl.bv_len;
 		int clen;
 		int b_offset = 0;
 
@@ -1972,12 +1972,13 @@ static void copy_data(int frombio, struc
 		else clen = len;
 
 		if (clen > 0) {
-			char *ba = __bio_kmap_atomic(bio, i, KM_USER0);
+			char *ba = kmap_atomic(bvl.bv_page, KM_USER0)
+				+ bvl.bv_offset;
 			if (frombio)
 				memcpy(pa+page_offset, ba+b_offset, clen);
 			else
 				memcpy(ba+b_offset, pa+page_offset, clen);
-			__bio_kunmap_atomic(ba, KM_USER0);
+			kunmap_atomic(ba - bvl.bv_offset, KM_USER0);
 		}
 		if (clen < len) /* hit end of page */
 			break;

diff .prev/drivers/s390/block/dcssblk.c ./drivers/s390/block/dcssblk.c
--- .prev/drivers/s390/block/dcssblk.c	2007-07-31 11:20:51.000000000 +1000
+++ ./drivers/s390/block/dcssblk.c	2007-07-31 11:21:06.000000000 +1000
@@ -624,12 +624,12 @@ static int
 dcssblk_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct dcssblk_dev_info *dev_info;
-	struct bio_vec *bvec;
+	struct bio_vec bvec;
 	unsigned long index;
 	unsigned long page_addr;
 	unsigned long source_addr;
 	unsigned long bytes_done;
-	int i;
+	struct bio_iterator i;
 
 	bytes_done = 0;
 	dev_info = bio->bi_bdev->bd_disk->private_data;
@@ -660,19 +660,20 @@ dcssblk_make_request(struct request_queu
 	index = (bio->bi_sector >> 3);
 	bio_for_each_segment(bvec, bio, i) {
 		page_addr = (unsigned long)
-			page_address(bvec->bv_page) + bvec->bv_offset;
+			page_address(bvec.bv_page) + bvec.bv_offset;
 		source_addr = dev_info->start + (index<<12) + bytes_done;
-		if (unlikely(page_addr & 4095) != 0 || (bvec->bv_len & 4095) != 0)
+		if (unlikely(page_addr & 4095) != 0
+		    || (bvec.bv_len & 4095) != 0)
 			// More paranoia.
 			goto fail;
 		if (bio_data_dir(bio) == READ) {
 			memcpy((void*)page_addr, (void*)source_addr,
-				bvec->bv_len);
+				bvec.bv_len);
 		} else {
 			memcpy((void*)source_addr, (void*)page_addr,
-				bvec->bv_len);
+				bvec.bv_len);
 		}
-		bytes_done += bvec->bv_len;
+		bytes_done += bvec.bv_len;
 	}
 	bio_endio(bio, 0);
 	return 0;

diff .prev/drivers/s390/block/xpram.c ./drivers/s390/block/xpram.c
--- .prev/drivers/s390/block/xpram.c	2007-07-31 11:20:51.000000000 +1000
+++ ./drivers/s390/block/xpram.c	2007-07-31 11:21:06.000000000 +1000
@@ -194,11 +194,11 @@ static unsigned long __init xpram_highes
 static int xpram_make_request(struct request_queue *q, struct bio *bio)
 {
 	xpram_device_t *xdev = bio->bi_bdev->bd_disk->private_data;
-	struct bio_vec *bvec;
+	struct bio_vec bvec;
 	unsigned int index;
 	unsigned long page_addr;
 	unsigned long bytes;
-	int i;
+	struct bio_iterator i;
 
 	if ((bio->bi_sector & 7) != 0 || (bio->bi_size & 4095) != 0)
 		/* Request is not page-aligned. */
@@ -211,8 +211,8 @@ static int xpram_make_request(struct req
 	index = (bio->bi_sector >> 3) + xdev->offset;
 	bio_for_each_segment(bvec, bio, i) {
 		page_addr = (unsigned long)
-			kmap(bvec->bv_page) + bvec->bv_offset;
-		bytes = bvec->bv_len;
+			kmap(bvec.bv_page) + bvec.bv_offset;
+		bytes = bvec.bv_len;
 		if ((page_addr & 4095) != 0 || (bytes & 4095) != 0)
 			/* More paranoia. */
 			goto fail;

diff .prev/fs/bio.c ./fs/bio.c
--- .prev/fs/bio.c	2007-07-31 11:21:03.000000000 +1000
+++ ./fs/bio.c	2007-07-31 11:21:06.000000000 +1000
@@ -195,13 +195,13 @@ struct bio *bio_alloc(gfp_t gfp_mask, in
 void zero_fill_bio(struct bio *bio)
 {
 	unsigned long flags;
-	struct bio_vec *bv;
-	int i;
+	struct bio_vec bv;
+	struct bio_iterator i;
 
 	bio_for_each_segment(bv, bio, i) {
-		char *data = bvec_kmap_irq(bv, &flags);
-		memset(data, 0, bv->bv_len);
-		flush_dcache_page(bv->bv_page);
+		char *data = bvec_kmap_irq(&bv, &flags);
+		memset(data, 0, bv.bv_len);
+		flush_dcache_page(bv.bv_page);
 		bvec_kunmap_irq(data, &flags);
 	}
 }
@@ -491,17 +491,18 @@ int bio_uncopy_user(struct bio *bio)
 {
 	struct bio_map_data *bmd = bio->bi_private;
 	const int read = bio_data_dir(bio) == READ;
-	struct bio_vec *bvec;
-	int i, ret = 0;
+	struct bio_vec bvec;
+	int ret = 0;
+	struct bio_iterator i;
 
 	bio_for_each_segment(bvec, bio, i) {
-		char *addr = page_address(bvec->bv_page);
-		unsigned int len = bmd->iovecs[i].bv_len;
+		char *addr = page_address(bvec.bv_page);
+		unsigned int len = bmd->iovecs[i.i].bv_len;
 
 		if (read && !ret && copy_to_user(bmd->userptr, addr, len))
 			ret = -EFAULT;
 
-		__free_page(bvec->bv_page);
+		__free_page(bvec.bv_page);
 		bmd->userptr += len;
 	}
 	bio_free_map_data(bmd);
@@ -526,10 +527,11 @@ struct bio *bio_copy_user(struct request
 	unsigned long end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	unsigned long start = uaddr >> PAGE_SHIFT;
 	struct bio_map_data *bmd;
-	struct bio_vec *bvec;
+	struct bio_vec bvec;
 	struct page *page;
 	struct bio *bio;
-	int i, ret;
+	int ret;
+	struct bio_iterator i;
 
 	bmd = bio_alloc_map_data(end - start);
 	if (!bmd)
@@ -577,11 +579,11 @@ struct bio *bio_copy_user(struct request
 		 */
 		ret = -EFAULT;
 		bio_for_each_segment(bvec, bio, i) {
-			char *addr = page_address(bvec->bv_page);
+			char *addr = page_address(bvec.bv_page);
 
-			if (copy_from_user(addr, p, bvec->bv_len))
+			if (copy_from_user(addr, p, bvec.bv_len))
 				goto cleanup;
-			p += bvec->bv_len;
+			p += bvec.bv_len;
 		}
 	}
 
@@ -589,7 +591,7 @@ struct bio *bio_copy_user(struct request
 	return bio;
 cleanup:
 	bio_for_each_segment(bvec, bio, i)
-		__free_page(bvec->bv_page);
+		__free_page(bvec.bv_page);
 
 	bio_put(bio);
 out_bmd:
@@ -764,17 +766,17 @@ struct bio *bio_map_user_iov(struct requ
 
 static void __bio_unmap_user(struct bio *bio)
 {
-	struct bio_vec *bvec;
-	int i;
+	struct bio_vec bvec;
+	struct bio_iterator i;
 
 	/*
 	 * make sure we dirty pages we wrote to
 	 */
 	bio_for_each_segment(bvec, bio, i) {
 		if (bio_data_dir(bio) == READ)
-			set_page_dirty_lock(bvec->bv_page);
+			set_page_dirty_lock(bvec.bv_page);
 
-		page_cache_release(bvec->bv_page);
+		page_cache_release(bvec.bv_page);
 	}
 
 	bio_put(bio);

diff .prev/include/linux/bio.h ./include/linux/bio.h
--- .prev/include/linux/bio.h	2007-07-31 11:21:03.000000000 +1000
+++ ./include/linux/bio.h	2007-07-31 11:21:06.000000000 +1000
@@ -175,18 +175,6 @@ struct bio {
 #define bvec_to_phys(bv)	(page_to_phys((bv)->bv_page) + (unsigned long) (bv)->bv_offset)
 
 /*
- * queues that have highmem support enabled may still need to revert to
- * PIO transfers occasionally and thus map high pages temporarily. For
- * permanent PIO fall back, user is probably better off disabling highmem
- * I/O completely on that queue (see ide-dma for example)
- */
-#define __bio_kmap_atomic(bio, idx, kmtype)				\
-	(kmap_atomic(bio_iovec_idx((bio), (idx))->bv_page, kmtype) +	\
-		bio_iovec_idx((bio), (idx))->bv_offset)
-
-#define __bio_kunmap_atomic(addr, kmtype) kunmap_atomic(addr, kmtype)
-
-/*
  * merge helpers etc
  */
 
@@ -212,10 +200,13 @@ struct bio {
 
 #define bio_io_error(bio) bio_endio((bio), -EIO)
 
+struct bio_iterator {
+	int i;
+};
 #define bio_for_each_segment(bvl, bio, i)				\
-	for (bvl = bio_iovec_idx((bio), 0), i = 0;			\
-	     i < (bio)->bi_vcnt;					\
-	     bvl++, i++)
+	for (i.i = 0, bvl = *bio_iovec_idx((bio), i.i);			\
+	     i.i < (bio)->bi_vcnt;					\
+	     i.i++, bvl = *bio_iovec_idx((bio), i.i))
 
 /*
  * get a reference to a bio, so it won't disappear. the intended use is
@@ -295,6 +286,11 @@ void zero_fill_bio(struct bio *bio);
 
 #ifdef CONFIG_HIGHMEM
 /*
+ * queues that have highmem support enabled may still need to revert to
+ * PIO transfers occasionally and thus map high pages temporarily. For
+ * permanent PIO fall back, user is probably better off disabling highmem
+ * I/O completely on that queue (see ide-dma for example)
+ *
  * remember to add offset! and never ever reenable interrupts between a
  * bvec_kmap_irq and bvec_kunmap_irq!!
  *
@@ -329,15 +325,4 @@ static inline void bvec_kunmap_irq(char 
 #define bvec_kunmap_irq(buf, flags)	do { *(flags) = 0; } while (0)
 #endif
 
-static inline char *__bio_kmap_irq(struct bio *bio, unsigned short idx,
-				   unsigned long *flags)
-{
-	return bvec_kmap_irq(bio_iovec_idx(bio, idx), flags);
-}
-#define __bio_kunmap_irq(buf, flags)	bvec_kunmap_irq(buf, flags)
-
-#define bio_kmap_irq(bio, flags) \
-	__bio_kmap_irq((bio), 0, (flags))
-#define bio_kunmap_irq(buf,flags)	__bio_kunmap_irq(buf, flags)
-
 #endif /* __LINUX_BIO_H */

diff .prev/mm/bounce.c ./mm/bounce.c
--- .prev/mm/bounce.c	2007-07-31 11:21:03.000000000 +1000
+++ ./mm/bounce.c	2007-07-31 11:21:06.000000000 +1000
@@ -95,16 +95,16 @@ int init_emergency_isa_pool(void)
 static void copy_to_high_bio_irq(struct bio *to, struct bio *from)
 {
 	unsigned char *vfrom;
-	struct bio_vec *tovec, *fromvec;
-	int i;
+	struct bio_vec tovec, *fromvec;
+	struct bio_iterator i;
 
 	bio_for_each_segment(tovec, to, i) {
-		fromvec = from->bi_io_vec + i;
+		fromvec = from->bi_io_vec + i.i;
 
 		/*
 		 * not bounced
 		 */
-		if (tovec->bv_page == fromvec->bv_page)
+		if (tovec.bv_page == fromvec->bv_page)
 			continue;
 
 		/*
@@ -112,18 +112,18 @@ static void copy_to_high_bio_irq(struct 
 		 * modified by the block layer, so use the original copy,
 		 * bounce_copy_vec already uses tovec->bv_len
 		 */
-		vfrom = page_address(fromvec->bv_page) + tovec->bv_offset;
+		vfrom = page_address(fromvec->bv_page) + tovec.bv_offset;
 
-		flush_dcache_page(tovec->bv_page);
-		bounce_copy_vec(tovec, vfrom);
+		flush_dcache_page(tovec.bv_page);
+		bounce_copy_vec(&tovec, vfrom);
 	}
 }
 
 static void bounce_end_io(struct bio *bio, mempool_t *pool, int err)
 {
 	struct bio *bio_orig = bio->bi_private;
-	struct bio_vec *bvec, *org_vec;
-	int i;
+	struct bio_vec bvec, *org_vec;
+	struct bio_iterator i;
 
 	if (test_bit(BIO_EOPNOTSUPP, &bio->bi_flags))
 		set_bit(BIO_EOPNOTSUPP, &bio_orig->bi_flags);
@@ -132,12 +132,12 @@ static void bounce_end_io(struct bio *bi
 	 * free up bounce indirect pages used
 	 */
 	bio_for_each_segment(bvec, bio, i) {
-		org_vec = bio_orig->bi_io_vec + i;
-		if (bvec->bv_page == org_vec->bv_page)
+		org_vec = bio_orig->bi_io_vec + i.i;
+		if (bvec.bv_page == org_vec->bv_page)
 			continue;
 
-		dec_zone_page_state(bvec->bv_page, NR_BOUNCE);
-		mempool_free(bvec->bv_page, pool);
+		dec_zone_page_state(bvec.bv_page, NR_BOUNCE);
+		mempool_free(bvec.bv_page, pool);
 	}
 
 	bio_endio(bio_orig, err);
@@ -180,11 +180,12 @@ static void __blk_queue_bounce(struct re
 {
 	struct page *page;
 	struct bio *bio = NULL;
-	int i, rw = bio_data_dir(*bio_orig);
-	struct bio_vec *to, *from;
+	int rw = bio_data_dir(*bio_orig);
+	struct bio_vec *to, from;
+	struct bio_iterator i;
 
 	bio_for_each_segment(from, *bio_orig, i) {
-		page = from->bv_page;
+		page = from.bv_page;
 
 		/*
 		 * is destination page below bounce pfn?
@@ -198,21 +199,21 @@ static void __blk_queue_bounce(struct re
 		if (!bio)
 			bio = bio_alloc(GFP_NOIO, (*bio_orig)->bi_vcnt);
 
-		to = bio->bi_io_vec + i;
+		to = bio->bi_io_vec + i.i;
 
 		to->bv_page = mempool_alloc(pool, q->bounce_gfp);
-		to->bv_len = from->bv_len;
-		to->bv_offset = from->bv_offset;
+		to->bv_len = from.bv_len;
+		to->bv_offset = from.bv_offset;
 		inc_zone_page_state(to->bv_page, NR_BOUNCE);
 
 		if (rw == WRITE) {
 			char *vto, *vfrom;
 
-			flush_dcache_page(from->bv_page);
+			flush_dcache_page(from.bv_page);
 			vto = page_address(to->bv_page) + to->bv_offset;
-			vfrom = kmap(from->bv_page) + from->bv_offset;
+			vfrom = kmap(from.bv_page) + from.bv_offset;
 			memcpy(vto, vfrom, to->bv_len);
-			kunmap(from->bv_page);
+			kunmap(from.bv_page);
 		}
 	}
 
@@ -229,11 +230,11 @@ static void __blk_queue_bounce(struct re
 	 * pages
 	 */
 	bio_for_each_segment(from, *bio_orig, i) {
-		to = bio_iovec_idx(bio, i);
+		to = bio_iovec_idx(bio, i.i);
 		if (!to->bv_page) {
-			to->bv_page = from->bv_page;
-			to->bv_len = from->bv_len;
-			to->bv_offset = from->bv_offset;
+			to->bv_page = from.bv_page;
+			to->bv_len = from.bv_len;
+			to->bv_offset = from.bv_offset;
 		}
 	}
 
