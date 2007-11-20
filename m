Return-Path: <linux-kernel-owner+w=401wt.eu-S1762548AbXKTTK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762548AbXKTTK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 14:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbXKTTKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 14:10:21 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59030 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758644AbXKTTKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 14:10:19 -0500
Date: Tue, 20 Nov 2007 11:07:26 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mark Lord <lkml@rtr.ca>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
Message-ID: <20071120110726.4cc2995e@laptopd505.fenrus.org>
In-Reply-To: <200711210243.46944.nickpiggin@yahoo.com.au>
References: <47425EA5.7000607@rtr.ca>
	<200711201837.39664.nickpiggin@yahoo.com.au>
	<20071120064747.2a8036cd@laptopd505.fenrus.org>
	<200711210243.46944.nickpiggin@yahoo.com.au>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007 02:43:46 +1100
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Wednesday 21 November 2007 01:47, Arjan van de Ven wrote:
> > On Tue, 20 Nov 2007 18:37:39 +1100
> >
> > Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > > actually.... no. IRQ balancing is not a "fast" decision; every
> > > > time you
> > >
> > > I didn't say anything of the sort. But IRQ load could still
> > > fluctuate a lot more rapidly than we'd like to wake up the
> > > irqbalancer.
> >
> > irq load fluctuates by definition. but acting on it faster isn't the
> > right thing.
> 
> Of course it is, if you want to effectively use your resources.
> Imagine if the task balancer only polled once every 10s.

but unlike the task balancer, moving an irq is really expensive.
(at least for networking and a few other similar systems)
ANd no it's not just the cache bouncing, it's the entire reassembly of
multiple packets etc etc that gets really messy.


> >
> > I assume you've read what/how irqbalance does; good luck convincing
> > people that that kind of policy belongs in the kernel.
> 
> Lots of code to get topology and device information.

yes this would go away in the kernel

> Some constants
> that make assumptions about the machine it is running on and may or
> may not agree with what the task scheduler is trying to do.

> Some
> classification stuff which makes guesses about how a particular bit of

you misunderstood this; the classification stuff is there to spread
different irqs of similar class (say networking) over multiple
cores/packages. Doing this is a system resource balancing proposition
not just a cpu time one. 

You may think this spreading based on classification is a mistake, but
it's based on the following observation: 
1) servers with multiple network cards serving internet traffic out
really need to load balance their loads; this is for various per-cpu
resource reasons (such as per cpu memory pools) to be evenly used. It
also makes sure that under network spikes on both interfaces, the
response is sane
2) servers with multiple IO devices need this to be spread out, just
think of oracle etc.

for both you could argue "but we could balance this based on actual
observed load in some way", but you can only do that if you rebalance
at a relatively high frequency, which you really don't want to do for
networking and probably even storage.

We used to rebalance this frequently in the 2.4-early kernels based on
a patch from Ingo. Turned out to be a really really bad idea;
performance really tanked.

> hardware or device driver wants to be balanced. Hacks to poll
> hotplugging and topology changes.

"hacks" as in "rescan".. so falls under the topology code and would
indeed be changed to hook into hotplug inside the kernel; just
different complexity.

> 
> I'm still convinced. Who isn't?

I know you can do SOME sort of balancing in the kernel. But please
describe the algorithm you would use; I started out with the same
thought but when it got down to the algorithm to me at least it became
clear "we really don't want this complexity in kernel mode".



> > > > etc. Balancing on a 10 second scale seems to work quite well; no
> > > > need to pull that complexity into the kernel....
> > >
> > > My perspective is that it isn't a good idea to have such a
> > > critical piece of infrastructure outside the kernel.
> >
> > kernel or kernel source? If there was a good place in the kernel
> > source I'd not be against moving irqbalance there. In the kernel...
> > not needed. (also because on single socket machines, the
> > irqbalancer basically has a one-shot task because there balancing
> > is effectively a static setup)
> 
> I don't think that's a good argument for not having it in kernel.

if you don't care about kernel unpagable memory footprint, fine.
Others do.


> > The same ("critical piece of infrastructure') can be said about
> > other things, like udev and ... even hal. Nobody is arguing for
> > moving those into the kernel though....
> 
> Maybe because there aren't any good arguments. I have good arguments
> for irq balancing, though, which aren't invalidated by this
> observation.

I'm not arguing against doing irqbalancing per se (heck that's why I
wrote irqbalance); just that every time I try to do it in kernel the
complexity to get the behavior people (and benchmarks) want turns me
right off that again.

> 
> 
> > > I want the kernel to balance interrupts and tasks fairly;
> >
> > with irqthreads that will come for free soon.
> 
> No it won't. It will balance irqthreads.

and it will know how much cpu they take and it'll move work around to
compensate for any unfairness. CFS is really good at that.

> > >maybe move
> > > interrupts closer to the tasks they are interacting with (instead
> > > of, or combined with our current policy of moving tasks near the
> > > interrupts, which can be much more damaging for cache and NUMA);
> >
> > interrupts and tasks have an N:M relationship.... or sometimes 1:M
> > where tasks only depend on one irq. Moving the irq around then
> > tends to be a loss. For NUMA, you actually very likely want the IRQ
> > on the node that the IO is associdated with.
> 
> And the kernel knows all this intimately. And it isn't always that
> straightforward. And even if it were for NUMA, you still have SMP
> within NUMA.

for now yes. I agree the kernel "knows" this to some form (well it
COULD know). I just don't believe the "extra" information it has is in
practice useful for making decisions on.


> 
> 
> > > move
> > > all interrupts to a single core when there is enough capacity and
> > > we are balancing for power savings;
> >
> > irqbalance does that today.
> 
> To the same core which the task scheduler moves tasks? If so, I missed
> that. Still, I guess that's the easiest thing to do.

yes; the power aware scheduler also moves processes to the first
package .. as does irqbalance.

> >
> > I listed a few;
> > 1) it's policy
> 
> I don't think that's such a constructive point. Task balancing is
> policy in exactly the same way.

not really; CFS has shown that.... the only real policy in task
balancing is the fairness part, and that seems to be general accepted
as the right thing.



> More out of place IMO, is irqbalance has things like checking for
> NAPI turned on in a driver and in that case it does something specific
> according to its knowledge of kernel implementation details.

no it doesn't; it uses "packet counts" to deal with NAPI and other
effects such as irq mitigation to get a more accurate estimate of load
caused by an irq, but it's not fair to call this inappropriate checking
for NAPI being turned on.




-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
