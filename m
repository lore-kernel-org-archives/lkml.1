Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbZFQGKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbZFQGKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 02:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbZFQGKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 02:10:11 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35536 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbZFQGKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 02:10:09 -0400
Date: Wed, 17 Jun 2009 09:10:09 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, a.beregalov@gmail.com, adobriyan@gmail.com,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, fengguang.wu@intel.com, heiko.carstens@de.ibm.com,
       kosaki.motohiro@jp.fujitsu.com, Larry.Finger@lwfinger.net,
       mel@csn.ul.ie, mingo@elte.hu, mpm@selenic.com, npiggin@suse.de,
       ron@debian.org
Subject: [GIT PULL] SLAB updates for 2.6.31-rc1
Message-ID: <Pine.LNX.4.64.0906170906440.28840@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are some slab allocator updates accumulated over the past few months. The
most important one of them is the early-boot GFP_DMA allocation fix from Nick
which is required by s390 boot code.

			Pekka

The following changes since commit 65795efbd380a832ae508b04dba8f8e53f0b84d9:
  Linus Torvalds (1):
        Merge branch 'next-i2c' of git://aeryn.fluff.org.uk/bjdooks/linux

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6 for-linus

Alexander Beregalov (1):
      SLUB: fix build when !SLUB_DEBUG

Nick Piggin (1):
      SLUB: Fix early boot GFP_DMA allocations

Pekka Enberg (5):
      slab: document kzfree() zeroing behavior
      SLUB: Out-of-memory diagnostics
      SLUB: Don't print out OOM warning for __GFP_NOFAIL
      Merge branches 'slab/documentation', 'slab/fixes', 'slob/cleanups' and 'slub/fixes' into for-linus
      Merge branch 'slub/earlyboot' into for-linus

Ron Lee (1):
      slab: fix generic PAGE_POISONING conflict with SLAB_RED_ZONE

Wu Fengguang (1):
      slob: use PG_slab for identifying SLOB pages

 include/linux/page-flags.h |    2 -
 mm/slab.c                  |    9 ++++
 mm/slob.c                  |    6 +-
 mm/slub.c                  |  105 ++++++++++++++++++++++++++++++++++----------
 mm/util.c                  |    4 ++
 5 files changed, 98 insertions(+), 28 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index d6792f8..e2e5ce5 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -118,7 +118,6 @@ enum pageflags {
 	PG_savepinned = PG_dirty,
 
 	/* SLOB */
-	PG_slob_page = PG_active,
 	PG_slob_free = PG_private,
 
 	/* SLUB */
@@ -201,7 +200,6 @@ PAGEFLAG(SavePinned, savepinned);			/* Xen */
 PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
 PAGEFLAG(SwapBacked, swapbacked) __CLEARPAGEFLAG(SwapBacked, swapbacked)
 
-__PAGEFLAG(SlobPage, slob_page)
 __PAGEFLAG(SlobFree, slob_free)
 
 __PAGEFLAG(SlubFrozen, slub_frozen)
diff --git a/mm/slab.c b/mm/slab.c
index f257d4d..d086923 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2308,6 +2308,15 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 		/* really off slab. No need for manual alignment */
 		slab_size =
 		    cachep->num * sizeof(kmem_bufctl_t) + sizeof(struct slab);
+
+#ifdef CONFIG_PAGE_POISONING
+		/* If we're going to use the generic kernel_map_pages()
+		 * poisoning, then it's going to smash the contents of
+		 * the redzone and userword anyhow, so switch them off.
+		 */
+		if (size % PAGE_SIZE == 0 && flags & SLAB_POISON)
+			flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
+#endif
 	}
 
 	cachep->colour_off = cache_line_size();
diff --git a/mm/slob.c b/mm/slob.c
index 64f6db1..c78742d 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -133,17 +133,17 @@ static LIST_HEAD(free_slob_large);
  */
 static inline int is_slob_page(struct slob_page *sp)
 {
-	return PageSlobPage((struct page *)sp);
+	return PageSlab((struct page *)sp);
 }
 
 static inline void set_slob_page(struct slob_page *sp)
 {
-	__SetPageSlobPage((struct page *)sp);
+	__SetPageSlab((struct page *)sp);
 }
 
 static inline void clear_slob_page(struct slob_page *sp)
 {
-	__ClearPageSlobPage((struct page *)sp);
+	__ClearPageSlab((struct page *)sp);
 }
 
 static inline struct slob_page *slob_page(const void *addr)
diff --git a/mm/slub.c b/mm/slub.c
index 2701419..4c64493 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -840,6 +840,11 @@ static inline unsigned long slabs_node(struct kmem_cache *s, int node)
 	return atomic_long_read(&n->nr_slabs);
 }
 
+static inline unsigned long node_nr_slabs(struct kmem_cache_node *n)
+{
+	return atomic_long_read(&n->nr_slabs);
+}
+
 static inline void inc_slabs_node(struct kmem_cache *s, int node, int objects)
 {
 	struct kmem_cache_node *n = get_node(s, node);
@@ -1058,6 +1063,8 @@ static inline unsigned long kmem_cache_flags(unsigned long objsize,
 
 static inline unsigned long slabs_node(struct kmem_cache *s, int node)
 							{ return 0; }
+static inline unsigned long node_nr_slabs(struct kmem_cache_node *n)
+							{ return 0; }
 static inline void inc_slabs_node(struct kmem_cache *s, int node,
 							int objects) {}
 static inline void dec_slabs_node(struct kmem_cache *s, int node,
@@ -1514,6 +1521,65 @@ static inline int node_match(struct kmem_cache_cpu *c, int node)
 	return 1;
 }
 
+static int count_free(struct page *page)
+{
+	return page->objects - page->inuse;
+}
+
+static unsigned long count_partial(struct kmem_cache_node *n,
+					int (*get_count)(struct page *))
+{
+	unsigned long flags;
+	unsigned long x = 0;
+	struct page *page;
+
+	spin_lock_irqsave(&n->list_lock, flags);
+	list_for_each_entry(page, &n->partial, lru)
+		x += get_count(page);
+	spin_unlock_irqrestore(&n->list_lock, flags);
+	return x;
+}
+
+static inline unsigned long node_nr_objs(struct kmem_cache_node *n)
+{
+#ifdef CONFIG_SLUB_DEBUG
+	return atomic_long_read(&n->total_objects);
+#else
+	return 0;
+#endif
+}
+
+static noinline void
+slab_out_of_memory(struct kmem_cache *s, gfp_t gfpflags, int nid)
+{
+	int node;
+
+	printk(KERN_WARNING
+		"SLUB: Unable to allocate memory on node %d (gfp=0x%x)\n",
+		nid, gfpflags);
+	printk(KERN_WARNING "  cache: %s, object size: %d, buffer size: %d, "
+		"default order: %d, min order: %d\n", s->name, s->objsize,
+		s->size, oo_order(s->oo), oo_order(s->min));
+
+	for_each_online_node(node) {
+		struct kmem_cache_node *n = get_node(s, node);
+		unsigned long nr_slabs;
+		unsigned long nr_objs;
+		unsigned long nr_free;
+
+		if (!n)
+			continue;
+
+		nr_free  = count_partial(n, count_free);
+		nr_slabs = node_nr_slabs(n);
+		nr_objs  = node_nr_objs(n);
+
+		printk(KERN_WARNING
+			"  node %d: slabs: %ld, objs: %ld, free: %ld\n",
+			node, nr_slabs, nr_objs, nr_free);
+	}
+}
+
 /*
  * Slow path. The lockless freelist is empty or we need to perform
  * debugging duties.
@@ -1595,6 +1661,8 @@ new_slab:
 		c->page = new;
 		goto load_freelist;
 	}
+	if (!(gfpflags & __GFP_NOWARN) && printk_ratelimit())
+		slab_out_of_memory(s, gfpflags, node);
 	return NULL;
 debug:
 	if (!alloc_debug_processing(s, c->page, object, addr))
@@ -2636,6 +2704,7 @@ static noinline struct kmem_cache *dma_kmalloc_cache(int index, gfp_t flags)
 	struct kmem_cache *s;
 	char *text;
 	size_t realsize;
+	unsigned long slabflags;
 
 	s = kmalloc_caches_dma[index];
 	if (s)
@@ -2657,10 +2726,18 @@ static noinline struct kmem_cache *dma_kmalloc_cache(int index, gfp_t flags)
 			 (unsigned int)realsize);
 	s = kmalloc(kmem_size, flags & ~SLUB_DMA);
 
+	/*
+	 * Must defer sysfs creation to a workqueue because we don't know
+	 * what context we are called from. Before sysfs comes up, we don't
+	 * need to do anything because our sysfs initcall will start by
+	 * adding all existing slabs to sysfs.
+	 */
+	slabflags = SLAB_CACHE_DMA|SLAB_NOTRACK;
+	if (slab_state >= SYSFS)
+		slabflags |= __SYSFS_ADD_DEFERRED;
+
 	if (!s || !text || !kmem_cache_open(s, flags, text,
-			realsize, ARCH_KMALLOC_MINALIGN,
-			SLAB_CACHE_DMA|SLAB_NOTRACK|__SYSFS_ADD_DEFERRED,
-			NULL)) {
+			realsize, ARCH_KMALLOC_MINALIGN, slabflags, NULL)) {
 		kfree(s);
 		kfree(text);
 		goto unlock_out;
@@ -2669,7 +2746,8 @@ static noinline struct kmem_cache *dma_kmalloc_cache(int index, gfp_t flags)
 	list_add(&s->list, &slab_caches);
 	kmalloc_caches_dma[index] = s;
 
-	schedule_work(&sysfs_add_work);
+	if (slab_state >= SYSFS)
+		schedule_work(&sysfs_add_work);
 
 unlock_out:
 	up_write(&slub_lock);
@@ -3368,20 +3446,6 @@ void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
 }
 
 #ifdef CONFIG_SLUB_DEBUG
-static unsigned long count_partial(struct kmem_cache_node *n,
-					int (*get_count)(struct page *))
-{
-	unsigned long flags;
-	unsigned long x = 0;
-	struct page *page;
-
-	spin_lock_irqsave(&n->list_lock, flags);
-	list_for_each_entry(page, &n->partial, lru)
-		x += get_count(page);
-	spin_unlock_irqrestore(&n->list_lock, flags);
-	return x;
-}
-
 static int count_inuse(struct page *page)
 {
 	return page->inuse;
@@ -3392,11 +3456,6 @@ static int count_total(struct page *page)
 	return page->objects;
 }
 
-static int count_free(struct page *page)
-{
-	return page->objects - page->inuse;
-}
-
 static int validate_slab(struct kmem_cache *s, struct page *page,
 						unsigned long *map)
 {
diff --git a/mm/util.c b/mm/util.c
index d5d2213..7c35ad9 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -168,6 +168,10 @@ EXPORT_SYMBOL(krealloc);
  *
  * The memory of the object @p points to is zeroed before freed.
  * If @p is %NULL, kzfree() does nothing.
+ *
+ * Note: this function zeroes the whole allocated buffer which can be a good
+ * deal bigger than the requested buffer size passed to kmalloc(). So be
+ * careful when using this function in performance sensitive code.
  */
 void kzfree(const void *p)
 {
