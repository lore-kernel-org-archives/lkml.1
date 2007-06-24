Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbXFXKwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbXFXKwl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 06:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbXFXKwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 06:52:32 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3839 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbXFXKwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 06:52:31 -0400
Date: Sun, 24 Jun 2007 11:51:52 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <andrew@sanpeople.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Oops in a driver while using SLUB as a SLAB allocator
Message-ID: <20070624105152.GB14099@flint.arm.linux.org.uk>
References: <467A4532.40301@rfo.atmel.com> <Pine.LNX.4.64.0706212244090.19755@blonde.wat.veritas.com> <Pine.LNX.4.64.0706211835070.11608@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0706220539050.11131@blonde.wat.veritas.com> <alpine.LFD.0.98.0706220937271.3593@woody.linux-foundation.org> <Pine.LNX.4.64.0706221040310.17139@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0706221931370.4699@blonde.wat.veritas.com> <20070624083849.GA19079@flint.arm.linux.org.uk> <Pine.LNX.4.64.0706241122030.27778@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706241122030.27778@blonde.wat.veritas.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 11:24:16AM +0100, Hugh Dickins wrote:
> On Sun, 24 Jun 2007, Russell King wrote:
> > On Fri, Jun 22, 2007 at 07:39:33PM +0100, Hugh Dickins wrote:
> > > I'm quite happy with this approach for 2.6.23-rc, along with your ARM
> > > dma_map patch which (if I understood aright) rmk approved.
> > 
> > I didn't approve it.  Please re-read my reply - there are still some
> > unanswered questions in it which _really_ need answering.
> 
> Sorry for misrepresenting you.
> 
> > The report talks about the AT91 machines.  These machines do not have
> > cache coherent DMA.  Therefore, the code being patched should be
> > optimised away by the compiler. *Or* we have even bigger problems.
> > 
> > Please forward the original problem report.
> 
> Done.

Okay, that seems to back up my suspicions - it's definitely AT91-based.
Since AT91-based machines do not have a DMA coherent cache,
arch_is_coherent() must be defined to '0'.  The only way that kmalloc
could be reached is if that were defined to something other than '0',
and if that's done on a machine with DMA incoherent caches, that will
lead to data corruption.

I think we need to wait for Nicolas to respond on this issue before
running headlong into applying a sticky plaster for something which is
actually a deeper issue.

However, the arch_is_coherent() path _is_ buggy as it stands, but in
more than the way identified thus far.  Eg, it doesn't set __GFP_DMA
appropriately for various DMA masks, so it might return DMA inaccessible
memory.

If we're after a simple fix for 2.6.22, the _easiest_ solution would be
to delete the entire arch_is_coherent() branches in arch/arm/mm/consistent.c;
that will result in a working solution for everyone, albiet at a slightly
lower performance for the DMA-coherent CPUs.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
