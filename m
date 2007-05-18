Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbXERH7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbXERH7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 03:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755478AbXERH7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 03:59:46 -0400
Received: from ns2.suse.de ([195.135.220.15]:45538 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854AbXERH7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 03:59:45 -0400
Date: Fri, 18 May 2007 09:59:43 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
Message-ID: <20070518075943.GB23998@wotan.suse.de>
References: <20070518040854.GA15654@wotan.suse.de> <20070518001905.54cafeeb.akpm@linux-foundation.org> <20070518073223.GA23998@wotan.suse.de> <20070518004304.14db3eef.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518004304.14db3eef.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 12:43:04AM -0700, Andrew Morton wrote:
> On Fri, 18 May 2007 09:32:23 +0200 Nick Piggin <npiggin@suse.de> wrote:
> 
> > On Fri, May 18, 2007 at 12:19:05AM -0700, Andrew Morton wrote:
> > > On Fri, 18 May 2007 06:08:54 +0200 Nick Piggin <npiggin@suse.de> wrote:
> > > 
> > > > Many batch operations on struct page are completely random,
> > > 
> > > But they shouldn't be: we should aim to place physically contiguous pages
> > > into logically contiguous pagecache slots, for all the reasons we
> > > discussed.
> > 
> > For big IO batch operations, pagecache would be more likely to be
> > physically contiguous, as would LRU, I suppose.
> 
> read(), write(), truncate(), writeback, pagefault.  Pretty common stuff.

Of course, but if you're doing them on random-ish ranges, or multiple
files, or continually on the same file while parts of it get reclaimed
and reinstantiated...


> > I'm more thinking of operations where things get reclaimed over time,
> > touched or dirtied in slightly different orderings, interleaved with
> > other allocations, etc.
> 
> Yes, that can happen.  But in such cases we by definition aren't touching
> the pageframes very often.  I'd assert that when the kernel is really
> hitting those pageframes hard, it is commonly doing this in ascending
> pagecache order.

I'm not sure that I would always agree. Sure if there is random *IO*
involved, then it is going to be slow and we won't be hitting page frames
so hard. But if there is random pagecache access, it will hit them almost
as hard.


> > > If/when that happens, there will be a *lot* of locality of reference
> > > against the pageframes in a lot of important codepaths.
> > 
> > And when it doesn't happen, we eat 75% more cache misses. And for that
> > matter we eat 75% more cache misses for non-batch operations like
> > allocating or freeing a page by slab, for example.
> 
> "measure twice, cut once"

Definitely agree there.

