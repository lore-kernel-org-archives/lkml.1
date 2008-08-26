Return-Path: <linux-kernel-owner+w=401wt.eu-S1759545AbYHZTAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbYHZTAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758727AbYHZS7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 14:59:51 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:50597 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757560AbYHZS7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 14:59:49 -0400
From: Daniel Walker <dwalker@mvista.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Matthew Wilcox <matthew@wil.cx>, Len Brown <len.brown@intel.com>,
       Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org
Subject: [PATCH 1/4] mutex: add mutex_lock_timeout()
Date: Tue, 26 Aug 2008 11:59:46 -0700
Message-Id: <1219777186-4787-1-git-send-email-dwalker@mvista.com>
X-Mailer: git-send-email 1.5.5.1.32.gba7d2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds mutex_lock_timeout() (and mutex_lock_timeout_nested()) used inside ACPI.

Cc: linux-acpi@vger.kernel.org
Signed-off-by: Daniel Walker <dwalker@mvista.com>
---
 include/asm-generic/mutex-dec.h  |   23 ++++++++++++
 include/asm-generic/mutex-null.h |    3 ++
 include/asm-generic/mutex-xchg.h |   23 ++++++++++++
 include/asm-x86/mutex_32.h       |   21 +++++++++++
 include/asm-x86/mutex_64.h       |   21 +++++++++++
 include/linux/mutex.h            |    8 ++++
 kernel/mutex.c                   |   70 +++++++++++++++++++++++++++++++++-----
 7 files changed, 160 insertions(+), 9 deletions(-)

diff --git a/include/asm-generic/mutex-dec.h b/include/asm-generic/mutex-dec.h
index ed108be..eddc8c4 100644
--- a/include/asm-generic/mutex-dec.h
+++ b/include/asm-generic/mutex-dec.h
@@ -109,4 +109,27 @@ __mutex_fastpath_trylock(atomic_t *count, int (*fail_fn)(atomic_t *))
 #endif
 }
 
+/**
+ *  __mutex_fastpath_lock_timeout - try to take the lock by moving the count
+ *                                  from 1 to a 0 value
+ *  @count: pointer of type atomic_t
+ *  @fail_fn: function to call if the original value was not 1
+ *  	      This function will need to accept two arguments.
+ *  @timeout: Timeout value as second argument to fail_fn.
+ *
+ * Change the count from 1 to a value lower than 1, and call <fail_fn> if
+ * it wasn't 1 originally. This function returns 0 if the fastpath succeeds,
+ * or anything the slow path function returns.
+ */
+static inline int
+__mutex_fastpath_lock_timeout(atomic_t *count, long timeout,
+					int (*fail_fn)(atomic_t *, long))
+{
+	if (unlikely(atomic_dec_return(count) < 0))
+		return fail_fn(count, timeout);
+	else {
+		smp_mb();
+		return 0;
+	}
+}
 #endif
diff --git a/include/asm-generic/mutex-null.h b/include/asm-generic/mutex-null.h
index e1bbbc7..192a756 100644
--- a/include/asm-generic/mutex-null.h
+++ b/include/asm-generic/mutex-null.h
@@ -14,6 +14,9 @@
 #define __mutex_fastpath_lock_retval(count, fail_fn)	fail_fn(count)
 #define __mutex_fastpath_unlock(count, fail_fn)		fail_fn(count)
 #define __mutex_fastpath_trylock(count, fail_fn)	fail_fn(count)
+
+#define __mutex_fastpath_timeout(count, timeout, fail_fn) \
+	fail_fn(count, timeout)
 #define __mutex_slowpath_needs_to_unlock()		1
 
 #endif
diff --git a/include/asm-generic/mutex-xchg.h b/include/asm-generic/mutex-xchg.h
index 7b9cd2c..34ccdd3 100644
--- a/include/asm-generic/mutex-xchg.h
+++ b/include/asm-generic/mutex-xchg.h
@@ -115,4 +115,27 @@ __mutex_fastpath_trylock(atomic_t *count, int (*fail_fn)(atomic_t *))
 	return prev;
 }
 
+/**
+ *  __mutex_fastpath_lock_timeout - try to take the lock by moving the count
+ *                                  from 1 to a 0 value
+ *  @count: pointer of type atomic_t
+ *  @fail_fn: function to call if the original value was not 1
+ *	      This function will need to accept two arguments.
+ *  @timeout: Timeout value as second argument to fail_fn.
+ *
+ * Change the count from 1 to a value lower than 1, and call <fail_fn> if it
+ * wasn't 1 originally. This function returns 0 if the fastpath succeeds,
+ * or anything the slow path function returns
+ */
+static inline int
+__mutex_fastpath_lock_timeout(atomic_t *count, timeout,
+			      int (*fail_fn)(atomic_t *, long))
+{
+	if (unlikely(atomic_xchg(count, 0) != 1))
+		return fail_fn(count, timeout);
+	else {
+		smp_mb();
+		return 0;
+	}
+}
 #endif
diff --git a/include/asm-x86/mutex_32.h b/include/asm-x86/mutex_32.h
index 73e928e..7d4696d 100644
--- a/include/asm-x86/mutex_32.h
+++ b/include/asm-x86/mutex_32.h
@@ -122,4 +122,25 @@ static inline int __mutex_fastpath_trylock(atomic_t *count,
 #endif
 }
 
+/**
+ *  __mutex_fastpath_lock_timeout - try to take the lock by moving the count
+ *                                  from 1 to a 0 value
+ *  @count: pointer of type atomic_t
+ *  @fail_fn: function to call if the original value was not 1
+ *	      This function will need to accept two arguments.
+ *  @timeout: Timeout value as second argument to fail_fn.
+ *
+ * Change the count from 1 to a value lower than 1, and call <fail_fn> if it
+ * wasn't 1 originally. This function returns 0 if the fastpath succeeds,
+ * or anything the slow path function returns
+ */
+static inline int
+__mutex_fastpath_lock_timeout(atomic_t *count, long timeout,
+			      int (*fail_fn)(atomic_t *, long))
+{
+	if (unlikely(atomic_dec_return(count) < 0))
+		return fail_fn(count, timeout);
+	else
+		return 0;
+}
 #endif
diff --git a/include/asm-x86/mutex_64.h b/include/asm-x86/mutex_64.h
index f3fae9b..3e63b61 100644
--- a/include/asm-x86/mutex_64.h
+++ b/include/asm-x86/mutex_64.h
@@ -97,4 +97,25 @@ static inline int __mutex_fastpath_trylock(atomic_t *count,
 		return 0;
 }
 
+/**
+ *  __mutex_fastpath_lock_timeout - try to take the lock by moving the count
+ *                                  from 1 to a 0 value
+ *  @count: pointer of type atomic_t
+ *  @fail_fn: function to call if the original value was not 1
+ *	      This function will need to accept two arguments.
+ *  @timeout: Timeout value as second argument to fail_fn.
+ *
+ * Change the count from 1 to a value lower than 1, and call <fail_fn> if
+ * it wasn't 1 originally. This function returns 0 if the fastpath succeeds,
+ * or anything the slow path function returns
+ */
+static inline int
+__mutex_fastpath_lock_timeout(atomic_t *count, long timeout,
+			      int (*fail_fn)(atomic_t *, long))
+{
+	if (unlikely(atomic_dec_return(count) < 0))
+		return fail_fn(count, timeout);
+	else
+		return 0;
+}
 #endif
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index bc6da10..bb84cd4 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -127,18 +127,26 @@ extern int __must_check mutex_lock_interruptible_nested(struct mutex *lock,
 					unsigned int subclass);
 extern int __must_check mutex_lock_killable_nested(struct mutex *lock,
 					unsigned int subclass);
+extern int __must_check
+mutex_lock_timeout_nested(struct mutex *lock, long jiffies,
+			  unsigned int subclass);
 
 #define mutex_lock(lock) mutex_lock_nested(lock, 0)
 #define mutex_lock_interruptible(lock) mutex_lock_interruptible_nested(lock, 0)
 #define mutex_lock_killable(lock) mutex_lock_killable_nested(lock, 0)
+#define mutex_lock_timeout(lock, jiffies) \
+	mutex_lock_timeout_nested(lock, jiffies, 0)
 #else
 extern void mutex_lock(struct mutex *lock);
 extern int __must_check mutex_lock_interruptible(struct mutex *lock);
 extern int __must_check mutex_lock_killable(struct mutex *lock);
+extern int __must_check mutex_lock_timeout(struct mutex *lock, long jiffies);
 
 # define mutex_lock_nested(lock, subclass) mutex_lock(lock)
 # define mutex_lock_interruptible_nested(lock, subclass) mutex_lock_interruptible(lock)
 # define mutex_lock_killable_nested(lock, subclass) mutex_lock_killable(lock)
+# define mutex_lock_timeout_nested(lock, jiffies, subclass) \
+	mutex_lock_timeout(lock, jiffies)
 #endif
 
 /*
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 12c779d..902be79 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -124,8 +124,8 @@ EXPORT_SYMBOL(mutex_unlock);
  * Lock a mutex (possibly interruptible), slowpath:
  */
 static inline int __sched
-__mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
-	       	unsigned long ip)
+__mutex_lock_common(struct mutex *lock, long state, long timeout,
+		    unsigned int subclass, unsigned long ip)
 {
 	struct task_struct *task = current;
 	struct mutex_waiter waiter;
@@ -179,7 +179,22 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 
 		/* didnt get the lock, go to sleep: */
 		spin_unlock_mutex(&lock->wait_lock, flags);
-		schedule();
+		if (timeout == MAX_SCHEDULE_TIMEOUT)
+			schedule();
+		else {
+			timeout = schedule_timeout(timeout);
+
+			if (timeout == 0) {
+				spin_lock_mutex(&lock->wait_lock, flags);
+				mutex_remove_waiter(lock, &waiter,
+						    task_thread_info(task));
+				mutex_release(&lock->dep_map, 1, ip);
+				spin_unlock_mutex(&lock->wait_lock, flags);
+
+				debug_mutex_free_waiter(&waiter);
+				return -ETIME;
+			}
+		}
 		spin_lock_mutex(&lock->wait_lock, flags);
 	}
 
@@ -205,7 +220,8 @@ void __sched
 mutex_lock_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
-	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, subclass, _RET_IP_);
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT,
+			    subclass, _RET_IP_);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_nested);
@@ -214,7 +230,8 @@ int __sched
 mutex_lock_killable_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
-	return __mutex_lock_common(lock, TASK_KILLABLE, subclass, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_KILLABLE, MAX_SCHEDULE_TIMEOUT,
+				   subclass, _RET_IP_);
 }
 EXPORT_SYMBOL_GPL(mutex_lock_killable_nested);
 
@@ -222,10 +239,22 @@ int __sched
 mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
-	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, subclass, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT,
+				   subclass, _RET_IP_);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
+
+int __sched
+mutex_lock_timeout_nested(struct mutex *lock, long timeout,
+			  unsigned int subclass)
+{
+	might_sleep();
+	return __mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, timeout,
+				   subclass, _RET_IP_);
+}
+EXPORT_SYMBOL_GPL(mutex_lock_timeout_nested);
+
 #endif
 
 /*
@@ -285,6 +314,9 @@ __mutex_lock_killable_slowpath(atomic_t *lock_count);
 static noinline int __sched
 __mutex_lock_interruptible_slowpath(atomic_t *lock_count);
 
+static noinline int __sched
+__mutex_lock_timeout_slowpath(atomic_t *lock_count, long timeout);
+
 /***
  * mutex_lock_interruptible - acquire the mutex, interruptable
  * @lock: the mutex to be acquired
@@ -313,12 +345,21 @@ int __sched mutex_lock_killable(struct mutex *lock)
 }
 EXPORT_SYMBOL(mutex_lock_killable);
 
+int __sched mutex_lock_timeout(struct mutex *lock, long timeout)
+{
+	might_sleep();
+	return __mutex_fastpath_lock_timeout
+			(&lock->count, timeout, __mutex_lock_timeout_slowpath);
+}
+EXPORT_SYMBOL(mutex_lock_timeout);
+
 static noinline void __sched
 __mutex_lock_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 
-	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, _RET_IP_);
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT,
+			    0, _RET_IP_);
 }
 
 static noinline int __sched
@@ -326,7 +367,8 @@ __mutex_lock_killable_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 
-	return __mutex_lock_common(lock, TASK_KILLABLE, 0, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_KILLABLE, MAX_SCHEDULE_TIMEOUT,
+				   0, _RET_IP_);
 }
 
 static noinline int __sched
@@ -334,7 +376,17 @@ __mutex_lock_interruptible_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 
-	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE,
+				   MAX_SCHEDULE_TIMEOUT, 0, _RET_IP_);
+}
+
+static noinline int __sched
+__mutex_lock_timeout_slowpath(atomic_t *lock_count, long timeout)
+{
+	struct mutex *lock = container_of(lock_count, struct mutex, count);
+
+	return __mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, timeout,
+				   0, _RET_IP_);
 }
 #endif
 
-- 
1.5.5.1.32.gba7d2


