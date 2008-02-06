Return-Path: <linux-kernel-owner+w=401wt.eu-S1762769AbYBFDEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762769AbYBFDEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 22:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbYBFDE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 22:04:26 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:57444 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365AbYBFDEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 22:04:25 -0500
Date: Tue, 5 Feb 2008 20:04:23 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Andi Kleen <ak@suse.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: down_killable implementations for every architecture
Message-ID: <20080206030423.GD21509@parisc-linux.org>
References: <20080128231918.GB31101@parisc-linux.org> <200801290523.52993.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801290523.52993.ak@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 05:23:52AM +0100, Andi Kleen wrote:
> On Tuesday 29 January 2008 00:19, Matthew Wilcox wrote:
> > As part of the TASK_KILLABLE changes, we're going to need
> > down_killable().  Unfortunately, semaphores are implemented for every
> > architecture, which we should probably fix at some point.
> 
> It would be best to just change it now before doing further changes. Right now
> we have the bizarre situation that semaphores are more optimized
> with fast path inline assembly code than the far more critical spinlocks.
> But that clearly doesn't make much sense. So the best approach would
> be likely to just pick some generic C implementation from some architecture
> and use it everywhere.

We don't really have an appropriate one.  So I've invented my own.

 104 files changed, 338 insertions(+), 7335 deletions(-)

(and 228k).  That seems inappropriate to post.

Here's the whole patch (includes deletions from every architecture):
http://www.parisc-linux.org/~willy/generic-semaphore.diff

Here's the interesting/useful bit.  I've only tested it briefly on my
laptop -- it could be full of holes, but I've tried very hard to think
of all the interesting edge/race conditions with multiple
sleepers/wakers.

Please review.  I won't be around to respond to comments for another
four days.

diff --git a/include/linux/semaphore.h b/include/linux/semaphore.h
new file mode 100644
index 0000000..8e563bc
--- /dev/null
+++ b/include/linux/semaphore.h
@@ -0,0 +1,81 @@
+/*
+ * Copyright (c) 2008 Intel Corporation
+ * Author: Matthew Wilcox <willy@linux.intel.com>
+ *
+ * Distributed under the terms of the GNU GPL, version 2
+ *
+ * Counting semaphores allow up to <n> tasks to acquire the semaphore
+ * simultaneously.
+ */
+#ifndef __LINUX_SEMAPHORE_H
+#define __LINUX_SEMAPHORE_H
+
+#include <linux/list.h>
+#include <linux/spinlock.h>
+
+/*
+ * The spinlock controls access to the other members of the semaphore.
+ * 'count' is decremented by every task which calls down*() and incremented
+ * by every call to up().  Thus, if it is positive, it indicates how many
+ * more tasks may acquire the lock.  If it is negative, it indicates how
+ * many tasks are waiting for the lock.  Tasks waiting for the lock are
+ * kept on the wait_list.
+ */
+struct semaphore {
+	spinlock_t		lock;
+	int			count;
+	struct list_head	wait_list;
+};
+
+#define __SEMAPHORE_INITIALIZER(name, n)				\
+{									\
+	.lock		= __SPIN_LOCK_UNLOCKED((name).lock),		\
+	.count		= n,						\
+	.wait_list	= LIST_HEAD_INIT((name).wait_list),		\
+}
+
+#define __DECLARE_SEMAPHORE_GENERIC(name, count) \
+	struct semaphore name = __SEMAPHORE_INITIALIZER(name, count)
+
+#define DECLARE_MUTEX(name)	__DECLARE_SEMAPHORE_GENERIC(name, 1)
+ 
+static inline void sema_init(struct semaphore *sem, int val)
+{
+	*sem = (struct semaphore) __SEMAPHORE_INITIALIZER(*sem, val);
+}
+
+#define init_MUTEX(sem)		sema_init(sem, 1)
+#define init_MUTEX_LOCKED(sem)	sema_init(sem, 0)
+
+/*
+ * Attempt to acquire the semaphore.  If another task is already holding the
+ * semaphore, sleep until the semaphore is released.
+ */
+extern void fastcall down(struct semaphore *sem);
+
+/*
+ * As down(), except the sleep may be interrupted by a signal.  If it is,
+ * this function will return -EINTR.
+ */
+extern int __must_check fastcall down_interruptible(struct semaphore *sem);
+
+/*
+ * As down_interruptible(), except the sleep may only be interrupted by
+ * signals which are fatal to this process.
+ */
+extern int __must_check fastcall down_killable(struct semaphore *sem);
+
+/*
+ * As down, except this function will not sleep.  It will return 0 if it
+ * acquired the semaphore and 1 if the semaphore was contended.  This
+ * function may be called from any context, including interrupt and softirq.
+ */
+extern int __must_check fastcall down_trylock(struct semaphore *sem);
+
+/*
+ * Release the semaphore.  Unlike mutexes, up() may be called from any
+ * context and even by tasks which have never called down().
+ */
+extern void fastcall up(struct semaphore *sem);
+
+#endif /* __LINUX_SEMAPHORE_H */
diff --git a/kernel/semaphore.c b/kernel/semaphore.c
new file mode 100644
index 0000000..94f65a1
--- /dev/null
+++ b/kernel/semaphore.c
@@ -0,0 +1,208 @@
+/*
+ * Copyright (c) 2008 Intel Corporation
+ * Author: Matthew Wilcox <willy@linux.intel.com>
+ *
+ * Distributed under the terms of the GNU GPL, version 2
+ */
+
+#include <linux/compiler.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/semaphore.h>
+#include <linux/spinlock.h>
+
+/*
+ * Some notes on the implementation:
+ *
+ * down_trylock() and up() can be called from interrupt context.
+ * So we have to disable interrupts when taking the lock.
+ *
+ * The ->count variable, if positive, defines how many more tasks can
+ * acquire the semaphore.  If negative, it represents how many tasks are
+ * waiting on the semaphore (*).  If zero, no tasks are waiting, and no more
+ * tasks can acquire the semaphore.
+ *
+ * (*) Except for the window between one task calling up() and the task
+ * sleeping in a __down_common() waking up.  In order to avoid a third task
+ * coming in and stealing the second task's wakeup, we leave the ->count
+ * negative.  If we have a more complex situation, the ->count may become
+ * zero or negative (eg a semaphore with count = 2, three tasks attempt to
+ * acquire it, one sleeps, two finish and call up(), the second task to call
+ * up() notices that the list is empty and just increments count).
+ */
+
+static void fastcall noinline __down(struct semaphore *sem);
+static int fastcall noinline __down_interruptible(struct semaphore *sem);
+static int fastcall noinline __down_killable(struct semaphore *sem);
+static void fastcall noinline __up(struct semaphore *sem);
+
+void fastcall down(struct semaphore *sem)
+{
+	might_sleep();
+	spin_lock_irq(&sem->lock);
+	if (unlikely(sem->count-- <= 0))
+		__down(sem);
+	spin_unlock_irq(&sem->lock);
+}
+EXPORT_SYMBOL(down);
+
+int fastcall down_interruptible(struct semaphore *sem)
+{
+	int result = 0;
+	might_sleep();
+	spin_lock_irq(&sem->lock);
+	if (unlikely(sem->count-- <= 0))
+		result = __down_interruptible(sem);
+	spin_unlock_irq(&sem->lock);
+	return result;
+}
+EXPORT_SYMBOL(down_interruptible);
+
+int fastcall down_killable(struct semaphore *sem)
+{
+	int result = 0;
+	might_sleep();
+	spin_lock_irq(&sem->lock);
+	if (unlikely(sem->count-- <= 0))
+		result = __down_killable(sem);
+	spin_unlock_irq(&sem->lock);
+	return result;
+}
+EXPORT_SYMBOL(down_killable);
+
+/**
+ * down_trylock - try to acquire the semaphore, without waiting
+ * @sem: the semaphore to be acquired
+ *
+ * Try to acquire the semaphore atomically.  Returns 0 if the mutex has
+ * been acquired successfully and 1 if it is contended.
+ *
+ * NOTE: This return value is inverted from both spin_trylock and
+ * mutex_trylock!  Be careful about this when converting code.
+ *
+ * Unlike mutex_trylock, this function can be used from interrupt context,
+ * and the semaphore can be released by any task or interrupt.
+ */
+int fastcall down_trylock(struct semaphore *sem)
+{
+	unsigned long flags;
+	int count;
+
+	spin_lock_irqsave(&sem->lock, flags);
+	count = sem->count - 1;
+	if (likely(count >= 0))
+		sem->count = count;
+	spin_unlock_irqrestore(&sem->lock, flags);
+	return (count < 0);
+}
+EXPORT_SYMBOL(down_trylock);
+
+void fastcall up(struct semaphore *sem)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sem->lock, flags);
+	if (likely(sem->count >= 0))
+		sem->count++;
+	else
+		__up(sem);
+	spin_unlock_irqrestore(&sem->lock, flags);
+}
+EXPORT_SYMBOL(up);
+
+/* Functions for the contended case */
+
+struct semaphore_waiter {
+	struct list_head list;
+	struct task_struct *task;
+	int up;
+};
+
+/*
+ * Wake up a process waiting on a semaphore.  We need to call this from both
+ * __up and __down_common as it's possible to race a task into the semaphore
+ * if it comes in at just the right time between two tasks calling up() and
+ * a third task waking up.  This function assumes the wait_list is already
+ * checked for being non-empty.
+ */
+static void noinline __sched __up_down_common(struct semaphore *sem)
+{
+	struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,
+						struct semaphore_waiter, list);
+	list_del(&waiter->list);
+	waiter->up = 1;
+	wake_up_process(waiter->task);
+}
+
+/*
+ * Because this function is inlined, the 'state' parameter will be constant,
+ * and thus optimised away by the compiler.
+ */
+static inline int __sched __down_common(struct semaphore *sem, long state)
+{
+	int result = 0;
+	struct task_struct *task = current;
+	struct semaphore_waiter waiter;
+
+	list_add_tail(&waiter.list, &sem->wait_list);
+	waiter.task = task;
+	waiter.up = 0;
+
+	for (;;) {
+		if (unlikely((state == TASK_INTERRUPTIBLE &&
+					signal_pending(task)) ||
+			     (state == TASK_KILLABLE &&
+					fatal_signal_pending(task))))
+			goto interrupted;
+		__set_task_state(task, state);
+		spin_unlock_irq(&sem->lock);
+		schedule();
+		spin_lock_irq(&sem->lock);
+		if (waiter.up)
+			goto woken;
+	}
+
+ interrupted:
+	list_del(&waiter.list);
+	result = -EINTR;
+ woken:
+	/*
+	 * Account for the process which woke us up.  For the case where
+	 * we're interrupted, we need to increment the count on our own
+	 * behalf.  I don't believe we can hit the case where the
+	 * sem->count hits zero, *and* there's a second task sleeping,
+	 * but it doesn't hurt, that's not a commonly exercised path and
+	 * it's not a performance path either.
+	 */
+	if (unlikely((++sem->count >= 0) && !list_empty(&sem->wait_list)))
+		__up_down_common(sem);
+	return result;
+}
+
+static void fastcall noinline __sched
+__down(struct semaphore *sem)
+{
+	__down_common(sem, TASK_UNINTERRUPTIBLE);
+}
+
+static int fastcall noinline __sched
+__down_interruptible(struct semaphore *sem)
+{
+	return __down_common(sem, TASK_INTERRUPTIBLE);
+}
+
+static int fastcall noinline __sched
+__down_killable(struct semaphore *sem)
+{
+	return __down_common(sem, TASK_KILLABLE);
+}
+
+static void fastcall noinline __sched
+__up(struct semaphore *sem)
+{
+	if (unlikely(list_empty(&sem->wait_list)))
+		sem->count++;
+	else
+		__up_down_common(sem);
+}

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
