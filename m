Return-Path: <linux-kernel-owner+w=401wt.eu-S933817AbZFLSJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933817AbZFLSJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 14:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbZFLSJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 14:09:12 -0400
Received: from www.tglx.de ([62.245.132.106]:48031 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405AbZFLSJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 14:09:11 -0400
Date: Fri, 12 Jun 2009 20:09:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kevin Hilman <khilman@deeprootsystems.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: do not disable IRQ_WAKEUP marked irqs on
 suspend
In-Reply-To: <87fxe5fi9v.fsf@deeprootsystems.com>
Message-ID: <alpine.LFD.2.00.0906122005140.2800@localhost.localdomain>
References: <cMiA9-1MZ-13@gated-at.bofh.it> <87fxe5fi9v.fsf@deeprootsystems.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009, Kevin Hilman wrote:
> Thomas Gleixner <tglx@linutronix.de> writes:
> 
> > commit 0a0c5168df (PM: Introduce functions for suspending and resuming
> > device interrupts) iterates through all interrupts and disables them
> > on the hardware level. Some architectures have functionality
> > implemented to mark an interrupt source as wakeup source for suspend,
> > but the new power management code disables them unconditionally which
> > breaks the resume on interrupt functionality.
> >
> > The wakeup interrupts are marked in the status with the IRQ_WAKEUP
> > bit. Skip the disablement for those interrupts which have the
> > IRQ_WAKEUP bit set.
> >     
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: stable@kernel.org
> 
> Hi Thomas,
> 
> I posted the same patch last month and lost the argument, original
> thread here:
> 
>   http://lkml.org/lkml/2009/5/6/549

Err no. Care to look at the difference ? 

I missed the above discussion, but I'm revisiting the delayed disable
issue.

> 
> > diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
> > index 638d8be..bce6afd 100644
> > --- a/kernel/irq/pm.c
> > +++ b/kernel/irq/pm.c
> > @@ -29,7 +29,8 @@ void suspend_device_irqs(void)
> >  		unsigned long flags;
> >  
> >  		spin_lock_irqsave(&desc->lock, flags);
> > -		__disable_irq(desc, irq, true);
> > +		if (!(desc->status & IRQ_WAKEUP))
> > +			__disable_irq(desc, irq, true);
> >  		spin_unlock_irqrestore(&desc->lock, flags);
> >  	}
> >  
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
