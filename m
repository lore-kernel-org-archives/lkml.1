Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbXHAXlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbXHAXlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 19:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbXHAXlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 19:41:05 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:50093 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbXHAXlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 19:41:02 -0400
Date: Thu, 2 Aug 2007 00:40:59 +0100
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
       linux-kernel@vger.kernel.org, apw@shadowen.org
Subject: Re: 2.6.23-rc1-mm2
Message-ID: <20070801234059.GA29224@skynet.ie>
References: <20070731230932.a9459617.akpm@linux-foundation.org> <12639.1186000208@turing-police.cc.vt.edu> <20070801134055.7862b95e.akpm@linux-foundation.org> <64bb37e0708011352q33053acdxa753cd198fb4233c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <64bb37e0708011352q33053acdxa753cd198fb4233c@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/08/07 22:52), Torsten Kaiser didst pronounce:
> On 8/1/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, 01 Aug 2007 16:30:08 -0400
> > Valdis.Kletnieks@vt.edu wrote:
> >
> > > As an aside, it looks like bits&pieces of dynticks-for-x86_64 are in there.
> > > In particular, x86_64-enable-high-resolution-timers-and-dynticks.patch is in
> > > there, adding a menu that depends on GENERIC_CLOCKEVENTS, but then nothing
> > > in the x86_64 tree actually *sets* it.  There's a few other dynticks-related
> > > prep patches in there as well.  Does this mean it's back to "coming soon to
> > > a CPU near you" status? :)
> >
> > I've lost the plot on that stuff: I'm just leaving things as-is for now,
> > wait for Thomas to return from vacation so we can have another run at it.
> 
> For what its worth: 2.6.22-rc6-mm1 with NO_HZ works for me on an AMD
> SMP system without trouble.
> 
> Next try with 2.6.23-rc1-mm2 and SPARSEMEM:
> Probably the same exception, but this time with Call Trace:
> [    0.000000] Bootmem setup node 0 0000000000000000-0000000080000000
> [    0.000000] Bootmem setup node 1 0000000080000000-0000000120000000
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA             0 ->     4096
> [    0.000000]   DMA32        4096 ->  1048576
> [    0.000000]   Normal    1048576 ->  1179648
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[4] active PFN ranges
> [    0.000000]     0:        0 ->      159
> [    0.000000]     0:      256 ->   524288
> [    0.000000]     1:   524288 ->   917488
> [    0.000000]     1:  1048576 ->  1179648
> PANIC: early exception rip ffffffff807cddb5 error 2 cr2 ffffe20003000010
> [    0.000000]
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff807cddb5>] memmap_init_zone+0xb5/0x130
> [    0.000000]  [<ffffffff807ce874>] init_currently_empty_zone+0x84/0x110
> [    0.000000]  [<ffffffff807cec93>] free_area_init_node+0x393/0x3e0
> [    0.000000]  [<ffffffff807cefea>] free_area_init_nodes+0x2da/0x320
> [    0.000000]  [<ffffffff807c9c97>] paging_init+0x87/0x90
> [    0.000000]  [<ffffffff807c0f85>] setup_arch+0x355/0x470
> [    0.000000]  [<ffffffff807bc967>] start_kernel+0x57/0x330
> [    0.000000]  [<ffffffff807bc12d>] _sinittext+0x12d/0x140
> [    0.000000]
> [    0.000000] RIP memmap_init_zone+0xb5/0x130
> 
> (gdb) list *0xffffffff807cddb5
> 0xffffffff807cddb5 is in memmap_init_zone (include/linux/list.h:32).
> 27      #define LIST_HEAD(name) \
> 28              struct list_head name = LIST_HEAD_INIT(name)
> 29
> 30      static inline void INIT_LIST_HEAD(struct list_head *list)
> 31      {
> 32              list->next = list;
> 33              list->prev = list;
> 34      }
> 35
> 36      /*
> 
> I will test more tomorrow...

Well.... That doesn't make a whole pile of sense unless the memory map
is not present. Looking at your boot log, we see this gem

> [    0.000000]     1:   524288 ->   917488
> [    0.000000]     1:  1048576 ->  1179648

Node 1 spans a region with a nice little hole in the middle of DMA32. In our
test machines, we wouldn't see a hole like this, at least that I can recall
so it would appear to work on some machines. On SPARSEMEM, sparse_init()
is responsible for allocating memmap for each section. In 2.6.22-rc6-mm1,
it allocated the memory if the section was *valid*. In 2.6.23-rc1-mm1,
it allocates the memory if the section is *present* due to the patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch[1]. Much later in
the init process, memmap is initialised based on spanned memory, not present
memory so initialisation will init memmap that resides in holes if a zone
spans that area in a node which is the case on this machine.  I think this
is why it kablamos - it's inits memmap that wasn't allocated because it's
not present and the suprise is that it doesn't blow up sooner. Please try
the patch below Torsten, thanks.

[1] yeah, I acked this patch and I had read through it. My bad if the
    patch below does fix the problem

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.23-rc1-mm2-clean/mm/sparse.c linux-2.6.23-rc1-mm2-present_revert/mm/sparse.c
--- linux-2.6.23-rc1-mm2-clean/mm/sparse.c	2007-08-01 10:09:39.000000000 +0100
+++ linux-2.6.23-rc1-mm2-present_revert/mm/sparse.c	2007-08-02 00:27:00.000000000 +0100
@@ -483,7 +483,7 @@ void __init sparse_init(void)
 	unsigned long *usemap;
 
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
-		if (!present_section_nr(pnum))
+		if (!valid_section_nr(pnum))
 			continue;
 
 		map = sparse_early_mem_map_alloc(pnum);
