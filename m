Return-Path: <linux-kernel-owner+w=401wt.eu-S933234AbXCZAgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234AbXCZAgA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 20:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933235AbXCZAgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 20:36:00 -0400
Received: from smtp-out.google.com ([216.239.45.13]:33848 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933234AbXCZAf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 20:35:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=EGufar7hHPrCGOeAyFont3yUGZKrPHGUDIS+eew0WgVBnTwu3xxjGGvwkDLQTOt6c
	UR0ICeMAamZ1xnEnbANSQ==
Date: Sun, 25 Mar 2007 17:35:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [patch -mm 1/2] i386: add ptep_test_and_clear_{dirty,young}
Message-ID: <Pine.LNX.4.64.0703251731040.19025@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add ptep_test_and_clear_{dirty,young} to i386.  They advertise that they
have it and there is at least one place where it needs to be called
without the page table lock: to clear the accessed bit on write to
/proc/pid/clear_refs.

ptep_clear_flush_{dirty,young} are updated to use the new functions.  The
overall net effect to current users of ptep_clear_flush_{dirty,young} is
that we introduce an additional branch.

Cc: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/asm-i386/pgtable.h |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/include/asm-i386/pgtable.h b/include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h
+++ b/include/asm-i386/pgtable.h
@@ -283,12 +283,23 @@ do {									\
 	}								\
 } while (0)
 
-/*
- * We don't actually have these, but we want to advertise them so that
- * we can encompass the flush here.
- */
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
+static inline int ptep_test_and_clear_dirty(struct vm_area_struct *vma,
+					    unsigned long addr, pte_t *ptep)
+{
+	if (!pte_dirty(*ptep))
+		return 0;
+	return test_and_clear_bit(_PAGE_BIT_DIRTY, &ptep->pte_low);
+}
+
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
+static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
+					    unsigned long addr, pte_t *ptep)
+{
+	if (!pte_young(*ptep))
+		return 0;
+	return test_and_clear_bit(_PAGE_BIT_ACCESSED, &ptep->pte_low);
+}
 
 /*
  * Rules for using ptep_establish: the pte MUST be a user pte, and
@@ -305,9 +316,8 @@ do {									\
 #define ptep_clear_flush_dirty(vma, address, ptep)			\
 ({									\
 	int __dirty;							\
-	__dirty = pte_dirty(*(ptep));					\
+	__dirty = ptep_test_and_clear_dirty((vma), (address), (ptep));	\
 	if (__dirty) {							\
-		clear_bit(_PAGE_BIT_DIRTY, &(ptep)->pte_low);		\
 		pte_update_defer((vma)->vm_mm, (address), (ptep));	\
 		flush_tlb_page(vma, address);				\
 	}								\
@@ -318,9 +328,8 @@ do {									\
 #define ptep_clear_flush_young(vma, address, ptep)			\
 ({									\
 	int __young;							\
-	__young = pte_young(*(ptep));					\
+	__young = ptep_test_and_clear_young((vma), (address), (ptep));	\
 	if (__young) {							\
-		clear_bit(_PAGE_BIT_ACCESSED, &(ptep)->pte_low);	\
 		pte_update_defer((vma)->vm_mm, (address), (ptep));	\
 		flush_tlb_page(vma, address);				\
 	}								\
