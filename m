Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbZCCQRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbZCCQRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 11:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbZCCQRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 11:17:19 -0500
Received: from mx1.emlix.com ([193.175.82.87]:57503 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755905AbZCCQRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 11:17:18 -0500
References: <E1LeXCe-0006wA-5k@mailer.emlix.com>
User-Agent: quilt/0.46-1
Date: Tue, 03 Mar 2009 16:30:45 +0100
From: Johannes Weiner <jw@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 2/3] xtensa: remove platform rtc hooks
Content-Disposition: inline; filename=xtensa-remove-platform-rtc.patch
Message-Id: <E1LeXIx-00071s-Tp@mailer.emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

platform_get/set_rtc_time() is not implemented by any of the supported
xtensa platforms.  Remove the facility completely.

The initial seconds for xtime come from read_persistent_clock() which
returns just 0 in the generic implementation.  Platforms that sport a
persistent clock can implement this function.

This is needed to implement the ccount register as a clock source.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 arch/xtensa/include/asm/platform.h |   11 -----------
 arch/xtensa/kernel/platform.c      |    2 --
 arch/xtensa/kernel/time.c          |   29 +----------------------------
 3 files changed, 1 insertion(+), 41 deletions(-)

--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -14,7 +14,6 @@
 
 #include <linux/errno.h>
 #include <linux/time.h>
-#include <linux/timex.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -25,18 +24,11 @@
 #include <asm/timex.h>
 #include <asm/platform.h>
 
-
-DEFINE_SPINLOCK(rtc_lock);
-EXPORT_SYMBOL(rtc_lock);
-
-
 #ifdef CONFIG_XTENSA_CALIBRATE_CCOUNT
 unsigned long ccount_per_jiffy;		/* per 1/HZ */
 unsigned long nsec_per_ccount;		/* nsec per ccount increment */
 #endif
 
-static long last_rtc_update = 0;
-
 static irqreturn_t timer_interrupt(int irq, void *dev_id);
 static struct irqaction timer_irqaction = {
 	.handler =	timer_interrupt,
@@ -46,8 +38,6 @@ static struct irqaction timer_irqaction 
 
 void __init time_init(void)
 {
-	time_t sec_o, sec_n = 0;
-
 	/* The platform must provide a function to calibrate the processor
 	 * speed for the CALIBRATE.
 	 */
@@ -59,15 +49,8 @@ void __init time_init(void)
 			(int)(ccount_per_jiffy/(10000/HZ))%100);
 #endif
 
-	/* Set time from RTC (if provided) */
-
-	if (platform_get_rtc_time(&sec_o) == 0)
-		while (platform_get_rtc_time(&sec_n))
-			if (sec_o != sec_n)
-				break;
-
 	xtime.tv_nsec = 0;
-	last_rtc_update = xtime.tv_sec = sec_n;
+	xtime.tv_sec = read_persistent_clock();
 
 	set_normalized_timespec(&wall_to_monotonic,
 		-xtime.tv_sec, -xtime.tv_nsec);
@@ -169,16 +152,6 @@ again:
 		next += CCOUNT_PER_JIFFY;
 		set_linux_timer(next);
 
-		if (ntp_synced() &&
-		    xtime.tv_sec - last_rtc_update >= 659 &&
-		    abs((xtime.tv_nsec/1000)-(1000000-1000000/HZ))<5000000/HZ) {
-
-			if (platform_set_rtc_time(xtime.tv_sec+1) == 0)
-				last_rtc_update = xtime.tv_sec+1;
-			else
-				/* Do it again in 60 s */
-				last_rtc_update += 60;
-		}
 		write_sequnlock(&xtime_lock);
 	}
 
--- a/arch/xtensa/include/asm/platform.h
+++ b/arch/xtensa/include/asm/platform.h
@@ -74,16 +74,5 @@ extern int platform_pcibios_fixup (void)
  */
 extern void platform_calibrate_ccount (void);
 
-/*
- * platform_get_rtc_time returns RTC seconds (returns 0 for no error)
- */
-extern int platform_get_rtc_time(time_t*);
-
-/*
- * platform_set_rtc_time set RTC seconds (returns 0 for no error)
- */
-extern int platform_set_rtc_time(time_t);
-
-
 #endif	/* _XTENSA_PLATFORM_H */
 
--- a/arch/xtensa/kernel/platform.c
+++ b/arch/xtensa/kernel/platform.c
@@ -36,8 +36,6 @@ _F(void, power_off, (void), { while(1); 
 _F(void, idle, (void), { __asm__ __volatile__ ("waiti 0" ::: "memory"); });
 _F(void, heartbeat, (void), { });
 _F(int,  pcibios_fixup, (void), { return 0; });
-_F(int, get_rtc_time, (time_t* t), { return 0; });
-_F(int, set_rtc_time, (time_t t), { return 0; });
 
 #ifdef CONFIG_XTENSA_CALIBRATE_CCOUNT
 _F(void, calibrate_ccount, (void),

-- 

