Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbYFPLg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbYFPLg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 07:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbYFPLgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 07:36:51 -0400
Received: from gw.goop.org ([64.81.55.164]:41065 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbYFPLgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 07:36:50 -0400
Message-ID: <48565028.6090907@goop.org>
Date: Mon, 16 Jun 2008 04:36:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH BUGFIX] xen: don't drop NX bit
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When converting the pfn/mfn in a pagetable entry, make sure we mask
out the protection flags properly.  Formerly, this code was losing the
NX bit, and not dealing with extra Xen-defined software flags in ptes.

Because NX is now enforced properly, we must put the hypercall page
into the .text segment so that it is executable.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Stable Kernel <stable@kernel.org>
---
 arch/x86/xen/mmu.c      |   58 +++++++++++++++++++++++++----------------------
 arch/x86/xen/xen-head.S |    2 -
 2 files changed, 32 insertions(+), 28 deletions(-)

===================================================================
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -323,48 +323,54 @@
 		preempt_enable();
 }
 
+/* Assume pteval_t is equivalent to all the other *val_t types. */
+static pteval_t pte_mfn_to_pfn(pteval_t val)
+{
+	if (val & _PAGE_PRESENT) {
+		unsigned long mfn = (val & PTE_MASK) >> PAGE_SHIFT;
+		pteval_t flags = val & ~PTE_MASK;
+		val = (mfn_to_pfn(mfn) << PAGE_SHIFT) | flags;
+	}
+
+	return val;
+}
+
+static pteval_t pte_pfn_to_mfn(pteval_t val)
+{
+	if (val & _PAGE_PRESENT) {
+		unsigned long pfn = (val & PTE_MASK) >> PAGE_SHIFT;
+		pteval_t flags = val & ~PTE_MASK;
+		val = (pfn_to_mfn(pfn) << PAGE_SHIFT) | flags;
+	}
+
+	return val;
+}
+
 pteval_t xen_pte_val(pte_t pte)
 {
-	pteval_t ret = pte.pte;
-
-	if (ret & _PAGE_PRESENT)
-		ret = machine_to_phys(XMADDR(ret)).paddr | _PAGE_PRESENT;
-
-	return ret;
+	return pte_mfn_to_pfn(pte.pte);
 }
 
 pgdval_t xen_pgd_val(pgd_t pgd)
 {
-	pgdval_t ret = pgd.pgd;
-	if (ret & _PAGE_PRESENT)
-		ret = machine_to_phys(XMADDR(ret)).paddr | _PAGE_PRESENT;
-	return ret;
+	return pte_mfn_to_pfn(pgd.pgd);
 }
 
 pte_t xen_make_pte(pteval_t pte)
 {
-	if (pte & _PAGE_PRESENT) {
-		pte = phys_to_machine(XPADDR(pte)).maddr;
-		pte &= ~(_PAGE_PCD | _PAGE_PWT);
-	}
-
-	return (pte_t){ .pte = pte };
+	pte = pte_pfn_to_mfn(pte);
+	return native_make_pte(pte);
 }
 
 pgd_t xen_make_pgd(pgdval_t pgd)
 {
-	if (pgd & _PAGE_PRESENT)
-		pgd = phys_to_machine(XPADDR(pgd)).maddr;
-
-	return (pgd_t){ pgd };
+	pgd = pte_pfn_to_mfn(pgd);
+	return native_make_pgd(pgd);
 }
 
 pmdval_t xen_pmd_val(pmd_t pmd)
 {
-	pmdval_t ret = native_pmd_val(pmd);
-	if (ret & _PAGE_PRESENT)
-		ret = machine_to_phys(XMADDR(ret)).paddr | _PAGE_PRESENT;
-	return ret;
+	return pte_mfn_to_pfn(pmd.pmd);
 }
 
 void xen_set_pud_hyper(pud_t *ptr, pud_t val)
@@ -423,9 +429,7 @@
 
 pmd_t xen_make_pmd(pmdval_t pmd)
 {
-	if (pmd & _PAGE_PRESENT)
-		pmd = phys_to_machine(XPADDR(pmd)).maddr;
-
+	pmd = pte_pfn_to_mfn(pmd);
 	return native_make_pmd(pmd);
 }
 
===================================================================
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -18,7 +18,7 @@
 
 	__FINIT
 
-.pushsection .bss.page_aligned
+.pushsection .text
 	.align PAGE_SIZE_asm
 ENTRY(hypercall_page)
 	.skip 0x1000


