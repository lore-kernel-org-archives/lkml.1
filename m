Return-Path: <linux-kernel-owner+w=401wt.eu-S1760578AbXFWN0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760578AbXFWN0Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 09:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbXFWNWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 09:22:15 -0400
Received: from www.osadl.org ([213.239.205.134]:59232 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758023AbXFWNWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 09:22:06 -0400
Message-Id: <20070623124030.710908151@inhelltoy.tec.linutronix.de>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 23 Jun 2007 13:32:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: [patch -mm 13/28] NTP: Move the cmos update code into ntp.c
Content-Disposition: inline; filename=ntp-make-cmos-update-generic.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i386 and sparc64 have the identical code to update the cmos clock.
Move it into kernel/time/ntp.c as there are other architectures
coming along with the same requirements.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: David Miller <davem@davemloft.net>

---
 arch/i386/Kconfig          |    4 +++
 arch/i386/kernel/time.c    |   50 +-------------------------------------
 arch/sparc64/Kconfig       |    4 +++
 arch/sparc64/kernel/time.c |   53 +---------------------------------------
 include/asm-i386/timer.h   |    1 
 include/linux/time.h       |    2 +
 kernel/time/ntp.c          |   59 ++++++++++++++++++++++++++++++++++++++++++---
 7 files changed, 70 insertions(+), 103 deletions(-)

Index: linux-2.6.22-rc4-mm/arch/i386/Kconfig
===================================================================
--- linux-2.6.22-rc4-mm.orig/arch/i386/Kconfig	2007-06-23 14:38:57.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/i386/Kconfig	2007-06-23 14:38:59.000000000 +0200
@@ -18,6 +18,10 @@ config GENERIC_TIME
 	bool
 	default y
 
+config GENERIC_CMOS_UPDATE
+	bool
+	default y
+
 config CLOCKSOURCE_WATCHDOG
 	bool
 	default y
Index: linux-2.6.22-rc4-mm/arch/i386/kernel/time.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/arch/i386/kernel/time.c	2007-06-23 14:38:55.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/i386/kernel/time.c	2007-06-23 14:38:59.000000000 +0200
@@ -207,55 +207,9 @@ unsigned long read_persistent_clock(void
 	return retval;
 }
 
-static void sync_cmos_clock(unsigned long dummy);
-
-static DEFINE_TIMER(sync_cmos_timer, sync_cmos_clock, 0, 0);
-int no_sync_cmos_clock;
-
-static void sync_cmos_clock(unsigned long dummy)
-{
-	struct timeval now, next;
-	int fail = 1;
-
-	/*
-	 * If we have an externally synchronized Linux clock, then update
-	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
-	 * called as close as possible to 500 ms before the new second starts.
-	 * This code is run on a timer.  If the clock is set, that timer
-	 * may not expire at the correct time.  Thus, we adjust...
-	 */
-	if (!ntp_synced())
-		/*
-		 * Not synced, exit, do not restart a timer (if one is
-		 * running, let it run out).
-		 */
-		return;
-
-	do_gettimeofday(&now);
-	if (now.tv_usec >= USEC_AFTER - ((unsigned) TICK_SIZE) / 2 &&
-	    now.tv_usec <= USEC_BEFORE + ((unsigned) TICK_SIZE) / 2)
-		fail = set_rtc_mmss(now.tv_sec);
-
-	next.tv_usec = USEC_AFTER - now.tv_usec;
-	if (next.tv_usec <= 0)
-		next.tv_usec += USEC_PER_SEC;
-
-	if (!fail)
-		next.tv_sec = 659;
-	else
-		next.tv_sec = 0;
-
-	if (next.tv_usec >= USEC_PER_SEC) {
-		next.tv_sec++;
-		next.tv_usec -= USEC_PER_SEC;
-	}
-	mod_timer(&sync_cmos_timer, jiffies + timeval_to_jiffies(&next));
-}
-
-void notify_arch_cmos_timer(void)
+int update_persistent_clock(struct timespec now)
 {
-	if (!no_sync_cmos_clock)
-		mod_timer(&sync_cmos_timer, jiffies + 1);
+	return set_rtc_mmss(now.tv_sec);
 }
 
 extern void (*late_time_init)(void);
Index: linux-2.6.22-rc4-mm/arch/sparc64/kernel/time.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/arch/sparc64/kernel/time.c	2007-06-23 14:38:58.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/sparc64/kernel/time.c	2007-06-23 14:38:59.000000000 +0200
@@ -403,58 +403,9 @@ static struct sparc64_tick_ops hbtick_op
 
 static unsigned long timer_ticks_per_nsec_quotient __read_mostly;
 
-#define TICK_SIZE (tick_nsec / 1000)
-
-#define USEC_AFTER	500000
-#define USEC_BEFORE	500000
-
-static void sync_cmos_clock(unsigned long dummy);
-
-static DEFINE_TIMER(sync_cmos_timer, sync_cmos_clock, 0, 0);
-
-static void sync_cmos_clock(unsigned long dummy)
-{
-	struct timeval now, next;
-	int fail = 1;
-
-	/*
-	 * If we have an externally synchronized Linux clock, then update
-	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
-	 * called as close as possible to 500 ms before the new second starts.
-	 * This code is run on a timer.  If the clock is set, that timer
-	 * may not expire at the correct time.  Thus, we adjust...
-	 */
-	if (!ntp_synced())
-		/*
-		 * Not synced, exit, do not restart a timer (if one is
-		 * running, let it run out).
-		 */
-		return;
-
-	do_gettimeofday(&now);
-	if (now.tv_usec >= USEC_AFTER - ((unsigned) TICK_SIZE) / 2 &&
-	    now.tv_usec <= USEC_BEFORE + ((unsigned) TICK_SIZE) / 2)
-		fail = set_rtc_mmss(now.tv_sec);
-
-	next.tv_usec = USEC_AFTER - now.tv_usec;
-	if (next.tv_usec <= 0)
-		next.tv_usec += USEC_PER_SEC;
-
-	if (!fail)
-		next.tv_sec = 659;
-	else
-		next.tv_sec = 0;
-
-	if (next.tv_usec >= USEC_PER_SEC) {
-		next.tv_sec++;
-		next.tv_usec -= USEC_PER_SEC;
-	}
-	mod_timer(&sync_cmos_timer, jiffies + timeval_to_jiffies(&next));
-}
-
-void notify_arch_cmos_timer(void)
+int update_persistent_clock(struct timespec now)
 {
-	mod_timer(&sync_cmos_timer, jiffies + 1);
+	return set_rtc_mmss(now.tv_sec);
 }
 
 /* Kick start a stopped clock (procedure from the Sun NVRAM/hostid FAQ). */
Index: linux-2.6.22-rc4-mm/include/linux/time.h
===================================================================
--- linux-2.6.22-rc4-mm.orig/include/linux/time.h	2007-06-23 14:38:55.000000000 +0200
+++ linux-2.6.22-rc4-mm/include/linux/time.h	2007-06-23 14:38:59.000000000 +0200
@@ -93,6 +93,8 @@ extern struct timespec wall_to_monotonic
 extern seqlock_t xtime_lock __attribute__((weak));
 
 extern unsigned long read_persistent_clock(void);
+extern int update_persistent_clock(struct timespec now);
+extern int no_sync_cmos_clock __read_mostly;
 void timekeeping_init(void);
 
 static inline unsigned long get_seconds(void)
Index: linux-2.6.22-rc4-mm/kernel/time/ntp.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/kernel/time/ntp.c	2007-06-23 14:38:55.000000000 +0200
+++ linux-2.6.22-rc4-mm/kernel/time/ntp.c	2007-06-23 14:38:59.000000000 +0200
@@ -10,6 +10,7 @@
 
 #include <linux/mm.h>
 #include <linux/time.h>
+#include <linux/timer.h>
 #include <linux/timex.h>
 #include <linux/jiffies.h>
 #include <linux/hrtimer.h>
@@ -187,12 +188,64 @@ u64 current_tick_length(void)
 	return tick_length;
 }
 
+#ifdef CONFIG_GENERIC_CMOS_UPDATE
 
-void __attribute__ ((weak)) notify_arch_cmos_timer(void)
+/* Disable the cmos update - used by virtualization and embedded */
+int no_sync_cmos_clock  __read_mostly;
+
+static void sync_cmos_clock(unsigned long dummy);
+
+static DEFINE_TIMER(sync_cmos_timer, sync_cmos_clock, 0, 0);
+
+static void sync_cmos_clock(unsigned long dummy)
 {
-	return;
+	struct timespec now, next;
+	int fail = 1;
+
+	/*
+	 * If we have an externally synchronized Linux clock, then update
+	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
+	 * called as close as possible to 500 ms before the new second starts.
+	 * This code is run on a timer.  If the clock is set, that timer
+	 * may not expire at the correct time.  Thus, we adjust...
+	 */
+	if (!ntp_synced())
+		/*
+		 * Not synced, exit, do not restart a timer (if one is
+		 * running, let it run out).
+		 */
+		return;
+
+	getnstimeofday(&now);
+	if (abs(xtime.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2)
+		fail = update_persistent_clock(now);
+
+	next.tv_nsec = (NSEC_PER_SEC / 2) - now.tv_nsec;
+	if (next.tv_nsec <= 0)
+		next.tv_nsec += NSEC_PER_SEC;
+
+	if (!fail)
+		next.tv_sec = 659;
+	else
+		next.tv_sec = 0;
+
+	if (next.tv_nsec >= NSEC_PER_SEC) {
+		next.tv_sec++;
+		next.tv_nsec -= NSEC_PER_SEC;
+	}
+	mod_timer(&sync_cmos_timer, jiffies + timespec_to_jiffies(&next));
 }
 
+static void notify_cmos_timer(void)
+{
+	if (no_sync_cmos_clock)
+		mod_timer(&sync_cmos_timer, jiffies + 1);
+}
+
+#else
+static inline void notify_cmos_timer(void) { }
+#endif
+
 /* adjtimex mainly allows reading (and writing, if superuser) of
  * kernel time-keeping variables. used by xntpd.
  */
@@ -357,6 +410,6 @@ leave:	if ((time_status & (STA_UNSYNC|ST
 	txc->stbcnt	   = 0;
 	write_sequnlock_irq(&xtime_lock);
 	do_gettimeofday(&txc->time);
-	notify_arch_cmos_timer();
+	notify_cmos_timer();
 	return(result);
 }
Index: linux-2.6.22-rc4-mm/arch/sparc64/Kconfig
===================================================================
--- linux-2.6.22-rc4-mm.orig/arch/sparc64/Kconfig	2007-06-23 14:38:55.000000000 +0200
+++ linux-2.6.22-rc4-mm/arch/sparc64/Kconfig	2007-06-23 14:38:59.000000000 +0200
@@ -23,6 +23,10 @@ config GENERIC_TIME
 	bool
 	default y
 
+config GENERIC_CMOS_UPDATE
+	bool
+	default y
+
 config GENERIC_CLOCKEVENTS
 	bool
 	default y
Index: linux-2.6.22-rc4-mm/include/asm-i386/timer.h
===================================================================
--- linux-2.6.22-rc4-mm.orig/include/asm-i386/timer.h	2007-06-23 14:38:55.000000000 +0200
+++ linux-2.6.22-rc4-mm/include/asm-i386/timer.h	2007-06-23 14:38:59.000000000 +0200
@@ -12,7 +12,6 @@ unsigned long native_calculate_cpu_khz(v
 
 extern int timer_ack;
 extern int no_timer_check;
-extern int no_sync_cmos_clock;
 extern int recalibrate_cpu_khz(void);
 
 #ifndef CONFIG_PARAVIRT

-- 

