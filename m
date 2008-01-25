Return-Path: <linux-kernel-owner+w=401wt.eu-S1761073AbYAYVzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761073AbYAYVzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 16:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760914AbYAYVw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:52:29 -0500
Received: from 42.sub-75-208-60.myvzw.com ([75.208.60.42]:37924 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760221AbYAYVw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:52:28 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 08 of 11] xen: deal with pmd being allocated/freed
X-Mercurial-Node: 17d8ead289dd347181484cd1feb054b5e7627131
Message-Id: <17d8ead289dd34718148.1201296197@localhost>
In-Reply-To: <patchbomb.1201296189@localhost>
Date: Fri, 25 Jan 2008 13:23:17 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deal properly with pmd-level pages being allocated and freed
dynamically.  We can handle them more or less the same as pte pages.

Also, deal with early_ioremap pagetable manipulations.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/xen/enlighten.c |   30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -658,6 +658,13 @@ static __init void xen_alloc_pt_init(str
 	make_lowmem_page_readonly(__va(PFN_PHYS(pfn)));
 }
 
+/* Early release_pt assumes that all pts are pinned, since there's
+   only init_mm and anything attached to that is pinned. */
+static void xen_release_pt_init(u32 pfn)
+{
+	make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
+}
+
 static void pin_pagetable_pfn(unsigned level, unsigned long pfn)
 {
 	struct mmuext_op op;
@@ -669,7 +676,7 @@ static void pin_pagetable_pfn(unsigned l
 
 /* This needs to make sure the new pte page is pinned iff its being
    attached to a pinned pagetable. */
-static void xen_alloc_pt(struct mm_struct *mm, u32 pfn)
+static void xen_alloc_ptpage(struct mm_struct *mm, u32 pfn, unsigned level)
 {
 	struct page *page = pfn_to_page(pfn);
 
@@ -678,12 +685,22 @@ static void xen_alloc_pt(struct mm_struc
 
 		if (!PageHighMem(page)) {
 			make_lowmem_page_readonly(__va(PFN_PHYS(pfn)));
-			pin_pagetable_pfn(MMUEXT_PIN_L1_TABLE, pfn);
+			pin_pagetable_pfn(level, pfn);
 		} else
 			/* make sure there are no stray mappings of
 			   this page */
 			kmap_flush_unused();
 	}
+}
+
+static void xen_alloc_pt(struct mm_struct *mm, u32 pfn)
+{
+	xen_alloc_ptpage(mm, pfn, MMUEXT_PIN_L1_TABLE);
+}
+
+static void xen_alloc_pd(struct mm_struct *mm, u32 pfn)
+{
+	xen_alloc_ptpage(mm, pfn, MMUEXT_PIN_L2_TABLE);
 }
 
 /* This should never happen until we're OK to use struct page */
@@ -788,6 +805,9 @@ static __init void xen_pagetable_setup_d
 	/* This will work as long as patching hasn't happened yet
 	   (which it hasn't) */
 	pv_mmu_ops.alloc_pt = xen_alloc_pt;
+	pv_mmu_ops.alloc_pd = xen_alloc_pd;
+	pv_mmu_ops.release_pt = xen_release_pt;
+	pv_mmu_ops.release_pd = xen_release_pt;
 	pv_mmu_ops.set_pte = xen_set_pte;
 
 	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
@@ -1011,10 +1031,10 @@ static const struct pv_mmu_ops xen_mmu_o
 	.pte_update_defer = paravirt_nop,
 
 	.alloc_pt = xen_alloc_pt_init,
-	.release_pt = xen_release_pt,
-	.alloc_pd = paravirt_nop,
+	.release_pt = xen_release_pt_init,
+	.alloc_pd = xen_alloc_pt_init,
 	.alloc_pd_clone = paravirt_nop,
-	.release_pd = paravirt_nop,
+	.release_pd = xen_release_pt_init,
 
 #ifdef CONFIG_HIGHPTE
 	.kmap_atomic_pte = xen_kmap_atomic_pte,


