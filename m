Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbYIHOAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbYIHOAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 10:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbYIHOAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 10:00:12 -0400
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:39268 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751963AbYIHOAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 10:00:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rg2b4iwahQigCH9mYXW6H8FRsvqo64g797/BCQl5Mww5CCG8NLIx6Mf6DXbBvTxTdeu3+exH79Gd25Q4Xs3Gz6pIhzZCt5QTU1mjLr6nNQUMaPh9rfgEjaKcSCGBl5k4bXk3KMvAsvPfErkTe1LPg6YGwjub+6w/9Zf79BeKCf0=  ;
X-YMail-OSG: TZOmrI4VM1mFYljp.H2Nwrv_cZSlDhXLLJLye0sgpzRv2SN_uI791yUvkfATdHpLjzlgv8nAGD6WXOc6Ys5AOBSW8uI5Pxx7a8IzOenZSgR_O04ijND9m4wC353roKNMSWM-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 0/4] Reclaim page capture v3
Date: Mon, 8 Sep 2008 23:59:54 +1000
User-Agent: KMail/1.9.5
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>
References: <1220610002-18415-1-git-send-email-apw@shadowen.org> <200809081608.03793.nickpiggin@yahoo.com.au> <20080908114423.GE18694@brain>
In-Reply-To: <20080908114423.GE18694@brain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809082359.55288.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2008 21:44, Andy Whitcroft wrote:
> On Mon, Sep 08, 2008 at 04:08:03PM +1000, Nick Piggin wrote:
> > On Friday 05 September 2008 20:19, Andy Whitcroft wrote:

> > > 		Absolute	Effective
> > > x86-64		2.48%		 4.58%
> > > powerpc		5.55%		25.22%
> >
> > These are the numbers for the improvement of hugepage allocation success?
> > Then what do you mean by absolute and effective?
>
> The absolute improvement is the literal change in success percentage,
> the literal percentage of all memory which may be allocated as huge
> pages.  The effective improvement is percentage of the baseline success
> rates that this change represents; for the powerpc results we get some
> 20% of memory allocatable without the patches, and 25% with, 25% more
> pages are allocatable with the patches.

OK.


> > What sort of constant stream of high order allocations are you talking
> > about? In what "real" situations are you seeing higher order page
> > allocation failures, and in those cases, how much do these patches help?
>
> The test case simulates a constant demand for huge pages, at various
> rates.  This is intended to replicate the scenario where a system is
> used with mixed small page and huge page applications, with a dynamic
> huge page pool.  Particularly we are examining the effect of starting a
> very large huge page job on a busy system.  Obviously starting hugepage
> applications depends on hugepage availability as they are not swappable.
> This test was chosen because it both tests the initial large page demand
> and then pushes the system to the limit.

So... what does the non-simulation version (ie. the real app) say?


> > I must say I don't really like this approach. IMO it might be better to
> > put some sort of queue in the page allocator, so if memory becomes low,
> > then processes will start queueing up and not be allowed to jump the
> > queue and steal memory that has been freed by hard work of a direct
> > reclaimer. That would improve a lot of fairness problems as well as
> > improve coalescing for higher order allocations without introducing this
> > capture stuff.
>
> The problem with queuing all allocators is two fold.  Firstly allocations
> are obviously required for reclaim and those would have to be exempt
> from the queue, and these are as likely to prevent coelesce of pages
> as any other.

*Much* less likely, actually. Because there should be very little allocation
required for reclaim (only dirty pages, and only when backed by filesystems
that do silly things like not ensuring their own reserves before allowing
the page to be dirtied).

Also, your scheme still doesn't avoid allocation for reclaim so I don't see
how you can use that as a point against queueing but not capturing!


> Secondly where a very large allocation is requested 
> all allocators would be held while reclaim at that size is performed,
> majorly increasing latency for those allocations.  Reclaim for an order
> 0 page may target of the order of 32 pages, whereas reclaim for x86_64
> hugepages is 1024 pages minimum.  It would be grosly unfair for a single
> large allocation to hold up normal allocations.

I don't see why it should be unfair to allow a process to allocate 1024
order-0 pages ahead of one order-10 page (actually, yes the order 10 page
is I guess somewhat more valueable than the same number of fragmented
pages, but you see where I'm coming from).

At least with queueing you are basing the idea on *some* reasonable policy,
rather than purely random "whoever happens to take this lock at the right
time will win" strategy, which might I add, can even be much more unfair
than you might say queueing is.

However, queueing would still be able to allow some flexibility in priority.
For example:

if (must_queue) {
  if (queue_head_prio == 0)
    join_queue(1<<order);
  else {
    queue_head_prio -= 1<<order;
    skip_queue();
  }
}

