Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbYILT62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbYILT62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 15:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbYILT6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 15:58:20 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:64723 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbYILT6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 15:58:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=XzJQJZPilqdsfTKSX06ztdAtIUyhATiCqNbOrNezSu3G5zYAa0zCE8afr/uBYbuk5v
         hg5V+dTPU5fvdVcpjVWtbDV257vEA05WsrH/QiyqO+BHIzUOeXonVKse3dHUiFMU2s0U
         rVVPP/P4OdAvNxK95o3OB84RxIRSEHBxVaFQ8=
Date: Fri, 12 Sep 2008 23:58:24 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: apic - fix unused vars warning in calibrate_APIC_clock
Message-ID: <20080912195824.GA8410@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we don't have CONFIG_X86_PM_TIMER=y compiler warns about
unused variables. Move PM timer based calibration into a
separate procedure and make the compiler happy.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Please review.

Index: linux-2.6.git/arch/x86/kernel/apic.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic.c	2008-09-12 22:46:40.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic.c	2008-09-12 23:55:49.000000000 +0400
@@ -538,14 +538,51 @@ static void __init lapic_cal_handler(str
 	}
 }
 
+static int __init calibrate_by_pmtimer(long deltapm, long *delta)
+{
+	const long pm_100ms = PMTMR_TICKS_PER_SEC / 10;
+	const long pm_thresh = pm_100ms / 100;
+	unsigned long mult;
+	u64 res;
+
+#ifndef CONFIG_X86_PM_TIMER
+	return -1;
+#endif
+
+	apic_printk(APIC_VERBOSE, "... PM timer delta = %ld\n", deltapm);
+
+	/* Check, if the PM timer is available */
+	if (!deltapm)
+		return -1;
+
+	mult = clocksource_hz2mult(PMTMR_TICKS_PER_SEC, 22);
+
+	if (deltapm > (pm_100ms - pm_thresh) &&
+	    deltapm < (pm_100ms + pm_thresh)) {
+		apic_printk(APIC_VERBOSE, "... PM timer result ok\n");
+	} else {
+		res = (((u64)deltapm) *  mult) >> 22;
+		do_div(res, 1000000);
+		printk(KERN_WARNING "APIC calibration not consistent "
+			"with PM Timer: %ldms instead of 100ms\n",
+			(long)res);
+		/* Correct the lapic counter value */
+		res = (((u64)(*delta)) * pm_100ms);
+		do_div(res, deltapm);
+		printk(KERN_INFO "APIC delta adjusted to PM-Timer: "
+			"%lu (%ld)\n", (unsigned long)res, *delta);
+		*delta = (long)res;
+	}
+
+	return 0;
+}
+
 static int __init calibrate_APIC_clock(void)
 {
 	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
-	const long pm_100ms = PMTMR_TICKS_PER_SEC/10;
-	const long pm_thresh = pm_100ms/100;
 	void (*real_handler)(struct clock_event_device *dev);
 	unsigned long deltaj;
-	long delta, deltapm;
+	long delta;
 	int pm_referenced = 0;
 
 	local_irq_disable();
@@ -575,36 +612,9 @@ static int __init calibrate_APIC_clock(v
 	delta = lapic_cal_t1 - lapic_cal_t2;
 	apic_printk(APIC_VERBOSE, "... lapic delta = %ld\n", delta);
 
-#ifdef CONFIG_X86_PM_TIMER
-	/* Check, if the PM timer is available */
-	deltapm = lapic_cal_pm2 - lapic_cal_pm1;
-	apic_printk(APIC_VERBOSE, "... PM timer delta = %ld\n", deltapm);
-
-	if (deltapm) {
-		unsigned long mult;
-		u64 res;
-
-		mult = clocksource_hz2mult(PMTMR_TICKS_PER_SEC, 22);
-
-		if (deltapm > (pm_100ms - pm_thresh) &&
-		    deltapm < (pm_100ms + pm_thresh)) {
-			apic_printk(APIC_VERBOSE, "... PM timer result ok\n");
-		} else {
-			res = (((u64) deltapm) *  mult) >> 22;
-			do_div(res, 1000000);
-			printk(KERN_WARNING "APIC calibration not consistent "
-			       "with PM Timer: %ldms instead of 100ms\n",
-			       (long)res);
-			/* Correct the lapic counter value */
-			res = (((u64) delta) * pm_100ms);
-			do_div(res, deltapm);
-			printk(KERN_INFO "APIC delta adjusted to PM-Timer: "
-			       "%lu (%ld)\n", (unsigned long) res, delta);
-			delta = (long) res;
-		}
-		pm_referenced = 1;
-	}
-#endif
+	/* we trust the PM based calibration if possible */
+	pm_referenced = !calibrate_by_pmtimer(lapic_cal_pm2 - lapic_cal_pm1,
+					&delta);
 
 	/* Calculate the scaled math multiplication factor */
 	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS,
@@ -646,7 +656,10 @@ static int __init calibrate_APIC_clock(v
 
 	levt->features &= ~CLOCK_EVT_FEAT_DUMMY;
 
-	/* We trust the pm timer based calibration */
+	/*
+	 * PM timer calibration failed or not turned on
+	 * so lets try APIC timer based calibration
+	 */
 	if (!pm_referenced) {
 		apic_printk(APIC_VERBOSE, "... verify APIC timer\n");
 
