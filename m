Return-Path: <linux-kernel-owner+w=401wt.eu-S933033AbYEFUv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033AbYEFUv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762029AbYEFUvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:51:45 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:41291 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761227AbYEFUvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:51:44 -0400
Date: Tue, 6 May 2008 17:50:04 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       venkatesh.pallipadi@intel.com
Subject: Re: x86: Clean up computation of HPET .mult variables
Message-ID: <20080506205003.GA3749@beyonder.ift.unesp.br>
Mail-Followup-To: Daniel Walker <dwalker@mvista.com>,
	linux-kernel@vger.kernel.org, tglx@linutronix.de,
	venkatesh.pallipadi@intel.com
References: <20080505231016.GA29072@beyonder.ift.unesp.br> <1210031888.17132.85.camel@localhost.localdomain> <20080506021321.GA4928@Pilar.virtua.com.br> <1210044218.17132.109.camel@localhost.localdomain> <20080506125920.GA26295@beyonder.ift.unesp.br> <1210090880.17132.140.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210090880.17132.140.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue  6.May'08 at  9:21:20 -0700, Daniel Walker wrote:
> 
> On Tue, 2008-05-06 at 09:59 -0300, Carlos R. Mafra wrote:
> > On Mon  5.May'08 at 20:23:38 -0700, Daniel Walker wrote:
> > > 
> > > On Mon, 2008-05-05 at 23:13 -0300, Carlos R. Mafra wrote:
> > > > So the savings in my patch is due to using the period directly, and
> > > > not the frequency. That's what my idea was, so if you object then
> > > > my attempt was a failure and should be forgotten :-)
> > > > 
> > > > Or maybe I should create a clocksource_period2mult to replace 
> > > > clocksource_hz2mult and save the extra operation in more places too?
> > > 
> > > The one concern I have is the rounding that is done in the
> > > clocksource_hz2mult(). The div_sc doesn't include it .. 
> > 
> > So that would be a point in favour of using div_sc(), right?
> 
> No, the other way. I think clocksource_hz2mult() is more accurate.

> [...]

> > And do you agree that your first suggestion of using clocksource_hz2mult
> > makes the code a bit bigger due to the extra computation of the frequency?
> 
> I agree, but the size in this case takes a back seat to accuracy.

So I wanted to check the accuracy of div_sc versus clocksource_hz2mult
for the computations in arch/x86/kernel/hpet.c, as you made me curious
about it.

First of all, note that hpet_clockevent.mult can not be computed
using clocksource_hz2mult (as you suggested in the first reply) due
to the different definitions for .mult in clockevents.h and 
clocksource.h, so I will skip this one and discuss 
clocksource_hpet.mult instead.

I applied the test patch below to implement the different ways of
computing it and this is what I got in the dmesg:

clocksource_hpet.mult orig = 292935555
clocksource_hpet.mult walker = 292935555
clocksource_hpet.mult my patch = 292935555 hpet_period = 69841279

so there is no difference at all at this precision level!

Out of curiosity I computed the "exact" value by hand and
got 292935555.9 so we can't even talk about "error" because
the difference is in the extra digit not considered with
the precision I used to print the results.

And if you look at the patch to do computation using 
clocksource_hz2mult() you will see that it is uglier
than the simple call to div_sc(), as you have to
consider an extra variable hpet_freq and do an extra
do_div() together with an extra rounding.

So I think you will be ok with the patch now, right? :-)

Thanks,
Carlos

PS: I also computed the "exact" value for hpet_clockevent.mult
by hand and got 

hpet_clockevent.mult = 61496114.58 (exact)
hpet_clockevent.mult = 61496114    (my patch)
hpet_clockevent.mult = 61496110    (original)

so my patch in fact improves the accuracy (due to the fact that
it removes the extra do_div() to compute the frequency, which
originaly did not have the rounding trick.)


diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 9b5cfcd..ee07694 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -326,6 +326,7 @@ static int hpet_clocksource_register(void)
 {
 	u64 tmp, start, now;
 	cycle_t t1;
+	uint64_t hpet_freq;
 
 	/* Start the counter */
 	hpet_start_counter();
@@ -366,6 +367,21 @@ static int hpet_clocksource_register(void)
 	tmp = (u64)hpet_period << HPET_SHIFT;
 	do_div(tmp, FSEC_PER_NSEC);
 	clocksource_hpet.mult = (u32)tmp;
+	printk(KERN_INFO "clocksource_hpet.mult orig = %u\n",
+	       clocksource_hpet.mult);
+
+	clocksource_hpet.mult = 0;
+	hpet_freq = 1000000000000000ULL;
+	hpet_freq += hpet_period/2; /* round for do_div */
+	do_div(hpet_freq, hpet_period);
+	clocksource_hpet.mult = clocksource_hz2mult((u32)hpet_freq, (u32)HPET_SHIFT);
+	printk(KERN_INFO "clocksource_hpet.mult walker = %u\n",
+	       clocksource_hpet.mult);
+
+	clocksource_hpet.mult = 0;
+	clocksource_hpet.mult = div_sc(hpet_period, FSEC_PER_NSEC, HPET_SHIFT);
+	printk(KERN_INFO "clocksource_hpet.mult my patch = %u hpet_period = %lu\n",
+	       clocksource_hpet.mult, hpet_period);
 
 	clocksource_register(&clocksource_hpet);
 
