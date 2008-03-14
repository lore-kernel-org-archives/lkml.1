Return-Path: <linux-kernel-owner+w=401wt.eu-S1759227AbYCNVUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227AbYCNVUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 17:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbYCNVUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 17:20:05 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:55585 "EHLO
	mail-05.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbYCNVUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 17:20:03 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au, lenb@kernel.org,
       dhowells@redhat.com, peterz@infradead.org, mingo@elte.hu,
       harvey.harrison@gmail.com
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 5/6] Add down_timeout and change ACPI to use it
Date: Fri, 14 Mar 2008 16:44:52 -0400
Message-Id: <1205527493-5740-5-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1205527493-5740-4-git-send-email-matthew@wil.cx>
References: <20080314204248.GV613@parisc-linux.org>
 <1205527493-5740-1-git-send-email-matthew@wil.cx>
 <1205527493-5740-2-git-send-email-matthew@wil.cx>
 <1205527493-5740-3-git-send-email-matthew@wil.cx>
 <1205527493-5740-4-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI currently emulates a timeout for semaphores with calls to
down_trylock and sleep.  This produces horrible behaviour in terms of
fairness and excessive wakeups.  Now that we have a unified semaphore
implementation, adding a real down_trylock is almost trivial.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/acpi/osl.c        |   89 +++++++++++----------------------------------
 include/linux/semaphore.h |    6 +++
 kernel/semaphore.c        |   42 ++++++++++++++++++----
 3 files changed, 62 insertions(+), 75 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 065819b..2adfb6d 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -4,6 +4,8 @@
  *  Copyright (C) 2000       Andrew Henroid
  *  Copyright (C) 2001, 2002 Andy Grover <andrew.grover@intel.com>
  *  Copyright (C) 2001, 2002 Paul Diefenbaugh <paul.s.diefenbaugh@intel.com>
+ *  Copyright (c) 2008 Intel Corporation
+ *   Author: Matthew Wilcox <willy@linux.intel.com>
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  *
@@ -37,15 +39,18 @@
 #include <linux/workqueue.h>
 #include <linux/nmi.h>
 #include <linux/acpi.h>
-#include <acpi/acpi.h>
-#include <asm/io.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/processor.h>
-#include <asm/uaccess.h>
-
 #include <linux/efi.h>
 #include <linux/ioport.h>
 #include <linux/list.h>
+#include <linux/jiffies.h>
+#include <linux/semaphore.h>
+
+#include <asm/io.h>
+#include <asm/uaccess.h>
+
+#include <acpi/acpi.h>
+#include <acpi/acpi_bus.h>
+#include <acpi/processor.h>
 
 #define _COMPONENT		ACPI_OS_SERVICES
 ACPI_MODULE_NAME("osl");
@@ -848,7 +853,6 @@ acpi_os_create_semaphore(u32 max_units, u32 initial_units, acpi_handle * handle)
 {
 	struct semaphore *sem = NULL;
 
-
 	sem = acpi_os_allocate(sizeof(struct semaphore));
 	if (!sem)
 		return AE_NO_MEMORY;
@@ -875,12 +879,12 @@ acpi_status acpi_os_delete_semaphore(acpi_handle handle)
 {
 	struct semaphore *sem = (struct semaphore *)handle;
 
-
 	if (!sem)
 		return AE_BAD_PARAMETER;
 
 	ACPI_DEBUG_PRINT((ACPI_DB_MUTEX, "Deleting semaphore[%p].\n", handle));
 
+	BUG_ON(!list_empty(&sem->wait_list));
 	kfree(sem);
 	sem = NULL;
 
@@ -888,21 +892,15 @@ acpi_status acpi_os_delete_semaphore(acpi_handle handle)
 }
 
 /*
- * TODO: The kernel doesn't have a 'down_timeout' function -- had to
- * improvise.  The process is to sleep for one scheduler quantum
- * until the semaphore becomes available.  Downside is that this
- * may result in starvation for timeout-based waits when there's
- * lots of semaphore activity.
- *
  * TODO: Support for units > 1?
  */
 acpi_status acpi_os_wait_semaphore(acpi_handle handle, u32 units, u16 timeout)
 {
 	acpi_status status = AE_OK;
 	struct semaphore *sem = (struct semaphore *)handle;
+	long jiffies;
 	int ret = 0;
 
-
 	if (!sem || (units < 1))
 		return AE_BAD_PARAMETER;
 
@@ -912,58 +910,14 @@ acpi_status acpi_os_wait_semaphore(acpi_handle handle, u32 units, u16 timeout)
 	ACPI_DEBUG_PRINT((ACPI_DB_MUTEX, "Waiting for semaphore[%p|%d|%d]\n",
 			  handle, units, timeout));
 
-	/*
-	 * This can be called during resume with interrupts off.
-	 * Like boot-time, we should be single threaded and will
-	 * always get the lock if we try -- timeout or not.
-	 * If this doesn't succeed, then we will oops courtesy of
-	 * might_sleep() in down().
-	 */
-	if (!down_trylock(sem))
-		return AE_OK;
-
-	switch (timeout) {
-		/*
-		 * No Wait:
-		 * --------
-		 * A zero timeout value indicates that we shouldn't wait - just
-		 * acquire the semaphore if available otherwise return AE_TIME
-		 * (a.k.a. 'would block').
-		 */
-	case 0:
-		if (down_trylock(sem))
-			status = AE_TIME;
-		break;
-
-		/*
-		 * Wait Indefinitely:
-		 * ------------------
-		 */
-	case ACPI_WAIT_FOREVER:
-		down(sem);
-		break;
-
-		/*
-		 * Wait w/ Timeout:
-		 * ----------------
-		 */
-	default:
-		// TODO: A better timeout algorithm?
-		{
-			int i = 0;
-			static const int quantum_ms = 1000 / HZ;
-
-			ret = down_trylock(sem);
-			for (i = timeout; (i > 0 && ret != 0); i -= quantum_ms) {
-				schedule_timeout_interruptible(1);
-				ret = down_trylock(sem);
-			}
-
-			if (ret != 0)
-				status = AE_TIME;
-		}
-		break;
-	}
+	if (timeout == ACPI_WAIT_FOREVER)
+		jiffies = MAX_SCHEDULE_TIMEOUT;
+	else
+		jiffies = msecs_to_jiffies(timeout);
+	
+	ret = down_timeout(sem, jiffies);
+	if (ret)
+		status = AE_TIME;
 
 	if (ACPI_FAILURE(status)) {
 		ACPI_DEBUG_PRINT((ACPI_DB_MUTEX,
@@ -986,7 +940,6 @@ acpi_status acpi_os_signal_semaphore(acpi_handle handle, u32 units)
 {
 	struct semaphore *sem = (struct semaphore *)handle;
 
-
 	if (!sem || (units < 1))
 		return AE_BAD_PARAMETER;
 
diff --git a/include/linux/semaphore.h b/include/linux/semaphore.h
index 88f2a28..a107aeb 100644
--- a/include/linux/semaphore.h
+++ b/include/linux/semaphore.h
@@ -75,6 +75,12 @@ extern int __must_check down_killable(struct semaphore *sem);
 extern int __must_check down_trylock(struct semaphore *sem);
 
 /*
+ * As down(), except this function will return -ETIME if it fails to
+ * acquire the semaphore within the specified number of jiffies.
+ */
+extern int __must_check down_timeout(struct semaphore *sem, long jiffies);
+
+/*
  * Release the semaphore.  Unlike mutexes, up() may be called from any
  * context and even by tasks which have never called down().
  */
diff --git a/kernel/semaphore.c b/kernel/semaphore.c
index 2da2aed..5a12a85 100644
--- a/kernel/semaphore.c
+++ b/kernel/semaphore.c
@@ -35,6 +35,7 @@
 static noinline void __down(struct semaphore *sem);
 static noinline int __down_interruptible(struct semaphore *sem);
 static noinline int __down_killable(struct semaphore *sem);
+static noinline int __down_timeout(struct semaphore *sem, long jiffies);
 static noinline void __up(struct semaphore *sem);
 
 void down(struct semaphore *sem)
@@ -104,6 +105,20 @@ int down_trylock(struct semaphore *sem)
 }
 EXPORT_SYMBOL(down_trylock);
 
+int down_timeout(struct semaphore *sem, long jiffies)
+{
+	unsigned long flags;
+	int result = 0;
+
+	spin_lock_irqsave(&sem->lock, flags);
+	if (unlikely(sem->count-- <= 0))
+		result = __down_timeout(sem, jiffies);
+	spin_unlock_irqrestore(&sem->lock, flags);
+
+	return result;
+}
+EXPORT_SYMBOL(down_timeout);
+
 void up(struct semaphore *sem)
 {
 	unsigned long flags;
@@ -142,10 +157,12 @@ static noinline void __sched __up_down_common(struct semaphore *sem)
 }
 
 /*
- * Because this function is inlined, the 'state' parameter will be constant,
- * and thus optimised away by the compiler.
+ * Because this function is inlined, the 'state' parameter will be
+ * constant, and thus optimised away by the compiler.  Likewise the
+ * 'timeout' parameter for the cases without timeouts.
  */
-static inline int __sched __down_common(struct semaphore *sem, long state)
+static inline int __sched __down_common(struct semaphore *sem, long state,
+								long timeout)
 {
 	int result = 0;
 	struct task_struct *task = current;
@@ -160,14 +177,20 @@ static inline int __sched __down_common(struct semaphore *sem, long state)
 			goto interrupted;
 		if (state == TASK_KILLABLE && fatal_signal_pending(task))
 			goto interrupted;
+		if (timeout <= 0)
+			goto timed_out;
 		__set_task_state(task, state);
 		spin_unlock_irq(&sem->lock);
-		schedule();
+		timeout = schedule_timeout(timeout);
 		spin_lock_irq(&sem->lock);
 		if (waiter.up)
 			goto woken;
 	}
 
+ timed_out:
+	list_del(&waiter.list);
+	result = -ETIME;
+	goto woken;
  interrupted:
 	list_del(&waiter.list);
 	result = -EINTR;
@@ -187,17 +210,22 @@ static inline int __sched __down_common(struct semaphore *sem, long state)
 
 static noinline void __sched __down(struct semaphore *sem)
 {
-	__down_common(sem, TASK_UNINTERRUPTIBLE);
+	__down_common(sem, TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
 }
 
 static noinline int __sched __down_interruptible(struct semaphore *sem)
 {
-	return __down_common(sem, TASK_INTERRUPTIBLE);
+	return __down_common(sem, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
 }
 
 static noinline int __sched __down_killable(struct semaphore *sem)
 {
-	return __down_common(sem, TASK_KILLABLE);
+	return __down_common(sem, TASK_KILLABLE, MAX_SCHEDULE_TIMEOUT);
+}
+
+static noinline int __sched __down_timeout(struct semaphore *sem, long jiffies)
+{
+	return __down_common(sem, TASK_UNINTERRUPTIBLE, jiffies);
 }
 
 static noinline void __sched __up(struct semaphore *sem)
-- 
1.5.4.3

