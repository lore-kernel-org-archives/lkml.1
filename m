Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbYBKJfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbYBKJfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 04:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbYBKJeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 04:34:36 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:37305 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbYBKJee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:34:34 -0500
From: Andi Kleen <ak@suse.de>
References: <200802111034.764275766@suse.de>
In-Reply-To: <200802111034.764275766@suse.de>
To: ying.huang@intel.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [4/8] CPA: Fix set_memory_x for ioremap
Message-Id: <20080211093432.DA4331B41CE@basil.firstfloor.org>
Date: Mon, 11 Feb 2008 10:34:32 +0100 (CET)
X-OriginalArrivalTime: 11 Feb 2008 09:28:12.0037 (UTC) FILETIME=[6BD68350:01C86C90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


EFI currently calls set_memory_x() on potentially ioremapped addresses.

This is problematic for several reasons: 

- The cpa code internally calls __pa on it which does not work for remapped
addresses and will give some random result.
- cpa will try to change all potential aliases (like the kernel mapping
on x86-64), but that is not needed for NX because the caller does only needs its 
specific virtual address executable. There is no requirement in the x86 architecture 
for nx bits to be coherent between mapping aliases. Also with the
previous problem of __pa returning a wrong address it would likely try to change 
some random other page if you're unlucky and the random result would
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

I don't have a EFI system so this is untested.

Cc: ying.huang@intel.com

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

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
@@ -602,7 +603,7 @@ static int change_page_attr_addr(struct 
 	 * fixup the low mapping first. __va() returns the virtual
 	 * address in the linear mapping:
 	 */
-	if (within(address, HIGH_MAP_START, HIGH_MAP_END))
+	if (within(address, HIGH_MAP_START, HIGH_MAP_END) && !cpa->addronly)
 		address = (unsigned long) __va(phys_addr);
 #endif
 
@@ -615,7 +616,7 @@ static int change_page_attr_addr(struct 
 	 * If the physical address is inside the kernel map, we need
 	 * to touch the high mapped kernel as well:
 	 */
-	if (within(phys_addr, 0, KERNEL_TEXT_SIZE)) {
+	if (!cpa->addronly && within(phys_addr, 0, KERNEL_TEXT_SIZE)) {
 		/*
 		 * Calc the high mapping address. See __phys_addr()
 		 * for the non obvious details.
@@ -695,6 +696,8 @@ static int change_page_attr_set_clr(unsi
 	cpa.mask_set = mask_set;
 	cpa.mask_clr = mask_clr;
 	cpa.flushtlb = 0;
+	cpa.addronly = !pgprot_val(mask_set) &&
+			pgprot_val(mask_clr) == _PAGE_NX;
 
 	ret = __change_page_attr_set_clr(&cpa);
 
