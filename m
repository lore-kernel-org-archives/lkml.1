Return-Path: <linux-kernel-owner+w=401wt.eu-S1758172AbZFXOiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbZFXOiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 10:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbZFXOiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 10:38:16 -0400
Received: from www.tglx.de ([62.245.132.106]:47241 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbZFXOiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 10:38:15 -0400
Date: Wed, 24 Jun 2009 16:36:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH V2] futex: Fix the write access fault problem for real
Message-ID: <alpine.LFD.2.00.0906241629590.2767@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 64d1304a64 (futex: setup writeable mapping for futex ops which
modify user space data) did address only half of the problem of write
access faults.

The patch was made on two wrong assumptions:

1) access_ok(VERIFY_WRITE,...) would actually check write access.

   On x86 it does _NOT_. It's a pure address range check.

2) a RW mapped region can not go away under us.

   That's wrong as well. Nobody can prevent another thread to call
   mprotect(PROT_READ) on that region where the futex resides. If that
   call hits between the get_user_pages_fast() verification and the
   actual write access in the atomic region we are toast again.

The solution is to not rely on access_ok and get_user() for any write
access related fault on private and shared futexes. Instead we need to
fault it in with verification of write access.

There is no generic non destructive write mechanism which would fault
the user page in trough a #PF, but as we already know that we will
fault we can as well call get_user_pages() directly and avoid the #PF
overhead.

If get_user_pages() returns -EFAULT we know that we can not fix it
anymore and need to bail out to user space.

Remove a bunch of confusing comments on this issue as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@kernel.org
---
 kernel/futex.c |   45 ++++++++++++++++++++++++---------------------
 1 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 80b5ce7..1c33711 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -284,6 +284,25 @@ void put_futex_key(int fshared, union futex_key *key)
 	drop_futex_key_refs(key);
 }
 
+/*
+ * fault_in_user_writeable - fault in user address and verify RW access
+ * @uaddr:	pointer to faulting user space address
+ *
+ * Slow path to fixup the fault we just took in the atomic write
+ * access to @uaddr.
+ *
+ * We have no generic implementation of a non destructive write to the
+ * user address. We know that we faulted in the atomic pagefault
+ * disabled section so we can as well avoid the #PF overhead by
+ * calling get_user_pages() right away.
+ */
+static int fault_in_user_writeable(u32 __user *uaddr)
+{
+	int ret = get_user_pages(current, current->mm, (unsigned long)uaddr,
+				 sizeof(*uaddr), 1, 0, NULL, NULL);
+	return ret < 0 ? ret : 0;
+}
+
 /**
  * futex_top_waiter() - Return the highest priority waiter on a futex
  * @hb:     the hash bucket the futex_q's reside in
@@ -896,7 +915,6 @@ retry:
 retry_private:
 	op_ret = futex_atomic_op_inuser(op, uaddr2);
 	if (unlikely(op_ret < 0)) {
-		u32 dummy;
 
 		double_unlock_hb(hb1, hb2);
 
@@ -914,7 +932,7 @@ retry_private:
 			goto out_put_keys;
 		}
 
-		ret = get_user(dummy, uaddr2);
+		ret = fault_in_user_writeable(uaddr2);
 		if (ret)
 			goto out_put_keys;
 
@@ -1204,7 +1222,7 @@ retry_private:
 			double_unlock_hb(hb1, hb2);
 			put_futex_key(fshared, &key2);
 			put_futex_key(fshared, &key1);
-			ret = get_user(curval2, uaddr2);
+			ret = fault_in_user_writeable(uaddr2);
 			if (!ret)
 				goto retry;
 			goto out;
@@ -1482,7 +1500,7 @@ retry:
 handle_fault:
 	spin_unlock(q->lock_ptr);
 
-	ret = get_user(uval, uaddr);
+	ret = fault_in_user_writeable(uaddr);
 
 	spin_lock(q->lock_ptr);
 
@@ -1807,7 +1825,6 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct futex_hash_bucket *hb;
-	u32 uval;
 	struct futex_q q;
 	int res, ret;
 
@@ -1909,16 +1926,9 @@ out:
 	return ret != -EINTR ? ret : -ERESTARTNOINTR;
 
 uaddr_faulted:
-	/*
-	 * We have to r/w  *(int __user *)uaddr, and we have to modify it
-	 * atomically.  Therefore, if we continue to fault after get_user()
-	 * below, we need to handle the fault ourselves, while still holding
-	 * the mmap_sem.  This can occur if the uaddr is under contention as
-	 * we have to drop the mmap_sem in order to call get_user().
-	 */
 	queue_unlock(&q, hb);
 
-	ret = get_user(uval, uaddr);
+	ret = fault_in_user_writeable(uaddr);
 	if (ret)
 		goto out_put_key;
 
@@ -2013,17 +2023,10 @@ out:
 	return ret;
 
 pi_faulted:
-	/*
-	 * We have to r/w  *(int __user *)uaddr, and we have to modify it
-	 * atomically.  Therefore, if we continue to fault after get_user()
-	 * below, we need to handle the fault ourselves, while still holding
-	 * the mmap_sem.  This can occur if the uaddr is under contention as
-	 * we have to drop the mmap_sem in order to call get_user().
-	 */
 	spin_unlock(&hb->lock);
 	put_futex_key(fshared, &key);
 
-	ret = get_user(uval, uaddr);
+	ret = fault_in_user_writeable(uaddr);
 	if (!ret)
 		goto retry;
 
-- 
1.6.0.6

