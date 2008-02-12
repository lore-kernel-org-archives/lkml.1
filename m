Return-Path: <linux-kernel-owner+w=401wt.eu-S1761856AbYBLMxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761856AbYBLMxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 07:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbYBLMxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 07:53:31 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:23602 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbYBLMxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 07:53:30 -0500
From: Andi Kleen <ak@suse.de>
Message-Id: <20080212153.888987414@suse.de>
To: ying.huang@intel.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [1/2] CPA: Fix set_memory_x for ioremap v2
Date: Tue, 12 Feb 2008 13:53:24 +0100 (CET)
X-OriginalArrivalTime: 12 Feb 2008 12:47:03.0396 (UTC) FILETIME=[5DE52A40:01C86D75]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


EFI currently calls set_memory_x() on addresses not in the direct mapping.

This is problematic for several reasons: 

- The cpa code internally calls __pa on it which does not work for remapped
addresses and will give some random result. In the EFI case EFI passes
in a fixmap address which when run though __pa() gives a valid looking but
wrong memory address.
- cpa will try to change all potential aliases (like the kernel mapping
on x86-64), but that is not needed for NX because the caller does only needs 
its specific virtual address executable. There is no requirement in the x86 
architecture for nx bits to be coherent between mapping aliases. Also with the
previous problem of __pa returning a wrong address it would likely try to 
change some random other page if you're unlucky and the random result would
match the kernel text range.

There would be several possible ways to fix this:
- Simply don't set the NX bit in the original ioremap and drop
set_memory_x and add a ioremap_exec(). That would be my preferred solution, 
but unfortunately has been dismissed before
- Drop all __pas and always use the physical address derived 
from the looked up PTE. This would need some significant restructuring
and would only fix the first problem above, not the second.
- Special case NX clear to change any aliases. I chose this one
because it happens to fix both problems, so is both a fix
and a optimization.

This implies that it's still not safe calling set_memory_(not x) on
any ioremaped/vmalloced/module addresses. 

I don't have easy access to a EFI system so this is untested.

Cc: ying.huang@intel.com

v2: Skip static_protections for the addronly case. This is needed 
    because static_protections calls __pa() too and gets a random result too.
    static_protections is also not needed because all the bits it handles
    can be already derived from the original PTE.
    Improve description slightly.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -28,6 +28,7 @@ struct cpa_data {
 	pgprot_t	mask_clr;
 	int		numpages;
 	int		flushtlb;
+	int		addronly;
 };
 
 static inline int
@@ -304,7 +305,8 @@ try_preserve_large_page(pte_t *kpte, uns
 
 	pgprot_val(new_prot) &= ~pgprot_val(cpa->mask_clr);
 	pgprot_val(new_prot) |= pgprot_val(cpa->mask_set);
-	new_prot = static_protections(new_prot, address);
+	if (!cpa->addronly)
+		new_prot = static_protections(new_prot, address);
 
 	/*
 	 * We need to check the full range, whether
@@ -610,7 +612,7 @@ static int change_page_attr_addr(struct 
 	 * fixup the low mapping first. __va() returns the virtual
 	 * address in the linear mapping:
 	 */
-	if (within(address, HIGH_MAP_START, HIGH_MAP_END))
+	if (within(address, HIGH_MAP_START, HIGH_MAP_END) && !cpa->addronly)
 		address = (unsigned long) __va(phys_addr);
 #endif
 
@@ -623,7 +625,7 @@ static int change_page_attr_addr(struct 
 	 * If the physical address is inside the kernel map, we need
 	 * to touch the high mapped kernel as well:
 	 */
-	if (within(phys_addr, 0, KERNEL_TEXT_SIZE)) {
+	if (!cpa->addronly && within(phys_addr, 0, KERNEL_TEXT_SIZE)) {
 		/*
 		 * Calc the high mapping address. See __phys_addr()
 		 * for the non obvious details.
@@ -703,6 +705,8 @@ static int change_page_attr_set_clr(unsi
 	cpa.mask_set = mask_set;
 	cpa.mask_clr = mask_clr;
 	cpa.flushtlb = 0;
+	cpa.addronly = !pgprot_val(mask_set) &&
+			pgprot_val(mask_clr) == _PAGE_NX;
 
 	ret = __change_page_attr_set_clr(&cpa);
 
