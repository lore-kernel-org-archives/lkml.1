Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbZIVR7C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbZIVR7C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 13:59:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbZIVR67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 13:58:59 -0400
Received: from www.tglx.de ([62.245.132.106]:58786 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756199AbZIVR66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 13:58:58 -0400
Date: Tue, 22 Sep 2009 10:57:56 -0700 (PDT)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] timer updated for 2.6.32
Message-ID: <alpine.LFD.2.00.0909221054050.2480@nanos>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-for-linus

Tracepoints for timers and itimer improvements which include some
fixups in various archs due to the core code changes.

Thanks,

	tglx

------------------>
Stanislaw Gruszka (4):
      itimers: Merge ITIMER_VIRT and ITIMER_PROF
      itimers: Fix periodic tics precision
      itimers: Simplify arm_timer() code a bit
      cputime: Optimize jiffies_to_cputime(1)

Xiao Guangrong (3):
      timers: Add tracepoints for timer_list timers
      hrtimer: Add tracepoint for hrtimers
      itimers: Add tracepoints for itimer


 arch/ia64/include/asm/cputime.h    |    1 +
 arch/powerpc/include/asm/cputime.h |   13 ++
 arch/powerpc/kernel/time.c         |    4 +
 arch/s390/include/asm/cputime.h    |    1 +
 include/asm-generic/cputime.h      |    1 +
 include/linux/sched.h              |   16 ++-
 include/trace/events/timer.h       |  342 ++++++++++++++++++++++++++++++++++++
 kernel/fork.c                      |    9 +-
 kernel/hrtimer.c                   |   40 ++++-
 kernel/itimer.c                    |  169 ++++++++++--------
 kernel/posix-cpu-timers.c          |  155 +++++++++--------
 kernel/sched.c                     |    9 +-
 kernel/timer.c                     |   32 +++-
 13 files changed, 620 insertions(+), 172 deletions(-)
 create mode 100644 include/trace/events/timer.h

diff --git a/arch/ia64/include/asm/cputime.h b/arch/ia64/include/asm/cputime.h
index d20b998..7fa8a85 100644
--- a/arch/ia64/include/asm/cputime.h
+++ b/arch/ia64/include/asm/cputime.h
@@ -30,6 +30,7 @@ typedef u64 cputime_t;
 typedef u64 cputime64_t;
 
 #define cputime_zero			((cputime_t)0)
+#define cputime_one_jiffy		jiffies_to_cputime(1)
 #define cputime_max			((~((cputime_t)0) >> 1) - 1)
 #define cputime_add(__a, __b)		((__a) +  (__b))
 #define cputime_sub(__a, __b)		((__a) -  (__b))
diff --git a/arch/powerpc/include/asm/cputime.h b/arch/powerpc/include/asm/cputime.h
index f42e623..fa19f3f 100644
--- a/arch/powerpc/include/asm/cputime.h
+++ b/arch/powerpc/include/asm/cputime.h
@@ -18,6 +18,9 @@
 
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 #include <asm-generic/cputime.h>
+#ifdef __KERNEL__
+static inline void setup_cputime_one_jiffy(void) { }
+#endif
 #else
 
 #include <linux/types.h>
@@ -49,6 +52,11 @@ typedef u64 cputime64_t;
 #ifdef __KERNEL__
 
 /*
+ * One jiffy in timebase units computed during initialization
+ */
+extern cputime_t cputime_one_jiffy;
+
+/*
  * Convert cputime <-> jiffies
  */
 extern u64 __cputime_jiffies_factor;
@@ -89,6 +97,11 @@ static inline cputime_t jiffies_to_cputime(const unsigned long jif)
 	return ct;
 }
 
+static inline void setup_cputime_one_jiffy(void)
+{
+	cputime_one_jiffy = jiffies_to_cputime(1);
+}
+
 static inline cputime64_t jiffies64_to_cputime64(const u64 jif)
 {
 	cputime_t ct;
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index a508388..5b16575 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -193,6 +193,8 @@ EXPORT_SYMBOL(__cputime_clockt_factor);
 DEFINE_PER_CPU(unsigned long, cputime_last_delta);
 DEFINE_PER_CPU(unsigned long, cputime_scaled_last_delta);
 
+cputime_t cputime_one_jiffy;
+
 static void calc_cputime_factors(void)
 {
 	struct div_result res;
@@ -500,6 +502,7 @@ static int __init iSeries_tb_recal(void)
 				tb_to_xs = divres.result_low;
 				vdso_data->tb_ticks_per_sec = tb_ticks_per_sec;
 				vdso_data->tb_to_xs = tb_to_xs;
+				setup_cputime_one_jiffy();
 			}
 			else {
 				printk( "Titan recalibrate: FAILED (difference > 4 percent)\n"
@@ -950,6 +953,7 @@ void __init time_init(void)
 	tb_ticks_per_usec = ppc_tb_freq / 1000000;
 	tb_to_us = mulhwu_scale_factor(ppc_tb_freq, 1000000);
 	calc_cputime_factors();
+	setup_cputime_one_jiffy();
 
 	/*
 	 * Calculate the length of each tick in ns.  It will not be
diff --git a/arch/s390/include/asm/cputime.h b/arch/s390/include/asm/cputime.h
index 7a3817a..24b1244 100644
--- a/arch/s390/include/asm/cputime.h
+++ b/arch/s390/include/asm/cputime.h
@@ -42,6 +42,7 @@ __div(unsigned long long n, unsigned int base)
 #endif /* __s390x__ */
 
 #define cputime_zero			(0ULL)
+#define cputime_one_jiffy		jiffies_to_cputime(1)
 #define cputime_max			((~0UL >> 1) - 1)
 #define cputime_add(__a, __b)		((__a) +  (__b))
 #define cputime_sub(__a, __b)		((__a) -  (__b))
diff --git a/include/asm-generic/cputime.h b/include/asm-generic/cputime.h
index 1c1fa42..ca0f239 100644
--- a/include/asm-generic/cputime.h
+++ b/include/asm-generic/cputime.h
@@ -7,6 +7,7 @@
 typedef unsigned long cputime_t;
 
 #define cputime_zero			(0UL)
+#define cputime_one_jiffy		jiffies_to_cputime(1)
 #define cputime_max			((~0UL >> 1) - 1)
 #define cputime_add(__a, __b)		((__a) +  (__b))
 #define cputime_sub(__a, __b)		((__a) -  (__b))
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3ab08e4..a069e65 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -470,6 +470,13 @@ struct pacct_struct {
 	unsigned long		ac_minflt, ac_majflt;
 };
 
+struct cpu_itimer {
+	cputime_t expires;
+	cputime_t incr;
+	u32 error;
+	u32 incr_error;
+};
+
 /**
  * struct task_cputime - collected CPU time counts
  * @utime:		time spent in user mode, in &cputime_t units
@@ -564,9 +571,12 @@ struct signal_struct {
 	struct pid *leader_pid;
 	ktime_t it_real_incr;
 
-	/* ITIMER_PROF and ITIMER_VIRTUAL timers for the process */
-	cputime_t it_prof_expires, it_virt_expires;
-	cputime_t it_prof_incr, it_virt_incr;
+	/*
+	 * ITIMER_PROF and ITIMER_VIRTUAL timers for the process, we use
+	 * CPUCLOCK_PROF and CPUCLOCK_VIRT for indexing array as these
+	 * values are defined to 0 and 1 respectively
+	 */
+	struct cpu_itimer it[2];
 
 	/*
 	 * Thread group totals for process CPU timers.
diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
new file mode 100644
index 0000000..1844c48
--- /dev/null
+++ b/include/trace/events/timer.h
@@ -0,0 +1,342 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM timer
+
+#if !defined(_TRACE_TIMER_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_TIMER_H
+
+#include <linux/tracepoint.h>
+#include <linux/hrtimer.h>
+#include <linux/timer.h>
+
+/**
+ * timer_init - called when the timer is initialized
+ * @timer:	pointer to struct timer_list
+ */
+TRACE_EVENT(timer_init,
+
+	TP_PROTO(struct timer_list *timer),
+
+	TP_ARGS(timer),
+
+	TP_STRUCT__entry(
+		__field( void *,	timer	)
+	),
+
+	TP_fast_assign(
+		__entry->timer	= timer;
+	),
+
+	TP_printk("timer %p", __entry->timer)
+);
+
+/**
+ * timer_start - called when the timer is started
+ * @timer:	pointer to struct timer_list
+ * @expires:	the timers expiry time
+ */
+TRACE_EVENT(timer_start,
+
+	TP_PROTO(struct timer_list *timer, unsigned long expires),
+
+	TP_ARGS(timer, expires),
+
+	TP_STRUCT__entry(
+		__field( void *,	timer		)
+		__field( void *,	function	)
+		__field( unsigned long,	expires		)
+		__field( unsigned long,	now		)
+	),
+
+	TP_fast_assign(
+		__entry->timer		= timer;
+		__entry->function	= timer->function;
+		__entry->expires	= expires;
+		__entry->now		= jiffies;
+	),
+
+	TP_printk("timer %p: func %pf, expires %lu, timeout %ld",
+		  __entry->timer, __entry->function, __entry->expires,
+		  (long)__entry->expires - __entry->now)
+);
+
+/**
+ * timer_expire_entry - called immediately before the timer callback
+ * @timer:	pointer to struct timer_list
+ *
+ * Allows to determine the timer latency.
+ */
+TRACE_EVENT(timer_expire_entry,
+
+	TP_PROTO(struct timer_list *timer),
+
+	TP_ARGS(timer),
+
+	TP_STRUCT__entry(
+		__field( void *,	timer	)
+		__field( unsigned long,	now	)
+	),
+
+	TP_fast_assign(
+		__entry->timer		= timer;
+		__entry->now		= jiffies;
+	),
+
+	TP_printk("timer %p: now %lu", __entry->timer, __entry->now)
+);
+
+/**
+ * timer_expire_exit - called immediately after the timer callback returns
+ * @timer:	pointer to struct timer_list
+ *
+ * When used in combination with the timer_expire_entry tracepoint we can
+ * determine the runtime of the timer callback function.
+ *
+ * NOTE: Do NOT derefernce timer in TP_fast_assign. The pointer might
+ * be invalid. We solely track the pointer.
+ */
+TRACE_EVENT(timer_expire_exit,
+
+	TP_PROTO(struct timer_list *timer),
+
+	TP_ARGS(timer),
+
+	TP_STRUCT__entry(
+		__field(void *,	timer	)
+	),
+
+	TP_fast_assign(
+		__entry->timer	= timer;
+	),
+
+	TP_printk("timer %p", __entry->timer)
+);
+
+/**
+ * timer_cancel - called when the timer is canceled
+ * @timer:	pointer to struct timer_list
+ */
+TRACE_EVENT(timer_cancel,
+
+	TP_PROTO(struct timer_list *timer),
+
+	TP_ARGS(timer),
+
+	TP_STRUCT__entry(
+		__field( void *,	timer	)
+	),
+
+	TP_fast_assign(
+		__entry->timer	= timer;
+	),
+
+	TP_printk("timer %p", __entry->timer)
+);
+
+/**
+ * hrtimer_init - called when the hrtimer is initialized
+ * @timer:	pointer to struct hrtimer
+ * @clockid:	the hrtimers clock
+ * @mode:	the hrtimers mode
+ */
+TRACE_EVENT(hrtimer_init,
+
+	TP_PROTO(struct hrtimer *timer, clockid_t clockid,
+		 enum hrtimer_mode mode),
+
+	TP_ARGS(timer, clockid, mode),
+
+	TP_STRUCT__entry(
+		__field( void *,		timer		)
+		__field( clockid_t,		clockid		)
+		__field( enum hrtimer_mode,	mode		)
+	),
+
+	TP_fast_assign(
+		__entry->timer		= timer;
+		__entry->clockid	= clockid;
+		__entry->mode		= mode;
+	),
+
+	TP_printk("hrtimer %p, clockid %s, mode %s", __entry->timer,
+		  __entry->clockid == CLOCK_REALTIME ?
+			"CLOCK_REALTIME" : "CLOCK_MONOTONIC",
+		  __entry->mode == HRTIMER_MODE_ABS ?
+			"HRTIMER_MODE_ABS" : "HRTIMER_MODE_REL")
+);
+
+/**
+ * hrtimer_start - called when the hrtimer is started
+ * @timer: pointer to struct hrtimer
+ */
+TRACE_EVENT(hrtimer_start,
+
+	TP_PROTO(struct hrtimer *timer),
+
+	TP_ARGS(timer),
+
+	TP_STRUCT__entry(
+		__field( void *,	timer		)
+		__field( void *,	function	)
+		__field( s64,		expires		)
+		__field( s64,		softexpires	)
+	),
+
+	TP_fast_assign(
+		__entry->timer		= timer;
+		__entry->function	= timer->function;
+		__entry->expires	= hrtimer_get_expires(timer).tv64;
+		__entry->softexpires	= hrtimer_get_softexpires(timer).tv64;
+	),
+
+	TP_printk("hrtimer %p, func %pf, expires %llu, softexpires %llu",
+		  __entry->timer, __entry->function,
+		  (unsigned long long)ktime_to_ns((ktime_t) {
+				  .tv64 = __entry->expires }),
+		  (unsigned long long)ktime_to_ns((ktime_t) {
+				  .tv64 = __entry->softexpires }))
+);
+
+/**
+ * htimmer_expire_entry - called immediately before the hrtimer callback
+ * @timer:	pointer to struct hrtimer
+ * @now:	pointer to variable which contains current time of the
+ *		timers base.
+ *
+ * Allows to determine the timer latency.
+ */
+TRACE_EVENT(hrtimer_expire_entry,
+
+	TP_PROTO(struct hrtimer *timer, ktime_t *now),
+
+	TP_ARGS(timer, now),
+
+	TP_STRUCT__entry(
+		__field( void *,	timer	)
+		__field( s64,		now	)
+	),
+
+	TP_fast_assign(
+		__entry->timer	= timer;
+		__entry->now	= now->tv64;
+	),
+
+	TP_printk("hrtimer %p, now %llu", __entry->timer,
+		  (unsigned long long)ktime_to_ns((ktime_t) {
+				  .tv64 = __entry->now }))
+ );
+
+/**
+ * hrtimer_expire_exit - called immediately after the hrtimer callback returns
+ * @timer:	pointer to struct hrtimer
+ *
+ * When used in combination with the hrtimer_expire_entry tracepoint we can
+ * determine the runtime of the callback function.
+ */
+TRACE_EVENT(hrtimer_expire_exit,
+
+	TP_PROTO(struct hrtimer *timer),
+
+	TP_ARGS(timer),
+
+	TP_STRUCT__entry(
+		__field( void *,	timer	)
+	),
+
+	TP_fast_assign(
+		__entry->timer	= timer;
+	),
+
+	TP_printk("hrtimer %p", __entry->timer)
+);
+
+/**
+ * hrtimer_cancel - called when the hrtimer is canceled
+ * @timer:	pointer to struct hrtimer
+ */
+TRACE_EVENT(hrtimer_cancel,
+
+	TP_PROTO(struct hrtimer *timer),
+
+	TP_ARGS(timer),
+
+	TP_STRUCT__entry(
+		__field( void *,	timer	)
+	),
+
+	TP_fast_assign(
+		__entry->timer	= timer;
+	),
+
+	TP_printk("hrtimer %p", __entry->timer)
+);
+
+/**
+ * itimer_state - called when itimer is started or canceled
+ * @which:	name of the interval timer
+ * @value:	the itimers value, itimer is canceled if value->it_value is
+ *		zero, otherwise it is started
+ * @expires:	the itimers expiry time
+ */
+TRACE_EVENT(itimer_state,
+
+	TP_PROTO(int which, const struct itimerval *const value,
+		 cputime_t expires),
+
+	TP_ARGS(which, value, expires),
+
+	TP_STRUCT__entry(
+		__field(	int,		which		)
+		__field(	cputime_t,	expires		)
+		__field(	long,		value_sec	)
+		__field(	long,		value_usec	)
+		__field(	long,		interval_sec	)
+		__field(	long,		interval_usec	)
+	),
+
+	TP_fast_assign(
+		__entry->which		= which;
+		__entry->expires	= expires;
+		__entry->value_sec	= value->it_value.tv_sec;
+		__entry->value_usec	= value->it_value.tv_usec;
+		__entry->interval_sec	= value->it_interval.tv_sec;
+		__entry->interval_usec	= value->it_interval.tv_usec;
+	),
+
+	TP_printk("which %d, expires %lu, it_value %lu.%lu, it_interval %lu.%lu",
+		  __entry->which, __entry->expires,
+		  __entry->value_sec, __entry->value_usec,
+		  __entry->interval_sec, __entry->interval_usec)
+);
+
+/**
+ * itimer_expire - called when itimer expires
+ * @which:	type of the interval timer
+ * @pid:	pid of the process which owns the timer
+ * @now:	current time, used to calculate the latency of itimer
+ */
+TRACE_EVENT(itimer_expire,
+
+	TP_PROTO(int which, struct pid *pid, cputime_t now),
+
+	TP_ARGS(which, pid, now),
+
+	TP_STRUCT__entry(
+		__field( int ,		which	)
+		__field( pid_t,		pid	)
+		__field( cputime_t,	now	)
+	),
+
+	TP_fast_assign(
+		__entry->which	= which;
+		__entry->now	= now;
+		__entry->pid	= pid_nr(pid);
+	),
+
+	    TP_printk("which %d, pid %d, now %lu", __entry->which,
+		      (int) __entry->pid, __entry->now)
+);
+
+#endif /*  _TRACE_TIMER_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/kernel/fork.c b/kernel/fork.c
index 021e113..14cf79f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -62,6 +62,7 @@
 #include <linux/fs_struct.h>
 #include <linux/magic.h>
 #include <linux/perf_counter.h>
+#include <linux/posix-timers.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -790,10 +791,10 @@ static void posix_cpu_timers_init_group(struct signal_struct *sig)
 	thread_group_cputime_init(sig);
 
 	/* Expiration times and increments. */
-	sig->it_virt_expires = cputime_zero;
-	sig->it_virt_incr = cputime_zero;
-	sig->it_prof_expires = cputime_zero;
-	sig->it_prof_incr = cputime_zero;
+	sig->it[CPUCLOCK_PROF].expires = cputime_zero;
+	sig->it[CPUCLOCK_PROF].incr = cputime_zero;
+	sig->it[CPUCLOCK_VIRT].expires = cputime_zero;
+	sig->it[CPUCLOCK_VIRT].incr = cputime_zero;
 
 	/* Cached expiration times. */
 	sig->cputime_expires.prof_exp = cputime_zero;
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index e2f91ec..b44d1b0 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -48,6 +48,8 @@
 
 #include <asm/uaccess.h>
 
+#include <trace/events/timer.h>
+
 /*
  * The timer bases:
  *
@@ -441,6 +443,26 @@ static inline void debug_hrtimer_activate(struct hrtimer *timer) { }
 static inline void debug_hrtimer_deactivate(struct hrtimer *timer) { }
 #endif
 
+static inline void
+debug_init(struct hrtimer *timer, clockid_t clockid,
+	   enum hrtimer_mode mode)
+{
+	debug_hrtimer_init(timer);
+	trace_hrtimer_init(timer, clockid, mode);
+}
+
+static inline void debug_activate(struct hrtimer *timer)
+{
+	debug_hrtimer_activate(timer);
+	trace_hrtimer_start(timer);
+}
+
+static inline void debug_deactivate(struct hrtimer *timer)
+{
+	debug_hrtimer_deactivate(timer);
+	trace_hrtimer_cancel(timer);
+}
+
 /* High resolution timer related functions */
 #ifdef CONFIG_HIGH_RES_TIMERS
 
@@ -797,7 +819,7 @@ static int enqueue_hrtimer(struct hrtimer *timer,
 	struct hrtimer *entry;
 	int leftmost = 1;
 
-	debug_hrtimer_activate(timer);
+	debug_activate(timer);
 
 	/*
 	 * Find the right place in the rbtree:
@@ -883,7 +905,7 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
 		 * reprogramming happens in the interrupt handler. This is a
 		 * rare case and less expensive than a smp call.
 		 */
-		debug_hrtimer_deactivate(timer);
+		debug_deactivate(timer);
 		timer_stats_hrtimer_clear_start_info(timer);
 		reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
 		__remove_hrtimer(timer, base, HRTIMER_STATE_INACTIVE,
@@ -1116,7 +1138,7 @@ static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 void hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 		  enum hrtimer_mode mode)
 {
-	debug_hrtimer_init(timer);
+	debug_init(timer, clock_id, mode);
 	__hrtimer_init(timer, clock_id, mode);
 }
 EXPORT_SYMBOL_GPL(hrtimer_init);
@@ -1140,7 +1162,7 @@ int hrtimer_get_res(const clockid_t which_clock, struct timespec *tp)
 }
 EXPORT_SYMBOL_GPL(hrtimer_get_res);
 
-static void __run_hrtimer(struct hrtimer *timer)
+static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
 {
 	struct hrtimer_clock_base *base = timer->base;
 	struct hrtimer_cpu_base *cpu_base = base->cpu_base;
@@ -1149,7 +1171,7 @@ static void __run_hrtimer(struct hrtimer *timer)
 
 	WARN_ON(!irqs_disabled());
 
-	debug_hrtimer_deactivate(timer);
+	debug_deactivate(timer);
 	__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK, 0);
 	timer_stats_account_hrtimer(timer);
 	fn = timer->function;
@@ -1160,7 +1182,9 @@ static void __run_hrtimer(struct hrtimer *timer)
 	 * the timer base.
 	 */
 	spin_unlock(&cpu_base->lock);
+	trace_hrtimer_expire_entry(timer, now);
 	restart = fn(timer);
+	trace_hrtimer_expire_exit(timer);
 	spin_lock(&cpu_base->lock);
 
 	/*
@@ -1271,7 +1295,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 				break;
 			}
 
-			__run_hrtimer(timer);
+			__run_hrtimer(timer, &basenow);
 		}
 		base++;
 	}
@@ -1393,7 +1417,7 @@ void hrtimer_run_queues(void)
 					hrtimer_get_expires_tv64(timer))
 				break;
 
-			__run_hrtimer(timer);
+			__run_hrtimer(timer, &base->softirq_time);
 		}
 		spin_unlock(&cpu_base->lock);
 	}
@@ -1569,7 +1593,7 @@ static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 	while ((node = rb_first(&old_base->active))) {
 		timer = rb_entry(node, struct hrtimer, node);
 		BUG_ON(hrtimer_callback_running(timer));
-		debug_hrtimer_deactivate(timer);
+		debug_deactivate(timer);
 
 		/*
 		 * Mark it as STATE_MIGRATE not INACTIVE otherwise the
diff --git a/kernel/itimer.c b/kernel/itimer.c
index 58762f7..b03451e 100644
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -12,6 +12,7 @@
 #include <linux/time.h>
 #include <linux/posix-timers.h>
 #include <linux/hrtimer.h>
+#include <trace/events/timer.h>
 
 #include <asm/uaccess.h>
 
@@ -41,10 +42,43 @@ static struct timeval itimer_get_remtime(struct hrtimer *timer)
 	return ktime_to_timeval(rem);
 }
 
+static void get_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
+			   struct itimerval *const value)
+{
+	cputime_t cval, cinterval;
+	struct cpu_itimer *it = &tsk->signal->it[clock_id];
+
+	spin_lock_irq(&tsk->sighand->siglock);
+
+	cval = it->expires;
+	cinterval = it->incr;
+	if (!cputime_eq(cval, cputime_zero)) {
+		struct task_cputime cputime;
+		cputime_t t;
+
+		thread_group_cputimer(tsk, &cputime);
+		if (clock_id == CPUCLOCK_PROF)
+			t = cputime_add(cputime.utime, cputime.stime);
+		else
+			/* CPUCLOCK_VIRT */
+			t = cputime.utime;
+
+		if (cputime_le(cval, t))
+			/* about to fire */
+			cval = cputime_one_jiffy;
+		else
+			cval = cputime_sub(cval, t);
+	}
+
+	spin_unlock_irq(&tsk->sighand->siglock);
+
+	cputime_to_timeval(cval, &value->it_value);
+	cputime_to_timeval(cinterval, &value->it_interval);
+}
+
 int do_getitimer(int which, struct itimerval *value)
 {
 	struct task_struct *tsk = current;
-	cputime_t cinterval, cval;
 
 	switch (which) {
 	case ITIMER_REAL:
@@ -55,44 +89,10 @@ int do_getitimer(int which, struct itimerval *value)
 		spin_unlock_irq(&tsk->sighand->siglock);
 		break;
 	case ITIMER_VIRTUAL:
-		spin_lock_irq(&tsk->sighand->siglock);
-		cval = tsk->signal->it_virt_expires;
-		cinterval = tsk->signal->it_virt_incr;
-		if (!cputime_eq(cval, cputime_zero)) {
-			struct task_cputime cputime;
-			cputime_t utime;
-
-			thread_group_cputimer(tsk, &cputime);
-			utime = cputime.utime;
-			if (cputime_le(cval, utime)) { /* about to fire */
-				cval = jiffies_to_cputime(1);
-			} else {
-				cval = cputime_sub(cval, utime);
-			}
-		}
-		spin_unlock_irq(&tsk->sighand->siglock);
-		cputime_to_timeval(cval, &value->it_value);
-		cputime_to_timeval(cinterval, &value->it_interval);
+		get_cpu_itimer(tsk, CPUCLOCK_VIRT, value);
 		break;
 	case ITIMER_PROF:
-		spin_lock_irq(&tsk->sighand->siglock);
-		cval = tsk->signal->it_prof_expires;
-		cinterval = tsk->signal->it_prof_incr;
-		if (!cputime_eq(cval, cputime_zero)) {
-			struct task_cputime times;
-			cputime_t ptime;
-
-			thread_group_cputimer(tsk, &times);
-			ptime = cputime_add(times.utime, times.stime);
-			if (cputime_le(cval, ptime)) { /* about to fire */
-				cval = jiffies_to_cputime(1);
-			} else {
-				cval = cputime_sub(cval, ptime);
-			}
-		}
-		spin_unlock_irq(&tsk->sighand->siglock);
-		cputime_to_timeval(cval, &value->it_value);
-		cputime_to_timeval(cinterval, &value->it_interval);
+		get_cpu_itimer(tsk, CPUCLOCK_PROF, value);
 		break;
 	default:
 		return(-EINVAL);
@@ -123,11 +123,62 @@ enum hrtimer_restart it_real_fn(struct hrtimer *timer)
 	struct signal_struct *sig =
 		container_of(timer, struct signal_struct, real_timer);
 
+	trace_itimer_expire(ITIMER_REAL, sig->leader_pid, 0);
 	kill_pid_info(SIGALRM, SEND_SIG_PRIV, sig->leader_pid);
 
 	return HRTIMER_NORESTART;
 }
 
+static inline u32 cputime_sub_ns(cputime_t ct, s64 real_ns)
+{
+	struct timespec ts;
+	s64 cpu_ns;
+
+	cputime_to_timespec(ct, &ts);
+	cpu_ns = timespec_to_ns(&ts);
+
+	return (cpu_ns <= real_ns) ? 0 : cpu_ns - real_ns;
+}
+
+static void set_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
+			   const struct itimerval *const value,
+			   struct itimerval *const ovalue)
+{
+	cputime_t cval, nval, cinterval, ninterval;
+	s64 ns_ninterval, ns_nval;
+	struct cpu_itimer *it = &tsk->signal->it[clock_id];
+
+	nval = timeval_to_cputime(&value->it_value);
+	ns_nval = timeval_to_ns(&value->it_value);
+	ninterval = timeval_to_cputime(&value->it_interval);
+	ns_ninterval = timeval_to_ns(&value->it_interval);
+
+	it->incr_error = cputime_sub_ns(ninterval, ns_ninterval);
+	it->error = cputime_sub_ns(nval, ns_nval);
+
+	spin_lock_irq(&tsk->sighand->siglock);
+
+	cval = it->expires;
+	cinterval = it->incr;
+	if (!cputime_eq(cval, cputime_zero) ||
+	    !cputime_eq(nval, cputime_zero)) {
+		if (cputime_gt(nval, cputime_zero))
+			nval = cputime_add(nval, cputime_one_jiffy);
+		set_process_cpu_timer(tsk, clock_id, &nval, &cval);
+	}
+	it->expires = nval;
+	it->incr = ninterval;
+	trace_itimer_state(clock_id == CPUCLOCK_VIRT ?
+			   ITIMER_VIRTUAL : ITIMER_PROF, value, nval);
+
+	spin_unlock_irq(&tsk->sighand->siglock);
+
+	if (ovalue) {
+		cputime_to_timeval(cval, &ovalue->it_value);
+		cputime_to_timeval(cinterval, &ovalue->it_interval);
+	}
+}
+
 /*
  * Returns true if the timeval is in canonical form
  */
@@ -139,7 +190,6 @@ int do_setitimer(int which, struct itimerval *value, struct itimerval *ovalue)
 	struct task_struct *tsk = current;
 	struct hrtimer *timer;
 	ktime_t expires;
-	cputime_t cval, cinterval, nval, ninterval;
 
 	/*
 	 * Validate the timevals in value.
@@ -171,51 +221,14 @@ again:
 		} else
 			tsk->signal->it_real_incr.tv64 = 0;
 
+		trace_itimer_state(ITIMER_REAL, value, 0);
 		spin_unlock_irq(&tsk->sighand->siglock);
 		break;
 	case ITIMER_VIRTUAL:
-		nval = timeval_to_cputime(&value->it_value);
-		ninterval = timeval_to_cputime(&value->it_interval);
-		spin_lock_irq(&tsk->sighand->siglock);
-		cval = tsk->signal->it_virt_expires;
-		cinterval = tsk->signal->it_virt_incr;
-		if (!cputime_eq(cval, cputime_zero) ||
-		    !cputime_eq(nval, cputime_zero)) {
-			if (cputime_gt(nval, cputime_zero))
-				nval = cputime_add(nval,
-						   jiffies_to_cputime(1));
-			set_process_cpu_timer(tsk, CPUCLOCK_VIRT,
-					      &nval, &cval);
-		}
-		tsk->signal->it_virt_expires = nval;
-		tsk->signal->it_virt_incr = ninterval;
-		spin_unlock_irq(&tsk->sighand->siglock);
-		if (ovalue) {
-			cputime_to_timeval(cval, &ovalue->it_value);
-			cputime_to_timeval(cinterval, &ovalue->it_interval);
-		}
+		set_cpu_itimer(tsk, CPUCLOCK_VIRT, value, ovalue);
 		break;
 	case ITIMER_PROF:
-		nval = timeval_to_cputime(&value->it_value);
-		ninterval = timeval_to_cputime(&value->it_interval);
-		spin_lock_irq(&tsk->sighand->siglock);
-		cval = tsk->signal->it_prof_expires;
-		cinterval = tsk->signal->it_prof_incr;
-		if (!cputime_eq(cval, cputime_zero) ||
-		    !cputime_eq(nval, cputime_zero)) {
-			if (cputime_gt(nval, cputime_zero))
-				nval = cputime_add(nval,
-						   jiffies_to_cputime(1));
-			set_process_cpu_timer(tsk, CPUCLOCK_PROF,
-					      &nval, &cval);
-		}
-		tsk->signal->it_prof_expires = nval;
-		tsk->signal->it_prof_incr = ninterval;
-		spin_unlock_irq(&tsk->sighand->siglock);
-		if (ovalue) {
-			cputime_to_timeval(cval, &ovalue->it_value);
-			cputime_to_timeval(cinterval, &ovalue->it_interval);
-		}
+		set_cpu_itimer(tsk, CPUCLOCK_PROF, value, ovalue);
 		break;
 	default:
 		return -EINVAL;
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index e33a21c..5c9dc22 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -8,17 +8,18 @@
 #include <linux/math64.h>
 #include <asm/uaccess.h>
 #include <linux/kernel_stat.h>
+#include <trace/events/timer.h>
 
 /*
  * Called after updating RLIMIT_CPU to set timer expiration if necessary.
  */
 void update_rlimit_cpu(unsigned long rlim_new)
 {
-	cputime_t cputime;
+	cputime_t cputime = secs_to_cputime(rlim_new);
+	struct signal_struct *const sig = current->signal;
 
-	cputime = secs_to_cputime(rlim_new);
-	if (cputime_eq(current->signal->it_prof_expires, cputime_zero) ||
-	    cputime_gt(current->signal->it_prof_expires, cputime)) {
+	if (cputime_eq(sig->it[CPUCLOCK_PROF].expires, cputime_zero) ||
+	    cputime_gt(sig->it[CPUCLOCK_PROF].expires, cputime)) {
 		spin_lock_irq(&current->sighand->siglock);
 		set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
 		spin_unlock_irq(&current->sighand->siglock);
@@ -542,6 +543,17 @@ static void clear_dead_task(struct k_itimer *timer, union cpu_time_count now)
 					     now);
 }
 
+static inline int expires_gt(cputime_t expires, cputime_t new_exp)
+{
+	return cputime_eq(expires, cputime_zero) ||
+	       cputime_gt(expires, new_exp);
+}
+
+static inline int expires_le(cputime_t expires, cputime_t new_exp)
+{
+	return !cputime_eq(expires, cputime_zero) &&
+	       cputime_le(expires, new_exp);
+}
 /*
  * Insert the timer on the appropriate list before any timers that
  * expire later.  This must be called with the tasklist_lock held
@@ -586,34 +598,32 @@ static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
 		 */
 
 		if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
+			union cpu_time_count *exp = &nt->expires;
+
 			switch (CPUCLOCK_WHICH(timer->it_clock)) {
 			default:
 				BUG();
 			case CPUCLOCK_PROF:
-				if (cputime_eq(p->cputime_expires.prof_exp,
-					       cputime_zero) ||
-				    cputime_gt(p->cputime_expires.prof_exp,
-					       nt->expires.cpu))
-					p->cputime_expires.prof_exp =
-						nt->expires.cpu;
+				if (expires_gt(p->cputime_expires.prof_exp,
+					       exp->cpu))
+					p->cputime_expires.prof_exp = exp->cpu;
 				break;
 			case CPUCLOCK_VIRT:
-				if (cputime_eq(p->cputime_expires.virt_exp,
-					       cputime_zero) ||
-				    cputime_gt(p->cputime_expires.virt_exp,
-					       nt->expires.cpu))
-					p->cputime_expires.virt_exp =
-						nt->expires.cpu;
+				if (expires_gt(p->cputime_expires.virt_exp,
+					       exp->cpu))
+					p->cputime_expires.virt_exp = exp->cpu;
 				break;
 			case CPUCLOCK_SCHED:
 				if (p->cputime_expires.sched_exp == 0 ||
-				    p->cputime_expires.sched_exp >
-							nt->expires.sched)
+				    p->cputime_expires.sched_exp > exp->sched)
 					p->cputime_expires.sched_exp =
-						nt->expires.sched;
+								exp->sched;
 				break;
 			}
 		} else {
+			struct signal_struct *const sig = p->signal;
+			union cpu_time_count *exp = &timer->it.cpu.expires;
+
 			/*
 			 * For a process timer, set the cached expiration time.
 			 */
@@ -621,30 +631,23 @@ static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
 			default:
 				BUG();
 			case CPUCLOCK_VIRT:
-				if (!cputime_eq(p->signal->it_virt_expires,
-						cputime_zero) &&
-				    cputime_lt(p->signal->it_virt_expires,
-					       timer->it.cpu.expires.cpu))
+				if (expires_le(sig->it[CPUCLOCK_VIRT].expires,
+					       exp->cpu))
 					break;
-				p->signal->cputime_expires.virt_exp =
-					timer->it.cpu.expires.cpu;
+				sig->cputime_expires.virt_exp = exp->cpu;
 				break;
 			case CPUCLOCK_PROF:
-				if (!cputime_eq(p->signal->it_prof_expires,
-						cputime_zero) &&
-				    cputime_lt(p->signal->it_prof_expires,
-					       timer->it.cpu.expires.cpu))
+				if (expires_le(sig->it[CPUCLOCK_PROF].expires,
+					       exp->cpu))
 					break;
-				i = p->signal->rlim[RLIMIT_CPU].rlim_cur;
+				i = sig->rlim[RLIMIT_CPU].rlim_cur;
 				if (i != RLIM_INFINITY &&
-				    i <= cputime_to_secs(timer->it.cpu.expires.cpu))
+				    i <= cputime_to_secs(exp->cpu))
 					break;
-				p->signal->cputime_expires.prof_exp =
-					timer->it.cpu.expires.cpu;
+				sig->cputime_expires.prof_exp = exp->cpu;
 				break;
 			case CPUCLOCK_SCHED:
-				p->signal->cputime_expires.sched_exp =
-					timer->it.cpu.expires.sched;
+				sig->cputime_expires.sched_exp = exp->sched;
 				break;
 			}
 		}
@@ -1071,6 +1074,40 @@ static void stop_process_timers(struct task_struct *tsk)
 	spin_unlock_irqrestore(&cputimer->lock, flags);
 }
 
+static u32 onecputick;
+
+static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
+			     cputime_t *expires, cputime_t cur_time, int signo)
+{
+	if (cputime_eq(it->expires, cputime_zero))
+		return;
+
+	if (cputime_ge(cur_time, it->expires)) {
+		if (!cputime_eq(it->incr, cputime_zero)) {
+			it->expires = cputime_add(it->expires, it->incr);
+			it->error += it->incr_error;
+			if (it->error >= onecputick) {
+				it->expires = cputime_sub(it->expires,
+							  cputime_one_jiffy);
+				it->error -= onecputick;
+			}
+		} else {
+			it->expires = cputime_zero;
+		}
+
+		trace_itimer_expire(signo == SIGPROF ?
+				    ITIMER_PROF : ITIMER_VIRTUAL,
+				    tsk->signal->leader_pid, cur_time);
+		__group_send_sig_info(signo, SEND_SIG_PRIV, tsk);
+	}
+
+	if (!cputime_eq(it->expires, cputime_zero) &&
+	    (cputime_eq(*expires, cputime_zero) ||
+	     cputime_lt(it->expires, *expires))) {
+		*expires = it->expires;
+	}
+}
+
 /*
  * Check for any per-thread CPU timers that have fired and move them
  * off the tsk->*_timers list onto the firing list.  Per-thread timers
@@ -1090,10 +1127,10 @@ static void check_process_timers(struct task_struct *tsk,
 	 * Don't sample the current process CPU clocks if there are no timers.
 	 */
 	if (list_empty(&timers[CPUCLOCK_PROF]) &&
-	    cputime_eq(sig->it_prof_expires, cputime_zero) &&
+	    cputime_eq(sig->it[CPUCLOCK_PROF].expires, cputime_zero) &&
 	    sig->rlim[RLIMIT_CPU].rlim_cur == RLIM_INFINITY &&
 	    list_empty(&timers[CPUCLOCK_VIRT]) &&
-	    cputime_eq(sig->it_virt_expires, cputime_zero) &&
+	    cputime_eq(sig->it[CPUCLOCK_VIRT].expires, cputime_zero) &&
 	    list_empty(&timers[CPUCLOCK_SCHED])) {
 		stop_process_timers(tsk);
 		return;
@@ -1153,38 +1190,11 @@ static void check_process_timers(struct task_struct *tsk,
 	/*
 	 * Check for the special case process timers.
 	 */
-	if (!cputime_eq(sig->it_prof_expires, cputime_zero)) {
-		if (cputime_ge(ptime, sig->it_prof_expires)) {
-			/* ITIMER_PROF fires and reloads.  */
-			sig->it_prof_expires = sig->it_prof_incr;
-			if (!cputime_eq(sig->it_prof_expires, cputime_zero)) {
-				sig->it_prof_expires = cputime_add(
-					sig->it_prof_expires, ptime);
-			}
-			__group_send_sig_info(SIGPROF, SEND_SIG_PRIV, tsk);
-		}
-		if (!cputime_eq(sig->it_prof_expires, cputime_zero) &&
-		    (cputime_eq(prof_expires, cputime_zero) ||
-		     cputime_lt(sig->it_prof_expires, prof_expires))) {
-			prof_expires = sig->it_prof_expires;
-		}
-	}
-	if (!cputime_eq(sig->it_virt_expires, cputime_zero)) {
-		if (cputime_ge(utime, sig->it_virt_expires)) {
-			/* ITIMER_VIRTUAL fires and reloads.  */
-			sig->it_virt_expires = sig->it_virt_incr;
-			if (!cputime_eq(sig->it_virt_expires, cputime_zero)) {
-				sig->it_virt_expires = cputime_add(
-					sig->it_virt_expires, utime);
-			}
-			__group_send_sig_info(SIGVTALRM, SEND_SIG_PRIV, tsk);
-		}
-		if (!cputime_eq(sig->it_virt_expires, cputime_zero) &&
-		    (cputime_eq(virt_expires, cputime_zero) ||
-		     cputime_lt(sig->it_virt_expires, virt_expires))) {
-			virt_expires = sig->it_virt_expires;
-		}
-	}
+	check_cpu_itimer(tsk, &sig->it[CPUCLOCK_PROF], &prof_expires, ptime,
+			 SIGPROF);
+	check_cpu_itimer(tsk, &sig->it[CPUCLOCK_VIRT], &virt_expires, utime,
+			 SIGVTALRM);
+
 	if (sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
 		unsigned long psecs = cputime_to_secs(ptime);
 		cputime_t x;
@@ -1457,7 +1467,7 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 		if (!cputime_eq(*oldval, cputime_zero)) {
 			if (cputime_le(*oldval, now.cpu)) {
 				/* Just about to fire. */
-				*oldval = jiffies_to_cputime(1);
+				*oldval = cputime_one_jiffy;
 			} else {
 				*oldval = cputime_sub(*oldval, now.cpu);
 			}
@@ -1703,10 +1713,15 @@ static __init int init_posix_cpu_timers(void)
 		.nsleep = thread_cpu_nsleep,
 		.nsleep_restart = thread_cpu_nsleep_restart,
 	};
+	struct timespec ts;
 
 	register_posix_clock(CLOCK_PROCESS_CPUTIME_ID, &process);
 	register_posix_clock(CLOCK_THREAD_CPUTIME_ID, &thread);
 
+	cputime_to_timespec(cputime_one_jiffy, &ts);
+	onecputick = ts.tv_nsec;
+	WARN_ON(ts.tv_sec != 0);
+
 	return 0;
 }
 __initcall(init_posix_cpu_timers);
diff --git a/kernel/sched.c b/kernel/sched.c
index 1b59e26..8f977d5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5031,17 +5031,16 @@ void account_idle_time(cputime_t cputime)
  */
 void account_process_tick(struct task_struct *p, int user_tick)
 {
-	cputime_t one_jiffy = jiffies_to_cputime(1);
-	cputime_t one_jiffy_scaled = cputime_to_scaled(one_jiffy);
+	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
 	struct rq *rq = this_rq();
 
 	if (user_tick)
-		account_user_time(p, one_jiffy, one_jiffy_scaled);
+		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
 	else if ((p != rq->idle) || (irq_count() != HARDIRQ_OFFSET))
-		account_system_time(p, HARDIRQ_OFFSET, one_jiffy,
+		account_system_time(p, HARDIRQ_OFFSET, cputime_one_jiffy,
 				    one_jiffy_scaled);
 	else
-		account_idle_time(one_jiffy);
+		account_idle_time(cputime_one_jiffy);
 }
 
 /*
diff --git a/kernel/timer.c b/kernel/timer.c
index 8e92be6..a7352b0 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -46,6 +46,9 @@
 #include <asm/timex.h>
 #include <asm/io.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/timer.h>
+
 u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
 
 EXPORT_SYMBOL(jiffies_64);
@@ -521,6 +524,25 @@ static inline void debug_timer_activate(struct timer_list *timer) { }
 static inline void debug_timer_deactivate(struct timer_list *timer) { }
 #endif
 
+static inline void debug_init(struct timer_list *timer)
+{
+	debug_timer_init(timer);
+	trace_timer_init(timer);
+}
+
+static inline void
+debug_activate(struct timer_list *timer, unsigned long expires)
+{
+	debug_timer_activate(timer);
+	trace_timer_start(timer, expires);
+}
+
+static inline void debug_deactivate(struct timer_list *timer)
+{
+	debug_timer_deactivate(timer);
+	trace_timer_cancel(timer);
+}
+
 static void __init_timer(struct timer_list *timer,
 			 const char *name,
 			 struct lock_class_key *key)
@@ -549,7 +571,7 @@ void init_timer_key(struct timer_list *timer,
 		    const char *name,
 		    struct lock_class_key *key)
 {
-	debug_timer_init(timer);
+	debug_init(timer);
 	__init_timer(timer, name, key);
 }
 EXPORT_SYMBOL(init_timer_key);
@@ -568,7 +590,7 @@ static inline void detach_timer(struct timer_list *timer,
 {
 	struct list_head *entry = &timer->entry;
 
-	debug_timer_deactivate(timer);
+	debug_deactivate(timer);
 
 	__list_del(entry->prev, entry->next);
 	if (clear_pending)
@@ -632,7 +654,7 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 			goto out_unlock;
 	}
 
-	debug_timer_activate(timer);
+	debug_activate(timer, expires);
 
 	new_base = __get_cpu_var(tvec_bases);
 
@@ -787,7 +809,7 @@ void add_timer_on(struct timer_list *timer, int cpu)
 	BUG_ON(timer_pending(timer) || !timer->function);
 	spin_lock_irqsave(&base->lock, flags);
 	timer_set_base(timer, base);
-	debug_timer_activate(timer);
+	debug_activate(timer, timer->expires);
 	if (time_before(timer->expires, base->next_timer) &&
 	    !tbase_get_deferrable(timer->base))
 		base->next_timer = timer->expires;
@@ -1000,7 +1022,9 @@ static inline void __run_timers(struct tvec_base *base)
 				 */
 				lock_map_acquire(&lockdep_map);
 
+				trace_timer_expire_entry(timer);
 				fn(data);
+				trace_timer_expire_exit(timer);
 
 				lock_map_release(&lockdep_map);
 
