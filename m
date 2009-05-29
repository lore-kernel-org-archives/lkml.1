Return-Path: <linux-kernel-owner+w=401wt.eu-S1758966AbZE2L0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966AbZE2L0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 07:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758823AbZE2L0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 07:26:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44040 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758795AbZE2L0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 07:26:34 -0400
Date: Fri, 29 May 2009 13:19:48 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH resend5 4/4] cputime: optimize jiffies_to_cputime(1)
Message-ID: <20090529131948.36174118@dhcp-lab-109.englab.brq.redhat.com>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For powerpc with CONFIG_VIRT_CPU_ACCOUNTING jiffies_to_cputime(1) is not
compile time constant and run time calculations are quite expensive. To
optimize we use precomputed value. For all other architectures is is
preprocessor definition.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
This patch (with 3 previous) was compiled on x86, x86_64, ppc with
CONFIG_VIRT_CPU_ACCOUNTNG=n, ppc64 with CONFIG_VIRT_CPU_ACCOUNTING=y.
Run time testing was done only on x86.

 arch/ia64/include/asm/cputime.h    |    1 +
 arch/powerpc/include/asm/cputime.h |   13 +++++++++++++
 arch/powerpc/kernel/time.c         |    4 ++++
 arch/s390/include/asm/cputime.h    |    1 +
 include/asm-generic/cputime.h      |    1 +
 kernel/itimer.c                    |    4 ++--
 kernel/posix-cpu-timers.c          |    6 +++---
 kernel/sched.c                     |    9 ++++-----
 8 files changed, 29 insertions(+), 10 deletions(-)

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
index 48571ac..8549edc 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -191,6 +191,8 @@ EXPORT_SYMBOL(__cputime_clockt_factor);
 DEFINE_PER_CPU(unsigned long, cputime_last_delta);
 DEFINE_PER_CPU(unsigned long, cputime_scaled_last_delta);
 
+cputime_t cputime_one_jiffy;
+
 static void calc_cputime_factors(void)
 {
 	struct div_result res;
@@ -498,6 +500,7 @@ static int __init iSeries_tb_recal(void)
 				tb_to_xs = divres.result_low;
 				vdso_data->tb_ticks_per_sec = tb_ticks_per_sec;
 				vdso_data->tb_to_xs = tb_to_xs;
+				setup_cputime_one_jiffy();
 			}
 			else {
 				printk( "Titan recalibrate: FAILED (difference > 4 percent)\n"
@@ -904,6 +907,7 @@ void __init time_init(void)
 	tb_ticks_per_usec = ppc_tb_freq / 1000000;
 	tb_to_us = mulhwu_scale_factor(ppc_tb_freq, 1000000);
 	calc_cputime_factors();
+	setup_cputime_one_jiffy();
 
 	/*
 	 * Calculate the length of each tick in ns.  It will not be
diff --git a/arch/s390/include/asm/cputime.h b/arch/s390/include/asm/cputime.h
index 941384f..ea52754 100644
--- a/arch/s390/include/asm/cputime.h
+++ b/arch/s390/include/asm/cputime.h
@@ -39,6 +39,7 @@ __div(unsigned long long n, unsigned int base)
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
diff --git a/kernel/itimer.c b/kernel/itimer.c
index 21adff7..8078a32 100644
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -64,7 +64,7 @@ static void get_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
 
 		if (cputime_le(cval, t))
 			/* about to fire */
-			cval = jiffies_to_cputime(1);
+			cval = cputime_one_jiffy;
 		else
 			cval = cputime_sub(cval, t);
 	}
@@ -161,7 +161,7 @@ static void set_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
 	if (!cputime_eq(cval, cputime_zero) ||
 	    !cputime_eq(nval, cputime_zero)) {
 		if (cputime_gt(nval, cputime_zero))
-			nval = cputime_add(nval, jiffies_to_cputime(1));
+			nval = cputime_add(nval, cputime_one_jiffy);
 		set_process_cpu_timer(tsk, clock_id, &nval, &cval);
 	}
 	it->expires = nval;
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 69c9237..18bdde6 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1086,7 +1086,7 @@ static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
 			it->error += it->incr_error;
 			if (it->error >= onecputick) {
 				it->expires = cputime_sub(it->expires,
-							jiffies_to_cputime(1));
+							  cputime_one_jiffy);
 				it->error -= onecputick;
 			}
 		} else
@@ -1461,7 +1461,7 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 		if (!cputime_eq(*oldval, cputime_zero)) {
 			if (cputime_le(*oldval, now.cpu)) {
 				/* Just about to fire. */
-				*oldval = jiffies_to_cputime(1);
+				*oldval = cputime_one_jiffy;
 			} else {
 				*oldval = cputime_sub(*oldval, now.cpu);
 			}
@@ -1712,7 +1712,7 @@ static __init int init_posix_cpu_timers(void)
 	register_posix_clock(CLOCK_PROCESS_CPUTIME_ID, &process);
 	register_posix_clock(CLOCK_THREAD_CPUTIME_ID, &thread);
 
-	cputime_to_timespec(jiffies_to_cputime(1), &ts);
+	cputime_to_timespec(cputime_one_jiffy, &ts);
 	onecputick = ts.tv_nsec;
 	WARN_ON(ts.tv_sec != 0);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 26efa47..954803e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4726,17 +4726,16 @@ void account_idle_time(cputime_t cputime)
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
-- 
1.5.5.6

