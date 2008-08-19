Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbYHSAcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbYHSAcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbYHSAbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:31:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46728 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbYHSAbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:31:39 -0400
Date: Tue, 19 Aug 2008 02:31:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Justin Madru <jdm64@gawab.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Michal Januszewski <spock@gentoo.org>,
       Antonino Daplas <adaplas@gmail.com>, Greg KH <gregkh@suse.de>,
       Rafael Wysocki <rjw@sisk.pl>,
       Romano Giannetti <romano.giannetti@gmail.com>,
       Adrian Bunk <bunk@kernel.org>,
       Jeremy Nickurak <kernel-bugs@atrus.rifetech.com>
Subject: Re: Backport hr-tick fix into .25/.26
Message-ID: <20080819003110.GH9914@elte.hu>
References: <48A9BDC0.9070800@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A9BDC0.9070800@gawab.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Justin Madru <jdm64@gawab.com> wrote:

> This commit introduced the bug.
> commit 8f4d37ec073c17e2d4aa8851df5837d798606d6f
> sched: high-res preemption tick

> And this one fixed it
>
> commit 31656519e132f6612584815f128c83976a9aaaef
> sched, x86: clean up hrtick implementation

hm, the backport of 31656519 is a bit intrusive.

find below is an (untested!) version of it - i havent even build-tested 
it. Does it work for you? But this is Greg's call really.

	Ingo

-------------->
>From 76cc8db4610c37f0d6b73d224517ce2526b681b6 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 19 Aug 2008 02:29:00 +0200
Subject: [PATCH] sched, x86: clean up hrtick implementation

random uvesafb failures were reported against Gentoo:

  http://bugs.gentoo.org/show_bug.cgi?id=222799

and Mihai Moldovan bisected it back to:

> 8f4d37ec073c17e2d4aa8851df5837d798606d6f is first bad commit
> commit 8f4d37ec073c17e2d4aa8851df5837d798606d6f
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Fri Jan 25 21:08:29 2008 +0100
>
>    sched: high-res preemption tick

Linus suspected it to be hrtick + vm86 interaction and observed:

> Btw, Peter, Ingo: I think that commit is doing bad things. They aren't
> _incorrect_ per se, but they are definitely bad.
>
> Why?
>
> Using random _TIF_WORK_MASK flags is really impolite for doing
> "scheduling" work. There's a reason that arch/x86/kernel/entry_32.S
> special-cases the _TIF_NEED_RESCHED flag: we don't want to exit out of
> vm86 mode unnecessarily.
>
> See the "work_notifysig_v86" label, and how it does that
> "save_v86_state()" thing etc etc.

Right, I never liked having to fiddle with those TIF flags. Initially I
needed it because the hrtimer base lock could not nest in the rq lock.
That however is fixed these days.

Currently the only reason left to fiddle with the TIF flags is remote
wakeups. We cannot program a remote cpu's hrtimer. I've been thinking
about using the new and improved IPI function call stuff to implement
hrtimer_start_on().

However that does require that smp_call_function_single(.wait=0) works
from interrupt context - /me looks at the latest series from Jens - Yes
that does seem to be supported, good.

Here's a stab at cleaning this stuff up ...

Mihai reported test success as well.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Mihai Moldovan <ionic@ionic.de>
Cc: Michal Januszewski <spock@gentoo.org>
Cc: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

Conflicts:

	include/asm-x86/thread_info.h
	kernel/sched.c

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/signal_32.c |    3 -
 arch/x86/kernel/signal_64.c |    3 -
 kernel/Kconfig.hz           |    2 +-
 kernel/sched.c              |  197 +++++++++++++------------------------------
 kernel/sched_fair.c         |    5 +-
 5 files changed, 61 insertions(+), 149 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index d923736..e1fc7bd 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -667,8 +667,5 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
 
-	if (thread_info_flags & _TIF_HRTICK_RESCHED)
-		hrtick_resched();
-
 	clear_thread_flag(TIF_IRET);
 }
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index e53b267..88023fc 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -502,9 +502,6 @@ void do_notify_resume(struct pt_regs *regs, void *unused,
 	/* deal with pending signal delivery */
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
-
-	if (thread_info_flags & _TIF_HRTICK_RESCHED)
-		hrtick_resched();
 }
 
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
diff --git a/kernel/Kconfig.hz b/kernel/Kconfig.hz
index 526128a..2a202a8 100644
--- a/kernel/Kconfig.hz
+++ b/kernel/Kconfig.hz
@@ -55,4 +55,4 @@ config HZ
 	default 1000 if HZ_1000
 
 config SCHED_HRTICK
-	def_bool HIGH_RES_TIMERS && X86
+	def_bool HIGH_RES_TIMERS
diff --git a/kernel/sched.c b/kernel/sched.c
index 4e2f603..b955d92 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -532,8 +532,10 @@ struct rq {
 #endif
 
 #ifdef CONFIG_SCHED_HRTICK
-	unsigned long hrtick_flags;
-	ktime_t hrtick_expire;
+#ifdef CONFIG_SMP
+	int hrtick_csd_pending;
+	struct call_single_data hrtick_csd;
+#endif
 	struct hrtimer hrtick_timer;
 #endif
 
@@ -996,13 +998,6 @@ static struct rq *this_rq_lock(void)
 	return rq;
 }
 
-static void __resched_task(struct task_struct *p, int tif_bit);
-
-static inline void resched_task(struct task_struct *p)
-{
-	__resched_task(p, TIF_NEED_RESCHED);
-}
-
 #ifdef CONFIG_SCHED_HRTICK
 /*
  * Use HR-timers to deliver accurate preemption points.
@@ -1014,25 +1009,6 @@ static inline void resched_task(struct task_struct *p)
  * When we get rescheduled we reprogram the hrtick_timer outside of the
  * rq->lock.
  */
-static inline void resched_hrt(struct task_struct *p)
-{
-	__resched_task(p, TIF_HRTICK_RESCHED);
-}
-
-static inline void resched_rq(struct rq *rq)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&rq->lock, flags);
-	resched_task(rq->curr);
-	spin_unlock_irqrestore(&rq->lock, flags);
-}
-
-enum {
-	HRTICK_SET,		/* re-programm hrtick_timer */
-	HRTICK_RESET,		/* not a new slice */
-	HRTICK_BLOCK,		/* stop hrtick operations */
-};
 
 /*
  * Use hrtick when:
@@ -1043,40 +1019,11 @@ static inline int hrtick_enabled(struct rq *rq)
 {
 	if (!sched_feat(HRTICK))
 		return 0;
-	if (unlikely(test_bit(HRTICK_BLOCK, &rq->hrtick_flags)))
+	if (!cpu_online(cpu_of(rq)))
 		return 0;
 	return hrtimer_is_hres_active(&rq->hrtick_timer);
 }
 
-/*
- * Called to set the hrtick timer state.
- *
- * called with rq->lock held and irqs disabled
- */
-static void hrtick_start(struct rq *rq, u64 delay, int reset)
-{
-	assert_spin_locked(&rq->lock);
-
-	/*
-	 * preempt at: now + delay
-	 */
-	rq->hrtick_expire =
-		ktime_add_ns(rq->hrtick_timer.base->get_time(), delay);
-	/*
-	 * indicate we need to program the timer
-	 */
-	__set_bit(HRTICK_SET, &rq->hrtick_flags);
-	if (reset)
-		__set_bit(HRTICK_RESET, &rq->hrtick_flags);
-
-	/*
-	 * New slices are called from the schedule path and don't need a
-	 * forced reschedule.
-	 */
-	if (reset)
-		resched_hrt(rq->curr);
-}
-
 static void hrtick_clear(struct rq *rq)
 {
 	if (hrtimer_active(&rq->hrtick_timer))
@@ -1084,32 +1031,6 @@ static void hrtick_clear(struct rq *rq)
 }
 
 /*
- * Update the timer from the possible pending state.
- */
-static void hrtick_set(struct rq *rq)
-{
-	ktime_t time;
-	int set, reset;
-	unsigned long flags;
-
-	WARN_ON_ONCE(cpu_of(rq) != smp_processor_id());
-
-	spin_lock_irqsave(&rq->lock, flags);
-	set = __test_and_clear_bit(HRTICK_SET, &rq->hrtick_flags);
-	reset = __test_and_clear_bit(HRTICK_RESET, &rq->hrtick_flags);
-	time = rq->hrtick_expire;
-	clear_thread_flag(TIF_HRTICK_RESCHED);
-	spin_unlock_irqrestore(&rq->lock, flags);
-
-	if (set) {
-		hrtimer_start(&rq->hrtick_timer, time, HRTIMER_MODE_ABS);
-		if (reset && !hrtimer_active(&rq->hrtick_timer))
-			resched_rq(rq);
-	} else
-		hrtick_clear(rq);
-}
-
-/*
  * High-resolution timer tick.
  * Runs from hardirq context with interrupts disabled.
  */
@@ -1128,27 +1049,37 @@ static enum hrtimer_restart hrtick(struct hrtimer *timer)
 }
 
 #ifdef CONFIG_SMP
-static void hotplug_hrtick_disable(int cpu)
+/*
+ * called from hardirq (IPI) context
+ */
+static void __hrtick_start(void *arg)
 {
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long flags;
-
-	spin_lock_irqsave(&rq->lock, flags);
-	rq->hrtick_flags = 0;
-	__set_bit(HRTICK_BLOCK, &rq->hrtick_flags);
-	spin_unlock_irqrestore(&rq->lock, flags);
+	struct rq *rq = arg;
 
-	hrtick_clear(rq);
+	spin_lock(&rq->lock);
+	hrtimer_restart(&rq->hrtick_timer);
+	rq->hrtick_csd_pending = 0;
+	spin_unlock(&rq->lock);
 }
 
-static void hotplug_hrtick_enable(int cpu)
+/*
+ * Called to set the hrtick timer state.
+ *
+ * called with rq->lock held and irqs disabled
+ */
+static void hrtick_start(struct rq *rq, u64 delay)
 {
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long flags;
+	struct hrtimer *timer = &rq->hrtick_timer;
+	ktime_t time = ktime_add_ns(timer->base->get_time(), delay);
 
-	spin_lock_irqsave(&rq->lock, flags);
-	__clear_bit(HRTICK_BLOCK, &rq->hrtick_flags);
-	spin_unlock_irqrestore(&rq->lock, flags);
+	timer->expires = time;
+
+	if (rq == this_rq()) {
+		hrtimer_restart(timer);
+	} else if (!rq->hrtick_csd_pending) {
+		__smp_call_function_single(cpu_of(rq), &rq->hrtick_csd);
+		rq->hrtick_csd_pending = 1;
+	}
 }
 
 static int
@@ -1163,16 +1094,7 @@ hotplug_hrtick(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_DOWN_PREPARE_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		hotplug_hrtick_disable(cpu);
-		return NOTIFY_OK;
-
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-	case CPU_DOWN_FAILED:
-	case CPU_DOWN_FAILED_FROZEN:
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		hotplug_hrtick_enable(cpu);
+		hrtick_clear(cpu_rq(cpu));
 		return NOTIFY_OK;
 	}
 
@@ -1183,46 +1105,45 @@ static void init_hrtick(void)
 {
 	hotcpu_notifier(hotplug_hrtick, 0);
 }
-#endif /* CONFIG_SMP */
+#else
+/*
+ * Called to set the hrtick timer state.
+ *
+ * called with rq->lock held and irqs disabled
+ */
+static void hrtick_start(struct rq *rq, u64 delay)
+{
+	hrtimer_start(&rq->hrtick_timer, ns_to_ktime(delay), HRTIMER_MODE_REL);
+}
 
-static void init_rq_hrtick(struct rq *rq)
+static void init_hrtick(void)
 {
-	rq->hrtick_flags = 0;
-	hrtimer_init(&rq->hrtick_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	rq->hrtick_timer.function = hrtick;
-	rq->hrtick_timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
 }
+#endif /* CONFIG_SMP */
 
-void hrtick_resched(void)
+static void init_rq_hrtick(struct rq *rq)
 {
-	struct rq *rq;
-	unsigned long flags;
+#ifdef CONFIG_SMP
+	rq->hrtick_csd_pending = 0;
 
-	if (!test_thread_flag(TIF_HRTICK_RESCHED))
-		return;
+	rq->hrtick_csd.flags = 0;
+	rq->hrtick_csd.func = __hrtick_start;
+	rq->hrtick_csd.info = rq;
+#endif
 
-	local_irq_save(flags);
-	rq = cpu_rq(smp_processor_id());
-	hrtick_set(rq);
-	local_irq_restore(flags);
+	hrtimer_init(&rq->hrtick_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	rq->hrtick_timer.function = hrtick;
+	rq->hrtick_timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
 }
 #else
 static inline void hrtick_clear(struct rq *rq)
 {
 }
 
-static inline void hrtick_set(struct rq *rq)
-{
-}
-
 static inline void init_rq_hrtick(struct rq *rq)
 {
 }
 
-void hrtick_resched(void)
-{
-}
-
 static inline void init_hrtick(void)
 {
 }
@@ -1241,16 +1162,16 @@ static inline void init_hrtick(void)
 #define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
 #endif
 
-static void __resched_task(struct task_struct *p, int tif_bit)
+static void resched_task(struct task_struct *p)
 {
 	int cpu;
 
 	assert_spin_locked(&task_rq(p)->lock);
 
-	if (unlikely(test_tsk_thread_flag(p, tif_bit)))
+	if (unlikely(test_tsk_thread_flag(p, TIF_NEED_RESCHED)))
 		return;
 
-	set_tsk_thread_flag(p, tif_bit);
+	set_tsk_thread_flag(p, TIF_NEED_RESCHED);
 
 	cpu = task_cpu(p);
 	if (cpu == smp_processor_id())
@@ -1316,10 +1237,10 @@ void wake_up_idle_cpu(int cpu)
 #endif
 
 #else
-static void __resched_task(struct task_struct *p, int tif_bit)
+static void resched_task(struct task_struct *p)
 {
 	assert_spin_locked(&task_rq(p)->lock);
-	set_tsk_thread_flag(p, tif_bit);
+	set_tsk_need_resched(p);
 }
 #endif
 
@@ -4204,8 +4125,6 @@ need_resched_nonpreemptible:
 	} else
 		spin_unlock_irq(&rq->lock);
 
-	hrtick_set(rq);
-
 	if (unlikely(reacquire_kernel_lock(current) < 0))
 		goto need_resched_nonpreemptible;
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 08ae848..e193a9d 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -808,7 +808,6 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 #ifdef CONFIG_SCHED_HRTICK
 static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
 {
-	int requeue = rq->curr == p;
 	struct sched_entity *se = &p->se;
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
 
@@ -829,10 +828,10 @@ static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
 		 * Don't schedule slices shorter than 10000ns, that just
 		 * doesn't make sense. Rely on vruntime for fairness.
 		 */
-		if (!requeue)
+		if (rq->curr != p)
 			delta = max(10000LL, delta);
 
-		hrtick_start(rq, delta, requeue);
+		hrtick_start(rq, delta);
 	}
 }
 #else
