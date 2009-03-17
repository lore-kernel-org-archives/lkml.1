Return-Path: <linux-kernel-owner+w=401wt.eu-S1759514AbZCQQN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514AbZCQQN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 12:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbZCQQNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 12:13:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51885 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808AbZCQQNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 12:13:46 -0400
Date: Tue, 17 Mar 2009 17:13:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jesper Krogh <jesper@krogh.cc>,
       john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
Message-ID: <20090317161322.GA25904@elte.hu>
References: <alpine.LFD.2.00.0903141814180.7421@localhost.localdomain> <49BD225C.4070305@krogh.cc> <alpine.LFD.2.00.0903151050070.3131@localhost.localdomain> <49BD4B2D.7000501@krogh.cc> <alpine.LFD.2.00.0903151146550.3131@localhost.localdomain> <49BD5C7C.2060605@krogh.cc> <49BEA1AD.1090901@krogh.cc> <alpine.LFD.2.00.0903161225210.3675@localhost.localdomain> <20090317081412.GA24115@elte.hu> <alpine.LFD.2.00.0903170831020.3082@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903170831020.3082@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 17 Mar 2009, Ingo Molnar wrote:
> > 
> > Cool. Will you apply it yourself (in the merge window) or should 
> > we pick it up?
> 
> I'll commit it.  I already split it into two commits - one for the 
> trivial startup problem that John had, one for the "estimate error 
> and exit when smaller than 500ppm" part.

ok.

> > Incidentally, yesterday i wrote a PIT auto-calibration routine 
> > (see WIP patch below).
> > 
> > The core idea is to use _all_ thousands of measurement points 
> > (not just two) to calculate the frequency ratio, with a built-in 
> > noise detector which drops out of the loop if the observed noise 
> > goes below ~10 ppm.
> 
> I suspect that reaching 10 ppm is going to take too long in 
> general. Considering that I found a machine where reaching 500ppm 
> took 16ms, getting to 10ppm would take almost a second. That's a 
> long time at bootup, considering that people want the whole boot 
> to take about that time ;)
> 
> I also do think it's a bit unnecessarily complicated. We really 
> only care about the end points - obviously we can end up being 
> unlucky and get a very noisy end-point due to something like SMI 
> or virtualization, but if that happens, we're really just better 
> off failing quickly instead, and we'll go on to the slower 
> calibration routines.

That's the idea of my patch: to use not two endpoints but thousands 
of measurement points. That way we dont have to worry about the 
precision of the endpoints - any 'bad' measurement will be 
counter-acted by thousands of 'good' measurements.

That's the theory at least - practice got in my way ;-)

By measuring more we can get a more precise result, and we also do 
not assume anything about how much time passes between two 
measurement points. A single measurement is:

+	/*
+        * We use the PIO accesses as natural TSC serialization barriers:
+        */
+       pit_lsb                 = inb(0x42);
+       tsc                     = get_cycles();
+       pit_msb                 = inb(0x42);

Just like we can prove that there's an exoplanet around a star, just 
by doing a _ton_ of measurements of a very noisy data source. As 
long as there's an underlying physical value to be measured (and we 
are not measuring pure noise) that value is recoverable, with enough 
measurements.

> On real hardware without SMI or virtualization overhead, the 
> delays _should_ be very stable. On my main machine, for example, 
> the PIT read really seems very stable at about 2.5us (which 
> matches the expectation that one 'inb' should take roughly one 
> microsecond pretty closely). So that should be the default case, 
> and the case that the fast calibration is designed for.
> 
> For the other cases, we really can just exit and do something 
> else.
> 
> > It's WIP because it's not working yet (or at all?): i couldnt 
> > get the statistical model right - it's too noisy at 1000-2000 
> > ppm and the frequency result is off by 5000 ppm.
> 
> I suspect your measurement overhead is getting noticeable. You do 
> all those divides, but even more so, you do all those traces. 
> Also, it looks like you do purely local pairwise analysis at 
> subsequent PIT modelling points, which can't work - you need to 
> average over a long time to stabilize it.

Actually, it's key to my trick that what happens _between_ the 
measurement points does not matter _at all_.

My 'delta' algorithm does not assume anything about how much time 
passes between two measurement points - it calculates the slope and 
keeps a rolling average of that slope.

That's why i could put the delta analysis there. We are capturing 
thousands of measurement points, and what matters is the precision 
of the 'pair' of (PIT,TSC) timestamp measurements.

I got roughly the same end result noise and the same anomalies with 
tracing enabled and disabled. (and the number of data points was cut 
in half with tracing enabled)

	Ingo
