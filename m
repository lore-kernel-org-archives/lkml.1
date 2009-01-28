Return-Path: <linux-kernel-owner+w=401wt.eu-S1755757AbZA1Wow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbZA1Wow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 17:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbZA1Wmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 17:42:51 -0500
Received: from gw.goop.org ([64.81.55.164]:52580 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753120AbZA1Wmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 17:42:49 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 7 of 7] x86/paravirt: use callee-saved convention for
	pte_val/make_pte/etc
X-Mercurial-Node: 452b0aa6f629b7325a3e4b6d40c7f7c38f6960d0
Message-Id: <452b0aa6f629b7325a3e.1233182107@abulafia.goop.org>
In-Reply-To: <patchbomb.1233182100@abulafia.goop.org>
References: <patchbomb.1233182100@abulafia.goop.org>
Date: Wed, 28 Jan 2009 14:35:07 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ravikiran Thirumalai <kiran@scalemp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the native case, pte_val, make_pte, etc are all just identity
functions, so there's no need to clobber a lot of registers over them.

(This changes the 32-bit callee-save calling convention to return both
EAX and EDX so functions can return 64-bit values.)

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/paravirt.h |   78 +++++++++++++++++++--------------------
 arch/x86/kernel/paravirt.c      |   53 ++++++--------------------
 arch/x86/xen/mmu.c              |   24 ++++++++----
 3 files changed, 67 insertions(+), 88 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -19,7 +19,7 @@
 #define CLBR_ANY  ((1 << 4) - 1)
 
 #define CLBR_ARG_REGS	(CLBR_EAX | CLBR_EDX | CLBR_ECX)
-#define CLBR_RET_REG	(CLBR_EAX)
+#define CLBR_RET_REG	(CLBR_EAX | CLBR_EDX)
 #define CLBR_SCRATCH	(0)
 #else
 #define CLBR_RAX  CLBR_EAX
@@ -308,11 +308,11 @@
 	void (*ptep_modify_prot_commit)(struct mm_struct *mm, unsigned long addr,
 					pte_t *ptep, pte_t pte);
 
-	pteval_t (*pte_val)(pte_t);
-	pte_t (*make_pte)(pteval_t pte);
+	struct paravirt_callee_save pte_val;
+	struct paravirt_callee_save make_pte;
 
-	pgdval_t (*pgd_val)(pgd_t);
-	pgd_t (*make_pgd)(pgdval_t pgd);
+	struct paravirt_callee_save pgd_val;
+	struct paravirt_callee_save make_pgd;
 
 #if PAGETABLE_LEVELS >= 3
 #ifdef CONFIG_X86_PAE
@@ -327,12 +327,12 @@
 
 	void (*set_pud)(pud_t *pudp, pud_t pudval);
 
-	pmdval_t (*pmd_val)(pmd_t);
-	pmd_t (*make_pmd)(pmdval_t pmd);
+	struct paravirt_callee_save pmd_val;
+	struct paravirt_callee_save make_pmd;
 
 #if PAGETABLE_LEVELS == 4
-	pudval_t (*pud_val)(pud_t);
-	pud_t (*make_pud)(pudval_t pud);
+	struct paravirt_callee_save pud_val;
+	struct paravirt_callee_save make_pud;
 
 	void (*set_pgd)(pgd_t *pudp, pgd_t pgdval);
 #endif	/* PAGETABLE_LEVELS == 4 */
@@ -1155,13 +1155,13 @@
 	pteval_t ret;
 
 	if (sizeof(pteval_t) > sizeof(long))
-		ret = PVOP_CALL2(pteval_t,
-				 pv_mmu_ops.make_pte,
-				 val, (u64)val >> 32);
+		ret = PVOP_CALLEE2(pteval_t,
+				   pv_mmu_ops.make_pte,
+				   val, (u64)val >> 32);
 	else
-		ret = PVOP_CALL1(pteval_t,
-				 pv_mmu_ops.make_pte,
-				 val);
+		ret = PVOP_CALLEE1(pteval_t,
+				   pv_mmu_ops.make_pte,
+				   val);
 
 	return (pte_t) { .pte = ret };
 }
@@ -1171,11 +1171,11 @@
 	pteval_t ret;
 
 	if (sizeof(pteval_t) > sizeof(long))
-		ret = PVOP_CALL2(pteval_t, pv_mmu_ops.pte_val,
-				 pte.pte, (u64)pte.pte >> 32);
+		ret = PVOP_CALLEE2(pteval_t, pv_mmu_ops.pte_val,
+				   pte.pte, (u64)pte.pte >> 32);
 	else
-		ret = PVOP_CALL1(pteval_t, pv_mmu_ops.pte_val,
-				 pte.pte);
+		ret = PVOP_CALLEE1(pteval_t, pv_mmu_ops.pte_val,
+				   pte.pte);
 
 	return ret;
 }
@@ -1185,11 +1185,11 @@
 	pgdval_t ret;
 
 	if (sizeof(pgdval_t) > sizeof(long))
-		ret = PVOP_CALL2(pgdval_t, pv_mmu_ops.make_pgd,
-				 val, (u64)val >> 32);
+		ret = PVOP_CALLEE2(pgdval_t, pv_mmu_ops.make_pgd,
+				   val, (u64)val >> 32);
 	else
-		ret = PVOP_CALL1(pgdval_t, pv_mmu_ops.make_pgd,
-				 val);
+		ret = PVOP_CALLEE1(pgdval_t, pv_mmu_ops.make_pgd,
+				   val);
 
 	return (pgd_t) { ret };
 }
@@ -1199,11 +1199,11 @@
 	pgdval_t ret;
 
 	if (sizeof(pgdval_t) > sizeof(long))
-		ret =  PVOP_CALL2(pgdval_t, pv_mmu_ops.pgd_val,
-				  pgd.pgd, (u64)pgd.pgd >> 32);
+		ret =  PVOP_CALLEE2(pgdval_t, pv_mmu_ops.pgd_val,
+				    pgd.pgd, (u64)pgd.pgd >> 32);
 	else
-		ret =  PVOP_CALL1(pgdval_t, pv_mmu_ops.pgd_val,
-				  pgd.pgd);
+		ret =  PVOP_CALLEE1(pgdval_t, pv_mmu_ops.pgd_val,
+				    pgd.pgd);
 
 	return ret;
 }
@@ -1267,11 +1267,11 @@
 	pmdval_t ret;
 
 	if (sizeof(pmdval_t) > sizeof(long))
-		ret = PVOP_CALL2(pmdval_t, pv_mmu_ops.make_pmd,
-				 val, (u64)val >> 32);
+		ret = PVOP_CALLEE2(pmdval_t, pv_mmu_ops.make_pmd,
+				   val, (u64)val >> 32);
 	else
-		ret = PVOP_CALL1(pmdval_t, pv_mmu_ops.make_pmd,
-				 val);
+		ret = PVOP_CALLEE1(pmdval_t, pv_mmu_ops.make_pmd,
+				   val);
 
 	return (pmd_t) { ret };
 }
@@ -1281,11 +1281,11 @@
 	pmdval_t ret;
 
 	if (sizeof(pmdval_t) > sizeof(long))
-		ret =  PVOP_CALL2(pmdval_t, pv_mmu_ops.pmd_val,
-				  pmd.pmd, (u64)pmd.pmd >> 32);
+		ret =  PVOP_CALLEE2(pmdval_t, pv_mmu_ops.pmd_val,
+				    pmd.pmd, (u64)pmd.pmd >> 32);
 	else
-		ret =  PVOP_CALL1(pmdval_t, pv_mmu_ops.pmd_val,
-				  pmd.pmd);
+		ret =  PVOP_CALLEE1(pmdval_t, pv_mmu_ops.pmd_val,
+				    pmd.pmd);
 
 	return ret;
 }
@@ -1307,11 +1307,11 @@
 	pudval_t ret;
 
 	if (sizeof(pudval_t) > sizeof(long))
-		ret = PVOP_CALL2(pudval_t, pv_mmu_ops.make_pud,
-				 val, (u64)val >> 32);
+		ret = PVOP_CALLEE2(pudval_t, pv_mmu_ops.make_pud,
+				   val, (u64)val >> 32);
 	else
-		ret = PVOP_CALL1(pudval_t, pv_mmu_ops.make_pud,
-				 val);
+		ret = PVOP_CALLEE1(pudval_t, pv_mmu_ops.make_pud,
+				   val);
 
 	return (pud_t) { ret };
 }
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -391,43 +391,12 @@
 #endif
 };
 
-typedef pte_t make_pte_t(pteval_t);
-typedef pmd_t make_pmd_t(pmdval_t);
-typedef pud_t make_pud_t(pudval_t);
-typedef pgd_t make_pgd_t(pgdval_t);
-
-typedef pteval_t pte_val_t(pte_t);
-typedef pmdval_t pmd_val_t(pmd_t);
-typedef pudval_t pud_val_t(pud_t);
-typedef pgdval_t pgd_val_t(pgd_t);
-
-
 #if defined(CONFIG_X86_32) && !defined(CONFIG_X86_PAE)
 /* 32-bit pagetable entries */
-#define paravirt_native_make_pte	(make_pte_t *)_paravirt_ident_32
-#define paravirt_native_pte_val		(pte_val_t *)_paravirt_ident_32
-
-#define paravirt_native_make_pmd	(make_pmd_t *)_paravirt_ident_32
-#define paravirt_native_pmd_val		(pmd_val_t *)_paravirt_ident_32
-
-#define paravirt_native_make_pud	(make_pud_t *)_paravirt_ident_32
-#define paravirt_native_pud_val		(pud_val_t *)_paravirt_ident_32
-
-#define paravirt_native_make_pgd	(make_pgd_t *)_paravirt_ident_32
-#define paravirt_native_pgd_val		(pgd_val_t *)_paravirt_ident_32
+#define PTE_IDENT	__PV_IS_CALLEE_SAVE(_paravirt_ident_32)
 #else
 /* 64-bit pagetable entries */
-#define paravirt_native_make_pte	(make_pte_t *)_paravirt_ident_64
-#define paravirt_native_pte_val		(pte_val_t *)_paravirt_ident_64
-
-#define paravirt_native_make_pmd	(make_pmd_t *)_paravirt_ident_64
-#define paravirt_native_pmd_val		(pmd_val_t *)_paravirt_ident_64
-
-#define paravirt_native_make_pud	(make_pud_t *)_paravirt_ident_64
-#define paravirt_native_pud_val		(pud_val_t *)_paravirt_ident_64
-
-#define paravirt_native_make_pgd	(make_pgd_t *)_paravirt_ident_64
-#define paravirt_native_pgd_val		(pgd_val_t *)_paravirt_ident_64
+#define PTE_IDENT	__PV_IS_CALLEE_SAVE(_paravirt_ident_64)
 #endif
 
 struct pv_mmu_ops pv_mmu_ops = {
@@ -481,21 +450,23 @@
 	.pmd_clear = native_pmd_clear,
 #endif
 	.set_pud = native_set_pud,
-	.pmd_val = paravirt_native_pmd_val,
-	.make_pmd = paravirt_native_make_pmd,
+
+	.pmd_val = PTE_IDENT,
+	.make_pmd = PTE_IDENT,
 
 #if PAGETABLE_LEVELS == 4
-	.pud_val = paravirt_native_pud_val,
-	.make_pud = paravirt_native_make_pud,
+	.pud_val = PTE_IDENT,
+	.make_pud = PTE_IDENT,
+
 	.set_pgd = native_set_pgd,
 #endif
 #endif /* PAGETABLE_LEVELS >= 3 */
 
-	.pte_val = paravirt_native_pte_val,
-	.pgd_val = paravirt_native_pgd_val,
+	.pte_val = PTE_IDENT,
+	.pgd_val = PTE_IDENT,
 
-	.make_pte = paravirt_native_make_pte,
-	.make_pgd = paravirt_native_make_pgd,
+	.make_pte = PTE_IDENT,
+	.make_pgd = PTE_IDENT,
 
 	.dup_mmap = paravirt_nop,
 	.exit_mmap = paravirt_nop,
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -492,28 +492,33 @@
 {
 	return pte_mfn_to_pfn(pte.pte);
 }
+PV_CALLEE_SAVE_REGS_THUNK(xen_pte_val);
 
 pgdval_t xen_pgd_val(pgd_t pgd)
 {
 	return pte_mfn_to_pfn(pgd.pgd);
 }
+PV_CALLEE_SAVE_REGS_THUNK(xen_pgd_val);
 
 pte_t xen_make_pte(pteval_t pte)
 {
 	pte = pte_pfn_to_mfn(pte);
 	return native_make_pte(pte);
 }
+PV_CALLEE_SAVE_REGS_THUNK(xen_make_pte);
 
 pgd_t xen_make_pgd(pgdval_t pgd)
 {
 	pgd = pte_pfn_to_mfn(pgd);
 	return native_make_pgd(pgd);
 }
+PV_CALLEE_SAVE_REGS_THUNK(xen_make_pgd);
 
 pmdval_t xen_pmd_val(pmd_t pmd)
 {
 	return pte_mfn_to_pfn(pmd.pmd);
 }
+PV_CALLEE_SAVE_REGS_THUNK(xen_pmd_val);
 
 void xen_set_pud_hyper(pud_t *ptr, pud_t val)
 {
@@ -590,12 +595,14 @@
 	pmd = pte_pfn_to_mfn(pmd);
 	return native_make_pmd(pmd);
 }
+PV_CALLEE_SAVE_REGS_THUNK(xen_make_pmd);
 
 #if PAGETABLE_LEVELS == 4
 pudval_t xen_pud_val(pud_t pud)
 {
 	return pte_mfn_to_pfn(pud.pud);
 }
+PV_CALLEE_SAVE_REGS_THUNK(xen_pud_val);
 
 pud_t xen_make_pud(pudval_t pud)
 {
@@ -603,6 +610,7 @@
 
 	return native_make_pud(pud);
 }
+PV_CALLEE_SAVE_REGS_THUNK(xen_make_pud);
 
 pgd_t *xen_get_user_pgd(pgd_t *pgd)
 {
@@ -1813,11 +1821,11 @@
 	.ptep_modify_prot_start = __ptep_modify_prot_start,
 	.ptep_modify_prot_commit = __ptep_modify_prot_commit,
 
-	.pte_val = xen_pte_val,
-	.pgd_val = xen_pgd_val,
+	.pte_val = PV_CALLEE_SAVE(xen_pte_val),
+	.pgd_val = PV_CALLEE_SAVE(xen_pgd_val),
 
-	.make_pte = xen_make_pte,
-	.make_pgd = xen_make_pgd,
+	.make_pte = PV_CALLEE_SAVE(xen_make_pte),
+	.make_pgd = PV_CALLEE_SAVE(xen_make_pgd),
 
 #ifdef CONFIG_X86_PAE
 	.set_pte_atomic = xen_set_pte_atomic,
@@ -1827,12 +1835,12 @@
 #endif	/* CONFIG_X86_PAE */
 	.set_pud = xen_set_pud_hyper,
 
-	.make_pmd = xen_make_pmd,
-	.pmd_val = xen_pmd_val,
+	.make_pmd = PV_CALLEE_SAVE(xen_make_pmd),
+	.pmd_val = PV_CALLEE_SAVE(xen_pmd_val),
 
 #if PAGETABLE_LEVELS == 4
-	.pud_val = xen_pud_val,
-	.make_pud = xen_make_pud,
+	.pud_val = PV_CALLEE_SAVE(xen_pud_val),
+	.make_pud = PV_CALLEE_SAVE(xen_make_pud),
 	.set_pgd = xen_set_pgd_hyper,
 
 	.alloc_pud = xen_alloc_pte_init,


