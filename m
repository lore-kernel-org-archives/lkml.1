Return-Path: <linux-kernel-owner+w=401wt.eu-S1759966AbZFJWMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966AbZFJWMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 18:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756464AbZFJWMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 18:12:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42986 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222AbZFJWMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 18:12:30 -0400
Date: Thu, 11 Jun 2009 00:12:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/locking for v2.6.31
Message-ID: <20090610221224.GA22952@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest locking-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git locking-for-linus

 Thanks,

	Ingo

------------------>
Andrew Morton (1):
      mutex: add atomic_dec_and_mutex_lock(), fix

Benjamin Herrenschmidt (1):
      spinlock: Add missing __raw_spin_lock_flags() stub for UP

Eric Paris (1):
      mutex: add atomic_dec_and_mutex_lock()

Luis Henriques (1):
      locking, rtmutex.c: Documentation cleanup


 include/linux/mutex.h       |    1 +
 include/linux/spinlock_up.h |    1 +
 kernel/mutex.c              |   25 ++++++++++++++++++++++++-
 kernel/rtmutex.c            |    8 ++++----
 4 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 3069ec7..878cab4 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -150,5 +150,6 @@ extern int __must_check mutex_lock_killable(struct mutex *lock);
  */
 extern int mutex_trylock(struct mutex *lock);
 extern void mutex_unlock(struct mutex *lock);
+extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
 
 #endif
diff --git a/include/linux/spinlock_up.h b/include/linux/spinlock_up.h
index 938234c..d4841ed 100644
--- a/include/linux/spinlock_up.h
+++ b/include/linux/spinlock_up.h
@@ -60,6 +60,7 @@ static inline void __raw_spin_unlock(raw_spinlock_t *lock)
 #define __raw_spin_is_locked(lock)	((void)(lock), 0)
 /* for sched.c and kernel_lock.c: */
 # define __raw_spin_lock(lock)		do { (void)(lock); } while (0)
+# define __raw_spin_lock_flags(lock, flags)	do { (void)(lock); } while (0)
 # define __raw_spin_unlock(lock)	do { (void)(lock); } while (0)
 # define __raw_spin_trylock(lock)	({ (void)(lock); 1; })
 #endif /* DEBUG_SPINLOCK */
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 507cf2b..e2d25e9 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -471,5 +471,28 @@ int __sched mutex_trylock(struct mutex *lock)
 
 	return ret;
 }
-
 EXPORT_SYMBOL(mutex_trylock);
+
+/**
+ * atomic_dec_and_mutex_lock - return holding mutex if we dec to 0
+ * @cnt: the atomic which we are to dec
+ * @lock: the mutex to return holding if we dec to 0
+ *
+ * return true and hold lock if we dec to 0, return false otherwise
+ */
+int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock)
+{
+	/* dec if we can't possibly hit 0 */
+	if (atomic_add_unless(cnt, -1, 1))
+		return 0;
+	/* we might hit 0, so take the lock */
+	mutex_lock(lock);
+	if (!atomic_dec_and_test(cnt)) {
+		/* when we actually did the dec, we didn't hit 0 */
+		mutex_unlock(lock);
+		return 0;
+	}
+	/* we hit 0, and we hold the lock */
+	return 1;
+}
+EXPORT_SYMBOL(atomic_dec_and_mutex_lock);
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 69d9cb9..013882e 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -864,9 +864,9 @@ int __sched rt_mutex_lock_interruptible(struct rt_mutex *lock,
 EXPORT_SYMBOL_GPL(rt_mutex_lock_interruptible);
 
 /**
- * rt_mutex_lock_interruptible_ktime - lock a rt_mutex interruptible
- *				       the timeout structure is provided
- *				       by the caller
+ * rt_mutex_timed_lock - lock a rt_mutex interruptible
+ *			the timeout structure is provided
+ *			by the caller
  *
  * @lock: 		the rt_mutex to be locked
  * @timeout:		timeout structure or NULL (no timeout)
@@ -913,7 +913,7 @@ void __sched rt_mutex_unlock(struct rt_mutex *lock)
 }
 EXPORT_SYMBOL_GPL(rt_mutex_unlock);
 
-/***
+/**
  * rt_mutex_destroy - mark a mutex unusable
  * @lock: the mutex to be destroyed
  *
