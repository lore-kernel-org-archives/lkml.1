Return-Path: <linux-kernel-owner+w=401wt.eu-S1757156AbXJXGzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbXJXGzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 02:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbXJXGzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 02:55:05 -0400
Received: from ozlabs.org ([203.10.76.45]:60002 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495AbXJXGzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 02:55:03 -0400
From: Michael Neuling <mikey@neuling.org>
To: paulus@samba.org, akpm@linux-foundation.org, linux390@de.ibm.com
cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-s390@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>
X-GPG-Fingerprint: 9B25 DC2A C58D 2C8D 47C2  457E 0887 E86F 32E6 BE16
MIME-Version: 1.0
Subject: [PATCH] taskstats scaled time cleanup
X-Mailer: MH-E 8.0.3; nmh 1.2; GNU Emacs 21.4.1
Date: Wed, 24 Oct 2007 16:54:57 +1000
Message-ID: <8789.1193208897@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the ability to scale cputime into generic code.  This
allows us to fix the issue in kernel/timer.c (noticed by Balbir) where
we could only add an unscaled value to the scaled utime/stime.

This adds a cputime_to_scaled function.  As before, the POWERPC
version does the scaling based on the last SPURR/PURR ratio
calculated.  The generic and s390 (only other arch to implement
asm/cputime.h) versions are both NOPs.

Also moves the SPURR and PURR snapshots closer.

Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 arch/powerpc/kernel/time.c    |   14 +++++++-------
 include/asm-generic/cputime.h |    1 +
 include/asm-powerpc/cputime.h |   14 ++++++++++++++
 include/asm-powerpc/paca.h    |    2 --
 include/asm-s390/cputime.h    |    1 +
 kernel/timer.c                |    9 +++++----
 6 files changed, 28 insertions(+), 13 deletions(-)

Index: linux-2.6-ozlabs/arch/powerpc/kernel/time.c
===================================================================
--- linux-2.6-ozlabs.orig/arch/powerpc/kernel/time.c
+++ linux-2.6-ozlabs/arch/powerpc/kernel/time.c
@@ -66,6 +66,7 @@
 #include <asm/smp.h>
 #include <asm/vdso_datapage.h>
 #include <asm/firmware.h>
+#include <asm/cputime.h>
 #ifdef CONFIG_PPC_ISERIES
 #include <asm/iseries/it_lp_queue.h>
 #include <asm/iseries/hv_call_xm.h>
@@ -186,6 +187,8 @@ u64 __cputime_sec_factor;
 EXPORT_SYMBOL(__cputime_sec_factor);
 u64 __cputime_clockt_factor;
 EXPORT_SYMBOL(__cputime_clockt_factor);
+DEFINE_PER_CPU(unsigned long, cputime_last_delta);
+DEFINE_PER_CPU(unsigned long, cputime_scaled_last_delta);
 
 static void calc_cputime_factors(void)
 {
@@ -232,9 +235,9 @@ void account_system_vtime(struct task_st
 
 	local_irq_save(flags);
 	now = read_purr();
+	nowscaled = read_spurr(now);
 	delta = now - get_paca()->startpurr;
 	get_paca()->startpurr = now;
-	nowscaled = read_spurr(now);
 	deltascaled = nowscaled - get_paca()->startspurr;
 	get_paca()->startspurr = nowscaled;
 	if (!in_interrupt()) {
@@ -247,9 +250,9 @@ void account_system_vtime(struct task_st
 		get_paca()->system_time = 0;
 	}
 	account_system_time(tsk, 0, delta);
-	get_paca()->purrdelta = delta;
+	per_cpu(cputime_last_delta, smp_processor_id()) = delta;
 	account_system_time_scaled(tsk, deltascaled);
-	get_paca()->spurrdelta = deltascaled;
+	per_cpu(cputime_scaled_last_delta, smp_processor_id()) = deltascaled;
 	local_irq_restore(flags);
 }
 
@@ -267,10 +270,7 @@ void account_process_vtime(struct task_s
 	get_paca()->user_time = 0;
 	account_user_time(tsk, utime);
 
-	/* Estimate the scaled utime by scaling the real utime based
-	 * on the last spurr to purr ratio */
-	utimescaled = utime * get_paca()->spurrdelta / get_paca()->purrdelta;
-	get_paca()->spurrdelta = get_paca()->purrdelta = 0;
+	utimescaled = cputime_to_scaled(utime);
 	account_user_time_scaled(tsk, utimescaled);
 }
 
Index: linux-2.6-ozlabs/include/asm-generic/cputime.h
===================================================================
--- linux-2.6-ozlabs.orig/include/asm-generic/cputime.h
+++ linux-2.6-ozlabs/include/asm-generic/cputime.h
@@ -18,6 +18,7 @@ typedef unsigned long cputime_t;
 #define cputime_lt(__a, __b)		((__a) <  (__b))
 #define cputime_le(__a, __b)		((__a) <= (__b))
 #define cputime_to_jiffies(__ct)	(__ct)
+#define cputime_to_scaled(__ct)		(__ct)
 #define jiffies_to_cputime(__hz)	(__hz)
 
 typedef u64 cputime64_t;
Index: linux-2.6-ozlabs/include/asm-powerpc/cputime.h
===================================================================
--- linux-2.6-ozlabs.orig/include/asm-powerpc/cputime.h
+++ linux-2.6-ozlabs/include/asm-powerpc/cputime.h
@@ -52,12 +52,26 @@ typedef u64 cputime64_t;
  * Convert cputime <-> jiffies
  */
 extern u64 __cputime_jiffies_factor;
+DECLARE_PER_CPU(unsigned long, cputime_last_delta);
+DECLARE_PER_CPU(unsigned long, cputime_scaled_last_delta);
 
 static inline unsigned long cputime_to_jiffies(const cputime_t ct)
 {
 	return mulhdu(ct, __cputime_jiffies_factor);
 }
 
+/* Estimate the scaled cputime by scaling the real cputime based on
+ * the last scaled to real ratio */
+static inline cputime_t cputime_to_scaled(const cputime_t ct)
+{
+	if (cpu_has_feature(CPU_FTR_SPURR) &&
+	    per_cpu(cputime_last_delta, smp_processor_id()))
+		return ct *
+			per_cpu(cputime_scaled_last_delta, smp_processor_id())/
+			per_cpu(cputime_last_delta, smp_processor_id());
+	return ct;
+}
+
 static inline cputime_t jiffies_to_cputime(const unsigned long jif)
 {
 	cputime_t ct;
Index: linux-2.6-ozlabs/include/asm-powerpc/paca.h
===================================================================
--- linux-2.6-ozlabs.orig/include/asm-powerpc/paca.h
+++ linux-2.6-ozlabs/include/asm-powerpc/paca.h
@@ -115,8 +115,6 @@ struct paca_struct {
 	u64 system_time;		/* accumulated system TB ticks */
 	u64 startpurr;			/* PURR/TB value snapshot */
 	u64 startspurr;			/* SPURR value snapshot */
-	u64 purrdelta;			/* FIXME: document */
-	u64 spurrdelta;			/* FIXME: document */
 };
 
 extern struct paca_struct paca[];
Index: linux-2.6-ozlabs/include/asm-s390/cputime.h
===================================================================
--- linux-2.6-ozlabs.orig/include/asm-s390/cputime.h
+++ linux-2.6-ozlabs/include/asm-s390/cputime.h
@@ -54,6 +54,7 @@ __div(unsigned long long n, unsigned int
 #define cputime_lt(__a, __b)		((__a) <  (__b))
 #define cputime_le(__a, __b)		((__a) <= (__b))
 #define cputime_to_jiffies(__ct)	(__div((__ct), 1000000 / HZ))
+#define cputime_to_scaled(__ct)		(__ct)
 #define jiffies_to_cputime(__hz)	((cputime_t)(__hz) * (1000000 / HZ))
 
 #define cputime64_zero			(0ULL)
Index: linux-2.6-ozlabs/kernel/timer.c
===================================================================
--- linux-2.6-ozlabs.orig/kernel/timer.c
+++ linux-2.6-ozlabs/kernel/timer.c
@@ -825,14 +825,15 @@ void update_process_times(int user_tick)
 {
 	struct task_struct *p = current;
 	int cpu = smp_processor_id();
+	cputime_t one_jiffy = jiffies_to_cputime(1);
 
 	/* Note: this timer irq context must be accounted for as well. */
 	if (user_tick) {
-		account_user_time(p, jiffies_to_cputime(1));
-		account_user_time_scaled(p, jiffies_to_cputime(1));
+		account_user_time(p, one_jiffy);
+		account_user_time_scaled(p, cputime_to_scaled(one_jiffy));
 	} else {
-		account_system_time(p, HARDIRQ_OFFSET, jiffies_to_cputime(1));
-		account_system_time_scaled(p, jiffies_to_cputime(1));
+		account_system_time(p, HARDIRQ_OFFSET, one_jiffy);
+		account_system_time_scaled(p, cputime_to_scaled(one_jiffy));
 	}
 	run_local_timers();
 	if (rcu_pending(cpu))
