Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbYIBXKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbYIBXKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 19:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbYIBXKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 19:10:21 -0400
Received: from www.tglx.de ([62.245.132.106]:44657 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbYIBXKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 19:10:20 -0400
Date: Wed, 3 Sep 2008 01:10:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <alpine.LFD.1.10.0809021446360.3160@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809030055490.3243@apollo.tec.linutronix.de>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020835150.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809020759480.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809021918450.3243@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0809021120120.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809022239220.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809021446360.3160@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2008, Linus Torvalds wrote:
> On Tue, 2 Sep 2008, Thomas Gleixner wrote:
> > 
> > On that box, the PIT is probably real hardware or a damned good
> > emulation. When you look at the 10 loop values you see that it does
> > 50% perfectly fine calibration loops. The others are just SMI
> > interruptions caused by random unknown crap in the BIOS.
> 
> Ok, so I actually think I know how to resolve the problem once and for 
> all.
> 
> The solution is actually fairly simple: we use the HPET algorithm. The 
> reason the HPET algorithm is so robust is that
> 
>  - we can actually read the frequency from the HPET itself
> 
>  - we also simply just read the counter values from the HPET, and so it 
>    doesn't really matter how much time has passed between the two reads, 
>    it only matters that _some_ time has passed, and that we pick _one_ 
>    stable read that we can associate with a TSC value.
> 
> But the thing is, the exact same thing is actually true of the old PIT 
> timer too - except we simply don't take advantage of it. The PIT timer has 
> a very well known frequency value (PIT_TICK_RATE: 1193180 Hz), and we can 
> trivially read the counter value too.

Except for the couple of exceptions, where the readout of the old PIT
timer is broken. See arch/x86/kernel/i8253.c:pit_read()

Thought about that already and discarded it as it is basically the
same problem as we have versus _ONE_ AMD K6 family pmtimer
incarnation.

> But the thing is, that for some forgotten reason, that's not actually what 
> we do. Instead of reading the counter value, we wait until it counts down 
> to zero, and read the output value instead. So instead of having a nice 
> and dependable counter that ticks down (16 bits of precision), we actually 
> use a _single_ bit of result, and depend on reading the TSC at the same 
> time.
> 
> That's kind of sad. 

For a reason.

> I'll try to whip up a test-patch to do this in a smarter way.

I'm fine with either solution as long it works on _ALL_ kind of broken
hardware. Believe me or not, but since I work on the whole timer
issue, I have not seen anything really reliable in the x86 world.

That's the really sad part, that the hardware dudes did not learn
anything about the importance of timing and timekeeping within 20
years.

I'm tearing my hair on a regular base when I try to get down to the
root cause of timer related wreckage in several (including todays)
generations of CPU technology in x86 land. Other architectures have
their odds and ends as well, but the vast majority of implementations
is pretty straight forward and usable without restrictions.

x86 is definitely the ultimate winner of the all time "timer ignorance
award".

Thanks,

	tglx
