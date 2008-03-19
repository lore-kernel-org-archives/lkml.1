Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbYCSTd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbYCSTd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbYCST0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:26:39 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:32862 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbYCST0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:26:36 -0400
From: Laurent Vivier <Laurent.Vivier@bull.net>
To: akpm@linux-foundation.org
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH][v4]  Modify loop device to be able to manage partitions of the disk image
Date: Wed, 19 Mar 2008 13:36:07 +0100
Message-Id: <12059301672966-git-send-email-Laurent.Vivier@bull.net>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12058427603971-git-send-email-Laurent.Vivier@bull.net>
References: <12058427603971-git-send-email-Laurent.Vivier@bull.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows to use loop device with partitionned disk image.

Original behavior of loop is not modified.

A new parameter is introduced to define how many partition we want to be
able to manage per loop device. This parameter is "max_part".

For instance, to manage 63 partitions / loop device, we will do:
# modprobe loop max_part=63
# ls -l /dev/loop?*
brw-rw---- 1 root disk 7,   0 2008-03-05 14:55 /dev/loop0
brw-rw---- 1 root disk 7,  64 2008-03-05 14:55 /dev/loop1
brw-rw---- 1 root disk 7, 128 2008-03-05 14:55 /dev/loop2
brw-rw---- 1 root disk 7, 192 2008-03-05 14:55 /dev/loop3
brw-rw---- 1 root disk 7, 256 2008-03-05 14:55 /dev/loop4
brw-rw---- 1 root disk 7, 320 2008-03-05 14:55 /dev/loop5
brw-rw---- 1 root disk 7, 384 2008-03-05 14:55 /dev/loop6
brw-rw---- 1 root disk 7, 448 2008-03-05 14:55 /dev/loop7

And to attach a raw partitionned disk image, the original losetup is used:

# losetup -f etch.img
# ls -l /dev/loop?*
brw-rw---- 1 root disk 7,   0 2008-03-05 14:55 /dev/loop0
brw-rw---- 1 root disk 7,   1 2008-03-05 14:57 /dev/loop0p1
brw-rw---- 1 root disk 7,   2 2008-03-05 14:57 /dev/loop0p2
brw-rw---- 1 root disk 7,   5 2008-03-05 14:57 /dev/loop0p5
brw-rw---- 1 root disk 7,  64 2008-03-05 14:55 /dev/loop1
brw-rw---- 1 root disk 7, 128 2008-03-05 14:55 /dev/loop2
brw-rw---- 1 root disk 7, 192 2008-03-05 14:55 /dev/loop3
brw-rw---- 1 root disk 7, 256 2008-03-05 14:55 /dev/loop4
brw-rw---- 1 root disk 7, 320 2008-03-05 14:55 /dev/loop5
brw-rw---- 1 root disk 7, 384 2008-03-05 14:55 /dev/loop6
brw-rw---- 1 root disk 7, 448 2008-03-05 14:55 /dev/loop7
# mount /dev/loop0p1 /mnt
# ls /mnt
bench  cdrom  home        lib         mnt   root     srv  usr
bin    dev    initrd      lost+found  opt   sbin     sys  var
boot   etc    initrd.img  media       proc  selinux  tmp  vmlinuz
# umount /mnt
# losetup -d /dev/loop0

Of course, the same behavior can be done using kpartx on a loop device,
but modifying loop avoids to stack several layers of block device (loop +
device mapper), this is a very light modification (40% of modifications
are to manage the new parameter).

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
---
 drivers/block/loop.c |   26 +++++++++++++++++++++-----
 1 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 91ebb00..f7f1635 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -82,6 +82,9 @@
 static LIST_HEAD(loop_devices);
 static DEFINE_MUTEX(loop_devices_mutex);
 
+static int max_part;
+static int part_shift;
+
 /*
  * Transfer functions
  */
@@ -692,6 +695,8 @@ static int loop_change_fd(struct loop_device *lo, struct file *lo_file,
 		goto out_putf;
 
 	fput(old_file);
+	if (max_part > 0)
+		ioctl_by_bdev(bdev, BLKRRPART, 0);
 	return 0;
 
  out_putf:
@@ -819,6 +824,8 @@ static int loop_set_fd(struct loop_device *lo, struct file *lo_file,
 	}
 	lo->lo_state = Lo_bound;
 	wake_up_process(lo->lo_thread);
+	if (max_part > 0)
+		ioctl_by_bdev(bdev, BLKRRPART, 0);
 	return 0;
 
 out_clr:
@@ -919,6 +926,8 @@ static int loop_clr_fd(struct loop_device *lo, struct block_device *bdev)
 	fput(filp);
 	/* This is safe: open() is still holding a reference. */
 	module_put(THIS_MODULE);
+	if (max_part > 0)
+		ioctl_by_bdev(bdev, BLKRRPART, 0);
 	return 0;
 }
 
@@ -1360,6 +1369,8 @@ static struct block_device_operations lo_fops = {
 static int max_loop;
 module_param(max_loop, int, 0);
 MODULE_PARM_DESC(max_loop, "Maximum number of loop devices");
+module_param(max_part, int, 0);
+MODULE_PARM_DESC(max_part, "Maximum number of partitions per loop device");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(LOOP_MAJOR);
 
@@ -1412,7 +1423,7 @@ static struct loop_device *loop_alloc(int i)
 	if (!lo->lo_queue)
 		goto out_free_dev;
 
-	disk = lo->lo_disk = alloc_disk(1);
+	disk = lo->lo_disk = alloc_disk(1 << part_shift);
 	if (!disk)
 		goto out_free_queue;
 
@@ -1422,7 +1433,7 @@ static struct loop_device *loop_alloc(int i)
 	init_waitqueue_head(&lo->lo_event);
 	spin_lock_init(&lo->lo_lock);
 	disk->major		= LOOP_MAJOR;
-	disk->first_minor	= i;
+	disk->first_minor	= i << part_shift;
 	disk->fops		= &lo_fops;
 	disk->private_data	= lo;
 	disk->queue		= lo->lo_queue;
@@ -1502,7 +1513,12 @@ static int __init loop_init(void)
 	 *     themselves and have kernel automatically instantiate actual
 	 *     device on-demand.
 	 */
-	if (max_loop > 1UL << MINORBITS)
+
+	part_shift = 0;
+	if (max_part > 0)
+		part_shift = fls(max_part);
+
+	if (max_loop > 1UL << (MINORBITS - part_shift))
 		return -EINVAL;
 
 	if (max_loop) {
@@ -1510,7 +1526,7 @@ static int __init loop_init(void)
 		range = max_loop;
 	} else {
 		nr = 8;
-		range = 1UL << MINORBITS;
+		range = 1UL << (MINORBITS - part_shift);
 	}
 
 	if (register_blkdev(LOOP_MAJOR, "loop"))
@@ -1549,7 +1565,7 @@ static void __exit loop_exit(void)
 	unsigned long range;
 	struct loop_device *lo, *next;
 
-	range = max_loop ? max_loop :  1UL << MINORBITS;
+	range = max_loop ? max_loop :  1UL << (MINORBITS - part_shift);
 
 	list_for_each_entry_safe(lo, next, &loop_devices, lo_list)
 		loop_del_one(lo);
-- 
1.5.2.4

