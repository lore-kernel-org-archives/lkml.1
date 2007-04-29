Return-Path: <linux-kernel-owner+w=401wt.eu-S1030962AbXD2RgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030962AbXD2RgY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754414AbXD2Rbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:31:33 -0400
Received: from gw.goop.org ([64.81.55.164]:58997 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754355AbXD2Rab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:30:31 -0400
Message-Id: <20070429172912.710019000@goop.org>
References: <20070429172835.284784000@goop.org>
User-Agent: quilt/0.46-1
Date: Sun, 29 Apr 2007 10:28:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       ebiederm@xmission.com ("Eric W. Biederman")
Subject: [patch 11/32] xen: ignore RW mapping of RO pages in pagetable_init
Content-Disposition: inline; filename=xen-pagetable_init-ignore-ro-mappings.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When setting up the initial pagetable, which includes mappings of all
low physical memory, ignore a mapping which tries to set the RW bit on
an RO pte.  An RO pte indicates a page which is part of the current
pagetable, and so it cannot be allowed to become RW.

Once xen_pagetable_setup_done is called, set_pte reverts to its normal
behaviour.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: ebiederm@xmission.com (Eric W. Biederman)

---
 arch/i386/xen/enlighten.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

===================================================================
--- a/arch/i386/xen/enlighten.c
+++ b/arch/i386/xen/enlighten.c
@@ -635,7 +635,7 @@ static void xen_write_cr3(unsigned long 
 
 /* Early in boot, while setting up the initial pagetable, assume
    everything is pinned. */
-static void xen_alloc_pt_init(struct mm_struct *mm, u32 pfn)
+static __init void xen_alloc_pt_init(struct mm_struct *mm, u32 pfn)
 {
 	BUG_ON(mem_map);	/* should only be used early */
 	make_lowmem_page_readonly(__va(PFN_PHYS(pfn)));
@@ -687,9 +687,31 @@ static void *xen_kmap_atomic_pte(struct 
 }
 #endif
 
+static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
+{
+	/* If there's an existing pte, then don't allow _PAGE_RW to be set */
+	if (pte_val_ma(*ptep) & _PAGE_PRESENT)
+		pte = __pte_ma(((pte_val_ma(*ptep) & _PAGE_RW) | ~_PAGE_RW) &
+			       pte_val_ma(pte));
+
+	return pte;
+}
+
+/* Init-time set_pte while constructing initial pagetables, which
+   doesn't allow RO pagetable pages to be remapped RW */
+static __init void xen_set_pte_init(pte_t *ptep, pte_t pte)
+{
+	pte = mask_rw_pte(ptep, pte);
+
+	xen_set_pte(ptep, pte);
+}
+
 static __init void xen_pagetable_setup_start(pgd_t *base)
 {
 	pgd_t *xen_pgd = (pgd_t *)xen_start_info->pt_base;
+
+	/* special set_pte for pagetable initialization */
+	paravirt_ops.set_pte = xen_set_pte_init;
 
 	init_mm.pgd = base;
 	/*
@@ -737,6 +759,7 @@ static __init void xen_pagetable_setup_d
 	/* This will work as long as patching hasn't happened yet
 	   (which it hasn't) */
 	paravirt_ops.alloc_pt = xen_alloc_pt;
+	paravirt_ops.set_pte = xen_set_pte;
 
 	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
 		/*
@@ -919,7 +942,7 @@ static const struct paravirt_ops xen_par
 	.dup_mmap = xen_dup_mmap,
 	.exit_mmap = xen_exit_mmap,
 
-	.set_pte = xen_set_pte,
+	.set_pte = NULL,	/* see xen_pagetable_setup_* */
 	.set_pte_at = xen_set_pte_at,
 	.set_pmd = xen_set_pmd,
 

-- 

