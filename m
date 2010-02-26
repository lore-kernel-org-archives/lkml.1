Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935350Ab0BZGfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 01:35:39 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:57872 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935284Ab0BZGfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 01:35:37 -0500
Message-Id: <201002260635.o1Q6ZYET040848@www262.sakura.ne.jp>
Subject: [RFC][PATCH] mm: Remove ZERO_SIZE_PTR.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Feb 2010 15:35:34 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 25022010 #3421183, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[RFC][PATCH] mm: Remove ZERO_SIZE_PTR.

kmalloc() and friends are sometimes used in a way

	struct foo *ptr = kmalloc(size + sizeof(struct foo), GFP_KERNEL);
	if (!ptr)
		return -ENOMEM;
	ptr->size = size;
	...
	return 0;

Everybody should check for ptr != NULL, and most callers are actually checking
for ptr != NULL. But nobody is checking for ptr != ZERO_SIZE_PTR.

If caller passed 0 as size argument by error (e.g. integer overflow bug),
the caller will start writing against address starting from ZERO_SIZE_PTR
because the caller assumes that "size + sizeof(struct foo)" bytes of memory is
successfully allocated. (kstrdup() is an example, although it will be
impossible to pass s where strlen(s) == (size_t) -1 .)

Yes, this is the fault of caller. But ZERO_SIZE_PTR is too small value to
distinguish "NULL pointer dereference" and "ZERO_SIZE_PTR dereference" because
address printed by oops message can easily exceed ZERO_SIZE_PTR when
"struct foo" is large.

Therefore, at the cost of being unable to distinguish "NULL pointer
dereference" and "ZERO_SIZE_PTR dereference" in some cases, removing
ZERO_SIZE_PTR could reduce the risk of "ZERO_SIZE_PTR dereference" in many
cases.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 include/linux/slab.h     |   12 ------------
 include/linux/slab_def.h |    4 ++--
 include/linux/slub_def.h |    4 ++--
 mm/slab.c                |   12 +++++-------
 mm/slob.c                |    8 +++-----
 mm/slub.c                |   15 ++++++---------
 mm/util.c                |    6 +++---
 7 files changed, 21 insertions(+), 40 deletions(-)

--- linux-2.6.33.orig/include/linux/slab.h
+++ linux-2.6.33/include/linux/slab.h
@@ -74,18 +74,6 @@
 /* The following flags affect the page allocator grouping pages by mobility */
 #define SLAB_RECLAIM_ACCOUNT	0x00020000UL		/* Objects are reclaimable */
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
-/*
- * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
- *
- * Dereferencing ZERO_SIZE_PTR will lead to a distinct access fault.
- *
- * ZERO_SIZE_PTR can be passed to kfree though in the same way that NULL can.
- * Both make kfree a no-op.
- */
-#define ZERO_SIZE_PTR ((void *)16)
-
-#define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) <= \
-				(unsigned long)ZERO_SIZE_PTR)
 
 /*
  * struct kmem_cache related prototypes
--- linux-2.6.33.orig/include/linux/slab_def.h
+++ linux-2.6.33/include/linux/slab_def.h
@@ -134,7 +134,7 @@ static __always_inline void *kmalloc(siz
 		int i = 0;
 
 		if (!size)
-			return ZERO_SIZE_PTR;
+			return NULL;
 
 #define CACHE(x) \
 		if (size <= x) \
@@ -189,7 +189,7 @@ static __always_inline void *kmalloc_nod
 		int i = 0;
 
 		if (!size)
-			return ZERO_SIZE_PTR;
+			return NULL;
 
 #define CACHE(x) \
 		if (size <= x) \
--- linux-2.6.33.orig/include/linux/slub_def.h
+++ linux-2.6.33/include/linux/slub_def.h
@@ -250,7 +250,7 @@ static __always_inline void *kmalloc(siz
 			struct kmem_cache *s = kmalloc_slab(size);
 
 			if (!s)
-				return ZERO_SIZE_PTR;
+				return NULL;
 
 			ret = kmem_cache_alloc_notrace(s, flags);
 
@@ -289,7 +289,7 @@ static __always_inline void *kmalloc_nod
 			struct kmem_cache *s = kmalloc_slab(size);
 
 		if (!s)
-			return ZERO_SIZE_PTR;
+			return NULL;
 
 		ret = kmem_cache_alloc_node_notrace(s, flags, node);
 
--- linux-2.6.33.orig/mm/slab.c
+++ linux-2.6.33/mm/slab.c
@@ -717,7 +717,7 @@ static inline struct kmem_cache *__find_
 	BUG_ON(malloc_sizes[INDEX_AC].cs_cachep == NULL);
 #endif
 	if (!size)
-		return ZERO_SIZE_PTR;
+		return NULL;
 
 	while (size > csizep->cs_size)
 		csizep++;
@@ -2346,7 +2346,7 @@ kmem_cache_create (const char *name, siz
 		 * this should not happen at all.
 		 * But leave a BUG_ON for some lucky dude.
 		 */
-		BUG_ON(ZERO_OR_NULL_PTR(cachep->slabp_cache));
+		BUG_ON(!cachep->slabp_cache);
 	}
 	cachep->ctor = ctor;
 	cachep->name = name;
@@ -3661,7 +3661,7 @@ __do_kmalloc_node(size_t size, gfp_t fla
 	void *ret;
 
 	cachep = kmem_find_general_cachep(size, flags);
-	if (unlikely(ZERO_OR_NULL_PTR(cachep)))
+	if (unlikely(!cachep))
 		return cachep;
 	ret = kmem_cache_alloc_node_notrace(cachep, flags, node);
 
@@ -3712,7 +3712,7 @@ static __always_inline void *__do_kmallo
 	 * functions.
 	 */
 	cachep = __find_general_cachep(size, flags);
-	if (unlikely(ZERO_OR_NULL_PTR(cachep)))
+	if (unlikely(!cachep))
 		return cachep;
 	ret = __cache_alloc(cachep, flags, caller);
 
@@ -3783,7 +3783,7 @@ void kfree(const void *objp)
 
 	trace_kfree(_RET_IP_, objp);
 
-	if (unlikely(ZERO_OR_NULL_PTR(objp)))
+	if (unlikely(!objp))
 		return;
 	local_irq_save(flags);
 	kfree_debugcheck(objp);
@@ -4519,8 +4519,6 @@ module_init(slab_proc_init);
 size_t ksize(const void *objp)
 {
 	BUG_ON(!objp);
-	if (unlikely(objp == ZERO_SIZE_PTR))
-		return 0;
 
 	return obj_size(virt_to_cache(objp));
 }
--- linux-2.6.33.orig/mm/slob.c
+++ linux-2.6.33/mm/slob.c
@@ -395,7 +395,7 @@ static void slob_free(void *block, int s
 	slobidx_t units;
 	unsigned long flags;
 
-	if (unlikely(ZERO_OR_NULL_PTR(block)))
+	if (unlikely(!block))
 		return;
 	BUG_ON(!size);
 
@@ -485,7 +485,7 @@ void *__kmalloc_node(size_t size, gfp_t 
 
 	if (size < PAGE_SIZE - align) {
 		if (!size)
-			return ZERO_SIZE_PTR;
+			return NULL;
 
 		m = slob_alloc(size + align, gfp, align, node);
 
@@ -521,7 +521,7 @@ void kfree(const void *block)
 
 	trace_kfree(_RET_IP_, block);
 
-	if (unlikely(ZERO_OR_NULL_PTR(block)))
+	if (unlikely(!block))
 		return;
 	kmemleak_free(block);
 
@@ -541,8 +541,6 @@ size_t ksize(const void *block)
 	struct slob_page *sp;
 
 	BUG_ON(!block);
-	if (unlikely(block == ZERO_SIZE_PTR))
-		return 0;
 
 	sp = slob_page(block);
 	if (is_slob_page(sp)) {
--- linux-2.6.33.orig/mm/slub.c
+++ linux-2.6.33/mm/slub.c
@@ -2836,7 +2836,7 @@ static struct kmem_cache *get_slab(size_
 
 	if (size <= 192) {
 		if (!size)
-			return ZERO_SIZE_PTR;
+			return NULL;
 
 		index = size_index[size_index_elem(size)];
 	} else
@@ -2860,7 +2860,7 @@ void *__kmalloc(size_t size, gfp_t flags
 
 	s = get_slab(size, flags);
 
-	if (unlikely(ZERO_OR_NULL_PTR(s)))
+	if (unlikely(!s))
 		return s;
 
 	ret = slab_alloc(s, flags, -1, _RET_IP_);
@@ -2903,7 +2903,7 @@ void *__kmalloc_node(size_t size, gfp_t 
 
 	s = get_slab(size, flags);
 
-	if (unlikely(ZERO_OR_NULL_PTR(s)))
+	if (unlikely(!s))
 		return s;
 
 	ret = slab_alloc(s, flags, node, _RET_IP_);
@@ -2920,9 +2920,6 @@ size_t ksize(const void *object)
 	struct page *page;
 	struct kmem_cache *s;
 
-	if (unlikely(object == ZERO_SIZE_PTR))
-		return 0;
-
 	page = virt_to_head_page(object);
 
 	if (unlikely(!PageSlab(page))) {
@@ -2961,7 +2958,7 @@ void kfree(const void *x)
 
 	trace_kfree(_RET_IP_, x);
 
-	if (unlikely(ZERO_OR_NULL_PTR(x)))
+	if (unlikely(!x))
 		return;
 
 	page = virt_to_head_page(x);
@@ -3468,7 +3465,7 @@ void *__kmalloc_track_caller(size_t size
 
 	s = get_slab(size, gfpflags);
 
-	if (unlikely(ZERO_OR_NULL_PTR(s)))
+	if (unlikely(!s))
 		return s;
 
 	ret = slab_alloc(s, gfpflags, -1, caller);
@@ -3490,7 +3487,7 @@ void *__kmalloc_node_track_caller(size_t
 
 	s = get_slab(size, gfpflags);
 
-	if (unlikely(ZERO_OR_NULL_PTR(s)))
+	if (unlikely(!s))
 		return s;
 
 	ret = slab_alloc(s, gfpflags, node, caller);
--- linux-2.6.33.orig/mm/util.c
+++ linux-2.6.33/mm/util.c
@@ -118,7 +118,7 @@ void *__krealloc(const void *p, size_t n
 	size_t ks = 0;
 
 	if (unlikely(!new_size))
-		return ZERO_SIZE_PTR;
+		return NULL;
 
 	if (p)
 		ks = ksize(p);
@@ -151,7 +151,7 @@ void *krealloc(const void *p, size_t new
 
 	if (unlikely(!new_size)) {
 		kfree(p);
-		return ZERO_SIZE_PTR;
+		return NULL;
 	}
 
 	ret = __krealloc(p, new_size, flags);
@@ -178,7 +178,7 @@ void kzfree(const void *p)
 	size_t ks;
 	void *mem = (void *)p;
 
-	if (unlikely(ZERO_OR_NULL_PTR(mem)))
+	if (unlikely(!mem))
 		return;
 	ks = ksize(mem);
 	memset(mem, 0, ks);
