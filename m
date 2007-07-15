Return-Path: <linux-kernel-owner+w=401wt.eu-S1765060AbXGOQOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765060AbXGOQOE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762468AbXGOQF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:05:26 -0400
Received: from www.osadl.org ([213.239.205.134]:42602 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762485AbXGOQFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:05:12 -0400
Message-Id: <20070715155541.606056872@inhelltoy.tec.linutronix.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jul 2007 16:11:02 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 21/33] x86_64: Move apic calibration code around
Content-Disposition: inline;
	filename=x86_64-apic-shuffle-calibration-around.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Let the calibration code fill in calibration_result directly and
move the variable on top of the file.

Fixup a printk w/o log level while at it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/x86_64/kernel/apic.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

Index: linux-2.6.22-rc6-mm/arch/x86_64/kernel/apic.c
===================================================================
--- linux-2.6.22-rc6-mm.orig/arch/x86_64/kernel/apic.c	2007-07-15 17:40:05.000000000 +0200
+++ linux-2.6.22-rc6-mm/arch/x86_64/kernel/apic.c	2007-07-15 17:48:57.000000000 +0200
@@ -56,6 +56,8 @@ static struct resource lapic_resource = 
 	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
 };
 
+static unsigned int calibration_result;
+
 /*
  * cpu_mask that denotes the CPUs that needs timer interrupt coming in as
  * IPIs in place of local APIC timers
@@ -822,7 +824,7 @@ static void setup_APIC_timer(unsigned in
 
 #define TICK_COUNT 100000000
 
-static int __init calibrate_APIC_clock(void)
+static void __init calibrate_APIC_clock(void)
 {
 	unsigned apic, apic_start;
 	unsigned long tsc, tsc_start;
@@ -856,17 +858,14 @@ static int __init calibrate_APIC_clock(v
 		result = (apic_start - apic) * 1000L * tsc_khz /
 					(tsc - tsc_start);
 	}
-	printk("result %d\n", result);
-
+	printk(KERN_DEBUG "APIC timer calibration result %d\n", result);
 
 	printk(KERN_INFO "Detected %d.%03d MHz APIC timer.\n",
 		result / 1000 / 1000, result / 1000 % 1000);
 
-	return result * APIC_DIVISOR / HZ;
+	calibration_result = result * APIC_DIVISOR / HZ;
 }
 
-static unsigned int calibration_result;
-
 void __init setup_boot_APIC_clock (void)
 {
 	if (disable_apic_timer) {
@@ -879,7 +878,7 @@ void __init setup_boot_APIC_clock (void)
 
 	local_irq_disable();
 
-	calibration_result = calibrate_APIC_clock();
+	calibrate_APIC_clock();
 	/*
 	 * Now set up the timer for real.
 	 */
@@ -986,8 +985,6 @@ void setup_APIC_extended_lvt(unsigned ch
 	apic_write(reg, v);
 }
 
-#undef APIC_DIVISOR
-
 /*
  * Local timer interrupt handler. It does both profiling and
  * process statistics/rescheduling.

-- 

