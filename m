Return-Path: <linux-kernel-owner+w=401wt.eu-S1752581AbZCRUKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbZCRUKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 16:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbZCRUJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 16:09:43 -0400
Received: from adsl-69-107-82-15.dsl.pltn13.pacbell.net ([69.107.82.15]:56299
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751652AbZCRUJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 16:09:42 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Alok Kataria <akataria@vmware.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [PATCH 2/2] x86: with the last user gone, remove set_pte_present
Date: Wed, 18 Mar 2009 13:03:33 -0700
Message-Id: <1237406613-2929-2-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1237406613-2929-1-git-send-email-jeremy@goop.org>
References: <1237406613-2929-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Impact: cleanup

set_pte_present() is no longer used, directly or indirectly,
so remove it.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Alok Kataria <akataria@vmware.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/paravirt.h       |   15 ---------------
 arch/x86/include/asm/pgtable-2level.h |    7 -------
 arch/x86/include/asm/pgtable-3level.h |   17 -----------------
 arch/x86/include/asm/pgtable.h        |    2 --
 arch/x86/kernel/kvm.c                 |    7 -------
 arch/x86/kernel/paravirt.c            |    1 -
 arch/x86/kernel/vmi_32.c              |    6 ------
 arch/x86/xen/mmu.c                    |    1 -
 8 files changed, 0 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 6922d16..1c4e520 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -321,8 +321,6 @@ struct pv_mmu_ops {
 #if PAGETABLE_LEVELS >= 3
 #ifdef CONFIG_X86_PAE
 	void (*set_pte_atomic)(pte_t *ptep, pte_t pteval);
-	void (*set_pte_present)(struct mm_struct *mm, unsigned long addr,
-				pte_t *ptep, pte_t pte);
 	void (*pte_clear)(struct mm_struct *mm, unsigned long addr,
 			  pte_t *ptep);
 	void (*pmd_clear)(pmd_t *pmdp);
@@ -1376,13 +1374,6 @@ static inline void set_pte_atomic(pte_t *ptep, pte_t pte)
 		    pte.pte, pte.pte >> 32);
 }
 
-static inline void set_pte_present(struct mm_struct *mm, unsigned long addr,
-				   pte_t *ptep, pte_t pte)
-{
-	/* 5 arg words */
-	pv_mmu_ops.set_pte_present(mm, addr, ptep, pte);
-}
-
 static inline void pte_clear(struct mm_struct *mm, unsigned long addr,
 			     pte_t *ptep)
 {
@@ -1399,12 +1390,6 @@ static inline void set_pte_atomic(pte_t *ptep, pte_t pte)
 	set_pte(ptep, pte);
 }
 
-static inline void set_pte_present(struct mm_struct *mm, unsigned long addr,
-				   pte_t *ptep, pte_t pte)
-{
-	set_pte(ptep, pte);
-}
-
 static inline void pte_clear(struct mm_struct *mm, unsigned long addr,
 			     pte_t *ptep)
 {
diff --git a/arch/x86/include/asm/pgtable-2level.h b/arch/x86/include/asm/pgtable-2level.h
index c1774ac..2334982 100644
--- a/arch/x86/include/asm/pgtable-2level.h
+++ b/arch/x86/include/asm/pgtable-2level.h
@@ -26,13 +26,6 @@ static inline void native_set_pte_atomic(pte_t *ptep, pte_t pte)
 	native_set_pte(ptep, pte);
 }
 
-static inline void native_set_pte_present(struct mm_struct *mm,
-					  unsigned long addr,
-					  pte_t *ptep, pte_t pte)
-{
-	native_set_pte(ptep, pte);
-}
-
 static inline void native_pmd_clear(pmd_t *pmdp)
 {
 	native_set_pmd(pmdp, __pmd(0));
diff --git a/arch/x86/include/asm/pgtable-3level.h b/arch/x86/include/asm/pgtable-3level.h
index 3f13cdf..177b016 100644
--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -31,23 +31,6 @@ static inline void native_set_pte(pte_t *ptep, pte_t pte)
 	ptep->pte_low = pte.pte_low;
 }
 
-/*
- * Since this is only called on user PTEs, and the page fault handler
- * must handle the already racy situation of simultaneous page faults,
- * we are justified in merely clearing the PTE present bit, followed
- * by a set.  The ordering here is important.
- */
-static inline void native_set_pte_present(struct mm_struct *mm,
-					  unsigned long addr,
-					  pte_t *ptep, pte_t pte)
-{
-	ptep->pte_low = 0;
-	smp_wmb();
-	ptep->pte_high = pte.pte_high;
-	smp_wmb();
-	ptep->pte_low = pte.pte_low;
-}
-
 static inline void native_set_pte_atomic(pte_t *ptep, pte_t pte)
 {
 	set_64bit((unsigned long long *)(ptep), native_pte_val(pte));
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index d7cbfaa..e9ec779 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -31,8 +31,6 @@ extern struct list_head pgd_list;
 #define set_pte(ptep, pte)		native_set_pte(ptep, pte)
 #define set_pte_at(mm, addr, ptep, pte)	native_set_pte_at(mm, addr, ptep, pte)
 
-#define set_pte_present(mm, addr, ptep, pte)				\
-	native_set_pte_present(mm, addr, ptep, pte)
 #define set_pte_atomic(ptep, pte)					\
 	native_set_pte_atomic(ptep, pte)
 
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 5d7f6e7..6551ded 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -138,12 +138,6 @@ static void kvm_set_pte_atomic(pte_t *ptep, pte_t pte)
 	kvm_mmu_write(ptep, pte_val(pte));
 }
 
-static void kvm_set_pte_present(struct mm_struct *mm, unsigned long addr,
-				pte_t *ptep, pte_t pte)
-{
-	kvm_mmu_write(ptep, pte_val(pte));
-}
-
 static void kvm_pte_clear(struct mm_struct *mm,
 			  unsigned long addr, pte_t *ptep)
 {
@@ -220,7 +214,6 @@ static void paravirt_ops_setup(void)
 #if PAGETABLE_LEVELS >= 3
 #ifdef CONFIG_X86_PAE
 		pv_mmu_ops.set_pte_atomic = kvm_set_pte_atomic;
-		pv_mmu_ops.set_pte_present = kvm_set_pte_present;
 		pv_mmu_ops.pte_clear = kvm_pte_clear;
 		pv_mmu_ops.pmd_clear = kvm_pmd_clear;
 #endif
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 394f4d8..8615ffe 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -467,7 +467,6 @@ struct pv_mmu_ops pv_mmu_ops = {
 #if PAGETABLE_LEVELS >= 3
 #ifdef CONFIG_X86_PAE
 	.set_pte_atomic = native_set_pte_atomic,
-	.set_pte_present = native_set_pte_present,
 	.pte_clear = native_pte_clear,
 	.pmd_clear = native_pmd_clear,
 #endif
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 55a5d69..b263423 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -395,11 +395,6 @@ static void vmi_set_pte_atomic(pte_t *ptep, pte_t pteval)
 	vmi_ops.update_pte(ptep, VMI_PAGE_PT);
 }
 
-static void vmi_set_pte_present(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte)
-{
-	vmi_ops.set_pte(pte, ptep, vmi_flags_addr_defer(mm, addr, VMI_PAGE_PT, 1));
-}
-
 static void vmi_set_pud(pud_t *pudp, pud_t pudval)
 {
 	/* Um, eww */
@@ -756,7 +751,6 @@ static inline int __init activate_vmi(void)
 		pv_mmu_ops.set_pmd = vmi_set_pmd;
 #ifdef CONFIG_X86_PAE
 		pv_mmu_ops.set_pte_atomic = vmi_set_pte_atomic;
-		pv_mmu_ops.set_pte_present = vmi_set_pte_present;
 		pv_mmu_ops.set_pud = vmi_set_pud;
 		pv_mmu_ops.pte_clear = vmi_pte_clear;
 		pv_mmu_ops.pmd_clear = vmi_pmd_clear;
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 5ea6ab1..52663f6 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2101,7 +2101,6 @@ const struct pv_mmu_ops xen_mmu_ops __initdata = {
 
 #ifdef CONFIG_X86_PAE
 	.set_pte_atomic = xen_set_pte_atomic,
-	.set_pte_present = xen_set_pte_at,
 	.pte_clear = xen_pte_clear,
 	.pmd_clear = xen_pmd_clear,
 #endif	/* CONFIG_X86_PAE */
-- 
1.6.0.6

