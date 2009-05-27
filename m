Return-Path: <linux-kernel-owner+w=401wt.eu-S1761321AbZE0HTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761321AbZE0HTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760033AbZE0HRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:17:14 -0400
Received: from claw.goop.org ([74.207.240.146]:41443 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759757AbZE0HRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:17:12 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 07/16] xen/dom0: use _PAGE_IOMAP in ioremap to do machine mappings
Date: Wed, 27 May 2009 00:15:29 -0700
Message-Id: <1243408538-21100-8-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1243408538-21100-1-git-send-email-jeremy@goop.org>
References: <1243408538-21100-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a Xen domain, ioremap operates on machine addresses, not
pseudo-physical addresses.  We use _PAGE_IOMAP to determine whether a
mapping is intended for machine addresses.

[ Impact: allow Xen domain to map real hardware ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/xen/page.h |    8 +---
 arch/x86/xen/enlighten.c        |    4 ++-
 arch/x86/xen/mmu.c              |   69 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 72 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 018a0a4..bf5f7d3 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -112,13 +112,9 @@ static inline xpaddr_t machine_to_phys(xmaddr_t machine)
  */
 static inline unsigned long mfn_to_local_pfn(unsigned long mfn)
 {
-	extern unsigned long max_mapnr;
 	unsigned long pfn = mfn_to_pfn(mfn);
-	if ((pfn < max_mapnr)
-	    && !xen_feature(XENFEAT_auto_translated_physmap)
-	    && (get_phys_to_machine(pfn) != mfn))
-		return max_mapnr; /* force !pfn_valid() */
-	/* XXX fixme; not true with sparsemem */
+	if (get_phys_to_machine(pfn) != mfn)
+		return -1; /* force !pfn_valid() */
 	return pfn;
 }
 
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 89f47da..f15a555 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1029,7 +1029,9 @@ asmlinkage void __init xen_start_kernel(void)
 
 	/* Prevent unwanted bits from being set in PTEs. */
 	__supported_pte_mask &= ~_PAGE_GLOBAL;
-	if (!xen_initial_domain())
+	if (xen_initial_domain())
+		__supported_pte_mask |= _PAGE_IOMAP;
+	else
 		__supported_pte_mask &= ~(_PAGE_PWT | _PAGE_PCD);
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index dc840ed..48806c5 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -375,6 +375,28 @@ static bool xen_page_pinned(void *ptr)
 	return PagePinned(page);
 }
 
+static bool xen_iomap_pte(pte_t pte)
+{
+	return xen_initial_domain() && (pte_flags(pte) & _PAGE_IOMAP);
+}
+
+static void xen_set_iomap_pte(pte_t *ptep, pte_t pteval)
+{
+	struct multicall_space mcs;
+	struct mmu_update *u;
+
+	mcs = xen_mc_entry(sizeof(*u));
+	u = mcs.args;
+
+	/* ptep might be kmapped when using 32-bit HIGHPTE */
+	u->ptr = arbitrary_virt_to_machine(ptep).maddr;
+	u->val = pte_val_ma(pteval);
+
+	MULTI_mmu_update(mcs.mc, mcs.args, 1, NULL, DOMID_IO);
+
+	xen_mc_issue(PARAVIRT_LAZY_MMU);
+}
+
 static void xen_extend_mmu_update(const struct mmu_update *update)
 {
 	struct multicall_space mcs;
@@ -451,6 +473,11 @@ void set_pte_mfn(unsigned long vaddr, unsigned long mfn, pgprot_t flags)
 void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
 		    pte_t *ptep, pte_t pteval)
 {
+	if (xen_iomap_pte(pteval)) {
+		xen_set_iomap_pte(ptep, pteval);
+		goto out;
+	}
+
 	ADD_STATS(set_pte_at, 1);
 //	ADD_STATS(set_pte_at_pinned, xen_page_pinned(ptep));
 	ADD_STATS(set_pte_at_current, mm == current->mm);
@@ -521,8 +548,25 @@ static pteval_t pte_pfn_to_mfn(pteval_t val)
 	return val;
 }
 
+static pteval_t iomap_pte(pteval_t val)
+{
+	if (val & _PAGE_PRESENT) {
+		unsigned long pfn = (val & PTE_PFN_MASK) >> PAGE_SHIFT;
+		pteval_t flags = val & PTE_FLAGS_MASK;
+
+		/* We assume the pte frame number is a MFN, so
+		   just use it as-is. */
+		val = ((pteval_t)pfn << PAGE_SHIFT) | flags;
+	}
+
+	return val;
+}
+
 pteval_t xen_pte_val(pte_t pte)
 {
+	if (xen_initial_domain() && (pte.pte & _PAGE_IOMAP))
+		return pte.pte;
+
 	return pte_mfn_to_pfn(pte.pte);
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_pte_val);
@@ -535,7 +579,11 @@ PV_CALLEE_SAVE_REGS_THUNK(xen_pgd_val);
 
 pte_t xen_make_pte(pteval_t pte)
 {
-	pte = pte_pfn_to_mfn(pte);
+	if (unlikely(xen_initial_domain() && (pte & _PAGE_IOMAP)))
+		pte = iomap_pte(pte);
+	else
+		pte = pte_pfn_to_mfn(pte);
+
 	return native_make_pte(pte);
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_make_pte);
@@ -591,6 +639,11 @@ void xen_set_pud(pud_t *ptr, pud_t val)
 
 void xen_set_pte(pte_t *ptep, pte_t pte)
 {
+	if (xen_iomap_pte(pte)) {
+		xen_set_iomap_pte(ptep, pte);
+		return;
+	}
+
 	ADD_STATS(pte_update, 1);
 //	ADD_STATS(pte_update_pinned, xen_page_pinned(ptep));
 	ADD_STATS(pte_update_batched, paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU);
@@ -607,6 +660,11 @@ void xen_set_pte(pte_t *ptep, pte_t pte)
 #ifdef CONFIG_X86_PAE
 void xen_set_pte_atomic(pte_t *ptep, pte_t pte)
 {
+	if (xen_iomap_pte(pte)) {
+		xen_set_iomap_pte(ptep, pte);
+		return;
+	}
+
 	set_64bit((u64 *)ptep, native_pte_val(pte));
 }
 
@@ -1824,9 +1882,16 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 		pte = pfn_pte(phys, prot);
 		break;
 
-	default:
+	case FIX_PARAVIRT_BOOTMAP:
+		/* This is an MFN, but it isn't an IO mapping from the
+		   IO domain */
 		pte = mfn_pte(phys, prot);
 		break;
+
+	default:
+		/* By default, set_fixmap is used for hardware mappings */
+		pte = mfn_pte(phys, __pgprot(pgprot_val(prot) | _PAGE_IOMAP));
+		break;
 	}
 
 	__native_set_fixmap(idx, pte);
-- 
1.6.0.6

