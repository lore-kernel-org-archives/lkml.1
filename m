Return-Path: <linux-kernel-owner+w=401wt.eu-S1751744AbXCSUGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbXCSUGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbXCSUGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:06:42 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54640 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367AbXCSUGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:06:11 -0400
From: Adam Litke <agl@us.ibm.com>
Subject: [PATCH 6/7] free_pgtable_range for hugetlb
Date: Mon, 19 Mar 2007 13:06:06 -0700
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adam Litke <agl@us.ibm.com>, Arjan van de Ven <arjan@infradead.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-Id: <20070319200606.17168.61740.stgit@localhost.localdomain>
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
 mm/memory.c          |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 3de5d93..823a9e3 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -570,6 +570,7 @@ static const struct pagetable_operations_struct hugetlbfs_pagetable_ops = {
 	.pin_pages		= follow_hugetlb_page,
 	.unmap_page_range	= unmap_hugepage_range,
 	.change_protection	= hugetlb_change_protection,
+	.free_pgtable_range	= hugetlb_free_pgd_range,
 };
 
 static const struct inode_operations hugetlbfs_dir_inode_operations = {
diff --git a/mm/memory.c b/mm/memory.c
index a3bcaf3..d2f28e7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -279,15 +279,15 @@ void free_pgtables(struct mmu_gather **tlb, struct vm_area_struct *vma,
 		anon_vma_unlink(vma);
 		unlink_file_vma(vma);
 
-		if (is_vm_hugetlb_page(vma)) {
-			hugetlb_free_pgd_range(tlb, addr, vma->vm_end,
+		if (has_pt_op(vma, free_pgtable_range)) {
+			pt_op(vma, free_pgtable_range)(tlb, addr, vma->vm_end,
 				floor, next? next->vm_start: ceiling);
 		} else {
 			/*
 			 * Optimization: gather nearby vmas into one call down
 			 */
 			while (next && next->vm_start <= vma->vm_end + PMD_SIZE
-			       && !is_vm_hugetlb_page(next)) {
+			       && !has_pt_op(next, free_pgtable_range)) {
 				vma = next;
 				next = vma->vm_next;
 				anon_vma_unlink(vma);
