Return-Path: <linux-kernel-owner+w=401wt.eu-S1758511AbZLNWol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511AbZLNWol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:44:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbZLNWoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:44:39 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:44392 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbZLNWoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:44:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=iGbayrd6mfBgnx7elkcsX1DVuPgy5toBH6Q+ccWqGIYQc57xz/e6Lg2eno4aqsOj7/
         YUAvyzxVky37O07wfoYu/A3dgIF8o6CBRbLdq6rYG6auvIbE96twQWjr8z6i+PAc8UCr
         vwj6xCQRRnUEHjtxesozxv57o1ElCjefC1s7Q=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched: Teach might_sleep about preemptable rcu
Date: Mon, 14 Dec 2009 23:44:32 +0100
Message-Id: <1260830672-7166-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In practice, it is harmless to voluntarily sleep in a rcu_read_lock()
section if we are running under preempt rcu, but it is illegal because
if we build a kernel running non-preemptable rcu.

Currently, might_sleep() doesn't notice sleepable operations under
rcu_read_lock() sections if we are running under preemptable rcu
because preempt_count() is left untouched after rcu_read_lock() in
this case. But we want developers who test their changes under such
config to notice the "sleeping while atomic" issues.

Then we add rcu_read_lock_nesting to prempt_count() in might_sleep()
checks.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/rcutree.h |   11 +++++++++++
 kernel/sched.c          |    2 +-
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index c93eee5..8044b1b 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -45,6 +45,12 @@ extern void __rcu_read_unlock(void);
 extern void synchronize_rcu(void);
 extern void exit_rcu(void);
 
+/*
+ * Defined as macro as it is a very low level header
+ * included from areas that don't even know about current
+ */
+#define rcu_preempt_depth() (current->rcu_read_lock_nesting)
+
 #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 static inline void __rcu_read_lock(void)
@@ -63,6 +69,11 @@ static inline void exit_rcu(void)
 {
 }
 
+static inline int rcu_preempt_depth(void)
+{
+	return 0;
+}
+
 #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 static inline void __rcu_read_lock_bh(void)
diff --git a/kernel/sched.c b/kernel/sched.c
index ab42754..586c82c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9658,7 +9658,7 @@ void __init sched_init(void)
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
 static inline int preempt_count_equals(int preempt_offset)
 {
-	int nested = preempt_count() & ~PREEMPT_ACTIVE;
+	int nested = (preempt_count() & ~PREEMPT_ACTIVE) + rcu_preempt_depth();
 
 	return (nested == PREEMPT_INATOMIC_BASE + preempt_offset);
 }
-- 
1.6.2.3

