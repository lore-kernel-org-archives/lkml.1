Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbXHULD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbXHULD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 07:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbXHULDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 07:03:49 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60720 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755051AbXHULDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 07:03:49 -0400
Date: Tue, 21 Aug 2007 12:03:47 +0100
To: nigel@suspend2.net
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Should GFP_ATOMIC fail when we're below low watermark?
Message-ID: <20070821110346.GB11329@skynet.ie>
References: <200708201138.50508.nigel@nigel.suspend2.net> <200708201838.50262.nigel@nigel.suspend2.net> <1187600376.6114.186.camel@twins> <200708202055.03058.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200708202055.03058.nigel@nigel.suspend2.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (20/08/07 20:55), Nigel Cunningham didst pronounce:
> Hi.
> 
> On Monday 20 August 2007 18:59:36 Peter Zijlstra wrote:
> > On Mon, 2007-08-20 at 18:38 +1000, Nigel Cunningham wrote:
> > > Hi.
> > > 
> > > On Monday 20 August 2007 12:43:50 Peter Zijlstra wrote:
> > > > On Mon, 2007-08-20 at 11:38 +1000, Nigel Cunningham wrote:
> > > > > Hi all.
> > > > > 
> > > > > In current git (and for a while now), an attempt to allocate memory 
> with 
> > > > > GFP_ATOMIC will fail if we're below the low watermark level. The only 
> way 
> > > to 
> > > > > access that memory that I can see (not that I've looked that hard) is 
> to 
> > > have 
> > > > > PF_MEMALLOC set (ie from kswapd). I'm wondering if this behaviour is 
> > > correct. 
> > > > > Shouldn't GFP_ATOMIC allocations ignore watermarks too? How about 
> > > GFP_KERNEL?
> > > > > 
> > > > > The following patch is a potential fix for GFP_ATOMIC.
> > > > 
> > > > Sorry, no.
> > > > 
> > > > GFP_ATOMIC must fail when below the watermark. GFP_KERNEL has __GFP_WAIT
> > > > and hence can sleep and wait for reclaim so that should not be a problem
> > > > (usually).
> > > > 
> > > > GFP_ATOMIC may not access the reserves because the reserves are needed
> > > > to get out of OOM deadlocks within the VM. Consider the fact that
> > > > freeing memory needs memory - if there is no memory free, you cannot
> > > > free memory and you're pretty much stuck.
> > > 
> > > I guess, then, the question should be whether the watermark values are 
> > > appropriate. Do we need high order allocations watermarked if this is the 
> > > only purpose, particularly considering that whatever memory is allocated 
> for 
> > > this purpose is essentially useless 99.9% of the time?
> > 
> > Could you perhaps explain what you're trying to do? No matter what we
> > do, GFP_ATOMIC will fail eventually, there is only so much one can do
> > without blocking.
> > 
> > As for higher order allocations, until we have a full online defrag
> > solution those too can fail at any moment (even with __GFP_WAIT).
> 
> I was just trying to make hibernation more reliable in sitations where there's 
> low amounts of memory available. I guess the amount of memory that's reserved 
> for this has increased, because some users have been reporting issues that 
> hadn't appeared before. No problem. I'll work around it.

Where are these reports? I'm not familiar with how hibernation works but
why does it need a large number of GFP_ATOMIC allocations?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
