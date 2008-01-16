Return-Path: <linux-kernel-owner+w=401wt.eu-S1756929AbYAPW1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbYAPW1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYAPWPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:15:51 -0500
Received: from mail.suse.de ([195.135.220.2]:55292 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196AbYAPWPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:15:35 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161114.239449000@suse.de>
In-Reply-To: <200801161114.239449000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com
Subject: [PATCH] [34/36] CPA: Add a BUG_ON checking for someone setting the kernel text NX
Message-Id: <20080116221534.87A44150C8@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:15:34 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Someone setting NX on the kernel text tends to result in nasty failures
and triple faults, so BUG_ON early for that.

Does not cover __inittext.

Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Jan Beulich <jbeulich@novell.com>

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
 
