Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab0CHJBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 04:01:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52648 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab0CHJBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 04:01:42 -0500
Date: Mon, 8 Mar 2010 10:01:39 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] genirq: spurious irq detection for threaded irqs
Message-ID: <20100308090139.GA27502@pengutronix.de>
References: <alpine.LFD.2.00.1003042323090.2014@localhost.localdomain> <1267802291-5197-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.00.1003052102580.2014@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1003052102580.2014@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,

On Fri, Mar 05, 2010 at 09:16:53PM +0100, Thomas Gleixner wrote:
> On Fri, 5 Mar 2010, Uwe Kleine-König wrote:
> 
> > For threaded irqs the top half returns IRQ_WAKE_THREAD.  Don't treat
> > that value like IRQ_HANDLED for the spurious check.  Instead check the
> > return value of the threaded handler to be able to detect stuck irqs
> > that only have threaded handlers and no top half that can detect the
> > problem.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > ---
> > Hello,
> > 
> > changed since v1:
> > 
> >  - use note_interrupt for the threaded handler's return value, getting rid of
> >    note_threaded_interrupt.  The only downside is that a threaded handler
> >    returning IRQ_WAKE_THREAD remains uncatched now.
> 
> Well that's easy to fix.
>  
> > +			if (!noirqdebug)
> > +				note_interrupt(action->irq, desc, action_ret);
> 
>   				note_interrupt(action->irq, desc,
>   					       action_ret & ~IRQ_WAKE_THREAD);
Hmmm, this makes IRQ_WAKE_THREAD be noted as IRQ_NONE.
If this is intended it IMHO deserves a comment.  Something like:

	/*
	 * The threaded handler must return IRQ_NONE or IRQ_HANDLED.
	 * As IRQ_WAKE_THREAD is handled special by note_interrupt
	 * report it as IRQ_NONE.
	 */

Well and with that approach (IRQ_WAKE_THREAD | IRQ_HANDLED) is handled
as IRQ_HANDLED, but I think I start wasting time.

Actually I don't care what we do here, should I resend with action_ret &
~IRQ_WAKE_THREAD and the comment?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
