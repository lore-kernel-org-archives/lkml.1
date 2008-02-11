Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbYBKNQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbYBKNQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 08:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYBKNQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 08:16:11 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:27214 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbYBKNQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 08:16:11 -0500
From: Andi Kleen <ak@suse.de>
Message-Id: <20080211216.571751871@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/1] CPA: Flush the caches when setting pages not present v2
Date: Mon, 11 Feb 2008 14:16:07 +0100 (CET)
X-OriginalArrivalTime: 11 Feb 2008 13:09:46.0515 (UTC) FILETIME=[5FF6DE30:01C86CAF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The AMD64 pci-gart code sets pages not present to prevent
cache coherency problems.  When doing this it is safer to flush the 
caches too so that there are no cache lines left over from when 
the pages were still mapped. 

So consider clearing of the present bit as a cache flush indicator.

Note that debug pagealloc marks pages regularly not present either, but it won't
call this because it calls directly into a lower level function.

I have not actually seen failures from this, but it seems safer 
to do it this way.

v2: Force WBINVD in this case because CLFLUSH does not work for !P pages.
    Improve description slightly.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -122,6 +122,14 @@ static void cpa_flush_range(unsigned lon
 		 */
 		if (pte && (pte_val(*pte) & _PAGE_PRESENT))
 			clflush_cache_range((void *) addr, PAGE_SIZE);
+		else {
+			/*
+			 * Make sure there are no left overs of pages
+			 * set non present in the cache.
+			 */
+			cpa_flush_all(cache);
+			return;
+		}
 	}
 }
 
@@ -670,9 +678,16 @@ static int __change_page_attr_set_clr(st
 	return 0;
 }
 
-static inline int cache_attr(pgprot_t attr)
+static inline int cache_attr(pgprot_t set, pgprot_t clr)
 {
-	return pgprot_val(attr) &
+	/*
+	 * Clearing pages is usually done for cache cohereny reasons
+	 * (except for pagealloc debug, but that doesn't call this anyways)
+	 * It's safer to flush the caches in this case too.
+	 */
+	if (pgprot_val(clr) & _PAGE_PRESENT)
+		return 1;
+	return pgprot_val(set) &
 		(_PAGE_PAT | _PAGE_PAT_LARGE | _PAGE_PWT | _PAGE_PCD);
 }
 
@@ -709,7 +724,7 @@ static int change_page_attr_set_clr(unsi
 	 * No need to flush, when we did not set any of the caching
 	 * attributes:
 	 */
-	cache = cache_attr(mask_set);
+	cache = cache_attr(mask_set, mask_clr);
 
 	/*
 	 * On success we use clflush, when the CPU supports it to
