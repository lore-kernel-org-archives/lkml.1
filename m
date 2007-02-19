Return-Path: <linux-kernel-owner+w=401wt.eu-S932469AbXBSSco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbXBSSco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 13:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932478AbXBSSco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 13:32:44 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:56268 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479AbXBSSck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 13:32:40 -0500
From: Adam Litke <agl@us.ibm.com>
Subject: [PATCH 7/7] hugetlbfs fault handler
Date: Mon, 19 Feb 2007 10:32:38 -0800
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, agl@us.ibm.com
Message-Id: <20070219183237.27318.97223.stgit@localhost.localdomain>
In-Reply-To: <20070219183123.27318.27319.stgit@localhost.localdomain>
References: <20070219183123.27318.27319.stgit@localhost.localdomain>
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
index 3461f9b..1de73c1 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -568,6 +568,7 @@ static struct pagetable_operations_struct hugetlbfs_pagetable_ops = {
 	.unmap_page_range	= unmap_hugepage_range,
 	.change_protection	= hugetlb_change_protection,
 	.free_pgtable_range	= hugetlb_free_pgd_range,
+	.fault			= hugetlb_fault,
 };
 
 static struct inode_operations hugetlbfs_dir_inode_operations = {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 3bcc0db..63de369 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -588,6 +588,8 @@ int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	unsigned long vaddr = *position;
 	int remainder = *length;
 
+	BUG_ON(!has_pt_op(vma, fault));
+
 	spin_lock(&mm->page_table_lock);
 	while (vaddr < vma->vm_end && remainder) {
 		pte_t *pte;
@@ -604,7 +606,7 @@ int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			int ret;
 
 			spin_unlock(&mm->page_table_lock);
-			ret = hugetlb_fault(mm, vma, vaddr, 0);
+			ret = pt_op(vma, fault)(mm, vma, vaddr, 0);
 			spin_lock(&mm->page_table_lock);
 			if (ret == VM_FAULT_MINOR)
 				continue;
diff --git a/mm/memory.c b/mm/memory.c
index 442e6b2..c8e17b4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2455,8 +2455,8 @@ int __handle_mm_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	count_vm_event(PGFAULT);
 
-	if (unlikely(is_vm_hugetlb_page(vma)))
-		return hugetlb_fault(mm, vma, address, write_access);
+	if (unlikely(has_pt_op(vma, fault)))
+		return pt_op(vma, fault)(mm, vma, address, write_access);
 
 	pgd = pgd_offset(mm, address);
 	pud = pud_alloc(mm, pgd, address);
