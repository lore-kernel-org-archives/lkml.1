Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbYJBEwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbYJBEwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 00:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbYJBEwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 00:52:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38848 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbYJBEwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 00:52:30 -0400
Date: Thu, 2 Oct 2008 00:52:27 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
Subject: Re: [RFC patch 2/5] genirq: add a quick check handler
In-Reply-To: <20081001223301.900862899@linutronix.de>
Message-ID: <alpine.DEB.1.10.0810020028230.11373@gandalf.stny.rr.com>
References: <20081001223213.078984344@linutronix.de> <20081001223301.900862899@linutronix.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thomas,

Nice work, thanks for doing this.

Little comments below.

On Wed, 1 Oct 2008, Thomas Gleixner wrote:
>  
>  extern irqreturn_t no_action(int cpl, void *dev_id);
> -extern int __must_check request_irq(unsigned int, irq_handler_t handler,
> +
> +extern int __must_check
> +request_irq_quickcheck(unsigned int, irq_handler_t handler,
> +		       irq_handler_t quick_check_handler,
>  		       unsigned long, const char *, void *);

It would be nice to still keep the name of the parameters here.
	unsigned long flags, const char *name, void *dev

> +
> +static inline int __must_check
> +request_irq(unsigned int irq, irq_handler_t handler, unsigned long flags,
> +	    const char *name, void *dev)
> +{
> +	return request_irq_quickcheck(irq, handler, NULL, flags, name, dev);
> +}
> +
>  extern void free_irq(unsigned int, void *);
>  
>  struct device;
> Index: linux-2.6-tip/include/linux/irqreturn.h
> ===================================================================
> --- linux-2.6-tip.orig/include/linux/irqreturn.h
> +++ linux-2.6-tip/include/linux/irqreturn.h
> @@ -5,10 +5,12 @@
>   * enum irqreturn
>   * @IRQ_NONE		interrupt was not from this device
>   * @IRQ_HANDLED		interrupt was handled by this device
> + * @IRQ_NEEDS_HANDLING	quick check handler requests to run real handler
>   */
>  enum irqreturn {
>  	IRQ_NONE,
>  	IRQ_HANDLED,
> +	IRQ_NEEDS_HANDLING,
>  };
>  
>  #define irqreturn_t	enum irqreturn
> Index: linux-2.6-tip/kernel/irq/handle.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/irq/handle.c
> +++ linux-2.6-tip/kernel/irq/handle.c
> @@ -137,9 +137,21 @@ irqreturn_t handle_IRQ_event(unsigned in
>  		local_irq_enable_in_hardirq();
>  
>  	do {
> -		ret = action->handler(irq, action->dev_id);
> -		if (ret == IRQ_HANDLED)
> -			status |= action->flags;
> +		if (action->quick_check_handler)
> +			ret = action->quick_check_handler(irq, action->dev_id);
> +		else
> +			ret = IRQ_NEEDS_HANDLING;
> +
> +		switch (ret) {
> +		default:
> +			break;
> +
> +		case IRQ_NEEDS_HANDLING:
> +			ret = action->handler(irq, action->dev_id);
> +			if (ret == IRQ_HANDLED)
> +				status |= action->flags;
> +			break;
> +		}
>  		retval |= ret;
>  		action = action->next;
>  	} while (action);
> Index: linux-2.6-tip/kernel/irq/manage.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/irq/manage.c
> +++ linux-2.6-tip/kernel/irq/manage.c
> @@ -563,9 +563,14 @@ void free_irq(unsigned int irq, void *de
>  EXPORT_SYMBOL(free_irq);
>  
>  /**
> - *	request_irq - allocate an interrupt line
> + *	request_irq_quickcheck - allocate an interrupt line
>   *	@irq: Interrupt line to allocate
> - *	@handler: Function to be called when the IRQ occurs
> + *	@handler: Function to be called when the IRQ occurs.
> + *		  Primary handler for threaded interrupts
> + *      @quick_check_handler: Function to be called when the interrupt
> + *			   before the real handler is called to check
> + *                         whether the interrupt originated from the device
> + *                         can be NULL


The above reads funny. How about something like:

	@quick_check_handler: Function called before the real interrupt
			handler. It checks if the interrupt originated
			from the device. This can be NULL.

-- Steve


>   *	@irqflags: Interrupt type flags
>   *	@devname: An ascii name for the claiming device
>   *	@dev_id: A cookie passed back to the handler function
> @@ -589,10 +594,11 @@ EXPORT_SYMBOL(free_irq);
>   *	IRQF_SHARED		Interrupt is shared
>   *	IRQF_DISABLED	Disable local interrupts while processing
>   *	IRQF_SAMPLE_RANDOM	The interrupt can be used for entropy
> - *
>   */
> -int request_irq(unsigned int irq, irq_handler_t handler,
> -		unsigned long irqflags, const char *devname, void *dev_id)
> +int request_irq_quickcheck(unsigned int irq, irq_handler_t handler,
> +			   irq_handler_t quick_check_handler,
> +			   unsigned long irqflags, const char *devname,
> +			   void *dev_id)
>  {
>  	struct irqaction *action;
>  	int retval;
> @@ -622,6 +628,7 @@ int request_irq(unsigned int irq, irq_ha
>  	if (!action)
>  		return -ENOMEM;
>  
> +	action->quick_check_handler = quick_check_handler;
>  	action->handler = handler;
>  	action->flags = irqflags;
>  	cpus_clear(action->mask);
> @@ -651,4 +658,4 @@ int request_irq(unsigned int irq, irq_ha
>  
>  	return retval;
>  }
> -EXPORT_SYMBOL(request_irq);
> +EXPORT_SYMBOL(request_irq_quickcheck);
> 
> 
> 
