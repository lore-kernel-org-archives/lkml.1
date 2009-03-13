Return-Path: <linux-kernel-owner+w=401wt.eu-S1757728AbZCMT63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728AbZCMT63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 15:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbZCMT6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 15:58:21 -0400
Received: from www.tglx.de ([62.245.132.106]:49041 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbZCMT6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 15:58:20 -0400
Date: Fri, 13 Mar 2009 20:55:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Ingo Molnar <mingo@elte.hu>, pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Frans Pop <elendil@planet.nl>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [update, rev. 6] Re: [PATCH 1/10] PM: Rework handling of interrupts
 during suspend-resume (rev. 5)
In-Reply-To: <200903122243.27452.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0903132052240.29264@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <alpine.LFD.2.00.0903112342440.29264@localhost.localdomain> <200903121436.21504.rjw@sisk.pl> <200903122243.27452.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009, Rafael J. Wysocki wrote:
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
> +
> +		spin_lock_irqsave(&desc->lock, flags);
> +		__disable_irq(desc, irq, true);
> +		spin_unlock_irqrestore(&desc->lock, flags);

Can we move the locking into __disable_irq ?

> +	}
> +
> +	for_each_irq_desc(irq, desc)
> +		if (desc->status & IRQ_SUSPENDED)
> +			synchronize_irq(irq);
> +}
> +EXPORT_SYMBOL_GPL(suspend_device_irqs);
> +
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
> +		__enable_irq(desc, irq, true);
> +		spin_unlock_irqrestore(&desc->lock, flags);

Ditto

Thanks,

	tglx
