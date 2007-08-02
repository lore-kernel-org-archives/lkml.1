Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbXHBOCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbXHBOCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 10:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbXHBOCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 10:02:09 -0400
Received: from 41.150.104.212.access.eclipse.net.uk ([212.104.150.41]:36173
	"EHLO localhost.localdomain" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751638AbXHBOCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 10:02:08 -0400
Date: Thu, 2 Aug 2007 15:01:59 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Mel Gorman <mel@skynet.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1-mm2
Message-ID: <20070802140159.GA30328@shadowen.org>
References: <20070731230932.a9459617.akpm@linux-foundation.org> <12639.1186000208@turing-police.cc.vt.edu> <20070801134055.7862b95e.akpm@linux-foundation.org> <64bb37e0708011352q33053acdxa753cd198fb4233c@mail.gmail.com> <20070801234059.GA29224@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070801234059.GA29224@skynet.ie>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 12:40:59AM +0100, Mel Gorman wrote:
> On (01/08/07 22:52), Torsten Kaiser didst pronounce:
> > On 8/1/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Wed, 01 Aug 2007 16:30:08 -0400
> > > Valdis.Kletnieks@vt.edu wrote:
> > >
> > > > As an aside, it looks like bits&pieces of dynticks-for-x86_64 are in there.
> > > > In particular, x86_64-enable-high-resolution-timers-and-dynticks.patch is in
> > > > there, adding a menu that depends on GENERIC_CLOCKEVENTS, but then nothing
> > > > in the x86_64 tree actually *sets* it.  There's a few other dynticks-related
> > > > prep patches in there as well.  Does this mean it's back to "coming soon to
> > > > a CPU near you" status? :)
> > >
> > > I've lost the plot on that stuff: I'm just leaving things as-is for now,
> > > wait for Thomas to return from vacation so we can have another run at it.
> > 
> > For what its worth: 2.6.22-rc6-mm1 with NO_HZ works for me on an AMD
> > SMP system without trouble.
> > 
> > Next try with 2.6.23-rc1-mm2 and SPARSEMEM:
> > Probably the same exception, but this time with Call Trace:
> > [    0.000000] Bootmem setup node 0 0000000000000000-0000000080000000
> > [    0.000000] Bootmem setup node 1 0000000080000000-0000000120000000
> > [    0.000000] Zone PFN ranges:
> > [    0.000000]   DMA             0 ->     4096
> > [    0.000000]   DMA32        4096 ->  1048576
> > [    0.000000]   Normal    1048576 ->  1179648
> > [    0.000000] Movable zone start PFN for each node
> > [    0.000000] early_node_map[4] active PFN ranges
> > [    0.000000]     0:        0 ->      159
> > [    0.000000]     0:      256 ->   524288
> > [    0.000000]     1:   524288 ->   917488
> > [    0.000000]     1:  1048576 ->  1179648
> > PANIC: early exception rip ffffffff807cddb5 error 2 cr2 ffffe20003000010
> > [    0.000000]
> > [    0.000000] Call Trace:
> > [    0.000000]  [<ffffffff807cddb5>] memmap_init_zone+0xb5/0x130
> > [    0.000000]  [<ffffffff807ce874>] init_currently_empty_zone+0x84/0x110
> > [    0.000000]  [<ffffffff807cec93>] free_area_init_node+0x393/0x3e0
> > [    0.000000]  [<ffffffff807cefea>] free_area_init_nodes+0x2da/0x320
> > [    0.000000]  [<ffffffff807c9c97>] paging_init+0x87/0x90
> > [    0.000000]  [<ffffffff807c0f85>] setup_arch+0x355/0x470
> > [    0.000000]  [<ffffffff807bc967>] start_kernel+0x57/0x330
> > [    0.000000]  [<ffffffff807bc12d>] _sinittext+0x12d/0x140
> > [    0.000000]
> > [    0.000000] RIP memmap_init_zone+0xb5/0x130
> > 
> > (gdb) list *0xffffffff807cddb5
> > 0xffffffff807cddb5 is in memmap_init_zone (include/linux/list.h:32).
> > 27      #define LIST_HEAD(name) \
> > 28              struct list_head name = LIST_HEAD_INIT(name)
> > 29
> > 30      static inline void INIT_LIST_HEAD(struct list_head *list)
> > 31      {
> > 32              list->next = list;
> > 33              list->prev = list;
> > 34      }
> > 35
> > 36      /*
> > 
> > I will test more tomorrow...
> 
> Well.... That doesn't make a whole pile of sense unless the memory map
> is not present. Looking at your boot log, we see this gem

This implies that &page->lru is invalid.  Which implies that the memory
map is indeed not present.  However, if we look at the code in detail we
have actually already updated several fields in the struct page already.
Particularly we have already updated the flags, _count, and _mapcount.
It is when we touch lru which we blammo.  All of the good entries are in
the first 24 bytes of the struct page, lru is in the 8th 64bit word, or
+64 bytes.  Looking at the faulting address it is ffffe20003000010, ie
the fault is 16 bytes into a page.  So the first three elements of this
struct page are in one PMD mapped page, and the lru the next.

As this has SPARSEMEM_VMEMMAP enabled that implies that the vemmmap has
not been filled out correctly.  Looking at the x86_64 initialiser it
appears that we have the same bug that Kame-san reported against the
generic initialisers.  At the end of this email is a proposed patch for
this, could you apply that to a clean 2.6.23-rc1-mm2 tree and give it
a test for me.  I have boot tested this on our x86_64 boxes, but they
happen to be sized and layed out to not trip this bug.

Let me know if it fixes things up for you and I will push it upstream.
If this patch does not fix it could you please get us a boot log at
loglevel=8 of an unmodified 2.6.23-rc1-mm2 kernel, this should give
sufficient debug on how the vmemmap is initialised.

> > [    0.000000]     1:   524288 ->   917488
> > [    0.000000]     1:  1048576 ->  1179648
[...]

-apw

=== 8< ===
vmemmap x86_64: ensure end of section memmap is initialised

Similar to the generic initialisers, the x86_64 vmemmap
initialisation may incorrectly skip the last page of a section if
the section start is not aligned to the page.

Where we have a section spanning the end of a PMD we will check the
start of the section at A populating it.  We will then move on 1
PMD page to C and find ourselves beyond the end of the section which
ends at B we will complete without checking the second PMD page.

        |     PMD     |     PMD     |
                 | SECTION |
                 A         B   C

We should round ourselves to the end of the PMD as we iterate.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 arch/x86_64/mm/init.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)
diff --git a/arch/x86_64/mm/init.c b/arch/x86_64/mm/init.c
index ac49df0..5d1ed03 100644
--- a/arch/x86_64/mm/init.c
+++ b/arch/x86_64/mm/init.c
@@ -792,9 +792,10 @@ int __meminit vmemmap_populate_pmd(pud_t *pud, unsigned long addr,
 						unsigned long end, int node)
 {
 	pmd_t *pmd;
+	unsigned long next;
 
-	for (pmd = pmd_offset(pud, addr); addr < end;
-						pmd++, addr += PMD_SIZE)
+	for (pmd = pmd_offset(pud, addr); addr < end; pmd++, addr = next) {
+		next = pmd_addr_end(addr, end);
 		if (pmd_none(*pmd)) {
 			pte_t entry;
 			void *p = vmemmap_alloc_block(PMD_SIZE, node);
@@ -808,8 +809,8 @@ int __meminit vmemmap_populate_pmd(pud_t *pud, unsigned long addr,
 			printk(KERN_DEBUG " [%lx-%lx] PMD ->%p on node %d\n",
 				addr, addr + PMD_SIZE - 1, p, node);
 		} else
-			vmemmap_verify((pte_t *)pmd, node,
-						pmd_addr_end(addr, end), end);
+			vmemmap_verify((pte_t *)pmd, node, next, end);
+	}
 	return 0;
 }
 #endif
