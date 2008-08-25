Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbYHYFk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbYHYFk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 01:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbYHYFkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 01:40:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:22080 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbYHYFks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 01:40:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sibject;
        b=Obaf95dPxy2Eq9vbaQbmivw+BXA2fqs1+q0EJlTXekreY6EV7QA5WLk98WKTReRoLN
         P8c+jdy1KC4FN0Hiwh+znZjgckpvEp50bPESwy8vacY22s8fq8jYUg2KngR1dEZOf8jd
         3vesrzVHYZq5wCgDnrk0F7qjvYirLd1VCsRi0=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: 
Date: Sun, 24 Aug 2008 22:39:50 -0700
Message-Id: <1219642790-21888-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sibject: [PATCH] x86: let 64 bit to use 32 bit calibrate_apic_clock
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/apic.c |   92 ++-----------------------------------------------
 1 file changed, 5 insertions(+), 87 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic.c
+++ linux-2.6/arch/x86/kernel/apic.c
@@ -478,90 +478,6 @@ static void __cpuinit setup_APIC_timer(v
 	clockevents_register_device(levt);
 }
 
-#ifdef CONFIG_X86_64
-/*
- * In this function we calibrate APIC bus clocks to the external
- * timer. Unfortunately we cannot use jiffies and the timer irq
- * to calibrate, since some later bootup code depends on getting
- * the first irq? Ugh.
- *
- * We want to do the calibration only once since we
- * want to have local timer irqs syncron. CPUs connected
- * by the same APIC bus have the very same bus frequency.
- * And we want to have irqs off anyways, no accidental
- * APIC irq that way.
- */
-
-#define TICK_COUNT 100000000
-
-static int __init calibrate_APIC_clock(void)
-{
-	unsigned apic, apic_start;
-	unsigned long tsc, tsc_start;
-	int result;
-
-	local_irq_disable();
-
-	/*
-	 * Put whatever arbitrary (but long enough) timeout
-	 * value into the APIC clock, we just want to get the
-	 * counter running for calibration.
-	 *
-	 * No interrupt enable !
-	 */
-	__setup_APIC_LVTT(250000000, 0, 0);
-
-	apic_start = apic_read(APIC_TMCCT);
-#ifdef CONFIG_X86_PM_TIMER
-	if (apic_calibrate_pmtmr && pmtmr_ioport) {
-		pmtimer_wait(5000);  /* 5ms wait */
-		apic = apic_read(APIC_TMCCT);
-		result = (apic_start - apic) * 1000L / 5;
-	} else
-#endif
-	{
-		rdtscll(tsc_start);
-
-		do {
-			apic = apic_read(APIC_TMCCT);
-			rdtscll(tsc);
-		} while ((tsc - tsc_start) < TICK_COUNT &&
-				(apic_start - apic) < TICK_COUNT);
-
-		result = (apic_start - apic) * 1000L * tsc_khz /
-					(tsc - tsc_start);
-	}
-
-	local_irq_enable();
-
-	printk(KERN_DEBUG "APIC timer calibration result %d\n", result);
-
-	printk(KERN_INFO "Detected %d.%03d MHz APIC timer.\n",
-		result / 1000 / 1000, result / 1000 % 1000);
-
-	/* Calculate the scaled math multiplication factor */
-	lapic_clockevent.mult = div_sc(result, NSEC_PER_SEC,
-				       lapic_clockevent.shift);
-	lapic_clockevent.max_delta_ns =
-		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
-	lapic_clockevent.min_delta_ns =
-		clockevent_delta2ns(0xF, &lapic_clockevent);
-
-	calibration_result = (result * APIC_DIVISOR) / HZ;
-
-	/*
-	 * Do a sanity check on the APIC calibration result
-	 */
-	if (calibration_result < (1000000 / HZ)) {
-		printk(KERN_WARNING
-			"APIC frequency too slow, disabling apic timer\n");
-		return -1;
-	}
-
-	return 0;
-}
-
-#else
 /*
  * In this functions we calibrate APIC bus clocks to the external timer.
  *
@@ -659,6 +575,7 @@ static int __init calibrate_APIC_clock(v
 	delta = lapic_cal_t1 - lapic_cal_t2;
 	apic_printk(APIC_VERBOSE, "... lapic delta = %ld\n", delta);
 
+#ifdef CONFIG_X86_PM_TIMER
 	/* Check, if the PM timer is available */
 	deltapm = lapic_cal_pm2 - lapic_cal_pm1;
 	apic_printk(APIC_VERBOSE, "... PM timer delta = %ld\n", deltapm);
@@ -687,6 +604,7 @@ static int __init calibrate_APIC_clock(v
 		}
 		pm_referenced = 1;
 	}
+#endif
 
 	/* Calculate the scaled math multiplication factor */
 	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS,
@@ -773,8 +691,6 @@ static int __init calibrate_APIC_clock(v
 	return 0;
 }
 
-#endif
-
 /*
  * Setup the boot APIC
  *
