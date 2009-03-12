Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbZCLH5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbZCLH5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 03:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbZCLH4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 03:56:19 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57235 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755132AbZCLH4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 03:56:17 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH 6/6] futex: cleanup fault logic
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>, Darren Hart <dvhltc@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 12 Mar 2009 00:56:13 -0700
Message-ID: <20090312075612.9856.48612.stgit@Aeon>
In-Reply-To: <20090312075349.9856.83687.stgit@Aeon>
References: <20090312075349.9856.83687.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Older versions of the futex code held the mmap_sem which had to be
dropped in order to call get_user(), so a two-pronged fault handling
mechanism was employed to handle faults of the atomic operations.  The
mmap_sem is no longer held, so get_user() should be adequate.  This patch
greatly simplifies the logic and improves legibility.

Build and boot tested on a 4 way Intel x86_64 workstation.  Passes basic
pthread_mutex and PI tests out of ltp/testcases/realtime.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---

 kernel/futex.c |  126 ++++++++++++++++----------------------------------------
 1 files changed, 36 insertions(+), 90 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index c980a55..9c97f67 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -298,41 +298,6 @@ static int get_futex_value_locked(u32 *dest, u32 __user *from)
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
@@ -760,9 +725,9 @@ futex_wake_op(u32 __user *uaddr1, int fshared, u32 __user *uaddr2,
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
@@ -773,9 +738,8 @@ retryfull:
 	hb1 = hash_futex(&key1);
 	hb2 = hash_futex(&key2);
 
-retry:
 	double_lock_hb(hb1, hb2);
-
+retry_private:
 	op_ret = futex_atomic_op_inuser(op, uaddr2);
 	if (unlikely(op_ret < 0)) {
 		u32 dummy;
@@ -796,28 +760,16 @@ retry:
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
 			goto out_put_keys;
 
+		if (!fshared)
+			goto retry_private;
+
 		put_futex_key(fshared, &key2);
 		put_futex_key(fshared, &key1);
-		goto retryfull;
+		goto retry;
 	}
 
 	head = &hb1->chain;
@@ -877,6 +829,7 @@ retry:
 	hb1 = hash_futex(&key1);
 	hb2 = hash_futex(&key2);
 
+retry_private:
 	double_lock_hb(hb1, hb2);
 
 	if (likely(cmpval != NULL)) {
@@ -887,15 +840,16 @@ retry:
 		if (unlikely(ret)) {
 			double_unlock_hb(hb1, hb2);
 
-			put_futex_key(fshared, &key2);
-			put_futex_key(fshared, &key1);
-
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
@@ -1070,7 +1024,7 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 	struct futex_pi_state *pi_state = q->pi_state;
 	struct task_struct *oldowner = pi_state->owner;
 	u32 uval, curval, newval;
-	int ret, attempt = 0;
+	int ret;
 
 	/* Owner died? */
 	if (!pi_state->owner)
@@ -1141,7 +1095,7 @@ retry:
 handle_fault:
 	spin_unlock(q->lock_ptr);
 
-	ret = futex_handle_fault((unsigned long)uaddr, attempt++);
+	ret = get_user(uval, uaddr);
 
 	spin_lock(q->lock_ptr);
 
@@ -1190,6 +1144,7 @@ retry:
 	if (unlikely(ret != 0))
 		goto out;
 
+retry_private:
 	hb = queue_lock(&q);
 
 	/*
@@ -1216,13 +1171,16 @@ retry:
 
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
@@ -1356,7 +1314,7 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 	struct futex_hash_bucket *hb;
 	u32 uval, newval, curval;
 	struct futex_q q;
-	int ret, lock_taken, ownerdied = 0, attempt = 0;
+	int ret, lock_taken, ownerdied = 0;
 
 	if (refill_pi_state_cache())
 		return -ENOMEM;
@@ -1376,7 +1334,7 @@ retry:
 	if (unlikely(ret != 0))
 		goto out;
 
-retry_unlocked:
+retry_private:
 	hb = queue_lock(&q);
 
 retry_locked:
@@ -1601,18 +1559,15 @@ uaddr_faulted:
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
-		goto retry_unlocked;
+	if (ret)
+		goto out_put_key;
 
-	goto out_put_key;
+	if (!fshared)
+		goto retry_private;
+
+	put_futex_key(fshared, &q.key);
+	goto retry;
 }
 
 
@@ -1628,7 +1583,7 @@ static int futex_unlock_pi(u32 __user *uaddr, int fshared)
 	u32 uval;
 	struct plist_head *head;
 	union futex_key key = FUTEX_KEY_INIT;
-	int ret, attempt = 0;
+	int ret;
 
 retry:
 	if (get_user(uval, uaddr))
@@ -1644,7 +1599,6 @@ retry:
 		goto out;
 
 	hb = hash_futex(&key);
-retry_unlocked:
 	spin_lock(&hb->lock);
 
 	/*
@@ -1709,17 +1663,9 @@ pi_faulted:
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
-	put_futex_key(fshared, &key);
 	if (!ret)
 		goto retry;
 

