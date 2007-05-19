Return-Path: <linux-kernel-owner+w=401wt.eu-S1758277AbXESBZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbXESBZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 21:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbXESBZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 21:25:32 -0400
Received: from ns.suse.de ([195.135.220.2]:40846 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbXESBZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 21:25:31 -0400
Date: Sat, 19 May 2007 03:25:30 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
Message-ID: <20070519012530.GB15569@wotan.suse.de>
References: <20070518040854.GA15654@wotan.suse.de> <Pine.LNX.4.64.0705181112250.11881@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705181112250.11881@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 11:14:26AM -0700, Christoph Lameter wrote:
> On Fri, 18 May 2007, Nick Piggin wrote:
> 
> > However we don't have to let those 8 bytes go to waste: we can use them
> > to store the virtual address of the page, which kind of makes sense for
> > 64-bit, because they can likely to use complicated memory models.
> 
> That is not a valid consideration anymore. There is virtual memmap update 
> pending with the sparsemem folks that will simplify things.
> 
> > Many batch operations on struct page are completely random, and as such, I
> > think it is better if each struct page fits completely into a single
> > cacheline even if it means being slightly larger.
> 
> Right. That would simplify the calculations.

It isn't the calculations I'm worried about, although they'll get simpler
too. It is the cache cost.


> > Don't let this space go to waste though, we can use page->virtual in order
> > to optimise page_address operations.
> 
> page->virtual is a benefit if the page is cache hot. Otherwise it may 
> cause a useless lookup.

It would be very rare for the page not to be in L1 cache at this point,
because we've likely taken a reference on it and/or locked it or moved it
between lists etc.
 
> I wonder if there are other uses for the free space?

Hugh points out that we should make _count and _mapcount atomic_long_t's,
which would probably be a better use of the space once your vmemmap goes
in.
