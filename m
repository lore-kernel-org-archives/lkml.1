Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbXFVUnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbXFVUnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 16:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbXFVUnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 16:43:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:45709 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbXFVUnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 16:43:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,452,1175497200"; 
   d="scan'208";a="257799287"
Date: Fri, 22 Jun 2007 13:39:18 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/7] ICH Force HPET: Restructure hpet generic clock code
Message-ID: <20070622203918.GB22807@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Restructure and rename legacy replacement mode HPET timer support.
Just the code structural changes and should be zero functionality change.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---

Index: linux-2.6.22-rc5/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.22-rc5.orig/arch/i386/kernel/hpet.c	2007-06-17 08:52:09.000000000 +0200
+++ linux-2.6.22-rc5/arch/i386/kernel/hpet.c	2007-06-17 08:52:10.000000000 +0200
@@ -158,9 +158,9 @@ static void hpet_reserve_platform_timers
  */
 static unsigned long hpet_period;
 
-static void hpet_set_mode(enum clock_event_mode mode,
+static void hpet_legacy_set_mode(enum clock_event_mode mode,
 			  struct clock_event_device *evt);
-static int hpet_next_event(unsigned long delta,
+static int hpet_legacy_next_event(unsigned long delta,
 			   struct clock_event_device *evt);
 
 /*
@@ -169,8 +169,8 @@ static int hpet_next_event(unsigned long
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
@@ -187,7 +187,7 @@ static void hpet_start_counter(void)
 	hpet_writel(cfg, HPET_CFG);
 }
 
-static void hpet_enable_int(void)
+static void hpet_enable_legacy_int(void)
 {
 	unsigned long cfg = hpet_readl(HPET_CFG);
 
@@ -196,7 +196,39 @@ static void hpet_enable_int(void)
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
+	hpet_clockevent.cpumask = cpumask_of_cpu(smp_processor_id());
+	clockevents_register_device(&hpet_clockevent);
+	global_clock_event = &hpet_clockevent;
+	printk(KERN_DEBUG "hpet clockevent registered\n");
+}
+
+static void hpet_legacy_set_mode(enum clock_event_mode mode,
 			  struct clock_event_device *evt)
 {
 	unsigned long cfg, cmp, now;
@@ -237,12 +269,12 @@ static void hpet_set_mode(enum clock_eve
 		break;
 
 	case CLOCK_EVT_MODE_RESUME:
-		hpet_enable_int();
+		hpet_enable_legacy_int();
 		break;
 	}
 }
 
-static int hpet_next_event(unsigned long delta,
+static int hpet_legacy_next_event(unsigned long delta,
 			   struct clock_event_device *evt)
 {
 	unsigned long cnt;
@@ -282,58 +314,11 @@ static struct clocksource clocksource_hp
 #endif
 };
 
-/*
- * Try to setup the HPET timer
- */
-int __init hpet_enable(void)
+static int hpet_clocksource_register(void)
 {
-	unsigned long id;
-	uint64_t hpet_freq;
 	u64 tmp, start, now;
 	cycle_t t1;
 
-	if (!is_hpet_capable())
-		return 0;
-
-	hpet_set_mapping();
-
-	/*
-	 * Read the period and check for a sane value:
-	 */
-	hpet_period = hpet_readl(HPET_PERIOD);
-	if (hpet_period < HPET_MIN_PERIOD || hpet_period > HPET_MAX_PERIOD)
-		goto out_nohpet;
-
-	/*
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
-	 * Read the HPET ID register to retrieve the IRQ routing
-	 * information and the number of channels
-	 */
-	id = hpet_readl(HPET_ID);
-
-#ifdef CONFIG_HPET_EMULATE_RTC
-	/*
-	 * The legacy routing mode needs at least two channels, tick timer
-	 * and the rtc emulation channel.
-	 */
-	if (!(id & HPET_ID_NUMBER))
-		goto out_nohpet;
-#endif
-
 	/* Start the counter */
 	hpet_start_counter();
 
@@ -356,7 +341,7 @@ int __init hpet_enable(void)
 	if (t1 == read_hpet()) {
 		printk(KERN_WARNING
 		       "HPET counter not counting. HPET disabled\n");
-		goto out_nohpet;
+		return -ENODEV;
 	}
 
 	/* Initialize and register HPET clocksource
@@ -377,16 +362,49 @@ int __init hpet_enable(void)
 
 	clocksource_register(&clocksource_hpet);
 
+	return 0;
+}
+
+/*
+ * Try to setup the HPET timer
+ */
+int __init hpet_enable(void)
+{
+	unsigned long id;
+
+	if (!is_hpet_capable())
+		return 0;
+
+	hpet_set_mapping();
+
+	/*
+	 * Read the period and check for a sane value:
+	 */
+	hpet_period = hpet_readl(HPET_PERIOD);
+	if (hpet_period < HPET_MIN_PERIOD || hpet_period > HPET_MAX_PERIOD)
+		goto out_nohpet;
+
+	/*
+	 * Read the HPET ID register to retrieve the IRQ routing
+	 * information and the number of channels
+	 */
+	id = hpet_readl(HPET_ID);
+
+#ifdef CONFIG_HPET_EMULATE_RTC
+	/*
+	 * The legacy routing mode needs at least two channels, tick timer
+	 * and the rtc emulation channel.
+	 */
+	if (!(id & HPET_ID_NUMBER))
+		goto out_nohpet;
+#endif
+
+	if (hpet_clocksource_register())
+		goto out_nohpet;
+
 	if (id & HPET_ID_LEGSUP) {
-		hpet_enable_int();
+		hpet_legacy_clockevent_register();
 		hpet_reserve_platform_timers(id);
-		/*
-		 * Start hpet with the boot cpu mask and make it
-		 * global after the IO_APIC has been initialized.
-		 */
-		hpet_clockevent.cpumask = cpumask_of_cpu(smp_processor_id());
-		clockevents_register_device(&hpet_clockevent);
-		global_clock_event = &hpet_clockevent;
 		return 1;
 	}
 	return 0;
