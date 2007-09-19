Return-Path: <linux-kernel-owner+w=401wt.eu-S1758462AbXISKva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462AbXISKva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 06:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756994AbXISKvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 06:51:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756726AbXISKvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 06:51:05 -0400
Message-Id: <20070919105054.585517000@chello.nl>
References: <20070919104125.286538000@chello.nl>
User-Agent: quilt/0.45-1
Date: Wed, 19 Sep 2007 12:41:28 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [RFC][PATCH 3/6] lockdep: rcu_dereference() vs preempt_disable()
Content-Disposition: inline; filename=rcu-lockdep-preempt.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Don't warn when preemption is disabled using preempt_disable()

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/preempt.h |   19 +++++++++++--------
 kernel/sched.c          |   14 ++++++++++----
 lib/Kconfig.debug       |    1 +
 3 files changed, 22 insertions(+), 12 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -3396,7 +3396,7 @@ void scheduler_tick(void)
 
 #if defined(CONFIG_PREEMPT) && defined(CONFIG_DEBUG_PREEMPT)
 
-void fastcall add_preempt_count(int val)
+void fastcall __add_preempt_count(int val, int exp)
 {
 	/*
 	 * Underflow?
@@ -3409,10 +3409,13 @@ void fastcall add_preempt_count(int val)
 	 */
 	DEBUG_LOCKS_WARN_ON((preempt_count() & PREEMPT_MASK) >=
 				PREEMPT_MASK - 10);
+
+	if (exp)
+		rcu_read_acquire();
 }
-EXPORT_SYMBOL(add_preempt_count);
+EXPORT_SYMBOL(__add_preempt_count);
 
-void fastcall sub_preempt_count(int val)
+void fastcall __sub_preempt_count(int val, int exp)
 {
 	/*
 	 * Underflow?
@@ -3427,8 +3430,11 @@ void fastcall sub_preempt_count(int val)
 		return;
 
 	preempt_count() -= val;
+
+	if (exp)
+		rcu_read_release();
 }
-EXPORT_SYMBOL(sub_preempt_count);
+EXPORT_SYMBOL(__sub_preempt_count);
 
 #endif
 
Index: linux-2.6/include/linux/preempt.h
===================================================================
--- linux-2.6.orig/include/linux/preempt.h
+++ linux-2.6/include/linux/preempt.h
@@ -11,15 +11,18 @@
 #include <linux/list.h>
 
 #ifdef CONFIG_DEBUG_PREEMPT
-  extern void fastcall add_preempt_count(int val);
-  extern void fastcall sub_preempt_count(int val);
+  extern void fastcall __add_preempt_count(int val, int exp);
+  extern void fastcall __sub_preempt_count(int val, int exp);
 #else
-# define add_preempt_count(val)	do { preempt_count() += (val); } while (0)
-# define sub_preempt_count(val)	do { preempt_count() -= (val); } while (0)
+# define __add_preempt_count(val, exp)	do { preempt_count() += (val); } while (0)
+# define __sub_preempt_count(val, exp)	do { preempt_count() -= (val); } while (0)
 #endif
 
-#define inc_preempt_count() add_preempt_count(1)
-#define dec_preempt_count() sub_preempt_count(1)
+#define add_preempt_count(val) __add_preempt_count(val, 0);
+#define sub_preempt_count(val) __sub_preempt_count(val, 0);
+
+#define inc_preempt_count() __add_preempt_count(1, 0)
+#define dec_preempt_count() __sub_preempt_count(1, 0)
 
 #define preempt_count()	(current_thread_info()->preempt_count)
 
@@ -29,14 +32,14 @@ asmlinkage void preempt_schedule(void);
 
 #define preempt_disable() \
 do { \
-	inc_preempt_count(); \
+	__add_preempt_count(1, 1); \
 	barrier(); \
 } while (0)
 
 #define preempt_enable_no_resched() \
 do { \
 	barrier(); \
-	dec_preempt_count(); \
+	__sub_preempt_count(1, 1); \
 } while (0)
 
 #define preempt_check_resched() \
Index: linux-2.6/lib/Kconfig.debug
===================================================================
--- linux-2.6.orig/lib/Kconfig.debug
+++ linux-2.6/lib/Kconfig.debug
@@ -237,6 +237,7 @@ config DEBUG_SEMAPHORE
 config DEBUG_LOCK_ALLOC
 	bool "Lock debugging: detect incorrect freeing of live locks"
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
+	select DEBUG_PREEMPT
 	select DEBUG_SPINLOCK
 	select DEBUG_MUTEXES
 	select LOCKDEP

--

