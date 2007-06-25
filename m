Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbXFYRAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbXFYRAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 13:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbXFYRAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 13:00:22 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55027 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750927AbXFYRAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 13:00:21 -0400
Date: Mon, 25 Jun 2007 10:00:16 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
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
In-Reply-To: <Pine.LNX.4.64.0706251729250.4911@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0706250952490.8320@schroedinger.engr.sgi.com>
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
 <Pine.LNX.4.64.0706251729250.4911@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007, Hugh Dickins wrote:

> > In many situations the page struct passed to flush_dcache_page is
> > simply used to calculate the virtual address. So its mostly harmless.
> > Trouble starts when page attributes like the mapping is used.
> 
> Mostly harmless indeed.  I don't understand why you insist on trying
> to complicate the situation.  flush_dcache_page is only expected to
> do something on pages mapped into userspace (correct me if I'm wrong
> there), it's expected to do nothing on kmalloc'ed pages.  It's
> been working that way for years, and will continue to work that way
> with slub, providing either page_mapping or flush_dcache_page checks
> PageSlab to avoid oopsing on page->mapping.

It is definitely intended to work. Otherwise we would not have code 
like this:

christoph@fly:~/linux-2.6$ find . -name "*.c" | xargs grep "flush_dcache_page"|grep virt
./drivers/scsi/scsi_tgt_if.c:   flush_dcache_page(virt_to_page(ev));
./drivers/scsi/scsi_tgt_if.c:           flush_dcache_page(virt_to_page(ev));


> 2.6.22-rc6 has page_mapping making that check: we could argue about
> which is the better site for it, there are good arguments both ways
> (page_mapping is the correct place, flush_dcache_page is the more
> efficient place), I suggest we leave it as is.

Ok. I think your patch is fine as a quick fix for 2.6.22. I am a bit 
uneasy with that given that its in such a broadly used function while its 
only use is to enable flush_dcache_page to work. But we need the general 
issue taken care of after 2.6.22.

> > A kmalloc slab object (even 64 byte) may be crossing a page boundary 
> > with a ARCH_KMALLOC_MINALIGN of 4 or 8. So I think that 
> > flush_dcache_range *must* be used rather than flush_dcache_page. 
> 
> Why????  All we require of flush_dcache_page is that it not oops on
> the first page in the range: we don't need to change over to
> flush_dcache_range for that.

As explained about: There are corner cases in which it does not work. You 
seem to assume that flush_dcache_page can become a no op. That may not be 
true on platforms that need explicit cache flushing for a DMA engine to 
access a data structure. The above listed use suggests that the caller 
expects flushing to occur correctly.



