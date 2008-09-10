Return-Path: <linux-kernel-owner+w=401wt.eu-S1753617AbYIJDTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbYIJDTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 23:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbYIJDTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 23:19:24 -0400
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:29688 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751957AbYIJDTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 23:19:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qq0QSrTGtG4gksvDQWnWh2JcD2pil93fa1tVl/7G8nlMrD3PgrRBP10zA6V3CxTdTnyF2i8eta2m5z+TMyOjAUZUdW8NMSvqSS30pUOea7lECgwFodJ6V+WoCpLTi3r2suHX29+Uy3gbgBOL0sacx9XTK/Oj1aVYBU+81dnXc6s=  ;
X-YMail-OSG: k_Z686AVM1mmrnzSp2R4sSKjgjUiBJS9tL7DANf6X15StuyAKBg68QPHtuBorC9dzFOiNjwujxtCumS1sHcY7eZ.ZXf8GcFMALQYwN01G9B.0zgA7q8BOWFFwIfaJXANF4A-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 0/4] Reclaim page capture v3
Date: Wed, 10 Sep 2008 13:19:01 +1000
User-Agent: KMail/1.9.5
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>
References: <1220610002-18415-1-git-send-email-apw@shadowen.org> <200809091331.43671.nickpiggin@yahoo.com.au> <20080909163559.GD21687@brain>
In-Reply-To: <20080909163559.GD21687@brain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809101319.01701.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2008 02:35, Andy Whitcroft wrote:
> On Tue, Sep 09, 2008 at 01:31:43PM +1000, Nick Piggin wrote:

> > Yeah, but blocking the whole pool gives a *much* bigger chance to
> > coalesce freed pages. And I'm not just talking about massive order-10
> > allocations or something where you have the targetted reclaim which
> > improves chances of getting a free page within that range, but also for
> > order-1/2/3 pages that might be more commonly used in normal kernel
> > workloads but can still have a fairly high latency to succeed if there is
> > a lot of other parallel allocation happening.
>
> Yes in isolation blocking the whole pool would give us a higher chance
> of coalescing higher order pages.  The problem here is that we cannot
> block the whole pool, we have to allow allocations for reclaim.  If we
> have those occuring we risk loss of pages from the areas we are trying
> to reclaim.

Allocations from reclaim should be pretty rare, I think you're too
worried about them.

Actually, if you have queueing, you can do a simple form of capture
just in the targetted reclaim path without all the stuff added to page
alloc etc. Because you can hold off from freeing the targetted pages
into the page allocator until you have built up a large number of them.
That way, they won't be subject to recursive allocations and they will
coalesce in the allocator; the queueing will ensure they don't get
stolen or broken into smaller pages under us. Yes I really think queueing
(perhaps with a much simplified form of capture) is the way to go.


> > > I think we have our wires crossed here.  I was saying it would seem
> > > unfair to block the allocator from giving out order-0 pages while we
> > > are struggling to get an order-10 page for one process.  Having a queue
> > > would seem to generate such behaviour.  What I am trying to achieve
> > > with capture is to push areas likely to return us a page of the
> > > requested size out of use, while we try and reclaim it without blocking
> > > the rest of the allocator.
> >
> > We don't have our wires crossed. I just don't agree that it is unfair.
> > It might be unfair to allow order-10 allocations at the same *rate* at
> > order-0 allocations, which is why you could allow some priority in the
> > queue. But when you decide you want to satisfy an order-10 allocation,
> > do you want the other guys potentially mopping up your coalescing
> > candidates? (and right, for targetted reclaim, maybe this is less of a
> > problem, but I'm also thinking about a general solution for all orders
> > of pages not just hugepages).
>
> When I am attempting to satisfy an order-10 allocation I clearly want to
> protect that order-10 area from use for allocation to other allocators.
> And that is the key thrust of the capture stuff, that is what it does.
> Capture puts the pages in areas under targetted reclaim out of the
> allocator during the reclaim pass.  Protecting those areas from any
> parallel parallel allocators, either regular or PF_MEMALLOC; but only
> protecting those areas.

And I've shown that by a principle of fairness, you don't need to protect
just one area, but you can hold off reclaim on all areas, which should
greatly increase your chances of getting a hugepage, and will allow you
to do so fairly.


> I think we have differing views on what a queuing alone can deliver.
> Given that the allocator will have to allow allocations made during reclaim
> in parallel with reclaim for higher orders it does not seem sufficient
> to have a 'fair queue' alone.  That will not stop the smaller necessary
> allocations from stealing our partial free buddies, allocations that we
> know are not always short lived.  [continued below]

Queueing is a general and natural step which (hopefully) benefits everyone,
so I think it should be tried before capture (which introduces new complexity
solely for big allocations).


> > > Sure you would be able to make some kind of more flexible decisions,
> > > but that still seems like a heavy handed approach.  You are important
> > > enough to takes pages (possibly from our mostly free high order page)
> > > or not.
> >
> > I don't understand the thought process that leads you to these
> > assertions. Where do you get your idea of fairness or importance?
> >
> > I would say that allowing 2^N order-0 allocations for every order-N
> > allocations if both allocators are in a tight loop (and reserves are low,
> > ie. reclaim is required) is a completely reasonable starting point for
> > fairness. Do you disagree with that? How is it less fair than your
> > approach?
>
> What I was trying to convey here is that given the limitation that we need
> to allow allocation from within reclaim for reclaim to complete, that
> even stopping other small allocations for the period of the high order
> allocation is insufficient as those reclaim allocations are potentially
> as damaging.  That even with a priority queue on the allocator you would
> need something to prevent allocations falling within an area under reclaim
> without preventing allocations completely, it is this problem that I
> am trying to solve.  Trying to get the most beneficial result from the
> effort put in during reclaim.  I actually think your idea of a priority
> queue and what capture is trying to do are othogonal.

Yes they are orthogonal, but I would like to see if we can do without
page capture. I'm not saying the theory or practice of it is wrong.


> The current model uses direct reclaim as the 'fairness control'.  If you
> are allocating a lot and the pool runs dry, you enter reclaim and are
> penalised for your greed.  "If you want something big, you work to get it."
> Someone entering reclaim for higher order is independant of lower order
> allocators, and may even take pages from the pool without reclaim.
> What you are proposing with the priority queue seems to be a replacement
> for that.

For order-2,3 etc allocations that can be commonly used by the kernel but
are not always in large supply, that fairness model doesn't really work.
You can work to free things, then have another process allocate them, then
exit direct reclaim to find none left etc.

Even for order-0 pages there is a problem in theory (although statistically
it probably evens out much better).


> > Even for hugepages: if, with your capture patches, if process 0 comes in
> > and does all this reclaim work and has nearly freed up some linear region
> > of memory; then do you think it is reasonable if process-1 happens to
> > come in and get lucky and find an subsequently coalesced hugepage and
> > allocate it?
>
> Are you saying of capture fails to obtain the high order page, so all
> the reclaim effort was wasted for that process, but then a subsequent
> reclaimer comes in and reclaims a few pages, gets the whole page and
> effectivly steals the work?  It is unfortuanate for sure.  Is it better
> that the work was not completely wasted, yes.  By containing and protecting
> the partial results we work to reduce the likely hood of this happening.

Yes.
