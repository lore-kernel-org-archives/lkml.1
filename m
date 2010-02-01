Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab0BAIvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 03:51:38 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46126 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab0BAIvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 03:51:37 -0500
Subject: Re: High scheduler wake up times
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100130164716.230dfe31@infradead.org>
References: <20100130234551.GA27390@mediacenter.gateway.2wire.net>
	 <20100130161114.07278221@infradead.org>
	 <20100131003549.GC27390@mediacenter.gateway.2wire.net>
	 <20100130164716.230dfe31@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 09:51:30 +0100
Message-ID: <1265014290.24455.98.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-30 at 16:47 -0800, Arjan van de Ven wrote:
> On Sat, 30 Jan 2010 18:35:49 -0600
> Shawn Bohrer <shawn.bohrer@gmail.com> wrote:
> \
> > 
> > I agree that we are currently depending on a bug in epoll.  The epoll
> > implementation currently rounds up to the next jiffie, so specifying a
> > timeout of 1 ms really just wakes the process up at the next timer
> > tick. I have a patch to fix epoll by converting it to use
> > schedule_hrtimeout_range() that I'll gladly send, but I still need a
> > way to achieve the same thing.
> 
> it's not going to help you; your expectation is incorrect.
> you CANNOT get 1000 iterations per second if you do
> 
> <wait 1 msec>
> <do a bunch of work>
> <wait 1 msec>
> etc in a loop
> 
> the more accurate (read: not rounding down) the implementation, the
> more not-1000 you will get, because to hit 1000 the two actions
> 
> <wait 1 msec>
> <do a bunch of work>
> 
> combined are not allowed to take more than 1000 microseconds wallcock
> time. Assuming "do a bunch of work" takes 100 microseconds, for you to
> hit 1000 there would need to be 900 microseconds in a milliseconds...
> and sadly physics don't work that way.
> 
> (and that's even ignoring various OS, CPU wakeup and scheduler
> contention overheads)

Right, aside from that, CFS will only (potentially) delay your wakeup if
there's someone else on the cpu at the moment of wakeup, and that's
fully by design, you don't want to fix that, its bad for throughput.

If you want deterministic wakeup latencies use a RT scheduling class
(and kernel).

Fwiw, your test proglet gives me:

peter@laptop:~/tmp$ ./epoll
Iterations Per Sec: 996.767947
Iterations Per Sec: 995.424135
Iterations Per Sec: 993.624936

and that's with full contemporary desktop bloat around.

As it stand it appears you have at least two bugs in your application,
you rely on broken epoll behaviour and you have incorrect assumptions on
what the regular scheduler class will guarantee you (which is in fact
nothing other than that your application will at one point in the future
receive some service, per posix).

Now CFS stives to gives you more guarantees than that, but they're soft.
We try to schedule such that your application will receive a
proportional amount of service to every other runnable task of the same
nice level (and there's a weighted proportion between nice levels as
well), furthermore we try to service each task at least once per
nr_running*sysctl.kernel.sched_min_granularity_ns. If you see wakeup
latencies an order of magnitude over that, we clearly messed up, but
until that point we're doing ok-ish.

