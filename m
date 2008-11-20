Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbYKTLbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbYKTLbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbYKTLau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:30:50 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:47329 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755237AbYKTLas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:30:48 -0500
Subject: [PATCH 2.6.28-rc5 03/11] kmemleak: Add the memory allocation/freeing
	hooks
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 20 Nov 2008 11:30:45 +0000
Message-ID: <20081120113045.16607.7462.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.286.g8983
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Nov 2008 11:30:45.0697 (UTC) FILETIME=[6DDD3B10:01C94B03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the callbacks to memleak_(alloc|free) functions from
kmalloc/kfree, kmem_cache_(alloc|free), vmalloc/vfree etc.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/page_alloc.c |    3 +++
 mm/slab.c       |    9 +++++++++
 mm/slob.c       |   15 +++++++++++----
 mm/slub.c       |    3 +++
 mm/vmalloc.c    |   25 ++++++++++++++++++++++---
 5 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d8ac014..90e7dbd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -46,6 +46,7 @@
 #include <linux/page-isolation.h>
 #include <linux/page_cgroup.h>
 #include <linux/debugobjects.h>
+#include <linux/memleak.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -4570,6 +4571,8 @@ void *__init alloc_large_system_hash(const char *tablename,
 	if (_hash_mask)
 		*_hash_mask = (1 << log2qty) - 1;
 
+	memleak_alloc(table, size, 1);
+
 	return table;
 }
 
diff --git a/mm/slab.c b/mm/slab.c
index 0918751..ea76bcb 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -112,6 +112,7 @@
 #include	<linux/rtmutex.h>
 #include	<linux/reciprocal_div.h>
 #include	<linux/debugobjects.h>
+#include	<linux/memleak.h>
 
 #include	<asm/cacheflush.h>
 #include	<asm/tlbflush.h>
@@ -2610,6 +2611,9 @@ static struct slab *alloc_slabmgmt(struct kmem_cache *cachep, void *objp,
 		/* Slab management obj is off-slab. */
 		slabp = kmem_cache_alloc_node(cachep->slabp_cache,
 					      local_flags & ~GFP_THISNODE, nodeid);
+		/* only scan the list member to avoid false negatives */
+		memleak_scan_area(slabp, offsetof(struct slab, list),
+				  sizeof(struct list_head));
 		if (!slabp)
 			return NULL;
 	} else {
@@ -3195,6 +3199,8 @@ static inline void *____cache_alloc(struct kmem_cache *cachep, gfp_t flags)
 		STATS_INC_ALLOCMISS(cachep);
 		objp = cache_alloc_refill(cachep, flags);
 	}
+	/* avoid false negatives */
+	memleak_erase(&ac->entry[ac->avail]);
 	return objp;
 }
 
@@ -3412,6 +3418,7 @@ __cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
   out:
 	local_irq_restore(save_flags);
 	ptr = cache_alloc_debugcheck_after(cachep, flags, ptr, caller);
+	memleak_alloc(ptr, obj_size(cachep), 1);
 
 	if (unlikely((flags & __GFP_ZERO) && ptr))
 		memset(ptr, 0, obj_size(cachep));
@@ -3465,6 +3472,7 @@ __cache_alloc(struct kmem_cache *cachep, gfp_t flags, void *caller)
 	objp = __do_cache_alloc(cachep, flags);
 	local_irq_restore(save_flags);
 	objp = cache_alloc_debugcheck_after(cachep, flags, objp, caller);
+	memleak_alloc(objp, obj_size(cachep), 1);
 	prefetchw(objp);
 
 	if (unlikely((flags & __GFP_ZERO) && objp))
@@ -3580,6 +3588,7 @@ static inline void __cache_free(struct kmem_cache *cachep, void *objp)
 	struct array_cache *ac = cpu_cache_get(cachep);
 
 	check_irq_off();
+	memleak_free(objp);
 	objp = cache_free_debugcheck(cachep, objp, __builtin_return_address(0));
 
 	/*
diff --git a/mm/slob.c b/mm/slob.c
index cb675d1..062e967 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -65,6 +65,7 @@
 #include <linux/module.h>
 #include <linux/rcupdate.h>
 #include <linux/list.h>
+#include <linux/memleak.h>
 #include <asm/atomic.h>
 
 /*
@@ -463,6 +464,7 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 {
 	unsigned int *m;
 	int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
+	void *ret;
 
 	if (size < PAGE_SIZE - align) {
 		if (!size)
@@ -472,18 +474,18 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 		if (!m)
 			return NULL;
 		*m = size;
-		return (void *)m + align;
+		ret = (void *)m + align;
 	} else {
-		void *ret;
-
 		ret = slob_new_page(gfp | __GFP_COMP, get_order(size), node);
 		if (ret) {
 			struct page *page;
 			page = virt_to_page(ret);
 			page->private = size;
 		}
-		return ret;
 	}
+
+	memleak_alloc(ret, size, 1);
+	return ret;
 }
 EXPORT_SYMBOL(__kmalloc_node);
 
@@ -493,6 +495,7 @@ void kfree(const void *block)
 
 	if (unlikely(ZERO_OR_NULL_PTR(block)))
 		return;
+	memleak_free(block);
 
 	sp = (struct slob_page *)virt_to_page(block);
 	if (slob_page(sp)) {
@@ -555,12 +558,14 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 	} else if (flags & SLAB_PANIC)
 		panic("Cannot create slab cache %s\n", name);
 
+	memleak_alloc(c, sizeof(struct kmem_cache), 1);
 	return c;
 }
 EXPORT_SYMBOL(kmem_cache_create);
 
 void kmem_cache_destroy(struct kmem_cache *c)
 {
+	memleak_free(c);
 	slob_free(c, sizeof(struct kmem_cache));
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
@@ -577,6 +582,7 @@ void *kmem_cache_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 	if (c->ctor)
 		c->ctor(b);
 
+	memleak_alloc(b, c->size, 1);
 	return b;
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node);
@@ -599,6 +605,7 @@ static void kmem_rcu_free(struct rcu_head *head)
 
 void kmem_cache_free(struct kmem_cache *c, void *b)
 {
+	memleak_free(b);
 	if (unlikely(c->flags & SLAB_DESTROY_BY_RCU)) {
 		struct slob_rcu *slob_rcu;
 		slob_rcu = b + (c->size - sizeof(struct slob_rcu));
diff --git a/mm/slub.c b/mm/slub.c
index 7ad489a..e84ed0d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -24,6 +24,7 @@
 #include <linux/kallsyms.h>
 #include <linux/memory.h>
 #include <linux/math64.h>
+#include <linux/memleak.h>
 
 /*
  * Lock order:
@@ -1608,6 +1609,7 @@ static __always_inline void *slab_alloc(struct kmem_cache *s,
 	if (unlikely((gfpflags & __GFP_ZERO) && object))
 		memset(object, 0, objsize);
 
+	memleak_alloc(object, objsize, 1);
 	return object;
 }
 
@@ -1710,6 +1712,7 @@ static __always_inline void slab_free(struct kmem_cache *s,
 	struct kmem_cache_cpu *c;
 	unsigned long flags;
 
+	memleak_free(x);
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
 	debug_check_no_locks_freed(object, c->objsize);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ba6b0f5..e053875 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -23,6 +23,7 @@
 #include <linux/rbtree.h>
 #include <linux/radix-tree.h>
 #include <linux/rcupdate.h>
+#include <linux/memleak.h>
 
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
@@ -1173,6 +1174,9 @@ static void __vunmap(const void *addr, int deallocate_pages)
 void vfree(const void *addr)
 {
 	BUG_ON(in_interrupt());
+
+	memleak_free(addr);
+
 	__vunmap(addr, 1);
 }
 EXPORT_SYMBOL(vfree);
@@ -1282,8 +1286,15 @@ fail:
 
 void *__vmalloc_area(struct vm_struct *area, gfp_t gfp_mask, pgprot_t prot)
 {
-	return __vmalloc_area_node(area, gfp_mask, prot, -1,
-					__builtin_return_address(0));
+	void *addr = __vmalloc_area_node(area, gfp_mask, prot, -1,
+					 __builtin_return_address(0));
+
+	/* this needs ref_count = 2 since vm_struct also contains a
+	 * pointer to this address. The guard page is also subtracted
+	 * from the size */
+	memleak_alloc(addr, area->size - PAGE_SIZE, 2);
+
+	return addr;
 }
 
 /**
@@ -1302,6 +1313,8 @@ static void *__vmalloc_node(unsigned long size, gfp_t gfp_mask, pgprot_t prot,
 						int node, void *caller)
 {
 	struct vm_struct *area;
+	void *addr;
+	unsigned long real_size = size;
 
 	size = PAGE_ALIGN(size);
 	if (!size || (size >> PAGE_SHIFT) > num_physpages)
@@ -1313,7 +1326,13 @@ static void *__vmalloc_node(unsigned long size, gfp_t gfp_mask, pgprot_t prot,
 	if (!area)
 		return NULL;
 
-	return __vmalloc_area_node(area, gfp_mask, prot, node, caller);
+	addr = __vmalloc_area_node(area, gfp_mask, prot, node, caller);
+
+	/* this needs ref_count = 2 since the vm_struct also contains
+	 * a pointer to this address */
+	memleak_alloc(addr, real_size, 2);
+
+	return addr;
 }
 
 void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot)

