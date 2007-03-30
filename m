Return-Path: <linux-kernel-owner+w=401wt.eu-S932760AbXC3HxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760AbXC3HxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 03:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933102AbXC3HxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 03:53:23 -0400
Received: from smtp-out.google.com ([216.239.45.13]:47474 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760AbXC3HxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 03:53:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:mime-version:
	content-type:content-transfer-encoding:content-disposition;
	b=c2q2mLCwCl/BAiuOOW1MDTu8fRvYmpuAzmgjYvUdQSd3rsGp7fESfjjlQOe/kehsl
	sdurP5khe3sI5K0DEKmOA==
Message-ID: <b040c32a0703300053u110063b0u80ee0e7b9dd158c2@mail.gmail.com>
Date: Fri, 30 Mar 2007 00:53:14 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: [patch] remove artificial software max_loop limit
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove artificial maximum 256 loop device that can be created due to a
legacy device number limit.  Searching through lkml archive, there are
several instances where users complained about the artificial limit
that the loop driver impose.  There is no reason to have such limit.

This patch rid the limit entirely and make loop device and associated
block queue instantiation on demand.  With on-demand instantiation, it
also gives the benefit of not wasting memory if these devices are not
in use (compare to current implementation that always create 8 loop
devices), a net improvement in both areas.  This version is both
tested with creation of large number of loop devices and is compatible
with existing losetup/mount user land tools.

There are a number of people who worked on this and provided valuable
suggestions, in no particular order, by:

Jens Axboe
Jan Engelhardt
Christoph Hellwig
Thomas M

Signed-off-by: Ken Chen <kenchen@google.com>

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 6b5b642..7db2c38 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -77,9 +77,8 @@ #include <linux/kthread.h>

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
@@ -1322,6 +1321,23 @@ static long lo_compat_ioctl(struct file
 }
 #endif

+static struct loop_device *loop_find_dev(int number)
+{
+	struct loop_device *lo;
+	int found = 0;
+		
+	spin_lock(&loop_devices_lock);
+	list_for_each_entry(lo, &loop_devices, lo_list) {
+		if (lo->lo_number == number) {
+			found = 1;
+			break;
+		}
+	}
+	spin_unlock(&loop_devices_lock);
+	return found ? lo : NULL;
+}
+
+static struct loop_device *loop_init_one(int i);
 static int lo_open(struct inode *inode, struct file *file)
 {
 	struct loop_device *lo = inode->i_bdev->bd_disk->private_data;
@@ -1330,6 +1346,9 @@ static int lo_open(struct inode *inode,
 	lo->lo_refcnt++;
 	mutex_unlock(&lo->lo_ctl_mutex);

+	if (!loop_find_dev(lo->lo_number + 1))
+		loop_init_one(lo->lo_number + 1);
+
 	return 0;
 }

@@ -1357,8 +1376,6 @@ #endif
 /*
  * And now the modules code and kernel interface.
  */
-module_param(max_loop, int, 0);
-MODULE_PARM_DESC(max_loop, "Maximum number of loop devices (1-256)");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(LOOP_MAJOR);

@@ -1383,7 +1400,7 @@ int loop_unregister_transfer(int number)

 	xfer_funcs[n] = NULL;

-	for (lo = &loop_dev[0]; lo < &loop_dev[max_loop]; lo++) {
+	list_for_each_entry(lo, &loop_devices, lo_list) {
 		mutex_lock(&lo->lo_ctl_mutex);

 		if (lo->lo_encryption == xfer)
@@ -1398,102 +1415,104 @@ int loop_unregister_transfer(int number)
 EXPORT_SYMBOL(loop_register_transfer);
 EXPORT_SYMBOL(loop_unregister_transfer);

-static int __init loop_init(void)
+static struct loop_device *loop_init_one(int i)
 {
-	int	i;
+	struct loop_device *lo;
+	struct gendisk *disk;

-	if (max_loop < 1 || max_loop > 256) {
-		printk(KERN_WARNING "loop: invalid max_loop (must be between"
-				    " 1 and 256), using default (8)\n");
-		max_loop = 8;
-	}
+	lo = kzalloc(sizeof(*lo), GFP_KERNEL);
+	if (!lo)
+		goto out;

-	if (register_blkdev(LOOP_MAJOR, "loop"))
-		return -EIO;
+	lo->lo_queue = blk_alloc_queue(GFP_KERNEL);
+	if (!lo->lo_queue)
+		goto out_free_dev;
+
+	disk = lo->lo_disk = alloc_disk(1);
+	if (!disk)
+		goto out_free_queue;
+
+	mutex_init(&lo->lo_ctl_mutex);
+	lo->lo_number		= i;
+	lo->lo_thread		= NULL;
+	init_waitqueue_head(&lo->lo_event);
+	spin_lock_init(&lo->lo_lock);
+	disk->major		= LOOP_MAJOR;
+	disk->first_minor	= i;
+	disk->fops		= &lo_fops;
+	disk->private_data	= lo;
+	disk->queue		= lo->lo_queue;
+	sprintf(disk->disk_name, "loop%d", i);
+	add_disk(disk);
+	spin_lock(&loop_devices_lock);
+	list_add_tail(&lo->lo_list, &loop_devices);
+	spin_unlock(&loop_devices_lock);
+	return lo;
+
+out_free_queue:
+	blk_cleanup_queue(lo->lo_queue);
+out_free_dev:
+	kfree(lo);
+out:
+	return ERR_PTR(-ENOMEM);
+}

-	loop_dev = kmalloc(max_loop * sizeof(struct loop_device), GFP_KERNEL);
-	if (!loop_dev)
-		goto out_mem1;
-	memset(loop_dev, 0, max_loop * sizeof(struct loop_device));
+static void loop_del_one(struct loop_device *lo)
+{
+	del_gendisk(lo->lo_disk);
+	blk_cleanup_queue(lo->lo_queue);
+	put_disk(lo->lo_disk);
+	list_del(&lo->lo_list);
+	kfree(lo);
+}

-	disks = kmalloc(max_loop * sizeof(struct gendisk *), GFP_KERNEL);
-	if (!disks)
-		goto out_mem2;
+static struct kobject *loop_probe(dev_t dev, int *part, void *data)
+{
+	unsigned int number = dev & MINORMASK;
+	struct loop_device *lo;

-	for (i = 0; i < max_loop; i++) {
-		disks[i] = alloc_disk(1);
-		if (!disks[i])
-			goto out_mem3;
+	if ((lo = loop_find_dev(number)) == NULL) {
+		lo = loop_init_one(number);
+		*part = 0;
+		if (IS_ERR(lo))
+			return (void *)lo;
 	}
+	return &lo->lo_disk->kobj;
+}

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
+static int __init loop_init(void)
+{
+	struct loop_device *lo;
+
+	if (register_blkdev(LOOP_MAJOR, "loop"))
+		return -EIO;
+	blk_register_region(MKDEV(LOOP_MAJOR, 0), 1UL << MINORBITS,
+				  THIS_MODULE, loop_probe, NULL, NULL);

-	/* We cannot fail after we call this, so another loop!*/
-	for (i = 0; i < max_loop; i++)
-		add_disk(disks[i]);
-	printk(KERN_INFO "loop: loaded (max %d devices)\n", max_loop);
+	lo = loop_init_one(0);
+	if (IS_ERR(lo))
+		goto out_free;
+
+	printk(KERN_INFO "loop: loaded");
 	return 0;

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
+out_free:
 	unregister_blkdev(LOOP_MAJOR, "loop");
 	printk(KERN_ERR "loop: ran out of memory\n");
 	return -ENOMEM;
 }

-static void loop_exit(void)
+static void __exit loop_exit(void)
 {
-	int i;
+	struct loop_device *lo, *next;

-	for (i = 0; i < max_loop; i++) {
-		del_gendisk(disks[i]);
-		blk_cleanup_queue(loop_dev[i].lo_queue);
-		put_disk(disks[i]);
-	}
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
diff --git a/include/linux/loop.h b/include/linux/loop.h
index 191a595..0b99b31 100644
--- a/include/linux/loop.h
+++ b/include/linux/loop.h
@@ -64,6 +64,8 @@ struct loop_device {
 	wait_queue_head_t	lo_event;

 	request_queue_t		*lo_queue;
+	struct gendisk		*lo_disk;
+	struct list_head	lo_list;
 };

 #endif /* __KERNEL__ */
