Return-Path: <linux-kernel-owner+w=401wt.eu-S1759014AbYHVWWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759014AbYHVWWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 18:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbYHVWWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 18:22:37 -0400
Received: from isilmar.linta.de ([213.133.102.198]:35023 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754721AbYHVWWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 18:22:36 -0400
Date: Sat, 23 Aug 2008 00:22:33 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, johnstul@us.ibm.com,
       hirofumi@mail.parknet.co.jp, alan@lxorguk.ukuu.org.uk,
       arjan@infradead.org
Subject: [PATCH v2 1/2] acpi_pm.c: use proper read function also in errata mode
Message-ID: <20080822222233.GA547@isilmar.linta.de>
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

next try...


From: Dominik Brodowski <linux@dominikbrodowski.net>
Date: Fri, 22 Aug 2008 23:49:21 +0200
Subject: [PATCH 1/2] acpi_pm.c: use proper read function also in errata mode.

On all hardware (some Intel ICH4, PIIX4 and PIIX4E chipsets) affected by a
hardware errata there's about a 4.2% chance that initialization of the ACPI
PMTMR fails. On those chipsets, we need to read out the timer value at least
three times to get a correct result, for every once in a while (i.e. within
a 3 ns window every 69.8 ns) the read returns a bogus result. During normal
operation we work around this issue, but during initialization reading a
bogus value may lead to -EINVAL even though the hardware is usable.

Thanks to Andreas Mohr for spotting this issue.

CC: John Stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
---
 drivers/clocksource/acpi_pm.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index 5ca1d80..860d033 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -151,13 +151,13 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_LE,
  */
 static int verify_pmtmr_rate(void)
 {
-	u32 value1, value2;
+	cycle_t value1, value2;
 	unsigned long count, delta;
 
 	mach_prepare_counter();
-	value1 = read_pmtmr();
+	value1 = clocksource_acpi_pm.read();
 	mach_countup(&count);
-	value2 = read_pmtmr();
+	value2 = clocksource_acpi_pm.read();
 	delta = (value2 - value1) & ACPI_PM_MASK;
 
 	/* Check that the PMTMR delta is within 5% of what we expect */
@@ -177,7 +177,7 @@ static int verify_pmtmr_rate(void)
 
 static int __init init_acpi_pm_clocksource(void)
 {
-	u32 value1, value2;
+	cycle_t value1, value2;
 	unsigned int i;
 
 	if (!pmtmr_ioport)
@@ -187,9 +187,9 @@ static int __init init_acpi_pm_clocksource(void)
 						clocksource_acpi_pm.shift);
 
 	/* "verify" this timing source: */
-	value1 = read_pmtmr();
+	value1 = clocksource_acpi_pm.read();
 	for (i = 0; i < 10000; i++) {
-		value2 = read_pmtmr();
+		value2 = clocksource_acpi_pm.read();
 		if (value2 == value1)
 			continue;
 		if (value2 > value1)
@@ -197,11 +197,11 @@ static int __init init_acpi_pm_clocksource(void)
 		if ((value2 < value1) && ((value2) < 0xFFF))
 			goto pm_good;
 		printk(KERN_INFO "PM-Timer had inconsistent results:"
-			" 0x%#x, 0x%#x - aborting.\n", value1, value2);
+			" 0x%#llx, 0x%#llx - aborting.\n", value1, value2);
 		return -EINVAL;
 	}
 	printk(KERN_INFO "PM-Timer had no reasonable result:"
-			" 0x%#x - aborting.\n", value1);
+			" 0x%#llx - aborting.\n", value1);
 	return -ENODEV;
 
 pm_good:
-- 
1.5.2.5

