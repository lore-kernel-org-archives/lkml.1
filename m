Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbZKQHrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbZKQHrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 02:47:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755891AbZKQHrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 02:47:07 -0500
Received: from smtp-out.google.com ([216.239.45.13]:6520 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbZKQHrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 02:47:01 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:user-agent:x-system-of-record;
	b=gXudUO0zQeYDb+mrImrttjoxeOtK3YTrsFJs7pG/UpgKBPNxyZukNlo2EQXIhy28e
	v2RsotMGlNrpgZ1ltzBBQ==
Date: Mon, 16 Nov 2009 23:46:55 -0800
From: Michel Lespinasse <walken@google.com>
To: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] futex: add FUTEX_SET_WAIT operation
Message-ID: <20091117074655.GA14023@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to propose adding a new FUTEX_SET_WAIT operation to the futex
code, as per the following patch against 2.6.32-rc7

The change adds a new FUTEX_SET_WAIT operation, which is similar to
FUTEX_WAIT_BITSET except for the addition of an additional 'val2'
parameter, which is an integer and is passed in place of the 'uaddr2'
parameter to the futex syscall.

When val2==val, the behavior is identical to FUTEX_WAIT_BITSET: The
kernel verifies that *uval == val, and waits if that condition is
satisfied. The typical use case is that userspace inspects the futex
value, finds out that it needs to block based on that value, changes the
value to something that indicates it wants to be woken up, and then goes
to execute the futex syscall with a FUTEX_WAIT or FUTEX_WAIT_BITSET
operation.

With the new FUTEX_SET_WAIT operation, the change of the futex value to
indicate a wakeup is desired is done atomically with the kernel's
inspection of the futex value to figure out if it is still necessary to
wait. That is, the kernel inspects the futex value and if 'val' is
found, atomically changes it to 'val2'. Then if the new futex value is
'val2' (either because that was the original value when the kernel first
inspected it, or because the atomic update from val to val2 succeeded),
the thread goes to wait on the futex.

By doing the futex value update atomically with the kernel's inspection
of it to decide to wait, we avoid the time window where the futex has
been set to the 'please wake me up' state, but the thread has not been
queued onto the hash bucket yet. This has two effects:
- Avoids a futex syscall with the FUTEX_WAKE operation if there is no
  thread to be woken yet
- In the heavily contended case, avoids waking an extra thread that's
  only likely to make the contention problem worse.

Sample test results, on a sun x4600 M2, using the test program included
after the diff (dumb lock/unlock stress test, comparing FUTEX_SET_WAIT
with FUTEX_WAIT):

FUTEX_SET_WAIT test
1 threads: 45662 Kiter/s (2.19s user 0.00s system 2.19s wall 1.00 cores)
2 threads: 11834 Kiter/s (11.07s user 4.70s system 8.45s wall 1.87 cores)
3 threads: 9425 Kiter/s (11.10s user 14.73s system 10.61s wall 2.43 cores)
4 threads: 20790 Kiter/s (5.73s user 10.53s system 4.81s wall 3.38 cores)
5 threads: 21505 Kiter/s (5.05s user 14.02s system 4.65s wall 4.10 cores)
6 threads: 18904 Kiter/s (5.64s user 19.07s system 5.29s wall 4.67 cores)
8 threads: 17212 Kiter/s (6.10s user 28.39s system 5.81s wall 5.94 cores)
10 threads: 19493 Kiter/s (5.20s user 35.82s system 5.13s wall 8.00 cores)
12 threads: 20325 Kiter/s (4.92s user 42.52s system 4.92s wall 9.64 cores)
16 threads: 22026 Kiter/s (4.64s user 56.58s system 4.54s wall 13.48 cores)
24 threads: 23041 Kiter/s (4.33s user 84.76s system 4.34s wall 20.53 cores)
32 threads: 23585 Kiter/s (4.11s user 112.75s system 4.24s wall 27.56 cores)
64 threads: 25907 Kiter/s (3.93s user 115.99s system 3.86s wall 31.07 cores)
128 threads: 26455 Kiter/s (4.02s user 114.50s system 3.78s wall 31.35 cores)
256 threads: 26596 Kiter/s (3.93s user 114.55s system 3.76s wall 31.51 cores)
512 threads: 26596 Kiter/s (3.92s user 114.74s system 3.76s wall 31.56 cores)
1024 threads: 26525 Kiter/s (3.95s user 115.96s system 3.77s wall 31.81 cores)

FUTEX_WAIT test
1 threads: 46083 Kiter/s (2.17s user 0.00s system 2.17s wall 1.00 cores)
2 threads: 10811 Kiter/s (12.39s user 4.71s system 9.25s wall 1.85 cores)
3 threads: 5353 Kiter/s (21.02s user 25.85s system 18.68s wall 2.51 cores)
4 threads: 4277 Kiter/s (27.12s user 54.89s system 23.38s wall 3.51 cores)
5 threads: 3861 Kiter/s (24.51s user 85.21s system 25.90s wall 4.24 cores)
6 threads: 3540 Kiter/s (20.37s user 125.47s system 28.25s wall 5.16 cores)
8 threads: 7257 Kiter/s (12.11s user 81.09s system 13.78s wall 6.76 cores)
10 threads: 8271 Kiter/s (10.87s user 90.33s system 12.09s wall 8.37 cores)
12 threads: 10965 Kiter/s (9.16s user 88.66s system 9.12s wall 10.73 cores)
16 threads: 14472 Kiter/s (7.24s user 95.69s system 6.91s wall 14.90 cores)
24 threads: 17331 Kiter/s (6.01s user 123.90s system 5.77s wall 22.51 cores)
32 threads: 18939 Kiter/s (5.60s user 155.93s system 5.28s wall 30.59 cores)
64 threads: 18727 Kiter/s (5.66s user 162.57s system 5.34s wall 31.50 cores)
128 threads: 18349 Kiter/s (5.56s user 167.46s system 5.45s wall 31.75 cores)
256 threads: 17271 Kiter/s (5.41s user 178.54s system 5.79s wall 31.77 cores)
512 threads: 16207 Kiter/s (5.15s user 191.55s system 6.17s wall 31.88 cores)
1024 threads: 14948 Kiter/s (4.72s user 208.38s system 6.69s wall 31.85 cores)


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
index a8cc4e1..a199606 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -25,6 +25,7 @@ struct restart_block {
 		struct {
 			u32 *uaddr;
 			u32 val;
+			u32 val2;
 			u32 flags;
 			u32 bitset;
 			u64 time;
diff --git a/kernel/futex.c b/kernel/futex.c
index fb65e82..be9de2b 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1694,6 +1694,7 @@ static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
  * futex_wait_setup() - Prepare to wait on a futex
  * @uaddr:	the futex userspace address
  * @val:	the expected value
+ * @val2:	the value we want to set, in replacement of val
  * @fshared:	whether the futex is shared (1) or not (0)
  * @q:		the associated futex_q
  * @hb:		storage for hash_bucket pointer to be returned to caller
@@ -1704,10 +1705,10 @@ static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
  * with no q.key reference on failure.
  *
  * Returns:
- *  0 - uaddr contains val and hb has been locked
+ *  0 - uaddr contains val2 and hb has been locked
  * <1 - -EFAULT or -EWOULDBLOCK (uaddr does not contain val) and hb is unlcoked
  */
-static int futex_wait_setup(u32 __user *uaddr, u32 val, int fshared,
+static int futex_wait_setup(u32 __user *uaddr, u32 val, u32 val2, int fshared,
 			   struct futex_q *q, struct futex_hash_bucket **hb)
 {
 	u32 uval;
@@ -1722,52 +1723,61 @@ static int futex_wait_setup(u32 __user *uaddr, u32 val, int fshared,
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
+			    (val == val2) ? VERIFY_READ : VERIFY_WRITE);
 	if (unlikely(ret != 0))
 		return ret;
 
 retry_private:
 	*hb = queue_lock(q);
 
-	ret = get_futex_value_locked(&uval, uaddr);
-
-	if (ret) {
+	pagefault_disable();
+	if (unlikely(__copy_from_user_inatomic(&uval, uaddr, sizeof(u32)))) {
+		pagefault_enable();
 		queue_unlock(q, *hb);
-
 		ret = get_user(uval, uaddr);
+	fault_common:
 		if (ret)
 			goto out;
-
 		if (!fshared)
 			goto retry_private;
-
 		put_futex_key(fshared, &q->key);
 		goto retry;
 	}
-
-	if (uval != val) {
-		queue_unlock(q, *hb);
-		ret = -EWOULDBLOCK;
+	if (val != val2 && uval == val) {
+		uval = futex_atomic_cmpxchg_inatomic(uaddr, val, val2);
+		if (unlikely(uval == -EFAULT)) {
+			pagefault_enable();
+			queue_unlock(q, *hb);
+			ret = fault_in_user_writeable(uaddr);
+			goto fault_common;
+		}
 	}
+	pagefault_enable();
+
+	if (uval == val || uval == val2)
+		return 0;  /* success */
 
+	queue_unlock(q, *hb);
+	ret = -EWOULDBLOCK;
 out:
-	if (ret)
-		put_futex_key(fshared, &q->key);
+	put_futex_key(fshared, &q->key);
 	return ret;
 }
 
-static int futex_wait(u32 __user *uaddr, int fshared,
-		      u32 val, ktime_t *abs_time, u32 bitset, int clockrt)
+static int futex_wait(u32 __user *uaddr, int fshared, u32 val, u32 val2,
+		      ktime_t *abs_time, u32 bitset, int clockrt)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct restart_block *restart;
@@ -1795,7 +1805,7 @@ static int futex_wait(u32 __user *uaddr, int fshared,
 
 retry:
 	/* Prepare to wait on uaddr. */
-	ret = futex_wait_setup(uaddr, val, fshared, &q, &hb);
+	ret = futex_wait_setup(uaddr, val, val2, fshared, &q, &hb);
 	if (ret)
 		goto out;
 
@@ -1827,6 +1837,7 @@ retry:
 	restart->fn = futex_wait_restart;
 	restart->futex.uaddr = (u32 *)uaddr;
 	restart->futex.val = val;
+	restart->futex.val2 = val2;
 	restart->futex.time = abs_time->tv64;
 	restart->futex.bitset = bitset;
 	restart->futex.flags = FLAGS_HAS_TIMEOUT;
@@ -1862,8 +1873,8 @@ static long futex_wait_restart(struct restart_block *restart)
 	restart->fn = do_no_restart_syscall;
 	if (restart->futex.flags & FLAGS_SHARED)
 		fshared = 1;
-	return (long)futex_wait(uaddr, fshared, restart->futex.val, tp,
-				restart->futex.bitset,
+	return (long)futex_wait(uaddr, fshared, restart->futex.val,
+				restart->futex.val2, tp, restart->futex.bitset,
 				restart->futex.flags & FLAGS_CLOCKRT);
 }
 
@@ -2219,7 +2230,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	q.requeue_pi_key = &key2;
 
 	/* Prepare to wait on uaddr. */
-	ret = futex_wait_setup(uaddr, val, fshared, &q, &hb);
+	ret = futex_wait_setup(uaddr, val, val, fshared, &q, &hb);
 	if (ret)
 		goto out_key2;
 
@@ -2532,14 +2543,18 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
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
@@ -2595,7 +2610,7 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 
 	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI ||
 		      cmd == FUTEX_WAIT_BITSET ||
-		      cmd == FUTEX_WAIT_REQUEUE_PI)) {
+		      cmd == FUTEX_WAIT_REQUEUE_PI || cmd == FUTEX_SET_WAIT)) {
 		if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
 			return -EFAULT;
 		if (!timespec_valid(&ts))
@@ -2609,10 +2624,16 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
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




test code:

#include <stdio.h>
#include <errno.h>
#include <linux/unistd.h>
#include <linux/futex.h>
#include <limits.h>
#include <pthread.h>
#include <unistd.h>
#include <sys/times.h>
#include <sys/syscall.h>

#define FUTEX_SET_WAIT 13
#define FUTEX_SET_WAIT_PRIVATE (FUTEX_SET_WAIT | FUTEX_PRIVATE_FLAG)

static inline int sys_futex(int * uaddr, int op, int val,
                            struct timespec * timeout, int * uaddr2, int val3)
{
  return syscall(__NR_futex, uaddr, op, val, timeout, uaddr2, val3);
}

static inline int cmpxchg(volatile int *ptr, int old, int new)
{
  int prev;
  asm volatile("lock; cmpxchgl %1,%2"
               : "=a" (prev)
               : "r"(new), "m"(*ptr), "0"(old)
               : "memory");
  return prev;
}



/***** Sample futex based lock/unlock operations *****/

/* States: 0 = unlocked; 1 = locked ; 2 = locked with possible waiters */

/* Classic lock, using FUTEX_WAIT */
static inline void futex_wait_lock(volatile int *ptr)
{
  int status = *ptr;
  if (status == 0)
    status = cmpxchg(ptr, 0, 1);
  while (status != 0) {
    if (status == 1)
      status = cmpxchg(ptr, 1, 2);
    if (status != 0) {
      sys_futex((int *)ptr, FUTEX_WAIT_PRIVATE, 2, NULL, NULL, 0);
      status = *ptr;
    }
    if (status == 0)
      status = cmpxchg(ptr, 0, 2);
  }
}

/* Optimized lock, using the proposed FUTEX_SET_WAIT operation */
static inline void futex_setwait_lock(volatile int *ptr)
{
  int status = *ptr;
  if (status == 0)
    status = cmpxchg(ptr, 0, 1);
  if (status != 0) {
    int desired_status = 1;
    do {
      if (sys_futex((int *)ptr, FUTEX_SET_WAIT_PRIVATE, 1, NULL,
                    (int *)2, ~0) == 0) {
        /* We absorbed a wakeup; so make sure to unblock next thread */
        desired_status = 2;
      }
      status = *ptr;
      if (status == 0)
        status = cmpxchg(ptr, 0, desired_status);
    } while (status != 0);
  }
}

/* Unlock. cmpxchg is not optimal for this sample 3-state locking protocol;
   but it is often required when implementing more complex locking protocols */
static inline void futex_cmpxchg_unlock(volatile int *ptr)
{
  int status = *ptr;
  if (status == 1)
    status = cmpxchg(ptr, 1, 0);
  if (status == 2) {
    cmpxchg(ptr, 2, 0);  /* Guaranteed to succeed in 3-state protocol */
    sys_futex((int *)ptr, FUTEX_WAKE_PRIVATE, 1, NULL, NULL, 0);
  }
}



/***** Lock/unlock perf test *****/

struct thread_barrier {
  int threads;
  int unblock;
};

static void barrier_sync(struct thread_barrier *barrier);

struct locktest_shared {
  struct thread_barrier barrier_before;
  struct thread_barrier barrier_after;
  int loops;
  int test_futex;
};

static void * futex_wait_test(void * dummy)
{
  struct locktest_shared * shared = dummy;
  int i = shared->loops;
  barrier_sync(&shared->barrier_before);
  while (i--) {
    futex_wait_lock(&shared->test_futex);
    futex_cmpxchg_unlock(&shared->test_futex);
  }
  barrier_sync(&shared->barrier_after);
  return NULL;
}

static void * futex_setwait_test(void * dummy)
{
  struct locktest_shared * shared = dummy;
  int i = shared->loops;
  barrier_sync(&shared->barrier_before);
  while (i--) {
    futex_setwait_lock(&shared->test_futex);
    futex_cmpxchg_unlock(&shared->test_futex);
  }
  barrier_sync(&shared->barrier_after);
  return NULL;
}



/***** Test harness & support functions *****/


static inline void decrement(int *ptr)
{
  asm volatile("lock; decl %0"
               : "=m" (*ptr)
               : "m" (*ptr));
}

/* Called by main thread to initialize barrier */
static void barrier_init(struct thread_barrier *barrier, int threads)
{
  barrier->threads = threads;
  barrier->unblock = 0;
}

/* Called by worker threads to synchronize with main thread */
static void barrier_sync(struct thread_barrier *barrier)
{
  decrement(&barrier->threads);
  if (barrier->threads == 0)
    sys_futex(&barrier->threads, FUTEX_WAKE_PRIVATE, 1, NULL, NULL, 0);
  while (barrier->unblock == 0)
    sys_futex(&barrier->unblock, FUTEX_WAIT_PRIVATE, 0, NULL, NULL, 0);
}

/* Called by main thread to wait for all workers to reach sync point */
static void barrier_wait(struct thread_barrier *barrier)
{
  int threads;
  while ((threads = barrier->threads) > 0)
    sys_futex(&barrier->threads, FUTEX_WAIT_PRIVATE, threads, NULL, NULL, 0);
}

/* Called by main thread to unblock worker threads from their sync point */
static void barrier_unblock(struct thread_barrier *barrier)
{
  barrier->unblock = 1;
  sys_futex(&barrier->unblock, FUTEX_WAKE_PRIVATE, INT_MAX, NULL, NULL, 0);
}


static void locktest(void * thread_function(void *), int iterations,
                     int num_threads)
{
  struct locktest_shared shared;
  pthread_t thread[num_threads];
  int i;
  clock_t before, after;
  struct tms tms_before, tms_after;
  int wall, user, system;
  double tick;

  barrier_init(&shared.barrier_before, num_threads);
  barrier_init(&shared.barrier_after, num_threads);
  shared.loops = iterations / num_threads;
  shared.test_futex = 0;

  for (i = 0; i < num_threads; i++)
    pthread_create(thread + i, NULL, thread_function, &shared);
  barrier_wait(&shared.barrier_before);
  before = times(&tms_before);
  barrier_unblock(&shared.barrier_before);
  barrier_wait(&shared.barrier_after);
  after = times(&tms_after);
  wall = after - before;
  user = tms_after.tms_utime - tms_before.tms_utime;
  system = tms_after.tms_stime - tms_before.tms_stime;
  tick = 1.0 / sysconf(_SC_CLK_TCK);
  printf("%d threads: %.0f Kiter/s "
         "(%.2fs user %.2fs system %.2fs wall %.2f cores)\n",
         num_threads, (num_threads * shared.loops) / (wall * tick * 1000),
         user * tick, system * tick, wall * tick,
         wall ? (user + system) * 1. / wall : 1.);
  barrier_unblock(&shared.barrier_after);
  for (i = 0; i < num_threads; i++)
    pthread_join(thread[i], NULL);
}

int futex_setwait_supported(void)
{
  int futex = 0;
  sys_futex(&futex, FUTEX_SET_WAIT_PRIVATE, 1, NULL, (int *)2, ~0);
  return errno == EWOULDBLOCK;
}

int main (void)
{
  int threads[] = { 1, 2, 3, 4, 5, 6, 8, 10, 12, 16, 24, 32,
                    64, 128, 256, 512, 1024, 0 };
  int i;
  if (futex_setwait_supported()) {
    printf("\nFUTEX_SET_WAIT test\n");
    for (i = 0; threads[i]; i++)
      locktest(futex_setwait_test, 100000000, threads[i]);
  }
  printf("\nFUTEX_WAIT test\n");
  for (i = 0; threads[i]; i++)
    locktest(futex_wait_test, 100000000, threads[i]);
  printf("\n");
  return 0;
}


-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
