Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbZGJRPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbZGJRPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 13:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272AbZGJRPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 13:15:05 -0400
Received: from ey-out-1920.google.com ([74.125.78.147]:38175 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbZGJRPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 13:15:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uSNs6/2QJhbUROmLRbzZyWpTGq9aahgB9PfMAnUG1Z4Rpx6/vv/JotB/sZTeWrRUFW
         P4SStpLjmD8MiTpB0MScSY3YoRK7nOU6enbCVWxrKtLsmOrN6wYuIf02ztgR/R9pP8eM
         pWo66OZ0fRtjxqgjjBZyBJACuUUn/ahZty1Xk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] sched: Move the sleeping while atomic checks early in cond_resched()
Date: Fri, 10 Jul 2009 19:14:58 +0200
Message-Id: <1247246098-5627-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090710161034.GB22049@elte.hu>
References: <20090710161034.GB22049@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

might_sleep() is called lately in cond_resched(), after the
need_resched()/preempt enabled/system running tests are checked.

It's better to check the sleeps while atomic earlier and not depend
on some environment datas that reduce the chances to detect a
problem.

Changes in v2:
- call __might_sleep() directly instead of might_sleep() which may call
  cond_resched()
- turn cond_resched() into a macro so that the file:line couple reported
  refers to the caller of cond_resched() and not __cond_resched() itself.
- drop the obsolete CONFIG_PREEMPT_BKL related zones

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/sched.h |   22 +++++++---------------
 kernel/sched.c        |    5 ++---
 2 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0cb0d8d..737f569 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2276,23 +2276,15 @@ static inline int need_resched(void)
  * cond_resched_softirq() will enable bhs before scheduling.
  */
 extern int _cond_resched(void);
-#ifdef CONFIG_PREEMPT_BKL
-static inline int cond_resched(void)
-{
-	return 0;
-}
-#else
-static inline int cond_resched(void)
-{
-	return _cond_resched();
-}
-#endif
+#define cond_resched() ({			\
+	__might_sleep(__FILE__, __LINE__);	\
+	_cond_resched();			\
+})
+
 extern int cond_resched_lock(spinlock_t * lock);
 extern int cond_resched_softirq(void);
-static inline int cond_resched_bkl(void)
-{
-	return _cond_resched();
-}
+
+#define cond_resched_bkl()	cond_resched();
 
 /*
  * Does a critical section need to be broken due to another
diff --git a/kernel/sched.c b/kernel/sched.c
index 87ecac1..649ec92 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6605,9 +6605,6 @@ SYSCALL_DEFINE0(sched_yield)
 
 static void __cond_resched(void)
 {
-#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
-	__might_sleep(__FILE__, __LINE__);
-#endif
 	/*
 	 * The BKS might be reacquired before we have dropped
 	 * PREEMPT_ACTIVE, which could trigger a second
@@ -6644,6 +6641,7 @@ int cond_resched_lock(spinlock_t *lock)
 
 	if (spin_needbreak(lock) || resched) {
 		spin_unlock(lock);
+		__might_sleep(__FILE__, __LINE__);
 		if (resched && need_resched())
 			__cond_resched();
 		else
@@ -6661,6 +6659,7 @@ int __sched cond_resched_softirq(void)
 
 	if (need_resched() && system_state == SYSTEM_RUNNING) {
 		local_bh_enable();
+		__might_sleep(__FILE__, __LINE__);
 		__cond_resched();
 		local_bh_disable();
 		return 1;
-- 
1.6.2.3

