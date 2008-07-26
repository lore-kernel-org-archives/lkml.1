Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbYGZPDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbYGZPDw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 11:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbYGZPDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 11:03:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54534 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbYGZPDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 11:03:44 -0400
Date: Sat, 26 Jul 2008 11:03:41 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/2] ftrace: single CPU tracers use CPU clock
In-Reply-To: <20080726132118.GA30903@elte.hu>
Message-ID: <Pine.LNX.4.58.0807261034590.13726@gandalf.stny.rr.com>
References: <20080725220040.911370182@goodmis.org> <20080725220334.781928198@goodmis.org>
 <20080726124058.GD20713@elte.hu> <Pine.LNX.4.58.0807260905500.12953@gandalf.stny.rr.com>
 <20080726132118.GA30903@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 26 Jul 2008, Ingo Molnar wrote:

>
> * Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > > this is not a good idea. We want to fix cpu_clock(), not work around
> > > any deficiencies it might have.
> >
> > cpu_clock currently is "sched_clock" when the
> > CONFIG_HAVE_UNSTABLE_SCHED_CLOCK is not set. Which is done via
> > configuration, and I noticed is set on my boxes with a stable TSC??
>
> define 'stable TSC' ;-)

heh, OK they are insync across CPUS. They also give better times than
running with the cpu_clock.


>
> > Perhaps we need to make cpu_clock change dynamically when an unstable
> > sched_clock is detected.
> >
> > Even in this case, forcing the tracers that are single CPU to use a
> > clock source that modifies itself to try to look stable across CPUs
> > still seems wrong to me.  The goal of looking stable across CPUs will
> > always be at odds with the irqsoff tracer that does not care about
> > other CPUS but cares tremendously about accurate latencies.
>
> other tracers care too - for example to have the right chronology of
> trace events. The scheduler cares too. What kind of worst-case cross-CPU
> effects have you observed?

1:            bash-3498  [01]  5459.824565:      0:140:R   +  7971:120:R
2:          <idle>-0     [00]  5459.824836:      0:140:R ==>  7971:120:R
3:            bash-3498  [01]  5459.824984:   3498:120:S ==>     0:140:R
4:          <idle>-0     [01]  5459.825342:      0:140:R ==>  7971:120:R
5:              ls-7971  [00]  5459.825380:   7971:120:R   +     3:  0:S
6:              ls-7971  [00]  5459.825384:   7971:120:R ==>     3:  0:R
7:     migration/0-3     [00]  5459.825401:      3:  0:S ==>     0:140:R
8:              ls-7971  [01]  5459.825565:   7971:120:R   +   598:115:S

The above was from my tutorial at OLS. I added the annotated numbers at
the beginning of the line. This is the sched_switch tracer.

Line 1, on CPU 1, bash wakes up process ls (pid 7971).
Line 2, on CPU 0, the idle task switches to the ls task.
Line 3, on CPU 1, bash switches back to idle
Line 4, on CPU 1, idle switches to the ls task??
Lines 5-7, on CPU 0, ls wakes up the migration task and the migration task runs
Line 8, on CPU 1 we see ls running and waking up a task with pid 598.

This strange trace is because the clocks between CPU 0 and 1 are off. This
box that ran this trace did have out of sync CPUS, so the numbers are much
closer on this box than if I were to use sched_clock.

The proper trace should have looked like this:

1:            bash-3498  [01]  5459.824565:      0:140:R   +  7971:120:R
2:          <idle>-0     [00]  5459.824836:      0:140:R ==>  7971:120:R
3:            bash-3498  [01]  5459.824984:   3498:120:S ==>     0:140:R
5:              ls-7971  [00]  5459.825380:   7971:120:R   +     3:  0:S
6:              ls-7971  [00]  5459.825384:   7971:120:R ==>     3:  0:R
7:     migration/0-3     [00]  5459.825401:      3:  0:S ==>     0:140:R
4:          <idle>-0     [01]  5459.825342:      0:140:R ==>  7971:120:R
8:              ls-7971  [01]  5459.825565:   7971:120:R   +   598:115:S

I moved 4 between 7 and 8. The trace looks much better.


Another thing about the cpu_clock and the difficulties of using both the
gtod and the tsc. I just found out that the gtod is affected by the NTP
algorithm. Which means that the changes between making the TSC sync with
the gtod, will have extra drifts since the TSC multiplier is now fighting
with the NTP multiplier.

The cpu_clock when having an unstable TSC or out of sync TSCs does very
well with keeping in sync. But it is very difficult to have it perfectly
accurate. The above inaccurate trace was caused by having the TSCs out of
sync by 60 usecs. Which is damn good accuracy. But as we see, can still
show lack of integrity in the order of events.

-- Steve

