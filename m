Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbZJZLhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbZJZLhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 07:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755747AbZJZLhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 07:37:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:57215 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729AbZJZLhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 07:37:51 -0400
Date: Mon, 26 Oct 2009 11:36:56 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       paulmck@linux.vnet.ibm.com, mtosatti@redhat.com, tglx@linutronix.de,
       josh@joshtriplett.org, laijs@cn.fujitsu.com, mingo@elte.hu,
       avi@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, mtosatti@redhat.com, tglx@linutronix.de,
       josh@joshtriplett.org, laijs@cn.fujitsu.com, mingo@elte.hu,
       avi@redhat.com
In-Reply-To: <12565226354038-git-send-email->
References: <12565226354038-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Add synchronize_srcu_expedited()
Message-ID: <tip-0cd397d33608ae6c97d2ee6c8c43462b419b7e26@git.kernel.org>
Git-Commit-ID: 0cd397d33608ae6c97d2ee6c8c43462b419b7e26
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0cd397d33608ae6c97d2ee6c8c43462b419b7e26
Gitweb:     http://git.kernel.org/tip/0cd397d33608ae6c97d2ee6c8c43462b419b7e26
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Sun, 25 Oct 2009 19:03:51 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 26 Oct 2009 09:40:30 +0100

rcu: Add synchronize_srcu_expedited()

This patch creates a synchronize_srcu_expedited() that uses
synchronize_sched_expedited() where synchronize_srcu()
uses synchronize_sched().  The synchronize_srcu() and
synchronize_srcu_expedited() functions become one-liners that
pass synchronize_sched() or synchronize_sched_expedited(),
repectively, to a new __synchronize_srcu() function.

While in the file, move the EXPORT_SYMBOL_GPL()s to immediately
follow the corresponding functions.

Requested-by: Avi Kivity <avi@redhat.com>
Tested-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
Cc: avi@redhat.com
LKML-Reference: <12565226354038-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/srcu.h |    1 +
 kernel/srcu.c        |   74 ++++++++++++++++++++++++++++++++++---------------
 2 files changed, 52 insertions(+), 23 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index aca0eee..4765d97 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -48,6 +48,7 @@ void cleanup_srcu_struct(struct srcu_struct *sp);
 int srcu_read_lock(struct srcu_struct *sp) __acquires(sp);
 void srcu_read_unlock(struct srcu_struct *sp, int idx) __releases(sp);
 void synchronize_srcu(struct srcu_struct *sp);
+void synchronize_srcu_expedited(struct srcu_struct *sp);
 long srcu_batches_completed(struct srcu_struct *sp);
 
 #endif
diff --git a/kernel/srcu.c b/kernel/srcu.c
index b0aeeaf..818d7d9 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -49,6 +49,7 @@ int init_srcu_struct(struct srcu_struct *sp)
 	sp->per_cpu_ref = alloc_percpu(struct srcu_struct_array);
 	return (sp->per_cpu_ref ? 0 : -ENOMEM);
 }
+EXPORT_SYMBOL_GPL(init_srcu_struct);
 
 /*
  * srcu_readers_active_idx -- returns approximate number of readers
@@ -97,6 +98,7 @@ void cleanup_srcu_struct(struct srcu_struct *sp)
 	free_percpu(sp->per_cpu_ref);
 	sp->per_cpu_ref = NULL;
 }
+EXPORT_SYMBOL_GPL(cleanup_srcu_struct);
 
 /**
  * srcu_read_lock - register a new reader for an SRCU-protected structure.
@@ -118,6 +120,7 @@ int srcu_read_lock(struct srcu_struct *sp)
 	preempt_enable();
 	return idx;
 }
+EXPORT_SYMBOL_GPL(srcu_read_lock);
 
 /**
  * srcu_read_unlock - unregister a old reader from an SRCU-protected structure.
@@ -136,22 +139,12 @@ void srcu_read_unlock(struct srcu_struct *sp, int idx)
 	per_cpu_ptr(sp->per_cpu_ref, smp_processor_id())->c[idx]--;
 	preempt_enable();
 }
+EXPORT_SYMBOL_GPL(srcu_read_unlock);
 
-/**
- * synchronize_srcu - wait for prior SRCU read-side critical-section completion
- * @sp: srcu_struct with which to synchronize.
- *
- * Flip the completed counter, and wait for the old count to drain to zero.
- * As with classic RCU, the updater must use some separate means of
- * synchronizing concurrent updates.  Can block; must be called from
- * process context.
- *
- * Note that it is illegal to call synchornize_srcu() from the corresponding
- * SRCU read-side critical section; doing so will result in deadlock.
- * However, it is perfectly legal to call synchronize_srcu() on one
- * srcu_struct from some other srcu_struct's read-side critical section.
+/*
+ * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
  */
-void synchronize_srcu(struct srcu_struct *sp)
+void __synchronize_srcu(struct srcu_struct *sp, void (*sync_func)(void))
 {
 	int idx;
 
@@ -173,7 +166,7 @@ void synchronize_srcu(struct srcu_struct *sp)
 		return;
 	}
 
-	synchronize_sched();  /* Force memory barrier on all CPUs. */
+	sync_func();  /* Force memory barrier on all CPUs. */
 
 	/*
 	 * The preceding synchronize_sched() ensures that any CPU that
@@ -190,7 +183,7 @@ void synchronize_srcu(struct srcu_struct *sp)
 	idx = sp->completed & 0x1;
 	sp->completed++;
 
-	synchronize_sched();  /* Force memory barrier on all CPUs. */
+	sync_func();  /* Force memory barrier on all CPUs. */
 
 	/*
 	 * At this point, because of the preceding synchronize_sched(),
@@ -203,7 +196,7 @@ void synchronize_srcu(struct srcu_struct *sp)
 	while (srcu_readers_active_idx(sp, idx))
 		schedule_timeout_interruptible(1);
 
-	synchronize_sched();  /* Force memory barrier on all CPUs. */
+	sync_func();  /* Force memory barrier on all CPUs. */
 
 	/*
 	 * The preceding synchronize_sched() forces all srcu_read_unlock()
@@ -237,6 +230,47 @@ void synchronize_srcu(struct srcu_struct *sp)
 }
 
 /**
+ * synchronize_srcu - wait for prior SRCU read-side critical-section completion
+ * @sp: srcu_struct with which to synchronize.
+ *
+ * Flip the completed counter, and wait for the old count to drain to zero.
+ * As with classic RCU, the updater must use some separate means of
+ * synchronizing concurrent updates.  Can block; must be called from
+ * process context.
+ *
+ * Note that it is illegal to call synchronize_srcu() from the corresponding
+ * SRCU read-side critical section; doing so will result in deadlock.
+ * However, it is perfectly legal to call synchronize_srcu() on one
+ * srcu_struct from some other srcu_struct's read-side critical section.
+ */
+void synchronize_srcu(struct srcu_struct *sp)
+{
+	__synchronize_srcu(sp, synchronize_sched);
+}
+EXPORT_SYMBOL_GPL(synchronize_srcu);
+
+/**
+ * synchronize_srcu_expedited - like synchronize_srcu, but less patient
+ * @sp: srcu_struct with which to synchronize.
+ *
+ * Flip the completed counter, and wait for the old count to drain to zero.
+ * As with classic RCU, the updater must use some separate means of
+ * synchronizing concurrent updates.  Can block; must be called from
+ * process context.
+ *
+ * Note that it is illegal to call synchronize_srcu_expedited()
+ * from the corresponding SRCU read-side critical section; doing so
+ * will result in deadlock.  However, it is perfectly legal to call
+ * synchronize_srcu_expedited() on one srcu_struct from some other
+ * srcu_struct's read-side critical section.
+ */
+void synchronize_srcu_expedited(struct srcu_struct *sp)
+{
+	__synchronize_srcu(sp, synchronize_sched_expedited);
+}
+EXPORT_SYMBOL_GPL(synchronize_srcu_expedited);
+
+/**
  * srcu_batches_completed - return batches completed.
  * @sp: srcu_struct on which to report batch completion.
  *
@@ -248,10 +282,4 @@ long srcu_batches_completed(struct srcu_struct *sp)
 {
 	return sp->completed;
 }
-
-EXPORT_SYMBOL_GPL(init_srcu_struct);
-EXPORT_SYMBOL_GPL(cleanup_srcu_struct);
-EXPORT_SYMBOL_GPL(srcu_read_lock);
-EXPORT_SYMBOL_GPL(srcu_read_unlock);
-EXPORT_SYMBOL_GPL(synchronize_srcu);
 EXPORT_SYMBOL_GPL(srcu_batches_completed);
