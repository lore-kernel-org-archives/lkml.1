Return-Path: <linux-kernel-owner+w=401wt.eu-S933727AbXGRQEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727AbXGRQEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758901AbXGRQEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:04:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52899 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760121AbXGRQEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:04:20 -0400
Date: Wed, 18 Jul 2007 18:02:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James Bruce <bruce@andrew.cmu.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Andrea Arcangeli <andrea@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
Message-ID: <20070718160251.GA29043@elte.hu>
References: <Pine.LNX.4.64.0707161213500.1817@scrub.home> <20070716112037.GA6895@elte.hu> <Pine.LNX.4.64.0707161331570.1817@scrub.home> <alpine.LFD.0.999.0707161045520.20061@woody.linux-foundation.org> <1184754430.20032.130.camel@twins> <Pine.LNX.4.64.0707181442340.1817@scrub.home> <1184763148.20032.135.camel@twins> <Pine.LNX.4.64.0707181506460.1817@scrub.home> <20070718134811.GA9227@elte.hu> <Pine.LNX.4.64.0707181558590.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707181558590.1817@scrub.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roman Zippel <zippel@linux-m68k.org> wrote:

> > _changing_ it is an option within reason, and we've done it a couple 
> > of times already in the past, and even within CFS (as Peter 
> > correctly observed) we've been through a couple of iterations 
> > already. And as i mentioned it before, the outer edge of nice levels 
> > (+19, by far the most commonly used nice level) was inconsistent to 
> > begin with: 3%, 5%, 9% of nice-0, depending on HZ.
> 
> Why do you constantly stress level 19? Yes, that one is special, all 
> other positive levels were already relatively consistent.

i constantly stress it for the reason i mentioned a good number of 
times: because it's by far the most commonly used (and complained about) 
nice level. =B-)

but because you are asking, i'm glad to give you some first-hand 
historic background about Linux nice levels (in case you are interested) 
and the motivations behind their old and new implementations:

nice levels were always so weak under Linux (just read Peter's report) 
that people continuously bugged me about making nice +19 tasks use up 
much less CPU time. Unfortunately that was not that easy to implement 
(otherwise we'd have done it long ago) because nice level support was 
historically coupled to timeslice length, and timeslice units were 
driven by the HZ tick, so the smallest timeslice was 1/HZ.

In the O(1) scheduler (about 4 years ago) i changed negative nice levels 
to be much stronger than they were before in 2.4 (and people were happy 
about that change), and i also intentionally calibrated the linear 
timeslice rule so that nice +19 level would be _exactly_ 1 jiffy. To 
better understand it, the timeslice graph went like this (cheesy ASCII 
art alert!):


                   A
             \     | [timeslice length]
              \    |
               \   |
                \  |
                 \ |
                  \|___100msecs
                   |^ . _
                   |      ^ . _
                   |            ^ . _
 -*----------------------------------*-----> [nice level]
 -20               |                +19
                   |
                   |

so that if someone wants to really renice tasks, +19 would give a much 
bigger hit than the normal linear rule would do. (The solution of 
changing the ABI to extend priorities was discarded early on.)

This approach worked to some degree for some time, but later on with 
HZ=1000 it caused 1 jiffy to be 1 msec, which meant 0.1% CPU usage which 
we felt to be a bit excessive. Excessive _not_ because it's too small of 
a CPU utilization, but because it causes too frequent (once per 
millisec) rescheduling. (and would thus trash the cache, etc. Remember, 
this was 4-5 years ago when hardware was weaker and caches were smaller, 
and people were running number crunching apps at nice +19.)

So for HZ=1000 i changed nice +19 to 5msecs, because that felt like the 
right minimal granularity - and this translates to 5% CPU utilization. 
But the fundamental HZ-sensitive property for nice+19 still remained, 
and i never got a single complaint about nice +19 being too _weak_ in 
terms of CPU utilization, i only got complaints about it (still) being 
way too _strong_.

To sum it up: i always wanted to make nice levels more consistent, but 
within the constraints of HZ and jiffies and their nasty design level 
coupling to timeslices and granularity it was not really viable.

The second (less frequent but still periodically occuring) complaint 
about Linux's nice level support was its assymetry around the origo 
(which you can see demonstrated in the picture above), or more 
accurately: the fact that nice level behavior depended on the _absolute_ 
nice level as well, while the nice API itself is fundamentally 
"relative":

   int nice(int inc);

   asmlinkage long sys_nice(int increment)

(the first one is the glibc API, the second one is the syscall API.) 
Note that the 'inc' is relative to the current nice level. Tools like 
bash's "nice" command mirror this relative API.

With the old scheduler, if you for example started a niced task with +1 
and another task with +2, the CPU split between the two tasks would 
depend on the nice level of the parent shell - if it was at nice -10 the 
CPU split was different than if it was at +5 or +10.

A third complaint against Linux's nice level support was that negative 
nice levels were not 'punchy enough', so lots of people had to resort to 
run audio (and other multimedia) apps under RT priorities such as 
SCHED_FIFO. But this caused other problems: SCHED_FIFO is not starvation 
proof, and a buggy SCHED_FIFO app can also lock up the system for good.

CFS addresses all three types of complaints:

To address the first complaint (of nice levels being not "punchy" 
enough), i decoupled the scheduler from 'time slice' and HZ concepts 
(and made granularity a separate concept from nice levels) and thus CFS 
was able to implement better and more consistent nice +19 support: now 
in CFS nice +19 tasks get a HZ-independent 1.5%, instead of the variable 
3%-5%-9% range they got in the old scheduler.

To address the second complaint (of nice levels not being consistent), i 
made nice(1) have the same CPU utilization effect on tasks, regardless 
of their absolute nice levels. So on CFS, running a nice +10 and a nice 
+11 task has the same CPU utilization "split" between them as running a 
nice -5 and a nice -4 task. (one will get 55% of the CPU, the other 
45%.) That is why I changed nice levels to be "multiplicative" (or 
exponential) - that way it does not matter which nice level you start 
out from, the 'relative result' will always be the same.

The third complaint (of negative nice levels not being "punchy" enough 
and forcing audio apps to run under the more dangerous SCHED_FIFO 
scheduling policy) is addressed by CFS almost automatically: stronger 
negative nice levels are an automatic side-effect of the recalibrated 
dynamic range of nice levels.

Hope this helps,

	Ingo
