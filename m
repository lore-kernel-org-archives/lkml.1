Return-Path: <linux-kernel-owner+w=401wt.eu-S933477AbXF2ONv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933477AbXF2ONv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 10:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932185AbXF2ON0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 10:13:26 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:34788 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765904AbXF2ONZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 10:13:25 -0400
Message-Id: <20070629141527.839906850@de.ibm.com>
References: <20070629135530.912094590@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Jun 2007 15:55:32 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 2/5] remove ptep_establish.
Content-Disposition: inline; filename=003-ptep-establish.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

The last user of ptep_establish in mm/ is long gone. Remove the
architecture primitive as well.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 include/asm-generic/pgtable.h |   19 -------------------
 include/asm-i386/pgtable.h    |   11 -----------
 include/asm-ia64/pgtable.h    |    6 ++++--
 3 files changed, 4 insertions(+), 32 deletions(-)

diff -urpN linux-2.6/include/asm-generic/pgtable.h linux-2.6-patched/include/asm-generic/pgtable.h
--- linux-2.6/include/asm-generic/pgtable.h	2007-06-18 09:43:22.000000000 +0200
+++ linux-2.6-patched/include/asm-generic/pgtable.h	2007-06-29 15:44:10.000000000 +0200
@@ -3,25 +3,6 @@
 
 #ifndef __ASSEMBLY__
 
-#ifndef __HAVE_ARCH_PTEP_ESTABLISH
-/*
- * Establish a new mapping:
- *  - flush the old one
- *  - update the page tables
- *  - inform the TLB about the new one
- *
- * We hold the mm semaphore for reading, and the pte lock.
- *
- * Note: the old pte is known to not be writable, so we don't need to
- * worry about dirty bits etc getting lost.
- */
-#define ptep_establish(__vma, __address, __ptep, __entry)		\
-do {				  					\
-	set_pte_at((__vma)->vm_mm, (__address), __ptep, __entry);	\
-	flush_tlb_page(__vma, __address);				\
-} while (0)
-#endif
-
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 /*
  * Largely same as above, but only sets the access flags (dirty,
diff -urpN linux-2.6/include/asm-i386/pgtable.h linux-2.6-patched/include/asm-i386/pgtable.h
--- linux-2.6/include/asm-i386/pgtable.h	2007-06-18 09:43:22.000000000 +0200
+++ linux-2.6-patched/include/asm-i386/pgtable.h	2007-06-29 15:44:10.000000000 +0200
@@ -317,17 +317,6 @@ static inline pte_t native_local_ptep_ge
 	__ret;								\
 })
 
-/*
- * Rules for using ptep_establish: the pte MUST be a user pte, and
- * must be a present->present transition.
- */
-#define __HAVE_ARCH_PTEP_ESTABLISH
-#define ptep_establish(vma, address, ptep, pteval)			\
-do {									\
-	set_pte_present((vma)->vm_mm, address, ptep, pteval);		\
-	flush_tlb_page(vma, address);					\
-} while (0)
-
 #define __HAVE_ARCH_PTEP_CLEAR_DIRTY_FLUSH
 #define ptep_clear_flush_dirty(vma, address, ptep)			\
 ({									\
diff -urpN linux-2.6/include/asm-ia64/pgtable.h linux-2.6-patched/include/asm-ia64/pgtable.h
--- linux-2.6/include/asm-ia64/pgtable.h	2007-06-18 09:43:22.000000000 +0200
+++ linux-2.6-patched/include/asm-ia64/pgtable.h	2007-06-29 15:44:10.000000000 +0200
@@ -546,8 +546,10 @@ extern void lazy_mmu_prot_update (pte_t 
 # define ptep_set_access_flags(__vma, __addr, __ptep, __entry, __safely_writable) \
 ({									\
 	int __changed = !pte_same(*(__ptep), __entry);			\
-	if (__changed)							\
-		ptep_establish(__vma, __addr, __ptep, __entry);		\
+	if (__changed) {						\
+		set_pte_at((__vma)->vm_mm, (__addr), __ptep, __entry);	\
+		flush_tlb_page(__vma, __addr);				\
+	}								\
 	__changed;							\
 })
 #endif

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

