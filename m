Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbZDAKAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbZDAKAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 06:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbZDAKAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 06:00:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34682 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbZDAKAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 06:00:30 -0400
Date: Wed, 1 Apr 2009 12:00:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] perf_counter: provide generic callchain bits
Message-ID: <20090401100015.GD27865@elte.hu>
References: <20090330170701.856843742@chello.nl> <20090330171024.254266860@chello.nl> <18897.46177.528910.51044@cargo.ozlabs.ibm.com> <1238481552.28248.1384.camel@twins> <49D1C544.7020403@linux.vnet.ibm.com> <18897.56973.324304.995540@cargo.ozlabs.ibm.com> <1238508032.8530.278.camel@twins> <18898.58399.957182.181124@drongo.ozlabs.ibm.com> <1238572744.8530.2541.camel@twins> <18899.10669.917693.67352@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18899.10669.917693.67352@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Peter Zijlstra writes:
> 
> > Ah, yes, I see how that can confuse. PERF_EVENT_COUNTER_OVERFLOW then?
> 
> Sounds reasonable.
> 
> > > Also, let's add PERF_RECORD/PERF_EVENT bits for:
> > > 
> > > * EVENT_INSTR_ADDR
> > 
> > I'm failing to come up with what this could be..
> 
> So, you have lots of instructions in flight in the processor, and 
> one of them causes an event that increments a counter and causes 
> it to overflow, so an interrupt request is generated.  Even if the 
> interrupt is taken "immediately", it can still happen that the set 
> of instructions the processor decides to complete before taking 
> the interrupt includes some instructions after the instruction 
> that caused the counter to overflow, and of course if interrupts 
> are (hard-) disabled at the time of the overflow, the interrupt 
> will happen later.  That means that the IP from the pt_regs is not 
> generally a reliable indication of which instruction made the 
> counter overflow.
> 
> On POWER processors we have a register which gives us a much more 
> reliable indication of which instruction caused the counter 
> overflow, at least in those cases where the event can be 
> attributed to a specific instruction.  This EVENT_INSTR_ADDR bit 
> would ask for that register to be sampled and recorded.

So it's a bit like PEBS and IBS on the x86, right?

In theory one could simply override the sampled ptregs->ip with this 
more precise register value. The instruction where the IRQ hit is 
probably meaningless, if more precise information is available. But 
we can have both too i guess.

The data address extension definitely makes sense - it can be used 
to for a profile view along the data symbol dimension, instead of 
the usual function symbol dimension.

CPU flags makes sense too - irqs-off can help the annotation of 
source code sections where the profiler sees that irqs were 
disabled.

It seems here we gradually descend into arch-specific CPU state 
technicalities and it's not immediately obvious where to draw the 
line.

Call-chain and data address abstractions are clear. CPU flags is 
less clear: we could perhaps split off the irq state and the 
privilege level information - that is present on all CPUs.

The rest should probably be opaque and not generalized.

_Perhaps_, to stem the inevitable list of such small details, it 
might make sense to have a record type with signal frame qualities - 
which would include most of this info. That would mix well with the 
planned feature of signal generation anyway, right?

I.e. we could extend the lowlevel sigcontext signal frame generation 
code in arch/x86/kernel/signal.c (and its powerpc equivalent) to 
generate a signal frame but output it into the mmap buffer, not into 
the userspace stack - and we would not actually execute a signal in 
that context.

 [ of course, when the counter is configured to generate a signal 
   that is done too. The code would be dual purpose. ]

So user-space would get a fully signal frame compatible record - and 
we'd not have to create a per arch ABI for this because we'd piggy 
back to the signal frame format.

We could add SA_NOFPU support for fast-track integer-registers-only 
frames, etc.

Hm?

	Ingo
