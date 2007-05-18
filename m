Return-Path: <linux-kernel-owner+w=401wt.eu-S1760647AbXERFbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760647AbXERFbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 01:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbXERFbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 01:31:38 -0400
Received: from mail.suse.de ([195.135.220.2]:56489 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbXERFbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 01:31:37 -0400
Date: Fri, 18 May 2007 07:31:35 +0200
From: Nick Piggin <npiggin@suse.de>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
Message-ID: <20070518053135.GB7696@wotan.suse.de>
References: <20070518040854.GA15654@wotan.suse.de> <20070517.214740.51856086.davem@davemloft.net> <20070518051238.GA7696@wotan.suse.de> <20070517.222217.112287075.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070517.222217.112287075.davem@davemloft.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 10:22:17PM -0700, David Miller wrote:
> From: Nick Piggin <npiggin@suse.de>
> Date: Fri, 18 May 2007 07:12:38 +0200
> 
> > The page->virtual thing is just a bonus (although have you seen what
> > sort of hoops SPARSEMEM has to go through to find page_address?! It
> > will definitely be a win on those architectures).
> 
> If you set the bit ranges in asm/sparsemem.h properly, as I
> have currently on sparc64, it isn't bad at all.  It's a
> single extra dereference from a table that sits in the main
> kernel image and thus is in a locked TLB entry.

It is still another cacheline, another load and more icache.

 
> SPARSEMEM_EXTREME is pretty much unnecessary and with the
> virtual mem-map stuff the sparsemem overhead goes away entirely
> and we're back to "page - mem_map" type simple calculations
> obviating any dereferencing advantage from page->virtual.

Sure, but you'd still like to save several KB of icache by doing
power of 2 arithmetic ;)

 
> > 0.2% of memory, or 2MB per GB. But considering we already use 14MB per
> > GB for the page structures, it isn't like I'm introducing an order of
> > magnitude problem.
> 
> All these little things add up, let's not suck like some other
> OSs by having that kind of mentality.
> 
> Show me instead a change that makes page struct 8 bytes smaller
> :-))))

They all do add up, but this isn't just wasting memory for no reason,
it is to make much better use of CPU caches. Back when PCs had only
a couple of MB of memory, size-speed optimisations were all the rage
because you had enough memory to throw around on big lookup tables and
such... that's only gone away because the cache cost hurts.

But this is one such size/speed tradeoff that actually should make
better use of the cache. Obviously extensive benchmarks are needed,
but I don't think it should be dismissed.

If you have a big problem with struct page overhead, cutting 8 bytes
off it isn't going to make you much happier -- you need to increase
PAGE_SIZE to get some real order-of-magnitude savings.

