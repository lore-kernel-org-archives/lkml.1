Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbXGHJzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbXGHJzA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 05:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbXGHJyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 05:54:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39322 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbXGHJyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 05:54:51 -0400
Date: Sun, 8 Jul 2007 11:54:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, suresh.b.siddha@intel.com,
       corey.d.gough@intel.com, Pekka Enberg <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, Matt Mackall <mpm@selenic.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
Message-ID: <20070708095422.GA2744@elte.hu>
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com> <20070708075119.GA16631@elte.hu> <4690B1A4.4010703@yahoo.com.au>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <4690B1A4.4010703@yahoo.com.au>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> I said exactly the same thing last time this came up. I would love to 
> remove code if its functionality can be adequately replaced by 
> existing code, but I think your reasons for removing SLOB aren't that 
> good, and just handwaving away the significant memory savings doesn't 
> work.

yeah. Also, the decision here is pretty easy: the behavior of the 
allocator is not really visible to applications. So this isnt like 
having a parallel IO scheduler or a parallel process scheduler (which 
cause problems to us by fragmenting the application space) - so the 
long-term cost to us kernel maintainers should be relatively low.

> > A year ago the -rt kernel defaulted to the SLOB for a few releases, 
> > and barring some initial scalability issues (which were solved in 
> > -rt) it worked pretty well on generic PCs, so i dont buy the 'it 
> > doesnt work' argument either.
> 
> It's actually recently been made to work on SMP, it is much more 
> scalable to large memories, and some initial NUMA work is happening 
> that some embedded guys are interested in, all without increasing 
> static footprint too much, and it has actually decreased dynamic 
> footprint too.

cool. I was referring to something else: people were running -rt on 
their beefy desktop boxes with several gigs of RAM they complained about 
the slowdown that is caused by SLOB's linear list walking.

Steve Rostedt did two nice changes to fix those scalability problems. 
I've attached Steve's two patches. With these in place SLOB was very 
usable for large systems as well, with no measurable overhead. 
(obviously the lack of per-cpu caching can still be measured, but it's a 
lot less of a problem in practice than the linear list walking was.)

	Ingo

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="slob-scale-no-bigblock-list.patch"

This patch uses the mem_map pages to find the bigblock descriptor for
large allocations.

-- Steve

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

 mm/slob.c |   74 ++++++++++++++++++++++++++++++++++----------------------------
 1 file changed, 41 insertions(+), 33 deletions(-)

Index: linux/mm/slob.c
===================================================================
--- linux.orig/mm/slob.c
+++ linux/mm/slob.c
@@ -49,15 +49,42 @@ typedef struct slob_block slob_t;
 struct bigblock {
 	int order;
 	void *pages;
-	struct bigblock *next;
 };
 typedef struct bigblock bigblock_t;
 
 static slob_t arena = { .next = &arena, .units = 1 };
 static slob_t *slobfree = &arena;
-static bigblock_t *bigblocks;
 static DEFINE_SPINLOCK(slob_lock);
-static DEFINE_SPINLOCK(block_lock);
+
+#define __get_slob_block(b) ((unsigned long)(b) & ~(PAGE_SIZE-1))
+
+static inline struct page *get_slob_page(const void *mem)
+{
+	void *virt = (void*)__get_slob_block(mem);
+
+	return virt_to_page(virt);
+}
+
+static inline void zero_slob_block(const void *b)
+{
+	struct page *page;
+	page = get_slob_page(b);
+	memset(&page->lru, 0, sizeof(page->lru));
+}
+
+static inline void *get_slob_block(const void *b)
+{
+	struct page *page;
+	page = get_slob_page(b);
+	return page->lru.next;
+}
+
+static inline void set_slob_block(const void *b, void *data)
+{
+	struct page *page;
+	page = get_slob_page(b);
+	page->lru.next = data;
+}
 
 static void slob_free(void *b, int size);
 static void slob_timer_cbk(void);
@@ -109,6 +136,7 @@ static void *slob_alloc(size_t size, gfp
 			if (!cur)
 				return 0;
 
+			zero_slob_block(cur);
 			slob_free(cur, PAGE_SIZE);
 			spin_lock_irqsave(&slob_lock, flags);
 			cur = slobfree;
@@ -163,7 +191,6 @@ void *__kmalloc(size_t size, gfp_t gfp)
 {
 	slob_t *m;
 	bigblock_t *bb;
-	unsigned long flags;
 
 	if (size < PAGE_SIZE - SLOB_UNIT) {
 		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
@@ -178,10 +205,7 @@ void *__kmalloc(size_t size, gfp_t gfp)
 	bb->pages = (void *)__get_free_pages(gfp, bb->order);
 
 	if (bb->pages) {
-		spin_lock_irqsave(&block_lock, flags);
-		bb->next = bigblocks;
-		bigblocks = bb;
-		spin_unlock_irqrestore(&block_lock, flags);
+		set_slob_block(bb->pages, bb);
 		return bb->pages;
 	}
 
@@ -192,25 +216,16 @@ EXPORT_SYMBOL(__kmalloc);
 
 void kfree(const void *block)
 {
-	bigblock_t *bb, **last = &bigblocks;
-	unsigned long flags;
+	bigblock_t *bb;
 
 	if (!block)
 		return;
 
-	if (!((unsigned long)block & (PAGE_SIZE-1))) {
-		/* might be on the big block list */
-		spin_lock_irqsave(&block_lock, flags);
-		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
-			if (bb->pages == block) {
-				*last = bb->next;
-				spin_unlock_irqrestore(&block_lock, flags);
-				free_pages((unsigned long)block, bb->order);
-				slob_free(bb, sizeof(bigblock_t));
-				return;
-			}
-		}
-		spin_unlock_irqrestore(&block_lock, flags);
+	bb = get_slob_block(block);
+	if (bb) {
+		free_pages((unsigned long)block, bb->order);
+		slob_free(bb, sizeof(bigblock_t));
+		return;
 	}
 
 	slob_free((slob_t *)block - 1, 0);
@@ -222,20 +237,13 @@ EXPORT_SYMBOL(kfree);
 unsigned int ksize(const void *block)
 {
 	bigblock_t *bb;
-	unsigned long flags;
 
 	if (!block)
 		return 0;
 
-	if (!((unsigned long)block & (PAGE_SIZE-1))) {
-		spin_lock_irqsave(&block_lock, flags);
-		for (bb = bigblocks; bb; bb = bb->next)
-			if (bb->pages == block) {
-				spin_unlock_irqrestore(&slob_lock, flags);
-				return PAGE_SIZE << bb->order;
-			}
-		spin_unlock_irqrestore(&block_lock, flags);
-	}
+	bb = get_slob_block(block);
+	if (bb)
+		return PAGE_SIZE << bb->order;
 
 	return ((slob_t *)block - 1)->units * SLOB_UNIT;
 }

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="slob-scale-break-out-caches.patch"

---
 mm/slob.c |  290 ++++++++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 235 insertions(+), 55 deletions(-)

Index: linux/mm/slob.c
===================================================================
--- linux.orig/mm/slob.c
+++ linux/mm/slob.c
@@ -27,6 +27,20 @@
  * are allocated by calling __get_free_pages. As SLAB objects know
  * their size, no separate size bookkeeping is necessary and there is
  * essentially no allocation space overhead.
+ *
+ * Modified by: Steven Rostedt <rostedt@goodmis.org> 12/20/05
+ *
+ * Now we take advantage of the kmem_cache usage.  I've removed
+ * the global slobfree, and created one for every cache.
+ *
+ * For kmalloc/kfree I've reintroduced the usage of cache_sizes,
+ * but only for sizes 32 through PAGE_SIZE >> 1 by order of 2.
+ *
+ * Having the SLOB alloc per size of the cache should speed things up
+ * greatly, not only by making the search paths smaller, but also by
+ * keeping all the caches of similar units.  This way the fragmentation
+ * should not be as big of a problem.
+ *
  */
 
 #include <linux/slab.h>
@@ -36,6 +50,8 @@
 #include <linux/module.h>
 #include <linux/timer.h>
 
+#undef DEBUG_CACHE
+
 struct slob_block {
 	int units;
 	struct slob_block *next;
@@ -52,17 +68,66 @@ struct bigblock {
 };
 typedef struct bigblock bigblock_t;
 
-static slob_t arena = { .next = &arena, .units = 1 };
-static slob_t *slobfree = &arena;
-static DEFINE_SPINLOCK(slob_lock);
+struct kmem_cache {
+	unsigned int size, align;
+	const char *name;
+	slob_t *slobfree;
+	slob_t arena;
+	spinlock_t lock;
+	void (*ctor)(void *, struct kmem_cache *, unsigned long);
+	void (*dtor)(void *, struct kmem_cache *, unsigned long);
+	atomic_t items;
+	unsigned int free;
+	struct list_head list;
+};
+
+#define NR_SLOB_CACHES ((PAGE_SHIFT) - 5) /* 32 to PAGE_SIZE-1 by order of 2 */
+#define MAX_SLOB_CACHE_SIZE (PAGE_SIZE >> 1)
+
+static struct kmem_cache *cache_sizes[NR_SLOB_CACHES];
+static struct kmem_cache *bb_cache;
 
-#define __get_slob_block(b) ((unsigned long)(b) & ~(PAGE_SIZE-1))
+static struct semaphore	cache_chain_sem;
+static struct list_head cache_chain;
 
+#ifdef DEBUG_CACHE
+static void test_cache(kmem_cache_t *c)
+{
+	slob_t *cur = c->slobfree;
+	unsigned int x = -1 >> 2;
+
+	do {
+		BUG_ON(!cur->next);
+		cur = cur->next;
+	} while (cur != c->slobfree && --x);
+	BUG_ON(!x);
+}
+#else
+#define test_cache(x) do {} while(0)
+#endif
+
+/*
+ * Here we take advantage of the lru field of the pages that
+ * map to the pages we use in the SLOB.  This is done similar
+ * to what is done with SLAB.
+ *
+ * The lru.next field is used to get the bigblock descriptor
+ *    for large blocks larger than PAGE_SIZE >> 1.
+ *
+ * Set and retrieved by set_slob_block and get_slob_block
+ * respectively.
+ *
+ * The lru.prev field is used to find the cache descriptor
+ *   for small blocks smaller than or equal to PAGE_SIZE >> 1.
+ *
+ * Set and retrieved by set_slob_ptr and get_slob_ptr
+ * respectively.
+ *
+ * The use of lru.next tells us in kmalloc that the page is large.
+ */
 static inline struct page *get_slob_page(const void *mem)
 {
-	void *virt = (void*)__get_slob_block(mem);
-
-	return virt_to_page(virt);
+	return virt_to_page(mem);
 }
 
 static inline void zero_slob_block(const void *b)
@@ -86,20 +151,39 @@ static inline void set_slob_block(const 
 	page->lru.next = data;
 }
 
-static void slob_free(void *b, int size);
-static void slob_timer_cbk(void);
+static inline void *get_slob_ptr(const void *b)
+{
+	struct page *page;
+	page = get_slob_page(b);
+	return page->lru.prev;
+}
+
+static inline void set_slob_ptr(const void *b, void *data)
+{
+	struct page *page;
+	page = get_slob_page(b);
+	page->lru.prev = data;
+}
 
+static void slob_free(kmem_cache_t *cachep, void *b, int size);
 
-static void *slob_alloc(size_t size, gfp_t gfp, int align)
+static void *slob_alloc(kmem_cache_t *cachep, gfp_t gfp, int align)
 {
+	size_t size;
 	slob_t *prev, *cur, *aligned = 0;
-	int delta = 0, units = SLOB_UNITS(size);
+	int delta = 0, units;
 	unsigned long flags;
 
-	spin_lock_irqsave(&slob_lock, flags);
-	prev = slobfree;
+	size = cachep->size;
+	units = SLOB_UNITS(size);
+	BUG_ON(!units);
+
+	spin_lock_irqsave(&cachep->lock, flags);
+	prev = cachep->slobfree;
 	for (cur = prev->next; ; prev = cur, cur = cur->next) {
 		if (align) {
+			while (align < SLOB_UNIT)
+				align <<= 1;
 			aligned = (slob_t *)ALIGN((unsigned long)cur, align);
 			delta = aligned - cur;
 		}
@@ -122,12 +206,16 @@ static void *slob_alloc(size_t size, gfp
 				cur->units = units;
 			}
 
-			slobfree = prev;
-			spin_unlock_irqrestore(&slob_lock, flags);
+			cachep->slobfree = prev;
+			test_cache(cachep);
+			if (prev < prev->next)
+				BUG_ON(cur + cur->units > prev->next);
+			spin_unlock_irqrestore(&cachep->lock, flags);
 			return cur;
 		}
-		if (cur == slobfree) {
-			spin_unlock_irqrestore(&slob_lock, flags);
+		if (cur == cachep->slobfree) {
+			test_cache(cachep);
+			spin_unlock_irqrestore(&cachep->lock, flags);
 
 			if (size == PAGE_SIZE) /* trying to shrink arena? */
 				return 0;
@@ -137,14 +225,15 @@ static void *slob_alloc(size_t size, gfp
 				return 0;
 
 			zero_slob_block(cur);
-			slob_free(cur, PAGE_SIZE);
-			spin_lock_irqsave(&slob_lock, flags);
-			cur = slobfree;
+			set_slob_ptr(cur, cachep);
+			slob_free(cachep, cur, PAGE_SIZE);
+			spin_lock_irqsave(&cachep->lock, flags);
+			cur = cachep->slobfree;
 		}
 	}
 }
 
-static void slob_free(void *block, int size)
+static void slob_free(kmem_cache_t *cachep, void *block, int size)
 {
 	slob_t *cur, *b = (slob_t *)block;
 	unsigned long flags;
@@ -156,26 +245,29 @@ static void slob_free(void *block, int s
 		b->units = SLOB_UNITS(size);
 
 	/* Find reinsertion point */
-	spin_lock_irqsave(&slob_lock, flags);
-	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
+	spin_lock_irqsave(&cachep->lock, flags);
+	for (cur = cachep->slobfree; !(b > cur && b < cur->next); cur = cur->next)
 		if (cur >= cur->next && (b > cur || b < cur->next))
 			break;
 
 	if (b + b->units == cur->next) {
 		b->units += cur->next->units;
 		b->next = cur->next->next;
+		BUG_ON(cur->next == &cachep->arena);
 	} else
 		b->next = cur->next;
 
 	if (cur + cur->units == b) {
 		cur->units += b->units;
 		cur->next = b->next;
+		BUG_ON(b == &cachep->arena);
 	} else
 		cur->next = b;
 
-	slobfree = cur;
+	cachep->slobfree = cur;
 
-	spin_unlock_irqrestore(&slob_lock, flags);
+	test_cache(cachep);
+	spin_unlock_irqrestore(&cachep->lock, flags);
 }
 
 static int FASTCALL(find_order(int size));
@@ -189,15 +281,24 @@ static int fastcall find_order(int size)
 
 void *__kmalloc(size_t size, gfp_t gfp)
 {
-	slob_t *m;
 	bigblock_t *bb;
 
-	if (size < PAGE_SIZE - SLOB_UNIT) {
-		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
-		return m ? (void *)(m + 1) : 0;
+	/*
+	 * If the size is less than PAGE_SIZE >> 1 then
+	 * we use the generic caches.  Otherwise, we
+	 * just allocate the necessary pages.
+	 */
+	if (size <= MAX_SLOB_CACHE_SIZE) {
+		int i;
+		int order;
+		for (i=0, order=32; i < NR_SLOB_CACHES; i++, order <<= 1)
+			if (size <= order)
+				break;
+		BUG_ON(i == NR_SLOB_CACHES);
+		return kmem_cache_alloc(cache_sizes[i], gfp);
 	}
 
-	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
+	bb = slob_alloc(bb_cache, gfp, 0);
 	if (!bb)
 		return 0;
 
@@ -209,26 +310,33 @@ void *__kmalloc(size_t size, gfp_t gfp)
 		return bb->pages;
 	}
 
-	slob_free(bb, sizeof(bigblock_t));
+	slob_free(bb_cache, bb, sizeof(bigblock_t));
 	return 0;
 }
 EXPORT_SYMBOL(__kmalloc);
 
 void kfree(const void *block)
 {
+	kmem_cache_t *c;
 	bigblock_t *bb;
 
 	if (!block)
 		return;
 
+	/*
+	 * look into the page of the allocated block to
+	 * see if this is a big allocation or not.
+	 */
 	bb = get_slob_block(block);
 	if (bb) {
 		free_pages((unsigned long)block, bb->order);
-		slob_free(bb, sizeof(bigblock_t));
+		slob_free(bb_cache, bb, sizeof(bigblock_t));
 		return;
 	}
 
-	slob_free((slob_t *)block - 1, 0);
+	c = get_slob_ptr(block);
+	kmem_cache_free(c, (void *)block);
+
 	return;
 }
 
@@ -237,6 +345,7 @@ EXPORT_SYMBOL(kfree);
 unsigned int ksize(const void *block)
 {
 	bigblock_t *bb;
+	kmem_cache_t *c;
 
 	if (!block)
 		return 0;
@@ -245,14 +354,16 @@ unsigned int ksize(const void *block)
 	if (bb)
 		return PAGE_SIZE << bb->order;
 
-	return ((slob_t *)block - 1)->units * SLOB_UNIT;
+	c = get_slob_ptr(block);
+	return c->size;
 }
 
-struct kmem_cache {
-	unsigned int size, align;
-	const char *name;
-	void (*ctor)(void *, struct kmem_cache *, unsigned long);
-	void (*dtor)(void *, struct kmem_cache *, unsigned long);
+static slob_t cache_arena = { .next = &cache_arena, .units = 0 };
+struct kmem_cache cache_cache = {
+	.name = "cache",
+	.slobfree = &cache_cache.arena,
+	.arena = { .next = &cache_cache.arena, .units = 0 },
+	.lock = SPIN_LOCK_UNLOCKED
 };
 
 struct kmem_cache *kmem_cache_create(const char *name, size_t size,
@@ -261,8 +372,22 @@ struct kmem_cache *kmem_cache_create(con
 	void (*dtor)(void*, struct kmem_cache *, unsigned long))
 {
 	struct kmem_cache *c;
+	void *p;
+
+	c = slob_alloc(&cache_cache, flags, 0);
+
+	memset(c, 0, sizeof(*c));
 
-	c = slob_alloc(sizeof(struct kmem_cache), flags, 0);
+	c->size = PAGE_SIZE;
+	c->arena.next = &c->arena;
+	c->arena.units = 0;
+	c->slobfree = &c->arena;
+	atomic_set(&c->items, 0);
+	spin_lock_init(&c->lock);
+
+	p = slob_alloc(c, 0, PAGE_SIZE-1);
+	if (p)
+		free_page((unsigned long)p);
 
 	if (c) {
 		c->name = name;
@@ -274,6 +399,9 @@ struct kmem_cache *kmem_cache_create(con
 		if (c->align < align)
 			c->align = align;
 	}
+	down(&cache_chain_sem);
+	list_add_tail(&c->list, &cache_chain);
+	up(&cache_chain_sem);
 
 	return c;
 }
@@ -281,7 +409,17 @@ EXPORT_SYMBOL(kmem_cache_create);
 
 void kmem_cache_destroy(struct kmem_cache *c)
 {
-	slob_free(c, sizeof(struct kmem_cache));
+	down(&cache_chain_sem);
+	list_del(&c->list);
+	up(&cache_chain_sem);
+
+	BUG_ON(atomic_read(&c->items));
+
+	/*
+	 * WARNING!!! Memory leak!
+	 */
+	printk("FIX ME: need to free memory\n");
+	slob_free(&cache_cache, c, sizeof(struct kmem_cache));
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
 
@@ -289,11 +427,16 @@ void *kmem_cache_alloc(struct kmem_cache
 {
 	void *b;
 
-	if (c->size < PAGE_SIZE)
-		b = slob_alloc(c->size, flags, c->align);
+	atomic_inc(&c->items);
+
+	if (c->size <= MAX_SLOB_CACHE_SIZE)
+		b = slob_alloc(c, flags, c->align);
 	else
 		b = (void *)__get_free_pages(flags, find_order(c->size));
 
+	if (!b)
+		return 0;
+
 	if (c->ctor)
 		c->ctor(b, c, SLAB_CTOR_CONSTRUCTOR);
 
@@ -313,11 +456,13 @@ EXPORT_SYMBOL(kmem_cache_zalloc);
 
 void kmem_cache_free(struct kmem_cache *c, void *b)
 {
+	atomic_dec(&c->items);
+
 	if (c->dtor)
 		c->dtor(b, c, 0);
 
-	if (c->size < PAGE_SIZE)
-		slob_free(b, c->size);
+	if (c->size <= MAX_SLOB_CACHE_SIZE)
+		slob_free(c, b, c->size);
 	else
 		free_pages((unsigned long)b, find_order(c->size));
 }
@@ -335,9 +480,6 @@ const char *kmem_cache_name(struct kmem_
 }
 EXPORT_SYMBOL(kmem_cache_name);
 
-static struct timer_list slob_timer = TIMER_INITIALIZER(
-	(void (*)(unsigned long))slob_timer_cbk, 0, 0);
-
 int kmem_cache_shrink(struct kmem_cache *d)
 {
 	return 0;
@@ -349,17 +491,55 @@ int kmem_ptr_validate(struct kmem_cache 
 	return 0;
 }
 
-void __init kmem_cache_init(void)
+static char cache_names[NR_SLOB_CACHES][15];
+
+void kmem_cache_init(void)
 {
-	slob_timer_cbk();
+	static int done;
+	void *p;
+
+	if (!done) {
+		int i;
+		int size = 32;
+		done = 1;
+
+		init_MUTEX(&cache_chain_sem);
+		INIT_LIST_HEAD(&cache_chain);
+
+		cache_cache.size = PAGE_SIZE;
+		p = slob_alloc(&cache_cache, 0, PAGE_SIZE-1);
+		if (p)
+			free_page((unsigned long)p);
+		cache_cache.size = sizeof(struct kmem_cache);
+
+		bb_cache = kmem_cache_create("bb_cache",sizeof(bigblock_t), 0,
+					     GFP_KERNEL, NULL, NULL);
+		for (i=0; i < NR_SLOB_CACHES; i++, size <<= 1)
+			cache_sizes[i] = kmem_cache_create(cache_names[i], size, 0,
+							   GFP_KERNEL, NULL, NULL);
+	}
 }
 
-static void slob_timer_cbk(void)
+static void test_slob(slob_t *s)
 {
-	void *p = slob_alloc(PAGE_SIZE, 0, PAGE_SIZE-1);
+	slob_t *p;
+	long x = 0;
 
-	if (p)
-		free_page((unsigned long)p);
+	for (p=s->next; p != s && x < 10000; p = p->next, x++)
+		printk(".");
+}
+
+void print_slobs(void)
+{
+	struct list_head *curr;
+
+	list_for_each(curr, &cache_chain) {
+		kmem_cache_t *c = list_entry(curr, struct kmem_cache, list);
 
-	mod_timer(&slob_timer, jiffies + HZ);
+		printk("%s items:%d",
+		       c->name?:"<none>",
+		       atomic_read(&c->items));
+		test_slob(&c->arena);
+		printk("\n");
+	}
 }

--C7zPtVaVf+AK4Oqc--
