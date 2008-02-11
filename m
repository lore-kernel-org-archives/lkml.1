Return-Path: <linux-kernel-owner+w=401wt.eu-S1751944AbYBKJeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbYBKJeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 04:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbYBKJee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 04:34:34 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:29275 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbYBKJed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:34:33 -0500
From: Andi Kleen <ak@suse.de>
References: <200802111034.764275766@suse.de>
In-Reply-To: <200802111034.764275766@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/8] CPA: Flush the caches when setting pages not present
Message-Id: <20080211093430.D198A1B41CE@basil.firstfloor.org>
Date: Mon, 11 Feb 2008 10:34:30 +0100 (CET)
X-OriginalArrivalTime: 11 Feb 2008 09:28:10.0005 (UTC) FILETIME=[6AA07450:01C86C90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


e.g. the AMD64 pci-gart code sets pages not present to prevent potential 
cache coherency problems.  When doing this it is probably safer to flush the 
caches too. So consider clearing of the present bit as a cache flush indicator.

Note that debug pagealloc marks pages regularly not present either, but it won't
call this because it calls directly into a lower level function.

I have not actually seen failures from this, but it seems safer 
to do it this way.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -670,9 +670,16 @@ static int __change_page_attr_set_clr(st
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
 
@@ -709,7 +716,7 @@ static int change_page_attr_set_clr(unsi
 	 * No need to flush, when we did not set any of the caching
 	 * attributes:
 	 */
-	cache = cache_attr(mask_set);
+	cache = cache_attr(mask_set, mask_clr);
 
 	/*
 	 * On success we use clflush, when the CPU supports it to
