Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbXJXEhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbXJXEhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 00:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbXJXEg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 00:36:57 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51241 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752843AbXJXEg4 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 00:36:56 -0400
Date: Wed, 24 Oct 2007 14:36:19 +1000
From: David Chinner <dgc@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Chinner <dgc@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       dean gaudet <dean@arctic.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Xen-devel <xen-devel@lists.xensource.com>, Morten@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>
Subject: [PATCH] Allow lazy unmapping by taking extra page references V2
Message-ID: <20071024043619.GE66820511@sgi.com>
References: <alpine.DEB.0.9999.0710212015430.2320@twinlark.arctic.org> <471C1A61.1010001@goop.org> <p73sl439s7k.fsf@bingen.suse.de> <471CEEB4.9040807@goop.org> <20071022190740.GA1695@one.firstfloor.org> <20071022223224.GC995458@sgi.com> <20071022233514.GA9057@one.firstfloor.org> <20071023003641.GF995458@sgi.com> <20071023070414.GM66820511@sgi.com> <20071023093035.GB24536@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023093035.GB24536@one.firstfloor.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Allow lazy unmapping of vmap()d regions be taking a reference
on each page in the region being vmap()ed. The page references
get released after the region is vunmap()ed, thereby ensuring
we don't leave stray mappings on freed pages that could lead to
problems pages being reallocated with incorrect mappings
associated with them.

Tested with XFS filesystems with 64k directory blocks with
dirstress and XFSQA.

Version 2:
  - drop the release function stuff and just call put_page()
    as it falls down to the same code in all calling cases.

Signed-Off-By: Dave Chinner <dgc@sgi.com>

---
 fs/xfs/linux-2.6/xfs_buf.c |   21 +-------
 include/linux/vmalloc.h    |    4 +
 mm/vmalloc.c               |  118 +++++++++++++++++++++++++++++++++++++--------
 3 files changed, 106 insertions(+), 37 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_buf.c	2007-10-18 17:11:06.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.c	2007-10-24 09:16:26.930345566 +1000
@@ -187,19 +187,6 @@ free_address(
 {
 	a_list_t	*aentry;
 
-#ifdef CONFIG_XEN
-	/*
-	 * Xen needs to be able to make sure it can get an exclusive
-	 * RO mapping of pages it wants to turn into a pagetable.  If
-	 * a newly allocated page is also still being vmap()ed by xfs,
-	 * it will cause pagetable construction to fail.  This is a
-	 * quick workaround to always eagerly unmap pages so that Xen
-	 * is happy.
-	 */
-	vunmap(addr);
-	return;
-#endif
-
 	aentry = kmalloc(sizeof(a_list_t), GFP_NOWAIT);
 	if (likely(aentry)) {
 		spin_lock(&as_lock);
@@ -209,7 +196,7 @@ free_address(
 		as_list_len++;
 		spin_unlock(&as_lock);
 	} else {
-		vunmap(addr);
+		vunmap_pages(addr);
 	}
 }
 
@@ -228,7 +215,7 @@ purge_addresses(void)
 	spin_unlock(&as_lock);
 
 	while ((old = aentry) != NULL) {
-		vunmap(aentry->vm_addr);
+		vunmap_pages(aentry->vm_addr);
 		aentry = aentry->next;
 		kfree(old);
 	}
@@ -456,8 +443,8 @@ _xfs_buf_map_pages(
 	} else if (flags & XBF_MAPPED) {
 		if (as_list_len > 64)
 			purge_addresses();
-		bp->b_addr = vmap(bp->b_pages, bp->b_page_count,
-					VM_MAP, PAGE_KERNEL);
+		bp->b_addr = vmap_pages(bp->b_pages, bp->b_page_count,
+					VM_MAP, PAGE_KERNEL, xb_to_gfp(flags));
 		if (unlikely(bp->b_addr == NULL))
 			return -ENOMEM;
 		bp->b_addr += bp->b_offset;
Index: 2.6.x-xfs-new/include/linux/vmalloc.h
===================================================================
--- 2.6.x-xfs-new.orig/include/linux/vmalloc.h	2007-09-12 15:41:41.000000000 +1000
+++ 2.6.x-xfs-new/include/linux/vmalloc.h	2007-10-24 09:16:55.194741855 +1000
@@ -51,6 +51,10 @@ extern void *vmap(struct page **pages, u
 			unsigned long flags, pgprot_t prot);
 extern void vunmap(void *addr);
 
+extern void *vmap_pages(struct page **pages, unsigned int count,
+			unsigned long flags, pgprot_t prot, gfp_t gfp_mask);
+extern void vunmap_pages(void *addr);
+
 extern int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
 							unsigned long pgoff);
 void vmalloc_sync_all(void);
Index: 2.6.x-xfs-new/mm/vmalloc.c
===================================================================
--- 2.6.x-xfs-new.orig/mm/vmalloc.c	2007-09-12 15:41:48.000000000 +1000
+++ 2.6.x-xfs-new/mm/vmalloc.c	2007-10-24 09:30:53.447102103 +1000
@@ -318,6 +318,34 @@ struct vm_struct *remove_vm_area(void *a
 	return v;
 }
 
+static int vm_area_alloc_pagearray(struct vm_struct *area, gfp_t gfp_mask,
+				unsigned int nr_pages, int node)
+{
+	struct page **pages;
+	unsigned int array_size;
+
+	array_size = (nr_pages * sizeof(struct page *));
+
+	area->nr_pages = nr_pages;
+	/* Please note that the recursion is strictly bounded. */
+	if (array_size > PAGE_SIZE) {
+		pages = __vmalloc_node(array_size, gfp_mask | __GFP_ZERO,
+					PAGE_KERNEL, node);
+		area->flags |= VM_VPAGES;
+	} else {
+		pages = kmalloc_node(array_size,
+				(gfp_mask & GFP_LEVEL_MASK) | __GFP_ZERO,
+				node);
+	}
+	area->pages = pages;
+	if (!area->pages) {
+		remove_vm_area(area->addr);
+		kfree(area);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
 static void __vunmap(void *addr, int deallocate_pages)
 {
 	struct vm_struct *area;
@@ -346,7 +374,7 @@ static void __vunmap(void *addr, int dea
 
 		for (i = 0; i < area->nr_pages; i++) {
 			BUG_ON(!area->pages[i]);
-			__free_page(area->pages[i]);
+			put_page(area->pages[i]);
 		}
 
 		if (area->flags & VM_VPAGES)
@@ -393,6 +421,23 @@ void vunmap(void *addr)
 EXPORT_SYMBOL(vunmap);
 
 /**
+ *	vunmap_pages  -  release virtual mapping obtained by vmap_pages()
+ *	@addr:		memory base address
+ *
+ *	Free the virtually contiguous memory area starting at @addr,
+ *	which was created from the page array passed to vmap_pages(),
+ *	releasing the reference on the pages gained in vmap_pages().
+ *
+ *	Must not be called in interrupt context.
+ */
+void vunmap_pages(void *addr)
+{
+	BUG_ON(in_interrupt());
+	__vunmap(addr, 1);
+}
+EXPORT_SYMBOL(vunmap_pages);
+
+/**
  *	vmap  -  map an array of pages into virtually contiguous space
  *	@pages:		array of page pointers
  *	@count:		number of pages to map
@@ -422,32 +467,63 @@ void *vmap(struct page **pages, unsigned
 }
 EXPORT_SYMBOL(vmap);
 
+/**
+ *	vmap_pages  -  map an array of pages into virtually contiguous space
+ *	@pages:		array of page pointers
+ *	@count:		number of pages to map
+ *	@flags:		vm_area->flags
+ *	@prot:		page protection for the mapping
+ *	@gfp_mask:	flags for the page level allocator
+ *
+ *	Maps @count pages from @pages into contiguous kernel virtual
+ *	space taking a reference to each page and keeping track of all
+ *	the pages within the vm area structure.
+ */
+void *vmap_pages(struct page **pages, unsigned int count,
+		unsigned long flags, pgprot_t prot, gfp_t gfp_mask)
+{
+	struct vm_struct *area;
+	struct page **pgp;
+	int i;
+
+	if (count > num_physpages)
+		return NULL;
+
+	area = get_vm_area((count << PAGE_SHIFT), flags);
+	if (!area)
+		return NULL;
+	if (vm_area_alloc_pagearray(area, gfp_mask, count, -1))
+		return NULL;
+
+	/* map_vm_area modifies pgp */
+	pgp = pages;
+	if (map_vm_area(area, prot, &pgp)) {
+		vunmap(area->addr);
+		return NULL;
+	}
+	/*
+	 * now that the region is mapped, take a reference to each
+	 * page and store them in the area page array.
+	 */
+	for (i = 0; i < area->nr_pages; i++) {
+		get_page(pages[i]);
+		area->pages[i] = pages[i];
+	}
+
+	return area->addr;
+}
+EXPORT_SYMBOL(vmap_pages);
+
 void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 				pgprot_t prot, int node)
 {
 	struct page **pages;
-	unsigned int nr_pages, array_size, i;
+	unsigned int nr_pages;
+	int i;
 
 	nr_pages = (area->size - PAGE_SIZE) >> PAGE_SHIFT;
-	array_size = (nr_pages * sizeof(struct page *));
-
-	area->nr_pages = nr_pages;
-	/* Please note that the recursion is strictly bounded. */
-	if (array_size > PAGE_SIZE) {
-		pages = __vmalloc_node(array_size, gfp_mask | __GFP_ZERO,
-					PAGE_KERNEL, node);
-		area->flags |= VM_VPAGES;
-	} else {
-		pages = kmalloc_node(array_size,
-				(gfp_mask & GFP_LEVEL_MASK) | __GFP_ZERO,
-				node);
-	}
-	area->pages = pages;
-	if (!area->pages) {
-		remove_vm_area(area->addr);
-		kfree(area);
+	if (vm_area_alloc_pagearray(area, gfp_mask, nr_pages, node))
 		return NULL;
-	}
 
 	for (i = 0; i < area->nr_pages; i++) {
 		if (node < 0)
@@ -461,6 +537,8 @@ void *__vmalloc_area_node(struct vm_stru
 		}
 	}
 
+	/* map_vm_area modifies pages */
+	pages = area->pages;
 	if (map_vm_area(area, prot, &pages))
 		goto fail;
 	return area->addr;
