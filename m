Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbYG2JOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbYG2JOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 05:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYG2JOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 05:14:06 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35874 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbYG2JOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 05:14:05 -0400
Date: Tue, 29 Jul 2008 10:14:01 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Alex Samad <alex@samad.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>
Subject: Re: page swap allocation error/failure in 2.6.25
Message-ID: <20080729091401.GB20774@csn.ul.ie>
References: <20080725072015.GA17688@samad.com.au> <1216971601.7257.345.camel@twins> <20080727060701.GA7157@samad.com.au> <1217239487.6331.24.camel@twins> <20080729000618.GE1747@samad.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080729000618.GE1747@samad.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (29/07/08 10:06), Alex Samad didst pronounce:
> On Mon, Jul 28, 2008 at 12:04:47PM +0200, Peter Zijlstra wrote:
> > On Sun, 2008-07-27 at 16:07 +1000, Alex Samad wrote:
> > > On Fri, Jul 25, 2008 at 09:40:01AM +0200, Peter Zijlstra wrote:
> > > > On Fri, 2008-07-25 at 17:20 +1000, Alex Samad wrote:
> > > > > Hi
> > > 
> > > [snip]
> > > 
> > > > 
> > > > 
> > > > Its harmless if it happens sporadically. 
> > > > 
> > > > Atomic order 2 allocations are just bound to go wrong under pressure.
> > > can you point me to any doco that explains this ?
> > 
> > An order 2 allocation means allocating 1<<2 or 4 physically contiguous
> > pages. Atomic allocation means not being able to sleep.
> > 
> > Now if the free page lists don't have any order 2 pages available due to
> > fragmentation there is currently nothing we can do about it.
> 
> Strange cause I don't normal have a high swap usage, I have 2G ram and
> 2G swap space. There is not that much memory being used squid, apache is
> about it.
> 

The problem is related to fragmentation. Look at /proc/buddinfo and
you'll see how many pages are free at each order. Now, the system can
deal with fragmentation to some extent but it requires the caller to be
able to perform IO, enter the FS and sleep.

An atomic allocation can do none of those. High-order atomic allocations
are almost always due to a network card using a large MTU that cannot
receive a packet into many page-sized buffers. Their requirement of
high-order atomic allocations is fragile as a result.

You *may* be able to "hide" this by increasing min_free_kbytes as this
will wake kswapd earlier. If the waker of kswapd had requested a high-order
buffer then kswapd will reclaim at that order as well. However, there are
timing issues involved (e.g. the network receive needs to enter the path
that wakes kswapd) and it could have been improved upon.

> > I've been meaning to try and play with 'atomic' page migration to try
> > and assemble a higher order page on demand with something like memory
> > compaction.
> > 
> > But its never managed to get high enough on the todo list..
> > 

Same here. I prototyped memory compaction a while back and the feeling at
the time was that it could be made atomic with a bit of work but I never got
around to pushing it further. Part of this was my feeling that any attempt
to make high-order atomic allocations more reliable would be frowned upon
as encouraging bad behaviour from device driver authors.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
