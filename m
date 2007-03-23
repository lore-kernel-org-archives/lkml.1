Return-Path: <linux-kernel-owner+w=401wt.eu-S2992635AbXCWX2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992635AbXCWX2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 19:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992630AbXCWX2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 19:28:18 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:36798 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934332AbXCWX16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 19:27:58 -0400
Date: Sat, 24 Mar 2007 00:26:34 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Tomas M <tomas@slax.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] max_loop limit
In-Reply-To: <Pine.LNX.4.61.0703230232320.9555@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0703240023220.10028@yvahk01.tjqt.qr>
References: <460236CE.1030303@slax.org> <20070322110058.GB23664@tatooine.rebelbase.local>
 <46026A92.4020106@slax.org> <20070322144210.73dfaf83.dada1@cosmosbay.com>
 <Pine.LNX.4.61.0703230232320.9555@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


here's one. Allocates all the fluff dynamically. It does not create any
dev nodes by itself, so you need to do it (à la mdadm), but you'll get all
1048576 available minors.

Sadly, it locks up the foreground process (losetup that would be), and I
have not yet figured out why. And the mpt regression elsewhere is
hindering me in finding out faster.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.21-rc4/drivers/block/loop.c
===================================================================
--- linux-2.6.21-rc4.orig/drivers/block/loop.c
+++ linux-2.6.21-rc4/drivers/block/loop.c
@@ -77,9 +77,8 @@
 
 #include <asm/uaccess.h>
 
-static int max_loop = 8;
-static struct loop_device *loop_dev;
-static struct gendisk **disks;
+static LIST_HEAD(loop_devices);
+static DEFINE_SPINLOCK(loop_devices_lock);
 
 /*
  * Transfer functions
@@ -183,7 +182,7 @@ figure_loop_size(struct loop_device *lo)
 	if (unlikely((loff_t)x != size))
 		return -EFBIG;
 
-	set_capacity(disks[lo->lo_number], x);
+	set_capacity(lo->lo_disk, x);
 	return 0;					
 }
 
@@ -812,7 +811,7 @@ static int loop_set_fd(struct loop_devic
 	lo->lo_queue->queuedata = lo;
 	lo->lo_queue->unplug_fn = loop_unplug;
 
-	set_capacity(disks[lo->lo_number], size);
+	set_capacity(lo->lo_disk, size);
 	bd_set_size(bdev, size << 9);
 
 	set_blocksize(bdev, lo_blocksize);
@@ -832,7 +831,7 @@ out_clr:
 	lo->lo_device = NULL;
 	lo->lo_backing_file = NULL;
 	lo->lo_flags = 0;
-	set_capacity(disks[lo->lo_number], 0);
+	set_capacity(lo->lo_disk, 0);
 	invalidate_bdev(bdev, 0);
 	bd_set_size(bdev, 0);
 	mapping_set_gfp_mask(mapping, lo->old_gfp_mask);
@@ -918,7 +917,7 @@ static int loop_clr_fd(struct loop_devic
 	memset(lo->lo_crypt_name, 0, LO_NAME_SIZE);
 	memset(lo->lo_file_name, 0, LO_NAME_SIZE);
 	invalidate_bdev(bdev, 0);
-	set_capacity(disks[lo->lo_number], 0);
+	set_capacity(lo->lo_disk, 0);
 	bd_set_size(bdev, 0);
 	mapping_set_gfp_mask(filp->f_mapping, gfp);
 	lo->lo_state = Lo_unbound;
@@ -1357,8 +1356,6 @@ static struct block_device_operations lo
 /*
  * And now the modules code and kernel interface.
  */
-module_param(max_loop, int, 0);
-MODULE_PARM_DESC(max_loop, "Maximum number of loop devices (1-256)");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(LOOP_MAJOR);
 
@@ -1383,7 +1380,7 @@ int loop_unregister_transfer(int number)
 
 	xfer_funcs[n] = NULL;
 
-	for (lo = &loop_dev[0]; lo < &loop_dev[max_loop]; lo++) {
+	list_for_each_entry(lo, &loop_devices, lo_list) {
 		mutex_lock(&lo->lo_ctl_mutex);
 
 		if (lo->lo_encryption == xfer)
@@ -1398,102 +1395,102 @@ int loop_unregister_transfer(int number)
 EXPORT_SYMBOL(loop_register_transfer);
 EXPORT_SYMBOL(loop_unregister_transfer);
 
-static int __init loop_init(void)
+static struct loop_device *loop_find_dev(unsigned int number)
+{
+	struct loop_device *lo;
+	list_for_each_entry(lo, &loop_devices, lo_list)
+		if (lo->lo_number == number)
+			return lo;
+	return NULL;
+}
+
+static struct loop_device *loop_init_one(unsigned int number)
 {
-	int	i;
+	struct loop_device *lo;
+	struct gendisk *disk;
+
+	lo = kzalloc(sizeof(struct loop_device), GFP_KERNEL);
+	if (lo == NULL)
+		goto out;
+
+	lo->lo_queue = blk_alloc_queue(GFP_KERNEL);
+	if (lo->lo_queue == NULL)
+		goto out_free_dev;
+
+	disk = lo->lo_disk = alloc_disk(1);
+	if (disk == NULL)
+		goto out_free_queue;
+
+	mutex_init(&lo->lo_ctl_mutex);
+	lo->lo_number      = number;
+	lo->lo_thread      = NULL;
+	init_waitqueue_head(&lo->lo_event);
+	spin_lock_init(&lo->lo_lock);
+	disk->major        = LOOP_MAJOR;
+	disk->first_minor  = number;
+	disk->fops         = &lo_fops;
+	disk->private_data = lo;
+	disk->queue        = lo->lo_queue;
+	sprintf(disk->disk_name, "loop%u", number);
+	add_disk(lo->lo_disk);
+
+	spin_lock(&loop_devices_lock);
+	list_add_tail(&lo->lo_list, &loop_devices);
+	spin_unlock(&loop_devices_lock);
+	return lo;
+
+ out_free_queue:
+	blk_cleanup_queue(lo->lo_queue);
+ out_free_dev:
+	kfree(lo);
+ out:
+	return ERR_PTR(-ENOMEM);
+}
+
+static void loop_del_one(struct loop_device *lo)
+{
+	del_gendisk(lo->lo_disk);
+	blk_cleanup_queue(lo->lo_queue);
+	put_disk(lo->lo_disk);
+	list_del(&lo->lo_list);
+	kfree(lo);
+	return;
+}
+
+static struct kobject *loop_probe(dev_t dev, int *part, void *data)
+{
+	unsigned int number = dev & MINORMASK;
+	struct loop_device *lo;
 
-	if (max_loop < 1 || max_loop > 256) {
-		printk(KERN_WARNING "loop: invalid max_loop (must be between"
-				    " 1 and 256), using default (8)\n");
-		max_loop = 8;
+	if ((lo = loop_find_dev(number)) == NULL) {
+		lo = loop_init_one(number);
+		if (IS_ERR(lo))
+			return (void *)lo;
 	}
 
+	return &lo->lo_disk->kobj;
+}
+
+static int __init loop_init(void)
+{
 	if (register_blkdev(LOOP_MAJOR, "loop"))
 		return -EIO;
-
-	loop_dev = kmalloc(max_loop * sizeof(struct loop_device), GFP_KERNEL);
-	if (!loop_dev)
-		goto out_mem1;
-	memset(loop_dev, 0, max_loop * sizeof(struct loop_device));
-
-	disks = kmalloc(max_loop * sizeof(struct gendisk *), GFP_KERNEL);
-	if (!disks)
-		goto out_mem2;
-
-	for (i = 0; i < max_loop; i++) {
-		disks[i] = alloc_disk(1);
-		if (!disks[i])
-			goto out_mem3;
-	}
-
-	for (i = 0; i < max_loop; i++) {
-		struct loop_device *lo = &loop_dev[i];
-		struct gendisk *disk = disks[i];
-
-		memset(lo, 0, sizeof(*lo));
-		lo->lo_queue = blk_alloc_queue(GFP_KERNEL);
-		if (!lo->lo_queue)
-			goto out_mem4;
-		mutex_init(&lo->lo_ctl_mutex);
-		lo->lo_number = i;
-		lo->lo_thread = NULL;
-		init_waitqueue_head(&lo->lo_event);
-		spin_lock_init(&lo->lo_lock);
-		disk->major = LOOP_MAJOR;
-		disk->first_minor = i;
-		disk->fops = &lo_fops;
-		sprintf(disk->disk_name, "loop%d", i);
-		disk->private_data = lo;
-		disk->queue = lo->lo_queue;
-	}
-
-	/* We cannot fail after we call this, so another loop!*/
-	for (i = 0; i < max_loop; i++)
-		add_disk(disks[i]);
-	printk(KERN_INFO "loop: loaded (max %d devices)\n", max_loop);
+	blk_register_region(MKDEV(LOOP_MAJOR, 0), 1UL << MINORBITS,
+	                    THIS_MODULE, loop_probe, NULL, NULL);
 	return 0;
+}
 
-out_mem4:
-	while (i--)
-		blk_cleanup_queue(loop_dev[i].lo_queue);
-	i = max_loop;
-out_mem3:
-	while (i--)
-		put_disk(disks[i]);
-	kfree(disks);
-out_mem2:
-	kfree(loop_dev);
-out_mem1:
-	unregister_blkdev(LOOP_MAJOR, "loop");
-	printk(KERN_ERR "loop: ran out of memory\n");
-	return -ENOMEM;
-}
-
-static void loop_exit(void)
-{
-	int i;
-
-	for (i = 0; i < max_loop; i++) {
-		del_gendisk(disks[i]);
-		blk_cleanup_queue(loop_dev[i].lo_queue);
-		put_disk(disks[i]);
-	}
+static void __exit loop_exit(void)
+{
+	struct loop_device *lo, *next;
+
+	list_for_each_entry_safe(lo, next, &loop_devices, lo_list)
+		loop_del_one(lo);
+
+	blk_unregister_region(MKDEV(LOOP_MAJOR, 0), 1UL << MINORBITS);
 	if (unregister_blkdev(LOOP_MAJOR, "loop"))
 		printk(KERN_WARNING "loop: cannot unregister blkdev\n");
-
-	kfree(disks);
-	kfree(loop_dev);
 }
 
 module_init(loop_init);
 module_exit(loop_exit);
-
-#ifndef MODULE
-static int __init max_loop_setup(char *str)
-{
-	max_loop = simple_strtol(str, NULL, 0);
-	return 1;
-}
-
-__setup("max_loop=", max_loop_setup);
-#endif
Index: linux-2.6.21-rc4/include/linux/loop.h
===================================================================
--- linux-2.6.21-rc4.orig/include/linux/loop.h
+++ linux-2.6.21-rc4/include/linux/loop.h
@@ -16,6 +16,7 @@
 #ifdef __KERNEL__
 #include <linux/bio.h>
 #include <linux/blkdev.h>
+#include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 
@@ -29,7 +30,8 @@ enum {
 struct loop_func_table;
 
 struct loop_device {
-	int		lo_number;
+	struct list_head lo_list;
+	unsigned int	lo_number;
 	int		lo_refcnt;
 	loff_t		lo_offset;
 	loff_t		lo_sizelimit;
@@ -50,6 +52,7 @@ struct loop_device {
 
 	struct file *	lo_backing_file;
 	struct block_device *lo_device;
+	struct gendisk *lo_disk;
 	unsigned	lo_blocksize;
 	void		*key_data; 
 
#<EOF>


Jan
-- 
