Return-Path: <linux-kernel-owner+w=401wt.eu-S936015AbZDCUjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936015AbZDCUjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759201AbZDCUjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:39:33 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:35547 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759619AbZDCUjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:39:32 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [tip PATCH v7 0/9] RFC: futex: requeue pi implementation
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>
Date: Fri, 03 Apr 2009 13:39:25 -0700
Message-ID: <20090403203832.9772.21410.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series is v7 of the requeue_pi patches against
linux-2.6-tip/core/futexes.  The current futex implementation doesn't allow for
requeueing of PI futexes, which leads to a thundering herd during
pthread_cond_broadcasa()t (as opposed to a civilized priority ordered wakeup
sequence).  The core of the problem is that the underlying rt_mutex cannot be
left with waiters and no owner (which would break the PI logic).  This patch
series updates the futex code to allow for requeueing from non-PI to PI futexes
in support of PI aware pthread_cond_* calls along with some needful rt_mutex
helper routines.  The credit for the conceptual design goes to Thomas Gleixner,
while the bugs and other idiocies present in this implementation should be
attributed to me.

New in V7:
-refactored futex_wait_requeue_pi()
-fixed pi_state handling for some corner cases in the wake-up path
-fixed a wakeup race bug introduced by refactoring futex_wait_queue_me()
-corrected a bug in futex_wait_requeue_pi() calling fixup_owner on the wrong
 uaddr
-rewrote finish_futex_lock_pi() as fixup_owner() with more intuitive logic
-fixed a couple logic errors
-cleaned up some comments and clarified some locking approaches

This version has been tested with a rough raw futex syscall test case as well
as with a preliminary glibc patch that updates the pthread_cond* calls to use
the new syscalls and allow for the PI calls to take ownership of the rt_mutex
inside the kernel (see the "glibc hacks for requeue_pi" at the end of this
series).  With this patched glibc the LTP realtime/func/prio-wake test case has
passes consistently[1] (whereas before it would fail 10% of the time).
prio-wake tests the priority ordered wakeup of a pthread_cond_broadcast() using
a PI mutex.  I have exercised the timeout and signal paths of
futex_wait_requeue_pi() prior to requeue.  I am working to add more
sophisticated tests to be able to exercise the post-requeue error paths as
well.  Additionally, I'd like to add some fault-injection.

I'd really appreciate feedback on the implementation as well as any design
critique.  Answers to the questions posed in the patch headers and code
comments are particularly welcome.

1. In the interest of full disclosure I should mention that I have seen an rare
   hang of the prio-wake testcase.  Upon closer inspection I now believe this
   to be due to a race inherent in the testcase, and not due to any flaw in the
   kernel.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sripathi Kodi <sripathik@in.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jakub Jelinek <jakub@redhat.com>

---

Darren Hart (9):
      RFC: futex: add requeue_pi calls
      RFC: futex: add futex_wait_setup()
      RFC: futex: Add requeue_futex() call
      RFC: futex: Add FUTEX_HAS_TIMEOUT flag to restart.futex.flags
      RFC: rt_mutex: add proxy lock routines
      RFC: futex: fixup_owner()
      RFC: futex: futex_lock_pi_atomic()
      RFC: futex: futex_top_waiter()
      RFC: futex: futex_wait_queue_me()


 include/linux/futex.h       |    8 
 include/linux/thread_info.h |    3 
 kernel/futex.c              | 1179 +++++++++++++++++++++++++++++++++----------
 kernel/rtmutex.c            |  240 +++++++--
 kernel/rtmutex_common.h     |    8 
 5 files changed, 1103 insertions(+), 335 deletions(-)

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
