Return-Path: <linux-kernel-owner+w=401wt.eu-S932471AbXIUWn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471AbXIUWn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763984AbXIUWci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:38 -0400
Received: from ns2.suse.de ([195.135.220.15]:40492 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762786AbXIUWca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:30 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: jbeulich@novell.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [29/50] x86: honor _PAGE_PSE bit on page walks
Message-Id: <20070921223228.B2DD313DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

 arch/i386/mm/fault.c   |    3 ++-
 arch/x86_64/mm/fault.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

Index: linux/arch/i386/mm/fault.c
===================================================================
--- linux.orig/arch/i386/mm/fault.c
+++ linux/arch/i386/mm/fault.c
@@ -569,7 +569,8 @@ no_context:
 		 * it's allocated already.
 		 */
 		if ((page >> PAGE_SHIFT) < max_low_pfn
-		    && (page & _PAGE_PRESENT)) {
+		    && (page & _PAGE_PRESENT)
+		    && !(page & _PAGE_PSE)) {
 			page &= PAGE_MASK;
 			page = ((__typeof__(page) *) __va(page))[(address >> PAGE_SHIFT)
 			                                         & (PTRS_PER_PTE - 1)];
Index: linux/arch/x86_64/mm/fault.c
===================================================================
--- linux.orig/arch/x86_64/mm/fault.c
+++ linux/arch/x86_64/mm/fault.c
@@ -175,7 +175,7 @@ void dump_pagetable(unsigned long addres
 	pmd = pmd_offset(pud, address);
 	if (bad_address(pmd)) goto bad;
 	printk("PMD %lx ", pmd_val(*pmd));
-	if (!pmd_present(*pmd))	goto ret;	 
+	if (!pmd_present(*pmd) || pmd_large(*pmd)) goto ret;
 
 	pte = pte_offset_kernel(pmd, address);
 	if (bad_address(pte)) goto bad;
