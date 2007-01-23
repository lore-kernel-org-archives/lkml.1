Return-Path: <linux-kernel-owner+w=401wt.eu-S933142AbXAWWMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbXAWWMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933141AbXAWWMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:12:17 -0500
Received: from www.osadl.org ([213.239.205.134]:35812 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933135AbXAWWAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:00:48 -0500
Message-Id: <20070123211203.731650000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:01:02 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 07/46] GTOD: persistent clock support
Content-Disposition: inline; filename=gtod-persistent-clock-support-core.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <johnstul@us.ibm.com>

Persistent clock support: do proper timekeeping across suspend/resume.

[ cleanup from Adrian Bunk <bunk@stusta.de> ]

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/hrtimer.h |    3 +++
 include/linux/time.h    |    1 +
 kernel/hrtimer.c        |    8 ++++++++
 kernel/timer.c          |   37 ++++++++++++++++++++++++++++++++++++-
 4 files changed, 48 insertions(+), 1 deletion(-)

Index: linux-2.6.20-rc4-mm1-bo/include/linux/hrtimer.h
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/include/linux/hrtimer.h
+++ linux-2.6.20-rc4-mm1-bo/include/linux/hrtimer.h
@@ -146,6 +146,9 @@ extern void hrtimer_init_sleeper(struct 
 /* Soft interrupt function to run the hrtimer queues: */
 extern void hrtimer_run_queues(void);
 
+/* Resume notification */
+void hrtimer_notify_resume(void);
+
 /* Bootup initialization: */
 extern void __init hrtimers_init(void);
 
Index: linux-2.6.20-rc4-mm1-bo/include/linux/time.h
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/include/linux/time.h
+++ linux-2.6.20-rc4-mm1-bo/include/linux/time.h
@@ -92,6 +92,7 @@ extern struct timespec xtime;
 extern struct timespec wall_to_monotonic;
 extern seqlock_t xtime_lock __attribute__((weak));
 
+extern unsigned long read_persistent_clock(void);
 void timekeeping_init(void);
 
 static inline unsigned long get_seconds(void)
Index: linux-2.6.20-rc4-mm1-bo/kernel/hrtimer.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/kernel/hrtimer.c
+++ linux-2.6.20-rc4-mm1-bo/kernel/hrtimer.c
@@ -292,6 +292,14 @@ static unsigned long ktime_divns(const k
 #endif /* BITS_PER_LONG >= 64 */
 
 /*
+ * Timekeeping resumed notification
+ */
+void hrtimer_notify_resume(void)
+{
+	clock_was_set();
+}
+
+/*
  * Counterpart to lock_timer_base above:
  */
 static inline
Index: linux-2.6.20-rc4-mm1-bo/kernel/timer.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/kernel/timer.c
+++ linux-2.6.20-rc4-mm1-bo/kernel/timer.c
@@ -878,12 +878,27 @@ int timekeeping_is_continuous(void)
 	return ret;
 }
 
+/**
+ * read_persistent_clock -  Return time in seconds from the persistent clock.
+ *
+ * Weak dummy function for arches that do not yet support it.
+ * Returns seconds from epoch using the battery backed persistent clock.
+ * Returns zero if unsupported.
+ *
+ *  XXX - Do be sure to remove it once all arches implement it.
+ */
+unsigned long __attribute__((weak)) read_persistent_clock(void)
+{
+	return 0;
+}
+
 /*
  * timekeeping_init - Initializes the clocksource and common timekeeping values
  */
 void __init timekeeping_init(void)
 {
 	unsigned long flags;
+	unsigned long sec = read_persistent_clock();
 
 	write_seqlock_irqsave(&xtime_lock, flags);
 
@@ -893,11 +908,20 @@ void __init timekeeping_init(void)
 	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 	clock->cycle_last = clocksource_read(clock);
 
+	xtime.tv_sec = sec;
+	xtime.tv_nsec = 0;
+	set_normalized_timespec(&wall_to_monotonic,
+		-xtime.tv_sec, -xtime.tv_nsec);
+
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 }
 
 
+/* flag for if timekeeping is suspended */
 static int timekeeping_suspended;
+/* time in seconds when suspend began */
+static unsigned long timekeeping_suspend_time;
+
 /**
  * timekeeping_resume - Resumes the generic timekeeping subsystem.
  * @dev:	unused
@@ -909,13 +933,23 @@ static int timekeeping_suspended;
 static int timekeeping_resume(struct sys_device *dev)
 {
 	unsigned long flags;
+	unsigned long now = read_persistent_clock();
 
 	write_seqlock_irqsave(&xtime_lock, flags);
-	/* restart the last cycle value */
+
+	if (now && (now > timekeeping_suspend_time)) {
+		unsigned long sleep_length = now - timekeeping_suspend_time;
+		xtime.tv_sec += sleep_length;
+		jiffies_64 += (u64)sleep_length * HZ;
+	}
+	/* re-base the last cycle value */
 	clock->cycle_last = clocksource_read(clock);
 	clock->error = 0;
 	timekeeping_suspended = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
+
+	hrtimer_notify_resume();
+
 	return 0;
 }
 
@@ -925,6 +959,7 @@ static int timekeeping_suspend(struct sy
 
 	write_seqlock_irqsave(&xtime_lock, flags);
 	timekeeping_suspended = 1;
+	timekeeping_suspend_time = read_persistent_clock();
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 	return 0;
 }

--

