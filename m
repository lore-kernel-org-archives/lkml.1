Return-Path: <linux-kernel-owner+w=401wt.eu-S1751027AbXDCCwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751027AbXDCCwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 22:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbXDCCwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 22:52:14 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43694 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbXDCCwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 22:52:13 -0400
Subject: [RFC] [PATCH] persistent_clock() for x86_64
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 19:52:09 -0700
Message-Id: <1175568729.5201.87.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the get_cmos_time() function to
read_persistent_clock(), which allows x86_64 to utilize the full generic
timekeeping suspend/resume code path.

Unfortunately I don't have any x86_64 boxes that suspend/resume to play
w/ so this is mostly untested (but uses the same generic code path as
i386).

Any thoughts or comments?

thanks
-john


Signed-off-by: John Stultz <johnstul@us.ibm.com>


 time.c |   43 +------------------------------------------
 1 file changed, 1 insertion(+), 42 deletions(-)

diff --git a/arch/x86_64/kernel/time.c b/arch/x86_64/kernel/time.c
index 75d73a9..df09c65 100644
--- a/arch/x86_64/kernel/time.c
+++ b/arch/x86_64/kernel/time.c
@@ -201,7 +201,7 @@ static irqreturn_t timer_interrupt(int i
 	return IRQ_HANDLED;
 }
 
-static unsigned long get_cmos_time(void)
+unsigned long read_persistent_clock(void)
 {
 	unsigned int year, mon, day, hour, min, sec;
 	unsigned long flags;
@@ -327,11 +327,6 @@ void __init time_init(void)
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
@@ -364,59 +359,23 @@ void __init time_init(void)
 }
 
 
-static long clock_cmos_diff;
-static unsigned long sleep_start;
-
 /*
  * sysfs support for the timer.
  */
 
-static int timer_suspend(struct sys_device *dev, pm_message_t state)
-{
-	/*
-	 * Estimate time zone so that set_time can update the clock
-	 */
-	long cmos_time =  get_cmos_time();
-
-	clock_cmos_diff = -cmos_time;
-	clock_cmos_diff += get_seconds();
-	sleep_start = cmos_time;
-	return 0;
-}
-
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
 
-	sec = ctime + clock_cmos_diff;
-	write_seqlock_irqsave(&xtime_lock,flags);
-	xtime.tv_sec = sec;
-	xtime.tv_nsec = 0;
-	jiffies += sleep_length;
-	write_sequnlock_irqrestore(&xtime_lock,flags);
 	touch_softlockup_watchdog();
 	return 0;
 }
 
 static struct sysdev_class timer_sysclass = {
 	.resume = timer_resume,
-	.suspend = timer_suspend,
 	set_kset_name("timer"),
 };
 


