Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbZLBOTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbZLBOTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbZLBOT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:19:29 -0500
Received: from gir.skynet.ie ([193.1.99.77]:36931 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbZLBOT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:19:28 -0500
Date: Wed, 2 Dec 2009 14:19:30 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] hugetlb: Acquire the i_mmap_lock before walking the
	prio_tree to unmap a page
Message-ID: <20091202141930.GF1457@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the owner of a mapping fails COW because a child process is holding a
reference and no pages are available, the children VMAs are walked and the
page is unmapped. The i_mmap_lock is taken for the unmapping of the page but
not the walking of the prio_tree. In theory, that tree could be changing
while the lock is released although in practice it is protected by the
hugetlb_instantiation_mutex. This patch takes the i_mmap_lock properly for
the duration of the prio_tree walk in case the hugetlb_instantiation_mutex
ever goes away.

[hugh.dickins@tiscali.co.uk: Spotted the problem in the first place]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/hugetlb.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a952cb8..5adc284 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1906,6 +1906,12 @@ static int unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
 		+ (vma->vm_pgoff >> PAGE_SHIFT);
 	mapping = (struct address_space *)page_private(page);
 
+	/*
+	 * Take the mapping lock for the duration of the table walk. As
+	 * this mapping should be shared between all the VMAs,
+	 * __unmap_hugepage_range() is called as the lock is already held
+	 */
+	spin_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(iter_vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		/* Do not unmap the current VMA */
 		if (iter_vma == vma)
@@ -1919,10 +1925,11 @@ static int unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
 		 * from the time of fork. This would look like data corruption
 		 */
 		if (!is_vma_resv_set(iter_vma, HPAGE_RESV_OWNER))
-			unmap_hugepage_range(iter_vma,
+			__unmap_hugepage_range(iter_vma,
 				address, address + huge_page_size(h),
 				page);
 	}
+	spin_unlock(&mapping->i_mmap_lock);
 
 	return 1;
 }
