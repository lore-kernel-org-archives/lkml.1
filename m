Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbXHBQJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbXHBQJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 12:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755989AbXHBQJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 12:09:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49339 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755902AbXHBQJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 12:09:22 -0400
Date: Thu, 2 Aug 2007 18:09:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, Andi Kleen <andi@firstfloor.org>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070802160906.GA20377@elte.hu>
References: <20070711214649.GK14435@v2.random> <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org> <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net> <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net> <Pine.LNX.4.64.0708010439050.1817@scrub.home> <p73wswfo0hf.fsf@bingen.suse.de> <Pine.LNX.4.64.0708011525560.1817@scrub.home> <alpine.LFD.0.999.0708011903300.3582@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708011903300.3582@woody.linux-foundation.org>
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

> It would be better, I suspect, to make the scheduler clock totally 
> distinct from the other clock sources (many architectures have per-cpu 
> cycle counters), and *not* try to even necessarily force it to be a 
> "time-based" one.

yeah. Note that i largely detached sched_clock() from the GTOD 
clocksources already in CFS, so part of this is already implemented and 
the intention is clear. For example, when the following happens:

   Marking TSC unstable due to: possible TSC halt in C2.
   Clocksource tsc unstable (delta = -71630388 ns)

sched_clock() does _not_ stop using the TSC. It is very careful with the 
TSC value, it checks against wraps, jumping, etc. (the whole rq_clock() 
wrapper around sched_clock()), but still tries to use the highest 
resolution time source possible, even if that time source is not good 
enough for GTOD's purposes anymore. So the scheduler clock is already 
largely detached from other clocksources in the system.

> It would still be true that something that is purely based on timer 
> ticks will always be liable to have rounding errors that will 
> inevitably mean that you don't get good fairness - tuning threads to 
> run less than a timer tick at a time would effectively "hide" them 
> from the scheduler accounting. However, in the end, I think that's 
> pretty much unavoidable.

Note that there is a relatively easy way of reducing the effects of such 
intentional coupling: turn on CONFIG_HIGH_RES_TIMERS. That decouples the 
scheduler tick from the jiffy tick and works against such 'exploits' - 
_even_ if the scheduler clock is otherwise low resolution. Also enable 
CONFIG_NO_HZ and the whole thing (of when the scheduler tick kicks in) 
becomes very hard to predict.

[ So while in a low-res clock situation scheduling will always be less 
  precise, with hres-timers and dynticks we have a natural 'random 
  sampler' mechanism so that no task can couple to the scheduler tick - 
  accidentally or even intentionally.

  The only 'unavoidable coupling' scenario is when the hardware has only 
  a single, low-resolution time sampling method. (that is pretty rare 
  though, even in the ultra-embedded space. If a box has two independent 
  hw clocks, even if they are low resolution, the timer tick can be
  decoupled from the scheduler tick.) ]

> I have to say, it would be interesting to try to use 32-bit 
> arithmetic.

yeah. We tried to do as much of that as possible, please read on below 
for (many) more details. There's no short summary i'm afraid :-/

Most importantly, CFS _already_ includes a number of measures that act 
against too frequent math. So even though you can see 64-bit math code 
in it, it's only rarely called if your clock has a low resolution - and 
that happens all automatically! (see below the details of this buffered 
delta math)

I have not seen Roman notice and mention any of these important details 
(perhaps because he was concentrating on finding faults in CFS - which a 
reviewer should do), but those measures are still very important for a 
complete, balanced picture, especially if one focuses on overhead on 
small boxes where the clock is low-resolution.

As Peter has said it in his detailed review of Roman's suggested 
algorithm, our main focus is on keeping total complexity down - and we 
are (of course) fundamentally open to changing the math behind CFS, we 
ourselves tweaked it numerous times, it's not cast into stone in any 
way, shape or form.

> I also think it's likely a mistake to do a nanosecond resolution. 
> That's part of what forces us to 64 bits, and it's just not even an 
> *interesting* resolution.

yes, very much not interesting, and we did not pick nanoseconds because 
we find anything "interesting" in that timescale. Firstly, before i go 
into the thinking behind nanoseconds, microseconds indeed have 
advantages too, so the choice was not easy, see the arguments in favor 
of microseconds below at: [*].

There are two fundamental reasons for nanoseconds:

 1) they _automatically_ act as a 'carry-over' for fractional math and
    thus reduce rounding errors. As Roman has noticed we dont care much
    about math rounding errors in the algorithm: _exactly_ because we
    *dont have to* care about rounding errors: we've got extra 10
    "uninteresting" bits in the time variables to offset the effects of 
    rounding errors and to carry over fractionals.

    ( Sidenote: in fact we had some simple extra anti-rounding-error 
      code in CFS and removed it because it made no measurable 
      difference. So even in the current structure there's additional 
      design reserves that we could tap before having to go to another 
      math model. All we need is a testcase that demonstrates rounding 
      errors. Roman's testcase was _not_ a demonstration of math 
      rounding errors, it was about clock granularity! )

 2) i tried microseconds resolution once (it's easy) but on fast hw it 
    already showed visible accounting/rounding artifacts in 
    high-frequency scheduling workloads, which, if hw gets just a little 
    bit faster, will become pain.

    ( Sidenote: if a workload is rescheduling once every few 
      microseconds, then it very much matters to the balance of things 
      whether there's a fundamental +- 1 microsecond skew on who gets 
      accounted what. In fact the placement of sched_clock() call within 
      schedule() is already visible in practice in some testcases, 
      whether the runqueue-spinlock acquire spinning time is accounted 
      to the 'previous' or the 'next' task - despite that time being 
      sub-microsecond on average. Going to microseconds makes this too 
      coarse. )

I.e. microseconds are on the limit today on fast hardware, and 
nanoseconds give us an automatic buffer against rounding errors.

On _slow_ hardware, with a low-resolution clock, i very much agree that 
we should not do too frequent math, and there are already four 
independent measures that we did in CFS to keep the math overhead down:

Firstly, CFS fundamentally "buffers the math" via deltas, _everywhere_ 
in the fastpath:

        if (unlikely(curr->delta_exec > sysctl_sched_stat_granularity)) {
                __update_curr(cfs_rq, curr, now);
                curr->delta_exec = 0;
        }

I.e. we only call the math routines if there was any delta. The beauty 
is that this "math buffering" works _automatically_ if there is a 
low-resolution sched_clock() present, because with a low-resolution 
clock a delta is only observed if a tick happens. I.e. in a 
high-frequency scheduling workload (the only place where scheduler 
overhead would be noticeable) all the CFS math is in a rare _slowpath_, 
that gets triggered only every 10 msecs or so! (if HZ=1000)

I.e. we didnt have to go down the (very painful) path of ktime_t 
split-model math and we didnt have to introduce a variable precision 
model for "scheduler time" either, because the delta math itself 
automatically buffers on slow boxes.

Secondly, note that all the key fastpath variables are already 32-bit 
(on 32-bit platforms):

        long                    wait_runtime;
        unsigned long           delta_fair_run;
        unsigned long           delta_fair_sleep;
        unsigned long           delta_exec;

The _timestamps_ are still 64-bit, but most of the actual math goes on 
in 32-bit delta variables. That's one of the advantages of doing deltas 
instead of absolute values.

Thirdly, if even this amount of buffering is not enough for an 
architecture, CFS also includes the sched_stat_granularity_ns tunable 
that allows the further reduction of the sampling frequency (and the 
frequency of us having to do the math) - so if the math overhead is a 
problem an architecture can set it.

Fourthly, in CFS there is a _single_ 64-bit division, and even for that 
division, the actual values passed to it are typically in a 32-bit 
range. Hence we've introduced the following optimization:

  static u64 div64_likely32(u64 divident, unsigned long divisor)
  {
  #if BITS_PER_LONG == 32
          if (likely(divident <= 0xffffffffULL))
                  return (u32)divident / divisor;
          do_div(divident, divisor);

          return divident;
  #else
          return divident / divisor;
  #endif
  }

Which, if the divident is in 32-bit range, does a 32-bit division.

About math related rounding errors mentioned by Roman (not to be 
confused with clock granularity rounding), in our analysis and in our 
experience rounding errors of the math were never an issue in CFS, due 
to the extra buffering that nanosecs gives - i tweaked it a bit around 
CFSv10 but it was unprovable to have any effect. That's one of the 
advantages of working with nanoseconds: the fundamental time unit 
includes about 10 "low bits" that can carry over much of the error and 
reduce rounding artifacts. And even that math rounding errors we believe 
centers around 0.

In Roman's variant of CFS's algorithm the variables are 32-bit, but the 
error is rolled forward in separate fract_* (fractional) 32-bit 
variables, so we still have 32+32==64 bit of stuff to handle. So we 
think that in the end such a 32+32 scheme would be more complex (and 
anyone who took a look at fs2.c would i think agree - it took Peter a 
day to decypher the math!) - but we'll be happy to be surprised with 
patches of course :-)

	Ingo

[*] the main advantage of microseconds would be that we could use "u32"
    throughout to carry around the "now" variable (timestamp). That 
    property of microseconds _is_ tempting and would reduce the 
    task_struct footprint as well. But if we did that it would have
    ripple effects: we'd have to resort to (pretty complex and 
    non-obvious) math to act against rounding errors. We'd either have 
    to carry the rounding error with us in separate 32-bit variables (in 
    essence creating 32+32 bit 64-bit variable), or we'd have to shift 
    up the microseconds by say ... 10 binary positions ... in essence 
    bringing us back into the same nanoseconds range. And then the 
    wraparound problem of microseconds - 72 hours is not _that_ 
    unrealistic to trigger intentionally, so we have to do _something_
    about it to inhibit infinite starvation. We experimented
    around with all this and the overwhelming conclusion (so far) was 
    that trying to reduce timestamps back to 32 bits is just not worth 
    it. _Deltas_ should, can and _are_ 32-bit values already, even in 
    the nanosecond model. So all the buffering and delta logic gives us
    most of the 32-bit advantages already, without the disadvantages of
    microseconds.
