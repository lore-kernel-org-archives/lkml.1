Return-Path: <linux-kernel-owner+w=401wt.eu-S1755065AbYIAXUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065AbYIAXUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 19:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbYIAXRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 19:17:12 -0400
Received: from www.tglx.de ([62.245.132.106]:58076 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451AbYIAXRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 19:17:10 -0400
Date: Tue, 2 Sep 2008 01:16:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008, Linus Torvalds wrote:
> 
> 
> On Mon, 1 Sep 2008, Thomas Gleixner wrote:
> > 
> > If the PIT interrupts are delayed by SMM code
> 
> Btw, this sentence of yours just doesn't seem to make much sense.
> 
> The thing is, the calibration code doesn't even use interrupts. It just 
> reads the PIT timer value. 

Sorry. I was wrong on the interrupts part. Too tired :(
 
> Now, look at what the 32-bit code _used_ to do. The good code. The code 
> that was _deleted_.

The _good_ code which results in a 8GhZ TSC calibration on that very
_32_ bit box I have here. The CPU is 32bit only, so it never even
touched a 64 bit kernel remotely.

> Really. I don't think you really even looked. It did:
> 
>         /* run 3 times to ensure the cache is warm and to get an accurate reading */
>         for (i = 0; i < 3; i++) {
>                 mach_prepare_counter();
>                 rdtscll(start);
>                 mach_countup(&count);
>                 rdtscll(end);
> 
> 		.. ignore bad values ..
> 
>                 /*
>                  * We want the minimum time of all runs in case one of them
>                  * is inaccurate due to SMI or other delay
>                  */
>                 delta64 = min(delta64, (end - start));
> 	}

I know that code.
 
> and if you actually look at those counter things, you'll see:
> 
> 	#define CALIBRATE_TIME_MSEC 30 /* 30 msecs */
> 	#define CALIBRATE_LATCH \
> 	        ((CLOCK_TICK_RATE * CALIBRATE_TIME_MSEC + 1000/2)/1000)
> 	
> 	static inline void mach_prepare_counter(void)
> 	{
> 	       /* Set the Gate high, disable speaker */
> 	        outb((inb(0x61) & ~0x02) | 0x01, 0x61);
> 
>         	/*
> 	         * Now let's take care of CTC channel 2
> 	         *
> 	         * Set the Gate high, program CTC channel 2 for mode 0,
> 	         * (interrupt on terminal count mode), binary count,
> 	         * load 5 * LATCH count, (LSB and MSB) to begin countdown.
> 	         *
> 	         * Some devices need a delay here.
> 	         */
> 	        outb(0xb0, 0x43);                       /* binary, mode 0, LSB/MSB, Ch 2 */
> 	        outb_p(CALIBRATE_LATCH & 0xff, 0x42);   /* LSB of count */
> 	        outb_p(CALIBRATE_LATCH >> 8, 0x42);       /* MSB of count */
> 	}
> 
> ie look how it actually tries to round to the nearest latch value, an how 
> it actually comments on what it is doing.
> 
> Now, which piece of code is better?
> 
> Honestly?

None. 

      start_pit_documented_magic()
      read_tsc()
      wait_until_pit_has_wrapped_documented_magic()
      read_tsc()

is error prone versus SMI/SMM code simply due to the fact, that at any
given point between those functions the SMM/SMI can happen. Doing it
three times in a row and select the lowest one does not change much. I
tried it 10 times in a row with varying bogus results.

So at every boot I get significant different calibration values. See
below.
 
> Have you tried the better version (for example, boot a 32-bit kernel 
> _before_ the unification on that machine to try).

The following is from a 32bit boot on that very 32bit Intel Core Duo
Laptop running 2.6.26:

[    0.000000] Detected 8340.258 MHz processor.

next boot

[    0.000000] Detected 3240.001 MHz processor.

next boot

[    0.000000] Detected 2211.134 MHz processor.

I can print you the value for 100 loops if you want, but I bet that
the correctness rate will be pretty small.

Current mainline calibrated against pmtimer gives me:

[    0.000000] Detected 2000.065 MHz processor.

next boot

[    0.000000] Detected 2000.129 MHz processor.

next boot

[    0.000000] Detected 1999.988 MHz processor.

which is about accurate:

[   13.408342] CPU0: Intel Genuine Intel(R) CPU           T2500  @ 2.00GHz stepping 08

We had the same problem versus the local APIC timer calibration, which
had basically the same algorithm as the TSC one and we changed it to
look at the PMTimer as well in the days where we debugged the initial
wreckage caused by the nohz/highres changes. I can dig up the archives
of LAPIC timers with 200Mhz clock frequency, which results in a 10GHz
bus frequency, if you want.

How do you prevent the SMM brain damage, when it hits 3 times in a row ? 

You can not prevent it for a very simple reason: The PIT is not
necessary a PIT. It can be a fake SMM code replacement. We actually
have no idea anymore what's hardware and what's just emulated crapola
under the control of BIOS maniacs.

But we know pretty much, that the old K6 has a reliable PIT, a maybe
broken pmtimer and is pretty much unaffected from todays SMM code
disasters.

So excluding the documented breakage of K6 from using pmtimer and
keeping the pmtimer as a reference for todays SMM code wreckaged
systems is not a too bad idea. That way we can actually serve both
worlds.

Thanks,

	tglx
