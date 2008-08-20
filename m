Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbYHTAjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbYHTAjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 20:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbYHTAjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 20:39:16 -0400
Received: from ozlabs.org ([203.10.76.45]:46989 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbYHTAjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 20:39:15 -0400
Date: Wed, 20 Aug 2008 10:36:45 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: William Lee Irwin <wli@holomorphy.com>, Andrew Morton <akpm@osdl.org>
Cc: libhugetlbfs-deve@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Handle updating of ACCESSED and DIRTY in hugetlb_fault()
Message-ID: <20080820003645.GC26611@yookeroo.seuss>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	William Lee Irwin <wli@holomorphy.com>,
	Andrew Morton <akpm@osdl.org>,
	libhugetlbfs-deve@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The page fault path for normal pages, if the fault is neither a
no-page fault nor a write-protect fault, will update the DIRTY and
ACCESSED bits in the page table appropriately.

The hugepage fault path, however, does not do this, handling only
no-page or write-protect type faults.  It assumes that either the
ACCESSED and DIRTY bits are irrelevant for hugepages (usually true,
since they are never swapped) or that they are handled by the arch
code.

This is inconvenient for some software-loaded TLB architectures, where
the _PAGE_ACCESSED (_PAGE_DIRTY) bits need to be set to enable read
(write) access to the page at the TLB miss.  This could be worked
around in the arch TLB miss code, but the TLB miss fast path can be
made simple more easily if the hugetlb_fault() path handles this, as
the normal page fault path does.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>

---

RFC, looking to merge for 2.6.28.

Index: working-2.6/mm/hugetlb.c
===================================================================
--- working-2.6.orig/mm/hugetlb.c	2008-08-19 15:14:51.000000000 +1000
+++ working-2.6/mm/hugetlb.c	2008-08-19 15:28:27.000000000 +1000
@@ -2008,7 +2008,7 @@ int hugetlb_fault(struct mm_struct *mm, 
 	entry = huge_ptep_get(ptep);
 	if (huge_pte_none(entry)) {
 		ret = hugetlb_no_page(mm, vma, address, ptep, write_access);
-		goto out_unlock;
+		goto out_mutex;
 	}
 
 	ret = 0;
@@ -2024,7 +2024,7 @@ int hugetlb_fault(struct mm_struct *mm, 
 	if (write_access && !pte_write(entry)) {
 		if (vma_needs_reservation(h, vma, address) < 0) {
 			ret = VM_FAULT_OOM;
-			goto out_unlock;
+			goto out_mutex;
 		}
 
 		if (!(vma->vm_flags & VM_SHARED))
@@ -2034,10 +2034,23 @@ int hugetlb_fault(struct mm_struct *mm, 
 
 	spin_lock(&mm->page_table_lock);
 	/* Check for a racing update before calling hugetlb_cow */
-	if (likely(pte_same(entry, huge_ptep_get(ptep))))
-		if (write_access && !pte_write(entry))
+	if (unlikely(!pte_same(entry, huge_ptep_get(ptep))))
+		goto out_page_table_lock;
+
+
+	if (write_access) {
+		if (!pte_write(entry)) {
 			ret = hugetlb_cow(mm, vma, address, ptep, entry,
 							pagecache_page);
+			goto out_page_table_lock;
+		}
+		entry = pte_mkdirty(entry);
+	}
+	entry = pte_mkyoung(entry);
+	if (huge_ptep_set_access_flags(vma, address, ptep, entry, write_access))
+		update_mmu_cache(vma, address, entry);
+
+out_page_table_lock:
 	spin_unlock(&mm->page_table_lock);
 
 	if (pagecache_page) {
@@ -2045,7 +2058,7 @@ int hugetlb_fault(struct mm_struct *mm, 
 		put_page(pagecache_page);
 	}
 
-out_unlock:
+out_mutex:
 	mutex_unlock(&hugetlb_instantiation_mutex);
 
 	return ret;

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
