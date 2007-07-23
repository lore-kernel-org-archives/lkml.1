Return-Path: <linux-kernel-owner+w=401wt.eu-S1761478AbXGWNSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761478AbXGWNSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 09:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbXGWNSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 09:18:08 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:57675 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760AbXGWNSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 09:18:05 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] [PATCH 1/5] Dynamically allocated pageflags - core code.
Date: Mon, 23 Jul 2007 23:16:22 +1000
User-Agent: KMail/1.9.6
References: <200707232234.58116.nigel@nigel.suspend2.net>
In-Reply-To: <200707232234.58116.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Message-Id: <200707232316.23058.nigel@nigel.suspend2.net>
Content-Disposition: inline
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the core of the support for dynamically allocated pageflags.

Signed-off-by: Nigel Cunningham <nigel@nigel.suspend2.net>

 include/linux/dyn_pageflags.h |   65 +++
 init/main.c                   |    3 
 mm/Makefile                   |    2 
 mm/dyn_pageflags.c            |  774 ++++++++++++++++++++++++++++++++++++++++++
 mm/memory_hotplug.c           |    2 
 5 files changed, 845 insertions(+), 1 deletion(-)
diff -ruNp 840-dyn-pageflags.patch-old/include/linux/dyn_pageflags.h 840-dyn-pageflags.patch-new/include/linux/dyn_pageflags.h
--- 840-dyn-pageflags.patch-old/include/linux/dyn_pageflags.h	1970-01-01 10:00:00.000000000 +1000
+++ 840-dyn-pageflags.patch-new/include/linux/dyn_pageflags.h	2007-07-23 19:48:40.000000000 +1000
@@ -0,0 +1,65 @@
+/*
+ * include/linux/dyn_pageflags.h
+ *
+ * Copyright (C) 2004-2007 Nigel Cunningham <nigel@suspend2.net>
+ *
+ * This file is released under the GPLv2.
+ *
+ * It implements support for dynamically allocated bitmaps that are
+ * used for temporary or infrequently used pageflags, in lieu of
+ * bits in the struct page flags entry.
+ */
+
+#ifndef DYN_PAGEFLAGS_H
+#define DYN_PAGEFLAGS_H
+
+#include <linux/mm.h>
+
+struct dyn_pageflags {
+	unsigned long ****bitmap; /* [pg_dat][zone][page_num] */
+	int sparse, initialised;
+	struct list_head list;
+	spinlock_t struct_lock;
+};
+
+#define DYN_PAGEFLAGS_INIT(name) { \
+	.list = LIST_HEAD_INIT(name.list), \
+	.struct_lock = __SPIN_LOCK_UNLOCKED(name.lock) \
+}
+
+#define DECLARE_DYN_PAGEFLAGS(name) \
+	struct dyn_pageflags name = DYN_PAGEFLAGS_INIT(name);
+
+#define BITMAP_FOR_EACH_SET(bitmap, counter) \
+	for (counter = get_next_bit_on(bitmap, max_pfn + 1); counter <= max_pfn; \
+		counter = get_next_bit_on(bitmap, counter))
+
+extern void clear_dyn_pageflags(struct dyn_pageflags *pagemap);
+extern int allocate_dyn_pageflags(struct dyn_pageflags *pagemap, int sparse);
+extern void free_dyn_pageflags(struct dyn_pageflags *pagemap);
+extern unsigned long get_next_bit_on(struct dyn_pageflags *bitmap, unsigned long counter);
+
+extern int test_dynpageflag(struct dyn_pageflags *bitmap, struct page *page);
+/*
+ * In sparse bitmaps, setting a flag can fail (we can fail to allocate
+ * the page to store the bit. If this happens, we will BUG(). If you don't
+ * want this behaviour, don't allocate sparse pageflags.
+ */
+extern void set_dynpageflag(struct dyn_pageflags *bitmap, struct page *page);
+extern void clear_dynpageflag(struct dyn_pageflags *bitmap, struct page *page);
+extern void dump_pagemap(struct dyn_pageflags *pagemap);
+
+/* 
+ * With the above macros defined, you can do...
+ * #define PagePageset1(page) (test_dynpageflag(&pageset1_map, page))
+ * #define SetPagePageset1(page) (set_dynpageflag(&pageset1_map, page))
+ * #define ClearPagePageset1(page) (clear_dynpageflag(&pageset1_map, page))
+ */
+
+extern void __init dyn_pageflags_init(void);
+extern void __init dyn_pageflags_use_kzalloc(void);
+
+#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
+extern void dyn_pageflags_hotplug(struct zone *zone);
+#endif
+#endif
diff -ruNp 840-dyn-pageflags.patch-old/init/main.c 840-dyn-pageflags.patch-new/init/main.c
--- 840-dyn-pageflags.patch-old/init/main.c	2007-07-23 22:11:27.000000000 +1000
+++ 840-dyn-pageflags.patch-new/init/main.c	2007-07-23 19:48:40.000000000 +1000
@@ -55,6 +55,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/device.h>
 #include <linux/kthread.h>
+#include <linux/dyn_pageflags.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -585,6 +586,7 @@ asmlinkage void __init start_kernel(void
 	softirq_init();
 	timekeeping_init();
 	time_init();
+	dyn_pageflags_init();
 	profile_init();
 	if (!irqs_disabled())
 		printk("start_kernel(): bug: interrupts were enabled early\n");
@@ -621,6 +623,7 @@ asmlinkage void __init start_kernel(void
 	cpuset_init_early();
 	mem_init();
 	kmem_cache_init();
+	dyn_pageflags_use_kzalloc();
 	setup_per_cpu_pageset();
 	numa_policy_init();
 	if (late_time_init)
diff -ruNp 840-dyn-pageflags.patch-old/mm/Makefile 840-dyn-pageflags.patch-new/mm/Makefile
--- 840-dyn-pageflags.patch-old/mm/Makefile	2007-07-11 22:19:42.000000000 +1000
+++ 840-dyn-pageflags.patch-new/mm/Makefile	2007-07-23 19:48:40.000000000 +1000
@@ -11,7 +11,7 @@ obj-y			:= bootmem.o filemap.o mempool.o
 			   page_alloc.o page-writeback.o pdflush.o \
 			   readahead.o swap.o truncate.o vmscan.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
-			   $(mmu-y)
+			   dyn_pageflags.o $(mmu-y)
 
 ifeq ($(CONFIG_MMU)$(CONFIG_BLOCK),yy)
 obj-y			+= bounce.o
diff -ruNp 840-dyn-pageflags.patch-old/mm/dyn_pageflags.c 840-dyn-pageflags.patch-new/mm/dyn_pageflags.c
--- 840-dyn-pageflags.patch-old/mm/dyn_pageflags.c	1970-01-01 10:00:00.000000000 +1000
+++ 840-dyn-pageflags.patch-new/mm/dyn_pageflags.c	2007-07-23 22:11:30.000000000 +1000
@@ -0,0 +1,774 @@
+/*
+ * lib/dyn_pageflags.c
+ *
+ * Copyright (C) 2004-2007 Nigel Cunningham <nigel@suspend2.net>
+ * 
+ * This file is released under the GPLv2.
+ *
+ * Routines for dynamically allocating and releasing bitmaps
+ * used as pseudo-pageflags.
+ *
+ * We use bitmaps, built out of order zero allocations and
+ * linked together by kzalloc'd arrays of pointers into
+ * an array that looks like...
+ *
+ * 	pageflags->bitmap[node][zone_id][page_num][ul]
+ *
+ * All of this is transparent to the caller, who just uses
+ * the allocate & free routines to create/destroy bitmaps,
+ * and get/set/clear to operate on individual flags.
+ *
+ * Bitmaps can be sparse, with the individual pages only being
+ * allocated when a bit is set in the page.
+ *
+ * Memory hotplugging support is work in progress. A zone's
+ * start_pfn may change. If it does, we need to reallocate
+ * the zone bitmap, adding additional pages to the front to
+ * cover the bitmap. For simplicity, we don't shift the
+ * contents of existing pages around. The lock is only used
+ * to avoid reentrancy when resizing zones. The replacement
+ * of old data with new is done atomically. If we try to test
+ * a bit in the new area before the update is completed, we
+ * know it's zero.
+ *
+ * TuxOnIce knows the structure of these pageflags, so that
+ * it can serialise them in the image header. TODO: Make
+ * that support more generic so that TuxOnIce doesn't need
+ * to know how dyn_pageflags are stored.
+ */
+
+/* Avoid warnings in include/linux/mm.h */
+struct page;
+struct dyn_pageflags;
+int test_dynpageflag(struct dyn_pageflags *bitmap, struct page *page);
+
+#include <linux/bootmem.h>
+#include <linux/dyn_pageflags.h>
+
+static LIST_HEAD(flags_list);
+static DEFINE_SPINLOCK(flags_list_lock);
+
+static void* (*dyn_allocator)(unsigned long size, unsigned long flags);
+
+static int dyn_pageflags_debug = 0;
+
+#define PR_DEBUG(a, b...) \
+	do { if (dyn_pageflags_debug) printk(a, ##b); } while(0)
+#define DUMP_DEBUG(bitmap) \
+	do { if (dyn_pageflags_debug) dump_pagemap(bitmap); } while(0)
+
+#if BITS_PER_LONG == 32
+#define UL_SHIFT 5
+#else 
+#if BITS_PER_LONG == 64
+#define UL_SHIFT 6
+#else
+#error Bits per long not 32 or 64?
+#endif
+#endif
+
+#define BIT_NUM_MASK ((sizeof(unsigned long) << 3) - 1)
+#define PAGE_NUM_MASK (~((1 << (PAGE_SHIFT + 3)) - 1))
+#define UL_NUM_MASK (~(BIT_NUM_MASK | PAGE_NUM_MASK))
+
+/*
+ * PAGENUMBER gives the index of the page within the zone.
+ * PAGEINDEX gives the index of the unsigned long within that page.
+ * PAGEBIT gives the index of the bit within the unsigned long.
+ */
+#define PAGENUMBER(zone_offset) ((int) (zone_offset >> (PAGE_SHIFT + 3)))
+#define PAGEINDEX(zone_offset) ((int) ((zone_offset & UL_NUM_MASK) >> UL_SHIFT))
+#define PAGEBIT(zone_offset) ((int) (zone_offset & BIT_NUM_MASK))
+
+#define PAGE_UL_PTR(bitmap, node, zone_num, zone_pfn) \
+       ((bitmap[node][zone_num][PAGENUMBER(zone_pfn)])+PAGEINDEX(zone_pfn))
+
+#define pages_for_zone(zone) \
+	(DIV_ROUND_UP((zone)->spanned_pages, (PAGE_SIZE << 3)))
+
+#define pages_for_span(span) \
+	(DIV_ROUND_UP(span, PAGE_SIZE << 3))
+
+/* __maybe_unused for testing functions below */
+#define GET_BIT_AND_UL(pageflags, page) \
+	struct zone *zone = page_zone(page); \
+	unsigned long pfn = page_to_pfn(page); \
+	unsigned long zone_pfn = pfn - zone->zone_start_pfn; \
+	int node = page_to_nid(page); \
+	int zone_num = zone_idx(zone); \
+	int pagenum = PAGENUMBER(zone_pfn) + 2; \
+	int page_offset = PAGEINDEX(zone_pfn); \
+	unsigned long **zone_array = ((pageflags)->bitmap && \
+		(pageflags)->bitmap[node] && \
+		(pageflags)->bitmap[node][zone_num]) ? \
+			(pageflags)->bitmap[node][zone_num] : NULL; \
+	unsigned long __maybe_unused *ul = (zone_array && \
+		(unsigned long) zone_array[0] <= pfn && \
+		(unsigned long) zone_array[1] >= (pagenum-2) && \
+		zone_array[pagenum]) ? zone_array[pagenum] + page_offset : \
+		  NULL; \
+	int bit __maybe_unused = PAGEBIT(zone_pfn);
+
+#define for_each_online_pgdat_zone(pgdat, zone_nr) \
+	for_each_online_pgdat(pgdat) \
+		for (zone_nr = 0; zone_nr < MAX_NR_ZONES; zone_nr++)
+
+/**
+ * dump_pagemap: Display the contents of a bitmap for debugging purposes.
+ *
+ * @pagemap: The array to be dumped.
+ */
+void dump_pagemap(struct dyn_pageflags *pagemap)
+{
+	int i=0;
+	struct pglist_data *pgdat;
+	unsigned long **** bitmap = pagemap->bitmap;
+
+	printk(" --- Dump bitmap %p ---\n", pagemap);
+
+	printk("%p: Sparse flag = %d\n", &pagemap->sparse, pagemap->sparse);
+	printk("%p: Bitmap      = %p\n", &pagemap->bitmap, bitmap);
+
+	if (!bitmap)
+		goto out;
+
+	for_each_online_pgdat(pgdat) {
+		int node_id = pgdat->node_id, zone_nr;
+		printk("%p: Node %d => %p\n", &bitmap[node_id], node_id,
+				bitmap[node_id]);
+		if (!bitmap[node_id])
+			continue;
+		for (zone_nr = 0; zone_nr < MAX_NR_ZONES; zone_nr++) {
+			printk("%p:   Zone %d => %p%s\n",
+					&bitmap[node_id][zone_nr], zone_nr,
+					bitmap[node_id][zone_nr],
+					bitmap[node_id][zone_nr] ? "" :
+						" (empty)");
+			if (!bitmap[node_id][zone_nr])
+				continue;
+
+			printk("%p:     Zone start pfn  = %p\n",
+					&bitmap[node_id][zone_nr][0],
+					bitmap[node_id][zone_nr][0]);
+			printk("%p:     Number of pages = %p\n",
+					&bitmap[node_id][zone_nr][1],
+					bitmap[node_id][zone_nr][1]);
+			for (i = 2; i < (unsigned long) bitmap[node_id][zone_nr][1] + 2; i++)
+				printk("%p:     Page %2d         = %p\n",
+					&bitmap[node_id][zone_nr][i],
+					i - 2,
+					bitmap[node_id][zone_nr][i]);
+		}
+	}
+out:
+	printk(" --- Dump of bitmap %p finishes\n", pagemap);
+}
+
+/**
+ * clear_dyn_pageflags: Zero all pageflags in a bitmap.
+ *
+ * @pagemap: The array to be cleared.
+ *
+ * Clear an array used to store dynamically allocated pageflags.
+ */
+void clear_dyn_pageflags(struct dyn_pageflags *pagemap)
+{
+	int i=0, zone_idx;
+	struct pglist_data *pgdat;
+	unsigned long **** bitmap = pagemap->bitmap;
+
+	for_each_online_pgdat_zone(pgdat, zone_idx) {
+		int node_id = pgdat->node_id;
+		struct zone *zone = &pgdat->node_zones[zone_idx];
+
+		if (!populated_zone(zone) ||
+		   (!bitmap[node_id] || !bitmap[node_id][zone_idx]))
+			continue;
+
+		for (i = 2; i < pages_for_zone(zone) + 2; i++)
+			if (bitmap[node_id][zone_idx][i])
+				memset((bitmap[node_id][zone_idx][i]), 0,
+						PAGE_SIZE);
+	}
+}
+
+/**
+ * Allocators.
+ *
+ * During boot time, we want to use alloc_bootmem_low. Afterwards, we want
+ * kzalloc. These routines let us do that without causing compile time warnings
+ * about mismatched sections, as would happen if we did a simple
+ * boot ? alloc_bootmem_low() : kzalloc() below.
+ */
+
+/**
+ * boot_time_allocator: Allocator used while booting.
+ *
+ * @size: Number of bytes wanted.
+ * @flags: Allocation flags (ignored here).
+ */
+static __init void *boot_time_allocator(unsigned long size, unsigned long flags)
+{
+	return alloc_bootmem_low(size);
+}
+
+/**
+ * normal_allocator: Allocator used post-boot.
+ *
+ * @size: Number of bytes wanted.
+ * @flags: Allocation flags.
+ *
+ * Allocate memory for our page flags.
+ */
+static void *normal_allocator(unsigned long size, unsigned long flags)
+{
+	if (size == PAGE_SIZE)
+		return (void *) get_zeroed_page(flags);
+	else
+		return kzalloc(size, flags);
+}
+
+/**
+ * dyn_pageflags_init: Do the earliest initialisation.
+ *
+ * Very early in the boot process, set our allocator (alloc_bootmem_low) and
+ * allocate bitmaps for slab and buddy pageflags.
+ */
+void __init dyn_pageflags_init(void)
+{
+	dyn_allocator = boot_time_allocator;
+}
+
+/**
+ * dyn_pageflags_use_kzalloc: Reset the allocator for normal use.
+ *
+ * Reset the allocator to our normal, post boot function.
+ */
+void __init dyn_pageflags_use_kzalloc(void)
+{
+	dyn_allocator = (void *) normal_allocator;
+}
+
+/**
+ * try_alloc_dyn_pageflag_part: Try to allocate a pointer array.
+ *
+ * Try to allocate a contiguous array of pointers.
+ */
+static int try_alloc_dyn_pageflag_part(int nr_ptrs, void **ptr)
+{
+	*ptr = (*dyn_allocator)(sizeof(void *) * nr_ptrs, GFP_ATOMIC);
+
+	if (*ptr)
+		return 0;
+
+	printk("Error. Unable to allocate memory for dynamic pageflags.");
+	return -ENOMEM;
+}
+
+static int populate_bitmap_page(struct dyn_pageflags *pageflags,
+			unsigned long **page_ptr)
+{
+	void *address;
+	unsigned long flags = 0;
+
+	if (pageflags)
+		spin_lock_irqsave(&pageflags->struct_lock, flags);
+
+	/*
+	 * The page may have been allocated while we waited.
+	 */
+	if (*page_ptr)
+		goto out;
+
+	address = (*dyn_allocator)(PAGE_SIZE, GFP_ATOMIC);
+
+	if (!address) {
+		PR_DEBUG("Error. Unable to allocate memory for "
+			"dynamic pageflags page.");
+		if (pageflags)
+			spin_unlock_irqrestore(&pageflags->struct_lock, flags);
+		return -ENOMEM;
+	}
+
+	*page_ptr = address;
+out:
+	if (pageflags)
+		spin_unlock_irqrestore(&pageflags->struct_lock, flags);
+	return 0;
+}
+
+/**
+ * resize_zone_bitmap: Resize the array of pages for a bitmap.
+ *
+ * Shrink or extend a list of pages for a zone in a bitmap, preserving
+ * existing data.
+ */
+static int resize_zone_bitmap(struct dyn_pageflags *pagemap, struct zone *zone,
+		unsigned long old_pages, unsigned long new_pages,
+		unsigned long copy_offset)
+{
+	unsigned long **new_ptr = NULL, ****bitmap = pagemap->bitmap;
+	int node_id = zone_to_nid(zone), zone_idx = zone_idx(zone),
+	    to_copy = min(old_pages, new_pages);
+	unsigned long **old_ptr = bitmap[node_id][zone_idx], i;
+
+	if (new_pages) {
+		if (try_alloc_dyn_pageflag_part(new_pages + 2,
+					(void **) &new_ptr))
+			return -ENOMEM;
+
+		if (old_pages)
+			memcpy(new_ptr + 2 + copy_offset, old_ptr + 2,
+					sizeof(unsigned long) * to_copy);
+
+		new_ptr[0] = (void *) zone->zone_start_pfn;
+		new_ptr[1] = (void *) new_pages;
+	}
+
+	/* Free/alloc bitmap pages. */
+	if (old_pages > new_pages) {
+		for (i = new_pages + 2; i < old_pages + 2; i++)
+			if (old_ptr[i])
+				free_page((unsigned long) old_ptr[i]);
+	} else if (!pagemap->sparse) {
+		for (i = old_pages + 2; i < new_pages + 2; i++)
+			if (populate_bitmap_page(NULL,
+					(unsigned long **) &new_ptr[i]))
+				break;
+	}
+
+	bitmap[node_id][zone_idx] = new_ptr;
+
+	if (old_ptr)
+		kfree(old_ptr);
+
+	return 0;
+}
+
+/**
+ * check_dyn_pageflag_range: Resize a section of a dyn_pageflag array.
+ *
+ * @pagemap: The array to be worked on.
+ * @zone: The zone to get in sync with reality.
+ *
+ * Check the pagemap has correct allocations for the zone. This can be
+ * invoked when allocating a new bitmap, or for hot[un]plug, and so
+ * must deal with any disparities between zone_start_pfn/spanned_pages
+ * and what we have allocated. In addition, we must deal with the possibility
+ * of zone_start_pfn having changed.
+ */
+int check_dyn_pageflag_zone(struct dyn_pageflags *pagemap, struct zone *zone,
+		int force_free_all)
+{
+	int node_id = zone_to_nid(zone), zone_idx = zone_idx(zone);
+	unsigned long copy_offset = 0, old_pages, new_pages;
+	unsigned long **old_ptr = pagemap->bitmap[node_id][zone_idx];
+
+	old_pages = old_ptr ? (unsigned long) old_ptr[1] : 0;
+	new_pages = force_free_all ? 0 : pages_for_span(zone->spanned_pages);
+
+	if (old_pages == new_pages &&
+	    (!old_pages || (unsigned long) old_ptr[0] == zone->zone_start_pfn))
+		return 0;
+
+	if (old_pages &&
+	    (unsigned long) old_ptr[0] != zone->zone_start_pfn)
+		copy_offset = pages_for_span((unsigned long) old_ptr[0] -
+							zone->zone_start_pfn);
+
+	/* New/expanded zone? */
+	return resize_zone_bitmap(pagemap, zone, old_pages, new_pages,
+			copy_offset);
+}
+
+#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
+/**
+ * dyn_pageflags_hotplug: Add pages to bitmaps for hotplugged memory.
+ *
+ * Seek to expand bitmaps for hotplugged memory. We ignore any failure.
+ * Since we handle sparse bitmaps anyway, they'll be automatically
+ * populated as needed.
+ */
+void dyn_pageflags_hotplug(struct zone *zone)
+{
+	struct dyn_pageflags *this;
+
+	list_for_each_entry(this, &flags_list, list)
+		check_dyn_pageflag_zone(this, zone, 0);
+}
+#endif
+
+/**
+ * free_dyn_pageflags: Free an array of dynamically allocated pageflags.
+ *
+ * @pagemap: The array to be freed.
+ *
+ * Free a dynamically allocated pageflags bitmap.
+ */
+void free_dyn_pageflags(struct dyn_pageflags *pagemap)
+{
+	int zone_idx;
+	struct pglist_data *pgdat;
+	unsigned long flags;
+
+	DUMP_DEBUG(pagemap);
+
+	if (!pagemap->bitmap)
+		return;
+	
+	for_each_online_pgdat_zone(pgdat, zone_idx)
+		check_dyn_pageflag_zone(pagemap,
+				&pgdat->node_zones[zone_idx], 1);
+
+	for_each_online_pgdat(pgdat) {
+		int i = pgdat->node_id;
+
+		if (pagemap->bitmap[i])
+			kfree((pagemap->bitmap)[i]);
+	}
+
+	kfree(pagemap->bitmap);
+	pagemap->bitmap = NULL;
+
+	pagemap->initialised = 0;
+
+	if (!pagemap->sparse) {
+		spin_lock_irqsave(&flags_list_lock, flags);
+		list_del_init(&pagemap->list);
+		spin_unlock_irqrestore(&flags_list_lock, flags);
+		pagemap->sparse = 1;
+	}
+}
+
+/**
+ * allocate_dyn_pageflags: Allocate a bitmap.
+ *
+ * @pagemap: The bitmap we want to allocate.
+ * @sparse: Whether to make the array sparse.
+ *
+ * The array we're preparing. If sparse, we don't allocate the actual
+ * pages until they're needed. If not sparse, we add the bitmap to the
+ * list so that if we're supporting memory hotplugging, we can allocate
+ * new pages on hotplug events.
+ *
+ * This routine may be called directly, or indirectly when the first bit
+ * needs to be set on a previously unused bitmap.
+ */
+int allocate_dyn_pageflags(struct dyn_pageflags *pagemap, int sparse)
+{
+	int zone_idx, result = 0;
+	struct zone *zone;
+	struct pglist_data *pgdat;
+	unsigned long flags;
+
+	if (!sparse && (pagemap->sparse || !pagemap->initialised)) {
+		spin_lock_irqsave(&flags_list_lock, flags);
+		list_add(&pagemap->list, &flags_list);
+		spin_unlock_irqrestore(&flags_list_lock, flags);
+	}
+
+	spin_lock_irqsave(&pagemap->struct_lock, flags);
+
+	pagemap->initialised = 1;
+	pagemap->sparse = sparse;
+
+	if (!pagemap->bitmap && try_alloc_dyn_pageflag_part((1 << NODES_WIDTH),
+				(void **) &pagemap->bitmap)) {
+		result = -ENOMEM;
+		goto out;
+	}
+
+	for_each_online_pgdat(pgdat) {
+		int node_id = pgdat->node_id;
+
+		if (!pagemap->bitmap[node_id] &&
+		    try_alloc_dyn_pageflag_part(MAX_NR_ZONES,
+			(void **) &(pagemap->bitmap)[node_id])) {
+				result = -ENOMEM;
+				goto out;
+		}
+
+		for (zone_idx = 0; zone_idx < MAX_NR_ZONES; zone_idx++) {
+			zone = &pgdat->node_zones[zone_idx];
+
+			if (populated_zone(zone))
+				check_dyn_pageflag_zone(pagemap, zone, 0);
+		}
+	}
+
+out:
+	spin_unlock_irqrestore(&pagemap->struct_lock, flags);
+	return result;
+}
+
+/**
+ * test_dynpageflag: Test a page in a bitmap.
+ *
+ * @bitmap: The bitmap we're checking.
+ * @page: The page for which we want to test the matching bit.
+ *
+ * Test whether the bit is on in the array. The array may be sparse,
+ * in which case the result is zero.
+ */
+int test_dynpageflag(struct dyn_pageflags *bitmap, struct page *page)
+{
+	GET_BIT_AND_UL(bitmap, page);
+	return ul ? test_bit(bit, ul) : 0;
+}
+
+/**
+ * set_dynpageflag: Set a bit in a bitmap.
+ *
+ * @bitmap: The bitmap we're operating on.
+ * @page: The page for which we want to set the matching bit.
+ *
+ * Set the associated bit in the array. If the array is sparse, we
+ * seek to allocate the missing page.
+ */
+void set_dynpageflag(struct dyn_pageflags *pageflags, struct page *page)
+{
+	GET_BIT_AND_UL(pageflags, page);
+
+	if (!ul) {	/* Sparse, hotplugged or unprepared */
+		/* Allocate / fill gaps in high levels */
+		if (allocate_dyn_pageflags(pageflags, 1) ||
+		    populate_bitmap_page(pageflags, (unsigned long **)
+				&pageflags->bitmap[node][zone_num][pagenum])) {
+			printk(KERN_EMERG "Failed to allocate storage in a "
+					"sparse bitmap.\n");
+			dump_pagemap(pageflags);
+			BUG();
+		}
+		set_dynpageflag(pageflags, page);
+	} else
+		set_bit(bit, ul);
+}
+
+/**
+ * clear_dynpageflag: Clear a bit in a bitmap.
+ *
+ * @bitmap: The bitmap we're operating on.
+ * @page: The page for which we want to clear the matching bit.
+ *
+ * Clear the associated bit in the array. It is not an error to be asked
+ * to clear a bit on a page we haven't allocated.
+ */
+void clear_dynpageflag(struct dyn_pageflags *bitmap, struct page *page)
+{
+	GET_BIT_AND_UL(bitmap, page);
+	if (ul)
+		clear_bit(bit, ul);
+}
+
+/**
+ * get_next_bit_on: Get the next bit in a bitmap.
+ *
+ * @pageflags: The bitmap we're searching.
+ * @counter: The previous pfn. We always return a value > this.
+ *
+ * Given a pfn (possibly max_pfn+1), find the next pfn in the bitmap that
+ * is set. If there are no more flags set, return max_pfn+1.
+ */
+unsigned long get_next_bit_on(struct dyn_pageflags *pageflags,
+		unsigned long counter)
+{
+	struct page *page;
+	struct zone *zone;
+	unsigned long *ul = NULL;
+	unsigned long zone_offset;
+	int pagebit, zone_num, first = (counter == (max_pfn + 1)), node;
+
+	if (first)
+		counter = first_online_pgdat()->node_zones->zone_start_pfn;
+
+	page = pfn_to_page(counter);
+	zone = page_zone(page);
+	node = zone->zone_pgdat->node_id;
+	zone_num = zone_idx(zone);
+	zone_offset = counter - zone->zone_start_pfn;
+
+	if (first)
+		goto test;
+
+	do {
+		zone_offset++;
+	
+		if (zone_offset >= zone->spanned_pages) {
+			do {
+				zone = next_zone(zone);
+				if (!zone)
+					return max_pfn + 1;
+			} while(!zone->spanned_pages);
+			
+			zone_num = zone_idx(zone);
+			node = zone->zone_pgdat->node_id;
+			zone_offset = 0;
+		}
+test:
+		pagebit = PAGEBIT(zone_offset);
+
+		if (!pagebit || !ul) {
+			ul = pageflags->bitmap[node][zone_num][PAGENUMBER(zone_offset)+2];
+			if (ul)
+				ul+= PAGEINDEX(zone_offset);
+			else {
+				PR_DEBUG("Unallocated page. Skipping from zone"
+					" offset %lu to the start of the next "
+					"one.\n", zone_offset);
+				zone_offset = roundup(zone_offset + 1,
+						PAGE_SIZE << 3) - 1;
+				PR_DEBUG("New zone offset is %lu.\n", zone_offset);
+				continue;
+			}
+		}
+
+		if (!ul || !(*ul & ~((1 << pagebit) - 1))) {
+			zone_offset += BITS_PER_LONG - pagebit - 1;
+			continue;
+		}
+
+	} while(!ul || !test_bit(pagebit, ul));
+
+	return zone->zone_start_pfn + zone_offset;
+}
+
+#ifdef SELF_TEST
+#include <linux/jiffies.h>
+
+static __init int dyn_pageflags_test(void)
+{
+	struct dyn_pageflags test_map;
+	struct page *test_page1 = pfn_to_page(1);
+	unsigned long pfn = 0, start, end;
+	int i, iterations;
+
+	memset(&test_map, 0, sizeof(test_map));
+
+	printk("Dynpageflags testing...\n");
+
+	printk("Set page 1...");
+	set_dynpageflag(&test_map, test_page1);
+	if (test_dynpageflag(&test_map, test_page1))
+		printk("Ok.\n");
+	else
+		printk("FAILED.\n");
+
+	printk("Test memory hotplugging #1 ...");
+	{
+		unsigned long orig_size;
+		GET_BIT_AND_UL(&test_map, test_page1);
+		orig_size = (unsigned long) test_map.bitmap[node][zone_num][1];
+		/*
+		 * Use the code triggered when zone_start_pfn lowers,
+		 * checking that our bit is then set in the third page.
+		 */
+		resize_zone_bitmap(&test_map, zone, orig_size, orig_size + 2, 2);
+		DUMP_DEBUG(&test_map);
+		if ((unsigned long) test_map.bitmap[node][zone_num][pagenum + 2] &&
+		    (unsigned long) test_map.bitmap[node][zone_num][pagenum + 2][0] == 2UL)
+			printk("Ok.\n");
+		else
+			printk("FAILED.\n");
+	}
+
+	printk("Test memory hotplugging #2 ...");
+	{
+		/*
+		 * Test expanding bitmap length.
+		 */
+		unsigned long orig_size;
+		GET_BIT_AND_UL(&test_map, test_page1);
+		orig_size = (unsigned long) test_map.bitmap[node][zone_num][1];
+		resize_zone_bitmap(&test_map, zone, orig_size, orig_size + 2, 0);
+		DUMP_DEBUG(&test_map);
+		pagenum += 2; /* Offset for first test */
+		if (test_map.bitmap[node][zone_num][pagenum] &&
+		    test_map.bitmap[node][zone_num][pagenum][0] == 2UL &&
+		    (unsigned long) test_map.bitmap[node][zone_num][1] ==
+					    	orig_size + 2)
+			printk("Ok.\n");
+		else
+			printk("FAILED ([%d][%d][%d]: %p && %lu == 2UL  && %p == %lu).\n",
+					node, zone_num, pagenum,
+					test_map.bitmap[node][zone_num][pagenum],
+					test_map.bitmap[node][zone_num][pagenum] ?
+					test_map.bitmap[node][zone_num][pagenum][0] : 0,
+					test_map.bitmap[node][zone_num][1],
+					orig_size + 2);
+	}
+
+	free_dyn_pageflags(&test_map);
+
+	allocate_dyn_pageflags(&test_map, 0);
+
+	start = jiffies;
+
+	iterations = 25000000 / max_pfn;
+
+	for (i = 0; i < iterations; i++) {
+		for (pfn = 0; pfn < max_pfn; pfn++)
+			set_dynpageflag(&test_map, pfn_to_page(pfn));
+		for (pfn = 0; pfn < max_pfn; pfn++)
+			clear_dynpageflag(&test_map, pfn_to_page(pfn));
+	}
+
+	end = jiffies;
+
+	free_dyn_pageflags(&test_map);
+
+	printk("Dyn: %d iterations of setting & clearing all %lu flags took %lu jiffies.\n",
+			iterations, max_pfn, end - start);
+
+	start = jiffies;
+
+	for (i = 0; i < iterations; i++) {
+		for (pfn = 0; pfn < max_pfn; pfn++)
+			set_bit(7, &(pfn_to_page(pfn))->flags);
+		for (pfn = 0; pfn < max_pfn; pfn++)
+			clear_bit(7, &(pfn_to_page(pfn))->flags);
+	}
+
+	end = jiffies;
+
+	printk("Real flags: %d iterations of setting & clearing all %lu flags took %lu jiffies.\n",
+			iterations, max_pfn, end - start);
+
+	iterations = 25000000;
+
+	start = jiffies;
+
+	for (i = 0; i < iterations; i++) {
+		set_dynpageflag(&test_map, pfn_to_page(1));
+		clear_dynpageflag(&test_map, pfn_to_page(1));
+	}
+
+	end = jiffies;
+
+	printk("Dyn: %d iterations of setting & clearing all one flag took %lu jiffies.\n",
+			iterations, end - start);
+
+	start = jiffies;
+
+	for (i = 0; i < iterations; i++) {
+		set_bit(7, &(pfn_to_page(1))->flags);
+		clear_bit(7, &(pfn_to_page(1))->flags);
+	}
+
+	end = jiffies;
+
+	printk("Real pageflag: %d iterations of setting & clearing all one flag took %lu jiffies.\n",
+			iterations, end - start);
+	return 0;
+}
+
+late_initcall(dyn_pageflags_test);
+#endif
+
+static int __init dyn_pageflags_debug_setup(char *str)
+{
+	printk("Dynamic pageflags debugging enabled.\n");
+	dyn_pageflags_debug = 1;
+	return 1;
+}
+
+__setup("dyn_pageflags_debug", dyn_pageflags_debug_setup);
diff -ruNp 840-dyn-pageflags.patch-old/mm/memory_hotplug.c 840-dyn-pageflags.patch-new/mm/memory_hotplug.c
--- 840-dyn-pageflags.patch-old/mm/memory_hotplug.c	2007-07-11 22:19:42.000000000 +1000
+++ 840-dyn-pageflags.patch-new/mm/memory_hotplug.c	2007-07-23 19:48:40.000000000 +1000
@@ -74,6 +74,8 @@ static int __add_zone(struct zone *zone,
 	}
 	memmap_init_zone(nr_pages, nid, zone_type,
 			 phys_start_pfn, MEMMAP_HOTPLUG);
+
+	dyn_pageflags_hotplug(zone);
 	return 0;
 }
 
