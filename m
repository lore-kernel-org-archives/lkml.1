Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbZHOO3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbZHOO3x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 10:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbZHOO3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 10:29:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36891 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754279AbZHOO3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 10:29:52 -0400
Date: Sat, 15 Aug 2009 16:29:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
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
Message-ID: <20090815142925.GA12298@elte.hu>
References: <20090813191535.945521006@linutronix.de> <20090813193116.509070851@linutronix.de> <20090814101739.GA32418@elf.ucw.cz> <alpine.LFD.2.00.0908141220190.1283@localhost.localdomain> <20090814112059.GB17755@rakim.wolfsonmicro.main> <20090815095503.GB15831@elte.hu> <alpine.LFD.2.00.0908151213350.1283@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0908151213350.1283@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Sat, 15 Aug 2009, Ingo Molnar wrote:
> > * Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> > 
> > > On Fri, Aug 14, 2009 at 12:20:49PM +0200, Thomas Gleixner wrote:
> > > > On Fri, 14 Aug 2009, Pavel Machek wrote:
> > > 
> > > > > AFAICT this means that driver would need to know what kind of IRQ it
> > > > > is hooked to, right? That will lead to some ugly code in drivers that
> > > > > can handle both normal and slowbus irqs, right?
> > > 
> > > > Are there such drivers in reality ?
> > > 
> > > Yes.  The GPIO based stuff is the prime example but there's other 
> > > examples - one is the WM831x touchscreen (no driver in mainline 
> > > yet) which can use interrupts via the main interrupt controller on 
> > > the CPU but also has the option of bringing the interrupt signals 
> > > out to dedicated pins on the chip for direct connection to the CPU 
> > > precisely to avoid the overheads of these slow interrupt 
> > > controllers.
> > 
> > This would call for Thomas's first version of the patch, that is 
> > transparent to drivers - the IRQ subsystem will know how to lock 
> > access to the line.
> > 
> > How about implementing that first patch in a cleaner way - can we 
> > somehow express the slow-bus property purely via the irqchip? Or is 
> > that too lowlevel?
> 
> The problem here is that the management functions serialize via 
> irqdesc->lock and call the chip level function with the lock held 
> (preemption and interrupts disabled). So we can not access the 
> slow bus chips from these low level functions.
> 
> If the low level functions just store the information and schedule 
> it for bus access then there is no serialization anymore. Lets 
> look at disable_irq():
> 
> 	spin_lock_irqsave(&desc->lock);
> 	....
> 	desc->chip->mask();
> 		schedule bus access;
> 	...
> 	spin_lock_irqsave(&desc->lock);
> 
> So now we return, but the mask has not reached the chip.
> 
> The idea of bus_lock/bus_sync_unlock() was to provide well defined
> synchronization points for the chip level implementation to do the bus
> update and have this serialized against other management functions.
> 
> 	desc->chip->bus_lock();
> 		Take the chip->bus mutex
> 
> 	spin_lock_irqsave(&desc->lock);
> 	....
> 	desc->chip->mask();
> 		store mask information
> 	...
> 	spin_lock_irqsave(&desc->lock);
> 
> 	desc->chip->bus_sync_unlock();
> 		Update the mask via the slow bus
> 		Release chip->bus mutex
> 
> That way we have made sure that the change to the chip actually 
> hits the hardware before we allow further management operations 
> and it simplifies the code for the chip implementation as the bus 
> access can be done in the context of the caller w/o the need of an 
> extra thread/workqueue ...

Given the alternatives i'd prefer this one now ...

	Ingo
