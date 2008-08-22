Return-Path: <linux-kernel-owner+w=401wt.eu-S1758323AbYHVW0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323AbYHVW0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 18:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYHVW0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 18:26:06 -0400
Received: from isilmar.linta.de ([213.133.102.198]:59123 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754629AbYHVW0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 18:26:05 -0400
Date: Sat, 23 Aug 2008 00:26:04 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, johnstul@us.ibm.com,
       hirofumi@mail.parknet.co.jp, alan@lxorguk.ukuu.org.uk,
       arjan@infradead.org
Subject: [PATCH v2 2/2] acpi_pm.c: check for monotonicity
Message-ID: <20080822222604.GA704@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org, johnstul@us.ibm.com,
	hirofumi@mail.parknet.co.jp, alan@lxorguk.ukuu.org.uk,
	arjan@infradead.org
References: <20080810190759.GA1879@rhlx01.hs-esslingen.de> <20080818190325.GA12581@comet.dominikbrodowski.net> <20080818121924.6b61f7af.akpm@linux-foundation.org> <20080818193517.GA22097@isilmar.linta.de> <20080818124755.162f24d1.akpm@linux-foundation.org> <20080818200916.GA18209@comet.dominikbrodowski.net> <20080818201033.GB18209@comet.dominikbrodowski.net> <20080819024334.2f3e69fa.akpm@linux-foundation.org> <20080819094938.GA21126@isilmar.linta.de> <20080819025915.c34951b6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819025915.c34951b6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Dominik Brodowski <linux@dominikbrodowski.net>
Date: Fri, 22 Aug 2008 23:51:23 +0200
Subject: [PATCH 2/2] acpi_pm.c: check for monotonicity

The current check for monotonicity is way too weak: Andreas Mohr reports
( http://lkml.org/lkml/2008/8/10/77  ) that on one of his test systems the
current check only triggers in 50% of all cases, leading to catastrophic timer
behaviour. To fix this issue, expand the check for monotonicity by doing ten
consecutive tests instead of one.

CC: John Stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
---
 drivers/clocksource/acpi_pm.c |   46 +++++++++++++++++++++++++---------------
 1 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index 860d033..4eee533 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -21,6 +21,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <linux/delay.h>
 #include <asm/io.h>
 
 /*
@@ -175,10 +176,13 @@ static int verify_pmtmr_rate(void)
 #define verify_pmtmr_rate() (0)
 #endif
 
+/* Number of monotonicity checks to perform during initialization */
+#define ACPI_PM_MONOTONICITY_CHECKS 10
+
 static int __init init_acpi_pm_clocksource(void)
 {
 	cycle_t value1, value2;
-	unsigned int i;
+	unsigned int i, j, good = 0;
 
 	if (!pmtmr_ioport)
 		return -ENODEV;
@@ -187,24 +191,32 @@ static int __init init_acpi_pm_clocksource(void)
 						clocksource_acpi_pm.shift);
 
 	/* "verify" this timing source: */
-	value1 = clocksource_acpi_pm.read();
-	for (i = 0; i < 10000; i++) {
-		value2 = clocksource_acpi_pm.read();
-		if (value2 == value1)
-			continue;
-		if (value2 > value1)
-			goto pm_good;
-		if ((value2 < value1) && ((value2) < 0xFFF))
-			goto pm_good;
-		printk(KERN_INFO "PM-Timer had inconsistent results:"
-			" 0x%#llx, 0x%#llx - aborting.\n", value1, value2);
-		return -EINVAL;
+	for (j = 0; j < ACPI_PM_MONOTONICITY_CHECKS; j++) {
+		value1 = clocksource_acpi_pm.read();
+		for (i = 0; i < 10000; i++) {
+			value2 = clocksource_acpi_pm.read();
+			if (value2 == value1)
+				continue;
+			if (value2 > value1)
+				good++;
+				break;
+			if ((value2 < value1) && ((value2) < 0xFFF))
+				good++;
+				break;
+			printk(KERN_INFO "PM-Timer had inconsistent results:"
+			       " 0x%#llx, 0x%#llx - aborting.\n",
+			       value1, value2);
+			return -EINVAL;
+		}
+		udelay(300 * i);
+	}
+
+	if (good != ACPI_PM_MONOTONICITY_CHECKS) {
+		printk(KERN_INFO "PM-Timer failed consistency check "
+		       " (0x%#llx) - aborting.\n", value1);
+		return -ENODEV;
 	}
-	printk(KERN_INFO "PM-Timer had no reasonable result:"
-			" 0x%#llx - aborting.\n", value1);
-	return -ENODEV;
 
-pm_good:
 	if (verify_pmtmr_rate() != 0)
 		return -ENODEV;
 
-- 
1.5.2.5

