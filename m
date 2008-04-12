Return-Path: <linux-kernel-owner+w=401wt.eu-S1758626AbYDMKgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbYDMKgf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 06:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbYDMKgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 06:36:22 -0400
Received: from saeurebad.de ([85.214.36.134]:50599 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758144AbYDMKgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 06:36:14 -0400
X-Mailbox-Line: From hannes@symbol.fehenstaub.lan Sun Apr 13 00:58:50 2008
Message-Id: <20080412225850.411927887@symbol.fehenstaub.lan>
References: <20080412223319.372887160@symbol.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Sun, 13 Apr 2008 00:33:20 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>
Subject: [patch 1/2] bootmem: Revert "mm: fix boundary checking in free_bootmem_core"
Content-Disposition: inline; filename=0001-Revert-mm-fix-boundary-checking-in-free_bootmem_co.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 5a982cbc7b3fe6cf72266f319286f29963c71b9e.

The intention behind this patch was to make the free_bootmem()
interface more robust with regards to the specified range and to let
it operate on multiple node setups as well.

However, it made free_bootmem_core()

  1. handle bogus node/memory-range combination input by just
     returning early without informing the callsite or screaming BUG()
     as it did before
  2. round slightly out of node-range values to the node boundaries
     instead of treating them as the invalid parameters they are

This was partially done to abuse free_bootmem_core() for node
iteration in free_bootmem (just feeding it every node on the box and
let it figure out what it wants to do with it) instead of looking up
the proper node before the call to free_bootmem_core().

It also affects free_bootmem_node() which relies on
free_bootmem_core() and on its sanity checks now removed.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andi Kleen <ak@suse.de>
CC: Yasunori Goto <y-goto@jp.fujitsu.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>
---

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 2ccea70..f6ff433 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -125,7 +125,6 @@ static int __init reserve_bootmem_core(bootmem_data_t *bdata,
 	BUG_ON(!size);
 	BUG_ON(PFN_DOWN(addr) >= bdata->node_low_pfn);
 	BUG_ON(PFN_UP(addr + size) > bdata->node_low_pfn);
-	BUG_ON(addr < bdata->node_boot_start);
 
 	sidx = PFN_DOWN(addr - bdata->node_boot_start);
 	eidx = PFN_UP(addr + size - bdata->node_boot_start);
@@ -157,31 +156,21 @@ static void __init free_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
 	unsigned long sidx, eidx;
 	unsigned long i;
 
-	BUG_ON(!size);
-
-	/* out range */
-	if (addr + size < bdata->node_boot_start ||
-		PFN_DOWN(addr) > bdata->node_low_pfn)
-		return;
 	/*
 	 * round down end of usable mem, partially free pages are
 	 * considered reserved.
 	 */
+	BUG_ON(!size);
+	BUG_ON(PFN_DOWN(addr + size) > bdata->node_low_pfn);
 
-	if (addr >= bdata->node_boot_start && addr < bdata->last_success)
+	if (addr < bdata->last_success)
 		bdata->last_success = addr;
 
 	/*
-	 * Round up to index to the range.
+	 * Round up the beginning of the address.
 	 */
-	if (PFN_UP(addr) > PFN_DOWN(bdata->node_boot_start))
-		sidx = PFN_UP(addr) - PFN_DOWN(bdata->node_boot_start);
-	else
-		sidx = 0;
-
+	sidx = PFN_UP(addr) - PFN_DOWN(bdata->node_boot_start);
 	eidx = PFN_DOWN(addr + size - bdata->node_boot_start);
-	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
-		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
 
 	for (i = sidx; i < eidx; i++) {
 		if (unlikely(!test_and_clear_bit(i, bdata->node_bootmem_map)))
@@ -432,9 +421,7 @@ int __init reserve_bootmem(unsigned long addr, unsigned long size,
 
 void __init free_bootmem(unsigned long addr, unsigned long size)
 {
-	bootmem_data_t *bdata;
-	list_for_each_entry(bdata, &bdata_list, list)
-		free_bootmem_core(bdata, addr, size);
+	free_bootmem_core(NODE_DATA(0)->bdata, addr, size);
 }
 
 unsigned long __init free_all_bootmem(void)

-- 
