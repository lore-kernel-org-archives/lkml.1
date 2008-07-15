Return-Path: <linux-kernel-owner+w=401wt.eu-S1762146AbYGORJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762146AbYGORJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761113AbYGORJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:09:04 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:16191 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065AbYGORJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:09:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=TDSMPpc7L2rt0tOUhtiVa3kwHau1SGrnd262+fXaRhToleaLpb6wFbi+vy7JKjkUq/
         7XBdjEdmez9/xBSoGUFGrgr+KV9ngMAhljxaxxP5p9gQ91YNwdvcoSwdRGyoAuB+1RUU
         5NJXNlCLR0J1UIGs+EbQ+tzK2HHpnBcqbpzho=
References: <20080715170253.921844144@gmail.com>>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jul 2008 21:02:55 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, macro@linux-mips.org,
       yhlu.kernel@gmail.com
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 2/2] x86: apic_32 - introduce calibrate_APIC_clock
Content-Disposition: inline; filename=cvgapic-calibrate-32
Message-ID: <487cd9aa.14064e0a.42aa.20c2@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce calibrate_APIC_clock so it could help in further 32/64bit apic code merging.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_32.c	2008-07-15 20:04:05.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_32.c	2008-07-15 20:13:12.000000000 +0400
@@ -372,12 +372,7 @@ static void __init lapic_cal_handler(str
 	}
 }
 
-/*
- * Setup the boot APIC
- *
- * Calibrate and verify the result.
- */
-void __init setup_boot_APIC_clock(void)
+static int __init calibrate_APIC_clock(void)
 {
 	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
 	const long pm_100ms = PMTMR_TICKS_PER_SEC/10;
@@ -387,24 +382,6 @@ void __init setup_boot_APIC_clock(void)
 	long delta, deltapm;
 	int pm_referenced = 0;
 
-	/*
-	 * The local apic timer can be disabled via the kernel
-	 * commandline or from the CPU detection code. Register the lapic
-	 * timer as a dummy clock event source on SMP systems, so the
-	 * broadcast mechanism is used. On UP systems simply ignore it.
-	 */
-	if (local_apic_timer_disabled) {
-		/* No broadcast on UP ! */
-		if (num_possible_cpus() > 1) {
-			lapic_clockevent.mult = 1;
-			setup_APIC_timer();
-		}
-		return;
-	}
-
-	apic_printk(APIC_VERBOSE, "Using local APIC timer interrupts.\n"
-		    "calibrating APIC timer ...\n");
-
 	local_irq_disable();
 
 	/* Replace the global interrupt handler */
@@ -489,8 +466,6 @@ void __init setup_boot_APIC_clock(void)
 		    calibration_result / (1000000 / HZ),
 		    calibration_result % (1000000 / HZ));
 
-	local_apic_timer_verify_ok = 1;
-
 	/*
 	 * Do a sanity check on the APIC calibration result
 	 */
@@ -498,12 +473,11 @@ void __init setup_boot_APIC_clock(void)
 		local_irq_enable();
 		printk(KERN_WARNING
 		       "APIC frequency too slow, disabling apic timer\n");
-		/* No broadcast on UP ! */
-		if (num_possible_cpus() > 1)
-			setup_APIC_timer();
-		return;
+		return -1;
 	}
 
+	local_apic_timer_verify_ok = 1;
+
 	/* We trust the pm timer based calibration */
 	if (!pm_referenced) {
 		apic_printk(APIC_VERBOSE, "... verify APIC timer\n");
@@ -543,22 +517,55 @@ void __init setup_boot_APIC_clock(void)
 	if (!local_apic_timer_verify_ok) {
 		printk(KERN_WARNING
 		       "APIC timer disabled due to verification failure.\n");
+			return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * Setup the boot APIC
+ *
+ * Calibrate and verify the result.
+ */
+void __init setup_boot_APIC_clock(void)
+{
+	/*
+	 * The local apic timer can be disabled via the kernel
+	 * commandline or from the CPU detection code. Register the lapic
+	 * timer as a dummy clock event source on SMP systems, so the
+	 * broadcast mechanism is used. On UP systems simply ignore it.
+	 */
+	if (local_apic_timer_disabled) {
 		/* No broadcast on UP ! */
-		if (num_possible_cpus() == 1)
-			return;
-	} else {
-		/*
-		 * If nmi_watchdog is set to IO_APIC, we need the
-		 * PIT/HPET going.  Otherwise register lapic as a dummy
-		 * device.
-		 */
-		if (nmi_watchdog != NMI_IO_APIC)
-			lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
-		else
-			printk(KERN_WARNING "APIC timer registered as dummy,"
-				" due to nmi_watchdog=%d!\n", nmi_watchdog);
+		if (num_possible_cpus() > 1) {
+			lapic_clockevent.mult = 1;
+			setup_APIC_timer();
+		}
+		return;
+	}
+
+	apic_printk(APIC_VERBOSE, "Using local APIC timer interrupts.\n"
+		    "calibrating APIC timer ...\n");
+
+	if (calibrate_APIC_clock()) {
+		/* No broadcast on UP ! */
+		if (num_possible_cpus() > 1)
+			setup_APIC_timer();
+		return;
 	}
 
+	/*
+	 * If nmi_watchdog is set to IO_APIC, we need the
+	 * PIT/HPET going.  Otherwise register lapic as a dummy
+	 * device.
+	 */
+	if (nmi_watchdog != NMI_IO_APIC)
+		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
+	else
+		printk(KERN_WARNING "APIC timer registered as dummy,"
+			" due to nmi_watchdog=%d!\n", nmi_watchdog);
+
 	/* Setup the lapic or request the broadcast */
 	setup_APIC_timer();
 }

-- 
