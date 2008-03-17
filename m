Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbYCRF2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbYCRF2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYCRFYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:20 -0400
Received: from gw.goop.org ([64.81.55.164]:37853 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbYCRFYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:08 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 09 of 31] x86: move all the pgd_list handling to one place
X-Mercurial-Node: b9155a8d693a89d763ddb3c3aa904c66dcb81ea8
Message-Id: <b9155a8d693a89d763dd.1205797020@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:37:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/pgtable.c |   28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -43,34 +43,31 @@
 #endif	/* PAGETABLE_LEVELS > 3 */
 #endif	/* PAGETABLE_LEVELS > 2 */
 
-#ifdef CONFIG_X86_64
 static inline void pgd_list_add(pgd_t *pgd)
 {
 	struct page *page = virt_to_page(pgd);
-	unsigned long flags;
 
-	spin_lock_irqsave(&pgd_lock, flags);
 	list_add(&page->lru, &pgd_list);
-	spin_unlock_irqrestore(&pgd_lock, flags);
 }
 
 static inline void pgd_list_del(pgd_t *pgd)
 {
 	struct page *page = virt_to_page(pgd);
-	unsigned long flags;
 
-	spin_lock_irqsave(&pgd_lock, flags);
 	list_del(&page->lru);
-	spin_unlock_irqrestore(&pgd_lock, flags);
 }
 
+#ifdef CONFIG_X86_64
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
 	unsigned boundary;
 	pgd_t *pgd = (pgd_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT);
+	unsigned long flags;
 	if (!pgd)
 		return NULL;
+	spin_lock_irqsave(&pgd_lock, flags);
 	pgd_list_add(pgd);
+	spin_unlock_irqrestore(&pgd_lock, flags);
 	/*
 	 * Copy kernel pointers in from init.
 	 * Could keep a freelist or slab cache of those because the kernel
@@ -86,8 +83,11 @@
 
 void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
+	unsigned long flags;
 	BUG_ON((unsigned long)pgd & (PAGE_SIZE-1));
+	spin_lock_irqsave(&pgd_lock, flags);
 	pgd_list_del(pgd);
+	spin_unlock_irqrestore(&pgd_lock, flags);
 	free_page((unsigned long)pgd);
 }
 #else
@@ -101,20 +101,6 @@
  * vmalloc faults work because attached pagetables are never freed.
  * -- wli
  */
-static inline void pgd_list_add(pgd_t *pgd)
-{
-	struct page *page = virt_to_page(pgd);
-
-	list_add(&page->lru, &pgd_list);
-}
-
-static inline void pgd_list_del(pgd_t *pgd)
-{
-	struct page *page = virt_to_page(pgd);
-
-	list_del(&page->lru);
-}
-
 #define UNSHARED_PTRS_PER_PGD				\
 	(SHARED_KERNEL_PMD ? USER_PTRS_PER_PGD : PTRS_PER_PGD)
 


