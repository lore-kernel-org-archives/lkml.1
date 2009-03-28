Return-Path: <linux-kernel-owner+w=401wt.eu-S1762107AbZC1W3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762107AbZC1W3W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 18:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbZC1W3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 18:29:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38427 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548AbZC1W3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 18:29:10 -0400
Date: Sat, 28 Mar 2009 23:28:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] futex updates for v2.6.30
Message-ID: <20090328222849.GA14144@elte.hu>
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

Please pull the latest futexes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git futexes-for-linus

 Thanks,

	Ingo

------------------>
Darren Hart (7):
      futex: update futex commentary
      futex: additional (get|put)_futex_key() fixes
      futex: add double_unlock_hb()
      futex: use current->time_slack_ns for rt tasks too
      futex: unlock before returning -EFAULT
      futex: clean up fault logic
      futex: remove the pointer math from double_unlock_hb

Ingo Molnar (1):
      futex: remove the pointer math from double_unlock_hb, fix


 kernel/futex.c |  201 +++++++++++++++++++++-----------------------------------
 1 files changed, 76 insertions(+), 125 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 438701a..6b50a02 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -114,7 +114,9 @@ struct futex_q {
 };
 
 /*
- * Split the global futex_lock into every hash list lock.
+ * Hash buckets are shared by all the futex_keys that hash to the same
+ * location.  Each key may have multiple futex_q structures, one for each task
+ * waiting on a futex.
  */
 struct futex_hash_bucket {
 	spinlock_t lock;
@@ -189,8 +191,7 @@ static void drop_futex_key_refs(union futex_key *key)
 /**
  * get_futex_key - Get parameters which are the keys for a futex.
  * @uaddr: virtual address of the futex
- * @shared: NULL for a PROCESS_PRIVATE futex,
- *	&current->mm->mmap_sem for a PROCESS_SHARED futex
+ * @fshared: 0 for a PROCESS_PRIVATE futex, 1 for PROCESS_SHARED
  * @key: address where result is stored.
  *
  * Returns a negative error code or 0
@@ -200,9 +201,7 @@ static void drop_futex_key_refs(union futex_key *key)
  * offset_within_page).  For private mappings, it's (uaddr, current->mm).
  * We can usually work out the index without swapping in the page.
  *
- * fshared is NULL for PROCESS_PRIVATE futexes
- * For other futexes, it points to &current->mm->mmap_sem and
- * caller must have taken the reader lock. but NOT any spinlocks.
+ * lock_page() might sleep, the caller should not hold a spinlock.
  */
 static int get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
 {
@@ -299,41 +298,6 @@ static int get_futex_value_locked(u32 *dest, u32 __user *from)
 	return ret ? -EFAULT : 0;
 }
 
-/*
- * Fault handling.
- */
-static int futex_handle_fault(unsigned long address, int attempt)
-{
-	struct vm_area_struct * vma;
-	struct mm_struct *mm = current->mm;
-	int ret = -EFAULT;
-
-	if (attempt > 2)
-		return ret;
-
-	down_read(&mm->mmap_sem);
-	vma = find_vma(mm, address);
-	if (vma && address >= vma->vm_start &&
-	    (vma->vm_flags & VM_WRITE)) {
-		int fault;
-		fault = handle_mm_fault(mm, vma, address, 1);
-		if (unlikely((fault & VM_FAULT_ERROR))) {
-#if 0
-			/* XXX: let's do this when we verify it is OK */
-			if (ret & VM_FAULT_OOM)
-				ret = -ENOMEM;
-#endif
-		} else {
-			ret = 0;
-			if (fault & VM_FAULT_MAJOR)
-				current->maj_flt++;
-			else
-				current->min_flt++;
-		}
-	}
-	up_read(&mm->mmap_sem);
-	return ret;
-}
 
 /*
  * PI code:
@@ -589,10 +553,9 @@ static void wake_futex(struct futex_q *q)
 	 * The waiting task can free the futex_q as soon as this is written,
 	 * without taking any locks.  This must come last.
 	 *
-	 * A memory barrier is required here to prevent the following store
-	 * to lock_ptr from getting ahead of the wakeup. Clearing the lock
-	 * at the end of wake_up_all() does not prevent this store from
-	 * moving.
+	 * A memory barrier is required here to prevent the following store to
+	 * lock_ptr from getting ahead of the wakeup. Clearing the lock at the
+	 * end of wake_up() does not prevent this store from moving.
 	 */
 	smp_wmb();
 	q->lock_ptr = NULL;
@@ -692,9 +655,16 @@ double_lock_hb(struct futex_hash_bucket *hb1, struct futex_hash_bucket *hb2)
 	}
 }
 
+static inline void
+double_unlock_hb(struct futex_hash_bucket *hb1, struct futex_hash_bucket *hb2)
+{
+	spin_unlock(&hb1->lock);
+	if (hb1 != hb2)
+		spin_unlock(&hb2->lock);
+}
+
 /*
- * Wake up all waiters hashed on the physical page that is mapped
- * to this virtual address:
+ * Wake up waiters matching bitset queued on this futex (uaddr).
  */
 static int futex_wake(u32 __user *uaddr, int fshared, int nr_wake, u32 bitset)
 {
@@ -750,9 +720,9 @@ futex_wake_op(u32 __user *uaddr1, int fshared, u32 __user *uaddr2,
 	struct futex_hash_bucket *hb1, *hb2;
 	struct plist_head *head;
 	struct futex_q *this, *next;
-	int ret, op_ret, attempt = 0;
+	int ret, op_ret;
 
-retryfull:
+retry:
 	ret = get_futex_key(uaddr1, fshared, &key1);
 	if (unlikely(ret != 0))
 		goto out;
@@ -763,16 +733,13 @@ retryfull:
 	hb1 = hash_futex(&key1);
 	hb2 = hash_futex(&key2);
 
-retry:
 	double_lock_hb(hb1, hb2);
-
+retry_private:
 	op_ret = futex_atomic_op_inuser(op, uaddr2);
 	if (unlikely(op_ret < 0)) {
 		u32 dummy;
 
-		spin_unlock(&hb1->lock);
-		if (hb1 != hb2)
-			spin_unlock(&hb2->lock);
+		double_unlock_hb(hb1, hb2);
 
 #ifndef CONFIG_MMU
 		/*
@@ -788,26 +755,16 @@ retry:
 			goto out_put_keys;
 		}
 
-		/*
-		 * futex_atomic_op_inuser needs to both read and write
-		 * *(int __user *)uaddr2, but we can't modify it
-		 * non-atomically.  Therefore, if get_user below is not
-		 * enough, we need to handle the fault ourselves, while
-		 * still holding the mmap_sem.
-		 */
-		if (attempt++) {
-			ret = futex_handle_fault((unsigned long)uaddr2,
-						 attempt);
-			if (ret)
-				goto out_put_keys;
-			goto retry;
-		}
-
 		ret = get_user(dummy, uaddr2);
 		if (ret)
-			return ret;
+			goto out_put_keys;
+
+		if (!fshared)
+			goto retry_private;
 
-		goto retryfull;
+		put_futex_key(fshared, &key2);
+		put_futex_key(fshared, &key1);
+		goto retry;
 	}
 
 	head = &hb1->chain;
@@ -834,9 +791,7 @@ retry:
 		ret += op_ret;
 	}
 
-	spin_unlock(&hb1->lock);
-	if (hb1 != hb2)
-		spin_unlock(&hb2->lock);
+	double_unlock_hb(hb1, hb2);
 out_put_keys:
 	put_futex_key(fshared, &key2);
 out_put_key1:
@@ -869,6 +824,7 @@ retry:
 	hb1 = hash_futex(&key1);
 	hb2 = hash_futex(&key2);
 
+retry_private:
 	double_lock_hb(hb1, hb2);
 
 	if (likely(cmpval != NULL)) {
@@ -877,16 +833,18 @@ retry:
 		ret = get_futex_value_locked(&curval, uaddr1);
 
 		if (unlikely(ret)) {
-			spin_unlock(&hb1->lock);
-			if (hb1 != hb2)
-				spin_unlock(&hb2->lock);
+			double_unlock_hb(hb1, hb2);
 
 			ret = get_user(curval, uaddr1);
+			if (ret)
+				goto out_put_keys;
 
-			if (!ret)
-				goto retry;
+			if (!fshared)
+				goto retry_private;
 
-			goto out_put_keys;
+			put_futex_key(fshared, &key2);
+			put_futex_key(fshared, &key1);
+			goto retry;
 		}
 		if (curval != *cmpval) {
 			ret = -EAGAIN;
@@ -923,9 +881,7 @@ retry:
 	}
 
 out_unlock:
-	spin_unlock(&hb1->lock);
-	if (hb1 != hb2)
-		spin_unlock(&hb2->lock);
+	double_unlock_hb(hb1, hb2);
 
 	/* drop_futex_key_refs() must be called outside the spinlocks. */
 	while (--drop_count >= 0)
@@ -1063,7 +1019,7 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 	struct futex_pi_state *pi_state = q->pi_state;
 	struct task_struct *oldowner = pi_state->owner;
 	u32 uval, curval, newval;
-	int ret, attempt = 0;
+	int ret;
 
 	/* Owner died? */
 	if (!pi_state->owner)
@@ -1076,11 +1032,9 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 	 * in the user space variable. This must be atomic as we have
 	 * to preserve the owner died bit here.
 	 *
-	 * Note: We write the user space value _before_ changing the
-	 * pi_state because we can fault here. Imagine swapped out
-	 * pages or a fork, which was running right before we acquired
-	 * mmap_sem, that marked all the anonymous memory readonly for
-	 * cow.
+	 * Note: We write the user space value _before_ changing the pi_state
+	 * because we can fault here. Imagine swapped out pages or a fork
+	 * that marked all the anonymous memory readonly for cow.
 	 *
 	 * Modifying pi_state _before_ the user space value would
 	 * leave the pi_state in an inconsistent state when we fault
@@ -1136,7 +1090,7 @@ retry:
 handle_fault:
 	spin_unlock(q->lock_ptr);
 
-	ret = futex_handle_fault((unsigned long)uaddr, attempt++);
+	ret = get_user(uval, uaddr);
 
 	spin_lock(q->lock_ptr);
 
@@ -1185,10 +1139,11 @@ retry:
 	if (unlikely(ret != 0))
 		goto out;
 
+retry_private:
 	hb = queue_lock(&q);
 
 	/*
-	 * Access the page AFTER the futex is queued.
+	 * Access the page AFTER the hash-bucket is locked.
 	 * Order is important:
 	 *
 	 *   Userspace waiter: val = var; if (cond(val)) futex_wait(&var, val);
@@ -1204,20 +1159,23 @@ retry:
 	 * a wakeup when *uaddr != val on entry to the syscall.  This is
 	 * rare, but normal.
 	 *
-	 * for shared futexes, we hold the mmap semaphore, so the mapping
+	 * For shared futexes, we hold the mmap semaphore, so the mapping
 	 * cannot have changed since we looked it up in get_futex_key.
 	 */
 	ret = get_futex_value_locked(&uval, uaddr);
 
 	if (unlikely(ret)) {
 		queue_unlock(&q, hb);
-		put_futex_key(fshared, &q.key);
 
 		ret = get_user(uval, uaddr);
+		if (ret)
+			goto out_put_key;
 
-		if (!ret)
-			goto retry;
-		goto out;
+		if (!fshared)
+			goto retry_private;
+
+		put_futex_key(fshared, &q.key);
+		goto retry;
 	}
 	ret = -EWOULDBLOCK;
 	if (unlikely(uval != val)) {
@@ -1248,16 +1206,13 @@ retry:
 		if (!abs_time)
 			schedule();
 		else {
-			unsigned long slack;
-			slack = current->timer_slack_ns;
-			if (rt_task(current))
-				slack = 0;
 			hrtimer_init_on_stack(&t.timer,
 					      clockrt ? CLOCK_REALTIME :
 					      CLOCK_MONOTONIC,
 					      HRTIMER_MODE_ABS);
 			hrtimer_init_sleeper(&t, current);
-			hrtimer_set_expires_range_ns(&t.timer, *abs_time, slack);
+			hrtimer_set_expires_range_ns(&t.timer, *abs_time,
+						     current->timer_slack_ns);
 
 			hrtimer_start_expires(&t.timer, HRTIMER_MODE_ABS);
 			if (!hrtimer_active(&t.timer))
@@ -1354,7 +1309,7 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 	struct futex_hash_bucket *hb;
 	u32 uval, newval, curval;
 	struct futex_q q;
-	int ret, lock_taken, ownerdied = 0, attempt = 0;
+	int ret, lock_taken, ownerdied = 0;
 
 	if (refill_pi_state_cache())
 		return -ENOMEM;
@@ -1374,7 +1329,7 @@ retry:
 	if (unlikely(ret != 0))
 		goto out;
 
-retry_unlocked:
+retry_private:
 	hb = queue_lock(&q);
 
 retry_locked:
@@ -1458,6 +1413,7 @@ retry_locked:
 			 * exit to complete.
 			 */
 			queue_unlock(&q, hb);
+			put_futex_key(fshared, &q.key);
 			cond_resched();
 			goto retry;
 
@@ -1564,6 +1520,13 @@ retry_locked:
 		}
 	}
 
+	/*
+	 * If fixup_pi_state_owner() faulted and was unable to handle the
+	 * fault, unlock it and return the fault to userspace.
+	 */
+	if (ret && (rt_mutex_owner(&q.pi_state->pi_mutex) == current))
+		rt_mutex_unlock(&q.pi_state->pi_mutex);
+
 	/* Unqueue and drop the lock */
 	unqueue_me_pi(&q);
 
@@ -1591,22 +1554,18 @@ uaddr_faulted:
 	 */
 	queue_unlock(&q, hb);
 
-	if (attempt++) {
-		ret = futex_handle_fault((unsigned long)uaddr, attempt);
-		if (ret)
-			goto out_put_key;
-		goto retry_unlocked;
-	}
-
 	ret = get_user(uval, uaddr);
-	if (!ret)
-		goto retry;
+	if (ret)
+		goto out_put_key;
 
-	if (to)
-		destroy_hrtimer_on_stack(&to->timer);
-	return ret;
+	if (!fshared)
+		goto retry_private;
+
+	put_futex_key(fshared, &q.key);
+	goto retry;
 }
 
+
 /*
  * Userspace attempted a TID -> 0 atomic transition, and failed.
  * This is the in-kernel slowpath: we look up the PI state (if any),
@@ -1619,7 +1578,7 @@ static int futex_unlock_pi(u32 __user *uaddr, int fshared)
 	u32 uval;
 	struct plist_head *head;
 	union futex_key key = FUTEX_KEY_INIT;
-	int ret, attempt = 0;
+	int ret;
 
 retry:
 	if (get_user(uval, uaddr))
@@ -1635,7 +1594,6 @@ retry:
 		goto out;
 
 	hb = hash_futex(&key);
-retry_unlocked:
 	spin_lock(&hb->lock);
 
 	/*
@@ -1700,14 +1658,7 @@ pi_faulted:
 	 * we have to drop the mmap_sem in order to call get_user().
 	 */
 	spin_unlock(&hb->lock);
-
-	if (attempt++) {
-		ret = futex_handle_fault((unsigned long)uaddr, attempt);
-		if (ret)
-			goto out;
-		uval = 0;
-		goto retry_unlocked;
-	}
+	put_futex_key(fshared, &key);
 
 	ret = get_user(uval, uaddr);
 	if (!ret)
