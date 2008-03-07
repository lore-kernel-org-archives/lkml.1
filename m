Return-Path: <linux-kernel-owner+w=401wt.eu-S1759982AbYCGMYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982AbYCGMYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 07:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYCGMY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 07:24:29 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59080 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbYCGMY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 07:24:28 -0500
From: Laurent Vivier <Laurent.Vivier@bull.net>
To: linux-kernel@vger.kernel.org
Cc: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH][v2] Modify loop device to be able to manage partitions of the disk image
Date: Fri,  7 Mar 2008 13:27:40 +0100
Message-Id: <12048928601734-git-send-email-Laurent.Vivier@bull.net>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows to use loop device with partitionned disk image.

Original behavior of loop is not modified.

A new parameter is introduced to define how many partition we want to be
able to manage per loop device. This parameter is "loop_max_part".

For instance, to manage 63 partitions / loop device, we will do:
# modprobe loop loop_max_part=63
# ls -l /dev/loop?
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
EXT3 FS on loop0p1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
loop: module loaded
 loop0: p1 p2 < p5 >
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
kjournald starting.  Commit interval 5 seconds
EXT3 FS on loop0p1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
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
 Documentation/kernel-parameters.txt |    4 +++
 drivers/block/loop.c                |   39 ++++++++++++++++++++++++++++++----
 2 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9a5b665..7f2fd52 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1075,6 +1075,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			be mounted
 			Format: <1-256>
 
+	loop_max_part=	[LOOP] Maximum number of partitions per loopback device.
+			Should be greater than 0, the maximum value depends
+			on max_loop.
+
 	maxcpus=	[SMP] Maximum number of processors that	an SMP kernel
 			should make use of.  maxcpus=n : n >= 0 limits the
 			kernel to using 'n' processors.  n=0 is a special case,
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 91ebb00..84fa98f 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -82,6 +82,9 @@
 static LIST_HEAD(loop_devices);
 static DEFINE_MUTEX(loop_devices_mutex);
 
+static int loop_max_part;
+static int part_shift;
+
 /*
  * Transfer functions
  */
@@ -692,6 +695,8 @@ static int loop_change_fd(struct loop_device *lo, struct file *lo_file,
 		goto out_putf;
 
 	fput(old_file);
+	if (loop_max_part > 0)
+		ioctl_by_bdev(bdev, BLKRRPART, 0);
 	return 0;
 
  out_putf:
@@ -819,6 +824,8 @@ static int loop_set_fd(struct loop_device *lo, struct file *lo_file,
 	}
 	lo->lo_state = Lo_bound;
 	wake_up_process(lo->lo_thread);
+	if (loop_max_part > 0)
+		ioctl_by_bdev(bdev, BLKRRPART, 0);
 	return 0;
 
 out_clr:
@@ -1360,6 +1367,8 @@ static struct block_device_operations lo_fops = {
 static int max_loop;
 module_param(max_loop, int, 0);
 MODULE_PARM_DESC(max_loop, "Maximum number of loop devices");
+module_param(loop_max_part, int, 0);
+MODULE_PARM_DESC(loop_max_part, "Maximum number of partitions per loop device");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(LOOP_MAJOR);
 
@@ -1412,7 +1421,7 @@ static struct loop_device *loop_alloc(int i)
 	if (!lo->lo_queue)
 		goto out_free_dev;
 
-	disk = lo->lo_disk = alloc_disk(1);
+	disk = lo->lo_disk = alloc_disk(1 << part_shift);
 	if (!disk)
 		goto out_free_queue;
 
@@ -1422,7 +1431,7 @@ static struct loop_device *loop_alloc(int i)
 	init_waitqueue_head(&lo->lo_event);
 	spin_lock_init(&lo->lo_lock);
 	disk->major		= LOOP_MAJOR;
-	disk->first_minor	= i;
+	disk->first_minor	= i << part_shift;
 	disk->fops		= &lo_fops;
 	disk->private_data	= lo;
 	disk->queue		= lo->lo_queue;
@@ -1502,7 +1511,12 @@ static int __init loop_init(void)
 	 *     themselves and have kernel automatically instantiate actual
 	 *     device on-demand.
 	 */
-	if (max_loop > 1UL << MINORBITS)
+
+	part_shift = 0;
+	if (loop_max_part > 0)
+		part_shift = fls(loop_max_part);
+
+	if (max_loop > 1UL << (MINORBITS - part_shift))
 		return -EINVAL;
 
 	if (max_loop) {
@@ -1510,7 +1524,7 @@ static int __init loop_init(void)
 		range = max_loop;
 	} else {
 		nr = 8;
-		range = 1UL << MINORBITS;
+		range = 1UL << (MINORBITS - part_shift);
 	}
 
 	if (register_blkdev(LOOP_MAJOR, "loop"))
@@ -1549,7 +1563,7 @@ static void __exit loop_exit(void)
 	unsigned long range;
 	struct loop_device *lo, *next;
 
-	range = max_loop ? max_loop :  1UL << MINORBITS;
+	range = max_loop ? max_loop :  1UL << (MINORBITS - part_shift);
 
 	list_for_each_entry_safe(lo, next, &loop_devices, lo_list)
 		loop_del_one(lo);
@@ -1569,4 +1583,19 @@ static int __init max_loop_setup(char *str)
 }
 
 __setup("max_loop=", max_loop_setup);
+
+static int __init max_part_setup(char *str)
+{
+	loop_max_part = simple_strtol(str, NULL, 0);
+	if (loop_max_part > (1UL << (MINORBITS - 1))) {
+		/* we must keep at least one bit for loop device number */
+		printk(KERN_ERR
+			"loop: loop_max_part cannot be greater than %d\n",
+			1UL << (MINORBITS - 1));
+		return 0;
+	}
+	return 1;
+}
+
+__setup("loop_max_part=", max_part_setup);
 #endif
-- 
1.5.2.4

