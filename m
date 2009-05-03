Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbZECA2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbZECA2W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 20:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbZECA1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 20:27:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60686 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbZECA1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 20:27:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/4] PM/Hibernate: Do not release preallocated memory unnecessarily
Date: Sun, 3 May 2009 02:25:06 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: pavel@ucw.cz, torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <20090502104947.2720f173.akpm@linux-foundation.org> <200905030220.57933.rjw@sisk.pl>
In-Reply-To: <200905030220.57933.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905030225.07366.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Since the hibernation code is now going to use allocations of memory
to create enough room for the image, it can also use the page frames
allocated at this stage as image page frames.  The low-level
hibernation code needs to be rearranged for this purpose, but it
allows us to avoid freeing a great number of pages and allocating
these same pages once again later, so it generally is worth doing.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/disk.c     |   15 +++-
 kernel/power/power.h    |    2 
 kernel/power/snapshot.c |  151 +++++++++++++++++++++++-------------------------
 3 files changed, 87 insertions(+), 81 deletions(-)

Index: linux-2.6/kernel/power/snapshot.c
===================================================================
--- linux-2.6.orig/kernel/power/snapshot.c
+++ linux-2.6/kernel/power/snapshot.c
@@ -783,21 +783,6 @@ void free_basic_memory_bitmaps(void)
 	pr_debug("PM: Basic memory bitmaps freed\n");
 }
 
-/**
- *	snapshot_additional_pages - estimate the number of additional pages
- *	be needed for setting up the suspend image data structures for given
- *	zone (usually the returned value is greater than the exact number)
- */
-
-unsigned int snapshot_additional_pages(struct zone *zone)
-{
-	unsigned int res;
-
-	res = DIV_ROUND_UP(zone->spanned_pages, BM_BITS_PER_BLOCK);
-	res += DIV_ROUND_UP(res * sizeof(struct bm_block), PAGE_SIZE);
-	return 2 * res;
-}
-
 #ifdef CONFIG_HIGHMEM
 /**
  *	count_free_highmem_pages - compute the total number of free highmem
@@ -1033,6 +1018,25 @@ copy_data_pages(struct memory_bitmap *co
 static unsigned int nr_copy_pages;
 /* Number of pages needed for saving the original pfns of the image pages */
 static unsigned int nr_meta_pages;
+/*
+ * Numbers of normal and highmem page frames allocated for hibernation image
+ * before suspending devices.
+ */
+unsigned int alloc_normal, alloc_highmem;
+/*
+ * Memory bitmap used for marking saveable pages (during hibernation) or
+ * hibernation image pages (during restore)
+ */
+static struct memory_bitmap orig_bm;
+/*
+ * Memory bitmap used during hibernation for marking allocated page frames that
+ * will contain copies of saveable pages.  During restore it is initially used
+ * for marking hibernation image pages, but then the set bits from it are
+ * duplicated in @orig_bm and it is released.  On highmem systems it is next
+ * used for marking "safe" highmem pages, but it has to be reinitialized for
+ * this purpose.
+ */
+static struct memory_bitmap copy_bm;
 
 /**
  *	swsusp_free - free pages allocated for the suspend.
@@ -1064,6 +1068,8 @@ void swsusp_free(void)
 	nr_meta_pages = 0;
 	restore_pblist = NULL;
 	buffer = NULL;
+	alloc_normal = 0;
+	alloc_highmem = 0;
 }
 
 /* Helper functions used for the shrinking of memory. */
@@ -1085,7 +1091,7 @@ void swsusp_free(void)
  * Return value: The number of normal (ie. non-highmem) pages allocated or
  * -ENOMEM on failure.
  */
-static long prealloc_pages(long nr_pages)
+static long prealloc_pages(struct memory_bitmap *bm, long nr_pages)
 {
 	long nr_normal = 0;
 
@@ -1095,6 +1101,7 @@ static long prealloc_pages(long nr_pages
 		page = alloc_image_page(GFP_IMAGE);
 		if (!page)
 			return -ENOMEM;
+		memory_bm_set_bit(bm, page_to_pfn(page));
 		if (!PageHighMem(page))
 			nr_normal++;
 	}
@@ -1103,7 +1110,7 @@ static long prealloc_pages(long nr_pages
 }
 
 /**
- * swsusp_shrink_memory -  Make the kernel release as much memory as needed
+ * hibernate_preallocate_memory - Preallocate memory for hibernation image
  *
  * To create a hibernation image it is necessary to make a copy of every page
  * frame in use.  We also need a number of page frames to be free during
@@ -1127,17 +1134,29 @@ static long prealloc_pages(long nr_pages
  * the preallocation of memory is continued until the total number of page
  * frames in use is below the requested image size.
  */
-int swsusp_shrink_memory(void)
+int hibernate_preallocate_memory(void)
 {
-	unsigned long pages = 0, alloc_normal = 0, alloc_highmem = 0;
+	unsigned long pages = 0;
 	unsigned int i = 0;
 	char *p = "-\\|/";
 	struct timeval start, stop;
-	int error = 0;
+	int error;
 
-	printk(KERN_INFO "PM: Shrinking memory...  ");
+	printk(KERN_INFO "PM: Preallocating image memory ...  ");
 	do_gettimeofday(&start);
 
+	error = memory_bm_create(&orig_bm, GFP_IMAGE, PG_ANY);
+	if (error)
+		goto err_out;
+
+	error = memory_bm_create(&copy_bm, GFP_IMAGE, PG_ANY);
+	if (error)
+		goto err_out;
+
+	alloc_normal = 0;
+	alloc_highmem = 0;
+	error = -ENOMEM;
+
 	for (;;) {
 		struct zone *zone;
 		long size, highmem_size, tmp, ret;
@@ -1158,7 +1177,6 @@ int swsusp_shrink_memory(void)
 		 * creation.
 		 */
 		for_each_populated_zone(zone) {
-			tmp += snapshot_additional_pages(zone);
 			if (is_highmem(zone)) {
 				highmem_size -=
 					zone_page_state(zone, NR_FREE_PAGES);
@@ -1179,11 +1197,9 @@ int swsusp_shrink_memory(void)
 		else if (tmp <= 0)
 			break;
 
-		ret = prealloc_pages(tmp);
-		if (ret < 0) {
-			error = -ENOMEM;
-			goto out;
-		}
+		ret = prealloc_pages(&copy_bm, tmp);
+		if (ret < 0)
+			goto err_out;
 		alloc_normal += ret;
 		alloc_highmem += tmp - ret;
 		pages += tmp;
@@ -1192,13 +1208,13 @@ int swsusp_shrink_memory(void)
 	}
 
 	do_gettimeofday(&stop);
-	printk("\bdone (preallocated %lu free pages)\n", pages);
-	swsusp_show_speed(&start, &stop, pages, "Freed");
+	printk("\bdone (allocated %lu image pages)\n", pages);
+	swsusp_show_speed(&start, &stop, pages, "Allocated");
 
- out:
-	/* Release the preallocated page frames. */
-	swsusp_free();
+	return 0;
 
+ err_out:
+	swsusp_free();
 	return error;
 }
 
@@ -1210,7 +1226,7 @@ int swsusp_shrink_memory(void)
 
 static unsigned int count_pages_for_highmem(unsigned int nr_highmem)
 {
-	unsigned int free_highmem = count_free_highmem_pages();
+	unsigned int free_highmem = count_free_highmem_pages() + alloc_highmem;
 
 	if (free_highmem >= nr_highmem)
 		nr_highmem = 0;
@@ -1232,19 +1248,17 @@ count_pages_for_highmem(unsigned int nr_
 static int enough_free_mem(unsigned int nr_pages, unsigned int nr_highmem)
 {
 	struct zone *zone;
-	unsigned int free = 0, meta = 0;
+	unsigned int free = alloc_normal;
 
-	for_each_zone(zone) {
-		meta += snapshot_additional_pages(zone);
+	for_each_zone(zone)
 		if (!is_highmem(zone))
 			free += zone_page_state(zone, NR_FREE_PAGES);
-	}
 
 	nr_pages += count_pages_for_highmem(nr_highmem);
-	pr_debug("PM: Normal pages needed: %u + %u + %u, available pages: %u\n",
-		nr_pages, PAGES_FOR_IO, meta, free);
+	pr_debug("PM: Normal pages needed: %u + %u, available pages: %u\n",
+		nr_pages, PAGES_FOR_IO, free);
 
-	return free > nr_pages + PAGES_FOR_IO + meta;
+	return free > nr_pages + PAGES_FOR_IO;
 }
 
 #ifdef CONFIG_HIGHMEM
@@ -1266,7 +1280,7 @@ static inline int get_highmem_buffer(int
  */
 
 static inline unsigned int
-alloc_highmem_image_pages(struct memory_bitmap *bm, unsigned int nr_highmem)
+alloc_highmem_pages(struct memory_bitmap *bm, unsigned int nr_highmem)
 {
 	unsigned int to_alloc = count_free_highmem_pages();
 
@@ -1277,7 +1291,7 @@ alloc_highmem_image_pages(struct memory_
 	while (to_alloc-- > 0) {
 		struct page *page;
 
-		page = alloc_image_page(__GFP_HIGHMEM);
+		page = alloc_image_page(__GFP_HIGHMEM | __GFP_NO_OOM_KILL);
 		memory_bm_set_bit(bm, page_to_pfn(page));
 	}
 	return nr_highmem;
@@ -1286,7 +1300,7 @@ alloc_highmem_image_pages(struct memory_
 static inline int get_highmem_buffer(int safe_needed) { return 0; }
 
 static inline unsigned int
-alloc_highmem_image_pages(struct memory_bitmap *bm, unsigned int n) { return 0; }
+alloc_highmem_pages(struct memory_bitmap *bm, unsigned int n) { return 0; }
 #endif /* CONFIG_HIGHMEM */
 
 /**
@@ -1305,51 +1319,36 @@ static int
 swsusp_alloc(struct memory_bitmap *orig_bm, struct memory_bitmap *copy_bm,
 		unsigned int nr_pages, unsigned int nr_highmem)
 {
-	int error;
-
-	error = memory_bm_create(orig_bm, GFP_ATOMIC | __GFP_COLD, PG_ANY);
-	if (error)
-		goto Free;
-
-	error = memory_bm_create(copy_bm, GFP_ATOMIC | __GFP_COLD, PG_ANY);
-	if (error)
-		goto Free;
+	int error = 0;
 
 	if (nr_highmem > 0) {
 		error = get_highmem_buffer(PG_ANY);
 		if (error)
-			goto Free;
-
-		nr_pages += alloc_highmem_image_pages(copy_bm, nr_highmem);
+			goto err_out;
+		if (nr_highmem > alloc_highmem) {
+			nr_highmem -= alloc_highmem;
+			nr_pages += alloc_highmem_pages(copy_bm, nr_highmem);
+		}
 	}
-	while (nr_pages-- > 0) {
-		struct page *page = alloc_image_page(GFP_ATOMIC | __GFP_COLD);
-
-		if (!page)
-			goto Free;
+	if (nr_pages > alloc_normal) {
+		nr_pages -= alloc_normal;
+		while (nr_pages-- > 0) {
+			struct page *page;
 
-		memory_bm_set_bit(copy_bm, page_to_pfn(page));
+			page = alloc_image_page(GFP_ATOMIC | __GFP_COLD);
+			if (!page)
+				goto err_out;
+			memory_bm_set_bit(copy_bm, page_to_pfn(page));
+		}
 	}
+
 	return 0;
 
- Free:
+ err_out:
 	swsusp_free();
-	return -ENOMEM;
+	return error;
 }
 
-/* Memory bitmap used for marking saveable pages (during suspend) or the
- * suspend image pages (during resume)
- */
-static struct memory_bitmap orig_bm;
-/* Memory bitmap used on suspend for marking allocated pages that will contain
- * the copies of saveable pages.  During resume it is initially used for
- * marking the suspend image pages, but then its set bits are duplicated in
- * @orig_bm and it is released.  Next, on systems with high memory, it may be
- * used for marking "safe" highmem pages, but it has to be reinitialized for
- * this purpose.
- */
-static struct memory_bitmap copy_bm;
-
 asmlinkage int swsusp_save(void)
 {
 	unsigned int nr_pages, nr_highmem;
Index: linux-2.6/kernel/power/power.h
===================================================================
--- linux-2.6.orig/kernel/power/power.h
+++ linux-2.6/kernel/power/power.h
@@ -74,7 +74,7 @@ extern asmlinkage int swsusp_arch_resume
 
 extern int create_basic_memory_bitmaps(void);
 extern void free_basic_memory_bitmaps(void);
-extern int swsusp_shrink_memory(void);
+extern int hibernate_preallocate_memory(void);
 
 /**
  *	Auxiliary structure used for reading the snapshot image data and
Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c
+++ linux-2.6/kernel/power/disk.c
@@ -303,8 +303,8 @@ int hibernation_snapshot(int platform_mo
 	if (error)
 		return error;
 
-	/* Free memory before shutting down devices. */
-	error = swsusp_shrink_memory();
+	/* Preallocate image memory before shutting down devices. */
+	error = hibernate_preallocate_memory();
 	if (error)
 		goto Close;
 
@@ -320,6 +320,10 @@ int hibernation_snapshot(int platform_mo
 	/* Control returns here after successful restore */
 
  Resume_devices:
+	/* We may need to release the preallocated image pages here. */
+	if (error || !in_suspend)
+		swsusp_free();
+
 	device_resume(in_suspend ?
 		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
 	resume_console();
@@ -593,7 +597,10 @@ int hibernate(void)
 		goto Thaw;
 
 	error = hibernation_snapshot(hibernation_mode == HIBERNATION_PLATFORM);
-	if (in_suspend && !error) {
+	if (error)
+		goto Thaw;
+
+	if (in_suspend) {
 		unsigned int flags = 0;
 
 		if (hibernation_mode == HIBERNATION_PLATFORM)
@@ -605,8 +612,8 @@ int hibernate(void)
 			power_down();
 	} else {
 		pr_debug("PM: Image restored successfully.\n");
-		swsusp_free();
 	}
+
  Thaw:
 	thaw_processes();
  Finish:
