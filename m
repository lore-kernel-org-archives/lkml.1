Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbZEKMjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbZEKMjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbZEKMjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:39:24 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:35889 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbZEKMjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:39:23 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [RFC/PATCH 0/6] lockdep: Maintain read/write states for lock_acquires
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul E McKenney <paulmck@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 11 May 2009 18:09:25 +0530
Message-ID: <20090511122936.31159.44531.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Lockdep, while maintaining it's dependency chains does currently not
differentiate between the read/write acquires of a lock.

Thus a dependency
	rlock(A) ---> wlock(B)
is treated the same as
	wlock(A) ---> rlock(B).

If the implementation of the reader writer lock is such that upon the arrival
of a writer, it ensures that all the future readers will wait till the
completion of the writer, this non-distinction between the read and the write
acquires doesn't matter. This is because, the reads in such implementations
aren't recursive, since a recursive-read can deadlock in the presence of a
writer.
i.e in :
	Thread1: rlock(A) ------------> rlock(A)
	Thread2:          wlock(A)

Thread 1 will end up blocking on the second rlock(A), while Thread 2 is blocked
on wlock(A).
The RW-Semaphores in the linux kernel are implemented in this fashion.

However, if the implementation of the reader-writer lock allows
"reader-preference", i.e it allows the writer to grab the lock iff there are
no readers in the system, the distinction between a read/write acquire may be
necessary, since the implementation permits, read-side recursion as a
side-effect. rwlocks in the linux kernel follow a similar implementation.

lockdep however refrains from making this read/write acquire distinction for
such locks. It tries to solve the problem by not maintaining dependencies for
the reads, and maintains dependencies only for the writes.

As a result, ABBA deadlocks of the following type, go unnoticed by lockdep:

	Thread 1
	=====================
	read_lock(A);
	spin_lock(B);
	/* A-->B dependency is not maintained for reason mentioned */

	+

	Thread 2
	=====================
	spin_lock(B);
	write_lock(A);
	/* B-->A dependency maintained. But no cycle in graph.*/

Peter Zijlstra had a patch to solve this by considering the only the
first recursive-read instance of a lock in the current context while
maintaining the dependencies. http://lkml.org/lkml/2008/4/29/212

However, this had a nasty side effect since now, dependencies of the type:
	read_lock(A) --> spin_lock(B)
	spin_lock(B) --> read_lock(A)
and it's variants would also be reported as a deadlock.

This patchset solves the problem by recording the read/write states of the
locks acquired in a dependency.

i.e, for a dependency of the
type
	spin_lock(B) --> read_lock(A),

in B's "locks_after" entry for this dependency, we not only store the class of A,
but also store the the "rw-state" of both A and B. Ditto for A's
"locks_before" entry.

We define three rw-states namely:
	STATE_WRITE
	STATE_READ
	STATE_RECURSIVE_READ.

For each of these states, we define a set of conflicting states which can cause
a deadlock when involved in a dependency with the former . i.e,
	conflict_states(STATE_WRITE) =
			STATE_WRITE | STATE_READ | STATE_RECURSIVE_READ
	conflict_state(STATE_READ)   =  STATE_WRITE | STATE_READ
	conflict_state(STATE_RECURSIVE_READ) = STATE_WRITE

So, when we're walking the dependency graph to see if there is a cycle in the
graph, we follow only those entries in the "locks_after" list of a given lock,
where this lock was acquired in a rw-state which conflicts with that lock's
current rw-state.

i.e, if say lock A's current rw-state is STATE_RECURSIVE_READ,
and the locks_after list for A looks something like this:

this_class: A

			A->locks_after
	                        |
				|
				V
	---------------------------------------------------
	| dep_class: B                                    |
	| dep_rw_state: STATE_WRITE                       |
	| this_rw_state: STATE_WRITE                      |
	---------------------------------------------------
	                        |
				|
				V
	---------------------------------------------------
	| dep_class: C                                    |
	| dep_rw_state: STATE_RECURSIVE_READ              |
	| this_rw_state: STATE_RECURSIVE_READ             |
	---------------------------------------------------
	                        |
				|
				V
	---------------------------------------------------
	| dep_class: D                                    |
	| dep_rw_state: STATE_RECURSIVE_READ              |
	| this_rw_state: STATE_WRITE                      |
	---------------------------------------------------

Here, we follow only the entries where dep_class is B and D since these are the
only entries where A's rw_state (STATE_WRITE) conflicts with
it's current rw_state (STATE_RECURSIVE_READ). However, if A's current rw_state
had been STATE_WRITE, we would have followed all the three entries.

The patch-set has been tested against 2.6.30-rc3. It passes the boot-up
self-test. However more test cases need to be added to the locking-self test
which will be done in the future iterations of the patch.

Feedback is very much appreciated.

---
Gautham R Shenoy (6):
      lockdep: Consider the rw_state of lock while validating the chain.
      lockdep: Maintain rw_state entries in locklist
      lockdep: Seperate lock ids for read/write acquires.
      lockdep: Annotate Read/write states
      lockdep: Remove strict read checks.
      lockdep: Remove redundant read checks.


 include/linux/lockdep.h |  153 +++++++++++++++++++++++++++++++------
 kernel/lockdep.c        |  193 +++++++++++++++++++++++++++++------------------
 kernel/lockdep_proc.c   |    4 -
 3 files changed, 247 insertions(+), 103 deletions(-)

-- 
Thanks and Regards
gautham.
