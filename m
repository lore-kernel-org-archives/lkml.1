Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbYB1Fz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbYB1Fz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 00:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbYB1FzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 00:55:18 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:47163 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079AbYB1FzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 00:55:16 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAEnbxUdMQWRV/2dsb2JhbACBVqxpgXo
Date: Thu, 28 Feb 2008 00:55:10 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Implement slub fastpath in terms of freebase and freeoffset
Message-ID: <20080228055510.GA9026@Krystal>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org> <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com> <20080219061107.GA23229@elte.hu> <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com> <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com> <20080219140230.GA32236@Krystal> <20080219172739.55c341b5.dada1@cosmosbay.com> <20080219200358.GB11197@Krystal> <Pine.LNX.4.64.0802271532580.14380@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802271532580.14380@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 00:36:30 up 17 days,  1:36,  2 users,  load average: 1.05, 0.98,
	0.92
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> On Tue, 19 Feb 2008, Mathieu Desnoyers wrote:
> 
> > I think you are right. A way to fix this would use the fact that the
> > freelist is only useful to point to the first free object in a page. We
> > could change it to an offset rather than an address.
> > 
> > The freelist would become a counter of type "long" which increments
> > until it wraps at 2^32 or 2^64. A PAGE_MASK bitmask could then be used
> > to get low order bits which would get the page offset of the first free
> > object, while the high order bits would insure we can detect this type
> > of object reuse when doing a cmpxchg. Upon free, the freelist counter
> > should always be incremented; this would be provided by adding PAGE_SIZE
> > to the counter and setting the LSBs to the correct offset.
> 
> Urgh.... That sounds way too complicated. Do you have an experimental 
> patch that would allow us to see the impact?
> 

Yep, I have an experimental patch ready. It would need some thorough
testing though. I seems to run fine on an x86_32 with and without
preemption (therefore with and without the slub cmpxchg_local fastpath).

You should first revert commit 00e962c5408b9f2d0bebd2308673fe982cb9a5fe
(this is the slub fastpath revert itself, currently in 2.6.25-rc3)

And then apply :


Implement slub fastpath in terms of freebase and freeoffset

It allows the cmpxchg_local to detect object re-use by keeping a counter in the
freeoffset MSBs.

freeoffset & PAGE_MASK is the offset of the freelist element within the page.
freeoffset & ~PAGE_MASK is the counter to detect object re-use.
freebase is the address of the page in this the object is located. It is a
multiple of PAGE_SIZE.

Whenever an object is freed in the cpu slab cache, the counter is incremented.
Whenever the alloc/free slow paths are modifying the freeoffset or freebase, the
freeoffset counter is also incremented. It is used to make sure we know if
freebase has been modified in an interrupt nested over the fast path.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Christoph Lameter <clameter@sgi.com>
---
 include/linux/slub_def.h |   35 +++++++++++++++++++
 mm/slub.c                |   84 +++++++++++++++++++++++++++++++++--------------
 2 files changed, 93 insertions(+), 26 deletions(-)

Index: linux-2.6-lttng/include/linux/slub_def.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/slub_def.h	2008-02-27 20:40:48.000000000 -0500
+++ linux-2.6-lttng/include/linux/slub_def.h	2008-02-28 00:17:28.000000000 -0500
@@ -32,7 +32,18 @@ enum stat_item {
 	NR_SLUB_STAT_ITEMS };
 
 struct kmem_cache_cpu {
-	void **freelist;	/* Pointer to first free per cpu object */
+	unsigned long freeoffset;	/*
+					 * Offset of the first free per cpu
+				 	 * object. The MSBs are used as a
+					 * counter which must be incremented
+					 * each time an object is freed and each
+					 * time freebase is changed.
+					 */
+	unsigned long freebase;	/*
+				 * Pointer to the page address
+				 * containing the first free per cpu
+				 * object.
+				 */
 	struct page *page;	/* The slab from which we are allocating */
 	int node;		/* The node of the page (or -1 for debug) */
 	unsigned int offset;	/* Freepointer offset (in word units) */
@@ -42,6 +53,28 @@ struct kmem_cache_cpu {
 #endif
 };
 
+/*
+ * Used when interrupts are disabled, so no memory barriers are needed.
+ */
+static inline void **get_freelist_ptr(struct kmem_cache_cpu *c)
+{
+	return (void **)(c->freebase | (c->freeoffset & PAGE_MASK));
+}
+
+/*
+ * Updates the freebase and freeoffset concurrently with slub fastpath.
+ * We can nest over the fastpath as an interrupt. Therefore, all the freebase
+ * and freeoffset modifications will appear to have happened atomically from the
+ * fastpath point of view. (those are per-cpu variables)
+ */
+static inline void set_freelist_ptr(struct kmem_cache_cpu *c, void **freelist)
+{
+	c->freebase = (unsigned long)freelist & ~PAGE_MASK;
+	c->freeoffset += PAGE_SIZE;
+	c->freeoffset &= ~PAGE_MASK;
+	c->freeoffset |= (unsigned long)freelist & PAGE_MASK;
+}
+
 struct kmem_cache_node {
 	spinlock_t list_lock;	/* Protect partial list and nr_partial */
 	unsigned long nr_partial;
Index: linux-2.6-lttng/mm/slub.c
===================================================================
--- linux-2.6-lttng.orig/mm/slub.c	2008-02-27 20:41:14.000000000 -0500
+++ linux-2.6-lttng/mm/slub.c	2008-02-28 00:20:06.000000000 -0500
@@ -305,7 +305,7 @@ static inline struct kmem_cache_cpu *get
  * Note that SLUB relies on page_mapping returning NULL for pages with bit 0
  * in the mapping set.
  */
-static inline int is_end(void *addr)
+static inline int is_end(long addr)
 {
 	return (unsigned long)addr & PAGE_MAPPING_ANON;
 }
@@ -1411,7 +1411,7 @@ static void deactivate_slab(struct kmem_
 	struct page *page = c->page;
 	int tail = 1;
 
-	if (c->freelist)
+	if (get_freelist_ptr(c))
 		stat(c, DEACTIVATE_REMOTE_FREES);
 	/*
 	 * Merge cpu freelist into freelist. Typically we get here
@@ -1422,14 +1422,14 @@ static void deactivate_slab(struct kmem_
 	 * be called for a debug slab. Then c->freelist may contain
 	 * a dummy pointer.
 	 */
-	while (unlikely(!is_end(c->freelist))) {
+	while (unlikely(!is_end(c->freeoffset))) {
 		void **object;
 
 		tail = 0;	/* Hot objects. Put the slab first */
 
 		/* Retrieve object from cpu_freelist */
-		object = c->freelist;
-		c->freelist = c->freelist[c->offset];
+		object = get_freelist_ptr(c);
+		set_freelist_ptr(c, object[c->offset]);
 
 		/* And put onto the regular freelist */
 		object[c->offset] = page->freelist;
@@ -1534,7 +1534,7 @@ load_freelist:
 		goto debug;
 
 	object = c->page->freelist;
-	c->freelist = object[c->offset];
+	set_freelist_ptr(c, object[c->offset]);
 	c->page->inuse = s->objects;
 	c->page->freelist = c->page->end;
 	c->node = page_to_nid(c->page);
@@ -1636,28 +1636,45 @@ static __always_inline void *slab_alloc(
  */
 
 #ifdef SLUB_FASTPATH
+	unsigned long freeoffset, freebase;
+
 	c = get_cpu_slab(s, raw_smp_processor_id());
 	do {
-		object = c->freelist;
-		if (unlikely(is_end(object) || !node_match(c, node))) {
+		freeoffset = c->freeoffset;
+		/*
+		 * If freebase is changed, freeoffset _must_ have its
+		 * counter incremented.
+		 * read freeoffset before freebase (wrt interrupts).
+		 */
+		barrier();
+		freebase = c->freebase;
+		if (unlikely(is_end(freeoffset) || !node_match(c, node))) {
 			object = __slab_alloc(s, gfpflags, node, addr, c);
 			break;
 		}
+		object = (void **)(freebase | (freeoffset & PAGE_MASK));
 		stat(c, ALLOC_FASTPATH);
-	} while (cmpxchg_local(&c->freelist, object, object[c->offset])
-								!= object);
+		/* No need to increment the MSB counter here, because only
+		 * object free will lead to counter re-use. */
+	} while (cmpxchg_local(&c->freeoffset, freeoffset,
+		(freeoffset + (c->offset * sizeof(void *)))) != freeoffset);
 #else
 	unsigned long flags;
 
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
-	if (unlikely(is_end(c->freelist) || !node_match(c, node)))
+	if (unlikely(is_end(c->freeoffset) || !node_match(c, node)))
 
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 
 	else {
-		object = c->freelist;
-		c->freelist = object[c->offset];
+		object = get_freelist_ptr(c);
+		/*
+		 * No need to change freebase or increment freeoffset of
+		 * PAGE_SIZE, so we simply update the freeoffset LSB here.
+		 */
+		c->freeoffset &= ~PAGE_MASK;
+		c->freeoffset |= (unsigned long)object[c->offset] & PAGE_MASK;
 		stat(c, ALLOC_FASTPATH);
 	}
 	local_irq_restore(flags);
@@ -1779,17 +1796,24 @@ static __always_inline void slab_free(st
 	struct kmem_cache_cpu *c;
 
 #ifdef SLUB_FASTPATH
-	void **freelist;
+	unsigned long freeoffset, freebase, newoffset;
 
 	c = get_cpu_slab(s, raw_smp_processor_id());
 	debug_check_no_locks_freed(object, s->objsize);
 	do {
-		freelist = c->freelist;
+		freeoffset = c->freeoffset;
+		/*
+		 * If freebase is changed, freeoffset _must_ have its
+		 * counter incremented.
+		 * read freeoffset before freebase (wrt interrupts).
+		 */
+		barrier();
+		freebase = c->freebase;
 		barrier();
 		/*
 		 * If the compiler would reorder the retrieval of c->page to
-		 * come before c->freelist then an interrupt could
-		 * change the cpu slab before we retrieve c->freelist. We
+		 * come before c->freeoffset and freebase then an interrupt
+		 * could change the cpu slab before we retrieve c->freelist. We
 		 * could be matching on a page no longer active and put the
 		 * object onto the freelist of the wrong slab.
 		 *
@@ -1801,9 +1825,14 @@ static __always_inline void slab_free(st
 			__slab_free(s, page, x, addr, c->offset);
 			break;
 		}
-		object[c->offset] = freelist;
+		object[c->offset] = (void **)(freebase |
+					(freeoffset & PAGE_MASK));
 		stat(c, FREE_FASTPATH);
-	} while (cmpxchg_local(&c->freelist, freelist, object) != freelist);
+		newoffset = freeoffset + PAGE_SIZE;
+		newoffset &= ~PAGE_MASK;
+		newoffset |= (unsigned long)object & PAGE_MASK;
+	} while (cmpxchg_local(&c->freeoffset, freeoffset, newoffset)
+			!= freeoffset);
 #else
 	unsigned long flags;
 
@@ -1811,8 +1840,13 @@ static __always_inline void slab_free(st
 	debug_check_no_locks_freed(object, s->objsize);
 	c = get_cpu_slab(s, smp_processor_id());
 	if (likely(page == c->page && c->node >= 0)) {
-		object[c->offset] = c->freelist;
-		c->freelist = object;
+		object[c->offset] = get_freelist_ptr(c);
+		/*
+		 * No need to update freebase here, so simply update freeoffset.
+		 */
+		c->freeoffset += PAGE_SIZE;
+		c->freeoffset &= ~PAGE_MASK;
+		c->freeoffset |= (unsigned long)object & PAGE_MASK;
 		stat(c, FREE_FASTPATH);
 	} else
 		__slab_free(s, page, x, addr, c->offset);
@@ -1995,7 +2029,8 @@ static void init_kmem_cache_cpu(struct k
 			struct kmem_cache_cpu *c)
 {
 	c->page = NULL;
-	c->freelist = (void *)PAGE_MAPPING_ANON;
+	c->freeoffset = PAGE_MAPPING_ANON;
+	c->freebase = 0;
 	c->node = 0;
 	c->offset = s->offset / sizeof(void *);
 	c->objsize = s->objsize;
@@ -2042,8 +2077,7 @@ static struct kmem_cache_cpu *alloc_kmem
 	struct kmem_cache_cpu *c = per_cpu(kmem_cache_cpu_free, cpu);
 
 	if (c)
-		per_cpu(kmem_cache_cpu_free, cpu) =
-				(void *)c->freelist;
+		per_cpu(kmem_cache_cpu_free, cpu) = (void *)get_freelist_ptr(c);
 	else {
 		/* Table overflow: So allocate ourselves */
 		c = kmalloc_node(
@@ -2064,7 +2098,7 @@ static void free_kmem_cache_cpu(struct k
 		kfree(c);
 		return;
 	}
-	c->freelist = (void *)per_cpu(kmem_cache_cpu_free, cpu);
+	set_freelist_ptr(c, (void *)per_cpu(kmem_cache_cpu_free, cpu));
 	per_cpu(kmem_cache_cpu_free, cpu) = c;
 }
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
