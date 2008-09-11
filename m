Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbYIKVfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbYIKVfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 17:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756973AbYIKVde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 17:33:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:31413 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756922AbYIKVdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 17:33:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,383,1217833200"; 
   d="scan'208";a="615332306"
Message-Id: <20080911204151.287251000@linux-os.sc.intel.com>
References: <20080911203048.929515000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 11 Sep 2008 13:30:55 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, arjan@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 7/7] x86, cpa: global flush tlb after splitting large page and before doing cpa
Content-Disposition: inline; filename=global_flush_tlb.patch
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

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/arch/x86/mm/pageattr.c
===================================================================
--- tip.orig/arch/x86/mm/pageattr.c	2008-09-11 13:25:55.000000000 -0700
+++ tip/arch/x86/mm/pageattr.c	2008-09-11 13:25:57.000000000 -0700
@@ -131,6 +131,18 @@
 	mb();
 }
 
+static void __global_flush_tlb(void *arg)
+{
+	__flush_tlb_all();
+}
+
+static void global_flush_tlb(void)
+{
+	BUG_ON(irqs_disabled());
+
+	on_each_cpu(__global_flush_tlb, NULL, 1);
+}
+
 static void __cpa_flush_all(void *arg)
 {
 	unsigned long cache = (unsigned long)arg;
@@ -506,6 +518,25 @@
 	ref_prot = pte_pgprot(pte_mkexec(pte_clrhuge(*kpte)));
 	pgprot_val(ref_prot) |= _PAGE_PRESENT;
 	__set_pmd_pte(kpte, address, mk_pte(base, ref_prot));
+
+	/*
+	 * Do a global flush tlb after splitting the large page
+	 * and before we do the actual change page attribute in the PTE.
+	 *
+	 * With out this, we violate the TLB application note, which says
+	 *  "The TLBs may contain both ordinary and large-page translations for
+	 *   a 4-KByte range of linear addresses. This may occur if software
+	 *   modifies the paging structures so that the page size used for the
+	 *   address range changes. If the two translations differ with respect
+	 *   to page frame or attributes (e.g., permissions), processor behavior
+	 *   is undefined and may be implementation-specific."
+	 *
+	 * We do this global tlb flush inside the pgd_lock, so that we don't
+	 * allow any other cpu, with stale tlb entries change the page table
+	 * attribute in parallel, that also falls into the just split large
+	 * page entry.
+	 */
+	global_flush_tlb();
 	base = NULL;
 
 out_unlock:
@@ -596,10 +627,8 @@
 	 * We have to split the large page:
 	 */
 	err = split_large_page(kpte, address);
-	if (!err) {
-		cpa->flags |= CPA_FLUSHTLB;
+	if (!err)
 		goto repeat;
-	}
 
 	return err;
 }

-- 

