Return-Path: <linux-kernel-owner+w=401wt.eu-S1761794AbXHTQFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761794AbXHTQFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 12:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759821AbXHTQEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 12:04:52 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:14945 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722AbXHTQEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 12:04:51 -0400
Date: Mon, 20 Aug 2007 09:09:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: nigel@suspend2.net, LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <piggin@cyberone.com.au>, Mel Gorman <mel@skynet.ie>
Subject: Re: [PATCH] Should GFP_ATOMIC fail when we're below low watermark?
Message-Id: <20070820090933.09d80d4c.randy.dunlap@oracle.com>
In-Reply-To: <1187607961.6114.191.camel@twins>
References: <200708201138.50508.nigel@nigel.suspend2.net>
	<200708201838.50262.nigel@nigel.suspend2.net>
	<1187600376.6114.186.camel@twins>
	<200708202055.03058.nigel@nigel.suspend2.net>
	<1187607961.6114.191.camel@twins>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2007 13:06:01 +0200 Peter Zijlstra wrote:

> On Mon, 2007-08-20 at 20:55 +1000, Nigel Cunningham wrote:
> > Hi.
> > 
> > On Monday 20 August 2007 18:59:36 Peter Zijlstra wrote:
> > > On Mon, 2007-08-20 at 18:38 +1000, Nigel Cunningham wrote:
> > > > Hi.
> > > > 
> > > > On Monday 20 August 2007 12:43:50 Peter Zijlstra wrote:
> > > > > On Mon, 2007-08-20 at 11:38 +1000, Nigel Cunningham wrote:
> > > > > > Hi all.
> > > > > > 
> > > > > > In current git (and for a while now), an attempt to allocate memory 
> > with 
> > > > > > GFP_ATOMIC will fail if we're below the low watermark level. The only 
> > way 
> > > > to 
> > > > > > access that memory that I can see (not that I've looked that hard) is 
> > to 
> > > > have 
> > > > > > PF_MEMALLOC set (ie from kswapd). I'm wondering if this behaviour is 
> > > > correct. 
> > > > > > Shouldn't GFP_ATOMIC allocations ignore watermarks too? How about 
> > > > GFP_KERNEL?
> > > > > > 
> > > > > > The following patch is a potential fix for GFP_ATOMIC.
> > > > > 
> > > > > Sorry, no.
> > > > > 
> > > > > GFP_ATOMIC must fail when below the watermark. GFP_KERNEL has __GFP_WAIT
> > > > > and hence can sleep and wait for reclaim so that should not be a problem
> > > > > (usually).
> > > > > 
> > > > > GFP_ATOMIC may not access the reserves because the reserves are needed
> > > > > to get out of OOM deadlocks within the VM. Consider the fact that
> > > > > freeing memory needs memory - if there is no memory free, you cannot
> > > > > free memory and you're pretty much stuck.
> > > > 
> > > > I guess, then, the question should be whether the watermark values are 
> > > > appropriate. Do we need high order allocations watermarked if this is the 
> > > > only purpose, particularly considering that whatever memory is allocated 
> > for 
> > > > this purpose is essentially useless 99.9% of the time?
> > > 
> > > Could you perhaps explain what you're trying to do? No matter what we
> > > do, GFP_ATOMIC will fail eventually, there is only so much one can do
> > > without blocking.
> > > 
> > > As for higher order allocations, until we have a full online defrag
> > > solution those too can fail at any moment (even with __GFP_WAIT).
> > 
> > I was just trying to make hibernation more reliable in sitations where there's 
> > low amounts of memory available. I guess the amount of memory that's reserved 
> > for this has increased, because some users have been reporting issues that 
> > hadn't appeared before. No problem. I'll work around it.
> 
> I think the last time the default reserves were changed was 2.6.12 or
> there about.
> 
> Perhaps Mel fiddled with it in .23-rc ?

Could there be a slab vs. slub difference?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
