Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbYFKKXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbYFKKXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 06:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbYFKKXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 06:23:12 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:56629 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751808AbYFKKXL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 06:23:11 -0400
Subject: Re: [PATCH 1/10] Add generic helpers for arch IPI function calls
From: Catalin Marinas <catalin.marinas@arm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: paulmck@linux.vnet.ibm.com, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, peterz@infradead.org,
       linux-arch@vger.kernel.org, jeremy@goop.org, mingo@elte.hu,
       Russell King <rmk+lkml@arm.linux.org.uk>
In-Reply-To: <20080611032531.GC8228@wotan.suse.de>
References: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com>
	 <1212051504-12561-2-git-send-email-jens.axboe@oracle.com>
	 <1213109485.24701.107.camel@pc1117.cambridge.arm.com>
	 <20080610154716.GF15481@linux.vnet.ibm.com>
	 <1213116788.24701.133.camel@pc1117.cambridge.arm.com>
	 <20080611032531.GC8228@wotan.suse.de>
Content-Type: text/plain; charset=utf-8
Organization: ARM Ltd
Date: Wed, 11 Jun 2008 11:13:35 +0100
Message-Id: <1213179215.19224.61.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 11 Jun 2008 10:13:36.0083 (UTC) FILETIME=[CF7AB230:01C8CBAB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-11 at 05:25 +0200, Nick Piggin wrote:
> On Tue, Jun 10, 2008 at 05:53:08PM +0100, Catalin Marinas wrote:
> > On Tue, 2008-06-10 at 08:47 -0700, Paul E. McKenney wrote:
> > > On Tue, Jun 10, 2008 at 03:51:25PM +0100, Catalin Marinas wrote:
> > > > I was thinking whether this condition can be removed and allow the
> > > > smp_call_function*() to be called with IRQs disabled. At a quick look,
> > > > it seems to be possible if the csd_flag_wait() function calls the IPI
> > > > handlers directly when the IRQs are disabled (see the patch below).
> > [...]
> > > There were objections last month:  http://lkml.org/lkml/2008/5/3/167
> > 
> > Thanks, I missed this discussion.
> > 
> > > The issue was that this permits some interrupts to arrive despite
> > > interrupts being disabled.  There seemed to be less resistance to
> > > doing this in the wait==1 case, however.
> > 
> > The "(wait == 1) && irqs_disabled()" case is what I would be interested
> > in. In the patch you proposed, this doesn't seem to be allowed (at least
> > from the use of WARN_ON). However, from your post in May:
> > 
> > > 5.	If you call smp_call_function() with irqs disabled, then you
> > > 	are guaranteed that no other CPU's smp_call_function() handler
> > > 	will be invoked while smp_call_function() is executing.
> > 
> > this would be possible but no one need this functionality yet.
> > 
> > Would one use-case (ARM SMP and DMA cache maintenance) be enough to
> > implement this or I should add it to the ARM-specific code?
> 
> How will you implement it? You have to be able to wait *somewhere*
> (either before or after the smp_call_function call) with interrupts
> enabled. It is not enough just to eg. use a spinlock around
> smp_call_function, because other CPUs might also be trying to call
> down the same path also with interrupts disabled, and they'll wait
> forever on the spinlock.

With the generic IPI patches, I think it is just a matter of polling for
incoming IPIs in the csd_flag_wait() if interrupts are disabled since no
spinlock is held when issuing the IPI (smp_call_function can be called
concurrently).

If I do it in the ARM-specific code, I would duplicate the
smp_call_function (but avoid the call_single_queue, maybe just like the
current ARM implementation) and use a spinlock around the IPI
invocation. If interrupts are allowed to be disabled, the spin_lock()
would actually be a spin_trylock() (or spin_trylock_irqsave()),
something like below (untested). It can be improved for the IRQs-enabled
case to reduce the latency.

smp_call_function(...)
{
	...
	/*
	 * disable IRQs so that we can call this function from
	 * ﻿interrupt context
	 */
	local_irq_save(flags)
	while (!spin_trylock(&call_function_lock)) {
		/* other CPU is sending an IPI, just poll for it */
		smp_call_function_interrupt();
	}
	/* acquired the lock, do the IPI stuff */
	...

	/* 
	 * wait for the other CPUs to complete the IPI. No other CPU 
	 * is waiting for completion because of the call_function_lock
	 */
	...

	spin_unlock(﻿&call_function_lock);
	local_irq_restore(flags);
}

One issue I saw raised with the polling loop is that it calls an
interrupt handler outside an interrupt context and with IRQs disabled.
There shouldn't be any issue with the existing code since
smp_call_function assumes interrupts enabled anyway. Whoever needs this
functionality should take greater care with IRQs disabled (in my case,
only calling some cache maintenance operations is OK).

Regarding the interrupt latency, it would be higher since the IPI is not
that cheap but (in ARM SMP case) calling dma_map_single/sg (especially
with TO_DEVICE) with interrupts disabled I think is pretty bad already
as it involves flushing the caches for that range and time-consuming.

If dma_map_single/sg would be disallowed with interrupts disabled or
from interrupt context, we would no longer need the above workarounds
for smp_call_function on ARM.

Regards.

-- 
Catalin

