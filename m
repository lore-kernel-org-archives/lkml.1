Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab0CKOiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:38:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:35292 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757919Ab0CKOis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:38:48 -0500
Date: Thu, 11 Mar 2010 14:38:18 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1267830207-9474-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1267830207-9474-1-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] ftrace: Replace read_barrier_depends() with rcu_dereference_raw()
Message-ID: <tip-3f379b03fbfddd20536389a85c6456f8233d1f8d@git.kernel.org>
Git-Commit-ID: 3f379b03fbfddd20536389a85c6456f8233d1f8d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 14:38:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f379b03fbfddd20536389a85c6456f8233d1f8d
Gitweb:     http://git.kernel.org/tip/3f379b03fbfddd20536389a85c6456f8233d1f8d
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Fri, 5 Mar 2010 15:03:25 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 13:38:01 +0100

ftrace: Replace read_barrier_depends() with rcu_dereference_raw()

Replace the calls to read_barrier_depends() in
ftrace_list_func() with rcu_dereference_raw() to improve
readability.  The reason that we use rcu_dereference_raw() here
is that removed entries are never freed, instead they are simply
leaked.  This is one of a very few cases where use of
rcu_dereference_raw() is the long-term right answer.  And I
don't yet know of any others.  ;-)

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <1267830207-9474-1-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
