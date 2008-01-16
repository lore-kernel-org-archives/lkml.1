Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbYAPWQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbYAPWQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYAPWPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:15:08 -0500
Received: from ns2.suse.de ([195.135.220.15]:38225 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbYAPWPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:15:04 -0500
From: Andi Kleen <ak@suse.de>
References: <200801161114.239449000@suse.de>
In-Reply-To: <200801161114.239449000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com
Subject: [PATCH] [5/36] CPA: Implement change_page_attr_addr entry point for i386
Message-Id: <20080116221503.AA7BF150C8@wotan.suse.de>
Date: Wed, 16 Jan 2008 23:15:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Similar to 64bit.

Needed by PAT patches. Replaces 5ec5c5a2302ca8794da03f8bedec931a2a814ae9

Note: should probably be put before PAT patches to avoid bisect failures later

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/pageattr_32.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: linux/arch/x86/mm/pageattr_32.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_32.c
+++ linux/arch/x86/mm/pageattr_32.c
@@ -233,6 +233,21 @@ int change_page_attr(struct page *page, 
 	return err;
 }
 
+int change_page_attr_addr(unsigned long addr, int numpages, pgprot_t prot)
+{
+	int i;
+	unsigned long pfn = (addr >> PAGE_SHIFT);
+	for (i = 0; i < numpages; i++) {
+		if (!pfn_valid(pfn + i)) {
+			break;
+		} else {
+			pte_t *pte = lookup_address(addr + i*PAGE_SIZE);
+			BUG_ON(pte && !pte_none(*pte));
+		}
+	}
+	return change_page_attr(virt_to_page(addr), i, prot);
+}
+
 void global_flush_tlb(void)
 {
 	struct list_head l;
