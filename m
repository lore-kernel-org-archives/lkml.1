Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbZHNNti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbZHNNti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 09:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756509AbZHNNth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 09:49:37 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:48695 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759AbZHNNsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 09:48:12 -0400
Message-Id: <20090814134811.296703241@de.ibm.com>
References: <20090814134717.859098725@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 14 Aug 2009 15:47:32 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Daniel Walker <dwalker@fifo99.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 15/15] introduce read_boot_clock
Content-Disposition: inline; filename=init_monotonic.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Add the new function read_boot_clock to get the exact time the
system has been started. For architectures without support for
exact boot time a new weak function is added that returns 0.
Use the exact boot time to initialize wall_to_monotonic, or
xtime if the read_boot_clock returned 0.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/kernel/time.c   |   17 +++++------------
 include/linux/time.h      |    1 +
 kernel/time/timekeeping.c |   24 ++++++++++++++++++++++--
 3 files changed, 28 insertions(+), 14 deletions(-)

Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -501,6 +501,21 @@ void __attribute__((weak)) read_persiste
 	ts->tv_nsec = 0;
 }
 
+/**
+ * read_boot_clock -  Return time of the system start.
+ *
+ * Weak dummy function for arches that do not yet support it.
+ * Function to read the exact time the system has been started.
+ * Returns a timespec with tv_sec=0 and tv_nsec=0 if unsupported.
+ *
+ *  XXX - Do be sure to remove it once all arches implement it.
+ */
+void __attribute__((weak)) read_boot_clock(struct timespec *ts)
+{
+	ts->tv_sec = 0;
+	ts->tv_nsec = 0;
+}
+
 /*
  * timekeeping_init - Initializes the clocksource and common timekeeping values
  */
@@ -508,9 +523,10 @@ void __init timekeeping_init(void)
 {
 	struct clocksource *clock;
 	unsigned long flags;
-	struct timespec now;
+	struct timespec now, boot;
 
 	read_persistent_clock(&now);
+	read_boot_clock(&boot);
 
 	write_seqlock_irqsave(&xtime_lock, flags);
 
@@ -525,8 +541,12 @@ void __init timekeeping_init(void)
 	xtime.tv_nsec = now.tv_nsec;
 	raw_time.tv_sec = 0;
 	raw_time.tv_nsec = 0;
+	if (boot.tv_sec == 0 && boot.tv_nsec == 0) {
+		boot.tv_sec = xtime.tv_sec;
+		boot.tv_nsec = xtime.tv_nsec;
+	}
 	set_normalized_timespec(&wall_to_monotonic,
-		-xtime.tv_sec, -xtime.tv_nsec);
+				-boot.tv_sec, -boot.tv_nsec);
 	update_xtime_cache(0);
 	total_sleep_time.tv_sec = 0;
 	total_sleep_time.tv_nsec = 0;
Index: linux-2.6/arch/s390/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/time.c
+++ linux-2.6/arch/s390/kernel/time.c
@@ -187,6 +187,11 @@ void read_persistent_clock(struct timesp
 	tod_to_timeval(get_clock() - TOD_UNIX_EPOCH, ts);
 }
 
+void read_boot_clock(struct timespec *ts)
+{
+	tod_to_timeval(sched_clock_base_cc - TOD_UNIX_EPOCH, ts);
+}
+
 static cycle_t read_tod_clock(struct clocksource *cs)
 {
 	return get_clock();
@@ -243,9 +248,6 @@ void update_vsyscall_tz(void)
  */
 void __init time_init(void)
 {
-	struct timespec ts;
-	unsigned long flags;
-
 	/* Reset time synchronization interfaces. */
 	etr_reset();
 	stp_reset();
@@ -261,15 +263,6 @@ void __init time_init(void)
 	if (clocksource_register(&clocksource_tod) != 0)
 		panic("Could not register TOD clock source");
 
-	/*
-	 * Reset wall_to_monotonic to the initial timestamp created
-	 * in head.S to get a precise value in /proc/uptime.
-	 */
-	write_seqlock_irqsave(&xtime_lock, flags);
-	tod_to_timeval(sched_clock_base_cc - TOD_UNIX_EPOCH, &ts);
-	set_normalized_timespec(&wall_to_monotonic, -ts.tv_sec, -ts.tv_nsec);
-	write_sequnlock_irqrestore(&xtime_lock, flags);
-
 	/* Enable TOD clock interrupts on the boot cpu. */
 	init_cpu_timer();
 
Index: linux-2.6/include/linux/time.h
===================================================================
--- linux-2.6.orig/include/linux/time.h
+++ linux-2.6/include/linux/time.h
@@ -102,6 +102,7 @@ extern struct timespec wall_to_monotonic
 extern seqlock_t xtime_lock;
 
 extern void read_persistent_clock(struct timespec *ts);
+extern void read_boot_clock(struct timespec *ts);
 extern int update_persistent_clock(struct timespec now);
 extern int no_sync_cmos_clock __read_mostly;
 void timekeeping_init(void);

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

