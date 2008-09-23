Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbYIWVWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbYIWVWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbYIWVVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:21:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:36375 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367AbYIWVVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:21:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,295,1220252400"; 
   d="scan'208";a="339695441"
Message-Id: <20080923211444.950008000@linux-os.sc.intel.com>
References: <20080923210035.413932000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 23 Sep 2008 14:00:42 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, arjan@linux.intel.com,
       venkatesh.pallipadi@intel.com, jeremy@goop.org
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 7/7] x86, cpa: srlz cpa(), global flush tlb after splitting big page and before doing cpa
Content-Disposition: inline; filename=introduce_cpa_lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do a global flush tlb after splitting the large page and before we do the
actual change page attribute in the PTE.

With out this, we violate the TLB application note, which says
    "The TLBs may contain both ordinary and large-page translations for
     a 4-KByte range of linear addresses. This may occur if software
     modifies the paging structures so that the page size used for the
     address range changes. If the two translations differ with respect
     to page frame or attributes (e.g., permissions), processor behavior
     is undefined and may be implementation-specific."

And also serialize cpa() (for !DEBUG_PAGEALLOC which uses large identity
mappings) using cpa_lock. So that we don't allow any other cpu, with stale
large tlb entries change the page attribute in parallel to some other cpu
splitting a large page entry along with changing the attribute.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/arch/x86/mm/pageattr.c
===================================================================
--- tip.orig/arch/x86/mm/pageattr.c	2008-09-23 13:47:51.000000000 -0700
+++ tip/arch/x86/mm/pageattr.c	2008-09-23 13:47:54.000000000 -0700
@@ -35,6 +35,14 @@
 	int		curpage;
 };
 
+/*
+ * Serialize cpa() (for !DEBUG_PAGEALLOC which uses large identity mappings)
+ * using cpa_lock. So that we don't allow any other cpu, with stale large tlb
+ * entries change the page attribute in parallel to some other cpu
+ * splitting a large page entry along with changing the attribute.
+ */
+static DEFINE_SPINLOCK(cpa_lock);
+
 #define CPA_FLUSHTLB 1
 #define CPA_ARRAY 2
 
@@ -453,7 +461,13 @@
 	unsigned int i, level;
 	pte_t *pbase, *tmp;
 	pgprot_t ref_prot;
-	struct page *base = alloc_pages(GFP_KERNEL, 0);
+	struct page *base;
+
+	if (!debug_pagealloc)
+		spin_unlock(&cpa_lock);
+	base = alloc_pages(GFP_KERNEL, 0);
+	if (!debug_pagealloc)
+		spin_lock(&cpa_lock);
 	if (!base)
 		return -ENOMEM;
 
@@ -594,7 +608,25 @@
 	 */
 	err = split_large_page(kpte, address);
 	if (!err) {
-		cpa->flags |= CPA_FLUSHTLB;
+		/*
+	 	 * Do a global flush tlb after splitting the large page
+	 	 * and before we do the actual change page attribute in the PTE.
+	 	 *
+	 	 * With out this, we violate the TLB application note, that says
+	 	 * "The TLBs may contain both ordinary and large-page
+		 *  translations for a 4-KByte range of linear addresses. This
+		 *  may occur if software modifies the paging structures so that
+		 *  the page size used for the address range changes. If the two
+		 *  translations differ with respect to page frame or attributes
+		 *  (e.g., permissions), processor behavior is undefined and may
+		 *  be implementation-specific."
+	 	 *
+	 	 * We do this global tlb flush inside the cpa_lock, so that we
+		 * don't allow any other cpu, with stale tlb entries change the
+		 * page attribute in parallel, that also falls into the
+		 * just split large page entry.
+	 	 */
+		flush_tlb_all();
 		goto repeat;
 	}
 
@@ -686,7 +718,11 @@
 		if (cpa->flags & CPA_ARRAY)
 			cpa->numpages = 1;
 
+		if (!debug_pagealloc)
+			spin_lock(&cpa_lock);
 		ret = __change_page_attr(cpa, checkalias);
+		if (!debug_pagealloc)
+			spin_unlock(&cpa_lock);
 		if (ret)
 			return ret;
 

-- 

