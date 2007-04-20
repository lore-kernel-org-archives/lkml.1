Return-Path: <linux-kernel-owner+w=401wt.eu-S2993301AbXDTSBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993301AbXDTSBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 14:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993110AbXDTSBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 14:01:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36832 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993301AbXDTSBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 14:01:16 -0400
Date: Fri, 20 Apr 2007 11:01:15 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: Mel Gorman <mel@skynet.ie>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 7/8] Enhance ramfs to support higher order pages
In-Reply-To: <20070420171928.GA2986@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0704201100040.20868@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
 <20070419163540.11948.51549.sendpatchset@schroedinger.engr.sgi.com>
 <20070420134226.GA16878@skynet.ie> <20070420144726.GI31925@holomorphy.com>
 <Pine.LNX.4.64.0704200925160.20232@schroedinger.engr.sgi.com>
 <20070420171118.GZ2986@holomorphy.com> <Pine.LNX.4.64.0704201012500.20723@schroedinger.engr.sgi.com>
 <20070420171928.GA2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Variable Order Page Cache: mmap_nopage and mmap_populate

Fix up both functions to be able to operate on arbitrary order
pages. However, both functions establish page table entries
in PAGE_SIZE only and the offset and pgoffset when calling
both functions is always in PAGE_SIZE units. Thus the parameters
were renamed to pgoff_page which is in PAGE_SIZE unites in
constrast to pgoff which is in the order prescribed by the
address space.

As a result both functions may handle a page struct pointer to
a tail page. That is the page to be mapped or that was mapped.
However, that page struct cannot be used to get a refcount
or mark page characteristics. This can only be done on the
head page!

We need to fixup install_page also since filemap_populate
relies on it.

[WARNING: Early early draft may not compile untested]

---
 mm/filemap.c |   38 ++++++++++++++++++++++++++++----------
 mm/fremap.c  |   17 +++++++++++------
 2 files changed, 39 insertions(+), 16 deletions(-)

Index: linux-2.6.21-rc7/mm/filemap.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/filemap.c	2007-04-19 21:26:16.000000000 -0700
+++ linux-2.6.21-rc7/mm/filemap.c	2007-04-19 21:27:55.000000000 -0700
@@ -1318,6 +1318,12 @@ static int fastcall page_cache_read(stru
  * The goto's are kind of ugly, but this streamlines the normal case of having
  * it in the page cache, and handles the special cases reasonably without
  * having a lot of duplicated code.
+ *
+ * filemap_nopage returns pointer to a page that may be a tail page
+ * of a compound page suitable for the VM to map a PAGE_SIZE portion.
+ * However, the VM must update state information in the head page
+ * alone. F.e. Taking a refcount on a tail page does not have the
+ * intended effect.
  */
 struct page *filemap_nopage(struct vm_area_struct *area,
 				unsigned long address, int *type)
@@ -1328,13 +1334,15 @@ struct page *filemap_nopage(struct vm_ar
 	struct file_ra_state *ra = &file->f_ra;
 	struct inode *inode = mapping->host;
 	struct page *page;
-	unsigned long size, pgoff;
+	unsigned long size, pgoff, pgoff_page, compound_index;
 	int did_readaround = 0, majmin = VM_FAULT_MINOR;
 
-	pgoff = ((address-area->vm_start) >> PAGE_CACHE_SHIFT) + area->vm_pgoff;
+	pgoff_page = ((address-area->vm_start) >> PAGE_CACHE_SHIFT) + area->vm_pgoff;
+	pgoff = pgoff_page >> mapping->order;
+	compound_index = pg_off_page % (1 << mapping->order);
 
 retry_all:
-	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	size = (i_size_read(inode) + page_cache_size(mapping) - 1) >> page_cache_shift(mapping);
 	if (pgoff >= size)
 		goto outside_data_content;
 
@@ -1412,7 +1420,7 @@ success:
 	mark_page_accessed(page);
 	if (type)
 		*type = majmin;
-	return page;
+	return page + compound_index;
 
 outside_data_content:
 	/*
@@ -1637,8 +1645,12 @@ err:
 	return NULL;
 }
 
+/*
+ * filemap_populate installs page sized ptes in the indicated area.
+ * However, the underlying pages may be of higher order.
+ */
 int filemap_populate(struct vm_area_struct *vma, unsigned long addr,
-		unsigned long len, pgprot_t prot, unsigned long pgoff,
+		unsigned long len, pgprot_t prot, unsigned long pgoff_page,
 		int nonblock)
 {
 	struct file *file = vma->vm_file;
@@ -1648,14 +1660,20 @@ int filemap_populate(struct vm_area_stru
 	struct mm_struct *mm = vma->vm_mm;
 	struct page *page;
 	int err;
+	unsigned long pgoff;
+	int compound_index;
 
 	if (!nonblock)
 		force_page_cache_readahead(mapping, vma->vm_file,
-					pgoff, len >> PAGE_CACHE_SHIFT);
+			pgoff_page >> mapping->order,
+			len >> page_cache_shift(mapping));
 
 repeat:
-	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-	if (pgoff + (len >> PAGE_CACHE_SHIFT) > size)
+	pgoff = pgoff_page >> mapping->order;
+	compound_index = pgoff_page % (1 << mapping->order);
+
+	size = (i_size_read(inode) + page_cache_size(mapping) - 1) >> page_cache_shift(mapping);
+	if (pgoff + (len >> page_cache_shift(mapping)) > size)
 		return -EINVAL;
 
 	page = filemap_getpage(file, pgoff, nonblock);
@@ -1666,7 +1684,7 @@ repeat:
 		return -ENOMEM;
 
 	if (page) {
-		err = install_page(mm, vma, addr, page, prot);
+		err = install_page(mm, vma, addr, page + compound_index, prot);
 		if (err) {
 			page_cache_release(page);
 			return err;
@@ -1682,7 +1700,7 @@ repeat:
 
 	len -= PAGE_SIZE;
 	addr += PAGE_SIZE;
-	pgoff++;
+	pgoff_page++;
 	if (len)
 		goto repeat;
 
Index: linux-2.6.21-rc7/mm/fremap.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/fremap.c	2007-04-19 21:33:34.000000000 -0700
+++ linux-2.6.21-rc7/mm/fremap.c	2007-04-19 21:37:30.000000000 -0700
@@ -46,7 +46,9 @@ static int zap_pte(struct mm_struct *mm,
 
 /*
  * Install a file page to a given virtual memory address, release any
- * previously existing mapping.
+ * previously existing mapping. The page may point to a tail page
+ * in which case we update the state in the head page but establish
+ * a PAGE_SIZEd mapping to the tail page alone.
  */
 int install_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		unsigned long addr, struct page *page, pgprot_t prot)
@@ -57,6 +59,8 @@ int install_page(struct mm_struct *mm, s
 	pte_t *pte;
 	pte_t pte_val;
 	spinlock_t *ptl;
+	struct address_space *mapping;
+	struct head_page *page = compound_head(page);
 
 	pte = get_locked_pte(mm, addr, &ptl);
 	if (!pte)
@@ -67,12 +71,13 @@ int install_page(struct mm_struct *mm, s
 	 * caller about it.
 	 */
 	err = -EINVAL;
-	inode = vma->vm_file->f_mapping->host;
-	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-	if (!page->mapping || page->index >= size)
+	mapping = vma->vm_file->f_mapping;
+	inode = mapping->host;
+	size = (i_size_read(inode) + page_cache_size(mapping) - 1) >> page_cache_shift(mapping);
+	if (!head_page->mapping || head_page->index >= size)
 		goto unlock;
 	err = -ENOMEM;
-	if (page_mapcount(page) > INT_MAX/2)
+	if (page_mapcount(head_page) > INT_MAX/2)
 		goto unlock;
 
 	if (pte_none(*pte) || !zap_pte(mm, vma, addr, pte))
@@ -81,7 +86,7 @@ int install_page(struct mm_struct *mm, s
 	flush_icache_page(vma, page);
 	pte_val = mk_pte(page, prot);
 	set_pte_at(mm, addr, pte, pte_val);
-	page_add_file_rmap(page);
+	page_add_file_rmap(head_page);
 	update_mmu_cache(vma, addr, pte_val);
 	lazy_mmu_prot_update(pte_val);
 	err = 0;

