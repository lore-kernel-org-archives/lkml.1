Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbZHWJCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbZHWJCm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 05:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755917AbZHWJCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 05:02:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:36936 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755908AbZHWJCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 05:02:36 -0400
Date: Sun, 23 Aug 2009 09:02:06 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12509746132349-git-send-email->
References: <12509746132349-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Consolidate sparse and lockdep declarations in include/linux/rcupdate.h
Message-ID: <tip-bc33f24bdca8b6e97376e3a182ab69e6cdefa989@git.kernel.org>
Git-Commit-ID: bc33f24bdca8b6e97376e3a182ab69e6cdefa989
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 23 Aug 2009 09:02:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bc33f24bdca8b6e97376e3a182ab69e6cdefa989
Gitweb:     http://git.kernel.org/tip/bc33f24bdca8b6e97376e3a182ab69e6cdefa989
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Sat, 22 Aug 2009 13:56:47 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 23 Aug 2009 10:32:37 +0200

rcu: Consolidate sparse and lockdep declarations in include/linux/rcupdate.h

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: josht@linux.vnet.ibm.com
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
LKML-Reference: <12509746132349-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/rcupdate.h   |   46 ++++++++++++++++++++++++++++++++++++++++---
 include/linux/rcupreempt.h |    4 +-
 include/linux/rcutree.h    |   18 -----------------
 3 files changed, 44 insertions(+), 24 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index e920f0f..9d85ee1 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -80,6 +80,16 @@ extern int rcu_scheduler_active;
        (ptr)->next = NULL; (ptr)->func = NULL; \
 } while (0)
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+extern struct lockdep_map rcu_lock_map;
+# define rcu_read_acquire()	\
+			lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
+# define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
+#else
+# define rcu_read_acquire()	do { } while (0)
+# define rcu_read_release()	do { } while (0)
+#endif
+
 /**
  * rcu_read_lock - mark the beginning of an RCU read-side critical section.
  *
@@ -109,7 +119,12 @@ extern int rcu_scheduler_active;
  *
  * It is illegal to block while in an RCU read-side critical section.
  */
-#define rcu_read_lock() __rcu_read_lock()
+static inline void rcu_read_lock(void)
+{
+	__rcu_read_lock();
+	__acquire(RCU);
+	rcu_read_acquire();
+}
 
 /**
  * rcu_read_unlock - marks the end of an RCU read-side critical section.
@@ -126,7 +141,12 @@ extern int rcu_scheduler_active;
  * used as well.  RCU does not care how the writers keep out of each
  * others' way, as long as they do so.
  */
-#define rcu_read_unlock() __rcu_read_unlock()
+static inline void rcu_read_unlock(void)
+{
+	rcu_read_release();
+	__release(RCU);
+	__rcu_read_unlock();
+}
 
 /**
  * rcu_read_lock_bh - mark the beginning of a softirq-only RCU critical section
@@ -139,14 +159,24 @@ extern int rcu_scheduler_active;
  * can use just rcu_read_lock().
  *
  */
-#define rcu_read_lock_bh() __rcu_read_lock_bh()
+static inline void rcu_read_lock_bh(void)
+{
+	__rcu_read_lock_bh();
+	__acquire(RCU_BH);
+	rcu_read_acquire();
+}
 
 /*
  * rcu_read_unlock_bh - marks the end of a softirq-only RCU critical section
  *
  * See rcu_read_lock_bh() for more information.
  */
-#define rcu_read_unlock_bh() __rcu_read_unlock_bh()
+static inline void rcu_read_unlock_bh(void)
+{
+	rcu_read_release();
+	__release(RCU_BH);
+	__rcu_read_unlock_bh();
+}
 
 /**
  * rcu_read_lock_sched - mark the beginning of a RCU-classic critical section
@@ -160,10 +190,14 @@ extern int rcu_scheduler_active;
 static inline void rcu_read_lock_sched(void)
 {
 	preempt_disable();
+	__acquire(RCU_SCHED);
+	rcu_read_acquire();
 }
 static inline void rcu_read_lock_sched_notrace(void)
 {
 	preempt_disable_notrace();
+	__acquire(RCU_SCHED);
+	rcu_read_acquire();
 }
 
 /*
@@ -173,10 +207,14 @@ static inline void rcu_read_lock_sched_notrace(void)
  */
 static inline void rcu_read_unlock_sched(void)
 {
+	rcu_read_release();
+	__release(RCU_SCHED);
 	preempt_enable();
 }
 static inline void rcu_read_unlock_sched_notrace(void)
 {
+	rcu_read_release();
+	__release(RCU_SCHED);
 	preempt_enable_notrace();
 }
 
diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
index 2963f08..6c9dd9c 100644
--- a/include/linux/rcupreempt.h
+++ b/include/linux/rcupreempt.h
@@ -64,8 +64,8 @@ static inline void rcu_bh_qs(int cpu) { }
 extern void call_rcu_sched(struct rcu_head *head,
 			   void (*func)(struct rcu_head *head));
 
-extern void __rcu_read_lock(void)	__acquires(RCU);
-extern void __rcu_read_unlock(void)	__releases(RCU);
+extern void __rcu_read_lock(void);
+extern void __rcu_read_unlock(void);
 extern int rcu_pending(int cpu);
 extern int rcu_needs_cpu(int cpu);
 
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index a0852d0..8a0222c 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -36,38 +36,20 @@ extern void rcu_bh_qs(int cpu);
 extern int rcu_pending(int cpu);
 extern int rcu_needs_cpu(int cpu);
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-extern struct lockdep_map rcu_lock_map;
-# define rcu_read_acquire()	\
-			lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
-# define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
-#else
-# define rcu_read_acquire()	do { } while (0)
-# define rcu_read_release()	do { } while (0)
-#endif
-
 static inline void __rcu_read_lock(void)
 {
 	preempt_disable();
-	__acquire(RCU);
-	rcu_read_acquire();
 }
 static inline void __rcu_read_unlock(void)
 {
-	rcu_read_release();
-	__release(RCU);
 	preempt_enable();
 }
 static inline void __rcu_read_lock_bh(void)
 {
 	local_bh_disable();
-	__acquire(RCU_BH);
-	rcu_read_acquire();
 }
 static inline void __rcu_read_unlock_bh(void)
 {
-	rcu_read_release();
-	__release(RCU_BH);
 	local_bh_enable();
 }
 
