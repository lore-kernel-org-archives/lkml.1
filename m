Return-Path: <linux-kernel-owner+w=401wt.eu-S933445AbXIUWvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933445AbXIUWvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763195AbXIUWcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:40522 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759648AbXIUWct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:49 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: jbeulich@novell.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [47/50] i386: avoid temporarily inconsistent pte-s
Message-Id: <20070921223247.DBC0013DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
One more of these issues (which were considered fixed a few releases
back): Other than on x86-64, i386 allows set_fixmap() to replace
already present mappings. Consequently, on PAE, care must be taken to
not update the high half of a pte while the low half is still holding
the old value.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

 arch/i386/mm/pgtable.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux/arch/i386/mm/pgtable.c
===================================================================
--- linux.orig/arch/i386/mm/pgtable.c
+++ linux/arch/i386/mm/pgtable.c
@@ -97,8 +97,7 @@ static void set_pte_pfn(unsigned long va
 	}
 	pte = pte_offset_kernel(pmd, vaddr);
 	if (pgprot_val(flags))
-		/* <pfn,flags> stored as-is, to permit clearing entries */
-		set_pte(pte, pfn_pte(pfn, flags));
+		set_pte_present(&init_mm, vaddr, pte, pfn_pte(pfn, flags));
 	else
 		pte_clear(&init_mm, vaddr, pte);
 
