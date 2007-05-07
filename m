Return-Path: <linux-kernel-owner+w=401wt.eu-S966611AbXEGUaD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966611AbXEGUaD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:30:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966592AbXEGUaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:30:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:2520 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966402AbXEGUaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:30:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,502,1170662400"; 
   d="scan'208";a="225361732"
Date: Mon, 7 May 2007 13:27:34 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH 1/8] Restructuring hpet timer generic clock interfaces
Message-ID: <20070507202734.GA3926@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



i386 HPET changes.

Patchset does the following changes to HPET support:
* Add HPET force detect to ICH chipsets, and detect the
  presence of HPET through PCI quirk.
* Enable HPET timer to function in standard interrupt delivery mode, against
  the current legacy replacement mode
* Enable HPET as a PER CPU time event, which will help in laptops that
  supports C3 and hence has unreliable LAPIC timer.

The changes enable processors to stay in idle longer, by increasing the
average time spend in an idle state per call, by more than twice, on
my dual core laptop. It reduces the number of interrupts on a totally
idle system, compared to when I use PIT.

The patchset is split as below:
* 1/8 - Restructuring of current HPET code
* 2/8 - Change clockevent brodcast timer code and enable switching to
        broadcast timer with a higher rating
* 3/8 - kernel irq balance bug fixes
* 4/8 - ICH detecting and enabling HPET through PCI quirk
* 5/8 - Late init HPET, after detection from PCI quirk
* 6/8 - Major part of the changes in this patchset are in this patch. Add
        support HPET timer in standard interrupt delivery mode
* 7/8 - Boot option changes for HPET in standard interrupt delivery mode
* 8/8 - Changes related to registering with HPET character driver

The patchset applies to 2.6.21. There will be conflicts with patchset that
Thomas posted yesterday. Will work on resolving those differences.

This patch:

Restructure and rename legacy replacement mode HPET timer support.
Just the code structural changes and should be zero functionality change.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.21-rc-mm-hpet/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.21-rc-mm-hpet.orig/arch/i386/kernel/hpet.c	2007-04-17 14:09:00.000000000 -0700
+++ linux-2.6.21-rc-mm-hpet/arch/i386/kernel/hpet.c	2007-04-18 13:49:10.000000000 -0700
@@ -110,9 +110,9 @@
  */
 static unsigned long hpet_period;
 
-static void hpet_set_mode(enum clock_event_mode mode,
+static void hpet_legacy_set_mode(enum clock_event_mode mode,
 			  struct clock_event_device *evt);
-static int hpet_next_event(unsigned long delta,
+static int hpet_legacy_next_event(unsigned long delta,
 			   struct clock_event_device *evt);
 
 /*
@@ -121,8 +121,8 @@
 static struct clock_event_device hpet_clockevent = {
 	.name		= "hpet",
 	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
-	.set_mode	= hpet_set_mode,
-	.set_next_event = hpet_next_event,
+	.set_mode	= hpet_legacy_set_mode,
+	.set_next_event = hpet_legacy_next_event,
 	.shift		= 32,
 	.irq		= 0,
 };
@@ -139,7 +139,7 @@
 	hpet_writel(cfg, HPET_CFG);
 }
 
-static void hpet_enable_int(void)
+static void hpet_enable_legacy_int(void)
 {
 	unsigned long cfg = hpet_readl(HPET_CFG);
 
@@ -148,7 +148,39 @@
 	hpet_legacy_int_enabled = 1;
 }
 
-static void hpet_set_mode(enum clock_event_mode mode,
+static void hpet_legacy_clockevent_register(void)
+{
+	uint64_t hpet_freq;
+
+	/* Start HPET legacy interrupts */
+	hpet_enable_legacy_int();
+
+	/*
+	 * The period is a femto seconds value. We need to calculate the
+	 * scaled math multiplication factor for nanosecond to hpet tick
+	 * conversion.
+	 */
+	hpet_freq = 1000000000000000ULL;
+	do_div(hpet_freq, hpet_period);
+	hpet_clockevent.mult = div_sc((unsigned long) hpet_freq,
+				      NSEC_PER_SEC, 32);
+	/* Calculate the min / max delta */
+	hpet_clockevent.max_delta_ns = clockevent_delta2ns(0x7FFFFFFF,
+							   &hpet_clockevent);
+	hpet_clockevent.min_delta_ns = clockevent_delta2ns(0x30,
+							   &hpet_clockevent);
+
+	/*
+	 * Start hpet with the boot cpu mask and make it
+	 * global after the IO_APIC has been initialized.
+	 */
+	hpet_clockevent.cpumask = cpumask_of_cpu(0);
+	clockevents_register_device(&hpet_clockevent);
+	global_clock_event = &hpet_clockevent;
+	printk(KERN_DEBUG "hpet clockevent registered\n");
+}
+
+static void hpet_legacy_set_mode(enum clock_event_mode mode,
 			  struct clock_event_device *evt)
 {
 	unsigned long cfg, cmp, now;
@@ -190,7 +222,7 @@
 	}
 }
 
-static int hpet_next_event(unsigned long delta,
+static int hpet_legacy_next_event(unsigned long delta,
 			   struct clock_event_device *evt)
 {
 	unsigned long cnt;
@@ -219,14 +251,39 @@
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
+static void hpet_clocksource_register(void)
+{
+	u64 tmp;
+
+	/* Start the counter */
+	hpet_start_counter();
+
+	/* Initialize and register HPET clocksource
+	 *
+	 * hpet period is in femto seconds per cycle
+	 * so we need to convert this to ns/cyc units
+	 * aproximated by mult/2^shift
+	 *
+	 *  fsec/cyc * 1nsec/1000000fsec = nsec/cyc = mult/2^shift
+	 *  fsec/cyc * 1ns/1000000fsec * 2^shift = mult
+	 *  fsec/cyc * 2^shift * 1nsec/1000000fsec = mult
+	 *  (fsec/cyc << shift)/1000000 = mult
+	 *  (hpet_period << shift)/FSEC_PER_NSEC = mult
+	 */
+	tmp = (u64)hpet_period << HPET_SHIFT;
+	do_div(tmp, FSEC_PER_NSEC);
+	clocksource_hpet.mult = (u32)tmp;
+
+	clocksource_register(&clocksource_hpet);
+	printk(KERN_DEBUG "hpet clocksource registered\n");
+}
+
 /*
  * Try to setup the HPET timer
  */
 int __init hpet_enable(void)
 {
 	unsigned long id;
-	uint64_t hpet_freq;
-	u64 tmp;
 
 	if (!is_hpet_capable())
 		return 0;
@@ -241,21 +298,6 @@
 		goto out_nohpet;
 
 	/*
-	 * The period is a femto seconds value. We need to calculate the
-	 * scaled math multiplication factor for nanosecond to hpet tick
-	 * conversion.
-	 */
-	hpet_freq = 1000000000000000ULL;
-	do_div(hpet_freq, hpet_period);
-	hpet_clockevent.mult = div_sc((unsigned long) hpet_freq,
-				      NSEC_PER_SEC, 32);
-	/* Calculate the min / max delta */
-	hpet_clockevent.max_delta_ns = clockevent_delta2ns(0x7FFFFFFF,
-							   &hpet_clockevent);
-	hpet_clockevent.min_delta_ns = clockevent_delta2ns(0x30,
-							   &hpet_clockevent);
-
-	/*
 	 * Read the HPET ID register to retrieve the IRQ routing
 	 * information and the number of channels
 	 */
@@ -270,38 +312,11 @@
 		goto out_nohpet;
 #endif
 
-	/* Start the counter */
-	hpet_start_counter();
-
-	/* Initialize and register HPET clocksource
-	 *
-	 * hpet period is in femto seconds per cycle
-	 * so we need to convert this to ns/cyc units
-	 * aproximated by mult/2^shift
-	 *
-	 *  fsec/cyc * 1nsec/1000000fsec = nsec/cyc = mult/2^shift
-	 *  fsec/cyc * 1ns/1000000fsec * 2^shift = mult
-	 *  fsec/cyc * 2^shift * 1nsec/1000000fsec = mult
-	 *  (fsec/cyc << shift)/1000000 = mult
-	 *  (hpet_period << shift)/FSEC_PER_NSEC = mult
-	 */
-	tmp = (u64)hpet_period << HPET_SHIFT;
-	do_div(tmp, FSEC_PER_NSEC);
-	clocksource_hpet.mult = (u32)tmp;
-
-	clocksource_register(&clocksource_hpet);
-
+	hpet_clocksource_register();
 
 	if (id & HPET_ID_LEGSUP) {
-		hpet_enable_int();
 		hpet_reserve_platform_timers(id);
-		/*
-		 * Start hpet with the boot cpu mask and make it
-		 * global after the IO_APIC has been initialized.
-		 */
-		hpet_clockevent.cpumask =cpumask_of_cpu(0);
-		clockevents_register_device(&hpet_clockevent);
-		global_clock_event = &hpet_clockevent;
+		hpet_legacy_clockevent_register();
 		return 1;
 	}
 	return 0;
@@ -551,7 +566,7 @@
 	id = hpet_readl(HPET_ID);
 
 	if (id & HPET_ID_LEGSUP)
-		hpet_enable_int();
+		hpet_enable_legacy_int();
 
 	return 0;
 }
