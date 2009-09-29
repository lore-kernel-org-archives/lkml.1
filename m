Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbZI2RSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbZI2RSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbZI2RSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:18:09 -0400
Received: from ozlabs.org ([203.10.76.45]:59215 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbZI2RSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:18:08 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 30 Sep 2009 02:48:09 +0930
Subject: [PATCH 1/4] virtio_blk: deprecate the 1024-byte ID field.
Cc: john cooper <john.cooper@redhat.com>,
       virtualization@lists.linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909300248.09630.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


PCI, lguest and s390 can all only support 256-byte configuration
space.  So, this giant field broke just about everyone.
Unfortunately, removing it is not so simple: we don't want to break
old userspace, but we're going to want to re-use that part of the
struct.

So, modern users can #define VIRTIO_BLK_IDENTIFY_DEPRECATED to indicate
that they know it's no longer in the config struct, and can use any
new features (all new features which add a configuration field will
conflict with this deprecated one).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/block/virtio_blk.c |   20 ++++++++++++++++++--
 include/linux/virtio_blk.h |   10 +++++++++-
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -1,4 +1,6 @@
 //#define DEBUG
+/* We want to see new fields: we use our own struct if we fall back to this */
+#define VIRTIO_BLK_IDENTIFY_DEPRECATED
 #include <linux/spinlock.h>
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
@@ -183,8 +185,22 @@ static void do_virtblk_request(struct re
 		vblk->vq->vq_ops->kick(vblk->vq);
 }
 
-/* return ATA identify data
+/* return ATA identify data: deprecated
  */
+struct virtio_blk_config_deprecated {
+	/* The capacity (in 512-byte sectors). */
+	__u64 capacity;
+	/* The maximum segment size (if VIRTIO_BLK_F_SIZE_MAX) */
+	__u32 size_max;
+	/* The maximum number of segments (if VIRTIO_BLK_F_SEG_MAX) */
+	__u32 seg_max;
+	/* geometry the device (if VIRTIO_BLK_F_GEOMETRY) */
+	struct virtio_blk_geometry geometry;
+	/* block size of device (if VIRTIO_BLK_F_BLK_SIZE) */
+	__u32 blk_size;
+	__u8 identify[VIRTIO_BLK_ID_BYTES];
+} __attribute__((packed));
+
 static int virtblk_identify(struct gendisk *disk, void *argp)
 {
 	struct virtio_blk *vblk = disk->private_data;
@@ -196,7 +212,7 @@ static int virtblk_identify(struct gendi
 		goto out;
 
 	err = virtio_config_buf(vblk->vdev, VIRTIO_BLK_F_IDENTIFY,
-		offsetof(struct virtio_blk_config, identify), opaque,
+		offsetof(struct virtio_blk_config_deprecated, identify), opaque,
 		VIRTIO_BLK_ID_BYTES);
 
 	if (err)
diff --git a/include/linux/virtio_blk.h b/include/linux/virtio_blk.h
--- a/include/linux/virtio_blk.h
+++ b/include/linux/virtio_blk.h
@@ -13,7 +13,7 @@
 #define VIRTIO_BLK_F_RO		5	/* Disk is read-only */
 #define VIRTIO_BLK_F_BLK_SIZE	6	/* Block size of disk is available*/
 #define VIRTIO_BLK_F_SCSI	7	/* Supports scsi command passthru */
-#define VIRTIO_BLK_F_IDENTIFY	8	/* ATA IDENTIFY supported */
+#define VIRTIO_BLK_F_IDENTIFY	8	/* ATA IDENTIFY support (deprecated) */
 #define VIRTIO_BLK_F_FLUSH	9	/* Cache flush command support */
 
 #define VIRTIO_BLK_ID_BYTES	(sizeof(__u16[256]))	/* IDENTIFY DATA */
@@ -33,7 +33,15 @@ struct virtio_blk_config {
 	} geometry;
 	/* block size of device (if VIRTIO_BLK_F_BLK_SIZE) */
 	__u32 blk_size;
+#ifndef VIRTIO_BLK_IDENTIFY_DEPRECATED
+	/*
+	 * New code shouldn't use this, but it's under the #ifndef so old
+	 * userspace doesn't break.
+	 */
 	__u8 identify[VIRTIO_BLK_ID_BYTES];
+#else
+	/* New fields go here: (all new extensions conflict with F_IDENTIFY) */
+#endif
 } __attribute__((packed));
 
 /*

