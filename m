Return-Path: <linux-kernel-owner+w=401wt.eu-S1758549AbXHBRhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758549AbXHBRhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 13:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759484AbXHBRgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 13:36:49 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1886 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758884AbXHBRgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 13:36:48 -0400
Date: Thu, 2 Aug 2007 19:36:51 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Peter Zijlstra <peterz@infradead.org>
cc: Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: CFS review
In-Reply-To: <1185979796.12034.92.camel@twins>
Message-ID: <Pine.LNX.4.64.0708011745330.1817@scrub.home>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> 
 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu> 
 <20070711211638.GE18767@one.firstfloor.org>  <20070711214649.GK14435@v2.random>
  <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0707130415520.1818@scrub.home>  <1184302024.6709.11.camel@Homer.simpson.net>
  <Pine.LNX.4.64.0707131728070.1817@scrub.home>  <1184389456.6632.13.camel@Homer.simpson.net>
  <Pine.LNX.4.64.0708010439050.1817@scrub.home> <1185979796.12034.92.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 1 Aug 2007, Peter Zijlstra wrote:

> Took me most of today trying to figure out WTH you did in fs2.c, more
> math and fundamental explanations would have been good. So please bear
> with me as I try to recap this thing. (No, your code was very much _not_
> obvious, a few comments and broken out functions would have made a world
> of a difference)

Thanks for the effort though. :)
I know I'm not the best explaining these things, so I really appreciate 
the questions, so I know what to concentrate on.

> So, for each task we keep normalised time
> 
>  normalised time := time/weight
> 
> using Bresenham's algorithm we can do this prefectly (up until a renice
> - where you'd get errors)
> 
>         avg_frac += weight_inv
>         
>         weight_inv = X / weight
>         
>         avg = avg_frac / weight0_inv
>         
>         weight0_inv = X / weight0
>         
>         avg = avg_frac / (X / weight0) 
>             = (X / weight) / (X / weight0) 
>             = X / weight * weight0 / X 
>             = weight0 / weight
>         
> 
> So avg ends up being in units of [weight0/weight].
> 
> Then, in order to allow sleeping, we need to have a global clock to sync
> with. Its this global clock that gave me headaches to reconstruct.
> 
> We're looking for a time like this:
> 
>   rq_time := sum(time)/sum(weight)
> 
> And you commented that the /sum(weight) part is where CFS obtained its
> accumulating rounding error? (I'm inclined to believe the error will
> statistically be 0, but I'll readily accept otherwise if you can show a
> practical 'exploit')
> 
> Its not obvious how to do this using modulo logic like Bresenham because
> that would involve using a gcm of all possible weights.

I think I've sent you off into the wrong direction somehow. Sorry. :)

Let's ignore the average for a second, normalized time is maintained as:

	normalized time := time * (2^16 / weight)

The important point is that I keep the value in full resolution of 2^-16 
vsec units (vsec for virtual second or sec/weight, where every tasks gets 
weight seconds for every virtual second, to keep things simpler I also 
omit the nano prefix from the units for a moment). Compared to that CFS 
maintains a global normalized value in 1 vsec units.
Since I don't round the value down I avoid the accumulating error, this 
means that 

	time_norm += time_delta1 * (2^16 / weight)
	time_norm += time_delta2 * (2^16 / weight)

is the same as

	time_norm += (time_delta1 + time_delta2) * (2^16 / weight)

CFS for example does this

	delta_mine = calc_delta_mine(delta_exec, curr->load.weight, lw);

in above terms this means

	time = time_delta * weight * (2^16 / weight_sum) / 2^16

The last shift now rounds the value down and if one does that 1000 times 
per second, the resolution of the value that is finally accounted to 
wait_runtime is also reduced appropriately.

The other rounding problem is based on that this term

	x * prio_to_weight[i] * prio_to_wmult[i] / 2^32

doesn't produce x for most values in that tables (the same applies to the 
weight sum), so if we have chains, where the values are converted from one 
scale to the other, a rounding error is produced. In CFS this happens now 
because wait_runtime is maintained in nanoseconds and fair_clock is a 
normalized value.

The problem here isn't that these errors might have a statistical 
relevance, as they are usually completely overshadowed by measurement 
errors anyway. The problem is that these errors exist at all, this means 
they have to be compensated somehow, so that they don't accumulate over 
time and then become significant. This also has to be seen in the context 
of the overflow checks. All this adds a number of variables to the system 
which considerably increases complexity and makes a thorough analysis 
quite challenging.

So to get back to the average, if you look for this

	rq_time := sum(time)/sum(weight)

you won't find it like this, this basically produces a weighted average 
and I agree this can't really be maintained via the modulo logic (at least 
AFAICT), so I'm using a simple average instead, so if we have:

	time_norm = time/weight

we can write your rq_time like this:

	weighted_avg = sum_{i}^{N}(time_norm_{i}*weight_{i})/sum_{i}^{N}(weight_{i})

this is the formula for a weighted average, so we can aproximate the value 
using a simple average instead:

	avg = sum_{i}^{N}(time_norm_{i})/N

This sum is now what I maintain at runtime incrementally:

	time_{i} = sum_{j}^{S}(time_{j})

	time_norm_{i} = time_{i}/weight_{i}
	              = sum_{j}^{S}(time_{j})/weight_{i}
	              = sum_{j}^{S}(time_{j}/weight_{i})

If I add this up and add weigth0 I get:

	avg*N*weigth0 = sum_{i}^{N}(time_norm_{i})*weight0

and now I have also the needed modulo factors.

The average probably could be further simplified by using a different 
approximation. The question is how perfect this average has to be. The 
average is only used to control when a task gets its share, currently 
higher priority tasks are already given a bit more preference or a sleep 
bonus is added.

In CFS the average already isn't perfect due to above rounding problems, 
otherwise the sum of all updated wait_runtime should be 0 and if a task 
with a wait_runtime value different from 0 is added, fair_clock would have 
to change too to keep the balance.

So unless someone has a brilliant idea, I guess we have to settle for the 
approximation of a perfect scheduler. :) My approach is insofar different 
that I at least maintain an accurate fair share and approximate based on 
this the scheduling decision. This has IMO the advantage that the 
scheduler function can be easily exchanged, one can do it the quick and 
dirty way or one can put in the extra effort to get it closer to 
perfection. Either way every task will get its fair share.

The scheduling function I used is rather simple:

	if (j >= 0 &&
	    ((int)(task[l].time_norm - (task[j].time_norm + SLICE(j))) >= 0 ||
	     ((int)(task[l].time_norm - task[j].time_norm) >= 0 &&
	      (int)(task[l].time_norm - (s + SLICE(l))) >= 0))) {

So a new task is selected if there is a higher priority task or if the 
task has used up its share (unless the other task has lower priority and 
already got its share). It would be interesting to use a dynamic (per 
task) time slice here, which should make it possible to control the 
burstiness that has been mentioned.

> I'm not sure all this is less complex than CFS, I'd be inclined to say
> it is more so.

The complexity is different, IMO the basic complexity to maintain the fair 
share is less and I can add arbitrary complexity to improve scheduling on 
top of it. Most of it comes now from maintaining the accurate average, it 
depends now on how the scheduling is finally done what other optimizations 
are possible.

> Also, I think you have an accumulating error on wakeup where you sync
> with the global clock but fully discard the fraction.

I hope not, otherwise the checks at the end should have triggered. :)
The per task requirement is

	time_norm = time_avg * weight0 + avg_fract

I don't simply discard it, it's accounted to time_norm and then synced to 
the global average.

bye, Roman
