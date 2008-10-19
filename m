Return-Path: <linux-kernel-owner+w=401wt.eu-S1751890AbYJSRU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbYJSRU2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 13:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYJSRUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 13:20:20 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:59899 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbYJSRUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 13:20:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=UHRZLqT4TfRNclrM2VUVTCmxBWC88h8RI9VgQt/0OyoVFG0nho9n+erQKtLWx7EXAG
         tRk/Elqa5y+CER3NE6hP4ik9Xq+Ykonr9WP5Sk4wEC1dgRqCUMvBUa3tU9OFcknZtUTV
         QSM/Ev4by0W870LBo5CprAX8u1uOpHGnkrRcE=
Date: Sun, 19 Oct 2008 19:20:41 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [PATCH] kmemcheck: (finally) use 4k pages for identity mapping
Message-ID: <20081019172041.GA3258@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 760932c8607b736504a134ed6feec25e90e089ac Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Sun, 19 Oct 2008 15:28:04 +0200
Subject: [PATCH] kmemcheck: (finally) use 4k pages for identity mapping

At last I found the right hooks for doing this properly. DEBUG_PAGEALLOC
has the exact same requirement: Kernel pages must be mapped with 4k
physical pages (since that's the size of pages returned by the page
allocator).

Now we finally get rid of the need to do set_memory_4k() or try to work
around TLB flushing from interrupt context. Yay!

Has been tested on both 32- and 64-bit on a P4 and a Dual Core.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/kernel/cpu/common.c      |    7 -------
 arch/x86/mm/init_32.c             |    2 +-
 arch/x86/mm/init_64.c             |    2 +-
 arch/x86/mm/kmemcheck/kmemcheck.c |    4 ----
 mm/kmemcheck.c                    |    8 --------
 5 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 5613afb..ff26d87 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -575,13 +575,6 @@ void __init early_cpu_init(void)
 	}
 
 	early_identify_cpu(&boot_cpu_data);
-
-#ifdef CONFIG_KMEMCHECK
-	/*
-	 * We need 4K granular PTEs for kmemcheck:
-	 */
-	setup_clear_cpu_cap(X86_FEATURE_PSE);
-#endif
 }
 
 /*
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 39e6a93..6ef3ef8 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -825,7 +825,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	pgd_t *pgd_base = swapper_pg_dir;
 	unsigned long start_pfn, end_pfn;
 	unsigned long big_page_start;
-#ifdef CONFIG_DEBUG_PAGEALLOC
+#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
 	/*
 	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
 	 * This will simplify cpa(), which otherwise needs to support splitting
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index b8e461d..99d7791 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -682,7 +682,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	if (!after_bootmem)
 		init_gbpages();
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
+#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
 	/*
 	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
 	 * This will simplify cpa(), which otherwise needs to support splitting
diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
index bd739a4..056b4f1 100644
--- a/arch/x86/mm/kmemcheck/kmemcheck.c
+++ b/arch/x86/mm/kmemcheck/kmemcheck.c
@@ -295,10 +295,6 @@ void kmemcheck_hide_pages(struct page *p, unsigned int n)
 {
 	unsigned int i;
 
-#ifdef CONFIG_X86_64
-	set_memory_4k((unsigned long) page_address(p), n);
-#endif
-
 	for (i = 0; i < n; ++i) {
 		unsigned long address;
 		pte_t *pte;
diff --git a/mm/kmemcheck.c b/mm/kmemcheck.c
index ffe5a8c..eaa41b8 100644
--- a/mm/kmemcheck.c
+++ b/mm/kmemcheck.c
@@ -10,14 +10,6 @@ void kmemcheck_alloc_shadow(struct kmem_cache *s, gfp_t flags, int node,
 	int pages;
 	int i;
 
-#ifdef CONFIG_X86_64
-	/* XXX: x86_64 doesn't honour PSE capabilities, so we need the call
-	 * to set_memory_4k(). However, that one wants to flush all CPUs,
-	 * which doesn't work when irqs are disabled. Temporary hack: */
-	if (irqs_disabled())
-		return;
-#endif
-
 	pages = 1 << order;
 
 	/*
-- 
1.5.5.1

