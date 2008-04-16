Return-Path: <linux-kernel-owner+w=401wt.eu-S1753637AbYDPS5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbYDPS5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYDPS5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:57:03 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:44870 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbYDPS5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:57:01 -0400
From: Ryan Harper <ryanh@us.ibm.com>
To: virtualization@lists.linux-foundation.org
Cc: Ryan Harper <ryanh@us.ibm.com>, linux-kernel@vger.kernel.org,
       kvm-devel@lists.sourceforge.net, Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>
Subject: [PATCH] add virtio disk geometry feature
Date: Wed, 16 Apr 2008 13:56:37 -0500
Message-Id: <1208372197-20815-1-git-send-email-ryanh@us.ibm.com>
X-Mailer: git-send-email 1.5.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ryan Harper <ryanh@us.ibm.com>

Rather than faking up some geometry, allow the backend to push the disk
geometry via virtio pci config option.  Keep the old geo code around for
compatibility.

Signed-off-by: Ryan Harper <ryanh@us.ibm.com>
Reviewed-by: Anthony Liguori <aliguori@us.ibm.com>

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 0cfbe8c..1d2142a 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -157,10 +157,28 @@ static int virtblk_ioctl(struct inode *inode, struct file *filp,
 /* We provide getgeo only to please some old bootloader/partitioning tools */
 static int virtblk_getgeo(struct block_device *bd, struct hd_geometry *geo)
 {
-	/* some standard values, similar to sd */
-	geo->heads = 1 << 6;
-	geo->sectors = 1 << 5;
-	geo->cylinders = get_capacity(bd->bd_disk) >> 11;
+	struct virtio_blk *vblk = bd->bd_disk->private_data;
+	int err = 0;
+
+	/* see if the host passed in geometry config */
+	err = virtio_config_val(vblk->vdev, VIRTIO_BLK_F_GEOMETRY,
+				offsetof(struct virtio_blk_config, cylinders),
+				&geo->cylinders);
+	
+	/* if host sets geo flag, all 3 values must be present */
+	if (!err) {
+		__virtio_config_val(vblk->vdev,
+				offsetof(struct virtio_blk_config, heads),
+				&geo->heads);
+		__virtio_config_val(vblk->vdev,
+				offsetof(struct virtio_blk_config, sectors),
+				&geo->sectors);
+	} else {
+		/* some standard values, similar to sd */
+		geo->heads = 1 << 6;
+		geo->sectors = 1 << 5;
+		geo->cylinders = get_capacity(bd->bd_disk) >> 11;
+	}
 	return 0;
 }
 
diff --git a/include/linux/virtio_blk.h b/include/linux/virtio_blk.h
index bca0b10..142c496 100644
--- a/include/linux/virtio_blk.h
+++ b/include/linux/virtio_blk.h
@@ -9,6 +9,7 @@
 #define VIRTIO_BLK_F_BARRIER	0	/* Does host support barriers? */
 #define VIRTIO_BLK_F_SIZE_MAX	1	/* Indicates maximum segment size */
 #define VIRTIO_BLK_F_SEG_MAX	2	/* Indicates maximum # of segments */
+#define VIRTIO_BLK_F_GEOMETRY	4	/* Legacy geometry available  */
 
 struct virtio_blk_config
 {
@@ -18,6 +19,12 @@ struct virtio_blk_config
 	__le32 size_max;
 	/* The maximum number of segments (if VIRTIO_BLK_F_SEG_MAX) */
 	__le32 seg_max;
+	/* cylinders of the device (if VIRTIO_BLK_F_GEOMETRY) */
+	__le16 cylinders;
+	/* heads of the device (if VIRTIO_BLK_F_GEOMETRY) */
+	__u8 heads;
+	/* sectors of the device (if VIRTIO_BLK_F_GEOMETRY) */
+	__u8 sectors;
 } __attribute__((packed));
 
 /* These two define direction. */
