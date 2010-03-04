Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab0CDBur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 20:50:47 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52025 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755575Ab0CDBuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 20:50:23 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/3] rcu: Make rcu_read_lock_sched_held() handle !PREEMPT
Date: Wed,  3 Mar 2010 17:50:16 -0800
Message-Id: <1267667418-32233-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100304015001.GA32190@linux.vnet.ibm.com>
References: <20100304015001.GA32190@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rcu_read_lock_sched_held() needs to unconditionally return the value
"1" in a !PREEMPT kernel, because under !PREEMPT, -all- kernel code is
implicitly preempt-disabled.  This patch makes this happen.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index fb80ce3..e0da43e 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -147,6 +147,7 @@ static inline int rcu_read_lock_bh_held(void)
  *
  * Check rcu_scheduler_active to prevent false positives during boot.
  */
+#ifdef CONFIG_PREEMPT
 static inline int rcu_read_lock_sched_held(void)
 {
 	int lockdep_opinion = 0;
@@ -157,6 +158,12 @@ static inline int rcu_read_lock_sched_held(void)
 		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
 	return lockdep_opinion || preempt_count() != 0;
 }
+#else /* #ifdef CONFIG_PREEMPT */
+static inline int rcu_read_lock_sched_held(void)
+{
+	return 1;
+}
+#endif /* #else #ifdef CONFIG_PREEMPT */
 
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
@@ -181,10 +188,17 @@ static inline int rcu_read_lock_bh_held(void)
 	return 1;
 }
 
+#ifdef CONFIG_PREEMPT
 static inline int rcu_read_lock_sched_held(void)
 {
 	return !rcu_scheduler_active || preempt_count() != 0;
 }
+#else /* #ifdef CONFIG_PREEMPT */
+static inline int rcu_read_lock_sched_held(void)
+{
+	return 1;
+}
+#endif /* #else #ifdef CONFIG_PREEMPT */
 
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
-- 
1.6.6

