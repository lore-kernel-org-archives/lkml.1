Return-Path: <linux-kernel-owner+w=401wt.eu-S964792AbXDQFgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792AbXDQFgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 01:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbXDQFgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 01:36:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59235 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753990AbXDQFgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 01:36:23 -0400
Date: Mon, 16 Apr 2007 22:35:21 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: akpm@linux-foundation.com
cc: linux-kernel@vger.kernel.org
Subject: slab allocators: Remove obsolete SLAB_MUST_HWCACHE_ALIGN
Message-ID: <Pine.LNX.4.64.0704162232530.31027@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The flag SLAB_MUST_HWCACHE_ALIGN is

1. Never checked by SLAB at all.

2. A duplicate of SLAB_HWCACHE_ALIGN for SLUB

3. Fulfills the role of SLAB_HWCACHE_ALIGN for SLOB.

The only remaining use is in sparc64 and ppc64 and their use there
reflects some earlier role that the slab flag once may have had. If
its specified then SLAB_HWCACHE_ALIGN is also specified.

The flag is confusing, inconsistent and has no purpose.

Remove it.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.21-rc6/include/linux/slab.h
===================================================================
--- linux-2.6.21-rc6.orig/include/linux/slab.h	2007-04-16 21:55:03.000000000 -0700
+++ linux-2.6.21-rc6/include/linux/slab.h	2007-04-16 21:55:10.000000000 -0700
@@ -26,7 +26,6 @@ typedef struct kmem_cache kmem_cache_t _
 #define SLAB_POISON		0x00000800UL	/* DEBUG: Poison objects */
 #define SLAB_HWCACHE_ALIGN	0x00002000UL	/* Align objs on cache lines */
 #define SLAB_CACHE_DMA		0x00004000UL	/* Use GFP_DMA memory */
-#define SLAB_MUST_HWCACHE_ALIGN	0x00008000UL	/* Force alignment even if debuggin is active */
 #define SLAB_STORE_USER		0x00010000UL	/* DEBUG: Store the last owner for bug hunting */
 #define SLAB_RECLAIM_ACCOUNT	0x00020000UL	/* Objects are reclaimable */
 #define SLAB_PANIC		0x00040000UL	/* Panic if kmem_cache_create() fails */
Index: linux-2.6.21-rc6/mm/slab.c
===================================================================
--- linux-2.6.21-rc6.orig/mm/slab.c	2007-04-16 21:55:16.000000000 -0700
+++ linux-2.6.21-rc6/mm/slab.c	2007-04-16 21:55:33.000000000 -0700
@@ -175,12 +175,12 @@
 # define CREATE_MASK	(SLAB_DEBUG_INITIAL | SLAB_RED_ZONE | \
 			 SLAB_POISON | SLAB_HWCACHE_ALIGN | \
 			 SLAB_CACHE_DMA | \
-			 SLAB_MUST_HWCACHE_ALIGN | SLAB_STORE_USER | \
+			 SLAB_STORE_USER | \
 			 SLAB_RECLAIM_ACCOUNT | SLAB_PANIC | \
 			 SLAB_DESTROY_BY_RCU | SLAB_MEM_SPREAD)
 #else
 # define CREATE_MASK	(SLAB_HWCACHE_ALIGN | \
-			 SLAB_CACHE_DMA | SLAB_MUST_HWCACHE_ALIGN | \
+			 SLAB_CACHE_DMA | \
 			 SLAB_RECLAIM_ACCOUNT | SLAB_PANIC | \
 			 SLAB_DESTROY_BY_RCU | SLAB_MEM_SPREAD)
 #endif
Index: linux-2.6.21-rc6/mm/slub.c
===================================================================
--- linux-2.6.21-rc6.orig/mm/slub.c	2007-04-16 21:55:38.000000000 -0700
+++ linux-2.6.21-rc6/mm/slub.c	2007-04-16 21:56:07.000000000 -0700
@@ -1500,7 +1500,7 @@ static int calculate_order(int size)
 static unsigned long calculate_alignment(unsigned long flags,
 		unsigned long align)
 {
-	if (flags & (SLAB_MUST_HWCACHE_ALIGN | SLAB_HWCACHE_ALIGN))
+	if (flags & SLAB_HWCACHE_ALIGN)
 		return max_t(unsigned long, align, L1_CACHE_BYTES);
 
 	if (align < ARCH_SLAB_MINALIGN)
@@ -3083,8 +3083,7 @@ SLAB_ATTR(reclaim_account);
 
 static ssize_t hwcache_align_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", !!(s->flags &
-		(SLAB_HWCACHE_ALIGN|SLAB_MUST_HWCACHE_ALIGN)));
+	return sprintf(buf, "%d\n", !!(s->flags & SLAB_HWCACHE_ALIGN));
 }
 SLAB_ATTR_RO(hwcache_align);
 
Index: linux-2.6.21-rc6/arch/powerpc/mm/hugetlbpage.c
===================================================================
--- linux-2.6.21-rc6.orig/arch/powerpc/mm/hugetlbpage.c	2007-04-16 21:58:53.000000000 -0700
+++ linux-2.6.21-rc6/arch/powerpc/mm/hugetlbpage.c	2007-04-16 21:59:02.000000000 -0700
@@ -1063,8 +1063,7 @@ static int __init hugetlbpage_init(void)
 	huge_pgtable_cache = kmem_cache_create("hugepte_cache",
 					       HUGEPTE_TABLE_SIZE,
 					       HUGEPTE_TABLE_SIZE,
-					       SLAB_HWCACHE_ALIGN |
-					       SLAB_MUST_HWCACHE_ALIGN,
+					       SLAB_HWCACHE_ALIGN,
 					       zero_ctor, NULL);
 	if (! huge_pgtable_cache)
 		panic("hugetlbpage_init(): could not create hugepte cache\n");
Index: linux-2.6.21-rc6/arch/powerpc/mm/init_64.c
===================================================================
--- linux-2.6.21-rc6.orig/arch/powerpc/mm/init_64.c	2007-04-16 21:59:08.000000000 -0700
+++ linux-2.6.21-rc6/arch/powerpc/mm/init_64.c	2007-04-16 21:59:19.000000000 -0700
@@ -183,8 +183,7 @@ void pgtable_cache_init(void)
 		    "for size: %08x...\n", name, i, size);
 		pgtable_cache[i] = kmem_cache_create(name,
 						     size, size,
-						     SLAB_HWCACHE_ALIGN |
-						     SLAB_MUST_HWCACHE_ALIGN,
+						     SLAB_HWCACHE_ALIGN,
 						     zero_ctor,
 						     NULL);
 		if (! pgtable_cache[i])
Index: linux-2.6.21-rc6/arch/sparc64/mm/init.c
===================================================================
--- linux-2.6.21-rc6.orig/arch/sparc64/mm/init.c	2007-04-16 21:59:32.000000000 -0700
+++ linux-2.6.21-rc6/arch/sparc64/mm/init.c	2007-04-16 21:59:40.000000000 -0700
@@ -191,8 +191,7 @@ void pgtable_cache_init(void)
 {
 	pgtable_cache = kmem_cache_create("pgtable_cache",
 					  PAGE_SIZE, PAGE_SIZE,
-					  SLAB_HWCACHE_ALIGN |
-					  SLAB_MUST_HWCACHE_ALIGN,
+					  SLAB_HWCACHE_ALIGN,
 					  zero_ctor,
 					  NULL);
 	if (!pgtable_cache) {
Index: linux-2.6.21-rc6/arch/sparc64/mm/tsb.c
===================================================================
--- linux-2.6.21-rc6.orig/arch/sparc64/mm/tsb.c	2007-04-16 22:00:02.000000000 -0700
+++ linux-2.6.21-rc6/arch/sparc64/mm/tsb.c	2007-04-16 22:00:12.000000000 -0700
@@ -262,8 +262,7 @@ void __init tsb_cache_init(void)
 
 		tsb_caches[i] = kmem_cache_create(name,
 						  size, size,
-						  SLAB_HWCACHE_ALIGN |
-						  SLAB_MUST_HWCACHE_ALIGN,
+						  SLAB_HWCACHE_ALIGN,
 						  NULL, NULL);
 		if (!tsb_caches[i]) {
 			prom_printf("Could not create %s cache\n", name);
Index: linux-2.6.21-rc6/mm/slob.c
===================================================================
--- linux-2.6.21-rc6.orig/mm/slob.c	2007-04-16 21:57:43.000000000 -0700
+++ linux-2.6.21-rc6/mm/slob.c	2007-04-16 21:58:28.000000000 -0700
@@ -21,7 +21,7 @@
  *
  * SLAB is emulated on top of SLOB by simply calling constructors and
  * destructors for every SLAB allocation. Objects are returned with
- * the 8-byte alignment unless the SLAB_MUST_HWCACHE_ALIGN flag is
+ * the 8-byte alignment unless the SLAB_HWCACHE_ALIGN flag is
  * set, in which case the low-level allocator will fragment blocks to
  * create the proper alignment. Again, objects of page-size or greater
  * are allocated by calling __get_free_pages. As SLAB objects know
@@ -295,7 +295,7 @@ struct kmem_cache *kmem_cache_create(con
 		c->ctor = ctor;
 		c->dtor = dtor;
 		/* ignore alignment unless it's forced */
-		c->align = (flags & SLAB_MUST_HWCACHE_ALIGN) ? SLOB_ALIGN : 0;
+		c->align = (flags & SLAB_HWCACHE_ALIGN) ? SLOB_ALIGN : 0;
 		if (c->align < align)
 			c->align = align;
 	}
