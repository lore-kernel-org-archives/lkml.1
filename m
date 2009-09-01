Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbZIANAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbZIANAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 09:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbZIANAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 09:00:52 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:16142 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339AbZIANAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 09:00:51 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [discuss] BTS overflow handling, was: [PATCH] perf_counter:
 Fix a race on perf_counter_ctx
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EC465F989@irsmsx504.ger.corp.intel.com>
References: <20090808120315.GA14086@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF464@irsmsx504.ger.corp.intel.com>
	 <20090810134608.GA8295@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF78D@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB7725@irsmsx504.ger.corp.intel.com>
	 <1250600348.7583.280.camel@twins> <1250600385.7583.281.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB7775@irsmsx504.ger.corp.intel.com>
	 <1250602664.7583.293.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB77C8@irsmsx504.ger.corp.intel.com>
	 <20090818140022.GB13013@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB77FF@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC465EFC5@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC465F989@irsmsx504.ger.corp.intel.com>
Content-Type: text/plain
Date: Tue, 01 Sep 2009 15:00:46 +0200
Message-Id: <1251810046.7547.13.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-01 at 12:17 +0100, Metzger, Markus T wrote:

> My current theory is that the BTS buffer fills up so quickly when tracing
> the kernel, that the kernel is busy handling overflows and reacting on
> other interrupts that pile up while we're handling the BTS overflow.
> 
> When I trace user-mode branches, it works.
> 
> When I do not copy the trace during overflow handling, the kernel does not hang.

Agreed, that was my suspicion as well. Would you happen to know where to
get these USB debug port cables, and how to find out if a machine
supports this?

> When I attach a jtag debugger to a hung system

Sweet, x86 JTAG.. want.. ;-)

>  (perf top and perf record
> -e branches -c 1), I find that one core is waiting for an smp call
> response, while the other core is busy emptying the BTS buffer.
>
> When I then disable branch tracing (the debugger prevents the kernel
> from changing DEBUGCTL to enable tracing again), the system recovers.
> 
> 
> I have a patch that switches buffers during overflow handling and leaves
> the draining for later (which currently never happens) - the kernel does
> not hang, in that case.
> 
> I do need 3 buffers of 2048 entries = 3x48 pages per cpu, though. 

And those pages have to be contiguous too, right? That's an order-6
alloc, painful.

> One buffer
> to switch in during overflow handling; another to switch in during sched_out
> (assuming that we need to schedule out the traced task before we may start
> the draining task). Even then, there's a chance that we will lose trace
> when the draining task may not start immediately. I would even say that
> this is quite likely.

Right, is it possible to detect this loss?

This makes me wonder how much time it takes to drain these buffers, it
is at all possible to optimize that code path into oblivion, or will
nothing be fast enough?

> What I do not have, yet, is the actual draining. Draining needs to start
> after the counter has been disabled. But draining needs the perf_counter
> to drain the trace into. The counter will thus be busy after it has been
> disabled - ugly.

Yes, this is a tad weird...

> There already seems to be something in place regarding deferring work, i.e.
> perf_counter_do_pending(). Would it be OK if I added the deferred BTS buffer
> draining to that?

Yes, note that this pending work runs from hardirq context as well. On
x86 we self-ipi to get into IRQ context ASAP after the NMI.

So if the remote cpu is blocked waiting on an SMP call, doing the work
from hardirq context won't really help things.

> Looks like this would guarantee that the counter does not go away as long
> as there is work pending. Is this correct?

Agreed, it waits for all pending bits to complete before destroying the
counter.

> In any case, this is getting late for the upcoming merge window.
> Would you rather drop the BTS patch or disable kernel tracing?

I don't think we need to drop it, at worst we could defer the patch
to .33, but I think we can indeed get away with disabling the kernel
tracing for now.

