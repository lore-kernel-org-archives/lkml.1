Return-Path: <linux-kernel-owner+w=401wt.eu-S1761180AbXK1Agg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761180AbXK1Agg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 19:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760559AbXK1Ae0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 19:34:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46462 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760454AbXK1AeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 19:34:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 7/7] Hibernation: Update messages
Date: Wed, 28 Nov 2007 01:37:24 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200711280113.36941.rjw@sisk.pl>
In-Reply-To: <200711280113.36941.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711280137.25481.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make hibernation messages start with one common prefix "PM: " and use
the word "hibernation" in messages as a synonym of "suspend to disk".

Turn some KERN_INFO messages into debug ones.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/disk.c     |   28 +++++++++++++++-------------
 kernel/power/snapshot.c |   23 ++++++++++++-----------
 kernel/power/swap.c     |   31 +++++++++++++++++--------------
 kernel/power/swsusp.c   |    5 +++--
 4 files changed, 47 insertions(+), 40 deletions(-)

Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c
+++ linux-2.6/kernel/power/disk.c
@@ -191,8 +191,8 @@ int create_image(int platform_mode)
 	 */
 	error = device_power_down(PMSG_FREEZE);
 	if (error) {
-		printk(KERN_ERR "Some devices failed to power down, "
-			KERN_ERR "aborting suspend\n");
+		printk(KERN_ERR "PM: Some devices failed to power down, "
+			"aborting hibernation\n");
 		goto Enable_irqs;
 	}
 
@@ -203,7 +203,8 @@ int create_image(int platform_mode)
 	save_processor_state();
 	error = swsusp_arch_suspend();
 	if (error)
-		printk(KERN_ERR "Error %d while creating the image\n", error);
+		printk(KERN_ERR "PM: Error %d creating hibernation image\n",
+			error);
 	/* Restore control flow magically appears here */
 	restore_processor_state();
 	if (!in_suspend)
@@ -289,7 +290,7 @@ static int resume_target_kernel(void)
 	local_irq_disable();
 	error = device_power_down(PMSG_PRETHAW);
 	if (error) {
-		printk(KERN_ERR "Some devices failed to power down, "
+		printk(KERN_ERR "PM: Some devices failed to power down, "
 			"aborting resume\n");
 		goto Enable_irqs;
 	}
@@ -438,7 +439,7 @@ static void power_down(void)
 	 * Valid image is on the disk, if we continue we risk serious data
 	 * corruption after resume.
 	 */
-	printk(KERN_CRIT "Please power me down manually\n");
+	printk(KERN_CRIT "PM: Please power down manually\n");
 	while(1);
 }
 
@@ -484,7 +485,7 @@ int hibernate(void)
 	if (error)
 		goto Exit;
 
-	printk("Syncing filesystems ... ");
+	printk(KERN_INFO "PM: Syncing filesystems ... ");
 	sys_sync();
 	printk("done.\n");
 
@@ -560,10 +561,11 @@ static int software_resume(void)
 			return -ENOENT;
 		}
 		swsusp_resume_device = name_to_dev_t(resume_file);
-		pr_debug("swsusp: Resume From Partition %s\n", resume_file);
+		pr_debug("PM: Resume from partition %s\n", resume_file);
 	} else {
-		pr_debug("swsusp: Resume From Partition %d:%d\n",
-			 MAJOR(swsusp_resume_device), MINOR(swsusp_resume_device));
+		pr_debug("PM: Resume from partition %d:%d\n",
+				MAJOR(swsusp_resume_device),
+				MINOR(swsusp_resume_device));
 	}
 
 	if (noresume) {
@@ -575,7 +577,7 @@ static int software_resume(void)
 		return 0;
 	}
 
-	pr_debug("PM: Checking swsusp image.\n");
+	pr_debug("PM: Checking hibernation image.\n");
 	error = swsusp_check();
 	if (error)
 		goto Unlock;
@@ -601,7 +603,7 @@ static int software_resume(void)
 		goto Done;
 	}
 
-	pr_debug("PM: Reading swsusp image.\n");
+	pr_debug("PM: Reading hibernation image.\n");
 
 	error = swsusp_read(&flags);
 	if (!error)
@@ -726,7 +728,7 @@ static ssize_t disk_store(struct kset *k
 		error = -EINVAL;
 
 	if (!error)
-		pr_debug("PM: suspend-to-disk mode set to '%s'\n",
+		pr_debug("PM: Hibernation mode set to '%s'\n",
 			 hibernation_modes[mode]);
 	mutex_unlock(&pm_mutex);
 	return error ? error : n;
@@ -756,7 +758,7 @@ static ssize_t resume_store(struct kset 
 	mutex_lock(&pm_mutex);
 	swsusp_resume_device = res;
 	mutex_unlock(&pm_mutex);
-	printk("Attempting manual resume\n");
+	printk(KERN_INFO "PM: Starting manual resume from disk\n");
 	noresume = 0;
 	software_resume();
 	ret = n;
Index: linux-2.6/kernel/power/snapshot.c
===================================================================
--- linux-2.6.orig/kernel/power/snapshot.c
+++ linux-2.6/kernel/power/snapshot.c
@@ -635,7 +635,7 @@ __register_nosave_region(unsigned long s
 	region->end_pfn = end_pfn;
 	list_add_tail(&region->list, &nosave_regions);
  Report:
-	printk("swsusp: Registered nosave memory region: %016lx - %016lx\n",
+	printk(KERN_INFO "PM: Registered nosave memory: %016lx - %016lx\n",
 		start_pfn << PAGE_SHIFT, end_pfn << PAGE_SHIFT);
 }
 
@@ -704,7 +704,7 @@ static void mark_nosave_pages(struct mem
 	list_for_each_entry(region, &nosave_regions, list) {
 		unsigned long pfn;
 
-		printk("swsusp: Marking nosave pages: %016lx - %016lx\n",
+		pr_debug("PM: Marking nosave pages: %016lx - %016lx\n",
 				region->start_pfn << PAGE_SHIFT,
 				region->end_pfn << PAGE_SHIFT);
 
@@ -749,7 +749,7 @@ int create_basic_memory_bitmaps(void)
 	free_pages_map = bm2;
 	mark_nosave_pages(forbidden_pages_map);
 
-	printk("swsusp: Basic memory bitmaps created\n");
+	pr_debug("PM: Basic memory bitmaps created\n");
 
 	return 0;
 
@@ -784,7 +784,7 @@ void free_basic_memory_bitmaps(void)
 	memory_bm_free(bm2, PG_UNSAFE_CLEAR);
 	kfree(bm2);
 
-	printk("swsusp: Basic memory bitmaps freed\n");
+	pr_debug("PM: Basic memory bitmaps freed\n");
 }
 
 /**
@@ -1088,7 +1088,7 @@ static int enough_free_mem(unsigned int 
 	}
 
 	nr_pages += count_pages_for_highmem(nr_highmem);
-	pr_debug("swsusp: Normal pages needed: %u + %u + %u, available pages: %u\n",
+	pr_debug("PM: Normal pages needed: %u + %u + %u, available pages: %u\n",
 		nr_pages, PAGES_FOR_IO, meta, free);
 
 	return free > nr_pages + PAGES_FOR_IO + meta;
@@ -1201,20 +1201,20 @@ asmlinkage int swsusp_save(void)
 {
 	unsigned int nr_pages, nr_highmem;
 
-	printk("swsusp: critical section: \n");
+	printk(KERN_INFO "PM: Creating hibernation image: \n");
 
 	drain_local_pages();
 	nr_pages = count_data_pages();
 	nr_highmem = count_highmem_pages();
-	printk("swsusp: Need to copy %u pages\n", nr_pages + nr_highmem);
+	printk(KERN_INFO "PM: Need to copy %u pages\n", nr_pages + nr_highmem);
 
 	if (!enough_free_mem(nr_pages, nr_highmem)) {
-		printk(KERN_ERR "swsusp: Not enough free memory\n");
+		printk(KERN_ERR "PM: Not enough free memory\n");
 		return -ENOMEM;
 	}
 
 	if (swsusp_alloc(&orig_bm, &copy_bm, nr_pages, nr_highmem)) {
-		printk(KERN_ERR "swsusp: Memory allocation failed\n");
+		printk(KERN_ERR "PM: Memory allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -1234,7 +1234,8 @@ asmlinkage int swsusp_save(void)
 	nr_copy_pages = nr_pages;
 	nr_meta_pages = DIV_ROUND_UP(nr_pages * sizeof(long), PAGE_SIZE);
 
-	printk("swsusp: critical section: done (%d pages copied)\n", nr_pages);
+	printk(KERN_INFO "PM: Hibernation image created (%d pages copied)\n",
+		nr_pages);
 
 	return 0;
 }
@@ -1433,7 +1434,7 @@ static int check_header(struct swsusp_in
 	if (!reason && info->num_physpages != num_physpages)
 		reason = "memory size";
 	if (reason) {
-		printk(KERN_ERR "swsusp: Resume mismatch: %s\n", reason);
+		printk(KERN_ERR "PM: Image mismatch: %s\n", reason);
 		return -EPERM;
 	}
 	return 0;
Index: linux-2.6/kernel/power/swap.c
===================================================================
--- linux-2.6.orig/kernel/power/swap.c
+++ linux-2.6/kernel/power/swap.c
@@ -71,7 +71,8 @@ static int submit(int rw, pgoff_t page_o
 	bio->bi_end_io = end_swap_bio_read;
 
 	if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
-		printk("swsusp: ERROR: adding page to bio at %ld\n", page_off);
+		printk(KERN_ERR "PM: Adding page to bio failed at %ld\n",
+			page_off);
 		bio_put(bio);
 		return -EFAULT;
 	}
@@ -151,7 +152,7 @@ static int mark_swapfiles(sector_t start
 		error = bio_write_page(swsusp_resume_block,
 					swsusp_header, NULL);
 	} else {
-		printk(KERN_ERR "swsusp: Swap header not found!\n");
+		printk(KERN_ERR "PM: Swap header not found!\n");
 		error = -ENODEV;
 	}
 	return error;
@@ -323,7 +324,8 @@ static int save_image(struct swap_map_ha
 	struct timeval start;
 	struct timeval stop;
 
-	printk("Saving image data pages (%u pages) ...     ", nr_to_write);
+	printk(KERN_INFO "PM: Saving image data pages (%u pages) ...     ",
+		nr_to_write);
 	m = nr_to_write / 100;
 	if (!m)
 		m = 1;
@@ -363,7 +365,7 @@ static int enough_swap(unsigned int nr_p
 {
 	unsigned int free_swap = count_swap_pages(root_swap, 1);
 
-	pr_debug("swsusp: free swap pages: %u\n", free_swap);
+	pr_debug("PM: Free swap pages: %u\n", free_swap);
 	return free_swap > nr_pages + PAGES_FOR_IO;
 }
 
@@ -386,7 +388,7 @@ int swsusp_write(unsigned int flags)
 
 	error = swsusp_swap_check();
 	if (error) {
-		printk(KERN_ERR "swsusp: Cannot find swap device, try "
+		printk(KERN_ERR "PM: Cannot find swap device, try "
 				"swapon -a.\n");
 		return error;
 	}
@@ -400,7 +402,7 @@ int swsusp_write(unsigned int flags)
 	}
 	header = (struct swsusp_info *)data_of(snapshot);
 	if (!enough_swap(header->pages)) {
-		printk(KERN_ERR "swsusp: Not enough free swap\n");
+		printk(KERN_ERR "PM: Not enough free swap\n");
 		error = -ENOSPC;
 		goto out;
 	}
@@ -415,7 +417,7 @@ int swsusp_write(unsigned int flags)
 
 		if (!error) {
 			flush_swap_writer(&handle);
-			printk("S");
+			printk(KERN_INFO "PM: S");
 			error = mark_swapfiles(start, flags);
 			printk("|\n");
 		}
@@ -505,7 +507,8 @@ static int load_image(struct swap_map_ha
 	int err2;
 	unsigned nr_pages;
 
-	printk("Loading image data pages (%u pages) ...     ", nr_to_read);
+	printk(KERN_INFO "PM: Loading image data pages (%u pages) ...     ",
+		nr_to_read);
 	m = nr_to_read / 100;
 	if (!m)
 		m = 1;
@@ -556,7 +559,7 @@ int swsusp_read(unsigned int *flags_p)
 
 	*flags_p = swsusp_header->flags;
 	if (IS_ERR(resume_bdev)) {
-		pr_debug("swsusp: block device not initialised\n");
+		pr_debug("PM: Image device not initialised\n");
 		return PTR_ERR(resume_bdev);
 	}
 
@@ -575,9 +578,9 @@ int swsusp_read(unsigned int *flags_p)
 	blkdev_put(resume_bdev);
 
 	if (!error)
-		pr_debug("swsusp: Reading resume file was successful\n");
+		pr_debug("PM: Image successfully loaded\n");
 	else
-		pr_debug("swsusp: Error %d resuming\n", error);
+		pr_debug("PM: Error %d resuming\n", error);
 	return error;
 }
 
@@ -609,13 +612,13 @@ int swsusp_check(void)
 		if (error)
 			blkdev_put(resume_bdev);
 		else
-			pr_debug("swsusp: Signature found, resuming\n");
+			pr_debug("PM: Signature found, resuming\n");
 	} else {
 		error = PTR_ERR(resume_bdev);
 	}
 
 	if (error)
-		pr_debug("swsusp: Error %d check for resume file\n", error);
+		pr_debug("PM: Error %d checking image file\n", error);
 
 	return error;
 }
@@ -627,7 +630,7 @@ int swsusp_check(void)
 void swsusp_close(void)
 {
 	if (IS_ERR(resume_bdev)) {
-		pr_debug("swsusp: block device not initialised\n");
+		pr_debug("PM: Image device not initialised\n");
 		return;
 	}
 
Index: linux-2.6/kernel/power/swsusp.c
===================================================================
--- linux-2.6.orig/kernel/power/swsusp.c
+++ linux-2.6/kernel/power/swsusp.c
@@ -188,7 +188,8 @@ void swsusp_show_speed(struct timeval *s
 		centisecs = 1;	/* avoid div-by-zero */
 	k = nr_pages * (PAGE_SIZE / 1024);
 	kps = (k * 100) / centisecs;
-	printk("%s %d kbytes in %d.%02d seconds (%d.%02d MB/s)\n", msg, k,
+	printk(KERN_INFO "PM: %s %d kbytes in %d.%02d seconds (%d.%02d MB/s)\n",
+			msg, k,
 			centisecs / 100, centisecs % 100,
 			kps / 1000, (kps % 1000) / 10);
 }
@@ -219,7 +220,7 @@ int swsusp_shrink_memory(void)
 	char *p = "-\\|/";
 	struct timeval start, stop;
 
-	printk("Shrinking memory...  ");
+	printk(KERN_INFO "PM: Shrinking memory...  ");
 	do_gettimeofday(&start);
 	do {
 		long size, highmem_size;
