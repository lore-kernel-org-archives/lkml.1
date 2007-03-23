Return-Path: <linux-kernel-owner+w=401wt.eu-S1753055AbXCWOT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbXCWOT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 10:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbXCWOT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 10:19:56 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:35714 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055AbXCWOTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 10:19:55 -0400
Date: Fri, 23 Mar 2007 15:19:56 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Tomas M <tomas@slax.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] [bugfix] loop.c
Message-Id: <20070323151956.1ac6a47b.dada1@cosmosbay.com>
In-Reply-To: <4603DE86.1090009@slax.org>
References: <4603DE86.1090009@slax.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007 15:04:54 +0100
Tomas M <tomas@slax.org> wrote:

> I posted this yesterday but it seems people didn't understand the real 
> goal of my patch. So I will explain once more again:
> 
> This is a bugfix for loop.c block driver, as it currently allocates more 
> memory then it needs, without any further use.

Well... changing the Changelog wont help I'm afraid.

I cooked the following patch (untested), feel free to test it.

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 6b5b642..3f4b68c 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -65,6 +65,7 @@ #include <linux/init.h>
 #include <linux/smp_lock.h>
 #include <linux/swap.h>
 #include <linux/slab.h>
+#include <linux/vmalloc.h>
 #include <linux/loop.h>
 #include <linux/compat.h>
 #include <linux/suspend.h>
@@ -78,8 +79,8 @@ #include <linux/kthread.h>
 #include <asm/uaccess.h>
 
 static int max_loop = 8;
-static struct loop_device *loop_dev;
-static struct gendisk **disks;
+static struct loop_device **loop_dev;
+static int loop_dev_vmalloced;
 
 /*
  * Transfer functions
@@ -183,7 +184,7 @@ figure_loop_size(struct loop_device *lo)
 	if (unlikely((loff_t)x != size))
 		return -EFBIG;
 
-	set_capacity(disks[lo->lo_number], x);
+	set_capacity(lo->lo_disk, x);
 	return 0;					
 }
 
@@ -812,7 +813,7 @@ static int loop_set_fd(struct loop_devic
 	lo->lo_queue->queuedata = lo;
 	lo->lo_queue->unplug_fn = loop_unplug;
 
-	set_capacity(disks[lo->lo_number], size);
+	set_capacity(lo->lo_disk, size);
 	bd_set_size(bdev, size << 9);
 
 	set_blocksize(bdev, lo_blocksize);
@@ -832,7 +833,7 @@ out_clr:
 	lo->lo_device = NULL;
 	lo->lo_backing_file = NULL;
 	lo->lo_flags = 0;
-	set_capacity(disks[lo->lo_number], 0);
+	set_capacity(lo->lo_disk, 0);
 	invalidate_bdev(bdev, 0);
 	bd_set_size(bdev, 0);
 	mapping_set_gfp_mask(mapping, lo->old_gfp_mask);
@@ -918,7 +919,7 @@ static int loop_clr_fd(struct loop_devic
 	memset(lo->lo_crypt_name, 0, LO_NAME_SIZE);
 	memset(lo->lo_file_name, 0, LO_NAME_SIZE);
 	invalidate_bdev(bdev, 0);
-	set_capacity(disks[lo->lo_number], 0);
+	set_capacity(lo->lo_disk, 0);
 	bd_set_size(bdev, 0);
 	mapping_set_gfp_mask(filp->f_mapping, gfp);
 	lo->lo_state = Lo_unbound;
@@ -1358,7 +1359,7 @@ #endif
  * And now the modules code and kernel interface.
  */
 module_param(max_loop, int, 0);
-MODULE_PARM_DESC(max_loop, "Maximum number of loop devices (1-256)");
+MODULE_PARM_DESC(max_loop, "Maximum number of loop devices (1-16384)");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(LOOP_MAJOR);
 
@@ -1377,13 +1378,15 @@ int loop_unregister_transfer(int number)
 	unsigned int n = number;
 	struct loop_device *lo;
 	struct loop_func_table *xfer;
+	int i;
 
 	if (n == 0 || n >= MAX_LO_CRYPT || (xfer = xfer_funcs[n]) == NULL)
 		return -EINVAL;
 
 	xfer_funcs[n] = NULL;
 
-	for (lo = &loop_dev[0]; lo < &loop_dev[max_loop]; lo++) {
+	for (i = 0; i < max_loop; i++) {
+		lo = loop_dev[i];
 		mutex_lock(&lo->lo_ctl_mutex);
 
 		if (lo->lo_encryption == xfer)
@@ -1400,70 +1403,74 @@ EXPORT_SYMBOL(loop_unregister_transfer);
 
 static int __init loop_init(void)
 {
-	int	i;
+	struct gendisk *disk;
+	struct loop_device *lo;
+	int	i, nba = 0, nbl = 0;
 
-	if (max_loop < 1 || max_loop > 256) {
-		printk(KERN_WARNING "loop: invalid max_loop (must be between"
-				    " 1 and 256), using default (8)\n");
+	if (max_loop < 1) {
+		printk(KERN_WARNING "loop: invalid max_loop (must be > 1)"
+				    ", using default (8)\n");
 		max_loop = 8;
 	}
 
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
-	for (i = 0; i < max_loop; i++) {
-		disks[i] = alloc_disk(1);
-		if (!disks[i])
-			goto out_mem3;
+	loop_dev = kmalloc(max_loop * sizeof(struct loop_device *), GFP_KERNEL);
+	if (!loop_dev) {
+		loop_dev = vmalloc(max_loop * sizeof(struct loop_device *));
+		if (!loop_dev)
+			goto out_mem;
+		loop_dev_vmalloced = 1;
 	}
 
-	for (i = 0; i < max_loop; i++) {
-		struct loop_device *lo = &loop_dev[i];
-		struct gendisk *disk = disks[i];
+	while (nbl < max_loop) {
+		lo = kzalloc(sizeof(struct loop_device), GFP_KERNEL);
+		if (!lo)
+			goto out_mem;
+		disk = alloc_disk(1);
+		lo->lo_disk = disk;
+		loop_dev[nbl++] = lo;
+		if (!disk)
+			goto out_mem;
+	}
 
-		memset(lo, 0, sizeof(*lo));
+	for (; nba < max_loop; nba++) {
+		lo = loop_dev[nba];
 		lo->lo_queue = blk_alloc_queue(GFP_KERNEL);
 		if (!lo->lo_queue)
-			goto out_mem4;
+			goto out_mem;
+		disk = lo->lo_disk;
 		mutex_init(&lo->lo_ctl_mutex);
-		lo->lo_number = i;
+		lo->lo_number = nba;
 		lo->lo_thread = NULL;
 		init_waitqueue_head(&lo->lo_event);
 		spin_lock_init(&lo->lo_lock);
 		disk->major = LOOP_MAJOR;
-		disk->first_minor = i;
+		disk->first_minor = nba;
 		disk->fops = &lo_fops;
-		sprintf(disk->disk_name, "loop%d", i);
+		sprintf(disk->disk_name, "loop%d", nba);
 		disk->private_data = lo;
 		disk->queue = lo->lo_queue;
 	}
 
 	/* We cannot fail after we call this, so another loop!*/
 	for (i = 0; i < max_loop; i++)
-		add_disk(disks[i]);
+		add_disk(loop_dev[i]->lo_disk);
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
+out_mem:
+	while (nba--)
+		blk_cleanup_queue(loop_dev[nba]->lo_queue);
+	while (nbl--) {
+		put_disk(loop_dev[nbl]->lo_disk);
+		kfree(loop_dev[nbl]);
+		}
+	if (loop_dev_vmalloced)
+		vfree(loop_dev);
+	else
+		kfree(loop_dev);
 	unregister_blkdev(LOOP_MAJOR, "loop");
 	printk(KERN_ERR "loop: ran out of memory\n");
 	return -ENOMEM;
@@ -1472,17 +1479,22 @@ out_mem1:
 static void loop_exit(void)
 {
 	int i;
+	struct loop_device *lo;
 
 	for (i = 0; i < max_loop; i++) {
-		del_gendisk(disks[i]);
-		blk_cleanup_queue(loop_dev[i].lo_queue);
-		put_disk(disks[i]);
+		lo = loop_dev[i];
+		del_gendisk(lo->lo_disk);
+		blk_cleanup_queue(lo->lo_queue);
+		put_disk(lo->lo_disk);
+		kfree(lo);
 	}
 	if (unregister_blkdev(LOOP_MAJOR, "loop"))
 		printk(KERN_WARNING "loop: cannot unregister blkdev\n");
 
-	kfree(disks);
-	kfree(loop_dev);
+	if (loop_dev_vmalloced)
+		vfree(loop_dev);
+	else
+		kfree(loop_dev);
 }
 
 module_init(loop_init);
diff --git a/include/linux/loop.h b/include/linux/loop.h
index 191a595..fef7c5e 100644
--- a/include/linux/loop.h
+++ b/include/linux/loop.h
@@ -29,6 +29,7 @@ enum {
 struct loop_func_table;
 
 struct loop_device {
+	struct gendisk *lo_disk;
 	int		lo_number;
 	int		lo_refcnt;
 	loff_t		lo_offset;
