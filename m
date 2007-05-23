Return-Path: <linux-kernel-owner+w=401wt.eu-S1765515AbXEWKC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765515AbXEWKC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 06:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758853AbXEWKCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 06:02:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756828AbXEWKCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 06:02:34 -0400
Message-Id: <20070523095807.735979042@chello.nl>
References: <20070523072618.129001605@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 23 May 2007 11:57:22 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 6/7] lockdep: runtime configure prove_locking and lock_stat
Content-Disposition: inline; filename=lockstat-sysctl.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allow for runtime configuration of lockdep and lockstat.

  /proc/sys/kernel/prove_locking
  /proc/sys/kernel/lock_stat

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |   27 +++++++++++++++++++++++++++
 kernel/sysctl.c  |   27 +++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c	2007-05-23 01:14:03.000000000 +0200
+++ linux-2.6/kernel/lockdep.c	2007-05-23 01:14:25.000000000 +0200
@@ -42,6 +42,16 @@
 
 #include "lockdep_internals.h"
 
+#ifdef CONFIG_PROVE_LOCKING
+int prove_locking = 1;
+module_param(prove_locking, int, 0644);
+#endif
+
+#ifdef CONFIG_LOCK_STAT
+int lock_stat = 1;
+module_param(lock_stat, int, 0644);
+#endif
+
 /*
  * lockdep_lock: protects the lockdep graph, the hashes and the
  *               class/list/hash allocators.
@@ -2091,9 +2101,13 @@ static int __lock_acquire(struct lockdep
 	hlock->waittime_stamp = 0;
 	hlock->holdtime_stamp = sched_clock();
 #endif
+#ifdef CONFIG_PROVE_LOCKING
+	if (!prove_locking)
+		goto out_irqflags;
 
 	if (check != 2)
 		goto out_calc_hash;
+#endif
 #ifdef CONFIG_TRACE_IRQFLAGS
 	/*
 	 * If non-trylock use in a hardirq or softirq context, then
@@ -2138,6 +2152,7 @@ static int __lock_acquire(struct lockdep
 		}
 	}
 #endif
+out_irqflags:
 	/* mark it as used: */
 	if (!mark_lock(curr, hlock, LOCK_USED))
 		return 0;
@@ -2190,6 +2205,8 @@ out_calc_hash:
 	curr->curr_chain_key = chain_key;
 
 #ifdef CONFIG_PROVE_LOCKING
+	if (!prove_locking)
+		goto out_graph;
 	/*
 	 * Trylock needs to maintain the stack of held locks, but it
 	 * does not add new dependencies, because trylock can be done
@@ -2236,6 +2253,7 @@ out_calc_hash:
 		/* after lookup_chain_cache(): */
 		if (unlikely(!debug_locks))
 			return 0;
+out_graph:
 #endif
 
 	curr->lockdep_depth++;
@@ -2349,6 +2367,9 @@ static void lock_release_holdtime(struct
 {
 	unsigned long long holdtime;
 
+	if (!lock_stat)
+		return;
+
 	holdtime = sched_clock() - hlock->holdtime_stamp;
 
 	if (hlock->read)
@@ -2659,6 +2680,9 @@ void lock_contended(struct lockdep_map *
 {
 	unsigned long flags;
 
+	if (!lock_stat)
+		return;
+
 	if (unlikely(current->lockdep_recursion))
 		return;
 
@@ -2675,6 +2699,9 @@ void lock_acquired(struct lockdep_map *l
 {
 	unsigned long flags;
 
+	if (!lock_stat)
+		return;
+
 	if (unlikely(current->lockdep_recursion))
 		return;
 
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c	2007-05-23 01:13:01.000000000 +0200
+++ linux-2.6/kernel/sysctl.c	2007-05-23 01:14:10.000000000 +0200
@@ -160,6 +160,13 @@ extern ctl_table inotify_table[];
 int sysctl_legacy_va_layout;
 #endif
 
+#ifdef CONFIG_PROVE_LOCKING
+extern int prove_locking;
+#endif
+
+#ifdef CONFIG_LOCK_STAT
+extern int lock_stat;
+#endif
 
 /* The default sysctl tables: */
 
@@ -615,6 +622,26 @@ static ctl_table kern_table[] = {
 		.proc_handler   = &proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_PROVE_LOCKING
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "prove_locking",
+		.data		= &prove_locking,
+		.maxlen		= sizeof(int),
+		.mode		= 0664,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
+#ifdef CONFIG_LOCK_STAT
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "lock_stat",
+		.data		= &lock_stat,
+		.maxlen		= sizeof(int),
+		.mode		= 0664,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
 
 	{ .ctl_name = 0 }
 };

-- 

