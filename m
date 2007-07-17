Return-Path: <linux-kernel-owner+w=401wt.eu-S1760865AbXGQOp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865AbXGQOp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbXGQOpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:45:14 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:40939 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751725AbXGQOpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:45:12 -0400
Date: Tue, 17 Jul 2007 10:45:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux@bohmer.net
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       RT-Users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ltt-dev@shafik.org
Subject: Re: LTTng for 2.6.22.1-rt4 (timestamping)
Message-ID: <20070717144509.GA27528@Krystal>
References: <3efb10970707161246se06ab22i32872cfe6fa4f2f6@mail.gmail.com> <20070716230313.GA8358@Krystal> <3efb10970707170034t3e1dabe5wc70d41f6ab209c7e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <3efb10970707170034t3e1dabe5wc70d41f6ab209c7e@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:17:01 up  8:51,  3 users,  load average: 0.04, 0.19, 0.18
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Remy Bohmer (l.pinguin@gmail.com) wrote:
> Hello Mathieu,
> 
> Thank you very much for this patch.
> It will be very useful.
> 
> But, I have a suggestion for the future.
> >For your ARM needs, you may have to tweak include/asm-arm/ltt.h so it
> >reads a time base register (or the equivalent).
> 
> Every RT-kernel, (and currently also the mainline kernel) has support
> for high-resolution timers.
> If selected, the time-of-day in the kernel will be as accurate as the
> hardware clock can provide. The time is kept in nanoseconds
> resolution. On X86 it will be TSC based, on ARM it can be based om
> some other clock.
> It could be an idea to always use this normal HR timebase instead of
> assuming there is a TSC available. This would make your code more
> architecture independent, and eliminates the need for any time
> conversion routines.
> 
> Just an idea...
> 

I have considered the option, but the two reasons why I don't use the
standard gettimeofday are (I'll reply publicly so that people can have
an idea of the constraints of the tracing field regarding timestamping).
Since LTTng needs to have its tracing site called from potentially
_everywhere_ in the kernel, and that timestamping is the only thing that
reorders the events written in the different subbuffers:

1 - In gettimeofday, there is often a fallback, in the worse case, to a
very low granularity time base which is useless for a tracer (RTC
clock).

2 - A read seqlock surrounds every operation. This is odd for me, since
I want to read this counter from a NMI handler (which can nest ofer a
write seqlock irqsave and deadlock).

3 - I currently don't need to disable interrupts at tracing site, and I
prefer it this way. It lessens the impact of my tracer on the system's
normal behavior.

4 - Even the HPET reads are too slow for _many_ users, although it's the
fallback on a lot of modern Intel and AMD chips with non synchronized
TSCs. These users often prefer to have a very high performance logical
clock than a slow HPET read.

5 - I have not seen raceless 32 to 64 bits timestamp extension wrt NMI
handlers yet. Roughly, people assume they can increment a counter for
their MSB whenever they receive an interrupt from the timer when it
overflows. If a higher priority interrupt arrives during the period
between the overflow and the actual MSB increment, time will appear to
go backward. I have created, in ltt/ltt-heartbeat.c, a "synthetic 64
TSC" which keeps a coherent state of a full 64 bits TSC based on a 32
bits time base input. I just don't care about the overflow/underflow
interrupt: I just let the counter run free, read it periodically to
detect wrap-arounds, and wrap every read of this counter and return the
full 64 bits.

If I could find a way to integrate my asm-*/ltt.h timestamping read
infrastructure into the Linux kernel, that would be awesome. I guess it
could be done by adding some flags to the clocksource mechanism, giving
the ability to specify "high granularity but low accuracy" clock sources
and also to specify that an atomic clocksource must be used (no seqlock).

I see in the 2.6.22.1-rt4 kernel that
include/asm-arm/arch-ep93xx/timex.h defines CLOCK_TICK_RATE and
mach_read_cycles(), which is basically what we need: a microsecond
precision is good. I wonder how much time takes this timer read
(performance impact).

When such timer is available on an architecture, it should really be
made LTTng's default choice.

And BTW, with such a 32 bits timer, you would need to use my "32->64
bits synthetic TSC" (see how asm-mips/ltt.h is implemented).

Regards,

Mathieu

> Thanks!
> 
> Remy

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
