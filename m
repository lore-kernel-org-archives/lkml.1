Return-Path: <linux-kernel-owner+w=401wt.eu-S934105AbYEUCTC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934105AbYEUCTC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 22:19:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762157AbYEUCS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 22:18:27 -0400
Received: from saeurebad.de ([85.214.36.134]:33159 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933248AbYEUCSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 22:18:22 -0400
X-Mailbox-Line: From hannes@saeurebad.de Wed May 21 03:46:35 2008
Message-Id: <20080521014635.104324823@saeurebad.de>
References: <20080521013735.559724194@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Wed, 21 May 2008 03:37:37 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC 2/3] mm: Reimplement bootmem
Content-Disposition: inline; filename=bootmem-rewrite.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a complete overhaul of the bootmem allocator.

alloc_bootmem() will more likely respect the requested goal as the old
logic tried allocation on the first node in the system and dropped the
goal immediately if it not happened to reside on that node.  Now we
try the first allocation on the node holding the goal and then fall
back.

free_bootmem() and reserve_bootmem() have become more strict.  Users
have to make sure that the PFNS of the range are contiguous.

__alloc_bootmem_node_low() now also falls back to other nodes as
__alloc_bootmem_node() already does.

Otherwise, massive code cleanup and documentation on all public
interfaces.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>
CC: Yinghai Lu <yhlu.kernel@gmail.com>
---

 include/linux/bootmem.h |  112 ++---
 mm/bootmem.c            |  925 ++++++++++++++++++++++++------------------------
 2 files changed, 511 insertions(+), 526 deletions(-)

--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -1,12 +1,11 @@
 /*
- *  linux/mm/bootmem.c
+ * bootmem - Physical boot-time memory allocator and configurator
  *
- *  Copyright (C) 1999 Ingo Molnar
- *  Discontiguous memory support, Kanoj Sarcar, SGI, Nov 1999
+ * Copyright (C) 1999 Ingo Molnar
+ *               2008 Johannes Weiner
  *
- *  simple boot-time physical memory area allocator and
- *  free memory collector. It's used to deal with reserved
- *  system memory and memory holes as well.
+ * Access to this subsystem has to be serialized externally (which is
+ * true for the boot process anyway).
  */
 #include <linux/init.h>
 #include <linux/pfn.h>
@@ -19,15 +18,10 @@
 
 #include "internal.h"
 
-/*
- * Access to this subsystem has to be serialized externally. (this is
- * true for the boot process anyway)
- */
 unsigned long max_low_pfn;
 unsigned long min_low_pfn;
 unsigned long max_pfn;
 
-static LIST_HEAD(bdata_list);
 #ifdef CONFIG_CRASH_DUMP
 /*
  * If we have booted due to a crash, max_pfn will be a very low value. We need
@@ -38,574 +32,597 @@ unsigned long saved_max_pfn;
 
 bootmem_data_t bootmem_node_data[MAX_NUMNODES] __initdata;
 
-/* return the number of _pages_ that will be allocated for the boot bitmap */
-unsigned long __init bootmem_bootmap_pages(unsigned long pages)
-{
-	unsigned long mapsize;
+static struct list_head bdata_list __initdata = LIST_HEAD_INIT(bdata_list);
 
-	mapsize = (pages+7)/8;
-	mapsize = (mapsize + ~PAGE_MASK) & PAGE_MASK;
-	mapsize >>= PAGE_SHIFT;
+static unsigned long __init bootmem_bootmap_bytes(unsigned long pages)
+{
+	unsigned long bytes = (pages + 7) / 8;
 
-	return mapsize;
+	/*
+	 * Wordsize aligned, see __free_all_bootmem_node
+	 * for the reason.
+	 */
+	return ALIGN(bytes, sizeof(long));
 }
 
 /*
- * link bdata in order
+ * bootmem_bootmap_pages - bitmap size in pages
+ * @pages: number of pages the bitmap must represent
  */
-static void __init link_bootmem(bootmem_data_t *bdata)
+unsigned long __init bootmem_bootmap_pages(unsigned long pages)
 {
-	bootmem_data_t *ent;
+	unsigned long bytes = bootmem_bootmap_bytes(pages);
 
-	if (list_empty(&bdata_list)) {
-		list_add(&bdata->list, &bdata_list);
-		return;
-	}
-	/* insert in order */
-	list_for_each_entry(ent, &bdata_list, list) {
-		if (bdata->node_boot_start < ent->node_boot_start) {
-			list_add_tail(&bdata->list, &ent->list);
-			return;
-		}
-	}
-	list_add_tail(&bdata->list, &bdata_list);
+	return PAGE_ALIGN(bytes) / PAGE_SIZE;
 }
 
-/*
- * Given an initialised bdata, it returns the size of the boot bitmap
- */
-static unsigned long __init get_mapsize(bootmem_data_t *bdata)
+static void link_bdata(bootmem_data_t *bdata)
 {
-	unsigned long mapsize;
-	unsigned long start = PFN_DOWN(bdata->node_boot_start);
-	unsigned long end = bdata->node_low_pfn;
+	struct list_head *iter;
+
+	list_for_each(iter, &bdata_list) {
+		bootmem_data_t *entry = list_entry(iter, bootmem_data_t, list);
+
+		if (bdata->node_min_pfn < entry->node_min_pfn)
+			break;
+	}
 
-	mapsize = ((end - start) + 7) / 8;
-	return ALIGN(mapsize, sizeof(long));
+	list_add_tail(&bdata->list, iter);
 }
 
-/*
- * Called once to set up the allocator itself.
- */
-static unsigned long __init init_bootmem_core(pg_data_t *pgdat,
-	unsigned long mapstart, unsigned long start, unsigned long end)
+static unsigned long __init __init_bootmem_node(int nid, unsigned long mappfn,
+						unsigned long startpfn,
+						unsigned long endpfn)
 {
-	bootmem_data_t *bdata = pgdat->bdata;
-	unsigned long mapsize;
+	unsigned long bytes;
+	bootmem_data_t *bdata = &bootmem_node_data[nid];
 
-	bdata->node_bootmem_map = phys_to_virt(PFN_PHYS(mapstart));
-	bdata->node_boot_start = PFN_PHYS(start);
-	bdata->node_low_pfn = end;
-	link_bootmem(bdata);
+	bdata->node_bootmem_map = phys_to_virt(mappfn << PAGE_SHIFT);
+	bdata->node_min_pfn = startpfn;
+	bdata->node_low_pfn = endpfn;
 
-	/*
-	 * Initially all pages are reserved - setup_arch() has to
-	 * register free RAM areas explicitly.
-	 */
-	mapsize = get_mapsize(bdata);
-	memset(bdata->node_bootmem_map, 0xff, mapsize);
+	/* XXX: To be dropped */
+	bdata->node_boot_start = startpfn << PAGE_SHIFT;
 
-	return mapsize;
+	bytes = bootmem_bootmap_bytes(endpfn - startpfn);
+	memset(bdata->node_bootmem_map, 0xff, bytes);
+	link_bdata(bdata);
+
+	return bytes;
 }
 
 /*
- * Marks a particular physical memory range as unallocatable. Usable RAM
- * might be used for boot-time allocations - or it might get added
- * to the free page pool later on.
+ * init_bootmem_node - Register node as boot memory
+ * @pgdat: node to register
+ * @mappfn: PFN where map can be placed
+ * @startpfn: first PFN on the node
+ * @endpfn: first PFN after the node
+ *
+ * Returns the number of bytes needed to hold the node's page bitmap.
  */
-static int __init can_reserve_bootmem_core(bootmem_data_t *bdata,
-			unsigned long addr, unsigned long size, int flags)
+unsigned long __init init_bootmem_node(pg_data_t *pgdat, unsigned long mappfn,
+				unsigned long startpfn, unsigned long endpfn)
 {
-	unsigned long sidx, eidx;
-	unsigned long i;
+	return __init_bootmem_node(pgdat->node_id, mappfn, startpfn, endpfn);
+}
+
+
+/*
+ * init_bootmem - Register boot memory on UMA configurations
+ * @lowpfn: first _usable_ PFN
+ * @pages: number of pages to register
+ *
+ * Operates on the first/only node in the system.
+ *
+ * Returns the number of bytes needed to hold the page bitmap.
+ */
+unsigned long __init init_bootmem(unsigned long lowpfn, unsigned long pages)
+{
+	max_low_pfn = pages;
+	min_low_pfn = lowpfn;
+	return __init_bootmem_node(0, lowpfn, 0, pages);
+}
 
-	BUG_ON(!size);
+static unsigned long __init __free_all_bootmem_node(int nid)
+{
+	int aligned;
+	struct page *page;
+	unsigned long start, end, pages, count = 0;
+	bootmem_data_t *bdata = &bootmem_node_data[nid];
 
-	/* out of range, don't hold other */
-	if (addr + size < bdata->node_boot_start ||
-		PFN_DOWN(addr) > bdata->node_low_pfn)
+	if (!bdata->node_bootmem_map)
 		return 0;
 
+	start = bdata->node_min_pfn;
+	end = bdata->node_low_pfn;
+
 	/*
-	 * Round up to index to the range.
+	 * If the start is aligned to the machine's wordsize, we might
+	 * be able to free pages in bulks of that order.
 	 */
-	if (addr > bdata->node_boot_start)
-		sidx= PFN_DOWN(addr - bdata->node_boot_start);
-	else
-		sidx = 0;
+	aligned = !(start & (BITS_PER_LONG - 1));
 
-	eidx = PFN_UP(addr + size - bdata->node_boot_start);
-	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
-		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
-
-	for (i = sidx; i < eidx; i++) {
-		if (test_bit(i, bdata->node_bootmem_map)) {
-			if (flags & BOOTMEM_EXCLUSIVE)
-				return -EBUSY;
+	while (start < end) {
+		unsigned long *map, idx, vec;
+
+		map = bdata->node_bootmem_map;
+		idx = (start - bdata->node_min_pfn) / BITS_PER_LONG;
+		vec = ~map[idx];
+
+		/* Free wordsize order blocks at once */
+		if (aligned && vec == ~0UL && start + BITS_PER_LONG < end) {
+			int order = ilog2(BITS_PER_LONG);
+
+			__free_pages_bootmem(pfn_to_page(start), order);
+			count += BITS_PER_LONG;
+
+		/* Free the rest of the pages in this vector one by one. */
+		} else {
+			unsigned long off = 0;
+
+			while (vec && off < BITS_PER_LONG) {
+				if (vec & 1) {
+					page = pfn_to_page(start + off);
+					__free_pages_bootmem(page, 0);
+					count++;
+				}
+				vec >>= 1;
+				off++;
+			}
 		}
+		start += BITS_PER_LONG;
 	}
 
-	return 0;
+	/* Bitmap can go now, too */
+	page = virt_to_page(bdata->node_bootmem_map);
+	pages = bdata->node_low_pfn - bdata->node_min_pfn;
+	pages = bootmem_bootmap_pages(pages);
 
+	count += pages;
+	while (pages--)
+		__free_pages_bootmem(page++, 0);
+
+	return count;
 }
 
-static void __init reserve_bootmem_core(bootmem_data_t *bdata,
-			unsigned long addr, unsigned long size, int flags)
+/*
+ * free_all_bootmem_node - Release node's free memory to the buddy allocator
+ * @pgdat: node to release
+ *
+ * Returns the number of released pages.
+ */
+unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
 {
-	unsigned long sidx, eidx;
-	unsigned long i;
-
-	BUG_ON(!size);
+	register_page_bootmem_info_node(pgdat);
+	return __free_all_bootmem_node(pgdat->node_id);
+}
 
-	/* out of range */
-	if (addr + size < bdata->node_boot_start ||
-		PFN_DOWN(addr) > bdata->node_low_pfn)
-		return;
+/*
+ * free_all_bootmem - Release free memory to the buddy allocator
+ *
+ * Operates on the first/only node in the system.
+ * Returns the number of released pages.
+ */
+unsigned long __init free_all_bootmem(void)
+{
+	return free_all_bootmem_node(NODE_DATA(0));
+}
 
-	/*
-	 * Round up to index to the range.
-	 */
-	if (addr > bdata->node_boot_start)
-		sidx= PFN_DOWN(addr - bdata->node_boot_start);
-	else
-		sidx = 0;
+static void __init __free(void *map, unsigned long start, unsigned long end)
+{
+	unsigned long idx;
 
-	eidx = PFN_UP(addr + size - bdata->node_boot_start);
-	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
-		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
-
-	for (i = sidx; i < eidx; i++) {
-		if (test_and_set_bit(i, bdata->node_bootmem_map)) {
-#ifdef CONFIG_DEBUG_BOOTMEM
-			printk("hm, page %08lx reserved twice.\n", i*PAGE_SIZE);
-#endif
-		}
-	}
+	for (idx = start; idx < end; idx++)
+		if (!test_and_clear_bit(idx, map))
+			BUG();
 }
 
-static void __init free_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
-				     unsigned long size)
+static int __init __reserve(void *map, unsigned long start,
+				unsigned long end, int flags)
 {
-	unsigned long sidx, eidx;
-	unsigned long i;
+	unsigned long idx;
+	int exclusive = flags & BOOTMEM_EXCLUSIVE;
 
-	BUG_ON(!size);
+	for (idx = start; idx < end; idx++)
+		if (test_and_set_bit(idx, map))
+			if (exclusive) {
+				__free(map, start, idx);
+				return -EBUSY;
+			}
+	return 0;
+}
+
+static int __init mark_bootmem(unsigned long start, unsigned long end,
+				int reserve, int flags)
+{
+	unsigned long pos;
+	bootmem_data_t *bdata;
 
-	/* out range */
-	if (addr + size < bdata->node_boot_start ||
-		PFN_DOWN(addr) > bdata->node_low_pfn)
-		return;
 	/*
-	 * round down end of usable mem, partially free pages are
-	 * considered reserved.
+	 * If nodes span other nodes, the arch code must
+	 * specify explicit nodes.  If we mark one PFN free
+	 * on two nodes, chaos and confusion will break lose.
 	 */
 
-	if (addr >= bdata->node_boot_start && addr < bdata->last_success)
-		bdata->last_success = addr;
+	pos = start;
+	list_for_each_entry(bdata, &bdata_list, list) {
+		unsigned long sidx, eidx, max;
 
-	/*
-	 * Round up to index to the range.
-	 */
-	if (PFN_UP(addr) > PFN_DOWN(bdata->node_boot_start))
-		sidx = PFN_UP(addr) - PFN_DOWN(bdata->node_boot_start);
-	else
-		sidx = 0;
+		if (pos < bdata->node_min_pfn) {
+			/* Range spans non-contiguous nodes? */
+			BUG_ON(pos != start);
+			continue;
+		}
 
-	eidx = PFN_DOWN(addr + size - bdata->node_boot_start);
-	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
-		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
+		max = min(bdata->node_low_pfn, end);
+		sidx = pos - bdata->node_min_pfn;
+		eidx = max - bdata->node_min_pfn;
+
+		if (reserve) {
+			int err;
+
+			err = __reserve(bdata->node_bootmem_map,
+					sidx, eidx, flags);
+			if (err) {
+				/* Unroll the reservation again */
+				mark_bootmem(start, pos, 0, 0);
+				return err;
+			}
+		} else
+			__free(bdata->node_bootmem_map, sidx, eidx);
 
-	for (i = sidx; i < eidx; i++) {
-		if (unlikely(!test_and_clear_bit(i, bdata->node_bootmem_map)))
-			BUG();
+		if (max == end)
+			return 0;
+		pos = bdata->node_low_pfn;
 	}
+	BUG();
 }
 
 /*
- * We 'merge' subsequent allocations to save space. We might 'lose'
- * some fraction of a page if allocations cannot be satisfied due to
- * size constraints on boxes where there is physical RAM space
- * fragmentation - in these cases (mostly large memory boxes) this
- * is not a problem.
- *
- * On low memory boxes we get it right in 100% of the cases.
- *
- * alignment has to be a power of 2 value.
- *
- * NOTE:  This function is _not_ reentrant.
- */
-void * __init
-__alloc_bootmem_core(struct bootmem_data *bdata, unsigned long size,
-	      unsigned long align, unsigned long goal, unsigned long limit)
-{
-	unsigned long areasize, preferred;
-	unsigned long i, start = 0, incr, eidx, end_pfn;
-	void *ret;
-	unsigned long node_boot_start;
-	void *node_bootmem_map;
+ * free_bootmem_node - Mark page range as usable
+ * @pgdat: node the range resides on
+ * @addr: starting address of the range
+ * @size: size of the range in bytes
+ */
+void __init free_bootmem_node(pg_data_t *pgdat, unsigned long addr,
+			unsigned long size)
+{
+	unsigned long sidx, eidx;
+	bootmem_data_t *bdata = &bootmem_node_data[pgdat->node_id];
 
-	if (!size) {
-		printk("__alloc_bootmem_core(): zero-sized request\n");
-		BUG();
-	}
-	BUG_ON(align & (align-1));
+	/* Partially free pages are considered reserved */
+	sidx = PFN_UP(addr) - bdata->node_min_pfn;
+	eidx = PFN_DOWN(addr + size) - bdata->node_min_pfn;
 
-	/* on nodes without memory - bootmem_map is NULL */
-	if (!bdata->node_bootmem_map)
-		return NULL;
+	__free(bdata->node_bootmem_map, sidx, eidx);
+}
 
-	/* bdata->node_boot_start is supposed to be (12+6)bits alignment on x86_64 ? */
-	node_boot_start = bdata->node_boot_start;
-	node_bootmem_map = bdata->node_bootmem_map;
-	if (align) {
-		node_boot_start = ALIGN(bdata->node_boot_start, align);
-		if (node_boot_start > bdata->node_boot_start)
-			node_bootmem_map = (unsigned long *)bdata->node_bootmem_map +
-			    PFN_DOWN(node_boot_start - bdata->node_boot_start)/BITS_PER_LONG;
-	}
+/*
+ * free_bootmem - Mark page range as usable
+ * @addr: starting address of the range
+ * @size: size of the range in bytes
+ *
+ * The specified range must be contigous and can even span subsequent nodes.
+ *
+ * Usage on discontiguous area is a BUG!
+ */
+void __init free_bootmem(unsigned long addr, unsigned long size)
+{
+	unsigned long start, end;
 
-	if (limit && node_boot_start >= limit)
-		return NULL;
+	/* Partially free pages are considered reserved */
+	start = PFN_UP(addr);
+	end = PFN_DOWN(addr + size);
 
-	end_pfn = bdata->node_low_pfn;
-	limit = PFN_DOWN(limit);
-	if (limit && end_pfn > limit)
-		end_pfn = limit;
+	mark_bootmem(start, end, 0, 0);
+}
 
-	eidx = end_pfn - PFN_DOWN(node_boot_start);
+/*
+ * reserve_bootmem_node - Mark page range as reserved
+ * @pgdat: node the range resides on
+ * @addr: starting address of the range
+ * @size: size of the range in bytes
+ * @flags: reservation flags
+ *
+ * If flags contains BOOTMEM_EXCLUSIVE, the function will return
+ * -EBUSY if the range is already reserved.
+ */
+int __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long addr,
+				unsigned long size, int flags)
+{
+	unsigned long sidx, eidx;
+	bootmem_data_t *bdata = &bootmem_node_data[pgdat->node_id];
 
-	/*
-	 * We try to allocate bootmem pages above 'goal'
-	 * first, then we try to allocate lower pages.
-	 */
-	preferred = 0;
-	if (goal && PFN_DOWN(goal) < end_pfn) {
-		if (goal > node_boot_start)
-			preferred = goal - node_boot_start;
-
-		if (bdata->last_success > node_boot_start &&
-			bdata->last_success - node_boot_start >= preferred)
-			if (!limit || (limit && limit > bdata->last_success))
-				preferred = bdata->last_success - node_boot_start;
-	}
+	/* Partially reserved pages are considered reserved */
+	sidx = PFN_DOWN(addr) - bdata->node_min_pfn;
+	eidx = PFN_UP(addr + size) - bdata->node_min_pfn;
 
-	preferred = PFN_DOWN(ALIGN(preferred, align));
-	areasize = (size + PAGE_SIZE-1) / PAGE_SIZE;
-	incr = align >> PAGE_SHIFT ? : 1;
-
-restart_scan:
-	for (i = preferred; i < eidx;) {
-		unsigned long j;
-
-		i = find_next_zero_bit(node_bootmem_map, eidx, i);
-		i = ALIGN(i, incr);
-		if (i >= eidx)
-			break;
-		if (test_bit(i, node_bootmem_map)) {
-			i += incr;
-			continue;
-		}
-		for (j = i + 1; j < i + areasize; ++j) {
-			if (j >= eidx)
-				goto fail_block;
-			if (test_bit(j, node_bootmem_map))
-				goto fail_block;
-		}
-		start = i;
-		goto found;
-	fail_block:
-		i = ALIGN(j, incr);
-		if (i == j)
-			i += incr;
-	}
+	return __reserve(bdata->node_bootmem_map, sidx, eidx, flags);
+}
 
-	if (preferred > 0) {
-		preferred = 0;
-		goto restart_scan;
-	}
-	return NULL;
+/*
+ * reserve_bootmem - Mark page range as reserved
+ * @addr: starting address of the range
+ * @size: size of the range in bytes
+ * @flags: reservation flags
+ *
+ * The specified range must be contiguous and can even span subsequent nodes.
+ *
+ * Usage on discontiguous area is a BUG!
+ *
+ * If flags contains BOOTMEM_EXCLUSIVE, the function will return
+ * -EBUSY if the range is already reserved.
+ */
+#ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
+int __init reserve_bootmem(unsigned long addr, unsigned long size, int flags)
+{
+	unsigned long start, end;
 
-found:
-	bdata->last_success = PFN_PHYS(start) + node_boot_start;
-	BUG_ON(start >= eidx);
+	/* Partially reserved pages are considered reserved */
+	start = PFN_DOWN(addr);
+	end = PFN_UP(addr + size);
 
-	/*
-	 * Is the next page of the previous allocation-end the start
-	 * of this allocation's buffer? If yes then we can 'merge'
-	 * the previous partial page with this allocation.
-	 */
-	if (align < PAGE_SIZE &&
-	    bdata->last_offset && bdata->last_pos+1 == start) {
-		unsigned long offset, remaining_size;
-		offset = ALIGN(bdata->last_offset, align);
-		BUG_ON(offset > PAGE_SIZE);
-		remaining_size = PAGE_SIZE - offset;
-		if (size < remaining_size) {
-			areasize = 0;
-			/* last_pos unchanged */
-			bdata->last_offset = offset + size;
-			ret = phys_to_virt(bdata->last_pos * PAGE_SIZE +
-					   offset + node_boot_start);
-		} else {
-			remaining_size = size - remaining_size;
-			areasize = (remaining_size + PAGE_SIZE-1) / PAGE_SIZE;
-			ret = phys_to_virt(bdata->last_pos * PAGE_SIZE +
-					   offset + node_boot_start);
-			bdata->last_pos = start + areasize - 1;
-			bdata->last_offset = remaining_size;
-		}
-		bdata->last_offset &= ~PAGE_MASK;
-	} else {
-		bdata->last_pos = start + areasize - 1;
-		bdata->last_offset = size & ~PAGE_MASK;
-		ret = phys_to_virt(start * PAGE_SIZE + node_boot_start);
-	}
+	return mark_bootmem(start, end, 1, flags);
+}
+#endif
 
-	/*
-	 * Reserve the area now:
-	 */
-	for (i = start; i < start + areasize; i++)
-		if (unlikely(test_and_set_bit(i, node_bootmem_map)))
-			BUG();
-	memset(ret, 0, size);
-	return ret;
+static void * __init __do_alloc(bootmem_data_t *bdata, unsigned long align,
+				unsigned long start, unsigned long bytes)
+{
+	int merge;
+	void *region;
+	unsigned long new_start, new_end;
+
+	/* Align at the previous allocation end if we are subsequent */
+	if (bdata->alloc_off && PFN_DOWN(bdata->alloc_off) + 1 == start)
+		new_start = ALIGN(bdata->alloc_off, align);
+	else
+		new_start = PFN_PHYS(start);
+
+	merge = PFN_DOWN(new_start) < start;
+
+	new_end = new_start + bytes;
+	bdata->alloc_off = new_end;
+
+	if (__reserve(bdata->node_bootmem_map,
+			PFN_DOWN(new_start) + merge,
+			PFN_UP(new_end),
+			BOOTMEM_EXCLUSIVE))
+		BUG();
+
+	region = phys_to_virt(PFN_PHYS(bdata->node_min_pfn) + new_start);
+	memset(region, 0, bytes);
+	return region;
 }
 
-static unsigned long __init free_all_bootmem_core(pg_data_t *pgdat)
+static void * __init do_alloc(bootmem_data_t *bdata, unsigned long size,
+				unsigned long align, unsigned long goal,
+				unsigned long limit)
 {
-	struct page *page;
-	unsigned long pfn;
-	bootmem_data_t *bdata = pgdat->bdata;
-	unsigned long i, count, total = 0;
-	unsigned long idx;
-	unsigned long *map; 
-	int gofast = 0;
+	unsigned long min, max, start, step;
 
-	BUG_ON(!bdata->node_bootmem_map);
+	if (!bdata->node_bootmem_map)
+		return NULL;
 
-	count = 0;
-	/* first extant page of the node */
-	pfn = PFN_DOWN(bdata->node_boot_start);
-	idx = bdata->node_low_pfn - pfn;
-	map = bdata->node_bootmem_map;
-	/* Check physaddr is O(LOG2(BITS_PER_LONG)) page aligned */
-	if (bdata->node_boot_start == 0 ||
-	    ffs(bdata->node_boot_start) - PAGE_SHIFT > ffs(BITS_PER_LONG))
-		gofast = 1;
-	for (i = 0; i < idx; ) {
-		unsigned long v = ~map[i / BITS_PER_LONG];
+	BUG_ON(align & (align - 1));
+	BUG_ON(limit && goal + size > limit);
 
-		if (gofast && v == ~0UL) {
-			int order;
+	min = bdata->node_min_pfn;
+	max = bdata->node_low_pfn;
 
-			page = pfn_to_page(pfn);
-			count += BITS_PER_LONG;
-			order = ffs(BITS_PER_LONG) - 1;
-			__free_pages_bootmem(page, order);
-			i += BITS_PER_LONG;
-			page += BITS_PER_LONG;
-		} else if (v) {
-			unsigned long m;
-
-			page = pfn_to_page(pfn);
-			for (m = 1; m && i < idx; m<<=1, page++, i++) {
-				if (v & m) {
-					count++;
-					__free_pages_bootmem(page, 0);
-				}
-			}
-		} else {
-			i += BITS_PER_LONG;
-		}
-		pfn += BITS_PER_LONG;
-	}
-	total += count;
+	goal >>= PAGE_SHIFT;
+	limit >>= PAGE_SHIFT;
+
+	if (limit && max > limit)
+		max = limit;
+	if (max <= min)
+		return NULL;
 
 	/*
-	 * Now free the allocator bitmap itself, it's not
-	 * needed anymore:
+	 * For the block search, alignment does only matter
+	 * if it is bigger than the page size.
 	 */
-	page = virt_to_page(bdata->node_bootmem_map);
-	count = 0;
-	idx = (get_mapsize(bdata) + PAGE_SIZE-1) >> PAGE_SHIFT;
-	for (i = 0; i < idx; i++, page++) {
-		__free_pages_bootmem(page, 0);
-		count++;
-	}
-	total += count;
-	bdata->node_bootmem_map = NULL;
+	step = max(align >> PAGE_SHIFT, 1UL);
 
-	return total;
-}
+	if (goal && goal < max)
+		start = ALIGN(goal, step);
+	else
+		start = ALIGN(min, step);
 
-unsigned long __init init_bootmem_node(pg_data_t *pgdat, unsigned long freepfn,
-				unsigned long startpfn, unsigned long endpfn)
-{
-	return init_bootmem_core(pgdat, freepfn, startpfn, endpfn);
-}
+	/* From here on, all numbers are relative to the node */
+	max -= bdata->node_min_pfn;
+	start -= bdata->node_min_pfn;
 
-void __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
-				 unsigned long size, int flags)
-{
-	int ret;
+	while (1) {
+		unsigned long end, idx;
 
-	ret = can_reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
-	if (ret < 0)
-		return;
-	reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
-}
+		start = find_next_zero_bit(bdata->node_bootmem_map, max, start);
+		start = ALIGN(start, step);
+		end = start + PFN_UP(size);
 
-void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
-			      unsigned long size)
-{
-	free_bootmem_core(pgdat->bdata, physaddr, size);
-}
+		if (start >= max || end > max)
+			break;
 
-unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
-{
-	register_page_bootmem_info_node(pgdat);
-	return free_all_bootmem_core(pgdat);
-}
+		/*
+		 * XXX: Might require one page more than
+		 * we actually use later due to merging...
+		 */
+		for (idx = start; idx < end; idx++)
+			if (test_bit(idx, bdata->node_bootmem_map)) {
+				/* No luck, search on */
+				start = ALIGN(idx, step);
+				if (start == idx)
+					start += step;
+				continue;
+			}
 
-unsigned long __init init_bootmem(unsigned long start, unsigned long pages)
-{
-	max_low_pfn = pages;
-	min_low_pfn = start;
-	return init_bootmem_core(NODE_DATA(0), start, 0, pages);
+		return __do_alloc(bdata, align, start, size);
+	}
+
+	return NULL;
 }
 
-#ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
-int __init reserve_bootmem(unsigned long addr, unsigned long size,
-			    int flags)
+static void * __init ___alloc_bootmem_nopanic(unsigned long size,
+					unsigned long align,
+					unsigned long goal,
+					unsigned long limit)
 {
 	bootmem_data_t *bdata;
-	int ret;
 
+restart:
 	list_for_each_entry(bdata, &bdata_list, list) {
-		ret = can_reserve_bootmem_core(bdata, addr, size, flags);
-		if (ret < 0)
-			return ret;
+		void *region;
+
+		if (goal && PFN_DOWN(goal) < bdata->node_min_pfn)
+			continue;
+		if (limit && PFN_DOWN(limit) < bdata->node_min_pfn)
+			continue;
+
+		region = do_alloc(bdata, size, align, goal, limit);
+		if (region)
+			return region;
+	}
+	if (goal) {
+		goal = 0;
+		goto restart;
 	}
-	list_for_each_entry(bdata, &bdata_list, list)
-		reserve_bootmem_core(bdata, addr, size, flags);
 
-	return 0;
+	return NULL;
 }
-#endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
 
-void __init free_bootmem(unsigned long addr, unsigned long size)
+/*
+ * __alloc_bootmem_nopanic - Allocate boot memory without panicking
+ * @size: size of the region
+ * @align: alignment of the region
+ * @goal: preferred starting address of the region
+ *
+ * The goal is dropped if it can not be satisfied.
+ * The allocation can be on any node.
+ */
+void * __init __alloc_bootmem_nopanic(unsigned long size,
+				unsigned long align, unsigned long goal)
 {
-	bootmem_data_t *bdata;
-	list_for_each_entry(bdata, &bdata_list, list)
-		free_bootmem_core(bdata, addr, size);
+	return ___alloc_bootmem_nopanic(size, align, goal, 0);
 }
 
-unsigned long __init free_all_bootmem(void)
+static void * __init ___alloc_bootmem(unsigned long size, unsigned long align,
+				      unsigned long goal, unsigned long limit)
 {
-	return free_all_bootmem_core(NODE_DATA(0));
-}
+	void *region;
 
-void * __init __alloc_bootmem_nopanic(unsigned long size, unsigned long align,
-				      unsigned long goal)
-{
-	bootmem_data_t *bdata;
-	void *ptr;
+	region = ___alloc_bootmem_nopanic(size, align, goal, limit);
+	if (region)
+		return region;
 
-	list_for_each_entry(bdata, &bdata_list, list) {
-		ptr = __alloc_bootmem_core(bdata, size, align, goal, 0);
-		if (ptr)
-			return ptr;
-	}
+	printk(KERN_ALERT "bootmem alloc of %lu bytes failed!\n", size);
+	panic("Out of memory");
 	return NULL;
 }
 
+/*
+ * __alloc_bootmem - Allocate boot memory
+ * @size: size of the region
+ * @align: alignment of the region
+ * @goal: preferred starting address of the region
+ *
+ * The goal is dropped if it can not be satisfied.
+ * The allocation can be on any node.
+ * The function panics when allocation is impossible.
+ */
 void * __init __alloc_bootmem(unsigned long size, unsigned long align,
-			      unsigned long goal)
+				unsigned long goal)
 {
-	void *mem = __alloc_bootmem_nopanic(size,align,goal);
-
-	if (mem)
-		return mem;
-	/*
-	 * Whoops, we cannot satisfy the allocation request.
-	 */
-	printk(KERN_ALERT "bootmem alloc of %lu bytes failed!\n", size);
-	panic("Out of memory");
-	return NULL;
+	return ___alloc_bootmem(size, align, goal, 0);
 }
 
-
-void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
-				   unsigned long align, unsigned long goal)
+static void * __init ___alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
+					unsigned long align, unsigned long goal,
+					unsigned long limit)
 {
-	void *ptr;
+	void *region;
+	bootmem_data_t *bdata = &bootmem_node_data[pgdat->node_id];
 
-	ptr = __alloc_bootmem_core(pgdat->bdata, size, align, goal, 0);
-	if (ptr)
-		return ptr;
+	region = do_alloc(bdata, size, align, goal, limit);
+	if (region)
+		return region;
 
-	return __alloc_bootmem(size, align, goal);
+	/* No success on this node, drop the goal too */
+	return ___alloc_bootmem(size, align, 0, limit);
 }
 
-#ifdef CONFIG_SPARSEMEM
-void * __init alloc_bootmem_section(unsigned long size,
-				    unsigned long section_nr)
+/*
+ * __alloc_bootmem_node - Allocate boot memory
+ * @pgdat: node to allocate from
+ * @size: size of the region
+ * @align: alignment of the region
+ * @goal: preferred starting address of the region
+ *
+ * The goal is dropped if it can not be satisfied.
+ * The allocation can fall back to other nodes.
+ * The function panics when allocation is impossible.
+ */
+void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
+				unsigned long align, unsigned long goal)
 {
-	void *ptr;
-	unsigned long limit, goal, start_nr, end_nr, pfn;
-	struct pglist_data *pgdat;
-
-	pfn = section_nr_to_pfn(section_nr);
-	goal = PFN_PHYS(pfn);
-	limit = PFN_PHYS(section_nr_to_pfn(section_nr + 1)) - 1;
-	pgdat = NODE_DATA(early_pfn_to_nid(pfn));
-	ptr = __alloc_bootmem_core(pgdat->bdata, size, SMP_CACHE_BYTES, goal,
-				   limit);
-
-	if (!ptr)
-		return NULL;
-
-	start_nr = pfn_to_section_nr(PFN_DOWN(__pa(ptr)));
-	end_nr = pfn_to_section_nr(PFN_DOWN(__pa(ptr) + size));
-	if (start_nr != section_nr || end_nr != section_nr) {
-		printk(KERN_WARNING "alloc_bootmem failed on section %ld.\n",
-		       section_nr);
-		free_bootmem_core(pgdat->bdata, __pa(ptr), size);
-		ptr = NULL;
-	}
-
-	return ptr;
+	return ___alloc_bootmem_node(pgdat, size, align, goal, 0);
 }
-#endif
 
 #ifndef ARCH_LOW_ADDRESS_LIMIT
 #define ARCH_LOW_ADDRESS_LIMIT	0xffffffffUL
 #endif
 
+/*
+ * __alloc_bootmem_low - Allocate low boot memory
+ * @size: size of the region
+ * @align: alignment of the region
+ * @goal: preferred starting address of the region
+ *
+ * The goal is dropped if it can not be satisfied.
+ * The allocation can be on any node.
+ * The function panics when allocation is impossible.
+ */
+
 void * __init __alloc_bootmem_low(unsigned long size, unsigned long align,
 				  unsigned long goal)
 {
-	bootmem_data_t *bdata;
-	void *ptr;
-
-	list_for_each_entry(bdata, &bdata_list, list) {
-		ptr = __alloc_bootmem_core(bdata, size, align, goal,
-						ARCH_LOW_ADDRESS_LIMIT);
-		if (ptr)
-			return ptr;
-	}
-
-	/*
-	 * Whoops, we cannot satisfy the allocation request.
-	 */
-	printk(KERN_ALERT "low bootmem alloc of %lu bytes failed!\n", size);
-	panic("Out of low memory");
-	return NULL;
+	return ___alloc_bootmem(size, align, goal, ARCH_LOW_ADDRESS_LIMIT);
 }
 
+/*
+ * __alloc_bootmem_low_node - Allocate low boot memory
+ * @pgdat: node to allocate from
+ * @size: size of the region
+ * @align: alignment of the region
+ * @goal: preferred starting address of the region
+ *
+ * The goal is dropped if it can not be satisfied.
+ * The allocation can fall back on other nodes.
+ * The function panics when allocation is impossible.
+ */
 void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
 				       unsigned long align, unsigned long goal)
 {
-	return __alloc_bootmem_core(pgdat->bdata, size, align, goal,
-				    ARCH_LOW_ADDRESS_LIMIT);
+	return ___alloc_bootmem_node(pgdat, size, align,
+				goal, ARCH_LOW_ADDRESS_LIMIT);
+}
+
+/*
+ * alloc_bootmem_section - Allocate memory from a section
+ * @size: size of memory region
+ * @section_nr: section where the region resides on
+ */
+#ifdef CONFIG_SPARSEMEM
+void * __init alloc_bootmem_section(unsigned long size,
+				    unsigned long section_nr)
+{
+	bootmem_data_t *bdata;
+	unsigned long pfn, goal, limit;
+
+	pfn = section_nr_to_pfn(section_nr);
+	goal = PFN_PHYS(pfn);
+	limit = PFN_PHYS(section_nr_to_pfn(section_nr + 1));
+	bdata = &bootmem_node_data[early_pfn_to_nid(pfn)];
+
+	return do_alloc(bdata, size, SMP_CACHE_BYTES, goal, limit);
 }
+#endif
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -1,54 +1,60 @@
-/*
- * Discontiguous memory support, Kanoj Sarcar, SGI, Nov 1999
- */
 #ifndef _LINUX_BOOTMEM_H
 #define _LINUX_BOOTMEM_H
 
 #include <linux/mmzone.h>
 #include <asm/dma.h>
 
-/*
- *  simple boot-time physical memory area allocator.
- */
-
 extern unsigned long max_low_pfn;
 extern unsigned long min_low_pfn;
-
-/*
- * highest page
- */
 extern unsigned long max_pfn;
 
 #ifdef CONFIG_CRASH_DUMP
 extern unsigned long saved_max_pfn;
 #endif
 
-/*
- * node_bootmem_map is a map pointer - the bits represent all physical 
- * memory pages (including holes) on the node.
- */
 typedef struct bootmem_data {
 	unsigned long node_boot_start;
+	unsigned long node_min_pfn;
 	unsigned long node_low_pfn;
 	void *node_bootmem_map;
-	unsigned long last_offset;
-	unsigned long last_pos;
-	unsigned long last_success;	/* Previous allocation point.  To speed
-					 * up searching */
+	unsigned long alloc_off;
 	struct list_head list;
 } bootmem_data_t;
 
 extern bootmem_data_t bootmem_node_data[];
 
 extern unsigned long bootmem_bootmap_pages(unsigned long);
+
+extern unsigned long init_bootmem_node(pg_data_t *pgdat, unsigned long mappfn,
+				unsigned long startpfn, unsigned long endpfn);
 extern unsigned long init_bootmem(unsigned long addr, unsigned long memend);
+
+extern unsigned long free_all_bootmem_node(pg_data_t *pgdat);
+extern unsigned long free_all_bootmem(void);
+
+/*
+ * flags for reserve_bootmem (also if CONFIG_HAVE_ARCH_BOOTMEM_NODE,
+ * the architecture-specific code should honor this)
+ */
+#define BOOTMEM_DEFAULT		0
+#define BOOTMEM_EXCLUSIVE	(1 << 0)
+
+extern int reserve_bootmem_node(pg_data_t *pgdat, unsigned long addr,
+				unsigned long size, int flags);
+extern int reserve_bootmem(unsigned long addr, unsigned long size, int flags);
+
+extern void free_bootmem_node(pg_data_t *pgdat,
+			unsigned long addr, unsigned long size);
 extern void free_bootmem(unsigned long addr, unsigned long size);
-extern void *__alloc_bootmem(unsigned long size,
-			     unsigned long align,
-			     unsigned long goal);
+
 extern void *__alloc_bootmem_nopanic(unsigned long size,
 				     unsigned long align,
 				     unsigned long goal);
+extern void *__alloc_bootmem(unsigned long size,
+			     unsigned long align,
+			     unsigned long goal);
+extern void *__alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
+				unsigned long align, unsigned long goal);
 extern void *__alloc_bootmem_low(unsigned long size,
 				 unsigned long align,
 				 unsigned long goal);
@@ -56,64 +62,27 @@ extern void *__alloc_bootmem_low_node(pg
 				      unsigned long size,
 				      unsigned long align,
 				      unsigned long goal);
-extern void *__alloc_bootmem_core(struct bootmem_data *bdata,
-				  unsigned long size,
-				  unsigned long align,
-				  unsigned long goal,
-				  unsigned long limit);
-
-/*
- * flags for reserve_bootmem (also if CONFIG_HAVE_ARCH_BOOTMEM_NODE,
- * the architecture-specific code should honor this)
- */
-#define BOOTMEM_DEFAULT		0
-#define BOOTMEM_EXCLUSIVE	(1<<0)
 
+#ifdef CONFIG_SPARSEMEM
+extern void *alloc_bootmem_section(unsigned long size,
+				unsigned long section_nr);
+#endif
 #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
-/*
- * If flags is 0, then the return value is always 0 (success). If
- * flags contains BOOTMEM_EXCLUSIVE, then -EBUSY is returned if the
- * memory already was reserved.
- */
-extern int reserve_bootmem(unsigned long addr, unsigned long size, int flags);
-#define alloc_bootmem(x) \
+#define alloc_bootmem(x)						\
 	__alloc_bootmem(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
-#define alloc_bootmem_low(x) \
+#define alloc_bootmem_low(x)						\
 	__alloc_bootmem_low(x, SMP_CACHE_BYTES, 0)
-#define alloc_bootmem_pages(x) \
+#define alloc_bootmem_pages(x)						\
 	__alloc_bootmem(x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
-#define alloc_bootmem_low_pages(x) \
+#define alloc_bootmem_low_pages(x)					\
 	__alloc_bootmem_low(x, PAGE_SIZE, 0)
-#endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
-
-extern unsigned long free_all_bootmem(void);
-extern unsigned long free_all_bootmem_node(pg_data_t *pgdat);
-extern void *__alloc_bootmem_node(pg_data_t *pgdat,
-				  unsigned long size,
-				  unsigned long align,
-				  unsigned long goal);
-extern unsigned long init_bootmem_node(pg_data_t *pgdat,
-				       unsigned long freepfn,
-				       unsigned long startpfn,
-				       unsigned long endpfn);
-extern void reserve_bootmem_node(pg_data_t *pgdat,
-				 unsigned long physaddr,
-				 unsigned long size,
-				 int flags);
-extern void free_bootmem_node(pg_data_t *pgdat,
-			      unsigned long addr,
-			      unsigned long size);
-extern void *alloc_bootmem_section(unsigned long size,
-				   unsigned long section_nr);
-
-#ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
-#define alloc_bootmem_node(pgdat, x) \
+#define alloc_bootmem_node(pgdat, x)					\
 	__alloc_bootmem_node(pgdat, x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
-#define alloc_bootmem_pages_node(pgdat, x) \
+#define alloc_bootmem_pages_node(pgdat, x)				\
 	__alloc_bootmem_node(pgdat, x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
-#define alloc_bootmem_low_pages_node(pgdat, x) \
+#define alloc_bootmem_low_pages_node(pgdat, x)				\
 	__alloc_bootmem_low_node(pgdat, x, PAGE_SIZE, 0)
-#endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
+#endif
 
 #ifdef CONFIG_HAVE_ARCH_ALLOC_REMAP
 extern void *alloc_remap(int nid, unsigned long size);
@@ -148,5 +117,4 @@ extern void *alloc_large_system_hash(con
 #endif
 extern int hashdist;		/* Distribute hashes across NUMA nodes? */
 
-
 #endif /* _LINUX_BOOTMEM_H */

-- 

