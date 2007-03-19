Return-Path: <linux-kernel-owner+w=401wt.eu-S1751691AbXCSUFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbXCSUFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbXCSUFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:05:41 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44577 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbXCSUF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:05:27 -0400
From: Adam Litke <agl@us.ibm.com>
Subject: [PATCH 2/7] copy_vma for hugetlbfs
Date: Mon, 19 Mar 2007 13:05:23 -0700
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adam Litke <agl@us.ibm.com>, Arjan van de Ven <arjan@infradead.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-Id: <20070319200523.17168.99676.stgit@localhost.localdomain>
In-Reply-To: <20070319200502.17168.17175.stgit@localhost.localdomain>
References: <20070319200502.17168.17175.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Adam Litke <agl@us.ibm.com>
---

 fs/hugetlbfs/inode.c |    6 ++++++
 mm/memory.c          |    4 ++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 8c718a3..2452dde 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -36,6 +36,7 @@
 static const struct super_operations hugetlbfs_ops;
 static const struct address_space_operations hugetlbfs_aops;
 const struct file_operations hugetlbfs_file_operations;
+static const struct pagetable_operations_struct hugetlbfs_pagetable_ops;
 static const struct inode_operations hugetlbfs_dir_inode_operations;
 static const struct inode_operations hugetlbfs_inode_operations;
 
@@ -70,6 +71,7 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	 */
 	vma->vm_flags |= VM_HUGETLB | VM_RESERVED;
 	vma->vm_ops = &hugetlb_vm_ops;
+	vma->pagetable_ops = &hugetlbfs_pagetable_ops;
 
 	vma_len = (loff_t)(vma->vm_end - vma->vm_start);
 
@@ -563,6 +565,10 @@ const struct file_operations hugetlbfs_file_operations = {
 	.get_unmapped_area	= hugetlb_get_unmapped_area,
 };
 
+static const struct pagetable_operations_struct hugetlbfs_pagetable_ops = {
+	.copy_vma		= copy_hugetlb_page_range,
+};
+
 static const struct inode_operations hugetlbfs_dir_inode_operations = {
 	.create		= hugetlbfs_create,
 	.lookup		= simple_lookup,
diff --git a/mm/memory.c b/mm/memory.c
index e7066e7..69bb0b3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -602,8 +602,8 @@ int copy_page_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 			return 0;
 	}
 
-	if (is_vm_hugetlb_page(vma))
-		return copy_hugetlb_page_range(dst_mm, src_mm, vma);
+	if (has_pt_op(vma, copy_vma))
+		return pt_op(vma, copy_vma)(dst_mm, src_mm, vma);
 
 	dst_pgd = pgd_offset(dst_mm, addr);
 	src_pgd = pgd_offset(src_mm, addr);
