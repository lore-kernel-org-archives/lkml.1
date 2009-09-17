Return-Path: <linux-kernel-owner+w=401wt.eu-S1759890AbZIQR5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759890AbZIQR5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 13:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758877AbZIQR5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 13:57:45 -0400
Received: from verein.lst.de ([213.95.11.210]:60502 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758735AbZIQR5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 13:57:44 -0400
Date: Thu, 17 Sep 2009 19:57:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] virtio-blk: add support for cache flush
Message-ID: <20090917175742.GA2416@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () UPPERCASE_25_50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Recent qemu has added a VIRTIO_BLK_F_FLUSH flag to advertise that the
virtual disk has a volatile write cache that needs to be flushed.  In case
we see this feature implement tell the Linux block layer about the fact
and use the new VIRTIO_BLK_T_FLUSH to flush the cache when required.  This
allows for an correct and simple implementation of write barriers.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/block/virtio_blk.c
===================================================================
--- linux-2.6.orig/drivers/block/virtio_blk.c	2009-09-17 14:31:58.269278765 -0300
+++ linux-2.6/drivers/block/virtio_blk.c	2009-09-17 14:32:43.228031777 -0300
@@ -91,15 +91,26 @@ static bool do_req(struct request_queue 
 		return false;
 
 	vbr->req = req;
-	if (blk_fs_request(vbr->req)) {
+	switch (req->cmd_type) {
+	case REQ_TYPE_FS:
 		vbr->out_hdr.type = 0;
 		vbr->out_hdr.sector = blk_rq_pos(vbr->req);
 		vbr->out_hdr.ioprio = req_get_ioprio(vbr->req);
-	} else if (blk_pc_request(vbr->req)) {
+		break;
+	case REQ_TYPE_BLOCK_PC:
 		vbr->out_hdr.type = VIRTIO_BLK_T_SCSI_CMD;
 		vbr->out_hdr.sector = 0;
 		vbr->out_hdr.ioprio = req_get_ioprio(vbr->req);
-	} else {
+		break;
+	case REQ_TYPE_LINUX_BLOCK:
+		if (req->cmd[0] == REQ_LB_OP_FLUSH) {
+			vbr->out_hdr.type = VIRTIO_BLK_T_FLUSH;
+			vbr->out_hdr.sector = 0;
+			vbr->out_hdr.ioprio = req_get_ioprio(vbr->req);
+			break;
+		}
+		/*FALLTHRU*/
+	default:
 		/* We don't put anything else in the queue. */
 		BUG();
 	}
@@ -199,6 +210,12 @@ out:
 	return err;
 }
 
+static void virtblk_prepare_flush(struct request_queue *q, struct request *req)
+{
+	req->cmd_type = REQ_TYPE_LINUX_BLOCK;
+	req->cmd[0] = REQ_LB_OP_FLUSH;
+}
+
 static int virtblk_ioctl(struct block_device *bdev, fmode_t mode,
 			 unsigned cmd, unsigned long data)
 {
@@ -336,7 +353,10 @@ static int __devinit virtblk_probe(struc
 	index++;
 
 	/* If barriers are supported, tell block layer that queue is ordered */
-	if (virtio_has_feature(vdev, VIRTIO_BLK_F_BARRIER))
+	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH))
+		blk_queue_ordered(vblk->disk->queue, QUEUE_ORDERED_DRAIN_FLUSH,
+				  virtblk_prepare_flush);
+	else if (virtio_has_feature(vdev, VIRTIO_BLK_F_BARRIER))
 		blk_queue_ordered(vblk->disk->queue, QUEUE_ORDERED_TAG, NULL);
 
 	/* If disk is read-only in the host, the guest should obey */
@@ -423,7 +443,7 @@ static struct virtio_device_id id_table[
 static unsigned int features[] = {
 	VIRTIO_BLK_F_BARRIER, VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX,
 	VIRTIO_BLK_F_GEOMETRY, VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE,
-	VIRTIO_BLK_F_SCSI, VIRTIO_BLK_F_IDENTIFY
+	VIRTIO_BLK_F_SCSI, VIRTIO_BLK_F_IDENTIFY, VIRTIO_BLK_F_FLUSH
 };
 
 /*
Index: linux-2.6/include/linux/virtio_blk.h
===================================================================
--- linux-2.6.orig/include/linux/virtio_blk.h	2009-09-02 08:37:31.460714184 -0300
+++ linux-2.6/include/linux/virtio_blk.h	2009-09-17 14:32:03.245004201 -0300
@@ -17,6 +17,7 @@
 #define VIRTIO_BLK_F_BLK_SIZE	6	/* Block size of disk is available*/
 #define VIRTIO_BLK_F_SCSI	7	/* Supports scsi command passthru */
 #define VIRTIO_BLK_F_IDENTIFY	8	/* ATA IDENTIFY supported */
+#define VIRTIO_BLK_F_FLUSH	9	/* Cache flush command support */
 
 #define VIRTIO_BLK_ID_BYTES	(sizeof(__u16[256]))	/* IDENTIFY DATA */
 
@@ -38,6 +39,17 @@ struct virtio_blk_config {
 	__u8 identify[VIRTIO_BLK_ID_BYTES];
 } __attribute__((packed));
 
+/*
+ * Command types
+ *
+ * Usage is a bit tricky as some bits are used as flags and some are not.
+ *
+ * Rules:
+ *   VIRTIO_BLK_T_OUT may be combinaed with VIRTIO_BLK_T_SCSI_CMD or
+ *   VIRTIO_BLK_T_BARRIER.  VIRTIO_BLK_T_FLUSH is a command of it's own
+ *   and may no be comined with any of the other flags.
+ */
+
 /* These two define direction. */
 #define VIRTIO_BLK_T_IN		0
 #define VIRTIO_BLK_T_OUT	1
@@ -45,6 +57,9 @@ struct virtio_blk_config {
 /* This bit says it's a scsi command, not an actual read or write. */
 #define VIRTIO_BLK_T_SCSI_CMD	2
 
+/* Cache flush command */
+#define VIRTIO_BLK_T_FLUSH	4
+
 /* Barrier before this op. */
 #define VIRTIO_BLK_T_BARRIER	0x80000000
 
