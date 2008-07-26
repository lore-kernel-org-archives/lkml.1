Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbYGZSXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbYGZSXa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 14:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYGZSXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 14:23:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34990 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbYGZSXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 14:23:22 -0400
Date: Sat, 26 Jul 2008 14:23:20 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/2] ftrace: single CPU tracers use CPU clock
In-Reply-To: <20080726152650.GA7823@elte.hu>
Message-ID: <Pine.LNX.4.58.0807261408120.15241@gandalf.stny.rr.com>
References: <20080725220040.911370182@goodmis.org> <20080725220334.781928198@goodmis.org>
 <20080726124058.GD20713@elte.hu> <Pine.LNX.4.58.0807260905500.12953@gandalf.stny.rr.com>
 <20080726132118.GA30903@elte.hu> <Pine.LNX.4.58.0807261034590.13726@gandalf.stny.rr.com>
 <20080726152650.GA7823@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 26 Jul 2008, Ingo Molnar wrote:
>
> so it's off by 60 usecs. That matters to the chronology of SMP events,
> and to the irqsoff and preemptoff tracers - if we update the clock
> incorrectly - i.e. if we modify the clock across CPUs so that a running
> CPU can see an 'involuntary' jump in local time.

Usually the jump is caused by the clock getting too far away from the
gtod clock. The way the current code works is to look at the gtod at every
tick and also record the TSC and jiffies.  When we read the cpu_clock, it
reads the TSC, calculates the delta from the last read (may be from the
tick if it is the first read since tick), and adds the delta to the clock.
To handle strange behaviours with TSC, if the TSC is too big we do not add
the full delta but instead put the clock to the max allowable, or if we are
already greater than or equal to the max, just add one nanosecond.

This causes some strange behaviour with the traces.


>
> that should be fixed then - and all tracers (and the scheduler) will
> improve - instead of having this special-case.

I added a multiplier to the tsc delta to try to keep it close to the gtod
clock. But there's still issues. No multiplier is perfect and we still
have drifts. The gtod itself is affected by the NTP and changes as well.


Two TSCs with different freqs on the same box will have an inaccuracy.
This is a very difficult problem to solve, and I'm not sure we can do much
better than the 60 microseconds that we currently have.

Even with insync TSCs, we see that the comparison to the GTOD causes
jumps, due to drifts between the two clocks.

I still like to have the special cases for the per CPU tracers. We can get
rid of it when (if) we fix the issues for the other tracers. Not adding
the special case for those tracers wont make us work faster on this
problem. But it will keep people from using those tracers because the
results will be meaningless.


-- Steve

