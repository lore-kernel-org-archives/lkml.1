Return-Path: <linux-kernel-owner+w=401wt.eu-S937328AbXGTVo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937328AbXGTVo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937128AbXGTVno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:43:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48463 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936948AbXGTVnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:43:42 -0400
Date: Fri, 20 Jul 2007 14:43:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Debug handling of early spurious interrupts
Message-Id: <20070720144302.2785e961.akpm@linux-foundation.org>
In-Reply-To: <1184898043.28418.3.camel@sebastian.kern.oss.ntt.co.jp>
References: <1184666997.5271.5.camel@sebastian.kern.oss.ntt.co.jp>
	<20070718154659.c8b5ffea.akpm@linux-foundation.org>
	<1184896459.27369.36.camel@sebastian.kern.oss.ntt.co.jp>
	<1184896944.27369.50.camel@sebastian.kern.oss.ntt.co.jp>
	<1184898043.28418.3.camel@sebastian.kern.oss.ntt.co.jp>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007 11:20:43 +0900
Fernando Luis V__zquez Cao <fernando@oss.ntt.co.jp> wrote:

> With the advent of kdump it is possible that device drivers receive
> interrupts generated in the context of a previous kernel. Ideally
> quiescing the underlying devices should suffice but not all drivers do
> this, either because it is not possible or because they did not
> contemplate this case. Thus drivers ought to be able to handle
> interrupts coming in as soon as the interrupt handler is registered.
> 
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> ---
> 
> diff -urNp linux-2.6.22-orig/kernel/irq/manage.c linux-2.6.22-pendirq/kernel/irq/manage.c
> --- linux-2.6.22-orig/kernel/irq/manage.c	2007-07-19 18:18:53.000000000 +0900
> +++ linux-2.6.22-pendirq/kernel/irq/manage.c	2007-07-19 19:43:41.000000000 +0900
> @@ -533,21 +533,32 @@ int request_irq(unsigned int irq, irq_ha
>  
>  	select_smp_affinity(irq);
>  
> -	if (irqflags & IRQF_SHARED) {
> -		/*
> -		 * It's a shared IRQ -- the driver ought to be prepared for it
> -		 * to happen immediately, so let's make sure....
> -		 * We do this before actually registering it, to make sure that
> -		 * a 'real' IRQ doesn't run in parallel with our fake
> -		 */
> -		if (irqflags & IRQF_DISABLED) {
> -			unsigned long flags;
> +	/*
> +	 * With the advent of kdump it possible that device drivers receive
> +	 * interrupts generated in the context of a previous kernel. Ideally
> +	 * quiescing the underlying devices should suffice but not all drivers
> +	 * do this, either because it is not possible or because they did not
> +	 * contemplate this case. Thus drivers ought to be able to handle
> +	 * interrupts coming in as soon as the interrupt handler is registered.
> +	 *
> +	 * Besides, if it is a shared IRQ the driver ought to be prepared for
> +	 * it to happen immediately too.
> +	 *
> +	 * We do this before actually registering it, to make sure that
> +	 * a 'real' IRQ doesn't run in parallel with our fake.
> +	 */
> +	if (irqflags & IRQF_DISABLED) {
> +		unsigned long flags;
>  
> -			local_irq_save(flags);
> -			handler(irq, dev_id);
> -			local_irq_restore(flags);
> -		} else
> -			handler(irq, dev_id);
> +		local_irq_save(flags);
> +		retval = handler(irq, dev_id);
> +		local_irq_restore(flags);
> +	} else
> +		retval = handler(irq, dev_id);
> +	if (retval == IRQ_HANDLED) {
> +		printk(KERN_WARNING
> +		       "%s (IRQ %d) handled a spurious interrupt\n",
> +		       devname, irq);
>  	}
>  

This change means that we'll run the irq handler at request_irq()-time even
for non-shared interrupts.

This is a bit of a worry.  See, shared-interrupt handlers are required to
be able to cope with being called when their device isn't interrupting. 
But nobody ever said that non-shared interrupt handlers need to be able to
cope with that.

Hence these non-shared handlers are within their rights to emit warning
printks, go BUG or accuse the operator of having busted hardware.

So bad things might happen because of this change.  And if they do, they
will take a loooong time to be discovered, because non-shared interrupt
handlers tend to dwell in crufty old drivers which not many people use.

So I'm wondering if it would be more prudent to only do all this for shared
handlers?


