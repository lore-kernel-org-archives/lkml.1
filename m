Return-Path: <linux-kernel-owner+w=401wt.eu-S1751772AbXLGF3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772AbXLGF3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 00:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbXLGF3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 00:29:41 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:36545 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750792AbXLGF3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 00:29:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Content-Type:Message-Id;
  b=fXIRr11ri054Pj3iFrmg1jklM3R2aFDXlJAu/w+EZhEkFyopJjkQZ9NNGT+irzoFmVcElTtQyb1TlR40LjjBA8QcF80FTEuAnrwhlV3S38EsGrSzPLc8rapek/Po+AN0fGh1nuVXIP1YUk3L7SYtMDSE6/EhdMQ41oV7dXprxTE=  ;
X-YMail-OSG: y30pZqsVM1ma8pMxsjCui_KWywvsM3L.pyX_sof4ZDllijqllQC3iuibeTXEe.Eut3mnVbFe98LPbUW7u6Hg8yayJMn9NZHrJOLL
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Date: Fri, 7 Dec 2007 16:29:30 +1100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Robert Love <rml@tech9.net>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
References: <20071207021952.6f0ac922@morte>
In-Reply-To: <20071207021952.6f0ac922@morte>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_7oNWHoJsLIYwyL8"
Message-Id: <200712071629.31300.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_7oNWHoJsLIYwyL8
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 07 December 2007 12:19, Stefano Brivio wrote:
> This patch fixes a regression introduced by:
>
> commit bb29ab26863c022743143f27956cc0ca362f258c
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Mon Jul 9 18:51:59 2007 +0200
>
> This caused the jiffies counter to leap back and forth on cpufreq changes
> on my x86 box. I'd say that we can't always assume that TSC does "small
> errors" only, when marked unstable. On cpufreq changes these errors can be
> huge.
>
> The original bug report can be found here:
> http://bugzilla.kernel.org/show_bug.cgi?id=9475
>
>
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

While your fix should probably go into 2.6.24...

This particular issue has aggravated me enough times. Let's
fix the damn thing properly already... I think what would work best
is a relatively simple change to the API along these lines:

--Boundary-00=_7oNWHoJsLIYwyL8
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="sched-clock.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="sched-clock.patch"

Index: linux-2.6/arch/x86/kernel/tsc_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tsc_32.c
+++ linux-2.6/arch/x86/kernel/tsc_32.c
@@ -92,27 +92,35 @@ static inline void set_cyc2ns_scale(unsi
 /*
  * Scheduler clock - returns current time in nanosec units.
  */
-unsigned long long native_sched_clock(void)
+u64 native_sched_clock(u64 *sample)
 {
-	unsigned long long this_offset;
+	u64 now, delta;
 
 	/*
-	 * Fall back to jiffies if there's no TSC available:
+	 * Fall back to the default sched_clock() implementation (keep in
+	 * synch with kernel/sched.c) if there's no TSC available:
 	 * ( But note that we still use it if the TSC is marked
 	 *   unstable. We do this because unlike Time Of Day,
 	 *   the scheduler clock tolerates small errors and it's
 	 *   very important for it to be as fast as the platform
 	 *   can achive it. )
 	 */
-	if (unlikely(!tsc_enabled && !tsc_unstable))
-		/* No locking but a rare wrong value is not a big deal: */
-		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
+	if (unlikely(!tsc_enabled && !tsc_unstable)) {
+		now = (u64)jiffies;
+		delta = now - *sample;
+		*sample = now;
+
+		return delta * (NSEC_PER_SEC / HZ);
+
+	} else {
+		/* read the Time Stamp Counter: */
+		rdtscll(now);
+		delta = now - *sample;
+		*sample = now;
 
-	/* read the Time Stamp Counter: */
-	rdtscll(this_offset);
-
-	/* return the value in ns */
-	return cycles_2_ns(this_offset);
+		/* return the delta value in ns */
+		return cycles_2_ns(delta);
+	}
 }
 
 /* We need to define a real function for sched_clock, to override the
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -72,9 +72,13 @@
  * This is default implementation.
  * Architectures and sub-architectures can override this.
  */
-unsigned long long __attribute__((weak)) sched_clock(void)
+u64 __attribute__((weak)) sched_clock(u64 *sample)
 {
-	return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
+	u64 now = (u64)jiffies;
+	u64 delta = now - *sample;
+	*sample = now;
+
+	return delta * (NSEC_PER_SEC / HZ);
 }
 
 /*
@@ -314,7 +318,7 @@ struct rq {
 	unsigned long next_balance;
 	struct mm_struct *prev_mm;
 
-	u64 clock, prev_clock_raw;
+	u64 clock, prev_clock_sample;
 	s64 clock_max_delta;
 
 	unsigned int clock_warps, clock_overflows;
@@ -385,9 +389,7 @@ static inline int cpu_of(struct rq *rq)
  */
 static void __update_rq_clock(struct rq *rq)
 {
-	u64 prev_raw = rq->prev_clock_raw;
-	u64 now = sched_clock();
-	s64 delta = now - prev_raw;
+	u64 delta = sched_clock(&rq->prev_clock_sample);
 	u64 clock = rq->clock;
 
 #ifdef CONFIG_SCHED_DEBUG
@@ -416,7 +418,6 @@ static void __update_rq_clock(struct rq 
 		}
 	}
 
-	rq->prev_clock_raw = now;
 	rq->clock = clock;
 }
 
@@ -656,7 +657,6 @@ EXPORT_SYMBOL_GPL(sched_clock_idle_sleep
 void sched_clock_idle_wakeup_event(u64 delta_ns)
 {
 	struct rq *rq = cpu_rq(smp_processor_id());
-	u64 now = sched_clock();
 
 	rq->idle_clock += delta_ns;
 	/*
@@ -666,7 +666,7 @@ void sched_clock_idle_wakeup_event(u64 d
 	 * rq clock:
 	 */
 	spin_lock(&rq->lock);
-	rq->prev_clock_raw = now;
+	(void)sched_clock(&rq->prev_clock_sample);
 	rq->clock += delta_ns;
 	spin_unlock(&rq->lock);
 }
@@ -4967,7 +4967,7 @@ void __cpuinit init_idle(struct task_str
 	unsigned long flags;
 
 	__sched_fork(idle);
-	idle->se.exec_start = sched_clock();
+	idle->se.exec_start = 0;
 
 	idle->prio = idle->normal_prio = MAX_PRIO;
 	idle->cpus_allowed = cpumask_of_cpu(cpu);
Index: linux-2.6/arch/x86/kernel/tsc_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tsc_64.c
+++ linux-2.6/arch/x86/kernel/tsc_64.c
@@ -30,18 +30,21 @@ static unsigned long long cycles_2_ns(un
 	return (cyc * cyc2ns_scale) >> NS_SCALE;
 }
 
-unsigned long long sched_clock(void)
+u64 sched_clock(u64 *sample)
 {
-	unsigned long a = 0;
+	u64 now, delta;
 
 	/* Could do CPU core sync here. Opteron can execute rdtsc speculatively,
 	 * which means it is not completely exact and may not be monotonous
 	 * between CPUs. But the errors should be too small to matter for
 	 * scheduling purposes.
 	 */
+	rdtscll(now);
+	delta = now - *sample;
+	*sample = now;
 
-	rdtscll(a);
-	return cycles_2_ns(a);
+	/* return the delta value in ns */
+	return cycles_2_ns(delta);
 }
 
 static int tsc_unstable;
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1433,7 +1433,7 @@ static inline int set_cpus_allowed(struc
 }
 #endif
 
-extern unsigned long long sched_clock(void);
+extern u64 sched_clock(u64 *sample);
 
 /*
  * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
Index: linux-2.6/include/asm-x86/timer.h
===================================================================
--- linux-2.6.orig/include/asm-x86/timer.h
+++ linux-2.6/include/asm-x86/timer.h
@@ -5,7 +5,7 @@
 
 #define TICK_SIZE (tick_nsec / 1000)
 
-unsigned long long native_sched_clock(void);
+unsigned u64 native_sched_clock(u64 *sample);
 unsigned long native_calculate_cpu_khz(void);
 
 extern int timer_ack;
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -216,7 +216,7 @@ static void lock_release_holdtime(struct
 	if (!lock_stat)
 		return;
 
-	holdtime = sched_clock() - hlock->holdtime_stamp;
+	holdtime = sched_clock(&hlock->holdtime_stamp);
 
 	stats = get_lock_stats(hlock->class);
 	if (hlock->read)
@@ -2413,7 +2413,7 @@ static int __lock_acquire(struct lockdep
 	hlock->hardirqs_off = hardirqs_off;
 #ifdef CONFIG_LOCK_STAT
 	hlock->waittime_stamp = 0;
-	hlock->holdtime_stamp = sched_clock();
+	(void)sched_clock(&hlock->holdtime_stamp);
 #endif
 
 	if (check == 2 && !mark_irqflags(curr, hlock))
@@ -2780,7 +2780,7 @@ __lock_contended(struct lockdep_map *loc
 	return;
 
 found_it:
-	hlock->waittime_stamp = sched_clock();
+	(void)sched_clock(&hlock->waittime_stamp);
 
 	point = lock_contention_point(hlock->class, ip);
 
@@ -2825,9 +2825,8 @@ __lock_acquired(struct lockdep_map *lock
 found_it:
 	cpu = smp_processor_id();
 	if (hlock->waittime_stamp) {
-		now = sched_clock();
-		waittime = now - hlock->waittime_stamp;
-		hlock->holdtime_stamp = now;
+		waittime = sched_clock(&hlock->waittime_stamp);
+		hlock->holdtime_stamp = hlock->waittime_stamp;
 	}
 
 	stats = get_lock_stats(hlock->class);
Index: linux-2.6/kernel/printk.c
===================================================================
--- linux-2.6.orig/kernel/printk.c
+++ linux-2.6/kernel/printk.c
@@ -575,7 +575,7 @@ __setup("time", printk_time_setup);
 
 __attribute__((weak)) unsigned long long printk_clock(void)
 {
-	return sched_clock();
+	return (unsigned long long)get_cycles();
 }
 
 /* Check if we have any console registered that can be called early in boot. */
Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
@@ -176,7 +176,7 @@ static void print_cpu(struct seq_file *m
 	P(curr->pid);
 	PN(clock);
 	PN(idle_clock);
-	PN(prev_clock_raw);
+	PN(prev_clock_sample);
 	P(clock_warps);
 	P(clock_overflows);
 	P(clock_deep_idle_events);
@@ -353,12 +353,12 @@ void proc_sched_show_task(struct task_st
 #undef __P
 
 	{
-		u64 t0, t1;
+		u64 sample, delta;
 
-		t0 = sched_clock();
-		t1 = sched_clock();
+		(void)sched_clock(&sample);
+		delta = sched_clock(&sample);
 		SEQ_printf(m, "%-35s:%21Ld\n",
-			   "clock-delta", (long long)(t1-t0));
+			   "clock-delta", (long long)delta);
 	}
 }
 

--Boundary-00=_7oNWHoJsLIYwyL8--
