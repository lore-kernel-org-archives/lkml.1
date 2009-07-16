Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbZGPG2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbZGPG2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 02:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756596AbZGPG22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 02:28:28 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:59564 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584AbZGPG2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 02:28:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Vsh9SXmrMvwKhVxPrxJu9DhpMqwNHOjTfoDBvwbIe5Q4/O2JGWGLgsXaqyUGBnzTkT
         wl39h0kzRvDEY7e5ejxtGYhTgN+wUyPCJHtY3tpGDwy52nvCcygBvsESI25AyYu1tqeq
         8mBeZBIxuFcPnJACBzgyje+A5f96mfWJNYryk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4/7] sched: Add a preempt count base offset to __might_sleep()
Date: Thu, 16 Jul 2009 02:28:11 -0400
Message-Id: <1247725694-6082-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1247725694-6082-1-git-send-email-fweisbec@gmail.com>
References: <1247725694-6082-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a preempt count base offset to compare against the current
preempt level count. It prepares to pull up the might_sleep
check from cond_resched() to cond_resched_lock() and
cond_resched_bh().

For these two helpers, we need to respectively ensure that once
we'll unlock the given spinlock / reenable local softirqs, we
will reach a sleepable state.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/hardirq.h |    7 +++++++
 include/linux/kernel.h  |    6 +++---
 kernel/sched.c          |    8 ++++----
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 8246c69..d55b0be 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -103,6 +103,13 @@
  */
 #define in_atomic()	((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_INATOMIC_BASE)
 
+static inline int current_preempt_equals(int preempt_offset)
+{
+	int nested = preempt_count() & ~PREEMPT_ACTIVE;
+
+	return (nested == PREEMPT_INATOMIC_BASE + preempt_offset);
+}
+
 /*
  * Check whether we were atomic before we did preempt_disable():
  * (used by the scheduler, *after* releasing the kernel lock)
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 99882e8..f61039e 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -217,7 +217,7 @@ extern int _cond_resched(void);
 #endif
 
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
-  void __might_sleep(char *file, int line);
+  void __might_sleep(char *file, int line, int preempt_offset);
 /**
  * might_sleep - annotation for functions that can sleep
  *
@@ -229,9 +229,9 @@ extern int _cond_resched(void);
  * supposed to.
  */
 # define might_sleep() \
-	do { __might_sleep(__FILE__, __LINE__); might_resched(); } while (0)
+	do { __might_sleep(__FILE__, __LINE__, 0); might_resched(); } while (0)
 #else
-  static inline void __might_sleep(char *file, int line) { }
+  static inline void __might_sleep(char *file, int line, int preempt_offset) { }
 # define might_sleep() do { might_resched(); } while (0)
 #endif
 
diff --git a/kernel/sched.c b/kernel/sched.c
index ac334ba..847e8fb 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6610,7 +6610,7 @@ static inline int should_resched(void)
 
 static void __cond_resched(void)
 {
-	__might_sleep(__FILE__, __LINE__);
+	__might_sleep(__FILE__, __LINE__, 0);
 
 	add_preempt_count(PREEMPT_ACTIVE);
 	schedule();
@@ -9444,13 +9444,13 @@ void __init sched_init(void)
 }
 
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
-void __might_sleep(char *file, int line)
+void __might_sleep(char *file, int line, int preempt_offset)
 {
 #ifdef in_atomic
 	static unsigned long prev_jiffy;	/* ratelimiting */
 
-	if ((!in_atomic() && !irqs_disabled()) ||
-		    system_state != SYSTEM_RUNNING || oops_in_progress)
+	if ((current_preempt_equals(preempt_offset) && !irqs_disabled()) ||
+	    system_state != SYSTEM_RUNNING || oops_in_progress)
 		return;
 	if (time_before(jiffies, prev_jiffy + HZ) && prev_jiffy)
 		return;
-- 
1.6.2.3

