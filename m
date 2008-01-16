Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYAPWRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYAPWRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbYAPWPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:15:09 -0500
Received: from mail.suse.de ([195.135.220.2]:55172 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbYAPWPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:15:06 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161114.239449000@suse.de>
In-Reply-To: <200801161114.239449000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com
Subject: [PATCH] [6/36] CPA Handle 4K split pages at boot on 64bit
Message-Id: <20080116221504.BA4DD150C8@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:15:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Port the code to check for already split 4K pages at boot over from
32bit to 64bit.

Note: should be probably put before PAT patches to avoid bisect failures later
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr_64.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux/arch/x86/mm/pageattr_64.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_64.c
+++ linux/arch/x86/mm/pageattr_64.c
@@ -160,11 +160,8 @@ __change_page_attr(unsigned long address
 	} else
 		BUG();
 
-	/* on x86-64 the direct mapping set at boot is not using 4k pages */
-	BUG_ON(PageReserved(kpte_page));
-
 	save_page(kpte_page);
-	if (page_private(kpte_page) == 0)
+	if (!PageReserved(kpte_page) && page_private(kpte_page) == 0)
 		revert_page(address, ref_prot);
 	return 0;
 } 
@@ -243,6 +240,8 @@ void global_flush_tlb(void)
 
 	list_for_each_entry_safe(pg, next, &l, lru) {
 		list_del(&pg->lru);
+		if (PageReserved(pg))
+			continue;
 		clear_bit(PG_arch_1, &pg->flags);
 		if (page_private(pg) != 0)
 			continue;
