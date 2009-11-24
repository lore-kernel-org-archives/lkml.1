Return-Path: <linux-kernel-owner+w=401wt.eu-S934415AbZKXXWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934415AbZKXXWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 18:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934372AbZKXXWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 18:22:54 -0500
Received: from waste.org ([173.11.57.241]:38526 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934366AbZKXXWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 18:22:53 -0500
Subject: Re: lockdep complaints in slab allocator
From: Matt Mackall <mpm@selenic.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
       linux-mm@kvack.org, cl@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <84144f020911241307u14cd2cf0h614827137e42378e@mail.gmail.com>
References: <84144f020911192249l6c7fa495t1a05294c8f5b6ac8@mail.gmail.com>
	 <1258729748.4104.223.camel@laptop> <1259002800.5630.1.camel@penberg-laptop>
	 <1259003425.17871.328.camel@calx> <4B0ADEF5.9040001@cs.helsinki.fi>
	 <1259080406.4531.1645.camel@laptop>
	 <20091124170032.GC6831@linux.vnet.ibm.com>
	 <1259082756.17871.607.camel@calx> <1259086459.4531.1752.camel@laptop>
	 <1259090615.17871.696.camel@calx>
	 <84144f020911241307u14cd2cf0h614827137e42378e@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 16:55:15 -0600
Message-ID: <1259103315.17871.895.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 23:07 +0200, Pekka Enberg wrote:
> On Tue, Nov 24, 2009 at 9:23 PM, Matt Mackall <mpm@selenic.com> wrote:
> > On Tue, 2009-11-24 at 19:14 +0100, Peter Zijlstra wrote:
> >> On Tue, 2009-11-24 at 11:12 -0600, Matt Mackall wrote:
> >> > On Tue, 2009-11-24 at 09:00 -0800, Paul E. McKenney wrote:
> >> > > On Tue, Nov 24, 2009 at 05:33:26PM +0100, Peter Zijlstra wrote:
> >> > > > On Mon, 2009-11-23 at 21:13 +0200, Pekka Enberg wrote:
> >> > > > > Matt Mackall wrote:
> >> > > > > > This seems like a lot of work to paper over a lockdep false positive in
> >> > > > > > code that should be firmly in the maintenance end of its lifecycle? I'd
> >> > > > > > rather the fix or papering over happen in lockdep.
> >> > > > >
> >> > > > > True that. Is __raw_spin_lock() out of question, Peter?-) Passing the
> >> > > > > state is pretty invasive because of the kmem_cache_free() call in
> >> > > > > slab_destroy(). We re-enter the slab allocator from the outer edges
> >> > > > > which makes spin_lock_nested() very inconvenient.
> >> > > >
> >> > > > I'm perfectly fine with letting the thing be as it is, its apparently
> >> > > > not something that triggers very often, and since slab will be killed
> >> > > > off soon, who cares.
> >> > >
> >> > > Which of the alternatives to slab should I be testing with, then?
> >> >
> >> > I'm guessing your system is in the minority that has more than $10 worth
> >> > of RAM, which means you should probably be evaluating SLUB.
> >>
> >> Well, I was rather hoping that'd die too ;-)
> >>
> >> Weren't we going to go with SLQB?
> >
> > News to me. Perhaps it was discussed at KS.
> 
> Yes, we discussed this at KS. The plan was to merge SLQB to mainline
> so people can test it more easily but unfortunately it hasn't gotten
> any loving from Nick recently which makes me think it's going to miss
> the merge window for .33 as well.
> 
> > My understanding of the current state of play is:
> >
> > SLUB: default allocator
> > SLAB: deep maintenance, will be removed if SLUB ever covers remaining
> > performance regressions
> > SLOB: useful for low-end (but high-volume!) embedded
> > SLQB: sitting in slab.git#for-next for months, has some ground to cover
> >
> > SLQB and SLUB have pretty similar target audiences, so I agree we should
> > eventually have only one of them. But I strongly expect performance
> > results to be mixed, just as they have been comparing SLUB/SLAB.
> > Similarly, SLQB still has of room for tuning left compared to SLUB, as
> > SLUB did compared to SLAB when it first emerged. It might be a while
> > before a clear winner emerges.
> 
> Yeah, something like that. I don't think we were really able to decide
> anything at the KS. IIRC Christoph was in favor of having multiple
> slab allocators in the tree whereas I, for example, would rather have
> only one. The SLOB allocator is bit special here because it's for
> embedded. However, I also talked to some embedded folks at the summit
> and none of them were using SLOB because the gains weren't big enough.
> So I don't know if it's being used that widely.

I'm afraid I have only anecdotal reports from SLOB users, and embedded
folks are notorious for lack of feedback, but I only need a few people
to tell me they're shipping 100k units/mo to be confident that SLOB is
in use in millions of devices.

-- 
http://selenic.com : development and support for Mercurial and Linux


