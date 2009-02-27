Return-Path: <linux-kernel-owner+w=401wt.eu-S1761614AbZB0WKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761614AbZB0WKB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 17:10:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761502AbZB0WJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 17:09:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761500AbZB0WJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 17:09:48 -0500
Date: Fri, 27 Feb 2009 14:09:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: me@felipebalbi.com, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, felipe.balbi@nokia.com,
       dmitry.torokhov@gmail.com, sameo@openedhand.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de
Subject: Re: lockdep and threaded IRQs (was: [PATCH 1/2] input: misc: add
 twl4030-pwrbutton driver)
Message-Id: <20090227140907.f159be9b.akpm@linux-foundation.org>
In-Reply-To: <200902271350.32380.david-b@pacbell.net>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com>
	<20090227123344.33196e99.akpm@linux-foundation.org>
	<20090227203717.GL16801@frodo>
	<200902271350.32380.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009 13:50:32 -0800
David Brownell <david-b@pacbell.net> wrote:

> On Friday 27 February 2009, Felipe Balbi wrote:
> > 
> > > > +static irqreturn_t powerbutton_irq(int irq, void *dev_id)
> > > > +{
> > > > +______int err;
> > > > +______u8 value;
> > > > +
> > > > +#ifdef CONFIG_LOCKDEP
> > > > +______/* WORKAROUND for lockdep forcing IRQF_DISABLED on us, which
> > > > +______ * we don't want and can't tolerate. __Although it might be
> > > > +______ * friendlier not to borrow this thread context...
> > > > +______ */
> > > > +______local_irq_enable();
> > > > +#endif
> > > > +
> > > > +______err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &value,
> > > > +______________________________________________________ __STS_HW_CONDITIONS);
> 
> And right there is the reason we can't tolerate IRQF_DISABLED:
> this IRQ handler must run in a thread, since it needs to make
> sleeping calls through the I2C stack.  (Typically using high
> speed I2C -- 2.6 MHz or more -- so it's not pokey slow; but
> this IRQ handler thread must still sleep.)
> 
> 
> > > > +______...
> > > 
> > > Tell us some more about this lockdep thing ;)
> 
> See kernel/irq/manage.c ... it forces IRQF_DISABLED on.

#ifdef CONFIG_LOCKDEP
	/*
	 * Lockdep wants atomic interrupt handlers:
	 */
	irqflags |= IRQF_DISABLED;
#endif

the comment is useless and the changelog ("[PATCH] lockdep: core") says
nothing about why this is here.  Great.

> That periodically hiddes locking bugs, because it makes
> debug kernels (with lockdep) act *very* differently
> from normal ones "in the field" (no lockdep).

I suppose we could just take that out, see if we can find out why it
was added.

> It also prevents some drivers from working with lockdep.
> Two that come immediatly to mind are the AT91 and OMAP1
> MMC/SD drivers.  (Though I suppose they might work if
> they grow an #ifdef like above.)
> 
> 
> The root cause is that the lock dependency analysis is
> currently making a troublesome simplifying assumption:
> all IRQ handlers disable IRQs.  At this point I think
> it's fair to say most do NOT disable IRQs.
> 
> Peter Zijlstra was really hoping to Tom-Sawyer a fix
> to this issue out of someone, but I think he gave up
> on that approach a while back.  :)
> 
> I'd still like to see the appended patch merge, so
> that developers at least get a heads-up when lockdep
> introduces adds such gremlins to system testing.  Or,
> various drivers could depend on !LOCKDEP ... but that
> would only help (a little) *after* bugs get tracked
> down to "root cause == lockdep", wasting much time.

I never noticed that lockdep was doing this.  Yes, it is pretty
regrettable.

> 
> > David Brownell can comment better about it, that came from him when we
> > were converting twl4030 driver(s) to a more readable form :-)
> > 
> > If you take a look at all twl4030's children, you'll all of them needed
> > that.
> > 
> > Dave, could you comment, please ?
> 
> There are actually two issues.  The lockdep issue is
> one ... the above #ifdef suffices to work around it
> for all the TWL4030 (family) IRQs.
> 
> The other is that Linux needs real support for threaded
> interrupts.  Almost every I2C (or SPI) device that raises
> an IRQ needs its IRQ handler to run in a thread, and most
> of them have the same type of workqueue-based hack to
> get such a thread.  (Some others have bugs instead...)
> 
> Obviously, if any threaded IRQ handler grabs a mutex,
> but lockdep has disabled IRQs, trouble ensues...

What's going on here?  hardirq handlers cannot take mutexes and cannot
sleep, period.  Enabling local interrupts might shut up some warning,
but won't fix the deadlocks which that warning is there to warn us
about.

Confused.

> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> When lockdep turns on IRQF_DISABLED, emit a warning to make it
> easier to track down problems this introduces in drivers that
> expect handlers to run with IRQs enabled.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  kernel/irq/manage.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -689,7 +689,11 @@ int request_irq(unsigned int irq, irq_ha
>  	/*
>  	 * Lockdep wants atomic interrupt handlers:
>  	 */
> -	irqflags |= IRQF_DISABLED;
> +	if (!(irqflags & IRQF_DISABLED)) {
> +		pr_warning("IRQ %d/%s: lockdep sets IRQF_DISABLED\n",
> +				irq, devname);
> +		irqflags |= IRQF_DISABLED;
> +	}
>  #endif

I suppose so, if we can't just stop doing this.
