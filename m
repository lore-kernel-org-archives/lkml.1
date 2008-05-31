Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbYEaAZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbYEaAZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 20:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbYEaAZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 20:25:07 -0400
Received: from gw.goop.org ([64.81.55.164]:34868 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbYEaAZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 20:25:05 -0400
Message-ID: <48409ABB.20301@goop.org>
Date: Sat, 31 May 2008 01:24:27 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: x86@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [PATCH] xen: avoid hypercalls when updating unpinned pud/pmd
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When operating on an unpinned pagetable (ie, one under construction or
destruction), it isn't necessary to use a hypercall to update a
pud/pmd entry.  Jan Beulich observed that a similar optimisation
avoided many thousands of hypercalls while doing a kernel build.

One tricky part is that early in the kernel boot there's no page
structure, so we can't check to see if the page is pinned.  In that
case, we just always use the hypercall.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Jan Beulich <jbeulich@novell.com>
---
 arch/x86/xen/enlighten.c |   14 +++++++++++---
 arch/x86/xen/mmu.c       |   39 +++++++++++++++++++++++++++++++++++----
 arch/x86/xen/mmu.h       |    8 ++++----
 3 files changed, 50 insertions(+), 11 deletions(-)

===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -903,6 +903,14 @@
 	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(base)));
 }
 
+static __init void xen_post_allocator_init(void)
+{
+	pv_mmu_ops.set_pmd = xen_set_pmd;
+	pv_mmu_ops.set_pud = xen_set_pud;
+
+	xen_mark_init_mm_pinned();
+}
+
 /* This is called once we have the cpu_possible_map */
 void xen_setup_vcpu_info_placement(void)
 {
@@ -990,7 +998,7 @@
 	.banner = xen_banner,
 	.memory_setup = xen_memory_setup,
 	.arch_setup = xen_arch_setup,
-	.post_allocator_init = xen_mark_init_mm_pinned,
+	.post_allocator_init = xen_post_allocator_init,
 };
 
 static const struct pv_time_ops xen_time_ops __initdata = {
@@ -1103,7 +1111,7 @@
 
 	.set_pte = NULL,	/* see xen_pagetable_setup_* */
 	.set_pte_at = xen_set_pte_at,
-	.set_pmd = xen_set_pmd,
+	.set_pmd = xen_set_pmd_hyper,
 
 	.ptep_modify_prot_start = __ptep_modify_prot_start,
 	.ptep_modify_prot_commit = __ptep_modify_prot_commit,
@@ -1117,7 +1125,7 @@
 
 	.set_pte_atomic = xen_set_pte_atomic,
 	.set_pte_present = xen_set_pte_at,
-	.set_pud = xen_set_pud,
+	.set_pud = xen_set_pud_hyper,
 	.pte_clear = xen_pte_clear,
 	.pmd_clear = xen_pmd_clear,
 
===================================================================
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -236,7 +236,14 @@
 	*u = *update;
 }
 
-void xen_set_pmd(pmd_t *ptr, pmd_t val)
+static bool page_pinned(void *ptr)
+{
+	struct page *page = virt_to_page(ptr);
+
+	return PagePinned(page);
+}
+
+void xen_set_pmd_hyper(pmd_t *ptr, pmd_t val)
 {
 	struct mmu_update u;
 
@@ -251,6 +258,18 @@
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
 
 	preempt_enable();
+}
+
+void xen_set_pmd(pmd_t *ptr, pmd_t val)
+{
+	/* If page is not pinned, we can just update the entry
+	   directly */
+	if (!page_pinned(ptr)) {
+		*ptr = val;
+		return;
+	}
+
+	xen_set_pmd_hyper(ptr, val);
 }
 
 /*
@@ -380,7 +399,7 @@
 	return ret;
 }
 
-void xen_set_pud(pud_t *ptr, pud_t val)
+void xen_set_pud_hyper(pud_t *ptr, pud_t val)
 {
 	struct mmu_update u;
 
@@ -395,6 +414,18 @@
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
 
 	preempt_enable();
+}
+
+void xen_set_pud(pud_t *ptr, pud_t val)
+{
+	/* If page is not pinned, we can just update the entry
+	   directly */
+	if (!page_pinned(ptr)) {
+		*ptr = val;
+		return;
+	}
+
+	xen_set_pud_hyper(ptr, val);
 }
 
 void xen_set_pte(pte_t *ptep, pte_t pte)
@@ -418,7 +449,7 @@
 
 void xen_pmd_clear(pmd_t *pmdp)
 {
-	xen_set_pmd(pmdp, __pmd(0));
+	set_pmd(pmdp, __pmd(0));
 }
 
 pmd_t xen_make_pmd(pmdval_t pmd)
@@ -789,7 +820,7 @@
 	spin_lock(&mm->page_table_lock);
 
 	/* pgd may not be pinned in the error exit path of execve */
-	if (PagePinned(virt_to_page(mm->pgd)))
+	if (page_pinned(mm->pgd))
 		xen_pgd_unpin(mm->pgd);
 
 	spin_unlock(&mm->page_table_lock);
===================================================================
--- a/arch/x86/xen/mmu.h
+++ b/arch/x86/xen/mmu.h
@@ -25,10 +25,6 @@
 
 void set_pte_mfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags);
 
-void xen_set_pte(pte_t *ptep, pte_t pteval);
-void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
-		    pte_t *ptep, pte_t pteval);
-void xen_set_pmd(pmd_t *pmdp, pmd_t pmdval);
 
 void xen_activate_mm(struct mm_struct *prev, struct mm_struct *next);
 void xen_dup_mmap(struct mm_struct *oldmm, struct mm_struct *mm);
@@ -45,10 +41,14 @@
 pmd_t xen_make_pmd(pmdval_t);
 pgd_t xen_make_pgd(pgdval_t);
 
+void xen_set_pte(pte_t *ptep, pte_t pteval);
 void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
 		    pte_t *ptep, pte_t pteval);
 void xen_set_pte_atomic(pte_t *ptep, pte_t pte);
+void xen_set_pmd(pmd_t *pmdp, pmd_t pmdval);
 void xen_set_pud(pud_t *ptr, pud_t val);
+void xen_set_pmd_hyper(pmd_t *pmdp, pmd_t pmdval);
+void xen_set_pud_hyper(pud_t *ptr, pud_t val);
 void xen_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
 void xen_pmd_clear(pmd_t *pmdp);
 


