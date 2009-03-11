Return-Path: <linux-kernel-owner+w=401wt.eu-S1753081AbZCKVP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbZCKVP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 17:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbZCKVPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 17:15:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54965 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZCKVPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 17:15:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/10] PM: Rework handling of interrupts during suspend-resume (rev. 5)
Date: Wed, 11 Mar 2009 22:15:00 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7-tst; KDE/4.2.1; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Frans Pop <elendil@planet.nl>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
References: <200902221837.49396.rjw@sisk.pl> <200903111036.02482.rjw@sisk.pl> <alpine.LFD.2.00.0903111106450.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903111106450.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903112215.02445.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 March 2009, Thomas Gleixner wrote:
> Rafael,
> 
> On Wed, 11 Mar 2009, Rafael J. Wysocki wrote:
> 
> > Index: linux-2.6/kernel/irq/pm.c
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6/kernel/irq/pm.c
> > @@ -0,0 +1,89 @@
> > +/*
> > + * linux/kernel/irq/pm.c
> > + *
> > + * Copyright (C) 2009 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
> > + *
> > + * This file contains power management functions related to interrupts.
> > + */
> > +
> > +#include <linux/irq.h>
> > +#include <linux/module.h>
> > +#include <linux/interrupt.h>
> > +
> > +#include "internals.h"
> > +
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
> > +		bool sync = false;
> > +
> > +		spin_lock_irqsave(&desc->lock, flags);
> > +
> > +		if (desc->action && !(desc->action->flags & IRQF_TIMER)) {
> > +			if (!desc->depth++) {
> > +				desc->status |= IRQ_DISABLED;
> > +				desc->chip->disable(irq);
> > +				sync = true;
> > +			}
> > +			desc->status |= IRQ_SUSPENDED;
> 
>   This flag needs to be checked in __enable_irq().

[I overlooked this comment, sorry.]

Why does it?

Rafael
