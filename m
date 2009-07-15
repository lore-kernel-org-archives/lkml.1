Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbZGOWMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbZGOWMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 18:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753340AbZGOWMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 18:12:13 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:52544 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbZGOWMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 18:12:12 -0400
Message-ID: <4A5E5430.8000102@nortel.com>
Date: Wed, 15 Jul 2009 16:12:00 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ted Baker <baker@cs.fsu.edu>
CC: Raistlin <raistlin@linux.it>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
References: <200907102350.47124.henrik@austad.us> <1247336891.9978.32.camel@laptop> <4A594D2D.3080101@ittc.ku.edu> <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir> <4A5B61DF.8090101@nortel.com> <1247568455.9086.115.camel@Palantir> <4A5C9ABA.9070909@nortel.com> <20090715214558.GC14993@cs.fsu.edu>
In-Reply-To: <20090715214558.GC14993@cs.fsu.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jul 2009 22:12:03.0200 (UTC) FILETIME=[48250000:01CA0599]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted Baker wrote:

> I have two questions:
> 
> (1) As Jim Anderson points out in a later comment,
> is priority inheritance (of any form) what you really want
> on an SMP system?  It does not give a good worst-case blocking
> time bound.

As Peter mentioned, it's not so much a matter of whether it's desired or
not.  It's required, at least in terms of supporting priority
inheritance for pthread mutexes.  I haven't been involved with the
linux-rt side of things, but I believe Peter implied that they used PI
fairly heavily there to try to minimize priority inversion issues
because it was infeasible to analyze all the various locks.  The kernel
is over 10 million lines of code, so any locking changes pretty much
have to fit into the existing framework with minimal changes.

> (2) If you do want priority inheritance, how do I implement the
> mechanics of the mechanics of the unlock operation of B on one
> processor causing C to be preempted on the other processor, simply
> and promptly?

<snip>

> I and a student of mine implemented something like this on a
> VME-bus based SMP system around 1990.  We decided to only wake up
> the highest (global) priority task. (In the case above, either A2
> or A3, depending on priority.)  We did this using compare-and-swap
> operatoins, in a way that I recall ended up using (for each lock)
> something like one global spin-lock variable, one "contending"
> variable per CPU, and one additional local spinlock variable per
> CPU to avoid bus contention on the global spin-lock variable.  We
> used a VME-bus interrupt for the lock-releasing CPU to invoke the
> scheduler of the CPU of the task selected to next receive the
> lock.  The interrupt handler could then do the job of waking up
> the corresponding contending task on that CPU.
> 
> It worked, but such global locks had a lot more overhead than
> other locks, mostly due to the inter-processor interrupt.
> So, we ended up distinguishing global locks from per-CPU
> locks to lower the overhead when we did not need it.
> 
> We were using a partitioned scheduling model, or else this
> would be a bit more complicated, and I would be talking about the
> CPU selected to run the task selected to next receive the lock.
> 
> Is there a more efficient way to do this? or are you all
> ready to pay this kind of overhead on every lock in your SMP
> system?

Peter would have a better idea of the low-level implementation than I,
but I suspect that the general idea would be similar, unless we were to
consider migrating the task chosen to run to the current cpu.  That
would save the IPI, at a cost of task migration.  (Which of course
wouldn't be possible in the case of cpu affinity.)

As to the additional cost, POSIX distinguishes between PI mutexes and
regular mutexes.  Any additional penalty due to PI should be limited to
the mutexes which actually have PI enabled.  If an application can limit
itself to "safe" syscalls and has enough knowledge of its own locking,
then it could presumably use regular mutexes and avoid the overhead of PI.

I'm not sure the same could apply to the kernel in general...Peter would
have to address that as I'm not familiar with the linux-rt changes.

Chris

