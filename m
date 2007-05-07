Return-Path: <linux-kernel-owner+w=401wt.eu-S934196AbXEGO2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934196AbXEGO2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 10:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934192AbXEGO2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 10:28:50 -0400
Received: from smtp-out.google.com ([216.239.45.13]:46089 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934168AbXEGO2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 10:28:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=mW9Y26PDq+S5u8xdEW59Zea6etMcbrbGBJyl7NOtmzZimptjEB9Ma8feQtc6R2LdR
	2gxKFlftD15nRuCbSqPMw==
Date: Mon, 7 May 2007 07:28:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <ak@suse.de>
cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Subject: [2.6.22 patch 2/4] x86_64: extract helper function from
 e820_register_active_regions
In-Reply-To: <Pine.LNX.4.64.0705061703060.27058@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0705061704380.27058@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705061703060.27058@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The logic in e820_find_active_regions() for determining the true active
regions for an e820 entry given a range of PFN's is needed for
e820_hole_size() as well.

e820_hole_size() is called from the NUMA emulation code to determine the
reserved area within an address range on a per-node basis.  Its logic
should duplicate that of finding active regions in an e820 entry because
these are the only true ranges we may register anyway.

Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86_64/kernel/e820.c |   82 ++++++++++++++++++++++++++------------------
 1 files changed, 48 insertions(+), 34 deletions(-)

diff --git a/arch/x86_64/kernel/e820.c b/arch/x86_64/kernel/e820.c
--- a/arch/x86_64/kernel/e820.c
+++ b/arch/x86_64/kernel/e820.c
@@ -303,47 +303,61 @@ void __init e820_mark_nosave_regions(void)
 	}
 }
 
-/* Walk the e820 map and register active regions within a node */
-void __init
-e820_register_active_regions(int nid, unsigned long start_pfn,
-							unsigned long end_pfn)
+/*
+ * Finds an active region in the address range from start_pfn to end_pfn and
+ * returns its range in ei_startpfn and ei_endpfn for the e820 entry.
+ */
+static __init int e820_find_active_region(const struct e820entry *ei,
+					  unsigned long start_pfn,
+					  unsigned long end_pfn,
+					  unsigned long *ei_startpfn,
+					  unsigned long *ei_endpfn)
 {
-	int i;
-	unsigned long ei_startpfn, ei_endpfn;
-	for (i = 0; i < e820.nr_map; i++) {
-		struct e820entry *ei = &e820.map[i];
-		ei_startpfn = round_up(ei->addr, PAGE_SIZE) >> PAGE_SHIFT;
-		ei_endpfn = round_down(ei->addr + ei->size, PAGE_SIZE)
-								>> PAGE_SHIFT;
+	*ei_startpfn = round_up(ei->addr, PAGE_SIZE) >> PAGE_SHIFT;
+	*ei_endpfn = round_down(ei->addr + ei->size, PAGE_SIZE) >> PAGE_SHIFT;
 
-		/* Skip map entries smaller than a page */
-		if (ei_startpfn >= ei_endpfn)
-			continue;
+	/* Skip map entries smaller than a page */
+	if (*ei_startpfn >= *ei_endpfn)
+		return 0;
 
-		/* Check if end_pfn_map should be updated */
-		if (ei->type != E820_RAM && ei_endpfn > end_pfn_map)
-			end_pfn_map = ei_endpfn;
+	/* Check if end_pfn_map should be updated */
+	if (ei->type != E820_RAM && *ei_endpfn > end_pfn_map)
+		end_pfn_map = *ei_endpfn;
 
-		/* Skip if map is outside the node */
-		if (ei->type != E820_RAM ||
-				ei_endpfn <= start_pfn ||
-				ei_startpfn >= end_pfn)
-			continue;
+	/* Skip if map is outside the node */
+	if (ei->type != E820_RAM || *ei_endpfn <= start_pfn ||
+				    *ei_startpfn >= end_pfn)
+		return 0;
 
-		/* Check for overlaps */
-		if (ei_startpfn < start_pfn)
-			ei_startpfn = start_pfn;
-		if (ei_endpfn > end_pfn)
-			ei_endpfn = end_pfn;
+	/* Check for overlaps */
+	if (*ei_startpfn < start_pfn)
+		*ei_startpfn = start_pfn;
+	if (*ei_endpfn > end_pfn)
+		*ei_endpfn = end_pfn;
 
-		/* Obey end_user_pfn to save on memmap */
-		if (ei_startpfn >= end_user_pfn)
-			continue;
-		if (ei_endpfn > end_user_pfn)
-			ei_endpfn = end_user_pfn;
+	/* Obey end_user_pfn to save on memmap */
+	if (*ei_startpfn >= end_user_pfn)
+		return 0;
+	if (*ei_endpfn > end_user_pfn)
+		*ei_endpfn = end_user_pfn;
 
-		add_active_range(nid, ei_startpfn, ei_endpfn);
-	}
+	return 1;
+}
+
+/* Walk the e820 map and register active regions within a node */
+void __init
+e820_register_active_regions(int nid, unsigned long start_pfn,
+							unsigned long end_pfn)
+{
+	unsigned long ei_startpfn;
+	unsigned long ei_endpfn;
+	int i;
+
+	for (i = 0; i < e820.nr_map; i++)
+		if (e820_find_active_region(&e820.map[i],
+					    start_pfn, end_pfn,
+					    &ei_startpfn, &ei_endpfn))
+			add_active_range(nid, ei_startpfn, ei_endpfn);
 }
 
 /* 
