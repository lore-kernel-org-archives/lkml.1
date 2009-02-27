Return-Path: <linux-kernel-owner+w=401wt.eu-S1758502AbZB0Vur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502AbZB0Vur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757206AbZB0Vuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:50:37 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:33468 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756805AbZB0Vuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:50:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=msaim5r4GjENPt1X7M16A6JePF/vVcAxvfNnpuMhQv9b1qX08gI+ftDTtcSeGl109yTRth9lOtV+LbgKwe4L9lECshjI7xzQ3RSdHzyIBx5QF5RBDau96Yla2RwMveik2KOMjWz8H7NwHsrVYMRk8CjKPF1Pk26lzfcEbWbjLRc=  ;
X-YMail-OSG: 3.9CfvgVM1mgpc00ex0bZDejjIFmtt86S8k0OMH2Y44hh9cL6BToabXudagdoONj4uJwZi3ugahIt_HDjklKbpdyPG4ZV59ulWFmI_O6BLidjM6zRn6nL9U8p2EWL50d.MUq7v8rxzE7nMpMGdNl5O5Kf73uwVSdkLiycyZ6WZfgodMQQNNwCjC3CTea3doR4g--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: me@felipebalbi.com
Subject: Re: lockdep and threaded IRQs (was: [PATCH 1/2] input: misc: add twl4030-pwrbutton driver)
Date: Fri, 27 Feb 2009 13:50:32 -0800
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, felipe.balbi@nokia.com,
       dmitry.torokhov@gmail.com, sameo@openedhand.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <20090227123344.33196e99.akpm@linux-foundation.org> <20090227203717.GL16801@frodo>
In-Reply-To: <20090227203717.GL16801@frodo>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902271350.32380.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 February 2009, Felipe Balbi wrote:
> 
> > > +static irqreturn_t powerbutton_irq(int irq, void *dev_id)
> > > +{
> > > +   int err;
> > > +   u8 value;
> > > +
> > > +#ifdef CONFIG_LOCKDEP
> > > +   /* WORKAROUND for lockdep forcing IRQF_DISABLED on us, which
> > > +    * we don't want and can't tolerate.  Although it might be
> > > +    * friendlier not to borrow this thread context...
> > > +    */
> > > +   local_irq_enable();
> > > +#endif
> > > +
> > > +   err = twl4030_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &value,
> > > +                             STS_HW_CONDITIONS);

And right there is the reason we can't tolerate IRQF_DISABLED:
this IRQ handler must run in a thread, since it needs to make
sleeping calls through the I2C stack.  (Typically using high
speed I2C -- 2.6 MHz or more -- so it's not pokey slow; but
this IRQ handler thread must still sleep.)


> > > +   ...
> > 
> > Tell us some more about this lockdep thing ;)

See kernel/irq/manage.c ... it forces IRQF_DISABLED on.

That periodically hiddes locking bugs, because it makes
debug kernels (with lockdep) act *very* differently
from normal ones "in the field" (no lockdep).

It also prevents some drivers from working with lockdep.
Two that come immediatly to mind are the AT91 and OMAP1
MMC/SD drivers.  (Though I suppose they might work if
they grow an #ifdef like above.)


The root cause is that the lock dependency analysis is
currently making a troublesome simplifying assumption:
all IRQ handlers disable IRQs.  At this point I think
it's fair to say most do NOT disable IRQs.

Peter Zijlstra was really hoping to Tom-Sawyer a fix
to this issue out of someone, but I think he gave up
on that approach a while back.  :)

I'd still like to see the appended patch merge, so
that developers at least get a heads-up when lockdep
introduces adds such gremlins to system testing.  Or,
various drivers could depend on !LOCKDEP ... but that
would only help (a little) *after* bugs get tracked
down to "root cause == lockdep", wasting much time.


> David Brownell can comment better about it, that came from him when we
> were converting twl4030 driver(s) to a more readable form :-)
> 
> If you take a look at all twl4030's children, you'll all of them needed
> that.
> 
> Dave, could you comment, please ?

There are actually two issues.  The lockdep issue is
one ... the above #ifdef suffices to work around it
for all the TWL4030 (family) IRQs.

The other is that Linux needs real support for threaded
interrupts.  Almost every I2C (or SPI) device that raises
an IRQ needs its IRQ handler to run in a thread, and most
of them have the same type of workqueue-based hack to
get such a thread.  (Some others have bugs instead...)

Obviously, if any threaded IRQ handler grabs a mutex,
but lockdep has disabled IRQs, trouble ensues...

I've lost track of the status of the threaded IRQ stuff,
but the last proposal I saw from Thomas Gleixner looked
like it omitted IRQ chaining support that TWL4030 type
chips need.  See drivers/mfd/twl4030-irq.c for what
AFAIK is the only in-tree example of an irq_chip where
the guts of the irq_chip methods themselves must run in
threads (to mask/ack/... IRQs using i2c registers).
Presumably the threaded IRQ support will offer cleaner
ways to handle such stuff.

- Dave


======== CUT HERE
From: David Brownell <dbrownell@users.sourceforge.net>

When lockdep turns on IRQF_DISABLED, emit a warning to make it
easier to track down problems this introduces in drivers that
expect handlers to run with IRQs enabled.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 kernel/irq/manage.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -689,7 +689,11 @@ int request_irq(unsigned int irq, irq_ha
 	/*
 	 * Lockdep wants atomic interrupt handlers:
 	 */
-	irqflags |= IRQF_DISABLED;
+	if (!(irqflags & IRQF_DISABLED)) {
+		pr_warning("IRQ %d/%s: lockdep sets IRQF_DISABLED\n",
+				irq, devname);
+		irqflags |= IRQF_DISABLED;
+	}
 #endif
 	/*
 	 * Sanity-check: shared interrupts must pass in a real dev-ID,

