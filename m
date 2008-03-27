Return-Path: <linux-kernel-owner+w=401wt.eu-S1761955AbYC0NdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761955AbYC0NdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 09:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760301AbYC0Nb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 09:31:26 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:52615 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757908AbYC0NbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 09:31:25 -0400
Message-Id: <20080327133015.159469909@polymtl.ca>
References: <20080327132057.449831367@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 27 Mar 2008 09:21:04 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mike Mason <mmlnx@us.ibm.com>, David Wilder <dwilder@us.ibm.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch for 2.6.26 7/7] LTTng instrumentation - lib
Content-Disposition: inline; filename=lttng-instrumentation-lib.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 27 Mar 2008 13:30:15 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Originally : Add Markers into Semaphore Primitives)

This patch adds several markers around semaphore primitives.
Along with a tracing application this patch can be useful for measuring
kernel semaphore usage and contention.

Added markers :

sem_down
sem_down_intr
sem_down_intr_fail
sem_down_intr_resume
sem_down_intr_sched
sem_down_resume
sem_down_sched
sem_up

Signed-off-by: Mike Mason <mmlnx@us.ibm.com>
Signed-off-by: David Wilder <dwilder@us.ibm.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 lib/semaphore-sleepers.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6-lttng/lib/semaphore-sleepers.c
===================================================================
--- linux-2.6-lttng.orig/lib/semaphore-sleepers.c	2008-03-27 08:08:37.000000000 -0400
+++ linux-2.6-lttng/lib/semaphore-sleepers.c	2008-03-27 08:08:56.000000000 -0400
@@ -15,6 +15,7 @@
 #include <linux/sched.h>
 #include <linux/err.h>
 #include <linux/init.h>
+#include <linux/marker.h>
 #include <asm/semaphore.h>
 
 /*
@@ -50,6 +51,7 @@
 
 void __up(struct semaphore *sem)
 {
+	trace_mark(sem_up, "%p", sem);
 	wake_up(&sem->wait);
 }
 
@@ -59,6 +61,7 @@ void __sched __down(struct semaphore *se
 	DECLARE_WAITQUEUE(wait, tsk);
 	unsigned long flags;
 
+	trace_mark(sem_down, "%p", sem);
 	tsk->state = TASK_UNINTERRUPTIBLE;
 	spin_lock_irqsave(&sem->wait.lock, flags);
 	add_wait_queue_exclusive_locked(&sem->wait, &wait);
@@ -73,12 +76,14 @@ void __sched __down(struct semaphore *se
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
@@ -97,6 +102,7 @@ int __sched __down_interruptible(struct 
 	DECLARE_WAITQUEUE(wait, tsk);
 	unsigned long flags;
 
+	trace_mark(sem_down_intr, "%p", sem);
 	tsk->state = TASK_INTERRUPTIBLE;
 	spin_lock_irqsave(&sem->wait.lock, flags);
 	add_wait_queue_exclusive_locked(&sem->wait, &wait);
@@ -113,6 +119,7 @@ int __sched __down_interruptible(struct 
 		 * and exit.
 		 */
 		if (signal_pending(current)) {
+			trace_mark(sem_down_intr_fail, "%p", sem);
 			retval = -EINTR;
 			sem->sleepers = 0;
 			atomic_add(sleepers, &sem->count);
@@ -126,12 +133,14 @@ int __sched __down_interruptible(struct 
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

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
