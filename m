Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbYDPVQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbYDPVQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 17:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbYDPVQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 17:16:08 -0400
Received: from ozlabs.org ([203.10.76.45]:35900 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbYDPVQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 17:16:07 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ryan Harper <ryanh@us.ibm.com>
Subject: Re: [PATCH] add virtio disk geometry feature
Date: Thu, 17 Apr 2008 07:15:54 +1000
User-Agent: KMail/1.9.9
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm-devel@lists.sourceforge.net, Anthony Liguori <aliguori@us.ibm.com>
References: <1208372197-20815-1-git-send-email-ryanh@us.ibm.com>
In-Reply-To: <1208372197-20815-1-git-send-email-ryanh@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804170715.55041.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 April 2008 04:56:37 Ryan Harper wrote:
> From: Ryan Harper <ryanh@us.ibm.com>
>
> Rather than faking up some geometry, allow the backend to push the disk
> geometry via virtio pci config option.  Keep the old geo code around for
> compatibility.

Hi Ryan,

   Looks good! Some brief review below.  Mainly just "how I would have done
things" stuff.  BTW, does this help in real life?  I assume something in
userspace wants it?

> +	int err = 0;
> +
> +	/* see if the host passed in geometry config */
> +	err = virtio_config_val(vblk->vdev, VIRTIO_BLK_F_GEOMETRY,
> +				offsetof(struct virtio_blk_config, cylinders),
> +				&geo->cylinders);

Unnecessary err initialization.  Sometimes gcc catches bugs when you defer 
initializations of err to as late as possible (ie. paths where err isn't
set properly), so I tend to do it.

> +	/* if host sets geo flag, all 3 values must be present */
> +	if (!err) {
> +		__virtio_config_val(vblk->vdev,
> +				offsetof(struct virtio_blk_config, heads),
> +				&geo->heads);
> +		__virtio_config_val(vblk->vdev,
> +				offsetof(struct virtio_blk_config, sectors),
> +				&geo->sectors);

Kind of ugly; we can represent this in the data structure explicitly tho...

> @@ -18,6 +19,12 @@ struct virtio_blk_config
>  	__le32 size_max;
>  	/* The maximum number of segments (if VIRTIO_BLK_F_SEG_MAX) */
>  	__le32 seg_max;
> +	/* cylinders of the device (if VIRTIO_BLK_F_GEOMETRY) */
> +	__le16 cylinders;
> +	/* heads of the device (if VIRTIO_BLK_F_GEOMETRY) */
> +	__u8 heads;
> +	/* sectors of the device (if VIRTIO_BLK_F_GEOMETRY) */
> +	__u8 sectors;
>  } __attribute__((packed));

... using a struct-within-a-struct.

Here's the result:
Subject: add virtio disk geometry feature
Date: Wed, 16 Apr 2008 13:56:37 -0500
From: Ryan Harper <ryanh@us.ibm.com>

Rather than faking up some geometry, allow the backend to push the disk
geometry via virtio pci config option.  Keep the old geo code around for
compatibility.

Signed-off-by: Ryan Harper <ryanh@us.ibm.com>
Reviewed-by: Anthony Liguori <aliguori@us.ibm.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (modified to single struct)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -157,10 +157,25 @@ static int virtblk_ioctl(struct inode *i
 /* We provide getgeo only to please some old bootloader/partitioning tools */
 static int virtblk_getgeo(struct block_device *bd, struct hd_geometry *geo)
 {
-	/* some standard values, similar to sd */
-	geo->heads = 1 << 6;
-	geo->sectors = 1 << 5;
-	geo->cylinders = get_capacity(bd->bd_disk) >> 11;
+	struct virtio_blk *vblk = bd->bd_disk->private_data;
+	struct virtio_blk_geometry vgeo;
+	int err;
+
+	/* see if the host passed in geometry config */
+	err = virtio_config_val(vblk->vdev, VIRTIO_BLK_F_GEOMETRY,
+				offsetof(struct virtio_blk_config, geometry),
+				&vgeo);
+
+	if (!err) {
+		geo->heads = vgeo.heads;
+		geo->sectors = vgeo.sectors;
+		geo->cylinders = vgeo.cylinders;
+	} else {
+		/* some standard values, similar to sd */
+		geo->heads = 1 << 6;
+		geo->sectors = 1 << 5;
+		geo->cylinders = get_capacity(bd->bd_disk) >> 11;
+	}
 	return 0;
 }
 
diff --git a/include/linux/virtio_blk.h b/include/linux/virtio_blk.h
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
+	/* geometry the device (if VIRTIO_BLK_F_GEOMETRY) */
+	struct virtio_blk_geometry {
+		__le16 cylinders;
+		__u8 heads;
+		__u8 sectors;
+	} geometry;
 } __attribute__((packed));
 
 /* These two define direction. */
