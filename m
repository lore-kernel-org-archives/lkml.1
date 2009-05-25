Return-Path: <linux-kernel-owner+w=401wt.eu-S1751279AbZEYLfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751279AbZEYLfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 07:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbZEYLfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 07:35:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44363 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbZEYLfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 07:35:14 -0400
Date: Mon, 25 May 2009 13:28:14 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH resend4 2/3] itimers: fix periodic tics precision
Message-ID: <20090525132814.442877e5@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <alpine.LFD.2.00.0905221611380.3570@localhost.localdomain>
References: <20090522154339.06d30f0a@dhcp-lab-109.englab.brq.redhat.com>
	<alpine.LFD.2.00.0905221611380.3570@localhost.localdomain>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(linuxppc-dev CC added)

On Fri, 22 May 2009 16:27:40 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> >  	if (cputime_ge(cur_time, it->expires)) {
> > -		it->expires = it->incr;
> > -		if (!cputime_eq(it->expires, cputime_zero))
> > -			it->expires = cputime_add(it->expires, cur_time);
> > +		if (!cputime_eq(it->incr, cputime_zero)) {
> > +			it->expires = cputime_add(it->expires, it->incr);
> > +			it->error += it->incr_error;
> > +			if (it->error >= onecputick) {
> > +				it->expires = cputime_sub(it->expires,
> > +							jiffies_to_cputime(1));
> > +				it->error -= onecputick;
> > +			}
> 
>   Yep, that's a sane solution except for jiffies_to_cputime(), which
>   can be precomputed as well.

I think precomputed is only needed for PPC where jiffies_to_cputime(1) is not
compile time constant. To not affect other architectures, I wrote a patch with
cputime_one value, it is global variable for PPC and preprocessor definition
for others. This patch is against current Linus' tree. I send it as RFC, it
was only compile tested for x86.

diff --git a/arch/ia64/include/asm/cputime.h b/arch/ia64/include/asm/cputime.h
index d20b998..df88b07 100644
--- a/arch/ia64/include/asm/cputime.h
+++ b/arch/ia64/include/asm/cputime.h
@@ -30,6 +30,7 @@ typedef u64 cputime_t;
 typedef u64 cputime64_t;
 
 #define cputime_zero			((cputime_t)0)
+#define cputime_one			jiffies_to_cputime(1)
 #define cputime_max			((~((cputime_t)0) >> 1) - 1)
 #define cputime_add(__a, __b)		((__a) +  (__b))
 #define cputime_sub(__a, __b)		((__a) -  (__b))
diff --git a/arch/powerpc/include/asm/cputime.h b/arch/powerpc/include/asm/cputime.h
index f42e623..e57f951 100644
--- a/arch/powerpc/include/asm/cputime.h
+++ b/arch/powerpc/include/asm/cputime.h
@@ -48,6 +48,8 @@ typedef u64 cputime64_t;
 
 #ifdef __KERNEL__
 
+extern cputime_t cputime_one;
+
 /*
  * Convert cputime <-> jiffies
  */
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 48571ac..e46e210 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -498,6 +498,7 @@ static int __init iSeries_tb_recal(void)
 				tb_to_xs = divres.result_low;
 				vdso_data->tb_ticks_per_sec = tb_ticks_per_sec;
 				vdso_data->tb_to_xs = tb_to_xs;
+				cputime_one = jiffies_to_cputime(1);
 			}
 			else {
 				printk( "Titan recalibrate: FAILED (difference > 4 percent)\n"
@@ -904,6 +905,7 @@ void __init time_init(void)
 	tb_ticks_per_usec = ppc_tb_freq / 1000000;
 	tb_to_us = mulhwu_scale_factor(ppc_tb_freq, 1000000);
 	calc_cputime_factors();
+	cputime_one = jiffies_to_cputime(1);
 
 	/*
 	 * Calculate the length of each tick in ns.  It will not be
diff --git a/arch/s390/include/asm/cputime.h b/arch/s390/include/asm/cputime.h
index 941384f..f7bbdc9 100644
--- a/arch/s390/include/asm/cputime.h
+++ b/arch/s390/include/asm/cputime.h
@@ -39,6 +39,7 @@ __div(unsigned long long n, unsigned int base)
 #endif /* __s390x__ */
 
 #define cputime_zero			(0ULL)
+#define cputime_one			jiffies_to_cputime(1)
 #define cputime_max			((~0UL >> 1) - 1)
 #define cputime_add(__a, __b)		((__a) +  (__b))
 #define cputime_sub(__a, __b)		((__a) -  (__b))
diff --git a/include/asm-generic/cputime.h b/include/asm-generic/cputime.h
index 1c1fa42..f2b18be 100644
--- a/include/asm-generic/cputime.h
+++ b/include/asm-generic/cputime.h
@@ -7,6 +7,7 @@
 typedef unsigned long cputime_t;
 
 #define cputime_zero			(0UL)
+#define cputime_one			(1UL)
 #define cputime_max			((~0UL >> 1) - 1)
 #define cputime_add(__a, __b)		((__a) +  (__b))
 #define cputime_sub(__a, __b)		((__a) -  (__b))
diff --git a/kernel/itimer.c b/kernel/itimer.c
index 58762f7..ba378c6 100644
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -65,7 +65,7 @@ int do_getitimer(int which, struct itimerval *value)
 			thread_group_cputimer(tsk, &cputime);
 			utime = cputime.utime;
 			if (cputime_le(cval, utime)) { /* about to fire */
-				cval = jiffies_to_cputime(1);
+				cval = cputime_one;
 			} else {
 				cval = cputime_sub(cval, utime);
 			}
@@ -85,7 +85,7 @@ int do_getitimer(int which, struct itimerval *value)
 			thread_group_cputimer(tsk, &times);
 			ptime = cputime_add(times.utime, times.stime);
 			if (cputime_le(cval, ptime)) { /* about to fire */
-				cval = jiffies_to_cputime(1);
+				cval = cputime_one;
 			} else {
 				cval = cputime_sub(cval, ptime);
 			}
@@ -182,8 +182,7 @@ again:
 		if (!cputime_eq(cval, cputime_zero) ||
 		    !cputime_eq(nval, cputime_zero)) {
 			if (cputime_gt(nval, cputime_zero))
-				nval = cputime_add(nval,
-						   jiffies_to_cputime(1));
+				nval = cputime_add(nval, cputime_one);
 			set_process_cpu_timer(tsk, CPUCLOCK_VIRT,
 					      &nval, &cval);
 		}
@@ -204,8 +203,7 @@ again:
 		if (!cputime_eq(cval, cputime_zero) ||
 		    !cputime_eq(nval, cputime_zero)) {
 			if (cputime_gt(nval, cputime_zero))
-				nval = cputime_add(nval,
-						   jiffies_to_cputime(1));
+				nval = cputime_add(nval, cputime_one);
 			set_process_cpu_timer(tsk, CPUCLOCK_PROF,
 					      &nval, &cval);
 		}
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index bece7c0..a86333c 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1456,7 +1456,7 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 		if (!cputime_eq(*oldval, cputime_zero)) {
 			if (cputime_le(*oldval, now.cpu)) {
 				/* Just about to fire. */
-				*oldval = jiffies_to_cputime(1);
+				*oldval = cputime_one;
 			} else {
 				*oldval = cputime_sub(*oldval, now.cpu);
 			}
diff --git a/kernel/sched.c b/kernel/sched.c
index 26efa47..b17fe3c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4726,17 +4726,16 @@ void account_idle_time(cputime_t cputime)
  */
 void account_process_tick(struct task_struct *p, int user_tick)
 {
-	cputime_t one_jiffy = jiffies_to_cputime(1);
-	cputime_t one_jiffy_scaled = cputime_to_scaled(one_jiffy);
+	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one);
 	struct rq *rq = this_rq();
 
 	if (user_tick)
-		account_user_time(p, one_jiffy, one_jiffy_scaled);
+		account_user_time(p, cputime_one, one_jiffy_scaled);
 	else if ((p != rq->idle) || (irq_count() != HARDIRQ_OFFSET))
-		account_system_time(p, HARDIRQ_OFFSET, one_jiffy,
+		account_system_time(p, HARDIRQ_OFFSET, cputime_one,
 				    one_jiffy_scaled);
 	else
-		account_idle_time(one_jiffy);
+		account_idle_time(cputime_one);
 }
 
 /*

