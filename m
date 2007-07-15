Return-Path: <linux-kernel-owner+w=401wt.eu-S932147AbXGOQO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147AbXGOQO7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762518AbXGOQFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:05:31 -0400
Received: from www.osadl.org ([213.239.205.134]:42602 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762573AbXGOQFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:05:15 -0400
Message-Id: <20070715155541.741062179@inhelltoy.tec.linutronix.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jul 2007 16:11:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 24/33] x86_64: remove nested irq disables
Content-Disposition: inline;
	filename=x86_64-apic-remove-nested-irq-disable.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

setup_APIC_timer disables interrupts anyway. So no need to do the same
in setup_boot_APIC_clock and setup_secondary_APIC_clock. Disable
interrupts explicit in the calibration code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/x86_64/kernel/apic.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6.22-rc6-mm/arch/x86_64/kernel/apic.c
===================================================================
--- linux-2.6.22-rc6-mm.orig/arch/x86_64/kernel/apic.c	2007-07-15 17:41:32.000000000 +0200
+++ linux-2.6.22-rc6-mm/arch/x86_64/kernel/apic.c	2007-07-15 17:48:54.000000000 +0200
@@ -827,6 +827,9 @@ static void __init calibrate_APIC_clock(
 	unsigned apic, apic_start;
 	unsigned long tsc, tsc_start;
 	int result;
+
+	local_irq_disable();
+
 	/*
 	 * Put whatever arbitrary (but long enough) timeout
 	 * value into the APIC clock, we just want to get the
@@ -856,6 +859,9 @@ static void __init calibrate_APIC_clock(
 		result = (apic_start - apic) * 1000L * tsc_khz /
 					(tsc - tsc_start);
 	}
+
+	local_irq_enable();
+
 	printk(KERN_DEBUG "APIC timer calibration result %d\n", result);
 
 	printk(KERN_INFO "Detected %d.%03d MHz APIC timer.\n",
@@ -874,22 +880,16 @@ void __init setup_boot_APIC_clock (void)
 	printk(KERN_INFO "Using local APIC timer interrupts.\n");
 	using_apic_timer = 1;
 
-	local_irq_disable();
-
 	calibrate_APIC_clock();
 	/*
 	 * Now set up the timer for real.
 	 */
 	setup_APIC_timer();
-
-	local_irq_enable();
 }
 
 void __cpuinit setup_secondary_APIC_clock(void)
 {
-	local_irq_disable(); /* FIXME: Do we need this? --RR */
 	setup_APIC_timer();
-	local_irq_enable();
 }
 
 void disable_APIC_timer(void)

-- 

