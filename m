Return-Path: <linux-kernel-owner+w=401wt.eu-S1762149AbZFXTsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762149AbZFXTsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 15:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbZFXTse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 15:48:34 -0400
Received: from www.tglx.de ([62.245.132.106]:58867 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbZFXTse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 15:48:34 -0400
Date: Wed, 24 Jun 2009 21:48:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhltc@us.ibm.com>
Subject: [GIT pull] futex fixes for 2.6.31
In-Reply-To: <alpine.LFD.2.01.0906240946000.3240@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0906242146500.2767@localhost.localdomain>
References: <alpine.LFD.2.00.0906241629590.2767@localhost.localdomain> <alpine.LFD.2.01.0906240946000.3240@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest futexes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git futexes-for-linus

Thanks,

	tglx

------------------>
Thomas Gleixner (1):
      futex: Fix the write access fault problem for real


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
 
