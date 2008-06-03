Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbYFCCBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbYFCCBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 22:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756449AbYFCB67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 21:58:59 -0400
Received: from saeurebad.de ([85.214.36.134]:39513 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756512AbYFCB65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 21:58:57 -0400
X-Mailbox-Line: From hannes@saeurebad.de Tue Jun  3 02:53:03 2008
Message-Id: <20080603005303.827963832@saeurebad.de>
References: <20080603005017.593345596@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jun 2008 02:50:26 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 09/14] bootmem: free/reserve helpers
Content-Disposition: inline; filename=bootmem-free-reserve-helpers.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out the common operation of marking a range on the bitmap.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>
---

 mm/bootmem.c |   64 +++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 43 insertions(+), 21 deletions(-)

--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -225,6 +225,44 @@ unsigned long __init free_all_bootmem(vo
 	return free_all_bootmem_core(NODE_DATA(0)->bdata);
 }
 
+static void __init __free(bootmem_data_t *bdata,
+			unsigned long sidx, unsigned long eidx)
+{
+	unsigned long idx;
+
+	bdebug("nid=%d start=%lx end=%lx\n", bdata - bootmem_node_data,
+		sidx + PFN_DOWN(bdata->node_boot_start),
+		eidx + PFN_DOWN(bdata->node_boot_start));
+
+	for (idx = sidx; idx < eidx; idx++)
+		if (!test_and_clear_bit(idx, bdata->node_bootmem_map))
+			BUG();
+}
+
+static int __init __reserve(bootmem_data_t *bdata, unsigned long sidx,
+			unsigned long eidx, int flags)
+{
+	unsigned long idx;
+	int exclusive = flags & BOOTMEM_EXCLUSIVE;
+
+	bdebug("nid=%d start=%lx end=%lx flags=%x\n",
+		bdata - bootmem_node_data,
+		sidx + PFN_DOWN(bdata->node_boot_start),
+		eidx + PFN_DOWN(bdata->node_boot_start),
+		flags);
+
+	for (idx = sidx; idx < eidx; idx++)
+		if (test_and_set_bit(idx, bdata->node_bootmem_map)) {
+			if (exclusive) {
+				__free(bdata, sidx, idx);
+				return -EBUSY;
+			}
+			bdebug("silent double reserve of PFN %lx\n",
+				idx + PFN_DOWN(bdata->node_boot_start));
+		}
+	return 0;
+}
+
 static void __init free_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
 				     unsigned long size)
 {
@@ -258,14 +296,7 @@ static void __init free_bootmem_core(boo
 	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
 		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
 
-	bdebug("nid=%d start=%lx end=%lx\n", bdata - bootmem_node_data,
-		sidx + PFN_DOWN(bdata->node_boot_start),
-		eidx + PFN_DOWN(bdata->node_boot_start));
-
-	for (i = sidx; i < eidx; i++) {
-		if (unlikely(!test_and_clear_bit(i, bdata->node_bootmem_map)))
-			BUG();
-	}
+	__free(bdata, sidx, eidx);
 }
 
 /**
@@ -367,16 +398,7 @@ static void __init reserve_bootmem_core(
 	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
 		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
 
-	bdebug("nid=%d start=%lx end=%lx flags=%x\n",
-		bdata - bootmem_node_data,
-		sidx + PFN_DOWN(bdata->node_boot_start),
-		eidx + PFN_DOWN(bdata->node_boot_start),
-		flags);
-
-	for (i = sidx; i < eidx; i++)
-		if (test_and_set_bit(i, bdata->node_bootmem_map))
-			bdebug("hm, page %lx reserved twice.\n",
-				PFN_DOWN(bdata->node_boot_start) + i);
+	return __reserve(bdata, sidx, eidx, flags);
 }
 
 /**
@@ -509,9 +531,9 @@ find_block:
 		/*
 		 * Reserve the area now:
 		 */
-		for (i = PFN_DOWN(new_start) + merge; i < PFN_UP(new_end); i++)
-			if (test_and_set_bit(i, bdata->node_bootmem_map))
-				BUG();
+		if (__reserve(bdata, PFN_DOWN(new_start) + merge,
+				PFN_UP(new_end), BOOTMEM_EXCLUSIVE))
+			BUG();
 
 		region = phys_to_virt(bdata->node_boot_start + new_start);
 		memset(region, 0, size);

-- 

