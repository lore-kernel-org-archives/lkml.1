Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbYFVBM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbYFVBM4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 21:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbYFVBMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 21:12:46 -0400
Received: from mail.queued.net ([207.210.101.209]:2870 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbYFVBMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 21:12:45 -0400
Date: Sat, 21 Jun 2008 21:15:16 -0400
From: Andres Salomon <dilinger@queued.net>
To: akpm@linux-foundation.org
Cc: drzeus-sdhci@drzeus.cx, sdhci-devel@lists.drzeus.cx,
       linux-kernel@vger.kernel.org
Subject: [OLPC] sdhci: add quirk for the Marvell CaFe's vdd/powerup issue
Message-ID: <20080621211516.0645a46f@xo-debian>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has been sitting around unloved for way too long..

The Marvell CaFe chip's SD implementation chokes during card insertion
if one attempts to set the voltage and power up in the same
SDHCI_POWER_CONTROL register write.  This adds a quirk that does
that particular dance in two steps.

It also adds an entry to pci_ids.h for the CaFe chip's SD device.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/mmc/host/sdhci.c |   18 ++++++++++++++++++
 include/linux/pci_ids.h  |    1 +
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 07c2048..5b74c8c 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -55,6 +55,8 @@ static unsigned int debug_quirks = 0;
 #define SDHCI_QUIRK_32BIT_DMA_SIZE			(1<<7)
 /* Controller needs to be reset after each request to stay stable */
 #define SDHCI_QUIRK_RESET_AFTER_REQUEST			(1<<8)
+/* Controller needs voltage and power writes to happen separately */
+#define SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER		(1<<9)
 
 static const struct pci_device_id pci_ids[] __devinitdata = {
 	{
@@ -128,6 +130,14 @@ static const struct pci_device_id pci_ids[] __devinitdata = {
 	},
 
 	{
+		.vendor         = PCI_VENDOR_ID_MARVELL,
+		.device         = PCI_DEVICE_ID_MARVELL_CAFE_SD,
+		.subvendor      = PCI_ANY_ID,
+		.subdevice      = PCI_ANY_ID,
+		.driver_data    = SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER,
+	},
+
+	{
 		.vendor         = PCI_VENDOR_ID_JMICRON,
 		.device         = PCI_DEVICE_ID_JMICRON_JMB38X_SD,
 		.subvendor      = PCI_ANY_ID,
@@ -774,6 +784,14 @@ static void sdhci_set_power(struct sdhci_host *host, unsigned short power)
 		BUG();
 	}
 
+	/*
+	 * At least the CaFe chip gets confused if we set the voltage
+	 * and set turn on power at the same time, so set the voltage first.
+	 */
+	if ((host->chip->quirks & SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER))
+		writeb(pwr & ~SDHCI_POWER_ON,
+				host->ioaddr + SDHCI_POWER_CONTROL);
+
 	writeb(pwr, host->ioaddr + SDHCI_POWER_CONTROL);
 
 out:
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index eafc9d6..6595382 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1520,6 +1520,7 @@
 #define PCI_DEVICE_ID_MARVELL_GT64260	0x6430
 #define PCI_DEVICE_ID_MARVELL_MV64360	0x6460
 #define PCI_DEVICE_ID_MARVELL_MV64460	0x6480
+#define PCI_DEVICE_ID_MARVELL_CAFE_SD	0x4101
 
 #define PCI_VENDOR_ID_V3		0x11b0
 #define PCI_DEVICE_ID_V3_V960		0x0001
-- 
1.5.5.3

