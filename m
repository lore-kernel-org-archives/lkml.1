Return-Path: <linux-kernel-owner+w=401wt.eu-S1751114AbZH0RG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751114AbZH0RG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbZH0RGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:06:25 -0400
Received: from verein.lst.de ([213.95.11.210]:40882 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbZH0RGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:06:24 -0400
Date: Thu, 27 Aug 2009 19:06:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Avi Kivity <avi@redhat.com>, Christoph Hellwig <hch@lst.de>,
       borntraeger@de.ibm.com, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH] virtio-blk: set QUEUE_ORDERED_DRAIN by default
Message-ID: <20090827170605.GA28387@lst.de>
References: <20090820205616.GA5503@lst.de> <200908262136.46570.rusty@rustcorp.com.au> <4A952A5D.5040606@redhat.com> <200908272013.50839.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908272013.50839.rusty@rustcorp.com.au>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I just wanted this small fix for cache modes that are sane out ASAP.
Maybe the picture is more clear once the we also add the support for
properly flagging volatile writecaches.

This is what I currently have, including experimental support in qemu
that I'm going to send out soon:


Index: linux-2.6/drivers/block/virtio_blk.c
===================================================================
--- linux-2.6.orig/drivers/block/virtio_blk.c
+++ linux-2.6/drivers/block/virtio_blk.c
@@ -91,15 +91,25 @@ static bool do_req(struct request_queue 
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
@@ -171,6 +181,12 @@ static void do_virtblk_request(struct re
 		vblk->vq->vq_ops->kick(vblk->vq);
 }
 
+static void virtblk_prepare_flush(struct request_queue *q, struct request *req)
+{
+	req->cmd_type = REQ_TYPE_LINUX_BLOCK;
+	req->cmd[0] = REQ_LB_OP_FLUSH;
+}
+
 /* return ATA identify data
  */
 static int virtblk_identify(struct gendisk *disk, void *argp)
@@ -336,9 +352,27 @@ static int __devinit virtblk_probe(struc
 	vblk->disk->driverfs_dev = &vdev->dev;
 	index++;
 
-	/* If barriers are supported, tell block layer that queue is ordered */
-	if (virtio_has_feature(vdev, VIRTIO_BLK_F_BARRIER))
+	/*
+	 * Set up queue ordering flags.  If a host has any sort of volatile
+	 * write cache it absolutely needs to set the WCACHE feature flag
+	 * so that we know about it and can flush it when needed.
+	 *
+	 * If it is not set assume that there is no caching going on and we
+	 * can just drain the the queue before and after the barrier.
+	 *
+	 * Alternatively a host can set the barrier feature flag to get
+	 * barrier requests tag.  This is not safe if write caching is
+	 * implemented and generally no recommended to be implemented in a
+	 * new host driver.
+         */
+	if (virtio_has_feature(vdev, VIRTIO_BLK_F_WCACHE)) {
+		blk_queue_ordered(vblk->disk->queue, QUEUE_ORDERED_DRAIN_FLUSH,
+				  virtblk_prepare_flush);
+	} else if (virtio_has_feature(vdev, VIRTIO_BLK_F_BARRIER)) {
 		blk_queue_ordered(vblk->disk->queue, QUEUE_ORDERED_TAG, NULL);
+	} else {
+		blk_queue_ordered(vblk->disk->queue, QUEUE_ORDERED_DRAIN, NULL);
+	}
 
 	/* If disk is read-only in the host, the guest should obey */
 	if (virtio_has_feature(vdev, VIRTIO_BLK_F_RO))
@@ -424,7 +458,7 @@ static struct virtio_device_id id_table[
 static unsigned int features[] = {
 	VIRTIO_BLK_F_BARRIER, VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX,
 	VIRTIO_BLK_F_GEOMETRY, VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE,
-	VIRTIO_BLK_F_SCSI, VIRTIO_BLK_F_IDENTIFY
+	VIRTIO_BLK_F_SCSI, VIRTIO_BLK_F_IDENTIFY, VIRTIO_BLK_F_WCACHE
 };
 
 /*
Index: linux-2.6/include/linux/virtio_blk.h
===================================================================
--- linux-2.6.orig/include/linux/virtio_blk.h
+++ linux-2.6/include/linux/virtio_blk.h
@@ -17,6 +17,7 @@
 #define VIRTIO_BLK_F_BLK_SIZE	6	/* Block size of disk is available*/
 #define VIRTIO_BLK_F_SCSI	7	/* Supports scsi command passthru */
 #define VIRTIO_BLK_F_IDENTIFY	8	/* ATA IDENTIFY supported */
+#define VIRTIO_BLK_F_WCACHE	9	/* write cache enabled */
 
 #define VIRTIO_BLK_ID_BYTES	(sizeof(__u16[256]))	/* IDENTIFY DATA */
 
@@ -45,6 +46,9 @@ struct virtio_blk_config {
 /* This bit says it's a scsi command, not an actual read or write. */
 #define VIRTIO_BLK_T_SCSI_CMD	2
 
+/* Flush the volatile write cache */
+#define VIRTIO_BLK_T_FLUSH	4
+
 /* Barrier before this op. */
 #define VIRTIO_BLK_T_BARRIER	0x80000000
 
