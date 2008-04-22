Return-Path: <linux-kernel-owner+w=401wt.eu-S1760943AbYDVCRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760943AbYDVCRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 22:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbYDVCRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 22:17:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:17744 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276AbYDVCRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 22:17:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,691,1199692800"; 
   d="scan'208";a="319747471"
Date: Tue, 22 Apr 2008 10:09:01 +0800
From: alek du <alek.du@intel.com>
To: <linux-kernel@vger.kernel.org>
Cc: jgarzik@pobox.com
Subject: [PATCH 3/3] ata: Add Intel SCH PATA support
Message-ID: <20080422100901.2d9a3d1e@dxy.sh.intel.com>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Apr 2008 02:17:03.0422 (UTC) FILETIME=[F4455DE0:01C8A41E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Intel SCH chipsets (US15W, US15L, UL11L) PATA controller
support.

Signed-off-by: Alek Du <alek.du@intel.com>
---
 drivers/ata/ata_piix.c |   40 ++++++++++++++++++++++++++++++++++++++--
 drivers/ide/pci/piix.c |    2 ++
 2 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index b7c38ee..7f95a9a 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -214,6 +214,8 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	/* ICH7/7-R (i945, i975) UDMA 100*/
 	{ 0x8086, 0x27DF, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 	{ 0x8086, 0x269E, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
+	/* INTEL SCH UDMA 100 */
+	{ 0x8086, 0x811A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 	/* ICH8 Mobile PATA Controller */
 	{ 0x8086, 0x2850, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 
@@ -561,6 +563,10 @@ struct ich_laptop {
 	u16 subdevice;
 };
 
+struct sch_80 {
+	u16 device;
+};
+
 /*
  *	List of laptops that use short cables rather than 80 wire
  */
@@ -577,6 +583,17 @@ static const struct ich_laptop ich_laptop[] = {
 	{ 0, }
 };
 
+/*
+ *	List of chipsets whose port IOCFG and enable bit registers are reserved
+ */
+
+static const struct sch_80 sch_80[] = {
+	/* devid */
+	{ 0x811A },	/* Intel SCH chipset */
+	/* end marker */
+	{ 0, }
+};
+
 /**
  *	ich_pata_cable_detect - Probe host controller cable detect info
  *	@ap: Port for which cable detect info is desired
@@ -592,6 +609,7 @@ static int ich_pata_cable_detect(struct ata_port *ap)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	const struct ich_laptop *lap = &ich_laptop[0];
+	const struct sch_80 *sch = &sch_80[0];
 	u8 tmp, mask;
 
 	/* Check for specials - Acer Aspire 5602WLMi */
@@ -604,6 +622,13 @@ static int ich_pata_cable_detect(struct ata_port *ap)
 		lap++;
 	}
 
+	/* Check for specials - Intel SCH chipset */
+	while (sch->device) {
+		if (sch->device == pdev->device)
+			return ATA_CBL_PATA80;
+		sch++;
+	}
+
 	/* check BIOS cable detect results */
 	mask = ap->port_no == 0 ? PIIX_80C_PRI : PIIX_80C_SEC;
 	pci_read_config_byte(pdev, PIIX_IOCFG, &tmp);
@@ -624,9 +649,20 @@ static int piix_pata_prereset(struct ata_link *link, unsigned long deadline)
 {
 	struct ata_port *ap = link->ap;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	const struct sch_80 *sch = &sch_80[0];
+	int skip_check = 0;
 
-	if (!pci_test_config_bits(pdev, &piix_enable_bits[ap->port_no]))
-		return -ENOENT;
+	/* Check for specials - Intel SCH chipset */
+	while (sch->device) {
+		if (sch->device == pdev->device) {
+			skip_check = 1;
+			break;
+		}
+		sch++;
+	}
+	if (!skip_check)
+		if (!pci_test_config_bits(pdev, &piix_enable_bits[ap->port_no]))
+			return -ENOENT;
 	return ata_sff_prereset(link, deadline);
 }
 
diff --git a/drivers/ide/pci/piix.c b/drivers/ide/pci/piix.c
index decef0f..dce830b 100644
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -377,6 +377,7 @@ static const struct ide_port_info piix_pci_info[] __devinitdata = {
 	/* 22 */ DECLARE_ICH_DEV("ICH4",	ATA_UDMA5),
 	/* 23 */ DECLARE_ICH_DEV("ESB2",	ATA_UDMA5),
 	/* 24 */ DECLARE_ICH_DEV("ICH8M",	ATA_UDMA5),
+	/* 25 */ DECLARE_ICH_DEV("SCH",		ATA_UDMA5),
 };
 
 /**
@@ -450,6 +451,7 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_82801DB_1),  22 },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ESB2_18),    23 },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ICH8_6),     24 },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_SCH_IDE),	25 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, piix_pci_tbl);
-- 
1.5.2.5
