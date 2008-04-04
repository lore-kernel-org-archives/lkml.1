Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbYDDNsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbYDDNsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086AbYDDNry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 09:47:54 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:2832 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419AbYDDNrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 09:47:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=xj0xZoznEhm5aOEj6Wn2rYbjpviC9rhDlPQFCYijeEUPA06Z27BDURN7+oARP19bv/Qe2A5MoR0ep1EWm3/fLlRnQKazrzpLbZWenJlyssIhDRBnEiQqS3WAxCvRvp6ptUXsJM8c3eord80PqtjcEHtiYIS5TzCZ24Dsnt2NUy0=
Message-ID: <47F63178.3010207@gmail.com>
Date: Fri, 04 Apr 2008 15:47:36 +0200
From: Vegard Nossum <vegard.nossum@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Christoph Lameter <clameter@sgi.com>,
       Daniel Walker <dwalker@mvista.com>, Andi Kleen <andi@firstfloor.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Josh Aune <luken@omner.org>,
       Pekka Paalanen <pq@iki.fi>
Subject: [PATCH 3/3] slub: add hooks for kmemcheck
References: <47F630AE.7050801@gmail.com>
In-Reply-To: <47F630AE.7050801@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From d3844118edba5548cce8d27a78bb15b8d6aded66 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 4 Apr 2008 00:54:48 +0200
Subject: [PATCH] slub: add hooks for kmemcheck

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
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
  include/linux/gfp.h      |    3 +-
  include/linux/slab.h     |    7 +++
  include/linux/slub_def.h |   17 ++++++++
  kernel/fork.c            |   15 ++++---
  mm/Makefile              |    3 +
  mm/slub.c                |   36 ++++++++++++-----
  mm/slub_kmemcheck.c      |   99 ++++++++++++++++++++++++++++++++++++++++++++++
  7 files changed, 161 insertions(+), 19 deletions(-)
  create mode 100644 mm/slub_kmemcheck.c

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 164be9d..0faeedc 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -50,8 +50,9 @@ struct vm_area_struct;
  #define __GFP_THISNODE	((__force gfp_t)0x40000u)/* No fallback, no policies */
  #define __GFP_RECLAIMABLE ((__force gfp_t)0x80000u) /* Page is reclaimable */
  #define __GFP_MOVABLE	((__force gfp_t)0x100000u)  /* Page is movable */
+#define __GFP_NOTRACK	((__force gfp_t)0x200000u)  /* Don't track with kmemcheck */

-#define __GFP_BITS_SHIFT 21	/* Room for 21 __GFP_FOO bits */
+#define __GFP_BITS_SHIFT 22	/* Room for 22 __GFP_FOO bits */
  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))

  /* This equals 0, but use constants in case they ever change */
diff --git a/include/linux/slab.h b/include/linux/slab.h
index f62caaa..d5505b1 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -29,6 +29,13 @@
  #define SLAB_MEM_SPREAD		0x00100000UL	/* Spread some memory over cpuset */
  #define SLAB_TRACE		0x00200000UL	/* Trace allocations and frees */

+#ifdef CONFIG_KMEMCHECK
+/* Don't track use of uninitialized memory */
+# define SLAB_NOTRACK		0x00400000UL
+#else
+# define SLAB_NOTRACK		0
+#endif
+
  /* The following flags affect the page allocator grouping pages by mobility */
  #define SLAB_RECLAIM_ACCOUNT	0x00020000UL		/* Objects are reclaimable */
  #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index b00c1c7..e0b9a39 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -231,4 +231,21 @@ static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
  }
  #endif

+#ifdef CONFIG_KMEMCHECK
+struct page *kmemcheck_allocate_slab(struct kmem_cache *s,
+	gfp_t flags, int node, int pages);
+void kmemcheck_free_slab(struct kmem_cache *s, struct page *page, int pages);
+
+void kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object);
+void kmemcheck_slab_free(struct kmem_cache *s, void *object);
+#else
+static inline struct page *kmemcheck_allocate_slab(struct kmem_cache *s,
+	gfp_t flags, int node, int pages) { return NULL; }
+static inline void kmemcheck_free_slab(struct kmem_cache *s,
+	struct page *page, int pages) { }
+static inline void kmemcheck_slab_alloc(struct kmem_cache *s,
+	gfp_t gfpflags, void *object) { }
+static inline void kmemcheck_slab_free(struct kmem_cache *s, void *object) { }
+#endif /* CONFIG_KMEMCHECK */
+
  #endif /* _LINUX_SLUB_DEF_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 9c042f9..1318da2 100644
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
diff --git a/mm/Makefile b/mm/Makefile
index a5b0dd9..ae65439 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -34,3 +34,6 @@ obj-$(CONFIG_SMP) += allocpercpu.o
  obj-$(CONFIG_QUICKLIST) += quicklist.o
  obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o

+ifeq ($(CONFIG_KMEMCHECK),y)
+obj-$(CONFIG_SLUB) += slub_kmemcheck.o
+endif
diff --git a/mm/slub.c b/mm/slub.c
index acc975f..325f2e4 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -21,6 +21,7 @@
  #include <linux/ctype.h>
  #include <linux/kallsyms.h>
  #include <linux/memory.h>
+#include <linux/kmemcheck.h>

  /*
   * Lock order:
@@ -191,7 +192,7 @@ static inline void ClearSlabDebug(struct page *page)
  		SLAB_TRACE | SLAB_DESTROY_BY_RCU)

  #define SLUB_MERGE_SAME (SLAB_DEBUG_FREE | SLAB_RECLAIM_ACCOUNT | \
-		SLAB_CACHE_DMA)
+		SLAB_CACHE_DMA | SLAB_NOTRACK)

  #ifndef ARCH_KMALLOC_MINALIGN
  #define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
@@ -1039,6 +1040,9 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)

  	flags |= s->allocflags;

+	if (kmemcheck_enabled && !(s->flags & SLAB_NOTRACK))
+		return kmemcheck_allocate_slab(s, flags, node, pages);
+
  	if (node == -1)
  		page = alloc_pages(flags, s->order);
  	else
@@ -1120,6 +1124,13 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
  		ClearSlabDebug(page);
  	}

+	if (PageTracked(page) && !(s->flags & SLAB_NOTRACK)) {
+		kmemcheck_free_slab(s, page, pages);
+		return;
+	}
+
+	__ClearPageSlab(page);
+
  	mod_zone_page_state(page_zone(page),
  		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
  		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
@@ -1155,7 +1166,6 @@ static void discard_slab(struct kmem_cache *s, struct page *page)

  	atomic_long_dec(&n->nr_slabs);
  	reset_page_mapcount(page);
-	__ClearPageSlab(page);
  	free_slab(s, page);
  }

@@ -1592,6 +1602,7 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
  	if (unlikely((gfpflags & __GFP_ZERO) && object))
  		memset(object, 0, c->objsize);

+	kmemcheck_slab_alloc(s, gfpflags, object);
  	return object;
  }

@@ -1694,6 +1705,8 @@ static __always_inline void slab_free(struct kmem_cache *s,
  	struct kmem_cache_cpu *c;
  	unsigned long flags;

+	kmemcheck_slab_free(s, object);
+
  	local_irq_save(flags);
  	c = get_cpu_slab(s, smp_processor_id());
  	debug_check_no_locks_freed(object, c->objsize);
@@ -2449,12 +2462,10 @@ static int __init setup_slub_nomerge(char *str)
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
@@ -2517,7 +2528,8 @@ static noinline struct kmem_cache *dma_kmalloc_cache(int index, gfp_t flags)

  	if (!s || !text || !kmem_cache_open(s, flags, text,
  			realsize, ARCH_KMALLOC_MINALIGN,
-			SLAB_CACHE_DMA|__SYSFS_ADD_DEFERRED, NULL)) {
+			SLAB_CACHE_DMA|SLAB_NOTRACK|__SYSFS_ADD_DEFERRED,
+			NULL)) {
  		kfree(s);
  		kfree(text);
  		goto unlock_out;
@@ -2910,7 +2922,7 @@ void __init kmem_cache_init(void)
  	 * kmem_cache_open for slab_state == DOWN.
  	 */
  	create_kmalloc_cache(&kmalloc_caches[0], "kmem_cache_node",
-		sizeof(struct kmem_cache_node), GFP_KERNEL);
+		sizeof(struct kmem_cache_node), GFP_KERNEL, 0);
  	kmalloc_caches[0].refcount = -1;
  	caches++;

@@ -2923,18 +2935,18 @@ void __init kmem_cache_init(void)
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

  	for (i = KMALLOC_SHIFT_LOW; i <= PAGE_SHIFT; i++) {
  		create_kmalloc_cache(&kmalloc_caches[i],
-			"kmalloc", 1 << i, GFP_KERNEL);
+			"kmalloc", 1 << i, GFP_KERNEL, 0);
  		caches++;
  	}

@@ -4167,6 +4179,8 @@ static char *create_unique_id(struct kmem_cache *s)
  		*p++ = 'a';
  	if (s->flags & SLAB_DEBUG_FREE)
  		*p++ = 'F';
+	if (!(s->flags & SLAB_NOTRACK))
+		*p++ = 't';
  	if (p != name + 1)
  		*p++ = '-';
  	p += sprintf(p, "%07d", s->size);
diff --git a/mm/slub_kmemcheck.c b/mm/slub_kmemcheck.c
new file mode 100644
index 0000000..ca5f1a9
--- /dev/null
+++ b/mm/slub_kmemcheck.c
@@ -0,0 +1,99 @@
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/kmemcheck.h>
+
+struct page *
+kmemcheck_allocate_slab(struct kmem_cache *s, gfp_t flags, int node, int pages)
+{
+	struct page *page;
+
+	/*
+	 * With kmemcheck enabled, we actually allocate twice as much. The
+	 * upper half of the allocation is used as our shadow memory where
+	 * the status (e.g. initialized/uninitialized) of each byte is
+	 * stored.
+	 */
+
+	flags |= __GFP_COMP;
+
+	if (node == -1)
+		page = alloc_pages(flags, s->order + 1);
+	else
+		page = alloc_pages_node(node, flags, s->order + 1);
+
+	if (!page)
+		return NULL;
+
+	/*
+	 * Mark it as non-present for the MMU so that our accesses to
+	 * this memory will trigger a page fault and let us analyze
+	 * the memory accesses.
+	 */
+	kmemcheck_hide_pages(page, pages);
+
+	/*
+	 * Objects from caches that have a constructor don't get
+	 * cleared when they're allocated, so we need to do it here.
+	 */
+	if (s->ctor)
+		kmemcheck_mark_uninitialized_pages(page, pages);
+	else
+		kmemcheck_mark_unallocated_pages(page, pages);
+
+	mod_zone_page_state(page_zone(page),
+		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
+		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
+		pages + pages);
+
+	return page;
+}
+
+void
+kmemcheck_free_slab(struct kmem_cache *s, struct page *page, int pages)
+{
+	kmemcheck_show_pages(page, pages);
+
+	__ClearPageSlab(page);
+
+	mod_zone_page_state(page_zone(page),
+		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
+		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
+		-pages - pages);
+
+	__free_pages(page, s->order + 1);
+}
+
+void
+kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object)
+{
+	if (gfpflags & __GFP_ZERO)
+		return;
+	if (s->flags & SLAB_NOTRACK)
+		return;
+
+	if (!kmemcheck_enabled || gfpflags & __GFP_NOTRACK) {
+		/*
+		 * Allow notracked objects to be allocated from
+		 * tracked caches. Note however that these objects
+		 * will still get page faults on access, they just
+		 * won't ever be flagged as uninitialized. If page
+		 * faults are not acceptable, the slab cache itself
+		 * should be marked NOTRACK.
+		 */
+		kmemcheck_mark_initialized(object, s->objsize);
+	} else if (!s->ctor) {
+		/*
+		 * New objects should be marked uninitialized before
+		 * they're returned to the called.
+		 */
+		kmemcheck_mark_uninitialized(object, s->objsize);
+	}
+}
+
+void
+kmemcheck_slab_free(struct kmem_cache *s, void *object)
+{
+	/* TODO: RCU freeing is unsupported for now; hide false positives. */
+	if (!s->ctor && !(s->flags & SLAB_DESTROY_BY_RCU))
+		kmemcheck_mark_freed(object, s->objsize);
+}
-- 
1.5.4.1


