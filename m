Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbXISDnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbXISDnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 23:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbXISDh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 23:37:28 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54926 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751984AbXISDgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 23:36:42 -0400
Message-Id: <20070919033641.468440734@sgi.com>
From: Christoph Lameter <clameter@sgi.com>
References: <20070919033605.785839297@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Sep 2007 20:36:10 -0700
To: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: [05/17] vunmap: return page array
Content-Disposition: inline; filename=vcompound_vunmap_returns_pages
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make vunmap return the page array that was used at vmap. This is useful
if one has no structures to track the page array but simply stores the
virtual address somewhere. The disposition of the page array can be
decided upon after vunmap. vfree() may now also be used instead of
vunmap which will release the page array after vunmap'ping it.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/vmalloc.h |    2 +-
 mm/vmalloc.c            |   26 ++++++++++++++++----------
 2 files changed, 17 insertions(+), 11 deletions(-)

Index: linux-2.6/include/linux/vmalloc.h
===================================================================
--- linux-2.6.orig/include/linux/vmalloc.h	2007-09-18 13:22:56.000000000 -0700
+++ linux-2.6/include/linux/vmalloc.h	2007-09-18 13:22:57.000000000 -0700
@@ -49,7 +49,7 @@ extern void vfree(const void *addr);
 
 extern void *vmap(struct page **pages, unsigned int count,
 			unsigned long flags, pgprot_t prot);
-extern void vunmap(const void *addr);
+extern struct page **vunmap(const void *addr);
 
 extern int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
 							unsigned long pgoff);
Index: linux-2.6/mm/vmalloc.c
===================================================================
--- linux-2.6.orig/mm/vmalloc.c	2007-09-18 13:22:56.000000000 -0700
+++ linux-2.6/mm/vmalloc.c	2007-09-18 13:22:57.000000000 -0700
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
 
@@ -453,6 +457,8 @@ void *vmap(struct page **pages, unsigned
 	area = get_vm_area((count << PAGE_SHIFT), flags);
 	if (!area)
 		return NULL;
+	area->pages = pages;
+	area->nr_pages = count;
 	if (map_vm_area(area, prot, &pages)) {
 		vunmap(area->addr);
 		return NULL;

-- 
