Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab0CMT4p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 14:56:45 -0500
Received: from www.tglx.de ([62.245.132.106]:60214 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172Ab0CMT4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 14:56:44 -0500
Date: Sat, 13 Mar 2010 20:56:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: akpm@linux-foundation.org
cc: Ingo Molnar <mingo@elte.hu>, maz@misterjones.org,
       joachim.eastwood@jotron.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/3] genirq: introduce IRQF_ALLOW_NESTED flag for
 request_irq()
In-Reply-To: <201003112209.o2BM91oQ013581@imap1.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1003132039110.22855@localhost.localdomain>
References: <201003112209.o2BM91oQ013581@imap1.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Back to LKML

On Thu, 11 Mar 2010, akpm@linux-foundation.org wrote:

Sorry, this dropped from my radar.

> From: Marc Zyngier <maz@misterjones.org>
> 
> Now that we enjoy threaded interrupts, we're starting to see irq_chip
> implementations (wm831x, pca953x) that make use of threaded interrupts for
> the controller, and nested interrupts for the client interrupt.  It all
> works very well, with one drawback:
> 
> Drivers requesting an IRQ must now know whether the handler will run in a
> thread context of not, and call request_threaded_irq() or request_irq()
> accordingly.
> 
> The problem is that the requesting driver sometimes doesn't know about the
> nature of the interrupt, specially when the interrupt controller is a
> discrete chip (typically a GPIO expander connected over I2C) that can be
> connected to a wide variety of otherwise perfectly supported hardware.
> 
> The following patch introduces the IRQF_ALLOW_NESTED flag, that acts as a
> "contract" between the driver and the genirq framework.  By using this
> flag as part of the request_irq() call, the driver informs the genirq
> framework that the handler will happily run either in hardirq or nested
> context, without any ill effect.
> 
> The benefit of this is a single API for drivers.  It still requires the
> driver to be audited, and the flag added to the request_irq() call.
> 
> Of course, this goes against Linus choice of having separate APIs for both
> cases.  The only alternative I can imagine for this is to use
> request_threaded_irq() with the same function provided for both the
> handler and the threaded handler.  Ugly...

In general I have no objections, but one thing bothers me. We have no
way to let a driver know whether it runs in a nested threaded context
or in hard irq context. There might be (future) drivers which would be
happy to know that to apply context dependent optimizations etc.

What about a new function which solves your problem and returns that
information ? Something along the line:

int request_any_context_irq(....)
{
	...
	if (desc->status & IRQ_NESTED_THREAD) {
	   	ret = request_threaded_irq();
		if (!ret)
			ret = IRQ_IS_NESTED;

	} else {
		.....
			ret = IRQ_IS_NONTHREADED;
		else
			ret = IRQ_IS_THREADED;
			
	}
	...
	return ret;
}

You get the idea, right ?

It's a bit more code, but less magic and more flexible for further use
cases.

Thanks,

	tglx
 
> This patch has been tested on ARM and Blackfin platforms.
> 
> Signed-off-by: Marc Zyngier <maz@misterjones.org>
> Tested-by: Joachim Eastwood <joachim.eastwood@jotron.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/interrupt.h |    3 +++
>  kernel/irq/manage.c       |   12 +++++++++---
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff -puN include/linux/interrupt.h~genirq-introduce-irqf_allow_nested-flag-for-request_irq include/linux/interrupt.h
> --- a/include/linux/interrupt.h~genirq-introduce-irqf_allow_nested-flag-for-request_irq
> +++ a/include/linux/interrupt.h
> @@ -52,6 +52,8 @@
>   * IRQF_ONESHOT - Interrupt is not reenabled after the hardirq handler finished.
>   *                Used by threaded interrupts which need to keep the
>   *                irq line disabled until the threaded handler has been run.
> + * IRQF_ALLOW_NESTED - Handler can be either run as hardirq or nested
> + *		       interrupt.
>   */
>  #define IRQF_DISABLED		0x00000020
>  #define IRQF_SAMPLE_RANDOM	0x00000040
> @@ -62,6 +64,7 @@
>  #define IRQF_NOBALANCING	0x00000800
>  #define IRQF_IRQPOLL		0x00001000
>  #define IRQF_ONESHOT		0x00002000
> +#define IRQF_ALLOW_NESTED	0x00004000
>  
>  /*
>   * Bits used by threaded handlers:
> diff -puN kernel/irq/manage.c~genirq-introduce-irqf_allow_nested-flag-for-request_irq kernel/irq/manage.c
> --- a/kernel/irq/manage.c~genirq-introduce-irqf_allow_nested-flag-for-request_irq
> +++ a/kernel/irq/manage.c
> @@ -641,12 +641,18 @@ __setup_irq(unsigned int irq, struct irq
>  
>  	/*
>  	 * Check whether the interrupt nests into another interrupt
> -	 * thread.
> +	 * thread. Nested interrupt must provide a thread function
> +	 * unless it raises the IRQF_ALLOW_NESTED flag.
>  	 */
>  	nested = desc->status & IRQ_NESTED_THREAD;
>  	if (nested) {
> -		if (!new->thread_fn)
> -			return -EINVAL;
> +		if (!new->thread_fn) {
> +			if (new->flags & IRQF_ALLOW_NESTED)
> +				new->thread_fn = new->handler;
> +			else
> +				return -EINVAL;
> +		}
> +
>  		/*
>  		 * Replace the primary handler which was provided from
>  		 * the driver for non nested interrupt handling by the
> _
> 
