Return-Path: <linux-kernel-owner+w=401wt.eu-S1755397AbZEJTyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbZEJTyU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 15:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbZEJTyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 15:54:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55407 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbZEJTyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 15:54:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [RFC][PATCH 6/6] PM/Hibernate: Estimate hard core working set size
Date: Sun, 10 May 2009 21:53:35 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@tuxonice.net>,
       David Rientjes <rientjes@google.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <200905070040.08561.rjw@sisk.pl> <200905101548.57557.rjw@sisk.pl> <200905101612.24764.rjw@sisk.pl>
In-Reply-To: <200905101612.24764.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905102153.36461.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 May 2009, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> We want to avoid attempting to free too much memory too hard, so
> estimate the size of the hard core working set and use it as the
> lower limit for preallocating memory.
> 
> Not-yet-signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
> 
> The formula used in this patch appears to return numbers that are too lower.

I was able to improve that a little by taking the reserved saveable pages into
accout and by the adding reclaimable slab, mlocked pages and inactive file
pages to the "hard core working set".  Still, the resulting number is only about
right for x86_64.  On i386 there still is something we're not taking into
account and that's something substantial (20000 pages seem to be "missing"
from the balance sheet).

Updated patch (on top of the corrected [6/6] I've just sent) is appended.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM/Hibernate: Estimate hard core working set size (rev. 2)

We want to avoid attempting to free too much memory too hard, so
estimate the size of the hard core working set and use it as the
lower limit for preallocating memory.

[rev. 2: Take saveable reserved pages into account and add some more
 types of pages to the "hard core working set".]

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/snapshot.c |   64 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

Index: linux-2.6/kernel/power/snapshot.c
===================================================================
--- linux-2.6.orig/kernel/power/snapshot.c
+++ linux-2.6/kernel/power/snapshot.c
@@ -1090,6 +1090,8 @@ void swsusp_free(void)
 /* Helper functions used for the shrinking of memory. */
 
 #define GFP_IMAGE	(GFP_KERNEL | __GFP_NOWARN | __GFP_NO_OOM_KILL)
+/* Typical desktop does not have more than 100MB of mapped pages. */
+#define MAX_MMAP_PAGES	(100 << (20 - PAGE_SHIFT))
 
 /**
  * preallocate_image_pages - Allocate a number of pages for hibernation image
@@ -1211,6 +1213,60 @@ static void free_unnecessary_pages(void)
 }
 
 /**
+ * minimum_image_size - Estimate the minimum acceptable size of an image
+ *
+ * We want to avoid attempting to free too much memory too hard, so estimate the
+ * minimum acceptable size of a hibernation image and use it as the lower limit
+ * for preallocating memory.
+ */
+static unsigned long minimum_image_size(void)
+{
+	struct zone *zone;
+	unsigned long size;
+
+	/*
+	 * Mapped pages are normally few and precious, but their number should
+	 * be bounded for safety.
+	 */
+	size = global_page_state(NR_FILE_MAPPED);
+	size = min_t(unsigned long, size, MAX_MMAP_PAGES);
+
+	/* mlocked pages cannot be swapped out. */
+	size += global_page_state(NR_MLOCK);
+
+	/* Hard (but normally small) memory requests. */
+	size += global_page_state(NR_SLAB_UNRECLAIMABLE);
+	size += global_page_state(NR_SLAB_RECLAIMABLE);
+	size += global_page_state(NR_UNEVICTABLE);
+	size += global_page_state(NR_PAGETABLE);
+
+	/* Saveable pages that are reserved cannot be freed. */
+	for_each_zone(zone) {
+		unsigned long pfn, max_zone_pfn;
+
+		if (is_highmem(zone))
+			continue;
+		mark_free_pages(zone);
+		max_zone_pfn = zone->zone_start_pfn + zone->spanned_pages;
+		for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++)
+			if (saveable_page(zone, pfn)
+			    && PageReserved(pfn_to_page(pfn)))
+				size++;
+	}
+
+	/*
+	 * Disk I/O can be much faster than swap I/O, so optimize for
+	 * performance.
+	 */
+	size += global_page_state(NR_ACTIVE_ANON);
+	size += global_page_state(NR_INACTIVE_ANON);
+	size += global_page_state(NR_ACTIVE_FILE);
+
+	return size;
+}
+
+
+/**
  * hibernate_preallocate_memory - Preallocate memory for hibernation image
  *
  * To create a hibernation image it is necessary to make a copy of every page
@@ -1298,6 +1354,14 @@ int hibernate_preallocate_memory(void)
 	shrink_all_memory(saveable - size);
 
 	/*
+	 * Estimate the size of the hard core working set and use it as the
+	 * minimum image size.
+	 */
+	pages = minimum_image_size();
+	if (size < pages)
+		size = pages;
+
+	/*
 	 * The number of saveable pages in memory was too high, so apply some
 	 * pressure to decrease it.  First, make room for the largest possible
 	 * image and fail if that doesn't work.  Next, try to decrease the size
