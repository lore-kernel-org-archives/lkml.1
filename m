Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbZJBG2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbZJBG2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 02:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756816AbZJBG2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 02:28:39 -0400
Received: from lucia.q-ag.de ([88.198.75.226]:47436 "EHLO lucia.q-ag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756806AbZJBG2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 02:28:38 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: npiggin@suse.de
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 1 Oct 2009 10:00:00 +0200
Subject: [PATCH 3/7] ipc/sem.c: sem preempt improve
Message-Id: <E1Mtbdx-00051W-3K@lucia.q-ag.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The strange sysv semaphore wakeup scheme has a kind of busy-wait lock
involved, which could deadlock if preemption is enabled during the
"lock".

It is an implementation detail (due to a spinlock being held) that this
is actually the case. However if "spinlocks" are made preemptible, or if
the sem lock is changed to a sleeping lock for example, then the wakeup
would become buggy. So this might be a bugfix for -rt kernels.

Imagine waker being preempted by wakee and never clearing IN_WAKEUP --
if wakee has higher RT priority then there is a priority inversion deadlock.
Even if there is not a priority inversion to cause a deadlock, then there
is still time wasted spinning.

Signed-off-by: Nick Piggin <npiggin@suse.de>

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c |   38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

Index: linux-2.6/ipc/sem.c
===================================================================
--- linux-2.6.orig/ipc/sem.c
+++ linux-2.6/ipc/sem.c
@@ -397,6 +397,27 @@ undo:
 	return result;
 }
 
+/*
+ * Wake up a process waiting on the sem queue with a given error.
+ * The queue is invalid (may not be accessed) after the function returns.
+ */
+static void wake_up_sem_queue(struct sem_queue *q, int error)
+{
+	/*
+	 * Hold preempt off so that we don't get preempted and have the
+	 * wakee busy-wait until we're scheduled back on. We're holding
+	 * locks here so it may not strictly be needed, however if the
+	 * locks become preemptible then this prevents such a problem.
+	 */
+	preempt_disable();
+	q->status = IN_WAKEUP;
+	wake_up_process(q->sleeper);
+	/* hands-off: q can disappear immediately after writing q->status. */
+	smp_wmb();
+	q->status = error;
+	preempt_enable();
+}
+
 /* Go through the pending queue for the indicated semaphore
  * looking for tasks that can be completed.
  */
@@ -428,17 +449,7 @@ again:
 		 *   continue.
 		 */
 		alter = q->alter;
-
-		/* wake up the waiting thread */
-		q->status = IN_WAKEUP;
-
-		wake_up_process(q->sleeper);
-		/* hands-off: q will disappear immediately after
-		 * writing q->status.
-		 */
-		smp_wmb();
-		q->status = error;
-
+		wake_up_sem_queue(q, error);
 		if (alter)
 			goto again;
 	}
@@ -522,10 +533,7 @@ static void freeary(struct ipc_namespace
 	list_for_each_entry_safe(q, tq, &sma->sem_pending, list) {
 		list_del(&q->list);
 
-		q->status = IN_WAKEUP;
-		wake_up_process(q->sleeper); /* doesn't sleep */
-		smp_wmb();
-		q->status = -EIDRM;	/* hands-off q */
+		wake_up_sem_queue(q, -EIDRM);
 	}
 
 	/* Remove the semaphore set from the IDR */

