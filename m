Return-Path: <linux-kernel-owner+w=401wt.eu-S1763730AbXGOQNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763730AbXGOQNG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762694AbXGOQFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:05:21 -0400
Received: from www.osadl.org ([213.239.205.134]:42583 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762455AbXGOQFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:05:08 -0400
Message-Id: <20070715155541.516056869@inhelltoy.tec.linutronix.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jul 2007 16:11:00 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 19/33] x86_64: prepare apic code for clock events
Content-Disposition: inline; filename=x86_64-preparatory-apic-set-lvtt.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change __setup_APIC_LVTT so it takes the arguments which are necessary
for the later clock events switch.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/x86_64/kernel/apic.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

Index: linux-2.6.22-rc6-mm/arch/x86_64/kernel/apic.c
===================================================================
--- linux-2.6.22-rc6-mm.orig/arch/x86_64/kernel/apic.c	2007-07-15 17:33:43.000000000 +0200
+++ linux-2.6.22-rc6-mm/arch/x86_64/kernel/apic.c	2007-07-15 17:48:59.000000000 +0200
@@ -760,14 +760,14 @@ void __init init_apic_mappings(void)
 
 #define APIC_DIVISOR 16
 
-static void __setup_APIC_LVTT(unsigned int clocks)
+static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 {
 	unsigned int lvtt_value, tmp_value;
-	int cpu = smp_processor_id();
-
-	lvtt_value = APIC_LVT_TIMER_PERIODIC | LOCAL_TIMER_VECTOR;
 
-	if (cpu_isset(cpu, timer_interrupt_broadcast_ipi_mask))
+	lvtt_value = LOCAL_TIMER_VECTOR;
+	if (!oneshot)
+		lvtt_value |= APIC_LVT_TIMER_PERIODIC;
+	if (!irqen)
 		lvtt_value |= APIC_LVT_MASKED;
 
 	apic_write(APIC_LVTT, lvtt_value);
@@ -780,12 +780,14 @@ static void __setup_APIC_LVTT(unsigned i
 				& ~(APIC_TDR_DIV_1 | APIC_TDR_DIV_TMBASE))
 				| APIC_TDR_DIV_16);
 
-	apic_write(APIC_TMICT, clocks/APIC_DIVISOR);
+	if (!oneshot)
+		apic_write(APIC_TMICT, clocks/APIC_DIVISOR);
 }
 
 static void setup_APIC_timer(unsigned int clocks)
 {
 	unsigned long flags;
+	int irqen;
 
 	local_irq_save(flags);
 
@@ -808,7 +810,10 @@ static void setup_APIC_timer(unsigned in
 			c2 |= inb_p(0x40) << 8;
 		} while (c2 - c1 < 300);
 	}
-	__setup_APIC_LVTT(clocks);
+
+	irqen = ! cpu_isset(smp_processor_id(),
+			    timer_interrupt_broadcast_ipi_mask);
+	__setup_APIC_LVTT(clocks, 0, irqen);
 	/* Turn off PIT interrupt if we use APIC timer as main timer.
 	   Only works with the PM timer right now
 	   TBD fix it for HPET too. */
@@ -846,8 +851,10 @@ static int __init calibrate_APIC_clock(v
 	 * Put whatever arbitrary (but long enough) timeout
 	 * value into the APIC clock, we just want to get the
 	 * counter running for calibration.
+	 *
+	 * No interrupt enable !
 	 */
-	__setup_APIC_LVTT(4000000000);
+	__setup_APIC_LVTT(4000000000, 0, 0);
 
 	apic_start = apic_read(APIC_TMCCT);
 #ifdef CONFIG_X86_PM_TIMER

-- 

