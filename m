Return-Path: <linux-kernel-owner+w=401wt.eu-S1758815AbXFUW2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815AbXFUW2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 18:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbXFUW21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 18:28:27 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:21312 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031AbXFUW20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 18:28:26 -0400
Date: Thu, 21 Jun 2007 23:27:45 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
cc: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <467A4532.40301@rfo.atmel.com>
Message-ID: <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
References: <467A4532.40301@rfo.atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAACWluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAY2xhbWV0ZXJAc2dpLmNvbQBhbmRyZXdAc2FucGVvcGxlLmNvbQBuaWNvbGFzLmZlcnJlQHJmby5hdG1lbC5jb20AbGludXgtYXJtLWtlcm5lbEBsaXN0cy5hcm0ubGludXgub3JnLnVrAHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnAGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmcAbWFyYy5waWduYXRAaGV2cy5jaABkcnpldXNAZHJ6ZXVzLmN4AA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007, Nicolas Ferre wrote:
> 
> While debugging a Linux driver on my ARM platform (AT91), I switched on the
> 2.6.22-rc5 kernel. While reconfiguring it I selected CONFIG_SLUB as a SLAB
> allocator.
> 
> The sd/mmc driver I tried to run is vanilla driver which never, until now,
> produces Oops (at91_mci.c).
> 
> The oops seems to occur after a page unmapping using dma_unmap_page() followed
> by a flush_dcache_page() (in at91mci_post_dma_read()).
... 
> Unable to handle kernel NULL pointer dereference at virtual address 0000000d
> pgd = c0004000
> [0000000d] *pgd=00000000
> Internal error: Oops: 1 [#1]
> Modules linked in:
> CPU: 0
> PC is at get_index+0x1c/0x50
> LR is at prio_tree_next+0x60/0x194
> pc : [<c01098ac>]    lr : [<c0109fc4>]    Not tainted
> sp : c3d0bca8  ip : ffffffdd  fp : c3d0bcb4
> r10: 00000040  r9 : c3d0be78  r8 : c3d0bcc4
> r7 : c3d0bcc0  r6 : 00000000  r5 : c029635c  r4 : c3d0bcfc
> r3 : c3d0bcc0  r2 : c3d0bcc4  r1 : 00000001  r0 : c3d0bcc0
> Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  Segment kernel
> Control: 5317F
> Table: 20004000  DAC: 00000017
> Process kmmcd (pid: 761, stack limit = 0xc3d0a258)
...
> Backtrace:
> [<c0109890>] (get_index+0x0/0x50) from [<c0109fc4>]
> (prio_tree_next+0x60/0x194)
> [<c0109f64>] (prio_tree_next+0x0/0x194) from [<c0067734>]
> (vma_prio_tree_next+0x1c/0x88)
> r8:c3d649e0 r7:c3d0be68 r6:c0298594 r5:00000000 r4:00000000
> [<c0067718>] (vma_prio_tree_next+0x0/0x88) from [<c002bd0c>]
> (flush_dcache_page+0x108/0x124)
> [<c002bc04>] (flush_dcache_page+0x0/0x124) from [<c017df00>]
> (at91_mci_irq+0x210/0x45c)
> r6:00000000 r5:c3d0be68 r4:c3d0a000
> [<c017dcf0>] (at91_mci_irq+0x0/0x45c) from [<c005a99c>]
> (handle_IRQ_event+0x44/0x80)
> [<c005a958>] (handle_IRQ_event+0x0/0x80) from [<c005bd04>]
...
> 
> Do you find a reason why I cannot use SLUB ? Did I missed something or do I
> use a bad dma_xx or cache flush call in the driver ?

That looks serious: thanks a lot for reporting it.

(I see Marc has sent you a patch or two for the driver end:
I didn't see their relevance, maybe they skirt around the
problem somehow; but unless I'm mistaken, what you've found
goes beyond that particular driver.)

Seems a little odd that it's gone throughout 2.6.22-rc unnoticed
until now - nobody else trying SLUB on ARM or PA-RISC yet perhaps.
As I understand it, you're not doing anything wrong (disclaimer:
I'm no expert on dma_mapping things), but SLUB's reuse of struct
page fields has collided with what flush_dcache_page is expecting.

Here's a patch: I'm not convinced it's necessarily the best one
(most uses of page_mapping will never see a slab page, it's a pity
to be cluttering up that inline even further); but in case nobody
else can provide a better...


[PATCH] page_mapping must avoid slub pages

Nicolas Ferre reports oops from flush_dcache_page() on ARM when using
SLUB: which reuses page->mapping as page->slab.  The page_mapping()
function, used by ARM and PA-RISC flush_dcache_page() implementations,
must not confuse SLUB pages with those which have page->mapping set.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
That #ifdef I've put in there is not essential:
it's perhaps more of a comment or an accusation ;)

 include/linux/mm.h |    4 ++++
 1 file changed, 4 insertions(+)

--- 2.6.22-rc5/include/linux/mm.h	2007-05-26 07:16:48.000000000 +0100
+++ linux/include/linux/mm.h	2007-06-21 15:52:47.000000000 +0100
@@ -603,6 +603,10 @@ static inline struct address_space *page
 
 	if (unlikely(PageSwapCache(page)))
 		mapping = &swapper_space;
+#ifdef CONFIG_SLUB
+	else if (unlikely(PageSlab(page)))
+		mapping = NULL;
+#endif
 	else if (unlikely((unsigned long)mapping & PAGE_MAPPING_ANON))
 		mapping = NULL;
 	return mapping;

