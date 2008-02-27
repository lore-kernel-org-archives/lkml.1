Return-Path: <linux-kernel-owner+w=401wt.eu-S1759344AbYB0U2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344AbYB0U2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 15:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbYB0U2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 15:28:30 -0500
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:65232 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751595AbYB0U23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 15:28:29 -0500
Date: Wed, 27 Feb 2008 22:28:03 +0200
From: Pekka Paalanen <pq@iki.fi>
To: corbet@lwn.net (Jonathan Corbet)
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, pq@iki.fi
Subject: Re: [RFC] mmiotrace full patch, preview 1
Message-ID: <20080227222803.28f581d6@daedalus.pq.iki.fi>
In-Reply-To: <1892.1204046408@vena.lwn.net>
References: <20080224190323.77adf683@daedalus.pq.iki.fi>
	<1892.1204046408@vena.lwn.net>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 10:20:08 -0700
corbet@lwn.net (Jonathan Corbet) wrote:

> A couple of little things I noticed...
> 
> > +static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
> > +{
> > +	int ret = 0;
> > +	struct kmmio_probe *probe;
> > +	struct kmmio_fault_page *faultpage;
> > +	struct kmmio_context *ctx = &get_cpu_var(kmmio_ctx);
> > +
> > +	if (!ctx->active)
> > +		goto out;
> 
> Should that text read something like:
> 
> 	if (condition != DIE_TRAP || !ctx->active)

The last thing in kmmio.c is:

static int kmmio_die_notifier(struct notifier_block *nb, unsigned long val,
								void *args)
{
	struct die_args *arg = args;

	if (val == DIE_DEBUG)
		if (post_kmmio_handler(arg->err, arg->regs) == 1)
			return NOTIFY_STOP;

	return NOTIFY_DONE;
}

so post_kmmio_handler() is not the die_notifier callback, and the handler
is limited to debug calls, which I assume can only come from
single-stepping. The variable 'condition' is something that on x86_64 comes
from get_debugreg(condition, 6); in arch/x86/kernel/traps_64.c do_debug().
I don't know what 'condition' is and kmmio is not using it.

> Presumably you won't be active if something else is going wrong, but one
> never knows.
> 
> > +int register_kmmio_probe(struct kmmio_probe *p)
> > +{
> > +	int ret = 0;
> > +	unsigned long size = 0;
> > +
> > +	spin_lock_irq(&kmmio_lock);
> > +	kmmio_count++;
> > +	if (get_kmmio_probe(p->addr)) {
> > +		ret = -EEXIST;
> > +		goto out;
> > +	}
> 
> That only checks the first page; if the probed region partially overlaps
> another one found later in memory, the registration will succeed.

True. I am assuming ioremap*() cannot return regions that overlap in
their kernel virtual addresses. Clearly this does not hold for the ISA
region, but tracing the ISA region has triggered hard freezes, so we
specifically exclude that.

Even if ioremap*() would return overlapping areas, I don't think it would
break things. It just means there are two probes on the same area. If an
MMIO access hits that area, the "first" probe gets selected and executed.
The only thing lost is which probe was actually hit, but then there's no
way to know that, anyway.

kmmio_fault_page objects are shared and reference-counted, so they should
not be a problem, either.

> Maybe you want to decrement kmmio_count if you decide to return -EEXIST
> (or hold off on the increment until after the test)?

Yes, good catch. Then again, maybe I would not even need the failure case
at all. I think I'll keep it there, though, maybe it catches something
stupid I will do.

> In general, I worry about what happens if an interrupt handler generates
> traced MMIO traffic while a fault handler is active.  It looks a lot
> like the "all hell breaks loose" scenario mentioned in the comments.  Is
> there some way of preventing that which I missed?  Otherwise, maybe,
> should the ioremap() wrappers take an additional argument, being an IRQ
> to disable while trace handlers are active?

I have thought of something like this, how could it happen. My current
understanding is the following.

kmmio_handler(), where-ever it was triggered, executes with interrupts
disabled. It modifies the saved CPU state: disable interrupts and
enable single-stepping (what's the correct term?). After disarming
the page, it returns. The faulted instruction is single-stepped,
all the time the interrupts are disabled. It hits the debug trap and
we end up in post_kmmio_handler(), still interrupts disabled. The
post handler does its thing, restores the CPU state changed in
kmmio_handler(), and returns.

Therefore, on this CPU, no interrupt except NMI may occur during the
handling of a probe hit. Of course, I am assuming the execution
flow will stay on this CPU, but there's no chance it could jump to
a different CPU, is there?

Which leads to the question, is preempt_disable() in kmmio_handler()
and the respective preempt_enable_no_resched() in post_kmmio_handler()
required, or does disabling interrupts guarantee that?

And also, the following code is probably useless in post_kmmio_handler()
because of the interrupts being disabled all the time:

	faultpage = get_kmmio_fault_page(ctx->addr);
	probe = get_kmmio_probe(ctx->addr);
	if (faultpage != ctx->fpage || probe != ctx->probe) {
		/*
		 * The trace setup changed after kmmio_handler() and before
		 * running this respective post handler. User does not want
		 * the result anymore.
		 */
		ctx->probe = NULL;
		ctx->fpage = NULL;
	}

For the if to trigger, the probe list or the kmmio_fault_page list
would have to change during a probe hit or the single-stepping. The
lists are protected by RCU, so this is impossible. Hmm, no, wait.
The lists could be modified, but the pointers would still stay valid
because RCU has not had a chance run the freeing function. OTOH,
rcu_read_lock() is not held over single-stepping.

Maybe I should replace the preempt_disable() with rcu_read_lock()
that would be held over single-stepping?

Are there any locks or anything I should *not* hold over the single-
stepping, i.e., lock in kmmio_handler() and unlock only in
post_kmmio_handler()?

Is there any way post_kmmio_handler() would not get called after
kmmio_handler() was called?

You might get the impression that I don't know what I'm doing. You
would be correct! ;-)


Thanks, I appreciate all feedback.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
