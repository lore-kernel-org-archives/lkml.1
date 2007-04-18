Return-Path: <linux-kernel-owner+w=401wt.eu-S2993051AbXDRTNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993051AbXDRTNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 15:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993053AbXDRTNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 15:13:55 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:62490 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993051AbXDRTNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 15:13:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TBw1gAkWcAEpMHN/WxrFdM3Sbh9FrzdoZkD2TyVSC+XeQfnUAhD60s1RZqK3EJfK7B8dwZsRITnEz2lCWQH9AhGRQ8CD+18wsWpMUTR5TSzP/sje+HB0oLiT02zIzr9zdu6e9rd17b2SXy6DsNXNo37MTf97lItYb4BK1bCCVCQ=
Message-ID: <f2b55d220704181213h2027a1c0w2282513d51035ecd@mail.gmail.com>
Date: Wed, 18 Apr 2007 12:13:52 -0700
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       "Mike Galbraith" <efault@gmx.de>, "Con Kolivas" <kernel@kolivas.org>,
       "Ingo Molnar" <mingo@elte.hu>, "ck list" <ck@vds.kolivas.org>,
       "Bill Huey" <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070418152355.GU11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070417060955.GO8915@holomorphy.com>
	 <20070417062621.GL2986@holomorphy.com>
	 <20070417070155.GF1057@wotan.suse.de>
	 <20070417213954.GE11166@waste.org>
	 <20070418031511.GA18452@wotan.suse.de>
	 <20070418043831.GR11115@waste.org>
	 <20070418050024.GF18452@wotan.suse.de>
	 <20070418055525.GS11115@waste.org>
	 <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org>
	 <20070418152355.GU11115@waste.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/18/07, Matt Mackall <mpm@selenic.com> wrote:
> For the record, you actually don't need to track a whole NxN matrix
> (or do the implied O(n**3) matrix inversion!) to get to the same
> result. You can converge on the same node weightings (ie dynamic
> priorities) by applying a damped function at each transition point
> (directed wakeup, preemption, fork, exit).
>
> The trouble with any scheme like this is that it needs careful tuning
> of the damping factor to converge rapidly and not oscillate and
> precise numerical attention to the transition functions so that the sum of
> dynamic priorities is conserved.

That would be the control theory approach.  And yes, you have to get
both the theoretical transfer function and the numerics right.  It
sometimes helps to use a control-systems framework like the classic
Takagi-Sugeno-Kang fuzzy logic controller; get the numerics right once
and for all, and treat the heuristics as data, not logic.  (I haven't
worked in this area in almost twenty years, but Google -- yes, I do
use Google+brain for fact-checking; what do you do? -- says that
people are still doing active research on TSK models, and solid
fixed-point reference implementations are readily available.)  That
seems like an attractive strategy here because you could easily embed
the control engine in the kernel and load rule sets dynamically.  Done
right, that could give most of the advantages of pluggable schedulers
(different heuristic strokes for different folks) without diluting the
tester pool for the actual engine code.

(Of course, different scheduling strategies require different input
data, and you might not want the overhead of collecting data that your
chosen heuristics won't use.  But that's not much different from the
netfilter situation, and is obviously a solvable problem, if anyone
cares to put that much work in.  The people who ought to be funding
this kind of work are Sun and IBM, who don't have a chance on the
desktop and are in big trouble in the database tier; their future as
processor vendors depends on being able to service presentation-tier
and business-logic-tier loads efficiently on their massively
multi-core chips.  MIPS should pitch in too, on behalf of licensees
like Cavium who need more predictable behavior on multi-core embedded
Linux.)

Note also that you might not even want to persistently prioritize
particular processes or process groups.  You might want a heuristic
that notices that some task (say, the X server) often responds to
being awakened by doing a little work and then unblocking the task
that awakened it.  When it is pinged from some highly interactive
task, you want it to jump the scheduler queue just long enough to
unblock the interactive task, which may mean letting it flush some
work out of its internal queue.  But otherwise you want to batch
things up until there's too much "scheduler pressure" behind it, then
let it work more or less until it runs out of things to do, because
its working set is so large that repeatedly scheduling it in and out
is hell on caches.

(Priority inheritance is the classic solution to the
blocked-high-priority-task problem _in_isolation_.  It is not without
its pitfalls, especially when the designer of the "server" didn't
expect to lose his timeslice instantly on releasing the lock.  True
priority inheritance is probably not something you want to inflict on
a non-real-time system, but you do need some urgency heuristic.  What
a "fuzzy logic" framework does for you is to let you combine competing
heuristics in a way that remains amenable to analysis using control
theory techniques.)

What does any of this have to do with "fairness"?  Nothing whatsoever!
 There's work that has to be done, and choosing when to do it is
almost entirely a matter of staying out of the way of more urgent work
while minimizing the task's negative impact on the rest of the system.
 Does that mean that the X server is "special", kind of the way that
latency-sensitive A/V applications are "special", and belongs in a
separate scheduler class?  No.  Nowadays, workloads where the kernel
has any idea what tasks belong to what "users" are the exception, not
the norm.  The X server is the canary in the coal mine, and a
scheduler that won't do the right thing for X without hand tweaking
won't do the right thing for other eyeball-driven,
multiple-tiers-on-one-box scenarios either.

If you want fairness among users to the extent that their demands
_compete_, you might as well partition the whole machine, and have a
separate fairness-oriented scheduler (let's call it a "hypervisor")
that lives outside the kernel.  (Talk about two students running gcc
on the same shell server, with more important people also doing things
on the same system, is so 1990's!)  Not that the design of scheduler
heuristics shouldn't include "fairness"-like considerations; but
they're probably only interesting as a fallback for when the scheduler
has no idea what it ought to schedule next.

So why is Ingo's scheduler apparently working well for desktop loads?
I haven't tried it or even looked at its code, but from its marketing
I would guess that it effectively penalizes tasks whose I/O requests
can be serviced from (or directed to) cache long enough to actually
consume a whole timeslice.  This is prima facie evidence that their
_current_behavior_ is non-interactive.  Presumably this penalty
expires quickly when the task again asks for information that is not
readily at hand (or writes data that the system is not willing to
cache) -- which usually implies either actual user interaction or a
change of working set, both of which deserve an "urgency premium".

The mainline scheduler seems to contain various heuristics that
mistake a burst of non-interactive _activity_ for a persistently
non-interactive _task_.  Take them away in the name of "fairness", and
the system adapts more quickly to the change of working set implied by
a change of user focus.  There are probably fewer pathological load
patterns too, since manual knob-turning uninformed by control theory
is a lot less likely to get you into trouble when there are few knobs
and no deliberately inserted long-time-constant feedback paths.  But
you can't say there are _no_ pathological load patterns, or even that
the major economic drivers of the Linux ecosystem don't generate them,
until you do some authentic engineering analysis.

In short (too late!) -- alternate schedulers are fun to experiment
with, and the sort of people who would actually try out patches
floated on LKML may find that they improve their desktop experience,
hosting farm throughput, etc.  But even if the mainline scheduler is a
hack atop a kludge covering a crock, it's more or less what production
applications have expected since the last major architectural shift
(NPTL).  There's just no sense in replacing it until you can either
add real value (say, integral clock scaling for power efficiency, with
a reasonable "spinning reserve" for peaking load) or demonstrate
stability by engineering analysis instead of trial and error.

Cheers,
- Michael
