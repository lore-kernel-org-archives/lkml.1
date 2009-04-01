Return-Path: <linux-kernel-owner+w=401wt.eu-S1759366AbZDAJco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366AbZDAJco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 05:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761564AbZDAJcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 05:32:15 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:59364 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761396AbZDAJcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 05:32:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18899.10669.917693.67352@cargo.ozlabs.ibm.com>
Date: Wed, 1 Apr 2009 19:45:33 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] perf_counter: provide generic callchain bits
In-Reply-To: <1238572744.8530.2541.camel@twins>
References: <20090330170701.856843742@chello.nl>
	<20090330171024.254266860@chello.nl>
	<18897.46177.528910.51044@cargo.ozlabs.ibm.com>
	<1238481552.28248.1384.camel@twins>
	<49D1C544.7020403@linux.vnet.ibm.com>
	<18897.56973.324304.995540@cargo.ozlabs.ibm.com>
	<1238508032.8530.278.camel@twins>
	<18898.58399.957182.181124@drongo.ozlabs.ibm.com>
	<1238572744.8530.2541.camel@twins>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> Ah, yes, I see how that can confuse. PERF_EVENT_COUNTER_OVERFLOW then?

Sounds reasonable.

> > Also, let's add PERF_RECORD/PERF_EVENT bits for:
> > 
> > * EVENT_INSTR_ADDR
> 
> I'm failing to come up with what this could be..

So, you have lots of instructions in flight in the processor, and one
of them causes an event that increments a counter and causes it to
overflow, so an interrupt request is generated.  Even if the interrupt
is taken "immediately", it can still happen that the set of
instructions the processor decides to complete before taking the
interrupt includes some instructions after the instruction that caused
the counter to overflow, and of course if interrupts are (hard-)
disabled at the time of the overflow, the interrupt will happen
later.  That means that the IP from the pt_regs is not generally a
reliable indication of which instruction made the counter overflow.

On POWER processors we have a register which gives us a much more
reliable indication of which instruction caused the counter overflow,
at least in those cases where the event can be attributed to a
specific instruction.  This EVENT_INSTR_ADDR bit would ask for that
register to be sampled and recorded.

> > * EVENT_DATA_ADDR
> 
> This would be the data address operated upon? Like what address caused
> the fault/cache-miss, etc?

That's right.  POWER processors have a register that records that
where possible.

> > * EVENT_INSTR_FLAGS
> 
> Again not quite sure what this would be.

POWER processors have a register that records information about the
instruction that caused the counter overflow, such as did it have a
data address associated with it, did it cause a dcache miss, etc.

> > * EVENT_CPU_FLAGS	(so we can distinguish hypervisor/kernel/user)
> 
> Currently we can based on address, an IP < 0 is kernel and > 0 is
> userspace, but yeah, I see how this makes life easier.

We can't distinguish hypervisor addresses that way, and on some
architectures (including x86_32 with a 4G/4G split) we can't
distinguish kernel/user just by the address.  I was thinking the cpu
flags would also include things like interrupt enable state, FPU
enable state, etc.

> > We would have to call into arch code to get the values for these.
> 
> I suppose all these things can be gleaned from pt_regs, so that should
> be doable.

Hmmm, 3 of the 4 would require SPR (= what x86 calls MSR) reads.
Maybe it's best to have a block of arch-specific bits that can be
defined per-arch and implemented in arch code.

Paul.
