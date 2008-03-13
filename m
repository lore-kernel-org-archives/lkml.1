Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646AbYCMBUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbYCMBUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 21:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbYCMBUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 21:20:33 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:58562 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752291AbYCMBUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 21:20:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhcFAFoe2EdMQWoK/2dsb2JhbACBWKNc
Date: Wed, 12 Mar 2008 21:20:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Implement slub fastpath with sequence number
Message-ID: <20080313012026.GA1720@Krystal>
References: <20080311093144.GB30220@Krystal> <1205246043.8514.188.camel@twins> <20080312221703.GA25625@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080312221703.GA25625@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:16:21 up 12 days, 21:27,  7 users,  load average: 1.11, 1.22,
	0.81
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
> > On Tue, 2008-03-11 at 05:31 -0400, Mathieu Desnoyers wrote:
> > > Here is a new version that works. tested on x86. tweaked the bitmasks
> > > into unions to remove operations from the critical path, but I tried to
> > > keep that clean. It applies on vm.git HEAD.
> > > 
> > > It allows the cmpxchg_local to detect object re-use by keeping a counter in the
> > > freeoffset MSBs.
> > > 
> > > Whenever an object is freed in the cpu slab cache, the counter is incremented.
> > > Whenever the alloc/free slow paths are modifying the offset or freebase, the
> > > sequence counter is also incremented. It is used to make sure we know if
> > > freebase has been modified in an interrupt nested over the fast path.
> > 
> > Is it (remotely) possible that the version will wrap giving the false
> > impression that nothing has changed and thus falsely proceed with a
> > wrong object?
> > 
> 
> If we have exactly, on a 32 bits arch, 65536 memory alloc or free in the
> slab we are dealing with done in interrupt and softirqs nested over the
> cmpxchg_local loop, without ever giving the control back to check the
> value, and that after we get the control back the offset within the slab
> is exactly the same, then, yes, it's possible. In that case, we would
> think it's ok to proceed with the object and we would have memory
> corruption (object used twice or free object list corruption).
> 

I think I found a solution to this.

Quoting the changelog :

- Make sure an overflow will _always_ be detected by forcing the slow path when
  overflow is detected and by only allowing !in_interrupt() code to reset the
  counter. This solution is good as long as preemption is disabled in the
  fastpath.

See the patch inlined below.

Mathieu

> Given that the alloc fast path takes about 115 cycles on a 3GHz Pentium
> 4 for an alloc/free pair (65536 * 38.33ns = 2.5ms total), having this
> scenario would mean that every other interrupt would not have been
> serviced for 2.5ms. In that case, we would probably have other problems
> to deal with. On 64 bits architectures, with 2^32 bits, we would have to
> wait for about 160 seconds (approx.).
> 
> This is why I added a check to verify if the sequence number delta is
> bigger than half of the number of bits we have to count it :
> 
> +#ifdef CONFIG_DEBUG_VM
> +       /*
> +        * Just to be paranoid : warn if we detect that enough free or
> +        * slow paths nested on top of us to get the counter to go
> +        * half-way to overflow. That would be insane to do that much
> +        * allocations/free in interrupt handers, but check it anyway.
> +        */
> +       WARN_ON(result - old > -1UL >> 1);
> +#endif
> 
> If we ever have a kernel which starts to behave weirdly and *could* be
> unlucky and get nearer to overflow, this check would likely detect it.
> Worse case I have seen so far on my stressed machine was a delta of 3.
> 
> > I would really prefer if we defer all this fast path fiddling until we
> > have the cpu_ops in place, this all just makes the code utterly
> > unreadable.
> > 
> > 
> 
> Even with cpu_ops in place, I think it would be safer to still disable
> preemption in the fastpath. It would make sure a thread is not stopped
> in the middle of the cmpxchg loop, a lot of activity happens, and later
> on the thread is woken up. In this scenario, the 16 bits might not be
> enough to keep track of allocations/frees in the slab.
> 
> Mathieu
> 


Implement slub fastpath with sequence number

It allows the cmpxchg_local to detect nested object re-use and slab change by
keeping a counter in the freelist MSBs. (16 bits on 32 bits architectures, 32
bits on 64 bits architectures)

Whenever an object is freed in the cpu slab cache, the counter is incremented.
Whenever the alloc/free slow paths are modifying the offset or freebase, the
sequence counter is also incremented. It is used to make sure we know if
freebase has been modified in an interrupt nested over the fast path.

This version running with preemption enabled gives the following results on
x86_32 (UP, 3GHz Pentium 4), 2.6.25-rc4 kernel.

The speedup for the alloc/free test is 2.69.

Single thread testing
=====================
1. Kmalloc: Repeatedly allocate then free test

* baseline

10000 times kmalloc(8) -> 184 cycles kfree -> 150 cycles
10000 times kmalloc(16) -> 185 cycles kfree -> 151 cycles
10000 times kmalloc(32) -> 194 cycles kfree -> 152 cycles
10000 times kmalloc(64) -> 208 cycles kfree -> 158 cycles
10000 times kmalloc(128) -> 325 cycles kfree -> 178 cycles
10000 times kmalloc(256) -> 387 cycles kfree -> 254 cycles
10000 times kmalloc(512) -> 376 cycles kfree -> 238 cycles
10000 times kmalloc(1024) -> 379 cycles kfree -> 246 cycles
10000 times kmalloc(2048) -> 403 cycles kfree -> 270 cycles
10000 times kmalloc(4096) -> 439 cycles kfree -> 292 cycles
10000 times kmalloc(8192) -> 697 cycles kfree -> 642 cycles
10000 times kmalloc(16384) -> 742 cycles kfree -> 744 cycles

* cmpxchg_local

10000 times kmalloc(8) -> 89 cycles kfree -> 178 cycles
10000 times kmalloc(16) -> 91 cycles kfree -> 176 cycles
10000 times kmalloc(32) -> 103 cycles kfree -> 187 cycles
10000 times kmalloc(64) -> 125 cycles kfree -> 186 cycles
10000 times kmalloc(128) -> 238 cycles kfree -> 208 cycles
10000 times kmalloc(256) -> 312 cycles kfree -> 258 cycles
10000 times kmalloc(512) -> 299 cycles kfree -> 245 cycles
10000 times kmalloc(1024) -> 312 cycles kfree -> 263 cycles
10000 times kmalloc(2048) -> 334 cycles kfree -> 282 cycles
10000 times kmalloc(4096) -> 398 cycles kfree -> 323 cycles
10000 times kmalloc(8192) -> 690 cycles kfree -> 641 cycles
10000 times kmalloc(16384) -> 738 cycles kfree -> 729 cycles


2. Kmalloc: alloc/free test

* baseline

10000 times kmalloc(8)/kfree -> 310 cycles
10000 times kmalloc(16)/kfree -> 318 cycles
10000 times kmalloc(32)/kfree -> 314 cycles
10000 times kmalloc(64)/kfree -> 310 cycles
10000 times kmalloc(128)/kfree -> 318 cycles
10000 times kmalloc(256)/kfree -> 332 cycles
10000 times kmalloc(512)/kfree -> 332 cycles
10000 times kmalloc(1024)/kfree -> 324 cycles
10000 times kmalloc(2048)/kfree -> 324 cycles
10000 times kmalloc(4096)/kfree -> 328 cycles
10000 times kmalloc(8192)/kfree -> 888 cycles
10000 times kmalloc(16384)/kfree -> 973 cycles

* cmpxchg_local

10000 times kmalloc(8)/kfree -> 115 cycles
10000 times kmalloc(16)/kfree -> 112 cycles
10000 times kmalloc(32)/kfree -> 112 cycles
10000 times kmalloc(64)/kfree -> 112 cycles
10000 times kmalloc(128)/kfree -> 112 cycles
10000 times kmalloc(256)/kfree -> 124 cycles
10000 times kmalloc(512)/kfree -> 128 cycles
10000 times kmalloc(1024)/kfree -> 127 cycles
10000 times kmalloc(2048)/kfree -> 127 cycles
10000 times kmalloc(4096)/kfree -> 127 cycles
10000 times kmalloc(8192)/kfree -> 874 cycles
10000 times kmalloc(16384)/kfree -> 934 cycles

Changelog :
- fix end of freelist
- Removed VM_BUG_ON in get_/set_freelist_ptr (killed init). It makes no sense
  anyway, because it is valid to get/set the freelist ptr when the freelist
  is not in use by the rest of the system yet without disabling interrupts.
- Fixed debug_check_no_locks_freed(object, c->objsize) in SLUB_FASTPATH free.
- Fix deactivate slab : write back the freelist pointer after the loop has been
  executed.
- Use union to select sub-registers instead of using masks.
- Add CONFIG_PREEMPT support.
- Fix CPU slab caches c->freelist direct references (use get/set).
- Fix error in set_freelist_ptr (base was set to LSB instead of MSB).
- Use END to mark slab end.
- Check for same_base at the beginning of fastpaths. It detects if we deal with
  cross-slabs pointers (object in one slab, next_object in another slab). It
  will also detect if the order of slab used is too big to be represented in
  half long size. It should be safe to deal with slabs with order higher than 4:
  the same_base check should detect this and fallback on the slow path.
- Check the sequence counter before using c->base. It makes sure base and
  offset are in sync and won't trigger a page fault. We re-read the c->freelist
  after reading c->base and check if the sequence number has changed. Therefore,
  since only an interrupt could have changed them, we can detect that both are
  in sync and that it is safe to use the make_ptr generated.
- Make sure an overflow will _always_ be detected by forcing the slow path when
  overflow is detected and by only allowing !in_interrupt() code to reset the
  counter. This solution is good as long as preemption is disabled in the
  fastpath.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/slub_def.h |    7 
 mm/slub.c                |  338 +++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 323 insertions(+), 22 deletions(-)

Index: vm/mm/slub.c
===================================================================
--- vm.orig/mm/slub.c	2008-03-12 17:25:40.000000000 -0400
+++ vm/mm/slub.c	2008-03-12 21:09:57.000000000 -0400
@@ -138,6 +138,109 @@ static inline void ClearSlabDebug(struct
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
+#define HALF_LONG_MASK ((1UL << HALF_BITS_PER_LONG) - 1)
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
+static inline int same_base(unsigned long base, void *object)
+{
+	return get_high_half(base) == get_high_half((unsigned long)object);
+}
+
+static inline void *make_ptr(unsigned long base, void *freelist)
+{
+	return (void *)(base | get_low_half((unsigned long)freelist));
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
+		.s.l = get_low_half((unsigned long)object),
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
+	c->base = get_high_half((unsigned long)freelist) << HALF_BITS_PER_LONG;
+	/*
+	 * Detect overflow. Only wrap if not in interrupt.
+	 * Slowpath is always taken when a counter overflow is detected.
+	 */
+	if (unlikely(get_high_half((unsigned long)c->freelist)
+			== HALF_LONG_MASK && in_interrupt())) {
+		c->freelist = make_version((void *)c->freelist, freelist);
+		return;
+	}
+	c->freelist = make_version((void *)c->freelist + HALF_LONG_MASK + 1,
+				freelist);
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
@@ -273,6 +376,13 @@ static inline struct kmem_cache_cpu *get
 #endif
 }
 
+#define END ((void *)1)
+
+static inline int is_end(const void *freelist)
+{
+	return (unsigned long)freelist & (unsigned long)END;
+}
+
 /* Determine the maximum number of objects that a slab page can hold */
 static inline unsigned long slab_objects(struct kmem_cache *s, struct page *page)
 {
@@ -287,7 +397,7 @@ static inline int check_valid_pointer(st
 {
 	void *base;
 
-	if (!object)
+	if (is_end(object))
 		return 1;
 
 	base = page_address(page);
@@ -324,7 +434,8 @@ static inline void set_freepointer(struc
 
 /* Scan freelist */
 #define for_each_free_object(__p, __s, __free) \
-	for (__p = (__free); __p; __p = get_freepointer((__s), __p))
+	for (__p = (__free); !is_end(__p); __p = get_freepointer((__s),\
+		__p))
 
 /* Determine object index from a given position */
 static inline int slab_index(void *p, struct kmem_cache *s, void *addr)
@@ -722,7 +833,7 @@ static int check_object(struct kmem_cach
 		 * of the free objects in this slab. May cause
 		 * another error because the object count is now wrong.
 		 */
-		set_freepointer(s, p, NULL);
+		set_freepointer(s, p, END);
 		return 0;
 	}
 	return 1;
@@ -757,18 +868,18 @@ static int on_freelist(struct kmem_cache
 	void *object = NULL;
 	int objects = slab_objects(s, page);
 
-	while (fp && nr <= objects) {
+	while (!is_end(fp) && nr <= objects) {
 		if (fp == search)
 			return 1;
 		if (!check_valid_pointer(s, page, fp)) {
 			if (object) {
 				object_err(s, page, object,
 					"Freechain corrupt");
-				set_freepointer(s, object, NULL);
+				set_freepointer(s, object, END);
 				break;
 			} else {
 				slab_err(s, page, "Freepointer corrupt");
-				page->freelist = NULL;
+				page->freelist = END;
 				page->inuse = objects;
 				slab_fix(s, "Freelist cleared");
 				return 0;
@@ -874,7 +985,7 @@ bad:
 		 */
 		slab_fix(s, "Marking all objects used");
 		page->inuse = slab_objects(s, page);
-		page->freelist = NULL;
+		page->freelist = END;
 	}
 	return 0;
 }
@@ -914,7 +1025,7 @@ static int free_debug_processing(struct 
 	}
 
 	/* Special debug activities for freeing objects */
-	if (!SlabFrozen(page) && !page->freelist)
+	if (!SlabFrozen(page) && is_end(page->freelist))
 		remove_full(s, page);
 	if (s->flags & SLAB_STORE_USER)
 		set_track(s, object, TRACK_FREE, addr);
@@ -1120,7 +1231,7 @@ static struct page *new_slab(struct kmem
 		last = p;
 	}
 	setup_object(s, page, last);
-	set_freepointer(s, last, NULL);
+	set_freepointer(s, last, END);
 
 	page->freelist = start;
 	page->inuse = 0;
@@ -1355,7 +1466,7 @@ static void unfreeze_slab(struct kmem_ca
 	ClearSlabFrozen(page);
 	if (page->inuse) {
 
-		if (page->freelist) {
+		if (!is_end(page->freelist)) {
 			add_partial(n, page, tail);
 			stat(c, tail ? DEACTIVATE_TO_TAIL : DEACTIVATE_TO_HEAD);
 		} else {
@@ -1394,28 +1505,32 @@ static void deactivate_slab(struct kmem_
 {
 	struct page *page = c->page;
 	int tail = 1;
+	void **freelist;
 
-	if (page->freelist)
+	if (!is_end(page->freelist))
 		stat(c, DEACTIVATE_REMOTE_FREES);
 	/*
 	 * Merge cpu freelist into slab freelist. Typically we get here
 	 * because both freelists are empty. So this is unlikely
 	 * to occur.
 	 */
-	while (unlikely(c->freelist)) {
+	freelist = get_freelist_ptr(c);
+	while (unlikely(!is_end(freelist))) {
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
+		set_freelist_ptr(c, freelist);
 	c->page = NULL;
 	unfreeze_slab(s, page, tail);
 }
@@ -1496,7 +1611,14 @@ static void *__slab_alloc(struct kmem_ca
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
 
@@ -1508,18 +1630,21 @@ static void *__slab_alloc(struct kmem_ca
 
 load_freelist:
 	object = c->page->freelist;
-	if (unlikely(!object))
+	if (unlikely(is_end(object)))
 		goto another_slab;
 	if (unlikely(SlabDebug(c->page)))
 		goto debug;
 
-	c->freelist = object[c->offset];
+	set_freelist_ptr(c, object[c->offset]);
 	c->page->inuse = slab_objects(s, c->page);
-	c->page->freelist = NULL;
+	c->page->freelist = END;
 	c->node = page_to_nid(c->page);
 unlock_out:
 	slab_unlock(c->page);
 	stat(c, ALLOC_SLOWPATH);
+#ifdef SLUB_FASTPATH
+	local_irq_restore(flags);
+#endif
 	return object;
 
 another_slab:
@@ -1551,7 +1676,9 @@ new_slab:
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
@@ -1578,11 +1705,96 @@ static __always_inline void *slab_alloc(
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
+	void *old, *new, *result, *next_object;
+	unsigned long base;
+
+	preempt_disable();
+	c = get_cpu_slab(s, raw_smp_processor_id());
+fastpath:	/* fastpath cmpxchg loop */
+	old = c->freelist;
+	/*
+	 * Whenever c->base is changed, the sequence number
+	 * _must_ be incremented. This barrier insures we read
+	 * version before c->base wrt interrupts.
+	 */
+	barrier();
+	base = c->base;
+	if (unlikely(is_end(old) || !node_match(c, node)))
+		goto slowpath;
+	if (unlikely(get_high_half((unsigned long)old) == HALF_LONG_MASK
+			&& in_interrupt()))
+		goto slowpath;
+	/*
+	 * make_ptr on base should always return a valid pointer;
+	 * insure base has not been changed by a nested interrupt by
+	 * re-reading the freelist sequence number. It makes sure the
+	 * base and the offset will generate a valid pointer.
+	 */
+	barrier();
+	if (c->freelist != old)
+		goto fastpath;	/* retry */
+	object = make_ptr(base, old);
+	/*
+	 * Need to increment the MSB counter here, because
+	 * object[c->offset] use is racy. We can race against
+	 * another slab_alloc fast path.
+	 * Note that the object[c->offset] read may return garbage, but
+	 * is insured to point to a valid address since pages are always
+	 * reused in the page allocator. We know if the
+	 * object[c->offset] read returned garbage because the sequence
+	 * number is incremented each time the freelist is modified.
+	 */
+	next_object = object[c->offset];
+	if (unlikely(!same_base(base, next_object)))
+		goto slowpath;
+	stat(c, ALLOC_FASTPATH);
+	new = make_version(old + HALF_LONG_MASK + 1, next_object);
+	result = cmpxchg_local(&c->freelist, old, new);
+#ifdef CONFIG_DEBUG_VM
+	/*
+	 * Just to be paranoid : warn if we detect that enough free or
+	 * slow paths nested on top of us to get the counter to go
+	 * half-way to overflow. That would be insane to do that much
+	 * allocations/free in interrupt handers, but check it anyway.
+	 */
+	WARN_ON(result - old > -1UL >> 1);
+#endif
+	if (result != old)
+		goto fastpath;	/* retry */
+	preempt_enable();
+	goto got_object;
+slowpath:
+	preempt_enable();
+	/*
+	 * __slab_alloc must make no assumption about the
+	 * tests previously done by slab_alloc : we could be
+	 * migrated to a different CPU.
+	 */
+	object = __slab_alloc(s, gfpflags, node, addr, c);
+got_object:
+#else
 	unsigned long flags;
 
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
-	if (unlikely(!c->freelist || !node_match(c, node)))
+	if (unlikely(is_end(c->freelist)) || !node_match(c, node))
 
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 
@@ -1592,6 +1804,7 @@ static __always_inline void *slab_alloc(
 		stat(c, ALLOC_FASTPATH);
 	}
 	local_irq_restore(flags);
+#endif
 
 	if (unlikely((gfpflags & __GFP_ZERO) && object))
 		memset(object, 0, c->objsize);
@@ -1628,6 +1841,11 @@ static void __slab_free(struct kmem_cach
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
@@ -1652,17 +1870,20 @@ checks_ok:
 	 * Objects left in the slab. If it was not on the partial list before
 	 * then add it.
 	 */
-	if (unlikely(!prior)) {
+	if (unlikely(is_end(prior))) {
 		add_partial(get_node(s, page_to_nid(page)), page, 1);
 		stat(c, FREE_ADD_PARTIAL);
 	}
 
 out_unlock:
 	slab_unlock(page);
+#ifdef SLUB_FASTPATH
+	local_irq_restore(flags);
+#endif
 	return;
 
 slab_empty:
-	if (prior) {
+	if (!is_end(prior)) {
 		/*
 		 * Slab still on the partial list.
 		 */
@@ -1672,6 +1893,9 @@ slab_empty:
 	slab_unlock(page);
 	stat(c, FREE_SLAB);
 	discard_slab(s, page);
+#ifdef SLUB_FASTPATH
+	local_irq_restore(flags);
+#endif
 	return;
 
 debug:
@@ -1696,6 +1920,70 @@ static __always_inline void slab_free(st
 {
 	void **object = (void *)x;
 	struct kmem_cache_cpu *c;
+
+#ifdef SLUB_FASTPATH
+	void *old, *new, *result;
+	unsigned long base;
+
+	preempt_disable();
+	c = get_cpu_slab(s, raw_smp_processor_id());
+	debug_check_no_locks_freed(object, c->objsize);
+	while (1) {
+		old = c->freelist;
+		/*
+		 * If the compiler would reorder the retrieval of c->page and
+		 * c->base to come before c->freelist then an interrupt
+		 * could change the cpu slab before we retrieve c->version.
+		 * We could be matching on a page no longer active and put the
+		 * object onto the freelist of the wrong slab.
+		 *
+		 * On the other hand: If we already have the version
+		 * then any change of cpu_slab will cause the cmpxchg to fail
+		 * since the freelist pointers are unique per slab.
+		 */
+		barrier();
+		base = c->base;
+		if (unlikely((get_high_half((unsigned long)old)
+					== HALF_LONG_MASK && in_interrupt()) ||
+				!same_base(base, object) ||
+				page != c->page || c->node < 0)) {
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
+		 * The result of make_ptr does not have to be dereferenced
+		 * until the cmpxchg succeeds. We don't care if base and old are
+		 * out-of-sync.
+		 */
+		object[c->offset] = make_ptr(base, old);
+		stat(c, FREE_FASTPATH);
+		new = make_version(old + HALF_LONG_MASK + 1, object);
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
@@ -1709,6 +1997,7 @@ static __always_inline void slab_free(st
 		__slab_free(s, page, x, addr, c->offset);
 
 	local_irq_restore(flags);
+#endif
 }
 
 void kmem_cache_free(struct kmem_cache *s, void *x)
@@ -1886,7 +2175,12 @@ static void init_kmem_cache_cpu(struct k
 			struct kmem_cache_cpu *c)
 {
 	c->page = NULL;
-	c->freelist = NULL;
+#ifdef SLUB_FASTPATH
+	c->freelist = make_version(0, END);
+	c->base = 0;
+#else
+	c->freelist = END;
+#endif
 	c->node = 0;
 	c->offset = s->offset / sizeof(void *);
 	c->objsize = s->objsize;
Index: vm/include/linux/slub_def.h
===================================================================
--- vm.orig/include/linux/slub_def.h	2008-03-12 17:25:40.000000000 -0400
+++ vm/include/linux/slub_def.h	2008-03-12 18:46:41.000000000 -0400
@@ -32,9 +32,16 @@ enum stat_item {
 	ORDER_FALLBACK,		/* Number of times fallback was necessary */
 	NR_SLUB_STAT_ITEMS };
 
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
