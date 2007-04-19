Return-Path: <linux-kernel-owner+w=401wt.eu-S2993049AbXDSAh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993049AbXDSAh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 20:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993064AbXDSAh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 20:37:27 -0400
Received: from omta02sl.mx.bigpond.com ([144.140.93.154]:57209 "EHLO
	omta02sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993049AbXDSAh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 20:37:26 -0400
Message-ID: <4626B9BD.8020806@bigpond.net.au>
Date: Thu, 19 Apr 2007 10:37:17 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de> <20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de> <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de> <20070418055525.GS11115@waste.org> <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org> <20070418152355.GU11115@waste.org> <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta02sl.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Thu, 19 Apr 2007 00:37:22 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 18 Apr 2007, Matt Mackall wrote:
>> On Wed, Apr 18, 2007 at 07:48:21AM -0700, Linus Torvalds wrote:
>>> And "fairness by euid" is probably a hell of a lot easier to do than 
>>> trying to figure out the wakeup matrix.
>> For the record, you actually don't need to track a whole NxN matrix
>> (or do the implied O(n**3) matrix inversion!) to get to the same
>> result.
> 
> I'm sure you can do things differently, but the reason I think "fairness 
> by euid" is actually worth looking at is that it's pretty much the 
> *identical* issue that we'll have with "fairness by virtual machine" and a 
> number of other "container" issues.
> 
> The fact is:
> 
>  - "fairness" is *not* about giving everybody the same amount of CPU time 
>    (scaled by some niceness level or not). Anybody who thinks that is 
>    "fair" is just being silly and hasn't thought it through.
> 
>  - "fairness" is multi-level. You want to be fair to threads within a 
>    thread group (where "process" may be one good approximation of what a 
>    "thread group" is, but not necessarily the only one).
> 
>    But you *also* want to be fair in between those "thread groups", and 
>    then you want to be fair across "containers" (where "user" may be one 
>    such container).
> 
> So I claim that anything that cannot be fair by user ID is actually really 
> REALLY unfair. I think it's absolutely humongously STUPID to call 
> something the "Completely Fair Scheduler", and then just be fair on a 
> thread level. That's not fair AT ALL! It's the anti-thesis of being fair!
> 
> So if you have 2 users on a machine running CPU hogs, you should *first* 
> try to be fair among users. If one user then runs 5 programs, and the 
> other one runs just 1, then the *one* program should get 50% of the CPU 
> time (the users fair share), and the five programs should get 10% of CPU 
> time each. And if one of them uses two threads, each thread should get 5%.
> 
> So you should see one thread get 50& CPU (single thread of one user), 4 
> threads get 10% CPU (their fair share of that users time), and 2 threads 
> get 5% CPU (the fair share within that thread group!).
> 
> Any scheduling argument that just considers the above to be "7 threads 
> total" and gives each thread 14% of CPU time "fairly" is *anything* but 
> fair. It's a joke if that kind of scheduler then calls itself CFS!
> 
> And yes, that's largely what the current scheduler will do, but at least 
> the current scheduler doesn't claim to be fair! So the current scheduler 
> is a lot *better* if only in the sense that it doesn't make ridiculous 
> claims that aren't true!
> 
> 			Linus

Sounds a lot like the PLFS (process level fair sharing) scheduler in 
Aurema's ARMTech (for whom I used to work).  The "fair" in the title is 
a bit misleading as it's all about unfair scheduling in order to meet 
specific policies.  But it's based on the principle that if you can 
allocate CPU band width "fairly" (which really means in proportion to 
the entitlement each process is allocated) then you can allocate CPU 
band width "fairly" between higher level entities such as process 
groups, users groups and so on by subdividing the entitlements downwards.

The tricky part of implementing this was the fact that not all entities 
at the various levels have sufficient demand for CPU band width to use 
their entitlements and this in turn means that the entities above them 
will have difficulty using their entitlements even if other of their 
subordinates have sufficient demand (because their entitlements will be 
too small).  The trick is to have a measure of each entity's demand for 
CPU bandwidth and use that to modify the way entitlement is divided 
among subordinates.

As a first guess, an entity's CPU band width usage is an indicator of 
demand but doesn't take into account unmet demand due to tasks waiting 
on a run queue waiting for access to the CPU.  On the other hand, usage 
plus time waiting on the queue isn't a good measure of demand either 
(although it's probably a good upper bound) as it's unlikely that the 
task would have used the same amount of CPU as the waiting time if it 
had gone straight to the CPU.

But my main point is that it is possible to build schedulers that can 
achieve higher level scheduling policies.  Versions of PLFS work on 
Windows from user space by twiddling process priorities.  Part of my 
more recent work at Aurema had been involved in patching Linux's 
scheduler so that nice worked more predictably so that we could release 
a user space version of PLFS for Linux.  The other part was to add hard 
CPU band width caps for processes so that ARMTech could enforce hard CPU 
bandwidth caps on higher level entities (as this can't be done without 
the kernel being able to do it at that level.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
