Return-Path: <linux-kernel-owner+w=401wt.eu-S933503AbZLQKxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503AbZLQKxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 05:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbZLQKxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 05:53:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:53973 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbZLQKxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 05:53:14 -0500
Date: Thu, 17 Dec 2009 10:52:18 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1260991265-8451-1-git-send-regression-fweisbec@gmail.com>
References: <1260991265-8451-1-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Teach might_sleep() about preemptible RCU
Message-ID: <tip-234da7bcdc7aaa935846534c3b726dbc79a9cdd5@git.kernel.org>
Git-Commit-ID: 234da7bcdc7aaa935846534c3b726dbc79a9cdd5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  234da7bcdc7aaa935846534c3b726dbc79a9cdd5
Gitweb:     http://git.kernel.org/tip/234da7bcdc7aaa935846534c3b726dbc79a9cdd5
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 16 Dec 2009 20:21:05 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 17 Dec 2009 09:46:44 +0100

sched: Teach might_sleep() about preemptible RCU

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

[ v2: Handle rcu-tiny ]
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1260991265-8451-1-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
index af7dfa7..7be88a7 100644
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
