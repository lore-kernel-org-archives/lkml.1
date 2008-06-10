Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbYFJPo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbYFJPo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 11:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbYFJPou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 11:44:50 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36180 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752984AbYFJPot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 11:44:49 -0400
Subject: Re: [PATCH 1/10] Add generic helpers for arch IPI function calls
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       peterz@infradead.org, npiggin@suse.de, linux-arch@vger.kernel.org,
       jeremy@goop.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
       Russell King <rmk+lkml@arm.linux.org.uk>
In-Reply-To: <1213109485.24701.107.camel@pc1117.cambridge.arm.com>
References: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com>
	 <1212051504-12561-2-git-send-email-jens.axboe@oracle.com>
	 <1213109485.24701.107.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Date: Tue, 10 Jun 2008 10:44:43 -0500
Message-Id: <1213112683.3440.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-10 at 15:51 +0100, Catalin Marinas wrote:
> Hi,
> 
> On Thu, 2008-05-29 at 10:58 +0200, Jens Axboe wrote:
> > This adds kernel/smp.c which contains helpers for IPI function calls. In
> > addition to supporting the existing smp_call_function() in a more efficient
> > manner, it also adds a more scalable variant called smp_call_function_single()
> > for calling a given function on a single CPU only.
> [...]
> > + * You must not call this function with disabled interrupts or from a
> > + * hardware interrupt handler or from a bottom half handler.
> > + */
> > +int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
> > +			   int wait)
> > +{
> > +	struct call_function_data d;
> > +	struct call_function_data *data = NULL;
> > +	cpumask_t allbutself;
> > +	unsigned long flags;
> > +	int cpu, num_cpus;
> > +
> > +	/* Can deadlock when called with interrupts disabled */
> > +	WARN_ON(irqs_disabled());
> 
> I was thinking whether this condition can be removed and allow the
> smp_call_function*() to be called with IRQs disabled. At a quick look,
> it seems to be possible if the csd_flag_wait() function calls the IPI
> handlers directly when the IRQs are disabled (see the patch below).
> 
> This would be useful on ARM11MPCore based systems where the cache
> maintenance operations are not detected by the snoop control unit and
> this affects the DMA calls like dma_map_single(). There doesn't seem to
> be any restriction on calls to dma_map_single() and hence we cannot
> broadcast the cache operation to the other CPUs. I could implement this
> in the ARM specific code using spin_try_lock (on an IPI-specific lock
> held during the cross-call) and polling for an IPI if a lock cannot be
> acquired (meaning that a different CPU is issuing an IPI) but I was
> wondering whether this would be possible in a more generic way.
> 
> Please let me know what you think or whether deadlocks are still
> possible (or any other solution apart from hardware fixes :-)). Thanks.

I don't see how your proposal fixes the deadlocks.  The problem is that
on a lot of arch's IPIs are normal interrupts.  If interrupts are
disabled, you don't see them.

The deadlock scenario is CPU1 enters smp_call_function() with IRQ's
disabled as CPU2 does the same thing and spins on the call_lock.  Now
CPU1 is waiting for an ack for its IPI to CPU2, but CPU2 will never see
the IPI until it enables interrupts.

One way to mitigate the effects of this is to enable interrupts if the
architecture code finds the call_lock (x86 implementation) held against
it, then re-disable before trying to get the lock again.  But really, in
order to make smp_call_function work in interrupt disabled sections, the
interrupt handler has to be modified to bar all non-IPI interrupts until
the critical section is over (otherwise there's no point allowing it
with disabled interrupts because an smp_call_function becomes a de facto
interrupt enable again).  If you really want to see how something like
this works, the voyager code has it (because interrupt disabling in the
VIC is expensive).  But it's quite a lot of code ...

James


