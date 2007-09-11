Return-Path: <linux-kernel-owner+w=401wt.eu-S1762957AbXIKGWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762957AbXIKGWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762442AbXIKGGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:06:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50594 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762052AbXIKGEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:04:36 -0400
Message-Id: <20070911060435.133534924@sgi.com>
References: <20070911060349.993975297@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 10 Sep 2007 23:04:31 -0700
From: Christoph Lameter <clameter@sgi.com>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com, hugh@veritas.com
Cc: joern@lazybastard.org
Subject: [41/41] Mmap support using pte PAGE_SIZE mappings
Content-Disposition: inline; filename=mmap_new
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is realized by mmapping base page size (4k on x86) of the potentially
larger page. Mmap semantics are not changed and therefore the large buffers
can be handled by userspace as if files consisted of 4k pages (as it is
now). The use of large buffersizes can therefore be fully transparent to user
space.

Details:
- Modify the rmap functions (try_to_unmap, page_referenced and page_mkclean)
  to interate over all base pages of a large buffer to get all ptes
  that may point to a larger buffer.

- Change vm_fault logic in __do_fault() and filemap_fault() to convert from
  4k pte logic into a pointer to the page of the large buffer and an
  index to the basepage in that large buffer.

- Fix up the memory policy address scan to skip tail pages of large buffers.

- Fix up page migration to allow the moving of large buffers.

Tested by formatting a 32k ext2 filesystem, booting off it and building
a kernel.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/mm.h |    1 
 mm/filemap.c       |   27 ++++++++----------
 mm/fremap.c        |    8 +++--
 mm/memory.c        |   79 ++++++++++++++++++++++++++++++++++++++---------------
 mm/mempolicy.c     |   27 ++++++++++++------
 mm/migrate.c       |   17 ++++++++---
 mm/rmap.c          |   63 ++++++++++++++++++++++++++++++++++--------
 7 files changed, 158 insertions(+), 64 deletions(-)

Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2007-09-10 22:37:28.000000000 -0700
+++ linux-2.6/mm/filemap.c	2007-09-10 22:37:29.000000000 -0700
@@ -1320,9 +1320,12 @@ int filemap_fault(struct vm_area_struct 
 	unsigned long size;
 	int did_readaround = 0;
 	int ret = 0;
+	pgoff_t pgoff = vmf->pgoff >> mapping_order(mapping);
 
+	vmf->page_index =
+		vmf->pgoff & ((1 << mapping_order(mapping)) -1);
 	size = page_cache_next(mapping, i_size_read(inode));
-	if (vmf->pgoff >= size)
+	if (pgoff >= size)
 		goto outside_data_content;
 
 	/* If we don't want any read-ahead, don't bother */
@@ -1333,21 +1336,21 @@ int filemap_fault(struct vm_area_struct 
 	 * Do we have something in the page cache already?
 	 */
 retry_find:
-	page = find_lock_page(mapping, vmf->pgoff);
+	page = find_lock_page(mapping, pgoff);
 	/*
 	 * For sequential accesses, we use the generic readahead logic.
 	 */
 	if (VM_SequentialReadHint(vma)) {
 		if (!page) {
 			page_cache_sync_readahead(mapping, ra, file,
-							   vmf->pgoff, 1);
-			page = find_lock_page(mapping, vmf->pgoff);
+							   pgoff, 1);
+			page = find_lock_page(mapping, pgoff);
 			if (!page)
 				goto no_cached_page;
 		}
 		if (PageReadahead(page)) {
 			page_cache_async_readahead(mapping, ra, file, page,
-							   vmf->pgoff, 1);
+							   pgoff, 1);
 		}
 	}
 
@@ -1377,10 +1380,10 @@ retry_find:
 			pgoff_t start = 0;
 
 			if (vmf->pgoff > ra_pages / 2)
-				start = vmf->pgoff - ra_pages / 2;
+				start = pgoff - ra_pages / 2;
 			do_page_cache_readahead(mapping, file, start, ra_pages);
 		}
-		page = find_lock_page(mapping, vmf->pgoff);
+		page = find_lock_page(mapping, pgoff);
 		if (!page)
 			goto no_cached_page;
 	}
@@ -1397,7 +1400,7 @@ retry_find:
 
 	/* Must recheck i_size under page lock */
 	size = page_cache_next(mapping, i_size_read(inode));
-	if (unlikely(vmf->pgoff >= size)) {
+	if (unlikely(pgoff >= size)) {
 		unlock_page(page);
 		goto outside_data_content;
 	}
@@ -1424,7 +1427,7 @@ no_cached_page:
 	 * We're only likely to ever get here if MADV_RANDOM is in
 	 * effect.
 	 */
-	error = page_cache_read(file, vmf->pgoff);
+	error = page_cache_read(file, pgoff);
 
 	/*
 	 * The page we want has now been added to the page cache.
@@ -1479,12 +1482,6 @@ int generic_file_mmap(struct file * file
 {
 	struct address_space *mapping = file->f_mapping;
 
-	/*
-	 * Forbid mmap access to higher order mappings.
-	 */
-	if (mapping_order(mapping))
-		return -ENOSYS;
-
 	if (!mapping->a_ops->readpage)
 		return -ENOEXEC;
 	file_accessed(file);
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2007-09-10 22:37:05.000000000 -0700
+++ linux-2.6/mm/memory.c	2007-09-10 22:37:29.000000000 -0700
@@ -382,6 +382,11 @@ static inline int is_cow_mapping(unsigne
  * and if that isn't true, the page has been COW'ed (in which case it
  * _does_ have a "struct page" associated with it even if it is in a
  * VM_PFNMAP range).
+ *
+ * vm_normal_page may return a tail page of a compound page. The tail
+ * page pointer allows the determination of the PAGE_SIZE slice
+ * intended to be operated upon on. The page head can be determined
+ * from the tail page.
  */
 struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr, pte_t pte)
 {
@@ -478,9 +483,11 @@ copy_one_pte(struct mm_struct *dst_mm, s
 
 	page = vm_normal_page(vma, addr, pte);
 	if (page) {
-		get_page(page);
-		page_dup_rmap(page, vma, addr);
-		rss[!!PageAnon(page)]++;
+		struct page *head = page_cache_head(page);
+
+		get_page(head);
+		page_dup_rmap(head, vma, addr);
+		rss[!!PageAnon(head)]++;
 	}
 
 out_set_pte:
@@ -639,9 +646,20 @@ static unsigned long zap_pte_range(struc
 		(*zap_work) -= PAGE_SIZE;
 
 		if (pte_present(ptent)) {
-			struct page *page;
+			int page_index = 0;
+			int index = 0;
+			struct page *page = vm_normal_page(vma, addr, ptent);
+
+			if (page) {
+				struct page *head = page_cache_head(page);
+
+				page_index = page - head;
+				page = head;
+				index = (page->index <<
+					page_cache_page_order(page))
+					+ page_index;
+			}
 
-			page = vm_normal_page(vma, addr, ptent);
 			if (unlikely(details) && page) {
 				/*
 				 * unmap_shared_mapping_pages() wants to
@@ -656,8 +674,8 @@ static unsigned long zap_pte_range(struc
 				 * invalidating or truncating nonlinear.
 				 */
 				if (details->nonlinear_vma &&
-				    (page->index < details->first_index ||
-				     page->index > details->last_index))
+				    (index < details->first_index ||
+				     index > details->last_index))
 					continue;
 			}
 			ptent = ptep_get_and_clear_full(mm, addr, pte,
@@ -667,9 +685,9 @@ static unsigned long zap_pte_range(struc
 				continue;
 			if (unlikely(details) && details->nonlinear_vma
 			    && linear_page_index(details->nonlinear_vma,
-						addr) != page->index)
+						addr) != index)
 				set_pte_at(mm, addr, pte,
-					   pgoff_to_pte(page->index));
+				   pgoff_to_pte(index));
 			if (PageAnon(page))
 				anon_rss--;
 			else {
@@ -680,7 +698,7 @@ static unsigned long zap_pte_range(struc
 				file_rss--;
 			}
 			page_remove_rmap(page, vma);
-			tlb_remove_page(tlb, page);
+			tlb_remove_page(tlb, page + page_index);
 			continue;
 		}
 		/*
@@ -897,6 +915,10 @@ unsigned long zap_page_range(struct vm_a
 
 /*
  * Do a quick page-table lookup for a single page.
+ *
+ * follow_page() may return a tail page. However, the reference count
+ * is taken on the head page. The head page must be determined
+ * to drop the refcount again.
  */
 struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 			unsigned int flags)
@@ -906,7 +928,7 @@ struct page *follow_page(struct vm_area_
 	pmd_t *pmd;
 	pte_t *ptep, pte;
 	spinlock_t *ptl;
-	struct page *page;
+	struct page *page, *head;
 	struct mm_struct *mm = vma->vm_mm;
 
 	page = follow_huge_addr(mm, address, flags & FOLL_WRITE);
@@ -947,13 +969,14 @@ struct page *follow_page(struct vm_area_
 	if (unlikely(!page))
 		goto unlock;
 
+	head = page_cache_head(page);
 	if (flags & FOLL_GET)
-		get_page(page);
+		get_page(head);
 	if (flags & FOLL_TOUCH) {
 		if ((flags & FOLL_WRITE) &&
-		    !pte_dirty(pte) && !PageDirty(page))
-			set_page_dirty(page);
-		mark_page_accessed(page);
+		    !pte_dirty(pte) && !PageDirty(head))
+			set_page_dirty(head);
+		mark_page_accessed(head);
 	}
 unlock:
 	pte_unmap_unlock(ptep, ptl);
@@ -1022,7 +1045,7 @@ int get_user_pages(struct task_struct *t
 				struct page *page = vm_normal_page(gate_vma, start, *pte);
 				pages[i] = page;
 				if (page)
-					get_page(page);
+					get_page(page_cache_head(page));
 			}
 			pte_unmap(pte);
 			if (vmas)
@@ -1638,13 +1661,20 @@ static int do_wp_page(struct mm_struct *
 {
 	struct page *old_page, *new_page;
 	pte_t entry;
-	int reuse = 0, ret = 0;
+	int reuse = 0, ret = 0, page_index = 0;
 	struct page *dirty_page = NULL;
 
 	old_page = vm_normal_page(vma, address, orig_pte);
 	if (!old_page)
 		goto gotten;
 
+	if (PageTail(old_page)) {
+		struct page *head = page_cache_head(old_page);
+
+		page_index = old_page - head;
+		old_page = head;
+	}
+
 	/*
 	 * Take out anonymous pages first, anonymous shared vmas are
 	 * not dirty accountable.
@@ -1722,7 +1752,8 @@ gotten:
 		new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
 		if (!new_page)
 			goto oom;
-		cow_user_page(new_page, old_page, address, vma);
+		cow_user_page(new_page, old_page + page_index,
+							address, vma);
 	}
 
 	/*
@@ -2316,6 +2347,7 @@ static int __do_fault(struct mm_struct *
 {
 	spinlock_t *ptl;
 	struct page *page;
+	int page_index;
 	pte_t entry;
 	int anon = 0;
 	struct page *dirty_page = NULL;
@@ -2326,6 +2358,7 @@ static int __do_fault(struct mm_struct *
 	vmf.pgoff = pgoff;
 	vmf.flags = flags;
 	vmf.page = NULL;
+	vmf.page_index = 0;
 
 	pte_unmap(page_table);
 	BUG_ON(vma->vm_flags & VM_PFNMAP);
@@ -2358,6 +2391,7 @@ static int __do_fault(struct mm_struct *
 	 * Should we do an early C-O-W break?
 	 */
 	page = vmf.page;
+	page_index = vmf.page_index;
 	if (flags & FAULT_FLAG_WRITE) {
 		if (!(vma->vm_flags & VM_SHARED)) {
 			anon = 1;
@@ -2371,7 +2405,10 @@ static int __do_fault(struct mm_struct *
 				ret = VM_FAULT_OOM;
 				goto out;
 			}
-			copy_user_highpage(page, vmf.page, address, vma);
+			copy_user_highpage(page,
+				vmf.page + page_index, address, vma);
+			/* The newly created anonymous page is of order 0 */
+			page_index = 0;
 		} else {
 			/*
 			 * If the page will be shareable, see if the backing
@@ -2417,8 +2454,8 @@ static int __do_fault(struct mm_struct *
 	 */
 	/* Only go through if we didn't race with anybody else... */
 	if (likely(pte_same(*page_table, orig_pte))) {
-		flush_icache_page(vma, page);
-		entry = mk_pte(page, vma->vm_page_prot);
+		flush_icache_page(vma, page + page_index);
+		entry = mk_pte(page + page_index, vma->vm_page_prot);
 		if (flags & FAULT_FLAG_WRITE)
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 		set_pte_at(mm, address, page_table, entry);
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2007-09-10 22:37:28.000000000 -0700
+++ linux-2.6/include/linux/mm.h	2007-09-10 22:37:29.000000000 -0700
@@ -216,6 +216,7 @@ struct vm_fault {
 					 * is set (which is also implied by
 					 * VM_FAULT_ERROR).
 					 */
+	int page_index;			/* Index into compound page */
 };
 
 /*
Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c	2007-09-10 22:37:05.000000000 -0700
+++ linux-2.6/mm/rmap.c	2007-09-10 22:39:41.000000000 -0700
@@ -271,7 +271,7 @@ pte_t *page_check_address(struct page *p
  * Subfunctions of page_referenced: page_referenced_one called
  * repeatedly from either page_referenced_anon or page_referenced_file.
  */
-static int page_referenced_one(struct page *page,
+static int __page_referenced_one(struct page *page,
 	struct vm_area_struct *vma, unsigned int *mapcount)
 {
 	struct mm_struct *mm = vma->vm_mm;
@@ -303,6 +303,18 @@ out:
 	return referenced;
 }
 
+static int page_referenced_one(struct page *page,
+	struct vm_area_struct *vma, unsigned int *mapcount)
+{
+	int i;
+	int referenced = 0;
+
+	for (i = 0; i < page_cache_base_pages(page); i++)
+		referenced += __page_referenced_one(page + i, vma, mapcount);
+
+	return referenced;
+}
+
 static int page_referenced_anon(struct page *page)
 {
 	unsigned int mapcount;
@@ -417,7 +429,7 @@ int page_referenced(struct page *page, i
 	return referenced;
 }
 
-static int page_mkclean_one(struct page *page, struct vm_area_struct *vma)
+static int __page_mkclean_one(struct page *page, struct vm_area_struct *vma)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address;
@@ -450,6 +462,17 @@ out:
 	return ret;
 }
 
+static int page_mkclean_one(struct page *page, struct vm_area_struct *vma)
+{
+	int i;
+	int ret = 0;
+
+	for (i = 0; i < page_cache_base_pages(page); i++)
+		ret += __page_mkclean_one(page + i, vma);
+
+	return ret;
+}
+
 static int page_mkclean_file(struct address_space *mapping, struct page *page)
 {
 	pgoff_t pgoff = page->index << (page_cache_shift(mapping) - PAGE_SHIFT);
@@ -657,8 +680,8 @@ void page_remove_rmap(struct page *page,
  * Subfunctions of try_to_unmap: try_to_unmap_one called
  * repeatedly from either try_to_unmap_anon or try_to_unmap_file.
  */
-static int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
-				int migration)
+static int __try_to_unmap_one(struct page *page, int page_index,
+		struct vm_area_struct *vma, int migration)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address;
@@ -667,11 +690,11 @@ static int try_to_unmap_one(struct page 
 	spinlock_t *ptl;
 	int ret = SWAP_AGAIN;
 
-	address = vma_address(page, vma);
+	address = vma_address(page + page_index, vma);
 	if (address == -EFAULT)
 		goto out;
 
-	pte = page_check_address(page, mm, address, &ptl);
+	pte = page_check_address(page + page_index, mm, address, &ptl);
 	if (!pte)
 		goto out;
 
@@ -687,7 +710,7 @@ static int try_to_unmap_one(struct page 
 	}
 
 	/* Nuke the page table entry. */
-	flush_cache_page(vma, address, page_to_pfn(page));
+	flush_cache_page(vma, address, page_to_pfn(page) + page_index);
 	pteval = ptep_clear_flush(vma, address, pte);
 
 	/* Move the dirty bit to the physical page now the pte is gone. */
@@ -731,7 +754,8 @@ static int try_to_unmap_one(struct page 
 	if (migration) {
 		/* Establish migration entry for a file page */
 		swp_entry_t entry;
-		entry = make_migration_entry(page, pte_write(pteval));
+		entry = make_migration_entry(page + page_index,
+						pte_write(pteval));
 		set_pte_at(mm, address, pte, swp_entry_to_pte(entry));
 	} else
 #endif
@@ -747,6 +771,20 @@ out:
 	return ret;
 }
 
+static int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
+				int migration)
+{
+	int ret = SWAP_AGAIN;
+	int i;
+
+	for (i = 0; i < page_cache_base_pages(page); i++) {
+		ret = __try_to_unmap_one(page, i, vma, migration);
+		if (ret == SWAP_FAIL || !page_mapped(page))
+			return ret;
+	}
+	return ret;
+}
+
 /*
  * objrmap doesn't work for nonlinear VMAs because the assumption that
  * offset-into-file correlates with offset-into-virtual-addresses does not hold.
@@ -779,7 +817,7 @@ static void try_to_unmap_cluster(unsigne
 	pte_t *pte;
 	pte_t pteval;
 	spinlock_t *ptl;
-	struct page *page;
+	struct page *page, *head;
 	unsigned long address;
 	unsigned long end;
 
@@ -816,6 +854,7 @@ static void try_to_unmap_cluster(unsigne
 		if (ptep_clear_flush_young(vma, address, pte))
 			continue;
 
+		head = page_cache_head(page);
 		/* Nuke the page table entry. */
 		flush_cache_page(vma, address, pte_pfn(*pte));
 		pteval = ptep_clear_flush(vma, address, pte);
@@ -826,10 +865,10 @@ static void try_to_unmap_cluster(unsigne
 
 		/* Move the dirty bit to the physical page now the pte is gone. */
 		if (pte_dirty(pteval))
-			set_page_dirty(page);
+			set_page_dirty(head);
 
-		page_remove_rmap(page, vma);
-		page_cache_release(page);
+		page_remove_rmap(head, vma);
+		page_cache_release(head);
 		dec_mm_counter(mm, file_rss);
 		(*mapcount)--;
 	}
Index: linux-2.6/mm/fremap.c
===================================================================
--- linux-2.6.orig/mm/fremap.c	2007-09-10 22:37:05.000000000 -0700
+++ linux-2.6/mm/fremap.c	2007-09-10 22:37:29.000000000 -0700
@@ -32,10 +32,12 @@ static void zap_pte(struct mm_struct *mm
 		pte = ptep_clear_flush(vma, addr, ptep);
 		page = vm_normal_page(vma, addr, pte);
 		if (page) {
+			struct page *head = page_cache_head(page);
+
 			if (pte_dirty(pte))
-				set_page_dirty(page);
-			page_remove_rmap(page, vma);
-			page_cache_release(page);
+				set_page_dirty(head);
+			page_remove_rmap(head, vma);
+			page_cache_release(head);
 			update_hiwater_rss(mm);
 			dec_mm_counter(mm, file_rss);
 		}
Index: linux-2.6/mm/mempolicy.c
===================================================================
--- linux-2.6.orig/mm/mempolicy.c	2007-09-10 22:37:05.000000000 -0700
+++ linux-2.6/mm/mempolicy.c	2007-09-10 22:40:03.000000000 -0700
@@ -227,12 +227,16 @@ static int check_pte_range(struct vm_are
 	do {
 		struct page *page;
 		int nid;
+		int pages = 1;
 
 		if (!pte_present(*pte))
-			continue;
+			goto next;
 		page = vm_normal_page(vma, addr, *pte);
-		if (!page)
-			continue;
+		if (!page || PageTail(page))
+			goto next;
+
+		pages = page_cache_base_pages(page);
+
 		/*
 		 * The check for PageReserved here is important to avoid
 		 * handling zero pages and other pages that may have been
@@ -245,10 +249,10 @@ static int check_pte_range(struct vm_are
 		 * to put zero pages on the migration list.
 		 */
 		if (PageReserved(page))
-			continue;
+			goto next;
 		nid = page_to_nid(page);
 		if (node_isset(nid, *nodes) == !!(flags & MPOL_MF_INVERT))
-			continue;
+			goto next;
 
 		if (flags & MPOL_MF_STATS)
 			gather_stats(page, private, pte_dirty(*pte));
@@ -256,7 +260,11 @@ static int check_pte_range(struct vm_are
 			migrate_page_add(page, private, flags);
 		else
 			break;
-	} while (pte++, addr += PAGE_SIZE, addr != end);
+	next:
+		pte += pages;
+		addr += PAGE_SIZE * pages;
+	} while (addr != end);
+
 	pte_unmap_unlock(orig_pte, ptl);
 	return addr != end;
 }
@@ -592,9 +600,12 @@ static void migrate_page_add(struct page
 		isolate_lru_page(page, pagelist);
 }
 
-static struct page *new_node_page(struct page *page, unsigned long node, int **x)
+static struct page *new_node_page(struct page *page,
+				unsigned long node, int **x)
 {
-	return alloc_pages_node(node, GFP_HIGHUSER_MOVABLE, 0);
+	return alloc_pages_node(node,
+		GFP_HIGHUSER_MOVABLE | __GFP_COMP,
+		page_cache_page_order(page));
 }
 
 /*
Index: linux-2.6/mm/migrate.c
===================================================================
--- linux-2.6.orig/mm/migrate.c	2007-09-10 22:37:05.000000000 -0700
+++ linux-2.6/mm/migrate.c	2007-09-10 22:44:04.000000000 -0700
@@ -196,15 +196,17 @@ static void remove_file_migration_ptes(s
 	struct address_space *mapping = page_mapping(new);
 	struct prio_tree_iter iter;
 	pgoff_t pgoff = new->index << mapping_order(mapping);
+	int i;
 
 	if (!mapping)
 		return;
 
 	spin_lock(&mapping->i_mmap_lock);
 
-	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff)
-		remove_migration_pte(vma, old, new);
-
+	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
+		for (i = 0; i < page_cache_base_pages(old); i++)
+			remove_migration_pte(vma, old + i, new + i);
+	}
 	spin_unlock(&mapping->i_mmap_lock);
 }
 
@@ -355,7 +357,10 @@ static int migrate_page_move_mapping(str
  */
 static void migrate_page_copy(struct page *newpage, struct page *page)
 {
-	copy_highpage(newpage, page);
+	int i;
+
+	for (i = 0; i < page_cache_base_pages(page); i++)
+		copy_highpage(newpage + i, page + i);
 
 	if (PageError(page))
 		SetPageError(newpage);
@@ -785,7 +790,8 @@ static struct page *new_page_node(struct
 	*result = &pm->status;
 
 	return alloc_pages_node(pm->node,
-				GFP_HIGHUSER_MOVABLE | GFP_THISNODE, 0);
+		GFP_HIGHUSER_MOVABLE | GFP_THISNODE | __GFP_COMP,
+		page_cache_page_order(p));
 }
 
 /*
@@ -826,6 +832,7 @@ static int do_move_pages(struct mm_struc
 		if (!page)
 			goto set_status;
 
+		page = page_cache_head(page);
 		if (PageReserved(page))		/* Check for zero page */
 			goto put_and_set;
 

-- 
