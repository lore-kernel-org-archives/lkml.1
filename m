Return-Path: <linux-kernel-owner+w=401wt.eu-S932794AbZHDKjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbZHDKjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 06:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932521AbZHDKjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 06:39:25 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:21494 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932779AbZHDKjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 06:39:24 -0400
X-IronPort-AV: E=Sophos;i="4.43,321,1246831200"; 
   d="scan'208";a="30765341"
Message-ID: <4A780FE6.9050704@inria.fr>
Date: Tue, 04 Aug 2009 12:39:34 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Leon Woestenberg <leon.woestenberg@gmail.com>
CC: Brice Goglin <Brice.Goglin@inria.fr>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] mm: get_user_pages() stores ERR_PTR() in pages[i] on failure
References: <c384c5ea0908030823y494ee8bei85aa62c1470fa3ec@mail.gmail.com>	 <Pine.LNX.4.64.0908031724200.2296@sister.anvils>	 <4A77FCFB.9020001@inria.fr> <c384c5ea0908040259k4295c986wdd45fe9e1e4315b1@mail.gmail.com>
In-Reply-To: <c384c5ea0908040259k4295c986wdd45fe9e1e4315b1@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> I wonder if we should change get_user_pages to store ERR_PTR(ret)
>> in page[i] when it fails to get page #i.
>>     
> Yes, I would see that as an improvement in finding out why rc <
> nr_pages, in case rc > 0.
>
> Also I think it does not break existing users.
>   

Only compile-tested (and not in the nommu case).




When get_user_pages() fails to get a non-first page, it returns
the number of successfully gotten pages. The caller has to call
get_user_pages() again on the failed page to figure out the
error code.

Store the error code with ERR_PTR() in pages[i] when we fail
to get page #i.

The arch specific get_user_pages_fast() do not need to be changed
since they revert to the main get_user_pages() on failure.

Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>

diff --git a/mm/memory.c b/mm/memory.c
index aede2ce..cd4efa3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1217,6 +1217,7 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 	int force = !!(flags & GUP_FLAGS_FORCE);
 	int ignore = !!(flags & GUP_FLAGS_IGNORE_VMA_PERMISSIONS);
 	int ignore_sigkill = !!(flags & GUP_FLAGS_IGNORE_SIGKILL);
+	int err = -EFAULT;
 
 	if (nr_pages <= 0)
 		return 0;
@@ -1243,7 +1244,7 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 
 			/* user gate pages are read-only */
 			if (!ignore && write)
-				return i ? : -EFAULT;
+				goto abort;
 			if (pg > TASK_SIZE)
 				pgd = pgd_offset_k(pg);
 			else
@@ -1253,11 +1254,11 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 			BUG_ON(pud_none(*pud));
 			pmd = pmd_offset(pud, pg);
 			if (pmd_none(*pmd))
-				return i ? : -EFAULT;
+				goto abort;
 			pte = pte_offset_map(pmd, pg);
 			if (pte_none(*pte)) {
 				pte_unmap(pte);
-				return i ? : -EFAULT;
+				goto abort;
 			}
 			if (pages) {
 				struct page *page = vm_normal_page(gate_vma, start, *pte);
@@ -1277,7 +1278,7 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		if (!vma ||
 		    (vma->vm_flags & (VM_IO | VM_PFNMAP)) ||
 		    (!ignore && !(vm_flags & vma->vm_flags)))
-			return i ? : -EFAULT;
+			goto abort;
 
 		if (is_vm_hugetlb_page(vma)) {
 			i = follow_hugetlb_page(mm, vma, pages, vmas,
@@ -1302,8 +1303,10 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 			 * we're only unlocking already resident/mapped pages.
 			 */
 			if (unlikely(!ignore_sigkill &&
-					fatal_signal_pending(current)))
-				return i ? i : -ERESTARTSYS;
+					fatal_signal_pending(current))) {
+				err = -ERESTARTSYS;
+				goto abort;
+			}
 
 			if (write)
 				foll_flags |= FOLL_WRITE;
@@ -1317,10 +1320,11 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 					FAULT_FLAG_WRITE : 0);
 
 				if (ret & VM_FAULT_ERROR) {
-					if (ret & VM_FAULT_OOM)
-						return i ? i : -ENOMEM;
-					else if (ret & VM_FAULT_SIGBUS)
-						return i ? i : -EFAULT;
+					if (ret & VM_FAULT_OOM) {
+						err = -ENOMEM;
+						goto abort;
+					} else if (ret & VM_FAULT_SIGBUS)
+						goto abort;
 					BUG();
 				}
 				if (ret & VM_FAULT_MAJOR)
@@ -1346,8 +1350,10 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 
 				cond_resched();
 			}
-			if (IS_ERR(page))
-				return i ? i : PTR_ERR(page);
+			if (IS_ERR(page)) {
+				err = PTR_ERR(page);
+				goto abort;
+			}
 			if (pages) {
 				pages[i] = page;
 
@@ -1362,6 +1368,11 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		} while (nr_pages && start < vma->vm_end);
 	} while (nr_pages);
 	return i;
+
+ abort:
+	if (pages)
+		pages[i] = ERR_PTR(err);
+	return i ? : err;
 }
 
 /**
diff --git a/mm/nommu.c b/mm/nommu.c
index 53cab10..5fe8083 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -212,6 +212,8 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 	return i;
 
 finish_or_fault:
+	if (pages)
+		pages[i] = ERR_PTR(-EFAULT);
 	return i ? : -EFAULT;
 }
 


