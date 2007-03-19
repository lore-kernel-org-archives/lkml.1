Return-Path: <linux-kernel-owner+w=401wt.eu-S932372AbXCSUF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372AbXCSUF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbXCSUFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:05:43 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:45871 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbXCSUFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:05:39 -0400
From: Adam Litke <agl@us.ibm.com>
Subject: [PATCH 3/7] pin_pages for hugetlb
Date: Mon, 19 Mar 2007 13:05:34 -0700
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adam Litke <agl@us.ibm.com>, Arjan van de Ven <arjan@infradead.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-Id: <20070319200534.17168.74446.stgit@localhost.localdomain>
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
index 2452dde..d0b4b46 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -567,6 +567,7 @@ const struct file_operations hugetlbfs_file_operations = {
 
 static const struct pagetable_operations_struct hugetlbfs_pagetable_ops = {
 	.copy_vma		= copy_hugetlb_page_range,
+	.pin_pages		= follow_hugetlb_page,
 };
 
 static const struct inode_operations hugetlbfs_dir_inode_operations = {
diff --git a/mm/memory.c b/mm/memory.c
index 69bb0b3..01256cf 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1039,9 +1039,9 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 				|| !(vm_flags & vma->vm_flags))
 			return i ? : -EFAULT;
 
-		if (is_vm_hugetlb_page(vma)) {
-			i = follow_hugetlb_page(mm, vma, pages, vmas,
-						&start, &len, i);
+		if (has_pt_op(vma, pin_pages)) {
+			i = pt_op(vma, pin_pages)(mm, vma, pages,
+						vmas, &start, &len, i);
 			continue;
 		}
 
