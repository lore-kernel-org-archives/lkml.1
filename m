Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbZCRMT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbZCRMT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 08:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbZCRMTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 08:19:19 -0400
Received: from smtp.nokia.com ([192.100.122.233]:23620 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbZCRMTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 08:19:18 -0400
Date: Wed, 18 Mar 2009 14:00:56 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext David Brownell <david-b@pacbell.net>
Cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "me@felipebalbi.com" <me@felipebalbi.com>,
       "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
       "sameo@openedhand.com" <sameo@openedhand.com>
Subject: Re: [patch/rfc 1/2] GENIRQ: add handle_threaded_irq() flow handler
Message-ID: <20090318120056.GG24947@scadufax.research.nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <20090303004427.GA8638@elte.hu> <200903171914.53688.david-b@pacbell.net> <200903171919.48030.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903171919.48030.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 18 Mar 2009 12:17:51.0009 (UTC) FILETIME=[8EA02110:01C9A7C3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 18, 2009 at 03:19:47AM +0100, David Brownell wrote:

[..]

> @@ -295,6 +295,67 @@ static inline void mask_ack_irq(struct i
>  }
>  
>  /**
> + *	handle_threaded_irq - flow handler reusing current irq thread
> + *	@irq:	the interrupt number
> + *	@desc:	the interrupt description structure for this irq
> + *	Context: irq thread, with IRQs enabled
> + *
> + *	IRQ threads which demultiplex IRQs may use this flow handler
> + *	to chain those demultiplexed IRQs to subsidiary handlers, when
> + *	all that IRQ dispatch logic must run in sleeping contexts.
> + *
> + *	Examples include some multifunction I2C and SPI based devices
> + *	(where access to registers, including ones involved in IRQ
> + *	dispatching, requires sleeping) that have multiple independent
> + *	maskable interupts.
> + *
> + *	The irq thread using this flow handler must handle any ack,
> + *	clear, mask or unmask issues needed.
> + */
> +void
> +handle_threaded_irq(unsigned int irq, struct irq_desc *desc)
> +{
> +	struct irqaction *action;
> +	irqreturn_t action_ret;
> +
> +	spin_lock_irq(&desc->lock);
> +
> +	if (unlikely(desc->status & IRQ_INPROGRESS))
> +		goto out_unlock;
> +	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
> +	kstat_incr_irqs_this_cpu(irq, desc);
> +
> +	action = desc->action;
> +	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
> +		goto out_unlock;

you say below irqs are always enabled so this branch is something we
never want to happen. How about adding a WARN() then ?

-- 
balbi
