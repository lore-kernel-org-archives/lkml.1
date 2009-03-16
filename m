Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbZCPPyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbZCPPyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 11:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbZCPPxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 11:53:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54754 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343AbZCPPxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 11:53:48 -0400
Date: Mon, 16 Mar 2009 16:53:42 +0100
From: Nick Piggin <npiggin@suse.de>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 00/35] Cleanup and optimise the page allocator V3
Message-ID: <20090316155342.GH30802@wotan.suse.de>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie> <20090316104054.GA23046@wotan.suse.de> <20090316111906.GA6382@csn.ul.ie> <20090316113358.GA30802@wotan.suse.de> <20090316120216.GB6382@csn.ul.ie> <20090316122505.GD30802@wotan.suse.de> <20090316133232.GA24293@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090316133232.GA24293@csn.ul.ie>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 01:32:32PM +0000, Mel Gorman wrote:
> On Mon, Mar 16, 2009 at 01:25:05PM +0100, Nick Piggin wrote:
> > > Well, buddy always uses the smallest available page first. Even with
> > > deferred coalescing, it will merge up to order-5 at least. Lets say they
> > > could have merged up to order-10 in ordinary circumstances, they are
> > > still avoided for as long as possible. Granted, it might mean that an
> > > order-5 is split that could have been merged but it's hard to tell how
> > > much of a difference that makes.
> > 
> > But the kinds of pages *you* are interested in are order-10, right?
> > 
> 
> Yes, but my expectation is that multiple free order-5 pages can be
> merged to make up an order-10.

Yes, but lazy buddy will give out part of an order-10 free area
to an order-5 request even when there are genuine order-5,6,7,8,9
free areas available.

Now it could be assumed that not too much else in the kernel
asks for anything over order-3, so you are unlikely to get these
kinds of requests. But it's worse than that actually, because
lazy buddy will also split half of an order-10 free area in order
to satisfy an order-0 allocation in cases that there are no smaller
orders than 5 available.

So yes definitely I think there should be a very real impact on
higher order coalescing no matter what you do.


> If they can't, then lumpy reclaim kicks
> in as normal. My expectation actually is that order-10 allocations often
> end up using lumpy reclaim and the pages are not automatically
> available.

movable zone is less interesting, although it will make it harder
to allocate these guys from movable zone. But the pages are
movable so eventually they should be able to be reclaimed.

unmovable zone fragmentation is more important point because it
eventually can destroy the movable zone.


