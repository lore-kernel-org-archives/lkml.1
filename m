Return-Path: <linux-kernel-owner+w=401wt.eu-S932785AbXAaD50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785AbXAaD50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932803AbXAaD50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:57:26 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:2325 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932785AbXAaD5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:57:24 -0500
Message-Id: <20070131033810.319576375@mvista.com>
References: <20070131033710.420168478@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Tue, 30 Jan 2007 19:37:33 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
Subject: [PATCH 23/23] clocksource tsc: add verify routine
Content-Disposition: inline; filename=generic-tsc-verifiy-clock.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've included this as another user of the clocksource interface. I don't see a
usage for this across all achitectures. So a fully generic version isn't needed.

I modified this from the pre 2.6.20-rc6-mm2 release to make the routine smaller
and to make it select a clocksource inside the timer. It should work with an HPET.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 arch/i386/kernel/tsc.c      |   55 ++++++++++++++++++++++++++++----------------
 include/linux/clocksource.h |   16 ++++++++++++
 2 files changed, 51 insertions(+), 20 deletions(-)

Index: linux-2.6.19/arch/i386/kernel/tsc.c
===================================================================
--- linux-2.6.19.orig/arch/i386/kernel/tsc.c
+++ linux-2.6.19/arch/i386/kernel/tsc.c
@@ -343,47 +343,59 @@ static struct dmi_system_id __initdata b
 	 {}
 };
 
-#define TSC_FREQ_CHECK_INTERVAL (10*MSEC_PER_SEC) /* 10sec in MS */
+#define WATCHDOG_TRESHOLD (NSEC_PER_SEC >> 4)
+#define TSC_FREQ_CHECK_INTERVAL (MSEC_PER_SEC/2)
 static struct timer_list verify_tsc_freq_timer;
+struct clocksource *verify_clock;
 
 /* XXX - Probably should add locking */
 static void verify_tsc_freq(unsigned long unused)
 {
-	static u64 last_tsc;
-	static unsigned long last_jiffies;
-
-	u64 now_tsc, interval_tsc;
-	unsigned long now_jiffies, interval_jiffies;
+	static cycle_t last_tsc, last_verify;
 
+	cycle_t now_tsc, verify_clock_now, interval;
+	s64 nsecs;
 
 	if (check_tsc_unstable())
 		return;
 
-	rdtscll(now_tsc);
-	now_jiffies = jiffies;
+	if (unlikely(system_state != SYSTEM_RUNNING))
+		goto out_timer;
 
-	if (!last_jiffies) {
-		goto out;
+	if (unlikely(!verify_clock)) {
+		verify_clock =
+			clocksource_get_masked_clock(CLOCKSOURCE_PM_AFFECTED);
+		printk("TSC: selected %s clocksource for TSC verification.\n",
+		       verify_clock->name);
 	}
 
-	interval_jiffies = now_jiffies - last_jiffies;
-	interval_tsc = now_tsc - last_tsc;
-	interval_tsc *= HZ;
-	do_div(interval_tsc, cpu_khz*1000);
+	now_tsc = clocksource_read(&clocksource_tsc);
+	verify_clock_now = clocksource_read(verify_clock);
+
+	if (!last_tsc)
+		goto out;
 
-	if (interval_tsc < (interval_jiffies * 3 / 4)) {
+	interval = clocksource_subtract(verify_clock, verify_clock_now,
+					last_verify);
+	nsecs = cyc2ns(verify_clock, interval);
+
+	interval = clocksource_subtract(&clocksource_tsc, now_tsc, last_tsc);
+	nsecs -= cyc2ns(&clocksource_tsc, interval);
+
+	if (nsecs > WATCHDOG_TRESHOLD) {
 		printk("TSC appears to be running slowly. "
-			"Marking it as unstable\n");
+		       "Marking it as unstable");
 		mark_tsc_unstable();
 		return;
 	}
 
 out:
-	last_tsc = now_tsc;
-	last_jiffies = now_jiffies;
+  	last_tsc = now_tsc;
+	last_verify = verify_clock_now;
+out_timer:
 	/* set us up to go off on the next interval: */
 	mod_timer(&verify_tsc_freq_timer,
-		jiffies + msecs_to_jiffies(TSC_FREQ_CHECK_INTERVAL));
+		  jiffies + msecs_to_jiffies(TSC_FREQ_CHECK_INTERVAL));
 }
 
 /*
@@ -444,7 +456,10 @@ static int __init init_tsc_clocksource(v
 		if (check_tsc_unstable())
 			clocksource_tsc.flags |= CLOCKSOURCE_UNSTABLE |
 						 CLOCKSOURCE_NOT_CONTINUOUS;
-
+		/*
+		 * The verify routine will select the right clock after the
+		 * system boots fully.
+		 */
 		init_timer(&verify_tsc_freq_timer);
 		verify_tsc_freq_timer.function = verify_tsc_freq;
 		verify_tsc_freq_timer.expires =
Index: linux-2.6.19/include/linux/clocksource.h
===================================================================
--- linux-2.6.19.orig/include/linux/clocksource.h
+++ linux-2.6.19/include/linux/clocksource.h
@@ -207,6 +207,22 @@ static inline s64 cyc2ns(struct clocksou
 }
 
 /**
+ * clocksource_subtract - Subtract two cycle_t timestamps
+ * @cs:		Clocksource the timestamp came from
+ * @stop:	Stop timestamp
+ * @start:	Start timestamp
+ *
+ * This subtract accounts for rollover by using the clocksource mask.
+ * The clock can roll over only once, after that this subtract will not
+ * work properly.
+ */
+static inline s64 clocksource_subtract(struct clocksource* cs, cycle_t stop,
+				       cycle_t start)
+{
+	return ((stop - start) & cs->mask);
+}
+
+/**
  * clocksource_calculate_interval - Calculates a clocksource interval struct
  *
  * @c:		Pointer to clocksource.

-- 
