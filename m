Return-Path: <linux-kernel-owner+w=401wt.eu-S1753192Ab0A3Jim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab0A3Jim (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 04:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114Ab0A3Jii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 04:38:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:41383 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027Ab0A3Jie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 04:38:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,373,1262592000"; 
   d="scan'208";a="536025105"
Message-Id: <20100130093704.007940597@intel.com>
User-Agent: quilt/0.48-1
Date: Sat, 30 Jan 2010 17:25:12 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
to: Andi Kleen <andi@firstfloor.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Wu Fengguang <fengguang.wu@intel.com>
cc: Nick Piggin <npiggin@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 3/4] hwpoison: prevent /dev/kcore from accessing hwpoison pages
References: <20100130092509.793222613@intel.com>
Content-Disposition: inline; filename=hwpoison-kcore.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Silently fill buffer with zeros when encounter hwpoison pages
(accessing the hwpoison page content is deadly).

This patch does not cover X86_32 - which has a dumb kern_addr_valid().
It is unlikely anyone run a 32bit kernel will care about the hwpoison
feature - its usable memory is limited.

CC: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org> 
CC: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 arch/x86/mm/init_64.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- linux-mm.orig/arch/x86/mm/init_64.c	2010-01-13 21:23:04.000000000 +0800
+++ linux-mm/arch/x86/mm/init_64.c	2010-01-13 21:25:32.000000000 +0800
@@ -825,6 +825,7 @@ int __init reserve_bootmem_generic(unsig
 int kern_addr_valid(unsigned long addr)
 {
 	unsigned long above = ((long)addr) >> __VIRTUAL_MASK_SHIFT;
+	unsigned long pfn;
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
@@ -845,14 +846,23 @@ int kern_addr_valid(unsigned long addr)
 	if (pmd_none(*pmd))
 		return 0;
 
-	if (pmd_large(*pmd))
-		return pfn_valid(pmd_pfn(*pmd));
+	if (pmd_large(*pmd)) {
+		pfn = pmd_pfn(*pmd);
+		pfn += pte_index(addr);
+		goto check_pfn;
+	}
 
 	pte = pte_offset_kernel(pmd, addr);
 	if (pte_none(*pte))
 		return 0;
 
-	return pfn_valid(pte_pfn(*pte));
+	pfn = pte_pfn(*pte);
+check_pfn:
+	if (!pfn_valid(pfn))
+		return 0;
+	if (PageHWPoison(pfn_to_page(pfn)))
+		return 0;
+	return 1;
 }
 
 /*


