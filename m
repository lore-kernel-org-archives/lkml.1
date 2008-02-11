Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbYBKJvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbYBKJvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 04:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbYBKJuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 04:50:24 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:17349 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbYBKJuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:50:21 -0500
From: Andi Kleen <ak@suse.de>
References: <200802111050.372086035@suse.de>
In-Reply-To: <200802111050.372086035@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [4/8] CPA: Ifdef the cpa pool for DEBUG_PAGEALLOC
Message-Id: <20080211095019.6ED761B41CE@basil.firstfloor.org>
Date: Mon, 11 Feb 2008 10:50:19 +0100 (CET)
X-OriginalArrivalTime: 11 Feb 2008 09:43:58.0282 (UTC) FILETIME=[9FD80AA0:01C86C92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When DEBUG_PAGEALLOC is not set there is no need for the complicated 
cpa pool because no recursion is possible in the memory allocator. 

So ifdef this case. This will save some memory because
the pool won't be needed for normal operation.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -345,6 +345,8 @@ out_unlock:
 	return do_split;
 }
 
+#ifdef CONFIG_DEBUG_PAGEALLOC
+
 static LIST_HEAD(page_pool);
 static unsigned long pool_size, pool_pages, pool_low;
 static unsigned long pool_used, pool_failed, pool_refill;
@@ -365,14 +367,12 @@ static void cpa_fill_pool(void)
 	if (pool_pages >= pool_size || test_and_set_bit_lock(0, &pool_refill))
 		return;
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
 	/*
 	 * We could do:
 	 * gfp = in_atomic() ? GFP_ATOMIC : GFP_KERNEL;
 	 * but this fails on !PREEMPT kernels
 	 */
 	gfp =  GFP_ATOMIC | __GFP_NORETRY | __GFP_NOWARN;
-#endif
 
 	while (pool_pages < pool_size) {
 		p = alloc_pages(gfp, 0);
@@ -416,6 +416,16 @@ void __init cpa_init(void)
 	       pool_pages, pool_size);
 }
 
+#else
+void __init cpa_init(void)
+{
+}
+
+static inline void cpa_fill_pool(void)
+{
+}
+#endif
+
 static int split_large_page(pte_t *kpte, unsigned long address)
 {
 	unsigned long flags, pfn, pfninc = 1;
@@ -424,12 +434,19 @@ static int split_large_page(pte_t *kpte,
 	pgprot_t ref_prot;
 	struct page *base;
 
+#ifndef CONFIG_DEBUG_PAGEALLOC
+	base = alloc_page(GFP_KERNEL);
+	if (!base)
+		return -ENOMEM;
+#endif
+
 	/*
 	 * Get a page from the pool. The pool list is protected by the
 	 * pgd_lock, which we have to take anyway for the split
 	 * operation:
 	 */
 	spin_lock_irqsave(&pgd_lock, flags);
+#ifdef CONFIG_DEBUG_PAGEALLOC
 	if (list_empty(&page_pool)) {
 		spin_unlock_irqrestore(&pgd_lock, flags);
 		return -ENOMEM;
@@ -441,6 +458,7 @@ static int split_large_page(pte_t *kpte,
 
 	if (pool_pages < pool_low)
 		pool_low = pool_pages;
+#endif
 
 	/*
 	 * Check for races, another CPU might have split this page
@@ -486,6 +504,7 @@ static int split_large_page(pte_t *kpte,
 	base = NULL;
 
 out_unlock:
+#ifdef CONFIG_DEBUG_PAGEALLOC
 	/*
 	 * If we dropped out via the lookup_address check under
 	 * pgd_lock then stick the page back into the pool:
@@ -495,6 +514,10 @@ out_unlock:
 		pool_pages++;
 	} else
 		pool_used++;
+#else
+	if (base)
+		__free_page(base);
+#endif
 	spin_unlock_irqrestore(&pgd_lock, flags);
 
 	return 0;
