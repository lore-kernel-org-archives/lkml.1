Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbYIDPUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbYIDPUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 11:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbYIDPTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 11:19:23 -0400
Received: from www.tglx.de ([62.245.132.106]:56997 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586AbYIDPTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:19:22 -0400
Message-Id: <20080904151249.783722713@linutronix.de>
References: <20080904150339.896115280@linutronix.de>
User-Agent: quilt/0.46-1
Date: Thu, 04 Sep 2008 15:18:59 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Alok Kataria <akataria@vmware.com>,
       Arjan van de Veen <arjan@infradead.org>
Subject: [RFC patch 4/4] x86: TSC make the calibration loop smarter
Content-Disposition: inline; filename=tsc-loop-smarter.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last changes made the calibration loop 250ms long which is far
too much. Try to do that more clever.

Experiments have shown that using a 10ms delay for the PIT based calibration
gives us a good enough value. If we have a reference (HPET/PMTIMER) and the
result of the PIT and the reference is close enough, then we can break out of
the calibration loop on a match right away and use the reference value.

Otherwise we just loop 3 times and decide then, which value to take.

One caveat is that for virtualized environments the PIT calibration often does
not work at all and I found out that 10us is a bit too short as well for the
reference to give a sane result. The solution here is to make the last loop
longer when the first two PIT calibrations failed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/tsc.c |   95 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 58 insertions(+), 37 deletions(-)

Index: linux-2.6/arch/x86/kernel/tsc.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tsc.c
+++ linux-2.6/arch/x86/kernel/tsc.c
@@ -159,9 +159,14 @@ static unsigned long calc_pmtimer_ref(u6
 	return (unsigned long) deltatsc;
 }
 
-#define CAL_MS		50
+#define CAL_MS		10
 #define CAL_LATCH	(CLOCK_TICK_RATE / (1000 / CAL_MS))
-#define CAL_PIT_LOOPS	5000
+#define CAL_PIT_LOOPS	1000
+
+#define CAL2_MS		50
+#define CAL2_LATCH	(CLOCK_TICK_RATE / (1000 / CAL2_MS))
+#define CAL2_PIT_LOOPS	5000
+
 
 /*
  * Try to calibrate the TSC against the Programmable
@@ -170,7 +175,7 @@ static unsigned long calc_pmtimer_ref(u6
  *
  * Return ULONG_MAX on failure to calibrate.
  */
-static unsigned long pit_calibrate_tsc(void)
+static unsigned long pit_calibrate_tsc(u32 latch, unsigned long ms, int loopmin)
 {
 	u64 tsc, t1, t2, delta;
 	unsigned long tscmin, tscmax;
@@ -185,8 +190,8 @@ static unsigned long pit_calibrate_tsc(v
 	 * (LSB then MSB) to begin countdown.
 	 */
 	outb(0xb0, 0x43);
-	outb(CAL_LATCH & 0xff, 0x42);
-	outb(CAL_LATCH >> 8, 0x42);
+	outb(latch & 0xff, 0x42);
+	outb(latch >> 8, 0x42);
 
 	tsc = t1 = t2 = get_cycles();
 
@@ -207,18 +212,18 @@ static unsigned long pit_calibrate_tsc(v
 	/*
 	 * Sanity checks:
 	 *
-	 * If we were not able to read the PIT more than PIT_MIN_LOOPS
+	 * If we were not able to read the PIT more than loopmin
 	 * times, then we have been hit by a massive SMI
 	 *
 	 * If the maximum is 10 times larger than the minimum,
 	 * then we got hit by an SMI as well.
 	 */
-	if (pitcnt < CAL_PIT_LOOPS || tscmax > 10 * tscmin)
+	if (pitcnt < loopmin || tscmax > 10 * tscmin)
 		return ULONG_MAX;
 
 	/* Calculate the PIT value */
 	delta = t2 - t1;
-	do_div(delta, CAL_MS);
+	do_div(delta, ms);
 	return delta;
 }
 
@@ -230,8 +235,8 @@ unsigned long native_calibrate_tsc(void)
 {
 	u64 tsc1, tsc2, delta, ref1, ref2;
 	unsigned long tsc_pit_min = ULONG_MAX, tsc_ref_min = ULONG_MAX;
-	unsigned long flags;
-	int hpet = is_hpet_enabled(), i;
+	unsigned long flags, latch, ms;
+	int hpet = is_hpet_enabled(), i, loopmin;
 
 	/*
 	 * Run 5 calibration loops to get the lowest frequency value
@@ -257,7 +262,13 @@ unsigned long native_calibrate_tsc(void)
 	 * calibration delay loop as we have to wait for a certain
 	 * amount of time anyway.
 	 */
-	for (i = 0; i < 5; i++) {
+
+	/* Preset PIT loop values */
+	latch = CAL_LATCH;
+	ms = CAL_MS;
+	loopmin = CAL_PIT_LOOPS;
+
+	for (i = 0; i < 3; i++) {
 		unsigned long tsc_pit_khz;
 
 		/*
@@ -268,7 +279,7 @@ unsigned long native_calibrate_tsc(void)
 		 */
 		local_irq_save(flags);
 		tsc1 = tsc_read_refs(&ref1, hpet);
-		tsc_pit_khz = pit_calibrate_tsc();
+		tsc_pit_khz = pit_calibrate_tsc(latch, ms, loopmin);
 		tsc2 = tsc_read_refs(&ref2, hpet);
 		local_irq_restore(flags);
 
@@ -290,6 +301,35 @@ unsigned long native_calibrate_tsc(void)
 			tsc2 = calc_pmtimer_ref(tsc2, ref1, ref2);
 
 		tsc_ref_min = min(tsc_ref_min, (unsigned long) tsc2);
+
+		/* Check the reference deviation */
+		delta = ((u64) tsc_pit_min) * 100;
+		do_div(delta, tsc_ref_min);
+
+		/*
+		 * If both calibration results are inside a 10% window
+		 * then we can be sure, that the calibration
+		 * succeeded. We break out of the loop right away. We
+		 * use the reference value, as it is more precise.
+		 */
+		if (delta >= 90 && delta <= 110) {
+			printk(KERN_INFO
+			       "TSC: PIT calibration matches %s. %d loops\n",
+			       hpet ? "HPET" : "PMTIMER", i + 1);
+			return tsc_ref_min;
+		}
+
+		/*
+		 * Check whether PIT failed more than once. This
+		 * happens in virtualized environments. We need to
+		 * give the virtual PC a slightly longer timeframe for
+		 * the HPET/PMTIMER to make the result precise.
+		 */
+		if (i == 1 && tsc_pit_min == ULONG_MAX) {
+			latch = CAL2_LATCH;
+			ms = CAL2_MS;
+			loopmin = CAL2_PIT_LOOPS;
+		}
 	}
 
 	/*
@@ -308,7 +348,7 @@ unsigned long native_calibrate_tsc(void)
 		/* The alternative source failed as well, disable TSC */
 		if (tsc_ref_min == ULONG_MAX) {
 			printk(KERN_WARNING "TSC: HPET/PMTIMER calibration "
-			       "failed due to SMI disturbance.\n");
+			       "failed.\n");
 			return 0;
 		}
 
@@ -327,37 +367,18 @@ unsigned long native_calibrate_tsc(void)
 
 	/* The alternative source failed, use the PIT calibration value */
 	if (tsc_ref_min == ULONG_MAX) {
-		printk(KERN_WARNING "TSC: HPET/PMTIMER calibration failed due "
-		       "to SMI disturbance. Using PIT calibration\n");
+		printk(KERN_WARNING "TSC: HPET/PMTIMER calibration failed. "
+		       "Using PIT calibration\n");
 		return tsc_pit_min;
 	}
 
-	/* Check the reference deviation */
-	delta = ((u64) tsc_pit_min) * 100;
-	do_div(delta, tsc_ref_min);
-
-	/*
-	 * If both calibration results are inside a 5% window, the we
-	 * use the lower frequency of those as it is probably the
-	 * closest estimate.
-	 */
-	if (delta >= 95 && delta <= 105) {
-		printk(KERN_INFO "TSC: PIT calibration confirmed by %s.\n",
-		       hpet ? "HPET" : "PMTIMER");
-		printk(KERN_INFO "TSC: using %s calibration value\n",
-		       tsc_pit_min <= tsc_ref_min ? "PIT" :
-		       hpet ? "HPET" : "PMTIMER");
-		return tsc_pit_min <= tsc_ref_min ? tsc_pit_min : tsc_ref_min;
-	}
-
-	printk(KERN_WARNING "TSC: PIT calibration deviates from %s: %lu %lu.\n",
-	       hpet ? "HPET" : "PMTIMER", tsc_pit_min, tsc_ref_min);
-
 	/*
 	 * The calibration values differ too much. In doubt, we use
 	 * the PIT value as we know that there are PMTIMERs around
-	 * running at double speed.
+	 * running at double speed. At least we let the user know:
 	 */
+	printk(KERN_WARNING "TSC: PIT calibration deviates from %s: %lu %lu.\n",
+	       hpet ? "HPET" : "PMTIMER", tsc_pit_min, tsc_ref_min);
 	printk(KERN_INFO "TSC: Using PIT calibration value\n");
 	return tsc_pit_min;
 }

-- 

