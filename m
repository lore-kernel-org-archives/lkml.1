Return-Path: <linux-kernel-owner+w=401wt.eu-S1762353AbYBAJ5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762353AbYBAJ5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757493AbYBAJx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:53:28 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:7580 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757359AbYBAJx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:53:27 -0500
From: Andi Kleen <ak@suse.de>
References: <200802011053.107168490@suse.de>
In-Reply-To: <200802011053.107168490@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [12/12] GBPAGES: Switch direct mapping setup over to set_pte
Message-Id: <20080201095325.6419E1B416F@basil.firstfloor.org>
Date: Fri,  1 Feb 2008 10:53:25 +0100 (CET)
X-OriginalArrivalTime: 01 Feb 2008 09:47:07.0905 (UTC) FILETIME=[68BCB710:01C864B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Actually not needed for gbpages, but an indepedent, but related cleanup]

Use set_pte() for setting up the 2MB pages in the direct mapping similar 
to what the earlier GBPAGES patches did for the 1GB PUDs.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/init_64.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -289,7 +289,6 @@ phys_pmd_init(pmd_t *pmd_page, unsigned 
 	int i = pmd_index(address);
 
 	for (; i < PTRS_PER_PMD; i++, address += PMD_SIZE) {
-		unsigned long entry;
 		pmd_t *pmd = pmd_page + pmd_index(address);
 
 		if (address >= end) {
@@ -303,9 +302,8 @@ phys_pmd_init(pmd_t *pmd_page, unsigned 
 		if (pmd_val(*pmd))
 			continue;
 
-		entry = __PAGE_KERNEL_LARGE|_PAGE_GLOBAL|address;
-		entry &= __supported_pte_mask;
-		set_pmd(pmd, __pmd(entry));
+		set_pte((pte_t *)pmd,
+			pfn_pte(address >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
 	}
 }
 
