Return-Path: <linux-kernel-owner+w=401wt.eu-S1763581AbZDALxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763581AbZDALxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762594AbZDALxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:53:11 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:52448 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762636AbZDALxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:53:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18899.21916.855073.509885@cargo.ozlabs.ibm.com>
Date: Wed, 1 Apr 2009 22:53:00 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] perf_counter: provide generic callchain bits
In-Reply-To: <20090401100015.GD27865@elte.hu>
References: <20090330170701.856843742@chello.nl>
	<20090330171024.254266860@chello.nl>
	<18897.46177.528910.51044@cargo.ozlabs.ibm.com>
	<1238481552.28248.1384.camel@twins>
	<49D1C544.7020403@linux.vnet.ibm.com>
	<18897.56973.324304.995540@cargo.ozlabs.ibm.com>
	<1238508032.8530.278.camel@twins>
	<18898.58399.957182.181124@drongo.ozlabs.ibm.com>
	<1238572744.8530.2541.camel@twins>
	<18899.10669.917693.67352@cargo.ozlabs.ibm.com>
	<20090401100015.GD27865@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> So it's a bit like PEBS and IBS on the x86, right?

Well, my hazy impression was that one or both of those wrote samples
into a ring buffer in hardware, which would be different...

> In theory one could simply override the sampled ptregs->ip with this 
> more precise register value. The instruction where the IRQ hit is 
> probably meaningless, if more precise information is available. But 
> we can have both too i guess.
> 
> The data address extension definitely makes sense - it can be used 
> to for a profile view along the data symbol dimension, instead of 
> the usual function symbol dimension.
> 
> CPU flags makes sense too - irqs-off can help the annotation of 
> source code sections where the profiler sees that irqs were 
> disabled.
> 
> It seems here we gradually descend into arch-specific CPU state 
> technicalities and it's not immediately obvious where to draw the 
> line.

I hoped that event instruction address, event data address and cpu
flags, at least, would be sufficiently abstract to consider having as
generic things, though of course how you get to them is
arch-specific.  The main use of event flags is to know whether or not
the event instruction/data address values are valid.  Instead of
recording the event flags we could just not put the event instr/data
address records in the ring buffer if the values aren't valid
(e.g. the event data address won't be valid if the instruction doesn't
access memory).

> Call-chain and data address abstractions are clear. CPU flags is 
> less clear: we could perhaps split off the irq state and the 
> privilege level information - that is present on all CPUs.

In a machine-independent format, you mean?  That would be a good idea.

> The rest should probably be opaque and not generalized.

And can be provided on a per-arch basis using special raw event code
values.

> _Perhaps_, to stem the inevitable list of such small details, it 
> might make sense to have a record type with signal frame qualities - 
> which would include most of this info. That would mix well with the 
> planned feature of signal generation anyway, right?

Hmmm, so record the entire architected state of the machine, and
effectively put an entire ucontext_t in the ring buffer?  That's
certainly possible - what would we use it for?

> I.e. we could extend the lowlevel sigcontext signal frame generation 
> code in arch/x86/kernel/signal.c (and its powerpc equivalent) to 
> generate a signal frame but output it into the mmap buffer, not into 
> the userspace stack - and we would not actually execute a signal in 
> that context.
> 
>  [ of course, when the counter is configured to generate a signal 
>    that is done too. The code would be dual purpose. ]
> 
> So user-space would get a fully signal frame compatible record - and 
> we'd not have to create a per arch ABI for this because we'd piggy 
> back to the signal frame format.
> 
> We could add SA_NOFPU support for fast-track integer-registers-only 
> frames, etc.
> 
> Hm?

I think the motivation for having the stop-and-signal behaviour is not
so much to get at the entire register set, as to have a way to profile
application-dependent things, i.e. you'd record or histogram something
derived from memory contents at the time the signal was delivered.
Or you might want to do a stack trace but use unwind information to
get the parameters to each function (which on powerpc could now be in
any register or saved onto the stack, once you start going up the call
chain any distance), which is more than we want to do in the kernel.

Paul.
