Return-Path: <linux-kernel-owner+w=401wt.eu-S1753673AbYCQI3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbYCQI3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 04:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYCQI2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 04:28:54 -0400
Received: from 1wt.eu ([62.212.114.60]:2503 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbYCQI2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 04:28:53 -0400
Date: Mon, 17 Mar 2008 09:26:38 +0100
From: Willy Tarreau <w@1wt.eu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ray Lee <ray-lk@madrabbit.org>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, "LKML," <linux-kernel@vger.kernel.org>
Subject: Re: Poor PostgreSQL scaling on Linux 2.6.25-rc5 (vs 2.6.22)
Message-ID: <20080317082638.GB18229@1wt.eu>
References: <200803111749.29143.nickpiggin@yahoo.com.au> <2c0942db0803162216r1892782bsc894d4188b51481b@mail.gmail.com> <20080317052134.GD13012@1wt.eu> <200803171819.38892.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803171819.38892.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 06:19:38PM +1100, Nick Piggin wrote:
> On Monday 17 March 2008 16:21, Willy Tarreau wrote:
> > On Sun, Mar 16, 2008 at 10:16:36PM -0700, Ray Lee wrote:
> > > On Sun, Mar 16, 2008 at 5:44 PM, Nick Piggin <nickpiggin@yahoo.com.au> 
> > > > Can this be changed by default, please?
> > >
> > > Not without benchmarks of interactivity, please. There are far, far
> > > more linux desktops than there are servers. People expect to have to
> > > tune servers (I do, for the servers I maintain). People don't expect
> > > to have to tune a desktop to make it run well.
> >
> > Oh and even on servers, when your anti-virus proxy reaches a load of 800,
> > you're happy no to have too large a time-slice so that you regularly get
> > a chance of being allowed to type in commands over SSH.
> 
> Your ssh session should be allowed to run anyway. I don't see the difference.
> If the runqueue length is 100 and the time-slice is (say) 10ms, then if your
> ssh only needs average of 5ms of CPU time per second, then it should be run
> next when it becomes runnable. If it wants 20ms of CPU time per second, then
> it has to wait for 2 seconds anyway to be run next, regardless of whether
> the timeslice was 10ms or 20ms.

It's not about what *ssh* uses but about what *others* use. Except by
renicing SSH or marking it real-time, it has no way to say "give the
CPU to me right now, I have something very short to do". So it will
have to wait for the 100 other tasks to eat their 10ms, waiting 1 second
to consume 5ms of CPU (and I was speaking about 800 and not 100).

It is one of the situations where I prefer to shorten timeslices when
load increases because it will not slow down the service too much, but
will still provide better interactivity, which is also benefical to the
service itself since there is no reason for the cycles usage to be the
same for all processes. So by having a finer granularity, small CPU eaters
will finish sooner.

> > Large time-slices are needed only in HPC environments IMHO, where only
> > one task runs.
> 
> That's silly. By definition if there is only one task running, you don't
> care what the timeslice is.

I mean there's only one important task. There is always a bit of pollution
around it, and interrupting the tasks less often slightly reduces the
context-switch overhead.

> We actually did conduct some benchmarks, and a 10ms timeslice can start
> hurting even things like kbuild quite a bit.
> 
> But anyway, I don't care what the time slice is so much (although it should
> be higher -- if the scheduler can't get good interactive behaviour with a
> 20-30ms timeslice in most cases then it's no good IMO). I care mostly that
> the timeslice does not decrease when load increases.

On the opposite, I think it's a fundamental requirement if you need to
maintain a reasonable interactivity, and a fair progress between all
tasks. I think it's obvious to understand that the only way to maintain
a constant latency with a growing number of tasks is to reduce the time
each task may spend on the CPU. Contrary to other domains such as network,
you don't know how much time a task will spend on the CPU if you grant an
access to it, and there is no way to know because only the work that this
task will perform will determine if it should run shorter or longer. Fair
scheduling in other areas such as network is "easier" because you know the
size of your packets so you know how much time they will take on the wire.

Here with tasks, the best you can do is estimating based on history. But
it will be very rare when you'll be able to correctly guess and guarantee
that the latency is correct.

Maybe the timeslices should shrink only past a certain load though (I don't
know how it's done today).

Regards,
willy

