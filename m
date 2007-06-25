Return-Path: <linux-kernel-owner+w=401wt.eu-S1755756AbXFYA0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbXFYA0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 20:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbXFYA0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 20:26:10 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:52076 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbXFYA0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 20:26:09 -0400
Date: Mon, 25 Jun 2007 01:25:26 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <20070624105152.GB14099@flint.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0706250120560.28286@blonde.wat.veritas.com>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706211835070.11608@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706220539050.11131@blonde.wat.veritas.com>
 <alpine.LFD.0.98.0706220937271.3593@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706221040310.17139@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706221931370.4699@blonde.wat.veritas.com>
 <20070624083849.GA19079@flint.arm.linux.org.uk>
 <Pine.LNX.4.64.0706241122030.27778@blonde.wat.veritas.com>
 <20070624105152.GB14099@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAACmluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAY2xhbWV0ZXJAc2dpLmNvbQBhbmRyZXdAc2FucGVvcGxlLmNvbQBuaWNvbGFzLmZlcnJlQHJmby5hdG1lbC5jb20AbGludXgtYXJtLWtlcm5lbEBsaXN0cy5hcm0ubGludXgub3JnLnVrAHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnAGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmcAbWFyYy5waWduYXRAaGV2cy5jaABkcnpldXNAZHJ6ZXVzLmN4AHJtaytsa21sQGFybS5saW51eC5vcmcudWsA
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2007, Russell King wrote:
> On Sun, Jun 24, 2007 at 11:24:16AM +0100, Hugh Dickins wrote:
> > On Sun, 24 Jun 2007, Russell King wrote:
> > > On Fri, Jun 22, 2007 at 07:39:33PM +0100, Hugh Dickins wrote:
> > > 
> > > Please forward the original problem report.
> > 
> > Done.
> 
> Okay, that seems to back up my suspicions - it's definitely AT91-based.
> Since AT91-based machines do not have a DMA coherent cache,
> arch_is_coherent() must be defined to '0'.  The only way that kmalloc
> could be reached is if that were defined to something other than '0',
> and if that's done on a machine with DMA incoherent caches, that will
> lead to data corruption.

Yes, having looked through that now, I agree with you 100%.

> 
> I think we need to wait for Nicolas to respond on this issue before
> running headlong into applying a sticky plaster for something which is
> actually a deeper issue.

No need for Nicolas to respond, I think I've found what's "wrong":
see below.

> 
> However, the arch_is_coherent() path _is_ buggy as it stands, but in
> more than the way identified thus far.  Eg, it doesn't set __GFP_DMA
> appropriately for various DMA masks, so it might return DMA inaccessible
> memory.

I expect you're right, but that's a separate issue.  I had thought
you were approving Christoph's ARM patch because both you and he seemed
to agree that kmalloc was inappropriate for use in dma_alloc_coherent,
whatever additional issues you saw with it.

I still don't see why kmalloc is wrong there myself: for a while
I bought Christoph's alignment argument, but now I don't see why
(more than long) alignment is important to it.  But I'm easily
wrong when it comes to DMA mapping issues.

> 
> If we're after a simple fix for 2.6.22, the _easiest_ solution would be
> to delete the entire arch_is_coherent() branches in arch/arm/mm/consistent.c;
> that will result in a working solution for everyone, albiet at a slightly
> lower performance for the DMA-coherent CPUs.

The fix for 2.6.22 is my PageSlab test in page_mapping which Linus
already put into -git.

And I now rather think that needs to stay, not be replaced by the
VM_BUG_ON Christoph was proposing for 2.6.23 (which earlier I acked).

Christoph responded to my page_mapping patch by looking at arch/arm,
and there finding a kmalloc in dma_alloc_coherent which he didn't
like; but you're right, it's entirely irrelevant to Nicolas' oops.

The slub allocation which gives rise to Nicolas' oops in not in
ARM, but (I'm guessing) in drivers/mmc/core/sd.c: one of those
	status = kmalloc(64, GFP_KERNEL);
where status is passed down for the response from mmc_sd_switch.

And what is wrong with using kmalloc there?
Why should that be changed to allocate a whole page?
How many other such cases might there be?

And the flush_dcache_page in at91mci_post_dma_read looks correct
to me too: it has just filled and perhaps also swabbed a buffer,
that buffer might in some cases be mapped into userspace, so it
calls flush_dcache_page.

In the kmalloc case it's not mapped into userspace: flush_dcache_page
should detect that and do nothing, as it does with slab; but slub was
reusing page->mapping for something else, so we oopsed.

Hugh
