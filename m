Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbXG3EHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbXG3EHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 00:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbXG3EHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 00:07:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57789 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbXG3EHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 00:07:09 -0400
Date: Mon, 30 Jul 2007 09:49:20 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Rodolfo Giometti <giometti@enneenne.com>
cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Chris Friesen <cfriesen@nortel.com>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: LinuxPPS & spinlocks
In-Reply-To: <20070729091709.GY9840@enneenne.com>
Message-ID: <alpine.LFD.0.999.0707300943550.10861@enigma.security.iitk.ac.in>
References: <20070724080013.GA22171@gundam.enneenne.com>
 <1185284942.14697.319.camel@pmac.infradead.org> <20070724142050.GD4074@enneenne.com>
 <1185288769.14697.339.camel@pmac.infradead.org> <20070727184418.GV9840@enneenne.com>
 <46AA42CA.4060004@nortel.com> <20070727192848.GW9840@enneenne.com>
 <46AA4A1E.8040302@nortel.com> <20070727194516.GX9840@enneenne.com>
 <a781481a0707271347w53dd9755j87e7762cfe953777@mail.gmail.com>
 <20070729091709.GY9840@enneenne.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rodolfo,


On Sun, 29 Jul 2007, Rodolfo Giometti wrote:

> On Sat, Jul 28, 2007 at 02:17:24AM +0530, Satyam Sharma wrote:
> > 
> > I only glanced through the code, so could be wrong, but I noticed that
> > the only global / shared data you have in there is a global "pps_source"
> > array of pps_s structs. That's accessed / modified from the various
> > syscalls introduced in the API exported to userspace, as well as the
> > register/unregister/pps_event API exported to in-kernel client subsystems,
> > yes? So it looks like you need to introduce proper locking for it, simply
> > type-qualifying it as "volatile" is not enough.
> > 
> > However, I think you've introduced two locks for it. The syscalls (that
> > run in process context, obviously) seem to use a pps_mutex and
> > pps_event() seems to be using the pps_lock spinlock (because that
> > gets executed from interrupt context) -- and from the looks of it, the
> > register/unregister functions are using /both/ the mutex and spinlock (!)
> 
> This is right.
> 
> > This isn't quite right, (in fact there's nothing to protect pps_event from
> > racing against a syscall), so you should use *only* the spinlock for
> > synchronization -- the spin_lock_irqsave/restore() variants, in fact.
> 
> We can't use the spin_lock_irqsave/restore() variants since PPS
> sources cannot manage IRQ enable/disable. For instance, the serial
> source doesn't manage IRQs directly but just uses it to record PPS
> events. The serial driver manages the IRQ enable/disable, not the PPS
> source which only uses the IRQ handler to records events.

Hmm? I still don't see why you can't introduce spin_lock_irqsave/restore()
in pps_event() around the access to pps_source.


> About using both mutex and spinlock I did it since (I think) I should
> protect syscalls from each others and from pps_register/unregister(),
> and pps_event() against pps_register/unregister().

Nopes, it's not about protecting code from each other, you're needlessly
complicating things. Locking is pretty simple, really -- any shared data,
that can be concurrently accessed by multiple threads (or from interrupts)
must be protected with a lock. Note that *data* is protected by a lock,
and not "code" that handles it (well, this is the kind of behaviour most
cases need, at least, including yours).

So here we're introducing the lock to protect *pps_source*, and not keep
*threads* of execution from stepping over each other. So, simply, just
ensure you grab the lock whenever you want to start accessing the shared
data, and release it when you're done.

The _irqsave/restore() variants are required because (say) one of the
syscalls executing in process context grabs the spinlock. Then, before it
has released it, it gets interrupted and pps_event() begins executing.
Now pps_event() also wants to grab the lock, but the syscall already
has it, so will continue spinning and deadlock!


> > [ Also, have you considered making pps_source a list and not an array?
> > It'll help you lose a whole lot of MAX_SOURCES, pps_is_allocated, etc
> > kind of gymnastics in there, and you _can_ return a pointer to the
> > corresponding pps source struct from the register() function to the in-kernel
> > users, so that way you get to retain the O(1) access to the corresponding
> > source when a client calls into pps_event(), similar to how you're using the
> > array index presently. ]
> > 
> > I also noticed code like (from pps_event):
> > 
> > +	/* Try to grab the lock, if not we prefere loose the event... */
> > +	if (!spin_trylock(&pps_lock))
> > +		return;
> > 
> > which looks worrisome and unnecessary. That spinlock looks to be of
> > fine enough granularity to me, do you think there'd be any contention
> > on it? I /think/ you can simply make that a spin_lock().
> 
> This is due the fact I cannot manage IRQ enable/disable.

What I meant is that you could make it a proper spin_lock() --
or spin_lock_irqsave(), actually -- instead of the _trylock_ variant
that it currently is.

I think you're unnecessarily worrying about contention here -- you can
have multiple locks (one for the list, and separate ones for your sources)
if you're really worrying about contention -- or probably rwlocks. But
really, rwlocks would end up being *slower* than spinlocks, unless the
contention is really heavy and it helps to keep multiple readers in the
critical section. But frankly, with at max a few (I'd expect generally
one) PPS sources ever to be connected / registered with teh system, and
just one-pulse-per-second, I don't see why any contention is ever gonna
happen.


Satyam
