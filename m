Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbYAPWX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbYAPWX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbYAPWPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:15:36 -0500
Received: from ns.suse.de ([195.135.220.2]:55238 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124AbYAPWPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:15:24 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161114.239449000@suse.de>
In-Reply-To: <200801161114.239449000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com
Subject: [PATCH] [23/36] CPA: Make change_page_attr() more robust against use of PAT bits
Message-Id: <20080116221522.C87DB150C8@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:15:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the page table level instead of the PSE bit to check if the PTE 
is for a 4K page or not. This makes the code more robust when the PAT
bit is changed because the PAT bit on 4K pages is in the same position as the
PSE bit.

Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/mm/pageattr_32.c |    4 ++--
 arch/x86/mm/pageattr_64.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: linux/arch/x86/mm/pageattr_32.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_32.c
+++ linux/arch/x86/mm/pageattr_32.c
@@ -209,7 +209,7 @@ __change_page_attr(struct page *page, pg
 	set_tlb_flush(address);
 
 	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL)) { 
-		if (!pte_huge(*kpte)) {
+		if (level == 3) {
 			set_pte_atomic(kpte, mk_pte(page, prot)); 
 		} else {
 			pgprot_t ref_prot;
@@ -225,7 +225,7 @@ __change_page_attr(struct page *page, pg
 			kpte_page = split;
 		}
 		page_private(kpte_page)++;
-	} else if (!pte_huge(*kpte)) {
+	} else if (level == 3) {
 		set_pte_atomic(kpte, mk_pte(page, PAGE_KERNEL));
 		BUG_ON(page_private(kpte_page) == 0);
 		page_private(kpte_page)--;
Index: linux/arch/x86/mm/pageattr_64.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_64.c
+++ linux/arch/x86/mm/pageattr_64.c
@@ -184,7 +184,7 @@ __change_page_attr(unsigned long address
 	set_tlb_flush(address);
 
 	if (pgprot_val(prot) != pgprot_val(ref_prot)) { 
-		if (!pte_huge(*kpte)) {
+		if (level == 4) {
 			set_pte(kpte, pfn_pte(pfn, prot));
 		} else {
 			/*
@@ -201,7 +201,7 @@ __change_page_attr(unsigned long address
 			kpte_page = split;
 		}
 		page_private(kpte_page)++;
-	} else if (!pte_huge(*kpte)) {
+	} else if (level == 4) {
 		set_pte(kpte, pfn_pte(pfn, ref_prot));
 		BUG_ON(page_private(kpte_page) == 0);
 		page_private(kpte_page)--;
