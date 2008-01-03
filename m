Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbYACP1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbYACP1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:27:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbYACPYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:24:32 -0500
Received: from mx1.suse.de ([195.135.220.2]:46755 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbYACPY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:24:29 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103424.989432000@suse.de>
In-Reply-To: <20080103424.989432000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH CPA] [14/28] CPA: Use page granuality TLB flushing in change_page_attr
Message-Id: <20080103152428.D8C8914E23@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:24:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With the infrastructure added for CLFLUSH it is possible
to only TLB flush the actually changed pages in change_page_attr()

Take care of old Athlon K7 Errata on the 32bit version

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr_32.c |   15 ++++++++-------
 arch/x86/mm/pageattr_64.c |   10 +++++-----
 2 files changed, 13 insertions(+), 12 deletions(-)

Index: linux/arch/x86/mm/pageattr_32.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_32.c
+++ linux/arch/x86/mm/pageattr_32.c
@@ -97,19 +97,20 @@ static void flush_kernel_map(void *arg)
 	struct flush_arg *a = (struct flush_arg *)arg;
 	struct flush *f;
 
-	if (!cpu_has_clflush)
-		a->full_flush = 1;
-	if (a->full_flush && boot_cpu_data.x86_model >= 4)
+	if ((!cpu_has_clflush || a->full_flush) && boot_cpu_data.x86_model >= 4)
 		wbinvd();
 	list_for_each_entry(f, &a->l, l) {
 		if (!a->full_flush)
 			clflush_cache_range((void *)f->addr, PAGE_SIZE);
+		if (!a->full_flush)
+			__flush_tlb_one(f->addr);
 	}
 
-	/* Flush all to work around Errata in early athlons regarding 
-	 * large page flushing. 
-	 */
-	__flush_tlb_all(); 	
+	/* Handle errata with flushing large pages in early Athlons */
+	if (a->full_flush ||
+	    (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
+	     boot_cpu_data.x86 == 7))
+		__flush_tlb_all();
 }
 
 static void set_pmd_pte(pte_t *kpte, unsigned long address, pte_t pte) 
Index: linux/arch/x86/mm/pageattr_64.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_64.c
+++ linux/arch/x86/mm/pageattr_64.c
@@ -92,18 +92,18 @@ static void flush_kernel_map(void *arg)
 	struct flush_arg *a = (struct flush_arg *)arg;
 	struct flush *f;
 
-	if (!cpu_has_clflush)
-		a->full_flush = 1;
-
 	/* When clflush is available always use it because it is
 	   much cheaper than WBINVD. */
-	if (a->full_flush)
+	if (a->full_flush || !cpu_has_clflush)
 		asm volatile("wbinvd" ::: "memory");
 	list_for_each_entry(f, &a->l, l) {
 		if (!a->full_flush)
 			clflush_cache_range((void *)f->addr, PAGE_SIZE);
+		if (!a->full_flush)
+			__flush_tlb_one(f->addr);
 	}
-	__flush_tlb_all();
+	if (a->full_flush)
+		__flush_tlb_all();
 }
 
 /* both protected by init_mm.mmap_sem */
