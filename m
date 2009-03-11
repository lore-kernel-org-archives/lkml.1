Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbZCKNCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbZCKNCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 09:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755924AbZCKNBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 09:01:43 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:29160 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856AbZCKNBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 09:01:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=LoAXKmUTAWGkBXy/C3n7/ZznuTIJ67TXx0ZFDxdXK2xA5b47gTYIBOYtZM3C4rnecs
         Vip99ZvZrAaNvO8NNVIHZ/NNFyeUqf3HBzyAMkUYrVjPlq823LzqC/EYQCdTkAayp9mT
         ASR9xu7kXU0vLLhFJDyuW1EnTYtlIJX2CYIJo=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: drzeus-wbsd@drzeus.cx, Magnus Damm <magnus.damm@gmail.com>,
       ian@mnementh.co.uk, akpm@linux-foundation.org
Date: Wed, 11 Mar 2009 21:59:11 +0900
Message-Id: <20090311125911.1563.27785.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se>
References: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se>
Subject: [PATCH 03/05] tmio_mmc: Break out cnf area operations
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:  Magnus Damm <damm@opensource.se>

Break out tmio_mmc io operations for the cnf area.
This moves similar register operations into one place.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/mmc/host/tmio_mmc.c |   59 ++++++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 20 deletions(-)

--- 0011/drivers/mmc/host/tmio_mmc.c
+++ work/drivers/mmc/host/tmio_mmc.c	2009-03-11 19:31:58.000000000 +0900
@@ -35,6 +35,36 @@
 
 #include "tmio_mmc.h"
 
+static void tmio_mmc_cnf_power(struct tmio_mmc_host *host, int on)
+{
+	tmio_iowrite8(on ? 0x02 : 0x00, host->cnf + CNF_PWR_CTL_2);
+}
+
+static void tmio_mmc_cnf_setup_regs(struct tmio_mmc_host *host,
+				    struct platform_device *dev)
+{
+	/* Enable the MMC/SD Control registers */
+	tmio_iowrite16(SDCREN, host->cnf + CNF_CMD);
+	tmio_iowrite32(dev->resource[0].start & 0xfffe,
+		       host->cnf + CNF_CTL_BASE);
+}
+
+static void tmio_mmc_cnf_setup_clock(struct tmio_mmc_host *host,
+				     int divide_by_one)
+{
+	tmio_iowrite8(divide_by_one ? 0 : 1,
+		      host->cnf + CNF_SD_CLK_MODE);
+}
+
+static void tmio_mmc_cnf_setup_late(struct tmio_mmc_host *host)
+{
+	/* Disable SD power during suspend */
+	tmio_iowrite8(0x01, host->cnf + CNF_PWR_CTL_3);
+
+	/* The below is required but why? FIXME */
+	tmio_iowrite8(0x1f, host->cnf + CNF_STOP_CLK_CTL);
+}
+
 /*
  * Fixme - documentation conflicts on what the clock values are for the
  * various dividers.
@@ -46,7 +76,6 @@
 
 static void tmio_mmc_set_clock(struct tmio_mmc_host *host, int new_clock)
 {
-	void __iomem *cnf = host->cnf;
 	void __iomem *ctl = host->ctl;
 	u32 clk = 0, clock;
 
@@ -59,7 +88,8 @@ static void tmio_mmc_set_clock(struct tm
 			clk = 0x20000;
 
 		clk >>= 2;
-		tmio_iowrite8((clk & 0x8000) ? 0 : 1, cnf + CNF_SD_CLK_MODE);
+
+		tmio_mmc_cnf_setup_clock(host, clk & 0x8000);
 		clk |= 0x100;
 	}
 
@@ -449,7 +479,6 @@ fail:
 static void tmio_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct tmio_mmc_host *host = mmc_priv(mmc);
-	void __iomem *cnf = host->cnf;
 	void __iomem *ctl = host->ctl;
 
 	if (ios->clock)
@@ -458,12 +487,11 @@ static void tmio_mmc_set_ios(struct mmc_
 	/* Power sequence - OFF -> ON -> UP */
 	switch (ios->power_mode) {
 	case MMC_POWER_OFF: /* power down SD bus */
-		tmio_iowrite8(0x00, cnf + CNF_PWR_CTL_2);
+		tmio_mmc_cnf_power(host, 0);
 		tmio_mmc_clk_stop(host);
 		break;
 	case MMC_POWER_ON: /* power up SD bus */
-
-		tmio_iowrite8(0x02, cnf + CNF_PWR_CTL_2);
+		tmio_mmc_cnf_power(host, 1);
 		break;
 	case MMC_POWER_UP: /* start bus clock */
 		tmio_mmc_clk_start(host);
@@ -518,12 +546,10 @@ static int tmio_mmc_resume(struct platfo
 	struct mfd_cell	*cell = (struct mfd_cell *)dev->dev.platform_data;
 	struct mmc_host *mmc = platform_get_drvdata(dev);
 	struct tmio_mmc_host *host = mmc_priv(mmc);
-	void __iomem *cnf = host->cnf;
 	int ret = 0;
 
 	/* Enable the MMC/SD Control registers */
-	tmio_iowrite16(SDCREN, cnf + CNF_CMD);
-	tmio_iowrite32(dev->resource[0].start & 0xfffe, cnf + CNF_CTL_BASE);
+	tmio_mmc_cnf_setup_regs(host, dev);
 
 	/* Tell the MFD core we are ready to be enabled */
 	if (cell->enable) {
@@ -583,9 +609,7 @@ static int __devinit tmio_mmc_probe(stru
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
 
 	/* Enable the MMC/SD Control registers */
-	tmio_iowrite16(SDCREN, host->cnf + CNF_CMD);
-	tmio_iowrite32(dev->resource[0].start & 0xfffe,
-		host->cnf + CNF_CTL_BASE);
+	tmio_mmc_cnf_setup_regs(host, dev);
 
 	/* Tell the MFD core we are ready to be enabled */
 	if (cell->enable) {
@@ -594,15 +618,10 @@ static int __devinit tmio_mmc_probe(stru
 			goto unmap_cnf;
 	}
 
-	/* Disable SD power during suspend */
-	tmio_iowrite8(0x01, host->cnf + CNF_PWR_CTL_3);
-
-	/* The below is required but why? FIXME */
-	tmio_iowrite8(0x1f, host->cnf + CNF_STOP_CLK_CTL);
-
-	/* Power down SD bus*/
-	tmio_iowrite8(0x0,  host->cnf + CNF_PWR_CTL_2);
+	tmio_mmc_cnf_setup_late(host);
 
+	/* Power down SD bus */
+	tmio_mmc_cnf_power(host, 0);
 	tmio_mmc_clk_stop(host);
 	reset(host);
 
