Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbYHDNUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbYHDNUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbYHDNTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:19:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:35640 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566AbYHDNT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:19:29 -0400
Message-Id: <20080804131012.076019775@chello.nl>
References: <20080804130317.994042639@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 04 Aug 2008 15:03:22 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, davej@redhat.com
Subject: [RFC][PATCH 5/7] lockdep: map_acquire
Content-Disposition: inline; filename=lockdep-map_acquire.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most the free-standing lock_acquire() usages look remarkably similar, sweep
them into a new helper.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/jbd/transaction.c    |    4 ++--
 fs/jbd2/transaction.c   |    4 ++--
 include/linux/lockdep.h |   12 ++++++++++++
 kernel/workqueue.c      |   24 ++++++++++++------------
 4 files changed, 28 insertions(+), 16 deletions(-)

Index: linux-2.6/fs/jbd/transaction.c
===================================================================
--- linux-2.6.orig/fs/jbd/transaction.c
+++ linux-2.6/fs/jbd/transaction.c
@@ -291,7 +291,7 @@ handle_t *journal_start(journal_t *journ
 		goto out;
 	}
 
-	lock_acquire(&handle->h_lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+	map_acquire(&handle->h_lockdep_map);
 
 out:
 	return handle;
@@ -1448,7 +1448,7 @@ int journal_stop(handle_t *handle)
 		spin_unlock(&journal->j_state_lock);
 	}
 
-	lock_release(&handle->h_lockdep_map, 1, _THIS_IP_);
+	map_release(&handle->h_lockdep_map);
 
 	jbd_free_handle(handle);
 	return err;
Index: linux-2.6/fs/jbd2/transaction.c
===================================================================
--- linux-2.6.orig/fs/jbd2/transaction.c
+++ linux-2.6/fs/jbd2/transaction.c
@@ -301,7 +301,7 @@ handle_t *jbd2_journal_start(journal_t *
 		goto out;
 	}
 
-	lock_acquire(&handle->h_lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+	map_acquire(&handle->h_lockdep_map);
 out:
 	return handle;
 }
@@ -1279,7 +1279,7 @@ int jbd2_journal_stop(handle_t *handle)
 		spin_unlock(&journal->j_state_lock);
 	}
 
-	lock_release(&handle->h_lockdep_map, 1, _THIS_IP_);
+	map_release(&handle->h_lockdep_map);
 
 	jbd2_free_handle(handle);
 	return err;
Index: linux-2.6/include/linux/lockdep.h
===================================================================
--- linux-2.6.orig/include/linux/lockdep.h
+++ linux-2.6/include/linux/lockdep.h
@@ -459,4 +459,16 @@ static inline void print_irqtrace_events
 # define rwsem_release(l, n, i)			do { } while (0)
 #endif
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# ifdef CONFIG_PROVE_LOCKING
+#  define map_acquire(l)		lock_acquire(l, 0, 0, 0, 2, _THIS_IP_)
+# else
+#  define map_acquire(l)		lock_acquire(l, 0, 0, 0, 1, _THIS_IP_)
+# endif
+# define map_release(l)			lock_release(l, 1, _THIS_IP_)
+#else
+# define map_acquire(l)			do { } while (0)
+# define map_release(l)			do { } while (0)
+#endif
+
 #endif /* __LINUX_LOCKDEP_H */
Index: linux-2.6/kernel/workqueue.c
===================================================================
--- linux-2.6.orig/kernel/workqueue.c
+++ linux-2.6/kernel/workqueue.c
@@ -290,11 +290,11 @@ static void run_workqueue(struct cpu_wor
 
 		BUG_ON(get_wq_data(work) != cwq);
 		work_clear_pending(work);
-		lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
-		lock_acquire(&lockdep_map, 0, 0, 0, 2, _THIS_IP_);
+		map_acquire(&cwq->wq->lockdep_map);
+		map_acquire(&lockdep_map);
 		f(work);
-		lock_release(&lockdep_map, 1, _THIS_IP_);
-		lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
+		map_release(&lockdep_map);
+		map_release(&cwq->wq->lockdep_map);
 
 		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
 			printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
@@ -413,8 +413,8 @@ void flush_workqueue(struct workqueue_st
 	int cpu;
 
 	might_sleep();
-	lock_acquire(&wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
-	lock_release(&wq->lockdep_map, 1, _THIS_IP_);
+	map_acquire(&wq->lockdep_map);
+	map_release(&wq->lockdep_map);
 	for_each_cpu_mask_nr(cpu, *cpu_map)
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 }
@@ -441,8 +441,8 @@ int flush_work(struct work_struct *work)
 	if (!cwq)
 		return 0;
 
-	lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
-	lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
+	map_acquire(&cwq->wq->lockdep_map);
+	map_release(&cwq->wq->lockdep_map);
 
 	prev = NULL;
 	spin_lock_irq(&cwq->lock);
@@ -536,8 +536,8 @@ static void wait_on_work(struct work_str
 
 	might_sleep();
 
-	lock_acquire(&work->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
-	lock_release(&work->lockdep_map, 1, _THIS_IP_);
+	map_acquire(&work->lockdep_map);
+	map_release(&work->lockdep_map);
 
 	cwq = get_wq_data(work);
 	if (!cwq)
@@ -872,8 +872,8 @@ static void cleanup_workqueue_thread(str
 	if (cwq->thread == NULL)
 		return;
 
-	lock_acquire(&cwq->wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
-	lock_release(&cwq->wq->lockdep_map, 1, _THIS_IP_);
+	map_acquire(&cwq->wq->lockdep_map);
+	map_release(&cwq->wq->lockdep_map);
 
 	flush_cpu_workqueue(cwq);
 	/*

-- 

