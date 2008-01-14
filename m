Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbYANWYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbYANWYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755966AbYANWRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:17:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:55077 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755846AbYANWQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:16:56 -0500
From: Andi Kleen <ak@suse.de>
References: <200801141116.534682000@suse.de>
In-Reply-To: <200801141116.534682000@suse.de>
To: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [22/31] CPA: Only queue actually unused page table pages for freeing
Message-Id: <20080114221655.28CCA14F83@wotan.suse.de>
Date: Mon, 14 Jan 2008 23:16:55 +0100 (CET)
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
