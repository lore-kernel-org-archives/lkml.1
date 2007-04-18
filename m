Return-Path: <linux-kernel-owner+w=401wt.eu-S965055AbXDRCjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965055AbXDRCjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 22:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965122AbXDRCjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 22:39:16 -0400
Received: from omta05sl.mx.bigpond.com ([144.140.93.195]:57269 "EHLO
	omta05sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965055AbXDRCjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 22:39:15 -0400
Message-ID: <462584CB.8060706@bigpond.net.au>
Date: Wed, 18 Apr 2007 12:39:07 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Michael K. Edwards" <medwards.linux@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <20070413202100.GA9957@elte.hu>	 <200704151327.13589.kernel@kolivas.org>	 <1176619384.6222.70.camel@Homer.simpson.net>	 <46240F98.3020800@bigpond.net.au>	 <1176776941.6222.21.camel@Homer.simpson.net>	 <20070417034050.GD25513@wotan.suse.de>	 <1176782489.13059.15.camel@Homer.simpson.net>	 <20070417041420.GF25513@wotan.suse.de>	 <20070417095140.GB22626@elte.hu> <4624CF3B.6040704@bigpond.net.au> <f2b55d220704171600w2de57cafhc1b2d8d7df67cc6b@mail.gmail.com>
In-Reply-To: <f2b55d220704171600w2de57cafhc1b2d8d7df67cc6b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta07sl.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Wed, 18 Apr 2007 02:39:12 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael K. Edwards wrote:
> On 4/17/07, Peter Williams <pwil3058@bigpond.net.au> wrote:
>> The other way in which the code deviates from the original as that (for
>> a few years now) I no longer calculated CPU bandwidth usage directly.
>> I've found that the overhead is less if I keep a running average of the
>> size of a tasks CPU bursts and the length of its scheduling cycle (i.e.
>> from on CPU one time to on CPU next time) and using the ratio of these
>> values as a measure of bandwidth usage.
>>
>> Anyway it works and gives very predictable allocations of CPU bandwidth
>> based on nice.
> 
> Works, that is, right up until you add nonlinear interactions with CPU
> speed scaling.  From my perspective as an embedded platform
> integrator, clock/voltage scaling is the elephant in the scheduler's
> living room.  Patch in DPM (now OpPoint?) to scale the clock based on
> what task is being scheduled, and suddenly the dynamic priority
> calculations go wild.  Nip this in the bud by putting an RT priority
> on the relevant threads (which you have to do anyway if you need
> remotely audio-grade latency), and the lock affinity heuristics break,
> so you have to hand-tune all the thread priorities.  Blecch.
> 
> Not to mention the likelihood that the task whose clock speed you're
> trying to crank up (say, a WiFi soft MAC) needs to be _lower_ priority
> than the application.  (You want to crank the CPU for this task
> because it runs with the RF hot, which may cost you as much power as
> the rest of the platform.)  You'd better hope you can remove it from
> the dynamic priority heuristics with SCHED_BATCH.  Otherwise
> everything _else_ has to be RT priority (or it'll be starved by the
> soft MAC) and you've basically tossed SCHED_NORMAL in the bin.  Double
> blecch!
> 
> Is it too much to ask for someone with actual engineering training
> (not me, unfortunately) to sit down and build a negative-feedback
> control system that handles soft-real-time _and_ dynamic-priority
> _and_ batch loads, CPU _and_ I/O scheduling, preemption _and_ clock
> scaling?  And actually separates the accounting and control mechanisms
> from the heuristics, so the latter can be tuned (within a well
> documented stable range) to reflect the expected system usage
> patterns?
> 
> It's not like there isn't a vast literature in this area over the past
> decade, including some dealing specifically with clock scaling
> consistent with low-latency applications.  It's a pity that people
> doing academic work in this area rarely wade into LKML, even when
> they're hacking on a Linux fork.  But then, there's not much economic
> incentive for them to do so, and they can usually get their fill of
> citation politics and dominance games without leaving their home
> department.  :-P
> 
> Seriously, though.  If you're really going to put the mainline
> scheduler through this kind of churn, please please pretty please knit
> in per-task clock scaling (possibly even rejigged during the slice;
> see e. g. Yuan and Nahrstedt's GRACE-OS papers) and some sort of
> linger mechanism to keep from taking context switch hits when you're
> confident that an I/O will complete quickly.

I think that this doesn't effect the basic design principles of spa_ebs 
but just means that the statistics that it uses need to be rethought. 
E.g. instead of measuring average CPU usage per burst in terms of wall 
clock time spent on the CPU measure it in terms of CPU capacity (for the 
want of a better word) used per burst.

I don't have suitable hardware for investigating this line of attack 
further, unfortunately, and have no idea what would be the best way to 
calculate this new statistic.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
