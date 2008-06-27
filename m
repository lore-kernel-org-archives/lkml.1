Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbYF0UWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbYF0UWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761539AbYF0UWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:22:22 -0400
Received: from mail.queued.net ([207.210.101.209]:1712 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756885AbYF0UWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:22:21 -0400
Date: Fri, 27 Jun 2008 16:24:35 -0400
From: Andres Salomon <dilinger@queued.net>
To: drzeus-sdhci@drzeus.cx
Cc: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 1/2] [OLPC] sdhci: add quirk for the Marvell CaFe's
 vdd/powerup issue
Message-ID: <20080627162435.0136788f@xo-debian>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

Here are the reworked patches.  Unfortunately, I'm traveling and don't
have an SD card with me to test these out with.




The Marvell CaFe chip's SD implementation chokes during card insertion
if one attempts to set the voltage and power up in the same
SDHCI_POWER_CONTROL register write.  This adds a quirk that does
that particular dance in two steps.

It also adds an entry to pci_ids.h for the CaFe chip's SD device.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/mmc/host/sdhci-pci.c |   12 ++++++++++++
 drivers/mmc/host/sdhci.c     |    8 ++++++++
 drivers/mmc/host/sdhci.h     |    2 ++
 include/linux/pci_ids.h      |    1 +
 4 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 22aab6a..ec375b8 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -104,6 +104,10 @@ static const struct sdhci_pci_fixes sdhci_ene_714 = {
 			  SDHCI_QUIRK_RESET_CMD_DATA_ON_IOS,
 };
 
+static const struct sdhci_pci_fixes sdhci_cafe = {
+	.quirks		= SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER,
+};
+
 static int jmicron_pmos(struct sdhci_pci_chip *chip, int on)
 {
 	u8 scratch;
@@ -299,6 +303,14 @@ static const struct pci_device_id pci_ids[] __devinitdata = {
 	},
 
 	{
+		.vendor		= PCI_VENDOR_ID_MARVELL,
+		.device		= PCI_DEVICE_ID_MARVELL_CAFE_SD,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (kernel_ulong_t)&sdhci_cafe,
+	},
+
+	{
 		.vendor		= PCI_VENDOR_ID_JMICRON,
 		.device		= PCI_DEVICE_ID_JMICRON_JMB38X_SD,
 		.subvendor	= PCI_ANY_ID,
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 6441e44..5f1c1bf 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -658,6 +658,14 @@ static void sdhci_set_power(struct sdhci_host *host, unsigned short power)
 		BUG();
 	}
 
+	/*
+	 * At least the Marvell CaFe chip gets confused if we set the voltage
+	 * and set turn on power at the same time, so set the voltage first.
+	 */
+	if ((host->quirks & SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER))
+		writeb(pwr & ~SDHCI_POWER_ON,
+				host->ioaddr + SDHCI_POWER_CONTROL);
+
 	writeb(pwr, host->ioaddr + SDHCI_POWER_CONTROL);
 
 out:
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 3d0a2c2..37ae056 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -176,6 +176,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_32BIT_DMA_SIZE			(1<<7)
 /* Controller needs to be reset after each request to stay stable */
 #define SDHCI_QUIRK_RESET_AFTER_REQUEST			(1<<8)
+/* Controller needs voltage and power writes to happen separately */
+#define SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER		(1<<9)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 0e964c0..3015347 100644
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

