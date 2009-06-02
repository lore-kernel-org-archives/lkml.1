Return-Path: <linux-kernel-owner+w=401wt.eu-S1760159AbZFBHR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159AbZFBHR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759904AbZFBHRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:17:46 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:58940 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760067AbZFBHRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:17:44 -0400
Date: Tue, 2 Jun 2009 16:17:18 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@fifo99.com>,
       Linus Walleij <linus.ml.walleij@gmail.com>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] sched: sched_clock() clocksource handling.
Message-ID: <20090602071718.GA17710@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Daniel Walker <dwalker@fifo99.com>,
	Linus Walleij <linus.ml.walleij@gmail.com>,
	Andrew Victor <linux@maxim.org.za>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	John Stultz <johnstul@linux.vnet.ibm.com>,
	linux-arm-kernel@lists.arm.linux.org.uk, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As there was no additional feedback on the most recent version of this
patch, I'm resubmitting it for inclusion. As far as I know there are no
more outstanding concerns.

--

sched: sched_clock() clocksource handling.

There are presently a number of issues and limitations with how the
clocksource and sched_clock() interaction works today. Configurations
tend to be grouped in to one of the following:

    - Platform provides a clocksource unsuitable for sched_clock()
      and prefers to use the generic jiffies-backed implementation.

    - Platform provides its own clocksource and sched_clock() that
      wraps in to it.

    - Platform uses a generic clocksource (ie, drivers/clocksource/)
      combined with the generic jiffies-backed sched_clock().

    - Platform supports multiple sched_clock()-capable clocksources.

This patch adds a new CLOCK_SOURCE_USE_FOR_SCHED_CLOCK flag to address
these issues, which can be set for any sched_clock()-capable clocksource.

The generic sched_clock() implementation is likewise switched over to
always read from a designated sched_clocksource, which is default
initialized to the jiffies clocksource and updated based on the
availability of CLOCK_SOURCE_USE_FOR_SCHED_CLOCK sources. As this uses
the generic cyc2ns() logic on the clocksource ->read(), most of the
platform-specific sched_clock() implementations can subsequently be
killed off.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 include/linux/clocksource.h |    4 +++-
 kernel/sched_clock.c        |   13 +++++++++++--
 kernel/time/clocksource.c   |   19 +++++++++++++++++++
 kernel/time/jiffies.c       |    2 +-
 4 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
index c56457c..2109940 100644
--- a/include/linux/clocksource.h
+++ b/include/linux/clocksource.h
@@ -202,7 +202,8 @@ struct clocksource {
 #endif
 };
 
-extern struct clocksource *clock;	/* current clocksource */
+extern struct clocksource *clock;		/* current clocksource */
+extern struct clocksource *sched_clocksource;	/* sched_clock() clocksource */
 
 /*
  * Clock source flags bits::
@@ -212,6 +213,7 @@ extern struct clocksource *clock;	/* current clocksource */
 
 #define CLOCK_SOURCE_WATCHDOG			0x10
 #define CLOCK_SOURCE_VALID_FOR_HRES		0x20
+#define CLOCK_SOURCE_USE_FOR_SCHED_CLOCK	0x40
 
 /* simplify initialization of mask field */
 #define CLOCKSOURCE_MASK(bits) (cycle_t)((bits) < 64 ? ((1ULL<<(bits))-1) : -1)
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index e1d16c9..b51d48d 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -30,6 +30,8 @@
 #include <linux/percpu.h>
 #include <linux/ktime.h>
 #include <linux/sched.h>
+#include <linux/clocksource.h>
+#include <linux/rcupdate.h>
 
 /*
  * Scheduler clock - returns current time in nanosec units.
@@ -38,8 +40,15 @@
  */
 unsigned long long __attribute__((weak)) sched_clock(void)
 {
-	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
-					* (NSEC_PER_SEC / HZ);
+	unsigned long long time;
+	struct clocksource *clock;
+
+	rcu_read_lock();
+	clock = rcu_dereference(sched_clocksource);
+	time = cyc2ns(clock, clocksource_read(clock));
+	rcu_read_unlock();
+
+	return time;
 }
 
 static __read_mostly int sched_clock_running;
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 80189f6..3795954 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -25,6 +25,7 @@
  */
 
 #include <linux/clocksource.h>
+#include <linux/rcupdate.h>
 #include <linux/sysdev.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -109,6 +110,7 @@ EXPORT_SYMBOL(timecounter_cyc2time);
 
 /* XXX - Would like a better way for initializing curr_clocksource */
 extern struct clocksource clocksource_jiffies;
+struct clocksource *sched_clocksource = &clocksource_jiffies;
 
 /*[Clocksource internal variables]---------
  * curr_clocksource:
@@ -362,6 +364,9 @@ static struct clocksource *select_clocksource(void)
 	if (next == curr_clocksource)
 		return NULL;
 
+	if (next->flags & CLOCK_SOURCE_USE_FOR_SCHED_CLOCK)
+		sched_clocksource = next;
+
 	return next;
 }
 
@@ -440,7 +445,21 @@ void clocksource_unregister(struct clocksource *cs)
 	list_del(&cs->list);
 	if (clocksource_override == cs)
 		clocksource_override = NULL;
+
 	next_clocksource = select_clocksource();
+
+	/*
+	 * If select_clocksource() fails to find another suitable
+	 * clocksource for sched_clocksource and we are unregistering
+	 * it, switch back to jiffies.
+	 */
+	if (sched_clocksource == cs) {
+		rcu_assign_pointer(sched_clocksource, &clocksource_jiffies);
+		spin_unlock_irqrestore(&clocksource_lock, flags);
+		synchronize_rcu();
+		return;
+	}
+
 	spin_unlock_irqrestore(&clocksource_lock, flags);
 }
 
diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index c3f6c30..727d881 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -52,7 +52,7 @@
 
 static cycle_t jiffies_read(struct clocksource *cs)
 {
-	return (cycle_t) jiffies;
+	return (cycle_t) (jiffies - INITIAL_JIFFIES);
 }
 
 struct clocksource clocksource_jiffies = {
