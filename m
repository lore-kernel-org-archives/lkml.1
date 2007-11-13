Return-Path: <linux-kernel-owner+w=401wt.eu-S1762609AbXKMTnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762609AbXKMTnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761316AbXKMTlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:41:20 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:47710 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760217AbXKMTlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:41:18 -0500
Message-Id: <20071113194025.807441753@polymtl.ca>
References: <20071113193349.214098508@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 13 Nov 2007 14:33:56 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mike Mason <mmlnx@us.ibm.com>, David Wilder <dwilder@us.ibm.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC 7/7] Add Markers Into Semaphore Primitives
Content-Disposition: inline; filename=add-markers-into-semaphore-primitives.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 13 Nov 2007 19:40:26 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds several markers around semaphore primitives.
Along with a tracing application this patch can be useful for measuring
kernel semaphore usage and contention.

Signed-off-by: Mike Mason <mmlnx@us.ibm.com>
Signed-off-by: David Wilder <dwilder@us.ibm.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 lib/semaphore-sleepers.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/lib/semaphore-sleepers.c b/lib/semaphore-sleepers.c
index 1281805..5343a96 100644
--- a/lib/semaphore-sleepers.c
+++ b/lib/semaphore-sleepers.c
@@ -15,6 +15,7 @@
 #include <linux/sched.h>
 #include <linux/err.h>
 #include <linux/init.h>
+#include <linux/marker.h>
 #include <asm/semaphore.h>
 
 /*
@@ -50,6 +51,7 @@
 
 fastcall void __up(struct semaphore *sem)
 {
+	trace_mark(sem_up, "%p", sem);
 	wake_up(&sem->wait);
 }
 
@@ -59,6 +61,7 @@ fastcall void __sched __down(struct semaphore * sem)
 	DECLARE_WAITQUEUE(wait, tsk);
 	unsigned long flags;
 
+	trace_mark(sem_down, "%p", sem);
 	tsk->state = TASK_UNINTERRUPTIBLE;
 	spin_lock_irqsave(&sem->wait.lock, flags);
 	add_wait_queue_exclusive_locked(&sem->wait, &wait);
@@ -73,12 +76,14 @@ fastcall void __sched __down(struct semaphore * sem)
 		 * the wait_queue_head.
 		 */
 		if (!atomic_add_negative(sleepers - 1, &sem->count)) {
+			trace_mark(sem_down_resume, "%p", sem);
 			sem->sleepers = 0;
 			break;
 		}
 		sem->sleepers = 1;	/* us - see -1 above */
 		spin_unlock_irqrestore(&sem->wait.lock, flags);
 
+		trace_mark(sem_down_sched, "%p", sem);
 		schedule();
 
 		spin_lock_irqsave(&sem->wait.lock, flags);
@@ -97,6 +102,7 @@ fastcall int __sched __down_interruptible(struct semaphore * sem)
 	DECLARE_WAITQUEUE(wait, tsk);
 	unsigned long flags;
 
+	trace_mark(sem_down_intr, "%p", sem);
 	tsk->state = TASK_INTERRUPTIBLE;
 	spin_lock_irqsave(&sem->wait.lock, flags);
 	add_wait_queue_exclusive_locked(&sem->wait, &wait);
@@ -113,6 +119,7 @@ fastcall int __sched __down_interruptible(struct semaphore * sem)
 		 * and exit.
 		 */
 		if (signal_pending(current)) {
+			trace_mark(sem_down_intr_fail, "%p", sem);
 			retval = -EINTR;
 			sem->sleepers = 0;
 			atomic_add(sleepers, &sem->count);
@@ -126,12 +133,14 @@ fastcall int __sched __down_interruptible(struct semaphore * sem)
 		 * still hoping to get the semaphore.
 		 */
 		if (!atomic_add_negative(sleepers - 1, &sem->count)) {
+			trace_mark(sem_down_intr_resume, "%p", sem);
 			sem->sleepers = 0;
 			break;
 		}
 		sem->sleepers = 1;	/* us - see -1 above */
 		spin_unlock_irqrestore(&sem->wait.lock, flags);
 
+		trace_mark(sem_down_intr_sched, "%p", sem);
 		schedule();
 
 		spin_lock_irqsave(&sem->wait.lock, flags);


-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
