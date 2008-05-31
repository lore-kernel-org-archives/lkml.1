Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbYEaB2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbYEaB2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 21:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbYEaB1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 21:27:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbYEaB13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 21:27:29 -0400
Date: Fri, 30 May 2008 21:27:21 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200805310127.m4V1RLR4013808@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] 64-bit futexes: Intro
Cc: akpm@linux-foundation.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for 64-bit futexes.  The current futexes
only protect 32-bits.  I don't know why, ask the original authors.  It is
unnecessarily limiting, though, especially for 64-bit machines.

To understand the problem let me just say that futexes work by storing
a program-defined state in a variable.  Threads then can wait for the
state of the variable to change.  It all works dandy if the protocol for
using futexes is followed correctly; see

	http://people.redhat.com/drepper/futexes.pdf

For mutexes, semaphores etc this is quite easy.  For mutexes, for instance,
we have as state to protect a flag whether the mutex is locked and whether
there is any thread waiting for the release.  This can be done easily with
the available 32 bits in a futex.

The situation is different for more complex synchronization objects.  The
best example are reader/writer locks.  Here the state consists at least
of

- number of readers which locked the rwlock
- flag whether rwlock is locked for reader, writing, or not at all
- number of readers waiting
- number of writers waiting

I.e., rwlocks are significantly more complicated.  Much of the complication
stems from the requirement to have to types: those which prefer readers and
those which prefer writers.

Without imposing unreasonable limitations on the number of concurrent users
a rwlock can have the state cannot be represented in a single 32-bit variable.
This is why the current rwlock implementation uses an internal lock and
spreads the state out in several variables.

This works, but there is a significant performance penalty to be paid:

- at least two atomic operations to lock and unlock the internal lock
- multiple readers are not really able to run concurrently since they
  might block on the internal lock
- following from the last point, the behaviour of the code is less
  predictable due to scheduling artifacts


The logical solution is to extend the size of the state which can be
protected by allowing 64-bit futexes on architectures which can support
them.  This is not new.  The last time it was brought in

  http://lkml.org/lkml/2007/3/21/65

but nothing happened.  I must admit that I didn't follow thorugh myself.

Anyway, I finally bit the bullet and wrote a patch myself.  It differs
from the old patch:

- FUTEX_64_FLAG is a flag to the existing syscall, not a new syscall.
  Given the changes which are needed the latter would have been overkill
  IMO

- no 64-bit support for the PI variants.  It simply makes no sense.  The
  value of the variables protected by the PI variants is under control of
  the kernel and it's always a TID.  Those are 32-bit values.

As you can see and the first patch the required changes really aren't that
many.  A large part of the patch deals with changing the interface of the
futex_atomic_op_inuser function.  The additional parameter is simply
ignored if 64-bit futexes aren't supported.

The patch also goes to great length to avoid negative impact for
archictectures which do not have 64-bit futexes.  You can see several
if-expressions which are decided at compile-time, optimizing out all the
additional code.

Finally, enabling 64-bit futexes for 64-bit architectures is quite simple.
The second patch enables them for x86-64.  Most of the new lines are simply
copies of the inline asms used for the 32-bit futexes, adapted for 64-bit
operations.

As for 32-bit architectures, they are mostly out of luck.  That's OK, all
the code still works as before, it's just slower.  The exception is perhaps
x86.  x86 has the cmpxchg8b instruction for many years now.  This is why
I added enablement for 64-bit futexes for x86 as well.  It's a bit more
complicated and it requires a new system call.  The reason is obvious: the
existing system call takes 32-bit values for the value parameters.  On
64-bit machines these are in any case 64-bit values, so passing 64-bit
values only requires a change to the function parameter type.  For 32-bit
machines it is not that easy, hence the new system call.  To make things
even more interesting, the required additional parameter pushes us beyond
the 6 parameter limit and the parameters have to be passed down in memory.
Nothing new.


Anyway, is it all worth it?  Well, here's a measurement of a workload
similar for what customers of our are using.  These are raw numbers,
for a reason:

#            Old              New       Gain
threads      Rwlocks          Rwlocks

1      4,991,633,560    3,986,898,840   20.13%
2     14,187,564,600    5,080,538,220   64.19%
3     20,727,416,260    5,291,971,820   74.47%
4     23,079,608,650    6,652,036,830   71.18%
5     23,1766,32,860    6,570,373,500   71.65%
6     21,913,357,010    6,591,716,100   69.92%
7     22,975,750,700    6,597,761,790   71.28%
8     22,349,919,860    6,632,005,730   70.33%
9     24,784,438,890    6,599,062,590   73.37%
10    24,899,243,380    6,493,066,340   73.92%
11    25,358,788,130    6,735,662,240   73.44%
12    19,955,548,890    6,591,059,500   66.97%
13    24,058,349,440    6,709,288,100   72.11%
14    26,002,901,340    6,741,505,130   74.07%
15    19,790,724,570    6,720,973,690   66.04%
16    26,639,730,750    6,558,662,430   75.38%

The test is run on a uni-processor quad core machine.  The task is run with
varying number of threads.  In this example the actual work performed is
trivial.  In other words, the overhead for the locking is quite large.  I
have put the data in a graph:

  http://people.redhat.com/drepper/newrwlock.png

What is obvious is that with the new implementation to uncontended case
is 20% faster.  That alone should be a good reason.  But as can be seen
it get even better with a large number of threads.  It peaks when four
threads are used (== number of cores) but I still show the results for
more threads to point out the better predictability.  These are the
minimum values from ten runs each, no averaging.  The old code, due to
the use of the internal lock, causes a lotter of jitters in the times,
reducing predictability.  In term of performance, the new code is about
four times faster on this workload.  It's certainly not characteristic
but I haven't seen a workload where the new code is slower.

I also haven't seen any case where the additional overhead in the futex
system call implementation is noticeable.

I tested the code extensively on a number of x86-64 machines, from small
dual cores machines to quad socket/quad cores machines.  I'm even using
it on my main workstation right now.

The three patches can be applied individually and everything should
continue to work fine.  The patches apply to Linus' current tree.
