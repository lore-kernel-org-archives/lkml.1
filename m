Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbYIAUHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbYIAUHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 16:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbYIAUHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 16:07:45 -0400
Received: from www.tglx.de ([62.245.132.106]:53619 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbYIAUHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 16:07:45 -0400
Date: Mon, 1 Sep 2008 22:07:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008, Linus Torvalds wrote:
> On Mon, 1 Sep 2008, Thomas Gleixner wrote:
> > 
> > Hmm. Haven't seen that before, but if confirms what I guessed from
> > your previous dmesg information. I wonder why you did not observe
> > strange behaviour with older kernel versions.
> 
> x86-32 never used the PM_TIMER for frequency estimation, it only ever used 
> the PIT. See the old "native_calculate_cpu_khz()" in tsc_32.c that you 
> deleted in favor of the (imho inferior) x86-64 version.
> 
> How about:
> 
>  - taking the old 32-bit code, and using it to initially _just_ estimate 
>    the TSC speed. That code was stable and pretty much guaranteed to work 
>    reasonably well on all machines. It retries the timings three times, 
>    and picks the best one.
> 
>  - Then, _after_ you already have a pretty good estimation for TSC, you 
>    can use _that_ to then get the HPET and/or PM_TIMER version (and not 
>    use the PIT at all for those calibrations)
> 
>  - and if the PM_TIMER one is too far off, just throw it away. We know the 
>    PIT is a lot more trustworthy than the PM_TIMER.

Far off in which direction ?

If the PIT interrupts are delayed by SMM code, then I see That's on a
max. three years old 32bit Core Duo things like:

[    0.000000] Detected 8340.258 MHz processor.
[   13.782091] APIC calibration not consistent with PM Timer: 228ms instead of 100ms

This one is way off, while the next one is in a reasonable range

[    0.000000] Detected 3240.001 MHz processor.
[   13.792122] APIC calibration not consistent with PM Timer: 178ms instead of 100ms

while in reality the machine is @2GHZ and current mainline says:

[    0.000000] Detected 2000.065 MHz processor.

The CPU calibration of < 2.6.27 is against PIT and does _NOT_ give me a
pretty good estimation for TSC.

I was pretty happy when Alok beat me to unify the TSC calibration code
as it solved one of my long standing todo items, which also filled my
buglist on a regular base.

I did debugged this thorougly using the tracer from preempt-rt to
check, what the box does during that time, and it definitely vanishes
for >100ms in a row in the black hole of the stupid BIOS.


So either way. Relying on PIT on newer machines is _BAD_, relying on
PM_TIMER on older machine is _BAD_ as well.

There is no given good estimate, when the TSC/PIT calibration is off
by factor 1.5 to 4. The consequence would be that I throw away a
perfect fine pmtimer and run a machine which advertises itself as the
fastest box on the planet. With your method I would disable nohz and I
would be back to 50% battery time.

I'm happy to discard the PIT on the 32bit machines again and then file
a bugreport for a regression between 2.6.27-rc1 and tomorrows git :)

This one is the first complaints, I've seen vs. a non working pmtimer
since quite a time. That's why I obviously forgot about the rate check
issue.

I just looked at drivers/clocksource/acpi_pm.c history and saw, that
John explicitely mentions AMD K6 in commit
562f9c574e0707f9159a729ea41faf53b221cd30

    This patch re-adds the verify_pmtmr_rate functionality from 2.6.17 that
    I dropped 2.6.18.
    
    This resolves problems seen on older K6 ASUS boards where the ACPI PM
    timer runs too fast.

Larry's box has: "an AMD-K6 at stepping 0c and running at 450 MHz."

The oracle of google only gave me hits for AMD-K6 in a quick survey
along with the slow access mode problem for older ICH4 chipsets.

So I think it's a reasonable thing to disable the PMTIMER based
calibration on AMD-K6 and older. I'm not sure about the exact cut line
we choose - it might be wrong as always, but it's definitely better
than adding a lot of magic into the calibration code.

Thanks,

	tglx
