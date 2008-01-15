Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbYAOW2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbYAOW2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757294AbYAOW1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:27:15 -0500
Received: from 247.sub-75-209-114.myvzw.com ([75.209.114.247]:38362 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754293AbYAOW1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:27:13 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 4] x86: refactor mmu ops in paravirt.h
X-Mercurial-Node: 561b851072875899ee942827f399571da493234b
Message-Id: <561b851072875899ee94.1200435426@localhost>
In-Reply-To: <patchbomb.1200435425@localhost>
Date: Tue, 15 Jan 2008 14:17:06 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Habkost <ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rearrange mmu ops in paravirt.h to remove duplication and to make
adding 4th level operations simple.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>
---
 include/asm-x86/page.h     |   10 +
 include/asm-x86/paravirt.h |  223 +++++++++++++++++++++++++-------------------
 2 files changed, 137 insertions(+), 96 deletions(-)

diff --git a/include/asm-x86/page.h b/include/asm-x86/page.h
--- a/include/asm-x86/page.h
+++ b/include/asm-x86/page.h
@@ -91,6 +91,11 @@ static inline pudval_t native_pud_val(pu
 }
 #else	/* PAGETABLE_LEVELS == 3 */
 #include <asm-generic/pgtable-nopud.h>
+
+static inline pudval_t native_pud_val(pud_t pud)
+{
+	return native_pgd_val(pud.pgd);
+}
 #endif	/* PAGETABLE_LEVELS == 4 */
 
 typedef struct { pmdval_t pmd; } pmd_t;
@@ -106,6 +111,11 @@ static inline pmdval_t native_pmd_val(pm
 }
 #else  /* PAGETABLE_LEVELS == 2 */
 #include <asm-generic/pgtable-nopmd.h>
+
+static inline pmdval_t native_pmd_val(pmd_t pmd)
+{
+	return native_pgd_val(pmd.pud.pgd);
+}
 #endif	/* PAGETABLE_LEVELS >= 3 */
 
 static inline pte_t native_make_pte(pteval_t val)
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -230,28 +230,31 @@ struct pv_mmu_ops {
 	void (*pte_update_defer)(struct mm_struct *mm,
 				 unsigned long addr, pte_t *ptep);
 
+	pteval_t (*pte_val)(pte_t);
+	pte_t (*make_pte)(pteval_t pte);
+
+	pgdval_t (*pgd_val)(pgd_t);
+	pgd_t (*make_pgd)(pgdval_t pgd);
+
+#if PAGETABLE_LEVELS >= 3
 #ifdef CONFIG_X86_PAE
 	void (*set_pte_atomic)(pte_t *ptep, pte_t pteval);
 	void (*set_pte_present)(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, pte_t pte);
-	void (*set_pud)(pud_t *pudp, pud_t pudval);
 	void (*pte_clear)(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
 	void (*pmd_clear)(pmd_t *pmdp);
+#endif	/* X86_PAE */
 
-	unsigned long long (*pte_val)(pte_t);
-	unsigned long long (*pmd_val)(pmd_t);
-	unsigned long long (*pgd_val)(pgd_t);
+	void (*set_pud)(pud_t *pudp, pud_t pudval);
 
-	pte_t (*make_pte)(unsigned long long pte);
-	pmd_t (*make_pmd)(unsigned long long pmd);
-	pgd_t (*make_pgd)(unsigned long long pgd);
-#else
-	unsigned long (*pte_val)(pte_t);
-	unsigned long (*pgd_val)(pgd_t);
+	pmdval_t (*pmd_val)(pmd_t);
+	pmd_t (*make_pmd)(pmdval_t pmd);
 
-	pte_t (*make_pte)(unsigned long pte);
-	pgd_t (*make_pgd)(unsigned long pgd);
-#endif
+#if PAGETABLE_LEVELS == 4
+	pudval_t (*pud_val)(pud_t);
+	pud_t (*make_pud)(pudval_t pud);
+#endif	/* PAGETABLE_LEVELS == 4 */
+#endif	/* PAGETABLE_LEVELS >= 3 */
 
 #ifdef CONFIG_HIGHPTE
 	void *(*kmap_atomic_pte)(struct page *page, enum km_type type);
@@ -916,57 +919,134 @@ static inline void pte_update_defer(stru
 	PVOP_VCALL3(pv_mmu_ops.pte_update_defer, mm, addr, ptep);
 }
 
-#ifdef CONFIG_X86_PAE
-static inline pte_t __pte(unsigned long long val)
+static inline pteval_t pte_val(pte_t pte)
 {
-	unsigned long long ret = PVOP_CALL2(unsigned long long,
-					    pv_mmu_ops.make_pte,
-					    val, val >> 32);
+	pteval_t ret;
+
+	if (sizeof(pteval_t) > sizeof(unsigned long))
+		ret = PVOP_CALL2(pteval_t, pv_mmu_ops.pte_val,
+				 pte.pte, (u64)pte.pte >> 32);
+	else
+		ret = PVOP_CALL1(pteval_t, pv_mmu_ops.pte_val, pte.pte);
+
+	return ret;
+}
+
+static inline pte_t __pte(pteval_t val)
+{
+	pteval_t ret;
+
+	if (sizeof(pteval_t) > sizeof(unsigned long))
+		ret = PVOP_CALL2(pteval_t, pv_mmu_ops.make_pte,
+				 val, (u64)val >> 32);
+	else
+		ret = PVOP_CALL1(pteval_t, pv_mmu_ops.make_pte, val);
+
 	return (pte_t) { .pte = ret };
 }
 
-static inline pmd_t __pmd(unsigned long long val)
+static inline pgdval_t pgd_val(pgd_t pgd)
 {
-	return (pmd_t) { PVOP_CALL2(unsigned long long, pv_mmu_ops.make_pmd,
-				    val, val >> 32) };
+	pgdval_t ret;
+
+	if (sizeof(pgdval_t) > sizeof(unsigned long))
+		ret = PVOP_CALL2(pgdval_t, pv_mmu_ops.pgd_val,
+				 pgd.pgd, (u64)pgd.pgd >> 32);
+	else
+		ret = PVOP_CALL1(pgdval_t, pv_mmu_ops.pgd_val, pgd.pgd);
+
+	return ret;
 }
 
-static inline pgd_t __pgd(unsigned long long val)
+static inline pgd_t __pgd(pgdval_t val)
 {
-	return (pgd_t) { PVOP_CALL2(unsigned long long, pv_mmu_ops.make_pgd,
-				    val, val >> 32) };
+	pgdval_t ret;
+
+	if (sizeof(pgdval_t) > sizeof(unsigned long))
+		ret = PVOP_CALL2(pgdval_t, pv_mmu_ops.make_pgd,
+				 val, (u64)val >> 32);
+	else
+		ret = PVOP_CALL1(pgdval_t, pv_mmu_ops.make_pgd, val);
+
+	return (pgd_t) { .pgd = ret };
 }
 
-static inline unsigned long long pte_val(pte_t x)
+static inline void set_pte(pte_t *ptep, pte_t pte)
 {
-	return PVOP_CALL2(unsigned long long, pv_mmu_ops.pte_val,
-			  x.pte_low, x.pte_high);
-}
+	pteval_t val = native_pte_val(pte);
 
-static inline unsigned long long pmd_val(pmd_t x)
-{
-	return PVOP_CALL2(unsigned long long, pv_mmu_ops.pmd_val,
-			  x.pmd, x.pmd >> 32);
-}
-
-static inline unsigned long long pgd_val(pgd_t x)
-{
-	return PVOP_CALL2(unsigned long long, pv_mmu_ops.pgd_val,
-			  x.pgd, x.pgd >> 32);
-}
-
-static inline void set_pte(pte_t *ptep, pte_t pteval)
-{
-	PVOP_VCALL3(pv_mmu_ops.set_pte, ptep, pteval.pte_low, pteval.pte_high);
+	if (sizeof(pteval_t) > sizeof(unsigned long))
+		PVOP_VCALL3(pv_mmu_ops.set_pte, ptep, val, (u64)val >> 32);
+	else
+		PVOP_VCALL2(pv_mmu_ops.set_pte, ptep, val);
 }
 
 static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
-			      pte_t *ptep, pte_t pteval)
+			      pte_t *ptep, pte_t pte)
 {
-	/* 5 arg words */
-	pv_mmu_ops.set_pte_at(mm, addr, ptep, pteval);
+	pteval_t val = native_pte_val(pte);
+
+	if (sizeof(pteval_t) > sizeof(unsigned long))
+		/* 5 arg words */
+		pv_mmu_ops.set_pte_at(mm, addr, ptep, pte);
+	else
+		PVOP_VCALL4(pv_mmu_ops.set_pte_at, mm, addr, ptep, val);
 }
 
+static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
+{
+	pmdval_t val = native_pmd_val(pmd);
+
+	if (sizeof(pmdval_t) > sizeof(unsigned long))
+		PVOP_VCALL3(pv_mmu_ops.set_pmd, pmdp,
+			    val, (u64)val >> 32);
+	else
+		PVOP_VCALL2(pv_mmu_ops.set_pmd, pmdp, val);
+}
+
+#if PAGETABLE_LEVELS >= 3
+static inline pmdval_t pmd_val(pmd_t pmd)
+{
+	pmdval_t ret;
+
+	if (sizeof(pmdval_t) > sizeof(unsigned long))
+		ret = PVOP_CALL2(pmdval_t, pv_mmu_ops.pmd_val,
+				 pmd.pmd, (u64)pmd.pmd >> 32);
+	else
+		ret = PVOP_CALL1(pmdval_t, pv_mmu_ops.pmd_val, pmd.pmd);
+
+	return ret;
+}
+
+static inline pmd_t __pmd(pmdval_t val)
+{
+	pmdval_t ret;
+
+	if (sizeof(pmdval_t) > sizeof(unsigned long))
+		ret = PVOP_CALL2(pmdval_t, pv_mmu_ops.make_pmd,
+				 val, (u64)val >> 32);
+	else
+		ret = PVOP_CALL1(pmdval_t, pv_mmu_ops.make_pmd, val);
+
+	return (pmd_t) { .pmd = ret };
+}
+
+static inline void set_pud(pud_t *pudp, pud_t pud)
+{
+	pudval_t val = native_pud_val(pud);
+
+	if (sizeof(pudval_t) > sizeof(unsigned long))
+		PVOP_VCALL3(pv_mmu_ops.set_pud, pudp,
+			    val, (u64)val >> 32);
+	else
+		PVOP_VCALL2(pv_mmu_ops.set_pud, pudp, val);
+}
+
+#if PAGETABLE_LEVELS == 4
+#endif	/* PAGETABLE_LEVELS == 4 */
+#endif	/* PAGETABLE_LEVELS >= 3 */
+
+#ifdef CONFIG_X86_PAE
 static inline void set_pte_atomic(pte_t *ptep, pte_t pteval)
 {
 	PVOP_VCALL3(pv_mmu_ops.set_pte_atomic, ptep,
@@ -980,18 +1060,6 @@ static inline void set_pte_present(struc
 	pv_mmu_ops.set_pte_present(mm, addr, ptep, pte);
 }
 
-static inline void set_pmd(pmd_t *pmdp, pmd_t pmdval)
-{
-	PVOP_VCALL3(pv_mmu_ops.set_pmd, pmdp,
-		    pmdval.pmd, pmdval.pmd >> 32);
-}
-
-static inline void set_pud(pud_t *pudp, pud_t pudval)
-{
-	PVOP_VCALL3(pv_mmu_ops.set_pud, pudp,
-		    pudval.pgd.pgd, pudval.pgd.pgd >> 32);
-}
-
 static inline void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
 	PVOP_VCALL3(pv_mmu_ops.pte_clear, mm, addr, ptep);
@@ -1001,45 +1069,7 @@ static inline void pmd_clear(pmd_t *pmdp
 {
 	PVOP_VCALL1(pv_mmu_ops.pmd_clear, pmdp);
 }
-
 #else  /* !CONFIG_X86_PAE */
-
-static inline pte_t __pte(unsigned long val)
-{
-	return (pte_t) { PVOP_CALL1(unsigned long, pv_mmu_ops.make_pte, val) };
-}
-
-static inline pgd_t __pgd(unsigned long val)
-{
-	return (pgd_t) { PVOP_CALL1(unsigned long, pv_mmu_ops.make_pgd, val) };
-}
-
-static inline unsigned long pte_val(pte_t x)
-{
-	return PVOP_CALL1(unsigned long, pv_mmu_ops.pte_val, x.pte_low);
-}
-
-static inline unsigned long pgd_val(pgd_t x)
-{
-	return PVOP_CALL1(unsigned long, pv_mmu_ops.pgd_val, x.pgd);
-}
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
-
-static inline void set_pmd(pmd_t *pmdp, pmd_t pmdval)
-{
-	PVOP_VCALL2(pv_mmu_ops.set_pmd, pmdp, pmdval.pud.pgd.pgd);
-}
-
 static inline void pmd_clear(pmd_t *pmdp)
 {
 	set_pmd(pmdp, __pmd(0));
@@ -1061,6 +1091,7 @@ static inline void set_pte_present(struc
 	set_pte(ptep, pte);
 }
 #endif	/* CONFIG_X86_PAE */
+
 
 /* Lazy mode for batching updates / context switch */
 enum paravirt_lazy_mode {


