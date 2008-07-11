Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbYGKFlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbYGKFlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 01:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbYGKFlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 01:41:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:59138 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbYGKFlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 01:41:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,343,1212390000"; 
   d="scan'208";a="590310433"
Date: Thu, 10 Jul 2008 22:41:06 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 11/26] x64, x2apic/intr-remap: generic irq migration support from process context
Message-ID: <20080711054106.GS1678@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com> <20080710182237.489115000@linux-os.sc.intel.com> <m13amhgwx8.fsf@frodo.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m13amhgwx8.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 04:08:03PM -0700, Eric W. Biederman wrote:
> Suresh Siddha <suresh.b.siddha@intel.com> writes:
> 
> > Generic infrastructure for migrating the irq from the process context in the
> > presence of CONFIG_GENERIC_PENDING_IRQ.
> >
> > This will be used later for migrating irq in the presence of
> > interrupt-remapping.
> 
> Why the API difference between IRQ_MOVE_PCNTXT set affinity handlers and
> !CONFIG_GENERIC_PENDING_IRQ handlers?

You are referring to desc->lock portion?

Two reasons:

a. Other code in CONFIG_GENERIC_PENDING_IRQ, assuming that desc->lock is held
while calling set_affinity. like fixup_irqs(). Just wanted to be same
across the board.

b. for level triggered, we still touch irq_desc and set IRQ_MOVE_PENDING,
when we fail to move the irq (if there is already some level triggered
interrupt happening in parallel). while, we can acquire the lock inside
the set_affinity, I thought this simplifies things.

> 
> 
> >  #ifdef CONFIG_GENERIC_PENDING_IRQ
> > -     set_pending_irq(irq, cpumask);
> > +     if (desc->status & IRQ_MOVE_PCNTXT) {
> > +             unsigned long flags;
> > +
> > +             spin_lock_irqsave(&desc->lock, flags);
> > +             desc->chip->set_affinity(irq, cpumask);
> > +             spin_unlock_irqrestore(&desc->lock, flags);
> > +     } else
> > +             set_pending_irq(irq, cpumask);
> >  #else
> >       desc->affinity = cpumask;
> >       desc->chip->set_affinity(irq, cpumask);
> >
> > --

thanks,
suresh
