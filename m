Return-Path: <linux-kernel-owner+w=401wt.eu-S1756870AbXFYQnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbXFYQnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 12:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbXFYQmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 12:42:55 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:57152 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbXFYQmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 12:42:53 -0400
Date: Mon, 25 Jun 2007 17:42:06 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
In-Reply-To: <Pine.LNX.4.64.0706250607260.5191@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0706251729250.4911@blonde.wat.veritas.com>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706211835070.11608@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706220539050.11131@blonde.wat.veritas.com>
 <alpine.LFD.0.98.0706220937271.3593@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706221040310.17139@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706221931370.4699@blonde.wat.veritas.com>
 <20070624083849.GA19079@flint.arm.linux.org.uk>
 <Pine.LNX.4.64.0706241122030.27778@blonde.wat.veritas.com>
 <20070624105152.GB14099@flint.arm.linux.org.uk>
 <Pine.LNX.4.64.0706250120560.28286@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0706250607260.5191@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAACmluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAY2xhbWV0ZXJAc2dpLmNvbQBhbmRyZXdAc2FucGVvcGxlLmNvbQBuaWNvbGFzLmZlcnJlQHJmby5hdG1lbC5jb20AbGludXgtYXJtLWtlcm5lbEBsaXN0cy5hcm0ubGludXgub3JnLnVrAHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnAGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmcAbWFyYy5waWduYXRAaGV2cy5jaABkcnpldXNAZHJ6ZXVzLmN4AHJtaytsa21sQGFybS5saW51eC5vcmcudWsA
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007, Christoph Lameter wrote:
> On Mon, 25 Jun 2007, Hugh Dickins wrote:
> 
> > And I now rather think that needs to stay, not be replaced by the
> > VM_BUG_ON Christoph was proposing for 2.6.23 (which earlier I acked).
> > 
> > Christoph responded to my page_mapping patch by looking at arch/arm,
> > and there finding a kmalloc in dma_alloc_coherent which he didn't
> > like; but you're right, it's entirely irrelevant to Nicolas' oops.
> > 
> > The slub allocation which gives rise to Nicolas' oops in not in
> > ARM, but (I'm guessing) in drivers/mmc/core/sd.c: one of those
> > 	status = kmalloc(64, GFP_KERNEL);
> > where status is passed down for the response from mmc_sd_switch.
> >
> > And what is wrong with using kmalloc there?
> > Why should that be changed to allocate a whole page?
> > How many other such cases might there be?
> 
> So someone effectively does a flush_dcache_page(virt_to_page(status))?

Yes.

> 
> > In the kmalloc case it's not mapped into userspace: flush_dcache_page
> > should detect that and do nothing, as it does with slab; but slub was
> > reusing page->mapping for something else, so we oopsed.
> 
> If that is the case then what we really want is a flush_dcache_range
> not the above. flush_dcache_range does not take a page struct as an 
> argument and it will work on memory that has no struct page backing it.
> 
> Is flush_dcache_range available in all platforms? I see some drivers
> using it:
> 
> drivers/net/fec.c
> drivers/serial/mpsc.c
> drivers/char/agp/uninorth-agp.c
> 
> 
> flush_dcache_page is implemented by
> 
> sparc64		Uses mapping
> sh		Ok. Only uses PG_mapped
> arm		Uses mapping in the mmu case
> frv		Does a kmap_atomic ?? Otherwise looks ok.
> ppc		Clears PG_arch_1
> mips		Uses mapping
> sh64		No page struct use
> parisc		Uses mapping
> xtensa		Uses mapping
> powerpc		Handles page flags PG_arch_1
> ia64		Clears PG_arch_1
> sparc		Calculates address based on page struct addr.
> blackfin	Does an immediate page_address(page)
> m68k		Does an immediate page_address(page)
> 
> In many situations the page struct passed to flush_dcache_page is
> simply used to calculate the virtual address. So its mostly harmless.
> Trouble starts when page attributes like the mapping is used.

Mostly harmless indeed.  I don't understand why you insist on trying
to complicate the situation.  flush_dcache_page is only expected to
do something on pages mapped into userspace (correct me if I'm wrong
there), it's expected to do nothing on kmalloc'ed pages.  It's
been working that way for years, and will continue to work that way
with slub, providing either page_mapping or flush_dcache_page checks
PageSlab to avoid oopsing on page->mapping.

2.6.22-rc6 has page_mapping making that check: we could argue about
which is the better site for it, there are good arguments both ways
(page_mapping is the correct place, flush_dcache_page is the more
efficient place), I suggest we leave it as is.

> 
> So the problem platforms are
> 
> sparc64 arm mips parisc xtensa
> 
> If we indeed do these weird things then I think the general fix should
> be to use flush_dcache_range() but that is too late for 2.6.22. The 
> VM_BUG_ON will be useful to detect these scenarios. Maybe we need
> to replace that with a WARN_ON or something if the usage is frequent?
> There are a large number of platforms on which flush_dcache_range has
> no effect or an effect that is negligible.
> 
> A kmalloc slab object (even 64 byte) may be crossing a page boundary 
> with a ARCH_KMALLOC_MINALIGN of 4 or 8. So I think that 
> flush_dcache_range *must* be used rather than flush_dcache_page. 

Why????  All we require of flush_dcache_page is that it not oops on
the first page in the range: we don't need to change over to
flush_dcache_range for that.

> flush_dcache_page(virt_to_page(object)) takes the starting address of 
> the object and flushes the page in which the object started. It may
> not be the complete object. This usually works fine with 64 byte objects
> because they neatly fit into a slab page. Again if CONFIG_SLAB_DEBUG
> f.e. is enabled then the alignment will no longer be to a 64 byte bound 
> but only to the alignment guaranteed by ARCH_KMALLOC_MINALIGN. If this 
> trick is used on a non kmalloc cache with a non power of size then we
> may have a larger chance of trouble occurring.
> 
> For 2.6.22 the easiest solution may be to check for PageSlab in the
> flush_dcache_pages of the affected platforms and then count on
> the users not enabling any slab debugging. Its then simply the same state 
> as before.

We have the PageSlab check in page_mapping now,
I don't see what further change is needed.

Hugh
