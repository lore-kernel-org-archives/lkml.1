Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbYAQCbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbYAQCbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 21:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbYAQC3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 21:29:32 -0500
Received: from gw.goop.org ([64.81.55.164]:46849 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071AbYAQC31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 21:29:27 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 6 of 8] x86/paravirt: make set_pte operations common
X-Mercurial-Node: 3ba5016002e84434af8b3d0b21078805371d590d
Message-Id: <3ba5016002e84434af8b.1200526044@localhost>
In-Reply-To: <patchbomb.1200526038@localhost>
Date: Wed, 16 Jan 2008 15:27:24 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate set_pte* operations.  PAE still needs to have special
variants of some of these because it can't atomically update a 64-bit
pte, so there's still some duplication.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 include/asm-x86/paravirt.h |  116 ++++++++++++++++++++++----------------------
 1 file changed, 60 insertions(+), 56 deletions(-)

diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -978,6 +978,66 @@ static inline pgdval_t pgd_val(pgd_t pgd
 	return ret;
 }
 
+static inline void set_pte(pte_t *ptep, pte_t pte)
+{
+	if (sizeof(pteval_t) > sizeof(long))
+		PVOP_VCALL3(pv_mmu_ops.set_pte, ptep,
+			    pte.pte, (u64)pte.pte >> 32);
+	else
+		PVOP_VCALL2(pv_mmu_ops.set_pte, ptep,
+			    pte.pte);
+}
+
+static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
+			      pte_t *ptep, pte_t pte)
+{
+	if (sizeof(pteval_t) > sizeof(long))
+		/* 5 arg words */
+		pv_mmu_ops.set_pte_at(mm, addr, ptep, pte);
+	else
+		PVOP_VCALL4(pv_mmu_ops.set_pte_at, mm, addr, ptep, pte.pte);
+}
+
+#ifdef CONFIG_X86_PAE
+/* Special-case pte-setting operations for PAE, which can't update a
+   64-bit pte atomically */
+static inline void set_pte_atomic(pte_t *ptep, pte_t pte)
+{
+	PVOP_VCALL3(pv_mmu_ops.set_pte_atomic, ptep,
+		    pte.pte, pte.pte >> 32);
+}
+
+static inline void set_pte_present(struct mm_struct *mm, unsigned long addr,
+				   pte_t *ptep, pte_t pte)
+{
+	/* 5 arg words */
+	pv_mmu_ops.set_pte_present(mm, addr, ptep, pte);
+}
+
+static inline void pte_clear(struct mm_struct *mm, unsigned long addr,
+			     pte_t *ptep)
+{
+	PVOP_VCALL3(pv_mmu_ops.pte_clear, mm, addr, ptep);
+}
+#else  /* !CONFIG_X86_PAE */
+static inline void set_pte_atomic(pte_t *ptep, pte_t pte)
+{
+	set_pte(ptep, pte);
+}
+
+static inline void set_pte_present(struct mm_struct *mm, unsigned long addr,
+				   pte_t *ptep, pte_t pte)
+{
+	set_pte(ptep, pte);
+}
+
+static inline void pte_clear(struct mm_struct *mm, unsigned long addr,
+			     pte_t *ptep)
+{
+	set_pte_at(mm, addr, ptep, __pte(0));
+}
+#endif	/* CONFIG_X86_PAE */
+
 #if PAGETABLE_LEVELS >= 3
 static inline pmd_t __pmd(pmdval_t val)
 {
@@ -1010,31 +1070,6 @@ static inline pmdval_t pmd_val(pmd_t pmd
 
 #ifdef CONFIG_X86_PAE
 
-static inline void set_pte(pte_t *ptep, pte_t pteval)
-{
-	PVOP_VCALL3(pv_mmu_ops.set_pte, ptep, pteval.pte_low, pteval.pte_high);
-}
-
-static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
-			      pte_t *ptep, pte_t pteval)
-{
-	/* 5 arg words */
-	pv_mmu_ops.set_pte_at(mm, addr, ptep, pteval);
-}
-
-static inline void set_pte_atomic(pte_t *ptep, pte_t pteval)
-{
-	PVOP_VCALL3(pv_mmu_ops.set_pte_atomic, ptep,
-		    pteval.pte_low, pteval.pte_high);
-}
-
-static inline void set_pte_present(struct mm_struct *mm, unsigned long addr,
-				   pte_t *ptep, pte_t pte)
-{
-	/* 5 arg words */
-	pv_mmu_ops.set_pte_present(mm, addr, ptep, pte);
-}
-
 static inline void set_pmd(pmd_t *pmdp, pmd_t pmdval)
 {
 	PVOP_VCALL3(pv_mmu_ops.set_pmd, pmdp,
@@ -1047,28 +1082,12 @@ static inline void set_pud(pud_t *pudp, 
 		    pudval.pgd.pgd, pudval.pgd.pgd >> 32);
 }
 
-static inline void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
-{
-	PVOP_VCALL3(pv_mmu_ops.pte_clear, mm, addr, ptep);
-}
-
 static inline void pmd_clear(pmd_t *pmdp)
 {
 	PVOP_VCALL1(pv_mmu_ops.pmd_clear, pmdp);
 }
 
 #else  /* !CONFIG_X86_PAE */
-
-static inline void set_pte(pte_t *ptep, pte_t pteval)
-{
-	PVOP_VCALL2(pv_mmu_ops.set_pte, ptep, pteval.pte_low);
-}
-
-static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
-			      pte_t *ptep, pte_t pteval)
-{
-	PVOP_VCALL4(pv_mmu_ops.set_pte_at, mm, addr, ptep, pteval.pte_low);
-}
 
 static inline void set_pmd(pmd_t *pmdp, pmd_t pmdval)
 {
@@ -1080,21 +1099,6 @@ static inline void pmd_clear(pmd_t *pmdp
 	set_pmd(pmdp, __pmd(0));
 }
 
-static inline void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
-{
-	set_pte_at(mm, addr, ptep, __pte(0));
-}
-
-static inline void set_pte_atomic(pte_t *ptep, pte_t pte)
-{
-	set_pte(ptep, pte);
-}
-
-static inline void set_pte_present(struct mm_struct *mm, unsigned long addr,
-				   pte_t *ptep, pte_t pte)
-{
-	set_pte(ptep, pte);
-}
 #endif	/* CONFIG_X86_PAE */
 
 /* Lazy mode for batching updates / context switch */


