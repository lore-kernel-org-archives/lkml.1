Return-Path: <linux-kernel-owner+w=401wt.eu-S1751027AbXCUJWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751027AbXCUJWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 05:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbXCUJWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 05:22:31 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:54003 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbXCUJWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 05:22:30 -0400
Date: Wed, 21 Mar 2007 10:22:31 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <christoph@lameter.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>
Subject: [RFC, PATCH] SLAB : [NUMA] keep nodeid in struct page instead of
 struct slab
Message-Id: <20070321102231.7288f231.dada1@cosmosbay.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In order to avoid a cache miss in kmem_cache_free() on NUMA and reduce hot path length, we could exploit the following common facts.

1) MAX_NUMNODES <= 64

2) alignment of 'struct kmem_cache *' can be >= 64

The following patch changes the page->lru.next to contain not only the 'struct kmem_cache *' pointer, but also the nodeid in the low order bits.

This also reduces sizeof(struct slab) by 8 bytes on 64bits arches.
This reduces sizeof(struct slab) on all platforms (UP, or SMP)

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

diff --git a/mm/slab.c b/mm/slab.c
index abf46ae..d2f7299 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -210,6 +210,16 @@ #define BUFCTL_FREE	(((kmem_bufctl_t)(~0
 #define	BUFCTL_ACTIVE	(((kmem_bufctl_t)(~0U))-2)
 #define	SLAB_LIMIT	(((kmem_bufctl_t)(~0U))-3)
 
+#ifdef CONFIG_NUMA
+#if MAX_NUMNODES <= 64
+/* we can use low order bits of page->lru.next to store nodeids */
+# define KEEP_NODEID_IN_PAGE
+#else
+/* too many nodes, we need a field in 'struct slab' */
+# define KEEP_NODEID_IN_SLAB
+#endif
+#endif
+
 /*
  * struct slab
  *
@@ -223,7 +233,9 @@ struct slab {
 	void *s_mem;		/* including colour offset */
 	unsigned int inuse;	/* num of objs active in slab */
 	kmem_bufctl_t free;
+#ifdef KEEP_NODEID_IN_SLAB
 	unsigned short nodeid;
+#endif
 };
 
 /*
@@ -585,9 +597,18 @@ static int slab_break_gfp_order = BREAK_
  * allocator.  These are used to find the slab an obj belongs to.  With kfree(),
  * these are used to find the cache which an obj belongs to.
  */
-static inline void page_set_cache(struct page *page, struct kmem_cache *cache)
+static inline void page_set_cache_slab_nodeid(struct page *page,
+	struct kmem_cache *cache, struct slab *slab, int nodeid)
 {
+	page->lru.prev = (struct list_head *)slab;
+#ifdef KEEP_NODEID_IN_PAGE
+	page->lru.next = (struct list_head *)((long)cache + nodeid);
+#else
 	page->lru.next = (struct list_head *)cache;
+#endif
+#ifdef KEEP_NODEID_IN_SLAB
+	slab->nodeid = nodeid;
+#endif
 }
 
 static inline struct kmem_cache *page_get_cache(struct page *page)
@@ -595,12 +616,11 @@ static inline struct kmem_cache *page_ge
 	if (unlikely(PageCompound(page)))
 		page = (struct page *)page_private(page);
 	BUG_ON(!PageSlab(page));
+#ifdef KEEP_NODEID_IN_PAGE
+	return (struct kmem_cache *)((long)page->lru.next & ~63);
+#else
 	return (struct kmem_cache *)page->lru.next;
-}
-
-static inline void page_set_slab(struct page *page, struct slab *slab)
-{
-	page->lru.prev = (struct list_head *)slab;
+#endif
 }
 
 static inline struct slab *page_get_slab(struct page *page)
@@ -617,6 +637,18 @@ static inline struct kmem_cache *virt_to
 	return page_get_cache(page);
 }
 
+#ifdef CONFIG_NUMA
+static inline int virt_to_nodeid(const void *obj)
+{
+	struct page *page = virt_to_page(obj);
+#ifdef KEEP_NODEID_IN_SLAB
+	return page_get_slab(page)->nodeid;
+#else
+	return (long)page->lru.next & 63;
+#endif
+}
+#endif
+
 static inline struct slab *virt_to_slab(const void *obj)
 {
 	struct page *page = virt_to_page(obj);
@@ -1134,8 +1166,7 @@ static void drain_alien_cache(struct kme
 
 static inline int cache_free_alien(struct kmem_cache *cachep, void *objp)
 {
-	struct slab *slabp = virt_to_slab(objp);
-	int nodeid = slabp->nodeid;
+	int nodeid = virt_to_nodeid(objp);
 	struct kmem_list3 *l3;
 	struct array_cache *alien = NULL;
 	int node;
@@ -1146,7 +1177,7 @@ static inline int cache_free_alien(struc
 	 * Make sure we are not freeing a object from another node to the array
 	 * cache on this cpu.
 	 */
-	if (likely(slabp->nodeid == node) || unlikely(!use_alien_caches))
+	if (likely(nodeid == node) || unlikely(!use_alien_caches))
 		return 0;
 
 	l3 = cachep->nodelists[node];
@@ -1437,8 +1468,14 @@ void __init kmem_cache_init(void)
 	cache_cache.array[smp_processor_id()] = &initarray_cache.cache;
 	cache_cache.nodelists[node] = &initkmem_list3[CACHE_CACHE];
 
+#ifdef KEEP_NODEID_IN_PAGE
+	/* kmem_cache addresses must be multiple of 64 */
+	cache_cache.buffer_size = ALIGN(cache_cache.buffer_size,
+					max(64, cache_line_size()));
+#else
 	cache_cache.buffer_size = ALIGN(cache_cache.buffer_size,
 					cache_line_size());
+#endif
 	cache_cache.reciprocal_buffer_size =
 		reciprocal_value(cache_cache.buffer_size);
 
@@ -2588,7 +2625,6 @@ static struct slab *alloc_slabmgmt(struc
 	slabp->inuse = 0;
 	slabp->colouroff = colour_off;
 	slabp->s_mem = objp + colour_off;
-	slabp->nodeid = nodeid;
 	return slabp;
 }
 
@@ -2699,7 +2735,7 @@ #endif
  * virtual address for kfree, ksize, kmem_ptr_validate, and slab debugging.
  */
 static void slab_map_pages(struct kmem_cache *cache, struct slab *slab,
-			   void *addr)
+			   void *addr, int nodeid)
 {
 	int nr_pages;
 	struct page *page;
@@ -2711,8 +2747,7 @@ static void slab_map_pages(struct kmem_c
 		nr_pages <<= cache->gfporder;
 
 	do {
-		page_set_cache(page, cache);
-		page_set_slab(page, slab);
+		page_set_cache_slab_nodeid(page, cache, slab, nodeid);
 		page++;
 	} while (--nr_pages);
 }
@@ -2787,8 +2822,7 @@ static int cache_grow(struct kmem_cache 
 	if (!slabp)
 		goto opps1;
 
-	slabp->nodeid = nodeid;
-	slab_map_pages(cachep, slabp, objp);
+	slab_map_pages(cachep, slabp, objp, nodeid);
 
 	cache_init_objs(cachep, slabp, ctor_flags);
 
