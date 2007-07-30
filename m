Return-Path: <linux-kernel-owner+w=401wt.eu-S932597AbXG3Ibd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597AbXG3Ibd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 04:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757481AbXG3Ib0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 04:31:26 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:44418 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933AbXG3IbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 04:31:24 -0400
Date: Mon, 30 Jul 2007 10:32:59 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Chris Friesen <cfriesen@nortel.com>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070730083259.GD9840@enneenne.com>
References: <20070724142050.GD4074@enneenne.com> <1185288769.14697.339.camel@pmac.infradead.org> <20070727184418.GV9840@enneenne.com> <46AA42CA.4060004@nortel.com> <20070727192848.GW9840@enneenne.com> <46AA4A1E.8040302@nortel.com> <20070727194516.GX9840@enneenne.com> <a781481a0707271347w53dd9755j87e7762cfe953777@mail.gmail.com> <20070729091709.GY9840@enneenne.com> <alpine.LFD.0.999.0707300943550.10861@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707300943550.10861@enigma.security.iitk.ac.in>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: LinuxPPS & spinlocks
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 09:49:20AM +0530, Satyam Sharma wrote:
> 
> Hmm? I still don't see why you can't introduce spin_lock_irqsave/restore()
> in pps_event() around the access to pps_source.

In pps_event() is not useful using spin_lock_irqsave/restore() since
the only difference between spin_lock_irqsave() and spin_lock() is
that the former will turn off interrupts if they are on, otherwise
does nothing (if we are already in an interrupt handler).

Maybe you meant I should using spin_lock_irqsave/restore() in user
context, but doing like this I will disable interrupts and I don't
wish doing it since, in this manner, the interrupt handler will be
delayed and the (probably) PPS event recording will be wrong. I
prefere loosing the event that registering it at delayed time.

> > About using both mutex and spinlock I did it since (I think) I should
> > protect syscalls from each others and from pps_register/unregister(),
> > and pps_event() against pps_register/unregister().
> 
> Nopes, it's not about protecting code from each other, you're needlessly
> complicating things. Locking is pretty simple, really -- any shared data,
> that can be concurrently accessed by multiple threads (or from interrupts)
> must be protected with a lock. Note that *data* is protected by a lock,
> and not "code" that handles it (well, this is the kind of behaviour most
> cases need, at least, including yours).

Of course, I meant "protecting data". In fact to protect pps_source[]
I need spin_lock() to protect user context from interrupt context and
mutex to protect user context from itself.

> So here we're introducing the lock to protect *pps_source*, and not keep
> *threads* of execution from stepping over each other. So, simply, just
> ensure you grab the lock whenever you want to start accessing the shared
> data, and release it when you're done.

I see. But consider pps_register_source(). This function should
provide protection of pps_source against both interrupt context
(pps_event()) and user context (maybe pps_unregister_source() or one
syscalls). Using only mutex is not possible, since we cannot use mutex
in interrupt context, and using only spin_locks is not possible since
in UP() they became void.

Can you please show me how I could write pps_register_source() in
order to be correct from your point of view?

> The _irqsave/restore() variants are required because (say) one of the
> syscalls executing in process context grabs the spinlock. Then, before it
> has released it, it gets interrupted and pps_event() begins executing.
> Now pps_event() also wants to grab the lock, but the syscall already
> has it, so will continue spinning and deadlock!

That's the point. I don't wish using _irqsave/restore() since they may
delay interrupt handler execution. As above, I prefere loosing the
event then registering it at wrong time.

> I think you're unnecessarily worrying about contention here -- you can
> have multiple locks (one for the list, and separate ones for your sources)
> if you're really worrying about contention -- or probably rwlocks. But
> really, rwlocks would end up being *slower* than spinlocks, unless the
> contention is really heavy and it helps to keep multiple readers in the
> critical section. But frankly, with at max a few (I'd expect generally
> one) PPS sources ever to be connected / registered with teh system, and
> just one-pulse-per-second, I don't see why any contention is ever gonna
> happen.

Why you wish using one lock per sources? Just one lock for the
list/array is not enought? :-o

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
