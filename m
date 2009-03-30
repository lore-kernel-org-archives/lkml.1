Return-Path: <linux-kernel-owner+w=401wt.eu-S1760815AbZC3Vhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760815AbZC3Vhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbZC3Vhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:37:41 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:55916 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580AbZC3Vhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:37:39 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [tip PATCH v6 0/8] requeue pi implementation
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>
Date: Mon, 30 Mar 2009 14:37:33 -0700
Message-ID: <20090330213306.606.9540.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series is v6 of the requeue_pi patches against
linux-2.6-tip/core/futexes + core/urgent + master.  The current futex
implementation doesn't allow for requeueing of PI futexes, which leads to a
thundering herd during pthread_cond_broadcasa()t (as opposed to a civilized
priority ordered wakeup sequence).  The core of the problem is that the
underlying rt_mutex cannot be left with waiters and no owner (which would break
the PI logic).  This patch series updates the futex code to allow for
requeueing from non-PI to PI futexes in support of PI aware pthread_cond_*
calls along with some needful rt_mutex helper routines.  The credit for the
conceptual design goes to Thomas Gleixner, while the bugs and other idiocies
present in this implementation should be attributed to me.

Since the last version I have reworked the requeue logic, renamed
futex_requeue_pi_init() to futex_proxy_trylock_atomic(), fixed several bugs in
timeout and signal handling in futex_wait_requeue_pi(), incorporated some
feedback from Thomas and others, and corrected some inconsistencies in my
comments and comment formats.

This version has been tested with a rough raw futex syscall test case as well
as with a preliminary glibc patch that updates the pthread_cond* calls to use
the new syscalls and allow for the PI calls to take ownership of the rt_mutex
inside the kernel (see the "glibc hacks for requeue_pi" at the end of this
series).  With this patched glibc the LTP realtime/func/prio-wake test case has
passed more than 6k consecutive iterations (whereas before it would fail 10% of
the time).  prio-wake tests the priority ordered wakeup of a
pthread_cond_broadcast() using a PI mutex.  I have exercised the timeout and
signal paths of futex_wait_requeue_pi() prior to requeue.  I am working to add
more sophisticated tests to be able to exercise the post-requeue paths as well.
Additionally, I'd like to add some fault-injection.

I'd really appreciate feedback on the implementation as well as any design
critique.  Answers to the questions posed in the patch headers and code
comments are particularly welcome.  If we agree on the general approach, I'd
like to refactor futex_wait_requeue_pi() as it is rather lengthy at this point.

---

Darren Hart (8):
      RFC: futex: add requeue_pi calls
      RFC: futex: Add requeue_futex() call
      RFC: futex: Add FUTEX_HAS_TIMEOUT flag to restart.futex.flags
      RFC: rt_mutex: add proxy lock routines
      RFC: futex: finish_futex_lock_pi()
      RFC: futex: futex_lock_pi_atomic()
      RFC: futex: futex_top_waiter()
      RFC: futex: futex_wait_queue_me()


 include/linux/futex.h       |    8 
 include/linux/thread_info.h |    3 
 kernel/futex.c              | 1116 +++++++++++++++++++++++++++++++++----------
 kernel/rtmutex.c            |  240 +++++++--
 kernel/rtmutex_common.h     |    8 
 5 files changed, 1063 insertions(+), 312 deletions(-)

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
