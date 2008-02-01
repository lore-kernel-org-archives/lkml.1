Return-Path: <linux-kernel-owner+w=401wt.eu-S1761373AbYBAJ41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761373AbYBAJ41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756913AbYBAJx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:53:26 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:49563 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877AbYBAJxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:53:24 -0500
From: Andi Kleen <ak@suse.de>
References: <200802011053.107168490@suse.de>
In-Reply-To: <200802011053.107168490@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [8/12] GBPAGES: Implement gbpages support in change_page_attr() 
Message-Id: <20080201095321.506401B416F@basil.firstfloor.org>
Date: Fri,  1 Feb 2008 10:53:21 +0100 (CET)
X-OriginalArrivalTime: 01 Feb 2008 09:47:03.0890 (UTC) FILETIME=[66581320:01C864B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -203,6 +203,7 @@ static int split_large_page(pte_t *kpte,
 	pte_t *pbase, *tmp;
 	struct page *base;
 	unsigned int i, level;
+	unsigned long ps;
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 	gfp_flags = __GFP_HIGH | __GFP_NOFAIL | __GFP_NOWARN;
@@ -225,13 +226,23 @@ static int split_large_page(pte_t *kpte,
 
 	address = __pa(address);
 	addr = address & PMD_PAGE_MASK;
+
+	ps = PAGE_SIZE;
+#ifdef CONFIG_X86_64
+	if (level == PG_LEVEL_1G) {
+		ps = PMD_PAGE_SIZE;
+		pgprot_val(ref_prot) |= _PAGE_PSE;
+		addr &= PUD_PAGE_MASK;
+	}
+#endif
+
 	pbase = (pte_t *)page_address(base);
 #ifdef CONFIG_X86_32
 	paravirt_alloc_pt(&init_mm, page_to_pfn(base));
 #endif
 
 	pgprot_val(ref_prot) &= ~_PAGE_NX;
-	for (i = 0; i < PTRS_PER_PTE; i++, addr += PAGE_SIZE)
+	for (i = 0; i < PTRS_PER_PTE; i++, addr += ps)
 		set_pte(&pbase[i], pfn_pte(addr >> PAGE_SHIFT, ref_prot));
 
 	/*
