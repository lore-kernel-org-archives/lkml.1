Return-Path: <linux-kernel-owner+w=401wt.eu-S2993113AbXDTSCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993113AbXDTSCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 14:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993306AbXDTSCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 14:02:37 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38708 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993113AbXDTSCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 14:02:35 -0400
Date: Fri, 20 Apr 2007 11:02:34 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: Mel Gorman <mel@skynet.ie>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 7/8] Enhance ramfs to support higher order pages
In-Reply-To: <20070420171928.GA2986@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0704201101170.20868@schroedinger.engr.sgi.com>
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

Some ideas for memory.c pieces. Just junk like the earlier patches.

---
 mm/memory.c |  108 ++++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 66 insertions(+), 42 deletions(-)

Index: linux-2.6.21-rc7/mm/memory.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/memory.c	2007-04-20 10:55:49.000000000 -0700
+++ linux-2.6.21-rc7/mm/memory.c	2007-04-20 10:56:13.000000000 -0700
@@ -368,6 +368,12 @@ static inline int is_cow_mapping(unsigne
 /*
  * This function gets the "struct page" associated with a pte.
  *
+ * NOTE! For compound pages it may get to a tail page (maybe we
+ * only deal with a portion of a compound page after all). This
+ * means that the result of vm_normal_page may not directly be
+ * used to manipulate the page state. Use compound_head() if
+ * operations (like getting a ref count) are necessary.
+ *
  * NOTE! Some mappings do not have "struct pages". A raw PFN mapping
  * will have each page table entry just pointing to a raw page frame
  * number, and as far as the VM layer is concerned, those do not have
@@ -480,9 +486,11 @@ copy_one_pte(struct mm_struct *dst_mm, s
 
 	page = vm_normal_page(vma, addr, pte);
 	if (page) {
-		get_page(page);
-		page_dup_rmap(page);
-		rss[!!PageAnon(page)]++;
+		struct page *head_page = compound_head(page);
+
+		get_page(head_page);
+		page_dup_rmap(head_page);
+		rss[!!PageAnon(head_page)]++;
 	}
 
 out_set_pte:
@@ -642,8 +650,14 @@ static unsigned long zap_pte_range(struc
 
 		if (pte_present(ptent)) {
 			struct page *page;
+			struct page *head_page;
 
 			page = vm_normal_page(vma, addr, ptent);
+			if (page)
+				head_page = compound_head(page);
+			else
+				head_page = NULL;
+
 			if (unlikely(details) && page) {
 				/*
 				 * unmap_shared_mapping_pages() wants to
@@ -651,15 +665,15 @@ static unsigned long zap_pte_range(struc
 				 * unmap shared but keep private pages.
 				 */
 				if (details->check_mapping &&
-				    details->check_mapping != page->mapping)
+				    details->check_mapping != head_page->mapping)
 					continue;
 				/*
 				 * Each page->index must be checked when
 				 * invalidating or truncating nonlinear.
 				 */
 				if (details->nonlinear_vma &&
-				    (page->index < details->first_index ||
-				     page->index > details->last_index))
+				    (head_page->index < details->first_index ||
+				     head_page->index > details->last_index))
 					continue;
 			}
 			ptent = ptep_get_and_clear_full(mm, addr, pte,
@@ -668,21 +682,24 @@ static unsigned long zap_pte_range(struc
 			if (unlikely(!page))
 				continue;
 			if (unlikely(details) && details->nonlinear_vma
-			    && linear_page_index(details->nonlinear_vma,
-						addr) != page->index)
+			    && linear_page_index_mapping(details->nonlinear_vma,
+						addr, compound_order(head_page))
+							!= head_page->index)
 				set_pte_at(mm, addr, pte,
-					   pgoff_to_pte(page->index));
-			if (PageAnon(page))
+					   pgoff_to_pte(
+					   	(head_page->index << compound_page(order))
+							+ page - head_page));
+			if (PageAnon(head_page))
 				anon_rss--;
 			else {
 				if (pte_dirty(ptent))
-					set_page_dirty(page);
+					set_page_dirty(head_page);
 				if (pte_young(ptent))
-					SetPageReferenced(page);
+					SetPageReferenced(head_page);
 				file_rss--;
 			}
-			page_remove_rmap(page, vma);
-			tlb_remove_page(tlb, page);
+			page_remove_rmap(head_page, vma);
+			tlb_remove_page(tlb, head_page);
 			continue;
 		}
 		/*
@@ -899,6 +916,10 @@ unsigned long zap_page_range(struct vm_a
 
 /*
  * Do a quick page-table lookup for a single page.
+ *
+ * Note: This function may return a pointer to a tail page. However,
+ * any operations like getting a page reference and touching it will
+ * have to be performed on the head page.
  */
 struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 			unsigned int flags)
@@ -949,13 +970,14 @@ struct page *follow_page(struct vm_area_
 	if (unlikely(!page))
 		goto unlock;
 
+	head_page = compound_head(page);
 	if (flags & FOLL_GET)
-		get_page(page);
+		get_page(head_page);
 	if (flags & FOLL_TOUCH) {
 		if ((flags & FOLL_WRITE) &&
-		    !pte_dirty(pte) && !PageDirty(page))
-			set_page_dirty(page);
-		mark_page_accessed(page);
+		    !pte_dirty(pte) && !PageDirty(head_page))
+			set_page_dirty(head_page);
+		mark_page_accessed(head_page);
 	}
 unlock:
 	pte_unmap_unlock(ptep, ptl);
@@ -1537,6 +1559,7 @@ static int do_wp_page(struct mm_struct *
 		spinlock_t *ptl, pte_t orig_pte)
 {
 	struct page *old_page, *new_page;
+	struct page *old_page_head, *new_page_head;
 	pte_t entry;
 	int reuse = 0, ret = VM_FAULT_MINOR;
 	struct page *dirty_page = NULL;
@@ -1545,14 +1568,15 @@ static int do_wp_page(struct mm_struct *
 	if (!old_page)
 		goto gotten;
 
+	old_page_head = compound_head(old_page);
 	/*
 	 * Take out anonymous pages first, anonymous shared vmas are
 	 * not dirty accountable.
 	 */
-	if (PageAnon(old_page)) {
-		if (!TestSetPageLocked(old_page)) {
-			reuse = can_share_swap_page(old_page);
-			unlock_page(old_page);
+	if (PageAnon(old_page_head)) {
+		if (!TestSetPageLocked(old_page_head)) {
+			reuse = can_share_swap_page(old_page_head);
+			unlock_page(old_page_head);
 		}
 	} else if (unlikely((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
 					(VM_WRITE|VM_SHARED))) {
@@ -1570,10 +1594,10 @@ static int do_wp_page(struct mm_struct *
 			 * We do this without the lock held, so that it can
 			 * sleep if it needs to.
 			 */
-			page_cache_get(old_page);
+			page_cache_get(old_page_head);
 			pte_unmap_unlock(page_table, ptl);
 
-			if (vma->vm_ops->page_mkwrite(vma, old_page) < 0)
+			if (vma->vm_ops->page_mkwrite(vma, old_page_head) < 0)
 				goto unwritable_page;
 
 			/*
@@ -1584,11 +1608,11 @@ static int do_wp_page(struct mm_struct *
 			 */
 			page_table = pte_offset_map_lock(mm, pmd, address,
 							 &ptl);
-			page_cache_release(old_page);
+			page_cache_release(old_page_head);
 			if (!pte_same(*page_table, orig_pte))
 				goto unlock;
 		}
-		dirty_page = old_page;
+		dirty_page = old_page_head;
 		get_page(dirty_page);
 		reuse = 1;
 	}
@@ -1607,7 +1631,7 @@ static int do_wp_page(struct mm_struct *
 	/*
 	 * Ok, we need to copy. Oh, well..
 	 */
-	page_cache_get(old_page);
+	page_cache_get(old_page_head);
 gotten:
 	pte_unmap_unlock(page_table, ptl);
 
@@ -1630,8 +1654,8 @@ gotten:
 	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
 	if (likely(pte_same(*page_table, orig_pte))) {
 		if (old_page) {
-			page_remove_rmap(old_page, vma);
-			if (!PageAnon(old_page)) {
+			page_remove_rmap(old_page_head, vma);
+			if (!PageAnon(old_page_head)) {
 				dec_mm_counter(mm, file_rss);
 				inc_mm_counter(mm, anon_rss);
 			}
@@ -1654,13 +1678,13 @@ gotten:
 		page_add_new_anon_rmap(new_page, vma, address);
 
 		/* Free the old page.. */
-		new_page = old_page;
+		new_page = old_page_head;
 		ret |= VM_FAULT_WRITE;
 	}
 	if (new_page)
 		page_cache_release(new_page);
 	if (old_page)
-		page_cache_release(old_page);
+		page_cache_release(old_page_head);
 unlock:
 	pte_unmap_unlock(page_table, ptl);
 	if (dirty_page) {
@@ -1669,8 +1693,8 @@ unlock:
 	}
 	return ret;
 oom:
-	if (old_page)
-		page_cache_release(old_page);
+	if (old_page_head)
+		page_cache_release(old_page_head);
 	return VM_FAULT_OOM;
 
 unwritable_page:
@@ -2243,7 +2267,7 @@ retry:
 			if (!page)
 				goto oom;
 			copy_user_highpage(page, new_page, address, vma);
-			page_cache_release(new_page);
+			page_cache_release(compound_head(new_page));
 			new_page = page;
 			anon = 1;
 
@@ -2254,7 +2278,7 @@ retry:
 			if (vma->vm_ops->page_mkwrite &&
 			    vma->vm_ops->page_mkwrite(vma, new_page) < 0
 			    ) {
-				page_cache_release(new_page);
+				page_cache_release(compound_head(new_page));
 				return VM_FAULT_SIGBUS;
 			}
 		}
@@ -2268,7 +2292,7 @@ retry:
 	 */
 	if (mapping && unlikely(sequence != mapping->truncate_count)) {
 		pte_unmap_unlock(page_table, ptl);
-		page_cache_release(new_page);
+		page_cache_release(compound_head(new_page));
 		cond_resched();
 		sequence = mapping->truncate_count;
 		smp_rmb();
@@ -2298,15 +2322,15 @@ retry:
 			page_add_new_anon_rmap(new_page, vma, address);
 		} else {
 			inc_mm_counter(mm, file_rss);
-			page_add_file_rmap(new_page);
+			page_add_file_rmap(compound_head(new_page));
 			if (write_access) {
-				dirty_page = new_page;
+				dirty_page = compound_head(new_page);
 				get_page(dirty_page);
 			}
 		}
 	} else {
 		/* One of our sibling threads was faster, back out. */
-		page_cache_release(new_page);
+		page_cache_release(compound_head(new_page));
 		goto unlock;
 	}
 
@@ -2321,7 +2345,7 @@ unlock:
 	}
 	return ret;
 oom:
-	page_cache_release(new_page);
+	page_cache_release(compound_head(new_page));
 	return VM_FAULT_OOM;
 }
 
@@ -2720,13 +2744,13 @@ int access_process_vm(struct task_struct
 		if (write) {
 			copy_to_user_page(vma, page, addr,
 					  maddr + offset, buf, bytes);
-			set_page_dirty_lock(page);
+			set_page_dirty_lock(compound_head(page));
 		} else {
 			copy_from_user_page(vma, page, addr,
 					    buf, maddr + offset, bytes);
 		}
 		kunmap(page);
-		page_cache_release(page);
+		page_cache_release(compound_head(page));
 		len -= bytes;
 		buf += bytes;
 		addr += bytes;

