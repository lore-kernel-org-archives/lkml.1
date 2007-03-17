Return-Path: <linux-kernel-owner+w=401wt.eu-S933699AbXCQJtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699AbXCQJtx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 05:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933700AbXCQJtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 05:49:53 -0400
Received: from www.osadl.org ([213.239.205.134]:35094 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933699AbXCQJtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 05:49:51 -0400
Subject: Re: [BUG] 2.6.21-rc1,2,3 regressions on my system that I found so
	far
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Len Brown <lenb@kernel.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <200703162132.53906.lenb@kernel.org>
References: <200703161230.03712.maximlevitsky@gmail.com>
	 <1174088686.13341.347.camel@localhost.localdomain>
	 <200703162132.53906.lenb@kernel.org>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 10:56:44 +0100
Message-Id: <1174125404.13341.396.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Len,

On Fri, 2007-03-16 at 21:32 -0400, Len Brown wrote:
> > > [   36.433917] APIC timer disabled due to verification failure.
> > > 
> > > And NO_HZ is disabled due to that (I get 1000/s timer's interrupts)
> > > I haven't investigated that yet.
> > > It looks like another new test that my hardware fails to perform... 
> > 
> > Yes, this is probably caused by SMM code trying to emulate a PS/2
> > keyboard from a (maybe connected or not) USB keyboard. Unfortunately we
> > have no way to disable this BIOS misfeature in the early boot process. 
> > Arjan, Len ?????
> 
> Nope.  By definition, SMM is invisible to the OS -- we don't even
> get a bit that said it occurred (though we'd like one -- it would
> be really helpful to diagnose issues like this one)

I know that it is invisible. Nevertheless I know that the BIOSes emulate
PS/2 keyboards from USB via SMM during the boot process until we call
the usb_handoff function.

> So go into BIOS SETUP and see if there is a USB Legacy Emulation
> feature that you can disable.  Sometimes there is not, but disabling
> onboard USB altogether may help at least prove the issue is in that area.

I have more than one box (even original Intel mainboards), where either
plugging a PS/2 keyboard or switching off USB makes this problem go
away.

> > I built in this test to rule out bogus LAPIC timer calibration values
> > which are sometimes off by factor 2-10.
> > 
> > But I also built in a calibration against the PM-Timer, which turned out
> > to be quite reliable and I think the additional verification step is
> > only necessary for sytems without PM-Timer.
> > 
> > That was a bit over cautious from my side. I send a patch to avoid this
> > when PM-Timer is available in a separate mail.
> 
> PM-Timer was invented to work-around the issue that the TSC became unreliable
> in the face of power management on laptops.  In particular, to be able
> to time duration of OS idle where TSC stopped.
> 
> While it is not fine grain, and it is not low-latency, is should
> be very reliable.  My understanding is that it is implemented as
> a simple divider right off the system 14MHz clock -- the signal
> which most motherboard clocks are PLL multiplied up from --
> including the 100MHz front-side bus which drives the LAPIC timer.
> 
> But that said, I don't understand why calibrating the LAPIC timer
> using the PM-timer is going to be more reliable -- exactly how
> and why did the previous calibration scheme fail?
> Maybe I could follow the new logic in apic.c if I saw the "apic=debug"
> output for this box.

calibrating APIC timer ...
... lapic delta = 2426884
... PM timer delta = 833908
APIC calibration PIT not consistent with PM Timer: 232ms instead of 100ms
APIC delta adjusted to PM-Timer: 1041737 (2426884)
..... delta 1041737
..... mult: 44749065
..... calibration result: 166677
..... CPU clock speed is 4659.0624 MHz.
..... host bus clock speed is 166.0677 MHz.

This box is off by factor 2.3 and using the PM-Timer instead of the
PIT/jiffies values gives me a correct result.

Another one:
APIC calibration not consistent with PM Timer: 2020ms instead of 100ms
APIC delta adjusted to PM-Timer: 1254436 (25341111)

Off by factor 20 !!

The original APIC timer calibration did:

	local_irq_disable();
	wait_until_pit_underflows();
	t1 = read_apic_counter();
	for (i = 0; i < HZ/10; i++)
		wait_until_pit_underflows();
	t2 = read_apic_counter();

and calculated the APIC timer frequency from the delta of t1 and t2 vs.
the 100ms time.

This had 2 problems:
1. It gave results, which are off by factor 2-10 on a couple of boxen.
2. Some systems stop there dead as the PIT readout is broken.

I changed it to do:

	local_irq_disable();
	original_pit_handler = pit->handler;
	pit->handler = lapic_calibration_handler;
	loops = 0;
	local_irq_enable();
	wait_until_handler_has_done_HZ/10_loops();

The handler does:

	if (!loops++) {
		t1_apic = read_apic_counter();
		t1_jiffies = jiffies;
		t1_pm = read_pm_timer();
	}

	if (loops == HZ/10) {
		t2_apic = read_apic_counter();
		t2_jiffies = jiffies;
		t2_pm = read_pm_timer();
		done = 1;
	}

If the pmtimer is available, then calculate the APIC timer frequency
from the t1_pm/t2_pm delta, otherwise use jiffies.

When pm_timer is there, we can trust the calculated value, if not we do
a verify run of the periodic apic timer and the pit timer. If this fails
- and it fails often due to the SMM crap - then I use the PIT and IPIs.

In the first version I did a verification run even when pm_timer was
there, but this produced false positives as well, because the lapic
timer interrupt is in the same way delayed as the PIT interrupt. I
removed this to avoid unnecessary switching to IPIs after I verified,
that it always produced false positives when the calibration was done
against the PM-Timer.

	tglx


