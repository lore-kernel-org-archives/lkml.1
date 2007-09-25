Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438AbXIYXpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbXIYXpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbXIYXnC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:43:02 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36404 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752397AbXIYXmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:42:51 -0400
Message-Id: <20070925234250.573532513@sgi.com>
References: <20070925234204.546836393@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 25 Sep 2007 16:42:10 -0700
From: Christoph Lameter <clameter@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [06/17] vunmap: return page array passed on vmap()
Content-Disposition: inline; filename=vcompound_vunmap_returns_pages
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make vunmap return the page array that was used at vmap. This is useful
if one has no structures to track the page array but simply stores the
virtual address somewhere. The disposition of the page array can be
decided upon after vunmap. vfree() may now also be used instead of
vunmap which will release the page array after vunmap'ping it.

As noted by Kamezawa: The same subsystem that provides the page array
to vmap must must use its own method to dispose of the page array.

If vfree() is called to free the page array then the page array must either
be

1. Allocated via the slab allocator

2. Allocated via vmalloc but then VM_VPAGES must have been passed at
   vunmap to specify that a vfree is needed.

RFC->v1:
- Add comment explaining how to use vfree() to dispose of the page
  array passed on vmap().

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/vmalloc.h |    2 +-
 mm/vmalloc.c            |   33 +++++++++++++++++++++++----------
 2 files changed, 24 insertions(+), 11 deletions(-)

Index: linux-2.6/include/linux/vmalloc.h
===================================================================
--- linux-2.6.orig/include/linux/vmalloc.h	2007-09-24 15:52:53.000000000 -0700
+++ linux-2.6/include/linux/vmalloc.h	2007-09-24 15:59:15.000000000 -0700
@@ -49,7 +49,7 @@ extern void vfree(const void *addr);
 
 extern void *vmap(struct page **pages, unsigned int count,
 			unsigned long flags, pgprot_t prot);
-extern void vunmap(const void *addr);
+extern struct page **vunmap(const void *addr);
 
 extern int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
 							unsigned long pgoff);
Index: linux-2.6/mm/vmalloc.c
===================================================================
--- linux-2.6.orig/mm/vmalloc.c	2007-09-24 15:56:49.000000000 -0700
+++ linux-2.6/mm/vmalloc.c	2007-09-24 16:02:10.000000000 -0700
@@ -356,17 +356,18 @@ struct vm_struct *remove_vm_area(const v
 	return v;
 }
 
-static void __vunmap(const void *addr, int deallocate_pages)
+static struct page **__vunmap(const void *addr, int deallocate_pages)
 {
 	struct vm_struct *area;
+	struct page **pages;
 
 	if (!addr)
-		return;
+		return NULL;
 
 	if ((PAGE_SIZE-1) & (unsigned long)addr) {
 		printk(KERN_ERR "Trying to vfree() bad address (%p)\n", addr);
 		WARN_ON(1);
-		return;
+		return NULL;
 	}
 
 	area = remove_vm_area(addr);
@@ -374,29 +375,30 @@ static void __vunmap(const void *addr, i
 		printk(KERN_ERR "Trying to vfree() nonexistent vm area (%p)\n",
 				addr);
 		WARN_ON(1);
-		return;
+		return NULL;
 	}
 
+	pages = area->pages;
 	debug_check_no_locks_freed(addr, area->size);
 
 	if (deallocate_pages) {
 		int i;
 
 		for (i = 0; i < area->nr_pages; i++) {
-			struct page *page = area->pages[i];
+			struct page *page = pages[i];
 
 			BUG_ON(!page);
 			__free_page(page);
 		}
 
 		if (area->flags & VM_VPAGES)
-			vfree(area->pages);
+			vfree(pages);
 		else
-			kfree(area->pages);
+			kfree(pages);
 	}
 
 	kfree(area);
-	return;
+	return pages;
 }
 
 /**
@@ -424,11 +426,13 @@ EXPORT_SYMBOL(vfree);
  *	which was created from the page array passed to vmap().
  *
  *	Must not be called in interrupt context.
+ *
+ *	Returns a pointer to the array of pointers to page structs
  */
-void vunmap(const void *addr)
+struct page **vunmap(const void *addr)
 {
 	BUG_ON(in_interrupt());
-	__vunmap(addr, 0);
+	return __vunmap(addr, 0);
 }
 EXPORT_SYMBOL(vunmap);
 
@@ -441,6 +445,13 @@ EXPORT_SYMBOL(vunmap);
  *
  *	Maps @count pages from @pages into contiguous kernel virtual
  *	space.
+ *
+ *	The page array may be freed via vfree() on the virtual address
+ *	returned. In that case the page array must be allocated via
+ *	the slab allocator. If the page array was allocated via
+ *	vmalloc then VM_VPAGES must be specified in the flags. There is
+ *	no support for vfree() to free a page array allocated via the
+ *	page allocator.
  */
 void *vmap(struct page **pages, unsigned int count,
 		unsigned long flags, pgprot_t prot)
@@ -453,6 +464,8 @@ void *vmap(struct page **pages, unsigned
 	area = get_vm_area((count << PAGE_SHIFT), flags);
 	if (!area)
 		return NULL;
+	area->pages = pages;
+	area->nr_pages = count;
 	if (map_vm_area(area, prot, &pages)) {
 		vunmap(area->addr);
 		return NULL;

-- 
