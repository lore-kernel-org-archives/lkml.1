Return-Path: <linux-kernel-owner+w=401wt.eu-S1757005AbZGMUc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbZGMUc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 16:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756663AbZGMUc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 16:32:57 -0400
Received: from smtpout.cs.fsu.edu ([128.186.122.75]:2574 "EHLO mail.cs.fsu.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756626AbZGMUc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 16:32:56 -0400
X-Greylist: delayed 1187 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jul 2009 16:32:55 EDT
Date: Mon, 13 Jul 2009 16:13:05 -0400
From: Ted Baker <baker@cs.fsu.edu>
To: Noah Watkins <jayhawk@soe.ucsc.edu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Raistlin <raistlin@linux.it>,
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
Message-ID: <20090713201305.GA25386@cs.fsu.edu>
References: <200907102350.47124.henrik@austad.us> <1247336891.9978.32.camel@laptop> <4A594D2D.3080101@ittc.ku.edu> <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir> <1247505941.7500.39.camel@twins> <5B78D181-E446-4266-B9DD-AC0A2629C638@soe.ucsc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B78D181-E446-4266-B9DD-AC0A2629C638@soe.ucsc.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am happy that Peter has included me in this discussion.  I will
have more to say after I have seen a few more messages, absorbed
the context better, and had some time to think things over.  I
guess that, being a newcomer to this discussion, I may re-open
some issues that have already been discussed.  However, I would
like to comment on a few things right off.

I would hope that all of the people working on the kernel could
agree on some basic goals, principles, and policies, which could
be kept stable, and would guide detailed design decisions.

In the real-time domain, I would hope that a goal would be to
support application-level analysis of schedulability, in a
modular, decomposable way.  That is, it should be possible to
write the time-critical portions of any application in a way that
if the system calls the application makes all succeed, the
application gets a guaranteed level of service that enables it to
meet its timing constraints, regardless of whatever else is going
on in the system.  

One part of this is support for a scheduling policy that enables
the application to request some guaranteed minimum level of CPU
bandwidth, and at the same time imposes an upper limit on how much
it can interfere with other tasks.  One way this model has been
abstracted is in terms of a pairs of parameters for each of these
two bounds: a level of service, expressed as a fraction of CPU(s),
and a lag time.  

The lag time is affected by a number of specific factors,
including the maximum time that a thread may be blocked due to
waiting for a lock.  The priority inheritance protocol (PIP) has
been proposed as a way of bounding the duration of such blocking
in the context of very simple task models (such as fixed-priority
preemptive scheduling of periodic tasks), where the blocking is
viewed as "priority inversion".

As several message mentioned, and as I observed in the kernel code
(to my disgust), the Linux PIP implementation is a nightmare:
extremely heavy weight, involving maintenance of a full wait-for
graph, and requiring updates for a range of events, including
priority changes and interruptions of wait operations.

I recognize that this complexity is a product of the desire to
provide an implementation that does the right thing in all cases,
but one needs keep a sense of proportion.  When one ends up having
to solve a more complex mutual exclusion problem (on the wait-for
graph and task priorities) in order to implement a mutual
exclusion primitive, you have a case of abstraction inversion--
something is out of whack.

It is sad enough that we have to implement PTHREAD_PRIO_INHERIT
for POSIX portable applications, but to use this internally within
the OS, or to build more complexity on top of it, seems totally
wrong.

For schedulability analysis, one just needs a way to bound the
duration of priority inversion.  Simple non-preemption (Linux
spinlock_t) is sufficient for that, and it is easy to implement.
You just have to be careful not to voluntarily suspend (give up
the processor) while holding a lock. The SRP (Ada Ceiling_Locking
and POSIX PTHREAD_PRIO_PROTECT) is s slight refinement, also
extremely lightweight to implement with reasonable restrictions
(e.g., no blocking while holding a lock, priority changes deferred
while a lock is held).

The priority inheritance protocol (PIP) has always been a problem
for schedulability analysis, because priority inversion is not
bounded to a single critical section; one must account for the
worst-case chain of blockings -- even before one considers the
distributed overhead (meaning overhead paid by non-users of
the feature) and the implementation complexity.

The only selling point for PIP has been the ability of a thread to
suspend itself while holding a lock, such as to wait for
completion of an I/O operation.  I would argue that this practice
is generally a sign of poor design, and it certainly throws out
the notion of bounding the priority inversion due to blocking on a
lock for schedulability analysis -- since now the lock-holding
time can depend on I/O completion time, timers, etc.

I do have sympathy for what you seem to be calling the "proxy"
implementation model of priority inheritance.  That is, the
scheduler choose a process, than if it was blocked, walk down the
wait-for chain until it found a process that was not blocked.  A
beauty of this approach is that you only need to maintain the one
wait-for link, and you only modify it when a task blocks.  There
is a small overhead on the lock and unlock operations, but no need
to overhead, since one never traverses these links unless blocking
has occurred and one about to schedule a blocked process.  In
particular, one gets around a case that I found very nasty if one
tries to do all the inheritance-caused priority changes
explicitly; that is, when mutex-wait operation times out you have
to recompute all the priorities, and that this involves traversal
of the reverse-wait-for relation, which is many-one.

The first case of its use that I saw published was for the
real-time Unix variant developed for the Harris SMP computers,
which were sold under the name Nighthawk.  I don't recall how they
handled some of the details I've seen mentioned in these recent
messages.  I have not been able to find any on-line publications
for that version of Unix (which I think may be what I see cited a
few places on the web as CX/RT).  I once had a copy of the book
Real-time Unix Systems, which I think might have touched on this
(http://www.flipkart.com/real-time-unix-systems-borko/0792390997-y6w3fq6ipb),
but a student walked away with my copy.  I just sent an e-mail to
Bork Fuhrt, one of the authors, and will let you know if I can get
any information from him.

This model does appear to extend to models of scheduling
appropriate for virtual processors, which enforce both upper and
lower bounds on processor bandwidth (e.g., sporadic server,
constant-bandwidth server), we do want to allow tasks that have
reached their current budget allocation to continue if they are
holding a lock, long enough to release the lock.  However, that
can also be accomplished using non-preemmption, or the SRP.

Regarding the notion of charging proxy execution to the budget of
the client task, I have grave concerns. It is already hard enough
to estimate the amount of budget that a real-time task requires,
without this additional complication.  

Ted Baker
