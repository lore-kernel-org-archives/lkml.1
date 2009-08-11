Return-Path: <linux-kernel-owner+w=401wt.eu-S1752113AbZHKL5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbZHKL5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 07:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZHKL5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:57:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:37430 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbZHKLyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:54:31 -0400
Message-Id: <20090811111607.144736971@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Tue, 11 Aug 2009 21:09:05 +1000
From: npiggin@suse.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Manfred Spraul <manfred@colorfullife.com>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: [patch 3/4] ipc: sem preempt improve
References: <20090811110902.255877673@suse.de>
Content-Disposition: inline; filename=ipc-sem-preempt-improve.patch
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


