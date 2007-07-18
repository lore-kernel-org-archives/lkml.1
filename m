Return-Path: <linux-kernel-owner+w=401wt.eu-S1761782AbXGRWrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761782AbXGRWrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbXGRWrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:47:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47113 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752164AbXGRWrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:47:12 -0400
Date: Wed, 18 Jul 2007 15:46:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH RFC] Debug handling of early spurious interrupts
Message-Id: <20070718154659.c8b5ffea.akpm@linux-foundation.org>
In-Reply-To: <1184666997.5271.5.camel@sebastian.kern.oss.ntt.co.jp>
References: <1184666997.5271.5.camel@sebastian.kern.oss.ntt.co.jp>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 19:09:57 +0900
Fernando Luis V__zquez Cao <fernando@oss.ntt.co.jp> wrote:

> With the advent of kdump it is possible that device drivers receive
> interrupts generated in the context of a previous kernel. Ideally
> quiescing the underlying devices should suffice but not all drivers
> do this, either because it is not possible or because they did not
> contemplate this case. Thus drivers ought to be able to handle
> interrupts coming in as soon as the interrupt handler is registered.
> 
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> ---
> 
> diff -urNp linux-2.6.22-orig/kernel/irq/manage.c linux-2.6.22/kernel/irq/manage.c
> --- linux-2.6.22-orig/kernel/irq/manage.c	2007-07-09 08:32:17.000000000 +0900
> +++ linux-2.6.22/kernel/irq/manage.c	2007-07-17 18:37:24.000000000 +0900
> @@ -537,6 +537,29 @@ int request_irq(unsigned int irq, irq_ha
>  
>  	select_smp_affinity(irq);
>  
> +#if defined(CONFIG_DEBUG_PENDING_IRQ) || defined(CONFIG_DEBUG_SHIRQ)
> +#ifndef CONFIG_DEBUG_PENDING_IRQ
> +	if (irqflags & IRQF_SHARED) {
> +		/*
> +		 * It's a shared IRQ -- the driver ought to be prepared for it
> +		 * to happen immediately, so let's make sure....
> +		 * We do this before actually registering it, to make sure that
> +		 * a 'real' IRQ doesn't run in parallel with our fake.
> +		 */
> +#endif /* !CONFIG_DEBUG_PENDING_IRQ */
> +		if (irqflags & IRQF_DISABLED) {
> +			unsigned long flags;
> +
> +			local_irq_save(flags);
> +			handler(irq, dev_id);
> +			local_irq_restore(flags);
> +		} else
> +			handler(irq, dev_id);
> +#ifndef CONFIG_DEBUG_PENDING_IRQ
> +	}
> +#endif /* !CONFIG_DEBUG_PENDING_IRQ */
> +#endif /* CONFIG_DEBUG_PENDING_IRQ || CONFIG_DEBUG_SHIRQ */

Even if we were going to merge this functionality as-is, I'd ask for some
sort of refactoring to fix up that ifdef maze.

But more substantial issues:

- This is presented as a "debug" feature, but it isn't a debug feature at
  all - it is new functionality which is unrelated to kernel development.

  Also, it is a "debug" feature which provides no debugging!  At the very
  least, one would expect to see it emit a printk to tell people that we
  have some driver which needs fixing.

  Also, this not-really-a-debug-feature is undesirably coupled with a
  real debugging feature: CONFIG_DEBUG_PENDING_IRQ.

- Does this new feature really need its own Kconfig setting?  Why not enable
  it unconditionally?  request_irq() isn't exactly performance-critical.

- If poss, we really do want to find some way of emitting a warning when
  we detect such a device driver.  Like, call the handler and if it
  returned IRQ_HANDLED, start shouting.


