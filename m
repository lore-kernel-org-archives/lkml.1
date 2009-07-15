Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbZGOVqC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbZGOVqC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 17:46:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbZGOVqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 17:46:01 -0400
Received: from smtpout.cs.fsu.edu ([128.186.122.75]:5646 "EHLO mail.cs.fsu.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752749AbZGOVqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 17:46:00 -0400
Date: Wed, 15 Jul 2009 17:45:58 -0400
From: Ted Baker <baker@cs.fsu.edu>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Raistlin <raistlin@linux.it>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
Message-ID: <20090715214558.GC14993@cs.fsu.edu>
References: <200907102350.47124.henrik@austad.us> <1247336891.9978.32.camel@laptop> <4A594D2D.3080101@ittc.ku.edu> <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir> <4A5B61DF.8090101@nortel.com> <1247568455.9086.115.camel@Palantir> <4A5C9ABA.9070909@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5C9ABA.9070909@nortel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 08:48:26AM -0600, Chris Friesen wrote:

> Let's call the highest priority task A, while the task holding the lock
> (that A wants) is called B.  Suppose we're on an dual-cpu system.
> 
> According to your proposal above we would have A busy-waiting while B
> runs with A's priority.  When B gives up the lock it gets downgraded and
> A acquires it and continues to run.
> 
> Alternately, we could have A blocked waiting for the lock, a separate
> task C running, and B runs with A's priority on the other cpu.  When B
> gives up the lock it gets downgraded and A acquires it and continues to run.
> 
> >From an overall system perspective we allowed C to make additional
> forward progress, increasing the throughput.  On the other hand, there
> is a small window where A isn't running and it theoretically should be.
> If we can bound it, would this window really cause so much difficulty
> to the schedulability analysis?

I have two questions:

(1) As Jim Anderson points out in a later comment,
is priority inheritance (of any form) what you really want
on an SMP system?  It does not give a good worst-case blocking
time bound.

(2) If you do want priority inheritance, how do I implement the
mechanics of the mechanics of the unlock operation of B on one
processor causing C to be preempted on the other processor, simply
and promptly?

A general solution needs to account for having multiple tasks in
the role of A for any given B, and possibly chains of such tasks
(and, of course, potential deadlock cycles).
For a relatively simple example,

A1 (on CPU1) -blocked_by-> B (on CPU2)
C (lower priority on CPU1)
A2 (preempts C on CPU1) -blocked_by-> B (CPU2)
A3 (on CPU3) -blocked_by-> B (on CPU2)
B releases the lock that is blocking A1, A2, and A3.

Do I need to wake up A1, A2, and A3?
Maybe I should only wake up A2 and A3?
Can I pick just one to wake up?
Then, how do I implement the wake-ups?

I and a student of mine implemented something like this on a
VME-bus based SMP system around 1990.  We decided to only wake up
the highest (global) priority task. (In the case above, either A2
or A3, depending on priority.)  We did this using compare-and-swap
operatoins, in a way that I recall ended up using (for each lock)
something like one global spin-lock variable, one "contending"
variable per CPU, and one additional local spinlock variable per
CPU to avoid bus contention on the global spin-lock variable.  We
used a VME-bus interrupt for the lock-releasing CPU to invoke the
scheduler of the CPU of the task selected to next receive the
lock.  The interrupt handler could then do the job of waking up
the corresponding contending task on that CPU.

It worked, but such global locks had a lot more overhead than
other locks, mostly due to the inter-processor interrupt.
So, we ended up distinguishing global locks from per-CPU
locks to lower the overhead when we did not need it.

We were using a partitioned scheduling model, or else this
would be a bit more complicated, and I would be talking about the
CPU selected to run the task selected to next receive the lock.

Is there a more efficient way to do this? or are you all
ready to pay this kind of overhead on every lock in your SMP
system?

Ted

