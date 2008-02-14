Return-Path: <linux-kernel-owner+w=401wt.eu-S1764333AbYBNUCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764333AbYBNUCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756163AbYBNUCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:02:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:53241 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128AbYBNUCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:02:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ObZ9mZsraghxNRaskto6fiujs9BTFquUWPL7/q4A9JlemQ5IueLPsBRMVqcrO9sGlaUbFY0v4NCJ7TXwzPR7/OwOxRxkWiQmk7q3M+aMCQCPzFznF6uEPvK2c6RH7ZmvXnuC3Y5vewm06o3PXqMnqtmYsm3XPInqkENcA0/b92s=
Message-ID: <47B49E39.7070904@gmail.com>
Date: Thu, 14 Feb 2008 21:02:01 +0100
From: Vegard Nossum <vegard.nossum@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Daniel Walker <dwalker@mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Richard Knutsson <ricknu-0@student.ltu.se>,
       Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 3/4] kmemcheck v4
References: <47B49DB2.2090402@gmail.com>
In-Reply-To: <47B49DB2.2090402@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From 4ce1c09e38b2402dc04f0246916f3c23abe8f3e1 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Thu, 14 Feb 2008 19:25:39 +0100
Subject: [PATCH] kmemcheck: make SLUB use kmemcheck

With kmemcheck enabled, SLUB needs to do this:

1. Request twice as much memory as would normally be needed. The bottom half
    of the memory is what the user actually sees and uses; the upper half
    contains the so-called shadow memory, which stores the status of each byte
    in the bottom half, e.g. initialized or uninitialized.
2. Tell kmemcheck which parts of memory that should be marked uninitialized.
    There are actually a few more states, such as "not yet allocated" and
    "recently freed".

If a slab cache is set up using the SLAB_NOTRACK flag, it will never return
memory that can take page faults because of kmemcheck.

If a slab cache is NOT set up using the SLAB_NOTRACK flag, callers can still
request memory with the __GFP_NOTRACK flag. This does not prevent the page
faults from occuring, however, but marks the object in question as being
initialized so that no warnings will ever be produced for this object.

Signed-off-by: Vegard Nossum <vegardno@ifi.uio.no>
---
  include/linux/slab.h |    1 +
  kernel/fork.c        |   15 ++++---
  mm/slub.c            |  113 +++++++++++++++++++++++++++++++++++++++++---------
  3 files changed, 102 insertions(+), 27 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index f62caaa..35cc185 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -28,6 +28,7 @@
  #define SLAB_DESTROY_BY_RCU	0x00080000UL	/* Defer freeing slabs to RCU */
  #define SLAB_MEM_SPREAD		0x00100000UL	/* Spread some memory over cpuset */
  #define SLAB_TRACE		0x00200000UL	/* Trace allocations and frees */
+#define SLAB_NOTRACK		0x00400000UL	/* Don't track use of uninitialized memory */

  /* The following flags affect the page allocator grouping pages by mobility */
  #define SLAB_RECLAIM_ACCOUNT	0x00020000UL		/* Objects are reclaimable */
diff --git a/kernel/fork.c b/kernel/fork.c
index 4363a4e..1541016 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -141,7 +141,7 @@ void __init fork_init(unsigned long mempages)
  	/* create a slab on which task_structs can be allocated */
  	task_struct_cachep =
  		kmem_cache_create("task_struct", sizeof(struct task_struct),
-			ARCH_MIN_TASKALIGN, SLAB_PANIC, NULL);
+			ARCH_MIN_TASKALIGN, SLAB_PANIC | SLAB_NOTRACK, NULL);
  #endif

  	/*
@@ -1547,23 +1547,24 @@ void __init proc_caches_init(void)
  {
  	sighand_cachep = kmem_cache_create("sighand_cache",
  			sizeof(struct sighand_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_DESTROY_BY_RCU,
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_DESTROY_BY_RCU
+			|SLAB_NOTRACK,
  			sighand_ctor);
  	signal_cachep = kmem_cache_create("signal_cache",
  			sizeof(struct signal_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
  	files_cachep = kmem_cache_create("files_cache",
  			sizeof(struct files_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
  	fs_cachep = kmem_cache_create("fs_cache",
  			sizeof(struct fs_struct), 0,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
  	vm_area_cachep = kmem_cache_create("vm_area_struct",
  			sizeof(struct vm_area_struct), 0,
-			SLAB_PANIC, NULL);
+			SLAB_PANIC|SLAB_NOTRACK, NULL);
  	mm_cachep = kmem_cache_create("mm_struct",
  			sizeof(struct mm_struct), ARCH_MIN_MMSTRUCT_ALIGN,
-			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK, NULL);
  }

  /*
diff --git a/mm/slub.c b/mm/slub.c
index e2989ae..c9787df 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -21,6 +21,7 @@
  #include <linux/ctype.h>
  #include <linux/kallsyms.h>
  #include <linux/memory.h>
+#include <linux/kmemcheck.h>

  /*
   * Lock order:
@@ -198,7 +199,7 @@ static inline void ClearSlabDebug(struct page *page)
  		SLAB_TRACE | SLAB_DESTROY_BY_RCU)

  #define SLUB_MERGE_SAME (SLAB_DEBUG_FREE | SLAB_RECLAIM_ACCOUNT | \
-		SLAB_CACHE_DMA)
+		SLAB_CACHE_DMA | SLAB_NOTRACK)

  #ifndef ARCH_KMALLOC_MINALIGN
  #define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
@@ -1077,9 +1078,7 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
  {
  	struct page *page;
  	int pages = 1 << s->order;
-
-	if (s->order)
-		flags |= __GFP_COMP;
+	int order = s->order;

  	if (s->flags & SLAB_CACHE_DMA)
  		flags |= SLUB_DMA;
@@ -1087,14 +1086,50 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
  	if (s->flags & SLAB_RECLAIM_ACCOUNT)
  		flags |= __GFP_RECLAIMABLE;

+#ifdef CONFIG_KMEMCHECK
+	/*
+	 * With kmemcheck enabled, we actually allocate twice as much. The
+	 * upper half of the allocation is used as our shadow memory where
+	 * the status (e.g. initialized/uninitialized) of each byte is
+	 * stored.
+	 */
+	if (!(s->flags & SLAB_NOTRACK)) {
+		pages += pages;
+		order += 1;
+	}
+#endif
+
+	if (order)
+		flags |= __GFP_COMP;
+
  	if (node == -1)
-		page = alloc_pages(flags, s->order);
+		page = alloc_pages(flags, order);
  	else
-		page = alloc_pages_node(node, flags, s->order);
+		page = alloc_pages_node(node, flags, order);

  	if (!page)
  		return NULL;

+#ifdef CONFIG_KMEMCHECK
+	if (!(s->flags & SLAB_NOTRACK)) {
+		/*
+		 * Mark it as non-present for the MMU so that our accesses to
+		 * this memory will trigger a page fault and let us analyze
+		 * the memory accesses.
+		 */
+		kmemcheck_hide_pages(page, pages >> 1);
+
+		/*
+		 * Objects from caches that have a constructor don't get
+		 * cleared when they're allocated, so we need to do it here.
+		 */
+		if (s->ctor)
+			kmemcheck_mark_uninitialized_pages(page, pages >> 1);
+		else
+			kmemcheck_mark_unallocated_pages(page, pages >> 1);
+	}
+#endif
+
  	mod_zone_page_state(page_zone(page),
  		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
  		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
@@ -1159,6 +1194,7 @@ out:
  static void __free_slab(struct kmem_cache *s, struct page *page)
  {
  	int pages = 1 << s->order;
+	int order = s->order;

  	if (unlikely(SlabDebug(page))) {
  		void *p;
@@ -1169,13 +1205,21 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
  		ClearSlabDebug(page);
  	}

+#ifdef CONFIG_KMEMCHECK
+	if (!(s->flags & SLAB_NOTRACK)) {
+		kmemcheck_show_pages(page, pages);
+		pages += pages;
+		order += 1;
+	}
+#endif
+
  	mod_zone_page_state(page_zone(page),
  		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
  		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
  		-pages);

  	page->mapping = NULL;
-	__free_pages(page, s->order);
+	__free_pages(page, order);
  }

  static void rcu_free_slab(struct rcu_head *h)
@@ -1656,6 +1700,28 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
  	if (unlikely((gfpflags & __GFP_ZERO) && object))
  		memset(object, 0, c->objsize);

+#ifdef CONFIG_KMEMCHECK
+	if (!(gfpflags & __GFP_ZERO) && !(s->flags & SLAB_NOTRACK)) {
+		if (gfpflags & __GFP_NOTRACK) {
+			/*
+			 * Allow notracked objects to be allocated from
+			 * tracked caches. Note however that these objects
+			 * will still get page faults on access, they just
+			 * won't ever be flagged as uninitialized. If page
+			 * faults are not acceptable, the slab cache itself
+			 * should be marked NOTRACK.
+			 */
+			kmemcheck_mark_initialized(object, s->objsize);
+		} else if (!s->ctor) {
+			/*
+			 * New objects should be marked uninitialized before
+			 * they're returned to the called.
+			 */
+			kmemcheck_mark_uninitialized(object, s->objsize);
+		}
+	}
+#endif
+
  	return object;
  }

@@ -1767,10 +1833,19 @@ static __always_inline void slab_free(struct kmem_cache *s,
  {
  	void **object = (void *)x;
  	struct kmem_cache_cpu *c;
-
  #ifdef SLUB_FASTPATH
  	void **freelist;
+#else
+	unsigned long flags;
+
+#endif
+
+#ifdef CONFIG_KMEMCHECK
+	if (!s->ctor)
+		kmemcheck_mark_freed(object, s->objsize);
+#endif

+#ifdef SLUB_FASTPATH
  	c = get_cpu_slab(s, raw_smp_processor_id());
  	debug_check_no_locks_freed(object, s->objsize);
  	do {
@@ -1795,8 +1870,6 @@ static __always_inline void slab_free(struct kmem_cache *s,
  		stat(c, FREE_FASTPATH);
  	} while (cmpxchg_local(&c->freelist, freelist, object) != freelist);
  #else
-	unsigned long flags;
-
  	local_irq_save(flags);
  	debug_check_no_locks_freed(object, s->objsize);
  	c = get_cpu_slab(s, smp_processor_id());
@@ -2527,12 +2600,10 @@ static int __init setup_slub_nomerge(char *str)
  __setup("slub_nomerge", setup_slub_nomerge);

  static struct kmem_cache *create_kmalloc_cache(struct kmem_cache *s,
-		const char *name, int size, gfp_t gfp_flags)
+	const char *name, int size, gfp_t gfp_flags, unsigned int flags)
  {
-	unsigned int flags = 0;
-
  	if (gfp_flags & SLUB_DMA)
-		flags = SLAB_CACHE_DMA;
+		flags |= SLAB_CACHE_DMA;

  	down_write(&slub_lock);
  	if (!kmem_cache_open(s, gfp_flags, name, size, ARCH_KMALLOC_MINALIGN,
@@ -2595,7 +2666,8 @@ static noinline struct kmem_cache *dma_kmalloc_cache(int index, gfp_t flags)

  	if (!s || !text || !kmem_cache_open(s, flags, text,
  			realsize, ARCH_KMALLOC_MINALIGN,
-			SLAB_CACHE_DMA|__SYSFS_ADD_DEFERRED, NULL)) {
+			SLAB_CACHE_DMA|SLAB_NOTRACK|__SYSFS_ADD_DEFERRED,
+			NULL)) {
  		kfree(s);
  		kfree(text);
  		goto unlock_out;
@@ -2979,7 +3051,7 @@ void __init kmem_cache_init(void)
  	 * kmem_cache_open for slab_state == DOWN.
  	 */
  	create_kmalloc_cache(&kmalloc_caches[0], "kmem_cache_node",
-		sizeof(struct kmem_cache_node), GFP_KERNEL);
+		sizeof(struct kmem_cache_node), GFP_KERNEL, 0);
  	kmalloc_caches[0].refcount = -1;
  	caches++;

@@ -2992,18 +3064,18 @@ void __init kmem_cache_init(void)
  	/* Caches that are not of the two-to-the-power-of size */
  	if (KMALLOC_MIN_SIZE <= 64) {
  		create_kmalloc_cache(&kmalloc_caches[1],
-				"kmalloc-96", 96, GFP_KERNEL);
+				"kmalloc-96", 96, GFP_KERNEL, 0);
  		caches++;
  	}
  	if (KMALLOC_MIN_SIZE <= 128) {
  		create_kmalloc_cache(&kmalloc_caches[2],
-				"kmalloc-192", 192, GFP_KERNEL);
+				"kmalloc-192", 192, GFP_KERNEL, 0);
  		caches++;
  	}

  	for (i = KMALLOC_SHIFT_LOW; i < PAGE_SHIFT; i++) {
  		create_kmalloc_cache(&kmalloc_caches[i],
-			"kmalloc", 1 << i, GFP_KERNEL);
+			"kmalloc", 1 << i, GFP_KERNEL, 0);
  		caches++;
  	}

@@ -3040,7 +3112,6 @@ void __init kmem_cache_init(void)
  	kmem_size = sizeof(struct kmem_cache);
  #endif

-
  	printk(KERN_INFO
  		"SLUB: Genslabs=%d, HWalign=%d, Order=%d-%d, MinObjects=%d,"
  		" CPUs=%d, Nodes=%d\n",
@@ -4230,6 +4301,8 @@ static char *create_unique_id(struct kmem_cache *s)
  		*p++ = 'a';
  	if (s->flags & SLAB_DEBUG_FREE)
  		*p++ = 'F';
+	if (!(s->flags & SLAB_NOTRACK))
+		*p++ = 't';
  	if (p != name + 1)
  		*p++ = '-';
  	p += sprintf(p, "%07d", s->size);
-- 
1.5.3.8


