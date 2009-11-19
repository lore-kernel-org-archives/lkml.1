Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbZKSRVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbZKSRVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbZKSRVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:21:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379AbZKSRVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:21:14 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/28] SLOW_WORK: Allow a requeueable work item to sleep till
	the thread is needed
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:21:10 +0000
Message-ID: <20091119172109.1679.14301.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to allow a requeueable work item to sleep till the thread
processing it is needed by the slow-work facility to perform other work.

Sometimes a work item can't progress immediately, but must wait for the
completion of another work item that's currently being processed by another
slow-work thread.

In some circumstances, the waiting item could instead - theoretically - put
itself back on the queue and yield its thread back to the slow-work facility,
thus waiting till it gets processing time again before attempting to progress.
This would allow other work items processing time on that thread.

However, this only works if there is something on the queue for it to queue
behind - otherwise it will just get a thread again immediately, and will end
up cycling between the queue and the thread, eating up valuable CPU time.

So, slow_work_sleep_till_thread_needed() is provided such that an item can put
itself on a wait queue that will wake it up when the event it is actually
interested in occurs, then call this function in lieu of calling schedule().

This function will then sleep until either the item's event occurs or another
work item appears on the queue.  If another work item is queued, but the
item's event hasn't occurred, then the work item should requeue itself and
yield the thread back to the slow-work facility by returning.

This can be used by CacheFiles for an object that is being created on one
thread to wait for an object being deleted on another thread where there is
nothing on the queue for the creation to go and wait behind.  As soon as an
item appears on the queue that could be given thread time instead, CacheFiles
can stick the creating object back on the queue and return to the slow-work
facility - assuming the object deletion didn't also complete.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/slow-work.txt |   44 ++++++++++++++++++++
 include/linux/slow-work.h   |    3 +
 kernel/slow-work.c          |   94 +++++++++++++++++++++++++++++++++++++++----
 3 files changed, 132 insertions(+), 9 deletions(-)

diff --git a/Documentation/slow-work.txt b/Documentation/slow-work.txt
index 0169c9d..52bc314 100644
--- a/Documentation/slow-work.txt
+++ b/Documentation/slow-work.txt
@@ -158,6 +158,50 @@ with a requeue pending).  This can be used to work out whether an item on which
 another depends is on the queue, thus allowing a dependent item to be queued
 after it.
 
+If the above shows an item on which another depends not to be queued, then the
+owner of the dependent item might need to wait.  However, to avoid locking up
+the threads unnecessarily be sleeping in them, it can make sense under some
+circumstances to return the work item to the queue, thus deferring it until
+some other items have had a chance to make use of the yielded thread.
+
+To yield a thread and defer an item, the work function should simply enqueue
+the work item again and return.  However, this doesn't work if there's nothing
+actually on the queue, as the thread just vacated will jump straight back into
+the item's work function, thus busy waiting on a CPU.
+
+Instead, the item should use the thread to wait for the dependency to go away,
+but rather than using schedule() or schedule_timeout() to sleep, it should use
+the following function:
+
+	bool requeue = slow_work_sleep_till_thread_needed(
+			struct slow_work *work,
+			signed long *_timeout);
+
+This will add a second wait and then sleep, such that it will be woken up if
+either something appears on the queue that could usefully make use of the
+thread - and behind which this item can be queued, or if the event the caller
+set up to wait for happens.  True will be returned if something else appeared
+on the queue and this work function should perhaps return, of false if
+something else woke it up.  The timeout is as for schedule_timeout().
+
+For example:
+
+	wq = bit_waitqueue(&my_flags, MY_BIT);
+	init_wait(&wait);
+	requeue = false;
+	do {
+		prepare_to_wait(wq, &wait, TASK_UNINTERRUPTIBLE);
+		if (!test_bit(MY_BIT, &my_flags))
+			break;
+		requeue = slow_work_sleep_till_thread_needed(&my_work,
+							     &timeout);
+	} while (timeout > 0 && !requeue);
+	finish_wait(wq, &wait);
+	if (!test_bit(MY_BIT, &my_flags)
+		goto do_my_thing;
+	if (requeue)
+		return; // to slow_work
+
 
 ===============
 ITEM OPERATIONS
diff --git a/include/linux/slow-work.h b/include/linux/slow-work.h
index bfd3ab4..5035a26 100644
--- a/include/linux/slow-work.h
+++ b/include/linux/slow-work.h
@@ -152,6 +152,9 @@ static inline void delayed_slow_work_cancel(struct delayed_slow_work *dwork)
 	slow_work_cancel(&dwork->work);
 }
 
+extern bool slow_work_sleep_till_thread_needed(struct slow_work *work,
+					       signed long *_timeout);
+
 #ifdef CONFIG_SYSCTL
 extern ctl_table slow_work_sysctls[];
 #endif
diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index b763bc2..da94f3c 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -133,6 +133,15 @@ LIST_HEAD(vslow_work_queue);
 DEFINE_SPINLOCK(slow_work_queue_lock);
 
 /*
+ * The following are two wait queues that get pinged when a work item is placed
+ * on an empty queue.  These allow work items that are hogging a thread by
+ * sleeping in a way that could be deferred to yield their thread and enqueue
+ * themselves.
+ */
+static DECLARE_WAIT_QUEUE_HEAD(slow_work_queue_waits_for_occupation);
+static DECLARE_WAIT_QUEUE_HEAD(vslow_work_queue_waits_for_occupation);
+
+/*
  * The thread controls.  A variable used to signal to the threads that they
  * should exit when the queue is empty, a waitqueue used by the threads to wait
  * for signals, and a completion set by the last thread to exit.
@@ -306,6 +315,50 @@ auto_requeue:
 }
 
 /**
+ * slow_work_sleep_till_thread_needed - Sleep till thread needed by other work
+ * work: The work item under execution that wants to sleep
+ * _timeout: Scheduler sleep timeout
+ *
+ * Allow a requeueable work item to sleep on a slow-work processor thread until
+ * that thread is needed to do some other work or the sleep is interrupted by
+ * some other event.
+ *
+ * The caller must set up a wake up event before calling this and must have set
+ * the appropriate sleep mode (such as TASK_UNINTERRUPTIBLE) and tested its own
+ * condition before calling this function as no test is made here.
+ *
+ * False is returned if there is nothing on the queue; true is returned if the
+ * work item should be requeued
+ */
+bool slow_work_sleep_till_thread_needed(struct slow_work *work,
+					signed long *_timeout)
+{
+	wait_queue_head_t *wfo_wq;
+	struct list_head *queue;
+
+	DEFINE_WAIT(wait);
+
+	if (test_bit(SLOW_WORK_VERY_SLOW, &work->flags)) {
+		wfo_wq = &vslow_work_queue_waits_for_occupation;
+		queue = &vslow_work_queue;
+	} else {
+		wfo_wq = &slow_work_queue_waits_for_occupation;
+		queue = &slow_work_queue;
+	}
+
+	if (!list_empty(queue))
+		return true;
+
+	add_wait_queue_exclusive(wfo_wq, &wait);
+	if (list_empty(queue))
+		*_timeout = schedule_timeout(*_timeout);
+	finish_wait(wfo_wq, &wait);
+
+	return !list_empty(queue);
+}
+EXPORT_SYMBOL(slow_work_sleep_till_thread_needed);
+
+/**
  * slow_work_enqueue - Schedule a slow work item for processing
  * @work: The work item to queue
  *
@@ -335,6 +388,8 @@ auto_requeue:
  */
 int slow_work_enqueue(struct slow_work *work)
 {
+	wait_queue_head_t *wfo_wq;
+	struct list_head *queue;
 	unsigned long flags;
 	int ret;
 
@@ -354,6 +409,14 @@ int slow_work_enqueue(struct slow_work *work)
 	 * maintaining our promise
 	 */
 	if (!test_and_set_bit_lock(SLOW_WORK_PENDING, &work->flags)) {
+		if (test_bit(SLOW_WORK_VERY_SLOW, &work->flags)) {
+			wfo_wq = &vslow_work_queue_waits_for_occupation;
+			queue = &vslow_work_queue;
+		} else {
+			wfo_wq = &slow_work_queue_waits_for_occupation;
+			queue = &slow_work_queue;
+		}
+
 		spin_lock_irqsave(&slow_work_queue_lock, flags);
 
 		if (unlikely(test_bit(SLOW_WORK_CANCELLING, &work->flags)))
@@ -380,11 +443,13 @@ int slow_work_enqueue(struct slow_work *work)
 			if (ret < 0)
 				goto failed;
 			slow_work_mark_time(work);
-			if (test_bit(SLOW_WORK_VERY_SLOW, &work->flags))
-				list_add_tail(&work->link, &vslow_work_queue);
-			else
-				list_add_tail(&work->link, &slow_work_queue);
+			list_add_tail(&work->link, queue);
 			wake_up(&slow_work_thread_wq);
+
+			/* if someone who could be requeued is sleeping on a
+			 * thread, then ask them to yield their thread */
+			if (work->link.prev == queue)
+				wake_up(wfo_wq);
 		}
 
 		spin_unlock_irqrestore(&slow_work_queue_lock, flags);
@@ -487,9 +552,19 @@ EXPORT_SYMBOL(slow_work_cancel);
  */
 static void delayed_slow_work_timer(unsigned long data)
 {
+	wait_queue_head_t *wfo_wq;
+	struct list_head *queue;
 	struct slow_work *work = (struct slow_work *) data;
 	unsigned long flags;
-	bool queued = false, put = false;
+	bool queued = false, put = false, first = false;
+
+	if (test_bit(SLOW_WORK_VERY_SLOW, &work->flags)) {
+		wfo_wq = &vslow_work_queue_waits_for_occupation;
+		queue = &vslow_work_queue;
+	} else {
+		wfo_wq = &slow_work_queue_waits_for_occupation;
+		queue = &slow_work_queue;
+	}
 
 	spin_lock_irqsave(&slow_work_queue_lock, flags);
 	if (likely(!test_bit(SLOW_WORK_CANCELLING, &work->flags))) {
@@ -502,17 +577,18 @@ static void delayed_slow_work_timer(unsigned long data)
 			put = true;
 		} else {
 			slow_work_mark_time(work);
-			if (test_bit(SLOW_WORK_VERY_SLOW, &work->flags))
-				list_add_tail(&work->link, &vslow_work_queue);
-			else
-				list_add_tail(&work->link, &slow_work_queue);
+			list_add_tail(&work->link, queue);
 			queued = true;
+			if (work->link.prev == queue)
+				first = true;
 		}
 	}
 
 	spin_unlock_irqrestore(&slow_work_queue_lock, flags);
 	if (put)
 		slow_work_put_ref(work);
+	if (first)
+		wake_up(wfo_wq);
 	if (queued)
 		wake_up(&slow_work_thread_wq);
 }

