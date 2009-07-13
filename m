Return-Path: <linux-kernel-owner+w=401wt.eu-S932104AbZGMVp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbZGMVp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757194AbZGMVp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:45:26 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:61247 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596AbZGMVpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:45:25 -0400
Message-ID: <4A5BAAE7.5020906@nortel.com>
Date: Mon, 13 Jul 2009 15:45:11 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ted Baker <baker@cs.fsu.edu>
CC: Noah Watkins <jayhawk@soe.ucsc.edu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Raistlin <raistlin@linux.it>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
References: <200907102350.47124.henrik@austad.us> <1247336891.9978.32.camel@laptop> <4A594D2D.3080101@ittc.ku.edu> <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir> <1247505941.7500.39.camel@twins> <5B78D181-E446-4266-B9DD-AC0A2629C638@soe.ucsc.edu> <20090713201305.GA25386@cs.fsu.edu>
In-Reply-To: <20090713201305.GA25386@cs.fsu.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jul 2009 21:45:14.0167 (UTC) FILETIME=[34428C70:01CA0403]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted Baker wrote:

> I recognize that this complexity is a product of the desire to
> provide an implementation that does the right thing in all cases,
> but one needs keep a sense of proportion.  When one ends up having
> to solve a more complex mutual exclusion problem (on the wait-for
> graph and task priorities) in order to implement a mutual
> exclusion primitive, you have a case of abstraction inversion--
> something is out of whack.

Given that the semantics of POSIX PI locking assumes certain scheduler
behaviours, is it actually abstraction inversion to have that same
dependency expressed in the kernel code that implements it?

> For schedulability analysis, one just needs a way to bound the
> duration of priority inversion.  Simple non-preemption (Linux
> spinlock_t) is sufficient for that, and it is easy to implement.
> You just have to be careful not to voluntarily suspend (give up
> the processor) while holding a lock.

The whole point of mutexes (and semaphores) within the linux kernel is
that it is possible to block while holding them.  I suspect you're going
to find it fairly difficult to convince people to spinlocks just to make
it possible to provide latency guarantees.

> The only selling point for PIP has been the ability of a thread to
> suspend itself while holding a lock, such as to wait for
> completion of an I/O operation.

You're comparing a full-featured PI implementation with a stripped-down
PP (priority protection, aka priority ceiling) approach.  In an
apples-to-apples comparison, the selling point for PI vs PP is that
under PIP the priority of the lock holder is automatically boosted only
if necessary, and only as high as necessary.  On the other hand, PP
requires code analysis to properly set the ceilings for each individual
mutex.

> I would argue that this practice
> is generally a sign of poor design, and it certainly throws out
> the notion of bounding the priority inversion due to blocking on a
> lock for schedulability analysis -- since now the lock-holding
> time can depend on I/O completion time, timers, etc.

Certainly if you block waiting for I/O while holding a lock then it
impacts the ability to provide latency guarantees for others waiting for
that lock.  But this has nothing to do with PI vs PP or spinlocks, and
everything to do with how the lock is actually used.

> Regarding the notion of charging proxy execution to the budget of
> the client task, I have grave concerns. It is already hard enough
> to estimate the amount of budget that a real-time task requires,
> without this additional complication.  

Agreed.

Chris

