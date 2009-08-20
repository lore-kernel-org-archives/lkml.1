Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZHTU4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZHTU4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 16:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbZHTU4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 16:56:23 -0400
Received: from verein.lst.de ([213.95.11.210]:43879 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908AbZHTU4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 16:56:23 -0400
Date: Thu, 20 Aug 2009 22:56:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: borntraeger@de.ibm.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] virtio-blk: set QUEUE_ORDERED_DRAIN by default
Message-ID: <20090820205616.GA5503@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently virtio-blk doesn't set any QUEUE_ORDERED_ flag by default, which
means it does not allow filesystems to use barriers.  But the typical use
case for virtio-blk is to use a backed that uses synchronous I/O, and in
that case we can simply set QUEUE_ORDERED_DRAIN to make the block layer
drain the request queue around barrier I/O and provide the semantics that
the filesystems need.  This is what the SCSI disk driver does for disks
that have the write cache disabled.

With this patch we incorrectly advertise barrier support if someone
configure qemu with write back caching.  While this displays wrong
information in the guest there is nothing that guest could have done
even if we rightfully told it that we do not support any barriers.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/block/virtio_blk.c
===================================================================
--- linux-2.6.orig/drivers/block/virtio_blk.c	2009-08-20 17:41:37.019718433 -0300
+++ linux-2.6/drivers/block/virtio_blk.c	2009-08-20 17:45:40.511747922 -0300
@@ -336,9 +336,16 @@ static int __devinit virtblk_probe(struc
 	vblk->disk->driverfs_dev = &vdev->dev;
 	index++;
 
-	/* If barriers are supported, tell block layer that queue is ordered */
+	/*
+	 * If barriers are supported, tell block layer that queue is ordered.
+	 *
+	 * If no barriers are supported assume the host uses synchronous
+	 * writes and just drain the the queue before and after the barrier.
+	 */
 	if (virtio_has_feature(vdev, VIRTIO_BLK_F_BARRIER))
 		blk_queue_ordered(vblk->disk->queue, QUEUE_ORDERED_TAG, NULL);
+	else
+		blk_queue_ordered(vblk->disk->queue, QUEUE_ORDERED_DRAIN, NULL);
 
 	/* If disk is read-only in the host, the guest should obey */
 	if (virtio_has_feature(vdev, VIRTIO_BLK_F_RO))
