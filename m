Return-Path: <linux-kernel-owner+w=401wt.eu-S934093AbXGKXUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934093AbXGKXUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758038AbXGKXTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:19:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44256 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757986AbXGKXTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:19:54 -0400
Date: Thu, 12 Jul 2007 01:19:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
Message-ID: <20070711231912.GA32263@elte.hu>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu> <alpine.LFD.0.999.0707111438530.20061@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707111438530.20061@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> That was *exactly* the same thing you talked about when I refused to 
> take the original timer changes into 2.6.20. You were talking about 
> how lots of people had worked really hard, and how it was really 
> tested.

yes - i was (way too!) upset about it, and your reasoning for the 
rejection was hard (on us) but fair: you wanted a quiet 2.6.20, and you 
felt fundamentally uneasy about the patches.

> And it damn well was NOT really tested, and 2.6.21 ended up being a 
> horribly painful experience (one of the more painful kernel releases 
> in recent times), and we ended up havign to fix a *lot* of stuff.

yes. We had 12 -hrt/dynticks merge related regressions between 
2.6.21-rc1 and -final, and 4 after final. Here's a quick post-mortem:

12 fixes after -rc1:

    [PATCH] i386: Fix bogus return value in hpet_next_event()
    [PATCH] clockevents: remove bad designed sysfs support for now
    [PATCH] clocksource: Fix thinko in watchdog selection
    [PATCH] dynticks: fix hrtimer rounding error in next_timer_interrupt
    [PATCH] i386: add command line option "local_apic_timer_c2_ok"
    [PATCH] i386: disable local apic timer via command line or dmi quirk
    [PATCH] i386: clockevents fix breakage on Geode/Cyrix PIT     
    [PATCH] i386: trust the PM-Timer calibration of the local APIC timer
    [PATCH] clockevents: Fix suspend/resume to disk hangs
    [PATCH] highres: do not run the TIMER_SOFTIRQ after switching to highres mode
    [PATCH] hrtimer: prevent overrun DoS in hrtimer_forward()
    [PATCH] Save/restore periodic tick information over suspend/resume implementations

4 fixes after -final:

 2.6.21.1: -
 2.6.21.2:
    [PATCH] clocksource: fix resume logic
 2.6.21.3: -
 2.6.21.4: -
 2.6.21.5:
    [PATCH] NOHZ: Rate limit the local softirq pending warning output
    [PATCH] Ignore bogus ACPI info for offline CPUs
    [PATCH] i386: HPET, check if the counter works
 2.6.21.6: -

it's all pretty quiet today on the dynticks regressions front. (there 
are no open regressions in either the upstream i386 code or in the devel 
patches we are aware of. Forced-HPET in -mm, which is not part of this 
queue in question [but which is done for dynticks], has one open 
regression.)

The majority of the above bugs were in the infrastructure code. (the 
worst was the generic resume/suspend one fixed in 2.6.21.2) And sadly, a 
fair number of the infrastructure bugs we introduced during the frentic 
clockevents/dynticks rewrites/redesigns we did between .20 and .21. That 
was a royally stupid mistake for us to do - instead of patiently waiting 
for the bugs to be shaken out we destabilized the infrastructure. (it 
was a "lets make this thing so nice that it's impossible to reject" 
instintic gut reaction.)

In the 'weird arch bugs' category, out of the 6 i386 breakages listed 
above, 'i386 legacy systems' was/is by far the worst offender: 4-5 were 
on such old (not 64-bit-capable) systems. (this is not really a 
surprise) While x86_64 certainly has weird crap hardware too, it 
probably is an order of magnitude fewer than i386 - just due to the 
sheer volume, time and diversity difference. (On the other hand if 
there's crap then it will be debugged/tested slower than on 32-bit, 
which offsets that advantage.)

The most prominent bugs were the ones that were in the infrastructure - 
they affected many machines. (But i'd expect the infrastructure to be 
pretty robust by now.)

The x86_64 hrt/dynticks code makes the x86_64 PIT driver (and hpet too) 
shared between the two architectures - which is perhaps another 
difference to the original i386 clockevents merge.

We also integrated _all_ feedback we got, and we had the capacity and 
capability to fix whatever other feedback comes back - it just never 
came ... until today.

But i fully agree with you that the cleanups should be done separately - 
it's just so hard to actually hack on the old hpet code (and to 
understand it to begin with) without first cleaning it up a bit so that 
it does not cause permanent brain damage ;)

	Ingo
