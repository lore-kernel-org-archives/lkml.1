Return-Path: <linux-kernel-owner+w=401wt.eu-S1759804AbXGSKJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759804AbXGSKJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757391AbXGSJzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33072 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbXGSJzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:16 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: tglx@linutronix.de, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [26/58] x86_64: Use generic xtime init
Message-Id: <20070719095511.9C83214E06@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:11 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Thomas Gleixner <tglx@linutronix.de>
xtime can be initialized including the cmos update from the generic
timekeeping code. Remove the arch specific implementation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/time.c |   40 +---------------------------------------
 1 file changed, 1 insertion(+), 39 deletions(-)

Index: linux/arch/x86_64/kernel/time.c
===================================================================
--- linux.orig/arch/x86_64/kernel/time.c
+++ linux/arch/x86_64/kernel/time.c
@@ -193,7 +193,7 @@ static irqreturn_t timer_interrupt(int i
 	return IRQ_HANDLED;
 }
 
-static unsigned long get_cmos_time(void)
+unsigned long read_persistent_clock(void)
 {
 	unsigned int year, mon, day, hour, min, sec;
 	unsigned long flags;
@@ -367,11 +367,6 @@ void __init time_init(void)
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
@@ -408,54 +403,21 @@ void __init time_init(void)
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
 
