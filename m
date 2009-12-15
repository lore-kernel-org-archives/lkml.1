Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171AbZLOXKB (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 15 Dec 2009 18:10:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbZLOXJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:09:53 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36493 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762348AbZLOXCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:02:50 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 17/18] rcu: Provide different lockdep classes for each flavor of RCU
Date: Tue, 15 Dec 2009 15:02:40 -0800
Message-Id: <12609181611183-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091215230213.GA9093@linux.vnet.ibm.com>
References: <20091215230213.GA9093@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Proposed for 2.6.34, not for inclusion.

In the past, all three flavors of RCU shared a common lockdep class.
This patch gives each of rcu_read_lock(), rcu_read_lock_bh(), and
rcu_read_lock_sched() their own lockdep classes to permit more precise
checking for read-holding the proper flavor of RCU.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   39 +++++++++++++++++++++++++++++----------
 kernel/rcupdate.c        |   10 ++++++++++
 2 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 24440f4..723c564 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -78,14 +78,33 @@ extern void rcu_init(void);
 } while (0)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
+
 extern struct lockdep_map rcu_lock_map;
-# define rcu_read_acquire()	\
-			lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
+# define rcu_read_acquire() \
+		lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
 # define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
-#else
-# define rcu_read_acquire()	do { } while (0)
-# define rcu_read_release()	do { } while (0)
-#endif
+
+extern struct lockdep_map rcu_bh_lock_map;
+# define rcu_read_acquire_bh() \
+		lock_acquire(&rcu_bh_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
+# define rcu_read_release_bh()	lock_release(&rcu_bh_lock_map, 1, _THIS_IP_)
+
+extern struct lockdep_map rcu_sched_lock_map;
+# define rcu_read_acquire_sched() \
+		lock_acquire(&rcu_sched_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
+# define rcu_read_release_sched() \
+		lock_release(&rcu_sched_lock_map, 1, _THIS_IP_)
+
+#else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
+# define rcu_read_acquire()		do { } while (0)
+# define rcu_read_release()		do { } while (0)
+# define rcu_read_acquire_bh()		do { } while (0)
+# define rcu_read_release_bh()		do { } while (0)
+# define rcu_read_acquire_sched()	do { } while (0)
+# define rcu_read_release_sched()	do { } while (0)
+
+#endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 /**
  * rcu_read_lock - mark the beginning of an RCU read-side critical section.
@@ -160,7 +179,7 @@ static inline void rcu_read_lock_bh(void)
 {
 	__rcu_read_lock_bh();
 	__acquire(RCU_BH);
-	rcu_read_acquire();
+	rcu_read_acquire_bh();
 }
 
 /*
@@ -170,7 +189,7 @@ static inline void rcu_read_lock_bh(void)
  */
 static inline void rcu_read_unlock_bh(void)
 {
-	rcu_read_release();
+	rcu_read_release_bh();
 	__release(RCU_BH);
 	__rcu_read_unlock_bh();
 }
@@ -188,7 +207,7 @@ static inline void rcu_read_lock_sched(void)
 {
 	preempt_disable();
 	__acquire(RCU_SCHED);
-	rcu_read_acquire();
+	rcu_read_acquire_sched();
 }
 
 /* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
@@ -205,7 +224,7 @@ static inline notrace void rcu_read_lock_sched_notrace(void)
  */
 static inline void rcu_read_unlock_sched(void)
 {
-	rcu_read_release();
+	rcu_read_release_sched();
 	__release(RCU_SCHED);
 	preempt_enable();
 }
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 9b7fd47..033cb55 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -50,6 +50,16 @@ static struct lock_class_key rcu_lock_key;
 struct lockdep_map rcu_lock_map =
 	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock", &rcu_lock_key);
 EXPORT_SYMBOL_GPL(rcu_lock_map);
+
+static struct lock_class_key rcu_bh_lock_key;
+struct lockdep_map rcu_bh_lock_map =
+	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock_bh", &rcu_bh_lock_key);
+EXPORT_SYMBOL_GPL(rcu_bh_lock_map);
+
+static struct lock_class_key rcu_sched_lock_key;
+struct lockdep_map rcu_sched_lock_map =
+	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock_sched", &rcu_sched_lock_key);
+EXPORT_SYMBOL_GPL(rcu_sched_lock_map);
 #endif
 
 /*
-- 
1.5.2.5

