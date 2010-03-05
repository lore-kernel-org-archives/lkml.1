Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab0CEH6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 02:58:42 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57389 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab0CEH6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 02:58:41 -0500
Date: Fri, 5 Mar 2010 08:58:39 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] genirq: spurious irq detection for threaded irqs
Message-ID: <20100305075839.GA15810@pengutronix.de>
References: <1267698622-1216-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.00.1003042323090.2014@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1003042323090.2014@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 11:26:20PM +0100, Thomas Gleixner wrote:
> On Thu, 4 Mar 2010, Uwe Kleine-König wrote:
> > -void note_interrupt(unsigned int irq, struct irq_desc *desc,
> > -		    irqreturn_t action_ret)
> > +void note_threaded_interrupt(unsigned int irq, struct irq_desc *desc,
> > +		irqreturn_t action_ret)
> >  {
> >  	if (unlikely(action_ret != IRQ_HANDLED)) {
> >  		/*
> > @@ -262,6 +262,19 @@ void note_interrupt(unsigned int irq, struct irq_desc *desc,
> >  	desc->irqs_unhandled = 0;
> >  }
> >  
> > +void note_interrupt(unsigned int irq, struct irq_desc *desc,
> > +		irqreturn_t action_ret)
> > +{
> > +	if (action_ret == IRQ_WAKE_THREAD)
> > +		/* handled in irq_thread() when the threaded handler returns */
> > +		return;
> > +
> > +	/* don't report IRQ_WAKE_THREAD | IRQ_HANDLED as bogus return value */
> > +	action_ret &= ~IRQ_WAKE_THREAD;
> > +
> > +	note_threaded_interrupt(irq, desc, action_ret);
> > +}
> > +
> 
> We don't need an extra function for that. A simple
> 
> 	if (action_ret & IRQ_WAKE_THREAD)
> 		return;
> 
> in note_interrupt() is sufficient to cover everything.
With your suggestion if action_ret == IRQ_WAKE_THREAD | IRQ_HANDLED then
the IRQ_HANDLED bit doesn't get noted.  Does that matter?

But still you're right about the extra function.  Assuming a threaded
handler doesn't return IRQ_WAKE_THREAD my note_interrupt does the same
as note_threaded_interrupt.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
