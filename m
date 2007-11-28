Return-Path: <linux-kernel-owner+w=401wt.eu-S1758790AbXK1NyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790AbXK1NyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 08:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbXK1NyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 08:54:17 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:6876 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbXK1NyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 08:54:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=XwHyymuT+GheqnT3Yzb0kjJLuVtomS6Py2/ktuccj0PLEelQ71OlkUXZ8uLxuvkqMrurw1flIGzmhJxDAlpTlf2SI7mVJeu0RvNcqEakNd3tuE1CTCS0kcrdDXgz9sRy6wQUp6Sq+Djg8gWuwQTMRBDTC1O7KqzfM5qhD6ACODY=
Date: Wed, 28 Nov 2007 08:53:41 -0500
From: "Liam R. Howlett" <howlett@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: willy@linux.intel.com, akpm@linux-foundation.org, mingo@redhat.com
Subject: [Patch 1/2] Kernel: mutex_lock_killable
Message-ID: <20071128135341.GA14479@solidsnake>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Addition of mutex_lock_killable for mutex.c and mutex.h
Signed-off-by: Liam R. Howlett <howlett@gmail.com>
Acked-by: Matthew Wilcox <willy@linux.intel.com>
---
 include/linux/mutex.h |    5 +++++
 kernel/mutex.c        |   36 +++++++++++++++++++++++++++++++++---
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 6014797..05c5903 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -125,15 +125,20 @@ static inline int fastcall mutex_is_locked(struct mutex *lock)
 extern void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
 extern int __must_check mutex_lock_interruptible_nested(struct mutex *lock,
 					unsigned int subclass);
+extern int __must_check mutex_lock_killable_nested(struct mutex *lock,
+					unsigned int subclass);
 
 #define mutex_lock(lock) mutex_lock_nested(lock, 0)
 #define mutex_lock_interruptible(lock) mutex_lock_interruptible_nested(lock, 0)
+#define mutex_lock_killable(lock) mutex_lock_killable_nested(lock, 0)
 #else
 extern void fastcall mutex_lock(struct mutex *lock);
 extern int __must_check fastcall mutex_lock_interruptible(struct mutex *lock);
+extern int __must_check fastcall mutex_lock_killable(struct mutex *lock);
 
 # define mutex_lock_nested(lock, subclass) mutex_lock(lock)
 # define mutex_lock_interruptible_nested(lock, subclass) mutex_lock_interruptible(lock)
+# define mutex_lock_killable_nested(lock, subclass) mutex_lock_killable(lock)
 #endif
 
 /*
diff --git a/kernel/mutex.c b/kernel/mutex.c
index d7fe50c..d9ec9b6 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -166,9 +166,12 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * got a signal? (This code gets eliminated in the
 		 * TASK_UNINTERRUPTIBLE case.)
 		 */
-		if (unlikely(state == TASK_INTERRUPTIBLE &&
-						signal_pending(task))) {
-			mutex_remove_waiter(lock, &waiter, task_thread_info(task));
+		if (unlikely((state == TASK_INTERRUPTIBLE &&
+					signal_pending(task)) ||
+			      (state == TASK_KILLABLE &&
+					fatal_signal_pending(task)))) {
+			mutex_remove_waiter(lock, &waiter,
+					    task_thread_info(task));
 			mutex_release(&lock->dep_map, 1, ip);
 			spin_unlock_mutex(&lock->wait_lock, flags);
 
@@ -211,6 +214,14 @@ mutex_lock_nested(struct mutex *lock, unsigned int subclass)
 EXPORT_SYMBOL_GPL(mutex_lock_nested);
 
 int __sched
+mutex_lock_killable_nested(struct mutex *lock, unsigned int subclass)
+{
+	might_sleep();
+	return __mutex_lock_common(lock, TASK_KILLABLE, subclass, _RET_IP_);
+}
+EXPORT_SYMBOL_GPL(mutex_lock_killable_nested);
+
+int __sched
 mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
@@ -272,6 +283,9 @@ __mutex_unlock_slowpath(atomic_t *lock_count)
  * mutex_lock_interruptible() and mutex_trylock().
  */
 static int fastcall noinline __sched
+__mutex_lock_killable_slowpath(atomic_t *lock_count);
+
+static noinline int fastcall __sched
 __mutex_lock_interruptible_slowpath(atomic_t *lock_count);
 
 /***
@@ -294,6 +308,14 @@ int fastcall __sched mutex_lock_interruptible(struct mutex *lock)
 
 EXPORT_SYMBOL(mutex_lock_interruptible);
 
+int fastcall __sched mutex_lock_killable(struct mutex *lock)
+{
+	might_sleep();
+	return __mutex_fastpath_lock_retval
+			(&lock->count, __mutex_lock_killable_slowpath);
+}
+EXPORT_SYMBOL(mutex_lock_killable);
+
 static void fastcall noinline __sched
 __mutex_lock_slowpath(atomic_t *lock_count)
 {
@@ -303,6 +325,14 @@ __mutex_lock_slowpath(atomic_t *lock_count)
 }
 
 static int fastcall noinline __sched
+__mutex_lock_killable_slowpath(atomic_t *lock_count)
+{
+	struct mutex *lock = container_of(lock_count, struct mutex, count);
+
+	return __mutex_lock_common(lock, TASK_KILLABLE, 0, _RET_IP_);
+}
+
+static noinline int fastcall __sched
 __mutex_lock_interruptible_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
-- 
1.5.2.5

