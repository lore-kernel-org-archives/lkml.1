Return-Path: <linux-kernel-owner+w=401wt.eu-S1760999AbZDQBDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760999AbZDQBDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 21:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757917AbZDQBCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 21:02:53 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:55726 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761349AbZDQBCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 21:02:52 -0400
Message-Id: <20090417003931.846405986@polymtl.ca>
References: <20090417003755.276959950@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 16 Apr 2009 20:37:57 -0400
From: mathieu.desnoyers@polymtl.ca
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>
Subject: [patch 2/3] RCU move trace defines to rcupdate_types.h
Content-Disposition: inline; filename=rcu-move-trace-defines-to-rcupdate_types-header.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 17 Apr 2009 01:01:17 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given tracepoint.h need to include the minimal set of headers, split some
RCU defines from the global rcupdate.h header.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Hellwig <hch@lst.de>
---
 include/linux/rcupdate.h       |  128 --------------------------------
 include/linux/rcupdate_types.h |  163 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 165 insertions(+), 126 deletions(-)

Index: linux.trees.git/include/linux/rcupdate.h
===================================================================
--- linux.trees.git.orig/include/linux/rcupdate.h	2009-04-16 20:34:19.000000000 -0400
+++ linux.trees.git/include/linux/rcupdate.h	2009-04-16 20:35:23.000000000 -0400
@@ -40,6 +40,7 @@
 #include <linux/seqlock.h>
 #include <linux/lockdep.h>
 #include <linux/completion.h>
+#include <linux/rcupdate_types.h>
 
 /**
  * struct rcu_head - callback structure for use with RCU
@@ -70,132 +71,7 @@ extern int rcu_scheduler_active;
        (ptr)->next = NULL; (ptr)->func = NULL; \
 } while (0)
 
-/**
- * rcu_read_lock - mark the beginning of an RCU read-side critical section.
- *
- * When synchronize_rcu() is invoked on one CPU while other CPUs
- * are within RCU read-side critical sections, then the
- * synchronize_rcu() is guaranteed to block until after all the other
- * CPUs exit their critical sections.  Similarly, if call_rcu() is invoked
- * on one CPU while other CPUs are within RCU read-side critical
- * sections, invocation of the corresponding RCU callback is deferred
- * until after the all the other CPUs exit their critical sections.
- *
- * Note, however, that RCU callbacks are permitted to run concurrently
- * with RCU read-side critical sections.  One way that this can happen
- * is via the following sequence of events: (1) CPU 0 enters an RCU
- * read-side critical section, (2) CPU 1 invokes call_rcu() to register
- * an RCU callback, (3) CPU 0 exits the RCU read-side critical section,
- * (4) CPU 2 enters a RCU read-side critical section, (5) the RCU
- * callback is invoked.  This is legal, because the RCU read-side critical
- * section that was running concurrently with the call_rcu() (and which
- * therefore might be referencing something that the corresponding RCU
- * callback would free up) has completed before the corresponding
- * RCU callback is invoked.
- *
- * RCU read-side critical sections may be nested.  Any deferred actions
- * will be deferred until the outermost RCU read-side critical section
- * completes.
- *
- * It is illegal to block while in an RCU read-side critical section.
- */
-#define rcu_read_lock() __rcu_read_lock()
-
-/**
- * rcu_read_unlock - marks the end of an RCU read-side critical section.
- *
- * See rcu_read_lock() for more information.
- */
-
-/*
- * So where is rcu_write_lock()?  It does not exist, as there is no
- * way for writers to lock out RCU readers.  This is a feature, not
- * a bug -- this property is what provides RCU's performance benefits.
- * Of course, writers must coordinate with each other.  The normal
- * spinlock primitives work well for this, but any other technique may be
- * used as well.  RCU does not care how the writers keep out of each
- * others' way, as long as they do so.
- */
-#define rcu_read_unlock() __rcu_read_unlock()
-
-/**
- * rcu_read_lock_bh - mark the beginning of a softirq-only RCU critical section
- *
- * This is equivalent of rcu_read_lock(), but to be used when updates
- * are being done using call_rcu_bh(). Since call_rcu_bh() callbacks
- * consider completion of a softirq handler to be a quiescent state,
- * a process in RCU read-side critical section must be protected by
- * disabling softirqs. Read-side critical sections in interrupt context
- * can use just rcu_read_lock().
- *
- */
-#define rcu_read_lock_bh() __rcu_read_lock_bh()
-
-/*
- * rcu_read_unlock_bh - marks the end of a softirq-only RCU critical section
- *
- * See rcu_read_lock_bh() for more information.
- */
-#define rcu_read_unlock_bh() __rcu_read_unlock_bh()
-
-/**
- * rcu_read_lock_sched - mark the beginning of a RCU-classic critical section
- *
- * Should be used with either
- * - synchronize_sched()
- * or
- * - call_rcu_sched() and rcu_barrier_sched()
- * on the write-side to insure proper synchronization.
- */
-#define rcu_read_lock_sched() preempt_disable()
-#define rcu_read_lock_sched_notrace() preempt_disable_notrace()
-
-/*
- * rcu_read_unlock_sched - marks the end of a RCU-classic critical section
- *
- * See rcu_read_lock_sched for more information.
- */
-#define rcu_read_unlock_sched() preempt_enable()
-#define rcu_read_unlock_sched_notrace() preempt_enable_notrace()
-
-
-
-/**
- * rcu_dereference - fetch an RCU-protected pointer in an
- * RCU read-side critical section.  This pointer may later
- * be safely dereferenced.
- *
- * Inserts memory barriers on architectures that require them
- * (currently only the Alpha), and, more importantly, documents
- * exactly which pointers are protected by RCU.
- */
-
-#define rcu_dereference(p)     ({ \
-				typeof(p) _________p1 = ACCESS_ONCE(p); \
-				smp_read_barrier_depends(); \
-				(_________p1); \
-				})
-
-/**
- * rcu_assign_pointer - assign (publicize) a pointer to a newly
- * initialized structure that will be dereferenced by RCU read-side
- * critical sections.  Returns the value assigned.
- *
- * Inserts memory barriers on architectures that require them
- * (pretty much all of them other than x86), and also prevents
- * the compiler from reordering the code that initializes the
- * structure after the pointer assignment.  More importantly, this
- * call documents which pointers will be dereferenced by RCU read-side
- * code.
- */
-
-#define rcu_assign_pointer(p, v) \
-	({ \
-		if (!__builtin_constant_p(v) || \
-		    ((v) != NULL)) \
-			smp_wmb(); \
-		(p) = (v); \
-	})
+/* See linux/rcupdate_types.h for read-side locking primitives */
 
 /* Infrastructure to implement the synchronize_() primitives. */
 
Index: linux.trees.git/include/linux/rcupdate_types.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/linux/rcupdate_types.h	2009-04-16 20:35:09.000000000 -0400
@@ -0,0 +1,163 @@
+/*
+ * Read-Copy Update mechanism for mutual exclusion - read-side definitions
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright IBM Corporation, 2001
+ *
+ * Author: Dipankar Sarma <dipankar@in.ibm.com>
+ *
+ * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
+ * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
+ * Papers:
+ * http://www.rdrop.com/users/paulmck/paper/rclockpdcsproof.pdf
+ * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
+ *
+ * For detailed explanation of Read-Copy Update mechanism see -
+ * 		http://lse.sourceforge.net/locking/rcupdate.html
+ *
+ */
+
+#ifndef __LINUX_RCUPDATE_TYPES_H
+#define __LINUX_RCUPDATE_TYPES_H
+
+/**
+ * rcu_read_lock - mark the beginning of an RCU read-side critical section.
+ *
+ * When synchronize_rcu() is invoked on one CPU while other CPUs
+ * are within RCU read-side critical sections, then the
+ * synchronize_rcu() is guaranteed to block until after all the other
+ * CPUs exit their critical sections.  Similarly, if call_rcu() is invoked
+ * on one CPU while other CPUs are within RCU read-side critical
+ * sections, invocation of the corresponding RCU callback is deferred
+ * until after the all the other CPUs exit their critical sections.
+ *
+ * Note, however, that RCU callbacks are permitted to run concurrently
+ * with RCU read-side critical sections.  One way that this can happen
+ * is via the following sequence of events: (1) CPU 0 enters an RCU
+ * read-side critical section, (2) CPU 1 invokes call_rcu() to register
+ * an RCU callback, (3) CPU 0 exits the RCU read-side critical section,
+ * (4) CPU 2 enters a RCU read-side critical section, (5) the RCU
+ * callback is invoked.  This is legal, because the RCU read-side critical
+ * section that was running concurrently with the call_rcu() (and which
+ * therefore might be referencing something that the corresponding RCU
+ * callback would free up) has completed before the corresponding
+ * RCU callback is invoked.
+ *
+ * RCU read-side critical sections may be nested.  Any deferred actions
+ * will be deferred until the outermost RCU read-side critical section
+ * completes.
+ *
+ * It is illegal to block while in an RCU read-side critical section.
+ */
+#define rcu_read_lock() __rcu_read_lock()
+
+/**
+ * rcu_read_unlock - marks the end of an RCU read-side critical section.
+ *
+ * See rcu_read_lock() for more information.
+ */
+
+/*
+ * So where is rcu_write_lock()?  It does not exist, as there is no
+ * way for writers to lock out RCU readers.  This is a feature, not
+ * a bug -- this property is what provides RCU's performance benefits.
+ * Of course, writers must coordinate with each other.  The normal
+ * spinlock primitives work well for this, but any other technique may be
+ * used as well.  RCU does not care how the writers keep out of each
+ * others' way, as long as they do so.
+ */
+#define rcu_read_unlock() __rcu_read_unlock()
+
+/**
+ * rcu_read_lock_bh - mark the beginning of a softirq-only RCU critical section
+ *
+ * This is equivalent of rcu_read_lock(), but to be used when updates
+ * are being done using call_rcu_bh(). Since call_rcu_bh() callbacks
+ * consider completion of a softirq handler to be a quiescent state,
+ * a process in RCU read-side critical section must be protected by
+ * disabling softirqs. Read-side critical sections in interrupt context
+ * can use just rcu_read_lock().
+ *
+ */
+#define rcu_read_lock_bh() __rcu_read_lock_bh()
+
+/*
+ * rcu_read_unlock_bh - marks the end of a softirq-only RCU critical section
+ *
+ * See rcu_read_lock_bh() for more information.
+ */
+#define rcu_read_unlock_bh() __rcu_read_unlock_bh()
+
+/**
+ * rcu_read_lock_sched - mark the beginning of a RCU-classic critical section
+ *
+ * Should be used with either
+ * - synchronize_sched()
+ * or
+ * - call_rcu_sched() and rcu_barrier_sched()
+ * on the write-side to insure proper synchronization.
+ */
+#define rcu_read_lock_sched() preempt_disable()
+#define rcu_read_lock_sched_notrace() preempt_disable_notrace()
+
+/*
+ * rcu_read_unlock_sched - marks the end of a RCU-classic critical section
+ *
+ * See rcu_read_lock_sched for more information.
+ */
+#define rcu_read_unlock_sched() preempt_enable()
+#define rcu_read_unlock_sched_notrace() preempt_enable_notrace()
+
+
+
+/**
+ * rcu_dereference - fetch an RCU-protected pointer in an
+ * RCU read-side critical section.  This pointer may later
+ * be safely dereferenced.
+ *
+ * Inserts memory barriers on architectures that require them
+ * (currently only the Alpha), and, more importantly, documents
+ * exactly which pointers are protected by RCU.
+ */
+
+#define rcu_dereference(p)     ({ \
+				typeof(p) _________p1 = ACCESS_ONCE(p); \
+				smp_read_barrier_depends(); \
+				(_________p1); \
+				})
+
+/**
+ * rcu_assign_pointer - assign (publicize) a pointer to a newly
+ * initialized structure that will be dereferenced by RCU read-side
+ * critical sections.  Returns the value assigned.
+ *
+ * Inserts memory barriers on architectures that require them
+ * (pretty much all of them other than x86), and also prevents
+ * the compiler from reordering the code that initializes the
+ * structure after the pointer assignment.  More importantly, this
+ * call documents which pointers will be dereferenced by RCU read-side
+ * code.
+ */
+
+#define rcu_assign_pointer(p, v) \
+	({ \
+		if (!__builtin_constant_p(v) || \
+		    ((v) != NULL)) \
+			smp_wmb(); \
+		(p) = (v); \
+	})
+
+#endif /* __LINUX_RCUPDATE_TYPES_H */

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
