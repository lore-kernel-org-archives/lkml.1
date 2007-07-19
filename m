Return-Path: <linux-kernel-owner+w=401wt.eu-S938179AbXGSKUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938179AbXGSKUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759680AbXGSJ4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:56:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:35426 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759549AbXGSJzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:37 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: rientjes@google.com, mel@csn.ul.ie, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [44/58] x86_64: extract helper function from e820_register_active_regions
Message-Id: <20070719095530.B5F6514E05@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: David Rientjes <rientjes@google.com>

The logic in e820_find_active_regions() for determining the true active
regions for an e820 entry given a range of PFN's is needed for
e820_hole_size() as well.

e820_hole_size() is called from the NUMA emulation code to determine the
reserved area within an address range on a per-node basis.  Its logic should
duplicate that of finding active regions in an e820 entry because these are
the only true ranges we may register anyway.

[akpm@linux-foundation.org: cleanup]
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/e820.c |   82 ++++++++++++++++++++++++++--------------------
 1 file changed, 48 insertions(+), 34 deletions(-)

Index: linux/arch/x86_64/kernel/e820.c
===================================================================
--- linux.orig/arch/x86_64/kernel/e820.c
+++ linux/arch/x86_64/kernel/e820.c
@@ -289,47 +289,61 @@ void __init e820_mark_nosave_regions(voi
 	}
 }
 
+/*
+ * Finds an active region in the address range from start_pfn to end_pfn and
+ * returns its range in ei_startpfn and ei_endpfn for the e820 entry.
+ */
+static int __init e820_find_active_region(const struct e820entry *ei,
+					  unsigned long start_pfn,
+					  unsigned long end_pfn,
+					  unsigned long *ei_startpfn,
+					  unsigned long *ei_endpfn)
+{
+	*ei_startpfn = round_up(ei->addr, PAGE_SIZE) >> PAGE_SHIFT;
+	*ei_endpfn = round_down(ei->addr + ei->size, PAGE_SIZE) >> PAGE_SHIFT;
+
+	/* Skip map entries smaller than a page */
+	if (*ei_startpfn >= *ei_endpfn)
+		return 0;
+
+	/* Check if end_pfn_map should be updated */
+	if (ei->type != E820_RAM && *ei_endpfn > end_pfn_map)
+		end_pfn_map = *ei_endpfn;
+
+	/* Skip if map is outside the node */
+	if (ei->type != E820_RAM || *ei_endpfn <= start_pfn ||
+				    *ei_startpfn >= end_pfn)
+		return 0;
+
+	/* Check for overlaps */
+	if (*ei_startpfn < start_pfn)
+		*ei_startpfn = start_pfn;
+	if (*ei_endpfn > end_pfn)
+		*ei_endpfn = end_pfn;
+
+	/* Obey end_user_pfn to save on memmap */
+	if (*ei_startpfn >= end_user_pfn)
+		return 0;
+	if (*ei_endpfn > end_user_pfn)
+		*ei_endpfn = end_user_pfn;
+
+	return 1;
+}
+
 /* Walk the e820 map and register active regions within a node */
 void __init
 e820_register_active_regions(int nid, unsigned long start_pfn,
 							unsigned long end_pfn)
 {
+	unsigned long ei_startpfn;
+	unsigned long ei_endpfn;
 	int i;
-	unsigned long ei_startpfn, ei_endpfn;
-	for (i = 0; i < e820.nr_map; i++) {
-		struct e820entry *ei = &e820.map[i];
-		ei_startpfn = round_up(ei->addr, PAGE_SIZE) >> PAGE_SHIFT;
-		ei_endpfn = round_down(ei->addr + ei->size, PAGE_SIZE)
-								>> PAGE_SHIFT;
-
-		/* Skip map entries smaller than a page */
-		if (ei_startpfn >= ei_endpfn)
-			continue;
-
-		/* Check if end_pfn_map should be updated */
-		if (ei->type != E820_RAM && ei_endpfn > end_pfn_map)
-			end_pfn_map = ei_endpfn;
-
-		/* Skip if map is outside the node */
-		if (ei->type != E820_RAM ||
-				ei_endpfn <= start_pfn ||
-				ei_startpfn >= end_pfn)
-			continue;
-
-		/* Check for overlaps */
-		if (ei_startpfn < start_pfn)
-			ei_startpfn = start_pfn;
-		if (ei_endpfn > end_pfn)
-			ei_endpfn = end_pfn;
-
-		/* Obey end_user_pfn to save on memmap */
-		if (ei_startpfn >= end_user_pfn)
-			continue;
-		if (ei_endpfn > end_user_pfn)
-			ei_endpfn = end_user_pfn;
 
-		add_active_range(nid, ei_startpfn, ei_endpfn);
-	}
+	for (i = 0; i < e820.nr_map; i++)
+		if (e820_find_active_region(&e820.map[i],
+					    start_pfn, end_pfn,
+					    &ei_startpfn, &ei_endpfn))
+			add_active_range(nid, ei_startpfn, ei_endpfn);
 }
 
 /* 
