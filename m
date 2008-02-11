Return-Path: <linux-kernel-owner+w=401wt.eu-S1753799AbYBKJgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbYBKJgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 04:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbYBKJei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 04:34:38 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:29284 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbYBKJeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:34:36 -0500
From: Andi Kleen <ak@suse.de>
References: <200802111034.764275766@suse.de>
In-Reply-To: <200802111034.764275766@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [5/8] Fix logic error in 64bit memory hotadd
Message-Id: <20080211093433.DE4961B41CE@basil.firstfloor.org>
Date: Mon, 11 Feb 2008 10:34:33 +0100 (CET)
X-OriginalArrivalTime: 11 Feb 2008 09:28:13.0068 (UTC) FILETIME=[6C73D4C0:01C86C90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The memory hotadd code assumes that the pud always exists already, but 
that might be not true. Allocate it if it isn't there.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/init_64.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -432,17 +432,22 @@ void __init_refok init_memory_mapping(un
 		unsigned long pud_phys;
 		pud_t *pud;
 
-		if (after_bootmem)
+		if (after_bootmem) {
 			pud = pud_offset(pgd, start & PGDIR_MASK);
-		else
+			if (!pud_present(*pud)) {
+				pud = (pud_t *)get_zeroed_page(GFP_ATOMIC);
+				if (!pud)
+					panic("Out of memory");
+			}
+			pud_phys = __pa(pud);
+		} else
 			pud = alloc_low_page(&pud_phys);
 
 		next = start + PGDIR_SIZE;
 		if (next > end)
 			next = end;
 		phys_pud_init(pud, __pa(start), __pa(next));
-		if (!after_bootmem)
-			set_pgd(pgd_offset_k(start), mk_kernel_pgd(pud_phys));
+		set_pgd(pgd_offset_k(start), mk_kernel_pgd(pud_phys));
 		unmap_low_page(pud);
 	}
 
