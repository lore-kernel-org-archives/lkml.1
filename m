Return-Path: <linux-kernel-owner+w=401wt.eu-S1759338AbXKMB0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338AbXKMB0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 20:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbXKMB0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 20:26:43 -0500
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:30569 "HELO
	smtp110.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753690AbXKMB0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 20:26:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KaHdQy2MUPE66Ovo2Dqx/VbeL9OloTKzm/ms4yEVdGrM0GIQ4xGngN/FaISRgFVj+bWiMtHZrB026Vv8JPF5KtB54go6W/kRqUXZemR/PHb+yxf3osU7hSUZ8pyjfSwLGdQzA2M7Vm8lZImX3PFjSEgZ3FL4pO9lCf4bJ5gVSzM=  ;
X-YMail-OSG: trCsco0VM1kgusMIgnctuFEI81J9xjHdXWUSj1gz8z_O8fxCypd8e3V1XE56Q50MwwDOl28XeyHQE2z3ZHiv8fG_APUgWNEOa6UZXbm0mDoaYa3HcnQ-
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Date: Mon, 12 Nov 2007 17:26:38 -0800
User-Agent: KMail/1.9.6
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>
References: <200711091136.20051.david-b@pacbell.net> <200711121432.54307.david-b@pacbell.net> <20071112152857.a60643b0.akpm@linux-foundation.org>
In-Reply-To: <20071112152857.a60643b0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711121726.39263.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >	 It seems info on raw spinlocks is out
> > of sync with current code.  Allegedly it should be possible to just
> > pass a raw_spinlock_t pointer to spin_lock_irqsave() and friends
> > and have GCC sort out the right stuff ... but that didn't work.
> > 
> > I speculate that either the design has changed (without fanfare),
> > or else that stuff is in RT kernels and has not yet gone upstream.
> 
> Well whatever.  We shouldn't have to resort to caller-side party tricks
> like this to get acceptable performance.

I'd be happy if, as originally presented, it were possible to just
pass a raw_spinlock_t to spin_lock_irqsave() and friends.


> > > And the rationale seems dubious.  All you're saving here is a couple of
> > > accesses to task_struct at spin_unlock()-time.  If the current task has a
> > > preemption pending then yes, we'll schedule away but that's a very rare
> > > thing and that's just what we're supposed to do.

I don't think we really want to be scheduling on bit ops;
that seems a bit more fundamental.


> > 
> > Unfortunately, that's not what I observed/measured.
> > 
> >   http://marc.info/?l=linux-kernel&m=119429680220361&w=2
> 
> There's something missing here.  It went from 6.4 usec/bit up to 11.2
> usec/bit.  You seem to be saying that enabling preemption accounts for 1
> usec.  What caused the rest of the slowdown?

It was caused by some debug options I run with all the time,
which don't otherwise have easily observed performance effects.

DEBUG_PREEMPT, DEBUG_SPINLOCK, and DEBUG_SPINLOCK_SLEEP, but not
LOCKDEP (which I run with all the time, on platforms where it's
available).  There were other options too, which didn't matter.
This was with a basically idle system, note ... there was no
preemption happening.


> > Plus, note the comment about hardirq context and RT environments.
> > When that spinlock is really a mutex, and the non-hardirq contexts
> > are tasks, non-raw spinlocks would wrongly prevent access to GPIOs
> > from true hardirq contexts.
> 
> I don't understand all this about raw spinlocks and hardirq context. 
> We use plain old spin_lock()/spin_unlock() in hardirq context all the time?

Think RT kernels, with threaded IRQs and spinlocks morphed to mutexes.

Only irq handlers marked IRQF_NODELAY|IRQF_DISABLED will always be
"hard irqs" [1] which run the way you describe ... i.e. the way the
current mainstream kernel always works for IRQ handlers.


> I'm still trying to understand what you've observed here.  Is it the case
> that a single gpio operation went from 6.4 up to 11.2 usecs?

That was a single bitbanged I2C bit transfer, with embedded udelay()s.
I believe that was four gpio operations, as summarized at the end of
that email above.  Enabling preempt + debug increased the cost of
each GPIO call from whatever it was (reasonable) by 1.2 usecs.


> And that this 
> operation does a single spin_lock/spin_unlock?  If so, something would have
> had to have gone seriously wrong for a spin_lock/unlock time to increase by
> 4.8 microseconds.

See above; that was probably four lock/unlocks; 1.2 usec a pair.

But per-bit preemption for GPIOs would in any case be Just Wrong;
much like making test_bit(), set_bit(), and clear_bit() become
preemption points would be wrong.


> I assume these timings are from a reasonably fast machine?

They were from a relatively normal speed embedded processor; exactly
the kind which tends to both use these operations, and not uncommonly
also involve bitbanging.  In this case it was an AVR32 devel board,
BogoMips about 250 (comparable to ARM5 ones with BogoMips around 90).


> > > > +	local_irq_save(flags);
> > > > +	__raw_spin_lock(&gpio_lock);
> > > >
> > > > ...
> > > > +	__raw_spin_unlock(&gpio_lock);
> > > > +	local_irq_restore(flags);
> > > > +	return status;
> > > > +}
> > > 
> > > And of course if this code is converted to conventional locking, the above
> > > becomes spin_lock_irqsave()/spin_lock_irqrestore() in many places.
> > 
> > See above.  Allegedly we ought to be able to use those calls even
> > with raw spinlocks ... but that didn't work when I tried it. I'd
> > certainly prefer if it did work.
> 
> It would of course be better to not use raw spinlocks at all.  It's an
> internal implementation detail and drivers shouldn't go poking at it:

They weren't originally supposed to be like that.  They were to be
reserved for cases where their behavior was necessary ... like, to
synch with IRQF_NODELAY ("hard irq") handlers, and in other cases
where preemption would be wrong.


> So can we please drill down and work out what went wrong and see if we can
> fix it all up properly?

That's what I thought I did.  As I summarized it in the message
with the URL given above:

>>> Fortuntely it turns out those problems all go away if the gpiolib
>>> code uses a *raw* spinlock to guard its table lookups...
>>>
>>> That's as it should be, since the only substantive changes were to
>>> grab and release a lock, do one table lookup a bit differently, and
>>> add one indirect function call ... changes which should not have
>>> any visible performance impact on per-bit codepaths, and one might
>>> expect to cost on the order of one dozen instructions.

At most, I think one counter-argument would be that the costs of that
preempt (and debug) code aren't "enough" to merit using raw spinlocks;
a judgement call.

But that would have ignored the fact that such bit operations shouldn't
really be preemption points.  Only the "cansleep" versions should be;
they need to work through e.g. an I2C or SPI gpio expanders.

- Dave 

[1] http://rt.wiki.kernel.org/index.php/RT_PREEMPT_HOWTO
