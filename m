Return-Path: <linux-kernel-owner+w=401wt.eu-S1765893AbXEUTdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765893AbXEUTdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758318AbXEUTWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:22:05 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46462 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765495AbXEUTWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:22:01 -0400
Message-Id: <20070521191733.986725000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:50 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       johnstul@us.ibm.com, ak@suse.de, tglx@linutronix.de, mingo@elte.hu
Subject: [patch 38/69] clocksource: fix resume logic
Content-Disposition: inline; filename=clocksource-fix-resume-logic.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Thomas Gleixner <tglx@linutronix.de>

We need to make sure that the clocksources are resumed, when timekeeping is
resumed.  The current resume logic does not guarantee this.

Add a resume function pointer to the clocksource struct, so clocksource
drivers which need to reinitialize the clocksource can provide a resume
function.

Add a resume function, which calls the maybe available clocksource resume
functions and resets the watchdog function, so a stable TSC can be used
accross suspend/resume.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 include/linux/clocksource.h |    3 ++
 kernel/time/clocksource.c   |   45 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/timer.c              |    2 +
 3 files changed, 50 insertions(+)

--- linux-2.6.21.1.orig/include/linux/clocksource.h
+++ linux-2.6.21.1/include/linux/clocksource.h
@@ -48,6 +48,7 @@ struct clocksource;
  * @shift:		cycle to nanosecond divisor (power of two)
  * @flags:		flags describing special properties
  * @vread:		vsyscall based read
+ * @resume:		resume function for the clocksource, if necessary
  * @cycle_interval:	Used internally by timekeeping core, please ignore.
  * @xtime_interval:	Used internally by timekeeping core, please ignore.
  */
@@ -61,6 +62,7 @@ struct clocksource {
 	u32 shift;
 	unsigned long flags;
 	cycle_t (*vread)(void);
+	void (*resume)(void);
 
 	/* timekeeping specific data, ignore */
 	cycle_t cycle_last, cycle_interval;
@@ -198,6 +200,7 @@ static inline void clocksource_calculate
 extern int clocksource_register(struct clocksource*);
 extern struct clocksource* clocksource_get_next(void);
 extern void clocksource_change_rating(struct clocksource *cs, int rating);
+extern void clocksource_resume(void);
 
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
--- linux-2.6.21.1.orig/kernel/time/clocksource.c
+++ linux-2.6.21.1/kernel/time/clocksource.c
@@ -74,6 +74,8 @@ static struct clocksource *watchdog;
 static struct timer_list watchdog_timer;
 static DEFINE_SPINLOCK(watchdog_lock);
 static cycle_t watchdog_last;
+static int watchdog_resumed;
+
 /*
  * Interval: 0.5sec Treshold: 0.0625s
  */
@@ -98,15 +100,26 @@ static void clocksource_watchdog(unsigne
 	struct clocksource *cs, *tmp;
 	cycle_t csnow, wdnow;
 	int64_t wd_nsec, cs_nsec;
+	int resumed;
 
 	spin_lock(&watchdog_lock);
 
+	resumed = watchdog_resumed;
+	if (unlikely(resumed))
+		watchdog_resumed = 0;
+
 	wdnow = watchdog->read();
 	wd_nsec = cyc2ns(watchdog, (wdnow - watchdog_last) & watchdog->mask);
 	watchdog_last = wdnow;
 
 	list_for_each_entry_safe(cs, tmp, &watchdog_list, wd_list) {
 		csnow = cs->read();
+
+		if (unlikely(resumed)) {
+			cs->wd_last = csnow;
+			continue;
+		}
+
 		/* Initialized ? */
 		if (!(cs->flags & CLOCK_SOURCE_WATCHDOG)) {
 			if ((cs->flags & CLOCK_SOURCE_IS_CONTINUOUS) &&
@@ -136,6 +149,13 @@ static void clocksource_watchdog(unsigne
 	}
 	spin_unlock(&watchdog_lock);
 }
+static void clocksource_resume_watchdog(void)
+{
+	spin_lock(&watchdog_lock);
+	watchdog_resumed = 1;
+	spin_unlock(&watchdog_lock);
+}
+
 static void clocksource_check_watchdog(struct clocksource *cs)
 {
 	struct clocksource *cse;
@@ -182,9 +202,34 @@ static void clocksource_check_watchdog(s
 	if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS)
 		cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
 }
+
+static inline void clocksource_resume_watchdog(void) { }
 #endif
 
 /**
+ * clocksource_resume - resume the clocksource(s)
+ */
+void clocksource_resume(void)
+{
+	struct list_head *tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&clocksource_lock, flags);
+
+	list_for_each(tmp, &clocksource_list) {
+		struct clocksource *cs;
+
+		cs = list_entry(tmp, struct clocksource, list);
+		if (cs->resume)
+			cs->resume();
+	}
+
+	clocksource_resume_watchdog();
+
+	spin_unlock_irqrestore(&clocksource_lock, flags);
+}
+
+/**
  * clocksource_get_next - Returns the selected clocksource
  *
  */
--- linux-2.6.21.1.orig/kernel/timer.c
+++ linux-2.6.21.1/kernel/timer.c
@@ -1903,6 +1903,8 @@ unregister_time_interpolator(struct time
 		prev = &curr->next;
 	}
 
+	clocksource_resume();
+
 	write_seqlock_irqsave(&xtime_lock, flags);
 	if (ti == time_interpolator) {
 		/* we lost the best time-interpolator: */

-- 
