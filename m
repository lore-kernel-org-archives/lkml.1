Return-Path: <linux-kernel-owner+w=401wt.eu-S1761178AbYCUToy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761178AbYCUToy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 15:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760585AbYCUTog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 15:44:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760355AbYCUTof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 15:44:35 -0400
Date: Fri, 21 Mar 2008 12:44:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: andi@firstfloor.org, ak@suse.de, mingo@elte.hu, clameter@sgi.com,
       linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH] mm: fix boundary checking in free_bootmem_core
Message-Id: <20080321124404.f9d74052.akpm@linux-foundation.org>
In-Reply-To: <86802c440803141036m4a508a91o2cf6706157231429@mail.gmail.com>
References: <86802c440803111801m20349386l58a108cec13eb5ee@mail.gmail.com>
	<86802c440803121811i262b21bdrfb07df52fd27aaae@mail.gmail.com>
	<20080312182240.db32c858.akpm@linux-foundation.org>
	<200803132259.47063.ak@suse.de>
	<86802c440803131522t3d038d39gbe8eb0d38ddcb634@mail.gmail.com>
	<87iqzp5xfv.fsf@basil.nowhere.org>
	<86802c440803140944p302b300fy7515fb758221932b@mail.gmail.com>
	<20080314165336.GS2522@one.firstfloor.org>
	<86802c440803141036m4a508a91o2cf6706157231429@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008 10:36:52 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> On Fri, Mar 14, 2008 at 9:53 AM, Andi Kleen <andi@firstfloor.org> wrote:
> > On Fri, Mar 14, 2008 at 09:44:50AM -0700, Yinghai Lu wrote:
> >  > On 14 Mar 2008 12:58:44 +0100, Andi Kleen <andi@firstfloor.org> wrote:
> >  > > "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
> >  > >  >
> >  > >  > then i tried to reserve 64M or 128M RAM before that, and free that
> >  > >  > before gart/switotble try to allloc_bootmem under 4g.
> >  > >
> >  > >  Sounds like an incredible hack. There are far better ways to do that
> >  > >  for bootmem allocations. e.g. you can just specify a high enough "goal"
> >  > >  That is how swiotlb solves a similar problem (at least before my
> >  > >  mask allocator rewrite)
> >  >
> >  > I don't think so.
> >  >
> >  > anyway, otherway to workaround it is
> >  > change
> >  >                 return __earlyonly_bootmem_alloc(node, size, size,
> >  >                                 __pa(MAX_DMA_ADDRESS));
> >  > in vmemmap_alloc_block to
> >  >                 return __earlyonly_bootmem_alloc(node, size, size,
> >  >                                 __pa(MAX_DMA_ADDRESS + (1<<27)));
> >  > to make room for gart. but that is global change. and may affect other
> >  > platform.
> >
> >  You can just make it an optional architecture defined macro
> it is hard to use MACRO, if someone have allsysconfig, that will make
> kernel code use a lot.
> >
> >
> >  > and don't make sure gart will get it.
> >
> >  Has nothing to do with the gart?
> >
> >
> >
> >  >
> >  > also i assume swiotlb need that range is less than 4g.
> >
> >  The normal rule is that anybody who needs big bootmem allocations
> >  need to make sure they're high enough to not fill up first 4GB.
> >  For small allocations like most of bootmem it doesn't matter because
> >  they're, um, small.
> >
> >  If vmemmap doesn't do that vmemmap needs to be fixed.
> 
> how to define big?
> it has hundreds of 2M block. when numa is on, they span on all nodes,
> and if numa is off, they are sitting on first_online_node.
> 

So Ingo has now merged some x86 patches which apparently had a dependency
upon this patch: "otherwise free_bootmem_node in dma32_free could do sth
bad.".

I had this patch on hold awaiting conclusive feedback from Andi.  It looks
like it needs to be merged asap and any remaining problems should be
addressed separately.

Here's what I have:


From: "Yinghai Lu" <yhlu.kernel@gmail.com>

With numa enabled, some callers could have a range o fmemory on one node but
try to free that on other node.  This can cause some pages to be freed
wrongly.

For example: when we try to allocate 128g boot ram early for gart/swiotlb, and
free that range later so gart/swiotlb can get some range afterwards.

With this patch, we don't need to care which node holds the range, just loop
to call free_bootmem_node for all online nodes.

This patch makes free_bootmem_core() more robust by trimming the sidx and eidx
according the ram range that the node has.

And make the free_bootmem_core handle this out of range case.  We could use
bdata_list to make sure the range can be freed for sure.  So next time, we
don't need to loop online nodes and could use free_bootmem directly.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff -puN mm/bootmem.c~mm-fix-boundary-checking-in-free_bootmem_core mm/bootmem.c
--- a/mm/bootmem.c~mm-fix-boundary-checking-in-free_bootmem_core
+++ a/mm/bootmem.c
@@ -125,6 +125,7 @@ static int __init reserve_bootmem_core(b
 	BUG_ON(!size);
 	BUG_ON(PFN_DOWN(addr) >= bdata->node_low_pfn);
 	BUG_ON(PFN_UP(addr + size) > bdata->node_low_pfn);
+	BUG_ON(addr < bdata->node_boot_start);
 
 	sidx = PFN_DOWN(addr - bdata->node_boot_start);
 	eidx = PFN_UP(addr + size - bdata->node_boot_start);
@@ -156,21 +157,31 @@ static void __init free_bootmem_core(boo
 	unsigned long sidx, eidx;
 	unsigned long i;
 
+	BUG_ON(!size);
+
+	/* out range */
+	if (addr + size < bdata->node_boot_start ||
+		PFN_DOWN(addr) > bdata->node_low_pfn)
+		return;
 	/*
 	 * round down end of usable mem, partially free pages are
 	 * considered reserved.
 	 */
-	BUG_ON(!size);
-	BUG_ON(PFN_DOWN(addr + size) > bdata->node_low_pfn);
 
-	if (addr < bdata->last_success)
+	if (addr >= bdata->node_boot_start && addr < bdata->last_success)
 		bdata->last_success = addr;
 
 	/*
-	 * Round up the beginning of the address.
+	 * Round up to index to the range.
 	 */
-	sidx = PFN_UP(addr) - PFN_DOWN(bdata->node_boot_start);
+	if (PFN_UP(addr) > PFN_DOWN(bdata->node_boot_start))
+		sidx = PFN_UP(addr) - PFN_DOWN(bdata->node_boot_start);
+	else
+		sidx = 0;
+
 	eidx = PFN_DOWN(addr + size - bdata->node_boot_start);
+	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
+		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
 
 	for (i = sidx; i < eidx; i++) {
 		if (unlikely(!test_and_clear_bit(i, bdata->node_bootmem_map)))
@@ -421,7 +432,9 @@ int __init reserve_bootmem(unsigned long
 
 void __init free_bootmem(unsigned long addr, unsigned long size)
 {
-	free_bootmem_core(NODE_DATA(0)->bdata, addr, size);
+	bootmem_data_t *bdata;
+	list_for_each_entry(bdata, &bdata_list, list)
+		free_bootmem_core(bdata, addr, size);
 }
 
 unsigned long __init free_all_bootmem(void)
_

