Return-Path: <linux-kernel-owner+w=401wt.eu-S1764519AbYDOLxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764519AbYDOLxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 07:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYDOLxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 07:53:32 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:51942 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758713AbYDOLxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 07:53:31 -0400
Date: Tue, 15 Apr 2008 17:23:14 +0530
From: "K. Prasad" <prasad@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, a.p.zijlstra@chello.nl, mingo@elte.hu,
       mathieu.desnoyers@polymtl.ca
Subject: [RFC PATCH 1/2] Marker probes in futex.c
Message-ID: <20080415115314.GA6975@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20080415115058.GA6788@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415115058.GA6788@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We place a probe at the function entry for each futex operation,
and also at each point where a futex operation fails.
 
Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 kernel/futex.c |  110 +++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 88 insertions(+), 22 deletions(-)

Index: linux-2.6.25-rc8-mm2/kernel/futex.c
===================================================================
--- linux-2.6.25-rc8-mm2.orig/kernel/futex.c
+++ linux-2.6.25-rc8-mm2/kernel/futex.c
@@ -737,8 +737,14 @@ static int futex_wake(u32 __user *uaddr,
 	union futex_key key;
 	int ret;
 
-	if (!bitset)
-		return -EINVAL;
+	trace_mark(futex_wake_called, "uaddr:%p fshared:%p nr_wake:%d "
+			"bitset:%d",
+			uaddr, fshared, nr_wake, bitset);
+
+	if (unlikely(!bitset)) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	futex_lock_mm(fshared);
 
@@ -770,6 +776,8 @@ static int futex_wake(u32 __user *uaddr,
 	spin_unlock(&hb->lock);
 out:
 	futex_unlock_mm(fshared);
+	if (unlikely(ret != 0))
+		trace_mark(futex_wake_failed, "uaddr:%p ret:%d", uaddr, ret);
 	return ret;
 }
 
@@ -901,6 +909,14 @@ static int futex_requeue(u32 __user *uad
 	struct futex_q *this, *next;
 	int ret, drop_count = 0;
 
+	/*
+	 * Call this probe futex_cmp_requeue_called, although this function is
+	 * common to both FUTEX_REQUEUE and FUTEX_CMP_REQUEUE. This is because
+	 * FUTEX_REQUEUE is deprecated.
+	 */
+	trace_mark(futex_cmp_requeue_called, "uaddr1:%p fshared:%p uaddr2:%p "
+			"nr_wake:%d nr_requeue:%d cmpval:%p",
+			uaddr1, fshared, uaddr2, nr_wake, nr_requeue, cmpval);
  retry:
 	futex_lock_mm(fshared);
 
@@ -908,8 +924,12 @@ static int futex_requeue(u32 __user *uad
 	if (unlikely(ret != 0))
 		goto out;
 	ret = get_futex_key(uaddr2, fshared, &key2);
-	if (unlikely(ret != 0))
+	if (unlikely(ret != 0)) {
+		trace_mark(futex_cmp_requeue_uaddr2_failed, "uaddr1:%p "
+				"uaddr2:%p ret:%d",
+				uaddr1, uaddr2, ret);
 		goto out;
+	}
 
 	hb1 = hash_futex(&key1);
 	hb2 = hash_futex(&key2);
@@ -984,6 +1004,9 @@ out_unlock:
 
 out:
 	futex_unlock_mm(fshared);
+	if (unlikely(ret != 0))
+		trace_mark(futex_cmp_requeue_failed, "uaddr1:%p ret:%d", uaddr1,
+				ret);
 	return ret;
 }
 
@@ -1182,8 +1205,14 @@ static int futex_wait(u32 __user *uaddr,
 	struct hrtimer_sleeper t;
 	int rem = 0;
 
-	if (!bitset)
-		return -EINVAL;
+	trace_mark(futex_wait_called, "uaddr:%p fshared:%p val:%u "
+			"abs_time:%p bitset:%d",
+			uaddr, fshared, val, abs_time, bitset);
+
+	if (!bitset) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	q.pi_state = NULL;
 	q.bitset = bitset;
@@ -1231,11 +1260,13 @@ static int futex_wait(u32 __user *uaddr,
 
 		if (!ret)
 			goto retry;
-		return ret;
+		goto out;
 	}
 	ret = -EWOULDBLOCK;
-	if (uval != val)
+	if (uval != val) {
+		trace_mark(futex_wait_uval, "uaddr:%p uval:%u", uval, uaddr);
 		goto out_unlock_release_sem;
+	}
 
 	/* Only actually queue if *uaddr contained val.  */
 	__queue_me(&q, hb);
@@ -1292,6 +1323,7 @@ static int futex_wait(u32 __user *uaddr,
 			destroy_hrtimer_on_stack(&t.timer);
 		}
 	}
+	trace_mark(futex_wait_after_sched, "uaddr:%p", uaddr);
 	__set_current_state(TASK_RUNNING);
 
 	/*
@@ -1302,16 +1334,19 @@ static int futex_wait(u32 __user *uaddr,
 	/* If we were woken (and unqueued), we succeeded, whatever. */
 	if (!unqueue_me(&q))
 		return 0;
-	if (rem)
-		return -ETIMEDOUT;
+	if (rem) {
+		ret = -ETIMEDOUT;
+		goto out;
+	}
 
 	/*
 	 * We expect signal_pending(current), but another thread may
 	 * have handled it for us already.
 	 */
-	if (!abs_time)
-		return -ERESTARTSYS;
-	else {
+	if (!abs_time) {
+		ret = -ERESTARTSYS;
+		goto out;
+	} else {
 		struct restart_block *restart;
 		restart = &current_thread_info()->restart_block;
 		restart->fn = futex_wait_restart;
@@ -1323,7 +1358,8 @@ static int futex_wait(u32 __user *uaddr,
 
 		if (fshared)
 			restart->futex.flags |= FLAGS_SHARED;
-		return -ERESTART_RESTARTBLOCK;
+		ret = -ERESTART_RESTARTBLOCK;
+		goto out;
 	}
 
  out_unlock_release_sem:
@@ -1331,6 +1367,10 @@ static int futex_wait(u32 __user *uaddr,
 
  out_release_sem:
 	futex_unlock_mm(fshared);
+
+ out:
+	if (unlikely(ret != 0))
+		trace_mark(futex_wait_failed, "uaddr:%p ret:%d", uaddr, ret);
 	return ret;
 }
 
@@ -1366,8 +1406,14 @@ static int futex_lock_pi(u32 __user *uad
 	struct futex_q q;
 	int ret, lock_taken, ownerdied = 0, attempt = 0;
 
-	if (refill_pi_state_cache())
-		return -ENOMEM;
+	trace_mark(futex_lock_pi_called, "uaddr:%p fshared:%p detect:%d "
+			"time:%p trylock:%d",
+			uaddr, fshared, detect, time, trylock);
+
+	if (refill_pi_state_cache()) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	if (time) {
 		to = &timeout;
@@ -1588,7 +1634,9 @@ static int futex_lock_pi(u32 __user *uad
 
 	if (to)
 		destroy_hrtimer_on_stack(&to->timer);
-	return ret != -EINTR ? ret : -ERESTARTNOINTR;
+	if (ret == -EINTR)
+		ret = -ERESTARTNOINTR;
+	goto out;
 
  out_unlock_release_sem:
 	queue_unlock(&q, hb);
@@ -1597,7 +1645,7 @@ static int futex_lock_pi(u32 __user *uad
 	futex_unlock_mm(fshared);
 	if (to)
 		destroy_hrtimer_on_stack(&to->timer);
-	return ret;
+	goto out;
 
  uaddr_faulted:
 	/*
@@ -1624,6 +1672,9 @@ static int futex_lock_pi(u32 __user *uad
 	if (!ret && (uval != -EFAULT))
 		goto retry;
 
+ out:
+	if (unlikely(ret != 0))
+		trace_mark(futex_lock_pi_failed, "uaddr:%p ret:%d", uaddr, ret);
 	if (to)
 		destroy_hrtimer_on_stack(&to->timer);
 	return ret;
@@ -1643,14 +1694,20 @@ static int futex_unlock_pi(u32 __user *u
 	union futex_key key;
 	int ret, attempt = 0;
 
+	trace_mark(futex_unlock_pi_called, "uaddr:%p fshared:%p",
+							uaddr, fshared);
 retry:
-	if (get_user(uval, uaddr))
-		return -EFAULT;
+	if (get_user(uval, uaddr)) {
+		ret = -EFAULT;
+		goto out_return;
+	}
 	/*
 	 * We release only a lock we actually own:
 	 */
-	if ((uval & FUTEX_TID_MASK) != task_pid_vnr(current))
-		return -EPERM;
+	if ((uval & FUTEX_TID_MASK) != task_pid_vnr(current)) {
+		ret = -EPERM;
+		goto out_return;
+	}
 	/*
 	 * First take all the futex related locks:
 	 */
@@ -1715,7 +1772,7 @@ out_unlock:
 out:
 	futex_unlock_mm(fshared);
 
-	return ret;
+	goto out_return;
 
 pi_faulted:
 	/*
@@ -1743,6 +1800,10 @@ pi_faulted:
 	if (!ret && (uval != -EFAULT))
 		goto retry;
 
+out_return:
+	if (unlikely(ret != 0))
+		trace_mark(futex_unlock_pi_failed, "uaddr:%p ret:%d",
+							uaddr, ret);
 	return ret;
 }
 
@@ -2120,6 +2181,11 @@ long do_futex(u32 __user *uaddr, int op,
 	default:
 		ret = -ENOSYS;
 	}
+	trace_mark(do_futex_probe, "uaddr: %lu op:%d val:%lu timeout:%p "
+			"uaddr2:%lu val2:%lu val3:%lu ret:%d",
+			(unsigned long)uaddr, op, (unsigned long)val,
+			timeout, (unsigned long)uaddr2, (unsigned long)val2,
+			(unsigned long)val3, ret);
 	return ret;
 }
 
