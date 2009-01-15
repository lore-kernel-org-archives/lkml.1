Return-Path: <linux-kernel-owner+w=401wt.eu-S1765744AbZAOUPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765744AbZAOUPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765982AbZAOUAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:00:51 -0500
Received: from kroah.org ([198.145.64.141]:48968 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765926AbZAOUAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:38 -0500
Date: Thu, 15 Jan 2009 11:58:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>
Subject: [patch 24/94] sched_clock: prevent scd->clock from moving
	backwards, take #2
Message-ID: <20090115195806.GX14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sched_clock-prevent-scd-clock-from-moving-backwards-take-2.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 1c5745aa380efb6417b5681104b007c8612fb496 upstream.

Redo:

  5b7dba4: sched_clock: prevent scd->clock from moving backwards

which had to be reverted due to s2ram hangs:

  ca7e716: Revert "sched_clock: prevent scd->clock from moving backwards"

... this time with resume restoring GTOD later in the sequence
taken into account as well.

The "timekeeping_suspended" flag is not very nice but we cannot call into
GTOD before it has been properly resumed and the scheduler will run very
early in the resume sequence.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/time.h      |    1 +
 kernel/sched_clock.c      |    5 ++++-
 kernel/time/timekeeping.c |    7 +++++--
 3 files changed, 10 insertions(+), 3 deletions(-)

--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -105,6 +105,7 @@ extern unsigned long read_persistent_clo
 extern int update_persistent_clock(struct timespec now);
 extern int no_sync_cmos_clock __read_mostly;
 void timekeeping_init(void);
+extern int timekeeping_suspended;
 
 unsigned long get_seconds(void);
 struct timespec current_kernel_time(void);
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -124,7 +124,7 @@ static u64 __update_sched_clock(struct s
 
 	clock = scd->tick_gtod + delta;
 	min_clock = wrap_max(scd->tick_gtod, scd->clock);
-	max_clock = scd->tick_gtod + TICK_NSEC;
+	max_clock = wrap_max(scd->clock, scd->tick_gtod + TICK_NSEC);
 
 	clock = wrap_max(clock, min_clock);
 	clock = wrap_min(clock, max_clock);
@@ -227,6 +227,9 @@ EXPORT_SYMBOL_GPL(sched_clock_idle_sleep
  */
 void sched_clock_idle_wakeup_event(u64 delta_ns)
 {
+	if (timekeeping_suspended)
+		return;
+
 	sched_clock_tick();
 	touch_softlockup_watchdog();
 }
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -46,6 +46,9 @@ struct timespec xtime __attribute__ ((al
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
 

