Return-Path: <linux-kernel-owner+w=401wt.eu-S932454AbXBSSbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbXBSSbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 13:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932465AbXBSSbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 13:31:49 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49175 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454AbXBSSbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 13:31:48 -0500
From: Adam Litke <agl@us.ibm.com>
Subject: [PATCH 2/7] copy_vma for hugetlbfs
Date: Mon, 19 Feb 2007 10:31:44 -0800
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, agl@us.ibm.com
Message-Id: <20070219183144.27318.64028.stgit@localhost.localdomain>
In-Reply-To: <20070219183123.27318.27319.stgit@localhost.localdomain>
References: <20070219183123.27318.27319.stgit@localhost.localdomain>
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
index 4f4cd13..c0a7984 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -36,6 +36,7 @@
 static struct super_operations hugetlbfs_ops;
 static const struct address_space_operations hugetlbfs_aops;
 const struct file_operations hugetlbfs_file_operations;
+static struct pagetable_operations_struct hugetlbfs_pagetable_ops;
 static struct inode_operations hugetlbfs_dir_inode_operations;
 static struct inode_operations hugetlbfs_inode_operations;
 
@@ -70,6 +71,7 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	 */
 	vma->vm_flags |= VM_HUGETLB | VM_RESERVED;
 	vma->vm_ops = &hugetlb_vm_ops;
+	vma->pagetable_ops = &hugetlbfs_pagetable_ops;
 
 	vma_len = (loff_t)(vma->vm_end - vma->vm_start);
 
@@ -560,6 +562,10 @@ const struct file_operations hugetlbfs_file_operations = {
 	.get_unmapped_area	= hugetlb_get_unmapped_area,
 };
 
+static struct pagetable_operations_struct hugetlbfs_pagetable_ops = {
+	.copy_vma		= copy_hugetlb_page_range,
+};
+
 static struct inode_operations hugetlbfs_dir_inode_operations = {
 	.create		= hugetlbfs_create,
 	.lookup		= simple_lookup,
diff --git a/mm/memory.c b/mm/memory.c
index ef09f0a..80eafd5 100644
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
