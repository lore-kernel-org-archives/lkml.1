Return-Path: <linux-kernel-owner+w=401wt.eu-S1758914AbYF0P7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914AbYF0P7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 11:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758198AbYF0P6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 11:58:08 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:43670 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757951AbYF0P6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 11:58:07 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 4/6] avr32: Cover the kernel page tables in the user PGDs
Date: Fri, 27 Jun 2008 17:57:54 +0200
Message-Id: <1214582276-10889-4-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1214582276-10889-3-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214582276-10889-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1214582276-10889-2-git-send-email-haavard.skinnemoen@atmel.com>
 <1214582276-10889-3-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 27 Jun 2008 15:57:42.0248 (UTC) FILETIME=[88297680:01C8D86E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expand the per-process PGDs so that they cover the kernel virtual
memory area as well. This simplifies the TLB miss handler fastpath
since it doesn't have to check for kernel addresses anymore.

If a TLB miss happens on a kernel address and a second-level page
table can't be found, we check swapper_pg_dir and copy the PGD entry
into the user PGD if it can be found there.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 arch/avr32/kernel/entry-avr32b.S |   42 ++++++++++++++++++++++++++++---------
 include/asm-avr32/pgalloc.h      |   14 +++++++++---
 2 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/arch/avr32/kernel/entry-avr32b.S b/arch/avr32/kernel/entry-avr32b.S
index 3cdd707..2b398ca 100644
--- a/arch/avr32/kernel/entry-avr32b.S
+++ b/arch/avr32/kernel/entry-avr32b.S
@@ -98,10 +98,6 @@ tlb_miss_common:
 	mfsr	r0, SYSREG_TLBEAR
 	mfsr	r1, SYSREG_PTBR
 
-	/* Is it the vmalloc space? */
-	bld	r0, 31
-	brcs	handle_vmalloc_miss
-
 	/*
 	 * First level lookup: The PGD contains virtual pointers to
 	 * the second-level page tables, but they may be NULL if not
@@ -143,15 +139,13 @@ pgtbl_lookup:
 	tlbmiss_restore
 	rete
 
-handle_vmalloc_miss:
-	/* Simply do the lookup in init's page table */
-	mov	r1, lo(swapper_pg_dir)
-	orh	r1, hi(swapper_pg_dir)
-	rjmp	pgtbl_lookup
-
 	/* The slow path of the TLB miss handler */
 	.align	2
 page_table_not_present:
+	/* Do we need to synchronize with swapper_pg_dir? */
+	bld	r0, 31
+	brcs	sync_with_swapper_pg_dir
+
 page_not_present:
 	tlbmiss_restore
 	sub	sp, 4
@@ -162,6 +156,34 @@ page_not_present:
 	rcall	do_page_fault
 	rjmp	ret_from_exception
 
+	.align	2
+sync_with_swapper_pg_dir:
+	/*
+	 * If swapper_pg_dir contains a non-NULL second-level page
+	 * table pointer, copy it into the current PGD. If not, we
+	 * must handle it as a full-blown page fault.
+	 *
+	 * Jumping back to pgtbl_lookup causes an unnecessary lookup,
+	 * but it is guaranteed to be a cache hit, it won't happen
+	 * very often, and we absolutely do not want to sacrifice any
+	 * performance in the fast path in order to improve this.
+	 */
+	mov	r1, lo(swapper_pg_dir)
+	orh	r1, hi(swapper_pg_dir)
+	ld.w	r3, r1[r2 << 2]
+	cp.w	r3, 0
+	breq	page_not_present
+	mfsr	r1, SYSREG_PTBR
+	st.w	r1[r2 << 2], r3
+	rjmp	pgtbl_lookup
+
+	/*
+	 * We currently have two bytes left at this point until we
+	 * crash into the system call handler...
+	 *
+	 * Don't worry, the assembler will let us know.
+	 */
+
 
 	/* ---                    System Call                    --- */
 
diff --git a/include/asm-avr32/pgalloc.h b/include/asm-avr32/pgalloc.h
index 5b768fc..e9636d1 100644
--- a/include/asm-avr32/pgalloc.h
+++ b/include/asm-avr32/pgalloc.h
@@ -9,8 +9,6 @@
 #define __ASM_AVR32_PGALLOC_H
 
 #include <linux/mm.h>
-#include <linux/sched.h>
-#include <linux/slab.h>
 
 static inline void pmd_populate_kernel(struct mm_struct *mm,
 				       pmd_t *pmd, pte_t *pte)
@@ -30,12 +28,20 @@ static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
  */
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	return kcalloc(USER_PTRS_PER_PGD, sizeof(pgd_t), GFP_KERNEL);
+	pgd_t *pgd;
+
+	pgd = (pgd_t *)get_zeroed_page(GFP_KERNEL | __GFP_REPEAT);
+	if (likely(pgd))
+		memcpy(pgd + USER_PTRS_PER_PGD,
+			swapper_pg_dir + USER_PTRS_PER_PGD,
+			(PTRS_PER_PGD - USER_PTRS_PER_PGD) * sizeof(pgd_t));
+
+	return pgd;
 }
 
 static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
-	kfree(pgd);
+	free_page((unsigned long)pgd);
 }
 
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
-- 
1.5.5.4

