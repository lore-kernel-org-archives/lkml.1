Return-Path: <linux-kernel-owner+w=401wt.eu-S1765801AbXIUWhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765801AbXIUWhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762213AbXIUWcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:40472 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763266AbXIUWcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:16 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [16/50] x86: Use macros to modify the PG_arch_1 page flags in change_page_attr
Message-Id: <20070921223214.E730213DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:14 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Instead of open coding the bit accesses uses standard style
*PageDeferred* macros. 

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/mm/pageattr.c   |   10 +++++++---
 arch/x86_64/mm/pageattr.c |   11 ++++++++---
 2 files changed, 15 insertions(+), 6 deletions(-)

Index: linux/arch/x86_64/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86_64/mm/pageattr.c
+++ linux/arch/x86_64/mm/pageattr.c
@@ -17,6 +17,11 @@
 #define SetPageFlush(p) set_bit(PG_owner_priv_1, &(p)->flags)
 #define TestClearPageFlush(p) test_and_clear_bit(PG_owner_priv_1, &(p)->flags)
 
+#define PageDeferred(p) test_bit(PG_arch_1, &(p)->flags)
+#define SetPageDeferred(p) set_bit(PG_arch_1, &(p)->flags)
+#define ClearPageDeferred(p) clear_bit(PG_arch_1, &(p)->flags)
+#define TestSetPageDeferred(p) test_and_set_bit(PG_arch_1, &(p)->flags)
+
 pte_t *lookup_address(unsigned long address)
 { 
 	pgd_t *pgd = pgd_offset_k(address);
@@ -101,7 +106,7 @@ static inline void save_page(struct page
 {
 	if (data && cpu_has_clflush)
 		SetPageFlush(fpage);
-	if (test_and_set_bit(PG_arch_1, &fpage->flags))
+	if (TestSetPageDeferred(fpage))
 		return;
 	if (cpu_has_clflush || !data) 
 		list_add(&fpage->lru, &deferred_pages);
@@ -137,7 +142,7 @@ static struct page *flush_page(unsigned 
 	if (!(pfn_valid(__pa(address) >> PAGE_SHIFT)))
 		return NULL;
 	p = virt_to_page(address);
-	if ((PageFlush(p) || PageLRU(p)) && !test_bit(PG_arch_1, &p->flags))
+	if ((PageFlush(p) || PageLRU(p)) && !PageDeferred(p))
 		return NULL;
 	return p;
 }
@@ -272,7 +277,7 @@ void global_flush_tlb(void)
 
 	list_for_each_entry_safe(pg, next, &arg.l, lru) {
 		list_del(&pg->lru);
-		clear_bit(PG_arch_1, &pg->flags);
+		ClearPageDeferred(pg);
 		if (TestClearPageFlush(pg))
 			continue;
 		if (page_private(pg) != 0)
Index: linux/arch/i386/mm/pageattr.c
===================================================================
--- linux.orig/arch/i386/mm/pageattr.c
+++ linux/arch/i386/mm/pageattr.c
@@ -17,6 +17,10 @@
 #define PageFlush(p) test_bit(PG_owner_priv_1, &(p)->flags)
 #define SetPageFlush(p) set_bit(PG_owner_priv_1, &(p)->flags)
 #define TestClearPageFlush(p) test_and_clear_bit(PG_owner_priv_1, &(p)->flags)
+#define PageDeferred(p) test_bit(PG_arch_1, &(p)->flags)
+#define SetPageDeferred(p) set_bit(PG_arch_1, &(p)->flags)
+#define ClearPageDeferred(p) clear_bit(PG_arch_1, &(p)->flags)
+#define TestSetPageDeferred(p) test_and_set_bit(PG_arch_1, &(p)->flags)
 
 static DEFINE_SPINLOCK(cpa_lock);
 /* Both protected by cpa_lock */
@@ -152,7 +156,7 @@ static inline void save_page(struct page
 {
 	if (data && cpu_has_clflush)
 		SetPageFlush(fpage);
-	if (test_and_set_bit(PG_arch_1, &fpage->flags))
+	if (TestSetPageDeferred(fpage))
 		return;
 	if (!data || cpu_has_clflush)
 		list_add(&fpage->lru, &df_list);
@@ -164,7 +168,7 @@ static struct page *flush_page(unsigned 
 	if (!(pfn_valid(__pa(address) >> PAGE_SHIFT)))
 		return NULL;
 	p = virt_to_page(address);
-	if ((PageFlush(p) || PageLRU(p)) && !test_bit(PG_arch_1, &p->flags))
+	if ((PageFlush(p) || PageLRU(p)) && !PageDeferred(p))
 		return NULL;
 	return p;
 }
@@ -282,7 +286,7 @@ void global_flush_tlb(void)
 	on_each_cpu(flush_kernel_map, &arg, 1, 1);
 	list_for_each_entry_safe(pg, next, &arg.l, lru) {
 		list_del(&pg->lru);
-		clear_bit(PG_arch_1, &pg->flags);
+		ClearPageDeferred(pg);
 		if (TestClearPageFlush(pg))
 			continue;
 		if (PageReserved(pg) || !cpu_has_pse || page_private(pg) != 0)
