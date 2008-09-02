Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbYIBWzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbYIBWzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 18:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbYIBWzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 18:55:36 -0400
Received: from www.tglx.de ([62.245.132.106]:38646 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbYIBWze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 18:55:34 -0400
Date: Wed, 3 Sep 2008 00:54:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: [PATCH] Fix TSC calibration issues
In-Reply-To: <alpine.LFD.1.10.0809021120120.3210@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809022358370.3243@apollo.tec.linutronix.de>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020835150.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809020759480.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809021918450.3243@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0809021120120.3210@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger reported at http://lkml.org/lkml/2008/9/1/90:
An ancient laptop of mine started throwing errors from b43legacy when
I started using 2.6.27 on it. This has been bisected to commit bfc0f59
"x86: merge tsc calibration".

The unification of the TSC code adopted mostly the 64bit code, which
prefers PMTIMER/HPET over the PIT calibration.

Larrys system has an AMD K6 CPU. Such systems are known to have
PMTIMER incarnations which run at double speed. This results in a
miscalibration of the TSC by factor 0.5. So the resulting calibrated
CPU/TSC speed is half of the real CPU speed, which means that the TSC
based delay loop will run half the time it should run. That might
explain why the b43legacy driver went berserk.

On the other hand we know about systems, where the PIT based
calibration results in random crap due to heavy SMI/SMM
disturbance. On those systems the PMTIMER/HPET based calibration logic
with SMI detection shows better results.

According to Alok also virtualized systems suffer from the PIT
calibration method.

The solution is to use a more wreckage aware aproach than the current
either/or decision.

1) reimplement the retry loop which was dropped from the 32bit code
during the merge. It repeats the calibration and selects the lowest
frequency value as this is probably the closest estimate to the real
frequency

2) Monitor the delta of the TSC values in the delay loop which waits
for the PIT counter to reach zero. If the maximum value is
significantly different from the minimum, then we have a pretty safe
indicator that the loop was disturbed by an SMI.

3) keep the pmtimer/hpet reference as a backup solution for systems
where the SMI disturbance is a permanent point of failure for PIT
based calibration

4) do the loop iteration for both methods, record the lowest value and
decide after all iterations finished.

5) Set a clear preference to PIT based calibration when the result
makes sense.

The implementation does the reference calibration based on
HPET/PMTIMER around the delay, which is necessary for the PIT anyway,
but keeps separate TSC values to ensure the "independency" of the
resulting calibration values.

Tested on various 32bit/64bit machines including Geode 266Mhz, AMD K6
(affected machine with a double speed pmtimer which I grabbed out of
the dump), Pentium class machines and AMD/Intel 64 bit boxen.

Bisected-by:  Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/tsc.c |  235 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 181 insertions(+), 54 deletions(-)

Index: linux-2.6/arch/x86/kernel/tsc.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tsc.c
+++ linux-2.6/arch/x86/kernel/tsc.c
@@ -127,74 +127,201 @@ static u64 tsc_read_refs(u64 *pm, u64 *h
  */
 unsigned long native_calibrate_tsc(void)
 {
-	unsigned long flags;
-	u64 tsc1, tsc2, tr1, tr2, delta, pm1, pm2, hpet1, hpet2;
-	int hpet = is_hpet_enabled();
-	unsigned int tsc_khz_val = 0;
+	u64 tsc1, tsc2, tr1, tr2, tsc, delta, pm1, pm2, hpet1, hpet2;
+	unsigned long tsc_pit_min = ULONG_MAX, tsc_ref_min = ULONG_MAX;
+	unsigned long flags, tscmin, tscmax;
+	int hpet = is_hpet_enabled(), pitcnt, i;
 
-	local_irq_save(flags);
-
-	tsc1 = tsc_read_refs(&pm1, hpet ? &hpet1 : NULL);
-
-	outb((inb(0x61) & ~0x02) | 0x01, 0x61);
-
-	outb(0xb0, 0x43);
-	outb((CLOCK_TICK_RATE / (1000 / 50)) & 0xff, 0x42);
-	outb((CLOCK_TICK_RATE / (1000 / 50)) >> 8, 0x42);
-	tr1 = get_cycles();
-	while ((inb(0x61) & 0x20) == 0);
-	tr2 = get_cycles();
+	/*
+	 * Run 5 calibration loops to get the lowest frequency value
+	 * (the best estimate). We use two different calibration modes
+	 * here:
+	 *
+	 * 1) PIT loop. We set the PIT Channel 2 to oneshot mode and
+	 * load a timeout of 50ms. We read the time right after we
+	 * started the timer and wait until the PIT count down reaches
+	 * zero. In each wait loop iteration we read the TSC and check
+	 * the delta to the previous read. We keep track of the min
+	 * and max values of that delta. The delta is mostly defined
+	 * by the IO time of the PIT access, so we can detect when a
+	 * SMI/SMM disturbance happend between the two reads. If the
+	 * maximum time is significantly larger than the minimum time,
+	 * then we discard the result and have another try.
+	 *
+	 * 2) Reference counter. If available we use the HPET or the
+	 * PMTIMER as a reference to check the sanity of that value.
+	 * We use separate TSC readouts and check inside of the
+	 * reference read for a SMI/SMM disturbance. We dicard
+	 * disturbed values here as well. We do that around the PIT
+	 * calibration delay loop as we have to wait for a certain
+	 * amount of time anyway.
+	 */
+	for (i = 0; i < 5; i++) {
 
-	tsc2 = tsc_read_refs(&pm2, hpet ? &hpet2 : NULL);
+		tscmin = ULONG_MAX;
+		tscmax = 0;
+		pitcnt = 0;
+
+		local_irq_save(flags);
+
+		/*
+		 * Read the start value and the reference count of
+		 * hpet/pmtimer when available:
+		 */
+		tsc1 = tsc_read_refs(&pm1, hpet ? &hpet1 : NULL);
+
+		/* Set the Gate high, disable speaker */
+		outb((inb(0x61) & ~0x02) | 0x01, 0x61);
+
+		/*
+		 * Setup CTC channel 2* for mode 0, (interrupt on terminal
+		 * count mode), binary count. Set the latch register to 50ms
+		 * (LSB then MSB) to begin countdown.
+		 *
+		 * Some devices need a delay here.
+		 */
+		outb(0xb0, 0x43);
+		outb((CLOCK_TICK_RATE / (1000 / 50)) & 0xff, 0x42);
+		outb((CLOCK_TICK_RATE / (1000 / 50)) >> 8, 0x42);
+
+		tsc = tr1 = tr2 = get_cycles();
+
+		while ((inb(0x61) & 0x20) == 0) {
+			tr2 = get_cycles();
+			delta = tr2 - tsc;
+			tsc = tr2;
+			if ((unsigned int) delta < tscmin)
+				tscmin = (unsigned int) delta;
+			if ((unsigned int) delta > tscmax)
+				tscmax = (unsigned int) delta;
+			pitcnt++;
+		}
+
+		/*
+		 * We waited at least 50ms above. Now read
+		 * pmtimer/hpet reference again
+		 */
+		tsc2 = tsc_read_refs(&pm2, hpet ? &hpet2 : NULL);
+
+		local_irq_restore(flags);
+
+		/*
+		 * Sanity checks:
+		 *
+		 * If we were not able to read the PIT more than 5000
+		 * times, then we have been hit by a massive SMI
+		 *
+		 * If the maximum is 10 times larger than the minimum,
+		 * then we got hit by an SMI as well.
+		 */
+		if (pitcnt > 5000 && tscmax < 10 * tscmin) {
+
+			/* Calculate the PIT value */
+			delta = tr2 - tr1;
+			do_div(delta, 50);
+
+			/* We take the smallest value into account */
+			tsc_pit_min = min(tsc_pit_min, (unsigned long) delta);
+		}
+
+		/* hpet or pmtimer available ? */
+		if (!hpet && !pm1 && !pm2)
+			continue;
+
+		/* Check, whether the sampling was disturbed by an SMI */
+		if (tsc1 == ULLONG_MAX || tsc2 == ULLONG_MAX)
+			continue;
+
+		tsc2 = (tsc2 - tsc1) * 1000000LL;
+
+		if (hpet) {
+			if (hpet2 < hpet1)
+				hpet2 += 0x100000000ULL;
+			hpet2 -= hpet1;
+			tsc1 = ((u64)hpet2 * hpet_readl(HPET_PERIOD));
+			do_div(tsc1, 1000000);
+		} else {
+			if (pm2 < pm1)
+				pm2 += (u64)ACPI_PM_OVRRUN;
+			pm2 -= pm1;
+			tsc1 = pm2 * 1000000000LL;
+			do_div(tsc1, PMTMR_TICKS_PER_SEC);
+		}
 
-	local_irq_restore(flags);
+		do_div(tsc2, tsc1);
+		tsc_ref_min = min(tsc_ref_min, (unsigned long) tsc2);
+	}
 
 	/*
-	 * Preset the result with the raw and inaccurate PIT
-	 * calibration value
+	 * Now check the results.
 	 */
-	delta = (tr2 - tr1);
-	do_div(delta, 50);
-	tsc_khz_val = delta;
+	if (tsc_pit_min == ULONG_MAX) {
+		/* PIT gave no useful value */
+		printk(KERN_WARNING "TSC: PIT calibration failed due to "
+		       "SMI disturbance.\n");
+
+		/* We don't have an alternative source, disable TSC */
+		if (!hpet && !pm1 && !pm2) {
+			printk("TSC: No reference (HPET/PMTIMER) available\n");
+			return 0;
+		}
+
+		/* The alternative source failed as well, disable TSC */
+		if (tsc_ref_min == ULONG_MAX) {
+			printk(KERN_WARNING "TSC: HPET/PMTIMER calibration "
+			       "failed due to SMI disturbance.\n");
+			return 0;
+		}
+
+		/* Use the alternative source */
+		printk(KERN_INFO "TSC: using %s reference calibration\n",
+		       hpet ? "HPET" : "PMTIMER");
+
+		return tsc_ref_min;
+	}
 
-	/* hpet or pmtimer available ? */
+	/* We don't have an alternative source, use the PIT calibration value */
 	if (!hpet && !pm1 && !pm2) {
-		printk(KERN_INFO "TSC calibrated against PIT\n");
-		goto out;
+		printk(KERN_INFO "TSC: Using PIT calibration value\n");
+		return tsc_pit_min;
 	}
 
-	/* Check, whether the sampling was disturbed by an SMI */
-	if (tsc1 == ULLONG_MAX || tsc2 == ULLONG_MAX) {
-		printk(KERN_WARNING "TSC calibration disturbed by SMI, "
-				"using PIT calibration result\n");
-		goto out;
-	}
-
-	tsc2 = (tsc2 - tsc1) * 1000000LL;
-
-	if (hpet) {
-		printk(KERN_INFO "TSC calibrated against HPET\n");
-		if (hpet2 < hpet1)
-			hpet2 += 0x100000000ULL;
-		hpet2 -= hpet1;
-		tsc1 = ((u64)hpet2 * hpet_readl(HPET_PERIOD));
-		do_div(tsc1, 1000000);
-	} else {
-		printk(KERN_INFO "TSC calibrated against PM_TIMER\n");
-		if (pm2 < pm1)
-			pm2 += (u64)ACPI_PM_OVRRUN;
-		pm2 -= pm1;
-		tsc1 = pm2 * 1000000000LL;
-		do_div(tsc1, PMTMR_TICKS_PER_SEC);
+	/* The alternative source failed, use the PIT calibration value */
+	if (tsc_ref_min == ULONG_MAX) {
+		printk(KERN_WARNING "TSC: HPET/PMTIMER calibration failed due "
+		       "to SMI disturbance. Using PIT calibration\n");
+		return tsc_pit_min;
 	}
 
-	do_div(tsc2, tsc1);
-	tsc_khz_val = tsc2;
+	/* Check the reference deviation */
+	delta = ((u64) tsc_pit_min) * 100;
+	do_div(delta, tsc_ref_min);
 
-out:
-	return tsc_khz_val;
-}
+	/*
+	 * If both calibration results are inside a 5% window, the we
+	 * use the lower frequency of those as it is probably the
+	 * closest estimate.
+	 */
+	if (delta >= 95 && delta <= 105) {
+		printk(KERN_INFO "TSC: PIT calibration confirmed by %s.\n",
+		       hpet ? "HPET" : "PMTIMER");
+		printk(KERN_INFO "TSC: using %s calibration value\n",
+		       tsc_pit_min <= tsc_ref_min ? "PIT" :
+		       hpet ? "HPET" : "PMTIMER");
+		return tsc_pit_min <= tsc_ref_min ? tsc_pit_min : tsc_ref_min;
+	}
 
+	printk(KERN_WARNING "TSC: PIT calibration deviates from %s: %lu %lu.\n",
+	       hpet ? "HPET" : "PMTIMER", tsc_pit_min, tsc_ref_min);
+
+	/*
+	 * The calibration values differ too much. In doubt, we use
+	 * the PIT value as we know that there are PMTIMERs around
+	 * running at double speed.
+	 */
+	printk(KERN_INFO "TSC: Using PIT calibration value\n");
+	return tsc_pit_min;
+}
 
 #ifdef CONFIG_X86_32
 /* Only called from the Powernow K7 cpu freq driver */
