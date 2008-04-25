Return-Path: <linux-kernel-owner+w=401wt.eu-S1761645AbYDYOV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761645AbYDYOV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 10:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756889AbYDYOVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 10:21:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55108 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649AbYDYOVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 10:21:12 -0400
Message-Id: <20080425130908.140707404@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 09:09:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Clark Williams <clark.williams@gmail.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Jon Masters <jonathan@jonmasters.org>,
       Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH RT 0/6] New read/write locks for PI and multiple readers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently in the -rt patch the rwlocks (and rwsems) are converted into a
simple mutex. That is, when PREEMP_RT is configured, the rwsems and rwlocks
can only have one reader at a time. Those locks may only be held by a single
owner (reader or writer). The reason for this is to allow priority
inheritance for these locks. PI can be quite complex, but it is easier
to handle PI when dealing with only a single owner. When multiple owners
are involved it gets even more complex. But this patch series aims to
accomplish PI over multiple owners.

Having multiple owners may also have other drawbacks in RT. One is that
it adds a bit more non-determinism. Because a writer may have to wait
the critical path time * each reader that currently holds the lock.
Since the number of readers is not set, this creates a non-deterministic
time frame.  To deal with this, this patch series adds the ability to
limit the number of readers that may own the lock. Setting that number
to the number of CPUS may be a good idea.

Having no limit to the number of readers may also be preferable. Although
it adds some non-determinism, the PI on the readers prevents unbounded priority
inversion, where a task can block a lower priority task that holds a lock
that is keeping higher priority tasks from running.

The way this algorithm works is by adding a new descriptor called
rw_mutex. This descriptor also contains a RT mutex (one with PI).
It also adds a new owner field in the rw_mutex. When taking the lock for
read, it does a cmpxchg (if the arch supports it) on the owner field placing
in its own current pointer if the owner field is currently NULL. If this
succeeds, then it grabs the lock and increments the owner counts.
If it fails it enters the slow path (if the arch doesn't have cmpxchg then
it always enters the slow path).

The slow path for read checks to see if the owner field is set for readers,
and if it is, it ups the owner counts of the locks and sets up the pointers
from the lock to the readers and grabs the lock.

If it fails, the reader blocking is much like the same as a simple mutex
since it may boost the writer (which there would be only one). But first
if the owner of the rw_lock is not set in the rt_mutex, then the owner
is updated, to allow the old PI algorithm to work (see patches for details).

For a writer to take the lock, in the fastpath it does a cmpxchg to the
rw_mutex field by trying to copy in the current pointer plus the second
least significant bit (the first least significant bit is set for serializing
fast paths with slowpaths).  The second least significant bit in the
owner field denotes that the owner is a writer.

If it fails the fast path, it enters the slow path. There if it still can't
get the lock, it updates the rt_mutex owner field (don't confuse the rt_mutex
with the rw_mutex descriptors). If the owner of the lock is a reader the
rt_mutex owner is given a factitious owner (RT_RW_READER).

The current PI algorithm takes at most two of the internal spin_locks
at a time and checks for deadlocks. One reason to do this is that this
algorithm is also used with futexes, and we can't allow user space code
be able deadlocking the kernel. But because rwlocks and rwsems are never
held while taking a futex (that would just be bad) we can trust the
rwlocks and rwsems will not deadlock (or the kernel itself is bad).

Because of this, when the PI algorithm walks the chain and comes across
a owner of RT_RW_READER, it breaks out of the loop, and will contiune
to hold that rt_mutex's internal spin lock. Then it will go through
each of the readers and continue the algorithm on each.

Yes this contains a recursive function, but it also keeps track
at the number of times it recurs. Which brings us to the limits that the
algorithm imposes. A task can only hold at most 5 different reader
locks at the same time. This should not be an issue, since it would be
bad programming practice to hold more that 5 different reader locks.
This is because each task has an array of 5 reader lock structures that
it uses to keep track of the reader locks it owns. This is for use
of the PI algorithm.

For more on this code, see the patches.

-- Steve


