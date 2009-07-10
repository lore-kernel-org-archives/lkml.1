Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbZGJNE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbZGJNE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 09:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZGJNEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 09:04:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:35430 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbZGJNEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 09:04:15 -0400
Message-Id: <20090710130125.160337304@chello.nl>
References: <20090710125755.559739294@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 10 Jul 2009 14:57:57 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>, oleg@redhat.com,
       mingo@elte.hu, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/2] sched: optimize cond_resched()
Content-Disposition: inline; filename=sched_opt_cond_resched.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimize cond_resched() by removing one conditional.

Currently cond_resched() checks system_state ==
SYSTEM_RUNNING in order to avoid scheduling before the
scheduler is running.

We can however, as per suggestion of Matt, use
PREEMPT_ACTIVE to accomplish that very same.

Suggested-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    5 ++++-
 kernel/sched.c        |   14 +++++++++-----
 2 files changed, 13 insertions(+), 6 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -503,8 +503,11 @@ struct task_cputime {
 /*
  * Disable preemption until the scheduler is running.
  * Reset by start_kernel()->sched_init()->init_idle().
+ *
+ * We include PREEMPT_ACTIVE to avoid cond_resched() from working
+ * before the scheduler is active -- see should_resched().
  */
-#define INIT_PREEMPT_COUNT	(1)
+#define INIT_PREEMPT_COUNT	(1 + PREEMPT_ACTIVE)
 
 /**
  * struct thread_group_cputimer - thread group interval timer counts
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6580,6 +6580,11 @@ SYSCALL_DEFINE0(sched_yield)
 	return 0;
 }
 
+static inline int should_resched(void)
+{
+	return need_resched() && !(preempt_count() & PREEMPT_ACTIVE);
+}
+
 static void __cond_resched(void)
 {
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
@@ -6599,8 +6604,7 @@ static void __cond_resched(void)
 
 int __sched _cond_resched(void)
 {
-	if (need_resched() && !(preempt_count() & PREEMPT_ACTIVE) &&
-					system_state == SYSTEM_RUNNING) {
+	if (should_resched()) {
 		__cond_resched();
 		return 1;
 	}
@@ -6618,12 +6622,12 @@ EXPORT_SYMBOL(_cond_resched);
  */
 int cond_resched_lock(spinlock_t *lock)
 {
-	int resched = need_resched() && system_state == SYSTEM_RUNNING;
+	int resched = should_resched();
 	int ret = 0;
 
 	if (spin_needbreak(lock) || resched) {
 		spin_unlock(lock);
-		if (resched && need_resched())
+		if (resched)
 			__cond_resched();
 		else
 			cpu_relax();
@@ -6638,7 +6642,7 @@ int __sched cond_resched_softirq(void)
 {
 	BUG_ON(!in_softirq());
 
-	if (need_resched() && system_state == SYSTEM_RUNNING) {
+	if (should_resched()) {
 		local_bh_enable();
 		__cond_resched();
 		local_bh_disable();

-- 

