Return-Path: <linux-kernel-owner+w=401wt.eu-S1758140AbYANW1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbYANW1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYANWRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:17:19 -0500
Received: from ns1.suse.de ([195.135.220.2]:60114 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbYANWRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:17:04 -0500
From: Andi Kleen <ak@suse.de>
References: <200801141116.534682000@suse.de>
In-Reply-To: <200801141116.534682000@suse.de>
To: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [29/31] CPA: Add a BUG_ON checking for someone setting the kernel text NX
Message-Id: <20080114221702.9598914F83@wotan.suse.de>
Date: Mon, 14 Jan 2008 23:17:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Someone setting NX on the kernel text tends to result in nasty failures
and triple faults, so BUG_ON early for that.

Does not cover __inittext.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr_32.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux/arch/x86/mm/pageattr_32.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_32.c
+++ linux/arch/x86/mm/pageattr_32.c
@@ -242,6 +242,14 @@ __change_page_attr(struct page *page, pg
 	BUG_ON(PageLRU(kpte_page));
 	BUG_ON(PageCompound(kpte_page));
 
+	/*
+	 * Better fail early if someone sets the kernel text to NX.
+	 * Does not cover __inittext
+	 */
+	BUG_ON(address >= (unsigned long)&_text &&
+		address < (unsigned long)&_etext &&
+	       (pgprot_val(prot) & _PAGE_NX));
+
 	set_tlb_flush(address, cache_attr_changed(*kpte, prot, level),
 			level < 3);
 
