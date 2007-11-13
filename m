Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbXKMAww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbXKMAww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 19:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbXKMAwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 19:52:44 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:52937 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbXKMAwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 19:52:44 -0500
Subject: [RFC] Add markers into semaphore primitives
From: "David J. Wilder" <dwilder@us.ibm.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 12 Nov 2007 16:52:36 -0800
Message-Id: <1194915156.913.4.camel@lc4eb748232119.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds several markers around semaphore primitives.
Along with a tracing application this patch can be useful for measuring
kernel semaphore usage and contention.

Signed-off-by: Mike Mason <mmlnx@us.ibm.com>
Signed-off-by: David Wilder <dwilder@us.ibm.com>
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


