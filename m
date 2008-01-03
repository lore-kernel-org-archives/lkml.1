Return-Path: <linux-kernel-owner+w=401wt.eu-S1759475AbYACPcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475AbYACPcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbYACPYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:24:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:43038 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754679AbYACPYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:24:44 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103424.989432000@suse.de>
In-Reply-To: <20080103424.989432000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH CPA] [28/28] Make kernel_text test match boot mapping initialization
Message-Id: <20080103152443.CA76214E23@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:24:43 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The boot direct mapping initialization used a different test to check if a 
page was part of the kernel mapping than c_p_a(). Fix that. Also 
round up to a large page size to be sure.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr_32.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux/arch/x86/mm/pageattr_32.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_32.c
+++ linux/arch/x86/mm/pageattr_32.c
@@ -183,6 +183,12 @@ static int cache_attr_changed(pte_t pte,
 	return a != (pgprot_val(prot) & _PAGE_CACHE);
 }
 
+static int text_address(unsigned long addr)
+{
+	unsigned long end = ((unsigned long)__init_end & LARGE_PAGE_MASK);
+	return addr < end + LARGE_PAGE_SIZE;
+}
+
 /*
  * Mark the address for flushing later in global_tlb_flush().
  *
@@ -237,7 +243,7 @@ __change_page_attr(struct page *page, pg
 	set_tlb_flush(address, cache_attr_changed(*kpte, prot, level),
 			level < 3);
 
-	if ((address & LARGE_PAGE_MASK) < (unsigned long)&_etext)
+	if (text_address(address))
 		ref_prot = PAGE_KERNEL_EXEC;
 
 	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL)) { 
