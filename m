Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab0CEXDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 18:03:53 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52704 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898Ab0CEXDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 18:03:33 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Subject: [PATCH tip/core/rcu 1/3] ftrace: replace read_barrier_depends() with rcu_dereference_raw()
Date: Fri,  5 Mar 2010 15:03:25 -0800
Message-Id: <1267830207-9474-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100305230256.GA9410@linux.vnet.ibm.com>
References: <20100305230256.GA9410@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the calls to read_barrier_depends() in ftrace_list_func() with
rcu_dereference_raw() to improve readability.  The reason that we use
rcu_dereference_raw() here is that removed entries are never freed,
instead they are simply leaked.  This is one of a very few cases where
use of rcu_dereference_raw() is the long-term right answer.  And I don't
yet know of any others.  ;-)

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/trace/ftrace.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8378357..8c5adc0 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -27,6 +27,7 @@
 #include <linux/ctype.h>
 #include <linux/list.h>
 #include <linux/hash.h>
+#include <linux/rcupdate.h>
 
 #include <trace/events/sched.h>
 
@@ -88,18 +89,22 @@ ftrace_func_t ftrace_pid_function __read_mostly = ftrace_stub;
 static int ftrace_set_func(unsigned long *array, int *idx, char *buffer);
 #endif
 
+/*
+ * Traverse the ftrace_list, invoking all entries.  The reason that we
+ * can use rcu_dereference_raw() is that elements removed from this list
+ * are simply leaked, so there is no need to interact with a grace-period
+ * mechanism.  The rcu_dereference_raw() calls are needed to handle
+ * concurrent insertions into the ftrace_list.
+ *
+ * Silly Alpha and silly pointer-speculation compiler optimizations!
+ */
 static void ftrace_list_func(unsigned long ip, unsigned long parent_ip)
 {
-	struct ftrace_ops *op = ftrace_list;
-
-	/* in case someone actually ports this to alpha! */
-	read_barrier_depends();
+	struct ftrace_ops *op = rcu_dereference_raw(ftrace_list); /*see above*/
 
 	while (op != &ftrace_list_end) {
-		/* silly alpha */
-		read_barrier_depends();
 		op->func(ip, parent_ip);
-		op = op->next;
+		op = rcu_dereference_raw(op->next); /*see above*/
 	};
 }
 
@@ -154,8 +159,7 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 	 * the ops->next pointer is valid before another CPU sees
 	 * the ops pointer included into the ftrace_list.
 	 */
-	smp_wmb();
-	ftrace_list = ops;
+	rcu_assign_pointer(ftrace_list, ops);
 
 	if (ftrace_enabled) {
 		ftrace_func_t func;
-- 
1.6.6

