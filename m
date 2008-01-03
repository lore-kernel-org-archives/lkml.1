Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbYACP0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbYACP0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbYACPYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:24:31 -0500
Received: from cantor.suse.de ([195.135.220.2]:46752 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052AbYACPY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:24:29 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103424.989432000@suse.de>
In-Reply-To: <20080103424.989432000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH CPA] [13/28] CPA: Use macros to modify the PG_arch_1 page flags in change_page_attr
Message-Id: <20080103152427.C8B3A14E23@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:24:27 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Instead of open coding the bit accesses uses standard style
*PageDeferred* macros. 

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr_32.c |   14 ++++++++++----
 arch/x86/mm/pageattr_64.c |   11 +++++++++--
 2 files changed, 19 insertions(+), 6 deletions(-)

Index: linux/arch/x86/mm/pageattr_64.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_64.c
+++ linux/arch/x86/mm/pageattr_64.c
@@ -18,6 +18,13 @@ struct flush {
 	unsigned long addr;
 };
 
+#define PG_deferred PG_arch_1
+
+#define PageDeferred(p) test_bit(PG_deferred, &(p)->flags)
+#define SetPageDeferred(p) set_bit(PG_deferred, &(p)->flags)
+#define ClearPageDeferred(p) clear_bit(PG_deferred, &(p)->flags)
+#define TestSetPageDeferred(p) test_and_set_bit(PG_deferred, &(p)->flags)
+
 pte_t *lookup_address(unsigned long address, int *level)
 { 
 	pgd_t *pgd = pgd_offset_k(address);
@@ -106,7 +113,7 @@ static LIST_HEAD(flush_pages);
 
 static inline void save_page(struct page *fpage)
 {
-	if (!test_and_set_bit(PG_arch_1, &fpage->flags))
+	if (!TestSetPageDeferred(fpage))
 		list_add(&fpage->lru, &deferred_pages);
 }
 
@@ -287,7 +294,7 @@ void global_flush_tlb(void)
 
 	list_for_each_entry_safe(pg, next, &free_pages, lru) {
 		list_del(&pg->lru);
-		clear_bit(PG_arch_1, &pg->flags);
+		ClearPageDeferred(pg);
 		if (page_private(pg) != 0)
 			continue;
 		ClearPagePrivate(pg);
Index: linux/arch/x86/mm/pageattr_32.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_32.c
+++ linux/arch/x86/mm/pageattr_32.c
@@ -14,8 +14,14 @@
 #include <asm/pgalloc.h>
 #include <asm/sections.h>
 
-/* Protected by init_mm.mmap_sem */
-/* Variables protected by cpa_lock */
+#define PG_deferred PG_arch_1
+
+#define PageDeferred(p) test_bit(PG_deferred, &(p)->flags)
+#define SetPageDeferred(p) set_bit(PG_deferred, &(p)->flags)
+#define ClearPageDeferred(p) clear_bit(PG_deferred, &(p)->flags)
+#define TestSetPageDeferred(p) test_and_set_bit(PG_deferred, &(p)->flags)
+
+/* Variables protected by init_mm.mmap_sem */
 static int full_flush;
 static struct list_head df_list = LIST_HEAD_INIT(df_list);
 static LIST_HEAD(flush_pages);
@@ -150,7 +156,7 @@ static inline void revert_page(struct pa
 
 static inline void save_page(struct page *kpte_page)
 {
-	if (!test_and_set_bit(PG_arch_1, &kpte_page->flags))
+	if (!TestSetPageDeferred(kpte_page))
 		list_add(&kpte_page->lru, &df_list);
 }
 
@@ -285,7 +291,7 @@ void global_flush_tlb(void)
 
 	list_for_each_entry_safe(pg, next, &free_pages, lru) {
 		list_del(&pg->lru);
-		clear_bit(PG_arch_1, &pg->flags);
+		ClearPageDeferred(pg);
 		if (PageReserved(pg) || !cpu_has_pse || page_private(pg) != 0)
 			continue;
 		ClearPagePrivate(pg);
