Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbZKBMHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbZKBMHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 07:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbZKBMHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 07:07:36 -0500
Received: from cantor.suse.de ([195.135.220.2]:53244 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606AbZKBMHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 07:07:35 -0500
Date: Mon, 2 Nov 2009 13:07:39 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch][rfc] x86, mutex: non-atomic unlock (and a rant)
Message-ID: <20091102120739.GA20318@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Chasing performance regressions, as usual (and not of the nice patch X
caused a n% slowdown type, but n% slowdown between a couple of years of
kernel releases, with few or no patches causing something above the
noise).

Unfortunately, our biggest competitors are our previous kernels, and
we (were?) really good at writing really fast kernels. And most of our
users who are running the competition are completely satisfied with
all the features it has[*], so an "upgrade" that causes a slowdown does
not go down well. A feature that 0.01% of people might use but causes
a 0.1% slowdown for everyone else... may not actually be a good idea.
Performance is a feature too, and every time we do this, we trade off
a little bit of that for things most people don't need.

[*] modulo hardware support perhaps

Anyway, end rant. Not much gets achieved by ranting, and seeing as I
can't just magic away overhead-causing features, then I've just been
looking for places to cut costs. So...

Non-atomic unlock for mutexs maybe? I do this by relying on cache
coherence on a cacheline basis for ordering rather than the memory
consistency of the x86. Linus I know you've told me this is an incorrect
assumption in the past, but I'm not so sure. If it is worthwhile, then
maybe we can ask the HW guys if we're allowed to do this? There are
actually other places where we could do similar tricks to avoid heavy
barriers...

In lmbench style syscall microbenchmarks I'm running, it is hard to
see much significant difference on a core2 with single threaded tests.
I'd say it could be very slightly favourable.

I also got rid of the more clever calling sequence when I was tinkering
with this patch which maybe could be added back in, although I didn't
like how it generated a short forward cond jump on success (to jump over
the fail_fn call).


---
 arch/x86/include/asm/mutex.h    |  105 ++++++++++++++++++++++++++++++++-
 arch/x86/include/asm/mutex_32.h |  125 ----------------------------------------
 arch/x86/include/asm/mutex_64.h |  100 --------------------------------
 include/linux/mutex.h           |    4 -
 kernel/mutex.c                  |   76 ++++++++----------------
 5 files changed, 132 insertions(+), 278 deletions(-)

Index: linux-2.6/arch/x86/include/asm/mutex.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mutex.h
+++ linux-2.6/arch/x86/include/asm/mutex.h
@@ -1,5 +1,104 @@
-#ifdef CONFIG_X86_32
-# include "mutex_32.h"
+/*
+ * Assembly implementation of the mutex fastpath, based on atomic
+ * decrement/increment.
+ *
+ * started by Ingo Molnar:
+ *
+ *  Copyright (C) 2004, 2005, 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
+ */
+#ifndef _ASM_X86_MUTEX_H
+#define _ASM_X86_MUTEX_H
+
+/**
+ *  __mutex_fastpath_lock - try to take the lock by moving the count
+ *                          from 1 to a 0 value
+ *  @count: pointer of type atomic_t
+ *  @fn: function to call if the original value was not 1
+ *
+ * Change the count from 1 to a value lower than 1, and call <fn> if it
+ * wasn't 1 originally. This function MUST leave the value lower than 1
+ * even when the "1" assertion wasn't true.
+ */
+static inline void __mutex_fastpath_lock(struct mutex *lock,
+					       void (*fail_fn)(struct mutex *))
+{
+	if (unlikely(atomic_dec_return(&lock->count) < 0))
+		fail_fn(lock);
+}
+
+/**
+ *  __mutex_fastpath_lock_retval - try to take the lock by moving the count
+ *                                 from 1 to a 0 value
+ *  @count: pointer of type atomic_t
+ *  @fail_fn: function to call if the original value was not 1
+ *
+ * Change the count from 1 to a value lower than 1, and call <fail_fn> if it
+ * wasn't 1 originally. This function returns 0 if the fastpath succeeds,
+ * or anything the slow path function returns
+ */
+static inline int __mutex_fastpath_lock_retval(struct mutex *lock,
+					       int (*fail_fn)(struct mutex *))
+{
+	if (unlikely(atomic_dec_return(&lock->count) < 0))
+		return fail_fn(lock);
+	else
+		return 0;
+}
+
+/**
+ *  __mutex_fastpath_unlock - try to promote the mutex from 0 to 1
+ *  @count: pointer of type atomic_t
+ *  @fail_fn: function to call if the original value was not 0
+ *
+ * try to promote the mutex from 0 to 1. if it wasn't 0, call <fail_fn>.
+ * In the failure case, this function is allowed to either set the value
+ * to 1, or to set it to a value lower than 1.
+ *
+ * If the implementation sets it to a value of lower than 1, the
+ * __mutex_slowpath_needs_to_unlock() macro needs to return 1, it needs
+ * to return 0 otherwise.
+ */
+static inline void __mutex_fastpath_unlock(struct mutex *lock,
+					       void (*fail_fn)(struct mutex *))
+{
+	atomic_set(&lock->count, 1);
+	barrier();
+	if (unlikely(lock->waiters))
+		fail_fn(lock);
+}
+
+/**
+ * __mutex_fastpath_trylock - try to acquire the mutex, without waiting
+ *
+ *  @count: pointer of type atomic_t
+ *  @fail_fn: fallback function
+ *
+ * Change the count from 1 to a value lower than 1, and return 0 (failure)
+ * if it wasn't 1 originally, or return 1 (success) otherwise. This function
+ * MUST leave the value lower than 1 even when the "1" assertion wasn't true.
+ * Additionally, if the value was < 0 originally, this function must not leave
+ * it to 0 on failure.
+ */
+static inline int __mutex_fastpath_trylock(struct mutex *lock,
+					   int (*fail_fn)(struct mutex *))
+{
+	/*
+	 * We have two variants here. The cmpxchg based one is the best one
+	 * because it never induce a false contention state.  It is included
+	 * here because architectures using the inc/dec algorithms over the
+	 * xchg ones are much more likely to support cmpxchg natively.
+	 *
+	 * If not we fall back to the spinlock based variant - that is
+	 * just as efficient (and simpler) as a 'destructive' probing of
+	 * the mutex state would be.
+	 */
+#ifdef __HAVE_ARCH_CMPXCHG
+	if (likely(atomic_cmpxchg(&lock->count, 1, 0) == 1))
+		return 1;
+	return 0;
 #else
-# include "mutex_64.h"
+	return fail_fn(&lock->count);
 #endif
+}
+
+#endif /* _ASM_X86_MUTEX_H */
Index: linux-2.6/arch/x86/include/asm/mutex_32.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mutex_32.h
+++ /dev/null
@@ -1,125 +0,0 @@
-/*
- * Assembly implementation of the mutex fastpath, based on atomic
- * decrement/increment.
- *
- * started by Ingo Molnar:
- *
- *  Copyright (C) 2004, 2005, 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
- */
-#ifndef _ASM_X86_MUTEX_32_H
-#define _ASM_X86_MUTEX_32_H
-
-#include <asm/alternative.h>
-
-/**
- *  __mutex_fastpath_lock - try to take the lock by moving the count
- *                          from 1 to a 0 value
- *  @count: pointer of type atomic_t
- *  @fn: function to call if the original value was not 1
- *
- * Change the count from 1 to a value lower than 1, and call <fn> if it
- * wasn't 1 originally. This function MUST leave the value lower than 1
- * even when the "1" assertion wasn't true.
- */
-#define __mutex_fastpath_lock(count, fail_fn)			\
-do {								\
-	unsigned int dummy;					\
-								\
-	typecheck(atomic_t *, count);				\
-	typecheck_fn(void (*)(atomic_t *), fail_fn);		\
-								\
-	asm volatile(LOCK_PREFIX "   decl (%%eax)\n"		\
-		     "   jns 1f	\n"				\
-		     "   call " #fail_fn "\n"			\
-		     "1:\n"					\
-		     : "=a" (dummy)				\
-		     : "a" (count)				\
-		     : "memory", "ecx", "edx");			\
-} while (0)
-
-
-/**
- *  __mutex_fastpath_lock_retval - try to take the lock by moving the count
- *                                 from 1 to a 0 value
- *  @count: pointer of type atomic_t
- *  @fail_fn: function to call if the original value was not 1
- *
- * Change the count from 1 to a value lower than 1, and call <fail_fn> if it
- * wasn't 1 originally. This function returns 0 if the fastpath succeeds,
- * or anything the slow path function returns
- */
-static inline int __mutex_fastpath_lock_retval(atomic_t *count,
-					       int (*fail_fn)(atomic_t *))
-{
-	if (unlikely(atomic_dec_return(count) < 0))
-		return fail_fn(count);
-	else
-		return 0;
-}
-
-/**
- *  __mutex_fastpath_unlock - try to promote the mutex from 0 to 1
- *  @count: pointer of type atomic_t
- *  @fail_fn: function to call if the original value was not 0
- *
- * try to promote the mutex from 0 to 1. if it wasn't 0, call <fail_fn>.
- * In the failure case, this function is allowed to either set the value
- * to 1, or to set it to a value lower than 1.
- *
- * If the implementation sets it to a value of lower than 1, the
- * __mutex_slowpath_needs_to_unlock() macro needs to return 1, it needs
- * to return 0 otherwise.
- */
-#define __mutex_fastpath_unlock(count, fail_fn)			\
-do {								\
-	unsigned int dummy;					\
-								\
-	typecheck(atomic_t *, count);				\
-	typecheck_fn(void (*)(atomic_t *), fail_fn);		\
-								\
-	asm volatile(LOCK_PREFIX "   incl (%%eax)\n"		\
-		     "   jg	1f\n"				\
-		     "   call " #fail_fn "\n"			\
-		     "1:\n"					\
-		     : "=a" (dummy)				\
-		     : "a" (count)				\
-		     : "memory", "ecx", "edx");			\
-} while (0)
-
-#define __mutex_slowpath_needs_to_unlock()	1
-
-/**
- * __mutex_fastpath_trylock - try to acquire the mutex, without waiting
- *
- *  @count: pointer of type atomic_t
- *  @fail_fn: fallback function
- *
- * Change the count from 1 to a value lower than 1, and return 0 (failure)
- * if it wasn't 1 originally, or return 1 (success) otherwise. This function
- * MUST leave the value lower than 1 even when the "1" assertion wasn't true.
- * Additionally, if the value was < 0 originally, this function must not leave
- * it to 0 on failure.
- */
-static inline int __mutex_fastpath_trylock(atomic_t *count,
-					   int (*fail_fn)(atomic_t *))
-{
-	/*
-	 * We have two variants here. The cmpxchg based one is the best one
-	 * because it never induce a false contention state.  It is included
-	 * here because architectures using the inc/dec algorithms over the
-	 * xchg ones are much more likely to support cmpxchg natively.
-	 *
-	 * If not we fall back to the spinlock based variant - that is
-	 * just as efficient (and simpler) as a 'destructive' probing of
-	 * the mutex state would be.
-	 */
-#ifdef __HAVE_ARCH_CMPXCHG
-	if (likely(atomic_cmpxchg(count, 1, 0) == 1))
-		return 1;
-	return 0;
-#else
-	return fail_fn(count);
-#endif
-}
-
-#endif /* _ASM_X86_MUTEX_32_H */
Index: linux-2.6/include/linux/mutex.h
===================================================================
--- linux-2.6.orig/include/linux/mutex.h
+++ linux-2.6/include/linux/mutex.h
@@ -48,6 +48,7 @@
 struct mutex {
 	/* 1: unlocked, 0: locked, negative: locked, possible waiters */
 	atomic_t		count;
+	unsigned int		waiters;
 	spinlock_t		wait_lock;
 	struct list_head	wait_list;
 #if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_SMP)
@@ -60,7 +61,8 @@ struct mutex {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
 #endif
-};
+} __attribute__((aligned(sizeof(atomic_t)+sizeof(unsigned int))));
+  /* first 2 atomics must be in the same cacheline */
 
 /*
  * This is the control structure for tasks blocked on mutex,
Index: linux-2.6/kernel/mutex.c
===================================================================
--- linux-2.6.orig/kernel/mutex.c
+++ linux-2.6/kernel/mutex.c
@@ -49,6 +49,7 @@ void
 __mutex_init(struct mutex *lock, const char *name, struct lock_class_key *key)
 {
 	atomic_set(&lock->count, 1);
+	lock->waiters = 0;
 	spin_lock_init(&lock->wait_lock);
 	INIT_LIST_HEAD(&lock->wait_list);
 	mutex_clear_owner(lock);
@@ -66,7 +67,7 @@ EXPORT_SYMBOL(__mutex_init);
  * branch is predicted by the CPU as default-untaken.
  */
 static __used noinline void __sched
-__mutex_lock_slowpath(atomic_t *lock_count);
+__mutex_lock_slowpath(struct mutex *lock);
 
 /***
  * mutex_lock - acquire the mutex
@@ -96,14 +97,14 @@ void __sched mutex_lock(struct mutex *lo
 	 * The locking fastpath is the 1->0 transition from
 	 * 'unlocked' into 'locked' state.
 	 */
-	__mutex_fastpath_lock(&lock->count, __mutex_lock_slowpath);
+	if (unlikely(!atomic_dec_and_test(&lock->count)))
+		__mutex_lock_slowpath(lock);
 	mutex_set_owner(lock);
 }
-
 EXPORT_SYMBOL(mutex_lock);
 #endif
 
-static __used noinline void __sched __mutex_unlock_slowpath(atomic_t *lock_count);
+static __used noinline void __sched __mutex_unlock_slowpath(struct mutex *lock);
 
 /***
  * mutex_unlock - release the mutex
@@ -130,9 +131,8 @@ void __sched mutex_unlock(struct mutex *
 	 */
 	mutex_clear_owner(lock);
 #endif
-	__mutex_fastpath_unlock(&lock->count, __mutex_unlock_slowpath);
+	__mutex_fastpath_unlock(lock, __mutex_unlock_slowpath);
 }
-
 EXPORT_SYMBOL(mutex_unlock);
 
 /*
@@ -228,14 +228,19 @@ __mutex_lock_common(struct mutex *lock,
 		 * that when we release the lock, we properly wake up the
 		 * other waiters:
 		 */
-		if (atomic_xchg(&lock->count, -1) == 1)
+		lock->waiters++;
+		barrier();
+		if (atomic_xchg(&lock->count, -1) == 1) {
+			lock->waiters--;
 			break;
+		}
 
 		/*
 		 * got a signal? (This code gets eliminated in the
 		 * TASK_UNINTERRUPTIBLE case.)
 		 */
 		if (unlikely(signal_pending_state(state, task))) {
+			lock->waiters--;
 			mutex_remove_waiter(lock, &waiter,
 					    task_thread_info(task));
 			mutex_release(&lock->dep_map, 1, ip);
@@ -253,6 +258,7 @@ __mutex_lock_common(struct mutex *lock,
 		schedule();
 		preempt_disable();
 		spin_lock_mutex(&lock->wait_lock, flags);
+		lock->waiters--;
 	}
 
 done:
@@ -261,10 +267,6 @@ done:
 	mutex_remove_waiter(lock, &waiter, current_thread_info());
 	mutex_set_owner(lock);
 
-	/* set it to 0 if there are no waiters left: */
-	if (likely(list_empty(&lock->wait_list)))
-		atomic_set(&lock->count, 0);
-
 	spin_unlock_mutex(&lock->wait_lock, flags);
 
 	debug_mutex_free_waiter(&waiter);
@@ -280,7 +282,6 @@ mutex_lock_nested(struct mutex *lock, un
 	might_sleep();
 	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, subclass, _RET_IP_);
 }
-
 EXPORT_SYMBOL_GPL(mutex_lock_nested);
 
 int __sched
@@ -298,7 +299,6 @@ mutex_lock_interruptible_nested(struct m
 	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE,
 				   subclass, _RET_IP_);
 }
-
 EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
 #endif
 
@@ -306,23 +306,14 @@ EXPORT_SYMBOL_GPL(mutex_lock_interruptib
  * Release the lock, slowpath:
  */
 static inline void
-__mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
+__mutex_unlock_common_slowpath(struct mutex *lock, int nested)
 {
-	struct mutex *lock = container_of(lock_count, struct mutex, count);
 	unsigned long flags;
 
 	spin_lock_mutex(&lock->wait_lock, flags);
 	mutex_release(&lock->dep_map, nested, _RET_IP_);
 	debug_mutex_unlock(lock);
 
-	/*
-	 * some architectures leave the lock unlocked in the fastpath failure
-	 * case, others need to leave it locked. In the later case we have to
-	 * unlock it here
-	 */
-	if (__mutex_slowpath_needs_to_unlock())
-		atomic_set(&lock->count, 1);
-
 	if (!list_empty(&lock->wait_list)) {
 		/* get the first entry from the wait-list: */
 		struct mutex_waiter *waiter =
@@ -341,9 +332,9 @@ __mutex_unlock_common_slowpath(atomic_t
  * Release the lock, slowpath:
  */
 static __used noinline void
-__mutex_unlock_slowpath(atomic_t *lock_count)
+__mutex_unlock_slowpath(struct mutex *lock)
 {
-	__mutex_unlock_common_slowpath(lock_count, 1);
+	__mutex_unlock_common_slowpath(lock, 1);
 }
 
 #ifndef CONFIG_DEBUG_LOCK_ALLOC
@@ -352,10 +343,10 @@ __mutex_unlock_slowpath(atomic_t *lock_c
  * mutex_lock_interruptible() and mutex_trylock().
  */
 static noinline int __sched
-__mutex_lock_killable_slowpath(atomic_t *lock_count);
+__mutex_lock_killable_slowpath(struct mutex *lock);
 
 static noinline int __sched
-__mutex_lock_interruptible_slowpath(atomic_t *lock_count);
+__mutex_lock_interruptible_slowpath(struct mutex *lock);
 
 /***
  * mutex_lock_interruptible - acquire the mutex, interruptable
@@ -373,8 +364,8 @@ int __sched mutex_lock_interruptible(str
 	int ret;
 
 	might_sleep();
-	ret =  __mutex_fastpath_lock_retval
-			(&lock->count, __mutex_lock_interruptible_slowpath);
+	ret =  __mutex_fastpath_lock_retval(lock,
+				__mutex_lock_interruptible_slowpath);
 	if (!ret)
 		mutex_set_owner(lock);
 
@@ -388,8 +379,8 @@ int __sched mutex_lock_killable(struct m
 	int ret;
 
 	might_sleep();
-	ret = __mutex_fastpath_lock_retval
-			(&lock->count, __mutex_lock_killable_slowpath);
+	ret = __mutex_fastpath_lock_retval(lock,
+				__mutex_lock_killable_slowpath);
 	if (!ret)
 		mutex_set_owner(lock);
 
@@ -398,26 +389,20 @@ int __sched mutex_lock_killable(struct m
 EXPORT_SYMBOL(mutex_lock_killable);
 
 static __used noinline void __sched
-__mutex_lock_slowpath(atomic_t *lock_count)
+__mutex_lock_slowpath(struct mutex *lock)
 {
-	struct mutex *lock = container_of(lock_count, struct mutex, count);
-
 	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, _RET_IP_);
 }
 
 static noinline int __sched
-__mutex_lock_killable_slowpath(atomic_t *lock_count)
+__mutex_lock_killable_slowpath(struct mutex *lock)
 {
-	struct mutex *lock = container_of(lock_count, struct mutex, count);
-
 	return __mutex_lock_common(lock, TASK_KILLABLE, 0, _RET_IP_);
 }
 
 static noinline int __sched
-__mutex_lock_interruptible_slowpath(atomic_t *lock_count)
+__mutex_lock_interruptible_slowpath(struct mutex *lock)
 {
-	struct mutex *lock = container_of(lock_count, struct mutex, count);
-
 	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0, _RET_IP_);
 }
 #endif
@@ -426,24 +411,17 @@ __mutex_lock_interruptible_slowpath(atom
  * Spinlock based trylock, we take the spinlock and check whether we
  * can get the lock:
  */
-static inline int __mutex_trylock_slowpath(atomic_t *lock_count)
+static inline int __mutex_trylock_slowpath(struct mutex *lock)
 {
-	struct mutex *lock = container_of(lock_count, struct mutex, count);
 	unsigned long flags;
 	int prev;
 
 	spin_lock_mutex(&lock->wait_lock, flags);
-
 	prev = atomic_xchg(&lock->count, -1);
 	if (likely(prev == 1)) {
 		mutex_set_owner(lock);
 		mutex_acquire(&lock->dep_map, 0, 1, _RET_IP_);
 	}
-
-	/* Set it back to 0 if there are no waiters: */
-	if (likely(list_empty(&lock->wait_list)))
-		atomic_set(&lock->count, 0);
-
 	spin_unlock_mutex(&lock->wait_lock, flags);
 
 	return prev == 1;
@@ -467,7 +445,7 @@ int __sched mutex_trylock(struct mutex *
 {
 	int ret;
 
-	ret = __mutex_fastpath_trylock(&lock->count, __mutex_trylock_slowpath);
+	ret = __mutex_fastpath_trylock(lock, __mutex_trylock_slowpath);
 	if (ret)
 		mutex_set_owner(lock);
 
Index: linux-2.6/arch/x86/include/asm/mutex_64.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mutex_64.h
+++ /dev/null
@@ -1,100 +0,0 @@
-/*
- * Assembly implementation of the mutex fastpath, based on atomic
- * decrement/increment.
- *
- * started by Ingo Molnar:
- *
- *  Copyright (C) 2004, 2005, 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
- */
-#ifndef _ASM_X86_MUTEX_64_H
-#define _ASM_X86_MUTEX_64_H
-
-/**
- * __mutex_fastpath_lock - decrement and call function if negative
- * @v: pointer of type atomic_t
- * @fail_fn: function to call if the result is negative
- *
- * Atomically decrements @v and calls <fail_fn> if the result is negative.
- */
-#define __mutex_fastpath_lock(v, fail_fn)			\
-do {								\
-	unsigned long dummy;					\
-								\
-	typecheck(atomic_t *, v);				\
-	typecheck_fn(void (*)(atomic_t *), fail_fn);		\
-								\
-	asm volatile(LOCK_PREFIX "   decl (%%rdi)\n"		\
-		     "   jns 1f		\n"			\
-		     "   call " #fail_fn "\n"			\
-		     "1:"					\
-		     : "=D" (dummy)				\
-		     : "D" (v)					\
-		     : "rax", "rsi", "rdx", "rcx",		\
-		       "r8", "r9", "r10", "r11", "memory");	\
-} while (0)
-
-/**
- *  __mutex_fastpath_lock_retval - try to take the lock by moving the count
- *                                 from 1 to a 0 value
- *  @count: pointer of type atomic_t
- *  @fail_fn: function to call if the original value was not 1
- *
- * Change the count from 1 to a value lower than 1, and call <fail_fn> if
- * it wasn't 1 originally. This function returns 0 if the fastpath succeeds,
- * or anything the slow path function returns
- */
-static inline int __mutex_fastpath_lock_retval(atomic_t *count,
-					       int (*fail_fn)(atomic_t *))
-{
-	if (unlikely(atomic_dec_return(count) < 0))
-		return fail_fn(count);
-	else
-		return 0;
-}
-
-/**
- * __mutex_fastpath_unlock - increment and call function if nonpositive
- * @v: pointer of type atomic_t
- * @fail_fn: function to call if the result is nonpositive
- *
- * Atomically increments @v and calls <fail_fn> if the result is nonpositive.
- */
-#define __mutex_fastpath_unlock(v, fail_fn)			\
-do {								\
-	unsigned long dummy;					\
-								\
-	typecheck(atomic_t *, v);				\
-	typecheck_fn(void (*)(atomic_t *), fail_fn);		\
-								\
-	asm volatile(LOCK_PREFIX "   incl (%%rdi)\n"		\
-		     "   jg 1f\n"				\
-		     "   call " #fail_fn "\n"			\
-		     "1:"					\
-		     : "=D" (dummy)				\
-		     : "D" (v)					\
-		     : "rax", "rsi", "rdx", "rcx",		\
-		       "r8", "r9", "r10", "r11", "memory");	\
-} while (0)
-
-#define __mutex_slowpath_needs_to_unlock()	1
-
-/**
- * __mutex_fastpath_trylock - try to acquire the mutex, without waiting
- *
- *  @count: pointer of type atomic_t
- *  @fail_fn: fallback function
- *
- * Change the count from 1 to 0 and return 1 (success), or return 0 (failure)
- * if it wasn't 1 originally. [the fallback function is never used on
- * x86_64, because all x86_64 CPUs have a CMPXCHG instruction.]
- */
-static inline int __mutex_fastpath_trylock(atomic_t *count,
-					   int (*fail_fn)(atomic_t *))
-{
-	if (likely(atomic_cmpxchg(count, 1, 0) == 1))
-		return 1;
-	else
-		return 0;
-}
-
-#endif /* _ASM_X86_MUTEX_64_H */
