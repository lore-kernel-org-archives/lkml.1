Return-Path: <linux-kernel-owner+w=401wt.eu-S934320AbXEGPOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934320AbXEGPOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 11:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934219AbXEGPOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 11:14:10 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:41578 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S934280AbXEGPOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 11:14:09 -0400
X-Greylist: delayed 1792 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 May 2007 11:14:08 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=IEE0+kshcIOWtR+zteESUJ9oqcTwCBzcEqDkUCW8YcpQ4unX/QpQjEv2+wjSNF+Znxx8Sf5ovyz5O+qRJFHFsEnjx+Ig3p+DnpnsGIEUXrsJ/xLBNBH4PXezBeFxwsZ0Iuny4NE/Ytr0+U5jQn21MR2O3t4tF6k1koKdFBHcb0Y=;
Date: Mon, 7 May 2007 18:43:51 +0400
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] muptiple bugs in PI futexes
Message-ID: <20070507144351.GA12302@ms2.inr.ac.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

1. New entries can be added to tsk->pi_state_list after task completed
   exit_pi_state_list(). The result is memory leakage and deadlocks.

2. handle_mm_fault() is called under spinlock. The result is obvious.

3. State machine is broken. Kernel thinks it owns futex after
   it released all the locks. Ergo, it corrupts futex. The result is that
   two processes think they took a futex.

All the bugs are trivially reproduced when running glibc's tst-robustpi7
test long enough.

The patch is not quite good (RFC!), because:

1. There is one case, when I did not figure out how to handle
   page fault correctly. I would do it releasing taken rtmutex
   and hb->lock and retrying futex from the very beginning.
   It is quite ugly. Probably, state machine can be fixed somehow.

2. Before this patch I had one unexplained oops inside rtmutex
   in plist_del. I did _not_ fix this, but it does not want to reproduce.
   Probably, more strong locking did some race window too narrow.

Alexey



diff --git a/kernel/futex.c b/kernel/futex.c
index 5a270b5..4207034 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -396,10 +396,13 @@ static struct task_struct * futex_find_g
 		p = NULL;
 		goto out_unlock;
 	}
+#if 0
+	/* The test is meaningless. Should I explain why? --ANK */
 	if (p->exit_state != 0) {
 		p = NULL;
 		goto out_unlock;
 	}
+#endif
 	get_task_struct(p);
 out_unlock:
 	rcu_read_unlock();
@@ -505,6 +508,18 @@ lookup_pi_state(u32 uval, struct futex_h
 	if (!p)
 		return -ESRCH;
 
+	/* Task state transitions are protected only by tasklist_lock
+	 * and by nothing else. Better solution would be
+	 * to use ->pi_lock. But this should be done in do_exit() as well.
+	 * So, I use tasklist_lock for now.
+	 */
+	read_lock(&tasklist_lock);
+	if (p->exit_state) {
+		read_unlock(&tasklist_lock);
+		put_task_struct(p);
+		return -ESRCH;
+	}
+
 	pi_state = alloc_pi_state();
 
 	/*
@@ -522,6 +537,8 @@ lookup_pi_state(u32 uval, struct futex_h
 	pi_state->owner = p;
 	spin_unlock_irq(&p->pi_lock);
 
+	read_unlock(&tasklist_lock);
+
 	put_task_struct(p);
 
 	me->pi_state = pi_state;
@@ -1149,6 +1166,7 @@ static int futex_lock_pi(u32 __user *uad
 	if (unlikely(ret != 0))
 		goto out_release_sem;
 
+ retry_unlocked:
 	hb = queue_lock(&q, -1, NULL);
 
  retry_locked:
@@ -1279,13 +1297,48 @@ static int futex_lock_pi(u32 __user *uad
 		list_add(&q.pi_state->list, &current->pi_state_list);
 		spin_unlock_irq(&current->pi_lock);
 
+		for (;;) {
+			newval = (uval & FUTEX_OWNER_DIED) | newtid;
+			pagefault_disable();
+			curval = futex_atomic_cmpxchg_inatomic(uaddr,
+							       uval, newval);
+			pagefault_enable();
+
+			/* If course, this is wrong. If we fault here,
+			 * we must:
+			 *  1. Probably, drop rtmutex, if we still hold it.
+			 *  2. drop all the locks.
+			 *  3. handle fault
+			 *  4. restart from the very beginning.
+			 *
+			 *  I am not doing this just because all the code
+			 *  dealing with faults (handle_mm_fault under
+			 *  spinlock, is not it cool?) used to be very wrong
+			 *  and my fix would be overwritten in any
+			 *  case. Seems, this needs more qualification
+			 *  than I have. Ingo, please...
+			 */
+			if (curval == -EFAULT) {
+				ret = -EFAULT;
+				break;
+			}
+			if (curval == uval)
+				break;
+			uval = curval;
+		}
+
 		/* Unqueue and drop the lock */
 		unqueue_me_pi(&q, hb);
 		up_read(&curr->mm->mmap_sem);
+#if 0
 		/*
 		 * We own it, so we have to replace the pending owner
 		 * TID. This must be atomic as we have preserve the
 		 * owner died bit here.
+		 *
+		 * Why do you think you "own" it? You have just dropped
+		 * all the locks and rtmutex. No traces of your right
+		 * remained :-) --ANK
 		 */
 		ret = get_user(uval, uaddr);
 		while (!ret) {
@@ -1298,6 +1351,7 @@ static int futex_lock_pi(u32 __user *uad
 				break;
 			uval = curval;
 		}
+#endif
 	} else {
 		/*
 		 * Catch the rare case, where the lock was released
@@ -1331,16 +1385,19 @@ static int futex_lock_pi(u32 __user *uad
 	 * non-atomically.  Therefore, if get_user below is not
 	 * enough, we need to handle the fault ourselves, while
 	 * still holding the mmap_sem.
+	 *
+	 * ... and hb->lock. :-) --ANK
 	 */
+	queue_unlock(&q, hb);
+
 	if (attempt++) {
 		if (futex_handle_fault((unsigned long)uaddr, attempt)) {
 			ret = -EFAULT;
-			goto out_unlock_release_sem;
+			goto out_release_sem;
 		}
-		goto retry_locked;
+		goto retry_unlocked;
 	}
 
-	queue_unlock(&q, hb);
 	up_read(&curr->mm->mmap_sem);
 
 	ret = get_user(uval, uaddr);
@@ -1382,9 +1439,9 @@ retry:
 		goto out;
 
 	hb = hash_futex(&key);
+retry_unlocked:
 	spin_lock(&hb->lock);
 
-retry_locked:
 	/*
 	 * To avoid races, try to do the TID -> 0 atomic transition
 	 * again. If it succeeds then we can return without waking
@@ -1446,16 +1503,19 @@ pi_faulted:
 	 * non-atomically.  Therefore, if get_user below is not
 	 * enough, we need to handle the fault ourselves, while
 	 * still holding the mmap_sem.
+	 *
+	 * ... and hb->lock. --ANK
 	 */
+	spin_unlock(&hb->lock);
+
 	if (attempt++) {
 		if (futex_handle_fault((unsigned long)uaddr, attempt)) {
 			ret = -EFAULT;
-			goto out_unlock;
+			goto out;
 		}
-		goto retry_locked;
+		goto retry_unlocked;
 	}
 
-	spin_unlock(&hb->lock);
 	up_read(&current->mm->mmap_sem);
 
 	ret = get_user(uval, uaddr);
