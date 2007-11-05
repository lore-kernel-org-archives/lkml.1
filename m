Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbXKELTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbXKELTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 06:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbXKELSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 06:18:53 -0500
Received: from nic2.axis.se ([193.13.178.10]:43192 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881AbXKELSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 06:18:52 -0500
Date: Mon, 5 Nov 2007 12:18:39 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRISv10 serial driver rewrite
Message-ID: <20071105111839.GI7621@axis.com>
References: <20071102093432.GD7621@axis.com> <472AFE4D.5030308@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <472AFE4D.5030308@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2007 at 11:39:09AM +0100, Jiri Slaby wrote:
> On 11/02/2007 10:34 AM, Jesper Nilsson wrote:
> > @@ -4434,7 +3941,7 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
> >  	if (tty_hung_up_p(filp) ||
> >  	    (info->flags & ASYNC_CLOSING)) {
> >  		if (info->flags & ASYNC_CLOSING)
> > -			interruptible_sleep_on(&info->close_wait);
> > +			wait_event_interruptible(info->close_wait, 0);
> 
> Aiee, this is nonsense, 0 will never be 1, only signal will stop this, use
> completion instead.

True, I've changed it to use "!info->flags & ASYNC_CLOSING" condition
for now, as this is a more non-intrusive patch.
I will look at using completion later, at the same time as using
spinlocks instead of volatiles.

> You maybe want to create a function for this deinit invoked from
> more places in the new code.

Good idea, I've done that too for the new patch.

> >  static int __init
> > @@ -4812,7 +4418,26 @@ rs_init(void)
> >  #if !defined(CONFIG_ETRAX_SERIAL_FAST_TIMER)
> >  	init_timer(&flush_timer);
> >  	flush_timer.function = timed_flush_handler;
> 
> Side note, this should be setup_timer without accessing .function.

Also excellent point, have done so.

> > -	if (request_irq(SERIAL_IRQ_NBR, ser_interrupt, IRQF_SHARED | IRQF_DISABLED, "serial ", NULL))
> > -		panic("irq8");
> > +	if (request_irq(SERIAL_IRQ_NBR, ser_interrupt,
> > +			IRQF_SHARED | IRQF_DISABLED, "serial ", driver))
> > +		panic("%s: Failed to request irq8", __FUNCTION__);
> 
> Is the panic needed here? Can't the cris architecture live without the driver?

There are some differing opinions on that here, it should probably not
reach this unless there is a configuration error, and so it more like
a debug-help. I'll put this on the "to clarify" list.

> > +	u8 dma_out_enabled:1;	/* Set to 1 if DMA should be used */
> > +	u8 dma_in_enabled:1;	/* Set to 1 if DMA should be used */
> 
> bitfileds generate ugly code.

Agreed, I've changed them to u8 instead. The space saving is
not worth the aggravation.

> > +	volatile int		tr_running; /* 1 if output is running */
> 
> What's the volatile for here? atomic_t?

The driver uses old volatile style synchronization. Changing over
to spinlocks is like I mentioned on my todo-list.

> > +#ifdef DECLARE_WAITQUEUE
> > +	wait_queue_head_t	open_wait;
> > +	wait_queue_head_t	close_wait;
> > +#else
> > +	struct wait_queue	*open_wait;
> > +	struct wait_queue	*close_wait;
> > +#endif
> 
> We know, we have it, don't we?

True, old compatibility code, removed in the new patch.

> Jiri Slaby (jirislaby@gmail.com)
> Faculty of Informatics, Masaryk University

Thanks for all the comments!

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
