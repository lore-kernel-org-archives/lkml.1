Return-Path: <linux-kernel-owner+w=401wt.eu-S1761254AbYBSJ0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254AbYBSJ0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 04:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759493AbYBSJZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 04:25:43 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39364 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762856AbYBSJZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 04:25:36 -0500
Date: Tue, 19 Feb 2008 10:25:37 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       Willy Tarreau <w@1wt.eu>, Roel Kluin <12o3l@tiscali.nl>,
       geoffrey.levand@am.sony.com, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Fix Unlikely(x) == y
Message-ID: <20080219092537.GA6485@one.firstfloor.org>
References: <47B70A61.9030306@tiscali.nl> <20080216094226.1e8eede1@laptopd505.fenrus.org> <p731w7axrat.fsf@bingen.suse.de> <200802191333.53607.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802191333.53607.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 01:33:53PM +1100, Nick Piggin wrote:
> On Tuesday 19 February 2008 01:39, Andi Kleen wrote:
> > Arjan van de Ven <arjan@infradead.org> writes:
> > > you have more faith in the authors knowledge of how his code actually
> > > behaves than I think is warranted  :)
> >
> > iirc there was a mm patch some time ago to keep track of the actual
> > unlikely values at runtime and it showed indeed some wrong ones. But the
> > far majority of them are probably correct.
> >
> > > Or faith in that he knows what "unlikely" means.
> > > I should write docs about this; but unlikely() means:
> > > 1) It happens less than 0.01% of the cases.
> > > 2) The compiler couldn't have figured this out by itself
> > >    (NULL pointer checks are compiler done already, same for some other
> > > conditions) 3) It's a hot codepath where shaving 0.5 cycles (less even on
> > > x86) matters (and the author is ok with taking a 500 cycles hit if he's
> > > wrong)
> >
> > One more thing unlikely() does is to move the unlikely code out of line.
> > So it should conserve some icache in critical functions, which might
> > well be worth some more cycles (don't have numbers though).
> 
> I actually once measured context switching performance in the scheduler,
> and removing the  unlikely hint for testing RT tasks IIRC gave about 5%
> performance drop.

OT: what benchmarks did you use for that? I had a change some time
ago to the CFS scheduler to avoid unpredicted indirect calls for
the common case, but I wasn't able to benchmark a difference with the usual 
suspect benchmark (lmbench). Since it increased code size by
a few bytes it was rejected then.

> 
> This was on a P4 which is very different from more modern CPUs both in
> terms of branch performance characteristics, 

> and icache characteristics.

Hmm, the P4 the trace cache actually should not care about inline
code that is not executed.

> However, the P4's branch predictor is pretty good, and it should easily

I think it depends on the generation. Prescott class branch
prediction should be much better than the earlier ones.

> Actually one thing I don't like about gcc is that I think it still emits
> cmovs for likely/unlikely branches, 

That's -Os.

> which is silly (the gcc developers

It depends on the CPU. e.g. on K8 and P6 using CMOV if possible
makes sense. P4 doesn't like it though.

> the quite good numbers that cold CPU predictors can attain. However
> for really performance critical code (or really "never" executed
> code), then I think it is OK to have the hints and not have to rely
> on gcc heuristics.

But only when the explicit hints are different from what the implicit
branch predictors would predict anyways. And if you look at the
heuristics that is not often the case...

Also I really think that mm patch that measured unlikely efficiency
should be dug out and merged to mainline and them regularly rechecked.

-Andi
