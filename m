Return-Path: <linux-kernel-owner+w=401wt.eu-S1759933AbXKLX3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759933AbXKLX3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 18:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756409AbXKLX3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 18:29:24 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58102 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755507AbXKLX3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 18:29:23 -0500
Date: Mon, 12 Nov 2007 15:28:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Message-Id: <20071112152857.a60643b0.akpm@linux-foundation.org>
In-Reply-To: <200711121432.54307.david-b@pacbell.net>
References: <200711091136.20051.david-b@pacbell.net>
	<20071112133638.ff671fa0.akpm@linux-foundation.org>
	<200711121432.54307.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2007 14:32:53 -0800 David Brownell <david-b@pacbell.net> wrote:

> On Monday 12 November 2007, Andrew Morton wrote:
> > On Fri, 9 Nov 2007 11:36:19 -0800 David Brownell <david-b@pacbell.net> wrote:
> > 
> > > Provide new implementation infrastructure that platforms may choose to use
> > > when implementing the GPIO programming interface.  ...
> > > 
> > > ...
> > >
> > > +/* gpio_lock protects the table of chips and to gpio_chip->requested.
> > > + * While any gpio is requested, its gpio_chip is not removable.  It's
> > > + * a raw spinlock to ensure safe access from hardirq contexts, and to
> > > + * shrink bitbang overhead:  per-bit preemption would be very wrong.
> > > + */
> > > +static raw_spinlock_t gpio_lock = __RAW_SPIN_LOCK_UNLOCKED;
> > 
> > Well that's weird.
> > 
> > For starters, this initialisation will confound lockdep: it should use
> > DEFINE_SPINLOCK.
> 
> Then it wouldn't be "raw"!  It seems info on raw spinlocks is out
> of sync with current code.  Allegedly it should be possible to just
> pass a raw_spinlock_t pointer to spin_lock_irqsave() and friends
> and have GCC sort out the right stuff ... but that didn't work.
> 
> I speculate that either the design has changed (without fanfare),
> or else that stuff is in RT kernels and has not yet gone upstream.

Well whatever.  We shouldn't have to resort to caller-side party tricks
like this to get acceptable performance.

> 
> > And the rationale seems dubious.  All you're saving here is a couple of
> > accesses to task_struct at spin_unlock()-time.  If the current task has a
> > preemption pending then yes, we'll schedule away but that's a very rare
> > thing and that's just what we're supposed to do.
> 
> Unfortunately, that's not what I observed/measured.
> 
>   http://marc.info/?l=linux-kernel&m=119429680220361&w=2

There's something missing here.  It went from 6.4 usec/bit up to 11.2
usec/bit.  You seem to be saying that enabling preemption accounts for 1
usec.  What caused the rest of the slowdown?

> Plus, note the comment about hardirq context and RT environments.
> When that spinlock is really a mutex, and the non-hardirq contexts
> are tasks, non-raw spinlocks would wrongly prevent access to GPIOs
> from true hardirq contexts.

I don't understand all this about raw spinlocks and hardirq context. 
We use plain old spin_lock()/spin_unlock() in hardirq context all the time?

I'm still trying to understand what you've observed here.  Is it the case
that a single gpio operation went from 6.4 up to 11.2 usecs?  And that this
operation does a single spin_lock/spin_unlock?  If so, something would have
had to have gone seriously wrong for a spin_lock/unlock time to increase by
4.8 microseconds.

I assume these timings are from a reasonably fast machine?

> 
> > So please tell us more about this.  Perhaps there are performance problems
> > with the current core preemption machinery.
> 
> The above email summarizes significant slowdown I observed using
> just i2c-gpio, which happened to be easy to measure down to the
> microsecond level.
> 
> 
> > > +	local_irq_save(flags);
> > > +	__raw_spin_lock(&gpio_lock);
> > >
> > > ...
> > > +	__raw_spin_unlock(&gpio_lock);
> > > +	local_irq_restore(flags);
> > > +	return status;
> > > +}
> > 
> > And of course if this code is converted to conventional locking, the above
> > becomes spin_lock_irqsave()/spin_lock_irqrestore() in many places.
> 
> See above.  Allegedly we ought to be able to use those calls even
> with raw spinlocks ... but that didn't work when I tried it. I'd
> certainly prefer if it did work.

It would of course be better to not use raw spinlocks at all.  It's an
internal implementation detail and drivers shouldn't go poking at it:

box:/usr/src/linux-2.6.24-rc2> grep -rl raw_spinlock_t .
./arch/x86/kernel/traps_32.c
./arch/x86/kernel/traps_64.c
./arch/x86/kernel/tsc_sync.c
./arch/mips/kernel/gdb-stub.c
./arch/parisc/lib/bitops.c
./arch/powerpc/lib/locks.c
./arch/s390/lib/spinlock.c
./include/asm-alpha/spinlock.h
./include/asm-alpha/spinlock_types.h
./include/asm-arm/spinlock.h
./include/asm-arm/spinlock_types.h
./include/asm-generic/bitops/atomic.h
./include/asm-x86/spinlock_32.h
./include/asm-x86/spinlock_64.h
./include/asm-x86/spinlock_types.h
./include/asm-ia64/spinlock.h
./include/asm-ia64/spinlock_types.h
./include/asm-m32r/spinlock.h
./include/asm-m32r/spinlock_types.h
./include/asm-mips/spinlock.h
./include/asm-mips/spinlock_types.h
./include/asm-parisc/atomic.h
./include/asm-parisc/spinlock.h
./include/asm-parisc/spinlock_types.h
./include/asm-powerpc/spinlock.h
./include/asm-powerpc/spinlock_types.h
./include/asm-ppc/spinlock.h
./include/asm-s390/spinlock.h
./include/asm-s390/spinlock_types.h
./include/asm-sh/spinlock.h
./include/asm-sh/spinlock_types.h
./include/asm-sparc/spinlock.h
./include/asm-sparc/spinlock_types.h
./include/asm-sparc64/spinlock.h
./include/asm-sparc64/spinlock_types.h
./include/linux/spinlock.h
./include/linux/spinlock_types.h
./include/linux/spinlock_types_up.h
./include/linux/spinlock_up.h
./kernel/lockdep.c
./lib/spinlock_debug.c


So can we please drill down and work out what went wrong and see if we can
fix it all up properly?

> 
> > > +/* There's no value in inlining GPIO calls that may sleep.
> > 
> > There's no value in inlining anything, hardly ;)
> 
> Remember that GPIOs do get used for bitbanging, and there's lots
> of kernel code to make bit ops stay fast!
> 
> The canonical reason to inline GPIO operations is so that when
> you bitbang some serial protocol, you're closer to one instruction
> per bit toggle than fifty ... at one point I measured a factor of
> nearly three speedup for byte-level bitbanging for SPI (ca. 70 Kbit
> with quick function calls, vs about 2 Mbits inlined, ISTR) ... with
> most of the overhead being to pass the next byte down to the bitbang
> loop.  Using a bigger wordsize saw even more improvement.
> 
> 
> > > +postcore_initcall(gpiolib_debugfs_init);
> > 
> > postcore_initcall() is unusual, hence a comment describing why it was
> > employed would be a good thing to have.
> 
> Actually that one could easily be later, fs_initcall or whatnot.
> I think that's debris from other versions.
> 
> - Dave
