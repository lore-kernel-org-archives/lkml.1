Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbZCSN2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbZCSN2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 09:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756333AbZCSN2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 09:28:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:40194 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756547AbZCSN2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:28:17 -0400
Date: Thu, 19 Mar 2009 13:27:37 GMT
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jeremy.fitzhardinge@citrix.com, mtosatti@redhat.com, tglx@linutronix.de,
       akataria@vmware.com, mingo@elte.hu, xen-devel@lists.xensource.com,
       avi@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jeremy.fitzhardinge@citrix.com, mtosatti@redhat.com, tglx@linutronix.de,
       akataria@vmware.com, avi@redhat.com, xen-devel@lists.xensource.com,
       mingo@elte.hu
In-Reply-To: <1237406613-2929-2-git-send-email-jeremy@goop.org>
References: <1237406613-2929-2-git-send-email-jeremy@goop.org>
Subject: [tip:x86/mm] x86: with the last user gone, remove set_pte_present
Message-ID: <tip-71ff49d71bb5cfcd2689b54cb433c0e6990a1d86@git.kernel.org>
Git-Commit-ID: 71ff49d71bb5cfcd2689b54cb433c0e6990a1d86
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 19 Mar 2009 13:27:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  71ff49d71bb5cfcd2689b54cb433c0e6990a1d86
Gitweb:     http://git.kernel.org/tip/71ff49d71bb5cfcd2689b54cb433c0e6990a1d86
Author:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
AuthorDate: Wed, 18 Mar 2009 13:03:33 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 19 Mar 2009 14:04:19 +0100

x86: with the last user gone, remove set_pte_present

Impact: cleanup

set_pte_present() is no longer used, directly or indirectly,
so remove it.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Xen-devel <xen-devel@lists.xensource.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Alok Kataria <akataria@vmware.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
LKML-Reference: <1237406613-2929-2-git-send-email-jeremy@goop.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
index 31fe83b..7727aa8 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -317,8 +317,6 @@ struct pv_mmu_ops {
 #if PAGETABLE_LEVELS >= 3
 #ifdef CONFIG_X86_PAE
 	void (*set_pte_atomic)(pte_t *ptep, pte_t pteval);
-	void (*set_pte_present)(struct mm_struct *mm, unsigned long addr,
-				pte_t *ptep, pte_t pte);
 	void (*pte_clear)(struct mm_struct *mm, unsigned long addr,
 			  pte_t *ptep);
 	void (*pmd_clear)(pmd_t *pmdp);
@@ -1365,13 +1363,6 @@ static inline void set_pte_atomic(pte_t *ptep, pte_t pte)
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
@@ -1388,12 +1379,6 @@ static inline void set_pte_atomic(pte_t *ptep, pte_t pte)
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
index d0812e1..29d96d1 100644
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
index 478bca9..33019dd 100644
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
index 63dd358..8e45f44 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -470,7 +470,6 @@ struct pv_mmu_ops pv_mmu_ops = {
 #if PAGETABLE_LEVELS >= 3
 #ifdef CONFIG_X86_PAE
 	.set_pte_atomic = native_set_pte_atomic,
-	.set_pte_present = native_set_pte_present,
 	.pte_clear = native_pte_clear,
 	.pmd_clear = native_pmd_clear,
 #endif
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 2cc4a90..95deb9f 100644
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
@@ -750,7 +745,6 @@ static inline int __init activate_vmi(void)
 		pv_mmu_ops.set_pmd = vmi_set_pmd;
 #ifdef CONFIG_X86_PAE
 		pv_mmu_ops.set_pte_atomic = vmi_set_pte_atomic;
-		pv_mmu_ops.set_pte_present = vmi_set_pte_present;
 		pv_mmu_ops.set_pud = vmi_set_pud;
 		pv_mmu_ops.pte_clear = vmi_pte_clear;
 		pv_mmu_ops.pmd_clear = vmi_pmd_clear;
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 72f6a76..db3802f 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1870,7 +1870,6 @@ const struct pv_mmu_ops xen_mmu_ops __initdata = {
 
 #ifdef CONFIG_X86_PAE
 	.set_pte_atomic = xen_set_pte_atomic,
-	.set_pte_present = xen_set_pte_at,
 	.pte_clear = xen_pte_clear,
 	.pmd_clear = xen_pmd_clear,
 #endif	/* CONFIG_X86_PAE */
