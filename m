Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbZCCQRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbZCCQRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 11:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756866AbZCCQRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 11:17:23 -0500
Received: from mx1.emlix.com ([193.175.82.87]:35430 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756666AbZCCQRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 11:17:21 -0500
References: <E1LeXCe-0006wA-5k@mailer.emlix.com>
User-Agent: quilt/0.46-1
Date: Tue, 03 Mar 2009 16:30:46 +0100
From: Johannes Weiner <jw@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 3/3] xtensa: ccount clocksource
Content-Disposition: inline; filename=xtensa-ccount-clocksource.patch
Message-Id: <E1LeXJ1-00071v-Dy@mailer.emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

Switch to GENERIC_TIME by using the ccount register as a clock source.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 arch/xtensa/Kconfig       |    3 +
 arch/xtensa/kernel/time.c |   92 ++++++++++------------------------------------
 2 files changed, 23 insertions(+), 72 deletions(-)

--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -45,6 +45,9 @@ config HZ
 	int
 	default 100
 
+config GENERIC_TIME
+	def_bool y
+
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -14,6 +14,7 @@
 
 #include <linux/errno.h>
 #include <linux/time.h>
+#include <linux/clocksource.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -29,6 +30,19 @@ unsigned long ccount_per_jiffy;		/* per 
 unsigned long nsec_per_ccount;		/* nsec per ccount increment */
 #endif
 
+static cycle_t ccount_read(void)
+{
+	return (cycle_t)get_ccount();
+}
+
+static struct clocksource ccount_clocksource = {
+	.name = "ccount",
+	.rating = 200,
+	.read = ccount_read,
+	.mask = CLOCKSOURCE_MASK(32),
+	.mult = NSEC_PER_CCOUNT,
+};
+
 static irqreturn_t timer_interrupt(int irq, void *dev_id);
 static struct irqaction timer_irqaction = {
 	.handler =	timer_interrupt,
@@ -38,9 +52,11 @@ static struct irqaction timer_irqaction 
 
 void __init time_init(void)
 {
-	/* The platform must provide a function to calibrate the processor
-	 * speed for the CALIBRATE.
-	 */
+	xtime.tv_nsec = 0;
+	xtime.tv_sec = read_persistent_clock();
+
+	set_normalized_timespec(&wall_to_monotonic,
+		-xtime.tv_sec, -xtime.tv_nsec);
 
 #ifdef CONFIG_XTENSA_CALIBRATE_CCOUNT
 	printk("Calibrating CPU frequency ");
@@ -48,12 +64,7 @@ void __init time_init(void)
 	printk("%d.%02d MHz\n", (int)ccount_per_jiffy/(1000000/HZ),
 			(int)(ccount_per_jiffy/(10000/HZ))%100);
 #endif
-
-	xtime.tv_nsec = 0;
-	xtime.tv_sec = read_persistent_clock();
-
-	set_normalized_timespec(&wall_to_monotonic,
-		-xtime.tv_sec, -xtime.tv_nsec);
+	clocksource_register(&ccount_clocksource);
 
 	/* Initialize the linux timer interrupt. */
 
@@ -61,69 +72,6 @@ void __init time_init(void)
 	set_linux_timer(get_ccount() + CCOUNT_PER_JIFFY);
 }
 
-
-int do_settimeofday(struct timespec *tv)
-{
-	time_t wtm_sec, sec = tv->tv_sec;
-	long wtm_nsec, nsec = tv->tv_nsec;
-	unsigned long delta;
-
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	write_seqlock_irq(&xtime_lock);
-
-	/* This is revolting. We need to set "xtime" correctly. However, the
-	 * value in this location is the value at the most recent update of
-	 * wall time.  Discover what correction gettimeofday() would have
-	 * made, and then undo it!
-	 */
-
-	delta = CCOUNT_PER_JIFFY;
-	delta += get_ccount() - get_linux_timer();
-	nsec -= delta * NSEC_PER_CCOUNT;
-
-	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
-
-	ntp_clear();
-	write_sequnlock_irq(&xtime_lock);
-	return 0;
-}
-
-EXPORT_SYMBOL(do_settimeofday);
-
-
-void do_gettimeofday(struct timeval *tv)
-{
-	unsigned long flags;
-	unsigned long volatile sec, usec, delta, seq;
-
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-
-		sec = xtime.tv_sec;
-		usec = (xtime.tv_nsec / NSEC_PER_USEC);
-
-		delta = get_linux_timer() - get_ccount();
-
-	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
-
-	usec += (((unsigned long) CCOUNT_PER_JIFFY - delta)
-		 * (unsigned long) NSEC_PER_CCOUNT) / NSEC_PER_USEC;
-
-	for (; usec >= 1000000; sec++, usec -= 1000000)
-		;
-
-	tv->tv_sec = sec;
-	tv->tv_usec = usec;
-}
-
-EXPORT_SYMBOL(do_gettimeofday);
-
 /*
  * The timer interrupt is called HZ times per second.
  */

-- 

