Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbXKGTv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbXKGTv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 14:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbXKGTvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 14:51:49 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55136 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969AbXKGTvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 14:51:48 -0500
From: Adam Litke <agl@us.ibm.com>
Subject: [PATCH] hugetlb: follow_hugetlb_page for write access
Date: Wed, 07 Nov 2007 11:51:43 -0800
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>,
       Ken Chen <kenchen@google.com>, Adam Litke <agl@us.ibm.com>
Message-Id: <20071107195142.13505.49398.stgit@kernel>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When calling get_user_pages(), a write flag is passed in by the caller to
indicate if write access is required on the faulted-in pages.  Currently,
follow_hugetlb_page() ignores this flag and always faults pages for
read-only access.  This can cause data corruption because a device driver
that calls get_user_pages() with write set will not expect COW faults to
occur on the returned pages.

This patch passes the write flag down to follow_hugetlb_page() and makes
sure hugetlb_fault() is called with the right write_access parameter.

Signed-off-by: Adam Litke <agl@us.ibm.com>
---

 include/linux/hugetlb.h |    2 +-
 mm/hugetlb.c            |    5 +++--
 mm/memory.c             |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 3a19b03..31fa0a0 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -19,7 +19,7 @@ static inline int is_vm_hugetlb_page(struct vm_area_struct *vma)
 int hugetlb_sysctl_handler(struct ctl_table *, int, struct file *, void __user *, size_t *, loff_t *);
 int hugetlb_treat_movable_handler(struct ctl_table *, int, struct file *, void __user *, size_t *, loff_t *);
 int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *, struct vm_area_struct *);
-int follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *, struct page **, struct vm_area_struct **, unsigned long *, int *, int);
+int follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *, struct page **, struct vm_area_struct **, unsigned long *, int *, int, int);
 void unmap_hugepage_range(struct vm_area_struct *, unsigned long, unsigned long);
 void __unmap_hugepage_range(struct vm_area_struct *, unsigned long, unsigned long);
 int hugetlb_prefault(struct address_space *, struct vm_area_struct *);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index eab8c42..b645985 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -621,7 +621,8 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 
 int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			struct page **pages, struct vm_area_struct **vmas,
-			unsigned long *position, int *length, int i)
+			unsigned long *position, int *length, int i,
+			int write)
 {
 	unsigned long pfn_offset;
 	unsigned long vaddr = *position;
@@ -643,7 +644,7 @@ int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			int ret;
 
 			spin_unlock(&mm->page_table_lock);
-			ret = hugetlb_fault(mm, vma, vaddr, 0);
+			ret = hugetlb_fault(mm, vma, vaddr, write);
 			spin_lock(&mm->page_table_lock);
 			if (!(ret & VM_FAULT_ERROR))
 				continue;
diff --git a/mm/memory.c b/mm/memory.c
index f82b359..1bcd444 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1039,7 +1039,7 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 
 		if (is_vm_hugetlb_page(vma)) {
 			i = follow_hugetlb_page(mm, vma, pages, vmas,
-						&start, &len, i);
+						&start, &len, i, write);
 			continue;
 		}
 
