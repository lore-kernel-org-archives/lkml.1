Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401Ab0A0O0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab0A0O0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 09:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378Ab0A0O0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 09:26:38 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:45085 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab0A0O0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 09:26:35 -0500
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] set block size to PAGE_SIZE and some cleanups
Date: Wed, 27 Jan 2010 19:54:06 +0530
Message-Id: <1264602246-12880-4-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1264602246-12880-1-git-send-email-ngupta@vflare.org>
References: <1264602246-12880-1-git-send-email-ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ramzswap block size needs to be set to PAGE_SIZE
to avoid receiving any unaligned block I/O (happens
during swapon time). These unaligned access produce
unncessary I/O errors, scaring users.

Also included some minor cleanups.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/ramzswap/ramzswap_drv.c   |   77 +++++++++++++++++------------
 drivers/staging/ramzswap/ramzswap_drv.h   |    2 +-
 drivers/staging/ramzswap/ramzswap_ioctl.h |    2 +-
 drivers/staging/ramzswap/xvmalloc.c       |    2 +-
 drivers/staging/ramzswap/xvmalloc.h       |    2 +-
 drivers/staging/ramzswap/xvmalloc_int.h   |    2 +-
 6 files changed, 50 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/ramzswap/ramzswap_drv.c b/drivers/staging/ramzswap/ramzswap_drv.c
index 64f49c9..7f47373 100644
--- a/drivers/staging/ramzswap/ramzswap_drv.c
+++ b/drivers/staging/ramzswap/ramzswap_drv.c
@@ -1,7 +1,7 @@
 /*
  * Compressed RAM based swap device
  *
- * Copyright (C) 2008, 2009  Nitin Gupta
+ * Copyright (C) 2008, 2009, 2010  Nitin Gupta
  *
  * This code is released using a dual license strategy: BSD/GPL
  * You can choose the licence that better fits your requirements.
@@ -220,7 +220,7 @@ out:
 	return ret;
 }
 
-void ramzswap_ioctl_get_stats(struct ramzswap *rzs,
+static void ramzswap_ioctl_get_stats(struct ramzswap *rzs,
 			struct ramzswap_ioctl_stats *s)
 {
 	strncpy(s->backing_swap_name, rzs->backing_swap_name,
@@ -502,6 +502,10 @@ static int setup_backing_swap(struct ramzswap *rzs)
 			goto bad_param;
 		}
 		disksize = i_size_read(inode);
+		if (!disksize) {
+			pr_err("Error reading backing swap size.\n");
+			goto bad_param;
+		}
 	} else if (S_ISREG(inode->i_mode)) {
 		bdev = inode->i_sb->s_bdev;
 		if (IS_SWAPFILE(inode)) {
@@ -519,7 +523,6 @@ static int setup_backing_swap(struct ramzswap *rzs)
 	rzs->swap_file = swap_file;
 	rzs->backing_swap = bdev;
 	rzs->disksize = disksize;
-	BUG_ON(!rzs->disksize);
 
 	return 0;
 
@@ -537,7 +540,7 @@ out:
  * Map logical page number 'pagenum' to physical page number
  * on backing swap device. For block device, this is a nop.
  */
-u32 map_backing_swap_page(struct ramzswap *rzs, u32 pagenum)
+static u32 map_backing_swap_page(struct ramzswap *rzs, u32 pagenum)
 {
 	u32 skip_pages, entries_per_page;
 	size_t delta, se_offset, skipped;
@@ -593,6 +596,10 @@ static void ramzswap_free_page(struct ramzswap *rzs, size_t index)
 	u32 offset = rzs->table[index].offset;
 
 	if (unlikely(!page)) {
+		/*
+		 * No memory is allocated for zero filled pages.
+		 * Simply clear zero page flag.
+		 */
 		if (rzs_test_flag(rzs, index, RZS_ZERO)) {
 			rzs_clear_flag(rzs, index, RZS_ZERO);
 			stat_dec(&rzs->stats.pages_zero);
@@ -664,7 +671,6 @@ static int handle_uncompressed_page(struct ramzswap *rzs, struct bio *bio)
 	return 0;
 }
 
-
 /*
  * Called when request page is not present in ramzswap.
  * Its either in backing swap device (if present) or
@@ -782,24 +788,15 @@ static int ramzswap_write(struct ramzswap *rzs, struct bio *bio)
 	page = bio->bi_io_vec[0].bv_page;
 	index = bio->bi_sector >> SECTORS_PER_PAGE_SHIFT;
 
-	src = rzs->compress_buffer;
-
 	/*
 	 * System swaps to same sector again when the stored page
 	 * is no longer referenced by any process. So, its now safe
 	 * to free the memory that was allocated for this page.
 	 */
-	if (rzs->table[index].page)
+	if (rzs->table[index].page || rzs_test_flag(rzs, index, RZS_ZERO))
 		ramzswap_free_page(rzs, index);
 
-	/*
-	 * No memory is allocated for zero filled pages.
-	 * Simply clear zero page flag.
-	 */
-	if (rzs_test_flag(rzs, index, RZS_ZERO)) {
-		stat_dec(&rzs->stats.pages_zero);
-		rzs_clear_flag(rzs, index, RZS_ZERO);
-	}
+	src = rzs->compress_buffer;
 
 	mutex_lock(&rzs->lock);
 
@@ -941,7 +938,6 @@ out:
 	return 0;
 }
 
-
 /*
  * Check if request is within bounds and page aligned.
  */
@@ -1069,6 +1065,7 @@ static void reset_device(struct ramzswap *rzs)
 			bd_release(rzs->backing_swap);
 		filp_close(rzs->swap_file, NULL);
 		rzs->backing_swap = NULL;
+		memset(rzs->backing_swap_name, 0, MAX_SWAP_NAME_LEN);
 	}
 
 	/* Reset stats */
@@ -1300,6 +1297,7 @@ static struct block_device_operations ramzswap_devops = {
 
 static int create_device(struct ramzswap *rzs, int device_id)
 {
+	int ret = 0;
 	mutex_init(&rzs->lock);
 	spin_lock_init(&rzs->stat64_lock);
 	INIT_LIST_HEAD(&rzs->backing_swap_extent_list);
@@ -1308,7 +1306,8 @@ static int create_device(struct ramzswap *rzs, int device_id)
 	if (!rzs->queue) {
 		pr_err("Error allocating disk queue for device %d\n",
 			device_id);
-		return 0;
+		ret = -ENOMEM;
+		goto out;
 	}
 
 	blk_queue_make_request(rzs->queue, ramzswap_make_request);
@@ -1320,7 +1319,8 @@ static int create_device(struct ramzswap *rzs, int device_id)
 		blk_cleanup_queue(rzs->queue);
 		pr_warning("Error allocating disk structure for device %d\n",
 			device_id);
-		return 0;
+		ret = -ENOMEM;
+		goto out;
 	}
 
 	rzs->disk->major = ramzswap_major;
@@ -1335,10 +1335,16 @@ static int create_device(struct ramzswap *rzs, int device_id)
 	 * or set equal to backing swap device (if provided)
 	 */
 	set_capacity(rzs->disk, 0);
+
+	blk_queue_physical_block_size(rzs->disk->queue, PAGE_SIZE);
+	blk_queue_logical_block_size(rzs->disk->queue, PAGE_SIZE);
+
 	add_disk(rzs->disk);
 
 	rzs->init_done = 0;
-	return 1;
+
+out:
+	return ret;
 }
 
 static void destroy_device(struct ramzswap *rzs)
@@ -1354,18 +1360,20 @@ static void destroy_device(struct ramzswap *rzs)
 
 static int __init ramzswap_init(void)
 {
-	int i, ret;
+	int ret, dev_id;
 
 	if (num_devices > max_num_devices) {
 		pr_warning("Invalid value for num_devices: %u\n",
 				num_devices);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	ramzswap_major = register_blkdev(0, "ramzswap");
 	if (ramzswap_major <= 0) {
 		pr_warning("Unable to get major number\n");
-		return -EBUSY;
+		ret = -EBUSY;
+		goto out;
 	}
 
 	if (!num_devices) {
@@ -1376,21 +1384,26 @@ static int __init ramzswap_init(void)
 	/* Allocate the device array and initialize each one */
 	pr_info("Creating %u devices ...\n", num_devices);
 	devices = kzalloc(num_devices * sizeof(struct ramzswap), GFP_KERNEL);
-	if (!devices)
-		goto out;
+	if (!devices) {
+		ret = -ENOMEM;
+		goto unregister;
+	}
 
-	for (i = 0; i < num_devices; i++)
-		if (!create_device(&devices[i], i)) {
-			ret = i;
+	for (dev_id = 0; dev_id < num_devices; dev_id++) {
+		if (create_device(&devices[dev_id], dev_id)) {
+			ret = -ENOMEM;
 			goto free_devices;
 		}
+	}
+
 	return 0;
+
 free_devices:
-	for (i = 0; i < ret; i++)
-		destroy_device(&devices[i]);
-out:
-	ret = -ENOMEM;
+	while (dev_id)
+		destroy_device(&devices[--dev_id]);
+unregister:
 	unregister_blkdev(ramzswap_major, "ramzswap");
+out:
 	return ret;
 }
 
diff --git a/drivers/staging/ramzswap/ramzswap_drv.h b/drivers/staging/ramzswap/ramzswap_drv.h
index 3831d93..e5ffdce 100644
--- a/drivers/staging/ramzswap/ramzswap_drv.h
+++ b/drivers/staging/ramzswap/ramzswap_drv.h
@@ -1,7 +1,7 @@
 /*
  * Compressed RAM based swap device
  *
- * Copyright (C) 2008, 2009  Nitin Gupta
+ * Copyright (C) 2008, 2009, 2010  Nitin Gupta
  *
  * This code is released using a dual license strategy: BSD/GPL
  * You can choose the licence that better fits your requirements.
diff --git a/drivers/staging/ramzswap/ramzswap_ioctl.h b/drivers/staging/ramzswap/ramzswap_ioctl.h
index 1edaeba..d26076d 100644
--- a/drivers/staging/ramzswap/ramzswap_ioctl.h
+++ b/drivers/staging/ramzswap/ramzswap_ioctl.h
@@ -1,7 +1,7 @@
 /*
  * Compressed RAM based swap device
  *
- * Copyright (C) 2008, 2009  Nitin Gupta
+ * Copyright (C) 2008, 2009, 2010  Nitin Gupta
  *
  * This code is released using a dual license strategy: BSD/GPL
  * You can choose the licence that better fits your requirements.
diff --git a/drivers/staging/ramzswap/xvmalloc.c b/drivers/staging/ramzswap/xvmalloc.c
index dabd266..3fdbb8a 100644
--- a/drivers/staging/ramzswap/xvmalloc.c
+++ b/drivers/staging/ramzswap/xvmalloc.c
@@ -1,7 +1,7 @@
 /*
  * xvmalloc memory allocator
  *
- * Copyright (C) 2008, 2009  Nitin Gupta
+ * Copyright (C) 2008, 2009, 2010  Nitin Gupta
  *
  * This code is released using a dual license strategy: BSD/GPL
  * You can choose the licence that better fits your requirements.
diff --git a/drivers/staging/ramzswap/xvmalloc.h b/drivers/staging/ramzswap/xvmalloc.h
index 010c6fe..5b1a81a 100644
--- a/drivers/staging/ramzswap/xvmalloc.h
+++ b/drivers/staging/ramzswap/xvmalloc.h
@@ -1,7 +1,7 @@
 /*
  * xvmalloc memory allocator
  *
- * Copyright (C) 2008, 2009  Nitin Gupta
+ * Copyright (C) 2008, 2009, 2010  Nitin Gupta
  *
  * This code is released using a dual license strategy: BSD/GPL
  * You can choose the licence that better fits your requirements.
diff --git a/drivers/staging/ramzswap/xvmalloc_int.h b/drivers/staging/ramzswap/xvmalloc_int.h
index 263c72d..e23ed5c 100644
--- a/drivers/staging/ramzswap/xvmalloc_int.h
+++ b/drivers/staging/ramzswap/xvmalloc_int.h
@@ -1,7 +1,7 @@
 /*
  * xvmalloc memory allocator
  *
- * Copyright (C) 2008, 2009  Nitin Gupta
+ * Copyright (C) 2008, 2009, 2010  Nitin Gupta
  *
  * This code is released using a dual license strategy: BSD/GPL
  * You can choose the licence that better fits your requirements.
-- 
1.6.2.5

