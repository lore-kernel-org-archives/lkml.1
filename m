Return-Path: <linux-kernel-owner+w=401wt.eu-S1764421AbYEARfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764421AbYEARfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 13:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760910AbYEARfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 13:35:19 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:9729 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760398AbYEARfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 13:35:17 -0400
Message-Id: <20080501173123.444094226@mvista.com>
User-Agent: quilt/0.46-1
Date: Thu, 01 May 2008 10:31:23 -0700
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: johnstul@us.ibm.com, ralf@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH] clocksource: shift helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a little helper I pulled from the mips tree. I've seen a couple 
of bogus shift values, and this helper calculates the shift. This
should move the shift selection away from the user, and systematically
pick the value base on the hz.

I also modified the acpi_pm timer to use this new interface. The original
shift was 22 , and after this patch it's increased to 23. Which should make
the clocksource slightly more accurate, but shouldn't have much of a visible
effect.

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 drivers/clocksource/acpi_pm.c |    5 ++++-
 include/linux/acpi_pmtmr.h    |    5 +++--
 include/linux/clocksource.h   |   21 +++++++++++++++++++++
 3 files changed, 28 insertions(+), 3 deletions(-)

Index: linux-2.6.25/drivers/clocksource/acpi_pm.c
===================================================================
--- linux-2.6.25.orig/drivers/clocksource/acpi_pm.c
+++ linux-2.6.25/drivers/clocksource/acpi_pm.c
@@ -72,7 +72,7 @@ static struct clocksource clocksource_ac
 	.read		= acpi_pm_read,
 	.mask		= (cycle_t)ACPI_PM_MASK,
 	.mult		= 0, /*to be calculated*/
-	.shift		= 22,
+	.shift		= 0,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 
 };
@@ -183,6 +183,9 @@ static int __init init_acpi_pm_clocksour
 	if (!pmtmr_ioport)
 		return -ENODEV;
 
+	clocksource_acpi_pm.shift =
+		clocksource_hz2shift(ACPI_PM_BITS, PMTMR_TICKS_PER_SEC);
+
 	clocksource_acpi_pm.mult = clocksource_hz2mult(PMTMR_TICKS_PER_SEC,
 						clocksource_acpi_pm.shift);
 
Index: linux-2.6.25/include/linux/acpi_pmtmr.h
===================================================================
--- linux-2.6.25.orig/include/linux/acpi_pmtmr.h
+++ linux-2.6.25/include/linux/acpi_pmtmr.h
@@ -7,10 +7,11 @@
 #define PMTMR_TICKS_PER_SEC 3579545
 
 /* limit it to 24 bits */
-#define ACPI_PM_MASK CLOCKSOURCE_MASK(24)
+#define ACPI_PM_BITS	24
+#define ACPI_PM_MASK CLOCKSOURCE_MASK(ACPI_PM_BITS)
 
 /* Overrun value */
-#define ACPI_PM_OVRRUN	(1<<24)
+#define ACPI_PM_OVRRUN	(1 << ACPI_PM_BITS)
 
 #ifdef CONFIG_X86_PM_TIMER
 
Index: linux-2.6.25/include/linux/clocksource.h
===================================================================
--- linux-2.6.25.orig/include/linux/clocksource.h
+++ linux-2.6.25/include/linux/clocksource.h
@@ -157,6 +157,27 @@ static inline u32 clocksource_hz2mult(u3
 }
 
 /**
+ * clocksource_hz2shift - calculates shift from hz and # of bits
+ * @bits:		Number of bits this clocksource uses
+ * @hz:			Clocksource frequency in Hz
+ *
+ * Helper functions that calculates the best shift value
+ * based on the hz and # of bits of any given clock.
+ */
+static inline u32 clocksource_hz2shift(u32 bits, u32 hz)
+{
+	u64 temp;
+
+	for (; bits > 0; bits--) {
+		temp = (u64) NSEC_PER_SEC << bits;
+		do_div(temp, hz);
+		if ((temp >> 32) == 0)
+			break;
+	}
+	return bits;
+}
+
+/**
  * clocksource_read: - Access the clocksource's current cycle value
  * @cs:		pointer to clocksource being read
  *
-- 

-- 
