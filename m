Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbYHJUCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbYHJUCo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 16:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYHJUCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 16:02:36 -0400
Received: from isilmar.linta.de ([213.133.102.198]:41721 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753329AbYHJUCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 16:02:35 -0400
Date: Sun, 10 Aug 2008 22:02:24 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Andreas Mohr <andi@lisas.de>
Cc: LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-acpi@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: ACPI PM-Timer on K6-3 SiS5591: Houston...
Message-ID: <20080810200224.GA6551@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Andreas Mohr <andi@lisas.de>, LKML <linux-kernel@vger.kernel.org>,
	john stultz <johnstul@us.ibm.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-acpi@vger.kernel.org,
	Arjan van de Ven <arjan@infradead.org>
References: <20080810101730.GA10024@rhlx01.hs-esslingen.de> <20080810162920.GA9860@comet.dominikbrodowski.net> <20080810190759.GA1879@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080810190759.GA1879@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

On Sun, Aug 10, 2008 at 09:08:02PM +0200, Andreas Mohr wrote:
> And it's in fact not this triple-read which has any weakness here but rather
> the init check.

right.

> IMHO the current init check is too weak, it will catch the very simplest
> types of problems only, and that's not a good thing.

what about this?

Best,
	Dominik


acpi_pm.c: check for monotonicity

Expand the check for monotonicity by doing ten tests instead of one. 

Applies on top of "acpi_pm.c: use proper read function also in errata mode."

Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.de>

diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index 2c00edd..f05c4fb 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -178,7 +178,7 @@ static int verify_pmtmr_rate(void)
 static int __init init_acpi_pm_clocksource(void)
 {
 	cycle_t value1, value2;
-	unsigned int i;
+	unsigned int i, j, good = 0;
 
 	if (!pmtmr_ioport)
 		return -ENODEV;
@@ -187,24 +187,32 @@ static int __init init_acpi_pm_clocksource(void)
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
+	for (j = 0; j < 10; j++) {
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
+	if (good != 10) {
+		printk(KERN_INFO "PM-Timer had no reasonable result:"
+		       " 0x%#llx - aborting.\n", value1);
+		return -ENODEV;
 	}
-	printk(KERN_INFO "PM-Timer had no reasonable result:"
-			" 0x%#llx - aborting.\n", value1);
-	return -ENODEV;
 
-pm_good:
 	if (verify_pmtmr_rate() != 0)
 		return -ENODEV;
 
