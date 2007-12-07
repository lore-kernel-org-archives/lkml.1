Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786AbXLGShR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbXLGShR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 13:37:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756720AbXLGShC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 13:37:02 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48010 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656AbXLGShA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 13:37:00 -0500
Date: Fri, 7 Dec 2007 19:36:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [git pull] x86/hrtimer/acpi fixes
Message-ID: <20071207183633.GC26778@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
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


Linus, please pull the latest x86 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

This contains 3 x86/hrtimer/hpet/ACPI fixes from Thomas: the ACPI fix 
has been ACK-ed by Venki. Build and boot tested on various boxes.

	Ingo

------------------>
Thomas Gleixner (3):
      hrtimers: avoid overflow for large relative timeouts
      clockevents: warn once when program_event() is called with negative expiry
      ACPI: move timer broadcast before busmaster disable

 drivers/acpi/processor_idle.c |   19 ++++++++++++++-----
 kernel/hrtimer.c              |    8 ++++++++
 kernel/time/clockevents.c     |    5 +++++
 3 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index b1fbee3..2fe34cc 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -531,6 +531,11 @@ static void acpi_processor_idle(void)
 
 	case ACPI_STATE_C3:
 		/*
+		 * Must be done before busmaster disable as we might
+		 * need to access HPET !
+		 */
+		acpi_state_timer_broadcast(pr, cx, 1);
+		/*
 		 * disable bus master
 		 * bm_check implies we need ARB_DIS
 		 * !bm_check implies we need cache flush
@@ -557,7 +562,6 @@ static void acpi_processor_idle(void)
 		/* Get start time (ticks) */
 		t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 		/* Invoke C3 */
-		acpi_state_timer_broadcast(pr, cx, 1);
 		/* Tell the scheduler that we are going deep-idle: */
 		sched_clock_idle_sleep_event();
 		acpi_cstate_enter(cx);
@@ -1401,9 +1405,6 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 	if (acpi_idle_suspend)
 		return(acpi_idle_enter_c1(dev, state));
 
-	if (pr->flags.bm_check)
-		acpi_idle_update_bm_rld(pr, cx);
-
 	local_irq_disable();
 	current_thread_info()->status &= ~TS_POLLING;
 	/*
@@ -1418,13 +1419,21 @@ static int acpi_idle_enter_simple(struct cpuidle_device *dev,
 		return 0;
 	}
 
+	/*
+	 * Must be done before busmaster disable as we might need to
+	 * access HPET !
+	 */
+	acpi_state_timer_broadcast(pr, cx, 1);
+
+	if (pr->flags.bm_check)
+		acpi_idle_update_bm_rld(pr, cx);
+
 	if (cx->type == ACPI_STATE_C3)
 		ACPI_FLUSH_CPU_CACHE();
 
 	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 	/* Tell the scheduler that we are going deep-idle: */
 	sched_clock_idle_sleep_event();
-	acpi_state_timer_broadcast(pr, cx, 1);
 	acpi_idle_do_entry(cx);
 	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 22a2514..e65dd0b 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -850,6 +850,14 @@ hrtimer_start(struct hrtimer *timer, ktime_t tim, const enum hrtimer_mode mode)
 #ifdef CONFIG_TIME_LOW_RES
 		tim = ktime_add(tim, base->resolution);
 #endif
+		/*
+		 * Careful here: User space might have asked for a
+		 * very long sleep, so the add above might result in a
+		 * negative number, which enqueues the timer in front
+		 * of the queue.
+		 */
+		if (tim.tv64 < 0)
+			tim.tv64 = KTIME_MAX;
 	}
 	timer->expires = tim;
 
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 822beeb..5fb139f 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -78,6 +78,11 @@ int clockevents_program_event(struct clock_event_device *dev, ktime_t expires,
 	unsigned long long clc;
 	int64_t delta;
 
+	if (unlikely(expires.tv64 < 0)) {
+		WARN_ON_ONCE(1);
+		return -ETIME;
+	}
+
 	delta = ktime_to_ns(ktime_sub(expires, now));
 
 	if (delta <= 0)
