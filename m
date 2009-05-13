Return-Path: <linux-kernel-owner+w=401wt.eu-S1761428AbZEMUHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761428AbZEMUHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 16:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbZEMUGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 16:06:52 -0400
Received: from plexity.net ([206.123.115.38]:52046 "EHLO plexity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbZEMUGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 16:06:51 -0400
Date: Wed, 13 May 2009 20:05:56 +0000
From: Deepak Saxena <dsaxena@plexity.net>
To: pierre@ossman.eu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] MMC: Add 400ms to CAFE SD controller resume path
Message-ID: <20090513200556.GA7882@plexity.net>
Reply-To: dsaxena@plexity.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Plexity, LLC
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The CAFE SD controller takes a long time to completely resume
and w/o this patch, we do not redetect an existing card but
instead detect it as a new one. Even with MMC_UNSAFE_RESUME
enabled, this leads to the partition table on the device being
wiped out.
    
See http://dev.laptop.org/ticket/6532 for gory details.

Signed-off-by: Deepak Saxena <dsaxena@laptop.org>

---

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 65be279..9941bb0 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -105,10 +105,26 @@ static const struct sdhci_pci_fixes sdhci_ene_714 = {
 			  SDHCI_QUIRK_BROKEN_DMA,
 };
 
+
+/*
+ * This 400ms timeout is needed to ensure that the chip has proper time to
+ * wake up an redetect an already inserted card. Without this, we end up
+ * corrupting the partition table on the device.
+ *
+ * See http://dev.laptop.org/ticket/6532 for lots of ugly details.
+ */
+static int cafe_resume(struct sdhci_pci_chip *chip)
+{
+	msleep(400);
+
+	return 0;
+}
+
 static const struct sdhci_pci_fixes sdhci_cafe = {
 	.quirks		= SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER |
 			  SDHCI_QUIRK_NO_BUSY_IRQ |
 			  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL,
+	.resume		= cafe_resume,
 };
 
 static int jmicron_pmos(struct sdhci_pci_chip *chip, int on)


-- 
In the end, they will not say, "those were dark times,"  they will ask
"why were their poets silent?" - Bertold Brecht

