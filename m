Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbXHTSJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbXHTSJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 14:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750784AbXHTSJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 14:09:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45165 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbXHTSJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 14:09:04 -0400
Date: Mon, 20 Aug 2007 20:08:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [accounting regression since rc1]  scheduler updates
Message-ID: <20070820180810.GA25160@elte.hu>
References: <20070812163225.GA11996@elte.hu> <200708141037.48001.borntraeger@de.ibm.com> <20070820154529.GA300@elte.hu> <1187629438.8541.40.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187629438.8541.40.camel@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> > could you send that precise sched_clock() patch? It should be an 
> > order of magnitude simpler than the high-precision stime/utime 
> > tracking you already do, and it's needed for quality scheduling 
> > anyway.
> 
> Sure if you can explain what it should do. This is still unclear to 
> me, for a non-idle CPU the virtual cpu time should be used but for an 
> idle CPU the real time should be used ? That seems rather ill-defined 
> to me. On s390 we have three times to consider, real time, virtual cpu 
> time and steal time. For a given period we have real = virtual + 
> steal. And if a cpu is idle we have real = steal, virtual = 0. My best 
> interpretation of what you want is that sched_clock should progress 
> with virtual cpu time if the current process is not idle and with the 
> real time if it is. No ?

The core scheduler is invariant to sched_clock()'s behavior during idle 
periods [i.e. sched_clock() can do _anything_ during idle periods, and 
scheduling would not/schould not change], and that's the source of the 
uncertainty you noted.

So the best way to proceed is still a bit unclear to me - but in any 
case, a few boundary conditions are already cast into stone: we 
definitely dont want to make life harder for s390 (without giving any 
tangible benefits) and we dont want to regress any existing precision of 
s390 either.

We seem to agree wrt. sched_clock()'s behavior while the virtual CPU is 
busy: sched_clock() very much wants to track virtual time. (real time is 
pretty much meaningless and coupling sched_clock() to real time would 
make the virtual machine's behavior dependent on the host's load, which 
breaks the "seemless virtualization to inside observers" common-sense 
requirement of virtual-CPU scheduling.)

For sched_clock()'s behavior while the virtual CPU is idle: my current 
idea for that is the patch below (a loosely analoguous problem exists 
with nohz/dynticks): it makes sched_clock() valid across idle periods 
too and uses wall-clock time for that.

If a virtual CPU is idle then i think the "real = steal, virtual = 0" 
way of thinking about idle looks a bit unnatural to me - wouldnt it be 
better to think in terms of "steal = 0, virtual = real" ? Basically a 
virtual CPU can idle at "perfect speed", without the host "stealing" any 
cycles from it. And with that way of thinking, if s390 passed in the 
real-idle-time value to the new callbacks below it would all fall into 
place. Hm?

that way we'd have a meaningful sched_clock() across idle periods too, 
useful for tracers, better scheduler debug-statistics, etc.

	Ingo

---------->
Subject: sched: sched_clock_idle_[sleep|wakeup]_event()
From: Ingo Molnar <mingo@elte.hu>

construct a more or less wall-clock time out of sched_clock(), by
using ACPI-idle's existing knowledge about how much time we spent
idling. This allows the rq clock to work around TSC-stops-in-C2,
TSC-gets-corrupted-in-C3 type of problems.

( Besides the scheduler's statistics this also benefits blktrace and
  printk-timestamps as well. )

Furthermore, the precise before-C2/C3-sleep and after-C2/C3-wakeup
callbacks allow the scheduler to get out the most of the period where
the CPU has a reliable TSC. This results in slightly more precise
task statistics.

the ACPI bits were acked by Len.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Len Brown <len.brown@intel.com>
---
 arch/i386/kernel/tsc.c        |    1 -
 drivers/acpi/processor_idle.c |   32 +++++++++++++++++++++++++-------
 include/linux/sched.h         |    3 ++-
 kernel/sched.c                |   41 ++++++++++++++++++++++++++++++++---------
 kernel/sched_debug.c          |    3 ++-
 5 files changed, 61 insertions(+), 19 deletions(-)

Index: linux/arch/i386/kernel/tsc.c
===================================================================
--- linux.orig/arch/i386/kernel/tsc.c
+++ linux/arch/i386/kernel/tsc.c
@@ -292,7 +292,6 @@ static struct clocksource clocksource_ts
 
 void mark_tsc_unstable(char *reason)
 {
-	sched_clock_unstable_event();
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
 		tsc_enabled = 0;
Index: linux/drivers/acpi/processor_idle.c
===================================================================
--- linux.orig/drivers/acpi/processor_idle.c
+++ linux/drivers/acpi/processor_idle.c
@@ -63,6 +63,7 @@
 ACPI_MODULE_NAME("processor_idle");
 #define ACPI_PROCESSOR_FILE_POWER	"power"
 #define US_TO_PM_TIMER_TICKS(t)		((t * (PM_TIMER_FREQUENCY/1000)) / 1000)
+#define PM_TIMER_TICK_NS		(1000000000ULL/PM_TIMER_FREQUENCY)
 #define C2_OVERHEAD			4	/* 1us (3.579 ticks per us) */
 #define C3_OVERHEAD			4	/* 1us (3.579 ticks per us) */
 static void (*pm_idle_save) (void) __read_mostly;
@@ -462,6 +463,9 @@ static void acpi_processor_idle(void)
 		 * TBD: Can't get time duration while in C1, as resumes
 		 *      go to an ISR rather than here.  Need to instrument
 		 *      base interrupt handler.
+		 *
+		 * Note: the TSC better not stop in C1, sched_clock() will
+		 *       skew otherwise.
 		 */
 		sleep_ticks = 0xFFFFFFFF;
 		break;
@@ -469,6 +473,8 @@ static void acpi_processor_idle(void)
 	case ACPI_STATE_C2:
 		/* Get start time (ticks) */
 		t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
+		/* Tell the scheduler that we are going deep-idle: */
+		sched_clock_idle_sleep_event();
 		/* Invoke C2 */
 		acpi_state_timer_broadcast(pr, cx, 1);
 		acpi_cstate_enter(cx);
@@ -479,17 +485,22 @@ static void acpi_processor_idle(void)
 		/* TSC halts in C2, so notify users */
 		mark_tsc_unstable("possible TSC halt in C2");
 #endif
+		/* Compute time (ticks) that we were actually asleep */
+		sleep_ticks = ticks_elapsed(t1, t2);
+
+		/* Tell the scheduler how much we idled: */
+		sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
+
 		/* Re-enable interrupts */
 		local_irq_enable();
+		/* Do not account our idle-switching overhead: */
+		sleep_ticks -= cx->latency_ticks + C2_OVERHEAD;
+
 		current_thread_info()->status |= TS_POLLING;
-		/* Compute time (ticks) that we were actually asleep */
-		sleep_ticks =
-		    ticks_elapsed(t1, t2) - cx->latency_ticks - C2_OVERHEAD;
 		acpi_state_timer_broadcast(pr, cx, 0);
 		break;
 
 	case ACPI_STATE_C3:
-
 		/*
 		 * disable bus master
 		 * bm_check implies we need ARB_DIS
@@ -518,6 +529,8 @@ static void acpi_processor_idle(void)
 		t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 		/* Invoke C3 */
 		acpi_state_timer_broadcast(pr, cx, 1);
+		/* Tell the scheduler that we are going deep-idle: */
+		sched_clock_idle_sleep_event();
 		acpi_cstate_enter(cx);
 		/* Get end time (ticks) */
 		t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
@@ -531,12 +544,17 @@ static void acpi_processor_idle(void)
 		/* TSC halts in C3, so notify users */
 		mark_tsc_unstable("TSC halts in C3");
 #endif
+		/* Compute time (ticks) that we were actually asleep */
+		sleep_ticks = ticks_elapsed(t1, t2);
+		/* Tell the scheduler how much we idled: */
+		sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
+
 		/* Re-enable interrupts */
 		local_irq_enable();
+		/* Do not account our idle-switching overhead: */
+		sleep_ticks -= cx->latency_ticks + C3_OVERHEAD;
+
 		current_thread_info()->status |= TS_POLLING;
-		/* Compute time (ticks) that we were actually asleep */
-		sleep_ticks =
-		    ticks_elapsed(t1, t2) - cx->latency_ticks - C3_OVERHEAD;
 		acpi_state_timer_broadcast(pr, cx, 0);
 		break;
 
Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -1388,7 +1388,8 @@ extern void sched_exec(void);
 #define sched_exec()   {}
 #endif
 
-extern void sched_clock_unstable_event(void);
+extern void sched_clock_idle_sleep_event(void);
+extern void sched_clock_idle_wakeup_event(u64 delta_ns);
 
 #ifdef CONFIG_HOTPLUG_CPU
 extern void idle_task_exit(void);
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -262,7 +262,8 @@ struct rq {
 	s64 clock_max_delta;
 
 	unsigned int clock_warps, clock_overflows;
-	unsigned int clock_unstable_events;
+	u64 idle_clock;
+	unsigned int clock_deep_idle_events;
 	u64 tick_timestamp;
 
 	atomic_t nr_iowait;
@@ -556,18 +557,40 @@ static inline struct rq *this_rq_lock(vo
 }
 
 /*
- * CPU frequency is/was unstable - start new by setting prev_clock_raw:
+ * We are going deep-idle (irqs are disabled):
  */
-void sched_clock_unstable_event(void)
+void sched_clock_idle_sleep_event(void)
 {
-	unsigned long flags;
-	struct rq *rq;
+	struct rq *rq = cpu_rq(smp_processor_id());
 
-	rq = task_rq_lock(current, &flags);
-	rq->prev_clock_raw = sched_clock();
-	rq->clock_unstable_events++;
-	task_rq_unlock(rq, &flags);
+	spin_lock(&rq->lock);
+	__update_rq_clock(rq);
+	spin_unlock(&rq->lock);
+	rq->clock_deep_idle_events++;
+}
+EXPORT_SYMBOL_GPL(sched_clock_idle_sleep_event);
+
+/*
+ * We just idled delta nanoseconds (called with irqs disabled):
+ */
+void sched_clock_idle_wakeup_event(u64 delta_ns)
+{
+	struct rq *rq = cpu_rq(smp_processor_id());
+	u64 now = sched_clock();
+
+	rq->idle_clock += delta_ns;
+	/*
+	 * Override the previous timestamp and ignore all
+	 * sched_clock() deltas that occured while we idled,
+	 * and use the PM-provided delta_ns to advance the
+	 * rq clock:
+	 */
+	spin_lock(&rq->lock);
+	rq->prev_clock_raw = now;
+	rq->clock += delta_ns;
+	spin_unlock(&rq->lock);
 }
+EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);
 
 /*
  * resched_task - mark a task 'to be rescheduled now'.
Index: linux/kernel/sched_debug.c
===================================================================
--- linux.orig/kernel/sched_debug.c
+++ linux/kernel/sched_debug.c
@@ -154,10 +154,11 @@ static void print_cpu(struct seq_file *m
 	P(next_balance);
 	P(curr->pid);
 	P(clock);
+	P(idle_clock);
 	P(prev_clock_raw);
 	P(clock_warps);
 	P(clock_overflows);
-	P(clock_unstable_events);
+	P(clock_deep_idle_events);
 	P(clock_max_delta);
 	P(cpu_load[0]);
 	P(cpu_load[1]);

