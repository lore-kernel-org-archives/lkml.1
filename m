Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbXHPFPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbXHPFPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 01:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760784AbXHPFOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 01:14:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:46451 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786AbXHPFN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 01:13:59 -0400
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 16 Aug 2007 15:13:50 +1000
Message-Id: <1070816051350.31377@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: [PATCH 004 of 5] Introduce rq_for_each_segment replacing rq_for_each_bio
References: <20070816150445.30843.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(almost) every usage of rq_for_each_bio wraps a usage of
bio_for_each_segment, so these can be combined into
rq_for_each_segment.

We get it to fill in a bio_vec structure rather than provide a
pointer, as future changes to make bi_io_vec immutable will require
that.

The one place where rq_for_each_bio remains will be changed to use
rq_for_each_segment in a subsequent patch.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c              |   54 +++++++++++--------------
 ./drivers/block/floppy.c         |   84 ++++++++++++++++++---------------------
 ./drivers/block/lguest_blk.c     |   25 +++++------
 ./drivers/block/nbd.c            |   67 +++++++++++++++----------------
 ./drivers/block/xen-blkfront.c   |   57 ++++++++++++--------------
 ./drivers/ide/ide-floppy.c       |   62 +++++++++++++---------------
 ./drivers/s390/block/dasd_diag.c |   40 ++++++++----------
 ./drivers/s390/block/dasd_eckd.c |   47 ++++++++++-----------
 ./drivers/s390/block/dasd_fba.c  |   47 ++++++++++-----------
 ./drivers/s390/char/tape_34xx.c  |   33 ++++++---------
 ./drivers/s390/char/tape_3590.c  |   41 ++++++++-----------
 ./include/linux/blkdev.h         |   18 ++++++++
 12 files changed, 280 insertions(+), 295 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-08-16 15:02:30.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-08-16 15:02:31.000000000 +1000
@@ -1313,9 +1313,11 @@ static int blk_hw_contig_segment(struct 
 int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 		  struct scatterlist *sg)
 {
-	struct bio_vec *bvec, *bvprv;
-	struct bio *bio;
-	int nsegs, i, cluster;
+	struct bio_vec bvec;
+	struct bio_vec bvprv = { 0 };
+	struct req_iterator i;
+	int nsegs;
+	int cluster;
 
 	nsegs = 0;
 	cluster = q->queue_flags & (1 << QUEUE_FLAG_CLUSTER);
@@ -1323,36 +1325,30 @@ int blk_rq_map_sg(struct request_queue *
 	/*
 	 * for each bio in rq
 	 */
-	bvprv = NULL;
-	rq_for_each_bio(bio, rq) {
-		/*
-		 * for each segment in bio
-		 */
-		bio_for_each_segment(bvec, bio, i) {
-			int nbytes = bvec->bv_len;
+	rq_for_each_segment(rq, i, bvec) {
+		int nbytes = bvec.bv_len;
 
-			if (bvprv && cluster) {
-				if (sg[nsegs - 1].length + nbytes > q->max_segment_size)
-					goto new_segment;
-
-				if (!BIOVEC_PHYS_MERGEABLE(bvprv, bvec))
-					goto new_segment;
-				if (!BIOVEC_SEG_BOUNDARY(q, bvprv, bvec))
-					goto new_segment;
+		if (bvprv.bv_page && cluster) {
+			if (sg[nsegs - 1].length + nbytes > q->max_segment_size)
+				goto new_segment;
+
+			if (!BIOVEC_PHYS_MERGEABLE(&bvprv, &bvec))
+				goto new_segment;
+			if (!BIOVEC_SEG_BOUNDARY(q, &bvprv, &bvec))
+				goto new_segment;
 
-				sg[nsegs - 1].length += nbytes;
-			} else {
+			sg[nsegs - 1].length += nbytes;
+		} else {
 new_segment:
-				memset(&sg[nsegs],0,sizeof(struct scatterlist));
-				sg[nsegs].page = bvec->bv_page;
-				sg[nsegs].length = nbytes;
-				sg[nsegs].offset = bvec->bv_offset;
+			memset(&sg[nsegs], 0, sizeof(struct scatterlist));
+			sg[nsegs].page = bvec.bv_page;
+			sg[nsegs].length = nbytes;
+			sg[nsegs].offset = bvec.bv_offset;
 
-				nsegs++;
-			}
-			bvprv = bvec;
-		} /* segments in bio */
-	} /* bios in rq */
+			nsegs++;
+		}
+		bvprv = bvec;
+	}
 
 	return nsegs;
 }

diff .prev/drivers/block/floppy.c ./drivers/block/floppy.c
--- .prev/drivers/block/floppy.c	2007-08-16 15:02:30.000000000 +1000
+++ ./drivers/block/floppy.c	2007-08-16 15:02:31.000000000 +1000
@@ -2450,23 +2450,20 @@ static void rw_interrupt(void)
 /* Compute maximal contiguous buffer size. */
 static int buffer_chain_size(void)
 {
-	struct bio *bio;
-	struct bio_vec *bv;
+	struct bio_vec bv;
 	int size;
-	int i;
+	struct req_iterator i;
 	char *base;
 
 	base = blk_rq_data(current_req);
 	size = 0;
 
-	rq_for_each_bio(bio, current_req) {
-		bio_for_each_segment(bv, bio, i) {
-			if (page_address(bv->bv_page) + bv->bv_offset !=
-			    base + size)
-				break;
+	rq_for_each_segment(current_req, i, bv) {
+		if (page_address(bv.bv_page) + bv.bv_offset !=
+		    base + size)
+			break;
 
-			size += bv->bv_len;
-		}
+		size += bv.bv_len;
 	}
 
 	return size >> 9;
@@ -2492,12 +2489,11 @@ static int transfer_size(int ssize, int 
 static void copy_buffer(int ssize, int max_sector, int max_sector_2)
 {
 	int remaining;		/* number of transferred 512-byte sectors */
-	struct bio_vec *bv;
-	struct bio *bio;
+	struct bio_vec bv;
 	char *buffer;
 	char *dma_buffer;
 	int size;
-	int i;
+	struct req_iterator i;
 
 	max_sector = transfer_size(ssize,
 				   min(max_sector, max_sector_2),
@@ -2530,43 +2526,41 @@ static void copy_buffer(int ssize, int m
 
 	size = current_req->current_nr_sectors << 9;
 
-	rq_for_each_bio(bio, current_req) {
-		bio_for_each_segment(bv, bio, i) {
-			if (!remaining)
-				break;
+	rq_for_each_segment(current_req, i, bv) {
+		if (!remaining)
+			break;
 
-			size = bv->bv_len;
-			SUPBOUND(size, remaining);
+		size = bv.bv_len;
+		SUPBOUND(size, remaining);
 
-			buffer = page_address(bv->bv_page) + bv->bv_offset;
+		buffer = page_address(bv.bv_page) + bv.bv_offset;
 #ifdef FLOPPY_SANITY_CHECK
-			if (dma_buffer + size >
-			    floppy_track_buffer + (max_buffer_sectors << 10) ||
-			    dma_buffer < floppy_track_buffer) {
-				DPRINT("buffer overrun in copy buffer %d\n",
-				       (int)((floppy_track_buffer -
-					      dma_buffer) >> 9));
-				printk("fsector_t=%d buffer_min=%d\n",
-				       fsector_t, buffer_min);
-				printk("current_count_sectors=%ld\n",
-				       current_count_sectors);
-				if (CT(COMMAND) == FD_READ)
-					printk("read\n");
-				if (CT(COMMAND) == FD_WRITE)
-					printk("write\n");
-				break;
-			}
-			if (((unsigned long)buffer) % 512)
-				DPRINT("%p buffer not aligned\n", buffer);
-#endif
+		if (dma_buffer + size >
+		    floppy_track_buffer + (max_buffer_sectors << 10) ||
+		    dma_buffer < floppy_track_buffer) {
+			DPRINT("buffer overrun in copy buffer %d\n",
+			       (int)((floppy_track_buffer -
+				      dma_buffer) >> 9));
+			printk(KERN_DEBUG "fsector_t=%d buffer_min=%d\n",
+			       fsector_t, buffer_min);
+			printk(KERN_DEBUG "current_count_sectors=%ld\n",
+			       current_count_sectors);
 			if (CT(COMMAND) == FD_READ)
-				memcpy(buffer, dma_buffer, size);
-			else
-				memcpy(dma_buffer, buffer, size);
-
-			remaining -= size;
-			dma_buffer += size;
+				printk(KERN_DEBUG "read\n");
+			if (CT(COMMAND) == FD_WRITE)
+				printk(KERN_DEBUG "write\n");
+			break;
 		}
+		if (((unsigned long)buffer) % 512)
+			DPRINT("%p buffer not aligned\n", buffer);
+#endif
+		if (CT(COMMAND) == FD_READ)
+			memcpy(buffer, dma_buffer, size);
+		else
+			memcpy(dma_buffer, buffer, size);
+
+		remaining -= size;
+		dma_buffer += size;
 	}
 #ifdef FLOPPY_SANITY_CHECK
 	if (remaining) {

diff .prev/drivers/block/lguest_blk.c ./drivers/block/lguest_blk.c
--- .prev/drivers/block/lguest_blk.c	2007-08-16 14:57:22.000000000 +1000
+++ ./drivers/block/lguest_blk.c	2007-08-16 15:02:31.000000000 +1000
@@ -142,25 +142,24 @@ static irqreturn_t lgb_irq(int irq, void
  * return the total length. */
 static unsigned int req_to_dma(struct request *req, struct lguest_dma *dma)
 {
-	unsigned int i = 0, idx, len = 0;
-	struct bio *bio;
+	unsigned int i = 0;
+	unsigned int len = 0;
+	struct req_iterator idx;
+	struct bio_vec bvec;
 
-	rq_for_each_bio(bio, req) {
-		struct bio_vec *bvec;
-		bio_for_each_segment(bvec, bio, idx) {
+	rq_for_each_segment(req, idx, bvec) {
 			/* We told the block layer not to give us too many. */
-			BUG_ON(i == LGUEST_MAX_DMA_SECTIONS);
+		BUG_ON(i == LGUEST_MAX_DMA_SECTIONS);
 			/* If we had a zero-length segment, it would look like
 			 * the end of the data referred to by the "struct
 			 * lguest_dma", so make sure that doesn't happen. */
-			BUG_ON(!bvec->bv_len);
+		BUG_ON(!bvec.bv_len);
 			/* Convert page & offset to a physical address */
-			dma->addr[i] = page_to_phys(bvec->bv_page)
-				+ bvec->bv_offset;
-			dma->len[i] = bvec->bv_len;
-			len += bvec->bv_len;
-			i++;
-		}
+		dma->addr[i] = page_to_phys(bvec.bv_page)
+			+ bvec.bv_offset;
+		dma->len[i] = bvec.bv_len;
+		len += bvec.bv_len;
+		i++;
 	}
 	/* If the array isn't full, we mark the end with a 0 length */
 	if (i < LGUEST_MAX_DMA_SECTIONS)

diff .prev/drivers/block/nbd.c ./drivers/block/nbd.c
--- .prev/drivers/block/nbd.c	2007-08-16 14:57:22.000000000 +1000
+++ ./drivers/block/nbd.c	2007-08-16 15:02:31.000000000 +1000
@@ -180,7 +180,8 @@ static inline int sock_send_bvec(struct 
 
 static int nbd_send_req(struct nbd_device *lo, struct request *req)
 {
-	int result, i, flags;
+	int result;
+	int flags;
 	struct nbd_request request;
 	unsigned long size = req->nr_sectors << 9;
 	struct socket *sock = lo->sock;
@@ -205,27 +206,28 @@ static int nbd_send_req(struct nbd_devic
 	}
 
 	if (nbd_cmd(req) == NBD_CMD_WRITE) {
-		struct bio *bio;
 		/*
 		 * we are really probing at internals to determine
 		 * whether to set MSG_MORE or not...
 		 */
-		rq_for_each_bio(bio, req) {
-			struct bio_vec *bvec;
-			bio_for_each_segment(bvec, bio, i) {
-				flags = 0;
-				if ((i < (bio->bi_vcnt - 1)) || bio->bi_next)
-					flags = MSG_MORE;
-				dprintk(DBG_TX, "%s: request %p: sending %d bytes data\n",
-						lo->disk->disk_name, req,
-						bvec->bv_len);
-				result = sock_send_bvec(sock, bvec, flags);
-				if (result <= 0) {
-					printk(KERN_ERR "%s: Send data failed (result %d)\n",
-							lo->disk->disk_name,
-							result);
-					goto error_out;
-				}
+		struct req_iterator i;
+		struct bio_vec bvec;
+
+		rq_for_each_segment(req, i, bvec) {
+			flags = 0;
+			if (!rq_iter_last(req, i))
+				flags = MSG_MORE;
+			dprintk(DBG_TX,
+				"%s: request %p: sending %d bytes data\n",
+				lo->disk->disk_name, req,
+				bvec.bv_len);
+			result = sock_send_bvec(sock, &bvec, flags);
+			if (result <= 0) {
+				printk(KERN_ERR
+				       "%s: Send data failed (result %d)\n",
+				       lo->disk->disk_name,
+				       result);
+				goto error_out;
 			}
 		}
 	}
@@ -317,22 +319,21 @@ static struct request *nbd_read_stat(str
 	dprintk(DBG_RX, "%s: request %p: got reply\n",
 			lo->disk->disk_name, req);
 	if (nbd_cmd(req) == NBD_CMD_READ) {
-		int i;
-		struct bio *bio;
-		rq_for_each_bio(bio, req) {
-			struct bio_vec *bvec;
-			bio_for_each_segment(bvec, bio, i) {
-				result = sock_recv_bvec(sock, bvec);
-				if (result <= 0) {
-					printk(KERN_ERR "%s: Receive data failed (result %d)\n",
-							lo->disk->disk_name,
-							result);
-					req->errors++;
-					return req;
-				}
-				dprintk(DBG_RX, "%s: request %p: got %d bytes data\n",
-					lo->disk->disk_name, req, bvec->bv_len);
+		struct req_iterator i;
+		struct bio_vec bvec;
+
+		rq_for_each_segment(req, i, bvec) {
+			result = sock_recv_bvec(sock, &bvec);
+			if (result <= 0) {
+				printk(KERN_ERR
+				       "%s: Receive data failed (result %d)\n",
+				       lo->disk->disk_name,
+				       result);
+				req->errors++;
+				return req;
 			}
+			dprintk(DBG_RX, "%s: request %p: got %d bytes data\n",
+				lo->disk->disk_name, req, bvec.bv_len);
 		}
 	}
 	return req;

diff .prev/drivers/block/xen-blkfront.c ./drivers/block/xen-blkfront.c
--- .prev/drivers/block/xen-blkfront.c	2007-08-16 14:57:22.000000000 +1000
+++ ./drivers/block/xen-blkfront.c	2007-08-16 15:02:31.000000000 +1000
@@ -150,9 +150,8 @@ static int blkif_queue_request(struct re
 	struct blkfront_info *info = req->rq_disk->private_data;
 	unsigned long buffer_mfn;
 	struct blkif_request *ring_req;
-	struct bio *bio;
-	struct bio_vec *bvec;
-	int idx;
+	struct bio_vec bvec;
+	struct req_iterator idx;
 	unsigned long id;
 	unsigned int fsect, lsect;
 	int ref;
@@ -186,34 +185,32 @@ static int blkif_queue_request(struct re
 		ring_req->operation = BLKIF_OP_WRITE_BARRIER;
 
 	ring_req->nr_segments = 0;
-	rq_for_each_bio (bio, req) {
-		bio_for_each_segment (bvec, bio, idx) {
-			BUG_ON(ring_req->nr_segments
-			       == BLKIF_MAX_SEGMENTS_PER_REQUEST);
-			buffer_mfn = pfn_to_mfn(page_to_pfn(bvec->bv_page));
-			fsect = bvec->bv_offset >> 9;
-			lsect = fsect + (bvec->bv_len >> 9) - 1;
-			/* install a grant reference. */
-			ref = gnttab_claim_grant_reference(&gref_head);
-			BUG_ON(ref == -ENOSPC);
+	rq_for_each_segment(req, idx, bvec) {
+		BUG_ON(ring_req->nr_segments
+		       == BLKIF_MAX_SEGMENTS_PER_REQUEST);
+		buffer_mfn = pfn_to_mfn(page_to_pfn(bvec.bv_page));
+		fsect = bvec.bv_offset >> 9;
+		lsect = fsect + (bvec.bv_len >> 9) - 1;
+		/* install a grant reference. */
+		ref = gnttab_claim_grant_reference(&gref_head);
+		BUG_ON(ref == -ENOSPC);
+
+		gnttab_grant_foreign_access_ref(
+			ref,
+			info->xbdev->otherend_id,
+			buffer_mfn,
+			rq_data_dir(req) );
+
+		info->shadow[id].frame[ring_req->nr_segments] =
+			mfn_to_pfn(buffer_mfn);
+
+		ring_req->seg[ring_req->nr_segments] =
+			(struct blkif_request_segment) {
+				.gref       = ref,
+				.first_sect = fsect,
+				.last_sect  = lsect };
 
-			gnttab_grant_foreign_access_ref(
-				ref,
-				info->xbdev->otherend_id,
-				buffer_mfn,
-				rq_data_dir(req) );
-
-			info->shadow[id].frame[ring_req->nr_segments] =
-				mfn_to_pfn(buffer_mfn);
-
-			ring_req->seg[ring_req->nr_segments] =
-				(struct blkif_request_segment) {
-					.gref       = ref,
-					.first_sect = fsect,
-					.last_sect  = lsect };
-
-			ring_req->nr_segments++;
-		}
+		ring_req->nr_segments++;
 	}
 
 	info->ring.req_prod_pvt++;

diff .prev/drivers/ide/ide-floppy.c ./drivers/ide/ide-floppy.c
--- .prev/drivers/ide/ide-floppy.c	2007-08-16 14:57:22.000000000 +1000
+++ ./drivers/ide/ide-floppy.c	2007-08-16 15:02:31.000000000 +1000
@@ -605,27 +605,26 @@ static int idefloppy_do_end_request(ide_
 static void idefloppy_input_buffers (ide_drive_t *drive, idefloppy_pc_t *pc, unsigned int bcount)
 {
 	struct request *rq = pc->rq;
-	struct bio_vec *bvec;
-	struct bio *bio;
+	struct bio_vec bvec;
 	unsigned long flags;
 	char *data;
-	int count, i, done = 0;
+	int count;
+	int done = 0;
+	struct req_iterator i;
 
-	rq_for_each_bio(bio, rq) {
-		bio_for_each_segment(bvec, bio, i) {
-			if (!bcount)
-				break;
+	rq_for_each_segment(rq, i, bvec) {
+		if (!bcount)
+			break;
 
-			count = min(bvec->bv_len, bcount);
+		count = min(bvec.bv_len, bcount);
 
-			data = bvec_kmap_irq(bvec, &flags);
-			drive->hwif->atapi_input_bytes(drive, data, count);
-			bvec_kunmap_irq(data, &flags);
-
-			bcount -= count;
-			pc->b_count += count;
-			done += count;
-		}
+		data = bvec_kmap_irq(&bvec, &flags);
+		drive->hwif->atapi_input_bytes(drive, data, count);
+		bvec_kunmap_irq(data, &flags);
+
+		bcount -= count;
+		pc->b_count += count;
+		done += count;
 	}
 
 	idefloppy_do_end_request(drive, 1, done >> 9);
@@ -639,27 +638,26 @@ static void idefloppy_input_buffers (ide
 static void idefloppy_output_buffers (ide_drive_t *drive, idefloppy_pc_t *pc, unsigned int bcount)
 {
 	struct request *rq = pc->rq;
-	struct bio *bio;
-	struct bio_vec *bvec;
+	struct bio_vec bvec;
+	struct req_iterator i;
 	unsigned long flags;
-	int count, i, done = 0;
+	int count;
+	int done = 0;
 	char *data;
 
-	rq_for_each_bio(bio, rq) {
-		bio_for_each_segment(bvec, bio, i) {
-			if (!bcount)
-				break;
+	rq_for_each_segment(rq, i, bvec) {
+		if (!bcount)
+			break;
 
-			count = min(bvec->bv_len, bcount);
+		count = min(bvec.bv_len, bcount);
 
-			data = bvec_kmap_irq(bvec, &flags);
-			drive->hwif->atapi_output_bytes(drive, data, count);
-			bvec_kunmap_irq(data, &flags);
-
-			bcount -= count;
-			pc->b_count += count;
-			done += count;
-		}
+		data = bvec_kmap_irq(&bvec, &flags);
+		drive->hwif->atapi_output_bytes(drive, data, count);
+		bvec_kunmap_irq(data, &flags);
+
+		bcount -= count;
+		pc->b_count += count;
+		done += count;
 	}
 
 	idefloppy_do_end_request(drive, 1, done >> 9);

diff .prev/drivers/s390/block/dasd_diag.c ./drivers/s390/block/dasd_diag.c
--- .prev/drivers/s390/block/dasd_diag.c	2007-08-16 14:57:22.000000000 +1000
+++ ./drivers/s390/block/dasd_diag.c	2007-08-16 15:02:31.000000000 +1000
@@ -471,14 +471,13 @@ dasd_diag_build_cp(struct dasd_device * 
 	struct dasd_ccw_req *cqr;
 	struct dasd_diag_req *dreq;
 	struct dasd_diag_bio *dbio;
-	struct bio *bio;
-	struct bio_vec *bv;
+	struct bio_vec bv;
 	char *dst;
 	unsigned int count, datasize;
 	sector_t recid, first_rec, last_rec;
 	unsigned int blksize, off;
 	unsigned char rw_cmd;
-	int i;
+	struct req_iterator i;
 
 	if (rq_data_dir(req) == READ)
 		rw_cmd = MDSK_READ_REQ;
@@ -492,13 +491,11 @@ dasd_diag_build_cp(struct dasd_device * 
 	last_rec = (req->sector + req->nr_sectors - 1) >> device->s2b_shift;
 	/* Check struct bio and count the number of blocks for the request. */
 	count = 0;
-	rq_for_each_bio(bio, req) {
-		bio_for_each_segment(bv, bio, i) {
-			if (bv->bv_len & (blksize - 1))
-				/* Fba can only do full blocks. */
-				return ERR_PTR(-EINVAL);
-			count += bv->bv_len >> (device->s2b_shift + 9);
-		}
+	rq_for_each_segment(req, i, bv) {
+		if (bv.bv_len & (blksize - 1))
+			/* Fba can only do full blocks. */
+			return ERR_PTR(-EINVAL);
+		count += bv.bv_len >> (device->s2b_shift + 9);
 	}
 	/* Paranoia. */
 	if (count != last_rec - first_rec + 1)
@@ -515,20 +512,19 @@ dasd_diag_build_cp(struct dasd_device * 
 	dreq->block_count = count;
 	dbio = dreq->bio;
 	recid = first_rec;
-	rq_for_each_bio(bio, req) {
-		bio_for_each_segment(bv, bio, i) {
-			dst = page_address(bv->bv_page) + bv->bv_offset;
-			for (off = 0; off < bv->bv_len; off += blksize) {
-				memset(dbio, 0, sizeof (struct dasd_diag_bio));
-				dbio->type = rw_cmd;
-				dbio->block_number = recid + 1;
-				dbio->buffer = dst;
-				dbio++;
-				dst += blksize;
-				recid++;
-			}
+	rq_for_each_segment(req, i, bv) {
+		dst = page_address(bv.bv_page) + bv.bv_offset;
+		for (off = 0; off < bv.bv_len; off += blksize) {
+			memset(dbio, 0, sizeof(struct dasd_diag_bio));
+			dbio->type = rw_cmd;
+			dbio->block_number = recid + 1;
+			dbio->buffer = dst;
+			dbio++;
+			dst += blksize;
+			recid++;
 		}
 	}
+
 	cqr->retries = DIAG_MAX_RETRIES;
 	cqr->buildclk = get_clock();
 	if (req->cmd_flags & REQ_FAILFAST)

diff .prev/drivers/s390/block/dasd_eckd.c ./drivers/s390/block/dasd_eckd.c
--- .prev/drivers/s390/block/dasd_eckd.c	2007-08-16 14:57:22.000000000 +1000
+++ ./drivers/s390/block/dasd_eckd.c	2007-08-16 15:02:31.000000000 +1000
@@ -1176,8 +1176,7 @@ dasd_eckd_build_cp(struct dasd_device * 
 	struct LO_eckd_data *LO_data;
 	struct dasd_ccw_req *cqr;
 	struct ccw1 *ccw;
-	struct bio *bio;
-	struct bio_vec *bv;
+	struct bio_vec bv;
 	char *dst;
 	unsigned int blksize, blk_per_trk, off;
 	int count, cidaw, cplength, datasize;
@@ -1185,7 +1184,7 @@ dasd_eckd_build_cp(struct dasd_device * 
 	sector_t first_trk, last_trk;
 	unsigned int first_offs, last_offs;
 	unsigned char cmd, rcmd;
-	int i;
+	struct req_iterator i;
 
 	private = (struct dasd_eckd_private *) device->private;
 	if (rq_data_dir(req) == READ)
@@ -1206,18 +1205,16 @@ dasd_eckd_build_cp(struct dasd_device * 
 	/* Check struct bio and count the number of blocks for the request. */
 	count = 0;
 	cidaw = 0;
-	rq_for_each_bio(bio, req) {
-		bio_for_each_segment(bv, bio, i) {
-			if (bv->bv_len & (blksize - 1))
-				/* Eckd can only do full blocks. */
-				return ERR_PTR(-EINVAL);
-			count += bv->bv_len >> (device->s2b_shift + 9);
+	rq_for_each_segment(req, i, bv) {
+		if (bv.bv_len & (blksize - 1))
+			/* Eckd can only do full blocks. */
+			return ERR_PTR(-EINVAL);
+		count += bv.bv_len >> (device->s2b_shift + 9);
 #if defined(CONFIG_64BIT)
-			if (idal_is_needed (page_address(bv->bv_page),
-					    bv->bv_len))
-				cidaw += bv->bv_len >> (device->s2b_shift + 9);
+		if (idal_is_needed (page_address(bv.bv_page),
+				    bv.bv_len))
+			cidaw += bv.bv_len >> (device->s2b_shift + 9);
 #endif
-		}
 	}
 	/* Paranoia. */
 	if (count != last_rec - first_rec + 1)
@@ -1257,17 +1254,17 @@ dasd_eckd_build_cp(struct dasd_device * 
 		locate_record(ccw++, LO_data++, first_trk, first_offs + 1,
 			      last_rec - recid + 1, cmd, device, blksize);
 	}
-	rq_for_each_bio(bio, req) bio_for_each_segment(bv, bio, i) {
-		dst = page_address(bv->bv_page) + bv->bv_offset;
+	rq_for_each_segment(req, i, bv) {
+		dst = page_address(bv.bv_page) + bv.bv_offset;
 		if (dasd_page_cache) {
 			char *copy = kmem_cache_alloc(dasd_page_cache,
 						      GFP_DMA | __GFP_NOWARN);
 			if (copy && rq_data_dir(req) == WRITE)
-				memcpy(copy + bv->bv_offset, dst, bv->bv_len);
+				memcpy(copy + bv.bv_offset, dst, bv.bv_len);
 			if (copy)
-				dst = copy + bv->bv_offset;
+				dst = copy + bv.bv_offset;
 		}
-		for (off = 0; off < bv->bv_len; off += blksize) {
+		for (off = 0; off < bv.bv_len; off += blksize) {
 			sector_t trkid = recid;
 			unsigned int recoffs = sector_div(trkid, blk_per_trk);
 			rcmd = cmd;
@@ -1328,12 +1325,12 @@ dasd_eckd_free_cp(struct dasd_ccw_req *c
 {
 	struct dasd_eckd_private *private;
 	struct ccw1 *ccw;
-	struct bio *bio;
-	struct bio_vec *bv;
+	struct bio_vec bv;
 	char *dst, *cda;
 	unsigned int blksize, blk_per_trk, off;
 	sector_t recid;
-	int i, status;
+	int status;
+	struct req_iterator i;
 
 	if (!dasd_page_cache)
 		goto out;
@@ -1346,9 +1343,9 @@ dasd_eckd_free_cp(struct dasd_ccw_req *c
 	ccw++;
 	if (private->uses_cdl == 0 || recid > 2*blk_per_trk)
 		ccw++;
-	rq_for_each_bio(bio, req) bio_for_each_segment(bv, bio, i) {
-		dst = page_address(bv->bv_page) + bv->bv_offset;
-		for (off = 0; off < bv->bv_len; off += blksize) {
+	rq_for_each_segment(req, i, bv) {
+		dst = page_address(bv.bv_page) + bv.bv_offset;
+		for (off = 0; off < bv.bv_len; off += blksize) {
 			/* Skip locate record. */
 			if (private->uses_cdl && recid <= 2*blk_per_trk)
 				ccw++;
@@ -1359,7 +1356,7 @@ dasd_eckd_free_cp(struct dasd_ccw_req *c
 					cda = (char *)((addr_t) ccw->cda);
 				if (dst != cda) {
 					if (rq_data_dir(req) == READ)
-						memcpy(dst, cda, bv->bv_len);
+						memcpy(dst, cda, bv.bv_len);
 					kmem_cache_free(dasd_page_cache,
 					    (void *)((addr_t)cda & PAGE_MASK));
 				}

diff .prev/drivers/s390/block/dasd_fba.c ./drivers/s390/block/dasd_fba.c
--- .prev/drivers/s390/block/dasd_fba.c	2007-08-16 14:57:22.000000000 +1000
+++ ./drivers/s390/block/dasd_fba.c	2007-08-16 15:02:31.000000000 +1000
@@ -234,14 +234,13 @@ dasd_fba_build_cp(struct dasd_device * d
 	struct LO_fba_data *LO_data;
 	struct dasd_ccw_req *cqr;
 	struct ccw1 *ccw;
-	struct bio *bio;
-	struct bio_vec *bv;
+	struct bio_vec bv;
 	char *dst;
 	int count, cidaw, cplength, datasize;
 	sector_t recid, first_rec, last_rec;
 	unsigned int blksize, off;
 	unsigned char cmd;
-	int i;
+	struct req_iterator i;
 
 	private = (struct dasd_fba_private *) device->private;
 	if (rq_data_dir(req) == READ) {
@@ -257,18 +256,16 @@ dasd_fba_build_cp(struct dasd_device * d
 	/* Check struct bio and count the number of blocks for the request. */
 	count = 0;
 	cidaw = 0;
-	rq_for_each_bio(bio, req) {
-		bio_for_each_segment(bv, bio, i) {
-			if (bv->bv_len & (blksize - 1))
-				/* Fba can only do full blocks. */
-				return ERR_PTR(-EINVAL);
-			count += bv->bv_len >> (device->s2b_shift + 9);
+	rq_for_each_segment(req, i, bv) {
+		if (bv.bv_len & (blksize - 1))
+			/* Fba can only do full blocks. */
+			return ERR_PTR(-EINVAL);
+		count += bv.bv_len >> (device->s2b_shift + 9);
 #if defined(CONFIG_64BIT)
-			if (idal_is_needed (page_address(bv->bv_page),
-					    bv->bv_len))
-				cidaw += bv->bv_len / blksize;
+		if (idal_is_needed (page_address(bv.bv_page),
+				    bv.bv_len))
+			cidaw += bv.bv_len / blksize;
 #endif
-		}
 	}
 	/* Paranoia. */
 	if (count != last_rec - first_rec + 1)
@@ -304,17 +301,17 @@ dasd_fba_build_cp(struct dasd_device * d
 		locate_record(ccw++, LO_data++, rq_data_dir(req), 0, count);
 	}
 	recid = first_rec;
-	rq_for_each_bio(bio, req) bio_for_each_segment(bv, bio, i) {
-		dst = page_address(bv->bv_page) + bv->bv_offset;
+	rq_for_each_segment(req, i, bv) {
+		dst = page_address(bv.bv_page) + bv.bv_offset;
 		if (dasd_page_cache) {
 			char *copy = kmem_cache_alloc(dasd_page_cache,
 						      GFP_DMA | __GFP_NOWARN);
 			if (copy && rq_data_dir(req) == WRITE)
-				memcpy(copy + bv->bv_offset, dst, bv->bv_len);
+				memcpy(copy + bv.bv_offset, dst, bv.bv_len);
 			if (copy)
-				dst = copy + bv->bv_offset;
+				dst = copy + bv.bv_offset;
 		}
-		for (off = 0; off < bv->bv_len; off += blksize) {
+		for (off = 0; off < bv.bv_len; off += blksize) {
 			/* Locate record for stupid devices. */
 			if (private->rdc_data.mode.bits.data_chain == 0) {
 				ccw[-1].flags |= CCW_FLAG_CC;
@@ -359,11 +356,11 @@ dasd_fba_free_cp(struct dasd_ccw_req *cq
 {
 	struct dasd_fba_private *private;
 	struct ccw1 *ccw;
-	struct bio *bio;
-	struct bio_vec *bv;
+	struct bio_vec bv;
 	char *dst, *cda;
 	unsigned int blksize, off;
-	int i, status;
+	int status;
+	struct req_iterator i;
 
 	if (!dasd_page_cache)
 		goto out;
@@ -374,9 +371,9 @@ dasd_fba_free_cp(struct dasd_ccw_req *cq
 	ccw++;
 	if (private->rdc_data.mode.bits.data_chain != 0)
 		ccw++;
-	rq_for_each_bio(bio, req) bio_for_each_segment(bv, bio, i) {
-		dst = page_address(bv->bv_page) + bv->bv_offset;
-		for (off = 0; off < bv->bv_len; off += blksize) {
+	rq_for_each_segment(req, i, bv) {
+		dst = page_address(bv.bv_page) + bv.bv_offset;
+		for (off = 0; off < bv.bv_len; off += blksize) {
 			/* Skip locate record. */
 			if (private->rdc_data.mode.bits.data_chain == 0)
 				ccw++;
@@ -387,7 +384,7 @@ dasd_fba_free_cp(struct dasd_ccw_req *cq
 					cda = (char *)((addr_t) ccw->cda);
 				if (dst != cda) {
 					if (rq_data_dir(req) == READ)
-						memcpy(dst, cda, bv->bv_len);
+						memcpy(dst, cda, bv.bv_len);
 					kmem_cache_free(dasd_page_cache,
 					    (void *)((addr_t)cda & PAGE_MASK));
 				}

diff .prev/drivers/s390/char/tape_34xx.c ./drivers/s390/char/tape_34xx.c
--- .prev/drivers/s390/char/tape_34xx.c	2007-08-16 14:57:22.000000000 +1000
+++ ./drivers/s390/char/tape_34xx.c	2007-08-16 15:02:31.000000000 +1000
@@ -1134,21 +1134,18 @@ tape_34xx_bread(struct tape_device *devi
 {
 	struct tape_request *request;
 	struct ccw1 *ccw;
-	int count = 0, i;
+	int count = 0;
+	struct req_iterator i;
 	unsigned off;
 	char *dst;
-	struct bio_vec *bv;
-	struct bio *bio;
+	struct bio_vec bv;
 	struct tape_34xx_block_id *	start_block;
 
 	DBF_EVENT(6, "xBREDid:");
 
 	/* Count the number of blocks for the request. */
-	rq_for_each_bio(bio, req) {
-		bio_for_each_segment(bv, bio, i) {
+	rq_for_each_segment(req, i, bv)
 			count += bv->bv_len >> (TAPEBLOCK_HSEC_S2B + 9);
-		}
-	}
 
 	/* Allocate the ccw request. */
 	request = tape_alloc_request(3+count+1, 8);
@@ -1175,18 +1172,16 @@ tape_34xx_bread(struct tape_device *devi
 	ccw = tape_ccw_cc(ccw, NOP, 0, NULL);
 	ccw = tape_ccw_cc(ccw, NOP, 0, NULL);
 
-	rq_for_each_bio(bio, req) {
-		bio_for_each_segment(bv, bio, i) {
-			dst = kmap(bv->bv_page) + bv->bv_offset;
-			for (off = 0; off < bv->bv_len;
-			     off += TAPEBLOCK_HSEC_SIZE) {
-				ccw->flags = CCW_FLAG_CC;
-				ccw->cmd_code = READ_FORWARD;
-				ccw->count = TAPEBLOCK_HSEC_SIZE;
-				set_normalized_cda(ccw, (void*) __pa(dst));
-				ccw++;
-				dst += TAPEBLOCK_HSEC_SIZE;
-			}
+	rq_for_each_segment(req, i, bv) {
+		dst = kmap(bv.bv_page) + bv.bv_offset;
+		for (off = 0; off < bv.bv_len;
+		     off += TAPEBLOCK_HSEC_SIZE) {
+			ccw->flags = CCW_FLAG_CC;
+			ccw->cmd_code = READ_FORWARD;
+			ccw->count = TAPEBLOCK_HSEC_SIZE;
+			set_normalized_cda(ccw, (void *) __pa(dst));
+			ccw++;
+			dst += TAPEBLOCK_HSEC_SIZE;
 		}
 	}
 

diff .prev/drivers/s390/char/tape_3590.c ./drivers/s390/char/tape_3590.c
--- .prev/drivers/s390/char/tape_3590.c	2007-08-16 14:57:22.000000000 +1000
+++ ./drivers/s390/char/tape_3590.c	2007-08-16 15:02:31.000000000 +1000
@@ -623,21 +623,20 @@ tape_3590_bread(struct tape_device *devi
 {
 	struct tape_request *request;
 	struct ccw1 *ccw;
-	int count = 0, start_block, i;
+	int count = 0;
+	int start_block;
+	struct req_iterator i;
 	unsigned off;
 	char *dst;
-	struct bio_vec *bv;
-	struct bio *bio;
+	struct bio_vec bv;
 
 	DBF_EVENT(6, "xBREDid:");
 	start_block = req->sector >> TAPEBLOCK_HSEC_S2B;
 	DBF_EVENT(6, "start_block = %i\n", start_block);
 
-	rq_for_each_bio(bio, req) {
-		bio_for_each_segment(bv, bio, i) {
-			count += bv->bv_len >> (TAPEBLOCK_HSEC_S2B + 9);
-		}
-	}
+	rq_for_each_segment(req, i, bv)
+		count += bv.bv_len >> (TAPEBLOCK_HSEC_S2B + 9);
+
 	request = tape_alloc_request(2 + count + 1, 4);
 	if (IS_ERR(request))
 		return request;
@@ -653,21 +652,19 @@ tape_3590_bread(struct tape_device *devi
 	 */
 	ccw = tape_ccw_cc(ccw, NOP, 0, NULL);
 
-	rq_for_each_bio(bio, req) {
-		bio_for_each_segment(bv, bio, i) {
-			dst = page_address(bv->bv_page) + bv->bv_offset;
-			for (off = 0; off < bv->bv_len;
-			     off += TAPEBLOCK_HSEC_SIZE) {
-				ccw->flags = CCW_FLAG_CC;
-				ccw->cmd_code = READ_FORWARD;
-				ccw->count = TAPEBLOCK_HSEC_SIZE;
-				set_normalized_cda(ccw, (void *) __pa(dst));
-				ccw++;
-				dst += TAPEBLOCK_HSEC_SIZE;
-			}
-			if (off > bv->bv_len)
-				BUG();
+	rq_for_each_segment(req, i, bv) {
+		dst = page_address(bv.bv_page) + bv.bv_offset;
+		for (off = 0; off < bv.bv_len;
+		     off += TAPEBLOCK_HSEC_SIZE) {
+			ccw->flags = CCW_FLAG_CC;
+			ccw->cmd_code = READ_FORWARD;
+			ccw->count = TAPEBLOCK_HSEC_SIZE;
+			set_normalized_cda(ccw, (void *) __pa(dst));
+			ccw++;
+			dst += TAPEBLOCK_HSEC_SIZE;
 		}
+		if (off > bv.bv_len)
+			BUG();
 	}
 	ccw = tape_ccw_end(ccw, NOP, 0, NULL);
 	DBF_EVENT(6, "xBREDccwg\n");

diff .prev/include/linux/blkdev.h ./include/linux/blkdev.h
--- .prev/include/linux/blkdev.h	2007-08-16 15:02:30.000000000 +1000
+++ ./include/linux/blkdev.h	2007-08-16 15:02:31.000000000 +1000
@@ -637,6 +637,24 @@ static inline void blk_queue_bounce(stru
 }
 #endif /* CONFIG_MMU */
 
+struct req_iterator {
+	int i;
+	struct bio *bio;
+};
+
+#define _bio_for_each_segment(bvec, bio, i)		\
+	for (i = (bio)->bi_idx;				\
+	     i < (bio)->bi_vcnt;			\
+	     i++) if ((bvec = *bio_iovec_idx(bio, i)), 1)
+
+#define rq_for_each_segment(rq, _iter, bvec)	\
+	for (_iter.bio = (rq)->bio;		\
+	     _iter.bio;				\
+	     _iter.bio = _iter.bio->bi_next)	\
+		_bio_for_each_segment(bvec, _iter.bio, _iter.i)
+
+#define rq_iter_last(rq, _iter) (_iter.bio->bi_next == NULL && 	\
+				 _iter.i == _iter.bio->bi_vcnt - 1)
 #define rq_for_each_bio(_bio, rq)	\
 	if ((rq->bio))			\
 		for (_bio = (rq)->bio; _bio; _bio = _bio->bi_next)
