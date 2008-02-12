Return-Path: <linux-kernel-owner+w=401wt.eu-S1762620AbYBLLcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762620AbYBLLcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 06:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761098AbYBLLcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 06:32:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724AbYBLLcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 06:32:05 -0500
Date: Tue, 12 Feb 2008 19:29:19 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, corbet@lwn.net
Subject: [PATCH 2/2] mm: various cleanups in get_user_pages()
Message-ID: <20080212112919.GB3481@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains various cleanups, including making sure vma is valid, and
the return value of follow_hugetlb_page() is validated.

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 mm/memory.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 54f951b..49403a8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1003,7 +1003,9 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		unsigned int foll_flags;
 
 		vma = find_extend_vma(mm, start);
-		if (!vma && in_gate_area(tsk, start)) {
+		if (!vma)
+			goto finish_or_fault;
+		if (in_gate_area(tsk, start)) {
 			unsigned long pg = start & PAGE_MASK;
 			struct vm_area_struct *gate_vma = get_gate_vma(tsk);
 			pgd_t *pgd;
@@ -1011,7 +1013,7 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 			pmd_t *pmd;
 			pte_t *pte;
 			if (write) /* user gate pages are read-only */
-				return i ? : -EFAULT;
+				goto finish_or_fault;
 			if (pg > TASK_SIZE)
 				pgd = pgd_offset_k(pg);
 			else
@@ -1021,11 +1023,11 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
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
@@ -1041,13 +1043,15 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 			continue;
 		}
 
-		if (!vma || (vma->vm_flags & (VM_IO | VM_PFNMAP))
+		if ((vma->vm_flags & (VM_IO | VM_PFNMAP))
 				|| !(vm_flags & vma->vm_flags))
-			return i ? : -EFAULT;
+			goto finish_or_fault;
 
 		if (is_vm_hugetlb_page(vma)) {
 			i = follow_hugetlb_page(mm, vma, pages, vmas,
 						&start, len, i, write);
+			if (i == -EFAULT)
+				goto finish_or_fault;
 			continue;
 		}
 
@@ -1080,9 +1084,9 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
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
@@ -1115,6 +1119,12 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		}
 	}
 	return i;
+
+finish_or_oom:
+	return i ? : -ENOMEM;
+
+finish_or_fault:
+	return i ? : -EFAULT;
 }
 EXPORT_SYMBOL(get_user_pages);
 
