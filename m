Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbYJUMJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbYJUMJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbYJUMJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:09:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45742 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbYJUMJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:09:16 -0400
Date: Tue, 21 Oct 2008 14:08:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Lockup in tracepoint unregister in sched switch ftrace plugin
Message-ID: <20081021120813.GA9672@elte.hu>
References: <alpine.DEB.1.10.0810202336560.25193@gandalf.stny.rr.com> <alpine.DEB.1.10.0810210012440.25193@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810210012440.25193@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> [ Paul, Thomas, wake up ]
> 
> On Mon, 20 Oct 2008, Steven Rostedt wrote:
> > 
> >   which calls unregister_trace_sched_switch define as macro to:
> > 
> > kernel/tracepoint.c: tracepoint_probe_unregister
> >    " "  : remove_tracepoint
> > kernel/rcupdate.c: rcu_barrier_sched
> >    " "  : _rcu_barrier
> > 
> > where it gets stuck at that "wait_for_completion".
> > 
> > I'm not sure if, because this is a scheduler trace point that we are 
> > hitting some kind of race that is preventing the wait_for_completion to 
> > finish, or what.
> 
> Note, I just booted this kernel with CONFIG_NOHZ=n and it booted fine. 
> This looks like a bug somewhere in tracepoints/RCU/dynamic-ticks

does it work with fb02fbc14 reverted? (see the reverter patch below or 
try tip/master)

	Ingo

---------------->
>From 75e7035e679c462c0c9c6a1cb0dc60fbcc58d3d4 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 21 Oct 2008 11:04:20 +0200
Subject: [PATCH] Revert "NOHZ: restart tick device from irq_enter()"

This reverts commit fb02fbc14d17837b4b7b02dbb36142c16a7bf208.

Test.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/time/tick-broadcast.c |   13 -------------
 kernel/time/tick-internal.h  |    2 --
 kernel/time/tick-sched.c     |   31 ++++++++-----------------------
 3 files changed, 8 insertions(+), 38 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index f98a1b7..cb01cd8 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -384,19 +384,6 @@ int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 }
 
 /*
- * Called from irq_enter() when idle was interrupted to reenable the
- * per cpu device.
- */
-void tick_check_oneshot_broadcast(int cpu)
-{
-	if (cpu_isset(cpu, tick_broadcast_oneshot_mask)) {
-		struct tick_device *td = &per_cpu(tick_cpu_device, cpu);
-
-		clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_ONESHOT);
-	}
-}
-
-/*
  * Handle oneshot mode broadcasting
  */
 static void tick_handle_oneshot_broadcast(struct clock_event_device *dev)
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index b1c05bf..4692487 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -36,7 +36,6 @@ extern void tick_broadcast_switch_to_oneshot(void);
 extern void tick_shutdown_broadcast_oneshot(unsigned int *cpup);
 extern int tick_resume_broadcast_oneshot(struct clock_event_device *bc);
 extern int tick_broadcast_oneshot_active(void);
-extern void tick_check_oneshot_broadcast(int cpu);
 # else /* BROADCAST */
 static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
@@ -46,7 +45,6 @@ static inline void tick_broadcast_oneshot_control(unsigned long reason) { }
 static inline void tick_broadcast_switch_to_oneshot(void) { }
 static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
 static inline int tick_broadcast_oneshot_active(void) { return 0; }
-static inline void tick_check_oneshot_broadcast(int cpu) { }
 # endif /* !BROADCAST */
 
 #else /* !ONESHOT */
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 0581c11..7aedf43 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -508,6 +508,10 @@ static void tick_nohz_handler(struct clock_event_device *dev)
 	update_process_times(user_mode(regs));
 	profile_tick(CPU_PROFILING);
 
+	/* Do not restart, when we are in the idle loop */
+	if (ts->tick_stopped)
+		return;
+
 	while (tick_nohz_reprogram(ts, now)) {
 		now = ktime_get();
 		tick_do_update_jiffies64(now);
@@ -553,27 +557,6 @@ static void tick_nohz_switch_to_nohz(void)
 	       smp_processor_id());
 }
 
-/*
- * When NOHZ is enabled and the tick is stopped, we need to kick the
- * tick timer from irq_enter() so that the jiffies update is kept
- * alive during long running softirqs. That's ugly as hell, but
- * correctness is key even if we need to fix the offending softirq in
- * the first place.
- *
- * Note, this is different to tick_nohz_restart. We just kick the
- * timer and do not touch the other magic bits which need to be done
- * when idle is left.
- */
-static void tick_nohz_kick_tick(int cpu)
-{
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
-
-	if (!ts->tick_stopped)
-		return;
-
-	tick_nohz_restart(ts, ktime_get());
-}
-
 #else
 
 static inline void tick_nohz_switch_to_nohz(void) { }
@@ -585,11 +568,9 @@ static inline void tick_nohz_switch_to_nohz(void) { }
  */
 void tick_check_idle(int cpu)
 {
-	tick_check_oneshot_broadcast(cpu);
 #ifdef CONFIG_NO_HZ
 	tick_nohz_stop_idle(cpu);
 	tick_nohz_update_jiffies();
-	tick_nohz_kick_tick(cpu);
 #endif
 }
 
@@ -646,6 +627,10 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 		profile_tick(CPU_PROFILING);
 	}
 
+	/* Do not restart, when we are in the idle loop */
+	if (ts->tick_stopped)
+		return HRTIMER_NORESTART;
+
 	hrtimer_forward(timer, now, tick_period);
 
 	return HRTIMER_RESTART;

