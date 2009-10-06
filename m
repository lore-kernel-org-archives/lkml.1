Return-Path: <linux-kernel-owner+w=401wt.eu-S932873AbZJFOmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873AbZJFOmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932852AbZJFOl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:41:59 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38670 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932849AbZJFOl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:41:58 -0400
Message-Id: <20091006144038.140258698@polymtl.ca>
References: <20091006143727.868480435@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 06 Oct 2009 10:37:30 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 2/4] tree rcu: Add debug RCU head option
Content-Disposition: inline; filename=rcu-head-debug.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue,  6 Oct 2009 14:40:40 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Poisoning the rcu_head callback list. Only for rcu tree for now.

Helps finding racy users of call_rcu(), which results in hangs because list
entries are overwritten and/or skipped. Using the lower bit to poison because
include/net/dst.h __pad_to_align_refcnt complains when struct rcu_head grows.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: mingo@elte.hu
CC: akpm@linux-foundation.org
---
 include/linux/rcupdate.h |    2 ++
 kernel/rcutree.c         |   10 ++++++++++
 lib/Kconfig.debug        |    9 +++++++++
 3 files changed, 21 insertions(+)

Index: linux-2.6-lttng/include/linux/rcupdate.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/rcupdate.h	2009-10-06 10:35:15.000000000 -0400
+++ linux-2.6-lttng/include/linux/rcupdate.h	2009-10-06 10:35:18.000000000 -0400
@@ -45,6 +45,8 @@
  * struct rcu_head - callback structure for use with RCU
  * @next: next update requests in a list
  * @func: actual update function to call after the grace period.
+ *
+ * Debug mode assumes func pointer value is word-aligned.
  */
 struct rcu_head {
 	struct rcu_head *next;
Index: linux-2.6-lttng/kernel/rcutree.c
===================================================================
--- linux-2.6-lttng.orig/kernel/rcutree.c	2009-10-06 10:35:15.000000000 -0400
+++ linux-2.6-lttng/kernel/rcutree.c	2009-10-06 10:35:27.000000000 -0400
@@ -927,6 +927,10 @@ static void rcu_do_batch(struct rcu_data
 		next = list->next;
 		prefetch(next);
 		trace_rcu_tree_callback(list);
+#ifdef DEBUG_RCU_HEAD
+		WARN_ON_ONCE(!((unsigned long)list->func & 0x1));
+		list->func = (void *)((unsigned long)list->func & ~0x1);
+#endif
 		list->func(list);
 		list = next;
 		if (++count >= rdp->blimit)
@@ -1194,7 +1198,13 @@ __call_rcu(struct rcu_head *head, void (
 	unsigned long flags;
 	struct rcu_data *rdp;
 
+#ifdef DEBUG_RCU_HEAD
+	WARN_ON_ONCE((unsigned long)head->func & 0x1);
+	WARN_ON_ONCE((unsigned long)func & 0x1);
+	head->func = (void *)((unsigned long)func | 0x1);
+#else
 	head->func = func;
+#endif
 	head->next = NULL;
 
 	smp_mb(); /* Ensure RCU update seen before callback registry. */
Index: linux-2.6-lttng/lib/Kconfig.debug
===================================================================
--- linux-2.6-lttng.orig/lib/Kconfig.debug	2009-10-06 10:35:15.000000000 -0400
+++ linux-2.6-lttng/lib/Kconfig.debug	2009-10-06 10:35:18.000000000 -0400
@@ -598,6 +598,15 @@ config DEBUG_LIST
 
 	  If unsure, say N.
 
+config DEBUG_RCU_HEAD
+	bool "Debug RCU callbacks"
+	depends on DEBUG_KERNEL
+	depends on TREE_RCU
+	help
+	  Enable this to turn on debugging of RCU list heads (call_rcu() usage).
+	  Seems to find problems more quickly with stress-tests in single-cpu
+	  mode.
+
 config DEBUG_SG
 	bool "Debug SG table operations"
 	depends on DEBUG_KERNEL

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
