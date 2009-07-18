Return-Path: <linux-kernel-owner+w=401wt.eu-S1752630AbZGROWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbZGROWx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 10:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbZGROWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 10:22:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:53922 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbZGROWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 10:22:52 -0400
Date: Sat, 18 Jul 2009 14:22:11 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1247725694-6082-4-git-send-email-fweisbec@gmail.com>
References: <1247725694-6082-4-git-send-email-fweisbec@gmail.com>
Subject: [tip:sched/core] sched: Add a preempt count base offset to __might_sleep()
Message-ID: <tip-e4aafea2d4bde8b44d6500c4ee7195bbfc51269e@git.kernel.org>
Git-Commit-ID: e4aafea2d4bde8b44d6500c4ee7195bbfc51269e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Jul 2009 14:22:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e4aafea2d4bde8b44d6500c4ee7195bbfc51269e
Gitweb:     http://git.kernel.org/tip/e4aafea2d4bde8b44d6500c4ee7195bbfc51269e
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 16 Jul 2009 15:44:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Jul 2009 15:51:42 +0200

sched: Add a preempt count base offset to __might_sleep()

Add a preempt count base offset to compare against the current
preempt level count. It prepares to pull up the might_sleep
check from cond_resched() to cond_resched_lock() and
cond_resched_bh().

For these two helpers, we need to respectively ensure that once
we'll unlock the given spinlock / reenable local softirqs, we
will reach a sleepable state.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
[ Move and rename preempt_count_equals() ]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1247725694-6082-4-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/kernel.h |    6 +++---
 kernel/sched.c         |   15 +++++++++++----
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index b804f69..2b5b1e0 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -125,7 +125,7 @@ extern int _cond_resched(void);
 #endif
 
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
-  void __might_sleep(char *file, int line);
+  void __might_sleep(char *file, int line, int preempt_offset);
 /**
  * might_sleep - annotation for functions that can sleep
  *
@@ -137,9 +137,9 @@ extern int _cond_resched(void);
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
index 370a6c3..3ff4d00 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6610,7 +6610,7 @@ static inline int should_resched(void)
 
 static void __cond_resched(void)
 {
-	__might_sleep(__FILE__, __LINE__);
+	__might_sleep(__FILE__, __LINE__, 0);
 
 	add_preempt_count(PREEMPT_ACTIVE);
 	schedule();
@@ -9429,13 +9429,20 @@ void __init sched_init(void)
 }
 
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
-void __might_sleep(char *file, int line)
+static inline int preempt_count_equals(int preempt_offset)
+{
+	int nested = preempt_count() & ~PREEMPT_ACTIVE;
+
+	return (nested == PREEMPT_INATOMIC_BASE + preempt_offset);
+}
+
+void __might_sleep(char *file, int line, int preempt_offset)
 {
 #ifdef in_atomic
 	static unsigned long prev_jiffy;	/* ratelimiting */
 
-	if ((!in_atomic() && !irqs_disabled()) ||
-		    system_state != SYSTEM_RUNNING || oops_in_progress)
+	if ((preempt_count_equals(preempt_offset) && !irqs_disabled()) ||
+	    system_state != SYSTEM_RUNNING || oops_in_progress)
 		return;
 	if (time_before(jiffies, prev_jiffy + HZ) && prev_jiffy)
 		return;
