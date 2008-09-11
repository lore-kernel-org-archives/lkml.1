Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbYIKVdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbYIKVdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 17:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbYIKVdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 17:33:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:33169 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbYIKVdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 17:33:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,383,1217833200"; 
   d="scan'208";a="379296708"
Message-Id: <20080911204151.010960000@linux-os.sc.intel.com>
References: <20080911203048.929515000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 11 Sep 2008 13:30:53 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, arjan@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 5/7] x86, cpa: fix taking the pgd_lock with interrupts off
Content-Disposition: inline; filename=fix_pageattr_irqlock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interrupt context no longer does the large page split, so no need to use
spin_lock_irqsave()

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/arch/x86/mm/pageattr.c
===================================================================
--- tip.orig/arch/x86/mm/pageattr.c	2008-09-11 13:19:54.000000000 -0700
+++ tip/arch/x86/mm/pageattr.c	2008-09-11 13:25:53.000000000 -0700
@@ -43,12 +43,10 @@
 
 void update_page_count(int level, unsigned long pages)
 {
-	unsigned long flags;
-
 	/* Protect against CPA */
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 	direct_pages_count[level] += pages;
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 }
 
 static void split_page_count(int level)
@@ -338,7 +336,7 @@
 try_preserve_large_page(pte_t *kpte, unsigned long address,
 			struct cpa_data *cpa)
 {
-	unsigned long nextpage_addr, numpages, pmask, psize, flags, addr, pfn;
+	unsigned long nextpage_addr, numpages, pmask, psize, addr, pfn;
 	pte_t new_pte, old_pte, *tmp;
 	pgprot_t old_prot, new_prot;
 	int i, do_split = 1;
@@ -347,7 +345,7 @@
 	if (cpa->force_split)
 		return 1;
 
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 	/*
 	 * Check for races, another CPU might have split this page
 	 * up already:
@@ -442,7 +440,7 @@
 	}
 
 out_unlock:
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 
 	return do_split;
 }
@@ -454,7 +452,6 @@
 static void cpa_fill_pool(struct page **ret)
 {
 	gfp_t gfp = GFP_KERNEL;
-	unsigned long flags;
 	struct page *p;
 
 	/*
@@ -484,10 +481,10 @@
 			*ret = p;
 			continue;
 		}
-		spin_lock_irqsave(&pgd_lock, flags);
+		spin_lock(&pgd_lock);
 		list_add(&p->lru, &page_pool);
 		pool_pages++;
-		spin_unlock_irqrestore(&pgd_lock, flags);
+		spin_unlock(&pgd_lock);
 	}
 
 	current->flags &= ~PF_MEMALLOC;
@@ -527,7 +524,7 @@
 
 static int split_large_page(pte_t *kpte, unsigned long address)
 {
-	unsigned long flags, pfn, pfninc = 1;
+	unsigned long pfn, pfninc = 1;
 	unsigned int i, level;
 	pte_t *pbase, *tmp;
 	pgprot_t ref_prot;
@@ -538,14 +535,14 @@
 	 * pgd_lock, which we have to take anyway for the split
 	 * operation:
 	 */
-	spin_lock_irqsave(&pgd_lock, flags);
+	spin_lock(&pgd_lock);
 	if (list_empty(&page_pool)) {
-		spin_unlock_irqrestore(&pgd_lock, flags);
+		spin_unlock(&pgd_lock);
 		base = NULL;
 		cpa_fill_pool(&base);
 		if (!base)
 			return -ENOMEM;
-		spin_lock_irqsave(&pgd_lock, flags);
+		spin_lock(&pgd_lock);
 	} else {
 		base = list_first_entry(&page_pool, struct page, lru);
 		list_del(&base->lru);
@@ -616,7 +613,7 @@
 		pool_pages++;
 	} else
 		pool_used++;
-	spin_unlock_irqrestore(&pgd_lock, flags);
+	spin_unlock(&pgd_lock);
 
 	return 0;
 }
@@ -676,6 +673,10 @@
 		return 0;
 	}
 
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	BUG_ON(irqs_disabled());
+#endif
+
 	/*
 	 * Check, whether we can keep the large page intact
 	 * and just change the pte:

-- 

