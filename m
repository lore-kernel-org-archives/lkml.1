Return-Path: <linux-kernel-owner+w=401wt.eu-S1756855AbXGHDxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbXGHDxX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 23:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756642AbXGHDuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 23:50:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49265 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753356AbXGHDuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 23:50:20 -0400
Message-Id: <20070708035018.074510057@sgi.com>
References: <20070708034952.022985379@sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 07 Jul 2007 20:50:01 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@vger.kernel.org
Cc: suresh.b.siddha@intel.com
Cc: corey.d.gough@intel.com
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org
Subject: [patch 09/10] Remove the SLOB allocator for 2.6.23
Content-Disposition: inline; filename=rm_slob
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maintenance of slab allocators becomes a problem as new features for
allocators are developed. The SLOB allocator in particular has been lagging
behind in many ways in the past:

- Had no support for SLAB_DESTROY_BY_RCU for years (but no one noticed)

- Still has no support for slab reclaim counters. This may currently not
  be necessary if one would restrict the supported configurations for
  functionality relying on these. But even that has not been done.

The only current advantage over SLUB in terms of memory savings is through
SLOBs kmalloc layout that is not power of two based like SLAB and SLUB which
allows to eliminate some memory waste.

Through that SLOB has still a slight memory advantage over SLUB of ~350k in
for a standard server configuration. It is likely that the savings are is
smaller for real embedded configurations that have less functionality.

The density of non kmalloc slabs is superior in SLUB since SLOB has the need
to keep a per object structure in a page which leads to a minimal loss of 4
bytes. If cacheline alignment is necessary then the loss may need to be
greater in order to align the objects. SLUB can avoid that through a linked
list and can pack objects tighly together in a page with no objects in
between.

We will likely be adding new slab features soon and we can avoid maintenance
of SLOB if we remove it. SLOB has customarily been neglected. It is best
to remove SLOB altogether given the minimal benefit that is remaining.

That no one noticed the lack of SLAB_DESTROY_BY_RCU for the longest time
indicates also that the user base is minimal.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/slab.h |    6 
 init/Kconfig         |   10 
 mm/Makefile          |    1 
 mm/slob.c            |  615 ---------------------------------------------------
 4 files changed, 2 insertions(+), 630 deletions(-)

Index: linux-2.6.22-rc6-mm1/init/Kconfig
===================================================================
--- linux-2.6.22-rc6-mm1.orig/init/Kconfig	2007-07-03 17:19:28.000000000 -0700
+++ linux-2.6.22-rc6-mm1/init/Kconfig	2007-07-05 22:17:20.000000000 -0700
@@ -624,16 +624,6 @@ config SLUB
 	   of queues of objects. SLUB can use memory efficiently
 	   and has enhanced diagnostics.
 
-config SLOB
-	depends on EMBEDDED && !SPARSEMEM
-	bool "SLOB (Simple Allocator)"
-	help
-	   SLOB replaces the SLAB allocator with a drastically simpler
-	   allocator.  SLOB is more space efficient than SLAB but does not
-	   scale well (single lock for all operations) and is also highly
-	   susceptible to fragmentation. SLUB can accomplish a higher object
-	   density. It is usually better to use SLUB instead of SLOB.
-
 endchoice
 
 config PROC_SMAPS
Index: linux-2.6.22-rc6-mm1/mm/slob.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/mm/slob.c	2007-07-05 19:08:30.000000000 -0700
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,615 +0,0 @@
-/*
- * SLOB Allocator: Simple List Of Blocks
- *
- * Matt Mackall <mpm@selenic.com> 12/30/03
- *
- * NUMA support by Paul Mundt, 2007.
- *
- * How SLOB works:
- *
- * The core of SLOB is a traditional K&R style heap allocator, with
- * support for returning aligned objects. The granularity of this
- * allocator is as little as 2 bytes, however typically most architectures
- * will require 4 bytes on 32-bit and 8 bytes on 64-bit.
- *
- * The slob heap is a linked list of pages from alloc_pages(), and
- * within each page, there is a singly-linked list of free blocks (slob_t).
- * The heap is grown on demand and allocation from the heap is currently
- * first-fit.
- *
- * Above this is an implementation of kmalloc/kfree. Blocks returned
- * from kmalloc are prepended with a 4-byte header with the kmalloc size.
- * If kmalloc is asked for objects of PAGE_SIZE or larger, it calls
- * alloc_pages() directly, allocating compound pages so the page order
- * does not have to be separately tracked, and also stores the exact
- * allocation size in page->private so that it can be used to accurately
- * provide ksize(). These objects are detected in kfree() because slob_page()
- * is false for them.
- *
- * SLAB is emulated on top of SLOB by simply calling constructors and
- * destructors for every SLAB allocation. Objects are returned with the
- * 4-byte alignment unless the SLAB_HWCACHE_ALIGN flag is set, in which
- * case the low-level allocator will fragment blocks to create the proper
- * alignment. Again, objects of page-size or greater are allocated by
- * calling alloc_pages(). As SLAB objects know their size, no separate
- * size bookkeeping is necessary and there is essentially no allocation
- * space overhead, and compound pages aren't needed for multi-page
- * allocations.
- *
- * NUMA support in SLOB is fairly simplistic, pushing most of the real
- * logic down to the page allocator, and simply doing the node accounting
- * on the upper levels. In the event that a node id is explicitly
- * provided, alloc_pages_node() with the specified node id is used
- * instead. The common case (or when the node id isn't explicitly provided)
- * will default to the current node, as per numa_node_id().
- *
- * Node aware pages are still inserted in to the global freelist, and
- * these are scanned for by matching against the node id encoded in the
- * page flags. As a result, block allocations that can be satisfied from
- * the freelist will only be done so on pages residing on the same node,
- * in order to prevent random node placement.
- */
-
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/mm.h>
-#include <linux/cache.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/rcupdate.h>
-#include <linux/list.h>
-#include <asm/atomic.h>
-
-/*
- * slob_block has a field 'units', which indicates size of block if +ve,
- * or offset of next block if -ve (in SLOB_UNITs).
- *
- * Free blocks of size 1 unit simply contain the offset of the next block.
- * Those with larger size contain their size in the first SLOB_UNIT of
- * memory, and the offset of the next free block in the second SLOB_UNIT.
- */
-#if PAGE_SIZE <= (32767 * 2)
-typedef s16 slobidx_t;
-#else
-typedef s32 slobidx_t;
-#endif
-
-struct slob_block {
-	slobidx_t units;
-};
-typedef struct slob_block slob_t;
-
-/*
- * We use struct page fields to manage some slob allocation aspects,
- * however to avoid the horrible mess in include/linux/mm_types.h, we'll
- * just define our own struct page type variant here.
- */
-struct slob_page {
-	union {
-		struct {
-			unsigned long flags;	/* mandatory */
-			atomic_t _count;	/* mandatory */
-			slobidx_t units;	/* free units left in page */
-			unsigned long pad[2];
-			slob_t *free;		/* first free slob_t in page */
-			struct list_head list;	/* linked list of free pages */
-		};
-		struct page page;
-	};
-};
-static inline void struct_slob_page_wrong_size(void)
-{ BUILD_BUG_ON(sizeof(struct slob_page) != sizeof(struct page)); }
-
-/*
- * free_slob_page: call before a slob_page is returned to the page allocator.
- */
-static inline void free_slob_page(struct slob_page *sp)
-{
-	reset_page_mapcount(&sp->page);
-	sp->page.mapping = NULL;
-}
-
-/*
- * All (partially) free slob pages go on this list.
- */
-static LIST_HEAD(free_slob_pages);
-
-/*
- * slob_page: True for all slob pages (false for bigblock pages)
- */
-static inline int slob_page(struct slob_page *sp)
-{
-	return test_bit(PG_active, &sp->flags);
-}
-
-static inline void set_slob_page(struct slob_page *sp)
-{
-	__set_bit(PG_active, &sp->flags);
-}
-
-static inline void clear_slob_page(struct slob_page *sp)
-{
-	__clear_bit(PG_active, &sp->flags);
-}
-
-/*
- * slob_page_free: true for pages on free_slob_pages list.
- */
-static inline int slob_page_free(struct slob_page *sp)
-{
-	return test_bit(PG_private, &sp->flags);
-}
-
-static inline void set_slob_page_free(struct slob_page *sp)
-{
-	list_add(&sp->list, &free_slob_pages);
-	__set_bit(PG_private, &sp->flags);
-}
-
-static inline void clear_slob_page_free(struct slob_page *sp)
-{
-	list_del(&sp->list);
-	__clear_bit(PG_private, &sp->flags);
-}
-
-#define SLOB_UNIT sizeof(slob_t)
-#define SLOB_UNITS(size) (((size) + SLOB_UNIT - 1)/SLOB_UNIT)
-#define SLOB_ALIGN L1_CACHE_BYTES
-
-/*
- * struct slob_rcu is inserted at the tail of allocated slob blocks, which
- * were created with a SLAB_DESTROY_BY_RCU slab. slob_rcu is used to free
- * the block using call_rcu.
- */
-struct slob_rcu {
-	struct rcu_head head;
-	int size;
-};
-
-/*
- * slob_lock protects all slob allocator structures.
- */
-static DEFINE_SPINLOCK(slob_lock);
-
-/*
- * Encode the given size and next info into a free slob block s.
- */
-static void set_slob(slob_t *s, slobidx_t size, slob_t *next)
-{
-	slob_t *base = (slob_t *)((unsigned long)s & PAGE_MASK);
-	slobidx_t offset = next - base;
-
-	if (size > 1) {
-		s[0].units = size;
-		s[1].units = offset;
-	} else
-		s[0].units = -offset;
-}
-
-/*
- * Return the size of a slob block.
- */
-static slobidx_t slob_units(slob_t *s)
-{
-	if (s->units > 0)
-		return s->units;
-	return 1;
-}
-
-/*
- * Return the next free slob block pointer after this one.
- */
-static slob_t *slob_next(slob_t *s)
-{
-	slob_t *base = (slob_t *)((unsigned long)s & PAGE_MASK);
-	slobidx_t next;
-
-	if (s[0].units < 0)
-		next = -s[0].units;
-	else
-		next = s[1].units;
-	return base+next;
-}
-
-/*
- * Returns true if s is the last free block in its page.
- */
-static int slob_last(slob_t *s)
-{
-	return !((unsigned long)slob_next(s) & ~PAGE_MASK);
-}
-
-static void *slob_new_page(gfp_t gfp, int order, int node)
-{
-	void *page;
-
-#ifdef CONFIG_NUMA
-	if (node != -1)
-		page = alloc_pages_node(node, gfp, order);
-	else
-#endif
-		page = alloc_pages(gfp, order);
-
-	if (!page)
-		return NULL;
-
-	return page_address(page);
-}
-
-/*
- * Allocate a slob block within a given slob_page sp.
- */
-static void *slob_page_alloc(struct slob_page *sp, size_t size, int align)
-{
-	slob_t *prev, *cur, *aligned = 0;
-	int delta = 0, units = SLOB_UNITS(size);
-
-	for (prev = NULL, cur = sp->free; ; prev = cur, cur = slob_next(cur)) {
-		slobidx_t avail = slob_units(cur);
-
-		if (align) {
-			aligned = (slob_t *)ALIGN((unsigned long)cur, align);
-			delta = aligned - cur;
-		}
-		if (avail >= units + delta) { /* room enough? */
-			slob_t *next;
-
-			if (delta) { /* need to fragment head to align? */
-				next = slob_next(cur);
-				set_slob(aligned, avail - delta, next);
-				set_slob(cur, delta, aligned);
-				prev = cur;
-				cur = aligned;
-				avail = slob_units(cur);
-			}
-
-			next = slob_next(cur);
-			if (avail == units) { /* exact fit? unlink. */
-				if (prev)
-					set_slob(prev, slob_units(prev), next);
-				else
-					sp->free = next;
-			} else { /* fragment */
-				if (prev)
-					set_slob(prev, slob_units(prev), cur + units);
-				else
-					sp->free = cur + units;
-				set_slob(cur + units, avail - units, next);
-			}
-
-			sp->units -= units;
-			if (!sp->units)
-				clear_slob_page_free(sp);
-			return cur;
-		}
-		if (slob_last(cur))
-			return NULL;
-	}
-}
-
-/*
- * slob_alloc: entry point into the slob allocator.
- */
-static void *slob_alloc(size_t size, gfp_t gfp, int align, int node)
-{
-	struct slob_page *sp;
-	slob_t *b = NULL;
-	unsigned long flags;
-
-	spin_lock_irqsave(&slob_lock, flags);
-	/* Iterate through each partially free page, try to find room */
-	list_for_each_entry(sp, &free_slob_pages, list) {
-#ifdef CONFIG_NUMA
-		/*
-		 * If there's a node specification, search for a partial
-		 * page with a matching node id in the freelist.
-		 */
-		if (node != -1 && page_to_nid(&sp->page) != node)
-			continue;
-#endif
-
-		if (sp->units >= SLOB_UNITS(size)) {
-			b = slob_page_alloc(sp, size, align);
-			if (b)
-				break;
-		}
-	}
-	spin_unlock_irqrestore(&slob_lock, flags);
-
-	/* Not enough space: must allocate a new page */
-	if (!b) {
-		b = slob_new_page(gfp, 0, node);
-		if (!b)
-			return 0;
-		sp = (struct slob_page *)virt_to_page(b);
-		set_slob_page(sp);
-
-		spin_lock_irqsave(&slob_lock, flags);
-		sp->units = SLOB_UNITS(PAGE_SIZE);
-		sp->free = b;
-		INIT_LIST_HEAD(&sp->list);
-		set_slob(b, SLOB_UNITS(PAGE_SIZE), b + SLOB_UNITS(PAGE_SIZE));
-		set_slob_page_free(sp);
-		b = slob_page_alloc(sp, size, align);
-		BUG_ON(!b);
-		spin_unlock_irqrestore(&slob_lock, flags);
-	}
-	if (unlikely((gfp & __GFP_ZERO) && b))
-		memset(b, 0, size);
-	return b;
-}
-
-/*
- * slob_free: entry point into the slob allocator.
- */
-static void slob_free(void *block, int size)
-{
-	struct slob_page *sp;
-	slob_t *prev, *next, *b = (slob_t *)block;
-	slobidx_t units;
-	unsigned long flags;
-
-	if (ZERO_OR_NULL_PTR(block))
-		return;
-	BUG_ON(!size);
-
-	sp = (struct slob_page *)virt_to_page(block);
-	units = SLOB_UNITS(size);
-
-	spin_lock_irqsave(&slob_lock, flags);
-
-	if (sp->units + units == SLOB_UNITS(PAGE_SIZE)) {
-		/* Go directly to page allocator. Do not pass slob allocator */
-		if (slob_page_free(sp))
-			clear_slob_page_free(sp);
-		clear_slob_page(sp);
-		free_slob_page(sp);
-		free_page((unsigned long)b);
-		goto out;
-	}
-
-	if (!slob_page_free(sp)) {
-		/* This slob page is about to become partially free. Easy! */
-		sp->units = units;
-		sp->free = b;
-		set_slob(b, units,
-			(void *)((unsigned long)(b +
-					SLOB_UNITS(PAGE_SIZE)) & PAGE_MASK));
-		set_slob_page_free(sp);
-		goto out;
-	}
-
-	/*
-	 * Otherwise the page is already partially free, so find reinsertion
-	 * point.
-	 */
-	sp->units += units;
-
-	if (b < sp->free) {
-		set_slob(b, units, sp->free);
-		sp->free = b;
-	} else {
-		prev = sp->free;
-		next = slob_next(prev);
-		while (b > next) {
-			prev = next;
-			next = slob_next(prev);
-		}
-
-		if (!slob_last(prev) && b + units == next) {
-			units += slob_units(next);
-			set_slob(b, units, slob_next(next));
-		} else
-			set_slob(b, units, next);
-
-		if (prev + slob_units(prev) == b) {
-			units = slob_units(b) + slob_units(prev);
-			set_slob(prev, units, slob_next(b));
-		} else
-			set_slob(prev, slob_units(prev), b);
-	}
-out:
-	spin_unlock_irqrestore(&slob_lock, flags);
-}
-
-/*
- * End of slob allocator proper. Begin kmem_cache_alloc and kmalloc frontend.
- */
-
-#ifndef ARCH_KMALLOC_MINALIGN
-#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long)
-#endif
-
-#ifndef ARCH_SLAB_MINALIGN
-#define ARCH_SLAB_MINALIGN __alignof__(unsigned long)
-#endif
-
-void *__kmalloc_node(size_t size, gfp_t gfp, int node)
-{
-	unsigned int *m;
-	int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
-
-	if (size < PAGE_SIZE - align) {
-		if (!size)
-			return ZERO_SIZE_PTR;
-
-		m = slob_alloc(size + align, gfp, align, node);
-		if (m)
-			*m = size;
-		return (void *)m + align;
-	} else {
-		void *ret;
-
-		ret = slob_new_page(gfp | __GFP_COMP, get_order(size), node);
-		if (ret) {
-			struct page *page;
-			page = virt_to_page(ret);
-			page->private = size;
-		}
-		return ret;
-	}
-}
-EXPORT_SYMBOL(__kmalloc_node);
-
-void kfree(const void *block)
-{
-	struct slob_page *sp;
-
-	if (ZERO_OR_NULL_PTR(block))
-		return;
-
-	sp = (struct slob_page *)virt_to_page(block);
-	if (slob_page(sp)) {
-		int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
-		unsigned int *m = (unsigned int *)(block - align);
-		slob_free(m, *m + align);
-	} else
-		put_page(&sp->page);
-}
-EXPORT_SYMBOL(kfree);
-
-/* can't use ksize for kmem_cache_alloc memory, only kmalloc */
-size_t ksize(const void *block)
-{
-	struct slob_page *sp;
-
-	if (ZERO_OR_NULL_PTR(block))
-		return 0;
-
-	sp = (struct slob_page *)virt_to_page(block);
-	if (slob_page(sp))
-		return ((slob_t *)block - 1)->units + SLOB_UNIT;
-	else
-		return sp->page.private;
-}
-
-struct kmem_cache {
-	unsigned int size, align;
-	unsigned long flags;
-	const char *name;
-	void (*ctor)(void *, struct kmem_cache *, unsigned long);
-};
-
-struct kmem_cache *kmem_cache_create(const char *name, size_t size,
-	size_t align, unsigned long flags,
-	void (*ctor)(void*, struct kmem_cache *, unsigned long),
-	const struct kmem_cache_ops *o)
-{
-	struct kmem_cache *c;
-
-	c = slob_alloc(sizeof(struct kmem_cache), flags, 0, -1);
-
-	if (c) {
-		c->name = name;
-		c->size = size;
-		if (flags & SLAB_DESTROY_BY_RCU) {
-			/* leave room for rcu footer at the end of object */
-			c->size += sizeof(struct slob_rcu);
-		}
-		c->flags = flags;
-		c->ctor = ctor;
-		/* ignore alignment unless it's forced */
-		c->align = (flags & SLAB_HWCACHE_ALIGN) ? SLOB_ALIGN : 0;
-		if (c->align < ARCH_SLAB_MINALIGN)
-			c->align = ARCH_SLAB_MINALIGN;
-		if (c->align < align)
-			c->align = align;
-	} else if (flags & SLAB_PANIC)
-		panic("Cannot create slab cache %s\n", name);
-
-	return c;
-}
-EXPORT_SYMBOL(kmem_cache_create);
-
-void kmem_cache_destroy(struct kmem_cache *c)
-{
-	slob_free(c, sizeof(struct kmem_cache));
-}
-EXPORT_SYMBOL(kmem_cache_destroy);
-
-void *kmem_cache_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
-{
-	void *b;
-
-	if (c->size < PAGE_SIZE)
-		b = slob_alloc(c->size, flags, c->align, node);
-	else
-		b = slob_new_page(flags, get_order(c->size), node);
-
-	if (c->ctor)
-		c->ctor(b, c, 0);
-
-	return b;
-}
-EXPORT_SYMBOL(kmem_cache_alloc_node);
-
-static void __kmem_cache_free(void *b, int size)
-{
-	if (size < PAGE_SIZE)
-		slob_free(b, size);
-	else
-		free_pages((unsigned long)b, get_order(size));
-}
-
-static void kmem_rcu_free(struct rcu_head *head)
-{
-	struct slob_rcu *slob_rcu = (struct slob_rcu *)head;
-	void *b = (void *)slob_rcu - (slob_rcu->size - sizeof(struct slob_rcu));
-
-	__kmem_cache_free(b, slob_rcu->size);
-}
-
-void kmem_cache_free(struct kmem_cache *c, void *b)
-{
-	if (unlikely(c->flags & SLAB_DESTROY_BY_RCU)) {
-		struct slob_rcu *slob_rcu;
-		slob_rcu = b + (c->size - sizeof(struct slob_rcu));
-		INIT_RCU_HEAD(&slob_rcu->head);
-		slob_rcu->size = c->size;
-		call_rcu(&slob_rcu->head, kmem_rcu_free);
-	} else {
-		__kmem_cache_free(b, c->size);
-	}
-}
-EXPORT_SYMBOL(kmem_cache_free);
-
-unsigned int kmem_cache_size(struct kmem_cache *c)
-{
-	return c->size;
-}
-EXPORT_SYMBOL(kmem_cache_size);
-
-const char *kmem_cache_name(struct kmem_cache *c)
-{
-	return c->name;
-}
-EXPORT_SYMBOL(kmem_cache_name);
-
-int kmem_cache_shrink(struct kmem_cache *d)
-{
-	return 0;
-}
-EXPORT_SYMBOL(kmem_cache_shrink);
-
-int kmem_cache_defrag(int percentage, int node)
-{
-	return 0;
-}
-
-/*
- * SLOB does not support slab defragmentation
- */
-int kmem_cache_vacate(struct page *page)
-{
-	return 0;
-}
-EXPORT_SYMBOL(kmem_cache_vacate);
-
-int kmem_ptr_validate(struct kmem_cache *a, const void *b)
-{
-	return 0;
-}
-
-void __init kmem_cache_init(void)
-{
-}
Index: linux-2.6.22-rc6-mm1/include/linux/slab.h
===================================================================
--- linux-2.6.22-rc6-mm1.orig/include/linux/slab.h	2007-07-05 19:08:30.000000000 -0700
+++ linux-2.6.22-rc6-mm1/include/linux/slab.h	2007-07-05 22:18:14.000000000 -0700
@@ -156,8 +156,6 @@ size_t ksize(const void *);
  */
 #ifdef CONFIG_SLUB
 #include <linux/slub_def.h>
-#elif defined(CONFIG_SLOB)
-#include <linux/slob_def.h>
 #else
 #include <linux/slab_def.h>
 #endif
@@ -220,7 +218,7 @@ static inline void *kcalloc(size_t n, si
 	return __kmalloc(n * size, flags | __GFP_ZERO);
 }
 
-#if !defined(CONFIG_NUMA) && !defined(CONFIG_SLOB)
+#if !defined(CONFIG_NUMA)
 /**
  * kmalloc_node - allocate memory from a specific node
  * @size: how many bytes of memory are required.
@@ -248,7 +246,7 @@ static inline void *kmem_cache_alloc_nod
 {
 	return kmem_cache_alloc(cachep, flags);
 }
-#endif /* !CONFIG_NUMA && !CONFIG_SLOB */
+#endif /* !CONFIG_NUMA */
 
 /*
  * kmalloc_track_caller is a special version of kmalloc that records the
Index: linux-2.6.22-rc6-mm1/mm/Makefile
===================================================================
--- linux-2.6.22-rc6-mm1.orig/mm/Makefile	2007-07-03 17:19:28.000000000 -0700
+++ linux-2.6.22-rc6-mm1/mm/Makefile	2007-07-05 22:17:20.000000000 -0700
@@ -22,7 +22,6 @@ obj-$(CONFIG_SPARSEMEM)	+= sparse.o
 obj-$(CONFIG_SHMEM) += shmem.o
 obj-$(CONFIG_TMPFS_POSIX_ACL) += shmem_acl.o
 obj-$(CONFIG_TINY_SHMEM) += tiny-shmem.o
-obj-$(CONFIG_SLOB) += slob.o
 obj-$(CONFIG_SLAB) += slab.o
 obj-$(CONFIG_SLUB) += slub.o
 obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o

-- 
