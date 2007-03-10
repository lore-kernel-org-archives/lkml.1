Return-Path: <linux-kernel-owner+w=401wt.eu-S1751353AbXCJXqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbXCJXqZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 18:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbXCJXqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 18:46:25 -0500
Received: from usul.saidi.cx ([204.11.33.34]:58230 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751353AbXCJXqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 18:46:24 -0500
X-Greylist: delayed 1792 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Mar 2007 18:46:24 EST
Message-ID: <45F33C2C.2090905@overt.org>
Date: Sat, 10 Mar 2007 15:15:56 -0800
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>,
       Carlos Aguiar <carlos.aguiar@indt.org.br>, juha.yrjola@solidboot.com
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [PATCH] MMC: Clean up low voltage range handling
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up the handling of low voltage MMC cards.

The latest MMC and SD specs both agree that the low
voltage range is defined as 1.65-1.95V and is signified
by bit 7 in the OCR. An old Sandisk spec implied that
bits 7-0 represented voltages below 2.0V in 1V increments,
and the code was accordingly written with that expectation.

This confusion meant that host drivers attempting to support
the typical low voltage (1.8V) would set the wrong bits in
the host OCR mask (usually bits 5 and 6) resulting in the
the low voltage mode never being used.

This change switches the code to conform to the specs and
fixes the SDHCI driver. It also removes the explicit
defines for the host vdd and updates the SDHCI driver
to convert the bit number back to the mask value
for comparisons. Having only a single set of defines
ensures there's nothing to get out of sync.

Signed-off-by: Philip Langdale <philipl@overt.org>

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index c87ce56..74ebd97 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -317,6 +317,24 @@ static u32 mmc_select_voltage(struct mmc
 {
 	int bit;

+	/*
+	 * Sanity check the voltages that the card claims to
+	 * support.
+	 */
+	if (ocr & 0x7F) {
+		printk("%s: card claims to support voltages below "
+		       "the defined range. These will be ignored.\n",
+		       mmc_hostname(host));
+		ocr &= ~0x7F;
+	}
+
+	if (host->mode == MMC_MODE_SD && (ocr & MMC_VDD_165_195)) {
+		printk("%s: SD card claims to support the incompletely "
+		       "defined 'low voltage range'. This will be ignored.\n",
+		       mmc_hostname(host));
+		ocr &= ~MMC_VDD_165_195;
+	}
+
 	ocr &= host->ocr_avail;

 	bit = ffs(ocr);
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 86d0957..a80c043 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -668,20 +668,16 @@ static void sdhci_set_power(struct sdhci

 	pwr = SDHCI_POWER_ON;

-	switch (power) {
-	case MMC_VDD_170:
-	case MMC_VDD_180:
-	case MMC_VDD_190:
+	switch (1 << power) {
+	case MMC_VDD_165_195:
 		pwr |= SDHCI_POWER_180;
 		break;
-	case MMC_VDD_290:
-	case MMC_VDD_300:
-	case MMC_VDD_310:
+	case MMC_VDD_29_30:
+	case MMC_VDD_30_31:
 		pwr |= SDHCI_POWER_300;
 		break;
-	case MMC_VDD_320:
-	case MMC_VDD_330:
-	case MMC_VDD_340:
+	case MMC_VDD_32_33:
+	case MMC_VDD_33_34:
 		pwr |= SDHCI_POWER_330;
 		break;
 	default:
@@ -1293,7 +1289,7 @@ static int __devinit sdhci_probe_slot(st
 	if (caps & SDHCI_CAN_VDD_300)
 		mmc->ocr_avail |= MMC_VDD_29_30|MMC_VDD_30_31;
 	if (caps & SDHCI_CAN_VDD_180)
-		mmc->ocr_avail |= MMC_VDD_17_18|MMC_VDD_18_19;
+		mmc->ocr_avail |= MMC_VDD_165_195;

 	if (mmc->ocr_avail == 0) {
 		printk(KERN_ERR "%s: Hardware doesn't report any "
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 43bf6a5..89dbb91 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -16,30 +16,7 @@ struct mmc_ios {
 	unsigned int	clock;			/* clock rate */
 	unsigned short	vdd;

-#define	MMC_VDD_150	0
-#define	MMC_VDD_155	1
-#define	MMC_VDD_160	2
-#define	MMC_VDD_165	3
-#define	MMC_VDD_170	4
-#define	MMC_VDD_180	5
-#define	MMC_VDD_190	6
-#define	MMC_VDD_200	7
-#define	MMC_VDD_210	8
-#define	MMC_VDD_220	9
-#define	MMC_VDD_230	10
-#define	MMC_VDD_240	11
-#define	MMC_VDD_250	12
-#define	MMC_VDD_260	13
-#define	MMC_VDD_270	14
-#define	MMC_VDD_280	15
-#define	MMC_VDD_290	16
-#define	MMC_VDD_300	17
-#define	MMC_VDD_310	18
-#define	MMC_VDD_320	19
-#define	MMC_VDD_330	20
-#define	MMC_VDD_340	21
-#define	MMC_VDD_350	22
-#define	MMC_VDD_360	23
+/* vdd stores the bit number of the selected voltage range from protocol.h */

 	unsigned char	bus_mode;		/* command output mode */

@@ -88,14 +65,7 @@ struct mmc_host {
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
