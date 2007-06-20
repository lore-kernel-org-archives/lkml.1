Return-Path: <linux-kernel-owner+w=401wt.eu-S1763135AbXFTKYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763135AbXFTKYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 06:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759484AbXFTKXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 06:23:44 -0400
Received: from ns.suse.de ([195.135.220.2]:48424 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756957AbXFTKXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 06:23:38 -0400
From: Andi Kleen <ak@suse.de>
References: <200706201223.443613000@suse.de>
In-Reply-To: <200706201223.443613000@suse.de>
To: torvalds@osdl.org, linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH for 2.6.22] [8/10] x86: change_page_attr bandaids
Message-Id: <20070620102337.0730614AD0@wotan.suse.de>
Date: Wed, 20 Jun 2007 12:23:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


- Disable CLFLUSH again; it is still broken. Always do WBINVD.
- Always flush in the i386 case, not only when there are deferred pages.

These are both brute-force inefficient fixes, to be improved
next release cycle.

The changes to i386 are a little more extensive than strictly 
needed (some dead code added), but it is more similar to the x86-64 version 
now and the dead code will be used soon.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/mm/pageattr.c   |   30 ++++++++++++++++++------------
 arch/x86_64/mm/pageattr.c |    7 ++++---
 2 files changed, 22 insertions(+), 15 deletions(-)

Index: linux/arch/i386/mm/pageattr.c
===================================================================
--- linux.orig/arch/i386/mm/pageattr.c
+++ linux/arch/i386/mm/pageattr.c
@@ -68,14 +68,23 @@ static struct page *split_large_page(uns
 	return base;
 } 
 
-static void flush_kernel_map(void *arg)
+static void cache_flush_page(struct page *p)
 { 
-	unsigned long adr = (unsigned long)arg;
+	unsigned long adr = (unsigned long)page_address(p);
+	int i;
+	for (i = 0; i < PAGE_SIZE; i += boot_cpu_data.x86_clflush_size)
+		asm volatile("clflush (%0)" :: "r" (adr + i));
+}
+
+static void flush_kernel_map(void *arg)
+{
+	struct list_head *lh = (struct list_head *)arg;
+	struct page *p;
 
-	if (adr && cpu_has_clflush) {
-		int i;
-		for (i = 0; i < PAGE_SIZE; i += boot_cpu_data.x86_clflush_size)
-			asm volatile("clflush (%0)" :: "r" (adr + i));
+	/* High level code is not ready for clflush yet */
+	if (0 && cpu_has_clflush) {
+		list_for_each_entry (p, lh, lru)
+			cache_flush_page(p);
 	} else if (boot_cpu_data.x86_model >= 4)
 		wbinvd();
 
@@ -181,9 +190,9 @@ __change_page_attr(struct page *page, pg
 	return 0;
 } 
 
-static inline void flush_map(void *adr)
+static inline void flush_map(struct list_head *l)
 {
-	on_each_cpu(flush_kernel_map, adr, 1, 1);
+	on_each_cpu(flush_kernel_map, l, 1, 1);
 }
 
 /*
@@ -225,11 +234,8 @@ void global_flush_tlb(void)
 	spin_lock_irq(&cpa_lock);
 	list_replace_init(&df_list, &l);
 	spin_unlock_irq(&cpa_lock);
-	if (!cpu_has_clflush)
-		flush_map(NULL);
+	flush_map(&l);
 	list_for_each_entry_safe(pg, next, &l, lru) {
-		if (cpu_has_clflush)
-			flush_map(page_address(pg));
 		__free_page(pg);
 	}
 }
Index: linux/arch/x86_64/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86_64/mm/pageattr.c
+++ linux/arch/x86_64/mm/pageattr.c
@@ -74,10 +74,11 @@ static void flush_kernel_map(void *arg)
 	struct page *pg;
 
 	/* When clflush is available always use it because it is
-	   much cheaper than WBINVD */
-	if (!cpu_has_clflush)
+	   much cheaper than WBINVD. Disable clflush for now because
+	   the high level code is not ready yet */
+	if (1 || !cpu_has_clflush)
 		asm volatile("wbinvd" ::: "memory");
-	list_for_each_entry(pg, l, lru) {
+	else list_for_each_entry(pg, l, lru) {
 		void *adr = page_address(pg);
 		if (cpu_has_clflush)
 			cache_flush_page(adr);
