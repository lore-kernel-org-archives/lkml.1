Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbXKTOus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbXKTOus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 09:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbXKTOul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 09:50:41 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41430 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583AbXKTOuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 09:50:40 -0500
Date: Tue, 20 Nov 2007 06:47:47 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mark Lord <lkml@rtr.ca>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
Message-ID: <20071120064747.2a8036cd@laptopd505.fenrus.org>
In-Reply-To: <200711201837.39664.nickpiggin@yahoo.com.au>
References: <47425EA5.7000607@rtr.ca>
	<200711201517.16171.nickpiggin@yahoo.com.au>
	<20071119213727.16d5917b@laptopd505.fenrus.org>
	<200711201837.39664.nickpiggin@yahoo.com.au>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007 18:37:39 +1100
Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > actually.... no. IRQ balancing is not a "fast" decision; every time
> > you
> 
> I didn't say anything of the sort. But IRQ load could still fluctuate
> a lot more rapidly than we'd like to wake up the irqbalancer.

irq load fluctuates by definition. but acting on it faster isn't the
right thing.
> 
> 
> > move an interrupt around, you end up causing a really a TON of cache
> > line bounces, and generally really bad performance
> 
> All the more reason why the kernel should do it. When I say move it to
> the kernel, I don't mean because I want to move IRQs 1 000 000 times
> per second and can't sustain enough context switches to do it in
> userspace. Userspace basically has insufficient information to do it
> as well as kernel.

like what?
Assuming this is a "once every few seconds" decision (and really it is,
esp for networking)....
> 
> 
> > (esp if you do it 
> > for networking ones, since you destroy the packet reassembly stuff
> > in the tcp/ip stack).
> >
> > Instead, what ends up working is if you do high level categories of
> > interrupt classes and balance within those (so that no 2 networking
> > irqs are on the same core/package unless you have more nics than
> > cores)
> 
> Sure, but you say that like it is difficult information for the kernel
> to know about. Actually it is much easier. Note that you can still
> bind interrupts to specific CPUs.

I assume you've read what/how irqbalance does; good luck convincing
people that that kind of policy belongs in the kernel.
> 
> 
> > etc. Balancing on a 10 second scale seems to work quite well; no
> > need to pull that complexity into the kernel....
> 
> My perspective is that it isn't a good idea to have such a critical
> piece of infrastructure outside the kernel.

kernel or kernel source? If there was a good place in the kernel source
I'd not be against moving irqbalance there. In the kernel... not needed.
(also because on single socket machines, the irqbalancer basically has
a one-shot task because there balancing is effectively a static setup)

The same ("critical piece of infrastructure') can be said about other
things, like udev and ... even hal. Nobody is arguing for moving those
into the kernel though....

> 
> I want the kernel to balance interrupts and tasks fairly; 

with irqthreads that will come for free soon.

>maybe move
> interrupts closer to the tasks they are interacting with (instead of,
> or combined with our current policy of moving tasks near the
> interrupts, which can be much more damaging for cache and NUMA);

interrupts and tasks have an N:M relationship.... or sometimes 1:M
where tasks only depend on one irq. Moving the irq around then tends to
be a loss. For NUMA, you actually very likely want the IRQ on the node
that the IO is associdated with.

> move
> all interrupts to a single core when there is enough capacity and we
> are balancing for power savings; 

irqbalance does that today.

>do exponential interrupt balancing
> backoff when it isn't required; etc. Not easy to do all that in
> userspace.
> 
> Any reason you actually think it is a good idea, aside from the fact
> that a userspace solution was able to be better than a crappy old
> kernel one?

I listed a few;
1) it's policy 
2) the memory is only needed for a short time (20 seconds or so) on
single-socket machines
3) it makes decisions on "subjective" information such as interrupt
device classes that the kernel currently just doesn't have (it could
grow that obviously), and is clearly policy information.




-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
