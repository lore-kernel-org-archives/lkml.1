Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980Ab0A2QMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab0A2QMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755895Ab0A2QMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:12:45 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:47963 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab0A2QJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:09:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=q+W3aG3cTmAJr2SwdMTBfn5idS1OhaTSou3qLBdxXKBPxP4HLHs8hAzq+Igqw9gBky
         jWY/t+5+v1n1N2HIWCWcwD9CC0ARJNYfCXrf7KIU6X83xp0VMaAyfOORwrZ+chAz8tvn
         /eeZpdCKzh1qpmkUJEDrGiXDMB71Uk28Tha+s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:09:21 +0100
Message-Id: <20100129160921.21495.71686.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 58/68] pata_sc1200: move code to be re-used by ide2libata to pata_sc1200.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_sc1200: move code to be re-used by ide2libata to pata_sc1200.h

Convert C99 style comments while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_sc1200.c |  108 --------------------------------------------
 drivers/ata/pata_sc1200.h |  112 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 113 insertions(+), 107 deletions(-)

Index: b/drivers/ata/pata_sc1200.c
===================================================================
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -41,113 +41,7 @@
 #define DRV_NAME	"sc1200"
 #define DRV_VERSION	"0.2.6"
 
-#define SC1200_REV_A	0x00
-#define SC1200_REV_B1	0x01
-#define SC1200_REV_B3	0x02
-#define SC1200_REV_C1	0x03
-#define SC1200_REV_D1	0x04
-
-/**
- *	sc1200_clock	-	PCI clock
- *
- *	Return the PCI bus clocking for the SC1200 chipset configuration
- *	in use. We return 0 for 33MHz 1 for 48MHz and 2 for 66Mhz
- */
-
-static int sc1200_clock(void)
-{
-	/* Magic registers that give us the chipset data */
-	u8 chip_id = inb(0x903C);
-	u8 silicon_rev = inb(0x903D);
-	u16 pci_clock;
-
-	if (chip_id == 0x04 && silicon_rev < SC1200_REV_B1)
-		return 0;	/* 33 MHz mode */
-
-	/* Clock generator configuration 0x901E its 8/9 are the PCI clocking
-	   0/3 is 33Mhz 1 is 48 2 is 66 */
-
-	pci_clock = inw(0x901E);
-	pci_clock >>= 8;
-	pci_clock &= 0x03;
-	if (pci_clock == 3)
-		pci_clock = 0;
-	return pci_clock;
-}
-
-/**
- *	sc1200_set_piomode		-	PIO setup
- *	@ap: ATA interface
- *	@adev: device on the interface
- *
- *	Set our PIO requirements. This is fairly simple on the SC1200
- */
-
-static void sc1200_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	static const u32 pio_timings[4][5] = {
-		{0x00009172, 0x00012171, 0x00020080, 0x00032010, 0x00040010},	// format0  33Mhz
-		{0xd1329172, 0x71212171, 0x30200080, 0x20102010, 0x00100010},	// format1, 33Mhz
-		{0xfaa3f4f3, 0xc23232b2, 0x513101c1, 0x31213121, 0x10211021},	// format1, 48Mhz
-		{0xfff4fff4, 0xf35353d3, 0x814102f1, 0x42314231, 0x11311131}	// format1, 66Mhz
-	};
-
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u32 format;
-	unsigned int reg = 0x40 + 0x10 * ap->port_no;
-	int mode = adev->pio_mode - XFER_PIO_0;
-
-	pci_read_config_dword(pdev, reg + 4, &format);
-	format >>= 31;
-	format += sc1200_clock();
-	pci_write_config_dword(pdev, reg + 8 * adev->devno,
-				pio_timings[format][mode]);
-}
-
-/**
- *	sc1200_set_dmamode		-	DMA timing setup
- *	@ap: ATA interface
- *	@adev: Device being configured
- *
- *	We cannot mix MWDMA and UDMA without reloading timings each switch
- *	master to slave.
- */
-
-static void sc1200_set_dmamode(struct ata_port *ap, struct ata_device *adev)
-{
-	static const u32 udma_timing[3][3] = {
-		{ 0x00921250, 0x00911140, 0x00911030 },
-		{ 0x00932470, 0x00922260, 0x00922140 },
-		{ 0x009436A1, 0x00933481, 0x00923261 }
-	};
-
-	static const u32 mwdma_timing[3][3] = {
-		{ 0x00077771, 0x00012121, 0x00002020 },
-		{ 0x000BBBB2, 0x00024241, 0x00013131 },
-		{ 0x000FFFF3, 0x00035352, 0x00015151 }
-	};
-
-	int clock = sc1200_clock();
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	unsigned int reg = 0x40 + 0x10 * ap->port_no;
-	int mode = adev->dma_mode;
-	u32 format;
-
-	if (mode >= XFER_UDMA_0)
-		format = udma_timing[clock][mode - XFER_UDMA_0];
-	else
-		format = mwdma_timing[clock][mode - XFER_MW_DMA_0];
-
-	if (adev->devno == 0) {
-		u32 timings;
-
-		pci_read_config_dword(pdev, reg + 4, &timings);
-		timings &= 0x80000000UL;
-		timings |= format;
-		pci_write_config_dword(pdev, reg + 4, timings);
-	} else
-		pci_write_config_dword(pdev, reg + 12, format);
-}
+#include "pata_sc1200.h"
 
 /**
  *	sc1200_qc_issue		-	command issue
Index: b/drivers/ata/pata_sc1200.h
===================================================================
--- /dev/null
+++ b/drivers/ata/pata_sc1200.h
@@ -0,0 +1,112 @@
+
+#define SC1200_REV_A	0x00
+#define SC1200_REV_B1	0x01
+#define SC1200_REV_B3	0x02
+#define SC1200_REV_C1	0x03
+#define SC1200_REV_D1	0x04
+
+/**
+ *	sc1200_clock	-	PCI clock
+ *
+ *	Return the PCI bus clocking for the SC1200 chipset configuration
+ *	in use. We return 0 for 33MHz 1 for 48MHz and 2 for 66Mhz
+ */
+
+static int sc1200_clock(void)
+{
+	/* Magic registers that give us the chipset data */
+	u8 chip_id = inb(0x903C);
+	u8 silicon_rev = inb(0x903D);
+	u16 pci_clock;
+
+	if (chip_id == 0x04 && silicon_rev < SC1200_REV_B1)
+		return 0;	/* 33 MHz mode */
+
+	/* Clock generator configuration 0x901E its 8/9 are the PCI clocking
+	   0/3 is 33Mhz 1 is 48 2 is 66 */
+
+	pci_clock = inw(0x901E);
+	pci_clock >>= 8;
+	pci_clock &= 0x03;
+	if (pci_clock == 3)
+		pci_clock = 0;
+	return pci_clock;
+}
+
+/**
+ *	sc1200_set_piomode		-	PIO setup
+ *	@ap: ATA interface
+ *	@adev: device on the interface
+ *
+ *	Set our PIO requirements. This is fairly simple on the SC1200
+ */
+
+static void sc1200_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	static const u32 pio_timings[4][5] = {
+		/* format0  33Mhz */
+		{0x00009172, 0x00012171, 0x00020080, 0x00032010, 0x00040010},
+		/* format1, 33Mhz */
+		{0xd1329172, 0x71212171, 0x30200080, 0x20102010, 0x00100010},
+		/* format1, 48Mhz */
+		{0xfaa3f4f3, 0xc23232b2, 0x513101c1, 0x31213121, 0x10211021},
+		/* format1, 66Mhz */
+		{0xfff4fff4, 0xf35353d3, 0x814102f1, 0x42314231, 0x11311131}
+	};
+
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u32 format;
+	unsigned int reg = 0x40 + 0x10 * ap->port_no;
+	int mode = adev->pio_mode - XFER_PIO_0;
+
+	pci_read_config_dword(pdev, reg + 4, &format);
+	format >>= 31;
+	format += sc1200_clock();
+	pci_write_config_dword(pdev, reg + 8 * adev->devno,
+				pio_timings[format][mode]);
+}
+
+/**
+ *	sc1200_set_dmamode		-	DMA timing setup
+ *	@ap: ATA interface
+ *	@adev: Device being configured
+ *
+ *	We cannot mix MWDMA and UDMA without reloading timings each switch
+ *	master to slave.
+ */
+
+static void sc1200_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	static const u32 udma_timing[3][3] = {
+		{ 0x00921250, 0x00911140, 0x00911030 },
+		{ 0x00932470, 0x00922260, 0x00922140 },
+		{ 0x009436A1, 0x00933481, 0x00923261 }
+	};
+
+	static const u32 mwdma_timing[3][3] = {
+		{ 0x00077771, 0x00012121, 0x00002020 },
+		{ 0x000BBBB2, 0x00024241, 0x00013131 },
+		{ 0x000FFFF3, 0x00035352, 0x00015151 }
+	};
+
+	int clock = sc1200_clock();
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	unsigned int reg = 0x40 + 0x10 * ap->port_no;
+	int mode = adev->dma_mode;
+	u32 format;
+
+	if (mode >= XFER_UDMA_0)
+		format = udma_timing[clock][mode - XFER_UDMA_0];
+	else
+		format = mwdma_timing[clock][mode - XFER_MW_DMA_0];
+
+	if (adev->devno == 0) {
+		u32 timings;
+
+		pci_read_config_dword(pdev, reg + 4, &timings);
+		timings &= 0x80000000UL;
+		timings |= format;
+		pci_write_config_dword(pdev, reg + 4, timings);
+	} else
+		pci_write_config_dword(pdev, reg + 12, format);
+}
