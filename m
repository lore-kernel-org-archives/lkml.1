Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbYCKJb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbYCKJb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 05:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbYCKJbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 05:31:50 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:64009 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbYCKJbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 05:31:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgEFAObu1UdMQWoK/2dsb2JhbACBWKlUggw
Date: Tue, 11 Mar 2008 05:31:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH] Implement slub fastpath with sequence number
Message-ID: <20080311093144.GB30220@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 05:25:38 up 11 days,  5:36,  4 users,  load average: 6.16, 3.17,
	1.77
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a new version that works. tested on x86. tweaked the bitmasks
into unions to remove operations from the critical path, but I tried to
keep that clean. It applies on vm.git HEAD.

It allows the cmpxchg_local to detect object re-use by keeping a counter in the
freeoffset MSBs.

Whenever an object is freed in the cpu slab cache, the counter is incremented.
Whenever the alloc/free slow paths are modifying the offset or freebase, the
sequence counter is also incremented. It is used to make sure we know if
freebase has been modified in an interrupt nested over the fast path.

Changelog :
- fix end of freelist
- Removed VM_BUG_ON in get_/set_freelist_ptr (killed init).
- Fixed debug_check_no_locks_freed(object, c->objsize) in SLUB_FASTPATH free.
- Fix deactivate slab.
- Use union to select sub-registers instead of using masks.
- Add CONFIG_PREEMPT support. (needs some performance testing though)

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/slub_def.h |   10 +
 mm/slub.c                |  263 +++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 265 insertions(+), 8 deletions(-)

Index: vm/mm/slub.c
===================================================================
--- vm.orig/mm/slub.c	2008-03-10 17:52:39.000000000 -0400
+++ vm/mm/slub.c	2008-03-11 05:21:34.000000000 -0400
@@ -138,6 +138,96 @@ static inline void ClearSlabDebug(struct
 	page->flags &= ~SLABDEBUG;
 }
 
+#ifdef SLUB_FASTPATH
+/*
+ * The fastpath divides the free pointer into two halves.
+ *
+ * The lower bits provide an offset relative to the base pointer (that is
+ * kept in different field). The upper bits provide a sequence number so
+ * that we can decide if a given pointer is still valid through a cmpxchg.
+ */
+#define HALF_BITS_PER_LONG (BITS_PER_LONG / 2)
+#define HALF_LONG_MAX (1UL << HALF_BITS_PER_LONG)
+
+/*
+ * Define a half-long type to use register selection instead of bitmasks.
+ */
+#if (HALF_BITS_PER_LONG == 32)
+typedef u32 hulong;
+#elif (HALF_BITS_PER_LONG == 16)
+typedef u16 hulong;
+#else
+#error "Unknown long size"
+#endif
+
+union halfselect {
+	struct {
+#ifdef __BIG_ENDIAN
+		hulong h;
+		hulong l;
+#else
+		hulong l;
+		hulong h;
+#endif
+	} s;
+	unsigned long v;
+};
+
+static inline unsigned long get_high_half(unsigned long v)
+{
+	return ((union halfselect)v).s.h;
+}
+
+static inline unsigned long get_low_half(unsigned long v)
+{
+	return ((union halfselect)v).s.l;
+}
+
+static inline void *make_ptr(unsigned long base, void *freelist)
+{
+	return (void *)(base
+		| (unsigned long)get_low_half((unsigned long)freelist));
+}
+
+/*
+ * Make a new version by keeping the high half of the previous version and
+ * low half of object.
+ */
+static inline void *make_version(void *version, void *object)
+{
+	union halfselect ret = {
+		.s.h = get_high_half((unsigned long)version),
+		.s.l = get_low_half((unsigned long)object)
+	};
+	return (void *)ret.v;
+}
+
+static inline void **get_freelist_ptr(struct kmem_cache_cpu *c)
+{
+	return make_ptr(c->base, c->freelist);
+}
+
+static inline void set_freelist_ptr(struct kmem_cache_cpu *c, void **freelist)
+{
+	c->base = get_high_half((unsigned long)freelist);
+	c->freelist = make_version((void *)c->freelist + HALF_LONG_MAX,
+			freelist);
+}
+
+#else
+
+static inline void **get_freelist_ptr(struct kmem_cache_cpu *c)
+{
+	return c->freelist;
+}
+
+static inline void set_freelist_ptr(struct kmem_cache_cpu *c, void **freelist)
+{
+	c->freelist = freelist;
+}
+
+#endif
+
 /*
  * Issues still to be resolved:
  *
@@ -1394,6 +1484,7 @@ static void deactivate_slab(struct kmem_
 {
 	struct page *page = c->page;
 	int tail = 1;
+	void **freelist;
 
 	if (page->freelist)
 		stat(c, DEACTIVATE_REMOTE_FREES);
@@ -1402,20 +1493,23 @@ static void deactivate_slab(struct kmem_
 	 * because both freelists are empty. So this is unlikely
 	 * to occur.
 	 */
-	while (unlikely(c->freelist)) {
+	freelist = get_freelist_ptr(c);
+	while (unlikely(freelist)) {
 		void **object;
 
 		tail = 0;	/* Hot objects. Put the slab first */
 
 		/* Retrieve object from cpu_freelist */
-		object = c->freelist;
-		c->freelist = c->freelist[c->offset];
+		object = freelist;
+		freelist = object[c->offset];
 
 		/* And put onto the regular freelist */
 		object[c->offset] = page->freelist;
 		page->freelist = object;
 		page->inuse--;
 	}
+	if (!tail)
+		set_freelist_ptr(c, NULL);
 	c->page = NULL;
 	unfreeze_slab(s, page, tail);
 }
@@ -1496,7 +1590,14 @@ static void *__slab_alloc(struct kmem_ca
 {
 	void **object;
 	struct page *new;
+#ifdef SLUB_FASTPATH
+	unsigned long flags;
 
+	local_irq_save(flags);
+#ifdef CONFIG_PREEMPT
+	c = get_cpu_slab(s, raw_smp_processor_id());
+#endif
+#endif
 	if (!c->page)
 		goto new_slab;
 
@@ -1513,13 +1614,16 @@ load_freelist:
 	if (unlikely(SlabDebug(c->page)))
 		goto debug;
 
-	c->freelist = object[c->offset];
+	set_freelist_ptr(c, object[c->offset]);
 	c->page->inuse = slab_objects(s, c->page);
 	c->page->freelist = NULL;
 	c->node = page_to_nid(c->page);
 unlock_out:
 	slab_unlock(c->page);
 	stat(c, ALLOC_SLOWPATH);
+#ifdef SLUB_FASTPATH
+	local_irq_restore(flags);
+#endif
 	return object;
 
 another_slab:
@@ -1551,7 +1655,9 @@ new_slab:
 		c->page = new;
 		goto load_freelist;
 	}
-
+#ifdef SLUB_FASTPATH
+	local_irq_restore(flags);
+#endif
 	return NULL;
 debug:
 	if (!alloc_debug_processing(s, c->page, object, addr))
@@ -1578,6 +1684,74 @@ static __always_inline void *slab_alloc(
 {
 	void **object;
 	struct kmem_cache_cpu *c;
+
+/*
+ * The SLUB_FASTPATH path is provisional and is currently disabled if the
+ * kernel is compiled with preemption or if the arch does not support
+ * fast cmpxchg operations. There are a couple of coming changes that will
+ * simplify matters and allow preemption. Ultimately we may end up making
+ * SLUB_FASTPATH the default.
+ *
+ * 1. The introduction of the per cpu allocator will avoid array lookups
+ *    through get_cpu_slab(). A special register can be used instead.
+ *
+ * 2. The introduction of per cpu atomic operations (cpu_ops) means that
+ *    we can realize the logic here entirely with per cpu atomics. The
+ *    per cpu atomic ops will take care of the preemption issues.
+ */
+
+#ifdef SLUB_FASTPATH
+	void *old, *new, *result;
+
+	preempt_disable();
+	c = get_cpu_slab(s, raw_smp_processor_id());
+	while (1) {
+		old = c->freelist;
+		/*
+		 * Whenever c->base is changed, the sequence number
+		 * _must_ be incremented. This barrier insures we read
+		 * version before c->base wrt interrupts.
+		 */
+		barrier();
+		object = make_ptr(c->base, old);
+		if (unlikely(!object || !node_match(c, node))) {
+			preempt_enable();
+			/*
+			 * __slab_alloc must make no assumption about the
+			 * tests previously done by slab_alloc : we could be
+			 * migrated to a different CPU.
+			 */
+			object = __slab_alloc(s, gfpflags, node, addr, c);
+			break;
+		}
+		stat(c, ALLOC_FASTPATH);
+		/*
+		 * Need to increment the MSB counter here, because
+		 * object[c->offset] use is racy. We can race against
+		 * another slab_alloc fast path.
+		 * Note that the object[c->offset] read may return garbage, but
+		 * is insured to point to a valid address since pages are always
+		 * reused in the page allocator. We know if the
+		 * object[c->offset] read returned garbage because the sequence
+		 * number is incremented each time the freelist is modified.
+		 */
+		new = make_version(old + HALF_LONG_MAX, object[c->offset]);
+		result = cmpxchg_local(&c->freelist, old, new);
+#ifdef CONFIG_DEBUG_VM
+		/*
+		 * Just to be paranoid : warn if we detect that enough free or
+		 * slow paths nested on top of us to get the counter to go
+		 * half-way to overflow. That would be insane to do that much
+		 * allocations/free in interrupt handers, but check it anyway.
+		 */
+		WARN_ON(result - old > -1UL >> 1);
+#endif
+		if (result == old) {
+			preempt_enable();
+			break;
+		}
+	}
+#else
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -1592,6 +1766,7 @@ static __always_inline void *slab_alloc(
 		stat(c, ALLOC_FASTPATH);
 	}
 	local_irq_restore(flags);
+#endif
 
 	if (unlikely((gfpflags & __GFP_ZERO) && object))
 		memset(object, 0, c->objsize);
@@ -1628,6 +1803,11 @@ static void __slab_free(struct kmem_cach
 	void **object = (void *)x;
 	struct kmem_cache_cpu *c;
 
+#ifdef SLUB_FASTPATH
+	unsigned long flags;
+
+	local_irq_save(flags);
+#endif
 	c = get_cpu_slab(s, raw_smp_processor_id());
 	stat(c, FREE_SLOWPATH);
 	slab_lock(page);
@@ -1659,6 +1839,9 @@ checks_ok:
 
 out_unlock:
 	slab_unlock(page);
+#ifdef SLUB_FASTPATH
+	local_irq_restore(flags);
+#endif
 	return;
 
 slab_empty:
@@ -1672,6 +1855,9 @@ slab_empty:
 	slab_unlock(page);
 	stat(c, FREE_SLAB);
 	discard_slab(s, page);
+#ifdef SLUB_FASTPATH
+	local_irq_restore(flags);
+#endif
 	return;
 
 debug:
@@ -1696,6 +1882,62 @@ static __always_inline void slab_free(st
 {
 	void **object = (void *)x;
 	struct kmem_cache_cpu *c;
+
+#ifdef SLUB_FASTPATH
+	void *old, *new, *result;
+
+	preempt_disable();
+	c = get_cpu_slab(s, raw_smp_processor_id());
+	debug_check_no_locks_freed(object, c->objsize);
+	while (1) {
+		old = c->freelist;
+		barrier();
+		/*
+		 * If the compiler would reorder the retrieval of c->page and
+		 * c->base to come before c->version then an interrupt
+		 * could change the cpu slab before we retrieve c->version.
+		 * We could be matching on a page no longer active and put the
+		 * object onto the freelist of the wrong slab.
+		 *
+		 * On the other hand: If we already have the version
+		 * then any change of cpu_slab will cause the cmpxchg to fail
+		 * since the freelist pointers are unique per slab.
+		 */
+		if (unlikely(page != c->page || c->node < 0)) {
+			preempt_enable();
+			/*
+			 * __slab_free must make no assumption about the
+			 * tests previously done by slab_free : we could be
+			 * migrated to a different CPU.
+			 */
+			__slab_free(s, page, x, addr, c->offset);
+			break;
+		}
+		/*
+		 * It's ok to overwrite the content of object[c->offset] because
+		 * we own the object. This object won't appear in the freelist
+		 * until our cmpxchg_local succeeds. Therefore, no other part of
+		 * the slub slow path can use this object.
+		 */
+		object[c->offset] = make_ptr(c->base, old);
+		stat(c, FREE_FASTPATH);
+		new = make_version(old + HALF_LONG_MAX, object);
+		result = cmpxchg_local(&c->freelist, old, new);
+#ifdef CONFIG_DEBUG_VM
+		/*
+		 * Just to be paranoid : warn if we detect that enough free or
+		 * slow paths nested on top of us to get the counter to go
+		 * half-way to overflow. That would be insane to do that much
+		 * allocations/free in interrupt handers, but check it anyway.
+		 */
+		WARN_ON(result - old > -1UL >> 1);
+#endif
+		if (result == old) {
+			preempt_enable();
+			break;
+		}
+	}
+#else
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -1709,6 +1951,7 @@ static __always_inline void slab_free(st
 		__slab_free(s, page, x, addr, c->offset);
 
 	local_irq_restore(flags);
+#endif
 }
 
 void kmem_cache_free(struct kmem_cache *s, void *x)
@@ -1886,7 +2129,12 @@ static void init_kmem_cache_cpu(struct k
 			struct kmem_cache_cpu *c)
 {
 	c->page = NULL;
+#ifdef SLUB_FASTPATH
+	c->freelist = make_version(0, NULL);
+	c->base = 0;
+#else
 	c->freelist = NULL;
+#endif
 	c->node = 0;
 	c->offset = s->offset / sizeof(void *);
 	c->objsize = s->objsize;
@@ -1933,8 +2181,7 @@ static struct kmem_cache_cpu *alloc_kmem
 	struct kmem_cache_cpu *c = per_cpu(kmem_cache_cpu_free, cpu);
 
 	if (c)
-		per_cpu(kmem_cache_cpu_free, cpu) =
-				(void *)c->freelist;
+		per_cpu(kmem_cache_cpu_free, cpu) = (void *)c->freelist;
 	else {
 		/* Table overflow: So allocate ourselves */
 		c = kmalloc_node(
@@ -1955,7 +2202,7 @@ static void free_kmem_cache_cpu(struct k
 		kfree(c);
 		return;
 	}
-	c->freelist = (void *)per_cpu(kmem_cache_cpu_free, cpu);
+	c->freelist = per_cpu(kmem_cache_cpu_free, cpu);
 	per_cpu(kmem_cache_cpu_free, cpu) = c;
 }
 
Index: vm/include/linux/slub_def.h
===================================================================
--- vm.orig/include/linux/slub_def.h	2008-03-10 17:52:39.000000000 -0400
+++ vm/include/linux/slub_def.h	2008-03-11 04:08:29.000000000 -0400
@@ -32,9 +32,19 @@ enum stat_item {
 	ORDER_FALLBACK,		/* Number of times fallback was necessary */
 	NR_SLUB_STAT_ITEMS };
 
+/*
+ * Currently the fastpath is not supported if preemption is enabled.
+ */
+#ifdef CONFIG_FAST_CMPXCHG_LOCAL
+#define SLUB_FASTPATH
+#endif
+
 struct kmem_cache_cpu {
 	void **freelist;	/* Pointer to first free per cpu object */
 	struct page *page;	/* The slab from which we are allocating */
+#ifdef SLUB_FASTPATH
+	unsigned long base;	/* Base for fastpath. */
+#endif
 	int node;		/* The node of the page (or -1 for debug) */
 	unsigned int offset;	/* Freepointer offset (in word units) */
 	unsigned int objsize;	/* Size of an object (from kmem_cache) */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
