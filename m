Return-Path: <linux-kernel-owner+w=401wt.eu-S1752094AbYBKJvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbYBKJvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 04:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbYBKJuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 04:50:25 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:28217 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbYBKJuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:50:22 -0500
From: Andi Kleen <ak@suse.de>
References: <200802111050.372086035@suse.de>
In-Reply-To: <200802111050.372086035@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [5/8] CPA: Move pool allocation/free into separate functions
Message-Id: <20080211095020.72C221B41CE@basil.firstfloor.org>
Date: Mon, 11 Feb 2008 10:50:20 +0100 (CET)
X-OriginalArrivalTime: 11 Feb 2008 09:43:59.0298 (UTC) FILETIME=[A0731220:01C86C92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Following up the previous ifdef patch this moves the pool allocation/free
code into separate functions.

Minor drawback is that the pgd_lock is now taken more times (this
was needed to separate the with/without DEBUG_PAGEALLOC cases cleanly), but the
additional lock only hits in the DEBUG_PAGEALLOC case which is already slow and 
shouldn't be a big issue. Advantage is easier readable code because split_large_page
gets smaller again and less ifdef jungle.

Other than taking the locks explicitely again for alloc and free
there should be no behaviour change.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr.c |   84 +++++++++++++++++++++++++++++--------------------
 1 file changed, 51 insertions(+), 33 deletions(-)

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -416,6 +416,42 @@ void __init cpa_init(void)
 	       pool_pages, pool_size);
 }
 
+static struct page *cpa_get_page(void)
+{
+	unsigned long flags;
+	struct page *page = NULL;
+
+	spin_lock_irqsave(&pgd_lock, flags);
+
+	if (list_empty(&page_pool))
+		goto out;
+
+	page = list_first_entry(&page_pool, struct page, lru);
+	list_del(&page->lru);
+	pool_pages--;
+
+	if (pool_pages < pool_low)
+		pool_low = pool_pages;
+	pool_used++;
+
+out:
+	spin_unlock_irqrestore(&pgd_lock, flags);
+
+	return page;
+}
+
+static void cpa_free_page(struct page *page)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&pgd_lock, flags);
+	list_add(&page->lru, &page_pool);
+	pool_pages++;
+	pool_used--;
+
+	spin_unlock_irqrestore(&pgd_lock, flags);
+}
+
 #else
 void __init cpa_init(void)
 {
@@ -424,6 +460,16 @@ void __init cpa_init(void)
 static inline void cpa_fill_pool(void)
 {
 }
+
+static struct page *cpa_get_page(void)
+{
+	return alloc_page(GFP_KERNEL);
+}
+
+static inline void cpa_free_page(struct page *page)
+{
+	__free_page(page);
+}
 #endif
 
 static int split_large_page(pte_t *kpte, unsigned long address)
@@ -434,32 +480,11 @@ static int split_large_page(pte_t *kpte,
 	pgprot_t ref_prot;
 	struct page *base;
 
-#ifndef CONFIG_DEBUG_PAGEALLOC
-	base = alloc_page(GFP_KERNEL);
+	base = cpa_get_page();
 	if (!base)
 		return -ENOMEM;
-#endif
 
-	/*
-	 * Get a page from the pool. The pool list is protected by the
-	 * pgd_lock, which we have to take anyway for the split
-	 * operation:
-	 */
 	spin_lock_irqsave(&pgd_lock, flags);
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	if (list_empty(&page_pool)) {
-		spin_unlock_irqrestore(&pgd_lock, flags);
-		return -ENOMEM;
-	}
-
-	base = list_first_entry(&page_pool, struct page, lru);
-	list_del(&base->lru);
-	pool_pages--;
-
-	if (pool_pages < pool_low)
-		pool_low = pool_pages;
-#endif
-
 	/*
 	 * Check for races, another CPU might have split this page
 	 * up for us already:
@@ -504,21 +529,14 @@ static int split_large_page(pte_t *kpte,
 	base = NULL;
 
 out_unlock:
-#ifdef CONFIG_DEBUG_PAGEALLOC
+	spin_unlock_irqrestore(&pgd_lock, flags);
+
 	/*
 	 * If we dropped out via the lookup_address check under
-	 * pgd_lock then stick the page back into the pool:
+	 * pgd_lock then get rid of the page again.
 	 */
-	if (base) {
-		list_add(&base->lru, &page_pool);
-		pool_pages++;
-	} else
-		pool_used++;
-#else
 	if (base)
-		__free_page(base);
-#endif
-	spin_unlock_irqrestore(&pgd_lock, flags);
+		cpa_free_page(base);
 
 	return 0;
 }
