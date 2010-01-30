Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656Ab0A3UTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab0A3UTX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 15:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617Ab0A3UTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 15:19:21 -0500
Received: from verein.lst.de ([213.95.11.210]:48332 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587Ab0A3UTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 15:19:19 -0500
Date: Sat, 30 Jan 2010 21:19:10 +0100
From: Christoph Hellwig <hch@lst.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@lst.de>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_blk: add block topology support
Message-ID: <20100130201910.GA19811@lst.de>
References: <20100129190158.GA25122@lst.de> <201001301529.49848.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001301529.49848.rusty@rustcorp.com.au>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 30, 2010 at 03:29:49PM +1030, Rusty Russell wrote:
> I bow to your expertise on that.  My only query is the __u16 for min_io_size; is that likely to restrict us?

Looks like you caught me there - I wrote the above odd format about the
physical_block exponent, but scsi actually does the min_io and opt_io
size in logical blocks, too.  With that in account the u16 as in scsi
is perfectly fine.

> Also, patch seems to be based on a prior one?

Yes, quilt once again totally messed up the patch, sorry.

New version below that uses block based values everywhere (but still the
strange exponent for the physical block size) and actually contains
all the needed hunks.  I'll make sure qemu also advertizes the values in
blocks.  Btw, I remember you had a virtio protocol documentation
somewhere - is that one only for the base virtio protocol or does it
also include virtio-blk?  I'll prepare some patches for it if it
includes the latter.

---

From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] virtio_blk: add block topology support

Allow reading various alignment values from the config page.  This
allows the guest to much better align I/O requests depending on the
storage topology.

Note that the formats for the config values appear a bit messed up,
but we follow the formats used by ATA and SCSI so they are expected in
the storage world.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/block/virtio_blk.c
===================================================================
--- linux-2.6.orig/drivers/block/virtio_blk.c	2010-01-30 11:26:36.867004166 +0100
+++ linux-2.6/drivers/block/virtio_blk.c	2010-01-30 19:04:39.378003955 +0100
@@ -243,10 +243,12 @@ static int index_to_minor(int index)
 static int __devinit virtblk_probe(struct virtio_device *vdev)
 {
 	struct virtio_blk *vblk;
+	struct request_queue *q;
 	int err;
 	u64 cap;
-	u32 v;
-	u32 blk_size, sg_elems;
+	u32 v, blk_size, sg_elems, opt_io_size;
+	u16 min_io_size;
+	u8 physical_block_exp, alignment_offset;
 
 	if (index_to_minor(index) >= 1 << MINORBITS)
 		return -ENOSPC;
@@ -293,13 +295,13 @@ static int __devinit virtblk_probe(struc
 		goto out_mempool;
 	}
 
-	vblk->disk->queue = blk_init_queue(do_virtblk_request, &vblk->lock);
-	if (!vblk->disk->queue) {
+	q = vblk->disk->queue = blk_init_queue(do_virtblk_request, &vblk->lock);
+	if (!q) {
 		err = -ENOMEM;
 		goto out_put_disk;
 	}
 
-	vblk->disk->queue->queuedata = vblk;
+	q->queuedata = vblk;
 
 	if (index < 26) {
 		sprintf(vblk->disk->disk_name, "vd%c", 'a' + index % 26);
@@ -323,10 +325,10 @@ static int __devinit virtblk_probe(struc
 
 	/* If barriers are supported, tell block layer that queue is ordered */
 	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH))
-		blk_queue_ordered(vblk->disk->queue, QUEUE_ORDERED_DRAIN_FLUSH,
+		blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH,
 				  virtblk_prepare_flush);
 	else if (virtio_has_feature(vdev, VIRTIO_BLK_F_BARRIER))
-		blk_queue_ordered(vblk->disk->queue, QUEUE_ORDERED_TAG, NULL);
+		blk_queue_ordered(q, QUEUE_ORDERED_TAG, NULL);
 
 	/* If disk is read-only in the host, the guest should obey */
 	if (virtio_has_feature(vdev, VIRTIO_BLK_F_RO))
@@ -345,14 +347,14 @@ static int __devinit virtblk_probe(struc
 	set_capacity(vblk->disk, cap);
 
 	/* We can handle whatever the host told us to handle. */
-	blk_queue_max_phys_segments(vblk->disk->queue, vblk->sg_elems-2);
-	blk_queue_max_hw_segments(vblk->disk->queue, vblk->sg_elems-2);
+	blk_queue_max_phys_segments(q, vblk->sg_elems-2);
+	blk_queue_max_hw_segments(q, vblk->sg_elems-2);
 
 	/* No need to bounce any requests */
-	blk_queue_bounce_limit(vblk->disk->queue, BLK_BOUNCE_ANY);
+	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
 
 	/* No real sector limit. */
-	blk_queue_max_sectors(vblk->disk->queue, -1U);
+	blk_queue_max_sectors(q, -1U);
 
 	/* Host can optionally specify maximum segment size and number of
 	 * segments. */
@@ -360,16 +362,45 @@ static int __devinit virtblk_probe(struc
 				offsetof(struct virtio_blk_config, size_max),
 				&v);
 	if (!err)
-		blk_queue_max_segment_size(vblk->disk->queue, v);
+		blk_queue_max_segment_size(q, v);
 	else
-		blk_queue_max_segment_size(vblk->disk->queue, -1U);
+		blk_queue_max_segment_size(q, -1U);
 
 	/* Host can optionally specify the block size of the device */
 	err = virtio_config_val(vdev, VIRTIO_BLK_F_BLK_SIZE,
 				offsetof(struct virtio_blk_config, blk_size),
 				&blk_size);
 	if (!err)
-		blk_queue_logical_block_size(vblk->disk->queue, blk_size);
+		blk_queue_logical_block_size(q, blk_size);
+	else
+		blk_size = queue_logical_block_size(q);
+
+	/* Use topology information if available */
+	err = virtio_config_val(vdev, VIRTIO_BLK_F_TOPOLOGY,
+			offsetof(struct virtio_blk_config, physical_block_exp),
+			&physical_block_exp);
+	if (!err && physical_block_exp)
+		blk_queue_physical_block_size(q,
+				blk_size * (1 << physical_block_exp));
+
+	err = virtio_config_val(vdev, VIRTIO_BLK_F_TOPOLOGY,
+			offsetof(struct virtio_blk_config, alignment_offset),
+			&alignment_offset);
+	if (!err && alignment_offset)
+		blk_queue_alignment_offset(q, blk_size * alignment_offset);
+
+	err = virtio_config_val(vdev, VIRTIO_BLK_F_TOPOLOGY,
+			offsetof(struct virtio_blk_config, min_io_size),
+			&min_io_size);
+	if (!err && min_io_size)
+		blk_queue_io_min(q, blk_size * min_io_size);
+
+	err = virtio_config_val(vdev, VIRTIO_BLK_F_TOPOLOGY,
+			offsetof(struct virtio_blk_config, opt_io_size),
+			&opt_io_size);
+	if (!err && opt_io_size)
+		blk_queue_io_opt(q, blk_size * opt_io_size);
+
 
 	add_disk(vblk->disk);
 	return 0;
@@ -412,7 +443,7 @@ static struct virtio_device_id id_table[
 static unsigned int features[] = {
 	VIRTIO_BLK_F_BARRIER, VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX,
 	VIRTIO_BLK_F_GEOMETRY, VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE,
-	VIRTIO_BLK_F_SCSI, VIRTIO_BLK_F_FLUSH
+	VIRTIO_BLK_F_SCSI, VIRTIO_BLK_F_FLUSH, VIRTIO_BLK_F_TOPOLOGY
 };
 
 /*
Index: linux-2.6/include/linux/virtio_blk.h
===================================================================
--- linux-2.6.orig/include/linux/virtio_blk.h	2010-01-29 23:10:26.000000000 +0100
+++ linux-2.6/include/linux/virtio_blk.h	2010-01-30 19:09:46.397253920 +0100
@@ -15,6 +15,7 @@
 #define VIRTIO_BLK_F_BLK_SIZE	6	/* Block size of disk is available*/
 #define VIRTIO_BLK_F_SCSI	7	/* Supports scsi command passthru */
 #define VIRTIO_BLK_F_FLUSH	9	/* Cache flush command support */
+#define VIRTIO_BLK_F_TOPOLOGY	10	/* Topology information is available */
 
 struct virtio_blk_config {
 	/* The capacity (in 512-byte sectors). */
@@ -29,8 +30,20 @@ struct virtio_blk_config {
 		__u8 heads;
 		__u8 sectors;
 	} geometry;
+
 	/* block size of device (if VIRTIO_BLK_F_BLK_SIZE) */
 	__u32 blk_size;
+
+	/* the next 4 entries are guarded by VIRTIO_BLK_F_TOPOLOGY  */
+	/* exponent for physical block per logical block. */
+	__u8 physical_block_exp;
+	/* alignment offset in logical blocks. */
+	__u8 alignment_offset;
+	/* minimum I/O size without performance penalty in logical blocks. */
+	__u16 min_io_size;
+	/* optimal sustained I/O size in logical blocks. */
+	__u32 opt_io_size;
+
 } __attribute__((packed));
 
 /*
