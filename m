Return-Path: <linux-kernel-owner+w=401wt.eu-S1752777AbZHNJSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbZHNJSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 05:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbZHNJSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 05:18:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34636 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbZHNJSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 05:18:46 -0400
Date: Fri, 14 Aug 2009 11:18:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Brian Swetland <swetland@google.com>,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>, Daniel Ribeiro <drwyrm@gmail.com>,
       arve@android.com, Barry Song <21cnbao@gmail.com>
Subject: Re: [RFC patch 2/3] genirq: Add buslock support for irq chips on
	slow busses
Message-ID: <20090814091819.GA27687@elte.hu>
References: <20090813191535.945521006@linutronix.de> <20090813193116.509070851@linutronix.de> <1250239811.5241.1198.camel@twins> <alpine.LFD.2.00.0908141101540.1283@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0908141101540.1283@localhost.localdomain>
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

> On Fri, 14 Aug 2009, Peter Zijlstra wrote:
> > On Thu, 2009-08-13 at 19:40 +0000, Thomas Gleixner wrote:
> > >  
> > > +/**
> > > + *	disable_slowbus_irq - disable an slowbus irq and wait for completion
> > > + *	@irq: Interrupt to disable
> > > + *
> > > + *	Disable the selected interrupt line.  Enables and Disables are
> > > + *	nested.
> > > + *	This function waits for any pending IRQ handlers for this interrupt
> > > + *	to complete before returning. If you use this function while
> > > + *	holding a resource the IRQ handler may need you will deadlock.
> > > + *
> > > + *	This function must not be called from IRQ context.
> > > + */
> > > +void disable_slowbus_irq(unsigned int irq)
> > > +{
> > > +	struct irq_desc *desc = irq_to_desc(irq);
> > > +
> > > +	if (!desc || !desc->chip || !desc->chip->bus_lock)
> > > +		return;
> > > +
> > > +	desc->chip->bus_lock(irq);
> > > +	disable_irq_nosync(irq);
> > > +	if (desc->action)
> > > +		synchronize_irq(irq);
> > > +	desc->chip->bus_sync_unlock(irq);
> > > +}
> > > +EXPORT_SYMBOL(disable_slowbus_irq);
> > 
> > Should we also not check that desc->chip->bus_lock is not set for the
> > regular function disable_irq()?
> > 
> > It seems to me mixing disable_irq() and disable_slowbus_irq() 
> > is a recipe for disaster.
> > 
> > Same for the other slowbus functions of course.
> 
> Yeah, that's what I wanted to avoid with the first version, which 
> did the conditional locking and did not require a separate API, 
> but Ingo frowned upon the conditional lock.

Mind posting that version too?

Conditional locking is really nasty but if the only other option is 
nastier there's not much we can do, is there?

	Ingo
