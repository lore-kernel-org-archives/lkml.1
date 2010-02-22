Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0BVPyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 10:54:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab0BVPyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 10:54:15 -0500
Date: Mon, 22 Feb 2010 16:53:13 +0100 (CET)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [ANNOUNCE] 2.6.33-rc8-rt1
In-Reply-To: <alpine.LFD.2.00.1002221614480.4136@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1002221652190.3770@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>  <alpine.LFD.2.00.0910061210400.2646@localhost.localdomain>  <alpine.LFD.2.00.0910141115020.9428@localhost.localdomain>  <alpine.LFD.2.00.0911061743210.12138@localhost.localdomain> 
 <alpine.LFD.2.00.0911101326280.2725@localhost.localdomain>  <alpine.LFD.2.00.1001212102220.2906@localhost.localdomain>  <alpine.LFD.2.00.1002181748460.2811@localhost.localdomain>  <alpine.LFD.2.00.1002212322450.2811@localhost.localdomain> 
 <520f0cf11002220311l2a0caa83lf3ae2817b78501b6@mail.gmail.com>  <alpine.LFD.2.00.1002221228130.2811@localhost.localdomain> <520f0cf11002220423u64daf89dxa6a4249522adabee@mail.gmail.com> <alpine.LFD.2.00.1002221614480.4136@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 22 Feb 2010, Thomas Gleixner wrote:

> On Mon, 22 Feb 2010, John Kacur wrote:
> > That patch fixes the symptom I reported, but unfortunately, I still
> > can't log-in to my laptop without the machine freezing.
> > Not sure why, investigating.
> 
> Found it, at least it make my mouse/keyboard work again and fixes the
> weird double character problem on VT login.
> 
> Thanks,
> 
> 	tglx
> ----
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 25642d1..1efad98 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -563,15 +563,20 @@ irq_wait_for_interrupt(struct irq_desc *desc, struct irqaction *action)
>   * handler finished. unmask if the interrupt has not been disabled and
>   * is marked MASKED.
>   */
> -static void irq_finalize_oneshot(unsigned int irq, struct irq_desc *desc)
> +static void irq_finalize_oneshot(unsigned int irq, struct irq_desc *desc,
> +				 struct irqaction *action)
>  {
>  	chip_bus_lock(irq, desc);
> +#ifndef CONFIG_PREEMPT_RT
>  	raw_spin_lock_irq(&desc->lock);
>  	if (!(desc->status & IRQ_DISABLED) && (desc->status & IRQ_MASKED)) {
>  		desc->status &= ~IRQ_MASKED;
>  		desc->chip->unmask(irq);
>  	}
>  	raw_spin_unlock_irq(&desc->lock);
> +#else
> +	preempt_hardirq_thread_done(desc, action);
> +#endif
>  	chip_bus_sync_unlock(irq, desc);
>  }
>  
> @@ -645,7 +650,7 @@ static int irq_thread(void *data)
>  			action->thread_fn(action->irq, action->dev_id);
>  
>  			if (oneshot)
> -				irq_finalize_oneshot(action->irq, desc);
> +				irq_finalize_oneshot(action->irq, desc, action);
>  		}
>  
>  		wake = atomic_dec_and_test(&desc->threads_active);
> 


Thanks Thomas

The fix seems to work for me.
I've got some other issues, but for now I'm going to assume they are the
same acpi problems I have reported to lkml for the "vanilla" -rc8

John
