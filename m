Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbXCWOlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbXCWOlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 10:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbXCWOlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 10:41:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45495 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbXCWOlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 10:41:09 -0400
Date: Fri, 23 Mar 2007 14:41:09 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Tomas M <tomas@slax.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] [bugfix] loop.c
Message-ID: <20070323144109.GA15114@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Tomas M <tomas@slax.org>, linux-kernel@vger.kernel.org
References: <4603DE86.1090009@slax.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4603DE86.1090009@slax.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 03:04:54PM +0100, Tomas M wrote:
> I posted this yesterday but it seems people didn't understand the real 
> goal of my patch. So I will explain once more again:
> 
> This is a bugfix for loop.c block driver, as it currently allocates more 
> memory then it needs, without any further use.
> 
> If 'max_loop=255' parameter is given, the loop.c driver allocates this 
> amount of memory:
> 
>   kmalloc(max_loop * sizeof(struct loop_device))
> 
> But in this case, (max_loop * sizeof) is greater than 65536, and thus 
> kmalloc must allocate the next bigger size (which is 128KB of RAM).
> 
> Unfortunately the loop.c driver doesn't allow users to use bigger 
> max_loop then 255 (for reasons which are completely obsolete) so the 
> rest of memory is *unused*.
> 
> This patch doesn't fix unused memory in the case of max_loop=255, but 
> rather it allows user to specify bigger max_loop (up to 455 on 386), so 
>  the user can fully use all the memory, which would be allocated anyway.
> 
> Thank you for your consideration

The right thing to start with is to split the allocation up, and allocate
each loop device by itself, like in the untested patch below:

After that you're not wasting memory for any off number of loop devices
and can create as many as you have device numbers available:


Index: linux-2.6/drivers/block/loop.c
===================================================================
--- linux-2.6.orig/drivers/block/loop.c	2007-03-23 15:21:57.000000000 +0100
+++ linux-2.6/drivers/block/loop.c	2007-03-23 15:39:44.000000000 +0100
@@ -78,8 +78,7 @@
 #include <asm/uaccess.h>
 
 static int max_loop = 8;
-static struct loop_device *loop_dev;
-static struct gendisk **disks;
+static LIST_HEAD(loop_devices);
 
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
@@ -1383,7 +1382,7 @@ int loop_unregister_transfer(int number)
 
 	xfer_funcs[n] = NULL;
 
-	for (lo = &loop_dev[0]; lo < &loop_dev[max_loop]; lo++) {
+	list_for_each_entry(lo, &loop_devices, lo_list) {
 		mutex_lock(&lo->lo_ctl_mutex);
 
 		if (lo->lo_encryption == xfer)
@@ -1398,9 +1397,56 @@ int loop_unregister_transfer(int number)
 EXPORT_SYMBOL(loop_register_transfer);
 EXPORT_SYMBOL(loop_unregister_transfer);
 
+static int __init loop_init_one(int i)
+{
+	struct loop_device *lo;
+
+	lo = kzalloc(sizeof(*lo), GFP_KERNEL);
+	if (!lo)
+		goto out;
+
+	lo->lo_queue = blk_alloc_queue(GFP_KERNEL);
+	if (!lo->lo_queue)
+		goto out_free_dev;
+	lo->lo_disk = alloc_disk(1);
+	if (!lo->lo_disk)
+		goto out_free_queue;
+	mutex_init(&lo->lo_ctl_mutex);
+	lo->lo_number = i;
+	lo->lo_thread = NULL;
+	init_waitqueue_head(&lo->lo_event);
+	spin_lock_init(&lo->lo_lock);
+	list_add(&lo->lo_list, &loop_devices);
+	lo->lo_disk->major = LOOP_MAJOR;
+	lo->lo_disk->first_minor = i;
+	lo->lo_disk->fops = &lo_fops;
+	sprintf(lo->lo_disk->disk_name, "loop%d", i);
+	lo->lo_disk->private_data = lo;
+	lo->lo_disk->queue = lo->lo_queue;
+	add_disk(lo->lo_disk);
+	return 0;
+
+ out_free_queue:
+	blk_cleanup_queue(lo->lo_queue);
+ out_free_dev:
+	kfree(lo);
+ out:
+	return -ENOMEM;
+}
+
+static void loop_del_one(struct loop_device *lo)
+{
+	del_gendisk(lo->lo_disk);
+	blk_cleanup_queue(lo->lo_queue);
+	put_disk(lo->lo_disk);
+	list_del(&lo->lo_list);
+	kfree(lo);
+}
+
 static int __init loop_init(void)
 {
-	int	i;
+	struct loop_device *lo, *next;
+	int err, i;
 
 	if (max_loop < 1 || max_loop > 256) {
 		printk(KERN_WARNING "loop: invalid max_loop (must be between"
@@ -1411,78 +1457,32 @@ static int __init loop_init(void)
 	if (register_blkdev(LOOP_MAJOR, "loop"))
 		return -EIO;
 
-	loop_dev = kmalloc(max_loop * sizeof(struct loop_device), GFP_KERNEL);
-	if (!loop_dev)
-		goto out_mem1;
-	memset(loop_dev, 0, max_loop * sizeof(struct loop_device));
-
-	disks = kmalloc(max_loop * sizeof(struct gendisk *), GFP_KERNEL);
-	if (!disks)
-		goto out_mem2;
-
 	for (i = 0; i < max_loop; i++) {
-		disks[i] = alloc_disk(1);
-		if (!disks[i])
-			goto out_mem3;
+		err = loop_init_one(i);
+		if (err)
+			goto out_free_devs;
 	}
 
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
 	printk(KERN_INFO "loop: loaded (max %d devices)\n", max_loop);
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
+ out_free_devs:
+	list_for_each_entry_safe(lo, next, &loop_devices, lo_list)
+		loop_del_one(lo);
 	unregister_blkdev(LOOP_MAJOR, "loop");
 	printk(KERN_ERR "loop: ran out of memory\n");
-	return -ENOMEM;
+	return err;
 }
 
 static void loop_exit(void)
 {
-	int i;
+	struct loop_device *lo, *next;
+
+	list_for_each_entry_safe(lo, next, &loop_devices, lo_list)
+		loop_del_one(lo);
 
-	for (i = 0; i < max_loop; i++) {
-		del_gendisk(disks[i]);
-		blk_cleanup_queue(loop_dev[i].lo_queue);
-		put_disk(disks[i]);
-	}
 	if (unregister_blkdev(LOOP_MAJOR, "loop"))
 		printk(KERN_WARNING "loop: cannot unregister blkdev\n");
-
-	kfree(disks);
-	kfree(loop_dev);
 }
 
 module_init(loop_init);
Index: linux-2.6/include/linux/loop.h
===================================================================
--- linux-2.6.orig/include/linux/loop.h	2007-03-23 15:23:32.000000000 +0100
+++ linux-2.6/include/linux/loop.h	2007-03-23 15:30:40.000000000 +0100
@@ -64,6 +64,8 @@ struct loop_device {
 	wait_queue_head_t	lo_event;
 
 	request_queue_t		*lo_queue;
+	struct gendisk		*lo_disk;
+	struct list_head	lo_list;
 };
 
 #endif /* __KERNEL__ */
