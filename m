Return-Path: <linux-kernel-owner+w=401wt.eu-S933559AbXHPLVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559AbXHPLVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 07:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933530AbXHPLVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 07:21:14 -0400
Received: from ns2.suse.de ([195.135.220.15]:48332 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933304AbXHPLVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 07:21:10 -0400
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 16 Aug 2007 21:21:00 +1000
Message-Id: <1070816112100.12182@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: [PATCH 002 of 6] Introduce rq_for_each_segment replacing rq_for_each_bio
References: <20070816211551.11839.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Every usage of rq_for_each_bio wraps a usage of
bio_for_each_segment, so these can be combined into
rq_for_each_segment.

We define "struct req_iterator" to hold the 'bio' and 'index' that
are needed for the double iteration.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./Documentation/block/biodoc.txt |   22 +++++++++++-----------
 ./block/ll_rw_blk.c              |   19 ++++++-------------
 ./drivers/block/floppy.c         |   14 ++++----------
 ./drivers/block/lguest_blk.c     |   10 ++++------
 ./drivers/block/nbd.c            |   22 +++++++++-------------
 ./drivers/block/ps3disk.c        |   29 +++++++++++++++--------------
 ./drivers/block/xen-blkfront.c   |    7 ++-----
 ./drivers/ide/ide-floppy.c       |   16 ++++++----------
 ./drivers/s390/block/dasd_diag.c |   11 +++--------
 ./drivers/s390/block/dasd_eckd.c |   15 ++++++---------
 ./drivers/s390/block/dasd_fba.c  |   15 ++++++---------
 ./drivers/s390/char/tape_34xx.c  |   15 +++++----------
 ./drivers/s390/char/tape_3590.c  |   16 ++++++----------
 ./include/linux/blkdev.h         |   15 ++++++++++++++-
 14 files changed, 97 insertions(+), 129 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-08-16 17:43:27.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-08-16 20:53:44.000000000 +1000
@@ -1233,8 +1233,7 @@ static void blk_recalc_rq_segments(struc
 	int seg_size;
 	int hw_seg_size;
 	int cluster;
-	struct bio *bio;
-	int i;
+	struct req_iterator iter;
 	int high, highprv = 1;
 	struct request_queue *q = rq->q;
 
@@ -1244,8 +1243,7 @@ static void blk_recalc_rq_segments(struc
 	cluster = q->queue_flags & (1 << QUEUE_FLAG_CLUSTER);
 	hw_seg_size = seg_size = 0;
 	phys_size = hw_size = nr_phys_segs = nr_hw_segs = 0;
-	rq_for_each_bio(bio, rq)
-	    bio_for_each_segment(bv, bio, i) {
+	rq_for_each_segment(bv, rq, iter) {
 		/*
 		 * the trick here is making sure that a high page is never
 		 * considered part of another segment, since that might
@@ -1342,8 +1340,8 @@ int blk_rq_map_sg(struct request_queue *
 		  struct scatterlist *sg)
 {
 	struct bio_vec *bvec, *bvprv;
-	struct bio *bio;
-	int nsegs, i, cluster;
+	struct req_iterator iter;
+	int nsegs, cluster;
 
 	nsegs = 0;
 	cluster = q->queue_flags & (1 << QUEUE_FLAG_CLUSTER);
@@ -1352,11 +1350,7 @@ int blk_rq_map_sg(struct request_queue *
 	 * for each bio in rq
 	 */
 	bvprv = NULL;
-	rq_for_each_bio(bio, rq) {
-		/*
-		 * for each segment in bio
-		 */
-		bio_for_each_segment(bvec, bio, i) {
+	rq_for_each_segment(bvec, rq, iter) {
 			int nbytes = bvec->bv_len;
 
 			if (bvprv && cluster) {
@@ -1379,8 +1373,7 @@ new_segment:
 				nsegs++;
 			}
 			bvprv = bvec;
-		} /* segments in bio */
-	} /* bios in rq */
+	} /* segments in rq */
 
 	return nsegs;
 }

diff .prev/Documentation/block/biodoc.txt ./Documentation/block/biodoc.txt
--- .prev/Documentation/block/biodoc.txt	2007-08-16 20:51:10.000000000 +1000
+++ ./Documentation/block/biodoc.txt	2007-08-16 20:52:51.000000000 +1000
@@ -477,9 +477,9 @@ With this multipage bio design:
   the same bi_io_vec array, but with the index and size accordingly modified)
 - A linked list of bios is used as before for unrelated merges (*) - this
   avoids reallocs and makes independent completions easier to handle.
-- Code that traverses the req list needs to make a distinction between
-  segments of a request (bio_for_each_segment) and the distinct completion
-  units/bios (rq_for_each_bio).
+- Code that traverses the req list can find all the segments of a bio
+  by using rq_for_each_segment.  This handles the fact that a request
+  has multiple bios, each of which can have multiple segments.
 - Drivers which can't process a large bio in one shot can use the bi_idx
   field to keep track of the next bio_vec entry to process.
   (e.g a 1MB bio_vec needs to be handled in max 128kB chunks for IDE)
@@ -664,14 +664,14 @@ in lvm or md.
 
 3.2.1 Traversing segments and completion units in a request
 
-The macros bio_for_each_segment() and rq_for_each_bio() should be used for
-traversing the bios in the request list (drivers should avoid directly
-trying to do it themselves). Using these helpers should also make it easier
-to cope with block changes in the future.
-
-	rq_for_each_bio(bio, rq)
-		bio_for_each_segment(bio_vec, bio, i)
-			/* bio_vec is now current segment */
+The macro rq_for_each_segment() should be used for traversing the bios
+in the request list (drivers should avoid directly trying to do it
+themselves). Using these helpers should also make it easier to cope
+with block changes in the future.
+
+	struct req_iterator iter;
+	rq_for_each_segment(bio_vec, rq, iter)
+		/* bio_vec is now current segment */
 
 I/O completion callbacks are per-bio rather than per-segment, so drivers
 that traverse bio chains on completion need to keep that in mind. Drivers

diff .prev/drivers/block/floppy.c ./drivers/block/floppy.c
--- .prev/drivers/block/floppy.c	2007-08-16 17:18:38.000000000 +1000
+++ ./drivers/block/floppy.c	2007-08-16 17:55:58.000000000 +1000
@@ -2450,23 +2450,20 @@ static void rw_interrupt(void)
 /* Compute maximal contiguous buffer size. */
 static int buffer_chain_size(void)
 {
-	struct bio *bio;
 	struct bio_vec *bv;
 	int size;
-	int i;
+	struct req_iterator iter;
 	char *base;
 
 	base = bio_data(current_req->bio);
 	size = 0;
 
-	rq_for_each_bio(bio, current_req) {
-		bio_for_each_segment(bv, bio, i) {
+	rq_for_each_segment(bv, current_req, iter) {
 			if (page_address(bv->bv_page) + bv->bv_offset !=
 			    base + size)
 				break;
 
 			size += bv->bv_len;
-		}
 	}
 
 	return size >> 9;
@@ -2493,11 +2490,10 @@ static void copy_buffer(int ssize, int m
 {
 	int remaining;		/* number of transferred 512-byte sectors */
 	struct bio_vec *bv;
-	struct bio *bio;
 	char *buffer;
 	char *dma_buffer;
 	int size;
-	int i;
+	struct req_iterator iter;
 
 	max_sector = transfer_size(ssize,
 				   min(max_sector, max_sector_2),
@@ -2530,8 +2526,7 @@ static void copy_buffer(int ssize, int m
 
 	size = current_req->current_nr_sectors << 9;
 
-	rq_for_each_bio(bio, current_req) {
-		bio_for_each_segment(bv, bio, i) {
+	rq_for_each_segment(bv, current_req, iter) {
 			if (!remaining)
 				break;
 
@@ -2566,7 +2561,6 @@ static void copy_buffer(int ssize, int m
 
 			remaining -= size;
 			dma_buffer += size;
-		}
 	}
 #ifdef FLOPPY_SANITY_CHECK
 	if (remaining) {

diff .prev/drivers/block/lguest_blk.c ./drivers/block/lguest_blk.c
--- .prev/drivers/block/lguest_blk.c	2007-08-16 17:18:37.000000000 +1000
+++ ./drivers/block/lguest_blk.c	2007-08-16 17:58:14.000000000 +1000
@@ -142,12 +142,11 @@ static irqreturn_t lgb_irq(int irq, void
  * return the total length. */
 static unsigned int req_to_dma(struct request *req, struct lguest_dma *dma)
 {
-	unsigned int i = 0, idx, len = 0;
-	struct bio *bio;
+	unsigned int i = 0, len = 0;
+	struct req_iterator iter;
+	struct bio_vec *bvec;
 
-	rq_for_each_bio(bio, req) {
-		struct bio_vec *bvec;
-		bio_for_each_segment(bvec, bio, idx) {
+	rq_for_each_segment(bvec, req, iter) {
 			/* We told the block layer not to give us too many. */
 			BUG_ON(i == LGUEST_MAX_DMA_SECTIONS);
 			/* If we had a zero-length segment, it would look like
@@ -160,7 +159,6 @@ static unsigned int req_to_dma(struct re
 			dma->len[i] = bvec->bv_len;
 			len += bvec->bv_len;
 			i++;
-		}
 	}
 	/* If the array isn't full, we mark the end with a 0 length */
 	if (i < LGUEST_MAX_DMA_SECTIONS)

diff .prev/drivers/block/nbd.c ./drivers/block/nbd.c
--- .prev/drivers/block/nbd.c	2007-08-16 17:18:37.000000000 +1000
+++ ./drivers/block/nbd.c	2007-08-16 20:31:41.000000000 +1000
@@ -180,7 +180,7 @@ static inline int sock_send_bvec(struct 
 
 static int nbd_send_req(struct nbd_device *lo, struct request *req)
 {
-	int result, i, flags;
+	int result, flags;
 	struct nbd_request request;
 	unsigned long size = req->nr_sectors << 9;
 	struct socket *sock = lo->sock;
@@ -205,16 +205,15 @@ static int nbd_send_req(struct nbd_devic
 	}
 
 	if (nbd_cmd(req) == NBD_CMD_WRITE) {
-		struct bio *bio;
+		struct req_iterator iter;
+		struct bio_vec *bvec;
 		/*
 		 * we are really probing at internals to determine
 		 * whether to set MSG_MORE or not...
 		 */
-		rq_for_each_bio(bio, req) {
-			struct bio_vec *bvec;
-			bio_for_each_segment(bvec, bio, i) {
+		rq_for_each_segment(bvec, req, iter) {
 				flags = 0;
-				if ((i < (bio->bi_vcnt - 1)) || bio->bi_next)
+				if (!rq_iter_last(req, iter))
 					flags = MSG_MORE;
 				dprintk(DBG_TX, "%s: request %p: sending %d bytes data\n",
 						lo->disk->disk_name, req,
@@ -226,7 +225,6 @@ static int nbd_send_req(struct nbd_devic
 							result);
 					goto error_out;
 				}
-			}
 		}
 	}
 	return 0;
@@ -317,11 +315,10 @@ static struct request *nbd_read_stat(str
 	dprintk(DBG_RX, "%s: request %p: got reply\n",
 			lo->disk->disk_name, req);
 	if (nbd_cmd(req) == NBD_CMD_READ) {
-		int i;
-		struct bio *bio;
-		rq_for_each_bio(bio, req) {
-			struct bio_vec *bvec;
-			bio_for_each_segment(bvec, bio, i) {
+		struct req_iterator iter;
+		struct bio_vec *bvec;
+
+		rq_for_each_segment(bvec, req, iter) {
 				result = sock_recv_bvec(sock, bvec);
 				if (result <= 0) {
 					printk(KERN_ERR "%s: Receive data failed (result %d)\n",
@@ -332,7 +329,6 @@ static struct request *nbd_read_stat(str
 				}
 				dprintk(DBG_RX, "%s: request %p: got %d bytes data\n",
 					lo->disk->disk_name, req, bvec->bv_len);
-			}
 		}
 	}
 	return req;

diff .prev/drivers/block/ps3disk.c ./drivers/block/ps3disk.c
--- .prev/drivers/block/ps3disk.c	2007-08-16 20:37:26.000000000 +1000
+++ ./drivers/block/ps3disk.c	2007-08-16 20:50:07.000000000 +1000
@@ -91,30 +91,30 @@ static void ps3disk_scatter_gather(struc
 				   struct request *req, int gather)
 {
 	unsigned int offset = 0;
-	struct bio *bio;
-	sector_t sector;
+	struct req_iterator iter;
 	struct bio_vec *bvec;
-	unsigned int i = 0, j;
+	unsigned int i = 0;
 	size_t size;
 	void *buf;
 
-	rq_for_each_bio(bio, req) {
-		sector = bio->bi_sector;
+	rq_for_each_segment(bvec, req, iter) {
+		unsigned long flags;
 		dev_dbg(&dev->sbd.core,
 			"%s:%u: bio %u: %u segs %u sectors from %lu\n",
-			__func__, __LINE__, i, bio_segments(bio),
-			bio_sectors(bio), sector);
-		bio_for_each_segment(bvec, bio, j) {
+			__func__, __LINE__, i, bio_segments(iter.bio),
+			bio_sectors(iter.bio),
+			(unsigned long)iter.bio->bi_sector);
+
 			size = bvec->bv_len;
-			buf = __bio_kmap_atomic(bio, j, KM_IRQ0);
+			buf = bvec_kmap_irq(bvec, flags);
 			if (gather)
 				memcpy(dev->bounce_buf+offset, buf, size);
 			else
 				memcpy(buf, dev->bounce_buf+offset, size);
 			offset += size;
 			flush_kernel_dcache_page(bio_iovec_idx(bio, j)->bv_page);
-			__bio_kunmap_atomic(bio, KM_IRQ0);
-		}
+			bio_kunmap_bvec(bvec, flags);
+
 		i++;
 	}
 }
@@ -130,12 +130,13 @@ static int ps3disk_submit_request_sg(str
 
 #ifdef DEBUG
 	unsigned int n = 0;
-	struct bio *bio;
+	struct bio_vec *bv;
+	struct req_iterator iter;
 
-	rq_for_each_bio(bio, req)
+	rq_for_each_segment(bv, req, iter)
 		n++;
 	dev_dbg(&dev->sbd.core,
-		"%s:%u: %s req has %u bios for %lu sectors %lu hard sectors\n",
+		"%s:%u: %s req has %u bvecs for %lu sectors %lu hard sectors\n",
 		__func__, __LINE__, op, n, req->nr_sectors,
 		req->hard_nr_sectors);
 #endif

diff .prev/drivers/block/xen-blkfront.c ./drivers/block/xen-blkfront.c
--- .prev/drivers/block/xen-blkfront.c	2007-08-16 17:18:37.000000000 +1000
+++ ./drivers/block/xen-blkfront.c	2007-08-16 18:03:12.000000000 +1000
@@ -150,9 +150,8 @@ static int blkif_queue_request(struct re
 	struct blkfront_info *info = req->rq_disk->private_data;
 	unsigned long buffer_mfn;
 	struct blkif_request *ring_req;
-	struct bio *bio;
+	struct req_iterator iter;
 	struct bio_vec *bvec;
-	int idx;
 	unsigned long id;
 	unsigned int fsect, lsect;
 	int ref;
@@ -186,8 +185,7 @@ static int blkif_queue_request(struct re
 		ring_req->operation = BLKIF_OP_WRITE_BARRIER;
 
 	ring_req->nr_segments = 0;
-	rq_for_each_bio (bio, req) {
-		bio_for_each_segment (bvec, bio, idx) {
+	rq_for_each_segment(bvec, req, iter) {
 			BUG_ON(ring_req->nr_segments
 			       == BLKIF_MAX_SEGMENTS_PER_REQUEST);
 			buffer_mfn = pfn_to_mfn(page_to_pfn(bvec->bv_page));
@@ -213,7 +211,6 @@ static int blkif_queue_request(struct re
 					.last_sect  = lsect };
 
 			ring_req->nr_segments++;
-		}
 	}
 
 	info->ring.req_prod_pvt++;

diff .prev/drivers/ide/ide-floppy.c ./drivers/ide/ide-floppy.c
--- .prev/drivers/ide/ide-floppy.c	2007-08-16 17:18:37.000000000 +1000
+++ ./drivers/ide/ide-floppy.c	2007-08-16 18:04:55.000000000 +1000
@@ -606,13 +606,12 @@ static void idefloppy_input_buffers (ide
 {
 	struct request *rq = pc->rq;
 	struct bio_vec *bvec;
-	struct bio *bio;
+	struct req_iterator iter;
 	unsigned long flags;
 	char *data;
-	int count, i, done = 0;
+	int count, done = 0;
 
-	rq_for_each_bio(bio, rq) {
-		bio_for_each_segment(bvec, bio, i) {
+	rq_for_each_segment(bvec, rq, iter) {
 			if (!bcount)
 				break;
 
@@ -625,7 +624,6 @@ static void idefloppy_input_buffers (ide
 			bcount -= count;
 			pc->b_count += count;
 			done += count;
-		}
 	}
 
 	idefloppy_do_end_request(drive, 1, done >> 9);
@@ -639,14 +637,13 @@ static void idefloppy_input_buffers (ide
 static void idefloppy_output_buffers (ide_drive_t *drive, idefloppy_pc_t *pc, unsigned int bcount)
 {
 	struct request *rq = pc->rq;
-	struct bio *bio;
+	struct req_iterator iter;
 	struct bio_vec *bvec;
 	unsigned long flags;
-	int count, i, done = 0;
+	int count, done = 0;
 	char *data;
 
-	rq_for_each_bio(bio, rq) {
-		bio_for_each_segment(bvec, bio, i) {
+	rq_for_each_segment(bvec, rq, iter) {
 			if (!bcount)
 				break;
 
@@ -659,7 +656,6 @@ static void idefloppy_output_buffers (id
 			bcount -= count;
 			pc->b_count += count;
 			done += count;
-		}
 	}
 
 	idefloppy_do_end_request(drive, 1, done >> 9);

diff .prev/drivers/s390/block/dasd_diag.c ./drivers/s390/block/dasd_diag.c
--- .prev/drivers/s390/block/dasd_diag.c	2007-08-16 17:18:37.000000000 +1000
+++ ./drivers/s390/block/dasd_diag.c	2007-08-16 18:06:21.000000000 +1000
@@ -471,14 +471,13 @@ dasd_diag_build_cp(struct dasd_device * 
 	struct dasd_ccw_req *cqr;
 	struct dasd_diag_req *dreq;
 	struct dasd_diag_bio *dbio;
-	struct bio *bio;
+	struct req_iterator iter;
 	struct bio_vec *bv;
 	char *dst;
 	unsigned int count, datasize;
 	sector_t recid, first_rec, last_rec;
 	unsigned int blksize, off;
 	unsigned char rw_cmd;
-	int i;
 
 	if (rq_data_dir(req) == READ)
 		rw_cmd = MDSK_READ_REQ;
@@ -492,13 +491,11 @@ dasd_diag_build_cp(struct dasd_device * 
 	last_rec = (req->sector + req->nr_sectors - 1) >> device->s2b_shift;
 	/* Check struct bio and count the number of blocks for the request. */
 	count = 0;
-	rq_for_each_bio(bio, req) {
-		bio_for_each_segment(bv, bio, i) {
+	rq_for_each_segment(bv, req, iter) {
 			if (bv->bv_len & (blksize - 1))
 				/* Fba can only do full blocks. */
 				return ERR_PTR(-EINVAL);
 			count += bv->bv_len >> (device->s2b_shift + 9);
-		}
 	}
 	/* Paranoia. */
 	if (count != last_rec - first_rec + 1)
@@ -515,8 +512,7 @@ dasd_diag_build_cp(struct dasd_device * 
 	dreq->block_count = count;
 	dbio = dreq->bio;
 	recid = first_rec;
-	rq_for_each_bio(bio, req) {
-		bio_for_each_segment(bv, bio, i) {
+	rq_for_each_segment(bv, req, iter) {
 			dst = page_address(bv->bv_page) + bv->bv_offset;
 			for (off = 0; off < bv->bv_len; off += blksize) {
 				memset(dbio, 0, sizeof (struct dasd_diag_bio));
@@ -527,7 +523,6 @@ dasd_diag_build_cp(struct dasd_device * 
 				dst += blksize;
 				recid++;
 			}
-		}
 	}
 	cqr->retries = DIAG_MAX_RETRIES;
 	cqr->buildclk = get_clock();

diff .prev/drivers/s390/block/dasd_eckd.c ./drivers/s390/block/dasd_eckd.c
--- .prev/drivers/s390/block/dasd_eckd.c	2007-08-16 17:18:37.000000000 +1000
+++ ./drivers/s390/block/dasd_eckd.c	2007-08-16 18:07:59.000000000 +1000
@@ -1176,7 +1176,7 @@ dasd_eckd_build_cp(struct dasd_device * 
 	struct LO_eckd_data *LO_data;
 	struct dasd_ccw_req *cqr;
 	struct ccw1 *ccw;
-	struct bio *bio;
+	struct req_iterator iter
 	struct bio_vec *bv;
 	char *dst;
 	unsigned int blksize, blk_per_trk, off;
@@ -1185,7 +1185,6 @@ dasd_eckd_build_cp(struct dasd_device * 
 	sector_t first_trk, last_trk;
 	unsigned int first_offs, last_offs;
 	unsigned char cmd, rcmd;
-	int i;
 
 	private = (struct dasd_eckd_private *) device->private;
 	if (rq_data_dir(req) == READ)
@@ -1206,8 +1205,7 @@ dasd_eckd_build_cp(struct dasd_device * 
 	/* Check struct bio and count the number of blocks for the request. */
 	count = 0;
 	cidaw = 0;
-	rq_for_each_bio(bio, req) {
-		bio_for_each_segment(bv, bio, i) {
+	rq_for_each_segment(bv, req, iter) {
 			if (bv->bv_len & (blksize - 1))
 				/* Eckd can only do full blocks. */
 				return ERR_PTR(-EINVAL);
@@ -1217,7 +1215,6 @@ dasd_eckd_build_cp(struct dasd_device * 
 					    bv->bv_len))
 				cidaw += bv->bv_len >> (device->s2b_shift + 9);
 #endif
-		}
 	}
 	/* Paranoia. */
 	if (count != last_rec - first_rec + 1)
@@ -1257,7 +1254,7 @@ dasd_eckd_build_cp(struct dasd_device * 
 		locate_record(ccw++, LO_data++, first_trk, first_offs + 1,
 			      last_rec - recid + 1, cmd, device, blksize);
 	}
-	rq_for_each_bio(bio, req) bio_for_each_segment(bv, bio, i) {
+	rq_for_each_segment(bv, req, iter) {
 		dst = page_address(bv->bv_page) + bv->bv_offset;
 		if (dasd_page_cache) {
 			char *copy = kmem_cache_alloc(dasd_page_cache,
@@ -1328,12 +1325,12 @@ dasd_eckd_free_cp(struct dasd_ccw_req *c
 {
 	struct dasd_eckd_private *private;
 	struct ccw1 *ccw;
-	struct bio *bio;
+	struct req_iterator iter;
 	struct bio_vec *bv;
 	char *dst, *cda;
 	unsigned int blksize, blk_per_trk, off;
 	sector_t recid;
-	int i, status;
+	int status;
 
 	if (!dasd_page_cache)
 		goto out;
@@ -1346,7 +1343,7 @@ dasd_eckd_free_cp(struct dasd_ccw_req *c
 	ccw++;
 	if (private->uses_cdl == 0 || recid > 2*blk_per_trk)
 		ccw++;
-	rq_for_each_bio(bio, req) bio_for_each_segment(bv, bio, i) {
+	rq_for_each_segment(bv, req, iter) {
 		dst = page_address(bv->bv_page) + bv->bv_offset;
 		for (off = 0; off < bv->bv_len; off += blksize) {
 			/* Skip locate record. */

diff .prev/drivers/s390/block/dasd_fba.c ./drivers/s390/block/dasd_fba.c
--- .prev/drivers/s390/block/dasd_fba.c	2007-08-16 17:18:37.000000000 +1000
+++ ./drivers/s390/block/dasd_fba.c	2007-08-16 18:09:43.000000000 +1000
@@ -234,14 +234,13 @@ dasd_fba_build_cp(struct dasd_device * d
 	struct LO_fba_data *LO_data;
 	struct dasd_ccw_req *cqr;
 	struct ccw1 *ccw;
-	struct bio *bio;
+	struct req_iterator iter;
 	struct bio_vec *bv;
 	char *dst;
 	int count, cidaw, cplength, datasize;
 	sector_t recid, first_rec, last_rec;
 	unsigned int blksize, off;
 	unsigned char cmd;
-	int i;
 
 	private = (struct dasd_fba_private *) device->private;
 	if (rq_data_dir(req) == READ) {
@@ -257,8 +256,7 @@ dasd_fba_build_cp(struct dasd_device * d
 	/* Check struct bio and count the number of blocks for the request. */
 	count = 0;
 	cidaw = 0;
-	rq_for_each_bio(bio, req) {
-		bio_for_each_segment(bv, bio, i) {
+	rq_for_each_segment(bv, req, iter) {
 			if (bv->bv_len & (blksize - 1))
 				/* Fba can only do full blocks. */
 				return ERR_PTR(-EINVAL);
@@ -268,7 +266,6 @@ dasd_fba_build_cp(struct dasd_device * d
 					    bv->bv_len))
 				cidaw += bv->bv_len / blksize;
 #endif
-		}
 	}
 	/* Paranoia. */
 	if (count != last_rec - first_rec + 1)
@@ -304,7 +301,7 @@ dasd_fba_build_cp(struct dasd_device * d
 		locate_record(ccw++, LO_data++, rq_data_dir(req), 0, count);
 	}
 	recid = first_rec;
-	rq_for_each_bio(bio, req) bio_for_each_segment(bv, bio, i) {
+	rq_for_each_segment(bv, req, iter) {
 		dst = page_address(bv->bv_page) + bv->bv_offset;
 		if (dasd_page_cache) {
 			char *copy = kmem_cache_alloc(dasd_page_cache,
@@ -359,11 +356,11 @@ dasd_fba_free_cp(struct dasd_ccw_req *cq
 {
 	struct dasd_fba_private *private;
 	struct ccw1 *ccw;
-	struct bio *bio;
+	struct req_iterator iter;
 	struct bio_vec *bv;
 	char *dst, *cda;
 	unsigned int blksize, off;
-	int i, status;
+	int status;
 
 	if (!dasd_page_cache)
 		goto out;
@@ -374,7 +371,7 @@ dasd_fba_free_cp(struct dasd_ccw_req *cq
 	ccw++;
 	if (private->rdc_data.mode.bits.data_chain != 0)
 		ccw++;
-	rq_for_each_bio(bio, req) bio_for_each_segment(bv, bio, i) {
+	rq_for_each_segment(bv, req, iter) {
 		dst = page_address(bv->bv_page) + bv->bv_offset;
 		for (off = 0; off < bv->bv_len; off += blksize) {
 			/* Skip locate record. */

diff .prev/drivers/s390/char/tape_34xx.c ./drivers/s390/char/tape_34xx.c
--- .prev/drivers/s390/char/tape_34xx.c	2007-08-16 17:18:37.000000000 +1000
+++ ./drivers/s390/char/tape_34xx.c	2007-08-16 18:10:50.000000000 +1000
@@ -1134,21 +1134,18 @@ tape_34xx_bread(struct tape_device *devi
 {
 	struct tape_request *request;
 	struct ccw1 *ccw;
-	int count = 0, i;
+	int count = 0;
 	unsigned off;
 	char *dst;
 	struct bio_vec *bv;
-	struct bio *bio;
+	struct req_iterator iter;
 	struct tape_34xx_block_id *	start_block;
 
 	DBF_EVENT(6, "xBREDid:");
 
 	/* Count the number of blocks for the request. */
-	rq_for_each_bio(bio, req) {
-		bio_for_each_segment(bv, bio, i) {
-			count += bv->bv_len >> (TAPEBLOCK_HSEC_S2B + 9);
-		}
-	}
+	rq_for_each_segment(bv, req, iter)
+		count += bv->bv_len >> (TAPEBLOCK_HSEC_S2B + 9);
 
 	/* Allocate the ccw request. */
 	request = tape_alloc_request(3+count+1, 8);
@@ -1175,8 +1172,7 @@ tape_34xx_bread(struct tape_device *devi
 	ccw = tape_ccw_cc(ccw, NOP, 0, NULL);
 	ccw = tape_ccw_cc(ccw, NOP, 0, NULL);
 
-	rq_for_each_bio(bio, req) {
-		bio_for_each_segment(bv, bio, i) {
+	rq_for_each_segment(bv, req, iter) {
 			dst = kmap(bv->bv_page) + bv->bv_offset;
 			for (off = 0; off < bv->bv_len;
 			     off += TAPEBLOCK_HSEC_SIZE) {
@@ -1187,7 +1183,6 @@ tape_34xx_bread(struct tape_device *devi
 				ccw++;
 				dst += TAPEBLOCK_HSEC_SIZE;
 			}
-		}
 	}
 
 	ccw = tape_ccw_end(ccw, NOP, 0, NULL);

diff .prev/drivers/s390/char/tape_3590.c ./drivers/s390/char/tape_3590.c
--- .prev/drivers/s390/char/tape_3590.c	2007-08-16 17:18:37.000000000 +1000
+++ ./drivers/s390/char/tape_3590.c	2007-08-16 20:30:31.000000000 +1000
@@ -623,21 +623,19 @@ tape_3590_bread(struct tape_device *devi
 {
 	struct tape_request *request;
 	struct ccw1 *ccw;
-	int count = 0, start_block, i;
+	int count = 0, start_block;
 	unsigned off;
 	char *dst;
 	struct bio_vec *bv;
-	struct bio *bio;
+	struct req_iterator iter;
 
 	DBF_EVENT(6, "xBREDid:");
 	start_block = req->sector >> TAPEBLOCK_HSEC_S2B;
 	DBF_EVENT(6, "start_block = %i\n", start_block);
 
-	rq_for_each_bio(bio, req) {
-		bio_for_each_segment(bv, bio, i) {
-			count += bv->bv_len >> (TAPEBLOCK_HSEC_S2B + 9);
-		}
-	}
+	rq_for_each_segment(bv, req, iter)
+		count += bv->bv_len >> (TAPEBLOCK_HSEC_S2B + 9);
+
 	request = tape_alloc_request(2 + count + 1, 4);
 	if (IS_ERR(request))
 		return request;
@@ -653,8 +651,7 @@ tape_3590_bread(struct tape_device *devi
 	 */
 	ccw = tape_ccw_cc(ccw, NOP, 0, NULL);
 
-	rq_for_each_bio(bio, req) {
-		bio_for_each_segment(bv, bio, i) {
+	rq_for_each_segment(bv, req, iter) {
 			dst = page_address(bv->bv_page) + bv->bv_offset;
 			for (off = 0; off < bv->bv_len;
 			     off += TAPEBLOCK_HSEC_SIZE) {
@@ -667,7 +664,6 @@ tape_3590_bread(struct tape_device *devi
 			}
 			if (off > bv->bv_len)
 				BUG();
-		}
 	}
 	ccw = tape_ccw_end(ccw, NOP, 0, NULL);
 	DBF_EVENT(6, "xBREDccwg\n");

diff .prev/include/linux/blkdev.h ./include/linux/blkdev.h
--- .prev/include/linux/blkdev.h	2007-08-16 17:39:13.000000000 +1000
+++ ./include/linux/blkdev.h	2007-08-16 20:54:26.000000000 +1000
@@ -637,10 +637,23 @@ static inline void blk_queue_bounce(stru
 }
 #endif /* CONFIG_MMU */
 
-#define rq_for_each_bio(_bio, rq)	\
+struct req_iterator {
+	int i;
+	struct bio *bio;
+};
+
+/* This should not be used directly - use rq_for_each_segment */
+#define __rq_for_each_bio(_bio, rq)	\
 	if ((rq->bio))			\
 		for (_bio = (rq)->bio; _bio; _bio = _bio->bi_next)
 
+#define rq_for_each_segment(bvl, _rq, _iter)			\
+	__rq_for_each_bio(_iter.bio, _rq)			\
+		bio_for_each_segment(bvl, _iter.bio, _iter.i)
+
+#define rq_iter_last(rq, _iter)					\
+		(_iter.bio->bi_next == NULL && _iter.i == _iter.bio->bi_vcnt-1)
+
 extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);
 extern void register_disk(struct gendisk *dev);
