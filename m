Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab0BWBFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 20:05:19 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47423 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab0BWBFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 20:05:13 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/21] rcu: add lockdep-enabled variants of rcu_dereference()
Date: Mon, 22 Feb 2010 17:04:46 -0800
Message-Id: <1266887105-1528-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100223010435.GA666@linux.vnet.ibm.com>
References: <20100223010435.GA666@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make rcu_dereference() check for being in an RCU read-side critical
section, and create rcu_dereference_bh(), rcu_dereference_sched(), and
srcu_dereference() to check for the other flavors of RCU.  Also create
rcu_dereference_raw() to avoid checking, and make rcu_dereference_check()
use rcu_dereference_raw().

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   41 ++++++++++++++++++++++++++++++++++-------
 include/linux/srcu.h     |    8 ++++++++
 2 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index e3d37ef..839d296 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -184,12 +184,12 @@ static inline int rcu_read_lock_sched_held(void)
 	({ \
 		if (debug_locks) \
 			WARN_ON_ONCE(!(c)); \
-		rcu_dereference(p); \
+		rcu_dereference_raw(p); \
 	})
 
 #else /* #ifdef CONFIG_PROVE_RCU */
 
-#define rcu_dereference_check(p, c)	rcu_dereference(p)
+#define rcu_dereference_check(p, c)	rcu_dereference_raw(p)
 
 #endif /* #else #ifdef CONFIG_PROVE_RCU */
 
@@ -325,22 +325,49 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 
 
 /**
- * rcu_dereference - fetch an RCU-protected pointer in an
- * RCU read-side critical section.  This pointer may later
- * be safely dereferenced.
+ * rcu_dereference_raw - fetch an RCU-protected pointer
+ *
+ * The caller must be within some flavor of RCU read-side critical
+ * section, or must be otherwise preventing the pointer from changing,
+ * for example, by holding an appropriate lock.  This pointer may later
+ * be safely dereferenced.  It is the caller's responsibility to have
+ * done the right thing, as this primitive does no checking of any kind.
  *
  * Inserts memory barriers on architectures that require them
  * (currently only the Alpha), and, more importantly, documents
  * exactly which pointers are protected by RCU.
  */
-
-#define rcu_dereference(p)     ({ \
+#define rcu_dereference_raw(p)	({ \
 				typeof(p) _________p1 = ACCESS_ONCE(p); \
 				smp_read_barrier_depends(); \
 				(_________p1); \
 				})
 
 /**
+ * rcu_dereference - fetch an RCU-protected pointer, checking for RCU
+ *
+ * Makes rcu_dereference_check() do the dirty work.
+ */
+#define rcu_dereference(p) \
+	rcu_dereference_check(p, rcu_read_lock_held())
+
+/**
+ * rcu_dereference_bh - fetch an RCU-protected pointer, checking for RCU-bh
+ *
+ * Makes rcu_dereference_check() do the dirty work.
+ */
+#define rcu_dereference_bh(p) \
+		rcu_dereference_check(p, rcu_read_lock_bh_held())
+
+/**
+ * rcu_dereference_sched - fetch RCU-protected pointer, checking for RCU-sched
+ *
+ * Makes rcu_dereference_check() do the dirty work.
+ */
+#define rcu_dereference_sched(p) \
+		rcu_dereference_check(p, rcu_read_lock_sched_held())
+
+/**
  * rcu_assign_pointer - assign (publicize) a pointer to a newly
  * initialized structure that will be dereferenced by RCU read-side
  * critical sections.  Returns the value assigned.
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index adbe167..3084f80 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -106,6 +106,14 @@ static inline int srcu_read_lock_held(struct srcu_struct *sp)
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 /**
+ * srcu_dereference - fetch SRCU-protected pointer with checking
+ *
+ * Makes rcu_dereference_check() do the dirty work.
+ */
+#define srcu_dereference(p, sp) \
+		rcu_dereference_check(p, srcu_read_lock_held(sp))
+
+/**
  * srcu_read_lock - register a new reader for an SRCU-protected structure.
  * @sp: srcu_struct in which to register the new reader.
  *
-- 
1.6.6

