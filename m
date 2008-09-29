Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbYI2PG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbYI2PG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 11:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYI2PGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 11:06:50 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:57869 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750855AbYI2PGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 11:06:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgUFAL+L4EhMQWq+/2dsb2JhbACBYrowgWc
Date: Mon, 29 Sep 2008 11:06:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] RCU read sched
Message-ID: <20080929150646.GD11245@Krystal>
References: <48E08B05.7030802@cn.fujitsu.com> <20080929082722.GB18663@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080929082722.GB18663@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:06:02 up 116 days, 19:46,  9 users,  load average: 0.82, 0.51,
	0.43
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(probably already in -tip)

Add rcu_read_lock_sched() and rcu_read_unlock_sched() to rcupdate.h to match the
recently added write-side call_rcu_sched() and rcu_barrier_sched(). They also
match the no-so-recently-added synchronize_sched().

It will help following matching use of the update/read lock primitives. Those
new read lock will replace preempt_disable()/enable() used in pair with
RCU-classic synchronization.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Peter Zijlstra <peterz@infradead.org>
CC: Paul E McKenney <paulmck@linux.vnet.ibm.com>
CC: akpm@linux-foundation.org
---
 include/linux/rcupdate.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

Index: linux-2.6-lttng/include/linux/rcupdate.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/rcupdate.h	2008-07-15 15:18:20.000000000 -0400
+++ linux-2.6-lttng/include/linux/rcupdate.h	2008-07-15 15:18:46.000000000 -0400
@@ -132,6 +132,26 @@ struct rcu_head {
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
+
+
+/**
  * rcu_dereference - fetch an RCU-protected pointer in an
  * RCU read-side critical section.  This pointer may later
  * be safely dereferenced.
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
