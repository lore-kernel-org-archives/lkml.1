Return-Path: <linux-kernel-owner+w=401wt.eu-S932066AbXGOQId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbXGOQId (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762530AbXGOQE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:04:58 -0400
Received: from www.osadl.org ([213.239.205.134]:42556 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762111AbXGOQE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:04:56 -0400
Message-Id: <20070715155540.957105574@inhelltoy.tec.linutronix.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jul 2007 16:10:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 07/33] x86_64: Use generic xtime init
Content-Disposition: inline; filename=x86_64-use-generic-xtime-init.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

xtime can be initialized including the cmos update from the generic
timekeeping code. Remove the arch specific implementation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/x86_64/kernel/time.c |   40 +---------------------------------------
 1 file changed, 1 insertion(+), 39 deletions(-)

Index: linux-2.6.22-rc6-mm/arch/x86_64/kernel/time.c
===================================================================
--- linux-2.6.22-rc6-mm.orig/arch/x86_64/kernel/time.c	2007-07-15 17:30:43.000000000 +0200
+++ linux-2.6.22-rc6-mm/arch/x86_64/kernel/time.c	2007-07-15 17:49:03.000000000 +0200
@@ -195,7 +195,7 @@ static irqreturn_t timer_interrupt(int i
 	return IRQ_HANDLED;
 }
 
-static unsigned long get_cmos_time(void)
+unsigned long read_persistent_clock(void)
 {
 	unsigned int year, mon, day, hour, min, sec;
 	unsigned long flags;
@@ -369,11 +369,6 @@ void __init time_init(void)
 {
 	if (nohpet)
 		hpet_address = 0;
-	xtime.tv_sec = get_cmos_time();
-	xtime.tv_nsec = 0;
-
-	set_normalized_timespec(&wall_to_monotonic,
-	                        -xtime.tv_sec, -xtime.tv_nsec);
 
 	if (hpet_arch_init())
 		hpet_address = 0;
@@ -410,54 +405,21 @@ void __init time_init(void)
 	setup_irq(0, &irq0);
 }
 
-
-static long clock_cmos_diff;
-static unsigned long sleep_start;
-
 /*
  * sysfs support for the timer.
  */
 
 static int timer_suspend(struct sys_device *dev, pm_message_t state)
 {
-	/*
-	 * Estimate time zone so that set_time can update the clock
-	 */
-	long cmos_time =  get_cmos_time();
-
-	clock_cmos_diff = -cmos_time;
-	clock_cmos_diff += get_seconds();
-	sleep_start = cmos_time;
 	return 0;
 }
 
 static int timer_resume(struct sys_device *dev)
 {
-	unsigned long flags;
-	unsigned long sec;
-	unsigned long ctime = get_cmos_time();
-	long sleep_length = (ctime - sleep_start) * HZ;
-
-	if (sleep_length < 0) {
-		printk(KERN_WARNING "Time skew detected in timer resume!\n");
-		/* The time after the resume must not be earlier than the time
-		 * before the suspend or some nasty things will happen
-		 */
-		sleep_length = 0;
-		ctime = sleep_start;
-	}
 	if (hpet_address)
 		hpet_reenable();
 	else
 		i8254_timer_resume();
-
-	sec = ctime + clock_cmos_diff;
-	write_seqlock_irqsave(&xtime_lock,flags);
-	xtime.tv_sec = sec;
-	xtime.tv_nsec = 0;
-	jiffies += sleep_length;
-	write_sequnlock_irqrestore(&xtime_lock,flags);
-	touch_softlockup_watchdog();
 	return 0;
 }
 

-- 

