Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbYHLJyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbYHLJyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 05:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbYHLJyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 05:54:00 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:52492 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbYHLJx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 05:53:59 -0400
X-BigFish: VPS-10(zz936eQ1442J3117Kzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K5HFHF-01-CPK-01
Date: Tue, 12 Aug 2008 11:53:36 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
CC: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@saeurebad.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] alloc_bootmem_core: fix misaligned allocation of 1G page
Message-ID: <20080812095336.GE5952@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 12 Aug 2008 09:53:40.0002 (UTC) FILETIME=[4C2BB820:01C8FC61]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If memory hole remapping is enabled on an x86-NUMA system, allocation
of 1G pages on node 1 will most probably trigger an BUG_ON in
alloc_bootmem_huge_page because alloc_bootmem_core fails to properly
align the huge page on a 1G boundary.

I've observed this Oops with kernel 2.6.27-rc2-00166-gaeee90d
with a 2 socket system and activated memory hole remapping.
(Of course disabling memory hole remapping works around the problem
but this wastes a significant amount of memory.)

Here some dmesg snippet with that kernel (using "bootmem_debug"  plus some
additional printk's):

  ...
  Bootmem setup node 0 0000000000000000-0000000130000000
  ...
  Bootmem setup node 1 0000000130000000-0000000230000000
  ...
  Kernel command line: root=/dev/sda4 console=ttyS0,115200
    hugepagesz=2M hugepages=0 hugepagesz=1G hugepages=3 bootmem_debug
    debug earlyprintk=ttyS0,115200
   ...

  bootmem::alloc_bootmem_core nid=1 size=40000000 [262144 pages]
    align=40000000 goal=0 limit=0
  min: 1245184, max: 2293760, step: 262144, start: 1310720
  sidx: 65536, midx: 1048576
  sidx: 65536
  sidx: 262144, eidx: 524288
  start_off: 1073741824, end_off: 2147483648, merge: 0, min_pfn: 1245184
  bootmem::__reserve nid=1 start=170000 end=1b0000 flags=1
  addr:ffff880170000000, paddr:0000000170000000, size: 1073741824
  PANIC: early exception 06 rip 10:ffffffff807ce3b0 error 0 cr2 0
  Pid: 0, comm: swapper Not tainted 2.6.27-rc2-00166-gaeee90d-dirty #6

  Call Trace:
   [<ffffffff807cccbe>] ___alloc_bootmem_nopanic+0x60/0x98
   [<ffffffff807bc195>] early_idt_handler+0x55/0x69
   [<ffffffff807ce3b0>] alloc_bootmem_huge_page+0xa6/0xd9
   [<ffffffff807ce39f>] alloc_bootmem_huge_page+0x95/0xd9
   [<ffffffff807ce3fe>] hugetlb_hstate_alloc_pages+0x1b/0x3a
   [<ffffffff807ce489>] hugetlb_nrpages_setup+0x6c/0x7a
   [<ffffffff807bc69e>] unknown_bootoption+0xdc/0x1e2
   [<ffffffff802446d6>] parse_args+0x137/0x1f5
   [<ffffffff807bc5c2>] unknown_bootoption+0x0/0x1e2
   [<ffffffff807bcb6e>] start_kernel+0x195/0x2b7
   [<ffffffff807bc369>] x86_64_start_kernel+0xe3/0xe7

  RIP 0x10

The problem in alloc_bootmem_core is that it just guarantees
proper alignment for the offset (sidx) from bdata->node_min_pfn.

A simple (ugly) fix is to add bdata->node_min_pfn to sidx and
friends. Patch is attached.

The current code in alloc_bootmem_core is based on changes introduced
with commit 5f2809e69c7128f86316048221cf45146f69a4a0 (bootmem: clean
up alloc_bootmem_core). But I didn't check whether this commit
introduced the problem.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 mm/bootmem.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

With attached patch the 1G huge page gets properly aligned on node 1:

  Linux version 2.6.27-rc2-00389-g10fec20-dirty ...
  ...
  Bootmem setup node 0 0000000000000000-0000000130000000
  ...
  Bootmem setup node 1 0000000130000000-0000000230000000
  ...

  Kernel command line: root=/dev/sda4 console=ttyS0,115200
    hugepagesz=2M hugepages=0 huge pagesz=1G hugepages=3 bootmem_debug
    debug earlyprintk=ttyS0,115200
  bootmem::alloc_bootmem_core nid=0 size=40000000 [262144 pages] align=40000000
    goal=0 limit=0
  bootmem::__reserve nid=0 start=40000 end=80000 flags=1
  bootmem::alloc_bootmem_core nid=0 size=40000000 [262144 pages] align=40000000
    goal=0 limit=0
  bootmem::__reserve nid=0 start=80000 end=c0000 flags=1
  bootmem::alloc_bootmem_core nid=0 size=40000000 [262144 pages] align=40000000
    goal=0 limit=0
  bootmem::alloc_bootmem_core nid=0 size=40000000 [262144 pages] align=40000000
    goal=0 limit=0
  bootmem::alloc_bootmem_core nid=1 size=40000000 [262144 pages] align=40000000
    goal=0 limit=0
  bootmem::__reserve nid=1 start=140000 end=180000 flags=1
  Initializing CPU#0
  ...

Patch is against v2.6.27-rc2-389-g10fec20.
Please apply for 2.6.27 ...  if nobody comes up with a better solution.


Regards,

Andreas

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 4af15d0..9d54244 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -441,8 +441,8 @@ static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
 	else
 		start = ALIGN(min, step);
 
-	sidx = start - bdata->node_min_pfn;;
-	midx = max - bdata->node_min_pfn;
+	sidx = start;
+	midx = max;
 
 	if (bdata->hint_idx > sidx) {
 		/*
@@ -458,7 +458,10 @@ static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
 		void *region;
 		unsigned long eidx, i, start_off, end_off;
 find_block:
-		sidx = find_next_zero_bit(bdata->node_bootmem_map, midx, sidx);
+		sidx = find_next_zero_bit(bdata->node_bootmem_map,
+					  midx - bdata->node_min_pfn,
+					  sidx - bdata->node_min_pfn);
+		sidx += bdata->node_min_pfn;
 		sidx = ALIGN(sidx, step);
 		eidx = sidx + PFN_UP(size);
 
@@ -466,7 +469,8 @@ find_block:
 			break;
 
 		for (i = sidx; i < eidx; i++)
-			if (test_bit(i, bdata->node_bootmem_map)) {
+			if (test_bit(i - bdata->node_min_pfn,
+				     bdata->node_bootmem_map)) {
 				sidx = ALIGN(i, step);
 				if (sidx == i)
 					sidx += step;
@@ -474,16 +478,17 @@ find_block:
 			}
 
 		if (bdata->last_end_off &&
-				PFN_DOWN(bdata->last_end_off) + 1 == sidx)
+		    (PFN_DOWN(bdata->last_end_off) + 1) ==
+		    (sidx - bdata->node_min_pfn))
 			start_off = ALIGN(bdata->last_end_off, align);
 		else
-			start_off = PFN_PHYS(sidx);
+			start_off = PFN_PHYS(sidx - bdata->node_min_pfn);
 
-		merge = PFN_DOWN(start_off) < sidx;
+		merge = PFN_DOWN(start_off) < (sidx - bdata->node_min_pfn);
 		end_off = start_off + size;
 
 		bdata->last_end_off = end_off;
-		bdata->hint_idx = PFN_UP(end_off);
+		bdata->hint_idx = PFN_UP(end_off + bdata->node_min_pfn);
 
 		/*
 		 * Reserve the area now:
-- 
1.5.6.4



