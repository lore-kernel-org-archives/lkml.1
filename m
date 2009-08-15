Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbZHOJFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbZHOJFc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 05:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZHOJF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 05:05:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:55414 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbZHOJF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 05:05:26 -0400
Date: Sat, 15 Aug 2009 09:04:33 GMT
From: tip-bot for Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, dwalker@fifo99.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: dwalker@fifo99.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       schwidefsky@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090814134811.296703241@de.ibm.com>
References: <20090814134811.296703241@de.ibm.com>
Subject: [tip:timers/core] timekeeping: Introduce read_boot_clock
Message-ID: <tip-23970e389e9cee43c4b41023935e1417271708b2@git.kernel.org>
Git-Commit-ID: 23970e389e9cee43c4b41023935e1417271708b2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 15 Aug 2009 09:04:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23970e389e9cee43c4b41023935e1417271708b2
Gitweb:     http://git.kernel.org/tip/23970e389e9cee43c4b41023935e1417271708b2
Author:     Martin Schwidefsky <schwidefsky@de.ibm.com>
AuthorDate: Fri, 14 Aug 2009 15:47:32 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 15 Aug 2009 10:55:47 +0200

timekeeping: Introduce read_boot_clock

Add the new function read_boot_clock to get the exact time the system
has been started. For architectures without support for exact boot
time a new weak function is added that returns 0.  Use the exact boot
time to initialize wall_to_monotonic, or xtime if the read_boot_clock
returned 0.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
LKML-Reference: <20090814134811.296703241@de.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 arch/s390/kernel/time.c   |   17 +++++------------
 include/linux/time.h      |    1 +
 kernel/time/timekeeping.c |   24 ++++++++++++++++++++++--
 3 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index a94ec48..6bff1a1 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -187,6 +187,11 @@ void read_persistent_clock(struct timespec *ts)
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
 
diff --git a/include/linux/time.h b/include/linux/time.h
index 53a3216..f505988 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -102,6 +102,7 @@ extern struct timespec wall_to_monotonic;
 extern seqlock_t xtime_lock;
 
 extern void read_persistent_clock(struct timespec *ts);
+extern void read_boot_clock(struct timespec *ts);
 extern int update_persistent_clock(struct timespec now);
 extern int no_sync_cmos_clock __read_mostly;
 void timekeeping_init(void);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index f1a21ce..15e06de 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -501,6 +501,21 @@ void __attribute__((weak)) read_persistent_clock(struct timespec *ts)
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
