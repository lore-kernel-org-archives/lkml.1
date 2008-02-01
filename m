Return-Path: <linux-kernel-owner+w=401wt.eu-S1764112AbYBAJ65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764112AbYBAJ65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760477AbYBAJzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:55:19 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:58490 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760100AbYBAJzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:55:17 -0500
From: Andi Kleen <ak@suse.de>
References: <200802011055.370582801@suse.de>
In-Reply-To: <200802011055.370582801@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/3] CPA: Only flush the cache if the caching attributes have changed.
Message-Id: <20080201095514.67B521B416F@basil.firstfloor.org>
Date: Fri,  1 Feb 2008 10:55:14 +0100 (CET)
X-OriginalArrivalTime: 01 Feb 2008 09:48:56.0923 (UTC) FILETIME=[A9B78AB0:01C864B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We only need to flush the caches in cpa() if the the caching attributes
have changed. Otherwise only flush the TLBs.

This checks the PAT bits too although they are currently not used by
the kernel.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr.c    |   28 +++++++++++++++++++---------
 include/asm-x86/pgtable.h |    4 ++++
 2 files changed, 23 insertions(+), 9 deletions(-)

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -54,21 +54,22 @@ void clflush_cache_range(void *vaddr, un
 
 static void __cpa_flush_all(void *arg)
 {
+	unsigned long cache = (unsigned long)arg;
 	/*
 	 * Flush all to work around Errata in early athlons regarding
 	 * large page flushing.
 	 */
 	__flush_tlb_all();
 
-	if (!cpu_has_ss && boot_cpu_data.x86_model >= 4)
+	if (cache && !cpu_has_ss && boot_cpu_data.x86_model >= 4)
 		wbinvd();
 }
 
-static void cpa_flush_all(void)
+static void cpa_flush_all(int cache)
 {
 	BUG_ON(irqs_disabled());
 
-	on_each_cpu(__cpa_flush_all, NULL, 1, 1);
+	on_each_cpu(__cpa_flush_all, (void *)(unsigned long)cache, 1, 1);
 }
 
 static void __cpa_flush_range(void *arg)
@@ -81,7 +82,7 @@ static void __cpa_flush_range(void *arg)
 	__flush_tlb_all();
 }
 
-static void cpa_flush_range(unsigned long start, int numpages)
+static void cpa_flush_range(unsigned long start, int numpages, int cache)
 {
 	unsigned int i, level;
 	unsigned long addr;
@@ -91,7 +92,7 @@ static void cpa_flush_range(unsigned lon
 
 	on_each_cpu(__cpa_flush_range, NULL, 1, 1);
 
-	if (cpu_has_ss)
+	if (!cache || cpu_has_ss)
 		return;
 
 	/*
@@ -395,7 +396,8 @@ static int __change_page_attr_set_clr(un
 }
 
 static int change_page_attr_set_clr(unsigned long addr, int numpages,
-				    pgprot_t mask_set, pgprot_t mask_clr)
+				    pgprot_t mask_set, pgprot_t mask_clr,
+				    int cache)
 {
 	int ret = __change_page_attr_set_clr(addr, numpages, mask_set,
 					     mask_clr);
@@ -407,23 +409,31 @@ static int change_page_attr_set_clr(unsi
 	 * wbindv):
 	 */
 	if (!ret && cpu_has_clflush)
-		cpa_flush_range(addr, numpages);
+		cpa_flush_range(addr, numpages, cache);
 	else
-		cpa_flush_all();
+		cpa_flush_all(cache);
 
 	return ret;
 }
 
+static int cache_attr(pgprot_t attr)
+{
+	if (pgprot_val(attr) & (_PAGE_PAT|_PAGE_PAT_LARGE|_PAGE_PWT|_PAGE_PCD))
+		return 1;
+	return 0;
+}
+
 static inline int change_page_attr_set(unsigned long addr, int numpages,
 				       pgprot_t mask)
 {
-	return change_page_attr_set_clr(addr, numpages, mask, __pgprot(0));
+	return change_page_attr_set_clr(addr, numpages, mask, __pgprot(0),
+					cache_attr(mask));
 }
 
 static inline int change_page_attr_clear(unsigned long addr, int numpages,
 					 pgprot_t mask)
 {
-	return change_page_attr_set_clr(addr, numpages, __pgprot(0), mask);
+	return change_page_attr_set_clr(addr, numpages, __pgprot(0), mask, 0);
 }
 
 int set_memory_uc(unsigned long addr, int numpages)
Index: linux/include/asm-x86/pgtable.h
===================================================================
--- linux.orig/include/asm-x86/pgtable.h
+++ linux/include/asm-x86/pgtable.h
@@ -13,10 +13,12 @@
 #define _PAGE_BIT_DIRTY		6
 #define _PAGE_BIT_FILE		6
 #define _PAGE_BIT_PSE		7	/* 4 MB (or 2MB) page */
+#define _PAGE_BIT_PAT		7	/* on 4KB pages */
 #define _PAGE_BIT_GLOBAL	8	/* Global TLB entry PPro+ */
 #define _PAGE_BIT_UNUSED1	9	/* available for programmer */
 #define _PAGE_BIT_UNUSED2	10
 #define _PAGE_BIT_UNUSED3	11
+#define _PAGE_BIT_PAT_LARGE	12	/* On 2MB or 1GB pages */
 #define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */
 
 /*
@@ -36,6 +38,8 @@
 #define _PAGE_UNUSED1	(_AC(1, L)<<_PAGE_BIT_UNUSED1)
 #define _PAGE_UNUSED2	(_AC(1, L)<<_PAGE_BIT_UNUSED2)
 #define _PAGE_UNUSED3	(_AC(1, L)<<_PAGE_BIT_UNUSED3)
+#define _PAGE_PAT	(_AC(1, L)<<_PAGE_BIT_PAT)
+#define _PAGE_PAT_LARGE (_AC(1, L)<<_PAGE_BIT_PAT_LARGE)
 
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 #define _PAGE_NX	(_AC(1, ULL) << _PAGE_BIT_NX)
