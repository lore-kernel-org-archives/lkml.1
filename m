Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbYLVHBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbYLVHBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 02:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbYLVHAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 02:00:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58673 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbYLVHAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 02:00:52 -0500
Date: Mon, 22 Dec 2008 08:00:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hrtimer: increase clock min delta threshold while
	interrupt hanging
Message-ID: <20081222070044.GC29160@elte.hu>
References: <494EEC60.4080708@gmail.com> <200812220307.16808.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200812220307.16808.elendil@planet.nl>
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


* Frans Pop <elendil@planet.nl> wrote:

> > Impact: avoid hanging on slow systems
> >
> > While using the function graph tracer on a virtualized system, the 
> > hrtimer_interrupt can hang the system on an infinite loop. This can be 
> > caused on several situation where something intrusive is slowing the 
> > system (ie: tracing) and the next clock events to program are always 
> > before the current time. This patch implements a reasonable 
> > compromise. If such a situation is detected, we share the CPUs time in 
> > 1/4 to process the hrtimer interrupts. This is enough to let the 
> > system running without serious starvation.
> 
> Should there maybe also be a mechanism to allow the system to 
> automatically "recover" to higher (the original?) clockfrequencies, for 
> example if the danger of loops has passed after tracing has been 
> disabled?

I dont think that's necessary - tick_dev_program_event() already includes 
a gradual approach that increases the 'min delta' interval step by step - 
so we should find the 'system is limping along' compromise pretty 
accurately.

A system can get "magically faster" later on (if we turn off tracing or 
other kernel features that impact the cost of the timer tick), and we 
might not need those safety measures anymore - but here the real solution 
will be to make the virtualizer faster. Taking milliseconds to process a 
timer tick (be that under tracing or not) is rather slow. So the kernel 
has applied the brakes and has printed a warning about it - we should do 
no more.

> > +static int force_clock_reprogram;
> 
> Shouldn't this be initialized to 0?

no - global or static scope variables are initialized to zero in C.

> > @@ -1239,7 +1267,7 @@ void hrtimer_interrupt(struct clock_event_device *dev) 
> >         /* Reprogramming necessary ? */
> >         if (expires_next.tv64 != KTIME_MAX) {
> > -               if (tick_program_event(expires_next, 0))
> > +               if (tick_program_event(expires_next, force_clock_reprogram))
> > 			goto retry; 
> >         }
> >  }
> 
> Shouldn't force_clock_reprogram be reset to 0 after it has fired and 
> been handled?

hm, that would be interesting to see - in theory the system should become 
stable after a few iterations of increasing min_delta. Frederic, is the 
system still workable if you try what Frans has suggested?

Also, there's min_delta doubling in tick_dev_program_event() itself too - 
that interacts with the irq-overload logic:

+       dev->min_delta_ns = (unsigned long)try_time.tv64 * 3;

	Ingo
