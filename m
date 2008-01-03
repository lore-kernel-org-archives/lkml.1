Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbYACPav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbYACPav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbYACPYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:24:43 -0500
Received: from ns1.suse.de ([195.135.220.2]:46761 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754532AbYACPYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:24:38 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103424.989432000@suse.de>
In-Reply-To: <20080103424.989432000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH CPA] [22/28] CPA: Only queue actually unused page table pages for freeing
Message-Id: <20080103152437.5C6AC14E23@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:24:37 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With the separate data structure added for flush earlier it is only
needed to call save_page() now on pte pages that have been already reverted.

Also move all freeing checks into the caller.

Signed-off-by: Andi Kleen <ak@suse.de>

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
@@ -333,8 +333,6 @@ void global_flush_tlb(void)
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
@@ -246,9 +246,10 @@ __change_page_attr(unsigned long address
 	/* on x86-64 the direct mapping set at boot is not using 4k pages */
  	BUG_ON(PageReserved(kpte_page));
 
-	save_page(kpte_page);
-	if (page_private(kpte_page) == 0)
+	if (page_private(kpte_page) == 0) {
+		save_page(kpte_page);
 		revert_page(address, ref_prot);
+	}
 	return 0;
 } 
 
@@ -336,8 +337,6 @@ void global_flush_tlb(void)
 	list_for_each_entry_safe(pg, next, &free_pages, lru) {
 		list_del(&pg->lru);
 		ClearPageDeferred(pg);
-		if (page_private(pg) != 0)
-			continue;
 		ClearPagePrivate(pg);
 		__free_page(pg);
 	} 
