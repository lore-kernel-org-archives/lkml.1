Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbZA0I2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbZA0I2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 03:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbZA0I2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 03:28:44 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36816 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbZA0I2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 03:28:43 -0500
Message-ID: <497EC3F8.6020100@jp.fujitsu.com>
Date: Tue, 27 Jan 2009 17:21:12 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mingo@redhat.com
Subject: [PATCH 1/3] fix debug message of CPU clock speed
References: <497EC23A.7050408@jp.fujitsu.com>
In-Reply-To: <497EC23A.7050408@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LOCAL APIC is corrected by PM-Timer, when SMI occurred while LOCAL APIC is calibrated.
In this case, LOCAL APIC debug message(Boot with apic=debug) is displayed correctly,
however, CPU clock speed debug message is displayed wrongly .

When SMI occured on my machine, which has 1.6GHz CPU, CPU clock speed is displayed
3622.0205 MHz as follow.

	CPU0: Intel(R) Xeon(R) CPU            5110  @ 1.60GHz stepping 06
	Using local APIC timer interrupts.
	calibrating APIC timer ...
	... lapic delta = 3773130
	... PM timer delta = 812434
	APIC calibration not consistent with PM Timer: 226ms instead of 100ms
	APIC delta adjusted to PM-Timer: 1662420 (3773130)
	..... delta 1662420
	..... mult: 71411249
	..... calibration result: 265987
	..... CPU clock speed is 3622.0205 MHz.  =====>  here
	..... host bus clock speed is 265.0987 MHz.

This patch fixes to displaying CPU clock speed correctly as follow.

	CPU0: Intel(R) Xeon(R) CPU            5110  @ 1.60GHz stepping 06
	Using local APIC timer interrupts.
	calibrating APIC timer ...
	... lapic delta = 3773131
	... PM timer delta = 812434
	APIC calibration not consistent with PM Timer: 226ms instead of 100ms
	APIC delta adjusted to PM-Timer: 1662420 (3773131)
	TSC delta adjusted to PM-Timer: 159592409 (362220564)
	..... delta 1662420
	..... mult: 71411249
	..... calibration result: 265987
	..... CPU clock speed is 1595.0924 MHz.
	..... host bus clock speed is 265.0987 MHz.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

---
 arch/x86/kernel/apic.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

Index: linux-2.6.29-rc2/arch/x86/kernel/apic.c
===================================================================
--- linux-2.6.29-rc2.orig/arch/x86/kernel/apic.c	2009-01-27 11:04:40.000000000 +0900
+++ linux-2.6.29-rc2/arch/x86/kernel/apic.c	2009-01-27 12:29:03.000000000 +0900
@@ -535,7 +535,8 @@ static void __init lapic_cal_handler(str
 	}
 }

-static int __init calibrate_by_pmtimer(long deltapm, long *delta)
+static int __init calibrate_by_pmtimer(long deltapm, long *delta,
+						long *deltatsc)
 {
 	const long pm_100ms = PMTMR_TICKS_PER_SEC / 10;
 	const long pm_thresh = pm_100ms / 100;
@@ -569,6 +570,15 @@ static int __init calibrate_by_pmtimer(l
 		pr_info("APIC delta adjusted to PM-Timer: "
 			"%lu (%ld)\n", (unsigned long)res, *delta);
 		*delta = (long)res;
+
+		if (cpu_has_tsc) {
+			res = (((u64)(*deltatsc)) * pm_100ms);
+			do_div(res, deltapm);
+			apic_printk(APIC_VERBOSE, "TSC delta adjusted to "
+					"PM-Timer: %lu (%ld)\n",
+					(unsigned long)res, *deltatsc);
+			*deltatsc = (long)res;
+		}
 	}

 	return 0;
@@ -579,7 +589,7 @@ static int __init calibrate_APIC_clock(v
 	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
 	void (*real_handler)(struct clock_event_device *dev);
 	unsigned long deltaj;
-	long delta;
+	long delta, deltatsc;
 	int pm_referenced = 0;

 	local_irq_disable();
@@ -609,9 +619,11 @@ static int __init calibrate_APIC_clock(v
 	delta = lapic_cal_t1 - lapic_cal_t2;
 	apic_printk(APIC_VERBOSE, "... lapic delta = %ld\n", delta);

+	deltatsc = (long)(lapic_cal_tsc2 - lapic_cal_tsc1);
+
 	/* we trust the PM based calibration if possible */
 	pm_referenced = !calibrate_by_pmtimer(lapic_cal_pm2 - lapic_cal_pm1,
-					&delta);
+					&delta, &deltatsc);

 	/* Calculate the scaled math multiplication factor */
 	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS,
@@ -629,11 +641,10 @@ static int __init calibrate_APIC_clock(v
 		    calibration_result);

 	if (cpu_has_tsc) {
-		delta = (long)(lapic_cal_tsc2 - lapic_cal_tsc1);
 		apic_printk(APIC_VERBOSE, "..... CPU clock speed is "
 			    "%ld.%04ld MHz.\n",
-			    (delta / LAPIC_CAL_LOOPS) / (1000000 / HZ),
-			    (delta / LAPIC_CAL_LOOPS) % (1000000 / HZ));
+			    (deltatsc / LAPIC_CAL_LOOPS) / (1000000 / HZ),
+			    (deltatsc / LAPIC_CAL_LOOPS) % (1000000 / HZ));
 	}

 	apic_printk(APIC_VERBOSE, "..... host bus clock speed is "


