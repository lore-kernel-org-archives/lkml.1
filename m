Return-Path: <linux-kernel-owner+w=401wt.eu-S1759401AbYGHXUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401AbYGHXUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757483AbYGHXOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:46 -0400
Received: from gw.goop.org ([64.81.55.164]:51205 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756046AbYGHXOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:42 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 16 of 55] xen64: add extra pv_mmu_ops
X-Mercurial-Node: 76d0856d664470b81640e0fa0cdb1465ea981d2f
Message-Id: <76d0856d664470b81640.1215554798@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need extra pv_mmu_ops for 64-bit, to deal with the extra level of
pagetable.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c   |   33 +++++++++++++++++++++++++++-
 arch/x86/xen/mmu.c         |   51 +++++++++++++++++++++++++++++++++++++++++++-
 arch/x86/xen/mmu.h         |   15 +++++++++++-
 include/asm-x86/xen/page.h |    4 +++
 4 files changed, 99 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -803,6 +803,18 @@
 	xen_release_ptpage(pfn, PT_PMD);
 }
 
+#if PAGETABLE_LEVELS == 4
+static void xen_alloc_pud(struct mm_struct *mm, u32 pfn)
+{
+	xen_alloc_ptpage(mm, pfn, PT_PUD);
+}
+
+static void xen_release_pud(u32 pfn)
+{
+	xen_release_ptpage(pfn, PT_PUD);
+}
+#endif
+
 #ifdef CONFIG_HIGHPTE
 static void *xen_kmap_atomic_pte(struct page *page, enum km_type type)
 {
@@ -922,6 +934,11 @@
 	pv_mmu_ops.alloc_pmd = xen_alloc_pmd;
 	pv_mmu_ops.release_pte = xen_release_pte;
 	pv_mmu_ops.release_pmd = xen_release_pmd;
+#if PAGETABLE_LEVELS == 4
+	pv_mmu_ops.alloc_pud = xen_alloc_pud;
+	pv_mmu_ops.release_pud = xen_release_pud;
+#endif
+
 	pv_mmu_ops.set_pte = xen_set_pte;
 
 	xen_setup_shared_info();
@@ -937,6 +954,9 @@
 {
 	pv_mmu_ops.set_pmd = xen_set_pmd;
 	pv_mmu_ops.set_pud = xen_set_pud;
+#if PAGETABLE_LEVELS == 4
+	pv_mmu_ops.set_pgd = xen_set_pgd;
+#endif
 
 	xen_mark_init_mm_pinned();
 }
@@ -1185,14 +1205,25 @@
 	.make_pte = xen_make_pte,
 	.make_pgd = xen_make_pgd,
 
+#ifdef CONFIG_X86_PAE
 	.set_pte_atomic = xen_set_pte_atomic,
 	.set_pte_present = xen_set_pte_at,
-	.set_pud = xen_set_pud_hyper,
 	.pte_clear = xen_pte_clear,
 	.pmd_clear = xen_pmd_clear,
+#endif	/* CONFIG_X86_PAE */
+	.set_pud = xen_set_pud_hyper,
 
 	.make_pmd = xen_make_pmd,
 	.pmd_val = xen_pmd_val,
+
+#if PAGETABLE_LEVELS == 4
+	.pud_val = xen_pud_val,
+	.make_pud = xen_make_pud,
+	.set_pgd = xen_set_pgd_hyper,
+
+	.alloc_pud = xen_alloc_pte_init,
+	.release_pud = xen_release_pte_init,
+#endif	/* PAGETABLE_LEVELS == 4 */
 
 	.activate_mm = xen_activate_mm,
 	.dup_mmap = xen_dup_mmap,
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -438,14 +438,19 @@
 
 void xen_set_pte(pte_t *ptep, pte_t pte)
 {
+#ifdef CONFIG_X86_PAE
 	ptep->pte_high = pte.pte_high;
 	smp_wmb();
 	ptep->pte_low = pte.pte_low;
+#else
+	*ptep = pte;
+#endif
 }
 
+#ifdef CONFIG_X86_PAE
 void xen_set_pte_atomic(pte_t *ptep, pte_t pte)
 {
-	set_64bit((u64 *)ptep, pte_val_ma(pte));
+	set_64bit((u64 *)ptep, native_pte_val(pte));
 }
 
 void xen_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
@@ -459,12 +464,56 @@
 {
 	set_pmd(pmdp, __pmd(0));
 }
+#endif	/* CONFIG_X86_PAE */
 
 pmd_t xen_make_pmd(pmdval_t pmd)
 {
 	pmd = pte_pfn_to_mfn(pmd);
 	return native_make_pmd(pmd);
 }
+
+#if PAGETABLE_LEVELS == 4
+pudval_t xen_pud_val(pud_t pud)
+{
+	return pte_mfn_to_pfn(pud.pud);
+}
+
+pud_t xen_make_pud(pudval_t pud)
+{
+	pud = pte_pfn_to_mfn(pud);
+
+	return native_make_pud(pud);
+}
+
+void xen_set_pgd_hyper(pgd_t *ptr, pgd_t val)
+{
+	struct mmu_update u;
+
+	preempt_disable();
+
+	xen_mc_batch();
+
+	u.ptr = virt_to_machine(ptr).maddr;
+	u.val = pgd_val_ma(val);
+	extend_mmu_update(&u);
+
+	xen_mc_issue(PARAVIRT_LAZY_MMU);
+
+	preempt_enable();
+}
+
+void xen_set_pgd(pgd_t *ptr, pgd_t val)
+{
+	/* If page is not pinned, we can just update the entry
+	   directly */
+	if (!page_pinned(ptr)) {
+		*ptr = val;
+		return;
+	}
+
+	xen_set_pgd_hyper(ptr, val);
+}
+#endif	/* PAGETABLE_LEVELS == 4 */
 
 /*
   (Yet another) pagetable walker.  This one is intended for pinning a
diff --git a/arch/x86/xen/mmu.h b/arch/x86/xen/mmu.h
--- a/arch/x86/xen/mmu.h
+++ b/arch/x86/xen/mmu.h
@@ -32,13 +32,24 @@
 void xen_set_pte(pte_t *ptep, pte_t pteval);
 void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
 		    pte_t *ptep, pte_t pteval);
+
+#ifdef CONFIG_X86_PAE
 void xen_set_pte_atomic(pte_t *ptep, pte_t pte);
+void xen_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
+void xen_pmd_clear(pmd_t *pmdp);
+#endif	/* CONFIG_X86_PAE */
+
 void xen_set_pmd(pmd_t *pmdp, pmd_t pmdval);
 void xen_set_pud(pud_t *ptr, pud_t val);
 void xen_set_pmd_hyper(pmd_t *pmdp, pmd_t pmdval);
 void xen_set_pud_hyper(pud_t *ptr, pud_t val);
-void xen_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
-void xen_pmd_clear(pmd_t *pmdp);
+
+#if PAGETABLE_LEVELS == 4
+pudval_t xen_pud_val(pud_t pud);
+pud_t xen_make_pud(pudval_t pudval);
+void xen_set_pgd(pgd_t *pgdp, pgd_t pgd);
+void xen_set_pgd_hyper(pgd_t *pgdp, pgd_t pgd);
+#endif
 
 pte_t xen_ptep_modify_prot_start(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
 void  xen_ptep_modify_prot_commit(struct mm_struct *mm, unsigned long addr,
diff --git a/include/asm-x86/xen/page.h b/include/asm-x86/xen/page.h
--- a/include/asm-x86/xen/page.h
+++ b/include/asm-x86/xen/page.h
@@ -148,7 +148,11 @@
 }
 
 #define pmd_val_ma(v) ((v).pmd)
+#ifdef __PAGETABLE_PUD_FOLDED
 #define pud_val_ma(v) ((v).pgd.pgd)
+#else
+#define pud_val_ma(v) ((v).pud)
+#endif
 #define __pmd_ma(x)	((pmd_t) { (x) } )
 
 #define pgd_val_ma(x)	((x).pgd)


