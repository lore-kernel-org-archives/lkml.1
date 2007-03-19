Return-Path: <linux-kernel-owner+w=401wt.eu-S1753120AbXCSUGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbXCSUGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932433AbXCSUGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:06:10 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42391 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367AbXCSUGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:06:02 -0400
From: Adam Litke <agl@us.ibm.com>
Subject: [PATCH 4/7] unmap_page_range for hugetlb
Date: Mon, 19 Mar 2007 13:05:45 -0700
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adam Litke <agl@us.ibm.com>, Arjan van de Ven <arjan@infradead.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-Id: <20070319200544.17168.13231.stgit@localhost.localdomain>
In-Reply-To: <20070319200502.17168.17175.stgit@localhost.localdomain>
References: <20070319200502.17168.17175.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Adam Litke <agl@us.ibm.com>
---

 fs/hugetlbfs/inode.c    |    3 ++-
 include/linux/hugetlb.h |    4 ++--
 mm/hugetlb.c            |   12 ++++++++----
 mm/memory.c             |   10 ++++------
 4 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index d0b4b46..198efa7 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -289,7 +289,7 @@ hugetlb_vmtruncate_list(struct prio_tree_root *root, pgoff_t pgoff)
 			v_offset = 0;
 
 		__unmap_hugepage_range(vma,
-				vma->vm_start + v_offset, vma->vm_end);
+				vma->vm_start + v_offset, vma->vm_end, 0);
 	}
 }
 
@@ -568,6 +568,7 @@ const struct file_operations hugetlbfs_file_operations = {
 static const struct pagetable_operations_struct hugetlbfs_pagetable_ops = {
 	.copy_vma		= copy_hugetlb_page_range,
 	.pin_pages		= follow_hugetlb_page,
+	.unmap_page_range	= unmap_hugepage_range,
 };
 
 static const struct inode_operations hugetlbfs_dir_inode_operations = {
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 3f3e7a6..502c2f8 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -17,8 +17,8 @@ static inline int is_vm_hugetlb_page(struct vm_area_struct *vma)
 int hugetlb_sysctl_handler(struct ctl_table *, int, struct file *, void __user *, size_t *, loff_t *);
 int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *, struct vm_area_struct *);
 int follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *, struct page **, struct vm_area_struct **, unsigned long *, int *, int);
-void unmap_hugepage_range(struct vm_area_struct *, unsigned long, unsigned long);
-void __unmap_hugepage_range(struct vm_area_struct *, unsigned long, unsigned long);
+unsigned long unmap_hugepage_range(struct vm_area_struct *, unsigned long, unsigned long, long *);
+void __unmap_hugepage_range(struct vm_area_struct *, unsigned long, unsigned long, long *);
 int hugetlb_prefault(struct address_space *, struct vm_area_struct *);
 int hugetlb_report_meminfo(char *);
 int hugetlb_report_node_meminfo(int, char *);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 36db012..d902fb9 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -356,7 +356,7 @@ nomem:
 }
 
 void __unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
-			    unsigned long end)
+			    unsigned long end, long *zap_work)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address;
@@ -399,10 +399,13 @@ void __unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 		list_del(&page->lru);
 		put_page(page);
 	}
+
+	if (zap_work)
+		*zap_work -= (end - start) / (HPAGE_SIZE / PAGE_SIZE);
 }
 
-void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
-			  unsigned long end)
+unsigned long unmap_hugepage_range(struct vm_area_struct *vma,
+			unsigned long start, unsigned long end, long *zap_work)
 {
 	/*
 	 * It is undesirable to test vma->vm_file as it should be non-null
@@ -414,9 +417,10 @@ void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 	 */
 	if (vma->vm_file) {
 		spin_lock(&vma->vm_file->f_mapping->i_mmap_lock);
-		__unmap_hugepage_range(vma, start, end);
+		__unmap_hugepage_range(vma, start, end, zap_work);
 		spin_unlock(&vma->vm_file->f_mapping->i_mmap_lock);
 	}
+	return end;
 }
 
 static int hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
diff --git a/mm/memory.c b/mm/memory.c
index 01256cf..a3bcaf3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -839,12 +839,10 @@ unsigned long unmap_vmas(struct mmu_gather **tlbp,
 				tlb_start_valid = 1;
 			}
 
-			if (unlikely(is_vm_hugetlb_page(vma))) {
-				unmap_hugepage_range(vma, start, end);
-				zap_work -= (end - start) /
-						(HPAGE_SIZE / PAGE_SIZE);
-				start = end;
-			} else
+			if (unlikely(has_pt_op(vma, unmap_page_range)))
+				start = pt_op(vma, unmap_page_range)
+						(vma, start, end, &zap_work);
+			else
 				start = unmap_page_range(*tlbp, vma,
 						start, end, &zap_work, details);
 
