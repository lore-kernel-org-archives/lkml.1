Return-Path: <linux-kernel-owner+w=401wt.eu-S1758573AbZDBM07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbZDBM07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757541AbZDBM0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:26:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34008 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757548AbZDBM0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:26:35 -0400
Date: Thu, 2 Apr 2009 14:26:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] RFC perf_counter: singleshot support
Message-ID: <20090402122616.GB24618@elte.hu>
References: <20090402091158.291810516@chello.nl> <20090402091319.257773792@chello.nl> <20090402105151.GB10828@elte.hu> <1238672893.8530.5909.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238672893.8530.5909.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2009-04-02 at 12:51 +0200, Ingo Molnar wrote:
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > By request, provide a way for counters to disable themselves and 
> > > signal at the first counter overflow.
> > > 
> > > This isn't complete, we really want pending work to be done ASAP 
> > > after queueing it. My preferred method would be a self-IPI, that 
> > > would ensure we run the code in a usable context right after the 
> > > current (IRQ-off, NMI) context is done.
> > 
> > Hm. I do think self-IPIs can be fragile but the more work we do 
> > in NMI context the more compelling of a case can be made for a 
> > self-IPI. So no big arguments against that.
> 
> Its not only NMI, but also things like software events in the 
> scheduler under rq->lock, or hrtimers in irq context. You cannot 
> do a wakeup from under rq->lock, nor hrtimer_cancel() from within 
> the timer handler.
> 
> All these nasty little issues stack up and could be solved with a 
> self-IPI.
>
> Then there is the software task-time clock which uses 
> p->se.sum_exec_runtime which requires the rq->lock to be read. 
> Coupling this with for example an NMI overflow handler gives an 
> instant deadlock.

Ok, convinced.

> Would you terribly mind if I remove all that sum_exec_runtime and 
> rq->lock stuff and simply use cpu_clock() to keep count. These 
> things get context switched along with tasks anyway.

Sure. One sidenote - the precision of sw clocks has dropped a bit 
lately:

aldebaran:~/linux/linux/Documentation/perf_counter> ./perfstat -e 
1:0 -e 1:0 -e 1:0 -e 1:0 -e 1:0 sleep 1

 Performance counter stats for 'sleep':

       0.762664  cpu clock ticks      (msecs)
       0.761440  cpu clock ticks      (msecs)
       0.760977  cpu clock ticks      (msecs)
       0.760587  cpu clock ticks      (msecs)
       0.760287  cpu clock ticks      (msecs)

 Wall-clock time elapsed:  1003.139373 msecs

See that slight but noticeable skew? This used to work fine and we 
had the exact same value everywhere. Can we fix that while still 
keeping the code nice?

> Except I probably should look into this pid-namespace mess and 
> clean all that up.

yeah. Hopefully it's all just a matter of adding or removing a 'v' 
somewhere. Get a bit more complicated with system-wide counters 
though.

> >  - 'event limit' attribute: the ability to pause new events after N 
> >    events. This limit auto-decrements on each event.
> >    limit==1 is the special case for single-shot.
> 
> That should go along with a toggle on what an event is I suppose, 
> either an 'output' event or a filled page?
> 
> Or do we want to limit that to counter overflow?

I think the proper form to rate-limit events and do buffering, 
without losing events, is to have an attribute that sets a 
buffer-full event threshold in bytes. That works well with variable 
sized records. That threshold would normally be set to a multiple of 
PAGE_SIZE - with a sensible default of half the mmap area or so?

Right?

> >  - new ioctl method to refill the limit, when user-space is ready to 
> >    receive new events. A special-case of this is when a signal 
> >    handler calls ioctl(refill_limit, 1) in the single-shot case - 
> >    this re-enables events after the signal has been handled.
> 
> Right, with the method implemented above, its simply a matter of 
> the enable ioctl.

ok.

> > Another observation: i think perf_counter_output() needs to 
> > depend on whether the counter is signalling, not on the 
> > single-shot-ness of the counter.
> > 
> > A completely valid use of this would be for user-space to create 
> > an mmap() buffer of 1024 events, then set the limit to 1024, and 
> > wait for the 1024 events to happen - process them and close the 
> > counter. Without any signalling.
> 
> Say we have a limit > 1, and a signal, that would mean we do not 
> generate event output?

I think we should have two independent limits that both may generate 
wakeups.

We have a stream of events filling in records in a buffer area. That 
is a given and we have no real influence over them happening (in a 
loss free model).

There's two further, independent properties here that make further 
sense to manage:

 1) what happens on the events themselves

 2) the buffer space gets squeezed

Here we have buffering and hence discretion over what happens, how 
frequently we wake up and what we do on each individual event.

For the #2 buffer space, in the view of variable size records, the 
best metric is bytes i think. The best default is 'half of the mmap 
area'. This should influence the wakeup behavior IMO. We only wake 
up if buffer space gets tight. (User-space can time out its poll() 
call and thus get a timely recording of even smaller-than-threshold 
events)

For the #1 'what happens on events' independent case, by default is 
that nothing happens. If the signal number is set, we send a signal 
- but the buffer space management itself remains independent and we 
may or may not wake up, depending on the 'bytes left' metric.

I think the 'trigger limit' threshold is a third independent 
attribute which actively throttles output [be that a signal, output 
into the buffer space, or both] - if despite the wakeup (or us 
sending a signal) nothing happened and we've got too much overlap.

The most common special case for the trigger limit would be in 
signal generation mode, with a value of 1. This means the counter 
turns off after each signal.

Remember the 'lost events' value patch in the header mmap area? This 
would be useful here: if the kernel has to throttle due to hitting 
the limit, it would set the overflow counter?

If this gets needlessly complex/weird in the code itself then i made 
a thinko somewhere and we need to reconsider. :-)

	Ingo
