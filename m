Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbXCaIfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbXCaIfo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 04:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbXCaIfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 04:35:43 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:35785 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbXCaIfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 04:35:42 -0400
Message-Id: <20070331083329.539511000@sous-sol.org>
References: <20070331083149.997762000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Sat, 31 Mar 2007 01:31:52 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/5] x86_64: drive set_rtc_mss from standalone timer
Content-Disposition: inline; filename=x86_64-use-timer-for-set_rtc_mmss.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is how it's done on i386, and it makes one less bit
of code to trim from main_timer_handler() when converting
to clockevents.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
---
 arch/x86_64/kernel/time.c |   68 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 52 insertions(+), 16 deletions(-)

--- linus-2.6.orig/arch/x86_64/kernel/time.c
+++ linus-2.6/arch/x86_64/kernel/time.c
@@ -81,8 +81,9 @@ EXPORT_SYMBOL(profile_pc);
  * sheet for details.
  */
 
-static void set_rtc_mmss(unsigned long nowtime)
+static int set_rtc_mmss(unsigned long nowtime)
 {
+	int retval = 0;
 	int real_seconds, real_minutes, cmos_minutes;
 	unsigned char control, freq_select;
 
@@ -122,6 +123,7 @@ static void set_rtc_mmss(unsigned long n
 	if (abs(real_minutes - cmos_minutes) >= 30) {
 		printk(KERN_WARNING "time.c: can't update CMOS clock "
 		       "from %d to %d\n", cmos_minutes, real_minutes);
+		retval = -1;
 	} else {
 		BIN_TO_BCD(real_seconds);
 		BIN_TO_BCD(real_minutes);
@@ -141,12 +143,60 @@ static void set_rtc_mmss(unsigned long n
 	CMOS_WRITE(freq_select, RTC_FREQ_SELECT);
 
 	spin_unlock(&rtc_lock);
+
+	return retval;
+}
+
+static void sync_cmos_clock(unsigned long dummy);
+
+static DEFINE_TIMER(sync_cmos_timer, sync_cmos_clock, 0, 0);
+
+static void sync_cmos_clock(unsigned long dummy)
+{
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
+	if (abs(xtime.tv_nsec - 500000000) <= tick_nsec / 2)
+		fail = set_rtc_mmss(now.tv_sec);
+
+	next.tv_nsec = 500000000 - now.tv_nsec;
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
 
+void notify_arch_cmos_timer(void)
+{
+	mod_timer(&sync_cmos_timer, jiffies + 1);
+}
 
 void main_timer_handler(void)
 {
-	static unsigned long rtc_update = 0;
 /*
  * Here we are in the timer irq handler. We have irqs locally disabled (so we
  * don't need spin_lock_irqsave()) but we don't know if the timer_bh is running
@@ -174,20 +224,6 @@ void main_timer_handler(void)
 	if (!using_apic_timer)
 		smp_local_timer_interrupt();
 
-/*
- * If we have an externally synchronized Linux clock, then update CMOS clock
- * accordingly every ~11 minutes. set_rtc_mmss() will be called in the jiffy
- * closest to exactly 500 ms before the next second. If the update fails, we
- * don't care, as it'll be updated on the next turn, and the problem (time way
- * off) isn't likely to go away much sooner anyway.
- */
-
-	if (ntp_synced() && xtime.tv_sec > rtc_update &&
-		abs(xtime.tv_nsec - 500000000) <= tick_nsec / 2) {
-		set_rtc_mmss(xtime.tv_sec);
-		rtc_update = xtime.tv_sec + 660;
-	}
- 
 	write_sequnlock(&xtime_lock);
 }
 

--
