Return-Path: <linux-kernel-owner+w=401wt.eu-S1752083AbYIAWRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbYIAWRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 18:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbYIAWRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 18:17:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017AbYIAWRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 18:17:06 -0400
Date: Mon, 1 Sep 2008 15:16:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Sep 2008, Thomas Gleixner wrote:
> 
> If the PIT interrupts are delayed by SMM code

Btw, this sentence of yours just doesn't seem to make much sense.

The thing is, the calibration code doesn't even use interrupts. It just 
reads the PIT timer value. 

And the thing is, the 64-bit code really does things that the 32-bit code 
does _not_ do. 

Just as an example, the old 32-bit code (the thing that was deleted) tried 
to actually round things correctly, while the 64-bit code does not. Look 
at what the 64-bit code does:

        outb((inb(0x61) & ~0x02) | 0x01, 0x61);

        outb(0xb0, 0x43);
        outb((CLOCK_TICK_RATE / (1000 / 50)) & 0xff, 0x42);
        outb((CLOCK_TICK_RATE / (1000 / 50)) >> 8, 0x42);
        tr1 = get_cycles();  
        while ((inb(0x61) & 0x20) == 0);
        tr2 = get_cycles();

and notice three things:

 - no comments (can you actually see what it does?)

 - no rounding of the inevitable errors of trying to wait 1/50th of a 
   second

 - not a single try to even account for the fact that there might be 
   things going on that perturb the value.

Now, look at what the 32-bit code _used_ to do. The good code. The code 
that was _deleted_.

Really. I don't think you really even looked. It did:

        /* run 3 times to ensure the cache is warm and to get an accurate reading */
        for (i = 0; i < 3; i++) {
                mach_prepare_counter();
                rdtscll(start);
                mach_countup(&count);
                rdtscll(end);

		.. ignore bad values ..

                /*
                 * We want the minimum time of all runs in case one of them
                 * is inaccurate due to SMI or other delay
                 */
                delta64 = min(delta64, (end - start));
	}

and if you actually look at those counter things, you'll see:

	#define CALIBRATE_TIME_MSEC 30 /* 30 msecs */
	#define CALIBRATE_LATCH \
	        ((CLOCK_TICK_RATE * CALIBRATE_TIME_MSEC + 1000/2)/1000)
	
	static inline void mach_prepare_counter(void)
	{
	       /* Set the Gate high, disable speaker */
	        outb((inb(0x61) & ~0x02) | 0x01, 0x61);

        	/*
	         * Now let's take care of CTC channel 2
	         *
	         * Set the Gate high, program CTC channel 2 for mode 0,
	         * (interrupt on terminal count mode), binary count,
	         * load 5 * LATCH count, (LSB and MSB) to begin countdown.
	         *
	         * Some devices need a delay here.
	         */
	        outb(0xb0, 0x43);                       /* binary, mode 0, LSB/MSB, Ch 2 */
	        outb_p(CALIBRATE_LATCH & 0xff, 0x42);   /* LSB of count */
	        outb_p(CALIBRATE_LATCH >> 8, 0x42);       /* MSB of count */
	}

ie look how it actually tries to round to the nearest latch value, an how 
it actually comments on what it is doing.

Now, which piece of code is better?

Honestly?

Have you tried the better version (for example, boot a 32-bit kernel 
_before_ the unification on that machine to try).

				Linus
