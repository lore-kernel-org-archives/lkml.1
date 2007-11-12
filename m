Return-Path: <linux-kernel-owner+w=401wt.eu-S1758101AbXKLWeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbXKLWeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 17:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759880AbXKLWeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 17:34:04 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:31611 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755806AbXKLWeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 17:34:01 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=R0f3ETAoWTZvoDANBiH+cY2jK/nHtB+rRq3TCrZqEoDr+OymN7N8LZlG+1WdKEWTLVy+k27Prkj5EQxQbFz5XFOhyzFoXkPa/MZHg3nlN9bG0WnBJb4Xc25CBP7W/BBmneDw/oAVuASC3k77Q8l/VtMhyO9C6bmpfP1N/JXFgX0=  ;
X-YMail-OSG: MH54T9kVM1l6Ro_3Lp7Y9KqZ9GOh5O0EveDq9UlV93jIALdm3z2_q0pSboaVYiB1UfdhskpiWRWatxOLthW8iT7hEKHPgvMZGDn7f.1PhlHijDZckg--
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Date: Mon, 12 Nov 2007 14:32:53 -0800
User-Agent: KMail/1.9.6
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
References: <200711091136.20051.david-b@pacbell.net> <20071112133638.ff671fa0.akpm@linux-foundation.org>
In-Reply-To: <20071112133638.ff671fa0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711121432.54307.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2007, Andrew Morton wrote:
> On Fri, 9 Nov 2007 11:36:19 -0800 David Brownell <david-b@pacbell.net> wrote:
> 
> > Provide new implementation infrastructure that platforms may choose to use
> > when implementing the GPIO programming interface.  ...
> > 
> > ...
> >
> > +/* gpio_lock protects the table of chips and to gpio_chip->requested.
> > + * While any gpio is requested, its gpio_chip is not removable.  It's
> > + * a raw spinlock to ensure safe access from hardirq contexts, and to
> > + * shrink bitbang overhead:  per-bit preemption would be very wrong.
> > + */
> > +static raw_spinlock_t gpio_lock = __RAW_SPIN_LOCK_UNLOCKED;
> 
> Well that's weird.
> 
> For starters, this initialisation will confound lockdep: it should use
> DEFINE_SPINLOCK.

Then it wouldn't be "raw"!  It seems info on raw spinlocks is out
of sync with current code.  Allegedly it should be possible to just
pass a raw_spinlock_t pointer to spin_lock_irqsave() and friends
and have GCC sort out the right stuff ... but that didn't work.

I speculate that either the design has changed (without fanfare),
or else that stuff is in RT kernels and has not yet gone upstream.


> And the rationale seems dubious.  All you're saving here is a couple of
> accesses to task_struct at spin_unlock()-time.  If the current task has a
> preemption pending then yes, we'll schedule away but that's a very rare
> thing and that's just what we're supposed to do.

Unfortunately, that's not what I observed/measured.

  http://marc.info/?l=linux-kernel&m=119429680220361&w=2

Plus, note the comment about hardirq context and RT environments.
When that spinlock is really a mutex, and the non-hardirq contexts
are tasks, non-raw spinlocks would wrongly prevent access to GPIOs
from true hardirq contexts.


> So please tell us more about this.  Perhaps there are performance problems
> with the current core preemption machinery.

The above email summarizes significant slowdown I observed using
just i2c-gpio, which happened to be easy to measure down to the
microsecond level.


> > +	local_irq_save(flags);
> > +	__raw_spin_lock(&gpio_lock);
> >
> > ...
> > +	__raw_spin_unlock(&gpio_lock);
> > +	local_irq_restore(flags);
> > +	return status;
> > +}
> 
> And of course if this code is converted to conventional locking, the above
> becomes spin_lock_irqsave()/spin_lock_irqrestore() in many places.

See above.  Allegedly we ought to be able to use those calls even
with raw spinlocks ... but that didn't work when I tried it. I'd
certainly prefer if it did work.


> > +/* There's no value in inlining GPIO calls that may sleep.
> 
> There's no value in inlining anything, hardly ;)

Remember that GPIOs do get used for bitbanging, and there's lots
of kernel code to make bit ops stay fast!

The canonical reason to inline GPIO operations is so that when
you bitbang some serial protocol, you're closer to one instruction
per bit toggle than fifty ... at one point I measured a factor of
nearly three speedup for byte-level bitbanging for SPI (ca. 70 Kbit
with quick function calls, vs about 2 Mbits inlined, ISTR) ... with
most of the overhead being to pass the next byte down to the bitbang
loop.  Using a bigger wordsize saw even more improvement.


> > +postcore_initcall(gpiolib_debugfs_init);
> 
> postcore_initcall() is unusual, hence a comment describing why it was
> employed would be a good thing to have.

Actually that one could easily be later, fs_initcall or whatnot.
I think that's debris from other versions.

- Dave

