Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbZCKKkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbZCKKkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 06:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbZCKKkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 06:40:10 -0400
Received: from www.tglx.de ([62.245.132.106]:38244 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbZCKKkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 06:40:09 -0400
Date: Wed, 11 Mar 2009 11:33:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Frans Pop <elendil@planet.nl>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH 1/10] PM: Rework handling of interrupts during suspend-resume
 (rev. 5)
In-Reply-To: <200903111036.02482.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0903111106450.29264@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <200903111030.39371.rjw@sisk.pl> <200903111036.02482.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

On Wed, 11 Mar 2009, Rafael J. Wysocki wrote:

> Index: linux-2.6/kernel/irq/pm.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/kernel/irq/pm.c
> @@ -0,0 +1,89 @@
> +/*
> + * linux/kernel/irq/pm.c
> + *
> + * Copyright (C) 2009 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
> + *
> + * This file contains power management functions related to interrupts.
> + */
> +
> +#include <linux/irq.h>
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +
> +#include "internals.h"
> +
> +/**
> + * suspend_device_irqs - disable all currently enabled interrupt lines
> + *
> + * During system-wide suspend or hibernation device interrupts need to be
> + * disabled at the chip level and this function is provided for this purpose.
> + * It disables all interrupt lines that are enabled at the moment and sets the
> + * IRQ_SUSPENDED flag for them.
> + */
> +void suspend_device_irqs(void)
> +{
> +	struct irq_desc *desc;
> +	int irq;
> +
> +	for_each_irq_desc(irq, desc) {
> +		unsigned long flags;
> +		bool sync = false;
> +
> +		spin_lock_irqsave(&desc->lock, flags);
> +
> +		if (desc->action && !(desc->action->flags & IRQF_TIMER)) {
> +			if (!desc->depth++) {
> +				desc->status |= IRQ_DISABLED;
> +				desc->chip->disable(irq);
> +				sync = true;
> +			}
> +			desc->status |= IRQ_SUSPENDED;

  This flag needs to be checked in __enable_irq().

> +		}
> +
> +		spin_unlock_irqrestore(&desc->lock, flags);
> +
> +		if (sync)
> +			synchronize_irq(irq);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(suspend_device_irqs);

  I'm not too enthusiastic about this open coded implementation of
  disable_irq() with slightly different semantics.

  Can we please move the fiddling with desc->* into
  kernel/irq/manage.c and share the code there ?

> +/**
> + * resume_device_irqs - enable interrupt lines disabled by suspend_device_irqs()
> + *
> + * Enable all interrupt lines previously disabled by suspend_device_irqs() that
> + * have the IRQ_SUSPENDED flag set.
> + */
> +void resume_device_irqs(void)
> +{
> +	struct irq_desc *desc;
> +	int irq;
> +
> +	for_each_irq_desc(irq, desc) {
> +		unsigned long flags;
> +
> +		if (!(desc->status & IRQ_SUSPENDED))
> +			continue;
> +
> +		spin_lock_irqsave(&desc->lock, flags);
> +		desc->status &= ~IRQ_SUSPENDED;
> +		__enable_irq(desc, irq);
> +		spin_unlock_irqrestore(&desc->lock, flags);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(resume_device_irqs);

  Ditto.

Thanks,

	tglx
