Return-Path: <linux-kernel-owner+w=401wt.eu-S966723AbXEGUhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966723AbXEGUhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966713AbXEGUh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:37:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:49645 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966714AbXEGUh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:37:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,502,1170662400"; 
   d="scan'208";a="243050877"
Date: Mon, 7 May 2007 13:35:03 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH 8/8] Register unused HPET timers with /dev/hpet driver
Message-ID: <20070507203503.GH3926@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Reserve available HPET timers with driver/hpet.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.21/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.21.orig/arch/i386/kernel/hpet.c	2007-04-27 14:59:00.000000000 -0700
+++ linux-2.6.21/arch/i386/kernel/hpet.c	2007-04-27 15:01:56.000000000 -0700
@@ -76,44 +76,7 @@
 	return is_hpet_capable() && hpet_legacy_int_enabled;
 }
 
-/*
- * When the hpet driver (/dev/hpet) is enabled, we need to reserve
- * timer 0 and timer 1 in case of RTC emulation.
- */
-#ifdef CONFIG_HPET
-static void hpet_reserve_platform_timers(unsigned long id)
-{
-	struct hpet __iomem *hpet = hpet_virt_address;
-	struct hpet_timer __iomem *timer = &hpet->hpet_timers[2];
-	unsigned int nrtimers, i;
-	struct hpet_data hd;
-
-	nrtimers = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT) + 1;
-
-	memset(&hd, 0, sizeof (hd));
-	hd.hd_phys_address = hpet_address;
-	hd.hd_address = hpet_virt_address;
-	hd.hd_nirqs = nrtimers;
-	hd.hd_flags = HPET_DATA_PLATFORM;
-	hpet_reserve_timer(&hd, 0);
-
-#ifdef CONFIG_HPET_EMULATE_RTC
-	hpet_reserve_timer(&hd, 1);
-#endif
-
-	hd.hd_irq[0] = HPET_LEGACY_8254;
-	hd.hd_irq[1] = HPET_LEGACY_RTC;
-
-	for (i = 2; i < nrtimers; timer++, i++)
-		hd.hd_irq[i] = (timer->hpet_config & Tn_INT_ROUTE_CNF_MASK) >>
-			Tn_INT_ROUTE_CNF_SHIFT;
-
-	hpet_alloc(&hd);
-
-}
-#else
-static void hpet_reserve_platform_timers(unsigned long id) { }
-#endif
+static void hpet_reserve_platform_timers(unsigned long id);
 
 /*
  * Common hpet info
@@ -730,6 +693,7 @@
 int __init hpet_enable(int early_call)
 {
 	unsigned long id;
+	int retval = 0;
 
 	if (hpet_virt_address)
 		return 0;
@@ -767,14 +731,18 @@
 	hpet_clocksource_register();
 
 	if (hpet_preferred_int_mode == HPET_INT_STD) {
-		hpet_reserve_platform_timers(id);
-		return hpet_std_clockevent_register();
+		if (hpet_std_clockevent_register() == 0)
+			retval = 1;
 	} else if (id & HPET_ID_LEGSUP) {
-		hpet_reserve_platform_timers(id);
 		hpet_legacy_clockevent_register();
-		return 1;
+		retval = 1;
 	}
-	return 0;
+
+	if (retval) {
+		hpet_reserve_platform_timers(id);
+	}
+
+	return retval;
 
 out_nohpet:
 	iounmap(hpet_virt_address);
@@ -809,6 +777,59 @@
 module_init(hpet_late_init);
 
 
+/*
+ * When the hpet driver (/dev/hpet) is enabled, we need to reserve
+ * timer 0 and timer 1 in case of RTC emulation.
+ */
+#ifdef CONFIG_HPET
+static void hpet_reserve_platform_timers(unsigned long id)
+{
+	struct hpet __iomem *hpet = hpet_virt_address;
+	struct hpet_timer __iomem *timer = &hpet->hpet_timers[2];
+	unsigned int nrtimers, i;
+	struct hpet_data hd;
+	int rem_timers = 0;
+
+	nrtimers = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT) + 1;
+
+	memset(&hd, 0, sizeof (hd));
+	hd.hd_phys_address = hpet_address;
+	hd.hd_address = hpet_virt_address;
+	hd.hd_nirqs = nrtimers;
+	hd.hd_flags = HPET_DATA_PLATFORM;
+
+	if (hpet_legacy_int_enabled && (id & HPET_ID_LEGSUP)) {
+		hpet_reserve_timer(&hd, 0);
+#ifdef CONFIG_HPET_EMULATE_RTC
+		hpet_reserve_timer(&hd, 1);
+#endif
+		hd.hd_irq[0] = HPET_LEGACY_8254;
+		hd.hd_irq[1] = HPET_LEGACY_RTC;
+		rem_timers = 2;
+	} else if (cpu_hpet_dev) {
+		int i;
+		for (i = 0; i < hpet_num_timers_used; i++) {
+			struct hpet_dev *hdev;
+			hdev = per_cpu_ptr(cpu_hpet_dev, i);
+
+			hpet_reserve_timer(&hd, i);
+			hd.hd_irq[i] = hdev->irq;
+		}
+		rem_timers = i;
+	}
+
+	for (i = rem_timers; i < nrtimers; timer++, i++)
+		hd.hd_irq[i] = (timer->hpet_config & Tn_INT_ROUTE_CNF_MASK) >>
+			Tn_INT_ROUTE_CNF_SHIFT;
+
+	hpet_alloc(&hd);
+
+}
+#else
+static void hpet_reserve_platform_timers(unsigned long id) { }
+#endif
+
+
 #ifdef CONFIG_HPET_EMULATE_RTC
 
 /* HPET in LegacyReplacement Mode eats up RTC interrupt line. When, HPET
@@ -893,6 +914,9 @@
 	if (!is_hpet_enabled())
 		return 0;
 
+	if (!hpet_legacy_int_enabled)
+		return 0;
+
 	hpet_rtc_flags &= ~bit_mask;
 	return 1;
 }
@@ -904,6 +928,9 @@
 	if (!is_hpet_enabled())
 		return 0;
 
+	if (!hpet_legacy_int_enabled)
+		return 0;
+
 	hpet_rtc_flags |= bit_mask;
 
 	if (!oldbits)
