Return-Path: <linux-kernel-owner+w=401wt.eu-S1758019AbYFCCCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbYFCCCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 22:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbYFCB70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 21:59:26 -0400
Received: from saeurebad.de ([85.214.36.134]:39541 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757195AbYFCB7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 21:59:24 -0400
X-Mailbox-Line: From hannes@saeurebad.de Tue Jun  3 02:53:04 2008
Message-Id: <20080603005304.502005553@saeurebad.de>
References: <20080603005017.593345596@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jun 2008 02:50:30 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, Yasunori Goto <y-goto@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 13/14] bootmem: revisit alloc_bootmem_section
Content-Disposition: inline; filename=bootmem-revisit-alloc_bootmem_section.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since alloc_bootmem_core does no goal-fallback anymore and just
returns NULL if the allocation fails, we might now use it in
alloc_bootmem_section without all the fixup code for a misplaced
allocation.

Also, the limit can be the first PFN of the next section as the
semantics is that the limit is _above_ the allocated region, not
within.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Yasunori Goto <y-goto@jp.fujitsu.com>
---

 mm/bootmem.c |   27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -674,29 +674,14 @@ void * __init __alloc_bootmem_low_node(p
 void * __init alloc_bootmem_section(unsigned long size,
 				    unsigned long section_nr)
 {
-	void *ptr;
-	unsigned long limit, goal, start_nr, end_nr, pfn;
-	struct pglist_data *pgdat;
+	bootmem_data_t *bdata;
+	unsigned long pfn, goal, limit;
 
 	pfn = section_nr_to_pfn(section_nr);
-	goal = PFN_PHYS(pfn);
-	limit = PFN_PHYS(section_nr_to_pfn(section_nr + 1)) - 1;
-	pgdat = NODE_DATA(early_pfn_to_nid(pfn));
-	ptr = alloc_bootmem_core(pgdat->bdata, size, SMP_CACHE_BYTES, goal,
-				limit);
+	goal = pfn << PAGE_SHIFT;
+	limit = section_nr_to_pfn(section_nr + 1) << PAGE_SHIFT;
+	bdata = &bootmem_node_data[early_pfn_to_nid(pfn)];
 
-	if (!ptr)
-		return NULL;
-
-	start_nr = pfn_to_section_nr(PFN_DOWN(__pa(ptr)));
-	end_nr = pfn_to_section_nr(PFN_DOWN(__pa(ptr) + size));
-	if (start_nr != section_nr || end_nr != section_nr) {
-		printk(KERN_WARNING "alloc_bootmem failed on section %ld.\n",
-		       section_nr);
-		free_bootmem_node(pgdat, __pa(ptr), size);
-		ptr = NULL;
-	}
-
-	return ptr;
+	return alloc_bootmem_core(bdata, size, SMP_CACHE_BYTES, goal, limit);
 }
 #endif

-- 

