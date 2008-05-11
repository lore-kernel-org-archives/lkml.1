Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbYEKVyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbYEKVyV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbYEKVyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:54:08 -0400
Received: from service2.sh.cvut.cz ([147.32.127.218]:35146 "EHLO
	service2.sh.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbYEKVyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:54:06 -0400
Message-ID: <48276B51.100@seznam.cz>
Date: Sun, 11 May 2008 23:55:29 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 08/56] microblaze_v2: Interrupt handling, timer support,
 supported function
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu> <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu> <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu> <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu> <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu> <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu> <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu> <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu> <alpine.LFD.1.10.0805070813160.3318@apollo.tec.linutronix.de> <4826FAC8.4010604@seznam.cz> <alpine.LFD.1.10.0805111630001.3197@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805111630001.3197@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

> Michal,
> 
> On Sun, 11 May 2008, Michal Simek wrote:
>>> Please split this modification code out into a separate function. The
>>> same code is used below.
>> Add Macro.
> 
> Please use a (inline) function whenever possible. Macros are harder to
> read and not type safe.

I'll try it.

>>> Can you please move a new architecture to clockevents / clocksource
>>> right from the beginning ? No need to invent another incompatible set
>>> of time(r) related functions.
>> I move whole code to GENERIC_TIME. Did you meant any others changes?
> 
> GENERIC_TIME and GENERIC_CLOCKEVENTS. You get high resolution timers
> and dynamic ticks for free when your timer hardware allows it.

About CLOCKEVENTS. I looked at arm/mach-versatile/

and I found I need implement:
loading current timer value - clocksource.read

clock_event_device.set_mode - set one from fourth modes
clock_event_device.set_next_event - the same mode with new init timer value
(this is little bit mess for me because arm do this that only change actual
counting value - I hope I do that too).

Supported modes are:
CLOCK_EVT_MODE_PERIODIC - reload and timer interrupt
CLOCK_EVT_MODE_ONESHOT - one interrupt at zero value and end - no others interrupts.
CLOCK_EVT_MODE_UNUSED: What is it?
CLOCK_EVT_MODE_SHUTDOWN: What is it?
CLOCK_EVT_MODE_RESUME: What is it?


I hope I can use only one timer(adding extra timers is not problem).
We have one timer with two timebase (that's one option in IP core).

And there is necessary to fill some value in timer initializing
timer0_clockevent.mult - nanosecond to cycles multiplier ?
timer0_clockevent.shift - nanoseconds to cycles divisor (power of two)?
timer0_clockevent.irq - irq from our intc.
timer0_clockevent.min_delta_ns - minimal timer resolution (I think this value
have to be sensible for system)
timer0_clockevent.max_delta_ns - maximal timer resolution
timer0_clockevent.cpumask = 0 for 1 cpu

I hope others is set by general code.

and change handler function to calling evt->enent_handler;

I found that archs use sys for showing values.

I hope I can see that this systems works via /proc/interrupts and from sysfs.

Am I right?

Thanks,
Michal

