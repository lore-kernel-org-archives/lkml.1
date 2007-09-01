Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbXIAGso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbXIAGso (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 02:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbXIAGsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 02:48:35 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1789 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbXIAGse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 02:48:34 -0400
Date: Sat, 1 Sep 2007 08:48:53 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
In-Reply-To: <20070831105447.GA17956@elte.hu>
Message-ID: <Pine.LNX.4.64.0709010206400.1817@scrub.home>
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home> <20070831105447.GA17956@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 31 Aug 2007, Ingo Molnar wrote:

Maybe I should explain for everyone else (especially after seeing some of 
the comments on kerneltrap), why I reacted somewhat irritated on what 
looks like such an innocent mail.
The problem is without the necessary background one can't know how wrong 
such statements as this are, the level of confidence is amazing though:

> Peter's work fully solves the rounding corner-cases you described as:

I'd expect Ingo to know better, but the more he refuses to answer my 
questions, the more I doubt it, at least than it comes to the math part.

While Peter's patches are interesting, they are only a small step to what 
I'm trying to achieve. With these patches the basic CFS math pretty much 
looks like this:

        sum_{t}^{T}(round(time_{t} * round(WMULT / weight_{t}) * WEIGTH0 / WMULT))
	= sum_{r}^{R}(round(time_{r} * round(WMULT / weight_sum) * WEIGTH0 / WMULT))

It's based on this equation:

	sum_{t}^{T}(time_{t} / weight_{t}) = sum_{r}^{R}(time_{r} / weight_sum)

This is the time a single task gets relative to the the runtime of all 
tasks. These sums are incrementally added/substracted to wait_runtime and 
it should stay around zero.

All Peter's wait_runtime-scale patch does is to move the weight_{t} from 
one side to the other and that's it, it changes _nothing_ about the 
rounding above - "the rounding corner-cases" are still there.

In my announcement I describe now in quite some detail, how I get rid of 
this rounding effect. The only rounding from above equation which is still 
left is "round(WMULT / weight_{t})", but this is luckily a constant and so 
is the time one task gets relative to another (unless reniced).

Anyone who has actually read and understood what I wrote will hopefully 
realize what complete nonsense a statement like this is:

> So the most intrusive (math) aspects of your patch have been implemented
> already for CFS (almost a month ago), in a finegrained way.

I'm not repeating again the whole math here, if anyone has questions about 
it, I'll try my best to answer them. So instead here are some of the 
intrusive aspects, which supposedly have been implemented already.

One key difference is that I don't maintain the global sum (fair_clock) 
directly anymore, I can calculate it if needed, but it's not used to 
update wait_runtime anymore. This has the advantage that the whole 
rounding involved in it has no influence anymore on how much time a task 
gets. Without this value the whole math around how to schedule a task is 
quite different as well.

Another key difference is that I got rid of (WEIGTH0 / WMULT), this has 
the advantage that it completely gets rid of the problematic rounding and 
the scheduler can be now finally precise as the hardware allows it. 
OTOH this has consequences for the range of values, as they can and are 
expected to overflow now after some time, which the math has to take into 
account.

One positive side effect of these overflows is that I can reduce the 
resolution the scheduler is working with and thus I can get rid of pretty 
much all of the 64bit math, if the reduced resolution is sufficient, e.g. 
for all archs which have a jiffies based scheduler clock, but even 
embedded archs might like it.

> So if you'd like to work with us on this and get items that make sense 
> merged (which we'd very much like to see happen), could you please 
> re-shape the rest of your changes and ideas (such as whether to use 
> ready-queueing or a runqueue concept, which does look interesting) ontop 
> of Peter's queue, and please do it as a finegrained, reviewable, 
> mergable series of patches, like Peter did. Thanks!

The funny thing is it should be no that hard to split the patch, but that 
wasn't point. The point is to discuss the differences - how the different 
approach effects the scheduling decisions, as the new scheduler maintains 
somewhat different values. If I'm now told "it's just the same thing 
mathematically", which is provably nonsense, I'm a little stunned and the 
point that aggravates me is that most people simply are going to believe 
Ingo, because they don't understand the issue (and they don't really have 
to). I'm still amazed how easily Ingo can just ignore the main part of my 
work and still gets away with it. The last thing I want is yet another 
flame war, all I want is that this work is taken seriously, but it took 
Ingo less than 9 hours to get to a thorough judgement...

bye, Roman
