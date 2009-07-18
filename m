Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbZGROXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbZGROXL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 10:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbZGROXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 10:23:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:53947 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbZGROXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 10:23:08 -0400
Date: Sat, 18 Jul 2009 14:22:35 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1247725694-6082-6-git-send-email-fweisbec@gmail.com>
References: <1247725694-6082-6-git-send-email-fweisbec@gmail.com>
Subject: [tip:sched/core] sched: Pull up the might_sleep() check into cond_resched()
Message-ID: <tip-613afbf83298efaead05ebcac23d2285609d7160@git.kernel.org>
Git-Commit-ID: 613afbf83298efaead05ebcac23d2285609d7160
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Jul 2009 14:22:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  613afbf83298efaead05ebcac23d2285609d7160
Gitweb:     http://git.kernel.org/tip/613afbf83298efaead05ebcac23d2285609d7160
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 16 Jul 2009 15:44:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Jul 2009 15:51:44 +0200

sched: Pull up the might_sleep() check into cond_resched()

might_sleep() is called late-ish in cond_resched(), after the
need_resched()/preempt enabled/system running tests are
checked.

It's better to check the sleeps while atomic earlier and not
depend on some environment datas that reduce the chances to
detect a problem.

Also define cond_resched_*() helpers as macros, so that the
FILE/LINE reported in the sleeping while atomic warning
displays the real origin and not sched.h

Changes in v2:

 - Call __might_sleep() directly instead of might_sleep() which
   may call cond_resched()

 - Turn cond_resched() into a macro so that the file:line
   couple reported refers to the caller of cond_resched() and
   not __cond_resched() itself.

Changes in v3:

 - Also propagate this __might_sleep() pull up to
   cond_resched_lock() and cond_resched_softirq()

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1247725694-6082-6-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 fs/dcache.c           |    1 +
 include/linux/sched.h |   29 +++++++++++++++++++----------
 kernel/sched.c        |   12 +++++-------
 3 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 9e5cd3c..a100fa3 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -32,6 +32,7 @@
 #include <linux/swap.h>
 #include <linux/bootmem.h>
 #include <linux/fs_struct.h>
+#include <linux/hardirq.h>
 #include "internal.h"
 
 int sysctl_vfs_cache_pressure __read_mostly = 100;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e2bdf18..c41d424 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2286,17 +2286,26 @@ static inline int need_resched(void)
  */
 extern int _cond_resched(void);
 
-static inline int cond_resched(void)
-{
-	return _cond_resched();
-}
+#define cond_resched() ({			\
+	__might_sleep(__FILE__, __LINE__, 0);	\
+	_cond_resched();			\
+})
 
-extern int cond_resched_lock(spinlock_t * lock);
-extern int cond_resched_softirq(void);
-static inline int cond_resched_bkl(void)
-{
-	return _cond_resched();
-}
+extern int __cond_resched_lock(spinlock_t *lock);
+
+#define cond_resched_lock(lock) ({				\
+	__might_sleep(__FILE__, __LINE__, PREEMPT_OFFSET);	\
+	__cond_resched_lock(lock);				\
+})
+
+extern int __cond_resched_softirq(void);
+
+#define cond_resched_softirq() ({				\
+	__might_sleep(__FILE__, __LINE__, SOFTIRQ_OFFSET);	\
+	__cond_resched_softirq();				\
+})
+
+#define cond_resched_bkl()	cond_resched()
 
 /*
  * Does a critical section need to be broken due to another
diff --git a/kernel/sched.c b/kernel/sched.c
index 3ff4d00..1f7919a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6610,8 +6610,6 @@ static inline int should_resched(void)
 
 static void __cond_resched(void)
 {
-	__might_sleep(__FILE__, __LINE__, 0);
-
 	add_preempt_count(PREEMPT_ACTIVE);
 	schedule();
 	sub_preempt_count(PREEMPT_ACTIVE);
@@ -6628,14 +6626,14 @@ int __sched _cond_resched(void)
 EXPORT_SYMBOL(_cond_resched);
 
 /*
- * cond_resched_lock() - if a reschedule is pending, drop the given lock,
+ * __cond_resched_lock() - if a reschedule is pending, drop the given lock,
  * call schedule, and on return reacquire the lock.
  *
  * This works OK both with and without CONFIG_PREEMPT. We do strange low-level
  * operations here to prevent schedule() from being called twice (once via
  * spin_unlock(), once by hand).
  */
-int cond_resched_lock(spinlock_t *lock)
+int __cond_resched_lock(spinlock_t *lock)
 {
 	int resched = should_resched();
 	int ret = 0;
@@ -6651,9 +6649,9 @@ int cond_resched_lock(spinlock_t *lock)
 	}
 	return ret;
 }
-EXPORT_SYMBOL(cond_resched_lock);
+EXPORT_SYMBOL(__cond_resched_lock);
 
-int __sched cond_resched_softirq(void)
+int __sched __cond_resched_softirq(void)
 {
 	BUG_ON(!in_softirq());
 
@@ -6665,7 +6663,7 @@ int __sched cond_resched_softirq(void)
 	}
 	return 0;
 }
-EXPORT_SYMBOL(cond_resched_softirq);
+EXPORT_SYMBOL(__cond_resched_softirq);
 
 /**
  * yield - yield the current processor to other threads.
