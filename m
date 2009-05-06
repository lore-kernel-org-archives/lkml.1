Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbZEFWv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbZEFWv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbZEFWuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 18:50:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60872 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbZEFWux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 18:50:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 5/5] PM/Hibernate: Do not release preallocated memory unnecessarily
Date: Thu, 7 May 2009 00:48:27 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@tuxonice.net>
References: <200905070040.08561.rjw@sisk.pl>
In-Reply-To: <200905070040.08561.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905070048.28449.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Since the hibernation code is now going to use allocations of memory
to make enough room for the image, it can also use the page frames
allocated at this stage as image page frames.  The low-level
hibernation code needs to be rearranged for this purpose, but it
allows us to avoid freeing a great number of pages and allocating
these same pages once again later, so it generally is worth doing.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/disk.c     |   15 ++--
 kernel/power/power.h    |    2 
 kernel/power/snapshot.c |  178 +++++++++++++++++++++++++++++++-----------------
 3 files changed, 130 insertions(+), 65 deletions(-)

Index: linux-2.6/kernel/power/snapshot.c
===================================================================
--- linux-2.6.orig/kernel/power/snapshot.c
+++ linux-2.6/kernel/power/snapshot.c
@@ -1033,6 +1033,25 @@ copy_data_pages(struct memory_bitmap *co
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
@@ -1064,10 +1083,14 @@ void swsusp_free(void)
 	nr_meta_pages = 0;
 	restore_pblist = NULL;
 	buffer = NULL;
+	alloc_normal = 0;
+	alloc_highmem = 0;
 }
 
 /* Helper functions used for the shrinking of memory. */
 
+#define GFP_IMAGE	(GFP_KERNEL | __GFP_NOWARN)
+
 /**
  * preallocate_image_memory - Allocate given number of page frames
  * @nr_pages: Number of page frames to allocate
@@ -1081,9 +1104,14 @@ static unsigned long preallocate_image_m
 	while (nr_pages-- > 0) {
 		struct page *page;
 
-		page = alloc_image_page(GFP_KERNEL | __GFP_NOWARN);
+		page = alloc_image_page(GFP_IMAGE);
 		if (!page)
 			break;
+		memory_bm_set_bit(&copy_bm, page_to_pfn(page));
+		if (PageHighMem(page))
+			alloc_highmem++;
+		else
+			alloc_normal++;
 		nr_alloc++;
 	}
 
@@ -1091,7 +1119,30 @@ static unsigned long preallocate_image_m
 }
 
 /**
- * swsusp_shrink_memory -  Make the kernel release as much memory as needed
+ * free_unnecessary_pages - Release preallocated pages not needed for the image
+ * @size: Anticipated hibernation image size
+ */
+static void free_unnecessary_pages(unsigned long size)
+{
+	memory_bm_position_reset(&copy_bm);
+
+	while (alloc_normal + alloc_highmem > size) {
+		unsigned long pfn = memory_bm_next_pfn(&copy_bm);
+		struct page *page = pfn_to_page(pfn);
+
+		memory_bm_clear_bit(&copy_bm, pfn);
+		if (PageHighMem(page))
+			alloc_highmem--;
+		else
+			alloc_normal--;
+		swsusp_unset_page_forbidden(page);
+		swsusp_unset_page_free(page);
+		__free_page(page);
+	}
+}
+
+/**
+ * hibernate_preallocate_memory - Preallocate memory for hibernation image
  *
  * To create a hibernation image it is necessary to make a copy of every page
  * frame in use.  We also need a number of page frames to be free during
@@ -1110,16 +1161,27 @@ static unsigned long preallocate_image_m
  * frames in use is below the requested image size or it is impossible to
  * allocate more memory, whichever happens first.
  */
-int swsusp_shrink_memory(void)
+int hibernate_preallocate_memory(void)
 {
 	struct zone *zone;
 	unsigned long saveable, size, max_size, count, pages = 0;
 	struct timeval start, stop;
-	int error = 0;
+	int error;
 
-	printk(KERN_INFO "PM: Shrinking memory ... ");
+	printk(KERN_INFO "PM: Preallocating image memory ... ");
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
+
 	/* Count the number of saveable data pages. */
 	saveable = count_data_pages() + count_highmem_pages();
 
@@ -1143,10 +1205,12 @@ int swsusp_shrink_memory(void)
 		size = max_size;
 	/*
 	 * If the maximum is not lesser than the current number of saveable
-	 * pages in memory, we don't need to do anything more.
+	 * pages in memory, allocate page frames for the image and we're done.
 	 */
-	if (size >= saveable)
+	if (size >= saveable) {
+		pages = preallocate_image_memory(saveable);
 		goto out;
+	}
 
 	/*
 	 * Let the memory management subsystem know that we're going to need a
@@ -1165,24 +1237,27 @@ int swsusp_shrink_memory(void)
 	count -= max_size;
 	pages = preallocate_image_memory(count);
 	if (pages < count)
-		error = -ENOMEM;
+		goto err_out;
 	else
 		pages += preallocate_image_memory(max_size - size);
 
-	/* Release all of the preallocated page frames. */
-	swsusp_free();
-
-	if (error) {
-		printk(KERN_CONT "\n");
-		return error;
-	}
+	/*
+	 * We only need 'size' page frames for the image but we have allocated
+	 * more.  Release the excessive ones now.
+	 */
+	free_unnecessary_pages(size);
 
  out:
 	do_gettimeofday(&stop);
-	printk(KERN_CONT "done (preallocated %lu free pages)\n", pages);
-	swsusp_show_speed(&start, &stop, pages, "Freed");
+	printk(KERN_CONT "done (allocated %lu pages)\n", pages);
+	swsusp_show_speed(&start, &stop, pages, "Allocated");
 
 	return 0;
+
+ err_out:
+	printk(KERN_CONT "\n");
+	swsusp_free();
+	return -ENOMEM;
 }
 
 #ifdef CONFIG_HIGHMEM
@@ -1193,7 +1268,7 @@ int swsusp_shrink_memory(void)
 
 static unsigned int count_pages_for_highmem(unsigned int nr_highmem)
 {
-	unsigned int free_highmem = count_free_highmem_pages();
+	unsigned int free_highmem = count_free_highmem_pages() + alloc_highmem;
 
 	if (free_highmem >= nr_highmem)
 		nr_highmem = 0;
@@ -1215,19 +1290,17 @@ count_pages_for_highmem(unsigned int nr_
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
@@ -1249,7 +1322,7 @@ static inline int get_highmem_buffer(int
  */
 
 static inline unsigned int
-alloc_highmem_image_pages(struct memory_bitmap *bm, unsigned int nr_highmem)
+alloc_highmem_pages(struct memory_bitmap *bm, unsigned int nr_highmem)
 {
 	unsigned int to_alloc = count_free_highmem_pages();
 
@@ -1269,7 +1342,7 @@ alloc_highmem_image_pages(struct memory_
 static inline int get_highmem_buffer(int safe_needed) { return 0; }
 
 static inline unsigned int
-alloc_highmem_image_pages(struct memory_bitmap *bm, unsigned int n) { return 0; }
+alloc_highmem_pages(struct memory_bitmap *bm, unsigned int n) { return 0; }
 #endif /* CONFIG_HIGHMEM */
 
 /**
@@ -1288,51 +1361,36 @@ static int
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
