Return-Path: <linux-kernel-owner+w=401wt.eu-S1763427AbYBSJ5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763427AbYBSJ5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 04:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755700AbYBSJ5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 04:57:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44469 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956AbYBSJ5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 04:57:02 -0500
Date: Tue, 19 Feb 2008 10:57:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       Willy Tarreau <w@1wt.eu>, Roel Kluin <12o3l@tiscali.nl>,
       geoffrey.levand@am.sony.com, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Fix Unlikely(x) == y
Message-ID: <20080219095702.GA6940@one.firstfloor.org>
References: <47B70A61.9030306@tiscali.nl> <200802191333.53607.nickpiggin@yahoo.com.au> <20080219092537.GA6485@one.firstfloor.org> <200802192046.46955.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802192046.46955.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, Feb 19, 2008 at 08:46:46PM +1100, Nick Piggin wrote:
> On Tuesday 19 February 2008 20:25, Andi Kleen wrote:
> > On Tue, Feb 19, 2008 at 01:33:53PM +1100, Nick Piggin wrote:
> 
> > > I actually once measured context switching performance in the scheduler,
> > > and removing the  unlikely hint for testing RT tasks IIRC gave about 5%
> > > performance drop.
> >
> > OT: what benchmarks did you use for that? I had a change some time
> > ago to the CFS scheduler to avoid unpredicted indirect calls for
> > the common case, but I wasn't able to benchmark a difference with the usual
> > suspect benchmark (lmbench). Since it increased code size by
> > a few bytes it was rejected then.
> 
> I think it was just a simple context switch benchmark, but not lmbench
> (which I found to be a bit too variable). But it was a long time ago...

Do you still have it?

I thought about writing my own but ended up being too lazy for that @)

> 
> > > However, the P4's branch predictor is pretty good, and it should easily
> >
> > I think it depends on the generation. Prescott class branch
> > prediction should be much better than the earlier ones.
> 
> I was using a Nocona Xeon, which I think is a Prescott class? 

Yes.

> And don't they have much higher mispredict penalty (than older P4s)?

They do have a longer pipeline, so yes more penalty (5 or 6 stages more iirc),
but also a lot better branch predictor which makes up for that.

> 
> 
> > > Actually one thing I don't like about gcc is that I think it still emits
> > > cmovs for likely/unlikely branches,
> >
> > That's -Os.
> 
> And -O2 and -O3, on the gccs that I'm using, AFAIKS.

Well if it still happens on gcc 4.2 with P4 tuning you should
perhaps open a gcc PR. They tend to ignore these bugs mostly in
my experience, but sometimes they act on them. 

> 
> 
> > > which is silly (the gcc developers
> >
> > It depends on the CPU. e.g. on K8 and P6 using CMOV if possible
> > makes sense. P4 doesn't like it though.
> 
> If the branch is completely predictable (eg. annotated), then I
> think branches should be used anyway. Even on well predicted
> branches, cmov is similar speed on microbenchmarks, but it will
> increase data hazards I think, so it will probably be worse for
> some real world situations.

At least the respective optimization manuals say they should be used.
I presume they only made this recommendation after some extensive
benchmarking.

> 
> 
> > > the quite good numbers that cold CPU predictors can attain. However
> > > for really performance critical code (or really "never" executed
> > > code), then I think it is OK to have the hints and not have to rely
> > > on gcc heuristics.
> >
> > But only when the explicit hints are different from what the implicit
> > branch predictors would predict anyways. And if you look at the
> > heuristics that is not often the case...
> 
> But a likely branch will be _strongly_ predicted to be taken,
> wheras a lot of the gcc heuristics simply have slightly more or
> slightly less probability. So it's not just a question of which
> way is more likely, but also _how_ likely it is to go that way.

Yes, but a lot of the heuristics are pretty strong (>80%) and gcc will
act on them unless it has a very strong contra cue. And that should
normally not be the case.

-Andi
