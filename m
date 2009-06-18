Return-Path: <linux-kernel-owner+w=401wt.eu-S1764153AbZFRPAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764153AbZFRPAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 11:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757357AbZFRPAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 11:00:05 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:53777 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735AbZFRPAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 11:00:04 -0400
Date: Thu, 18 Jun 2009 16:53:38 +0200
From: Harald Welte <HaraldWelte@viatech.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: [PATCH] sdhci: Specific quirk vor VIA SDHCI controller in VX855ES
Message-ID: <20090618145338.GX7692@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SDHCI controller found in the VX855ES requires 10ms
delay between applying power and applying clock.

This issue has been discovered and documented by the OLPC XO1.5 team.

Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
---
 drivers/mmc/host/sdhci-pci.c |   20 ++++++++++++++++++++
 drivers/mmc/host/sdhci.c     |    7 +++++++
 drivers/mmc/host/sdhci.h     |    2 ++
 3 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 65be279..2f15cc1 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -284,6 +284,18 @@ static const struct sdhci_pci_fixes sdhci_jmicron = {
 	.resume		= jmicron_resume,
 };
 
+static int via_probe(struct sdhci_pci_chip *chip)
+{
+	if (chip->pdev->revision == 0x10)
+		chip->quirks |= SDHCI_QUIRK_DELAY_AFTER_POWER;
+
+	return 0;
+}
+
+static const struct sdhci_pci_fixes sdhci_via = {
+	.probe		= via_probe,
+};
+
 static const struct pci_device_id pci_ids[] __devinitdata = {
 	{
 		.vendor		= PCI_VENDOR_ID_RICOH,
@@ -349,6 +361,14 @@ static const struct pci_device_id pci_ids[] __devinitdata = {
 		.driver_data	= (kernel_ulong_t)&sdhci_jmicron,
 	},
 
+	{
+		.vendor		= PCI_VENDOR_ID_VIA,
+		.device		= 0x95d0,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (kernel_ulong_t)&sdhci_via,
+	},
+
 	{	/* Generic SD host controller */
 		PCI_DEVICE_CLASS((PCI_CLASS_SYSTEM_SDHCI << 8), 0xFFFF00)
 	},
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 35789c6..62e2a63 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1057,6 +1057,13 @@ static void sdhci_set_power(struct sdhci_host *host, unsigned short power)
 	pwr |= SDHCI_POWER_ON;
 
 	sdhci_writeb(host, pwr, SDHCI_POWER_CONTROL);
+
+	/*
+	 * Some controllers need an extra 10ms delay of 10ms before they
+	 * can apply clock after applying power
+	 */
+	if ((host->quirks & SDHCI_QUIRK_DELAY_AFTER_POWER))
+		mdelay(10);
 }
 
 /*****************************************************************************\
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 2de0834..9832a5f 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -226,6 +226,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET		(1<<19)
 /* Controller has to be forced to use block size of 2048 bytes */
 #define SDHCI_QUIRK_FORCE_BLK_SZ_2048			(1<<20)
+/* Controller needs 10ms delay between applying power and clock */
+#define SDHCI_QUIRK_DELAY_AFTER_POWER			(1<<21)
 
 	int			irq;		/* Device IRQ */
 	void __iomem *		ioaddr;		/* Mapped address */
-- 
1.6.3.1
