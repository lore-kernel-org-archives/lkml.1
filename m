Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbYLaIyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbYLaIyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 03:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbYLaIyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 03:54:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40158 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbYLaIyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 03:54:36 -0500
Date: Wed, 31 Dec 2008 09:54:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jayson King <dev@jaysonking.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       a.p.zijlstra@chello.nl, shaggy@linux.vnet.ibm.com, rjw@sisk.pl,
       fabio.comolli@gmail.com
Subject: [PATCH] sched_clock: prevent scd->clock from moving backwards,
	take #2
Message-ID: <20081231085417.GB13665@elte.hu>
References: <495A96FF.1000200@jaysonking.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495A96FF.1000200@jaysonking.com>
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


* Jayson King <dev@jaysonking.com> wrote:

> Greetings,
>
> I noticed large latency spikes in 2.6.28 (and 2.6.27.10) which would 
> make the system unresponsive for minutes at a time (alt+Fn switching 
> wouldn't even work) when the system is under load. I could trigger the 
> latency by running a large make -j 3. Sometimes it would trigger in a 
> few seconds other times it would take a few minutes.
>
> I bisected it in 2.6.27.10 to d9a888b061f55534016d2d86a21639948312a117 
> -> Revert "sched_clock: prevent scd->clock from moving backwards" 
> (ca7e716c7833aeaeb8fedd6d004c5f5d5e14d325 in 2.6.28) and reverting it in 
> 2.6.28 make the latency spike go away. At least, so far no spike in over 
> 24 hours.

Could you try the patch below - does it solve the problem? (and if it 
solves the problem, and if you have working suspend-to-ram or hibernation 
on your system then please also double-check that those still work.)

	Ingo

------------------------>
>From 1c5745aa380efb6417b5681104b007c8612fb496 Mon Sep 17 00:00:00 2001
From: Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 22 Dec 2008 23:05:28 +0100
Subject: [PATCH] sched_clock: prevent scd->clock from moving backwards, take #2

Redo:

  5b7dba4: sched_clock: prevent scd->clock from moving backwards

which had to be reverted due to s2ram hangs:

  ca7e716: Revert "sched_clock: prevent scd->clock from moving backwards"

... this time with resume restoring GTOD later in the sequence
taken into account as well.

The "timekeeping_suspended" flag is not very nice but we cannot call into
GTOD before it has been properly resumed and the scheduler will run very
early in the resume sequence.

Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/time.h      |    1 +
 kernel/sched_clock.c      |    5 ++++-
 kernel/time/timekeeping.c |    7 +++++--
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index ce321ac..fbbd2a1 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -105,6 +105,7 @@ extern unsigned long read_persistent_clock(void);
 extern int update_persistent_clock(struct timespec now);
 extern int no_sync_cmos_clock __read_mostly;
 void timekeeping_init(void);
+extern int timekeeping_suspended;
 
 unsigned long get_seconds(void);
 struct timespec current_kernel_time(void);
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index e8ab096..a0b0852 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -124,7 +124,7 @@ static u64 __update_sched_clock(struct sched_clock_data *scd, u64 now)
 
 	clock = scd->tick_gtod + delta;
 	min_clock = wrap_max(scd->tick_gtod, scd->clock);
-	max_clock = scd->tick_gtod + TICK_NSEC;
+	max_clock = wrap_max(scd->clock, scd->tick_gtod + TICK_NSEC);
 
 	clock = wrap_max(clock, min_clock);
 	clock = wrap_min(clock, max_clock);
@@ -227,6 +227,9 @@ EXPORT_SYMBOL_GPL(sched_clock_idle_sleep_event);
  */
 void sched_clock_idle_wakeup_event(u64 delta_ns)
 {
+	if (timekeeping_suspended)
+		return;
+
 	sched_clock_tick();
 	touch_softlockup_watchdog();
 }
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index fa05e88..900f1b6 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -46,6 +46,9 @@ struct timespec xtime __attribute__ ((aligned (16)));
 struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
 static unsigned long total_sleep_time;		/* seconds */
 
+/* flag for if timekeeping is suspended */
+int __read_mostly timekeeping_suspended;
+
 static struct timespec xtime_cache __attribute__ ((aligned (16)));
 void update_xtime_cache(u64 nsec)
 {
@@ -92,6 +95,8 @@ void getnstimeofday(struct timespec *ts)
 	unsigned long seq;
 	s64 nsecs;
 
+	WARN_ON(timekeeping_suspended);
+
 	do {
 		seq = read_seqbegin(&xtime_lock);
 
@@ -299,8 +304,6 @@ void __init timekeeping_init(void)
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 }
 
-/* flag for if timekeeping is suspended */
-static int timekeeping_suspended;
 /* time in seconds when suspend began */
 static unsigned long timekeeping_suspend_time;
 
