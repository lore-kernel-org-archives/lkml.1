Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbZFIGe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbZFIGe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbZFIGeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:34:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46666 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880AbZFIGeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:34:19 -0400
Date: Tue, 9 Jun 2009 15:09:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Hannes Reinecke <hare@suse.de>, john cooper <john.cooper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: linux-next: manual merge of the block tree with the rr tree
Message-Id: <20090609150930.45eb8a32.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Today's linux-next merge of the block tree got conflicts in
drivers/block/virtio_blk.c and include/linux/virtio_blk.h between commit
a69a9b05d1050c24767d438bbe220157b7ff9250 ("Add serial number support for
virtio_blk, V4a") from the rr tree and commit
1cde26f928863d90e9e7c1217880c8450464d305 ("virtio_blk: SG_IO passthru
support") from the block tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/block/virtio_blk.c
index ad8cb22,c4845b1..0000000
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@@ -178,14 -175,16 +203,22 @@@ static int virtblk_ioctl(struct block_d
  			 unsigned cmd, unsigned long data)
  {
  	struct gendisk *disk = bdev->bd_disk;
 +	void __user *argp = (void __user *)data;
+ 	struct virtio_blk *vblk = disk->private_data;
  
 -	/*
 -	 * Only allow the generic SCSI ioctls if the host can support it.
 -	 */
 -	if (!virtio_has_feature(vblk->vdev, VIRTIO_BLK_F_SCSI))
 -		return -ENOIOCTLCMD;
 -
 -	return scsi_cmd_ioctl(disk->queue, disk, mode, cmd,
 -			      (void __user *)data);
 +	switch (cmd) {
 +	case HDIO_GET_IDENTITY:
 +		return virtblk_identify(disk, argp);
 +	default:
++		/*
++		 * Only allow the generic SCSI ioctls if the host
++		 * can support it.
++		 */
++		if (!virtio_has_feature(vblk->vdev, VIRTIO_BLK_F_SCSI))
++			return -ENOIOCTLCMD;
++
 +		return scsi_cmd_ioctl(disk->queue, disk, mode, cmd, argp);
 +	}
  }
  
  /* We provide getgeo only to please some old bootloader/partitioning tools */
@@@ -390,7 -390,7 +424,7 @@@ static struct virtio_device_id id_table
  static unsigned int features[] = {
  	VIRTIO_BLK_F_BARRIER, VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX,
  	VIRTIO_BLK_F_GEOMETRY, VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE,
- 	VIRTIO_BLK_F_IDENTIFY
 -	VIRTIO_BLK_F_SCSI,
++	VIRTIO_BLK_F_SCSI, VIRTIO_BLK_F_IDENTIFY,
  };
  
  static struct virtio_driver virtio_blk = {
diff --cc include/linux/virtio_blk.h
index eb470d5,4dbcbc1..0000000
--- a/include/linux/virtio_blk.h
+++ b/include/linux/virtio_blk.h
@@@ -15,9 -15,7 +15,10 @@@
  #define VIRTIO_BLK_F_GEOMETRY	4	/* Legacy geometry available  */
  #define VIRTIO_BLK_F_RO		5	/* Disk is read-only */
  #define VIRTIO_BLK_F_BLK_SIZE	6	/* Block size of disk is available*/
+ #define VIRTIO_BLK_F_SCSI	7	/* Supports scsi command passthru */
 +#define VIRTIO_BLK_F_IDENTIFY	8	/* ATA IDENTIFY supported */
 +
 +#define VIRTIO_BLK_ID_BYTES	(sizeof(__u16[256]))	/* IDENTIFY DATA */
  
  struct virtio_blk_config
  {
