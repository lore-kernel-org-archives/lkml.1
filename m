Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690AbXJWHFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbXJWHFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbXJWHEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:04:53 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54903 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752305AbXJWHEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:04:52 -0400
Date: Tue, 23 Oct 2007 17:04:14 +1000
From: David Chinner <dgc@sgi.com>
To: David Chinner <dgc@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       dean gaudet <dean@arctic.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Xen-devel <xen-devel@lists.xensource.com>, Morten@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>
Subject: [patch] Re: Interaction between Xen and XFS: stray RW mappings
Message-ID: <20071023070414.GM66820511@sgi.com>
References: <4712A254.4090604@goop.org> <200710151415.07248.nickpiggin@yahoo.com.au> <alpine.DEB.0.9999.0710212015430.2320@twinlark.arctic.org> <471C1A61.1010001@goop.org> <p73sl439s7k.fsf@bingen.suse.de> <471CEEB4.9040807@goop.org> <20071022190740.GA1695@one.firstfloor.org> <20071022223224.GC995458@sgi.com> <20071022233514.GA9057@one.firstfloor.org> <20071023003641.GF995458@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023003641.GF995458@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 10:36:41AM +1000, David Chinner wrote:
> On Tue, Oct 23, 2007 at 01:35:14AM +0200, Andi Kleen wrote:
> > On Tue, Oct 23, 2007 at 08:32:25AM +1000, David Chinner wrote:
> > > Could vmap()/vunmap() take references to the pages that are mapped? That
> > > way delaying the unmap would also delay the freeing of the pages and hence
> > > we'd have no problems with the pages being reused before the mapping is
> > > torn down. That'd work for Xen even with XFS's lazy unmapping scheme, and
> > > would allow Nick's more advanced methods to work as well....
> > 
> > You could always just keep around an array of the pages and then drop the
> > reference count after unmap. Or walk the vmalloc mapping and generate such
> > an array before freeing, then unmap and then drop the reference counts.
> 
> You mean like vmap() could record the pages passed to it in the area->pages
> array, and we walk and release than in __vunmap() like it already does
> for vfree()?
> 
> If we did this, it would probably be best to pass a page release function
> into the vmap or vunmap call - we'd need page_cache_release() called on
> the page rather than __free_page()....
> 
> The solution belongs behind the vmap/vunmap interface, not in XFS....

Lightly tested(*) patch that does this with lazy unmapping
below for comment.

(*) a) kernel boots, b) made an XFS filesystem with 64k directory
blocks, created ~100,000 files in a directory to get a wide btree
(~1700 blocks, still only a single level) and run repeated finds
across it dropping caches in between.  Each traversal maps and
unmaps every btree block.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/linux-2.6/xfs_buf.c |   21 +----
 include/linux/vmalloc.h    |    4 +
 mm/vmalloc.c               |  160 +++++++++++++++++++++++++++++++++++----------
 3 files changed, 133 insertions(+), 52 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_buf.c	2007-10-18 17:11:06.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.c	2007-10-23 14:48:32.131088616 +1000
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
+		vunmap_pages(addr, put_page);
 	}
 }
 
@@ -228,7 +215,7 @@ purge_addresses(void)
 	spin_unlock(&as_lock);
 
 	while ((old = aentry) != NULL) {
-		vunmap(aentry->vm_addr);
+		vunmap_pages(aentry->vm_addr, put_page);
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
+++ 2.6.x-xfs-new/include/linux/vmalloc.h	2007-10-23 14:36:56.264860921 +1000
@@ -51,6 +51,10 @@ extern void *vmap(struct page **pages, u
 			unsigned long flags, pgprot_t prot);
 extern void vunmap(void *addr);
 
+extern void *vmap_pages(struct page **pages, unsigned int count,
+			unsigned long flags, pgprot_t prot, gfp_t gfp_mask);
+extern void vunmap_pages(void *addr, void (*release)(struct page *page));
+
 extern int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
 							unsigned long pgoff);
 void vmalloc_sync_all(void);
Index: 2.6.x-xfs-new/mm/vmalloc.c
===================================================================
--- 2.6.x-xfs-new.orig/mm/vmalloc.c	2007-09-12 15:41:48.000000000 +1000
+++ 2.6.x-xfs-new/mm/vmalloc.c	2007-10-23 16:29:40.130384957 +1000
@@ -318,7 +318,56 @@ struct vm_struct *remove_vm_area(void *a
 	return v;
 }
 
-static void __vunmap(void *addr, int deallocate_pages)
+static void vm_area_release_page(struct page *page)
+{
+	__free_page(page);
+}
+
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
+static void vm_area_release_pagearray(struct vm_struct *area,
+				void (*release)(struct page *))
+{
+	int i;
+
+	for (i = 0; i < area->nr_pages; i++) {
+		BUG_ON(!area->pages[i]);
+		release(area->pages[i]);
+	}
+
+	if (area->flags & VM_VPAGES)
+		vfree(area->pages);
+	else
+		kfree(area->pages);
+}
+
+static void __vunmap(void *addr, void (*release)(struct page *))
 {
 	struct vm_struct *area;
 
@@ -341,19 +390,8 @@ static void __vunmap(void *addr, int dea
 
 	debug_check_no_locks_freed(addr, area->size);
 
-	if (deallocate_pages) {
-		int i;
-
-		for (i = 0; i < area->nr_pages; i++) {
-			BUG_ON(!area->pages[i]);
-			__free_page(area->pages[i]);
-		}
-
-		if (area->flags & VM_VPAGES)
-			vfree(area->pages);
-		else
-			kfree(area->pages);
-	}
+	if (release)
+		vm_area_release_pagearray(area, release);
 
 	kfree(area);
 	return;
@@ -372,7 +410,7 @@ static void __vunmap(void *addr, int dea
 void vfree(void *addr)
 {
 	BUG_ON(in_interrupt());
-	__vunmap(addr, 1);
+	__vunmap(addr, vm_area_release_page);
 }
 EXPORT_SYMBOL(vfree);
 
@@ -388,11 +426,30 @@ EXPORT_SYMBOL(vfree);
 void vunmap(void *addr)
 {
 	BUG_ON(in_interrupt());
-	__vunmap(addr, 0);
+	__vunmap(addr, NULL);
 }
 EXPORT_SYMBOL(vunmap);
 
 /**
+ *	vunmap_pages  -  release virtual mapping obtained by vmap_pages()
+ *	@addr:		memory base address
+ *	@release:	release page callback function
+ *
+ *	Free the virtually contiguous memory area starting at @addr,
+ *	which was created from the page array passed to vmap_pages(),
+ *	then call the release function on each page in the associated
+ *	array of page attached to the area.
+ *
+ *	Must not be called in interrupt context.
+ */
+void vunmap_pages(void *addr, void (*release)(struct page *))
+{
+	BUG_ON(in_interrupt());
+	__vunmap(addr, release);
+}
+EXPORT_SYMBOL(vunmap_pages);
+
+/**
  *	vmap  -  map an array of pages into virtually contiguous space
  *	@pages:		array of page pointers
  *	@count:		number of pages to map
@@ -422,32 +479,63 @@ void *vmap(struct page **pages, unsigned
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
@@ -461,6 +549,8 @@ void *__vmalloc_area_node(struct vm_stru
 		}
 	}
 
+	/* map_vm_area modifies pages */
+	pages = area->pages;
 	if (map_vm_area(area, prot, &pages))
 		goto fail;
 	return area->addr;
