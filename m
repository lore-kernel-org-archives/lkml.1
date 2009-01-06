Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbZAFQNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbZAFQNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 11:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbZAFQNC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 11:13:02 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52245 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbZAFQM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 11:12:57 -0500
Date: Tue, 6 Jan 2009 17:12:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] core updates/fixes
Message-ID: <20090106161246.GA12426@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

There's one non-fix category of changes: the swiotlb generalization bits 
are part of a rework towards highmem+swiotbl use by Xen and PowerPC.

 Thanks,

	Ingo

------------------>
Becky Bruce (2):
      swiotlb: store phys address in io_tlb_orig_addr array
      swiotlb: add support for systems with highmem

Darren Hart (2):
      futex: make futex_(get|put)_key() calls symmetric
      futex: catch certain assymetric (get|put)_futex_key calls

FUJITA Tomonori (3):
      swiotlb: replace architecture-specific swiotlb.h with linux/swiotlb.h
      swiotlb: remove unnecessary declaration
      swiotlb: clean up EXPORT_SYMBOL usage

Jeremy Fitzhardinge (1):
      swiotlb: add hwdev to swiotlb_phys_to_bus() / swiotlb_sg_to_bus()

Paul E. McKenney (4):
      rcu: fix rcutree grace-period-latency bug on small systems
      rcu: make treercu safe for suspend and resume
      rcu: eliminate synchronize_rcu_xxx macro
      rcu: fix rcutorture bug

Peter Zijlstra (1):
      locking, percpu counters: introduce separate lock classes


 arch/ia64/include/asm/swiotlb.h  |   39 +------
 arch/x86/include/asm/swiotlb.h   |   38 +------
 arch/x86/kernel/pci-swiotlb_64.c |    2 +-
 include/linux/percpu_counter.h   |   14 ++-
 include/linux/rcupdate.h         |   12 --
 include/linux/swiotlb.h          |    3 +-
 kernel/futex.c                   |   72 +++++++-----
 kernel/rcupdate.c                |   11 ++-
 kernel/rcupreempt.c              |   11 ++-
 kernel/rcutorture.c              |   18 ++--
 kernel/rcutree.c                 |   13 +--
 lib/percpu_counter.c             |   18 +---
 lib/proportions.c                |    6 +-
 lib/swiotlb.c                    |  237 ++++++++++++++++----------------------
 mm/backing-dev.c                 |    2 +-
 15 files changed, 195 insertions(+), 301 deletions(-)

diff --git a/arch/ia64/include/asm/swiotlb.h b/arch/ia64/include/asm/swiotlb.h
index fb79423..dcbaea7 100644
--- a/arch/ia64/include/asm/swiotlb.h
+++ b/arch/ia64/include/asm/swiotlb.h
@@ -2,44 +2,7 @@
 #define ASM_IA64__SWIOTLB_H
 
 #include <linux/dma-mapping.h>
-
-/* SWIOTLB interface */
-
-extern dma_addr_t swiotlb_map_single(struct device *hwdev, void *ptr,
-				     size_t size, int dir);
-extern void *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
-				    dma_addr_t *dma_handle, gfp_t flags);
-extern void swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
-				 size_t size, int dir);
-extern void swiotlb_sync_single_for_cpu(struct device *hwdev,
-					dma_addr_t dev_addr,
-					size_t size, int dir);
-extern void swiotlb_sync_single_for_device(struct device *hwdev,
-					   dma_addr_t dev_addr,
-					   size_t size, int dir);
-extern void swiotlb_sync_single_range_for_cpu(struct device *hwdev,
-					      dma_addr_t dev_addr,
-					      unsigned long offset,
-					      size_t size, int dir);
-extern void swiotlb_sync_single_range_for_device(struct device *hwdev,
-						 dma_addr_t dev_addr,
-						 unsigned long offset,
-						 size_t size, int dir);
-extern void swiotlb_sync_sg_for_cpu(struct device *hwdev,
-				    struct scatterlist *sg, int nelems,
-				    int dir);
-extern void swiotlb_sync_sg_for_device(struct device *hwdev,
-				       struct scatterlist *sg, int nelems,
-				       int dir);
-extern int swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg,
-			  int nents, int direction);
-extern void swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg,
-			     int nents, int direction);
-extern int swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
-extern void swiotlb_free_coherent(struct device *hwdev, size_t size,
-				  void *vaddr, dma_addr_t dma_handle);
-extern int swiotlb_dma_supported(struct device *hwdev, u64 mask);
-extern void swiotlb_init(void);
+#include <linux/swiotlb.h>
 
 extern int swiotlb_force;
 
diff --git a/arch/x86/include/asm/swiotlb.h b/arch/x86/include/asm/swiotlb.h
index 51fb2c7..b9e4e20 100644
--- a/arch/x86/include/asm/swiotlb.h
+++ b/arch/x86/include/asm/swiotlb.h
@@ -1,46 +1,10 @@
 #ifndef _ASM_X86_SWIOTLB_H
 #define _ASM_X86_SWIOTLB_H
 
-#include <asm/dma-mapping.h>
+#include <linux/swiotlb.h>
 
 /* SWIOTLB interface */
 
-extern dma_addr_t swiotlb_map_single(struct device *hwdev, void *ptr,
-				     size_t size, int dir);
-extern void *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
-				    dma_addr_t *dma_handle, gfp_t flags);
-extern void swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
-				 size_t size, int dir);
-extern void swiotlb_sync_single_for_cpu(struct device *hwdev,
-					dma_addr_t dev_addr,
-					size_t size, int dir);
-extern void swiotlb_sync_single_for_device(struct device *hwdev,
-					   dma_addr_t dev_addr,
-					   size_t size, int dir);
-extern void swiotlb_sync_single_range_for_cpu(struct device *hwdev,
-					      dma_addr_t dev_addr,
-					      unsigned long offset,
-					      size_t size, int dir);
-extern void swiotlb_sync_single_range_for_device(struct device *hwdev,
-						 dma_addr_t dev_addr,
-						 unsigned long offset,
-						 size_t size, int dir);
-extern void swiotlb_sync_sg_for_cpu(struct device *hwdev,
-				    struct scatterlist *sg, int nelems,
-				    int dir);
-extern void swiotlb_sync_sg_for_device(struct device *hwdev,
-				       struct scatterlist *sg, int nelems,
-				       int dir);
-extern int swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg,
-			  int nents, int direction);
-extern void swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg,
-			     int nents, int direction);
-extern int swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
-extern void swiotlb_free_coherent(struct device *hwdev, size_t size,
-				  void *vaddr, dma_addr_t dma_handle);
-extern int swiotlb_dma_supported(struct device *hwdev, u64 mask);
-extern void swiotlb_init(void);
-
 extern int swiotlb_force;
 
 #ifdef CONFIG_SWIOTLB
diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
index 8cba374..d59c917 100644
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -23,7 +23,7 @@ void *swiotlb_alloc(unsigned order, unsigned long nslabs)
 	return (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
 }
 
-dma_addr_t swiotlb_phys_to_bus(phys_addr_t paddr)
+dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
 {
 	return paddr;
 }
diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index 9007ccd..96bdde3 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -30,8 +30,16 @@ struct percpu_counter {
 #define FBC_BATCH	(NR_CPUS*4)
 #endif
 
-int percpu_counter_init(struct percpu_counter *fbc, s64 amount);
-int percpu_counter_init_irq(struct percpu_counter *fbc, s64 amount);
+int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
+			  struct lock_class_key *key);
+
+#define percpu_counter_init(fbc, value)					\
+	({								\
+		static struct lock_class_key __key;			\
+									\
+		__percpu_counter_init(fbc, value, &__key);		\
+	})
+
 void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
@@ -85,8 +93,6 @@ static inline int percpu_counter_init(struct percpu_counter *fbc, s64 amount)
 	return 0;
 }
 
-#define percpu_counter_init_irq percpu_counter_init
-
 static inline void percpu_counter_destroy(struct percpu_counter *fbc)
 {
 }
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 1168fbc..921340a 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -204,18 +204,6 @@ struct rcu_synchronize {
 
 extern void wakeme_after_rcu(struct rcu_head  *head);
 
-#define synchronize_rcu_xxx(name, func) \
-void name(void) \
-{ \
-	struct rcu_synchronize rcu; \
-	\
-	init_completion(&rcu.completion); \
-	/* Will wake me after RCU finished. */ \
-	func(&rcu.head, wakeme_after_rcu); \
-	/* Wait for it. */ \
-	wait_for_completion(&rcu.completion); \
-}
-
 /**
  * synchronize_sched - block until all CPUs have exited any non-preemptive
  * kernel code sequences.
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 325af1d..dedd3c0 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -27,7 +27,8 @@ swiotlb_init(void);
 extern void *swiotlb_alloc_boot(size_t bytes, unsigned long nslabs);
 extern void *swiotlb_alloc(unsigned order, unsigned long nslabs);
 
-extern dma_addr_t swiotlb_phys_to_bus(phys_addr_t address);
+extern dma_addr_t swiotlb_phys_to_bus(struct device *hwdev,
+				      phys_addr_t address);
 extern phys_addr_t swiotlb_bus_to_phys(dma_addr_t address);
 
 extern int swiotlb_arch_range_needs_mapping(void *ptr, size_t size);
diff --git a/kernel/futex.c b/kernel/futex.c
index 7c6cbab..002aa18 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -170,8 +170,11 @@ static void get_futex_key_refs(union futex_key *key)
  */
 static void drop_futex_key_refs(union futex_key *key)
 {
-	if (!key->both.ptr)
+	if (!key->both.ptr) {
+		/* If we're here then we tried to put a key we failed to get */
+		WARN_ON_ONCE(1);
 		return;
+	}
 
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
 	case FUT_OFF_INODE:
@@ -730,8 +733,8 @@ static int futex_wake(u32 __user *uaddr, int fshared, int nr_wake, u32 bitset)
 	}
 
 	spin_unlock(&hb->lock);
-out:
 	put_futex_key(fshared, &key);
+out:
 	return ret;
 }
 
@@ -755,7 +758,7 @@ retryfull:
 		goto out;
 	ret = get_futex_key(uaddr2, fshared, &key2);
 	if (unlikely(ret != 0))
-		goto out;
+		goto out_put_key1;
 
 	hb1 = hash_futex(&key1);
 	hb2 = hash_futex(&key2);
@@ -777,12 +780,12 @@ retry:
 		 * but we might get them from range checking
 		 */
 		ret = op_ret;
-		goto out;
+		goto out_put_keys;
 #endif
 
 		if (unlikely(op_ret != -EFAULT)) {
 			ret = op_ret;
-			goto out;
+			goto out_put_keys;
 		}
 
 		/*
@@ -796,7 +799,7 @@ retry:
 			ret = futex_handle_fault((unsigned long)uaddr2,
 						 attempt);
 			if (ret)
-				goto out;
+				goto out_put_keys;
 			goto retry;
 		}
 
@@ -834,10 +837,11 @@ retry:
 	spin_unlock(&hb1->lock);
 	if (hb1 != hb2)
 		spin_unlock(&hb2->lock);
-out:
+out_put_keys:
 	put_futex_key(fshared, &key2);
+out_put_key1:
 	put_futex_key(fshared, &key1);
-
+out:
 	return ret;
 }
 
@@ -854,13 +858,13 @@ static int futex_requeue(u32 __user *uaddr1, int fshared, u32 __user *uaddr2,
 	struct futex_q *this, *next;
 	int ret, drop_count = 0;
 
- retry:
+retry:
 	ret = get_futex_key(uaddr1, fshared, &key1);
 	if (unlikely(ret != 0))
 		goto out;
 	ret = get_futex_key(uaddr2, fshared, &key2);
 	if (unlikely(ret != 0))
-		goto out;
+		goto out_put_key1;
 
 	hb1 = hash_futex(&key1);
 	hb2 = hash_futex(&key2);
@@ -882,7 +886,7 @@ static int futex_requeue(u32 __user *uaddr1, int fshared, u32 __user *uaddr2,
 			if (!ret)
 				goto retry;
 
-			return ret;
+			goto out_put_keys;
 		}
 		if (curval != *cmpval) {
 			ret = -EAGAIN;
@@ -927,9 +931,11 @@ out_unlock:
 	while (--drop_count >= 0)
 		drop_futex_key_refs(&key1);
 
-out:
+out_put_keys:
 	put_futex_key(fshared, &key2);
+out_put_key1:
 	put_futex_key(fshared, &key1);
+out:
 	return ret;
 }
 
@@ -990,7 +996,7 @@ static int unqueue_me(struct futex_q *q)
 	int ret = 0;
 
 	/* In the common case we don't take the spinlock, which is nice. */
- retry:
+retry:
 	lock_ptr = q->lock_ptr;
 	barrier();
 	if (lock_ptr != NULL) {
@@ -1172,11 +1178,11 @@ static int futex_wait(u32 __user *uaddr, int fshared,
 
 	q.pi_state = NULL;
 	q.bitset = bitset;
- retry:
+retry:
 	q.key = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr, fshared, &q.key);
 	if (unlikely(ret != 0))
-		goto out_release_sem;
+		goto out;
 
 	hb = queue_lock(&q);
 
@@ -1204,6 +1210,7 @@ static int futex_wait(u32 __user *uaddr, int fshared,
 
 	if (unlikely(ret)) {
 		queue_unlock(&q, hb);
+		put_futex_key(fshared, &q.key);
 
 		ret = get_user(uval, uaddr);
 
@@ -1213,7 +1220,7 @@ static int futex_wait(u32 __user *uaddr, int fshared,
 	}
 	ret = -EWOULDBLOCK;
 	if (uval != val)
-		goto out_unlock_release_sem;
+		goto out_unlock_put_key;
 
 	/* Only actually queue if *uaddr contained val.  */
 	queue_me(&q, hb);
@@ -1305,11 +1312,11 @@ static int futex_wait(u32 __user *uaddr, int fshared,
 		return -ERESTART_RESTARTBLOCK;
 	}
 
- out_unlock_release_sem:
+out_unlock_put_key:
 	queue_unlock(&q, hb);
-
- out_release_sem:
 	put_futex_key(fshared, &q.key);
+
+out:
 	return ret;
 }
 
@@ -1358,16 +1365,16 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 	}
 
 	q.pi_state = NULL;
- retry:
+retry:
 	q.key = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr, fshared, &q.key);
 	if (unlikely(ret != 0))
-		goto out_release_sem;
+		goto out;
 
- retry_unlocked:
+retry_unlocked:
 	hb = queue_lock(&q);
 
- retry_locked:
+retry_locked:
 	ret = lock_taken = 0;
 
 	/*
@@ -1388,14 +1395,14 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 	 */
 	if (unlikely((curval & FUTEX_TID_MASK) == task_pid_vnr(current))) {
 		ret = -EDEADLK;
-		goto out_unlock_release_sem;
+		goto out_unlock_put_key;
 	}
 
 	/*
 	 * Surprise - we got the lock. Just return to userspace:
 	 */
 	if (unlikely(!curval))
-		goto out_unlock_release_sem;
+		goto out_unlock_put_key;
 
 	uval = curval;
 
@@ -1431,7 +1438,7 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 	 * We took the lock due to owner died take over.
 	 */
 	if (unlikely(lock_taken))
-		goto out_unlock_release_sem;
+		goto out_unlock_put_key;
 
 	/*
 	 * We dont have the lock. Look up the PI state (or create it if
@@ -1470,7 +1477,7 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 				goto retry_locked;
 			}
 		default:
-			goto out_unlock_release_sem;
+			goto out_unlock_put_key;
 		}
 	}
 
@@ -1561,16 +1568,17 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 		destroy_hrtimer_on_stack(&to->timer);
 	return ret != -EINTR ? ret : -ERESTARTNOINTR;
 
- out_unlock_release_sem:
+out_unlock_put_key:
 	queue_unlock(&q, hb);
 
- out_release_sem:
+out_put_key:
 	put_futex_key(fshared, &q.key);
+out:
 	if (to)
 		destroy_hrtimer_on_stack(&to->timer);
 	return ret;
 
- uaddr_faulted:
+uaddr_faulted:
 	/*
 	 * We have to r/w  *(int __user *)uaddr, and we have to modify it
 	 * atomically.  Therefore, if we continue to fault after get_user()
@@ -1583,7 +1591,7 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 	if (attempt++) {
 		ret = futex_handle_fault((unsigned long)uaddr, attempt);
 		if (ret)
-			goto out_release_sem;
+			goto out_put_key;
 		goto retry_unlocked;
 	}
 
@@ -1675,9 +1683,9 @@ retry_unlocked:
 
 out_unlock:
 	spin_unlock(&hb->lock);
-out:
 	put_futex_key(fshared, &key);
 
+out:
 	return ret;
 
 pi_faulted:
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index ad63af8..d92a76a 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -77,8 +77,15 @@ void wakeme_after_rcu(struct rcu_head  *head)
  * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
  * and may be nested.
  */
-void synchronize_rcu(void);	/* Makes kernel-doc tools happy */
-synchronize_rcu_xxx(synchronize_rcu, call_rcu)
+void synchronize_rcu(void)
+{
+	struct rcu_synchronize rcu;
+	init_completion(&rcu.completion);
+	/* Will wake me after RCU finished. */
+	call_rcu(&rcu.head, wakeme_after_rcu);
+	/* Wait for it. */
+	wait_for_completion(&rcu.completion);
+}
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
 static void rcu_barrier_callback(struct rcu_head *notused)
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index f9dc8f3..33cfc50 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -1177,7 +1177,16 @@ EXPORT_SYMBOL_GPL(call_rcu_sched);
  * in -rt this does -not- necessarily result in all currently executing
  * interrupt -handlers- having completed.
  */
-synchronize_rcu_xxx(__synchronize_sched, call_rcu_sched)
+void __synchronize_sched(void)
+{
+	struct rcu_synchronize rcu;
+
+	init_completion(&rcu.completion);
+	/* Will wake me after RCU finished. */
+	call_rcu_sched(&rcu.head, wakeme_after_rcu);
+	/* Wait for it. */
+	wait_for_completion(&rcu.completion);
+}
 EXPORT_SYMBOL_GPL(__synchronize_sched);
 
 /*
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 3245b40..1cff28d 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -136,7 +136,7 @@ static int stutter_pause_test = 0;
 #endif
 int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
 
-#define FULLSTOP_SIGNALED 1	/* Bail due to signal. */
+#define FULLSTOP_SHUTDOWN 1	/* Bail due to system shutdown/panic. */
 #define FULLSTOP_CLEANUP  2	/* Orderly shutdown. */
 static int fullstop;		/* stop generating callbacks at test end. */
 DEFINE_MUTEX(fullstop_mutex);	/* protect fullstop transitions and */
@@ -151,12 +151,10 @@ rcutorture_shutdown_notify(struct notifier_block *unused1,
 {
 	if (fullstop)
 		return NOTIFY_DONE;
-	if (signal_pending(current)) {
-		mutex_lock(&fullstop_mutex);
-		if (!ACCESS_ONCE(fullstop))
-			fullstop = FULLSTOP_SIGNALED;
-		mutex_unlock(&fullstop_mutex);
-	}
+	mutex_lock(&fullstop_mutex);
+	if (!fullstop)
+		fullstop = FULLSTOP_SHUTDOWN;
+	mutex_unlock(&fullstop_mutex);
 	return NOTIFY_DONE;
 }
 
@@ -624,7 +622,7 @@ rcu_torture_writer(void *arg)
 		rcu_stutter_wait();
 	} while (!kthread_should_stop() && !fullstop);
 	VERBOSE_PRINTK_STRING("rcu_torture_writer task stopping");
-	while (!kthread_should_stop() && fullstop != FULLSTOP_SIGNALED)
+	while (!kthread_should_stop() && fullstop != FULLSTOP_SHUTDOWN)
 		schedule_timeout_uninterruptible(1);
 	return 0;
 }
@@ -649,7 +647,7 @@ rcu_torture_fakewriter(void *arg)
 	} while (!kthread_should_stop() && !fullstop);
 
 	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task stopping");
-	while (!kthread_should_stop() && fullstop != FULLSTOP_SIGNALED)
+	while (!kthread_should_stop() && fullstop != FULLSTOP_SHUTDOWN)
 		schedule_timeout_uninterruptible(1);
 	return 0;
 }
@@ -759,7 +757,7 @@ rcu_torture_reader(void *arg)
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task stopping");
 	if (irqreader && cur_ops->irqcapable)
 		del_timer_sync(&t);
-	while (!kthread_should_stop() && fullstop != FULLSTOP_SIGNALED)
+	while (!kthread_should_stop() && fullstop != FULLSTOP_SHUTDOWN)
 		schedule_timeout_uninterruptible(1);
 	return 0;
 }
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index a342b03..f2d8638 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -79,7 +79,10 @@ struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
 #ifdef CONFIG_NO_HZ
-DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks);
+DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
+	.dynticks_nesting = 1,
+	.dynticks = 1,
+};
 #endif /* #ifdef CONFIG_NO_HZ */
 
 static int blimit = 10;		/* Maximum callbacks per softirq. */
@@ -572,6 +575,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	/* Special-case the common single-level case. */
 	if (NUM_RCU_NODES == 1) {
 		rnp->qsmask = rnp->qsmaskinit;
+		rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state OK. */
 		spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
@@ -1379,13 +1383,6 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
 
 static void __cpuinit rcu_online_cpu(int cpu)
 {
-#ifdef CONFIG_NO_HZ
-	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
-
-	rdtp->dynticks_nesting = 1;
-	rdtp->dynticks |= 1; 	/* need consecutive #s even for hotplug. */
-	rdtp->dynticks_nmi = (rdtp->dynticks_nmi + 1) & ~0x1;
-#endif /* #ifdef CONFIG_NO_HZ */
 	rcu_init_percpu_data(cpu, &rcu_state);
 	rcu_init_percpu_data(cpu, &rcu_bh_state);
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index b255b93..4bb0ed3 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -68,11 +68,11 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc)
 }
 EXPORT_SYMBOL(__percpu_counter_sum);
 
-static struct lock_class_key percpu_counter_irqsafe;
-
-int percpu_counter_init(struct percpu_counter *fbc, s64 amount)
+int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
+			  struct lock_class_key *key)
 {
 	spin_lock_init(&fbc->lock);
+	lockdep_set_class(&fbc->lock, key);
 	fbc->count = amount;
 	fbc->counters = alloc_percpu(s32);
 	if (!fbc->counters)
@@ -84,17 +84,7 @@ int percpu_counter_init(struct percpu_counter *fbc, s64 amount)
 #endif
 	return 0;
 }
-EXPORT_SYMBOL(percpu_counter_init);
-
-int percpu_counter_init_irq(struct percpu_counter *fbc, s64 amount)
-{
-	int err;
-
-	err = percpu_counter_init(fbc, amount);
-	if (!err)
-		lockdep_set_class(&fbc->lock, &percpu_counter_irqsafe);
-	return err;
-}
+EXPORT_SYMBOL(__percpu_counter_init);
 
 void percpu_counter_destroy(struct percpu_counter *fbc)
 {
diff --git a/lib/proportions.c b/lib/proportions.c
index 4f387a6..7367f2b 100644
--- a/lib/proportions.c
+++ b/lib/proportions.c
@@ -83,11 +83,11 @@ int prop_descriptor_init(struct prop_descriptor *pd, int shift)
 	pd->index = 0;
 	pd->pg[0].shift = shift;
 	mutex_init(&pd->mutex);
-	err = percpu_counter_init_irq(&pd->pg[0].events, 0);
+	err = percpu_counter_init(&pd->pg[0].events, 0);
 	if (err)
 		goto out;
 
-	err = percpu_counter_init_irq(&pd->pg[1].events, 0);
+	err = percpu_counter_init(&pd->pg[1].events, 0);
 	if (err)
 		percpu_counter_destroy(&pd->pg[0].events);
 
@@ -191,7 +191,7 @@ int prop_local_init_percpu(struct prop_local_percpu *pl)
 	spin_lock_init(&pl->lock);
 	pl->shift = 0;
 	pl->period = 0;
-	return percpu_counter_init_irq(&pl->events, 0);
+	return percpu_counter_init(&pl->events, 0);
 }
 
 void prop_local_destroy_percpu(struct prop_local_percpu *pl)
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 7f5e21b..48deef7 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -14,6 +14,7 @@
  * 04/07/.. ak		Better overflow handling. Assorted fixes.
  * 05/09/10 linville	Add support for syncing ranges, support syncing for
  *			DMA_BIDIRECTIONAL mappings, miscellaneous cleanup.
+ * 08/12/11 beckyb	Add highmem support
  */
 
 #include <linux/cache.h>
@@ -21,8 +22,9 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
-#include <linux/swiotlb.h>
 #include <linux/string.h>
+#include <linux/swiotlb.h>
+#include <linux/pfn.h>
 #include <linux/types.h>
 #include <linux/ctype.h>
 #include <linux/highmem.h>
@@ -88,10 +90,7 @@ static unsigned int io_tlb_index;
  * We need to save away the original address corresponding to a mapped entry
  * for the sync operations.
  */
-static struct swiotlb_phys_addr {
-	struct page *page;
-	unsigned int offset;
-} *io_tlb_orig_addr;
+static phys_addr_t *io_tlb_orig_addr;
 
 /*
  * Protect the above data structures in the map and unmap calls
@@ -125,7 +124,7 @@ void * __weak swiotlb_alloc(unsigned order, unsigned long nslabs)
 	return (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
 }
 
-dma_addr_t __weak swiotlb_phys_to_bus(phys_addr_t paddr)
+dma_addr_t __weak swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
 {
 	return paddr;
 }
@@ -135,9 +134,10 @@ phys_addr_t __weak swiotlb_bus_to_phys(dma_addr_t baddr)
 	return baddr;
 }
 
-static dma_addr_t swiotlb_virt_to_bus(volatile void *address)
+static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
+				      volatile void *address)
 {
-	return swiotlb_phys_to_bus(virt_to_phys(address));
+	return swiotlb_phys_to_bus(hwdev, virt_to_phys(address));
 }
 
 static void *swiotlb_bus_to_virt(dma_addr_t address)
@@ -150,35 +150,18 @@ int __weak swiotlb_arch_range_needs_mapping(void *ptr, size_t size)
 	return 0;
 }
 
-static dma_addr_t swiotlb_sg_to_bus(struct scatterlist *sg)
-{
-	return swiotlb_phys_to_bus(page_to_phys(sg_page(sg)) + sg->offset);
-}
-
 static void swiotlb_print_info(unsigned long bytes)
 {
 	phys_addr_t pstart, pend;
-	dma_addr_t bstart, bend;
 
 	pstart = virt_to_phys(io_tlb_start);
 	pend = virt_to_phys(io_tlb_end);
 
-	bstart = swiotlb_phys_to_bus(pstart);
-	bend = swiotlb_phys_to_bus(pend);
-
 	printk(KERN_INFO "Placing %luMB software IO TLB between %p - %p\n",
 	       bytes >> 20, io_tlb_start, io_tlb_end);
-	if (pstart != bstart || pend != bend)
-		printk(KERN_INFO "software IO TLB at phys %#llx - %#llx"
-		       " bus %#llx - %#llx\n",
-		       (unsigned long long)pstart,
-		       (unsigned long long)pend,
-		       (unsigned long long)bstart,
-		       (unsigned long long)bend);
-	else
-		printk(KERN_INFO "software IO TLB at phys %#llx - %#llx\n",
-		       (unsigned long long)pstart,
-		       (unsigned long long)pend);
+	printk(KERN_INFO "software IO TLB at phys %#llx - %#llx\n",
+	       (unsigned long long)pstart,
+	       (unsigned long long)pend);
 }
 
 /*
@@ -214,7 +197,7 @@ swiotlb_init_with_default_size(size_t default_size)
 	for (i = 0; i < io_tlb_nslabs; i++)
  		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
 	io_tlb_index = 0;
-	io_tlb_orig_addr = alloc_bootmem(io_tlb_nslabs * sizeof(struct swiotlb_phys_addr));
+	io_tlb_orig_addr = alloc_bootmem(io_tlb_nslabs * sizeof(phys_addr_t));
 
 	/*
 	 * Get the overflow emergency buffer
@@ -288,12 +271,14 @@ swiotlb_late_init_with_default_size(size_t default_size)
  		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
 	io_tlb_index = 0;
 
-	io_tlb_orig_addr = (struct swiotlb_phys_addr *)__get_free_pages(GFP_KERNEL,
-	                           get_order(io_tlb_nslabs * sizeof(struct swiotlb_phys_addr)));
+	io_tlb_orig_addr = (phys_addr_t *)
+		__get_free_pages(GFP_KERNEL,
+				 get_order(io_tlb_nslabs *
+					   sizeof(phys_addr_t)));
 	if (!io_tlb_orig_addr)
 		goto cleanup3;
 
-	memset(io_tlb_orig_addr, 0, io_tlb_nslabs * sizeof(struct swiotlb_phys_addr));
+	memset(io_tlb_orig_addr, 0, io_tlb_nslabs * sizeof(phys_addr_t));
 
 	/*
 	 * Get the overflow emergency buffer
@@ -308,8 +293,8 @@ swiotlb_late_init_with_default_size(size_t default_size)
 	return 0;
 
 cleanup4:
-	free_pages((unsigned long)io_tlb_orig_addr, get_order(io_tlb_nslabs *
-	                                                      sizeof(char *)));
+	free_pages((unsigned long)io_tlb_orig_addr,
+		   get_order(io_tlb_nslabs * sizeof(phys_addr_t)));
 	io_tlb_orig_addr = NULL;
 cleanup3:
 	free_pages((unsigned long)io_tlb_list, get_order(io_tlb_nslabs *
@@ -340,51 +325,44 @@ static int is_swiotlb_buffer(char *addr)
 	return addr >= io_tlb_start && addr < io_tlb_end;
 }
 
-static struct swiotlb_phys_addr swiotlb_bus_to_phys_addr(char *dma_addr)
-{
-	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
-	struct swiotlb_phys_addr buffer = io_tlb_orig_addr[index];
-	buffer.offset += (long)dma_addr & ((1 << IO_TLB_SHIFT) - 1);
-	buffer.page += buffer.offset >> PAGE_SHIFT;
-	buffer.offset &= PAGE_SIZE - 1;
-	return buffer;
-}
-
-static void
-__sync_single(struct swiotlb_phys_addr buffer, char *dma_addr, size_t size, int dir)
-{
-	if (PageHighMem(buffer.page)) {
-		size_t len, bytes;
-		char *dev, *host, *kmp;
-
-		len = size;
-		while (len != 0) {
-			unsigned long flags;
-
-			bytes = len;
-			if ((bytes + buffer.offset) > PAGE_SIZE)
-				bytes = PAGE_SIZE - buffer.offset;
-			local_irq_save(flags); /* protects KM_BOUNCE_READ */
-			kmp  = kmap_atomic(buffer.page, KM_BOUNCE_READ);
-			dev  = dma_addr + size - len;
-			host = kmp + buffer.offset;
-			if (dir == DMA_FROM_DEVICE)
-				memcpy(host, dev, bytes);
+/*
+ * Bounce: copy the swiotlb buffer back to the original dma location
+ */
+static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
+			   enum dma_data_direction dir)
+{
+	unsigned long pfn = PFN_DOWN(phys);
+
+	if (PageHighMem(pfn_to_page(pfn))) {
+		/* The buffer does not have a mapping.  Map it in and copy */
+		unsigned int offset = phys & ~PAGE_MASK;
+		char *buffer;
+		unsigned int sz = 0;
+		unsigned long flags;
+
+		while (size) {
+			sz = min(PAGE_SIZE - offset, size);
+
+			local_irq_save(flags);
+			buffer = kmap_atomic(pfn_to_page(pfn),
+					     KM_BOUNCE_READ);
+			if (dir == DMA_TO_DEVICE)
+				memcpy(dma_addr, buffer + offset, sz);
 			else
-				memcpy(dev, host, bytes);
-			kunmap_atomic(kmp, KM_BOUNCE_READ);
+				memcpy(buffer + offset, dma_addr, sz);
+			kunmap_atomic(buffer, KM_BOUNCE_READ);
 			local_irq_restore(flags);
-			len -= bytes;
-			buffer.page++;
-			buffer.offset = 0;
+
+			size -= sz;
+			pfn++;
+			dma_addr += sz;
+			offset = 0;
 		}
 	} else {
-		void *v = page_address(buffer.page) + buffer.offset;
-
 		if (dir == DMA_TO_DEVICE)
-			memcpy(dma_addr, v, size);
+			memcpy(dma_addr, phys_to_virt(phys), size);
 		else
-			memcpy(v, dma_addr, size);
+			memcpy(phys_to_virt(phys), dma_addr, size);
 	}
 }
 
@@ -392,7 +370,7 @@ __sync_single(struct swiotlb_phys_addr buffer, char *dma_addr, size_t size, int
  * Allocates bounce buffer and returns its kernel virtual address.
  */
 static void *
-map_single(struct device *hwdev, struct swiotlb_phys_addr buffer, size_t size, int dir)
+map_single(struct device *hwdev, phys_addr_t phys, size_t size, int dir)
 {
 	unsigned long flags;
 	char *dma_addr;
@@ -402,10 +380,9 @@ map_single(struct device *hwdev, struct swiotlb_phys_addr buffer, size_t size, i
 	unsigned long mask;
 	unsigned long offset_slots;
 	unsigned long max_slots;
-	struct swiotlb_phys_addr slot_buf;
 
 	mask = dma_get_seg_boundary(hwdev);
-	start_dma_addr = swiotlb_virt_to_bus(io_tlb_start) & mask;
+	start_dma_addr = swiotlb_virt_to_bus(hwdev, io_tlb_start) & mask;
 
 	offset_slots = ALIGN(start_dma_addr, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
 
@@ -487,15 +464,10 @@ found:
 	 * This is needed when we sync the memory.  Then we sync the buffer if
 	 * needed.
 	 */
-	slot_buf = buffer;
-	for (i = 0; i < nslots; i++) {
-		slot_buf.page += slot_buf.offset >> PAGE_SHIFT;
-		slot_buf.offset &= PAGE_SIZE - 1;
-		io_tlb_orig_addr[index+i] = slot_buf;
-		slot_buf.offset += 1 << IO_TLB_SHIFT;
-	}
+	for (i = 0; i < nslots; i++)
+		io_tlb_orig_addr[index+i] = phys + (i << IO_TLB_SHIFT);
 	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
-		__sync_single(buffer, dma_addr, size, DMA_TO_DEVICE);
+		swiotlb_bounce(phys, dma_addr, size, DMA_TO_DEVICE);
 
 	return dma_addr;
 }
@@ -509,17 +481,13 @@ unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
 	unsigned long flags;
 	int i, count, nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
 	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
-	struct swiotlb_phys_addr buffer = swiotlb_bus_to_phys_addr(dma_addr);
+	phys_addr_t phys = io_tlb_orig_addr[index];
 
 	/*
 	 * First, sync the memory before unmapping the entry
 	 */
-	if ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL))
-		/*
-		 * bounce... copy the data back into the original buffer * and
-		 * delete the bounce buffer.
-		 */
-		__sync_single(buffer, dma_addr, size, DMA_FROM_DEVICE);
+	if (phys && ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL)))
+		swiotlb_bounce(phys, dma_addr, size, DMA_FROM_DEVICE);
 
 	/*
 	 * Return the buffer to the free list by setting the corresponding
@@ -551,18 +519,21 @@ static void
 sync_single(struct device *hwdev, char *dma_addr, size_t size,
 	    int dir, int target)
 {
-	struct swiotlb_phys_addr buffer = swiotlb_bus_to_phys_addr(dma_addr);
+	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
+	phys_addr_t phys = io_tlb_orig_addr[index];
+
+	phys += ((unsigned long)dma_addr & ((1 << IO_TLB_SHIFT) - 1));
 
 	switch (target) {
 	case SYNC_FOR_CPU:
 		if (likely(dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL))
-			__sync_single(buffer, dma_addr, size, DMA_FROM_DEVICE);
+			swiotlb_bounce(phys, dma_addr, size, DMA_FROM_DEVICE);
 		else
 			BUG_ON(dir != DMA_TO_DEVICE);
 		break;
 	case SYNC_FOR_DEVICE:
 		if (likely(dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
-			__sync_single(buffer, dma_addr, size, DMA_TO_DEVICE);
+			swiotlb_bounce(phys, dma_addr, size, DMA_TO_DEVICE);
 		else
 			BUG_ON(dir != DMA_FROM_DEVICE);
 		break;
@@ -584,7 +555,9 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		dma_mask = hwdev->coherent_dma_mask;
 
 	ret = (void *)__get_free_pages(flags, order);
-	if (ret && !is_buffer_dma_capable(dma_mask, swiotlb_virt_to_bus(ret), size)) {
+	if (ret &&
+	    !is_buffer_dma_capable(dma_mask, swiotlb_virt_to_bus(hwdev, ret),
+				   size)) {
 		/*
 		 * The allocated memory isn't reachable by the device.
 		 * Fall back on swiotlb_map_single().
@@ -599,16 +572,13 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		 * swiotlb_map_single(), which will grab memory from
 		 * the lowest available address range.
 		 */
-		struct swiotlb_phys_addr buffer;
-		buffer.page = virt_to_page(NULL);
-		buffer.offset = 0;
-		ret = map_single(hwdev, buffer, size, DMA_FROM_DEVICE);
+		ret = map_single(hwdev, 0, size, DMA_FROM_DEVICE);
 		if (!ret)
 			return NULL;
 	}
 
 	memset(ret, 0, size);
-	dev_addr = swiotlb_virt_to_bus(ret);
+	dev_addr = swiotlb_virt_to_bus(hwdev, ret);
 
 	/* Confirm address can be DMA'd by device */
 	if (!is_buffer_dma_capable(dma_mask, dev_addr, size)) {
@@ -623,6 +593,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	*dma_handle = dev_addr;
 	return ret;
 }
+EXPORT_SYMBOL(swiotlb_alloc_coherent);
 
 void
 swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
@@ -635,6 +606,7 @@ swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
 		unmap_single(hwdev, vaddr, size, DMA_TO_DEVICE);
 }
+EXPORT_SYMBOL(swiotlb_free_coherent);
 
 static void
 swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
@@ -668,9 +640,8 @@ dma_addr_t
 swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
 			 int dir, struct dma_attrs *attrs)
 {
-	dma_addr_t dev_addr = swiotlb_virt_to_bus(ptr);
+	dma_addr_t dev_addr = swiotlb_virt_to_bus(hwdev, ptr);
 	void *map;
-	struct swiotlb_phys_addr buffer;
 
 	BUG_ON(dir == DMA_NONE);
 	/*
@@ -685,15 +656,13 @@ swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
 	/*
 	 * Oh well, have to allocate and map a bounce buffer.
 	 */
-	buffer.page   = virt_to_page(ptr);
-	buffer.offset = (unsigned long)ptr & ~PAGE_MASK;
-	map = map_single(hwdev, buffer, size, dir);
+	map = map_single(hwdev, virt_to_phys(ptr), size, dir);
 	if (!map) {
 		swiotlb_full(hwdev, size, dir, 1);
 		map = io_tlb_overflow_buffer;
 	}
 
-	dev_addr = swiotlb_virt_to_bus(map);
+	dev_addr = swiotlb_virt_to_bus(hwdev, map);
 
 	/*
 	 * Ensure that the address returned is DMA'ble
@@ -710,6 +679,7 @@ swiotlb_map_single(struct device *hwdev, void *ptr, size_t size, int dir)
 {
 	return swiotlb_map_single_attrs(hwdev, ptr, size, dir, NULL);
 }
+EXPORT_SYMBOL(swiotlb_map_single);
 
 /*
  * Unmap a single streaming mode DMA translation.  The dma_addr and size must
@@ -739,6 +709,8 @@ swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr, size_t size,
 {
 	return swiotlb_unmap_single_attrs(hwdev, dev_addr, size, dir, NULL);
 }
+EXPORT_SYMBOL(swiotlb_unmap_single);
+
 /*
  * Make physical memory consistent for a single streaming mode DMA translation
  * after a transfer.
@@ -768,6 +740,7 @@ swiotlb_sync_single_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
 {
 	swiotlb_sync_single(hwdev, dev_addr, size, dir, SYNC_FOR_CPU);
 }
+EXPORT_SYMBOL(swiotlb_sync_single_for_cpu);
 
 void
 swiotlb_sync_single_for_device(struct device *hwdev, dma_addr_t dev_addr,
@@ -775,6 +748,7 @@ swiotlb_sync_single_for_device(struct device *hwdev, dma_addr_t dev_addr,
 {
 	swiotlb_sync_single(hwdev, dev_addr, size, dir, SYNC_FOR_DEVICE);
 }
+EXPORT_SYMBOL(swiotlb_sync_single_for_device);
 
 /*
  * Same as above, but for a sub-range of the mapping.
@@ -800,6 +774,7 @@ swiotlb_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dev_addr,
 	swiotlb_sync_single_range(hwdev, dev_addr, offset, size, dir,
 				  SYNC_FOR_CPU);
 }
+EXPORT_SYMBOL_GPL(swiotlb_sync_single_range_for_cpu);
 
 void
 swiotlb_sync_single_range_for_device(struct device *hwdev, dma_addr_t dev_addr,
@@ -808,9 +783,8 @@ swiotlb_sync_single_range_for_device(struct device *hwdev, dma_addr_t dev_addr,
 	swiotlb_sync_single_range(hwdev, dev_addr, offset, size, dir,
 				  SYNC_FOR_DEVICE);
 }
+EXPORT_SYMBOL_GPL(swiotlb_sync_single_range_for_device);
 
-void swiotlb_unmap_sg_attrs(struct device *, struct scatterlist *, int, int,
-			    struct dma_attrs *);
 /*
  * Map a set of buffers described by scatterlist in streaming mode for DMA.
  * This is the scatter-gather version of the above swiotlb_map_single
@@ -832,20 +806,18 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 		     int dir, struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
-	struct swiotlb_phys_addr buffer;
-	dma_addr_t dev_addr;
 	int i;
 
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		dev_addr = swiotlb_sg_to_bus(sg);
-		if (range_needs_mapping(sg_virt(sg), sg->length) ||
+		void *addr = sg_virt(sg);
+		dma_addr_t dev_addr = swiotlb_virt_to_bus(hwdev, addr);
+
+		if (range_needs_mapping(addr, sg->length) ||
 		    address_needs_mapping(hwdev, dev_addr, sg->length)) {
-			void *map;
-			buffer.page   = sg_page(sg);
-			buffer.offset = sg->offset;
-			map = map_single(hwdev, buffer, sg->length, dir);
+			void *map = map_single(hwdev, sg_phys(sg),
+					       sg->length, dir);
 			if (!map) {
 				/* Don't panic here, we expect map_sg users
 				   to do proper error handling. */
@@ -855,7 +827,7 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 				sgl[0].dma_length = 0;
 				return 0;
 			}
-			sg->dma_address = swiotlb_virt_to_bus(map);
+			sg->dma_address = swiotlb_virt_to_bus(hwdev, map);
 		} else
 			sg->dma_address = dev_addr;
 		sg->dma_length = sg->length;
@@ -870,6 +842,7 @@ swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
 {
 	return swiotlb_map_sg_attrs(hwdev, sgl, nelems, dir, NULL);
 }
+EXPORT_SYMBOL(swiotlb_map_sg);
 
 /*
  * Unmap a set of streaming mode DMA translations.  Again, cpu read rules
@@ -885,11 +858,11 @@ swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		if (sg->dma_address != swiotlb_sg_to_bus(sg))
+		if (sg->dma_address != swiotlb_virt_to_bus(hwdev, sg_virt(sg)))
 			unmap_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
 				     sg->dma_length, dir);
 		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg->dma_length);
+			dma_mark_clean(sg_virt(sg), sg->dma_length);
 	}
 }
 EXPORT_SYMBOL(swiotlb_unmap_sg_attrs);
@@ -900,6 +873,7 @@ swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
 {
 	return swiotlb_unmap_sg_attrs(hwdev, sgl, nelems, dir, NULL);
 }
+EXPORT_SYMBOL(swiotlb_unmap_sg);
 
 /*
  * Make physical memory consistent for a set of streaming mode DMA translations
@@ -918,11 +892,11 @@ swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		if (sg->dma_address != swiotlb_sg_to_bus(sg))
+		if (sg->dma_address != swiotlb_virt_to_bus(hwdev, sg_virt(sg)))
 			sync_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
 				    sg->dma_length, dir, target);
 		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg->dma_length);
+			dma_mark_clean(sg_virt(sg), sg->dma_length);
 	}
 }
 
@@ -932,6 +906,7 @@ swiotlb_sync_sg_for_cpu(struct device *hwdev, struct scatterlist *sg,
 {
 	swiotlb_sync_sg(hwdev, sg, nelems, dir, SYNC_FOR_CPU);
 }
+EXPORT_SYMBOL(swiotlb_sync_sg_for_cpu);
 
 void
 swiotlb_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
@@ -939,12 +914,14 @@ swiotlb_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
 {
 	swiotlb_sync_sg(hwdev, sg, nelems, dir, SYNC_FOR_DEVICE);
 }
+EXPORT_SYMBOL(swiotlb_sync_sg_for_device);
 
 int
 swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
 {
-	return (dma_addr == swiotlb_virt_to_bus(io_tlb_overflow_buffer));
+	return (dma_addr == swiotlb_virt_to_bus(hwdev, io_tlb_overflow_buffer));
 }
+EXPORT_SYMBOL(swiotlb_dma_mapping_error);
 
 /*
  * Return whether the given device DMA address mask can be supported
@@ -955,20 +932,6 @@ swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
 int
 swiotlb_dma_supported(struct device *hwdev, u64 mask)
 {
-	return swiotlb_virt_to_bus(io_tlb_end - 1) <= mask;
+	return swiotlb_virt_to_bus(hwdev, io_tlb_end - 1) <= mask;
 }
-
-EXPORT_SYMBOL(swiotlb_map_single);
-EXPORT_SYMBOL(swiotlb_unmap_single);
-EXPORT_SYMBOL(swiotlb_map_sg);
-EXPORT_SYMBOL(swiotlb_unmap_sg);
-EXPORT_SYMBOL(swiotlb_sync_single_for_cpu);
-EXPORT_SYMBOL(swiotlb_sync_single_for_device);
-EXPORT_SYMBOL_GPL(swiotlb_sync_single_range_for_cpu);
-EXPORT_SYMBOL_GPL(swiotlb_sync_single_range_for_device);
-EXPORT_SYMBOL(swiotlb_sync_sg_for_cpu);
-EXPORT_SYMBOL(swiotlb_sync_sg_for_device);
-EXPORT_SYMBOL(swiotlb_dma_mapping_error);
-EXPORT_SYMBOL(swiotlb_alloc_coherent);
-EXPORT_SYMBOL(swiotlb_free_coherent);
 EXPORT_SYMBOL(swiotlb_dma_supported);
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 801c08b..a7c6c56 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -223,7 +223,7 @@ int bdi_init(struct backing_dev_info *bdi)
 	bdi->max_prop_frac = PROP_FRAC_BASE;
 
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++) {
-		err = percpu_counter_init_irq(&bdi->bdi_stat[i], 0);
+		err = percpu_counter_init(&bdi->bdi_stat[i], 0);
 		if (err)
 			goto err;
 	}
