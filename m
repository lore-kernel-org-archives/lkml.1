Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab0CDQdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:33:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:48496 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384Ab0CDQdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:33:02 -0500
Date: Thu, 4 Mar 2010 16:32:35 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1267667418-32233-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1267667418-32233-1-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Make rcu_read_lock_sched_held() handle !PREEMPT
Message-ID: <tip-e6033e3b307fcfae08408e0673266db38392bda4@git.kernel.org>
Git-Commit-ID: e6033e3b307fcfae08408e0673266db38392bda4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Mar 2010 16:32:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6033e3b307fcfae08408e0673266db38392bda4
Gitweb:     http://git.kernel.org/tip/e6033e3b307fcfae08408e0673266db38392bda4
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Wed, 3 Mar 2010 17:50:16 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Mar 2010 12:07:33 +0100

rcu: Make rcu_read_lock_sched_held() handle !PREEMPT

The rcu_read_lock_sched_held() needs to unconditionally return
the value "1" in a !PREEMPT kernel, because under !PREEMPT,
-all- kernel code is implicitly preempt-disabled.  This patch
makes this happen.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <1267667418-32233-1-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/rcupdate.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index c843736..e22960e 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -136,6 +136,7 @@ static inline int rcu_read_lock_bh_held(void)
  * can prove otherwise.  Note that disabling of preemption (including
  * disabling irqs) counts as an RCU-sched read-side critical section.
  */
+#ifdef CONFIG_PREEMPT
 static inline int rcu_read_lock_sched_held(void)
 {
 	int lockdep_opinion = 0;
@@ -144,6 +145,12 @@ static inline int rcu_read_lock_sched_held(void)
 		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
 	return lockdep_opinion || preempt_count() != 0 || !rcu_scheduler_active;
 }
+#else /* #ifdef CONFIG_PREEMPT */
+static inline int rcu_read_lock_sched_held(void)
+{
+	return 1;
+}
+#endif /* #else #ifdef CONFIG_PREEMPT */
 
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
@@ -164,10 +171,17 @@ static inline int rcu_read_lock_bh_held(void)
 	return 1;
 }
 
+#ifdef CONFIG_PREEMPT
 static inline int rcu_read_lock_sched_held(void)
 {
 	return preempt_count() != 0 || !rcu_scheduler_active;
 }
+#else /* #ifdef CONFIG_PREEMPT */
+static inline int rcu_read_lock_sched_held(void)
+{
+	return 1;
+}
+#endif /* #else #ifdef CONFIG_PREEMPT */
 
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
