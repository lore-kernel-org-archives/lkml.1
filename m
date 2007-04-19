Return-Path: <linux-kernel-owner+w=401wt.eu-S1767002AbXDSVfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767002AbXDSVfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 17:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422708AbXDSVfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 17:35:24 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:36939 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422667AbXDSVfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 17:35:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JWq3njp43wQf9Kut3QSHFQTjCJX4BpSU+PHnDIr8UkPKixp+WXPKCeXmgxuTYIS/OK1lCTM5OoNsy46Wrj69PcneApMPlYtLNzKaO1iymeFBrV5MBYLUy4E/iZU7IiPEQBJ+kCH1HC/KAEyswlnhcNM7UVSQODXfhrAI3FOhLy0=
Message-ID: <f2b55d220704191435x7a9ffa47s237484b03c6b1a36@mail.gmail.com>
Date: Thu, 19 Apr 2007 14:35:22 -0700
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Gene Heskett" <gene.heskett@gmail.com>
Subject: Re: Renice X for cpu schedulers
Cc: "Con Kolivas" <kernel@kolivas.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Matt Mackall" <mpm@selenic.com>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       "Mike Galbraith" <efault@gmx.de>, "ck list" <ck@vds.kolivas.org>,
       "Bill Huey" <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <200704191416.14374.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070417062621.GL2986@holomorphy.com>
	 <20070419063810.GA22418@elte.hu>
	 <200704192159.35546.kernel@kolivas.org>
	 <200704191416.14374.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/07, Gene Heskett <gene.heskett@gmail.com> wrote:
> Having tried re-nicing X a while back, and having the rest of the system
> suffer in quite obvious ways for even 1 + or - from its default felt pretty
> bad from this users perspective.
>
> It is my considered opinion (yeah I know, I'm just a leaf in the hurricane of
> this list) that if X has to be re-niced from the 1 point advantage its had
> for ages, then something is basicly wrong with the overall scheduling, cpu or
> i/o, or both in combination.  FWIW I'm using cfq for i/o.

I think I just realized why the X server is such a problem.  If it
gets preempted when it's not actually selecting/polling over a set of
fds that includes the input devices, the scheduler doesn't know that
it's a good candidate for scheduling when data arrives on those
devices.  (That's all that any of these dynamic priority heuristics
really seem to do -- weight the scheduler towards switching to
conspicuously I/O bound tasks when they become runnable, without the
forced preemption on lock release that would result from a true
priority inheritance mechanism.)

One way of looking at this is that "fairness-driven" scheduling is a
poor man's priority ceiling protocol for I/O bound workloads, with the
implicit priority of an fd or lock given by how desperately the reader
side needs more data in order to accomplish anything.  "Nice" on a
task is sort of an indirect way of boosting or dropping the base
priority of the fds it commonly waits on.  I recognize this is a
drastic oversimplification, and possibly even a misrepresentation of
the design _intent_; but I think it's fairly accurate in terms of the
design _effect_.

The event-driven, non-threaded design of the X server makes it
particularly vulnerable to "non-interactive behavior" penalties, which
is appropriate to the extent that it's an output device having trouble
keeping up with rendering -- in fact, that's exactly the throttling
mechanism you need in order to exert back-pressure on the X client.
(Trying to exert back-pressure over Linux's local domain sockets seems
to be like pushing on a rope, but that's a different problem.)  That
same event-driven design would prioritize input events just fine --
except the scheduler won't wake the task in order to deliver them,
because as far as it's concerned the X server is getting more than
enough I/O to keep it busy.  It's not only not blocked on the input
device, it isn't even selecting on it at the moment that its timeslice
expires -- so no amount of poor-man's PCP emulation is going to help.

What "more negative nice on the X server than on any CPU-bound
process" seems to do is to put the X server on a hair-trigger,
boosting its dynamic priority in a render-limited scenario (on some
graphics cards!) just enough to cancel the penalty for non-interactive
behavior.  It's forced to share _some_ CPU cycles, but nobody else is
allowed a long enough timeslice to keep the X server off the CPU (and
insensitive to input events) for long.  Not terribly efficient in
terms of context switch / cache eviction overhead, but certainly
friendlier to the PEBCAK (who is clearly putting totally inappropriate
load on a single-threaded CPU by running both a local X server and
non-SCHED_BATCH compute jobs) than a frozen mouse cursor.

So what's the right answer?  Not special-casing the X server, that's
for sure.  If this analysis is correct (and as of now it's pure
speculation), any event-driven application that does compute work
opportunistically in the absence of user interaction is vulnerable to
the same overzealous squelching.  I wouldn't design a new application
that way, of course -- user interaction belongs in a separate thread
on any UNIX-legacy system which assigns priorities to threads of
control instead of to patterns of activity.  But all sorts of Linux
applications have been designed to implicitly elevate artificial
throughput benchmarks over user responsiveness -- that has been the
UNIX way at least since SVR4, and Linux's history of expensive thread
switches prior to NPTL didn't help.

If you want responsiveness when the CPU is oversubscribed -- and I for
one do, which is one reason why I abandoned the Linux desktop once
both Microsoft and Apple figured out how to make hyperthreading work
in their favor -- you should probably think about how to get it
without rewriting half of userspace.  IMHO, dinking around with
"fairness", as if there were any relationship these days between UIDs
or process groups or any other control structure and the work that's
trying to flow through the system, is not going to get you there.

If this were my problem, I might start by attaching urgency to
behavior instead of to thread ID, which demands a scheduler queue
built around a data structure with a cheap decrease-key operation.
I'd figure out how to propagate this urgency not just along lock
chains but also along chains of fds that need flushing (or refilling)
-- even if the reader (or writer) got preempted for unrelated reasons.
 Tie appropriate urgency to audio and input devices, and SCHED_FIFO
can pretty much go away along with nice -10 X.

Then I would use the fact that taking an uncontended futex is
impressively cheap, ask Ulrich for an extra class of thread-private
recursive mutexes streamlined for the never-contended case, and
encourage application developers to use them to bracket any short
section that would prefer not to have its cache footprint evicted out
from under it.  Unless things get pretty nasty, when you're too
impatient to wait for a task to block, you want to preempt it at a
local minimum in its working set; the easy way to do this is to have a
per-CPU "soft preemption" timer that causes a per-CPU kernel thread to
attempt to take the foreground task's thread-private mutex.  The
foreground task will then block on the next entry into a "cache-hot"
section, and you can remember its appetite for CPU cycles by the
urgency on its thread-private futex.

For better or for worse, this is far more work than _I'm_ likely to do
on a volunteer basis, and whether or not this analysis is right, it is
guaranteed to fail with -ENOPATCH.

Oh, by the way -- maybe someone should look at whether a little
backpressure on /tmp/.X11-unix/X0 and friends helps, too.  (Evidently
it works right over pipes, or else hardly anything on Linux would
DWIM.)  That might succeed in papering over the problem, without
requiring actual design effort before wading into the code.  Then
again, I haven't actually looked at the local domain socket code, so
for all I know there's already backpressure there but X.org's
excessive cleverness defeats it.

Cheers,
- Michael
