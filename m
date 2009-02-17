Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbZBQWtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbZBQWtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 17:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbZBQWtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 17:49:06 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:26549 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752318AbZBQWtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 17:49:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JnHQRsDe2XzxdtKa5qmsLCCXuvY3aAusyBi3zhoHeXIHmyt+mh8nuzDt8Xd6G9U/LlZpfX3dybLagtPddAiqn5ws4XbUZER+ZYntZvoIqN3kHgHAIafLJKBk7g+Uo1K7p9CjGUV5sH3n5bdrpRaUvp5fZtFa3oMVn7ZFFIgMbFg=  ;
X-YMail-OSG: eNtuVYgVM1kBzZVUJTWhbhoUMoAoPLf0HfNxTctN2JIdQ_vDzolr4yq6tDDTZNePhVqchhTlY8NPmuY7X77OIWuLZ5EuOfYzzrJsBfXYz7_Nyds9x.c.02r7LEvRY0icCfktXdt9usT_W5LFw6LObk4L7CI32MfxdRk6VWF6fXUhwk7ThbNFUYabdw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: [patch 2.6.29-rc5] MMC: omap_hsmmc: only MMC1 allows HCTL.SDVS != 1.8V
Date: Tue, 17 Feb 2009 14:49:01 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>, Tony Lindgren <tony@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902171449.01646.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Based on a patch from Tony Lindgren ... after initialization,
never change HCTL.SDVS except for MMC1.  The other controller
instances only support 1.8V in that field, although they can
suport other card/SDIO/eMMC/... voltages with level shifting
solutions such as external transceivers.

MMC2 behavior sanity tested on Overo/WLAN, OMAP3430 SDP, and
custom hardware.  MMC1 also sanity tested on those platforms
plus Beagle.  This also fixes a bug preventing MMC2 (and also
presumably MMC3) from powering down when requested.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Goes on top of this RC3 bugfix
  http://marc.info/?l=linux-omap&m=123378733331003&w=2
but does not depend on it.

 drivers/mmc/host/omap_hsmmc.c |   43 ++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 10 deletions(-)

--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -55,6 +55,7 @@
 #define VS30			(1 << 25)
 #define SDVS18			(0x5 << 9)
 #define SDVS30			(0x6 << 9)
+#define SDVS33			(0x7 << 9)
 #define SDVSCLR			0xFFFFF1FF
 #define SDVSDET			0x00000400
 #define AUTOIDLE		0x1
@@ -456,13 +457,20 @@ static irqreturn_t mmc_omap_irq(int irq,
 }
 
 /*
- * Switch MMC operating voltage
+ * Switch MMC interface voltage ... only relevant for MMC1.
+ *
+ * MMC2 and MMC3 use fixed 1.8V levels, and maybe a transceiver.
+ * The MMC2 transceiver controls are used instead of DAT4..DAT7.
+ * Some chips, like eMMC ones, use internal transceivers.
  */
 static int omap_mmc_switch_opcond(struct mmc_omap_host *host, int vdd)
 {
 	u32 reg_val = 0;
 	int ret;
 
+	if (host->id != OMAP_MMC1_DEVID)
+		return 0;
+
 	/* Disable the clocks */
 	clk_disable(host->fclk);
 	clk_disable(host->iclk);
@@ -485,19 +493,26 @@ static int omap_mmc_switch_opcond(struct
 	OMAP_HSMMC_WRITE(host->base, HCTL,
 		OMAP_HSMMC_READ(host->base, HCTL) & SDVSCLR);
 	reg_val = OMAP_HSMMC_READ(host->base, HCTL);
+
 	/*
 	 * If a MMC dual voltage card is detected, the set_ios fn calls
 	 * this fn with VDD bit set for 1.8V. Upon card removal from the
 	 * slot, omap_mmc_set_ios sets the VDD back to 3V on MMC_POWER_OFF.
 	 *
-	 * Only MMC1 supports 3.0V.  MMC2 will not function if SDVS30 is
-	 * set in HCTL.
+	 * Cope with a bit of slop in the range ... per data sheets:
+	 *  - "1.8V" for vdds_mmc1/vdds_mmc1a can be up to 2.45V max,
+	 *    but recommended values are 1.71V to 1.89V
+	 *  - "3.0V" for vdds_mmc1/vdds_mmc1a can be up to 3.5V max,
+	 *    but recommended values are 2.7V to 3.3V
+	 *
+	 * Board setup code shouldn't permit anything very out-of-range.
+	 * TWL4030-family VMMC1 and VSIM regulators are fine (avoiding the
+	 * middle range) but VSIM can't power DAT4..DAT7 at more than 3V.
 	 */
-	if (host->id == OMAP_MMC1_DEVID && (((1 << vdd) == MMC_VDD_32_33) ||
-				((1 << vdd) == MMC_VDD_33_34)))
-		reg_val |= SDVS30;
-	if ((1 << vdd) == MMC_VDD_165_195)
+	if ((1 << vdd) <= MMC_VDD_23_24)
 		reg_val |= SDVS18;
+	else
+		reg_val |= SDVS30;
 
 	OMAP_HSMMC_WRITE(host->base, HCTL, reg_val);
 
@@ -759,10 +774,14 @@ static void omap_mmc_set_ios(struct mmc_
 	case MMC_POWER_OFF:
 		mmc_slot(host).set_power(host->dev, host->slot_id, 0, 0);
 		/*
-		 * Reset bus voltage to 3V if it got set to 1.8V earlier.
+		 * Reset interface voltage to 3V if it's 1.8V now;
+		 * only relevant on MMC-1, the others always use 1.8V.
+		 *
 		 * REVISIT: If we are able to detect cards after unplugging
 		 * a 1.8V card, this code should not be needed.
 		 */
+		if (host->id != OMAP_MMC1_DEVID)
+			break;
 		if (!(OMAP_HSMMC_READ(host->base, HCTL) & SDVSDET)) {
 			int vdd = fls(host->mmc->ocr_avail) - 1;
 			if (omap_mmc_switch_opcond(host, vdd) != 0)
@@ -786,7 +805,9 @@ static void omap_mmc_set_ios(struct mmc_
 	}
 
 	if (host->id == OMAP_MMC1_DEVID) {
-		/* Only MMC1 can operate at 3V/1.8V */
+		/* Only MMC1 can interface at 3V without some flavor
+		 * of external transceiver; but they all handle 1.8V.
+		 */
 		if ((OMAP_HSMMC_READ(host->base, HCTL) & SDVSDET) &&
 			(ios->vdd == DUAL_VOLT_OCR_BIT)) {
 				/*
@@ -1139,7 +1160,9 @@ static int omap_mmc_suspend(struct platf
 						" level suspend\n");
 			}
 
-			if (!(OMAP_HSMMC_READ(host->base, HCTL) & SDVSDET)) {
+			if (host->id == OMAP_MMC1_DEVID
+					&& !(OMAP_HSMMC_READ(host->base, HCTL)
+							& SDVSDET)) {
 				OMAP_HSMMC_WRITE(host->base, HCTL,
 					OMAP_HSMMC_READ(host->base, HCTL)
 					& SDVSCLR);
