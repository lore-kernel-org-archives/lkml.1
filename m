Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbZCLH4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbZCLH4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 03:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbZCLHzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 03:55:44 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57166 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbZCLHzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 03:55:43 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH 1/6] Update futex commentary
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>, Darren Hart <dvhltc@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 12 Mar 2009 00:55:37 -0700
Message-ID: <20090312075537.9856.29954.stgit@Aeon>
In-Reply-To: <20090312075349.9856.83687.stgit@Aeon>
References: <20090312075349.9856.83687.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The futex_hash_bucket can be a bit confusing when first looking at the code as
it is a shared queue (and futex_q isn't a queue at all, but rather an element
on the queue).

The mmap_sem is no longer held outside of the futex_handle_fault() routine, yet
numerous comments refer to it.  The fshared argument is no an integer.  I left
some of these comments along as they are simply removed in future patches.

Some of the commentary refering to futexes by virtual page mappings was not
very clear, and completely accurate (as for shared futexes both the page and
the offset are used to determine the key).  For the purposes of the function
description, just referring to "the futex" seems sufficient.

With hashed futexes we now access the page after the hash-bucket is locked, and
not only after it is enqueued.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---

 kernel/futex.c |   33 ++++++++++++++-------------------
 1 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 438701a..e6a4d72 100644
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
@@ -589,10 +588,9 @@ static void wake_futex(struct futex_q *q)
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
@@ -693,8 +691,7 @@ double_lock_hb(struct futex_hash_bucket *hb1, struct futex_hash_bucket *hb2)
 }
 
 /*
- * Wake up all waiters hashed on the physical page that is mapped
- * to this virtual address:
+ * Wake up waiters matching bitset queued on this futex (uaddr).
  */
 static int futex_wake(u32 __user *uaddr, int fshared, int nr_wake, u32 bitset)
 {
@@ -1076,11 +1073,9 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
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
@@ -1188,7 +1183,7 @@ retry:
 	hb = queue_lock(&q);
 
 	/*
-	 * Access the page AFTER the futex is queued.
+	 * Access the page AFTER the hash-bucket is locked.
 	 * Order is important:
 	 *
 	 *   Userspace waiter: val = var; if (cond(val)) futex_wait(&var, val);
@@ -1204,7 +1199,7 @@ retry:
 	 * a wakeup when *uaddr != val on entry to the syscall.  This is
 	 * rare, but normal.
 	 *
-	 * for shared futexes, we hold the mmap semaphore, so the mapping
+	 * For shared futexes, we hold the mmap semaphore, so the mapping
 	 * cannot have changed since we looked it up in get_futex_key.
 	 */
 	ret = get_futex_value_locked(&uval, uaddr);

