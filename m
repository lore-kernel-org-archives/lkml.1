Return-Path: <linux-kernel-owner+w=401wt.eu-S1757782AbYCNVdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782AbYCNVdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 17:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646AbYCNVd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 17:33:28 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:58298 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbYCNVd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 17:33:28 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au, lenb@kernel.org,
       dhowells@redhat.com, peterz@infradead.org, mingo@elte.hu,
       harvey.harrison@gmail.com
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 6/6] Simplify semaphore implementation
Date: Fri, 14 Mar 2008 16:44:53 -0400
Message-Id: <1205527493-5740-6-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1205527493-5740-5-git-send-email-matthew@wil.cx>
References: <20080314204248.GV613@parisc-linux.org>
 <1205527493-5740-1-git-send-email-matthew@wil.cx>
 <1205527493-5740-2-git-send-email-matthew@wil.cx>
 <1205527493-5740-3-git-send-email-matthew@wil.cx>
 <1205527493-5740-4-git-send-email-matthew@wil.cx>
 <1205527493-5740-5-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By removing the negative values of 'count' and relying on the wait_list to
indicate whether we have any waiters, we can simplify the implementation
by removing the protection against an unlikely race condition.  Thanks to
David Howells for his suggestions.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 include/linux/semaphore.h |    9 ++---
 kernel/semaphore.c        |   78 ++++++++++++++-------------------------------
 2 files changed, 27 insertions(+), 60 deletions(-)

diff --git a/include/linux/semaphore.h b/include/linux/semaphore.h
index a107aeb..a7125da 100644
--- a/include/linux/semaphore.h
+++ b/include/linux/semaphore.h
@@ -15,15 +15,12 @@
 
 /*
  * The spinlock controls access to the other members of the semaphore.
- * 'count' is decremented by every task which calls down*() and incremented
- * by every call to up().  Thus, if it is positive, it indicates how many
- * more tasks may acquire the lock.  If it is negative, it indicates how
- * many tasks are waiting for the lock.  Tasks waiting for the lock are
- * kept on the wait_list.
+ * 'count' represents how many more tasks can acquire this semaphore.
+ * Tasks waiting for the lock are kept on the wait_list.
  */
 struct semaphore {
 	spinlock_t		lock;
-	int			count;
+	unsigned int		count;
 	struct list_head	wait_list;
 };
 
diff --git a/kernel/semaphore.c b/kernel/semaphore.c
index 5a12a85..bef977b 100644
--- a/kernel/semaphore.c
+++ b/kernel/semaphore.c
@@ -18,18 +18,8 @@
  * down_trylock() and up() can be called from interrupt context.
  * So we have to disable interrupts when taking the lock.
  *
- * The ->count variable, if positive, defines how many more tasks can
- * acquire the semaphore.  If negative, it represents how many tasks are
- * waiting on the semaphore (*).  If zero, no tasks are waiting, and no more
- * tasks can acquire the semaphore.
- *
- * (*) Except for the window between one task calling up() and the task
- * sleeping in a __down_common() waking up.  In order to avoid a third task
- * coming in and stealing the second task's wakeup, we leave the ->count
- * negative.  If we have a more complex situation, the ->count may become
- * zero or negative (eg a semaphore with count = 2, three tasks attempt to
- * acquire it, one sleeps, two finish and call up(), the second task to call
- * up() notices that the list is empty and just increments count).
+ * The ->count variable defines how many more tasks can acquire the
+ * semaphore.  If it's zero, there may be tasks waiting on the list.
  */
 
 static noinline void __down(struct semaphore *sem);
@@ -43,7 +33,9 @@ void down(struct semaphore *sem)
 	unsigned long flags;
 
 	spin_lock_irqsave(&sem->lock, flags);
-	if (unlikely(sem->count-- <= 0))
+	if (likely(sem->count > 0))
+		sem->count--;
+	else
 		__down(sem);
 	spin_unlock_irqrestore(&sem->lock, flags);
 }
@@ -55,7 +47,9 @@ int down_interruptible(struct semaphore *sem)
 	int result = 0;
 
 	spin_lock_irqsave(&sem->lock, flags);
-	if (unlikely(sem->count-- <= 0))
+	if (likely(sem->count > 0))
+		sem->count--;
+	else
 		result = __down_interruptible(sem);
 	spin_unlock_irqrestore(&sem->lock, flags);
 
@@ -69,7 +63,9 @@ int down_killable(struct semaphore *sem)
 	int result = 0;
 
 	spin_lock_irqsave(&sem->lock, flags);
-	if (unlikely(sem->count-- <= 0))
+	if (likely(sem->count > 0))
+		sem->count--;
+	else
 		result = __down_killable(sem);
 	spin_unlock_irqrestore(&sem->lock, flags);
 
@@ -111,7 +107,9 @@ int down_timeout(struct semaphore *sem, long jiffies)
 	int result = 0;
 
 	spin_lock_irqsave(&sem->lock, flags);
-	if (unlikely(sem->count-- <= 0))
+	if (likely(sem->count > 0))
+		sem->count--;
+	else
 		result = __down_timeout(sem, jiffies);
 	spin_unlock_irqrestore(&sem->lock, flags);
 
@@ -124,7 +122,7 @@ void up(struct semaphore *sem)
 	unsigned long flags;
 
 	spin_lock_irqsave(&sem->lock, flags);
-	if (likely(sem->count >= 0))
+	if (likely(list_empty(&sem->wait_list)))
 		sem->count++;
 	else
 		__up(sem);
@@ -141,22 +139,6 @@ struct semaphore_waiter {
 };
 
 /*
- * Wake up a process waiting on a semaphore.  We need to call this from both
- * __up and __down_common as it's possible to race a task into the semaphore
- * if it comes in at just the right time between two tasks calling up() and
- * a third task waking up.  This function assumes the wait_list is already
- * checked for being non-empty.
- */
-static noinline void __sched __up_down_common(struct semaphore *sem)
-{
-	struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,
-						struct semaphore_waiter, list);
-	list_del(&waiter->list);
-	waiter->up = 1;
-	wake_up_process(waiter->task);
-}
-
-/*
  * Because this function is inlined, the 'state' parameter will be
  * constant, and thus optimised away by the compiler.  Likewise the
  * 'timeout' parameter for the cases without timeouts.
@@ -164,7 +146,6 @@ static noinline void __sched __up_down_common(struct semaphore *sem)
 static inline int __sched __down_common(struct semaphore *sem, long state,
 								long timeout)
 {
-	int result = 0;
 	struct task_struct *task = current;
 	struct semaphore_waiter waiter;
 
@@ -184,28 +165,16 @@ static inline int __sched __down_common(struct semaphore *sem, long state,
 		timeout = schedule_timeout(timeout);
 		spin_lock_irq(&sem->lock);
 		if (waiter.up)
-			goto woken;
+			return 0;
 	}
 
  timed_out:
 	list_del(&waiter.list);
-	result = -ETIME;
-	goto woken;
+	return -ETIME;
+
  interrupted:
 	list_del(&waiter.list);
-	result = -EINTR;
- woken:
-	/*
-	 * Account for the process which woke us up.  For the case where
-	 * we're interrupted, we need to increment the count on our own
-	 * behalf.  I don't believe we can hit the case where the
-	 * sem->count hits zero, *and* there's a second task sleeping,
-	 * but it doesn't hurt, that's not a commonly exercised path and
-	 * it's not a performance path either.
-	 */
-	if (unlikely((++sem->count >= 0) && !list_empty(&sem->wait_list)))
-		__up_down_common(sem);
-	return result;
+	return -EINTR;
 }
 
 static noinline void __sched __down(struct semaphore *sem)
@@ -230,8 +199,9 @@ static noinline int __sched __down_timeout(struct semaphore *sem, long jiffies)
 
 static noinline void __sched __up(struct semaphore *sem)
 {
-	if (unlikely(list_empty(&sem->wait_list)))
-		sem->count++;
-	else
-		__up_down_common(sem);
+	struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,
+						struct semaphore_waiter, list);
+	list_del(&waiter->list);
+	waiter->up = 1;
+	wake_up_process(waiter->task);
 }
-- 
1.5.4.3

