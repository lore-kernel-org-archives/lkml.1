Return-Path: <linux-kernel-owner+w=401wt.eu-S938680AbXGTBym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938680AbXGTBym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 21:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbXGTByg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 21:54:36 -0400
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:42479 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761080AbXGTByf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 21:54:35 -0400
Subject: Re: [PATCH RFC] Debug handling of early spurious interrupts
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
In-Reply-To: <20070718154659.c8b5ffea.akpm@linux-foundation.org>
References: <1184666997.5271.5.camel@sebastian.kern.oss.ntt.co.jp>
	 <20070718154659.c8b5ffea.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Fri, 20 Jul 2007 10:54:19 +0900
Message-Id: <1184896459.27369.36.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-18 at 15:46 -0700, Andrew Morton wrote:
> On Tue, 17 Jul 2007 19:09:57 +0900
> Fernando Luis V__zquez Cao <fernando@oss.ntt.co.jp> wrote:
> 
> > With the advent of kdump it is possible that device drivers receive
> > interrupts generated in the context of a previous kernel. Ideally
> > quiescing the underlying devices should suffice but not all drivers
> > do this, either because it is not possible or because they did not
> > contemplate this case. Thus drivers ought to be able to handle
> > interrupts coming in as soon as the interrupt handler is registered.
> > 
> > Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> > ---
> > 
> > diff -urNp linux-2.6.22-orig/kernel/irq/manage.c linux-2.6.22/kernel/irq/manage.c
> > --- linux-2.6.22-orig/kernel/irq/manage.c	2007-07-09 08:32:17.000000000 +0900
> > +++ linux-2.6.22/kernel/irq/manage.c	2007-07-17 18:37:24.000000000 +0900
> > @@ -537,6 +537,29 @@ int request_irq(unsigned int irq, irq_ha
> >  
> >  	select_smp_affinity(irq);
> >  
> > +#if defined(CONFIG_DEBUG_PENDING_IRQ) || defined(CONFIG_DEBUG_SHIRQ)
> > +#ifndef CONFIG_DEBUG_PENDING_IRQ
> > +	if (irqflags & IRQF_SHARED) {
> > +		/*
> > +		 * It's a shared IRQ -- the driver ought to be prepared for it
> > +		 * to happen immediately, so let's make sure....
> > +		 * We do this before actually registering it, to make sure that
> > +		 * a 'real' IRQ doesn't run in parallel with our fake.
> > +		 */
> > +#endif /* !CONFIG_DEBUG_PENDING_IRQ */
> > +		if (irqflags & IRQF_DISABLED) {
> > +			unsigned long flags;
> > +
> > +			local_irq_save(flags);
> > +			handler(irq, dev_id);
> > +			local_irq_restore(flags);
> > +		} else
> > +			handler(irq, dev_id);
> > +#ifndef CONFIG_DEBUG_PENDING_IRQ
> > +	}
> > +#endif /* !CONFIG_DEBUG_PENDING_IRQ */
> > +#endif /* CONFIG_DEBUG_PENDING_IRQ || CONFIG_DEBUG_SHIRQ */
> 
> Even if we were going to merge this functionality as-is, I'd ask for some
> sort of refactoring to fix up that ifdef maze.
I a absolutely agree. My first impulse was to get rid of all the cpp
kludge including the Kconfig setting CONFIG_DEBUG_SHIRQ, since, as you
pointed out, request_irq() is not really performance critical.
Unfortunately for the RFC I decided to be conservative and ended up with
an "ifdef maze". Thank you for the heads-up.

> But more substantial issues:
> 
> - This is presented as a "debug" feature, but it isn't a debug feature at
>   all - it is new functionality which is unrelated to kernel development.
Yup.

>   Also, it is a "debug" feature which provides no debugging!  At the very
>   least, one would expect to see it emit a printk to tell people that we
>   have some driver which needs fixing.
I am afraid that in some occasions the kernel may panic inside the
interrupt handler, but I agree that we need to print a meaningful
message for the general case (i.e. something goes wrong but we can
recover). I will do that.

>   Also, this not-really-a-debug-feature is undesirably coupled with a
>   real debugging feature: CONFIG_DEBUG_PENDING_IRQ.
In the new version of the patch I will remove both
CONFIG_DEBUG_PENDING_IRQ and CONFIG_DEBUG_SHIRQ. request_irq() and
setup_irq() are not fast paths and free_irq() much less so.

> - Does this new feature really need its own Kconfig setting?  Why not enable
>   it unconditionally?  request_irq() isn't exactly performance-critical.
I guess the Kconfig setting is not needed. In fact, by enabling this
feature unconditionally we would have _everyone_ (unknowing) testing an
area which is a major pain point for kdump. I am not sure this is an
acceptable default for all systems though. Opinions welcome.

> - If poss, we really do want to find some way of emitting a warning when
>   we detect such a device driver.  Like, call the handler and if it
>   returned IRQ_HANDLED, start shouting.
I will do that and submit updated patches.

Thank you for your feedback, Andrew!

