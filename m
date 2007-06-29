Return-Path: <linux-kernel-owner+w=401wt.eu-S1752632AbXF2EBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbXF2EBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 00:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750703AbXF2EBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 00:01:40 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:39800 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750702AbXF2EBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 00:01:40 -0400
Date: Thu, 28 Jun 2007 21:01:36 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>,
       Russell King <rmk+lkml@arm.linux.org.uk>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Containment measures for slab objects on scatter gather
 lists
Message-ID: <Pine.LNX.4.64.0706282047160.10035@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I had a talk with James Bottomley last night and it seems that there is an 
established way of using the page structs of slab objects in the block 
layer. Drivers may use the DMA interfaces to issue control commands. In 
that case they may allocate a short structure via the slab allocator and 
put the control commands into that slab object.

The driver will then perform a sg_init_one() on the slab object. 
sg_init_one() calls sg_set_buf() which determines the page struct of a 
page. In this case sg_set_buf() will determine the page struct of a slab 
object. The dma layer may then perform operations on the "slab page". The 
block layer folks seem to have spend some time to make this work right.

That usage is made a bit dangerous by the issue that the fields of the 
page struct are used to varying degrees by slab allocators for their own 
purposes. A particular problem arises with SLUB since SLUB needs to 
maximizes the usage of the page struct fields to avoid having to put 
control structures in the page itself and be able to completely fill up a 
page with slab objects.

What is new in SLUB is the overloading of the mapping, index and mapcount 
fields. The other slab allocators only overload the lru and private fields 
(The version of SLOB in mm also overloads the index field like SLUB).

So it is in general not possible to call arbitrary page cache functions on 
slab pages because fields are used in ways not conforming to page cache 
use. The use of slab page structs on scatter gather lists currently only 
works because a select number of page cache functions are called on them 
that make restricted use of fields in the page structs.

The called functions are:

kmap / kunmap

	This is not a problem since slab pages are never highmem
	pages. The effect of kmap if used on the page struct of a slab page
	is to determine the address of the page.

flush_dcache_page

	This is a no op for most architectures. On architectures that
	have a virtualized cache it is necessary to flush all the
	page ranges in which this page is mapped. For that purpose
	the mapping of a page must be determined. Since SLUB uses
	the mapping for a pointer to the kmem_cache structure this
	will result in using a kmem_cache address. If this address is
	used like an address_space structure then the kernel will oops.

	flush_dcache_page() must flush even for slab objects if
	slab objects are put onto the scatter gather lists since the
	dma engine must be able to read the information of the control
	structure from memory. The block layer will take care of any objects
	overlapping page boundaries and flush multiple pages if necessary.

We have only recently encountered this issue which is due to the following:

1. Architectures that need to flush virtual caches are rare and so
   flush_dcache_page() typically does nothing or nothing harmful since
   page->mapping, page->mapcount and page->index are not used.

2. It is not too frequent for a driver to perform a kmalloc in order to
   generate a control structure. As a result tests on sparc64 and arm
   did not show any problems.

Architectures affected seem to be only pa-risc and arm. Sparc64 may be 
affected too but sparc64 does not use page_mapping to scan over uses of 
the page (and xtensa has the virtual cache flushing commented out for some 
reason). The issue is currently fixed in Linus' tree by Hugh's check for a 
slab page in page_mapping.

We have here an established use that is somewhat dicey. It may be best to 
ensure that the sort of use is restricted to the functions listed above. 
The issue only occurs in the flush_dcache_page() of the two or three 
listed platforms.

Make sure that no other page cache functions are called for such pages by 
putting a VM_BUG_ON(PageSlab(page)) into the frequently used 
page_mapping() inline function. It will trigger even on platforms that do 
not implement a flush_dcache_page() function if page_mapping() is used on 
any slab page so that we can detect potential issues early. This is useful 
regardless of the slab allocator in use since in general a slab page 
cannot be handled like a regular page cache page.

Modify the functions in the affected arches to check for PageSlab() and 
use a NULL mapping if such a page is encountered. This may only be 
necessary for parisc and arm since sparc64 and xtensa do not scan over 
processes mapping a page but I have modified those two arches also for 
correctnesses sake since they use page_mapping() in flush_dcache_page().

Still a better solution would be to not use the slab allocator at all for 
the objects that are used to send commands to the devices. These are not 
permanent and grabbing a page from the pcp lists and putting it back is 
likely as fast as performing a kmalloc.

I have no access to the platforms discussed here. Testing was restricted 
to running it on my laptop.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6/arch/arm/mm/flush.c
===================================================================
--- linux-2.6.orig/arch/arm/mm/flush.c	2007-06-28 18:57:18.000000000 -0700
+++ linux-2.6/arch/arm/mm/flush.c	2007-06-28 19:11:46.000000000 -0700
@@ -188,7 +188,17 @@
  */
 void flush_dcache_page(struct page *page)
 {
-	struct address_space *mapping = page_mapping(page);
+	struct address_space *mapping;
+
+	/*
+	 * This function is special in that a page struct obtained via
+	 * virt_to_page from a slab object may be passed to it. However, slab
+	 * allocators may use the mapping field for their own purposes. As a
+	 * result mapping may be != NULL here although the page is not mapped.
+	 * Slab objects are never mapped into user space so use NULL for that
+	 * special case.
+	 */
+	mapping = PageSlab(page) ? NULL : page_mapping(page);
 
 #ifndef CONFIG_SMP
 	if (mapping && !mapping_mapped(mapping))
Index: linux-2.6/arch/parisc/kernel/cache.c
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/cache.c	2007-06-28 18:57:18.000000000 -0700
+++ linux-2.6/arch/parisc/kernel/cache.c	2007-06-28 19:11:46.000000000 -0700
@@ -339,7 +339,7 @@
 
 void flush_dcache_page(struct page *page)
 {
-	struct address_space *mapping = page_mapping(page);
+	struct address_space *mapping;
 	struct vm_area_struct *mpnt;
 	struct prio_tree_iter iter;
 	unsigned long offset;
@@ -347,6 +347,15 @@
 	pgoff_t pgoff;
 	unsigned long pfn = page_to_pfn(page);
 
+	/*
+	 * This function is special in that a page struct obtained via
+	 * virt_to_page from a slab object may be passed to it. However, slab
+	 * allocators may use the mapping field for their own purposes. As a
+	 * result mapping may be != NULL here although the page is not mapped.
+	 * Slab objects are never mapped into user space so use NULL for that
+	 * special case.
+	 */
+	mapping = PageSlab(page) ? NULL : page_mapping(page);
 
 	if (mapping && !mapping_mapped(mapping)) {
 		set_bit(PG_dcache_dirty, &page->flags);
Index: linux-2.6/arch/sparc64/mm/init.c
===================================================================
--- linux-2.6.orig/arch/sparc64/mm/init.c	2007-06-28 18:57:18.000000000 -0700
+++ linux-2.6/arch/sparc64/mm/init.c	2007-06-28 19:11:46.000000000 -0700
@@ -339,7 +339,15 @@
 
 	this_cpu = get_cpu();
 
-	mapping = page_mapping(page);
+	/*
+	 * This function is special in that a page struct obtained via
+	 * virt_to_page from a slab object may be passed to it. However, slab
+	 * allocators may use the mapping field for their own purposes. As a
+	 * result mapping may be != NULL here although the page is not mapped.
+	 * Slab objects are never mapped into user space so use NULL for that
+	 * special case.
+	 */
+	mapping = PageSlab(page) ? NULL : page_mapping(page);
 	if (mapping && !mapping_mapped(mapping)) {
 		int dirty = test_bit(PG_dcache_dirty, &page->flags);
 		if (dirty) {
Index: linux-2.6/arch/xtensa/mm/init.c
===================================================================
--- linux-2.6.orig/arch/xtensa/mm/init.c	2007-06-28 18:57:18.000000000 -0700
+++ linux-2.6/arch/xtensa/mm/init.c	2007-06-28 19:11:46.000000000 -0700
@@ -433,7 +433,7 @@
 void flush_dcache_page(struct page *page)
 {
 	unsigned long addr = __pa(page_address(page));
-	struct address_space *mapping = page_mapping(page);
+	struct address_space *mapping;
 
 	__flush_invalidate_dcache_page_phys(addr);
 
@@ -442,6 +442,15 @@
 
 	/* If this page hasn't been mapped, yet, handle I$/D$ coherency later.*/
 #if 0
+	/*
+	 * This function is special in that a page struct obtained via
+	 * virt_to_page from a slab object may be passed to it. However, slab
+	 * allocators may use the mapping field for their own purposes. As a
+	 * result mapping may be != NULL although the page is not mapped.
+	 * Slab objects are never mapped into user space so use NULL for that
+	 * special case.
+	 */
+	mapping = PageSlab(page) ? NULL : page_mapping(page);
 	if (mapping && !mapping_mapped(mapping))
 		clear_bit(PG_cache_clean, &page->flags);
 	else
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2007-06-28 18:57:18.000000000 -0700
+++ linux-2.6/include/linux/mm.h	2007-06-28 19:11:46.000000000 -0700
@@ -601,12 +601,16 @@
 {
 	struct address_space *mapping = page->mapping;
 
+	/*
+	 * The scatter gather layer currently may place the page struct
+	 * of slab objects onto the scatter gather lists. The VM_BUG_ON
+	 * here insures that we get notified if page cache functions are
+	 * called for such a page.
+	 */
+	VM_BUG_ON(PageSlab(page));
+
 	if (unlikely(PageSwapCache(page)))
 		mapping = &swapper_space;
-#ifdef CONFIG_SLUB
-	else if (unlikely(PageSlab(page)))
-		mapping = NULL;
-#endif
 	else if (unlikely((unsigned long)mapping & PAGE_MAPPING_ANON))
 		mapping = NULL;
 	return mapping;
Index: linux-2.6/include/linux/highmem.h
===================================================================
--- linux-2.6.orig/include/linux/highmem.h	2007-06-28 19:11:48.000000000 -0700
+++ linux-2.6/include/linux/highmem.h	2007-06-28 19:25:36.000000000 -0700
@@ -38,6 +38,11 @@
 #ifndef ARCH_HAS_KMAP
 static inline void *kmap(struct page *page)
 {
+	/*
+	 * WARNING: page may be a slab page and kmap may be called for such
+	 * a page as a result of putting a slab object onto scatter gather
+	 * lists by a device driver.
+	 */
 	might_sleep();
 	return page_address(page);
 }
@@ -48,6 +53,11 @@
 
 static inline void *kmap_atomic(struct page *page, enum km_type idx)
 {
+	/*
+	 * WARNING: page may be a slab page and kmap_atomic may be called for
+	 * such a page as a result of putting a slab object onto scatter gather
+	 * lists by a device driver.
+	 */
 	pagefault_disable();
 	return page_address(page);
 }
