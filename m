Return-Path: <linux-kernel-owner+w=401wt.eu-S1753116AbZKQIue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbZKQIue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 03:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZKQIud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 03:50:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:52979 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbZKQIuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 03:50:32 -0500
Subject: Re: [PATCH] futex: add FUTEX_SET_WAIT operation
From: Peter Zijlstra <peterz@infradead.org>
To: Michel Lespinasse <walken@google.com>
Cc: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20091117074655.GA14023@google.com>
References: <20091117074655.GA14023@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Nov 2009 09:50:07 +0100
Message-ID: <1258447807.7816.20.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(long quote for Linus' benefit, added an old patch to the tail)

On Mon, 2009-11-16 at 23:46 -0800, Michel Lespinasse wrote:
> 
> I would like to propose adding a new FUTEX_SET_WAIT operation to the futex
> code, as per the following patch against 2.6.32-rc7
> 
> The change adds a new FUTEX_SET_WAIT operation, which is similar to
> FUTEX_WAIT_BITSET except for the addition of an additional 'val2'
> parameter, which is an integer and is passed in place of the 'uaddr2'
> parameter to the futex syscall.
> 
> When val2==val, the behavior is identical to FUTEX_WAIT_BITSET: The
> kernel verifies that *uval == val, and waits if that condition is
> satisfied. The typical use case is that userspace inspects the futex
> value, finds out that it needs to block based on that value, changes the
> value to something that indicates it wants to be woken up, and then goes
> to execute the futex syscall with a FUTEX_WAIT or FUTEX_WAIT_BITSET
> operation.
> 
> With the new FUTEX_SET_WAIT operation, the change of the futex value to
> indicate a wakeup is desired is done atomically with the kernel's
> inspection of the futex value to figure out if it is still necessary to
> wait. That is, the kernel inspects the futex value and if 'val' is
> found, atomically changes it to 'val2'. Then if the new futex value is
> 'val2' (either because that was the original value when the kernel first
> inspected it, or because the atomic update from val to val2 succeeded),
> the thread goes to wait on the futex.

Right, so this is something I was needing to make adaptive spinning work
with futexes (aside from braving the glibc futex horror).

I've attached an old patch (which was never actually tested), that shows
how to do the adaptive wait. It also does the cmpxchg thing you do, and
it imposes a structure on the futex value.

Maybe we can merge these things.. One more point below.

> By doing the futex value update atomically with the kernel's inspection
> of it to decide to wait, we avoid the time window where the futex has
> been set to the 'please wake me up' state, but the thread has not been
> queued onto the hash bucket yet. This has two effects:
> - Avoids a futex syscall with the FUTEX_WAKE operation if there is no
>   thread to be woken yet
> - In the heavily contended case, avoids waking an extra thread that's
>   only likely to make the contention problem worse.

  - avoids lock stealing, which might make real world loads suck a
    little?

> Sample test results, on a sun x4600 M2, using the test program included
> after the diff (dumb lock/unlock stress test, comparing FUTEX_SET_WAIT
> with FUTEX_WAIT):

[ snipped results showing FUTEX_SET_WAIT is faster for this workload ]

> Signed-off-by: Michel Lespinasse <walken@google.com>
> 
> diff --git a/include/linux/futex.h b/include/linux/futex.h
> index 1e5a26d..c5e887d 100644
> --- a/include/linux/futex.h
> +++ b/include/linux/futex.h
> @@ -20,6 +20,7 @@
>  #define FUTEX_WAKE_BITSET      10
>  #define FUTEX_WAIT_REQUEUE_PI  11
>  #define FUTEX_CMP_REQUEUE_PI   12
> +#define FUTEX_SET_WAIT         13
>  
>  #define FUTEX_PRIVATE_FLAG     128
>  #define FUTEX_CLOCK_REALTIME   256
> @@ -39,6 +40,7 @@
>                                          FUTEX_PRIVATE_FLAG)
>  #define FUTEX_CMP_REQUEUE_PI_PRIVATE   (FUTEX_CMP_REQUEUE_PI | \
>                                          FUTEX_PRIVATE_FLAG)
> +#define FUTEX_SET_WAIT_PRIVATE         (FUTEX_SET_WAIT | FUTEX_PRIVATE_FLAG)
>  
>  /*
>   * Support for robust futexes: the kernel cleans up held futexes at
> diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
> index a8cc4e1..a199606 100644
> --- a/include/linux/thread_info.h
> +++ b/include/linux/thread_info.h
> @@ -25,6 +25,7 @@ struct restart_block {
>                 struct {
>                         u32 *uaddr;
>                         u32 val;
> +                       u32 val2;
>                         u32 flags;
>                         u32 bitset;
>                         u64 time;
> diff --git a/kernel/futex.c b/kernel/futex.c
> index fb65e82..be9de2b 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -1694,6 +1694,7 @@ static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
>   * futex_wait_setup() - Prepare to wait on a futex
>   * @uaddr:     the futex userspace address
>   * @val:       the expected value
> + * @val2:      the value we want to set, in replacement of val
>   * @fshared:   whether the futex is shared (1) or not (0)
>   * @q:         the associated futex_q
>   * @hb:                storage for hash_bucket pointer to be returned to caller
> @@ -1704,10 +1705,10 @@ static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
>   * with no q.key reference on failure.
>   *
>   * Returns:
> - *  0 - uaddr contains val and hb has been locked
> + *  0 - uaddr contains val2 and hb has been locked
>   * <1 - -EFAULT or -EWOULDBLOCK (uaddr does not contain val) and hb is unlcoked
>   */
> -static int futex_wait_setup(u32 __user *uaddr, u32 val, int fshared,
> +static int futex_wait_setup(u32 __user *uaddr, u32 val, u32 val2, int fshared,
>                            struct futex_q *q, struct futex_hash_bucket **hb)
>  {
>         u32 uval;
> @@ -1722,52 +1723,61 @@ static int futex_wait_setup(u32 __user *uaddr, u32 val, int fshared,
>          *
>          * The basic logical guarantee of a futex is that it blocks ONLY
>          * if cond(var) is known to be true at the time of blocking, for
> -        * any cond.  If we queued after testing *uaddr, that would open
> -        * a race condition where we could block indefinitely with
> +        * any cond.  If we locked the hash-bucket after testing *uaddr, that
> +        * would open a race condition where we could block indefinitely with
>          * cond(var) false, which would violate the guarantee.
>          *
> -        * A consequence is that futex_wait() can return zero and absorb
> -        * a wakeup when *uaddr != val on entry to the syscall.  This is
> -        * rare, but normal.
> +        * On the other hand, we insert q and release the hash-bucket only
> +        * after testing *uaddr. This guarantees that futex_wait() will NOT
> +        * absorb a wakeup if *uaddr does not match the desired values
> +        * while the syscall executes.
>          */
>  retry:
>         q->key = FUTEX_KEY_INIT;
> -       ret = get_futex_key(uaddr, fshared, &q->key, VERIFY_READ);
> +       ret = get_futex_key(uaddr, fshared, &q->key,
> +                           (val == val2) ? VERIFY_READ : VERIFY_WRITE);
>         if (unlikely(ret != 0))
>                 return ret;
>  
>  retry_private:
>         *hb = queue_lock(q);
>  
> -       ret = get_futex_value_locked(&uval, uaddr);
> -
> -       if (ret) {
> +       pagefault_disable();
> +       if (unlikely(__copy_from_user_inatomic(&uval, uaddr, sizeof(u32)))) {
> +               pagefault_enable();
>                 queue_unlock(q, *hb);
> -
>                 ret = get_user(uval, uaddr);
> +       fault_common:
>                 if (ret)
>                         goto out;
> -
>                 if (!fshared)
>                         goto retry_private;
> -
>                 put_futex_key(fshared, &q->key);
>                 goto retry;
>         }
> -
> -       if (uval != val) {
> -               queue_unlock(q, *hb);
> -               ret = -EWOULDBLOCK;
> +       if (val != val2 && uval == val) {
> +               uval = futex_atomic_cmpxchg_inatomic(uaddr, val, val2);
> +               if (unlikely(uval == -EFAULT)) {
> +                       pagefault_enable();
> +                       queue_unlock(q, *hb);
> +                       ret = fault_in_user_writeable(uaddr);
> +                       goto fault_common;
> +               }
>         }
> +       pagefault_enable();
> +
> +       if (uval == val || uval == val2)
> +               return 0;  /* success */
>  
> +       queue_unlock(q, *hb);
> +       ret = -EWOULDBLOCK;
>  out:
> -       if (ret)
> -               put_futex_key(fshared, &q->key);
> +       put_futex_key(fshared, &q->key);
>         return ret;
>  }
>  
> -static int futex_wait(u32 __user *uaddr, int fshared,
> -                     u32 val, ktime_t *abs_time, u32 bitset, int clockrt)
> +static int futex_wait(u32 __user *uaddr, int fshared, u32 val, u32 val2,
> +                     ktime_t *abs_time, u32 bitset, int clockrt)
>  {
>         struct hrtimer_sleeper timeout, *to = NULL;
>         struct restart_block *restart;
> @@ -1795,7 +1805,7 @@ static int futex_wait(u32 __user *uaddr, int fshared,
>  
>  retry:
>         /* Prepare to wait on uaddr. */
> -       ret = futex_wait_setup(uaddr, val, fshared, &q, &hb);
> +       ret = futex_wait_setup(uaddr, val, val2, fshared, &q, &hb);
>         if (ret)
>                 goto out;
>  
> @@ -1827,6 +1837,7 @@ retry:
>         restart->fn = futex_wait_restart;
>         restart->futex.uaddr = (u32 *)uaddr;
>         restart->futex.val = val;
> +       restart->futex.val2 = val2;
>         restart->futex.time = abs_time->tv64;
>         restart->futex.bitset = bitset;
>         restart->futex.flags = FLAGS_HAS_TIMEOUT;
> @@ -1862,8 +1873,8 @@ static long futex_wait_restart(struct restart_block *restart)
>         restart->fn = do_no_restart_syscall;
>         if (restart->futex.flags & FLAGS_SHARED)
>                 fshared = 1;
> -       return (long)futex_wait(uaddr, fshared, restart->futex.val, tp,
> -                               restart->futex.bitset,
> +       return (long)futex_wait(uaddr, fshared, restart->futex.val,
> +                               restart->futex.val2, tp, restart->futex.bitset,
>                                 restart->futex.flags & FLAGS_CLOCKRT);
>  }
>  
> @@ -2219,7 +2230,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
>         q.requeue_pi_key = &key2;
>  
>         /* Prepare to wait on uaddr. */
> -       ret = futex_wait_setup(uaddr, val, fshared, &q, &hb);
> +       ret = futex_wait_setup(uaddr, val, val, fshared, &q, &hb);
>         if (ret)
>                 goto out_key2;
>  
> @@ -2532,14 +2543,18 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
>                 fshared = 1;
>  
>         clockrt = op & FUTEX_CLOCK_REALTIME;
> -       if (clockrt && cmd != FUTEX_WAIT_BITSET && cmd != FUTEX_WAIT_REQUEUE_PI)
> +       if (clockrt && cmd != FUTEX_WAIT_BITSET &&
> +           cmd != FUTEX_WAIT_REQUEUE_PI && cmd != FUTEX_SET_WAIT)
>                 return -ENOSYS;
>  
>         switch (cmd) {
>         case FUTEX_WAIT:
>                 val3 = FUTEX_BITSET_MATCH_ANY;
>         case FUTEX_WAIT_BITSET:
> -               ret = futex_wait(uaddr, fshared, val, timeout, val3, clockrt);
> +               val2 = val;
> +       case FUTEX_SET_WAIT:
> +               ret = futex_wait(uaddr, fshared, val, val2, timeout, val3,
> +                                clockrt);
>                 break;
>         case FUTEX_WAKE:
>                 val3 = FUTEX_BITSET_MATCH_ANY;
> @@ -2595,7 +2610,7 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
>  
>         if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI ||
>                       cmd == FUTEX_WAIT_BITSET ||
> -                     cmd == FUTEX_WAIT_REQUEUE_PI)) {
> +                     cmd == FUTEX_WAIT_REQUEUE_PI || cmd == FUTEX_SET_WAIT)) {
>                 if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
>                         return -EFAULT;
>                 if (!timespec_valid(&ts))
> @@ -2609,10 +2624,16 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
>         /*
>          * requeue parameter in 'utime' if cmd == FUTEX_*_REQUEUE_*.
>          * number of waiters to wake in 'utime' if cmd == FUTEX_WAKE_OP.
> +        * new uval value in 'uaddr2' if cmd == FUTEX_SET_WAIT.
>          */
>         if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE ||
>             cmd == FUTEX_CMP_REQUEUE_PI || cmd == FUTEX_WAKE_OP)
>                 val2 = (u32) (unsigned long) utime;
> +       else if (cmd == FUTEX_SET_WAIT) {
> +               if (!futex_cmpxchg_enabled)
> +                       return -ENOSYS;
> +               val2 = (u32) (unsigned long) uaddr2;
> +       }
>  
>         return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
>  }
> 


--- 
Subject: futex: implement adaptive spin
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Jan 20 14:40:36 CET 2009

Implement kernel side adaptive spining for futexes.

This is implemented as a new futex op: FUTEX_WAIT_ADAPTIVE, because it
requires the futex lock field to contain a TID and regular futexes do
not have that restriction.

FUTEX_WAIT_ADAPTIVE will spin while the lock owner is running (on a 
different cpu) or until the task gets preempted. After that it behaves
like FUTEX_WAIT.

The spin loop tries to acquire the lock by cmpxchg(lock, 0, tid) == tid
on the lower 30 bits (TID_MASK) of the lock field -- leaving the
WAITERS and OWNER_DIED flags in tact.

NOTE: we could fold mutex_spin_on_owner() and futex_spin_on_owner() by
adding a lock_owner function argument.

  void lock_spin_on_owner(struct thread_info *(*lock_owner)(void *lock),
                          void *lock, struct thread_info *owner);

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/futex.h |    2 +
 include/linux/sched.h |    1 
 kernel/futex.c        |   96 ++++++++++++++++++++++++++++++++++++++++++--------
 kernel/sched.c        |   59 ++++++++++++++++++++++++++++++
 4 files changed, 143 insertions(+), 15 deletions(-)

Index: linux-2.6/include/linux/futex.h
===================================================================
--- linux-2.6.orig/include/linux/futex.h
+++ linux-2.6/include/linux/futex.h
@@ -23,6 +23,7 @@ union ktime;
 #define FUTEX_TRYLOCK_PI	8
 #define FUTEX_WAIT_BITSET	9
 #define FUTEX_WAKE_BITSET	10
+#define FUTEX_WAIT_ADAPTIVE	11
 
 #define FUTEX_PRIVATE_FLAG	128
 #define FUTEX_CLOCK_REALTIME	256
@@ -171,6 +172,7 @@ union futex_key {
 extern void exit_robust_list(struct task_struct *curr);
 extern void exit_pi_state_list(struct task_struct *curr);
 extern int futex_cmpxchg_enabled;
+extern struct thread_info *futex_owner(u32 __user *uaddr);
 #else
 static inline void exit_robust_list(struct task_struct *curr)
 {
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -341,6 +341,7 @@ extern signed long schedule_timeout_unin
 asmlinkage void __schedule(void);
 asmlinkage void schedule(void);
 extern int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner);
+extern int futex_spin_on_owner(u32 __user *uaddr, struct thread_info *owner);
 
 struct nsproxy;
 struct user_namespace;
Index: linux-2.6/kernel/futex.c
===================================================================
--- linux-2.6.orig/kernel/futex.c
+++ linux-2.6/kernel/futex.c
@@ -1158,10 +1158,40 @@ handle_fault:
  */
 #define FLAGS_SHARED		0x01
 #define FLAGS_CLOCKRT		0x02
+#define FLAGS_ADAPTIVE		0x03
 
 static long futex_wait_restart(struct restart_block *restart);
 
-static int futex_wait(u32 __user *uaddr, int fshared,
+#ifdef CONFIG_SMP
+struct thread_info *futex_owner(u32 __user *uaddr)
+{
+	struct thread_info *ti = NULL;
+	struct task_struct *p;
+	pid_t pid;
+	u32 uval;
+
+	if (get_futex_value_locked(&uval, uaddr))
+		return NULL;
+
+	pid = uval & FUTEX_TID_MASK;
+	rcu_read_lock();
+	p = find_taks_by_vpid(pid);
+	if (p) {
+		const struct cred *cred, *pcred;
+
+		cread = current_cred();
+		pcred = __task_cred(p);
+		if (cred->euid == pcred->euid ||
+		    cred->euid == pcred->uid)
+			ti = task_thread_info(p);
+	}
+	rcu_read_unlock();
+
+	return ti;
+}
+#endif
+
+static int futex_wait(u32 __user *uaddr, int flags,
 		      u32 val, ktime_t *abs_time, u32 bitset, int clockrt)
 {
 	struct task_struct *curr = current;
@@ -1176,11 +1206,43 @@ static int futex_wait(u32 __user *uaddr,
 	if (!bitset)
 		return -EINVAL;
 
+#ifdef CONFIG_SMP
+	if (!futex_cmpxchg_enabled || !(flags & FLAGS_ADAPTIVE))
+		goto skip_adaptive;
+
+	preempt_disable();
+	for (;;) {
+		struct thread_info *owner;
+		u32 curval = 0, newval = task_pid_vnr(curr);
+
+		owner = futex_owner(uaddr);
+		if (owner && futex_spin_on_owner(uaddr, owner))
+			break;
+
+		if (get_futex_value_locked(&uval, uaddr))
+			break;
+
+		curval |= uval & ~FUTEX_TID_MASK;
+		newval |= uval & ~FUTEX_TID_MASK;
+
+		if (cmpxchg_futex_value_locked(uaddr, curval, newval)
+				== newval)
+			return 0;
+
+		if (!owner && (need_resched() || rt_task(curr)))
+			break;
+
+		cpu_relax();
+	}
+	preempt_enable();
+skip_adaptive:
+#endif
+
 	q.pi_state = NULL;
 	q.bitset = bitset;
 retry:
 	q.key = FUTEX_KEY_INIT;
-	ret = get_futex_key(uaddr, fshared, &q.key);
+	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q.key);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -1210,7 +1272,7 @@ retry:
 
 	if (unlikely(ret)) {
 		queue_unlock(&q, hb);
-		put_futex_key(fshared, &q.key);
+		put_futex_key(flags & FLAGS_SHARED, &q.key);
 
 		ret = get_user(uval, uaddr);
 
@@ -1305,7 +1367,7 @@ retry:
 		restart->futex.bitset = bitset;
 		restart->futex.flags = 0;
 
-		if (fshared)
+		if (flags & FLAGS_SHARED)
 			restart->futex.flags |= FLAGS_SHARED;
 		if (clockrt)
 			restart->futex.flags |= FLAGS_CLOCKRT;
@@ -1314,7 +1376,7 @@ retry:
 
 out_unlock_put_key:
 	queue_unlock(&q, hb);
-	put_futex_key(fshared, &q.key);
+	put_futex_key(flags & FLAGS_SHARED, &q.key);
 
 out:
 	return ret;
@@ -1929,46 +1991,50 @@ long do_futex(u32 __user *uaddr, int op,
 {
 	int clockrt, ret = -ENOSYS;
 	int cmd = op & FUTEX_CMD_MASK;
-	int fshared = 0;
+	int flags = 0;
 
 	if (!(op & FUTEX_PRIVATE_FLAG))
-		fshared = 1;
+		flags |= FLAGS_SHARED;
 
 	clockrt = op & FUTEX_CLOCK_REALTIME;
 	if (clockrt && cmd != FUTEX_WAIT_BITSET)
 		return -ENOSYS;
 
 	switch (cmd) {
+	case FUTEX_WAIT_ADAPTIVE:
+		flags |= FLAGS_ADAPTIVE;
 	case FUTEX_WAIT:
 		val3 = FUTEX_BITSET_MATCH_ANY;
 	case FUTEX_WAIT_BITSET:
-		ret = futex_wait(uaddr, fshared, val, timeout, val3, clockrt);
+		ret = futex_wait(uaddr, flags, val, timeout, val3, clockrt);
 		break;
+
 	case FUTEX_WAKE:
 		val3 = FUTEX_BITSET_MATCH_ANY;
 	case FUTEX_WAKE_BITSET:
-		ret = futex_wake(uaddr, fshared, val, val3);
+		ret = futex_wake(uaddr, flags, val, val3);
 		break;
+
 	case FUTEX_REQUEUE:
-		ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, NULL);
+		ret = futex_requeue(uaddr, flags, uaddr2, val, val2, NULL);
 		break;
 	case FUTEX_CMP_REQUEUE:
-		ret = futex_requeue(uaddr, fshared, uaddr2, val, val2, &val3);
+		ret = futex_requeue(uaddr, flags, uaddr2, val, val2, &val3);
 		break;
 	case FUTEX_WAKE_OP:
-		ret = futex_wake_op(uaddr, fshared, uaddr2, val, val2, val3);
+		ret = futex_wake_op(uaddr, flags, uaddr2, val, val2, val3);
 		break;
 	case FUTEX_LOCK_PI:
 		if (futex_cmpxchg_enabled)
-			ret = futex_lock_pi(uaddr, fshared, val, timeout, 0);
+			ret = futex_lock_pi(uaddr, flags, val, timeout, 0);
 		break;
 	case FUTEX_UNLOCK_PI:
 		if (futex_cmpxchg_enabled)
-			ret = futex_unlock_pi(uaddr, fshared);
+			ret = futex_unlock_pi(uaddr, flags);
 		break;
 	case FUTEX_TRYLOCK_PI:
 		if (futex_cmpxchg_enabled)
-			ret = futex_lock_pi(uaddr, fshared, 0, timeout, 1);
+			ret = futex_lock_pi(uaddr, flags, 0, timeout, 1);
 		break;
 	default:
 		ret = -ENOSYS;
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4834,6 +4834,65 @@ int mutex_spin_on_owner(struct mutex *lo
 out:
 	return 1;
 }
+
+#ifdef CONFIG_FUTEX
+#include <linux/futex.h>
+
+int futex_spin_on_owner(u32 __user *uaddr, struct thread_info *owner)
+{
+	unsigned int cpu;
+	struct rq *rq;
+
+	if (!sched_feat(OWNER_SPIN))
+		return 0;
+
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	/*
+	 * Need to access the cpu field knowing that
+	 * DEBUG_PAGEALLOC could have unmapped it if
+	 * the mutex owner just released it and exited.
+	 */
+	if (probe_kernel_address(&owner->cpu, cpu))
+		goto out;
+#else
+	cpu = owner->cpu;
+#endif
+
+	/*
+	 * Even if the access succeeded (likely case),
+	 * the cpu field may no longer be valid.
+	 */
+	if (cpu >= nr_cpumask_bits)
+		goto out;
+
+	/*
+	 * We need to validate that we can do a
+	 * get_cpu() and that we have the percpu area.
+	 */
+	if (!cpu_online(cpu))
+		goto out;
+
+	rq = cpu_rq(cpu);
+
+	for (;;) {
+		/*
+		 * Owner changed, break to re-assess state.
+		 */
+		if (futex_owner(uaddr) != owner)
+			break;
+
+		/*
+		 * Is that owner really running on that cpu?
+		 */
+		if (task_thread_info(rq->curr) != owner || need_resched())
+			return 0;
+
+		cpu_relax();
+	}
+out:
+	return 1;
+}
+#endif
 #endif
 
 #ifdef CONFIG_PREEMPT



