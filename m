Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbZKRD3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbZKRD3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 22:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbZKRD3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 22:29:15 -0500
Received: from smtp-out.google.com ([216.239.45.13]:46236 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbZKRD3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 22:29:14 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:user-agent:x-system-of-record;
	b=GX/4pPsqOz0ze30iVcuhX8q2IuvrszRmnp8c3Puw8MUkyE7Iroe46qOoCdhUd++lo
	8unWNVt3VykRZtJo0r0Gw==
Date: Tue, 17 Nov 2009 19:29:10 -0800
From: Michel Lespinasse <walken@google.com>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] futex: add FUTEX_SET_WAIT operation
Message-ID: <20091118032910.GA23808@google.com>
References: <20091117074655.GA14023@google.com> <4B02DBCA.4050307@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B02DBCA.4050307@us.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 09:22:18AM -0800, Darren Hart wrote:
>> By doing the futex value update atomically with the kernel's inspection
>> of it to decide to wait, we avoid the time window where the futex has
>> been set to the 'please wake me up' state, but the thread has not been
>> queued onto the hash bucket yet. This has two effects:
>> - Avoids a futex syscall with the FUTEX_WAKE operation if there is no
>>   thread to be woken yet
>
> This also reduces lock contention on the hash-bucket locks, another plus.

Yes :)

>> - In the heavily contended case, avoids waking an extra thread that's
>>   only likely to make the contention problem worse.
>
> I'm not seeing this. What is the extra thread that would be woken which  
> isn't with FUTEX_SET_WAIT?

I meant that when several threads get queued on the futex, one can
choose to wake only one of them when releasing the futex - the remaining
ones stay queued and will ideally be woken only by a thread that already
blocked, or when a new thread blocks.

> It's a nitpic, but val2 is used in the futex syscall arguments already  
> and another variable of the same name that is actually initially derived  
> from uaddr2... is more likely to confuse than not.  Perhaps "setval"?  
> Throughout the patch.

OK, I renamed val2 into setval in futex_wait and futex_wait_setup.
I did not do this in do_futex - I followed the example of bitset vs val3
(val2 is just a made up name for one of the sys_futex pointer arguments
casted to integer, I did not want to add a second such variable).

> Have you compared the performance of FUTEX_WAIT before and after the  
> application of this patch? I'd be interested to see your test results on  
> a prepatched kernel (with the FUTEX_SET_WAIT side commented out of 
> course).

Performance seems to be similar as far as I can tell. It's hard to gauge it
for the 2-24 threads case, as there is quite a bit of run-to-run noise there
depending on where your threads land up. In the >=32 threads case, it looks
like the patched kernel is actually slightly faster. It's not clear to me if
this is pure luck or if it's due to getting the fault patch out of the way
with the unlikely() if statement.

FUTEX_WAIT test   (with unpatched 2.6.32-rc7):
1 threads: 45045 Kiter/s (2.21s user 0.00s system 2.22s wall 1.00 cores)
2 threads: 17483 Kiter/s (3.98s user 3.80s system 5.72s wall 1.36 cores)
3 threads: 5984 Kiter/s (16.78s user 24.06s system 16.71s wall 2.44 cores)
4 threads: 2910 Kiter/s (21.61s user 86.48s system 34.36s wall 3.15 cores)
5 threads: 4619 Kiter/s (17.53s user 78.59s system 21.65s wall 4.44 cores)
6 threads: 6549 Kiter/s (14.01s user 68.49s system 15.27s wall 5.40 cores)
8 threads: 7663 Kiter/s (12.21s user 72.55s system 13.05s wall 6.50 cores)
10 threads: 7831 Kiter/s (11.54s user 91.41s system 12.77s wall 8.06 cores)
12 threads: 10941 Kiter/s (8.81s user 79.86s system 9.14s wall 9.70 cores)
16 threads: 13661 Kiter/s (7.51s user 92.31s system 7.32s wall 13.64 cores)
24 threads: 17483 Kiter/s (6.13s user 118.48s system 5.72s wall 21.78 cores)
32 threads: 18215 Kiter/s (5.91s user 148.16s system 5.49s wall 28.06 cores)
64 threads: 18349 Kiter/s (5.72s user 160.06s system 5.45s wall 30.42 cores)
128 threads: 18382 Kiter/s (5.68s user 166.96s system 5.44s wall 31.74 cores)
256 threads: 17007 Kiter/s (5.30s user 181.25s system 5.88s wall 31.73 cores)
512 threads: 16026 Kiter/s (4.79s user 193.34s system 6.24s wall 31.75 cores)
1024 threads: 15432 Kiter/s (4.38s user 202.08s system 6.48s wall 31.86 cores)

>> -	ret = get_futex_value_locked(&uval, uaddr);
>> -
>> -	if (ret) {
>> +	pagefault_disable();
>> +	if (unlikely(__copy_from_user_inatomic(&uval, uaddr, sizeof(u32)))) {
>> +		pagefault_enable();
>
> What about the addition of val2 makes it so we have to expand  
> get_futex_value_locked() here with the nested fault handling?

This is because I did not want to re-enable page faults right afterwards
if we end up going to the futex_atomic_cmpxchg_inatomic path...

I applied your other feedback into the updated change down below.


Signed-off-by: Michel Lespinasse <walken@google.com>

diff --git a/include/linux/futex.h b/include/linux/futex.h
index 1e5a26d..c5e887d 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -20,6 +20,7 @@
 #define FUTEX_WAKE_BITSET	10
 #define FUTEX_WAIT_REQUEUE_PI	11
 #define FUTEX_CMP_REQUEUE_PI	12
+#define FUTEX_SET_WAIT		13
 
 #define FUTEX_PRIVATE_FLAG	128
 #define FUTEX_CLOCK_REALTIME	256
@@ -39,6 +40,7 @@
 					 FUTEX_PRIVATE_FLAG)
 #define FUTEX_CMP_REQUEUE_PI_PRIVATE	(FUTEX_CMP_REQUEUE_PI | \
 					 FUTEX_PRIVATE_FLAG)
+#define FUTEX_SET_WAIT_PRIVATE		(FUTEX_SET_WAIT | FUTEX_PRIVATE_FLAG)
 
 /*
  * Support for robust futexes: the kernel cleans up held futexes at
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index a8cc4e1..b08c3ec 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -25,6 +25,7 @@ struct restart_block {
 		struct {
 			u32 *uaddr;
 			u32 val;
+			u32 setval;
 			u32 flags;
 			u32 bitset;
 			u64 time;
diff --git a/kernel/futex.c b/kernel/futex.c
index fb65e82..7ed0869 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1694,6 +1694,7 @@ static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
  * futex_wait_setup() - Prepare to wait on a futex
  * @uaddr:	the futex userspace address
  * @val:	the expected value
+ * @setval:	the value we want to set, in replacement of val
  * @fshared:	whether the futex is shared (1) or not (0)
  * @q:		the associated futex_q
  * @hb:		storage for hash_bucket pointer to be returned to caller
@@ -1704,11 +1705,12 @@ static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
  * with no q.key reference on failure.
  *
  * Returns:
- *  0 - uaddr contains val and hb has been locked
+ *  0 - uaddr contains setval and hb has been locked
  * <1 - -EFAULT or -EWOULDBLOCK (uaddr does not contain val) and hb is unlcoked
  */
-static int futex_wait_setup(u32 __user *uaddr, u32 val, int fshared,
-			   struct futex_q *q, struct futex_hash_bucket **hb)
+static int futex_wait_setup(u32 __user *uaddr, u32 val, u32 setval,
+			    int fshared, struct futex_q *q,
+			    struct futex_hash_bucket **hb)
 {
 	u32 uval;
 	int ret;
@@ -1722,29 +1724,33 @@ static int futex_wait_setup(u32 __user *uaddr, u32 val, int fshared,
 	 *
 	 * The basic logical guarantee of a futex is that it blocks ONLY
 	 * if cond(var) is known to be true at the time of blocking, for
-	 * any cond.  If we queued after testing *uaddr, that would open
-	 * a race condition where we could block indefinitely with
+	 * any cond.  If we locked the hash-bucket after testing *uaddr, that
+	 * would open a race condition where we could block indefinitely with
 	 * cond(var) false, which would violate the guarantee.
 	 *
-	 * A consequence is that futex_wait() can return zero and absorb
-	 * a wakeup when *uaddr != val on entry to the syscall.  This is
-	 * rare, but normal.
+	 * On the other hand, we insert q and release the hash-bucket only
+	 * after testing *uaddr. This guarantees that futex_wait() will NOT
+	 * absorb a wakeup if *uaddr does not match the desired values
+	 * while the syscall executes.
 	 */
 retry:
 	q->key = FUTEX_KEY_INIT;
-	ret = get_futex_key(uaddr, fshared, &q->key, VERIFY_READ);
+	ret = get_futex_key(uaddr, fshared, &q->key,
+			    (val == setval) ? VERIFY_READ : VERIFY_WRITE);
 	if (unlikely(ret != 0))
 		return ret;
 
 retry_private:
 	*hb = queue_lock(q);
 
-	ret = get_futex_value_locked(&uval, uaddr);
+	pagefault_disable();
+	if (unlikely(__copy_from_user_inatomic(&uval, uaddr, sizeof(u32)))) {
+		pagefault_enable();
 
-	if (ret) {
 		queue_unlock(q, *hb);
 
 		ret = get_user(uval, uaddr);
+fault_common:
 		if (ret)
 			goto out;
 
@@ -1755,7 +1761,21 @@ retry_private:
 		goto retry;
 	}
 
-	if (uval != val) {
+	if (val != setval && uval == val) {
+		uval = futex_atomic_cmpxchg_inatomic(uaddr, val, setval);
+		if (unlikely(uval == -EFAULT)) {
+			pagefault_enable();
+
+			queue_unlock(q, *hb);
+
+			ret = fault_in_user_writeable(uaddr);
+			goto fault_common;
+		}
+	}
+
+	pagefault_enable();
+
+	if (uval != val && uval != setval) {
 		queue_unlock(q, *hb);
 		ret = -EWOULDBLOCK;
 	}
@@ -1766,8 +1786,8 @@ out:
 	return ret;
 }
 
-static int futex_wait(u32 __user *uaddr, int fshared,
-		      u32 val, ktime_t *abs_time, u32 bitset, int clockrt)
+static int futex_wait(u32 __user *uaddr, int fshared, u32 val, u32 setval,
+		      ktime_t *abs_time, u32 bitset, int clockrt)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct restart_block *restart;
@@ -1795,7 +1815,7 @@ static int futex_wait(u32 __user *uaddr, int fshared,
 
 retry:
 	/* Prepare to wait on uaddr. */
-	ret = futex_wait_setup(uaddr, val, fshared, &q, &hb);
+	ret = futex_wait_setup(uaddr, val, setval, fshared, &q, &hb);
 	if (ret)
 		goto out;
 
@@ -1827,6 +1847,7 @@ retry:
 	restart->fn = futex_wait_restart;
 	restart->futex.uaddr = (u32 *)uaddr;
 	restart->futex.val = val;
+	restart->futex.setval = setval;
 	restart->futex.time = abs_time->tv64;
 	restart->futex.bitset = bitset;
 	restart->futex.flags = FLAGS_HAS_TIMEOUT;
@@ -1862,7 +1883,8 @@ static long futex_wait_restart(struct restart_block *restart)
 	restart->fn = do_no_restart_syscall;
 	if (restart->futex.flags & FLAGS_SHARED)
 		fshared = 1;
-	return (long)futex_wait(uaddr, fshared, restart->futex.val, tp,
+	return (long)futex_wait(uaddr, fshared, restart->futex.val,
+				restart->futex.setval, tp,
 				restart->futex.bitset,
 				restart->futex.flags & FLAGS_CLOCKRT);
 }
@@ -2219,7 +2241,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	q.requeue_pi_key = &key2;
 
 	/* Prepare to wait on uaddr. */
-	ret = futex_wait_setup(uaddr, val, fshared, &q, &hb);
+	ret = futex_wait_setup(uaddr, val, val, fshared, &q, &hb);
 	if (ret)
 		goto out_key2;
 
@@ -2532,14 +2554,18 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		fshared = 1;
 
 	clockrt = op & FUTEX_CLOCK_REALTIME;
-	if (clockrt && cmd != FUTEX_WAIT_BITSET && cmd != FUTEX_WAIT_REQUEUE_PI)
+	if (clockrt && cmd != FUTEX_WAIT_BITSET &&
+	    cmd != FUTEX_WAIT_REQUEUE_PI && cmd != FUTEX_SET_WAIT)
 		return -ENOSYS;
 
 	switch (cmd) {
 	case FUTEX_WAIT:
 		val3 = FUTEX_BITSET_MATCH_ANY;
 	case FUTEX_WAIT_BITSET:
-		ret = futex_wait(uaddr, fshared, val, timeout, val3, clockrt);
+		val2 = val;
+	case FUTEX_SET_WAIT:
+		ret = futex_wait(uaddr, fshared, val, val2, timeout, val3,
+				 clockrt);
 		break;
 	case FUTEX_WAKE:
 		val3 = FUTEX_BITSET_MATCH_ANY;
@@ -2595,7 +2621,7 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 
 	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI ||
 		      cmd == FUTEX_WAIT_BITSET ||
-		      cmd == FUTEX_WAIT_REQUEUE_PI)) {
+		      cmd == FUTEX_WAIT_REQUEUE_PI || cmd == FUTEX_SET_WAIT)) {
 		if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
 			return -EFAULT;
 		if (!timespec_valid(&ts))
@@ -2609,10 +2635,16 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 	/*
 	 * requeue parameter in 'utime' if cmd == FUTEX_*_REQUEUE_*.
 	 * number of waiters to wake in 'utime' if cmd == FUTEX_WAKE_OP.
+	 * new uval value in 'uaddr2' if cmd == FUTEX_SET_WAIT.
 	 */
 	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE ||
 	    cmd == FUTEX_CMP_REQUEUE_PI || cmd == FUTEX_WAKE_OP)
 		val2 = (u32) (unsigned long) utime;
+	else if (cmd == FUTEX_SET_WAIT) {
+		if (!futex_cmpxchg_enabled)
+			return -ENOSYS;
+		val2 = (u32) (unsigned long) uaddr2;
+	}
 
 	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
 }


-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
