Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758475Ab0BYKK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:10:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:47682 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135Ab0BYKKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:10:19 -0500
Date: Thu, 25 Feb 2010 10:09:32 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, eric.dumazet@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1266887105-1528-2-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1266887105-1528-2-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Add lockdep-enabled variants of rcu_dereference()
Message-ID: <tip-c26d34a5858f96a564c45048bf5f09319d2abad1@git.kernel.org>
Git-Commit-ID: c26d34a5858f96a564c45048bf5f09319d2abad1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 10:09:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c26d34a5858f96a564c45048bf5f09319d2abad1
Gitweb:     http://git.kernel.org/tip/c26d34a5858f96a564c45048bf5f09319d2abad1
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 22 Feb 2010 17:04:46 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 09:41:00 +0100

rcu: Add lockdep-enabled variants of rcu_dereference()

Make rcu_dereference() check for being in an RCU read-side
critical section, and create rcu_dereference_bh(),
rcu_dereference_sched(), and srcu_dereference() to check for the
other flavors of RCU.  Also create rcu_dereference_raw() to
avoid checking, and make rcu_dereference_check() use
rcu_dereference_raw().

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
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
LKML-Reference: <1266887105-1528-2-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
