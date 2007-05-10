Return-Path: <linux-kernel-owner+w=401wt.eu-S1761198AbXEJTAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761198AbXEJTAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757622AbXEJTAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:00:13 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52013 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757369AbXEJTAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:00:11 -0400
Date: Thu, 10 May 2007 12:00:08 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: linux-kernel@vger.kernel.org
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Paul Mundt <lethal@linux-sh.org>
Subject: [RFC] Slab allocators: Drop support for destructors
Message-ID: <Pine.LNX.4.64.0705101156190.10663@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As far as I can tell there is only a single slab destructor left (there 
is currently another in i386 but its going to go as soon as Andi merges 
i386s support for quicklists).

I wonder how difficult it would be to remove it? If we have no need for 
destructors anymore then maybe we could remove destructor support from the 
slab allocators? There is no point in checking for destructor uses in 
the slab allocators if there are none.

Or are there valid reason to keep them around? It seems they were mainly 
used for list management which required them to take a spinlock. Taking a 
spinlock in a destructor is a bit risky since the slab allocators may run 
the destructors anytime they decide a slab is no longer needed.

Or do we want to continue support destructors? If so why?




The last destructor is in

arch/mm/pmb.c:

static void pmb_cache_ctor(void *pmb, struct kmem_cache *cachep, unsigned 
long flags)
{
        struct pmb_entry *pmbe = pmb;

        memset(pmb, 0, sizeof(struct pmb_entry));

        spin_lock_irq(&pmb_list_lock);

        pmbe->entry = PMB_NO_ENTRY;
        pmb_list_add(pmbe);

        spin_unlock_irq(&pmb_list_lock);
}

static void pmb_cache_dtor(void *pmb, struct kmem_cache *cachep, unsigned 
long flags)
{
        spin_lock_irq(&pmb_list_lock);
        pmb_list_del(pmb);
        spin_unlock_irq(&pmb_list_lock);
}

static int __init pmb_init(void)
{
        unsigned int nr_entries = ARRAY_SIZE(pmb_init_map);
        unsigned int entry;

        BUG_ON(unlikely(nr_entries >= NR_PMB_ENTRIES));

        pmb_cache = kmem_cache_create("pmb", sizeof(struct pmb_entry), 0,
                                      SLAB_PANIC, pmb_cache_ctor,
                                      pmb_cache_dtor);



Patch drops destructor support from all slab allocators. Any attempt to 
use a destructor will BUG().

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/slub_def.h |    1 -
 mm/slab.c                |   27 ++-------------------------
 mm/slob.c                |    6 +-----
 mm/slub.c                |   46 +++++++++++++++-------------------------------
 4 files changed, 18 insertions(+), 62 deletions(-)

Index: slub/include/linux/slub_def.h
===================================================================
--- slub.orig/include/linux/slub_def.h	2007-05-10 11:47:41.000000000 -0700
+++ slub/include/linux/slub_def.h	2007-05-10 11:47:58.000000000 -0700
@@ -40,7 +40,6 @@ struct kmem_cache {
 	int objects;		/* Number of objects in slab */
 	int refcount;		/* Refcount for slab cache destroy */
 	void (*ctor)(void *, struct kmem_cache *, unsigned long);
-	void (*dtor)(void *, struct kmem_cache *, unsigned long);
 	int inuse;		/* Offset to metadata */
 	int align;		/* Alignment */
 	const char *name;	/* Name (only for display!) */
Index: slub/mm/slab.c
===================================================================
--- slub.orig/mm/slab.c	2007-05-10 11:47:41.000000000 -0700
+++ slub/mm/slab.c	2007-05-10 11:47:58.000000000 -0700
@@ -409,9 +409,6 @@ struct kmem_cache {
 	/* constructor func */
 	void (*ctor) (void *, struct kmem_cache *, unsigned long);
 
-	/* de-constructor func */
-	void (*dtor) (void *, struct kmem_cache *, unsigned long);
-
 /* 5) cache creation/removal */
 	const char *name;
 	struct list_head next;
@@ -1911,20 +1908,11 @@ static void slab_destroy_objs(struct kme
 				slab_error(cachep, "end of a freed object "
 					   "was overwritten");
 		}
-		if (cachep->dtor && !(cachep->flags & SLAB_POISON))
-			(cachep->dtor) (objp + obj_offset(cachep), cachep, 0);
 	}
 }
 #else
 static void slab_destroy_objs(struct kmem_cache *cachep, struct slab *slabp)
 {
-	if (cachep->dtor) {
-		int i;
-		for (i = 0; i < cachep->num; i++) {
-			void *objp = index_to_obj(cachep, slabp, i);
-			(cachep->dtor) (objp, cachep, 0);
-		}
-	}
 }
 #endif
 
@@ -2124,7 +2112,7 @@ static int setup_cpu_cache(struct kmem_c
  * @align: The required alignment for the objects.
  * @flags: SLAB flags
  * @ctor: A constructor for the objects.
- * @dtor: A destructor for the objects.
+ * @dtor: A destructor for the objects (not implemented anymore).
  *
  * Returns a ptr to the cache on success, NULL on failure.
  * Cannot be called within a int, but can be interrupted.
@@ -2159,7 +2147,7 @@ kmem_cache_create (const char *name, siz
 	 * Sanity checks... these are all serious usage bugs.
 	 */
 	if (!name || in_interrupt() || (size < BYTES_PER_WORD) ||
-	    (size > (1 << MAX_OBJ_ORDER) * PAGE_SIZE) || (dtor && !ctor)) {
+	    (size > (1 << MAX_OBJ_ORDER) * PAGE_SIZE) || dtor) {
 		printk(KERN_ERR "%s: Early error in slab %s\n", __FUNCTION__,
 				name);
 		BUG();
@@ -2213,9 +2201,6 @@ kmem_cache_create (const char *name, siz
 	if (flags & SLAB_DESTROY_BY_RCU)
 		BUG_ON(flags & SLAB_POISON);
 #endif
-	if (flags & SLAB_DESTROY_BY_RCU)
-		BUG_ON(dtor);
-
 	/*
 	 * Always checks flags, a caller might be expecting debug support which
 	 * isn't available.
@@ -2370,7 +2355,6 @@ kmem_cache_create (const char *name, siz
 		BUG_ON(!cachep->slabp_cache);
 	}
 	cachep->ctor = ctor;
-	cachep->dtor = dtor;
 	cachep->name = name;
 
 	if (setup_cpu_cache(cachep)) {
@@ -2835,7 +2819,6 @@ failed:
  * Perform extra freeing checks:
  * - detect bad pointers.
  * - POISON/RED_ZONE checking
- * - destructor calls, for caches with POISON+dtor
  */
 static void kfree_debugcheck(const void *objp)
 {
@@ -2894,12 +2877,6 @@ static void *cache_free_debugcheck(struc
 	BUG_ON(objnr >= cachep->num);
 	BUG_ON(objp != index_to_obj(cachep, slabp, objnr));
 
-	if (cachep->flags & SLAB_POISON && cachep->dtor) {
-		/* we want to cache poison the object,
-		 * call the destruction callback
-		 */
-		cachep->dtor(objp + obj_offset(cachep), cachep, 0);
-	}
 #ifdef CONFIG_DEBUG_SLAB_LEAK
 	slab_bufctl(slabp)[objnr] = BUFCTL_FREE;
 #endif
Index: slub/mm/slob.c
===================================================================
--- slub.orig/mm/slob.c	2007-05-10 11:47:41.000000000 -0700
+++ slub/mm/slob.c	2007-05-10 11:47:58.000000000 -0700
@@ -268,7 +268,6 @@ struct kmem_cache {
 	unsigned int size, align;
 	const char *name;
 	void (*ctor)(void *, struct kmem_cache *, unsigned long);
-	void (*dtor)(void *, struct kmem_cache *, unsigned long);
 };
 
 struct kmem_cache *kmem_cache_create(const char *name, size_t size,
@@ -278,13 +277,13 @@ struct kmem_cache *kmem_cache_create(con
 {
 	struct kmem_cache *c;
 
+	BUG_ON(dtor);
 	c = slob_alloc(sizeof(struct kmem_cache), flags, 0);
 
 	if (c) {
 		c->name = name;
 		c->size = size;
 		c->ctor = ctor;
-		c->dtor = dtor;
 		/* ignore alignment unless it's forced */
 		c->align = (flags & SLAB_HWCACHE_ALIGN) ? SLOB_ALIGN : 0;
 		if (c->align < align)
@@ -330,9 +329,6 @@ EXPORT_SYMBOL(kmem_cache_zalloc);
 
 void kmem_cache_free(struct kmem_cache *c, void *b)
 {
-	if (c->dtor)
-		c->dtor(b, c, 0);
-
 	if (c->size < PAGE_SIZE)
 		slob_free(b, c->size);
 	else
Index: slub/mm/slub.c
===================================================================
--- slub.orig/mm/slub.c	2007-05-10 11:47:57.000000000 -0700
+++ slub/mm/slub.c	2007-05-10 11:54:29.000000000 -0700
@@ -898,13 +898,13 @@ static void kmem_cache_open_debug_check(
 	 * On 32 bit platforms the limit is 256k. On 64bit platforms
 	 * the limit is 512k.
 	 *
-	 * Debugging or ctor/dtors may create a need to move the free
+	 * Debugging or ctor may create a need to move the free
 	 * pointer. Fail if this happens.
 	 */
 	if (s->size >= 65535 * sizeof(void *)) {
 		BUG_ON(s->flags & (SLAB_RED_ZONE | SLAB_POISON |
 				SLAB_STORE_USER | SLAB_DESTROY_BY_RCU));
-		BUG_ON(s->ctor || s->dtor);
+		BUG_ON(s->ctor);
 	}
 	else
 		/*
@@ -1037,15 +1037,12 @@ static void __free_slab(struct kmem_cach
 {
 	int pages = 1 << s->order;
 
-	if (unlikely(SlabDebug(page) || s->dtor)) {
+	if (unlikely(SlabDebug(page))) {
 		void *p;
 
 		slab_pad_check(s, page);
-		for_each_object(p, s, page_address(page)) {
-			if (s->dtor)
-				s->dtor(p, s, 0);
+		for_each_object(p, s, page_address(page))
 			check_object(s, page, p, 0);
-		}
 	}
 
 	mod_zone_page_state(page_zone(page),
@@ -1883,7 +1880,7 @@ static int calculate_sizes(struct kmem_c
 	 * then we should never poison the object itself.
 	 */
 	if ((flags & SLAB_POISON) && !(flags & SLAB_DESTROY_BY_RCU) &&
-			!s->ctor && !s->dtor)
+			!s->ctor)
 		s->flags |= __OBJECT_POISON;
 	else
 		s->flags &= ~__OBJECT_POISON;
@@ -1913,7 +1910,7 @@ static int calculate_sizes(struct kmem_c
 
 #ifdef CONFIG_SLUB_DEBUG
 	if (((flags & (SLAB_DESTROY_BY_RCU | SLAB_POISON)) ||
-		s->ctor || s->dtor)) {
+		s->ctor)) {
 		/*
 		 * Relocate free pointer after the object if it is not
 		 * permitted to overwrite the first word of the object on
@@ -1982,13 +1979,11 @@ static int calculate_sizes(struct kmem_c
 static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
 		const char *name, size_t size,
 		size_t align, unsigned long flags,
-		void (*ctor)(void *, struct kmem_cache *, unsigned long),
-		void (*dtor)(void *, struct kmem_cache *, unsigned long))
+		void (*ctor)(void *, struct kmem_cache *, unsigned long))
 {
 	memset(s, 0, kmem_size);
 	s->name = name;
 	s->ctor = ctor;
-	s->dtor = dtor;
 	s->objsize = size;
 	s->flags = flags;
 	s->align = align;
@@ -2173,7 +2168,7 @@ static struct kmem_cache *create_kmalloc
 
 	down_write(&slub_lock);
 	if (!kmem_cache_open(s, gfp_flags, name, size, ARCH_KMALLOC_MINALIGN,
-			flags, NULL, NULL))
+			flags, NULL))
 		goto panic;
 
 	list_add(&s->list, &slab_caches);
@@ -2485,7 +2480,7 @@ static int slab_unmergeable(struct kmem_
 	if (slub_nomerge || (s->flags & SLUB_NEVER_MERGE))
 		return 1;
 
-	if (s->ctor || s->dtor)
+	if (s->ctor)
 		return 1;
 
 	return 0;
@@ -2493,15 +2488,14 @@ static int slab_unmergeable(struct kmem_
 
 static struct kmem_cache *find_mergeable(size_t size,
 		size_t align, unsigned long flags,
-		void (*ctor)(void *, struct kmem_cache *, unsigned long),
-		void (*dtor)(void *, struct kmem_cache *, unsigned long))
+		void (*ctor)(void *, struct kmem_cache *, unsigned long))
 {
 	struct list_head *h;
 
 	if (slub_nomerge || (flags & SLUB_NEVER_MERGE))
 		return NULL;
 
-	if (ctor || dtor)
+	if (ctor)
 		return NULL;
 
 	size = ALIGN(size, sizeof(void *));
@@ -2543,8 +2537,10 @@ struct kmem_cache *kmem_cache_create(con
 {
 	struct kmem_cache *s;
 
+	BUG_ON(dtor);
+
 	down_write(&slub_lock);
-	s = find_mergeable(size, align, flags, dtor, ctor);
+	s = find_mergeable(size, align, flags, ctor);
 	if (s) {
 		s->refcount++;
 		/*
@@ -2558,7 +2554,7 @@ struct kmem_cache *kmem_cache_create(con
 	} else {
 		s = kmalloc(kmem_size, GFP_KERNEL);
 		if (s && kmem_cache_open(s, GFP_KERNEL, name,
-				size, align, flags, ctor, dtor)) {
+				size, align, flags, ctor)) {
 			if (sysfs_slab_add(s)) {
 				kfree(s);
 				goto err;
@@ -3199,17 +3195,6 @@ static ssize_t ctor_show(struct kmem_cac
 }
 SLAB_ATTR_RO(ctor);
 
-static ssize_t dtor_show(struct kmem_cache *s, char *buf)
-{
-	if (s->dtor) {
-		int n = sprint_symbol(buf, (unsigned long)s->dtor);
-
-		return n + sprintf(buf + n, "\n");
-	}
-	return 0;
-}
-SLAB_ATTR_RO(dtor);
-
 static ssize_t aliases_show(struct kmem_cache *s, char *buf)
 {
 	return sprintf(buf, "%d\n", s->refcount - 1);
@@ -3441,7 +3426,6 @@ static struct attribute * slab_attrs[] =
 	&partial_attr.attr,
 	&cpu_slabs_attr.attr,
 	&ctor_attr.attr,
-	&dtor_attr.attr,
 	&aliases_attr.attr,
 	&align_attr.attr,
 	&sanity_checks_attr.attr,
