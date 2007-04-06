Return-Path: <linux-kernel-owner+w=401wt.eu-S932473AbXDFTxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473AbXDFTxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932493AbXDFTxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:53:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41170 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932473AbXDFTxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:53:22 -0400
Date: Fri, 6 Apr 2007 12:53:22 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: SLUB: Add Kconfig option for SLAB quirks
Message-ID: <Pine.LNX.4.64.0704061227170.11797@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch may allow to reduce the churn for SLUB. It adds a Kconfig
option that makes SLUB replicate SLAB special handling for slab caches.

With this i386 etc will be able to boot without other modifications.
One can boot with "slub_debug" on all arches to enable full debugging.
(Err... SLAB was never able to perform full debugging. We emulate that
behavior, so no real full debugging. Lets say debugging as much as 
possible. Full debugging is only possible if CONFIG_SLUB_SLAB_QUIRKS is 
off).

If build with CONFIG_SLUB_SLAB_QUIRKS set then slabs that get
special handling are flagged on bootup. That does not mean that there
is a problem with these slabs. It just means that SLUB prevented
possible issues by modifying its behavior for those slab caches.

I would really prefer that these issues be addressed in the code
rather than using this patch. If we have the issues addressed then
hopefully this patch can be reverted.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.21-rc5-mm4/init/Kconfig
===================================================================
--- linux-2.6.21-rc5-mm4.orig/init/Kconfig	2007-04-06 12:12:59.000000000 -0700
+++ linux-2.6.21-rc5-mm4/init/Kconfig	2007-04-06 12:21:44.000000000 -0700
@@ -569,6 +569,32 @@ config SLUB
 	   of queues of objects. SLUB can use memory efficiently
 	   way and has enhanced diagnostics.
 
+config SLUB_SLAB_QUIRKS
+	depends on SLUB
+	bool "SLUB: Handle SLAB quirks"
+	help
+	  Make SLUB emulate various inconsistent behaviors of SLAB in order
+	  to avoid having to fix these issues. Switching this on will make
+	  debugging on some slabs impossible and may lead to a slight
+	  performance degradation (one additional check in the hotpath).
+
+	  The issues addressed are
+	  1. Page order slabs are always aligned on page boundaries
+	     regardless of other alignment requirements. This also
+	     affects the kmalloc array. Kmalloc slabs are usually aligned
+	     to KMALLOC_MINALIGN. Now we make an exception for those of
+	     page order. Debugging options are disabled if they would
+	     misalign a cache.
+
+	  2. Page order slabs are handled in such a way that page->index
+	     can be used for other purposes.
+
+	  3. PAGE_SIZE slabs are never increased beyond PAGE_SIZE.
+	     Debugging is switched off in order to guarantee that.
+	     This allows the use of page->private for other purposes.
+	     All slab allocators use compound pages for higher order
+	     allocations which would no longer allow the use of page->private.
+
 config SLOB
 #
 #	SLOB cannot support SMP because SLAB_DESTROY_BY_RCU does not work
Index: linux-2.6.21-rc5-mm4/mm/slub.c
===================================================================
--- linux-2.6.21-rc5-mm4.orig/mm/slub.c	2007-04-06 12:12:59.000000000 -0700
+++ linux-2.6.21-rc5-mm4/mm/slub.c	2007-04-06 12:13:08.000000000 -0700
@@ -101,7 +101,8 @@
 #endif
 
 /* Internal SLUB flags */
-#define __OBJECT_POISON 0x80000000	/* Poison object */
+#define __OBJECT_POISON		0x80000000	/* Poison object */
+#define __NO_FREE_POINTER	0x40000000	/* Avoid use of free pointer */
 
 static int kmem_size = sizeof(struct kmem_cache);
 
@@ -475,6 +476,9 @@ static int check_object(struct kmem_cach
 			return 0;
 	}
 
+	if (s->flags & __NO_FREE_POINTER)
+		return 1;
+
 	if (!s->offset && active)
 		/*
 		 * Object and freepointer overlap. Cannot check
@@ -578,6 +582,9 @@ static int alloc_object_checks(struct km
 	if (!check_slab(s, page))
 		goto bad;
 
+	if (s->flags & __NO_FREE_POINTER)
+		return 1;
+
 	if (object && !on_freelist(s, page, object)) {
 		printk(KERN_ERR "SLAB: %s Object 0x%p@0x%p "
 			"already allocated.\n",
@@ -627,7 +634,8 @@ static int free_object_checks(struct kme
 		goto fail;
 	}
 
-	if (on_freelist(s, page, object)) {
+	if (!(s->flags & __NO_FREE_POINTER) &&
+			on_freelist(s, page, object)) {
 		printk(KERN_CRIT "SLUB: %s slab 0x%p object "
 			"0x%p already free.\n", s->name, page, object);
 		goto fail;
@@ -746,6 +754,9 @@ static struct page *new_slab(struct kmem
 			SLAB_STORE_USER | SLAB_TRACE))
 		page->flags |= 1 << PG_error;
 
+	if (s->flags & __NO_FREE_POINTER)
+		page->flags |= 1 << PG_dirty;
+
 	start = page_address(page);
 	end = start + s->objects * s->size;
 
@@ -759,7 +770,8 @@ static struct page *new_slab(struct kmem
 		last = p;
 	}
 	setup_object(s, page, last);
-	set_freepointer(s, last, NULL);
+	if (!PageDirty(page))
+		set_freepointer(s, last, NULL);
 
 	page->freelist = start;
 	page->inuse = 0;
@@ -822,7 +834,7 @@ static void discard_slab(struct kmem_cac
 
 	atomic_long_dec(&n->nr_slabs);
 	reset_page_mapcount(page);
-	page->flags &= ~(1 << PG_slab | 1 << PG_error);
+	page->flags &= ~(1 << PG_slab | 1 << PG_error | 1 << PG_dirty);
 	free_slab(s, page);
 }
 
@@ -1157,6 +1169,12 @@ have_slab:
 
 	page = new_slab(s, gfpflags, node);
 	if (page) {
+#ifdef CONFIG_SLUB_SLAB_QUIRKS
+		if (unlikely(PageDirty(page))) {
+			local_irq_restore(flags);
+			return page_address(page);
+		}
+#endif
 		if (s->cpu_slab[cpu]) {
 			/*
 			 * Someone else populated the cpu_slab while
@@ -1217,6 +1235,14 @@ static void slab_free(struct kmem_cache 
 	unsigned long flags;
 
 	local_irq_save(flags);
+
+#ifdef CONFIG_SLUB_SLAB_QUIRKS
+	if (unlikely(PageDirty(page))) {
+		discard_slab(s, page);
+		local_irq_restore(flags);
+		return;
+	}
+#endif
 	slab_lock(page);
 
 	if (unlikely(PageError(page)))
@@ -1480,8 +1506,9 @@ int calculate_sizes(struct kmem_cache *s
 
 	s->inuse = size;
 
-	if (((flags & (SLAB_DESTROY_BY_RCU | SLAB_POISON)) ||
-		s->ctor || s->dtor)) {
+	if (!(s->flags & __NO_FREE_POINTER) &&
+		(((flags & (SLAB_DESTROY_BY_RCU | SLAB_POISON)) ||
+		s->ctor || s->dtor))) {
 		/*
 		 * Relocate free pointer after the object if it is not
 		 * permitted to overwrite the first word of the object on
@@ -1513,6 +1540,39 @@ int calculate_sizes(struct kmem_cache *s
 
 }
 
+#ifdef CONFIG_SLUB_SLAB_QUIRKS
+static int check_slab_challenged_slab(struct kmem_cache *s)
+{
+	if (s->size <= 4096)
+		return 0;
+
+	/*
+	 * Is the slab growing beyond the next order boundary? */
+	if (fls(s->objsize -1) == fls(s->size - 1))
+		return 0;
+
+	/*
+	 * Disable debugging to prevent this.
+	 */
+	s->flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
+
+	/*
+	 * Do not touch freelist for page sized slabs in order
+	 * to free up the page->index field.
+	 */
+	s->flags |= __NO_FREE_POINTER;
+
+	printk(KERN_WARNING "SLUB: SLAB quirks handling activated for %s size %d\n",
+		s->name, s->objsize);
+	calculate_sizes(s);
+	return 1;
+}
+#else
+static int check_slab_challenged_slab(struct kmem_cache *s) {
+	return 0;
+}
+#endif
+
 static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
 		const char *name, size_t size,
 		size_t align, unsigned long flags,
@@ -1544,6 +1604,7 @@ static int kmem_cache_open(struct kmem_c
 	if (!calculate_sizes(s))
 		goto error;
 
+	check_slab_challenged_slab(s);
 	s->refcount = 1;
 #ifdef CONFIG_NUMA
 	s->defrag_ratio = 100;
Index: linux-2.6.21-rc5-mm4/arch/i386/Kconfig
===================================================================
--- linux-2.6.21-rc5-mm4.orig/arch/i386/Kconfig	2007-04-06 12:12:59.000000000 -0700
+++ linux-2.6.21-rc5-mm4/arch/i386/Kconfig	2007-04-06 12:13:08.000000000 -0700
@@ -79,9 +79,10 @@ config ARCH_MAY_HAVE_PC_FDC
 	bool
 	default y
 
-config ARCH_USES_SLAB_PAGE_STRUCT
+config SLUB_SLAB_QUIRKS
 	bool
 	default y
+	depends on SLUB
 
 config DMI
 	bool
Index: linux-2.6.21-rc5-mm4/arch/frv/Kconfig
===================================================================
--- linux-2.6.21-rc5-mm4.orig/arch/frv/Kconfig	2007-04-06 12:12:59.000000000 -0700
+++ linux-2.6.21-rc5-mm4/arch/frv/Kconfig	2007-04-06 12:13:08.000000000 -0700
@@ -53,9 +53,10 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default y
 
-config ARCH_USES_SLAB_PAGE_STRUCT
+config SLUB_SLAB_QUIRKS
 	bool
 	default y
+	depends on SLUB
 
 mainmenu "Fujitsu FR-V Kernel Configuration"
 
