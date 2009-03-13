Return-Path: <linux-kernel-owner+w=401wt.eu-S1757617AbZCMV5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617AbZCMV5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 17:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbZCMV5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 17:57:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38531 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817AbZCMV5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 17:57:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [update, rev. 6] Re: [PATCH 1/10] PM: Rework handling of interrupts during suspend-resume (rev. 5)
Date: Fri, 13 Mar 2009 22:56:50 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7-tst; KDE/4.2.1; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Frans Pop <elendil@planet.nl>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
References: <200902221837.49396.rjw@sisk.pl> <200903122243.27452.rjw@sisk.pl> <alpine.LFD.2.00.0903132052240.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903132052240.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903132256.51522.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 March 2009, Thomas Gleixner wrote:
> On Thu, 12 Mar 2009, Rafael J. Wysocki wrote:
> > +/**
> > + * suspend_device_irqs - disable all currently enabled interrupt lines
> > + *
> > + * During system-wide suspend or hibernation device interrupts need to be
> > + * disabled at the chip level and this function is provided for this purpose.
> > + * It disables all interrupt lines that are enabled at the moment and sets the
> > + * IRQ_SUSPENDED flag for them.
> > + */
> > +void suspend_device_irqs(void)
> > +{
> > +	struct irq_desc *desc;
> > +	int irq;
> > +
> > +	for_each_irq_desc(irq, desc) {
> > +		unsigned long flags;
> > +
> > +		spin_lock_irqsave(&desc->lock, flags);
> > +		__disable_irq(desc, irq, true);
> > +		spin_unlock_irqrestore(&desc->lock, flags);
> 
> Can we move the locking into __disable_irq ?

Well, yes, but (see below)

> > +	}
> > +
> > +	for_each_irq_desc(irq, desc)
> > +		if (desc->status & IRQ_SUSPENDED)
> > +			synchronize_irq(irq);
> > +}
> > +EXPORT_SYMBOL_GPL(suspend_device_irqs);
> > +
> > +/**
> > + * resume_device_irqs - enable interrupt lines disabled by suspend_device_irqs()
> > + *
> > + * Enable all interrupt lines previously disabled by suspend_device_irqs() that
> > + * have the IRQ_SUSPENDED flag set.
> > + */
> > +void resume_device_irqs(void)
> > +{
> > +	struct irq_desc *desc;
> > +	int irq;
> > +
> > +	for_each_irq_desc(irq, desc) {
> > +		unsigned long flags;
> > +
> > +		if (!(desc->status & IRQ_SUSPENDED))
> > +			continue;
> > +
> > +		spin_lock_irqsave(&desc->lock, flags);
> > +		__enable_irq(desc, irq, true);
> > +		spin_unlock_irqrestore(&desc->lock, flags);
> 
> Ditto

No, because of __setup_irq().

Thanks,
Rafael
