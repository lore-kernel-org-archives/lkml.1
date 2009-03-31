Return-Path: <linux-kernel-owner+w=401wt.eu-S1761977AbZCaDOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761977AbZCaDOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 23:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757028AbZCaDN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 23:13:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754906AbZCaDN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 23:13:58 -0400
Date: Mon, 30 Mar 2009 23:13:52 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: jens.axboe@oracle.com
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] remove virtual merge accounting
Message-ID: <Pine.LNX.4.64.0903302311490.6158@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Some times ago you removed virtual merge accounting from the kernel, but 
there is still one leftover variable, max_hw_segments. This patch removes 
it. It has the same meaning as max_phys_segments, and it is pointless to 
have two variables that do the same thing.

Mikulas

--

Remove max_hw_segments and blk_queue_max_hw_segments.

The virtual merge accounting was already removed, so this field has
the same meaning as max_phys_segments.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 arch/um/drivers/ubd_kern.c          |    2 +-
 block/blk-core.c                    |    3 +-
 block/blk-merge.c                   |    6 +----
 block/blk-settings.c                |   38 ++++------------------------------
 block/elevator.c                    |    2 +-
 drivers/ata/sata_nv.c               |    2 +-
 drivers/block/DAC960.c              |    1 -
 drivers/block/cciss.c               |    3 --
 drivers/block/cpqarray.c            |    3 --
 drivers/block/paride/pf.c           |    1 -
 drivers/block/ps3disk.c             |    1 -
 drivers/block/ps3vram.c             |    1 -
 drivers/block/sunvdc.c              |    1 -
 drivers/block/sx8.c                 |    1 -
 drivers/block/ub.c                  |    1 -
 drivers/block/viodasd.c             |    1 -
 drivers/block/virtio_blk.c          |    1 -
 drivers/block/xen-blkfront.c        |    1 -
 drivers/cdrom/gdrom.c               |    2 +-
 drivers/cdrom/viocd.c               |    1 -
 drivers/ide/ide-probe.c             |    1 -
 drivers/md/dm-table.c               |    9 --------
 drivers/memstick/core/mspro_block.c |    1 -
 drivers/message/i2o/i2o_block.c     |    4 +--
 drivers/mmc/card/queue.c            |    5 +--
 drivers/s390/block/dasd.c           |    1 -
 drivers/s390/char/tape_block.c      |    1 -
 drivers/scsi/scsi_lib.c             |    3 +-
 drivers/scsi/sg.c                   |    5 +--
 drivers/scsi/st.c                   |    3 +-
 fs/bio.c                            |    5 +---
 include/linux/blkdev.h              |    3 --
 include/linux/device-mapper.h       |    1 -
 33 files changed, 19 insertions(+), 95 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 0a86811..fff7640 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -870,7 +870,7 @@ static int ubd_add(int n, char **error_out)
 	}
 	ubd_dev->queue->queuedata = ubd_dev;
 
-	blk_queue_max_hw_segments(ubd_dev->queue, MAX_SG);
+	blk_queue_max_phys_segments(ubd_dev->queue, MAX_SG);
 	err = ubd_disk_register(MAJOR_NR, ubd_dev->size, n, &ubd_gendisk[n]);
 	if(err){
 		*error_out = "Failed to register device";
diff --git a/block/blk-core.c b/block/blk-core.c
index 996ed90..02d2cab 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1595,8 +1595,7 @@ int blk_rq_check_limits(struct request_queue *q, struct request *rq)
 	 * limitation.
 	 */
 	blk_recalc_rq_segments(rq);
-	if (rq->nr_phys_segments > q->max_phys_segments ||
-	    rq->nr_phys_segments > q->max_hw_segments) {
+	if (rq->nr_phys_segments > q->max_phys_segments) {
 		printk(KERN_ERR "%s: over max segments limit.\n", __func__);
 		return -EIO;
 	}
diff --git a/block/blk-merge.c b/block/blk-merge.c
index e39cb24..6611672 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -233,8 +233,7 @@ static inline int ll_new_hw_segment(struct request_queue *q,
 {
 	int nr_phys_segs = bio_phys_segments(q, bio);
 
-	if (req->nr_phys_segments + nr_phys_segs > q->max_hw_segments
-	    || req->nr_phys_segments + nr_phys_segs > q->max_phys_segments) {
+	if (req->nr_phys_segments + nr_phys_segs > q->max_phys_segments) {
 		req->cmd_flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
 			q->last_merge = NULL;
@@ -330,9 +329,6 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
 	if (total_phys_segments > q->max_phys_segments)
 		return 0;
 
-	if (total_phys_segments > q->max_hw_segments)
-		return 0;
-
 	/* Merge is OK... */
 	req->nr_phys_segments = total_phys_segments;
 	return 1;
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 59fd05d..a5e4074 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -124,7 +124,6 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
 	 */
 	q->nr_requests = BLKDEV_MAX_RQ;
 	blk_queue_max_phys_segments(q, MAX_PHYS_SEGMENTS);
-	blk_queue_max_hw_segments(q, MAX_HW_SEGMENTS);
 	blk_queue_segment_boundary(q, BLK_SEG_BOUNDARY_MASK);
 	blk_queue_max_segment_size(q, MAX_SEGMENT_SIZE);
 
@@ -241,30 +240,6 @@ void blk_queue_max_phys_segments(struct request_queue *q,
 EXPORT_SYMBOL(blk_queue_max_phys_segments);
 
 /**
- * blk_queue_max_hw_segments - set max hw segments for a request for this queue
- * @q:  the request queue for the device
- * @max_segments:  max number of segments
- *
- * Description:
- *    Enables a low level driver to set an upper limit on the number of
- *    hw data segments in a request.  This would be the largest number of
- *    address/length pairs the host adapter can actually give at once
- *    to the device.
- **/
-void blk_queue_max_hw_segments(struct request_queue *q,
-			       unsigned short max_segments)
-{
-	if (!max_segments) {
-		max_segments = 1;
-		printk(KERN_INFO "%s: set to minimum %d\n",
-		       __func__, max_segments);
-	}
-
-	q->max_hw_segments = max_segments;
-}
-EXPORT_SYMBOL(blk_queue_max_hw_segments);
-
-/**
  * blk_queue_max_segment_size - set max segment size for blk_rq_map_sg
  * @q:  the request queue for the device
  * @max_size:  max size of segment in bytes
@@ -320,7 +295,6 @@ void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b)
 	t->seg_boundary_mask = min_not_zero(t->seg_boundary_mask, b->seg_boundary_mask);
 
 	t->max_phys_segments = min_not_zero(t->max_phys_segments, b->max_phys_segments);
-	t->max_hw_segments = min_not_zero(t->max_hw_segments, b->max_hw_segments);
 	t->max_segment_size = min_not_zero(t->max_segment_size, b->max_segment_size);
 	t->hardsect_size = max(t->hardsect_size, b->hardsect_size);
 	if (!t->queue_lock)
@@ -383,21 +357,19 @@ EXPORT_SYMBOL(blk_queue_update_dma_pad);
  * does is adjust the queue so that the buf is always appended
  * silently to the scatterlist.
  *
- * Note: This routine adjusts max_hw_segments to make room for
- * appending the drain buffer.  If you call
- * blk_queue_max_hw_segments() or blk_queue_max_phys_segments() after
- * calling this routine, you must set the limit to one fewer than your
- * device can support otherwise there won't be room for the drain
+ * Note: This routine adjusts max_phys_segments to make room for
+ * appending the drain buffer.  If you call * blk_queue_max_phys_segments()
+ * after calling this routine, you must set the limit to one fewer than
+ * your device can support otherwise there won't be room for the drain
  * buffer.
  */
 int blk_queue_dma_drain(struct request_queue *q,
 			       dma_drain_needed_fn *dma_drain_needed,
 			       void *buf, unsigned int size)
 {
-	if (q->max_hw_segments < 2 || q->max_phys_segments < 2)
+	if (q->max_phys_segments < 2)
 		return -EINVAL;
 	/* make room for appending the drain */
-	--q->max_hw_segments;
 	--q->max_phys_segments;
 	q->dma_drain_needed = dma_drain_needed;
 	q->dma_drain_buffer = buf;
diff --git a/block/elevator.c b/block/elevator.c
index 98259ed..fba6eae 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -785,7 +785,7 @@ struct request *elv_next_request(struct request_queue *q)
 		if (q->dma_drain_size && rq->data_len) {
 			/*
 			 * make sure space for the drain appears we
-			 * know we can do this because max_hw_segments
+			 * know we can do this because max_phys_segments
 			 * has been adjusted to be one fewer than the
 			 * device can handle
 			 */
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index f65b537..e481d81 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -748,7 +748,7 @@ static int nv_adma_slave_config(struct scsi_device *sdev)
 	}
 
 	blk_queue_segment_boundary(sdev->request_queue, segment_boundary);
-	blk_queue_max_hw_segments(sdev->request_queue, sg_tablesize);
+	blk_queue_max_phys_segments(sdev->request_queue, sg_tablesize);
 	ata_port_printk(ap, KERN_INFO,
 		"DMA mask 0x%llX, segment boundary 0x%lX, hw segs %hu\n",
 		(unsigned long long)*ap->host->dev->dma_mask,
diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index f6a337c..e702e04 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -2531,7 +2531,6 @@ static bool DAC960_RegisterBlockDevice(DAC960_Controller_T *Controller)
   	Controller->RequestQueue[n] = RequestQueue;
   	blk_queue_bounce_limit(RequestQueue, Controller->BounceBufferLimit);
   	RequestQueue->queuedata = Controller;
-  	blk_queue_max_hw_segments(RequestQueue, Controller->DriverScatterGatherLimit);
 	blk_queue_max_phys_segments(RequestQueue, Controller->DriverScatterGatherLimit);
 	blk_queue_max_sectors(RequestQueue, Controller->MaxBlocksPerCommand);
 	disk->queue = RequestQueue;
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 5d0e135..933a660 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1363,9 +1363,6 @@ static void cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 	blk_queue_bounce_limit(disk->queue, h->pdev->dma_mask);
 
 	/* This is a hardware imposed limit. */
-	blk_queue_max_hw_segments(disk->queue, MAXSGENTRIES);
-
-	/* This is a limit in the driver and could be eliminated. */
 	blk_queue_max_phys_segments(disk->queue, MAXSGENTRIES);
 
 	blk_queue_max_sectors(disk->queue, h->cciss_max_sectors);
diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index ca268ca..c468adc 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -451,9 +451,6 @@ static int __init cpqarray_register_ctlr( int i, struct pci_dev *pdev)
 		blk_queue_bounce_limit(q, hba[i]->pci_dev->dma_mask);
 
 	/* This is a hardware imposed limit. */
-	blk_queue_max_hw_segments(q, SG_MAX);
-
-	/* This is a driver limit and could be eliminated. */
 	blk_queue_max_phys_segments(q, SG_MAX);
 	
 	init_timer(&hba[i]->timer);
diff --git a/drivers/block/paride/pf.c b/drivers/block/paride/pf.c
index bef3b99..4441de9 100644
--- a/drivers/block/paride/pf.c
+++ b/drivers/block/paride/pf.c
@@ -958,7 +958,6 @@ static int __init pf_init(void)
 	}
 
 	blk_queue_max_phys_segments(pf_queue, cluster);
-	blk_queue_max_hw_segments(pf_queue, cluster);
 
 	for (pf = units, unit = 0; unit < PF_UNITS; pf++, unit++) {
 		struct gendisk *disk = pf->disk;
diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index bccc42b..126bc12 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -487,7 +487,6 @@ static int __devinit ps3disk_probe(struct ps3_system_bus_device *_dev)
 			  ps3disk_prepare_flush);
 
 	blk_queue_max_phys_segments(queue, -1);
-	blk_queue_max_hw_segments(queue, -1);
 	blk_queue_max_segment_size(queue, dev->bounce_size);
 
 	gendisk = alloc_disk(PS3DISK_MINORS);
diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 393ed67..c01531c 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -741,7 +741,6 @@ static int __devinit ps3vram_probe(struct ps3_system_bus_device *dev)
 	queue->queuedata = dev;
 	blk_queue_make_request(queue, ps3vram_make_request);
 	blk_queue_max_phys_segments(queue, MAX_PHYS_SEGMENTS);
-	blk_queue_max_hw_segments(queue, MAX_HW_SEGMENTS);
 	blk_queue_max_segment_size(queue, MAX_SEGMENT_SIZE);
 	blk_queue_max_sectors(queue, SAFE_MAX_SECTORS);
 
diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 5861e33..35b01e7 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -697,7 +697,6 @@ static int probe_disk(struct vdc_port *port)
 
 	port->disk = g;
 
-	blk_queue_max_hw_segments(q, port->ring_cookies);
 	blk_queue_max_phys_segments(q, port->ring_cookies);
 	blk_queue_max_sectors(q, port->max_xfer_size);
 	g->major = vdc_major;
diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index a18e1ca..df21bd3 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -1521,7 +1521,6 @@ static int carm_init_disks(struct carm_host *host)
 			break;
 		}
 		disk->queue = q;
-		blk_queue_max_hw_segments(q, CARM_MAX_REQ_SG);
 		blk_queue_max_phys_segments(q, CARM_MAX_REQ_SG);
 		blk_queue_segment_boundary(q, CARM_SG_BOUNDARY);
 
diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index 12fb816..77008f8 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -2333,7 +2333,6 @@ static int ub_probe_lun(struct ub_dev *sc, int lnum)
 	disk->queue = q;
 
 	blk_queue_bounce_limit(q, BLK_BOUNCE_HIGH);
-	blk_queue_max_hw_segments(q, UB_MAX_REQ_SG);
 	blk_queue_max_phys_segments(q, UB_MAX_REQ_SG);
 	blk_queue_segment_boundary(q, 0xffffffff);	/* Dubious. */
 	blk_queue_max_sectors(q, UB_MAX_SECTORS);
diff --git a/drivers/block/viodasd.c b/drivers/block/viodasd.c
index ecccf65..795b161 100644
--- a/drivers/block/viodasd.c
+++ b/drivers/block/viodasd.c
@@ -479,7 +479,6 @@ retry:
 	}
 
 	d->disk = g;
-	blk_queue_max_hw_segments(q, VIOMAXBLOCKDMA);
 	blk_queue_max_phys_segments(q, VIOMAXBLOCKDMA);
 	blk_queue_max_sectors(q, VIODASD_MAXSECTORS);
 	g->major = VIODASD_MAJOR;
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 5d34764..d2b6f4d 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -293,7 +293,6 @@ static int virtblk_probe(struct virtio_device *vdev)
 
 	/* We can handle whatever the host told us to handle. */
 	blk_queue_max_phys_segments(vblk->disk->queue, vblk->sg_elems-2);
-	blk_queue_max_hw_segments(vblk->disk->queue, vblk->sg_elems-2);
 
 	/* No real sector limit. */
 	blk_queue_max_sectors(vblk->disk->queue, -1U);
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 8f90508..8131c69 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -353,7 +353,6 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size)
 
 	/* Ensure a merged request will fit in a single I/O ring slot. */
 	blk_queue_max_phys_segments(rq, BLKIF_MAX_SEGMENTS_PER_REQUEST);
-	blk_queue_max_hw_segments(rq, BLKIF_MAX_SEGMENTS_PER_REQUEST);
 
 	/* Make sure buffer addresses are sector-aligned. */
 	blk_queue_dma_alignment(rq, 511);
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 2eecb77..f053b0f 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -745,7 +745,7 @@ static int __devinit probe_gdrom_setupqueue(void)
 {
 	blk_queue_hardsect_size(gd.gdrom_rq, GDROM_HARD_SECTOR);
 	/* using DMA so memory will need to be contiguous */
-	blk_queue_max_hw_segments(gd.gdrom_rq, 1);
+	blk_queue_max_phys_segments(gd.gdrom_rq, 1);
 	/* set a large max size to get most from DMA */
 	blk_queue_max_segment_size(gd.gdrom_rq, 0x40000);
 	gd.disk->queue = gd.gdrom_rq;
diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
index 1392935..0603dff 100644
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@ -633,7 +633,6 @@ static int viocd_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	gendisk->first_minor = deviceno;
 	strncpy(gendisk->disk_name, c->name,
 			sizeof(gendisk->disk_name));
-	blk_queue_max_hw_segments(q, 1);
 	blk_queue_max_phys_segments(q, 1);
 	blk_queue_max_sectors(q, 4096 / 512);
 	gendisk->queue = q;
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index ee8e3e7..dc0258e 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -900,7 +900,6 @@ static int ide_init_queue(ide_drive_t *drive)
 		max_sg_entries >>= 1;
 #endif /* CONFIG_PCI */
 
-	blk_queue_max_hw_segments(q, max_sg_entries);
 	blk_queue_max_phys_segments(q, max_sg_entries);
 
 	/* assign drive queue */
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 2fd66c3..2fa1613 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -107,9 +107,6 @@ static void combine_restrictions_low(struct io_restrictions *lhs,
 	lhs->max_phys_segments =
 		min_not_zero(lhs->max_phys_segments, rhs->max_phys_segments);
 
-	lhs->max_hw_segments =
-		min_not_zero(lhs->max_hw_segments, rhs->max_hw_segments);
-
 	lhs->hardsect_size = max(lhs->hardsect_size, rhs->hardsect_size);
 
 	lhs->max_segment_size =
@@ -527,9 +524,6 @@ void dm_set_device_limits(struct dm_target *ti, struct block_device *bdev)
 		min_not_zero(rs->max_phys_segments,
 			     q->max_phys_segments);
 
-	rs->max_hw_segments =
-		min_not_zero(rs->max_hw_segments, q->max_hw_segments);
-
 	rs->hardsect_size = max(rs->hardsect_size, q->hardsect_size);
 
 	rs->max_segment_size =
@@ -682,8 +676,6 @@ static void check_for_valid_limits(struct io_restrictions *rs)
 		rs->max_hw_sectors = SAFE_MAX_SECTORS;
 	if (!rs->max_phys_segments)
 		rs->max_phys_segments = MAX_PHYS_SEGMENTS;
-	if (!rs->max_hw_segments)
-		rs->max_hw_segments = MAX_HW_SEGMENTS;
 	if (!rs->hardsect_size)
 		rs->hardsect_size = 1 << SECTOR_SHIFT;
 	if (!rs->max_segment_size)
@@ -885,7 +877,6 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q)
 	 */
 	blk_queue_max_sectors(q, t->limits.max_sectors);
 	q->max_phys_segments = t->limits.max_phys_segments;
-	q->max_hw_segments = t->limits.max_hw_segments;
 	q->hardsect_size = t->limits.hardsect_size;
 	q->max_segment_size = t->limits.max_segment_size;
 	q->max_hw_sectors = t->limits.max_hw_sectors;
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index de143de..a364437 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -1229,7 +1229,6 @@ static int mspro_block_init_disk(struct memstick_dev *card)
 	blk_queue_bounce_limit(msb->queue, limit);
 	blk_queue_max_sectors(msb->queue, MSPRO_BLOCK_MAX_PAGES);
 	blk_queue_max_phys_segments(msb->queue, MSPRO_BLOCK_MAX_SEGS);
-	blk_queue_max_hw_segments(msb->queue, MSPRO_BLOCK_MAX_SEGS);
 	blk_queue_max_segment_size(msb->queue,
 				   MSPRO_BLOCK_MAX_PAGES * msb->page_size);
 
diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index a443e13..c339a91 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -1068,13 +1068,11 @@ static int i2o_block_probe(struct device *dev)
 	queue = gd->queue;
 	queue->queuedata = i2o_blk_dev;
 
-	blk_queue_max_phys_segments(queue, I2O_MAX_PHYS_SEGMENTS);
+	blk_queue_max_phys_segments(queue, min(I2O_MAX_PHYS_SEGMENTS, i2o_sg_tablesize(c, body_size)));
 	blk_queue_max_sectors(queue, max_sectors);
-	blk_queue_max_hw_segments(queue, i2o_sg_tablesize(c, body_size));
 
 	osm_debug("max sectors = %d\n", queue->max_sectors);
 	osm_debug("phys segments = %d\n", queue->max_phys_segments);
-	osm_debug("max hw segments = %d\n", queue->max_hw_segments);
 
 	/*
 	 *      Ask for the current media data. If that isn't supported
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 7a72e75..7a32cbe 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -160,7 +160,6 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 			blk_queue_bounce_limit(mq->queue, BLK_BOUNCE_ANY);
 			blk_queue_max_sectors(mq->queue, bouncesz / 512);
 			blk_queue_max_phys_segments(mq->queue, bouncesz / 512);
-			blk_queue_max_hw_segments(mq->queue, bouncesz / 512);
 			blk_queue_max_segment_size(mq->queue, bouncesz);
 
 			mq->sg = kmalloc(sizeof(struct scatterlist),
@@ -186,8 +185,8 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 		blk_queue_bounce_limit(mq->queue, limit);
 		blk_queue_max_sectors(mq->queue,
 			min(host->max_blk_count, host->max_req_size / 512));
-		blk_queue_max_phys_segments(mq->queue, host->max_phys_segs);
-		blk_queue_max_hw_segments(mq->queue, host->max_hw_segs);
+	/* TODO: drop host->max_hw_segs */
+		blk_queue_max_phys_segments(mq->queue, min(host->max_phys_segs, host->max_hw_segs));
 		blk_queue_max_segment_size(mq->queue, host->max_seg_size);
 
 		mq->sg = kmalloc(sizeof(struct scatterlist) *
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 08c23a9..595ff9b 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -1990,7 +1990,6 @@ static void dasd_setup_queue(struct dasd_block *block)
 	max = block->base->discipline->max_blocks << block->s2b_shift;
 	blk_queue_max_sectors(block->request_queue, max);
 	blk_queue_max_phys_segments(block->request_queue, -1L);
-	blk_queue_max_hw_segments(block->request_queue, -1L);
 	blk_queue_max_segment_size(block->request_queue, -1L);
 	blk_queue_segment_boundary(block->request_queue, -1L);
 	blk_queue_ordered(block->request_queue, QUEUE_ORDERED_DRAIN, NULL);
diff --git a/drivers/s390/char/tape_block.c b/drivers/s390/char/tape_block.c
index ae18baf..55ece8d 100644
--- a/drivers/s390/char/tape_block.c
+++ b/drivers/s390/char/tape_block.c
@@ -235,7 +235,6 @@ tapeblock_setup_device(struct tape_device * device)
 	blk_queue_hardsect_size(blkdat->request_queue, TAPEBLOCK_HSEC_SIZE);
 	blk_queue_max_sectors(blkdat->request_queue, TAPEBLOCK_MAX_SEC);
 	blk_queue_max_phys_segments(blkdat->request_queue, -1L);
-	blk_queue_max_hw_segments(blkdat->request_queue, -1L);
 	blk_queue_max_segment_size(blkdat->request_queue, -1L);
 	blk_queue_segment_boundary(blkdat->request_queue, -1L);
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b82ffd9..c232ee0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1822,8 +1822,7 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 	/*
 	 * this limit is imposed by hardware restrictions
 	 */
-	blk_queue_max_hw_segments(q, shost->sg_tablesize);
-	blk_queue_max_phys_segments(q, SCSI_MAX_SG_CHAIN_SEGMENTS);
+	blk_queue_max_phys_segments(q, min(shost->sg_tablesize, (unsigned short)SCSI_MAX_SG_CHAIN_SEGMENTS));
 
 	blk_queue_max_sectors(q, shost->max_sectors);
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 516925d..7310de3 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -297,8 +297,7 @@ sg_open(struct inode *inode, struct file *filp)
 	if (!sdp->headfp) {	/* no existing opens on this device */
 		sdp->sgdebug = 0;
 		q = sdp->device->request_queue;
-		sdp->sg_tablesize = min(q->max_hw_segments,
-					q->max_phys_segments);
+		sdp->sg_tablesize = q->max_phys_segments;
 	}
 	if ((sfp = sg_add_sfp(sdp, dev)))
 		filp->private_data = sfp;
@@ -1389,7 +1388,7 @@ static Sg_device *sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 	sdp->disk = disk;
 	sdp->device = scsidp;
 	init_waitqueue_head(&sdp->o_excl_wait);
-	sdp->sg_tablesize = min(q->max_hw_segments, q->max_phys_segments);
+	sdp->sg_tablesize = q->max_phys_segments;
 	sdp->index = k;
 
 	error = 0;
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index c6f19ee..2d5624f 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3983,8 +3983,7 @@ static int st_probe(struct device *dev)
 		return -ENODEV;
 	}
 
-	i = min(SDp->request_queue->max_hw_segments,
-		SDp->request_queue->max_phys_segments);
+	i = SDp->request_queue->max_phys_segments;
 	if (st_max_sg_segs < i)
 		i = st_max_sg_segs;
 	buffer = new_tape_buffer((SDp->host)->unchecked_isa_dma, i);
diff --git a/fs/bio.c b/fs/bio.c
index a040cde..45dbc0e 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -494,8 +494,6 @@ int bio_get_nr_vecs(struct block_device *bdev)
 	nr_pages = ((q->max_sectors << 9) + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	if (nr_pages > q->max_phys_segments)
 		nr_pages = q->max_phys_segments;
-	if (nr_pages > q->max_hw_segments)
-		nr_pages = q->max_hw_segments;
 
 	return nr_pages;
 }
@@ -554,8 +552,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	 * make this too complex.
 	 */
 
-	while (bio->bi_phys_segments >= q->max_phys_segments
-	       || bio->bi_phys_segments >= q->max_hw_segments) {
+	while (bio->bi_phys_segments >= q->max_phys_segments) {
 
 		if (retried_segments)
 			return 0;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 465d6ba..2ece54d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -390,7 +390,6 @@ struct request_queue
 	unsigned int		max_sectors;
 	unsigned int		max_hw_sectors;
 	unsigned short		max_phys_segments;
-	unsigned short		max_hw_segments;
 	unsigned short		hardsect_size;
 	unsigned int		max_segment_size;
 
@@ -855,7 +854,6 @@ extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
 extern void blk_queue_bounce_limit(struct request_queue *, u64);
 extern void blk_queue_max_sectors(struct request_queue *, unsigned int);
 extern void blk_queue_max_phys_segments(struct request_queue *, unsigned short);
-extern void blk_queue_max_hw_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
 extern void blk_queue_hardsect_size(struct request_queue *, unsigned short);
 extern void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b);
@@ -934,7 +932,6 @@ extern void blk_unregister_filter(struct gendisk *disk);
 extern void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter);
 
 #define MAX_PHYS_SEGMENTS 128
-#define MAX_HW_SEGMENTS 128
 #define SAFE_MAX_SECTORS 255
 #define BLK_DEF_MAX_SECTORS 1024
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 8209e08..0230791 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -148,7 +148,6 @@ struct io_restrictions {
 	unsigned max_sectors;
 	unsigned max_segment_size;
 	unsigned short hardsect_size;
-	unsigned short max_hw_segments;
 	unsigned short max_phys_segments;
 	unsigned char no_cluster; /* inverted so that 0 is default */
 };
-- 
1.5.6.5

