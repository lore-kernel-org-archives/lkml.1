Return-Path: <linux-kernel-owner+w=401wt.eu-S1757842AbZDKJxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbZDKJxN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 05:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757528AbZDKJw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 05:52:57 -0400
Received: from www.tglx.de ([62.245.132.106]:56345 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757010AbZDKJw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 05:52:56 -0400
Date: Sat, 11 Apr 2009 11:51:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dimitri Sivanich <sivanich@sgi.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2] Move calc_load call out from xtime_lock protection
In-Reply-To: <20090410173437.GA23415@sgi.com>
Message-ID: <alpine.LFD.2.00.0904110931240.21577@localhost.localdomain>
References: <20090410173437.GA23415@sgi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009, Dimitri Sivanich wrote:

> The xtime_lock is being held for long periods on larger systems due
> to an extensive amount of time being spent in calc_load(),
> specifically here:
>   do_timer->update_times->calc_load->count_active_tasks->nr_active()
> 
> On a 64 cpu system I've seen this take approximately 55 usec.
> Presumably it would be worse on larger systems.  This causes other
> cpus to be held off in places such as
> scheduler_tick->sched_clock_tick waiting for the xtime_lock to be
> released.

I thought more about that. Why don't we move the calc_load() call into
the timer softirq context and avoid fiddling with all the call sites ?
Also moving calc_load out of the timer interrupt context reduces the
interrupts off section as well.

Thanks,

	tglx

--------->

Subject: timer: move calc_load to softirq
From: Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 11 Apr 2009 10:43:41 +0200

xtime_lock is held write locked across calc_load() which iterates over
all online CPUs. That can cause long latencies for xtime_lock readers
on large SMP systems.

Move the calculation to the softirq and reduce the xtime_lock write
locked section. This also reduces the interrupts off section.

Inspired by a inital patch from Dimitri Sivanich.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/timer.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -1139,9 +1139,12 @@ static unsigned long count_active_tasks(
  * Requires xtime_lock to access.
  */
 unsigned long avenrun[3];
-
 EXPORT_SYMBOL(avenrun);
 
+static atomic_t avenrun_ticks;
+static DEFINE_SPINLOCK(avenrun_lock);
+static DEFINE_PER_CPU(int, avenrun_calculate);
+
 /*
  * calc_load - given tick count, update the avenrun load estimates.
  * This is called while holding a write_lock on xtime_lock.
@@ -1164,12 +1167,56 @@ static inline void calc_load(unsigned lo
 }
 
 /*
+ * Check whether we need to calculate load.
+ */
+static void check_calc_load(void)
+{
+	int ticks, *calc = &__get_cpu_var(avenrun_calculate);
+
+	/*
+	 * The trigger is set in the timer interrupt when this CPU
+	 * called do_timer(). We handle this sloppy w/o disabling
+	 * interrupts. If the trigger is set after we cleared it we
+	 * might look at a stale trigger in the next cycle, but then
+	 * we check anyway whether avenrun_ticks is > 0. Normally the
+	 * do_timer() call is bound to a particular CPU except for the
+	 * NOHZ case where a CPU going into a long idle sleep drops
+	 * the do_timer() duty. In the case that another timer
+	 * interrupt happens right after we return from this function,
+	 * then we run the calculation in the next cycle or in the
+	 * nohz case if we give up the do_timer() duty then the next
+	 * CPU which calls do_timer() will take care of the
+	 * unaccounted ticks. calc_load is not a precise accounting so
+	 * having some lag is not hurting.
+	 */
+	if (!*calc)
+		return;
+
+	*calc = 0;
+
+	while (atomic_read(&avenrun_ticks)) {
+		/*
+		 * avenrun_lock serializes the decrement of
+		 * avenrun_ticks and the avenrun calculation.
+		 */
+		spin_lock(&avenrun_lock);
+		ticks = atomic_read(&avenrun_ticks);
+		if (ticks) {
+			atomic_sub(ticks, &avenrun_ticks);
+			calc_load(ticks);
+		}
+		spin_unlock(&avenrun_lock);
+	}
+}
+
+/*
  * This function runs timers and the timer-tq in bottom half context.
  */
 static void run_timer_softirq(struct softirq_action *h)
 {
 	struct tvec_base *base = __get_cpu_var(tvec_bases);
 
+	check_calc_load();
 	hrtimer_run_pending();
 
 	if (time_after_eq(jiffies, base->timer_jiffies))
@@ -1193,7 +1240,9 @@ void run_local_timers(void)
 static inline void update_times(unsigned long ticks)
 {
 	update_wall_time();
-	calc_load(ticks);
+
+	atomic_add(ticks, &avenrun_ticks);
+	__get_cpu_var(avenrun_calculate) = 1;
 }
 
 /*
