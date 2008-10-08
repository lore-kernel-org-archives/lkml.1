Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbYJHWlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbYJHWlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 18:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755440AbYJHWla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 18:41:30 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:56805 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144AbYJHWla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 18:41:30 -0400
Date: Thu, 9 Oct 2008 00:41:24 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Tony Lindgren <tony@atomide.com>
Subject: Re: [patch 2.6.27-rc8-git] add drivers/mfd/twl4030-core.c
Message-ID: <20081008224123.GD4766@localdomain>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <200810061047.50127.david-b@pacbell.net> <20081008171814.GB4766@localdomain> <200810081051.00132.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200810081051.00132.david-b@pacbell.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2008 at 10:50:59AM -0700, David Brownell wrote:
> On Wednesday 08 October 2008, Samuel Ortiz wrote:
> > Thanks, applied to my mfd tree.
> 
> Great!
> 
> > > +#if defined(CONFIG_TWL4030_BCI_BATTERY) || \
> > > +     defined(CONFIG_TWL4030_BCI_BATTERY_MODUEL)
> > 
> > minor typo, you probably meant: CONFIG_TWL4030_BCI_BATTERY_MODULE
> 
> Yes, good catch.  You'll tweak?
Sure.
 
> Appended is that simple IRQ cleanup I mentioned.
> (Get a load of the diffstat!)
Sweet. I should look at it for the asic3 driver.
Applied to the mfd tree, thanks.


> There's more substantial IRQ stuff on the way, but
> it won't be ready before the 2.6.28 merges start.
I can still take patches during the merge window, if you think they're really
ready and necessary.

Cheers,
Samuel.


> - Dave
> 
> ================== CUT HERE
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> twl4030-core irq simplification
> 
> Simplify twl4030 IRQ handling by removing a needless custom flow
> handler.  The top level IRQs, from the PIH, are well suited for
> handle_simple_irq() ... they can't be acked or masked.
> 
> Switching resolves some issues with how IRQs were dispatched.
> Notably, abuse of desc->status, IRQ accounting, and handling
> of various faults.
> 
> In short, use standard genirq code.
> 
> Drivers that request_irq() to the PIH will need to pay more
> attention to things like setting IRQF_DISABLED (since it's
> no longer ignored), and making I2C calls from handlers (you'll
> need a lockdep workaround).
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---
>  drivers/mfd/twl4030-core.c |   68 +--------------------------------------------
>  1 file changed, 2 insertions(+), 66 deletions(-)
> 
> --- a/drivers/mfd/twl4030-core.c
> +++ b/drivers/mfd/twl4030-core.c
> @@ -535,68 +535,6 @@ EXPORT_SYMBOL(twl4030_i2c_read_u8);
>  
>  /*----------------------------------------------------------------------*/
>  
> -/*
> - * do_twl4030_module_irq() is the desc->handle method for each of the twl4030
> - * module interrupts that doesn't chain to another irq_chip (GPIO, power, etc).
> - * It executes in kernel thread context.  On entry, cpu interrupts are disabled.
> - */
> -static void do_twl4030_module_irq(unsigned int irq, irq_desc_t *desc)
> -{
> -	struct irqaction *action;
> -	const unsigned int cpu = smp_processor_id();
> -
> -	/*
> -	 * Earlier this was desc->triggered = 1;
> -	 */
> -	desc->status |= IRQ_LEVEL;
> -
> -	/*
> -	 * The desc->handle method would normally call the desc->chip->ack
> -	 * method here, but we won't bother since our ack method is NULL.
> -	 */
> -
> -	if (!desc->depth) {
> -		kstat_cpu(cpu).irqs[irq]++;
> -
> -		action = desc->action;
> -		if (action) {
> -			int ret;
> -			int status = 0;
> -			int retval = 0;
> -
> -			local_irq_enable();
> -
> -			do {
> -				/* Call the ISR with cpu interrupts enabled */
> -				ret = action->handler(irq, action->dev_id);
> -				if (ret == IRQ_HANDLED)
> -					status |= action->flags;
> -				retval |= ret;
> -				action = action->next;
> -			} while (action);
> -
> -			if (status & IRQF_SAMPLE_RANDOM)
> -				add_interrupt_randomness(irq);
> -
> -			local_irq_disable();
> -
> -			if (retval != IRQ_HANDLED)
> -				printk(KERN_ERR "ISR for TWL4030 module"
> -					" irq %d can't handle interrupt\n",
> -					irq);
> -
> -			/*
> -			 * Here is where we should call the unmask method, but
> -			 * again we won't bother since it is NULL.
> -			 */
> -		} else
> -			printk(KERN_CRIT "TWL4030 module irq %d has no ISR"
> -					" but can't be masked!\n", irq);
> -	} else
> -		printk(KERN_CRIT "TWL4030 module irq %d is disabled but can't"
> -				" be masked!\n", irq);
> -}
> -
>  static unsigned twl4030_irq_base;
>  
>  static struct completion irq_event;
> @@ -611,7 +549,6 @@ static int twl4030_irq_thread(void *data)
>  	static unsigned i2c_errors;
>  	const static unsigned max_i2c_errors = 100;
>  
> -	daemonize("twl4030-irq");
>  	current->flags |= PF_NOFREEZE;
>  
>  	while (!kthread_should_stop()) {
> @@ -691,8 +628,7 @@ static struct task_struct * __init start_twl4030_irq_thread(long irq)
>  	struct task_struct *thread;
>  
>  	init_completion(&irq_event);
> -	thread = kthread_run(twl4030_irq_thread, (void *)irq,
> -			     "twl4030 irq %ld", irq);
> +	thread = kthread_run(twl4030_irq_thread, (void *)irq, "twl4030-irq");
>  	if (!thread)
>  		pr_err("%s: could not create twl4030 irq %ld thread!\n",
>  		       DRIVER_NAME, irq);
> @@ -1126,7 +1062,7 @@ static void twl_init_irq(int irq_num, unsigned irq_base, unsigned irq_end)
>  	/* install an irq handler for each of the PIH modules */
>  	for (i = irq_base; i < irq_end; i++) {
>  		set_irq_chip_and_handler(i, &twl4030_irq_chip,
> -				do_twl4030_module_irq);
> +				handle_simple_irq);
>  		activate_irq(i);
>  	}
>  
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
