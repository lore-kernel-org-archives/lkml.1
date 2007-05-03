Return-Path: <linux-kernel-owner+w=401wt.eu-S1751884AbXECJWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbXECJWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 05:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbXECJWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 05:22:00 -0400
Received: from brick.kernel.dk ([80.160.20.94]:12841 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbXECJV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 05:21:58 -0400
Date: Thu, 3 May 2007 11:21:00 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH][RFC] Chaining sg lists for big IO commands
Message-ID: <20070503092100.GE2939@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Started playing with this a bit, this is a very rough first patch. It
works for me, but has some limitations:

- It's i386 only right now. You need to update asm/scatterlist.h for
  other archs, adding a next pointer and so on. See the
  asm-i386/scatterlist.h changes, it's trivial. It gets more tricky if
  you have iommu code diddling around with the sglists, x86-64 needs
  some work there which I'll take a look at.

- libata needs more love because of its atapi and pio stuff.

- scsi_alloc_sgtable() runs into mempool issues, because we may allocate
  a bunch of elements for just one command. This needs some sort of fix,
  naturally.

- Should work on SCSI/SATA.

Anyway, if you want to play with larger commands, you have to enable the
building of big commands for that device. For sda, you would do:

# cd /sys/block/sda/queue
# echo 1024 > max_segments
# cat echo 4096 > max_sectors_kb

which would enable up to 4mb commands.

I'll try and get this more polished soon. Feel free to fire your
comments/questions my way, though.

 block/ll_rw_blk.c              |   40 +++++-
 crypto/digest.c                |    2 
 crypto/scatterwalk.c           |    2 
 crypto/scatterwalk.h           |    2 
 drivers/ata/libata-core.c      |   28 +++-
 drivers/scsi/scsi_lib.c        |  198 ++++++++++++++++++++++++---------
 drivers/scsi/scsi_tgt_lib.c    |    4 
 include/asm-i386/dma-mapping.h |   13 +-
 include/asm-i386/scatterlist.h |    4 
 include/linux/libata.h         |    9 +
 include/linux/scatterlist.h    |   22 +++
 include/scsi/scsi.h            |    7 -
 include/scsi/scsi_cmnd.h       |    3 
 13 files changed, 247 insertions(+), 87 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 123003a..2add845 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -1307,9 +1307,11 @@ static int blk_hw_contig_segment(request_queue_t *q, struct bio *bio,
  * map a request to scatterlist, return number of sg entries setup. Caller
  * must make sure sg can hold rq->nr_phys_segments entries
  */
-int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *sg)
+int blk_rq_map_sg(request_queue_t *q, struct request *rq,
+		  struct scatterlist *sglist)
 {
 	struct bio_vec *bvec, *bvprv;
+	struct scatterlist *next_sg, *sg;
 	struct bio *bio;
 	int nsegs, i, cluster;
 
@@ -1320,6 +1322,7 @@ int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *sg
 	 * for each bio in rq
 	 */
 	bvprv = NULL;
+	sg = next_sg = &sglist[0];
 	rq_for_each_bio(bio, rq) {
 		/*
 		 * for each segment in bio
@@ -1328,7 +1331,7 @@ int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *sg
 			int nbytes = bvec->bv_len;
 
 			if (bvprv && cluster) {
-				if (sg[nsegs - 1].length + nbytes > q->max_segment_size)
+				if (sg->length + nbytes > q->max_segment_size)
 					goto new_segment;
 
 				if (!BIOVEC_PHYS_MERGEABLE(bvprv, bvec))
@@ -1336,14 +1339,15 @@ int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *sg
 				if (!BIOVEC_SEG_BOUNDARY(q, bvprv, bvec))
 					goto new_segment;
 
-				sg[nsegs - 1].length += nbytes;
+				sg->length += nbytes;
 			} else {
 new_segment:
-				memset(&sg[nsegs],0,sizeof(struct scatterlist));
-				sg[nsegs].page = bvec->bv_page;
-				sg[nsegs].length = nbytes;
-				sg[nsegs].offset = bvec->bv_offset;
+				sg = next_sg;
+				next_sg = sg_next(sg);
 
+				sg->page = bvec->bv_page;
+				sg->length = nbytes;
+				sg->offset = bvec->bv_offset;
 				nsegs++;
 			}
 			bvprv = bvec;
@@ -3923,7 +3927,22 @@ static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
 	return queue_var_show(max_hw_sectors_kb, (page));
 }
 
+static ssize_t queue_max_segments_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(q->max_phys_segments, page);
+}
+
+static ssize_t queue_max_segments_store(struct request_queue *q, const char *page, size_t count)
+{
+	unsigned long segments;
+	ssize_t ret = queue_var_store(&segments, page, count);
 
+	spin_lock_irq(q->queue_lock);
+	q->max_phys_segments = segments;
+	spin_unlock_irq(q->queue_lock);
+
+	return ret;
+}
 static struct queue_sysfs_entry queue_requests_entry = {
 	.attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_requests_show,
@@ -3947,6 +3966,12 @@ static struct queue_sysfs_entry queue_max_hw_sectors_entry = {
 	.show = queue_max_hw_sectors_show,
 };
 
+static struct queue_sysfs_entry queue_max_segments_entry = {
+	.attr = {.name = "max_segments", .mode = S_IRUGO |S_IWUSR },
+	.show = queue_max_segments_show,
+	.store = queue_max_segments_store,
+};
+
 static struct queue_sysfs_entry queue_iosched_entry = {
 	.attr = {.name = "scheduler", .mode = S_IRUGO | S_IWUSR },
 	.show = elv_iosched_show,
@@ -3958,6 +3983,7 @@ static struct attribute *default_attrs[] = {
 	&queue_ra_entry.attr,
 	&queue_max_hw_sectors_entry.attr,
 	&queue_max_sectors_entry.attr,
+	&queue_max_segments_entry.attr,
 	&queue_iosched_entry.attr,
 	NULL,
 };
diff --git a/crypto/digest.c b/crypto/digest.c
index 1bf7414..e56de67 100644
--- a/crypto/digest.c
+++ b/crypto/digest.c
@@ -77,7 +77,7 @@ static int update2(struct hash_desc *desc,
 
 		if (!nbytes)
 			break;
-		sg = sg_next(sg);
+		sg = scatterwalk_sg_next(sg);
 	}
 
 	return 0;
diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 81afd17..2e51f82 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -70,7 +70,7 @@ static void scatterwalk_pagedone(struct scatter_walk *walk, int out,
 		walk->offset += PAGE_SIZE - 1;
 		walk->offset &= PAGE_MASK;
 		if (walk->offset >= walk->sg->offset + walk->sg->length)
-			scatterwalk_start(walk, sg_next(walk->sg));
+			scatterwalk_start(walk, scatterwalk_sg_next(walk->sg));
 	}
 }
 
diff --git a/crypto/scatterwalk.h b/crypto/scatterwalk.h
index f1592cc..e049c62 100644
--- a/crypto/scatterwalk.h
+++ b/crypto/scatterwalk.h
@@ -20,7 +20,7 @@
 
 #include "internal.h"
 
-static inline struct scatterlist *sg_next(struct scatterlist *sg)
+static inline struct scatterlist *scatterwalk_sg_next(struct scatterlist *sg)
 {
 	return (++sg)->length ? sg : (void *)sg->page;
 }
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ca67484..302a5a1 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1368,7 +1368,7 @@ static void ata_qc_complete_internal(struct ata_queued_cmd *qc)
  */
 unsigned ata_exec_internal_sg(struct ata_device *dev,
 			      struct ata_taskfile *tf, const u8 *cdb,
-			      int dma_dir, struct scatterlist *sg,
+			      int dma_dir, struct scatterlist *sgl,
 			      unsigned int n_elem)
 {
 	struct ata_port *ap = dev->ap;
@@ -1426,11 +1426,12 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 	qc->dma_dir = dma_dir;
 	if (dma_dir != DMA_NONE) {
 		unsigned int i, buflen = 0;
+		struct scatterlist *sg;
+	
+		for_each_sg(sgl, sg, n_elem, i)
+			buflen += sg->length;
 
-		for (i = 0; i < n_elem; i++)
-			buflen += sg[i].length;
-
-		ata_sg_init(qc, sg, n_elem);
+		ata_sg_init(qc, sgl, n_elem);
 		qc->nbytes = buflen;
 	}
 
@@ -4185,6 +4186,21 @@ skip_map:
 	return 0;
 }
 
+/*
+ * This is obviously a hack that needs improving. We could track the
+ * last element while building the list, for instance.
+ */
+static struct scatterlist *ata_last_sg(struct ata_queued_cmd *qc)
+{
+	struct scatterlist *sg, *ret = NULL;
+	int i;
+
+	for_each_sg(qc->__sg, sg, qc->n_elem, i)
+		ret = sg;
+
+	return ret;
+}
+
 /**
  *	ata_sg_setup - DMA-map the scatter-gather table associated with a command.
  *	@qc: Command with scatter-gather table to be mapped.
@@ -4203,7 +4219,7 @@ static int ata_sg_setup(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	struct scatterlist *sg = qc->__sg;
-	struct scatterlist *lsg = &sg[qc->n_elem - 1];
+	struct scatterlist *lsg = ata_last_sg(qc);
 	int n_elem, pre_n_elem, dir, trim_sg = 0;
 
 	VPRINTK("ENTER, ata%u\n", ap->print_id);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 05d79af..065170b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -35,33 +35,19 @@
 
 struct scsi_host_sg_pool {
 	size_t		size;
-	char		*name; 
+	char		*name;
 	struct kmem_cache	*slab;
 	mempool_t	*pool;
 };
 
-#if (SCSI_MAX_PHYS_SEGMENTS < 32)
-#error SCSI_MAX_PHYS_SEGMENTS is too small
-#endif
-
-#define SP(x) { x, "sgpool-" #x } 
+#define SP(x) { x, "sgpool-" #x }
 static struct scsi_host_sg_pool scsi_sg_pools[] = {
 	SP(8),
 	SP(16),
 	SP(32),
-#if (SCSI_MAX_PHYS_SEGMENTS > 32)
 	SP(64),
-#if (SCSI_MAX_PHYS_SEGMENTS > 64)
 	SP(128),
-#if (SCSI_MAX_PHYS_SEGMENTS > 128)
-	SP(256),
-#if (SCSI_MAX_PHYS_SEGMENTS > 256)
-#error SCSI_MAX_PHYS_SEGMENTS is too large
-#endif
-#endif
-#endif
-#endif
-}; 	
+};
 #undef SP
 
 static void scsi_run_queue(struct request_queue *q);
@@ -302,14 +288,15 @@ static int scsi_req_map_sg(struct request *rq, struct scatterlist *sgl,
 	struct request_queue *q = rq->q;
 	int nr_pages = (bufflen + sgl[0].offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	unsigned int data_len = 0, len, bytes, off;
+	struct scatterlist *sg;
 	struct page *page;
 	struct bio *bio = NULL;
 	int i, err, nr_vecs = 0;
 
-	for (i = 0; i < nsegs; i++) {
-		page = sgl[i].page;
-		off = sgl[i].offset;
-		len = sgl[i].length;
+	for_each_sg(sgl, sg, nsegs, i) {
+		page = sg->page;
+		off = sg->offset;
+		len = sg->length;
 		data_len += len;
 
 		while (len > 0) {
@@ -701,56 +688,155 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int uptodate,
 	return NULL;
 }
 
-struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
-{
-	struct scsi_host_sg_pool *sgp;
-	struct scatterlist *sgl;
+/*
+ * Should fit within a single page, and must be a power-of-2.
+ */
+#define SCSI_MAX_SG_SEGMENTS	128
 
-	BUG_ON(!cmd->use_sg);
+static inline unsigned int scsi_sgtable_index(unsigned short nents)
+{
+	unsigned int index;
 
-	switch (cmd->use_sg) {
+	switch (nents) {
 	case 1 ... 8:
-		cmd->sglist_len = 0;
+		index = 0;
 		break;
 	case 9 ... 16:
-		cmd->sglist_len = 1;
+		index = 1;
 		break;
 	case 17 ... 32:
-		cmd->sglist_len = 2;
+		index = 2;
 		break;
-#if (SCSI_MAX_PHYS_SEGMENTS > 32)
 	case 33 ... 64:
-		cmd->sglist_len = 3;
-		break;
-#if (SCSI_MAX_PHYS_SEGMENTS > 64)
-	case 65 ... 128:
-		cmd->sglist_len = 4;
+		index = 3;
 		break;
-#if (SCSI_MAX_PHYS_SEGMENTS  > 128)
-	case 129 ... 256:
-		cmd->sglist_len = 5;
+	case 65 ... SCSI_MAX_SG_SEGMENTS:
+		index = 4;
 		break;
-#endif
-#endif
-#endif
 	default:
-		return NULL;
+		printk(KERN_ERR "scsi: bad segment count=%d\n", nents);
+		BUG();
 	}
 
-	sgp = scsi_sg_pools + cmd->sglist_len;
-	sgl = mempool_alloc(sgp->pool, gfp_mask);
-	return sgl;
+	return index;
+}
+
+struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
+{
+	struct scsi_host_sg_pool *sgp;
+	struct scatterlist *sgl, *prev, *ret;
+	unsigned int index;
+	int this, left;
+
+	BUG_ON(!cmd->use_sg);
+
+	left = cmd->use_sg;
+	ret = prev = NULL;
+	do {
+		this = left;
+		if (this > SCSI_MAX_SG_SEGMENTS) {
+			this = SCSI_MAX_SG_SEGMENTS;
+			index = SG_MEMPOOL_NR - 1;
+		} else
+			index = scsi_sgtable_index(this);
+
+		left -= this;
+
+		sgp = scsi_sg_pools + index;
+
+		sgl = mempool_alloc(sgp->pool, gfp_mask);
+		if (unlikely(!sgl))
+			goto enomem;
+
+		memset(sgl, 0, sizeof(*sgl) * sgp->size);
+
+		/*
+		 * first loop through, set initial index and return value
+		 */
+		if (!ret) {
+			cmd->sglist_len = index;
+			ret = sgl;
+		}
+
+		/*
+		 * chain previous sglist, if any. we know the previous
+		 * sglist must be the biggest one, or we would not have
+		 * ended up doing another loop.
+		 */
+		if (prev)
+			sg_chain(prev, SCSI_MAX_SG_SEGMENTS, sgl);
+
+		prev = sgl;
+	} while (left);
+
+	cmd->__use_sg = cmd->use_sg;
+	return ret;
+enomem:
+	if (ret) {
+		/*
+		 * Free entries chained off ret. Since we were trying to
+		 * allocate another sglist, we know that all entries are of
+		 * the max size.
+		 */
+		sgp = scsi_sg_pools + SG_MEMPOOL_NR - 1;
+		prev = &ret[SCSI_MAX_SG_SEGMENTS - 1];
+
+		while ((sgl = sg_chain_ptr(ret)) != NULL) {
+			ret = &sgl[SCSI_MAX_SG_SEGMENTS - 1];
+			mempool_free(sgl, sgp->pool);
+		}
+
+		mempool_free(prev, sgp->pool);
+	}
+	return NULL;
 }
 
 EXPORT_SYMBOL(scsi_alloc_sgtable);
 
-void scsi_free_sgtable(struct scatterlist *sgl, int index)
+void scsi_free_sgtable(struct scsi_cmnd *cmd)
 {
+	struct scatterlist *sgl = cmd->request_buffer;
 	struct scsi_host_sg_pool *sgp;
 
-	BUG_ON(index >= SG_MEMPOOL_NR);
+	BUG_ON(cmd->sglist_len >= SG_MEMPOOL_NR);
+
+	/*
+	 * if this is the biggest size sglist, check if we have
+	 * chained parts we need to free
+	 */
+	if (cmd->__use_sg > SCSI_MAX_SG_SEGMENTS) {
+		unsigned short this, left;
+		struct scatterlist *next;
+		unsigned int index;
+
+		left = cmd->__use_sg - SCSI_MAX_SG_SEGMENTS;
+		next = sg_chain_ptr(&sgl[SCSI_MAX_SG_SEGMENTS - 1]);
+		do {
+			sgl = next;
+			this = left;
+			if (this > SCSI_MAX_SG_SEGMENTS) {
+				this = SCSI_MAX_SG_SEGMENTS;
+				index = SG_MEMPOOL_NR - 1;
+			} else
+				index = scsi_sgtable_index(this);
 
-	sgp = scsi_sg_pools + index;
+			left -= this;
+
+			sgp = scsi_sg_pools + index;
+
+			if (left)
+				next = sg_chain_ptr(&sgl[sgp->size - 1]);
+
+			mempool_free(sgl, sgp->pool);
+		} while (left);
+
+		/*
+		 * Restore original, will be freed below
+		 */
+		sgl = cmd->request_buffer;
+	}
+
+	sgp = scsi_sg_pools + cmd->sglist_len;
 	mempool_free(sgl, sgp->pool);
 }
 
@@ -775,8 +861,8 @@ EXPORT_SYMBOL(scsi_free_sgtable);
  */
 static void scsi_release_buffers(struct scsi_cmnd *cmd)
 {
-	if (cmd->use_sg)
-		scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
+	if (cmd->__use_sg)
+		scsi_free_sgtable(cmd);
 
 	/*
 	 * Zero these out.  They now point to freed memory, and it is
@@ -1577,8 +1663,16 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 	if (!q)
 		return NULL;
 
+	/*
+	 * this limit is imposed by hardware restrictions
+	 */
 	blk_queue_max_hw_segments(q, shost->sg_tablesize);
-	blk_queue_max_phys_segments(q, SCSI_MAX_PHYS_SEGMENTS);
+
+	/*
+	 * we can chain scatterlists, so this limit is fairly arbitrary
+	 */
+	blk_queue_max_phys_segments(q, 128);
+
 	blk_queue_max_sectors(q, shost->max_sectors);
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
 	blk_queue_segment_boundary(q, shost->dma_boundary);
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index d402aff..dc6e3d3 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -407,7 +407,7 @@ static int scsi_tgt_init_cmd(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 	}
 
 	eprintk("cmd %p addr %p cnt %d\n", cmd, tcmd->buffer, cmd->use_sg);
-	scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
+	scsi_free_sgtable(cmd);
 	return -EINVAL;
 }
 
@@ -489,7 +489,7 @@ send_uspace_err:
 	dprintk("cmd %p request_bufflen %u bufflen %u\n",
 		cmd, cmd->request_bufflen, tcmd->bufflen);
 
-	scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
+	scsi_free_sgtable(cmd);
 	bio_list_add(&tcmd->xfer_done_list, cmd->request->bio);
 
 	tcmd->buffer += cmd->request_bufflen;
diff --git a/include/asm-i386/dma-mapping.h b/include/asm-i386/dma-mapping.h
index 183eebe..a956ec1 100644
--- a/include/asm-i386/dma-mapping.h
+++ b/include/asm-i386/dma-mapping.h
@@ -2,10 +2,10 @@
 #define _ASM_I386_DMA_MAPPING_H
 
 #include <linux/mm.h>
+#include <linux/scatterlist.h>
 
 #include <asm/cache.h>
 #include <asm/io.h>
-#include <asm/scatterlist.h>
 #include <asm/bug.h>
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
@@ -35,18 +35,19 @@ dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
 }
 
 static inline int
-dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
 	   enum dma_data_direction direction)
 {
+	struct scatterlist *sg;
 	int i;
 
 	BUG_ON(!valid_dma_direction(direction));
-	WARN_ON(nents == 0 || sg[0].length == 0);
+	WARN_ON(nents == 0 || sglist[0].length == 0);
 
-	for (i = 0; i < nents; i++ ) {
-		BUG_ON(!sg[i].page);
+	for_each_sg(sglist, sg, nents, i) {
+		BUG_ON(!sg->page);
 
-		sg[i].dma_address = page_to_phys(sg[i].page) + sg[i].offset;
+		sg->dma_address = page_to_phys(sg->page) + sg->offset;
 	}
 
 	flush_write_buffers();
diff --git a/include/asm-i386/scatterlist.h b/include/asm-i386/scatterlist.h
index 55d6c95..5654d3c 100644
--- a/include/asm-i386/scatterlist.h
+++ b/include/asm-i386/scatterlist.h
@@ -6,8 +6,11 @@ struct scatterlist {
     unsigned int	offset;
     dma_addr_t		dma_address;
     unsigned int	length;
+    struct scatterlist	*next;
 };
 
+#define ARCH_HAS_SG_CHAIN
+
 /* These macros should be used after a pci_map_sg call has been done
  * to get bus addresses of each of the SG entries and their lengths.
  * You should only work with the number of sg entries pci_map_sg
@@ -15,6 +18,7 @@ struct scatterlist {
  */
 #define sg_dma_address(sg)	((sg)->dma_address)
 #define sg_dma_len(sg)		((sg)->length)
+#define sg_chain_ptr(sg)	((sg)->next)
 
 #define ISA_DMA_THRESHOLD (0x00ffffff)
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index d8cfc72..1e4daa4 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -397,6 +397,7 @@ struct ata_queued_cmd {
 	unsigned long		flags;		/* ATA_QCFLAG_xxx */
 	unsigned int		tag;
 	unsigned int		n_elem;
+	unsigned int		n_iter;
 	unsigned int		orig_n_elem;
 
 	int			dma_dir;
@@ -945,7 +946,7 @@ ata_sg_is_last(struct scatterlist *sg, struct ata_queued_cmd *qc)
 		return 1;
 	if (qc->pad_len)
 		return 0;
-	if (((sg - qc->__sg) + 1) == qc->n_elem)
+	if (qc->n_iter == qc->n_elem)
 		return 1;
 	return 0;
 }
@@ -953,6 +954,7 @@ ata_sg_is_last(struct scatterlist *sg, struct ata_queued_cmd *qc)
 static inline struct scatterlist *
 ata_qc_first_sg(struct ata_queued_cmd *qc)
 {
+	qc->n_iter = 0;
 	if (qc->n_elem)
 		return qc->__sg;
 	if (qc->pad_len)
@@ -965,8 +967,8 @@ ata_qc_next_sg(struct scatterlist *sg, struct ata_queued_cmd *qc)
 {
 	if (sg == &qc->pad_sgent)
 		return NULL;
-	if (++sg - qc->__sg < qc->n_elem)
-		return sg;
+	if (++qc->n_iter < qc->n_elem)
+		return sg_next(sg);
 	if (qc->pad_len)
 		return &qc->pad_sgent;
 	return NULL;
@@ -1170,6 +1172,7 @@ static inline void ata_qc_reinit(struct ata_queued_cmd *qc)
 	qc->cursg = qc->cursg_ofs = 0;
 	qc->nbytes = qc->curbytes = 0;
 	qc->n_elem = 0;
+	qc->n_iter = 0;
 	qc->err_mask = 0;
 	qc->pad_len = 0;
 	qc->sect_size = ATA_SECT_SIZE;
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 4efbd9c..019b8b1 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -20,4 +20,26 @@ static inline void sg_init_one(struct scatterlist *sg, const void *buf,
 	sg_set_buf(sg, buf, buflen);
 }
 
+#ifdef ARCH_HAS_SG_CHAIN
+#define sg_next(sg)	(sg_chain_ptr((sg)) ? : (sg) + 1)
+/*
+ * Chain previous sglist to this one
+ */
+static inline void sg_chain(struct scatterlist *prv, unsigned int nents,
+			    struct scatterlist *sgl)
+{
+	sg_chain_ptr(&prv[nents - 1]) = sgl;
+}
+#else
+#define sg_next(sg)			((sg) + 1)
+#define sg_chain(prv, nents, sgl)	BUG()
+#define	sg_chain_ptr(sg)		NULL
+#endif
+
+/*
+ * Loop over each sg element, following the pointer to a new list if necessary
+ */
+#define for_each_sg(sglist, sg, nr, __i)	\
+	for (__i = 0, sg = (sglist); __i < nr; __i++, sg = sg_next(sg))
+
 #endif /* _LINUX_SCATTERLIST_H */
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 5c0e979..5487cb2 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -11,13 +11,6 @@
 #include <linux/types.h>
 
 /*
- *	The maximum sg list length SCSI can cope with
- *	(currently must be a power of 2 between 32 and 256)
- */
-#define SCSI_MAX_PHYS_SEGMENTS	MAX_PHYS_SEGMENTS
-
-
-/*
  *	SCSI command lengths
  */
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index d6948d0..96e8513 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -72,6 +72,7 @@ struct scsi_cmnd {
 	/* These elements define the operation we ultimately want to perform */
 	unsigned short use_sg;	/* Number of pieces of scatter-gather */
 	unsigned short sglist_len;	/* size of malloc'd scatter-gather list */
+	unsigned short __use_sg;
 
 	/* offset in cmd we are at (for multi-transfer tgt cmds) */
 	unsigned offset;
@@ -136,6 +137,6 @@ extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
 extern void scsi_kunmap_atomic_sg(void *virt);
 
 extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
-extern void scsi_free_sgtable(struct scatterlist *, int);
+extern void scsi_free_sgtable(struct scsi_cmnd *);
 
 #endif /* _SCSI_SCSI_CMND_H */

-- 
Jens Axboe

