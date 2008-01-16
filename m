Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbYAPWYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbYAPWYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbYAPWPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:15:42 -0500
Received: from ns2.suse.de ([195.135.220.15]:38287 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153AbYAPWP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:15:28 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161114.239449000@suse.de>
In-Reply-To: <200801161114.239449000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com
Subject: [PATCH] [27/36] CPA: Only queue actually unused page table pages for freeing
Message-Id: <20080116221527.1907F150C8@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:15:27 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With the separate data structure added for flush earlier it is only
needed to call save_page() now on pte pages that have been already reverted.

Also move all freeing checks into the caller.

Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/mm/pageattr_32.c |    4 +---
 arch/x86/mm/pageattr_64.c |    7 +++----
 2 files changed, 4 insertions(+), 7 deletions(-)

Index: linux/arch/x86/mm/pageattr_32.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_32.c
+++ linux/arch/x86/mm/pageattr_32.c
@@ -270,9 +270,9 @@ __change_page_attr(struct page *page, pg
 	 * replace it with a largepage.
 	 */
 
-	save_page(kpte_page);
 	if (!PageReserved(kpte_page)) {
 		if (cpu_has_pse && (page_private(kpte_page) == 0)) {
+			save_page(kpte_page);
 			paravirt_release_pt(page_to_pfn(kpte_page));
 			revert_page(kpte_page, address);
 		}
@@ -349,8 +349,6 @@ void global_flush_tlb(void)
 	list_for_each_entry_safe(pg, next, &free_pages, lru) {
 		list_del(&pg->lru);
 		ClearPageDeferred(pg);
-		if (PageReserved(pg) || !cpu_has_pse || page_private(pg) != 0)
-			continue;
 		ClearPagePrivate(pg);
 		__free_page(pg);
 	}
Index: linux/arch/x86/mm/pageattr_64.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_64.c
+++ linux/arch/x86/mm/pageattr_64.c
@@ -243,9 +243,10 @@ __change_page_attr(unsigned long address
 		BUG();
 	}
 
-	save_page(kpte_page);
-	if (!PageReserved(kpte_page) && page_private(kpte_page) == 0)
+	if (!PageReserved(kpte_page) && page_private(kpte_page) == 0) {
+		save_page(kpte_page);
 		revert_page(address, ref_prot);
+	}
 	return 0;
 } 
 
@@ -335,8 +336,6 @@ void global_flush_tlb(void)
 		if (PageReserved(pg))
 			continue;
 		ClearPageDeferred(pg);
-		if (page_private(pg) != 0)
-			continue;
 		ClearPagePrivate(pg);
 		__free_page(pg);
 	} 
