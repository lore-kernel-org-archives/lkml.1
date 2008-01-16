Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbYAPWQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbYAPWQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbYAPWPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:15:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbYAPWPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:15:02 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161114.239449000@suse.de>
In-Reply-To: <200801161114.239449000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com
Subject: [PATCH] [3/36] Undo pageattr_64 parts of 4157e20af49a04d75a807e6d15b3e70c8e688ccc
Message-Id: <20080116221501.8DC60150C5@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:15:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Note sure what the point of that change was 

 Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
 Date:   Tue Jan 15 16:53:24 2008 +0100

    patches/x86-pat-usable_only_map.patch
    
    x86_64: Map only usable memory in identity map. Reserved memory maps to a
    zero page.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr_64.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: linux/arch/x86/mm/pageattr_64.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_64.c
+++ linux/arch/x86/mm/pageattr_64.c
@@ -53,11 +53,9 @@ split_large_page(unsigned long address, 
 	/*
 	 * page_private is used to track the number of entries in
 	 * the page table page have non standard attributes.
-	 * Count of 1 indicates page split by split_large_page(),
-	 * additional count indicates the number of pages with non-std attr.
 	 */
 	SetPagePrivate(base);
-	page_private(base) = 1;
+	page_private(base) = 0;
 
 	address = __pa(address);
 	addr = address & LARGE_PAGE_MASK;
@@ -178,8 +176,11 @@ __change_page_attr(unsigned long address
 			BUG();
 	}
 
+	/* on x86-64 the direct mapping set at boot is not using 4k pages */
+	BUG_ON(PageReserved(kpte_page));
+
 	save_page(kpte_page);
-	if (page_private(kpte_page) == 1)
+	if (page_private(kpte_page) == 0)
 		revert_page(address, ref_prot);
 	return 0;
 }
