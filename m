Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbXCQCjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbXCQCjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 22:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbXCQCjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 22:39:40 -0400
Received: from usul.saidi.cx ([204.11.33.34]:35302 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753566AbXCQCjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 22:39:39 -0400
Message-ID: <45FB54C4.2020000@overt.org>
Date: Fri, 16 Mar 2007 19:39:00 -0700
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>,
       Carlos Aguiar <carlos.aguiar@indt.org.br>, juha.yrjola@solidboot.com
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [PATCH] MMC: Fix handling of low-voltage cards (take 2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix handling of low voltage MMC cards.

The latest MMC and SD specs both agree that support for
low-voltage operations is indicated by bit 7 in the OCR.
The MMC spec states that the low voltage range is
1.65-1.95V while the SD spec leaves the actual voltage
range undefined - meaning that there is still no such
thing as a low voltage SD card.

However, an old Sandisk spec implied that bits 7.0
represented voltages below 2.0V in 1V or 0.5V increments,
and the code was accordingly written with that expectation.

This confusion meant that host drivers attempting to support
the typical low voltage (1.8V) would set the wrong bits in
the host OCR mask (usually bits 5 and/or 6) resulting in the
the low voltage mode never being used.

This change corrects the low voltage range and adds sanity
checks on the reserved bits (0-6) and for SD cards that
claim to support low-voltage operations.

Signed-off-by: Philip Langdale <philipl@overt.org>

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 21c0517..310b242 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -319,6 +319,17 @@ int mmc_attach_mmc(struct mmc_host *host

 	mmc_attach_bus(host, &mmc_ops);

+	/*
+	 * Sanity check the voltages that the card claims to
+	 * support.
+	 */
+	if (ocr & 0x7F) {
+		printk(KERN_WARNING "%s: card claims to support voltages "
+		       "below the defined range. These will be ignored.\n",
+		       mmc_hostname(host));
+		ocr &= ~0x7F;
+	}
+
 	host->ocr = mmc_select_voltage(host, ocr);

 	/*
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 6289ae6..e27845e 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -297,6 +297,24 @@ int mmc_attach_sd(struct mmc_host *host,

 	mmc_attach_bus(host, &mmc_sd_ops);

+	/*
+	 * Sanity check the voltages that the card claims to
+	 * support.
+	 */
+	if (ocr & 0x7F) {
+		printk(KERN_WARNING "%s: card claims to support voltages "
+		       "below the defined range. These will be ignored.\n",
+		       mmc_hostname(host));
+		ocr &= ~0x7F;
+	}
+
+	if (ocr & MMC_VDD_165_195) {
+		printk(KERN_WARNING "%s: SD card claims to support the "
+		       "incompletely defined 'low voltage range'. This "
+		       "will be ignored.\n", mmc_hostname(host));
+		ocr &= ~MMC_VDD_165_195;
+	}
+
 	host->ocr = mmc_select_voltage(host, ocr);

 	/*
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 2f34ae3..a80c043 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -669,8 +669,7 @@ static void sdhci_set_power(struct sdhci
 	pwr = SDHCI_POWER_ON;

 	switch (1 << power) {
-	case MMC_VDD_17_18:
-	case MMC_VDD_18_19:
+	case MMC_VDD_165_195:
 		pwr |= SDHCI_POWER_180;
 		break;
 	case MMC_VDD_29_30:
@@ -1290,7 +1289,7 @@ static int __devinit sdhci_probe_slot(st
 	if (caps & SDHCI_CAN_VDD_300)
 		mmc->ocr_avail |= MMC_VDD_29_30|MMC_VDD_30_31;
 	if (caps & SDHCI_CAN_VDD_180)
-		mmc->ocr_avail |= MMC_VDD_17_18|MMC_VDD_18_19;
+		mmc->ocr_avail |= MMC_VDD_165_195;

 	if (mmc->ocr_avail == 0) {
 		printk(KERN_ERR "%s: Hardware doesn't report any "
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 5a66d8a..b1350df 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -65,14 +65,7 @@ struct mmc_host {
 	unsigned int		f_max;
 	u32			ocr_avail;

-#define MMC_VDD_145_150		0x00000001	/* VDD voltage 1.45 - 1.50 */
-#define MMC_VDD_150_155		0x00000002	/* VDD voltage 1.50 - 1.55 */
-#define MMC_VDD_155_160		0x00000004	/* VDD voltage 1.55 - 1.60 */
-#define MMC_VDD_160_165		0x00000008	/* VDD voltage 1.60 - 1.65 */
-#define MMC_VDD_165_170		0x00000010	/* VDD voltage 1.65 - 1.70 */
-#define MMC_VDD_17_18		0x00000020	/* VDD voltage 1.7 - 1.8 */
-#define MMC_VDD_18_19		0x00000040	/* VDD voltage 1.8 - 1.9 */
-#define MMC_VDD_19_20		0x00000080	/* VDD voltage 1.9 - 2.0 */
+#define MMC_VDD_165_195		0x00000080	/* VDD voltage 1.65 - 1.95 */
 #define MMC_VDD_20_21		0x00000100	/* VDD voltage 2.0 ~ 2.1 */
 #define MMC_VDD_21_22		0x00000200	/* VDD voltage 2.1 ~ 2.2 */
 #define MMC_VDD_22_23		0x00000400	/* VDD voltage 2.2 ~ 2.3 */

