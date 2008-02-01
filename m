Return-Path: <linux-kernel-owner+w=401wt.eu-S1759472AbYBAQ6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472AbYBAQ6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 11:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbYBAQ6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 11:58:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56524 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755781AbYBAQ6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 11:58:45 -0500
Date: Fri, 1 Feb 2008 17:58:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] scheduler and futex updates
Message-ID: <20080201165835.GA437@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
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


Linus, please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

Fixes, plus the futex "bitset filter" conditional futex wakeup API 
variant that Ulrich asked for to reduce the number of false wakeups in 
user-space rwlocks. Thanks,

	Ingo

------------------>
Heiko Carstens (1):
      latencytop: Change Kconfig dependency.

Peter Zijlstra (1):
      hrtimer: fix hrtimer_init_sleeper() users

Thomas Gleixner (5):
      timekeeping: update xtime_cache when time(zone) changes
      tick-sched: add more debug information
      x86: replace LOCK_PREFIX in futex.h
      futex: Remove warn on in return fixup path
      futex: Add bitset conditional wait/wakeup functionality

 arch/x86/Kconfig            |    3 +++
 include/asm-x86/futex.h     |    6 +++---
 include/linux/futex.h       |   10 ++++++++++
 include/linux/thread_info.h |    1 +
 include/linux/tick.h        |    4 ++++
 include/linux/time.h        |    1 +
 kernel/futex.c              |   42 ++++++++++++++++++++++++++++++++----------
 kernel/futex_compat.c       |    3 ++-
 kernel/hrtimer.c            |    2 ++
 kernel/time.c               |    1 +
 kernel/time/tick-sched.c    |    2 ++
 kernel/time/timekeeping.c   |    6 ++++--
 kernel/time/timer_list.c    |    2 ++
 lib/Kconfig.debug           |    2 +-
 14 files changed, 68 insertions(+), 17 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 65b4491..93e6667 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -44,6 +44,9 @@ config LOCKDEP_SUPPORT
 config STACKTRACE_SUPPORT
 	def_bool y
 
+config HAVE_LATENCYTOP_SUPPORT
+	def_bool y
+
 config SEMAPHORE_SLEEPERS
 	def_bool y
 
diff --git a/include/asm-x86/futex.h b/include/asm-x86/futex.h
index 62828d6..9d91926 100644
--- a/include/asm-x86/futex.h
+++ b/include/asm-x86/futex.h
@@ -30,7 +30,7 @@
 "1:	movl	%2, %0\n					\
 	movl	%0, %3\n"					\
 	insn "\n"						\
-"2:	" LOCK_PREFIX "cmpxchgl %3, %2\n			\
+"2:	lock; cmpxchgl %3, %2\n					\
 	jnz	1b\n						\
 3:	.section .fixup,\"ax\"\n				\
 4:	mov	%5, %1\n					\
@@ -72,7 +72,7 @@ futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 		__futex_atomic_op1("xchgl %0, %2", ret, oldval, uaddr, oparg);
 		break;
 	case FUTEX_OP_ADD:
-		__futex_atomic_op1(LOCK_PREFIX "xaddl %0, %2", ret, oldval,
+		__futex_atomic_op1("lock; xaddl %0, %2", ret, oldval,
 				   uaddr, oparg);
 		break;
 	case FUTEX_OP_OR:
@@ -111,8 +111,8 @@ futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
 		return -EFAULT;
 
 	__asm__ __volatile__(
-		"1:	" LOCK_PREFIX "cmpxchgl %3, %1		\n"
 
+		"1:	lock; cmpxchgl %3, %1			\n"
 		"2:	.section .fixup, \"ax\"			\n"
 		"3:	mov     %2, %0				\n"
 		"	jmp     2b				\n"
diff --git a/include/linux/futex.h b/include/linux/futex.h
index 1a15f8e..90048fb 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -21,6 +21,8 @@ union ktime;
 #define FUTEX_LOCK_PI		6
 #define FUTEX_UNLOCK_PI		7
 #define FUTEX_TRYLOCK_PI	8
+#define FUTEX_WAIT_BITSET	9
+#define FUTEX_WAKE_BITSET	10
 
 #define FUTEX_PRIVATE_FLAG	128
 #define FUTEX_CMD_MASK		~FUTEX_PRIVATE_FLAG
@@ -33,6 +35,8 @@ union ktime;
 #define FUTEX_LOCK_PI_PRIVATE	(FUTEX_LOCK_PI | FUTEX_PRIVATE_FLAG)
 #define FUTEX_UNLOCK_PI_PRIVATE	(FUTEX_UNLOCK_PI | FUTEX_PRIVATE_FLAG)
 #define FUTEX_TRYLOCK_PI_PRIVATE (FUTEX_TRYLOCK_PI | FUTEX_PRIVATE_FLAG)
+#define FUTEX_WAIT_BITSET_PRIVATE	(FUTEX_WAIT_BITS | FUTEX_PRIVATE_FLAG)
+#define FUTEX_WAKE_BITSET_PRIVATE	(FUTEX_WAKE_BITS | FUTEX_PRIVATE_FLAG)
 
 /*
  * Support for robust futexes: the kernel cleans up held futexes at
@@ -111,6 +115,12 @@ struct robust_list_head {
  */
 #define ROBUST_LIST_LIMIT	2048
 
+/*
+ * bitset with all bits set for the FUTEX_xxx_BITSET OPs to request a
+ * match of any bit.
+ */
+#define FUTEX_BITSET_MATCH_ANY	0xffffffff
+
 #ifdef __KERNEL__
 long do_futex(u32 __user *uaddr, int op, u32 val, union ktime *timeout,
 	      u32 __user *uaddr2, u32 val2, u32 val3);
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index dfbdfb9..421323e 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -23,6 +23,7 @@ struct restart_block {
 			u32 *uaddr;
 			u32 val;
 			u32 flags;
+			u32 bitset;
 			u64 time;
 		} futex;
 	};
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 0fadf95..a881c65 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -39,6 +39,8 @@ enum tick_nohz_mode {
  * @idle_calls:		Total number of idle calls
  * @idle_sleeps:	Number of idle calls, where the sched tick was stopped
  * @idle_entrytime:	Time when the idle call was entered
+ * @idle_waketime:	Time when the idle was interrupted
+ * @idle_exittime:	Time when the idle state was left
  * @idle_sleeptime:	Sum of the time slept in idle with sched tick stopped
  * @sleep_length:	Duration of the current idle sleep
  */
@@ -53,6 +55,8 @@ struct tick_sched {
 	unsigned long			idle_sleeps;
 	int				idle_active;
 	ktime_t				idle_entrytime;
+	ktime_t				idle_waketime;
+	ktime_t				idle_exittime;
 	ktime_t				idle_sleeptime;
 	ktime_t				idle_lastupdate;
 	ktime_t				sleep_length;
diff --git a/include/linux/time.h b/include/linux/time.h
index b04136d..ceaab9f 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -122,6 +122,7 @@ extern void monotonic_to_bootbased(struct timespec *ts);
 extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 extern int timekeeping_is_continuous(void);
 extern void update_wall_time(void);
+extern void update_xtime_cache(u64 nsec);
 
 /**
  * timespec_to_ns - Convert timespec to nanoseconds
diff --git a/kernel/futex.c b/kernel/futex.c
index db9824d..a6baaec 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -109,6 +109,9 @@ struct futex_q {
 	/* Optional priority inheritance state: */
 	struct futex_pi_state *pi_state;
 	struct task_struct *task;
+
+	/* Bitset for the optional bitmasked wakeup */
+	u32 bitset;
 };
 
 /*
@@ -722,7 +725,7 @@ double_lock_hb(struct futex_hash_bucket *hb1, struct futex_hash_bucket *hb2)
  * to this virtual address:
  */
 static int futex_wake(u32 __user *uaddr, struct rw_semaphore *fshared,
-		      int nr_wake)
+		      int nr_wake, u32 bitset)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
@@ -730,6 +733,9 @@ static int futex_wake(u32 __user *uaddr, struct rw_semaphore *fshared,
 	union futex_key key;
 	int ret;
 
+	if (!bitset)
+		return -EINVAL;
+
 	futex_lock_mm(fshared);
 
 	ret = get_futex_key(uaddr, fshared, &key);
@@ -746,6 +752,11 @@ static int futex_wake(u32 __user *uaddr, struct rw_semaphore *fshared,
 				ret = -EINVAL;
 				break;
 			}
+
+			/* Check if one of the bits is set in both bitsets */
+			if (!(this->bitset & bitset))
+				continue;
+
 			wake_futex(this);
 			if (++ret >= nr_wake)
 				break;
@@ -1156,7 +1167,7 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 static long futex_wait_restart(struct restart_block *restart);
 
 static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
-		      u32 val, ktime_t *abs_time)
+		      u32 val, ktime_t *abs_time, u32 bitset)
 {
 	struct task_struct *curr = current;
 	DECLARE_WAITQUEUE(wait, curr);
@@ -1167,7 +1178,11 @@ static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
 	struct hrtimer_sleeper t;
 	int rem = 0;
 
+	if (!bitset)
+		return -EINVAL;
+
 	q.pi_state = NULL;
+	q.bitset = bitset;
  retry:
 	futex_lock_mm(fshared);
 
@@ -1252,6 +1267,8 @@ static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
 			t.timer.expires = *abs_time;
 
 			hrtimer_start(&t.timer, t.timer.expires, HRTIMER_MODE_ABS);
+			if (!hrtimer_active(&t.timer))
+				t.task = NULL;
 
 			/*
 			 * the timer could have already expired, in which
@@ -1293,6 +1310,7 @@ static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
 		restart->futex.uaddr = (u32 *)uaddr;
 		restart->futex.val = val;
 		restart->futex.time = abs_time->tv64;
+		restart->futex.bitset = bitset;
 		restart->futex.flags = 0;
 
 		if (fshared)
@@ -1319,7 +1337,8 @@ static long futex_wait_restart(struct restart_block *restart)
 	restart->fn = do_no_restart_syscall;
 	if (restart->futex.flags & FLAGS_SHARED)
 		fshared = &current->mm->mmap_sem;
-	return (long)futex_wait(uaddr, fshared, restart->futex.val, &t);
+	return (long)futex_wait(uaddr, fshared, restart->futex.val, &t,
+				restart->futex.bitset);
 }
 
 
@@ -1535,9 +1554,6 @@ static int futex_lock_pi(u32 __user *uaddr, struct rw_semaphore *fshared,
 				owner = rt_mutex_owner(&q.pi_state->pi_mutex);
 				res = fixup_pi_state_owner(uaddr, &q, owner);
 
-				WARN_ON(rt_mutex_owner(&q.pi_state->pi_mutex) !=
-					owner);
-
 				/* propagate -EFAULT, if the fixup failed */
 				if (res)
 					ret = res;
@@ -1943,7 +1959,8 @@ retry:
 		 * PI futexes happens in exit_pi_state():
 		 */
 		if (!pi && (uval & FUTEX_WAITERS))
-				futex_wake(uaddr, &curr->mm->mmap_sem, 1);
+			futex_wake(uaddr, &curr->mm->mmap_sem, 1,
+				   FUTEX_BITSET_MATCH_ANY);
 	}
 	return 0;
 }
@@ -2043,10 +2060,14 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 
 	switch (cmd) {
 	case FUTEX_WAIT:
-		ret = futex_wait(uaddr, fshared, val, timeout);
+		val3 = FUTEX_BITSET_MATCH_ANY;
+	case FUTEX_WAIT_BITSET:
+		ret = futex_wait(uaddr, fshared, val, timeout, val3);
 		break;
 	case FUTEX_WAKE:
-		ret = futex_wake(uaddr, fshared, val);
+		val3 = FUTEX_BITSET_MATCH_ANY;
+	case FUTEX_WAKE_BITSET:
+		ret = futex_wake(uaddr, fshared, val, val3);
 		break;
 	case FUTEX_FD:
 		/* non-zero val means F_SETOWN(getpid()) & F_SETSIG(val) */
@@ -2086,7 +2107,8 @@ asmlinkage long sys_futex(u32 __user *uaddr, int op, u32 val,
 	u32 val2 = 0;
 	int cmd = op & FUTEX_CMD_MASK;
 
-	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI)) {
+	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI ||
+		      cmd == FUTEX_WAIT_BITSET)) {
 		if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
 			return -EFAULT;
 		if (!timespec_valid(&ts))
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 0a43def..133d558 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -167,7 +167,8 @@ asmlinkage long compat_sys_futex(u32 __user *uaddr, int op, u32 val,
 	int val2 = 0;
 	int cmd = op & FUTEX_CMD_MASK;
 
-	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI)) {
+	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI ||
+		      cmd == FUTEX_WAIT_BITSET)) {
 		if (get_compat_timespec(&ts, utime))
 			return -EFAULT;
 		if (!timespec_valid(&ts))
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index bd5d6b5..1069998 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1315,6 +1315,8 @@ static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mod
 
 	} while (t->task && !signal_pending(current));
 
+	__set_current_state(TASK_RUNNING);
+
 	return t->task == NULL;
 }
 
diff --git a/kernel/time.c b/kernel/time.c
index 09d3c45..4064c05 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -129,6 +129,7 @@ static inline void warp_clock(void)
 	write_seqlock_irq(&xtime_lock);
 	wall_to_monotonic.tv_sec -= sys_tz.tz_minuteswest * 60;
 	xtime.tv_sec += sys_tz.tz_minuteswest * 60;
+	update_xtime_cache(0);
 	write_sequnlock_irq(&xtime_lock);
 	clock_was_set();
 }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 63f24b5..88267f0 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -137,6 +137,7 @@ void tick_nohz_update_jiffies(void)
 
 	cpu_clear(cpu, nohz_cpu_mask);
 	now = ktime_get();
+	ts->idle_waketime = now;
 
 	local_irq_save(flags);
 	tick_do_update_jiffies64(now);
@@ -400,6 +401,7 @@ void tick_nohz_restart_sched_tick(void)
 	 * Cancel the scheduled timer and restore the tick
 	 */
 	ts->tick_stopped  = 0;
+	ts->idle_exittime = now;
 	hrtimer_cancel(&ts->sched_timer);
 	ts->sched_timer.expires = ts->idle_tick;
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 092a236..cd5dbc4 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -47,7 +47,7 @@ struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
 static unsigned long total_sleep_time;		/* seconds */
 
 static struct timespec xtime_cache __attribute__ ((aligned (16)));
-static inline void update_xtime_cache(u64 nsec)
+void update_xtime_cache(u64 nsec)
 {
 	xtime_cache = xtime;
 	timespec_add_ns(&xtime_cache, nsec);
@@ -145,6 +145,7 @@ int do_settimeofday(struct timespec *tv)
 
 	set_normalized_timespec(&xtime, sec, nsec);
 	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
+	update_xtime_cache(0);
 
 	clock->error = 0;
 	ntp_clear();
@@ -252,8 +253,8 @@ void __init timekeeping_init(void)
 	xtime.tv_nsec = 0;
 	set_normalized_timespec(&wall_to_monotonic,
 		-xtime.tv_sec, -xtime.tv_nsec);
+	update_xtime_cache(0);
 	total_sleep_time = 0;
-
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 }
 
@@ -290,6 +291,7 @@ static int timekeeping_resume(struct sys_device *dev)
 	}
 	/* Make sure that we have the correct xtime reference */
 	timespec_add_ns(&xtime, timekeeping_suspend_nsecs);
+	update_xtime_cache(0);
 	/* re-base the last cycle value */
 	clock->cycle_last = clocksource_read(clock);
 	clock->error = 0;
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 12c5f4c..d3d94c1 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -166,6 +166,8 @@ static void print_cpu(struct seq_file *m, int cpu, u64 now)
 		P(idle_calls);
 		P(idle_sleeps);
 		P_ns(idle_entrytime);
+		P_ns(idle_waketime);
+		P_ns(idle_exittime);
 		P_ns(idle_sleeptime);
 		P(last_jiffies);
 		P(next_jiffies);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 89f4035..0d8a5a4 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -581,7 +581,7 @@ config LATENCYTOP
 	select STACKTRACE
 	select SCHEDSTATS
 	select SCHED_DEBUG
-	depends on X86 || X86_64
+	depends on HAVE_LATENCYTOP_SUPPORT
 	help
 	  Enable this option if you want to use the LatencyTOP tool
 	  to find out which userspace is blocking on what kernel operations.
