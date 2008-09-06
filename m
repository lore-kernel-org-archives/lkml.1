Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbYIFBGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbYIFBGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 21:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYIFBFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 21:05:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:2697 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbYIFBFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 21:05:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,343,1217833200"; 
   d="scan'208";a="377264944"
Message-Id: <20080906010448.560257000@intel.com>
References: <20080906010214.229910000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 05 Sep 2008 18:02:16 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, shaohua.li@intel.com,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [RFC 2/4] x86: HPET_MSI Refactor code in preparation for HPET_MSI
Content-Disposition: inline; filename=hpet_msi_prep.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparatory patch before the actual HPET MSI changes. Sets up hpet_set_mode
and hpet_next_event for the MSI related changes. Just the code
refactoring and should be zero functional change.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 arch/x86/kernel/hpet.c |   42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

Index: tip/arch/x86/kernel/hpet.c
===================================================================
--- tip.orig/arch/x86/kernel/hpet.c	2008-09-05 17:03:52.000000000 -0700
+++ tip/arch/x86/kernel/hpet.c	2008-09-05 17:04:12.000000000 -0700
@@ -227,44 +227,44 @@ static void hpet_legacy_clockevent_regis
 	printk(KERN_DEBUG "hpet clockevent registered\n");
 }
 
-static void hpet_legacy_set_mode(enum clock_event_mode mode,
-			  struct clock_event_device *evt)
+static void hpet_set_mode(enum clock_event_mode mode,
+			  struct clock_event_device *evt, int timer)
 {
 	unsigned long cfg, cmp, now;
 	uint64_t delta;
 
 	switch(mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
-		delta = ((uint64_t)(NSEC_PER_SEC/HZ)) * hpet_clockevent.mult;
-		delta >>= hpet_clockevent.shift;
+		delta = ((uint64_t)(NSEC_PER_SEC/HZ)) * evt->mult;
+		delta >>= evt->shift;
 		now = hpet_readl(HPET_COUNTER);
 		cmp = now + (unsigned long) delta;
-		cfg = hpet_readl(HPET_T0_CFG);
+		cfg = hpet_readl(HPET_Tn_CFG(timer));
 		cfg |= HPET_TN_ENABLE | HPET_TN_PERIODIC |
 		       HPET_TN_SETVAL | HPET_TN_32BIT;
-		hpet_writel(cfg, HPET_T0_CFG);
+		hpet_writel(cfg, HPET_Tn_CFG(timer));
 		/*
 		 * The first write after writing TN_SETVAL to the
 		 * config register sets the counter value, the second
 		 * write sets the period.
 		 */
-		hpet_writel(cmp, HPET_T0_CMP);
+		hpet_writel(cmp, HPET_Tn_CMP(timer));
 		udelay(1);
-		hpet_writel((unsigned long) delta, HPET_T0_CMP);
+		hpet_writel((unsigned long) delta, HPET_Tn_CMP(timer));
 		break;
 
 	case CLOCK_EVT_MODE_ONESHOT:
-		cfg = hpet_readl(HPET_T0_CFG);
+		cfg = hpet_readl(HPET_Tn_CFG(timer));
 		cfg &= ~HPET_TN_PERIODIC;
 		cfg |= HPET_TN_ENABLE | HPET_TN_32BIT;
-		hpet_writel(cfg, HPET_T0_CFG);
+		hpet_writel(cfg, HPET_Tn_CFG(timer));
 		break;
 
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
-		cfg = hpet_readl(HPET_T0_CFG);
+		cfg = hpet_readl(HPET_Tn_CFG(timer));
 		cfg &= ~HPET_TN_ENABLE;
-		hpet_writel(cfg, HPET_T0_CFG);
+		hpet_writel(cfg, HPET_Tn_CFG(timer));
 		break;
 
 	case CLOCK_EVT_MODE_RESUME:
@@ -273,18 +273,30 @@ static void hpet_legacy_set_mode(enum cl
 	}
 }
 
-static int hpet_legacy_next_event(unsigned long delta,
-			   struct clock_event_device *evt)
+static int hpet_next_event(unsigned long delta,
+			   struct clock_event_device *evt, int timer)
 {
 	unsigned long cnt;
 
 	cnt = hpet_readl(HPET_COUNTER);
 	cnt += delta;
-	hpet_writel(cnt, HPET_T0_CMP);
+	hpet_writel(cnt, HPET_Tn_CMP(timer));
 
 	return ((long)(hpet_readl(HPET_COUNTER) - cnt ) > 0) ? -ETIME : 0;
 }
 
+static void hpet_legacy_set_mode(enum clock_event_mode mode,
+			struct clock_event_device *evt)
+{
+	hpet_set_mode(mode, evt, 0);
+}
+
+static int hpet_legacy_next_event(unsigned long delta,
+			struct clock_event_device *evt)
+{
+	return hpet_next_event(delta, evt, 0);
+}
+
 /*
  * Clock source related code
  */

-- 

