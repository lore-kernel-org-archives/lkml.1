Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbXCSUGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbXCSUGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbXCSUGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:06:40 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58779 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbXCSUGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:06:30 -0400
From: Adam Litke <agl@us.ibm.com>
Subject: [PATCH 7/7] hugetlbfs fault handler
Date: Mon, 19 Mar 2007 13:06:16 -0700
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adam Litke <agl@us.ibm.com>, Arjan van de Ven <arjan@infradead.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-Id: <20070319200616.17168.62372.stgit@localhost.localdomain>
In-Reply-To: <20070319200502.17168.17175.stgit@localhost.localdomain>
References: <20070319200502.17168.17175.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Adam Litke <agl@us.ibm.com>
---

 fs/hugetlbfs/inode.c |    1 +
 mm/hugetlb.c         |    4 +++-
 mm/memory.c          |    4 ++--
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 823a9e3..29e65c2 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -571,6 +571,7 @@ static const struct pagetable_operations_struct hugetlbfs_pagetable_ops = {
 	.unmap_page_range	= unmap_hugepage_range,
 	.change_protection	= hugetlb_change_protection,
 	.free_pgtable_range	= hugetlb_free_pgd_range,
+	.fault			= hugetlb_fault,
 };
 
 static const struct inode_operations hugetlbfs_dir_inode_operations = {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d902fb9..e0f0607 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -590,6 +590,8 @@ int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	unsigned long vaddr = *position;
 	int remainder = *length;
 
+	BUG_ON(!has_pt_op(vma, fault));
+
 	spin_lock(&mm->page_table_lock);
 	while (vaddr < vma->vm_end && remainder) {
 		pte_t *pte;
@@ -606,7 +608,7 @@ int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			int ret;
 
 			spin_unlock(&mm->page_table_lock);
-			ret = hugetlb_fault(mm, vma, vaddr, 0);
+			ret = pt_op(vma, fault)(mm, vma, vaddr, 0);
 			spin_lock(&mm->page_table_lock);
 			if (ret == VM_FAULT_MINOR)
 				continue;
diff --git a/mm/memory.c b/mm/memory.c
index d2f28e7..bd7c243 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2499,8 +2499,8 @@ int __handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	count_vm_event(PGFAULT);
 
-	if (unlikely(is_vm_hugetlb_page(vma)))
-		return hugetlb_fault(mm, vma, address, write_access);
+	if (unlikely(has_pt_op(vma, fault)))
+		return pt_op(vma, fault)(mm, vma, address, write_access);
 
 	pgd = pgd_offset(mm, address);
 	pud = pud_alloc(mm, pgd, address);
