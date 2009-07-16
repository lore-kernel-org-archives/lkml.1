Return-Path: <linux-kernel-owner+w=401wt.eu-S1757029AbZGPG2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbZGPG2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 02:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756596AbZGPG2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 02:28:31 -0400
Received: from mail-qy0-f192.google.com ([209.85.221.192]:63897 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756864AbZGPG20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 02:28:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TRp8jWCcsUyBFDYE3EaSx4Ww1MEEVWSIAfr8a11XxO+o6lLsol0BvlO52nt9OqWHPj
         MRQNYMwyZcZ+ZHiJ5Ntlgytq/yd3gVvMgv2Jj4N7gnANZhte2KPH/y2uBie/0xzHprd+
         EPLIUIH7TPPA8dref8Z/ZERAGyryc3otBpDJw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6/7 v3] sched: Pull up the might_sleep() check in cond_resched()
Date: Thu, 16 Jul 2009 02:28:13 -0400
Message-Id: <1247725694-6082-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1247725694-6082-1-git-send-email-fweisbec@gmail.com>
References: <1247725694-6082-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

might_sleep() is called lately in cond_resched(), after the
need_resched()/preempt enabled/system running tests are checked.

It's better to check the sleeps while atomic earlier and not depend
on some environment datas that reduce the chances to detect a
problem.

Also define cond_resched_*() helpers as macros, so that the FILE/LINE
reported in the sleeping while atomic warning displays the real origin
and not sched.h

Changes in v2:
- call __might_sleep() directly instead of might_sleep() which may call
  cond_resched()
- turn cond_resched() into a macro so that the file:line couple reported
  refers to the caller of cond_resched() and not __cond_resched() itself.

Changes in v3:
- also propagate this __might_sleep() pull up to cond_resched_lock() and
  cond_resched_softirq()

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/dcache.c           |    1 +
 include/linux/sched.h |   29 +++++++++++++++++++----------
 kernel/sched.c        |   12 +++++-------
 3 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 5ecb8e1..64698d6 100644
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
index e2bdf18..099408f 100644
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
+extern int __cond_resched_lock(spinlock_t * lock);
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
index 847e8fb..b9950b1 100644
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
-- 
1.6.2.3

