Return-Path: <linux-kernel-owner+w=401wt.eu-S1767859AbXCJQRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767859AbXCJQRn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 11:17:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767856AbXCJQRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 11:17:43 -0500
Received: from www.osadl.org ([213.239.205.134]:46992 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767854AbXCJQRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 11:17:42 -0500
Subject: Re: question about periodic clocks
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <45F2D3CE.1060008@goop.org>
References: <45F1ED30.5070402@goop.org>
	 <1173516061.24738.1148.camel@localhost.localdomain>
	 <45F2D3CE.1060008@goop.org>
Content-Type: text/plain
Date: Sat, 10 Mar 2007 17:24:04 +0100
Message-Id: <1173543844.24738.1178.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-10 at 07:50 -0800, Jeremy Fitzhardinge wrote:
> Thomas Gleixner wrote:
> > Good point. I never thought about that and we set the period in the
> > clock event device itself. You are right, the clockevents layer should
> > hand over the period either with the set_mode call or seperately.
> > Probably with the set_mode call, as it is needed exactly there and we
> > don't want to have a "if (dev->mode == XXX)" check in set_next_event().
> >
> > I look into this.
> >
> So, in the meantime, the period is 1/HZ?

Yep.

> I also have a question about clockevent cpumasks.  I was using the lapic
> clockevent as a model, but as I understand it there's a lapic per CPU,
> which explains why it registers a clockevent per cpu with that cpu alone
> in the cpumask.
> 
> The Xen timer is a bit different; I guess more like hpet.  There's a
> single (virtual-)machine-wide timer, which is "owned" by the last cpu
> with programmed it; ie, that cpu is the one which gets the resulting
> event interrupt.  Does this mean I should register a single clockevent
> device with a cpumask of CPU_MASK_ALL?  Or should I constrain it to a
> single cpu?

Uuurg. That's ugly. clockevents expect a per CPU timer especially for
dynamic ticks. If you cannot provide a per cpu timer, then you probably
need to use the broadcast trick.

Register a primary clocksource (as PIT/HPET) and register per CPU dummy
clocksources with CLOCK_EVT_FEAT_DUMMY set - we use the same trick, when
the lapic timer is broken. The clockevents code then uses PIT/HPET as
the primary tick source and broadcasts the periodic tick to the other
CPUs. In that case the dyntick / highres features are disabled.

We did some experiments to support multiple CPUs with one timer for
hres/dyntick but it does not scale and it is so ugly that it is not
worth the trouble. It works for the lapic stops in C3 case, as we have a
well defined point (right before going into the deep power state) where
we can rearm the global clock event device. As we are idle at that point
anyway there is not much penalty, but I really dont want to do that in
an active system.

> There's a comment in hpet.c saying
> 
> 		 * Start hpet with the boot cpu mask and make it
> 		 * global after the IO_APIC has been initialized.
> 
> but I don't see any place where the hpet cpumask is updated.

I wanted to do that in the first place, but never bothered. In an UP
environment it does not matter. On a sane SMP box (where we do not have
the local APIC stops in C3 problem) the HPET (analogous PIT) is switched
off for ever. In the case of LAPIC stops in C3 the HPET(PIT) is used as
a broadcast fallback. That means before we go into C3 we arm the
HPET/PIT for the earliest to expire lapic event of all CPUs. In that
case it does not matter, whether HPET/PIT is pinned to CPU#0 or anything
else.

	tglx


