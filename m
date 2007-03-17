Return-Path: <linux-kernel-owner+w=401wt.eu-S2992463AbXCPX6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992463AbXCPX6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 19:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992458AbXCPX6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 19:58:07 -0400
Received: from www.osadl.org ([213.239.205.134]:35235 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992469AbXCPX6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 19:58:06 -0400
Subject: [PATCH] i386: trust the PM-Timer calibration of the local APIC
	timer
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Arjan van de Ven <arjan@infradead.org>, Len Brown <lenb@kernel.org>
In-Reply-To: <1174088686.13341.347.camel@localhost.localdomain>
References: <200703161230.03712.maximlevitsky@gmail.com>
	 <1174088686.13341.347.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 01:04:56 +0100
Message-Id: <1174089896.13341.362.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When PM-Timer is available for local APIC timer calibration we can skip
the verification of the calibrated time value. The resulting error is
quite small on a bunch of evaluated platforms and is less harming than
the observed false positives.

We need to keep the verification on systems, which have no PM-Timer to
avoid bogus local APIC timer calibrations in the range of factor 2-10,
which can be observed when swicthing off the PM-timer support in the
kernel configuration.

The wrong calibration values are probably caused by SMM code trying to
emulate a PS/2 keyboard from a (maybe connected or not) USB keyboard.
This prohibits the accurate delivery of PIT interrupts, which are used
to calibrate the local APIC timer. Unfortunately we have no way to
disable this BIOS misfeature in the early boot process.

Add also the dropped cpu_relax() back to the wait loops.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/arch/i386/kernel/apic.c b/arch/i386/kernel/apic.c
index 2383bcf..92f4210 100644
--- a/arch/i386/kernel/apic.c
+++ b/arch/i386/kernel/apic.c
@@ -338,6 +338,7 @@ void __init setup_boot_APIC_clock(void)
 	void (*real_handler)(struct clock_event_device *dev);
 	unsigned long deltaj;
 	long delta, deltapm;
+	int pm_referenced = 0;
 
 	apic_printk(APIC_VERBOSE, "Using local APIC timer interrupts.\n"
 		    "calibrating APIC timer ...\n");
@@ -357,7 +358,8 @@ void __init setup_boot_APIC_clock(void)
 	/* Let the interrupts run */
 	local_irq_enable();
 
-	while(lapic_cal_loops <= LAPIC_CAL_LOOPS);
+	while(lapic_cal_loops <= LAPIC_CAL_LOOPS)
+		cpu_relax();
 
 	local_irq_disable();
 
@@ -394,6 +396,7 @@ void __init setup_boot_APIC_clock(void)
 			       "%lu (%ld)\n", (unsigned long) res, delta);
 			delta = (long) res;
 		}
+		pm_referenced = 1;
 	}
 
 	/* Calculate the scaled math multiplication factor */
@@ -423,68 +426,41 @@ void __init setup_boot_APIC_clock(void)
 		    calibration_result / (1000000 / HZ),
 		    calibration_result % (1000000 / HZ));
 
-
-	apic_printk(APIC_VERBOSE, "... verify APIC timer\n");
-
-	/*
-	 * Setup the apic timer manually
-	 */
 	local_apic_timer_verify_ok = 1;
-	levt->event_handler = lapic_cal_handler;
-	lapic_timer_setup(CLOCK_EVT_MODE_PERIODIC, levt);
-	lapic_cal_loops = -1;
 
-	/* Let the interrupts run */
-	local_irq_enable();
+	/* We trust the pm timer based calibration */
+	if (!pm_referenced) {
+		apic_printk(APIC_VERBOSE, "... verify APIC timer\n");
 
-	while(lapic_cal_loops <= LAPIC_CAL_LOOPS);
+		/*
+		 * Setup the apic timer manually
+		 */
+		levt->event_handler = lapic_cal_handler;
+		lapic_timer_setup(CLOCK_EVT_MODE_PERIODIC, levt);
+		lapic_cal_loops = -1;
 
-	local_irq_disable();
+		/* Let the interrupts run */
+		local_irq_enable();
 
-	/* Stop the lapic timer */
-	lapic_timer_setup(CLOCK_EVT_MODE_SHUTDOWN, levt);
+		while(lapic_cal_loops <= LAPIC_CAL_LOOPS)
+			cpu_relax();
 
-	local_irq_enable();
+		local_irq_disable();
 
-	/* Jiffies delta */
-	deltaj = lapic_cal_j2 - lapic_cal_j1;
-	apic_printk(APIC_VERBOSE, "... jiffies delta = %lu\n", deltaj);
+		/* Stop the lapic timer */
+		lapic_timer_setup(CLOCK_EVT_MODE_SHUTDOWN, levt);
 
-	/* Check, if the PM timer is available */
-	deltapm = lapic_cal_pm2 - lapic_cal_pm1;
-	apic_printk(APIC_VERBOSE, "... PM timer delta = %ld\n", deltapm);
+		local_irq_enable();
 
-	local_apic_timer_verify_ok = 0;
+		/* Jiffies delta */
+		deltaj = lapic_cal_j2 - lapic_cal_j1;
+		apic_printk(APIC_VERBOSE, "... jiffies delta = %lu\n", deltaj);
 
-	if (deltapm) {
-		if (deltapm > (pm_100ms - pm_thresh) &&
-		    deltapm < (pm_100ms + pm_thresh)) {
-			apic_printk(APIC_VERBOSE, "... PM timer result ok\n");
-			/* Check, if the jiffies result is consistent */
-			if (deltaj < LAPIC_CAL_LOOPS-2 ||
-			    deltaj > LAPIC_CAL_LOOPS+2) {
-				/*
-				 * Not sure, what we can do about this one.
-				 * When high resultion timers are active
-				 * and the lapic timer does not stop in C3
-				 * we are fine. Otherwise more trouble might
-				 * be waiting. -- tglx
-				 */
-				printk(KERN_WARNING "Global event device %s "
-				       "has wrong frequency "
-				       "(%lu ticks instead of %d)\n",
-				       global_clock_event->name, deltaj,
-				       LAPIC_CAL_LOOPS);
-			}
-			local_apic_timer_verify_ok = 1;
-		}
-	} else {
 		/* Check, if the jiffies result is consistent */
-		if (deltaj >= LAPIC_CAL_LOOPS-2 &&
-		    deltaj <= LAPIC_CAL_LOOPS+2) {
+		if (deltaj >= LAPIC_CAL_LOOPS-2 && deltaj <= LAPIC_CAL_LOOPS+2)
 			apic_printk(APIC_VERBOSE, "... jiffies result ok\n");
-			local_apic_timer_verify_ok = 1;
-		}
+		else
+			local_apic_timer_verify_ok = 0;
 	}
 
 	if (!local_apic_timer_verify_ok) {


