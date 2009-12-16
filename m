Return-Path: <linux-kernel-owner+w=401wt.eu-S935377AbZLPTV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935377AbZLPTV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763143AbZLPTVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:21:17 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:43640 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763141AbZLPTVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:21:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VwQ7vdnUqacLxZNgGG+cn6mWzFlZN+yiCRHSrQyRIboNhI6frdVHvEM1CC1afk42Bz
         4JH9+k5GQMa9ek3DkjOH59WZFZ4UpzSm7g3PqG37QSOOHlgK6tt2NDHUTCsBnikt/JB2
         5Xj2aUNclgSlvfyqulg9DesiWaoVJ6ozpL7Qk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       tip-bot for Frederic Weisbecker <fweisbec@gmail.com>,
       "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched: Teach might_sleep() about preemptible RCU
Date: Wed, 16 Dec 2009 20:21:05 +0100
Message-Id: <1260991265-8451-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20091216142536.GA18091@elte.hu>
References: <20091216142536.GA18091@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>

In practice, it is harmless to voluntarily sleep in a
rcu_read_lock() section if we are running under preempt rcu, but
it is illegal if we build a kernel running non-preemptable rcu.

Currently, might_sleep() doesn't notice sleepable operations
under rcu_read_lock() sections if we are running under
preemptable rcu because preempt_count() is left untouched after
rcu_read_lock() in this case. But we want developers who test
their changes under such config to notice the "sleeping while
atomic" issues.

So we add rcu_read_lock_nesting to prempt_count() in
might_sleep() checks.

v2: Handle rcu tiny

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/rcutiny.h |    5 +++++
 include/linux/rcutree.h |   11 +++++++++++
 kernel/sched.c          |    2 +-
 3 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index c4ba9a7..96cc307 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -101,4 +101,9 @@ static inline void exit_rcu(void)
 {
 }
 
+static inline int rcu_preempt_depth(void)
+{
+	return 0;
+}
+
 #endif /* __LINUX_RCUTINY_H */
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
index 8a2bfd3..418e638 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9682,7 +9682,7 @@ void __init sched_init(void)
 #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
 static inline int preempt_count_equals(int preempt_offset)
 {
-	int nested = preempt_count() & ~PREEMPT_ACTIVE;
+	int nested = (preempt_count() & ~PREEMPT_ACTIVE) + rcu_preempt_depth();
 
 	return (nested == PREEMPT_INATOMIC_BASE + preempt_offset);
 }
-- 
1.6.2.3

