Return-Path: <linux-kernel-owner+w=401wt.eu-S1760659AbXJPXWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760659AbXJPXWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 19:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756036AbXJPXVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 19:21:55 -0400
Received: from ns2.suse.de ([195.135.220.15]:56572 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833AbXJPXVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 19:21:55 -0400
Date: Wed, 17 Oct 2007 01:21:53 +0200
From: Nick Piggin <npiggin@suse.de>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: LFENCE instruction (was: [rfc][patch 3/3] x86: optimise barriers)
Message-ID: <20071016232153.GC29378@wotan.suse.de>
References: <Pine.LNX.4.64.0710152204060.30307@artax.karlin.mff.cuni.cz> <20071015143732.01d99af8@laptopd505.fenrus.org> <Pine.LNX.4.64.0710160004500.2604@artax.karlin.mff.cuni.cz> <20071016002229.GA5851@wotan.suse.de> <Pine.LNX.4.64.0710161221300.1315@artax.karlin.mff.cuni.cz> <20071016222921.GA29378@wotan.suse.de> <Pine.LNX.4.64.0710170049450.19210@artax.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710170049450.19210@artax.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2007 at 01:05:16AM +0200, Mikulas Patocka wrote:
> > > I see, AMD says that WC memory loads can be out-of-order.
> > > 
> > > There is very little usability to it --- framebuffer and AGP aperture is 
> > > the only piece of memory that is WC and no kernel structures are placed 
> > > there, so it is possible to remove that lfence.
> > 
> > No. In Linux kernel, rmb() means that all previous loads, including to
> > any IO regions, will be executed before any subsequent load.
> 
> You already must not place any data structures into WC memory --- for 
> example, spinlocks wouldn't work there.

What do you mean "already"? If we already have drivers loading data from
WC memory, then rmb() needs to order them, whether or not they actually
need it. If that were prohibitively costly, then we'd introduce a new
barrier which does not order WC memory, right?


> wmb() also won't work on WC 
> memory, because it assumes that writes are ordered.

You mean the one defined like this:
  #define wmb()   asm volatile("sfence" ::: "memory")
? If it assumed writes are ordered, then it would just be a barrier().


> > How can you possibly get rid of lfence from there just because you may
> > happen to *know* that it isn't used (btw. the IO serialisation isn't for
> > kernel data structures, it is for actual IO operations, generally).
> 
> IO regions are in uncached memory, and x86 already serializes it fine. It 
> flushes any write buffers on access to uncached memory.
> 
> (BTW. what is the general portable rule for serializing writel() and 
> readl()? On x86 they are serialized in hardware, but what on other archs?)

Most tend to order them strongly these days. There are also relaxed
variants for architectures that can take advantage of them.


> > Doing that would lead to an unmaintainable mess. If drivers don't need rmb,
> > then they don't call it.
> 
> If wmb() doesn't currently work on write-combining memory, why should 
> rmb() work there?

I don't understand why you say wmb() doesn't work on WC memory. What part
of which spec are you reading (or, given your mistrust of specs, what CPU
are you seeing failures with)?
 

> The purpose of rmb() is to enforce ordering on architectures that don't 
> force it in hardware --- that is not the case of x86.

Well it clearly is the case because I just pointed you to a document
that says they can go out of order. If you want to argue that existing
implementations do not, then by all means go ahead and send a patch to
Linus and see what he says about it ;)

