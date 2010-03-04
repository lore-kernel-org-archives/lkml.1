Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab0CDW0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 17:26:52 -0500
Received: from www.tglx.de ([62.245.132.106]:50225 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab0CDW0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 17:26:51 -0500
Date: Thu, 4 Mar 2010 23:26:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] genirq: spurious irq detection for threaded irqs
In-Reply-To: <1267698622-1216-1-git-send-email-u.kleine-koenig@pengutronix.de>
Message-ID: <alpine.LFD.2.00.1003042323090.2014@localhost.localdomain>
References: <1267698622-1216-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-197665319-1267741582=:2014"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-197665319-1267741582=:2014
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 4 Mar 2010, Uwe Kleine-König wrote:
> -void note_interrupt(unsigned int irq, struct irq_desc *desc,
> -		    irqreturn_t action_ret)
> +void note_threaded_interrupt(unsigned int irq, struct irq_desc *desc,
> +		irqreturn_t action_ret)
>  {
>  	if (unlikely(action_ret != IRQ_HANDLED)) {
>  		/*
> @@ -262,6 +262,19 @@ void note_interrupt(unsigned int irq, struct irq_desc *desc,
>  	desc->irqs_unhandled = 0;
>  }
>  
> +void note_interrupt(unsigned int irq, struct irq_desc *desc,
> +		irqreturn_t action_ret)
> +{
> +	if (action_ret == IRQ_WAKE_THREAD)
> +		/* handled in irq_thread() when the threaded handler returns */
> +		return;
> +
> +	/* don't report IRQ_WAKE_THREAD | IRQ_HANDLED as bogus return value */
> +	action_ret &= ~IRQ_WAKE_THREAD;
> +
> +	note_threaded_interrupt(irq, desc, action_ret);
> +}
> +

We don't need an extra function for that. A simple

	if (action_ret & IRQ_WAKE_THREAD)
		return;

in note_interrupt() is sufficient to cover everything.

Thanks,

	tglx
--8323328-197665319-1267741582=:2014--
