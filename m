Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbZHOLiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbZHOLiW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 07:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbZHOLiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 07:38:21 -0400
Received: from www.tglx.de ([62.245.132.106]:53352 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbZHOLiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 07:38:20 -0400
Date: Sat, 15 Aug 2009 13:37:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>,
       Brian Swetland <swetland@google.com>,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>, Daniel Ribeiro <drwyrm@gmail.com>,
       arve@android.com, Barry Song <21cnbao@gmail.com>
Subject: Re: [RFC patch 2/3] genirq: Add buslock support for irq chips on
 slow busses
In-Reply-To: <20090815095503.GB15831@elte.hu>
Message-ID: <alpine.LFD.2.00.0908151213350.1283@localhost.localdomain>
References: <20090813191535.945521006@linutronix.de> <20090813193116.509070851@linutronix.de> <20090814101739.GA32418@elf.ucw.cz> <alpine.LFD.2.00.0908141220190.1283@localhost.localdomain> <20090814112059.GB17755@rakim.wolfsonmicro.main>
 <20090815095503.GB15831@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Aug 2009, Ingo Molnar wrote:
> * Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> 
> > On Fri, Aug 14, 2009 at 12:20:49PM +0200, Thomas Gleixner wrote:
> > > On Fri, 14 Aug 2009, Pavel Machek wrote:
> > 
> > > > AFAICT this means that driver would need to know what kind of IRQ it
> > > > is hooked to, right? That will lead to some ugly code in drivers that
> > > > can handle both normal and slowbus irqs, right?
> > 
> > > Are there such drivers in reality ?
> > 
> > Yes.  The GPIO based stuff is the prime example but there's other 
> > examples - one is the WM831x touchscreen (no driver in mainline 
> > yet) which can use interrupts via the main interrupt controller on 
> > the CPU but also has the option of bringing the interrupt signals 
> > out to dedicated pins on the chip for direct connection to the CPU 
> > precisely to avoid the overheads of these slow interrupt 
> > controllers.
> 
> This would call for Thomas's first version of the patch, that is 
> transparent to drivers - the IRQ subsystem will know how to lock 
> access to the line.
> 
> How about implementing that first patch in a cleaner way - can we 
> somehow express the slow-bus property purely via the irqchip? Or is 
> that too lowlevel?

The problem here is that the management functions serialize via
irqdesc->lock and call the chip level function with the lock held
(preemption and interrupts disabled). So we can not access the slow
bus chips from these low level functions.

If the low level functions just store the information and schedule it
for bus access then there is no serialization anymore. Lets look at
disable_irq():

	spin_lock_irqsave(&desc->lock);
	....
	desc->chip->mask();
		schedule bus access;
	...
	spin_lock_irqsave(&desc->lock);

So now we return, but the mask has not reached the chip.

The idea of bus_lock/bus_sync_unlock() was to provide well defined
synchronization points for the chip level implementation to do the bus
update and have this serialized against other management functions.

	desc->chip->bus_lock();
		Take the chip->bus mutex

	spin_lock_irqsave(&desc->lock);
	....
	desc->chip->mask();
		store mask information
	...
	spin_lock_irqsave(&desc->lock);

	desc->chip->bus_sync_unlock();
		Update the mask via the slow bus
		Release chip->bus mutex

That way we have made sure that the change to the chip actually hits
the hardware before we allow further management operations and it
simplifies the code for the chip implementation as the bus access can
be done in the context of the caller w/o the need of an extra
thread/workqueue ...

Thanks,

	tglx


