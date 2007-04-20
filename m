Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbXDTBcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbXDTBcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 21:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbXDTBcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 21:32:17 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:12804 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbXDTBcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 21:32:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uiKIXDQbMbVBTLhe+HQAPZDhX+4wnbkQsJR7qNzeX4l3epnf4LLZAEbJEUOsDSIpM2yJmgcn/0wSZ35Q1GDDdhQtpMJ3CIBhqCHTt/xuENzz/qWnkjrc/8iEPghAzEUHg6VPF1ITjkGTC51Z3didZqoRb4n0I0ctLMs2XJFrh6M=
Message-ID: <f2b55d220704191832x7d364b3bw93690ccaa29e2630@mail.gmail.com>
Date: Thu, 19 Apr 2007 18:32:15 -0700
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Lee Revell" <rlrevell@joe-job.com>
Subject: Re: Renice X for cpu schedulers
Cc: "Peter Williams" <pwil3058@bigpond.net.au>,
       "Con Kolivas" <kernel@kolivas.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Matt Mackall" <mpm@selenic.com>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "Mike Galbraith" <efault@gmx.de>, "ck list" <ck@vds.kolivas.org>,
       "Bill Huey" <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <75b66ecd0704190722l5ba8db7n52734c209504e802@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070417062621.GL2986@holomorphy.com>
	 <20070418221432.e4dbcf4f.akpm@linux-foundation.org>
	 <20070419063810.GA22418@elte.hu>
	 <200704192159.35546.kernel@kolivas.org>
	 <462763A4.8080601@bigpond.net.au> <46276C83.40608@bigpond.net.au>
	 <75b66ecd0704190722l5ba8db7n52734c209504e802@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/07, Lee Revell <rlrevell@joe-job.com> wrote:
> IMHO audio streamers should use SCHED_FIFO thread for time critical
> work.  I think it's insane to expect the scheduler to figure out that
> these processes need low latency when they can just be explicit about
> it.  "Professional" audio software does it already, on Linux as well
> as other OS...

It is certainly true that SCHED_FIFO is currently necessary in the
layers of an audio application lying closest to the hardware, if you
don't want to throw a monstrous hardware ring buffer at the problem.
See the alsa-devel archives for a patch to aplay (sched_setscheduler
plus some cleanups) that converts it from "unsafe at any speed" (on a
non-RT kernel) to a rock-solid 18ms round trip from PCM in to PCM out.
 (The hardware and driver aren't terribly exotic for an SoC, and the
measurement was done with aplay -C | aplay -P -- on a
not-particularly-tuned CONFIG_PREEMPT kernel with a 12ms+ peak
scheduling latency according to cyclictest.  A similar test via
/dev/dsp, done through a slightly modified OSS emulation layer to the
same driver, measures at 40ms and is probably tuned too
conservatively.)

Note that SCHED_FIFO may be less necessary on an -rt kernel, but I
haven't had that option on the embedded hardware I've been working
with lately.  Ingo, please please pretty please pick a -stable branch
one of these days and provide a git repo with -rt integrated against
that branch.  Then I could port our chip support to it -- all of which
will be GPLed after the impending code review -- after which I might
have a prayer of strong-arming our chip vendor into porting their WiFi
driver onto -rt.  It's really a much more interesting scheduler use
case than make -j200 under X, because it's a best-effort
SCHED_BATCH-ish load that wants to be temporally clustered for power
management reasons.

(Believe it or not, a stable -rt branch with a clock-scaling-aware
scheduler is the one thing that might lead to this major WiFi vendor's
GPLing their driver core.  They're starting to see the light on the
biz dev side, and the nature of the devices their chip will go in
makes them somewhat less concerned about the regulatory fig leaf
aspect of a closed-source driver; but they would have to port off of
the third-party real-time executive embedded within the driver, and
mainline's task and timer granularity won't cut it.  I can't even get
more detail about _why_ it won't cut it unless there's some remotely
supportable -rt base they could port to.)

But I think SCHED_FIFO on a chain of tasks is fundamentally not the
right way to handle low audio latency.  The object with a low latency
requirement isn't the task, it's the device.  When it's starting to
get urgent to deliver more data to the device, the task that it's
waiting on should slide up the urgency scale; and if it's waiting on
something else, that something else should slide up the scale; and so
forth.  Similarly, responding to user input is urgent; so when user
input is available (by whatever mechanism), the task that's waiting
for it should slide up the urgency scale, etc.

In practice, you probably don't want to burden desktop Linux with
priority inheritance where you don't have to.  Priority queues with
algorithmically efficient decrease-key operations (Fibonacci heaps and
their ilk) are complicated to implement and have correspondingly high
constant factors.  (However, a sufficiently clever heuristic for
assigning quasi-static task priorities would usually short-circuit the
priority cascade; if you can keep N small in the
tasks-with-unpredictable-priority queue, you can probably use a
simpler flavor with O(log N) decrease-key.  Ask someone who knows more
about data structures than I do.)

More importantly, non-real-time application coders aren't very smart
about grouping data structure accesses on one side or the other of a
system call that is likely to release a lock and let something else
run, flushing application data out of cache.  (Kernel coders aren't
always smart about this either; see LKML threads a few weeks ago about
racy, and cache-stall-prone, f_pos handling in VFS.)  So switching
tasks immediately on lock release is usually the wrong thing to do if
letting the task run a little longer would allow it to reach a point
where it has to block anyway.

Anyway, I already described the urgency-driven strategy to the extent
that I've thought it out, elsewhere in this thread.  I only held this
draft back because I wanted to double-check my latency measurements.

Cheers,
- Michael
