Return-Path: <linux-kernel-owner+w=401wt.eu-S1754935AbZKWPLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbZKWPLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 10:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbZKWPLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 10:11:52 -0500
Received: from cantor.suse.de ([195.135.220.2]:36124 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbZKWPLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 10:11:51 -0500
Date: Mon, 23 Nov 2009 16:11:52 +0100
From: Nick Piggin <npiggin@suse.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: newidle balancing in NUMA domain?
Message-ID: <20091123151152.GA19175@wotan.suse.de>
References: <20091123112228.GA2287@wotan.suse.de> <1258987059.6193.73.camel@marge.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258987059.6193.73.camel@marge.simson.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 03:37:39PM +0100, Mike Galbraith wrote:
> On Mon, 2009-11-23 at 12:22 +0100, Nick Piggin wrote:
> > Hi,
> > 
> > I wonder why it was decided to do newidle balancing in the NUMA
> > domain? And with newidle_idx == 0 at that.
> > 
> > This means that every time the CPU goes idle, every CPU in the
> > system gets a remote cacheline or two hit. Not very nice O(n^2)
> > behaviour on the interconnect. Not to mention trashing our
> > NUMA locality.
> 
> Painful on little boxen too if left unchained.

Yep. It's an order of magnitude more expensive to go on the
interconnect rather than stay in LLC. So even on little systems,
new idle balancing can become an order of magnitude more
expensive.

On slightly larger systems, where you have an order of magnitude
more cores on remote nodes than local, new idle balancing can now
be two orders of magnitude more expensive.


> > And then I see some proposal to do ratelimiting of newidle
> > balancing :( Seems like hack upon hack making behaviour much more
> > complex.
> 
> That's mine, and yeah, it is hackish.  It just keeps newidle at bay for
> high speed switchers while keeping it available to kick start CPUs for
> fork/exec loads.  Suggestions welcome.  I have a threaded testcase
> (x264) where turning the think off costs ~40% throughput.  Take that
> same testcase (or ilk) to a big NUMA beast, and performance will very
> likely suck just as bad as it does on my little Q6600 box.
> 
> Other than that, I'd be most happy to see the thing crawl back in it's
> cave and _die_ despite the little gain it provides for a kbuild.  It has
> been (is) very annoying.

Wait, you say it was activated to improve fork/exec CPU utilization?
For the x264 load? What do you mean by this? Do you mean it is doing
a lot of fork/exec/exits and load is not being spread quickly enough?
Or that NUMA allocations get screwed up because tasks don't get spread
out quickly enough before running?

In either case, I think newidle balancing is maybe not the right solution.
newidle balancing only checks the system state when the destination
CPU goes idle. fork events increase load at the source CPU. So for
example if you find newidle helps to pick up forks, then if the
newidle event happens to come in before the fork, we'll have to wait
for the next rebalance event.

So possibly making fork/exec balancing more aggressive might be a
better approach. This can be done by reducing the damping idx, or
perhaps some other conditions to reduce eg imbalance_pct or something
for forkexec balancing. Probably needs some studying of the workload
to work out why forkexec is failing.


> > One "symptom" of bad mutex contention can be that increasing the
> > balancing rate can help a bit to reduce idle time (because it
> > can get the woken thread which is holding a semaphore to run ASAP
> > after we run out of runnable tasks in the system due to them 
> > hitting contention on that semaphore).
> 
> Yes, when mysql+oltp starts jamming up, load balancing helps bust up the
> logjam somewhat, but that's not at all why newidle was activated..

OK good to know.

 
> > I really hope this change wasn't done in order to help -rt or
> > something sad like sysbench on MySQL.
> 
> Newidle was activated to improve fork/exec CPU utilization.  A nasty
> side effect is that it tries to rip other loads to tatters.
> 
> > And btw, I'll stay out of mentioning anything about CFS development,
> > but it really sucks to be continually making significant changes to
> > domains balancing *and* per-runqueue scheduling at the same time :(
> > It makes it even difficult to bisect things.
> 
> Yeah, balancing got jumbled up with desktop tweakage.  Much fallout this
> round, and some things still to be fixed back up.

OK. This would be great if fixing up involves making things closer
to what they were rather than adding more complex behaviour on top
of other changes that broke stuff. And doing it in 2.6.32 would be
kind of nice...

