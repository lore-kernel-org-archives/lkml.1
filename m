Return-Path: <linux-kernel-owner+w=401wt.eu-S1762272AbYBLLay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762272AbYBLLay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 06:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbYBLLaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 06:30:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760276AbYBLLap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 06:30:45 -0500
Date: Tue, 12 Feb 2008 19:28:31 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, corbet@lwn.net
Subject: [PATCH 1/2] mm: make get_user_pages() more robust in handling
	arguments
Message-ID: <20080212112831.GA3481@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that get_user_pages() evaluates len upon entry into the while loops.
A BUG_ON check is added so that it will catch potential bugs when it is asked
to grab zero pages. follow_hugetlb_page() is modified to adapt the changes
made in get_user_pages().

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 include/linux/hugetlb.h |    2 +-
 mm/hugetlb.c            |   10 +++-------
 mm/memory.c             |   15 ++++++---------
 3 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 7ca198b..2e8a01d 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -20,7 +20,7 @@ int hugetlb_sysctl_handler(struct ctl_table *, int, struct file *, void __user *
 int hugetlb_overcommit_handler(struct ctl_table *, int, struct file *, void __user *, size_t *, loff_t *);
 int hugetlb_treat_movable_handler(struct ctl_table *, int, struct file *, void __user *, size_t *, loff_t *);
 int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *, struct vm_area_struct *);
-int follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *, struct page **, struct vm_area_struct **, unsigned long *, int *, int, int);
+int follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *, struct page **, struct vm_area_struct **, unsigned long *, int, int, int);
 void unmap_hugepage_range(struct vm_area_struct *, unsigned long, unsigned long);
 void __unmap_hugepage_range(struct vm_area_struct *, unsigned long, unsigned long);
 int hugetlb_prefault(struct address_space *, struct vm_area_struct *);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d9a3803..5bb8130 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -960,15 +960,14 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 
 int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			struct page **pages, struct vm_area_struct **vmas,
-			unsigned long *position, int *length, int i,
+			unsigned long *position, int length, int i,
 			int write)
 {
 	unsigned long pfn_offset;
 	unsigned long vaddr = *position;
-	int remainder = *length;
 
 	spin_lock(&mm->page_table_lock);
-	while (vaddr < vma->vm_end && remainder) {
+	while (i < length && vaddr < vma->vm_end) {
 		pte_t *pte;
 		struct page *page;
 
@@ -988,7 +987,6 @@ int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			if (!(ret & VM_FAULT_ERROR))
 				continue;
 
-			remainder = 0;
 			if (!i)
 				i = -EFAULT;
 			break;
@@ -1007,9 +1005,8 @@ same_page:
 
 		vaddr += PAGE_SIZE;
 		++pfn_offset;
-		--remainder;
 		++i;
-		if (vaddr < vma->vm_end && remainder &&
+		if (i < length && vaddr < vma->vm_end &&
 				pfn_offset < HPAGE_SIZE/PAGE_SIZE) {
 			/*
 			 * We use pfn_offset to avoid touching the pageframes
@@ -1019,7 +1016,6 @@ same_page:
 		}
 	}
 	spin_unlock(&mm->page_table_lock);
-	*length = remainder;
 	*position = vaddr;
 
 	return i;
diff --git a/mm/memory.c b/mm/memory.c
index 717aa0e..54f951b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -989,8 +989,7 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 	int i;
 	unsigned int vm_flags;
 
-	if (len <= 0)
-		return 0;
+	BUG_ON(len <= 0);
 	/* 
 	 * Require read or write permissions.
 	 * If 'force' is set, we only require the "MAY" flags.
@@ -999,7 +998,7 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 	vm_flags &= force ? (VM_MAYREAD | VM_MAYWRITE) : (VM_READ | VM_WRITE);
 	i = 0;
 
-	do {
+	while (i < len) {
 		struct vm_area_struct *vma;
 		unsigned int foll_flags;
 
@@ -1039,7 +1038,6 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 				vmas[i] = gate_vma;
 			i++;
 			start += PAGE_SIZE;
-			len--;
 			continue;
 		}
 
@@ -1049,7 +1047,7 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 
 		if (is_vm_hugetlb_page(vma)) {
 			i = follow_hugetlb_page(mm, vma, pages, vmas,
-						&start, &len, i, write);
+						&start, len, i, write);
 			continue;
 		}
 
@@ -1061,7 +1059,7 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 					!vma->vm_ops->fault)))
 			foll_flags |= FOLL_ANON;
 
-		do {
+		while (i < len && start < vma->vm_end) {
 			struct page *page;
 
 			/*
@@ -1114,9 +1112,8 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 				vmas[i] = vma;
 			i++;
 			start += PAGE_SIZE;
-			len--;
-		} while (len && start < vma->vm_end);
-	} while (len);
+		}
+	}
 	return i;
 }
 EXPORT_SYMBOL(get_user_pages);

