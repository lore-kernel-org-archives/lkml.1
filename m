Return-Path: <linux-kernel-owner+w=401wt.eu-S1765238AbXGOQNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765238AbXGOQNo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762108AbXGOQFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:05:24 -0400
Received: from www.osadl.org ([213.239.205.134]:42600 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762496AbXGOQFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:05:11 -0400
Message-Id: <20070715155541.651124309@inhelltoy.tec.linutronix.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jul 2007 16:11:04 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 22/33] x86_64: Remove APIC_DIVISOR
Content-Disposition: inline;
	filename=x86_64-apic-calibration-remove-divisor.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

APIC_DIVISOR is rather useless. It makes the calibration result more
accurate in the first place, but we discard this later when we write
the value to the APIC timer by dividing the calibration value by
APIC_DIVISOR.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/x86_64/kernel/apic.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: linux-2.6.22-rc6-mm/arch/x86_64/kernel/apic.c
===================================================================
--- linux-2.6.22-rc6-mm.orig/arch/x86_64/kernel/apic.c	2007-07-15 17:40:59.000000000 +0200
+++ linux-2.6.22-rc6-mm/arch/x86_64/kernel/apic.c	2007-07-15 17:48:57.000000000 +0200
@@ -760,8 +760,6 @@ void __init init_apic_mappings(void)
  * P5 APIC double write bug.
  */
 
-#define APIC_DIVISOR 16
-
 static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 {
 	unsigned int lvtt_value, tmp_value;
@@ -783,7 +781,7 @@ static void __setup_APIC_LVTT(unsigned i
 				| APIC_TDR_DIV_16);
 
 	if (!oneshot)
-		apic_write(APIC_TMICT, clocks/APIC_DIVISOR);
+		apic_write(APIC_TMICT, clocks);
 }
 
 static void setup_APIC_timer(unsigned int clocks)
@@ -836,7 +834,7 @@ static void __init calibrate_APIC_clock(
 	 *
 	 * No interrupt enable !
 	 */
-	__setup_APIC_LVTT(4000000000, 0, 0);
+	__setup_APIC_LVTT(250000000, 0, 0);
 
 	apic_start = apic_read(APIC_TMCCT);
 #ifdef CONFIG_X86_PM_TIMER
@@ -863,7 +861,7 @@ static void __init calibrate_APIC_clock(
 	printk(KERN_INFO "Detected %d.%03d MHz APIC timer.\n",
 		result / 1000 / 1000, result / 1000 % 1000);
 
-	calibration_result = result * APIC_DIVISOR / HZ;
+	calibration_result = result / HZ;
 }
 
 void __init setup_boot_APIC_clock (void)

-- 

