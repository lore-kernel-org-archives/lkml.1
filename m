Return-Path: <linux-kernel-owner+w=401wt.eu-S1752644AbYCLCyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbYCLCyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 22:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYCLCxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 22:53:33 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:9280 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbYCLCxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 22:53:31 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080312353.598285931@firstfloor.org>
In-Reply-To: <20080312353.598285931@firstfloor.org>
To: andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [3/7] Add set_memory_4k to pageattr.c
Message-Id: <20080312025329.A74C71B41D1@basil.firstfloor.org>
Date: Wed, 12 Mar 2008 03:53:29 +0100 (CET)
X-OriginalArrivalTime: 12 Mar 2008 02:46:57.0551 (UTC) FILETIME=[56B7F9F0:01C883EB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add a new function to force split large pages into 4k pages.
This is needed for some followup optimizations.

I had to add a new field to cpa_data to pass down the information
that try_preserve_large_page should not run.

Right now no set_page_4k() because I didn't need it and all the
specialized users I have in mind would be more comfortable with
pure addresses. I also didn't export it because it's unlikely
external code needs it.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -28,6 +28,7 @@ struct cpa_data {
 	int		numpages;
 	int		flushtlb;
 	unsigned long	pfn;
+	unsigned	force_split : 1;
 };
 
 #ifdef CONFIG_X86_64
@@ -259,6 +260,9 @@ try_preserve_large_page(pte_t *kpte, uns
 	int i, do_split = 1;
 	unsigned int level;
 
+	if (cpa->force_split)
+		return 1;
+
 	spin_lock_irqsave(&pgd_lock, flags);
 	/*
 	 * Check for races, another CPU might have split this page
@@ -693,7 +697,8 @@ static inline int cache_attr(pgprot_t at
 }
 
 static int change_page_attr_set_clr(unsigned long addr, int numpages,
-				    pgprot_t mask_set, pgprot_t mask_clr)
+				    pgprot_t mask_set, pgprot_t mask_clr,
+				    int force_split)
 {
 	struct cpa_data cpa;
 	int ret, cache, checkalias;
@@ -704,7 +709,7 @@ static int change_page_attr_set_clr(unsi
 	 */
 	mask_set = canon_pgprot(mask_set);
 	mask_clr = canon_pgprot(mask_clr);
-	if (!pgprot_val(mask_set) && !pgprot_val(mask_clr))
+	if (!pgprot_val(mask_set) && !pgprot_val(mask_clr) && !force_split)
 		return 0;
 
 	/* Ensure we are PAGE_SIZE aligned */
@@ -721,6 +726,7 @@ static int change_page_attr_set_clr(unsi
 	cpa.mask_set = mask_set;
 	cpa.mask_clr = mask_clr;
 	cpa.flushtlb = 0;
+	cpa.force_split = force_split;
 
 	/* No alias checking for _NX bit modifications */
 	checkalias = (pgprot_val(mask_set) | pgprot_val(mask_clr)) != _PAGE_NX;
@@ -759,13 +765,13 @@ out:
 static inline int change_page_attr_set(unsigned long addr, int numpages,
 				       pgprot_t mask)
 {
-	return change_page_attr_set_clr(addr, numpages, mask, __pgprot(0));
+	return change_page_attr_set_clr(addr, numpages, mask, __pgprot(0), 0);
 }
 
 static inline int change_page_attr_clear(unsigned long addr, int numpages,
 					 pgprot_t mask)
 {
-	return change_page_attr_set_clr(addr, numpages, __pgprot(0), mask);
+	return change_page_attr_set_clr(addr, numpages, __pgprot(0), mask, 0);
 }
 
 int set_memory_uc(unsigned long addr, int numpages)
@@ -809,6 +815,12 @@ int set_memory_np(unsigned long addr, in
 	return change_page_attr_clear(addr, numpages, __pgprot(_PAGE_PRESENT));
 }
 
+int set_memory_4k(unsigned long addr, int numpages)
+{
+	return change_page_attr_set_clr(addr, numpages, __pgprot(0),
+					__pgprot(0), 1);
+}
+
 int set_pages_uc(struct page *page, int numpages)
 {
 	unsigned long addr = (unsigned long)page_address(page);
Index: linux/include/asm-x86/cacheflush.h
===================================================================
--- linux.orig/include/asm-x86/cacheflush.h
+++ linux/include/asm-x86/cacheflush.h
@@ -41,6 +41,7 @@ int set_memory_nx(unsigned long addr, in
 int set_memory_ro(unsigned long addr, int numpages);
 int set_memory_rw(unsigned long addr, int numpages);
 int set_memory_np(unsigned long addr, int numpages);
+int set_memory_4k(unsigned long addr, int numpages);
 
 void clflush_cache_range(void *addr, unsigned int size);
 
