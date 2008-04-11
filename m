Return-Path: <linux-kernel-owner+w=401wt.eu-S1758317AbYDKTWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317AbYDKTWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 15:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757581AbYDKTV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 15:21:56 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:60868 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758220AbYDKTVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 15:21:55 -0400
Date: Fri, 11 Apr 2008 13:21:54 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: [DOC PATCH] semaphore documentation
Message-ID: <20080411192153.GH11962@parisc-linux.org>
References: <20080410143403.c03757e5.akpm@linux-foundation.org> <20080410220816.GY11962@parisc-linux.org> <20080410151907.91f11c74.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410151907.91f11c74.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 03:19:07PM -0700, Andrew Morton wrote:
> On Thu, 10 Apr 2008 16:08:16 -0600
> Matthew Wilcox <matthew@wil.cx> wrote:
> > It seems very strange to me to document the API with the implementation
> > rather than with the declaration.  It's almost as if we expect people to
> > have to read the implementation to figure out how stuff works.
> 
> That approach makes sense for C++.  But for C, the code is .c-centric.

I've never programmed in C++ ... I just expect to find API documentation
in header files.

> That's particularly the case with the kernel, where we explicitly work to
> make the .c files the things which people look at, while not caring about
> the .h files.  Look at how much we say "get that ifdef out of there and
> hide it in the header file".

I see that as being "move the complexity around" and "get the interfaces
right", not "hide it in the header files where nobody ever looks".

> > How about a note in semaphore.c that says "refer to semaphore.h for
> > usage information"?
> 
> No, please document it in the C file, where people expect to find it.

Fine, I've done it the other way round.

Please review this doc-patch.  Without comments, I'll commit it to the
semaphore git tree tomorrow.

diff --git a/include/linux/semaphore.h b/include/linux/semaphore.h
index a7125da..9cae64b 100644
--- a/include/linux/semaphore.h
+++ b/include/linux/semaphore.h
@@ -4,8 +4,7 @@
  *
  * Distributed under the terms of the GNU GPL, version 2
  *
- * Counting semaphores allow up to <n> tasks to acquire the semaphore
- * simultaneously.
+ * Please see kernel/semaphore.c for documentation of these functions
  */
 #ifndef __LINUX_SEMAPHORE_H
 #define __LINUX_SEMAPHORE_H
@@ -13,11 +12,7 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 
-/*
- * The spinlock controls access to the other members of the semaphore.
- * 'count' represents how many more tasks can acquire this semaphore.
- * Tasks waiting for the lock are kept on the wait_list.
- */
+/* Please don't access any members of this structure directly */
 struct semaphore {
 	spinlock_t		lock;
 	unsigned int		count;
@@ -46,41 +41,11 @@ static inline void sema_init(struct semaphore *sem, int val)
 #define init_MUTEX(sem)		sema_init(sem, 1)
 #define init_MUTEX_LOCKED(sem)	sema_init(sem, 0)
 
-/*
- * Attempt to acquire the semaphore.  If another task is already holding the
- * semaphore, sleep until the semaphore is released.
- */
 extern void down(struct semaphore *sem);
-
-/*
- * As down(), except the sleep may be interrupted by a signal.  If it is,
- * this function will return -EINTR.
- */
 extern int __must_check down_interruptible(struct semaphore *sem);
-
-/*
- * As down_interruptible(), except the sleep may only be interrupted by
- * signals which are fatal to this process.
- */
 extern int __must_check down_killable(struct semaphore *sem);
-
-/*
- * As down(), except this function will not sleep.  It will return 0 if it
- * acquired the semaphore and 1 if the semaphore was contended.  This
- * function may be called from any context, including interrupt and softirq.
- */
 extern int __must_check down_trylock(struct semaphore *sem);
-
-/*
- * As down(), except this function will return -ETIME if it fails to
- * acquire the semaphore within the specified number of jiffies.
- */
 extern int __must_check down_timeout(struct semaphore *sem, long jiffies);
-
-/*
- * Release the semaphore.  Unlike mutexes, up() may be called from any
- * context and even by tasks which have never called down().
- */
 extern void up(struct semaphore *sem);
 
 #endif /* __LINUX_SEMAPHORE_H */
diff --git a/kernel/semaphore.c b/kernel/semaphore.c
index bef977b..5c2942e 100644
--- a/kernel/semaphore.c
+++ b/kernel/semaphore.c
@@ -3,6 +3,26 @@
  * Author: Matthew Wilcox <willy@linux.intel.com>
  *
  * Distributed under the terms of the GNU GPL, version 2
+ *
+ * This file implements counting semaphores.
+ * A counting semaphore may be acquired 'n' times before sleeping.
+ * See mutex.c for single-acquisition sleeping locks which enforce
+ * rules which allow code to be debugged more easily.
+ */
+
+/*
+ * Some notes on the implementation:
+ *
+ * The spinlock controls access to the other members of the semaphore.
+ * down_trylock() and up() can be called from interrupt context, so we
+ * have to disable interrupts when taking the lock.  It turns out various
+ * parts of the kernel expect to be able to use down() on a semaphore in
+ * interrupt context when they know it will succeed, so we have to use
+ * irqsave variants for down(), down_interruptible() and down_killable()
+ * too.
+ *
+ * The ->count variable represents how many more tasks can acquire this
+ * semaphore.  If it's zero, there may be tasks waiting on the wait_list.
  */
 
 #include <linux/compiler.h>
@@ -12,22 +32,23 @@
 #include <linux/semaphore.h>
 #include <linux/spinlock.h>
 
-/*
- * Some notes on the implementation:
- *
- * down_trylock() and up() can be called from interrupt context.
- * So we have to disable interrupts when taking the lock.
- *
- * The ->count variable defines how many more tasks can acquire the
- * semaphore.  If it's zero, there may be tasks waiting on the list.
- */
-
 static noinline void __down(struct semaphore *sem);
 static noinline int __down_interruptible(struct semaphore *sem);
 static noinline int __down_killable(struct semaphore *sem);
 static noinline int __down_timeout(struct semaphore *sem, long jiffies);
 static noinline void __up(struct semaphore *sem);
 
+/**
+ * down - acquire the semaphore
+ * @sem: the semaphore to be acquired
+ *
+ * Acquires the semaphore.  If no more tasks are allowed to acquire the
+ * semaphore, calling this function will put the task to sleep until the
+ * semaphore is released.
+ *
+ * Use of this function is deprecated, please use down_interruptible() or
+ * down_killable() instead.
+ */
 void down(struct semaphore *sem)
 {
 	unsigned long flags;
@@ -41,6 +62,15 @@ void down(struct semaphore *sem)
 }
 EXPORT_SYMBOL(down);
 
+/**
+ * down_interruptible - acquire the semaphore unless interrupted
+ * @sem: the semaphore to be acquired
+ *
+ * Attempts to acquire the semaphore.  If no more tasks are allowed to
+ * acquire the semaphore, calling this function will put the task to sleep.
+ * If the sleep is interrupted by a signal, this function will return -EINTR.
+ * If the semaphore is successfully acquired, this function returns 0.
+ */
 int down_interruptible(struct semaphore *sem)
 {
 	unsigned long flags;
@@ -57,6 +87,16 @@ int down_interruptible(struct semaphore *sem)
 }
 EXPORT_SYMBOL(down_interruptible);
 
+/**
+ * down_killable - acquire the semaphore unless killed
+ * @sem: the semaphore to be acquired
+ *
+ * Attempts to acquire the semaphore.  If no more tasks are allowed to
+ * acquire the semaphore, calling this function will put the task to sleep.
+ * If the sleep is interrupted by a fatal signal, this function will return
+ * -EINTR.  If the semaphore is successfully acquired, this function returns
+ * 0.
+ */
 int down_killable(struct semaphore *sem)
 {
 	unsigned long flags;
@@ -78,7 +118,7 @@ EXPORT_SYMBOL(down_killable);
  * @sem: the semaphore to be acquired
  *
  * Try to acquire the semaphore atomically.  Returns 0 if the mutex has
- * been acquired successfully and 1 if it is contended.
+ * been acquired successfully or 1 if it it cannot be acquired.
  *
  * NOTE: This return value is inverted from both spin_trylock and
  * mutex_trylock!  Be careful about this when converting code.
@@ -101,6 +141,16 @@ int down_trylock(struct semaphore *sem)
 }
 EXPORT_SYMBOL(down_trylock);
 
+/**
+ * down_timeout - acquire the semaphore within a specified time
+ * @sem: the semaphore to be acquired
+ * @jiffies: how long to wait before failing
+ *
+ * Attempts to acquire the semaphore.  If no more tasks are allowed to
+ * acquire the semaphore, calling this function will put the task to sleep.
+ * If the semaphore is not released within the specified number of jiffies,
+ * this function returns -ETIME.  It returns 0 if the semaphore was acquired.
+ */
 int down_timeout(struct semaphore *sem, long jiffies)
 {
 	unsigned long flags;
@@ -117,6 +167,13 @@ int down_timeout(struct semaphore *sem, long jiffies)
 }
 EXPORT_SYMBOL(down_timeout);
 
+/**
+ * up - release the semaphore
+ * @sem: the semaphore to release
+ *
+ * Release the semaphore.  Unlike mutexes, up() may be called from any
+ * context and even by tasks which have never called down().
+ */
 void up(struct semaphore *sem)
 {
 	unsigned long flags;

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
