Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbZBJTEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbZBJTEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbZBJTD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:03:28 -0500
Received: from kroah.org ([198.145.64.141]:53596 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754593AbZBJTD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:03:27 -0500
Date: Tue, 10 Feb 2009 10:59:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Johannes Weiner <hannes@cmpxchg.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Matthew Wilcox <matthew@wil.cx>, Chuck Lever <cel@citi.umich.edu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 03/53] wait: prevent exclusive waiter starvation
Message-ID: <20090210185946.GD14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="wait-prevent-exclusive-waiter-starvation.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Johannes Weiner <hannes@cmpxchg.org>

commit 777c6c5f1f6e757ae49ecca2ed72d6b1f523c007 upstream.

With exclusive waiters, every process woken up through the wait queue must
ensure that the next waiter down the line is woken when it has finished.

Interruptible waiters don't do that when aborting due to a signal.  And if
an aborting waiter is concurrently woken up through the waitqueue, noone
will ever wake up the next waiter.

This has been observed with __wait_on_bit_lock() used by
lock_page_killable(): the first contender on the queue was aborting when
the actual lock holder woke it up concurrently.  The aborted contender
didn't acquire the lock and therefor never did an unlock followed by
waking up the next waiter.

Add abort_exclusive_wait() which removes the process' wait descriptor from
the waitqueue, iff still queued, or wakes up the next waiter otherwise.
It does so under the waitqueue lock.  Racing with a wake up means the
aborting process is either already woken (removed from the queue) and will
wake up the next waiter, or it will remove itself from the queue and the
concurrent wake up will apply to the next waiter after it.

Use abort_exclusive_wait() in __wait_event_interruptible_exclusive() and
__wait_on_bit_lock() when they were interrupted by other means than a wake
up through the queue.

[akpm@linux-foundation.org: coding-style fixes]
Reported-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Mentored-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Chuck Lever <cel@citi.umich.edu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/wait.h |   11 +++++++--
 kernel/sched.c       |    4 +--
 kernel/wait.c        |   59 ++++++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 63 insertions(+), 11 deletions(-)

--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -132,6 +132,8 @@ static inline void __remove_wait_queue(w
 	list_del(&old->task_list);
 }
 
+void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
+			int nr_exclusive, int sync, void *key);
 void __wake_up(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
 extern void __wake_up_locked(wait_queue_head_t *q, unsigned int mode);
 extern void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
@@ -333,16 +335,19 @@ do {									\
 	for (;;) {							\
 		prepare_to_wait_exclusive(&wq, &__wait,			\
 					TASK_INTERRUPTIBLE);		\
-		if (condition)						\
+		if (condition) {					\
+			finish_wait(&wq, &__wait);			\
 			break;						\
+		}							\
 		if (!signal_pending(current)) {				\
 			schedule();					\
 			continue;					\
 		}							\
 		ret = -ERESTARTSYS;					\
+		abort_exclusive_wait(&wq, &__wait, 			\
+				TASK_INTERRUPTIBLE, NULL);		\
 		break;							\
 	}								\
-	finish_wait(&wq, &__wait);					\
 } while (0)
 
 #define wait_event_interruptible_exclusive(wq, condition)		\
@@ -431,6 +436,8 @@ extern long interruptible_sleep_on_timeo
 void prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state);
 void prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state);
 void finish_wait(wait_queue_head_t *q, wait_queue_t *wait);
+void abort_exclusive_wait(wait_queue_head_t *q, wait_queue_t *wait,
+			unsigned int mode, void *key);
 int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
 int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
 
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4586,8 +4586,8 @@ EXPORT_SYMBOL(default_wake_function);
  * started to run but is not in state TASK_RUNNING. try_to_wake_up() returns
  * zero in this (rare) case, and we handle it by continuing to scan the queue.
  */
-static void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
-			     int nr_exclusive, int sync, void *key)
+void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
+			int nr_exclusive, int sync, void *key)
 {
 	wait_queue_t *curr, *next;
 
--- a/kernel/wait.c
+++ b/kernel/wait.c
@@ -91,6 +91,15 @@ prepare_to_wait_exclusive(wait_queue_hea
 }
 EXPORT_SYMBOL(prepare_to_wait_exclusive);
 
+/*
+ * finish_wait - clean up after waiting in a queue
+ * @q: waitqueue waited on
+ * @wait: wait descriptor
+ *
+ * Sets current thread back to running state and removes
+ * the wait descriptor from the given waitqueue if still
+ * queued.
+ */
 void finish_wait(wait_queue_head_t *q, wait_queue_t *wait)
 {
 	unsigned long flags;
@@ -117,6 +126,39 @@ void finish_wait(wait_queue_head_t *q, w
 }
 EXPORT_SYMBOL(finish_wait);
 
+/*
+ * abort_exclusive_wait - abort exclusive waiting in a queue
+ * @q: waitqueue waited on
+ * @wait: wait descriptor
+ * @state: runstate of the waiter to be woken
+ * @key: key to identify a wait bit queue or %NULL
+ *
+ * Sets current thread back to running state and removes
+ * the wait descriptor from the given waitqueue if still
+ * queued.
+ *
+ * Wakes up the next waiter if the caller is concurrently
+ * woken up through the queue.
+ *
+ * This prevents waiter starvation where an exclusive waiter
+ * aborts and is woken up concurrently and noone wakes up
+ * the next waiter.
+ */
+void abort_exclusive_wait(wait_queue_head_t *q, wait_queue_t *wait,
+			unsigned int mode, void *key)
+{
+	unsigned long flags;
+
+	__set_current_state(TASK_RUNNING);
+	spin_lock_irqsave(&q->lock, flags);
+	if (!list_empty(&wait->task_list))
+		list_del_init(&wait->task_list);
+	else if (waitqueue_active(q))
+		__wake_up_common(q, mode, 1, 0, key);
+	spin_unlock_irqrestore(&q->lock, flags);
+}
+EXPORT_SYMBOL(abort_exclusive_wait);
+
 int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key)
 {
 	int ret = default_wake_function(wait, mode, sync, key);
@@ -177,17 +219,20 @@ int __sched
 __wait_on_bit_lock(wait_queue_head_t *wq, struct wait_bit_queue *q,
 			int (*action)(void *), unsigned mode)
 {
-	int ret = 0;
-
 	do {
+		int ret;
+
 		prepare_to_wait_exclusive(wq, &q->wait, mode);
-		if (test_bit(q->key.bit_nr, q->key.flags)) {
-			if ((ret = (*action)(q->key.flags)))
-				break;
-		}
+		if (!test_bit(q->key.bit_nr, q->key.flags))
+			continue;
+		ret = action(q->key.flags);
+		if (!ret)
+			continue;
+		abort_exclusive_wait(wq, &q->wait, mode, &q->key);
+		return ret;
 	} while (test_and_set_bit(q->key.bit_nr, q->key.flags));
 	finish_wait(wq, &q->wait);
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(__wait_on_bit_lock);
 

