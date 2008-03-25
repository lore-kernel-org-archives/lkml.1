Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbYCYKcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbYCYKcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 06:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbYCYKcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 06:32:31 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:35859 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbYCYKca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 06:32:30 -0400
From: Laurent Vivier <Laurent.Vivier@bull.net>
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-kernel@vger.kernel.org, Bill Davidsen <davidsen@tmr.com>,
       nbd-general@lists.sourceforge.net,
       Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH] Modify Network Block Device (nbd) to be able to manage partitions
Date: Tue, 25 Mar 2008 11:34:58 +0100
Message-Id: <12064412984094-git-send-email-Laurent.Vivier@bull.net>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <47E6E8B4.5000602@tmr.com>
References: <47E6E8B4.5000602@tmr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows to use partitions with network block devices (NBD).

A new parameter is introduced to define how many partition we want to be
able to manage per network block device. This parameter is "max_part".

For instance, to manage 63 partitions / loop device, we will do:

   [on the server side]
# nbd-server 1234 /dev/sdb
   [on the client side]
# modprobe nbd max_part=63
# ls -l /dev/nbd*
brw-rw---- 1 root disk 43,   0 2008-03-25 11:14 /dev/nbd0
brw-rw---- 1 root disk 43,  64 2008-03-25 11:11 /dev/nbd1
brw-rw---- 1 root disk 43, 640 2008-03-25 11:11 /dev/nbd10
brw-rw---- 1 root disk 43, 704 2008-03-25 11:11 /dev/nbd11
brw-rw---- 1 root disk 43, 768 2008-03-25 11:11 /dev/nbd12
brw-rw---- 1 root disk 43, 832 2008-03-25 11:11 /dev/nbd13
brw-rw---- 1 root disk 43, 896 2008-03-25 11:11 /dev/nbd14
brw-rw---- 1 root disk 43, 960 2008-03-25 11:11 /dev/nbd15
brw-rw---- 1 root disk 43, 128 2008-03-25 11:11 /dev/nbd2
brw-rw---- 1 root disk 43, 192 2008-03-25 11:11 /dev/nbd3
brw-rw---- 1 root disk 43, 256 2008-03-25 11:11 /dev/nbd4
brw-rw---- 1 root disk 43, 320 2008-03-25 11:11 /dev/nbd5
brw-rw---- 1 root disk 43, 384 2008-03-25 11:11 /dev/nbd6
brw-rw---- 1 root disk 43, 448 2008-03-25 11:11 /dev/nbd7
brw-rw---- 1 root disk 43, 512 2008-03-25 11:11 /dev/nbd8
brw-rw---- 1 root disk 43, 576 2008-03-25 11:11 /dev/nbd9
# nbd-client localhost 1234 /dev/nbd0
Negotiation: ..size = 80418240KB
bs=1024, sz=80418240

-------NOTE, RFC: partition table is not automatically read.
The driver sets bdev->bd_invalidated to 1 to force the read of the partition
table of the device, but this is done only on an open of the device.
So we have to do a "touch /dev/nbdX" or something like that.
It can't be done from the nbd-client or nbd driver because at this
level we can't ask to read the partition table and to serve the request
at the same time (-> deadlock)

If someone has a better idea, I'm open to any suggestion.
-------NOTE, RFC

# fdisk -l /dev/nbd0

Disk /dev/nbd0: 82.3 GB, 82348277760 bytes
255 heads, 63 sectors/track, 10011 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

     Device Boot      Start         End      Blocks   Id  System
/dev/nbd0p1   *           1        9965    80043831   83  Linux
/dev/nbd0p2            9966       10011      369495    5  Extended
/dev/nbd0p5            9966       10011      369463+  82  Linux swap / Solaris

# ls -l /dev/nbd0*
brw-rw---- 1 root disk 43,   0 2008-03-25 11:16 /dev/nbd0
brw-rw---- 1 root disk 43,   1 2008-03-25 11:16 /dev/nbd0p1
brw-rw---- 1 root disk 43,   2 2008-03-25 11:16 /dev/nbd0p2
brw-rw---- 1 root disk 43,   5 2008-03-25 11:16 /dev/nbd0p5
# mount /dev/nbd0p1 /mnt
# ls /mnt
bin    dev   initrd      lost+found  opt   sbin     sys  var
boot   etc   initrd.img  media       proc  selinux  tmp  vmlinuz
cdrom  home  lib         mnt         root  srv      usr
# umount /mnt
# nbd-client -d /dev/nbd0
# ls -l /dev/nbd0*
brw-rw---- 1 root disk 43, 0 2008-03-25 11:16 /dev/nbd0
-------NOTE
On "nbd-client -d", we can do an iocl(BLKRRPART) to update partition table:
as the size of the device is 0, we don't have to serve the partition manager
request (-> no deadlock).
-------NOTE

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
---
 drivers/block/nbd.c |   25 ++++++++++++++++++++++---
 1 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index b53fdb0..36070d5 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -55,6 +55,7 @@ static unsigned int debugflags;
 
 static unsigned int nbds_max = 16;
 static struct nbd_device *nbd_dev;
+static int max_part;
 
 /*
  * Use just one lock (or at most 1 per NIC). Two arguments for this:
@@ -565,10 +566,13 @@ static int nbd_ioctl(struct inode *inode, struct file *file,
 		error = -EINVAL;
 		file = fget(arg);
 		if (file) {
+			struct block_device *bdev = inode->i_bdev;
 			inode = file->f_path.dentry->d_inode;
 			if (S_ISSOCK(inode->i_mode)) {
 				lo->file = file;
 				lo->sock = SOCKET_I(inode);
+				if (max_part > 0)
+					bdev->bd_invalidated = 1;
 				error = 0;
 			} else {
 				fput(file);
@@ -613,6 +617,8 @@ static int nbd_ioctl(struct inode *inode, struct file *file,
 		lo->bytesize = 0;
 		inode->i_bdev->bd_inode->i_size = 0;
 		set_capacity(lo->disk, 0);
+		if (max_part > 0)
+			ioctl_by_bdev(inode->i_bdev, BLKRRPART, 0);
 		return lo->harderror;
 	case NBD_CLEAR_QUE:
 		/*
@@ -646,6 +652,7 @@ static int __init nbd_init(void)
 {
 	int err = -ENOMEM;
 	int i;
+	int part_shift;
 
 	BUILD_BUG_ON(sizeof(struct nbd_request) != 28);
 
@@ -653,8 +660,17 @@ static int __init nbd_init(void)
 	if (!nbd_dev)
 		return -ENOMEM;
 
+	if (max_part < 0) {
+		printk(KERN_CRIT "nbd: max_part must be >= 0\n");
+		return -EINVAL;
+	}
+
+	part_shift = 0;
+	if (max_part > 0)
+		part_shift = fls(max_part);
+
 	for (i = 0; i < nbds_max; i++) {
-		struct gendisk *disk = alloc_disk(1);
+		struct gendisk *disk = alloc_disk(1 << part_shift);
 		elevator_t *old_e;
 		if (!disk)
 			goto out;
@@ -696,10 +712,11 @@ static int __init nbd_init(void)
 		nbd_dev[i].blksize = 1024;
 		nbd_dev[i].bytesize = 0;
 		disk->major = NBD_MAJOR;
-		disk->first_minor = i;
+		disk->first_minor = i << part_shift;
 		disk->fops = &nbd_fops;
 		disk->private_data = &nbd_dev[i];
-		disk->flags |= GENHD_FL_SUPPRESS_PARTITION_INFO;
+		if (max_part == 0)
+			disk->flags |= GENHD_FL_SUPPRESS_PARTITION_INFO;
 		sprintf(disk->disk_name, "nbd%d", i);
 		set_capacity(disk, 0);
 		add_disk(disk);
@@ -738,6 +755,8 @@ MODULE_LICENSE("GPL");
 
 module_param(nbds_max, int, 0444);
 MODULE_PARM_DESC(nbds_max, "How many network block devices to initialize.");
+module_param(max_part, int, 0444);
+MODULE_PARM_DESC(max_part, "How many partitions by device.");
 #ifndef NDEBUG
 module_param(debugflags, int, 0644);
 MODULE_PARM_DESC(debugflags, "flags for controlling debug output");
-- 
1.5.2.4

