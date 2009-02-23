Return-Path: <linux-kernel-owner+w=401wt.eu-S1753770AbZBWRRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbZBWRRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 12:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbZBWRR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 12:17:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50847 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbZBWRR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 12:17:26 -0500
Date: Mon, 23 Feb 2009 18:16:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during
	suspend-resume
Message-ID: <20090223171630.GA28651@elte.hu>
References: <200902221837.49396.rjw@sisk.pl> <200902230048.33635.rjw@sisk.pl> <20090223083645.GA9582@elte.hu> <200902231229.58743.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902231229.58743.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > > +void suspend_device_irqs(void)
> > > +{
> > > +	struct irq_desc *desc;
> > > +	int irq;
> > > +
> > > +	for_each_irq_desc(irq, desc) {
> > > +		unsigned long flags;
> > > +
> > > +		spin_lock_irqsave(&desc->lock, flags);
> > > +
> > > +		if (!desc->depth && desc->action
> > > +		    && !(desc->action->flags & IRQF_TIMER)) {
> > > +			desc->depth++;
> > > +			desc->status |= IRQ_DISABLED | IRQ_SUSPENDED;
> > > +			desc->chip->disable(irq);
> > > +		}
> > > +
> > > +		spin_unlock_irqrestore(&desc->lock, flags);
> > > +	}
> > > +
> > > +	for_each_irq_desc(irq, desc) {
> > > +		if (desc->status & IRQ_SUSPENDED)
> > > +			synchronize_irq(irq);
> > > +	}
> > 
> > Optimization/code-flow nit: a possibility might be to do a 
> > single loop, i.e. i think it's safe to couple the 
> > disable+sync bits [as in 99.99% of the cases there will be 
> > no in-execution irq handlers when we execute this.]
> 
> Well, Linus suggested to do it in a separate loop.  I'm fine 
> with both ways.

Linus, do you have a strong opinion about which variant we 
should use?

The two approaches are not completely equivalent, the variant 
suggested by Linus is a bit more 'atomic' - in that it first 
turns off everything, then looks for everything that needs to be 
synchronized.

OTOH, it _shouldnt_ make much of a difference on a correctly 
working system - we ought to be able to disable the irqs one by 
one and wait on any pending ones on the spot. Maybe if there was 
some implicit dependency between irq sources it would be more 
robust to do Linus's version.

Dunno ... no strong feelings either way.

	Ingo
