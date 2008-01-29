Return-Path: <linux-kernel-owner+w=401wt.eu-S1759786AbYA2FKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759786AbYA2FKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 00:10:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756409AbYA2FGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 00:06:39 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:16142 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976AbYA2FGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 00:06:38 -0500
From: Andi Kleen <ak@suse.de>
References: <20080129606.610336873@suse.de>
In-Reply-To: <20080129606.610336873@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [8/9] GBPAGES: Implement gbpages support in change_page_attr() 
Message-Id: <20080129050636.B98901B416E@basil.firstfloor.org>
Date: Tue, 29 Jan 2008 06:06:36 +0100 (CET)
X-OriginalArrivalTime: 29 Jan 2008 05:00:20.0377 (UTC) FILETIME=[D9031090:01C86233]
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
 	int i, level;
+	unsigned long ps;
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 	gfp_flags = GFP_ATOMIC;
@@ -224,12 +225,22 @@ static int split_large_page(pte_t *kpte,
 
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
 
-	for (i = 0; i < PTRS_PER_PTE; i++, addr += PAGE_SIZE)
+	for (i = 0; i < PTRS_PER_PTE; i++, addr += ps)
 		set_pte(&pbase[i], pfn_pte(addr >> PAGE_SHIFT, ref_prot));
 
 	/*
