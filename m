Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbYKQI4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbYKQI4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 03:56:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbYKQI4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 03:56:37 -0500
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:56431 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752303AbYKQI4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 03:56:36 -0500
Date: Mon, 17 Nov 2008 03:13:26 -0500
From: Theodore Tso <tytso@mit.edu>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, bugme-daemon@bugzilla.kernel.org,
       akpm@linux-foundation.org
Subject: [Bug 11905] REGRESSION: lots of extra timer interrupts costing
	power
Message-ID: <20081117081326.GA14523@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Elias Oltmanns <eo@nebensachen.de>, linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	bugme-daemon@bugzilla.kernel.org, akpm@linux-foundation.org
References: <E1KvN6w-0002QE-E3@closure.thunk.org> <20081031031516.GA9781@mit.edu> <87mygl2hg1.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mygl2hg1.fsf@denkblock.local>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, what's going on with this regression?  To refresh people's memory,
I tracked down the excess interrupts to a specific commit, fb02fbc1,
and I've been running quite happily with a patch to revert this
commit.

I'm not sure it's the right thing, but if no one has had any time to
figure out what's wrong with the original commit, can we please revert
it for 2.6.28?  I reported it over two weeks ago, and I've not heard
anything from about alternative ways of fixing this regression.

Thanks!!

						- Ted


commit c38a3882eeeb6dcb45c99f29c7b95595606eaf4d
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Oct 31 12:37:31 2008 -0400

    Revert "NOHZ: restart tick device from irq_enter()"
    
    This reverts commit fb02fbc14d17837b4b7b02dbb36142c16a7bf208 to avoid
    a large number of excess interrupts which burns a significant amount 
    on a X61s laptop (and probably many more); others have reported this
    problem as well on the bugzilla entry:

    http://bugzilla.kernel.org/show_bug.cgi?id=11905
    
    Conflicts:
    
    	kernel/time/tick-sched.c

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
index 5bbb104..c8b3d8d 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -510,6 +510,10 @@ static void tick_nohz_handler(struct clock_event_device *dev)
 	update_process_times(user_mode(regs));
 	profile_tick(CPU_PROFILING);
 
+	/* Do not restart, when we are in the idle loop */
+	if (ts->tick_stopped)
+		return;
+
 	while (tick_nohz_reprogram(ts, now)) {
 		now = ktime_get();
 		tick_do_update_jiffies64(now);
@@ -555,37 +559,6 @@ static void tick_nohz_switch_to_nohz(void)
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
-	ktime_t delta, now;
-
-	if (!ts->tick_stopped)
-		return;
-
-	/*
-	 * Do not touch the tick device, when the next expiry is either
-	 * already reached or less/equal than the tick period.
-	 */
-	now = ktime_get();
-	delta =	ktime_sub(hrtimer_get_expires(&ts->sched_timer), now);
-	if (delta.tv64 <= tick_period.tv64)
-		return;
-
-	tick_nohz_restart(ts, now);
-}
-
 #else
 
 static inline void tick_nohz_switch_to_nohz(void) { }
@@ -597,11 +570,9 @@ static inline void tick_nohz_switch_to_nohz(void) { }
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
 
@@ -658,6 +629,10 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 		profile_tick(CPU_PROFILING);
 	}
 
+	/* Do not restart, when we are in the idle loop */
+	if (ts->tick_stopped)
+		return HRTIMER_NORESTART;
+
 	hrtimer_forward(timer, now, tick_period);
 
 	return HRTIMER_RESTART;
