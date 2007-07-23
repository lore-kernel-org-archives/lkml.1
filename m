Return-Path: <linux-kernel-owner+w=401wt.eu-S932990AbXGWITm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990AbXGWITm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbXGWITf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:19:35 -0400
Received: from mga05.intel.com ([192.55.52.89]:37478 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751665AbXGWITe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:19:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,569,1175497200"; 
   d="scan'208";a="271484835"
Subject: [PATCH] spinlock in function hugetlb_fault could be deleted
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: agl@us.ibm.com
Content-Type: text/plain; charset=utf-8
Date: Mon, 23 Jul 2007 16:18:47 +0800
Message-Id: <1185178727.4688.63.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Function hugetlb_fault needn't hold spinlock mm->page_table_lock,
because when hugetlb_fault is called:
1) mm->mmap_sem is held already;
2) hugetlb_instantiation_mutex is held by hugetlb_fault, which prevents
other threads/processes from entering this critical area. It's impossible
for other threads/processes to change the page table now.

My patch against kenel 2.6.22 deletes the spinlock statements in the
related functions.

Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>

---

diff -Nraup linux-2.6.22/mm/hugetlb.c linux-2.6.22_hugetlb/mm/hugetlb.c
--- linux-2.6.22/mm/hugetlb.c	2007-07-09 07:32:17.000000000 +0800
+++ linux-2.6.22_hugetlb/mm/hugetlb.c	2007-07-23 15:51:49.000000000 +0800
@@ -434,12 +434,12 @@ void unmap_hugepage_range(struct vm_area
 }
 
 static int hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
-			unsigned long address, pte_t *ptep, pte_t pte)
+			unsigned long address, pte_t *ptep)
 {
 	struct page *old_page, *new_page;
 	int avoidcopy;
 
-	old_page = pte_page(pte);
+	old_page = pte_page(*ptep);
 
 	/* If no-one else is actually using this page, avoid the copy
 	 * and just make the page writable */
@@ -449,28 +449,16 @@ static int hugetlb_cow(struct mm_struct 
 		return VM_FAULT_MINOR;
 	}
 
-	page_cache_get(old_page);
 	new_page = alloc_huge_page(vma, address);
-
 	if (!new_page) {
 		page_cache_release(old_page);
 		return VM_FAULT_OOM;
 	}
 
-	spin_unlock(&mm->page_table_lock);
 	copy_huge_page(new_page, old_page, address, vma);
-	spin_lock(&mm->page_table_lock);
-
-	ptep = huge_pte_offset(mm, address & HPAGE_MASK);
-	if (likely(pte_same(*ptep, pte))) {
-		/* Break COW */
-		set_huge_pte_at(mm, address, ptep,
-				make_huge_pte(vma, new_page, 1));
-		/* Make the old page be freed below */
-		new_page = old_page;
-	}
-	page_cache_release(new_page);
+	set_huge_pte_at (mm, address, ptep, make_huge_pte (vma, new_page, 1));
 	page_cache_release(old_page);
+
 	return VM_FAULT_MINOR;
 }
 
@@ -523,7 +511,6 @@ retry:
 			lock_page(page);
 	}
 
-	spin_lock(&mm->page_table_lock);
 	size = i_size_read(mapping->host) >> HPAGE_SHIFT;
 	if (idx >= size)
 		goto backout;
@@ -538,16 +525,14 @@ retry:
 
 	if (write_access && !(vma->vm_flags & VM_SHARED)) {
 		/* Optimization, do the COW without a second fault */
-		ret = hugetlb_cow(mm, vma, address, ptep, new_pte);
+		ret = hugetlb_cow(mm, vma, address, ptep);
 	}
 
-	spin_unlock(&mm->page_table_lock);
 	unlock_page(page);
 out:
 	return ret;
 
 backout:
-	spin_unlock(&mm->page_table_lock);
 	hugetlb_put_quota(mapping);
 	unlock_page(page);
 	put_page(page);
@@ -580,13 +565,8 @@ int hugetlb_fault(struct mm_struct *mm, 
 	}
 
 	ret = VM_FAULT_MINOR;
-
-	spin_lock(&mm->page_table_lock);
-	/* Check for a racing update before calling hugetlb_cow */
-	if (likely(pte_same(entry, *ptep)))
-		if (write_access && !pte_write(entry))
-			ret = hugetlb_cow(mm, vma, address, ptep, entry);
-	spin_unlock(&mm->page_table_lock);
+	if (write_access && !pte_write(entry))
+		ret = hugetlb_cow(mm, vma, address, ptep);
 	mutex_unlock(&hugetlb_instantiation_mutex);
 
 	return ret;
