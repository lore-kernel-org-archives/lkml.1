Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbYACP2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbYACP2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbYACPYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:24:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43025 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285AbYACPYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:24:33 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103424.989432000@suse.de>
In-Reply-To: <20080103424.989432000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH CPA] [17/28] CPA: Reorder TLB / cache flushes to follow Intel recommendation
Message-Id: <20080103152432.0E7E714E23@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:24:32 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Intel recommends to first flush the TLBs and then the caches
on caching attribute changes. c_p_a() previously did it the
other way round. Reorder that.

The procedure is still not fully compliant to the Intel documentation
because Intel recommends a all CPU synchronization step between
the TLB flushes and the cache flushes.

However on all new Intel CPUs this is now meaningless anyways
because they support Self-Snoop and can skip the cache flush 
step anyways.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr_32.c |   13 ++++++++++---
 arch/x86/mm/pageattr_64.c |   14 ++++++++++----
 2 files changed, 20 insertions(+), 7 deletions(-)

Index: linux/arch/x86/mm/pageattr_32.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_32.c
+++ linux/arch/x86/mm/pageattr_32.c
@@ -97,9 +97,6 @@ static void flush_kernel_map(void *arg)
 	struct flush_arg *a = (struct flush_arg *)arg;
 	struct flush *f;
 
-	if ((!cpu_has_clflush || a->full_flush) && boot_cpu_data.x86_model >= 4 &&
-		!cpu_has_ss)
-		wbinvd();
 	list_for_each_entry(f, &a->l, l) {
 		if (!a->full_flush && !cpu_has_ss)
 			clflush_cache_range((void *)f->addr, PAGE_SIZE);
@@ -112,6 +109,16 @@ static void flush_kernel_map(void *arg)
 	    (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
 	     boot_cpu_data.x86 == 7))
 		__flush_tlb_all();
+
+	/*
+	 * RED-PEN: Intel documentation ask for a CPU synchronization step
+	 * here and in the loop. But it is moot on Self-Snoop CPUs anyways.
+	 */
+
+	if ((!cpu_has_clflush || a->full_flush) &&
+	    !cpu_has_ss && boot_cpu_data.x86_model >= 4)
+		wbinvd();
+
 }
 
 static void set_pmd_pte(pte_t *kpte, unsigned long address, pte_t pte) 
Index: linux/arch/x86/mm/pageattr_64.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_64.c
+++ linux/arch/x86/mm/pageattr_64.c
@@ -94,16 +94,22 @@ static void flush_kernel_map(void *arg)
 
 	/* When clflush is available always use it because it is
 	   much cheaper than WBINVD. */
-	if ((a->full_flush || !cpu_has_clflush) && !cpu_has_ss)
-		wbinvd();
 	list_for_each_entry(f, &a->l, l) {
-		if (!a->full_flush && !cpu_has_ss)
-			clflush_cache_range((void *)f->addr, PAGE_SIZE);
 		if (!a->full_flush)
 			__flush_tlb_one(f->addr);
+		if (!a->full_flush && !cpu_has_ss)
+			clflush_cache_range((void *)f->addr, PAGE_SIZE);
 	}
 	if (a->full_flush)
 		__flush_tlb_all();
+
+	/*
+	 * RED-PEN: Intel documentation ask for a CPU synchronization step
+	 * here and in the loop. But it is moot on Self-Snoop CPUs anyways.
+	 */
+
+	if ((!cpu_has_clflush || a->full_flush) && !cpu_has_ss)
+		wbinvd();
 }
 
 /* both protected by init_mm.mmap_sem */
