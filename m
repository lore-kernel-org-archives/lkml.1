Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbZEGXMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbZEGXMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 19:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbZEGXMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 19:12:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39381 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbZEGXML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 19:12:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Date: Fri, 8 May 2009 01:11:30 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <20090507154502.a7f51dd9.akpm@linux-foundation.org> <alpine.DEB.2.00.0905071554490.10759@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0905071554490.10759@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905080111.31273.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 May 2009, David Rientjes wrote:
> On Thu, 7 May 2009, Andrew Morton wrote:
> 
> > The setting and clearing of that thing looks gruesomely racy..
> > 
> 
> It's not racy currently because zone_scan_lock ensures ZONE_OOM_LOCKED 
> gets test/set and cleared atomically for the entire zonelist (the clear 
> happens for the same zonelist that was test/set).
> 
> Using it for hibernation in the way I've proposed will open it up to the 
> race I earlier described: when a kthread is in the oom killer and 
> subsequently clears its zonelist of ZONE_OOM_LOCKED (all other tasks are 
> frozen so they can't be in the oom killer).  That's perfectly acceptable, 
> however, since the system is by definition already oom if kthreads can't 
> get memory so it will end up killing a user task even though it's stuck in 
> D state and will exit on thaw; we aren't concerned about killing 
> needlessly because the oom killer becomes a no-op when it finds a task 
> that has already been killed but hasn't exited by way of TIF_MEMDIE.

OK there.

So everyone seems to agree we can do something like in the patch below?

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM/Hibernate: Rework shrinking of memory

Rework swsusp_shrink_memory() so that it calls shrink_all_memory()
just once to make some room for the image and then allocates memory
to apply more pressure to the memory management subsystem, if
necessary.

Unfortunately, we don't seem to be able to drop shrink_all_memory()
entirely just yet, because that would lead to huge performance
regressions in some test cases.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/snapshot.c |  151 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 104 insertions(+), 47 deletions(-)

Index: linux-2.6/kernel/power/snapshot.c
===================================================================
--- linux-2.6.orig/kernel/power/snapshot.c
+++ linux-2.6/kernel/power/snapshot.c
@@ -1066,69 +1066,126 @@ void swsusp_free(void)
 	buffer = NULL;
 }
 
+/* Helper functions used for the shrinking of memory. */
+
 /**
- *	swsusp_shrink_memory -  Try to free as much memory as needed
- *
- *	... but do not OOM-kill anyone
+ * preallocate_image_memory - Allocate given number of page frames
+ * @nr_pages: Number of page frames to allocate
  *
- *	Notice: all userland should be stopped before it is called, or
- *	livelock is possible.
+ * Return value: Number of page frames actually allocated
  */
-
-#define SHRINK_BITE	10000
-static inline unsigned long __shrink_memory(long tmp)
+static unsigned long preallocate_image_memory(unsigned long nr_pages)
 {
-	if (tmp > SHRINK_BITE)
-		tmp = SHRINK_BITE;
-	return shrink_all_memory(tmp);
+	unsigned long nr_alloc = 0;
+
+	while (nr_pages > 0) {
+		if (!alloc_image_page(GFP_KERNEL | __GFP_NOWARN))
+			break;
+		nr_pages--;
+		nr_alloc++;
+	}
+
+	return nr_alloc;
 }
 
+/**
+ * swsusp_shrink_memory -  Make the kernel release as much memory as needed
+ *
+ * To create a hibernation image it is necessary to make a copy of every page
+ * frame in use.  We also need a number of page frames to be free during
+ * hibernation for allocations made while saving the image and for device
+ * drivers, in case they need to allocate memory from their hibernation
+ * callbacks (these two numbers are given by PAGES_FOR_IO and SPARE_PAGES,
+ * respectively, both of which are rough estimates).  To make this happen, we
+ * compute the total number of available page frames and allocate at least
+ *
+ * ([page frames total] + PAGES_FOR_IO + [metadata pages]) / 2 + 2 * SPARE_PAGES
+ *
+ * of them, which corresponds to the maximum size of a hibernation image.
+ *
+ * If image_size is set below the number following from the above formula,
+ * the preallocation of memory is continued until the total number of page
+ * frames in use is below the requested image size or it is impossible to
+ * allocate more memory, whichever happens first.
+ */
 int swsusp_shrink_memory(void)
 {
-	long tmp;
 	struct zone *zone;
-	unsigned long pages = 0;
-	unsigned int i = 0;
-	char *p = "-\\|/";
+	unsigned long saveable, size, max_size, count, pages = 0;
 	struct timeval start, stop;
+	int error = 0;
 
-	printk(KERN_INFO "PM: Shrinking memory...  ");
+	printk(KERN_INFO "PM: Shrinking memory ... ");
 	do_gettimeofday(&start);
-	do {
-		long size, highmem_size;
 
-		highmem_size = count_highmem_pages();
-		size = count_data_pages() + PAGES_FOR_IO + SPARE_PAGES;
-		tmp = size;
-		size += highmem_size;
-		for_each_populated_zone(zone) {
-			tmp += snapshot_additional_pages(zone);
-			if (is_highmem(zone)) {
-				highmem_size -=
-					zone_page_state(zone, NR_FREE_PAGES);
-			} else {
-				tmp -= zone_page_state(zone, NR_FREE_PAGES);
-				tmp += zone->lowmem_reserve[ZONE_NORMAL];
-			}
-		}
+	/* Count the number of saveable data pages. */
+	saveable = count_data_pages() + count_highmem_pages();
 
-		if (highmem_size < 0)
-			highmem_size = 0;
+	/*
+	 * Compute the total number of page frames we can use (count) and the
+	 * number of pages needed for image metadata (size).
+	 */
+	count = saveable;
+	size = 0;
+	for_each_populated_zone(zone) {
+		size += snapshot_additional_pages(zone);
+		count += zone_page_state(zone, NR_FREE_PAGES);
+		count -= zone->pages_min;
+	}
 
-		tmp += highmem_size;
-		if (tmp > 0) {
-			tmp = __shrink_memory(tmp);
-			if (!tmp)
-				return -ENOMEM;
-			pages += tmp;
-		} else if (size > image_size / PAGE_SIZE) {
-			tmp = __shrink_memory(size - (image_size / PAGE_SIZE));
-			pages += tmp;
-		}
-		printk("\b%c", p[i++%4]);
-	} while (tmp > 0);
+	/* Compute the maximum number of saveable pages to leave in memory. */
+	max_size = (count - (size + PAGES_FOR_IO)) / 2 - 2 * SPARE_PAGES;
+	size = DIV_ROUND_UP(image_size, PAGE_SIZE);
+	if (size > max_size)
+		size = max_size;
+	/*
+	 * If the maximum is not less than the current number of saveable pages
+	 * in memory, we don't need to do anything more.
+	 */
+	if (size >= saveable)
+		goto out;
+
+	/*
+	 * Let the memory management subsystem know that we're going to need a
+	 * large number of page frames to allocate and make it free some memory.
+	 * NOTE: If this is not done, performance is heavily affected in some
+	 * test cases.
+	 */
+	shrink_all_memory(saveable - size);
+
+	/*
+	 * Prevent the OOM killer from triggering while we're allocating image
+	 * memory.
+	 */
+	for_each_populated_zone(zone)
+		zone_set_flag(zone, ZONE_OOM_LOCKED);
+	/*
+	 * The number of saveable pages in memory was too high, so apply some
+	 * pressure to decrease it.  First, make room for the largest possible
+	 * image and fail if that doesn't work.  Next, try to decrease the size
+	 * of the image as much as indicated by image_size.
+	 */
+	count -= max_size;
+	pages = preallocate_image_memory(count);
+	if (pages < count)
+		error = -ENOMEM;
+	else
+		pages += preallocate_image_memory(max_size - size);
+
+	for_each_populated_zone(zone)
+		zone_clear_flag(zone, ZONE_OOM_LOCKED);
+
+	/* Release all of the preallocated page frames. */
+	swsusp_free();
+
+	if (error) {
+		printk(KERN_CONT "\n");
+		return error;
+	}
+
+ out:
 	do_gettimeofday(&stop);
-	printk("\bdone (%lu pages freed)\n", pages);
+	printk(KERN_CONT "done (preallocated %lu free pages)\n", pages);
 	swsusp_show_speed(&start, &stop, pages, "Freed");
 
 	return 0;
