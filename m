Return-Path: <linux-kernel-owner+w=401wt.eu-S1760724AbXKTQCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724AbXKTQCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 11:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756052AbXKTQCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 11:02:20 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:29266 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757170AbXKTQCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 11:02:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=c+q11ZuUi/mLX/RKY5o1Tm7bNxvyG2nUqRiRfZVMCTtp755dcrazfVSIqIWWLcdfSaIKzm2G3StY/d7GN+QZZ395G1pxvWrWHXajlFYoaERH9jiBiO81dbqjhbNGR8AYt3TaKP93PD3TdYt4EhKQeM19HsCkMexOGgem9EgKEfw=  ;
X-YMail-OSG: 6IeeFc4VM1mL.AEc5awDPdhUsw0CHF5DJ5Ae31ytal0549ctap2YGGjMCQUPguXbSikxSnQCiA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
Date: Wed, 21 Nov 2007 02:43:46 +1100
User-Agent: KMail/1.9.5
Cc: Mark Lord <lkml@rtr.ca>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <47425EA5.7000607@rtr.ca> <200711201837.39664.nickpiggin@yahoo.com.au> <20071120064747.2a8036cd@laptopd505.fenrus.org>
In-Reply-To: <20071120064747.2a8036cd@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711210243.46944.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 November 2007 01:47, Arjan van de Ven wrote:
> On Tue, 20 Nov 2007 18:37:39 +1100
>
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > actually.... no. IRQ balancing is not a "fast" decision; every time
> > > you
> >
> > I didn't say anything of the sort. But IRQ load could still fluctuate
> > a lot more rapidly than we'd like to wake up the irqbalancer.
>
> irq load fluctuates by definition. but acting on it faster isn't the
> right thing.

Of course it is, if you want to effectively use your resources.
Imagine if the task balancer only polled once every 10s.


> > > move an interrupt around, you end up causing a really a TON of cache
> > > line bounces, and generally really bad performance
> >
> > All the more reason why the kernel should do it. When I say move it to
> > the kernel, I don't mean because I want to move IRQs 1 000 000 times
> > per second and can't sustain enough context switches to do it in
> > userspace. Userspace basically has insufficient information to do it
> > as well as kernel.
>
> like what?

Knowledge of wakeup events, runqueue load, task and group fairness
requirements, the task balancer's consolidation of load to fewer cores.


> Assuming this is a "once every few seconds" decision (and really it is,
> esp for networking)....

Definitely not always the case. Sometimes fairness is a top concern, in
which case you probably want a lot better response than the hard coded
10 seconds in the userspace thing.


> > > (esp if you do it
> > > for networking ones, since you destroy the packet reassembly stuff
> > > in the tcp/ip stack).
> > >
> > > Instead, what ends up working is if you do high level categories of
> > > interrupt classes and balance within those (so that no 2 networking
> > > irqs are on the same core/package unless you have more nics than
> > > cores)
> >
> > Sure, but you say that like it is difficult information for the kernel
> > to know about. Actually it is much easier. Note that you can still
> > bind interrupts to specific CPUs.
>
> I assume you've read what/how irqbalance does; good luck convincing
> people that that kind of policy belongs in the kernel.

Lots of code to get topology and device information. Some constants
that make assumptions about the machine it is running on and may or may
not agree with what the task scheduler is trying to do. Some
classification stuff which makes guesses about how a particular bit of
hardware or device driver wants to be balanced. Hacks to poll hotplugging
and topology changes.

I'm still convinced. Who isn't?


> > > etc. Balancing on a 10 second scale seems to work quite well; no
> > > need to pull that complexity into the kernel....
> >
> > My perspective is that it isn't a good idea to have such a critical
> > piece of infrastructure outside the kernel.
>
> kernel or kernel source? If there was a good place in the kernel source
> I'd not be against moving irqbalance there. In the kernel... not needed.
> (also because on single socket machines, the irqbalancer basically has
> a one-shot task because there balancing is effectively a static setup)

I don't think that's a good argument for not having it in kernel.


> The same ("critical piece of infrastructure') can be said about other
> things, like udev and ... even hal. Nobody is arguing for moving those
> into the kernel though....

Maybe because there aren't any good arguments. I have good arguments
for irq balancing, though, which aren't invalidated by this observation.


> > I want the kernel to balance interrupts and tasks fairly;
>
> with irqthreads that will come for free soon.

No it won't. It will balance irqthreads. And irqthreads may not even
exist depending on the configuration.


> >maybe move
> > interrupts closer to the tasks they are interacting with (instead of,
> > or combined with our current policy of moving tasks near the
> > interrupts, which can be much more damaging for cache and NUMA);
>
> interrupts and tasks have an N:M relationship.... or sometimes 1:M
> where tasks only depend on one irq. Moving the irq around then tends to
> be a loss. For NUMA, you actually very likely want the IRQ on the node
> that the IO is associdated with.

And the kernel knows all this intimately. And it isn't always that
straightforward. And even if it were for NUMA, you still have SMP
within NUMA.


> > move
> > all interrupts to a single core when there is enough capacity and we
> > are balancing for power savings;
>
> irqbalance does that today.

To the same core which the task scheduler moves tasks? If so, I missed
that. Still, I guess that's the easiest thing to do.


> >do exponential interrupt balancing
> > backoff when it isn't required; etc. Not easy to do all that in
> > userspace.
> >
> > Any reason you actually think it is a good idea, aside from the fact
> > that a userspace solution was able to be better than a crappy old
> > kernel one?
>
> I listed a few;
> 1) it's policy

I don't think that's such a constructive point. Task balancing is
policy in exactly the same way.


> 2) the memory is only needed for a short time (20 seconds or so) on
> single-socket machines

Actually it could be a good idea for fairness and load balancing
to do it more than for a short time. Isn't it easily possible to
have a single socket, multicore system which can overload all cores
with combined IO (including a fair amount of int processing overhead),
but that often runs within CPU capacity?


> 3) it makes decisions on "subjective" information such as interrupt
> device classes that the kernel currently just doesn't have (it could
> grow that obviously), and is clearly policy information.

I'd argue that the kernel, eg. drivers, subsystems, arch code, knows
about this stuff better than irqbalance does anyway.

More out of place IMO, is irqbalance has things like checking for
NAPI turned on in a driver and in that case it does something specific
according to its knowledge of kernel implementation details.
