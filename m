Return-Path: <linux-kernel-owner+w=401wt.eu-S1761384AbZD1OD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761384AbZD1OD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 10:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755976AbZD1ODS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 10:03:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54172 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418AbZD1ODR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 10:03:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Document memory barriers implied by sleep/wake-up primitives
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: oleg@redhat.com, dhowells@redhat.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Date: Tue, 28 Apr 2009 15:01:38 +0100
Message-ID: <20090428140138.1192.94723.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a section to the memory barriers document to note the implied memory
barriers of sleep primitives (set_current_state() and wrappers) and wake-up
primitives (wake_up() and co.).

Also extend the in-code comments on the wake_up() functions to note these
implied barriers.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/memory-barriers.txt |  129 +++++++++++++++++++++++++++++++++++++
 kernel/sched.c                    |   23 +++++++
 2 files changed, 151 insertions(+), 1 deletions(-)


diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index f5b7127..7f5809e 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -31,6 +31,7 @@ Contents:
 
      - Locking functions.
      - Interrupt disabling functions.
+     - Sleep and wake-up functions.
      - Miscellaneous functions.
 
  (*) Inter-CPU locking barrier effects.
@@ -1217,6 +1218,132 @@ barriers are required in such a situation, they must be provided from some
 other means.
 
 
+SLEEP AND WAKE-UP FUNCTIONS
+---------------------------
+
+Sleeping and waking on an event flagged in global data can be viewed as an
+interaction between two pieces of data: the task state of the task waiting for
+the event and the global data used to indicate the event.  To make sure that
+these appear to happen in the right order, the primitives to begin the process
+of going to sleep, and the primitives to initiate a wake up imply certain
+barriers.
+
+Firstly, the sleeper normally follows something like this sequence of events:
+
+	for (;;) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		if (event_indicated)
+			break;
+		schedule();
+	}
+
+A general memory barrier is interpolated automatically by set_current_state()
+after it has altered the task state:
+
+	CPU 1
+	===============================
+	set_current_state();
+	  set_mb();
+	    STORE current->state
+	    <general barrier>
+	LOAD event_indicated
+
+set_current_state() may be wrapped by:
+
+	prepare_to_wait();
+	prepare_to_wait_exclusive();
+
+which therefore also imply a general memory barrier after setting the state.
+The whole sequence above is available in various canned forms, all of which
+interpolate the memory barrier in the right place:
+
+	wait_event();
+	wait_event_interruptible();
+	wait_event_interruptible_exclusive();
+	wait_event_interruptible_timeout();
+	wait_event_killable();
+	wait_event_timeout();
+	wait_on_bit();
+	wait_on_bit_lock();
+
+
+Secondly, code that performs a wake up normally follows something like this:
+
+	event_indicated = 1;
+	wake_up(&event_wait_queue);
+
+or:
+
+	event_indicated = 1;
+	wake_up_process(event_daemon);
+
+A write memory barrier is implied by wake_up() and co. if and only if they wake
+something up.  The barrier occurs before the task state is cleared, and so sits
+between the STORE to indicate the event and the STORE to set TASK_RUNNING:
+
+	CPU 1				CPU 2
+	===============================	===============================
+	set_current_state();		STORE event_indicated
+	  set_mb();			wake_up();
+	    STORE current->state	  <write barrier>
+	    <general barrier>		  STORE current->state
+	LOAD event_indicated
+
+The available waker functions include:
+
+	complete();
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
+	wake_up_process();
+
+
+[!] Note that the memory barriers implied by the sleeper and the waker do _not_
+order multiple stores before the wake-up with respect to loads of those stored
+values after the sleeper has called set_current_state().  For instance, if the
+sleeper does:
+
+	set_current_state(TASK_INTERRUPTIBLE);
+	if (event_indicated)
+		break;
+	__set_current_state(TASK_RUNNING);
+	do_something(my_data);
+
+and the waker does:
+
+	my_data = value;
+	event_indicated = 1;
+	wake_up(&event_wait_queue);
+
+there's no guarantee that the change to event_indicated will be perceived by
+the sleeper as coming after the change to my_data.  In such a circumstance, the
+code on both sides must interpolate its own memory barriers between the
+separate data accesses.  Thus the above sleeper ought to do:
+
+	set_current_state(TASK_INTERRUPTIBLE);
+	if (event_indicated) {
+		smp_rmb();
+		do_something(my_data);
+	}
+
+and the waker should do:
+
+	my_data = value;
+	smp_wmb();
+	event_indicated = 1;
+	wake_up(&event_wait_queue);
+
+
 MISCELLANEOUS FUNCTIONS
 -----------------------
 
@@ -1366,7 +1493,7 @@ WHERE ARE MEMORY BARRIERS NEEDED?
 
 Under normal operation, memory operation reordering is generally not going to
 be a problem as a single-threaded linear piece of code will still appear to
-work correctly, even if it's in an SMP kernel.  There are, however, three
+work correctly, even if it's in an SMP kernel.  There are, however, four
 circumstances in which reordering definitely _could_ be a problem:
 
  (*) Interprocessor interaction.
diff --git a/kernel/sched.c b/kernel/sched.c
index b902e58..fd0c2ce 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2458,6 +2458,17 @@ out:
 	return success;
 }
 
+/**
+ * wake_up_process - Wake up a specific process
+ * @p: The process to be woken up.
+ *
+ * Attempt to wake up the nominated process and move it to the set of runnable
+ * processes.  Returns 1 if the process was woken up, 0 if it was already
+ * running.
+ *
+ * It may be assumed that this function implies a write memory barrier before
+ * changing the task state if and only if any tasks are woken up.
+ */
 int wake_up_process(struct task_struct *p)
 {
 	return try_to_wake_up(p, TASK_ALL, 0);
@@ -5241,6 +5252,9 @@ void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
  * @mode: which threads
  * @nr_exclusive: how many wake-one or wake-many threads to wake up
  * @key: is directly passed to the wakeup function
+ *
+ * It may be assumed that this function implies a write memory barrier before
+ * changing the task state if and only if any tasks are woken up.
  */
 void __wake_up(wait_queue_head_t *q, unsigned int mode,
 			int nr_exclusive, void *key)
@@ -5279,6 +5293,9 @@ void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key)
  * with each other. This can prevent needless bouncing between CPUs.
  *
  * On UP it can prevent extra preemption.
+ *
+ * It may be assumed that this function implies a write memory barrier before
+ * changing the task state if and only if any tasks are woken up.
  */
 void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode,
 			int nr_exclusive, void *key)
@@ -5315,6 +5332,9 @@ EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
  * awakened in the same order in which they were queued.
  *
  * See also complete_all(), wait_for_completion() and related routines.
+ *
+ * It may be assumed that this function implies a write memory barrier before
+ * changing the task state if and only if any tasks are woken up.
  */
 void complete(struct completion *x)
 {
@@ -5332,6 +5352,9 @@ EXPORT_SYMBOL(complete);
  * @x:  holds the state of this particular completion
  *
  * This will wake up all threads waiting on this particular completion event.
+ *
+ * It may be assumed that this function implies a write memory barrier before
+ * changing the task state if and only if any tasks are woken up.
  */
 void complete_all(struct completion *x)
 {

