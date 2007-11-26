Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbXKZXTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbXKZXTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 18:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757516AbXKZXSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 18:18:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40851 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757378AbXKZXSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:18:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 5/6] Hibernation: Use common prefix in messages
Date: Tue, 27 Nov 2007 00:32:07 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200711270025.08128.rjw@sisk.pl>
In-Reply-To: <200711270025.08128.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711270032.07724.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make hibernation messages start with one common prefix "PM: ".

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/disk.c     |   38 ++++++++++++++++++++------------------
 kernel/power/snapshot.c |   24 +++++++++++++-----------
 kernel/power/swap.c     |   43 +++++++++++++++++++++++--------------------
 kernel/power/swsusp.c   |   10 +++++-----
 4 files changed, 61 insertions(+), 54 deletions(-)

Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c
+++ linux-2.6/kernel/power/disk.c
@@ -191,7 +191,7 @@ int create_image(int platform_mode)
 	 */
 	error = device_power_down(PMSG_FREEZE);
 	if (error) {
-		printk(KERN_ERR "Some devices failed to power down, "
+		printk(KERN_ERR PREFIX "Some devices failed to power down, "
 			KERN_ERR "aborting suspend\n");
 		goto Enable_irqs;
 	}
@@ -203,7 +203,8 @@ int create_image(int platform_mode)
 	save_processor_state();
 	error = swsusp_arch_suspend();
 	if (error)
-		printk(KERN_ERR "Error %d while creating the image\n", error);
+		printk(KERN_ERR PREFIX "Error %d while creating the image\n",
+			error);
 	/* Restore control flow magically appears here */
 	restore_processor_state();
 	if (!in_suspend)
@@ -289,7 +290,7 @@ static int resume_target_kernel(void)
 	local_irq_disable();
 	error = device_power_down(PMSG_PRETHAW);
 	if (error) {
-		printk(KERN_ERR "Some devices failed to power down, "
+		printk(KERN_ERR PREFIX "Some devices failed to power down, "
 			KERN_ERR "aborting resume\n");
 		goto Enable_irqs;
 	}
@@ -436,7 +437,7 @@ static void power_down(void)
 	 * Valid image is on the disk, if we continue we risk serious data
 	 * corruption after resume.
 	 */
-	printk(KERN_CRIT "Please power me down manually\n");
+	printk(KERN_CRIT PREFIX "Please power down manually\n");
 	while(1);
 }
 
@@ -482,9 +483,9 @@ int hibernate(void)
 	if (error)
 		goto Exit;
 
-	printk("Syncing filesystems ... ");
+	printk(KERN_INFO PREFIX "Syncing filesystems ... ");
 	sys_sync();
-	printk("done.\n");
+	printk(KERN_INFO "done.\n");
 
 	error = prepare_processes();
 	if (error)
@@ -502,13 +503,13 @@ int hibernate(void)
 
 		if (hibernation_mode == HIBERNATION_PLATFORM)
 			flags |= SF_PLATFORM_MODE;
-		pr_debug("PM: writing image.\n");
+		pr_debug(PREFIX "Writing image.\n");
 		error = swsusp_write(flags);
 		swsusp_free();
 		if (!error)
 			power_down();
 	} else {
-		pr_debug("PM: Image restored successfully.\n");
+		pr_debug(PREFIX "Image restored successfully.\n");
 		swsusp_free();
 	}
  Thaw:
@@ -558,10 +559,11 @@ static int software_resume(void)
 			return -ENOENT;
 		}
 		swsusp_resume_device = name_to_dev_t(resume_file);
-		pr_debug("swsusp: Resume From Partition %s\n", resume_file);
+		pr_debug(PREFIX "Resume from fartition %s\n", resume_file);
 	} else {
-		pr_debug("swsusp: Resume From Partition %d:%d\n",
-			 MAJOR(swsusp_resume_device), MINOR(swsusp_resume_device));
+		pr_debug(PREFIX "Resume from partition %d:%d\n",
+			 MAJOR(swsusp_resume_device),
+			 MINOR(swsusp_resume_device));
 	}
 
 	if (noresume) {
@@ -573,7 +575,7 @@ static int software_resume(void)
 		return 0;
 	}
 
-	pr_debug("PM: Checking swsusp image.\n");
+	pr_debug(PREFIX "Checking hibernation image.\n");
 	error = swsusp_check();
 	if (error)
 		goto Unlock;
@@ -592,20 +594,20 @@ static int software_resume(void)
 	if (error)
 		goto Finish;
 
-	pr_debug("PM: Preparing processes for restore.\n");
+	pr_debug(PREFIX "Preparing processes for restore.\n");
 	error = prepare_processes();
 	if (error) {
 		swsusp_close();
 		goto Done;
 	}
 
-	pr_debug("PM: Reading swsusp image.\n");
+	pr_debug(PREFIX "Reading hibernation image.\n");
 
 	error = swsusp_read(&flags);
 	if (!error)
 		hibernation_restore(flags & SF_PLATFORM_MODE);
 
-	printk(KERN_ERR "PM: Restore failed, recovering.\n");
+	printk(KERN_ERR PREFIX "Restore failed, recovering.\n");
 	swsusp_free();
 	unprepare_processes();
  Done:
@@ -616,7 +618,7 @@ static int software_resume(void)
 	/* For success case, the suspend path will release the lock */
  Unlock:
 	mutex_unlock(&pm_mutex);
-	pr_debug("PM: Resume from disk failed.\n");
+	pr_debug(PREFIX "Resume from disk failed.\n");
 	return error;
 }
 
@@ -724,7 +726,7 @@ static ssize_t disk_store(struct kset *k
 		error = -EINVAL;
 
 	if (!error)
-		pr_debug("PM: suspend-to-disk mode set to '%s'\n",
+		pr_debug(PREFIX "Hibernation mode set to '%s'\n",
 			 hibernation_modes[mode]);
 	mutex_unlock(&pm_mutex);
 	return error ? error : n;
@@ -754,7 +756,7 @@ static ssize_t resume_store(struct kset 
 	mutex_lock(&pm_mutex);
 	swsusp_resume_device = res;
 	mutex_unlock(&pm_mutex);
-	printk("Attempting manual resume\n");
+	printk(KERN_INFO PREFIX "Starting manual resume from disk\n");
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
+	printk(PREFIX "Registered nosave memory region: %016lx - %016lx\n",
 		start_pfn << PAGE_SHIFT, end_pfn << PAGE_SHIFT);
 }
 
@@ -704,7 +704,7 @@ static void mark_nosave_pages(struct mem
 	list_for_each_entry(region, &nosave_regions, list) {
 		unsigned long pfn;
 
-		printk("swsusp: Marking nosave pages: %016lx - %016lx\n",
+		printk(PREFIX "Marking nosave pages: %016lx - %016lx\n",
 				region->start_pfn << PAGE_SHIFT,
 				region->end_pfn << PAGE_SHIFT);
 
@@ -749,7 +749,7 @@ int create_basic_memory_bitmaps(void)
 	free_pages_map = bm2;
 	mark_nosave_pages(forbidden_pages_map);
 
-	printk("swsusp: Basic memory bitmaps created\n");
+	printk(PREFIX "Basic memory bitmaps created\n");
 
 	return 0;
 
@@ -784,7 +784,7 @@ void free_basic_memory_bitmaps(void)
 	memory_bm_free(bm2, PG_UNSAFE_CLEAR);
 	kfree(bm2);
 
-	printk("swsusp: Basic memory bitmaps freed\n");
+	printk(PREFIX "Basic memory bitmaps freed\n");
 }
 
 /**
@@ -1088,7 +1088,8 @@ static int enough_free_mem(unsigned int 
 	}
 
 	nr_pages += count_pages_for_highmem(nr_highmem);
-	pr_debug("swsusp: Normal pages needed: %u + %u + %u, available pages: %u\n",
+	pr_debug(PREFIX "Normal pages needed: %u + %u + %u, "
+		"available pages: %u\n",
 		nr_pages, PAGES_FOR_IO, meta, free);
 
 	return free > nr_pages + PAGES_FOR_IO + meta;
@@ -1201,20 +1202,20 @@ asmlinkage int swsusp_save(void)
 {
 	unsigned int nr_pages, nr_highmem;
 
-	printk("swsusp: critical section: \n");
+	printk(PREFIX "Critical section: \n");
 
 	drain_local_pages();
 	nr_pages = count_data_pages();
 	nr_highmem = count_highmem_pages();
-	printk("swsusp: Need to copy %u pages\n", nr_pages + nr_highmem);
+	printk(PREFIX "Need to copy %u pages\n", nr_pages + nr_highmem);
 
 	if (!enough_free_mem(nr_pages, nr_highmem)) {
-		printk(KERN_ERR "swsusp: Not enough free memory\n");
+		printk(KERN_ERR PREFIX "Not enough free memory\n");
 		return -ENOMEM;
 	}
 
 	if (swsusp_alloc(&orig_bm, &copy_bm, nr_pages, nr_highmem)) {
-		printk(KERN_ERR "swsusp: Memory allocation failed\n");
+		printk(KERN_ERR PREFIX "Memory allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -1234,7 +1235,8 @@ asmlinkage int swsusp_save(void)
 	nr_copy_pages = nr_pages;
 	nr_meta_pages = DIV_ROUND_UP(nr_pages * sizeof(long), PAGE_SIZE);
 
-	printk("swsusp: critical section: done (%d pages copied)\n", nr_pages);
+	printk(KERN_INFO PREFIX "Critical section: done (%d pages copied)\n",
+		nr_pages);
 
 	return 0;
 }
@@ -1433,7 +1435,7 @@ static int check_header(struct swsusp_in
 	if (!reason && info->num_physpages != num_physpages)
 		reason = "memory size";
 	if (reason) {
-		printk(KERN_ERR "swsusp: Resume mismatch: %s\n", reason);
+		printk(KERN_ERR PREFIX "Resume mismatch: %s\n", reason);
 		return -EPERM;
 	}
 	return 0;
Index: linux-2.6/kernel/power/swap.c
===================================================================
--- linux-2.6.orig/kernel/power/swap.c
+++ linux-2.6/kernel/power/swap.c
@@ -73,7 +73,8 @@ static int submit(int rw, pgoff_t page_o
 	bio->bi_end_io = end_swap_bio_read;
 
 	if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
-		printk("swsusp: ERROR: adding page to bio at %ld\n", page_off);
+		printk(KERN_ERR PREFIX "Error adding page to bio at %ld\n",
+			page_off);
 		bio_put(bio);
 		return -EFAULT;
 	}
@@ -153,7 +154,7 @@ static int mark_swapfiles(sector_t start
 		error = bio_write_page(swsusp_resume_block,
 					swsusp_header, NULL);
 	} else {
-		printk(KERN_ERR "swsusp: Swap header not found!\n");
+		printk(KERN_ERR PREFIX "Swap header not found!\n");
 		error = -ENODEV;
 	}
 	return error;
@@ -325,7 +326,8 @@ static int save_image(struct swap_map_ha
 	struct timeval start;
 	struct timeval stop;
 
-	printk("Saving image data pages (%u pages) ...     ", nr_to_write);
+	printk(KERN_INFO PREFIX "Saving image data pages (%u pages) ...     ",
+		nr_to_write);
 	m = nr_to_write / 100;
 	if (!m)
 		m = 1;
@@ -340,7 +342,7 @@ static int save_image(struct swap_map_ha
 			if (error)
 				break;
 			if (!(nr_pages % m))
-				printk("\b\b\b\b%3d%%", nr_pages / m);
+				printk(KERN_INFO "\b\b\b\b%3d%%", nr_pages / m);
 			nr_pages++;
 		}
 	} while (ret > 0);
@@ -349,7 +351,7 @@ static int save_image(struct swap_map_ha
 	if (!error)
 		error = err2;
 	if (!error)
-		printk("\b\b\b\bdone\n");
+		printk(KERN_INFO "\b\b\b\bdone\n");
 	swsusp_show_speed(&start, &stop, nr_to_write, "Wrote");
 	return error;
 }
@@ -365,7 +367,7 @@ static int enough_swap(unsigned int nr_p
 {
 	unsigned int free_swap = count_swap_pages(root_swap, 1);
 
-	pr_debug("swsusp: free swap pages: %u\n", free_swap);
+	pr_debug(PREFIX "Free swap pages: %u\n", free_swap);
 	return free_swap > nr_pages + PAGES_FOR_IO;
 }
 
@@ -388,8 +390,8 @@ int swsusp_write(unsigned int flags)
 
 	error = swsusp_swap_check();
 	if (error) {
-		printk(KERN_ERR "swsusp: Cannot find swap device, try "
-				"swapon -a.\n");
+		printk(KERN_ERR PREFIX "Cannot find swap device, try "
+			KERN_ERR "swapon -a.\n");
 		return error;
 	}
 	memset(&snapshot, 0, sizeof(struct snapshot_handle));
@@ -402,7 +404,7 @@ int swsusp_write(unsigned int flags)
 	}
 	header = (struct swsusp_info *)data_of(snapshot);
 	if (!enough_swap(header->pages)) {
-		printk(KERN_ERR "swsusp: Not enough free swap\n");
+		printk(KERN_ERR PREFIX "Not enough free swap\n");
 		error = -ENOSPC;
 		goto out;
 	}
@@ -417,9 +419,9 @@ int swsusp_write(unsigned int flags)
 
 		if (!error) {
 			flush_swap_writer(&handle);
-			printk("S");
+			printk(KERN_INFO PREFIX "S");
 			error = mark_swapfiles(start, flags);
-			printk("|\n");
+			printk(KERN_INFO "|\n");
 		}
 	}
 	if (error)
@@ -507,7 +509,8 @@ static int load_image(struct swap_map_ha
 	int err2;
 	unsigned nr_pages;
 
-	printk("Loading image data pages (%u pages) ...     ", nr_to_read);
+	printk(KERN_INFO PREFIX "Loading image data pages (%u pages) ...     ",
+		nr_to_read);
 	m = nr_to_read / 100;
 	if (!m)
 		m = 1;
@@ -526,7 +529,7 @@ static int load_image(struct swap_map_ha
 		if (error)
 			break;
 		if (!(nr_pages % m))
-			printk("\b\b\b\b%3d%%", nr_pages / m);
+			printk(KERN_INFO "\b\b\b\b%3d%%", nr_pages / m);
 		nr_pages++;
 	}
 	err2 = wait_on_bio_chain(&bio);
@@ -534,7 +537,7 @@ static int load_image(struct swap_map_ha
 	if (!error)
 		error = err2;
 	if (!error) {
-		printk("\b\b\b\bdone\n");
+		printk(KERN_INFO "\b\b\b\bdone\n");
 		snapshot_write_finalize(snapshot);
 		if (!snapshot_image_loaded(snapshot))
 			error = -ENODATA;
@@ -558,7 +561,7 @@ int swsusp_read(unsigned int *flags_p)
 
 	*flags_p = swsusp_header->flags;
 	if (IS_ERR(resume_bdev)) {
-		pr_debug("swsusp: block device not initialised\n");
+		pr_debug(PREFIX "Block device not initialised\n");
 		return PTR_ERR(resume_bdev);
 	}
 
@@ -577,9 +580,9 @@ int swsusp_read(unsigned int *flags_p)
 	blkdev_put(resume_bdev);
 
 	if (!error)
-		pr_debug("swsusp: Reading resume file was successful\n");
+		pr_debug(PREFIX "Reading resume file was successful\n");
 	else
-		pr_debug("swsusp: Error %d resuming\n", error);
+		pr_debug(PREFIX "Error %d resuming\n", error);
 	return error;
 }
 
@@ -611,13 +614,13 @@ int swsusp_check(void)
 		if (error)
 			blkdev_put(resume_bdev);
 		else
-			pr_debug("swsusp: Signature found, resuming\n");
+			pr_debug(PREFIX "Signature found, resuming\n");
 	} else {
 		error = PTR_ERR(resume_bdev);
 	}
 
 	if (error)
-		pr_debug("swsusp: Error %d check for resume file\n", error);
+		pr_debug(PREFIX "Error %d check for resume file\n", error);
 
 	return error;
 }
@@ -629,7 +632,7 @@ int swsusp_check(void)
 void swsusp_close(void)
 {
 	if (IS_ERR(resume_bdev)) {
-		pr_debug("swsusp: block device not initialised\n");
+		pr_debug(PREFIX "Block device not initialised\n");
 		return;
 	}
 
Index: linux-2.6/kernel/power/swsusp.c
===================================================================
--- linux-2.6.orig/kernel/power/swsusp.c
+++ linux-2.6/kernel/power/swsusp.c
@@ -188,8 +188,8 @@ void swsusp_show_speed(struct timeval *s
 		centisecs = 1;	/* avoid div-by-zero */
 	k = nr_pages * (PAGE_SIZE / 1024);
 	kps = (k * 100) / centisecs;
-	printk("%s %d kbytes in %d.%02d seconds (%d.%02d MB/s)\n", msg, k,
-			centisecs / 100, centisecs % 100,
+	printk(KERN_INFO "%s %d kbytes in %d.%02d seconds (%d.%02d MB/s)\n",
+			msg, k, centisecs / 100, centisecs % 100,
 			kps / 1000, (kps % 1000) / 10);
 }
 
@@ -219,7 +219,7 @@ int swsusp_shrink_memory(void)
 	char *p = "-\\|/";
 	struct timeval start, stop;
 
-	printk("Shrinking memory...  ");
+	printk(KERN_INFO PREFIX "Shrinking memory...  ");
 	do_gettimeofday(&start);
 	do {
 		long size, highmem_size;
@@ -253,10 +253,10 @@ int swsusp_shrink_memory(void)
 			tmp = __shrink_memory(size - (image_size / PAGE_SIZE));
 			pages += tmp;
 		}
-		printk("\b%c", p[i++%4]);
+		printk(KERN_INFO "\b%c", p[i++%4]);
 	} while (tmp > 0);
 	do_gettimeofday(&stop);
-	printk("\bdone (%lu pages freed)\n", pages);
+	printk(KERN_INFO "\bdone (%lu pages freed)\n", pages);
 	swsusp_show_speed(&start, &stop, pages, "Freed");
 
 	return 0;
