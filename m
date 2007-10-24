Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbXJXXVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbXJXXVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 19:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbXJXXVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 19:21:40 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60280 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753635AbXJXXVj (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 19:21:39 -0400
Date: Thu, 25 Oct 2007 09:21:10 +1000
From: David Chinner <dgc@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Chinner <dgc@sgi.com>, Andi Kleen <andi@firstfloor.org>,
       dean gaudet <dean@arctic.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Xen-devel <xen-devel@lists.xensource.com>, Morten@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>
Subject: Re: [PATCH] Allow lazy unmapping by taking extra page references V3
Message-ID: <20071024232110.GO66820511@sgi.com>
References: <20071022190740.GA1695@one.firstfloor.org> <20071022223224.GC995458@sgi.com> <20071022233514.GA9057@one.firstfloor.org> <20071023003641.GF995458@sgi.com> <20071023070414.GM66820511@sgi.com> <20071023093035.GB24536@one.firstfloor.org> <20071024043619.GE66820511@sgi.com> <471ED35F.3020605@goop.org> <20071024214826.GH66820511@sgi.com> <471FCB38.10106@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471FCB38.10106@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 03:46:16PM -0700, Jeremy Fitzhardinge wrote:
> David Chinner wrote:
> > Version 3:
> >   - compile on latest -git
> >   
> 
> Not quite:
> 
>   CC      mm/vmalloc.o
> /home/jeremy/hg/xen/paravirt/linux/mm/vmalloc.c: In function 'vm_area_alloc_pagearray':
> /home/jeremy/hg/xen/paravirt/linux/mm/vmalloc.c:338: error: 'GFP_LEVEL_MASK' undeclared (first use in this function)
> /home/jeremy/hg/xen/paravirt/linux/mm/vmalloc.c:338: error: (Each undeclared identifier is reported only once
> /home/jeremy/hg/xen/paravirt/linux/mm/vmalloc.c:338: error: for each function it appears in.)
> make[3]: *** [mm/vmalloc.o] Error 1
> make[2]: *** [mm] Error 2
> make[2]: *** Waiting for unfinished jobs....
> 
> 
> GFP_RECLAM_MASK now?

Yeah, it is. Not sure what happened there - I did make that change.
new diff below.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index b9c8589..38f073f 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
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
@@ -209,7 +196,7 @@ #endif
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
@@ -458,8 +445,8 @@ _xfs_buf_map_pages(
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
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 89338b4..40c34da 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
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
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index af77e17..720f338 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -319,6 +319,34 @@ struct vm_struct *remove_vm_area(void *a
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
+				(gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO,
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
@@ -347,7 +375,7 @@ static void __vunmap(void *addr, int dea
 
 		for (i = 0; i < area->nr_pages; i++) {
 			BUG_ON(!area->pages[i]);
-			__free_page(area->pages[i]);
+			put_page(area->pages[i]);
 		}
 
 		if (area->flags & VM_VPAGES)
@@ -394,6 +422,23 @@ void vunmap(void *addr)
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
@@ -423,32 +468,63 @@ void *vmap(struct page **pages, unsigned
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
-				(gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO,
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
@@ -462,6 +538,8 @@ void *__vmalloc_area_node(struct vm_stru
 		}
 	}
 
+	/* map_vm_area modifies pages */
+	pages = area->pages;
 	if (map_vm_area(area, prot, &pages))
 		goto fail;
 	return area->addr;
