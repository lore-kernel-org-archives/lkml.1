Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbZDWQfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbZDWQfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 12:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbZDWQe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 12:34:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53990 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbZDWQe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 12:34:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090422175753.GA14236@elte.hu>
References: <20090422175753.GA14236@elte.hu> <20090415162712.342d4c07.akpm@linux-foundation.org> <1239649429.16771.9.camel@heimdal.trondhjem.org> <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com> <21239.1240407420@redhat.com> <5591.1240417398@redhat.com> 
To: Ingo Molnar <mingo@elte.hu>, torvalds@osdl.org
Cc: dhowells@redhat.com, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, serue@us.ibm.com,
       viro@zeniv.linux.org.uk,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH] It may not be assumed that wake_up(), finish_wait() and co. imply a memory barrier
Date: Thu, 23 Apr 2009 17:32:24 +0100
Message-ID: <21209.1240504344@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:

> Why would an unlock be needed before a call to wake_up() variants?

Good point.  I've amended my patch again (see attached).

> In fact i'd encourage to _not_ document try_to_lock() as a write barrier
> either

Did you mean try_to_wake_up()?  Or did you mean things like
spin_lock_trylock()?  If the latter, it *has* to be a LOCK-class barrier if it
succeeds - otherwise what's the point?

> - but rather have explicit barriers where they are needed. Then we
> could remove that barrier from try_to_wake_up() too ;-)

I was wondering if wake_up() and friends should in fact imply smp_wmb(), but I
guess that they're often used in conjunction with spinlocks - and in such a
situation a barrier is unnecessary overhead.

David
---
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] It may not be assumed that wake_up(), finish_wait() and co. imply a memory barrier

Add to the memory barriers document to note that try_to_wake_up(), wake_up(),
complete(), finish_wait() and co. should not be assumed to imply any sort of
memory barrier.

This is because:

 (1) A lot of the time, memory barriers in the wake-up and sleeper paths would
     be superfluous due to the use of locks.

 (2) It is possible to pass right through wake_up() and co. without hitting
     anything at all or anything other than a spin_lock/spin_unlock (if
     try_to_wake_up() isn't invoked).

 (3) The smp_wmb() should probably move out of try_to_wake_up() and into
     suitable places in its callers.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/memory-barriers.txt |   34 +++++++++++++++++++++++++++++++++-
 kernel/sched.c                    |   11 +++++++++++
 2 files changed, 44 insertions(+), 1 deletions(-)


diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index f5b7127..8c32e23 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -42,6 +42,7 @@ Contents:
 
      - Interprocessor interaction.
      - Atomic operations.
+     - Wake up of processes
      - Accessing devices.
      - Interrupts.
 
@@ -1366,13 +1367,15 @@ WHERE ARE MEMORY BARRIERS NEEDED?
 
 Under normal operation, memory operation reordering is generally not going to
 be a problem as a single-threaded linear piece of code will still appear to
-work correctly, even if it's in an SMP kernel.  There are, however, three
+work correctly, even if it's in an SMP kernel.  There are, however, five
 circumstances in which reordering definitely _could_ be a problem:
 
  (*) Interprocessor interaction.
 
  (*) Atomic operations.
 
+ (*) Wake up of processes.
+
  (*) Accessing devices.
 
  (*) Interrupts.
@@ -1568,6 +1571,35 @@ and in such cases the special barrier primitives will be no-ops.
 See Documentation/atomic_ops.txt for more information.
 
 
+WAKE UP OF PROCESSES
+--------------------
+
+If locking is not used, and if the waker sets some state that the sleeper will
+need to see, a write memory barrier or a full memory barrier may be needed
+before one of the following calls is used to wake up another process:
+
+	complete();
+	try_to_wake_up();
+	wake_up();
+	wake_up_all();
+	wake_up_bit();
+	wake_up_interruptible();
+	wake_up_interruptible_all();
+	wake_up_interruptible_nr();
+	wake_up_interruptible_poll();
+	wake_up_interruptible_sync();
+	wake_up_interruptible_sync_poll();
+	wake_up_locked();
+	wake_up_locked_poll();
+	wake_up_nr();
+	wake_up_poll();
+
+After waking, and assuming it doesn't take a matching lock, the sleeper may
+need to interpolate a read or full memory barrier before accessing that state
+as finish_wait() does not imply a barrier either, and schedule() only implies a
+barrier on entry.
+
+
 ACCESSING DEVICES
 -----------------
 
diff --git a/kernel/sched.c b/kernel/sched.c
index b902e58..2ef0479 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2337,6 +2337,9 @@ static int sched_balance_self(int cpu, int flag)
  * runnable without the overhead of this.
  *
  * returns failure only if the task is already active.
+ *
+ * It should not be assumed that this function implies any sort of memory
+ * barrier.
  */
 static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 {
@@ -5241,6 +5244,8 @@ void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
  * @mode: which threads
  * @nr_exclusive: how many wake-one or wake-many threads to wake up
  * @key: is directly passed to the wakeup function
+ *
+ * It may not be assumed that this function implies any sort of memory barrier.
  */
 void __wake_up(wait_queue_head_t *q, unsigned int mode,
 			int nr_exclusive, void *key)
@@ -5279,6 +5284,8 @@ void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key)
  * with each other. This can prevent needless bouncing between CPUs.
  *
  * On UP it can prevent extra preemption.
+ *
+ * It may not be assumed that this function implies any sort of memory barrier.
  */
 void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode,
 			int nr_exclusive, void *key)
@@ -5315,6 +5322,8 @@ EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
  * awakened in the same order in which they were queued.
  *
  * See also complete_all(), wait_for_completion() and related routines.
+ *
+ * It may not be assumed that this function implies any sort of memory barrier.
  */
 void complete(struct completion *x)
 {
@@ -5332,6 +5341,8 @@ EXPORT_SYMBOL(complete);
  * @x:  holds the state of this particular completion
  *
  * This will wake up all threads waiting on this particular completion event.
+ *
+ * It may not be assumed that this function implies any sort of memory barrier.
  */
 void complete_all(struct completion *x)
 {
