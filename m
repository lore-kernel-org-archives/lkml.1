Return-Path: <linux-kernel-owner+w=401wt.eu-S932465AbXBSScJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465AbXBSScJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 13:32:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932472AbXBSScI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 13:32:08 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57523 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932465AbXBSSb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 13:31:58 -0500
From: Adam Litke <agl@us.ibm.com>
Subject: [PATCH 3/7] pin_pages for hugetlb
Date: Mon, 19 Feb 2007 10:31:55 -0800
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, agl@us.ibm.com
Message-Id: <20070219183155.27318.17766.stgit@localhost.localdomain>
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
 mm/memory.c          |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index c0a7984..2d1dd84 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -564,6 +564,7 @@ const struct file_operations hugetlbfs_file_operations = {
 
 static struct pagetable_operations_struct hugetlbfs_pagetable_ops = {
 	.copy_vma		= copy_hugetlb_page_range,
+	.pin_pages		= follow_hugetlb_page,
 };
 
 static struct inode_operations hugetlbfs_dir_inode_operations = {
diff --git a/mm/memory.c b/mm/memory.c
index 80eafd5..9467c65 100644
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
 
