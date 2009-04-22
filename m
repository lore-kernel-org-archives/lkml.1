Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbZDVQYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbZDVQYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 12:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZDVQYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 12:24:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48420 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbZDVQYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 12:24:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
In-Reply-To: <4664.1240413126@redhat.com>
References: <4664.1240413126@redhat.com> <20090422135134.GA5249@elte.hu> <20090416143351.GD6532@redhat.com> <20090415162712.342d4c07.akpm@linux-foundation.org> <1239649429.16771.9.camel@heimdal.trondhjem.org> <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com> <21239.1240407420@redhat.com> 
To: Ingo Molnar <mingo@elte.hu>
Cc: dhowells@redhat.com, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, serue@us.ibm.com,
       viro@zeniv.linux.org.uk,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Document that wake_up(), complete() and co. imply a full memory barrier
Date: Wed, 22 Apr 2009 17:23:18 +0100
Message-ID: <5591.1240417398@redhat.com>
From: David Howells <dhowells@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> So we can't assume that complete(), wake_up() and co. imply any barriers.
> 
> All we can assume is that try_to_wake_up() implies a write barrier, but we
> can't assume that that will be called via __wake_up_common().

So how about this, then?

David
---
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Document that wake_up(), complete() and co. may not imply a memory barrier

Add to the memory barriers document to note that wake_up(), complete() and
co. may not be assumed to imply any sort of memory barrier, with the exception
of try_to_wake_up() and things derived from that.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/memory-barriers.txt |   34 +++++++++++++++++++++++++++++++++-
 kernel/sched.c                    |   10 ++++++++++
 2 files changed, 43 insertions(+), 1 deletions(-)


diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index f5b7127..6bd626a 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -42,6 +42,7 @@ Contents:
 
      - Interprocessor interaction.
      - Atomic operations.
+     - Wake up of processes
      - Accessing devices.
      - Interrupts.
 
@@ -1224,6 +1225,9 @@ Other functions that imply barriers:
 
  (*) schedule() and similar imply full memory barriers.
 
+ (*) try_to_wake_up() and things derived from that imply a write memory
+     barrier.
+
 
 =================================
 INTER-CPU LOCKING BARRIER EFFECTS
@@ -1366,13 +1370,15 @@ WHERE ARE MEMORY BARRIERS NEEDED?
 
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
@@ -1568,6 +1574,32 @@ and in such cases the special barrier primitives will be no-ops.
 See Documentation/atomic_ops.txt for more information.
 
 
+WAKE UP OF PROCESSES
+--------------------
+
+An unlock, write memory barrier or a full memory barrier may be needed before a
+call to wake up another processes if the waker sets some state that the sleeper
+will need to see.
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
+
+The sleeper may then need to interpolate a lock, read or full memory barrier
+before accessing that state.
+
+
 ACCESSING DEVICES
 -----------------
 
diff --git a/kernel/sched.c b/kernel/sched.c
index b902e58..7cbc3de 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2337,6 +2337,8 @@ static int sched_balance_self(int cpu, int flag)
  * runnable without the overhead of this.
  *
  * returns failure only if the task is already active.
+ *
+ * It may be assumed that this function implies a full memory barrier.
  */
 static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 {
@@ -5241,6 +5243,8 @@ void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
  * @mode: which threads
  * @nr_exclusive: how many wake-one or wake-many threads to wake up
  * @key: is directly passed to the wakeup function
+ *
+ * It may not be assumed that this function implies any sort of memory barrier.
  */
 void __wake_up(wait_queue_head_t *q, unsigned int mode,
 			int nr_exclusive, void *key)
@@ -5279,6 +5283,8 @@ void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key)
  * with each other. This can prevent needless bouncing between CPUs.
  *
  * On UP it can prevent extra preemption.
+ *
+ * It may not be assumed that this function implies any sort of memory barrier.
  */
 void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode,
 			int nr_exclusive, void *key)
@@ -5315,6 +5321,8 @@ EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
  * awakened in the same order in which they were queued.
  *
  * See also complete_all(), wait_for_completion() and related routines.
+ *
+ * It may not be assumed that this function implies any sort of memory barrier.
  */
 void complete(struct completion *x)
 {
@@ -5332,6 +5340,8 @@ EXPORT_SYMBOL(complete);
  * @x:  holds the state of this particular completion
  *
  * This will wake up all threads waiting on this particular completion event.
+ *
+ * It may not be assumed that this function implies any sort of memory barrier.
  */
 void complete_all(struct completion *x)
 {
