Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbXIRU3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbXIRU3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 16:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757490AbXIRU3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 16:29:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56988 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316AbXIRU3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 16:29:11 -0400
Date: Tue, 18 Sep 2007 22:26:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>, Alexey Dobriyan <adobriyan@sw.ru>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/2] lockdep: annotate rcu_read_lock()
Message-ID: <20070918222645.4d8cbf99@lappy>
In-Reply-To: <20070918182924.GF8665@linux.vnet.ibm.com>
References: <20070918091728.GA6766@localhost.sw.ru>
	<20070918031723.05689e92.akpm@linux-foundation.org>
	<46EFA8DC.2020909@bull.net>
	<20070918033400.495b02dd.akpm@linux-foundation.org>
	<20070918142451.418b3b51@twins>
	<20070918161337.GC8665@linux.vnet.ibm.com>
	<20070918095715.05899d12.akpm@linux-foundation.org>
	<20070918182924.GF8665@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.11.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lockdep annotate rcu_read_lock() so that it will find unbalanced
locking.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/lockdep.h  |    7 +++++++
 include/linux/rcupdate.h |   12 ++++++++++++
 kernel/rcupdate.c        |    8 ++++++++
 3 files changed, 27 insertions(+)

Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h
+++ linux-2.6/include/linux/lockdep.h
@@ -252,6 +252,13 @@ extern void lockdep_init_map(struct lock
 			     struct lock_class_key *key, int subclass);
 
 /*
+ * To initialize a lockdep_map statically use this macro.
+ * Note that _name must not be NULL.
+ */
+#define STATIC_LOCKDEP_MAP_INIT(_name, _key) \
+	{ .name = (_name), .key = (void *)(_key), }
+
+/*
  * Reinitialize a lock key - for cases where there is special locking or
  * special initialization of locks so that the validator gets the scope
  * of dependencies wrong: they are either too broad (they need a class-split)
Index: linux-2.6/include/linux/rcupdate.h
===================================================================
--- linux-2.6.orig/include/linux/rcupdate.h
+++ linux-2.6/include/linux/rcupdate.h
@@ -41,6 +41,7 @@
 #include <linux/percpu.h>
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
+#include <linux/lockdep.h>
 
 /**
  * struct rcu_head - callback structure for use with RCU
@@ -133,6 +134,15 @@ static inline void rcu_bh_qsctr_inc(int 
 extern int rcu_pending(int cpu);
 extern int rcu_needs_cpu(int cpu);
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+extern struct lockdep_map rcu_lock_map;
+# define rcu_read_acquire()	lock_acquire(&rcu_lock_map, 0, 0, 2, 1, _THIS_IP_)
+# define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
+#else
+# define rcu_read_acquire()	do { } while (0)
+# define rcu_read_release()	do { } while (0)
+#endif
+
 /**
  * rcu_read_lock - mark the beginning of an RCU read-side critical section.
  *
@@ -166,6 +176,7 @@ extern int rcu_needs_cpu(int cpu);
 	do { \
 		preempt_disable(); \
 		__acquire(RCU); \
+		rcu_read_acquire(); \
 	} while(0)
 
 /**
@@ -175,6 +186,7 @@ extern int rcu_needs_cpu(int cpu);
  */
 #define rcu_read_unlock() \
 	do { \
+		rcu_read_release(); \
 		__release(RCU); \
 		preempt_enable(); \
 	} while(0)
Index: linux-2.6/kernel/rcupdate.c
===================================================================
--- linux-2.6.orig/kernel/rcupdate.c
+++ linux-2.6/kernel/rcupdate.c
@@ -48,6 +48,14 @@
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+static struct lock_class_key rcu_lock_key;
+struct lockdep_map rcu_lock_map =
+	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock", &rcu_lock_key);
+
+EXPORT_SYMBOL_GPL(rcu_lock_map);
+#endif
+
 /* Definition for rcupdate control block. */
 static struct rcu_ctrlblk rcu_ctrlblk = {
 	.cur = -300,
