Return-Path: <linux-kernel-owner+w=401wt.eu-S932081AbXCZGhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbXCZGhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 02:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933630AbXCZGhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 02:37:21 -0400
Received: from smtp-out.google.com ([216.239.45.13]:12000 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081AbXCZGhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 02:37:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=MytlpHYHvjvyRY+Mb1OZjWQ43MDIj35Vyrl93UHQ7+Rw4wqEMq1bby25l273e7BWg
	LVnkLze2gKSGBqPglcTIg==
Date: Sun, 25 Mar 2007 23:37:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, Zachary Amsden <zach@vmware.com>,
       linux-kernel@vger.kernel.org
Subject: [patch -mm] i386: use pte_update_defer in ptep_test_and_clear_{dirty,young}
Message-ID: <Pine.LNX.4.64.0703252335560.4535@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Date: Sun, 25 Mar 2007 23:07:43 -0800
	From: Zachary Amsden <zach@vmware.com>

	If you actually clear the bit, you need to:

	+         pte_update_defer(vma->vm_mm, addr, ptep);

	The reason is, when updating PTEs, the hypervisor must be notified.  Using
	atomic operations to do this is fine for all hypervisors I am aware of.
	However, for hypervisors which shadow page tables, if these PTE
	modifications are not trapped, you need a post-modification call to fulfill
	the update of the shadow page table.

Cc: Zachary Amsden <zach@vmware.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/asm-i386/pgtable.h |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/asm-i386/pgtable.h b/include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h
+++ b/include/asm-i386/pgtable.h
@@ -287,18 +287,24 @@ do {									\
 static inline int ptep_test_and_clear_dirty(struct vm_area_struct *vma,
 					    unsigned long addr, pte_t *ptep)
 {
-	if (!pte_dirty(*ptep))
-		return 0;
-	return test_and_clear_bit(_PAGE_BIT_DIRTY, &ptep->pte_low);
+	int ret = 0;
+	if (pte_dirty(*ptep))
+		ret = test_and_clear_bit(_PAGE_BIT_DIRTY, &ptep->pte_low);
+	if (ret)
+		pte_update_defer(vma->vm_mm, addr, ptep);
+	return ret;
 }
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
 					    unsigned long addr, pte_t *ptep)
 {
-	if (!pte_young(*ptep))
-		return 0;
-	return test_and_clear_bit(_PAGE_BIT_ACCESSED, &ptep->pte_low);
+	int ret = 0;
+	if (pte_young(*ptep))
+		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED, &ptep->pte_low);
+	if (ret)
+		pte_update_defer(vma->vm_mm, addr, ptep);
+	return ret;
 }
 
 /*
@@ -317,10 +323,8 @@ do {									\
 ({									\
 	int __dirty;							\
 	__dirty = ptep_test_and_clear_dirty((vma), (address), (ptep));	\
-	if (__dirty) {							\
-		pte_update_defer((vma)->vm_mm, (address), (ptep));	\
+	if (__dirty)							\
 		flush_tlb_page(vma, address);				\
-	}								\
 	__dirty;							\
 })
 
@@ -329,10 +333,8 @@ do {									\
 ({									\
 	int __young;							\
 	__young = ptep_test_and_clear_young((vma), (address), (ptep));	\
-	if (__young) {							\
-		pte_update_defer((vma)->vm_mm, (address), (ptep));	\
+	if (__young)							\
 		flush_tlb_page(vma, address);				\
-	}								\
 	__young;							\
 })
 
