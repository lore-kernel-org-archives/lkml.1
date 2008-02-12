Return-Path: <linux-kernel-owner+w=401wt.eu-S1761308AbYBLHvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761308AbYBLHvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 02:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757597AbYBLHvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 02:51:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756412AbYBLHvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 02:51:14 -0500
Date: Tue, 12 Feb 2008 15:48:30 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] mm: tidy up follow_hugetlb_page() and get_user_pages()
Message-ID: <20080212074830.GA10346@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
References: <20080212052840.GA3942@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212052840.GA3942@kernel.sg>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed that Linus has committed your patch.

Here's a resend of my patch. Kindly review please.

[PATCH] mm: tidy up follow_hugetlb_page() and get_user_pages()

This patch extends Jonathan Corbet's patch to avoid buffer overflows in
get_user_pages(). It tidies up follow_hugetlb_page(), and get_user_pages() to
make sure that vma is also validated, and the code is more readable.

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 include/linux/hugetlb.h |    2 +-
 mm/hugetlb.c            |   13 +++----------
 mm/memory.c             |   39 ++++++++++++++++++++++-----------------
 3 files changed, 26 insertions(+), 28 deletions(-)

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
index d9a3803..ac5cf8a 100644
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
 
@@ -987,10 +986,6 @@ int follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			spin_lock(&mm->page_table_lock);
 			if (!(ret & VM_FAULT_ERROR))
 				continue;
-
-			remainder = 0;
-			if (!i)
-				i = -EFAULT;
 			break;
 		}
 
@@ -1007,9 +1002,8 @@ same_page:
 
 		vaddr += PAGE_SIZE;
 		++pfn_offset;
-		--remainder;
 		++i;
-		if (vaddr < vma->vm_end && remainder &&
+		if (i < length && vaddr < vma->vm_end &&
 				pfn_offset < HPAGE_SIZE/PAGE_SIZE) {
 			/*
 			 * We use pfn_offset to avoid touching the pageframes
@@ -1019,7 +1013,6 @@ same_page:
 		}
 	}
 	spin_unlock(&mm->page_table_lock);
-	*length = remainder;
 	*position = vaddr;
 
 	return i;
diff --git a/mm/memory.c b/mm/memory.c
index 717aa0e..ac7d104 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -989,8 +989,7 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 	int i;
 	unsigned int vm_flags;
 
-	if (len <= 0)
-		return 0;
+ 	BUG_ON(len <= 0);
 	/* 
 	 * Require read or write permissions.
 	 * If 'force' is set, we only require the "MAY" flags.
@@ -999,12 +998,14 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 	vm_flags &= force ? (VM_MAYREAD | VM_MAYWRITE) : (VM_READ | VM_WRITE);
 	i = 0;
 
-	do {
+	while (i < len) {
 		struct vm_area_struct *vma;
 		unsigned int foll_flags;
 
 		vma = find_extend_vma(mm, start);
-		if (!vma && in_gate_area(tsk, start)) {
+ 		if (!vma)
+ 			goto finish_or_fault;
+ 		if (in_gate_area(tsk, start)) {
 			unsigned long pg = start & PAGE_MASK;
 			struct vm_area_struct *gate_vma = get_gate_vma(tsk);
 			pgd_t *pgd;
@@ -1012,7 +1013,7 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 			pmd_t *pmd;
 			pte_t *pte;
 			if (write) /* user gate pages are read-only */
-				return i ? : -EFAULT;
+				goto finish_or_fault;
 			if (pg > TASK_SIZE)
 				pgd = pgd_offset_k(pg);
 			else
@@ -1022,11 +1023,11 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 			BUG_ON(pud_none(*pud));
 			pmd = pmd_offset(pud, pg);
 			if (pmd_none(*pmd))
-				return i ? : -EFAULT;
+				goto finish_or_fault;
 			pte = pte_offset_map(pmd, pg);
 			if (pte_none(*pte)) {
 				pte_unmap(pte);
-				return i ? : -EFAULT;
+				goto finish_or_fault;
 			}
 			if (pages) {
 				struct page *page = vm_normal_page(gate_vma, start, *pte);
@@ -1039,17 +1040,16 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 				vmas[i] = gate_vma;
 			i++;
 			start += PAGE_SIZE;
-			len--;
 			continue;
 		}
 
-		if (!vma || (vma->vm_flags & (VM_IO | VM_PFNMAP))
+		if ((vma->vm_flags & (VM_IO | VM_PFNMAP))
 				|| !(vm_flags & vma->vm_flags))
-			return i ? : -EFAULT;
+			goto finish_or_fault;
 
 		if (is_vm_hugetlb_page(vma)) {
 			i = follow_hugetlb_page(mm, vma, pages, vmas,
-						&start, &len, i, write);
+						&start, len, i, write);
 			continue;
 		}
 
@@ -1061,7 +1061,7 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 					!vma->vm_ops->fault)))
 			foll_flags |= FOLL_ANON;
 
-		do {
+		while (i < len && start < vma->vm_end) {
 			struct page *page;
 
 			/*
@@ -1082,9 +1082,9 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 						foll_flags & FOLL_WRITE);
 				if (ret & VM_FAULT_ERROR) {
 					if (ret & VM_FAULT_OOM)
-						return i ? i : -ENOMEM;
+						goto finish_or_oom;
 					else if (ret & VM_FAULT_SIGBUS)
-						return i ? i : -EFAULT;
+						goto finish_or_fault;
 					BUG();
 				}
 				if (ret & VM_FAULT_MAJOR)
@@ -1114,10 +1114,15 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 				vmas[i] = vma;
 			i++;
 			start += PAGE_SIZE;
-			len--;
-		} while (len && start < vma->vm_end);
-	} while (len);
+		}
+	}
 	return i;
+
+finish_or_oom:
+	return i ? : -ENOMEM;
+
+finish_or_fault:
+	return i ? : -EFAULT;
 }
 EXPORT_SYMBOL(get_user_pages);
 
