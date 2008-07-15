Return-Path: <linux-kernel-owner+w=401wt.eu-S1764108AbYGOWfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764108AbYGOWfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763259AbYGOWao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:30:44 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:47637 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763248AbYGOWam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:30:42 -0400
Message-Id: <20080715222746.136282703@polymtl.ca>
References: <20080715222604.331269462@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jul 2008 18:26:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
Subject: [patch 01/17] RCU read sched
Content-Disposition: inline; filename=rcu-read-sched.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue, 15 Jul 2008 22:27:49 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add rcu_read_lock_sched() and rcu_read_unlock_sched() to rcupdate.h to match the
recently added write-side call_rcu_sched() and rcu_barrier_sched(). They also
match the no-so-recently-added synchronize_sched().

It will help following matching use of the update/read lock primitives. Those
new read lock will replace preempt_disable()/enable() used in pair with
RCU-classic synchronization.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Paul E McKenney <paulmck@linux.vnet.ibm.com>
CC: akpm@linux-foundation.org
---
 include/linux/rcupdate.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

Index: linux-2.6-lttng/include/linux/rcupdate.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/rcupdate.h	2008-07-15 15:28:08.000000000 -0400
+++ linux-2.6-lttng/include/linux/rcupdate.h	2008-07-15 17:38:02.000000000 -0400
@@ -133,6 +133,24 @@ struct rcu_head {
 #define rcu_read_unlock_bh() __rcu_read_unlock_bh()
 
 /**
+ * rcu_read_lock_sched - mark the beginning of a RCU-classic critical section
+ *
+ * Should be used with either
+ * - synchronize_sched()
+ * or
+ * - call_rcu_sched() and rcu_barrier_sched()
+ * on the write-side to insure proper synchronization.
+ */
+#define rcu_read_lock_sched() preempt_disable()
+
+/*
+ * rcu_read_unlock_sched - marks the end of a RCU-classic critical section
+ *
+ * See rcu_read_lock_sched for more information.
+ */
+#define rcu_read_unlock_sched() preempt_enable()
+
+/**
  * rcu_dereference - fetch an RCU-protected pointer in an
  * RCU read-side critical section.  This pointer may later
  * be safely dereferenced.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
