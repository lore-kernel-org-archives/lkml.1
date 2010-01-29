Return-Path: <linux-kernel-owner+w=401wt.eu-S1755663Ab0A2QJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab0A2QJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:09:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607Ab0A2QJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:09:07 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574Ab0A2QJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:09:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=W79pHrfm1rylQi+P5b9ZnfctBpvxqfqlSTfQ56isffLIjT9MLlWzGznz0Ov7JMdZph
         I+/p7eWunXHgSuw8+dDNmcBiypkgfCqcYF+5rZAUW7MLuPV8BJgl4kR8j5Yq7yVxkTrI
         uZUQXzxNWjiiKJR0dj6GQwA2L0dRXgTD+G+zI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:08:55 +0100
Message-Id: <20100129160855.21495.42952.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 54/68] pata_it821x: move code to be re-used by ide2libata to pata_it821x.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_it821x: move code to be re-used by ide2libata to pata_it821x.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_it821x.c |  319 ----------------------------------------------
 drivers/ata/pata_it821x.h |  318 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 319 insertions(+), 318 deletions(-)

Index: b/drivers/ata/pata_it821x.c
===================================================================
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -19,51 +19,6 @@
  * 	http://www.ite.com.tw/pc/IT8212F_V04.pdf
  *  Some other documents are NDA.
  *
- *  The ITE8212 isn't exactly a standard IDE controller. It has two
- *  modes. In pass through mode then it is an IDE controller. In its smart
- *  mode its actually quite a capable hardware raid controller disguised
- *  as an IDE controller. Smart mode only understands DMA read/write and
- *  identify, none of the fancier commands apply. The IT8211 is identical
- *  in other respects but lacks the raid mode.
- *
- *  Errata:
- *  o	Rev 0x10 also requires master/slave hold the same DMA timings and
- *	cannot do ATAPI MWDMA.
- *  o	The identify data for raid volumes lacks CHS info (technically ok)
- *	but also fails to set the LBA28 and other bits. We fix these in
- *	the IDE probe quirk code.
- *  o	If you write LBA48 sized I/O's (ie > 256 sector) in smart mode
- *	raid then the controller firmware dies
- *  o	Smart mode without RAID doesn't clear all the necessary identify
- *	bits to reduce the command set to the one used
- *
- *  This has a few impacts on the driver
- *  - In pass through mode we do all the work you would expect
- *  - In smart mode the clocking set up is done by the controller generally
- *    but we must watch the other limits and filter.
- *  - There are a few extra vendor commands that actually talk to the
- *    controller but only work PIO with no IRQ.
- *
- *  Vendor areas of the identify block in smart mode are used for the
- *  timing and policy set up. Each HDD in raid mode also has a serial
- *  block on the disk. The hardware extra commands are get/set chip status,
- *  rebuild, get rebuild status.
- *
- *  In Linux the driver supports pass through mode as if the device was
- *  just another IDE controller. If the smart mode is running then
- *  volumes are managed by the controller firmware and each IDE "disk"
- *  is a raid volume. Even more cute - the controller can do automated
- *  hotplug and rebuild.
- *
- *  The pass through controller itself is a little demented. It has a
- *  flaw that it has a single set of PIO/MWDMA timings per channel so
- *  non UDMA devices restrict each others performance. It also has a
- *  single clock source per channel so mixed UDMA100/133 performance
- *  isn't perfect and we have to pick a clock. Thankfully none of this
- *  matters in smart mode. ATAPI DMA is not currently supported.
- *
- *  It seems the smart mode is a win for RAID1/RAID10 but otherwise not.
- *
  *  TODO
  *	-	ATAPI and other speed filtering
  *	-	RAID configuration ioctls
@@ -78,260 +33,10 @@
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
 
-
 #define DRV_NAME "pata_it821x"
 #define DRV_VERSION "0.4.2"
 
-struct it821x_dev
-{
-	unsigned int smart:1,		/* Are we in smart raid mode */
-		timing10:1;		/* Rev 0x10 */
-	u8	clock_mode;		/* 0, ATA_50 or ATA_66 */
-	u8	want[2][2];		/* Mode/Pri log for master slave */
-	/* We need these for switching the clock when DMA goes on/off
-	   The high byte is the 66Mhz timing */
-	u16	pio[2];			/* Cached PIO values */
-	u16	mwdma[2];		/* Cached MWDMA values */
-	u16	udma[2];		/* Cached UDMA values (per drive) */
-	u16	last_device;		/* Master or slave loaded ? */
-};
-
-#define ATA_66		0
-#define ATA_50		1
-#define ATA_ANY		2
-
-#define UDMA_OFF	0
-#define MWDMA_OFF	0
-
-/*
- *	We allow users to force the card into non raid mode without
- *	flashing the alternative BIOS. This is also necessary right now
- *	for embedded platforms that cannot run a PC BIOS but are using this
- *	device.
- */
-
-static int it8212_noraid;
-
-/**
- *	it821x_program	-	program the PIO/MWDMA registers
- *	@ap: ATA port
- *	@adev: Device to program
- *	@timing: Timing value (66Mhz in top 8bits, 50 in the low 8)
- *
- *	Program the PIO/MWDMA timing for this channel according to the
- *	current clock. These share the same register so are managed by
- *	the DMA start/stop sequence as with the old driver.
- */
-
-static void it821x_program(struct ata_port *ap, struct ata_device *adev, u16 timing)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	struct it821x_dev *itdev = ap->private_data;
-	int channel = ap->port_no;
-	u8 conf;
-
-	/* Program PIO/MWDMA timing bits */
-	if (itdev->clock_mode == ATA_66)
-		conf = timing >> 8;
-	else
-		conf = timing & 0xFF;
-	pci_write_config_byte(pdev, 0x54 + 4 * channel, conf);
-}
-
-
-/**
- *	it821x_program_udma	-	program the UDMA registers
- *	@ap: ATA port
- *	@adev: ATA device to update
- *	@timing: Timing bits. Top 8 are for 66Mhz bottom for 50Mhz
- *
- *	Program the UDMA timing for this drive according to the
- *	current clock. Handles the dual clocks and also knows about
- *	the errata on the 0x10 revision. The UDMA errata is partly handled
- *	here and partly in start_dma.
- */
-
-static void it821x_program_udma(struct ata_port *ap, struct ata_device *adev, u16 timing)
-{
-	struct it821x_dev *itdev = ap->private_data;
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	int channel = ap->port_no;
-	int unit = adev->devno;
-	u8 conf;
-
-	/* Program UDMA timing bits */
-	if (itdev->clock_mode == ATA_66)
-		conf = timing >> 8;
-	else
-		conf = timing & 0xFF;
-	if (itdev->timing10 == 0)
-		pci_write_config_byte(pdev, 0x56 + 4 * channel + unit, conf);
-	else {
-		/* Early revision must be programmed for both together */
-		pci_write_config_byte(pdev, 0x56 + 4 * channel, conf);
-		pci_write_config_byte(pdev, 0x56 + 4 * channel + 1, conf);
-	}
-}
-
-/**
- *	it821x_clock_strategy
- *	@ap: ATA interface
- *	@adev: ATA device being updated
- *
- *	Select between the 50 and 66Mhz base clocks to get the best
- *	results for this interface.
- */
-
-static void it821x_clock_strategy(struct ata_port *ap, struct ata_device *adev)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	struct it821x_dev *itdev = ap->private_data;
-	u8 unit = adev->devno;
-	struct ata_device *pair = ata_dev_pair(adev);
-
-	int clock, altclock;
-	u8 v;
-	int sel = 0;
-
-	/* Look for the most wanted clocking */
-	if (itdev->want[0][0] > itdev->want[1][0]) {
-		clock = itdev->want[0][1];
-		altclock = itdev->want[1][1];
-	} else {
-		clock = itdev->want[1][1];
-		altclock = itdev->want[0][1];
-	}
-
-	/* Master doesn't care does the slave ? */
-	if (clock == ATA_ANY)
-		clock = altclock;
-
-	/* Nobody cares - keep the same clock */
-	if (clock == ATA_ANY)
-		return;
-	/* No change */
-	if (clock == itdev->clock_mode)
-		return;
-
-	/* Load this into the controller */
-	if (clock == ATA_66)
-		itdev->clock_mode = ATA_66;
-	else {
-		itdev->clock_mode = ATA_50;
-		sel = 1;
-	}
-	pci_read_config_byte(pdev, 0x50, &v);
-	v &= ~(1 << (1 + ap->port_no));
-	v |= sel << (1 + ap->port_no);
-	pci_write_config_byte(pdev, 0x50, v);
-
-	/*
-	 *	Reprogram the UDMA/PIO of the pair drive for the switch
-	 *	MWDMA will be dealt with by the dma switcher
-	 */
-	if (pair && itdev->udma[1-unit] != UDMA_OFF) {
-		it821x_program_udma(ap, pair, itdev->udma[1-unit]);
-		it821x_program(ap, pair, itdev->pio[1-unit]);
-	}
-	/*
-	 *	Reprogram the UDMA/PIO of our drive for the switch.
-	 *	MWDMA will be dealt with by the dma switcher
-	 */
-	if (itdev->udma[unit] != UDMA_OFF) {
-		it821x_program_udma(ap, adev, itdev->udma[unit]);
-		it821x_program(ap, adev, itdev->pio[unit]);
-	}
-}
-
-/**
- *	it821x_passthru_set_piomode	-	set PIO mode data
- *	@ap: ATA interface
- *	@adev: ATA device
- *
- *	Configure for PIO mode. This is complicated as the register is
- *	shared by PIO and MWDMA and for both channels.
- */
-
-static void it821x_passthru_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	/* Spec says 89 ref driver uses 88 */
-	static const u16 pio[]	= { 0xAA88, 0xA382, 0xA181, 0x3332, 0x3121 };
-	static const u8 pio_want[]    = { ATA_66, ATA_66, ATA_66, ATA_66, ATA_ANY };
-
-	struct it821x_dev *itdev = ap->private_data;
-	int unit = adev->devno;
-	int mode_wanted = adev->pio_mode - XFER_PIO_0;
-
-	/* We prefer 66Mhz clock for PIO 0-3, don't care for PIO4 */
-	itdev->want[unit][1] = pio_want[mode_wanted];
-	itdev->want[unit][0] = 1;	/* PIO is lowest priority */
-	itdev->pio[unit] = pio[mode_wanted];
-	it821x_clock_strategy(ap, adev);
-	it821x_program(ap, adev, itdev->pio[unit]);
-}
-
-/**
- *	it821x_passthru_set_dmamode	-	set initial DMA mode data
- *	@ap: ATA interface
- *	@adev: ATA device
- *
- *	Set up the DMA modes. The actions taken depend heavily on the mode
- *	to use. If UDMA is used as is hopefully the usual case then the
- *	timing register is private and we need only consider the clock. If
- *	we are using MWDMA then we have to manage the setting ourself as
- *	we switch devices and mode.
- */
-
-static void it821x_passthru_set_dmamode(struct ata_port *ap, struct ata_device *adev)
-{
-	static const u16 dma[]	= 	{ 0x8866, 0x3222, 0x3121 };
-	static const u8 mwdma_want[] =  { ATA_ANY, ATA_66, ATA_ANY };
-	static const u16 udma[]	= 	{ 0x4433, 0x4231, 0x3121, 0x2121, 0x1111, 0x2211, 0x1111 };
-	static const u8 udma_want[] =   { ATA_ANY, ATA_50, ATA_ANY, ATA_66, ATA_66, ATA_50, ATA_66 };
-
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	struct it821x_dev *itdev = ap->private_data;
-	int channel = ap->port_no;
-	int unit = adev->devno;
-	u8 conf;
-
-	if (adev->dma_mode >= XFER_UDMA_0) {
-		int mode_wanted = adev->dma_mode - XFER_UDMA_0;
-
-		itdev->want[unit][1] = udma_want[mode_wanted];
-		itdev->want[unit][0] = 3;	/* UDMA is high priority */
-		itdev->mwdma[unit] = MWDMA_OFF;
-		itdev->udma[unit] = udma[mode_wanted];
-		if (mode_wanted >= 5)
-			itdev->udma[unit] |= 0x8080;	/* UDMA 5/6 select on */
-
-		/* UDMA on. Again revision 0x10 must do the pair */
-		pci_read_config_byte(pdev, 0x50, &conf);
-		if (itdev->timing10)
-			conf &= channel ? 0x9F: 0xE7;
-		else
-			conf &= ~ (1 << (3 + 2 * channel + unit));
-		pci_write_config_byte(pdev, 0x50, conf);
-		it821x_clock_strategy(ap, adev);
-		it821x_program_udma(ap, adev, itdev->udma[unit]);
-	} else {
-		int mode_wanted = adev->dma_mode - XFER_MW_DMA_0;
-
-		itdev->want[unit][1] = mwdma_want[mode_wanted];
-		itdev->want[unit][0] = 2;	/* MWDMA is low priority */
-		itdev->mwdma[unit] = dma[mode_wanted];
-		itdev->udma[unit] = UDMA_OFF;
-
-		/* UDMA bits off - Revision 0x10 do them in pairs */
-		pci_read_config_byte(pdev, 0x50, &conf);
-		if (itdev->timing10)
-			conf |= channel ? 0x60: 0x18;
-		else
-			conf |= 1 << (3 + 2 * channel + unit);
-		pci_write_config_byte(pdev, 0x50, conf);
-		it821x_clock_strategy(ap, adev);
-	}
-}
+#include "pata_it821x.h"
 
 /**
  *	it821x_passthru_dma_start	-	DMA start callback
@@ -846,28 +551,6 @@ static struct ata_port_operations it821x
 	.port_start	= it821x_port_start,
 };
 
-static void it821x_disable_raid(struct pci_dev *pdev)
-{
-	/* Neither the RDC nor the IT8211 */
-	if (pdev->vendor != PCI_VENDOR_ID_ITE ||
-			pdev->device != PCI_DEVICE_ID_ITE_8212)
-			return;
-
-	/* Reset local CPU, and set BIOS not ready */
-	pci_write_config_byte(pdev, 0x5E, 0x01);
-
-	/* Set to bypass mode, and reset PCI bus */
-	pci_write_config_byte(pdev, 0x50, 0x00);
-	pci_write_config_word(pdev, PCI_COMMAND,
-			      PCI_COMMAND_PARITY | PCI_COMMAND_IO |
-			      PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER);
-	pci_write_config_word(pdev, 0x40, 0xA0F3);
-
-	pci_write_config_dword(pdev,0x4C, 0x02040204);
-	pci_write_config_byte(pdev, 0x42, 0x36);
-	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x20);
-}
-
 static int it821x_fixup(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
Index: b/drivers/ata/pata_it821x.h
===================================================================
--- /dev/null
+++ b/drivers/ata/pata_it821x.h
@@ -0,0 +1,318 @@
+/*
+ *  The ITE8212 isn't exactly a standard IDE controller. It has two
+ *  modes. In pass through mode then it is an IDE controller. In its smart
+ *  mode its actually quite a capable hardware raid controller disguised
+ *  as an IDE controller. Smart mode only understands DMA read/write and
+ *  identify, none of the fancier commands apply. The IT8211 is identical
+ *  in other respects but lacks the raid mode.
+ *
+ *  Errata:
+ *  o	Rev 0x10 also requires master/slave hold the same DMA timings and
+ *	cannot do ATAPI MWDMA.
+ *  o	The identify data for raid volumes lacks CHS info (technically ok)
+ *	but also fails to set the LBA28 and other bits. We fix these in
+ *	the IDE probe quirk code.
+ *  o	If you write LBA48 sized I/O's (ie > 256 sector) in smart mode
+ *	raid then the controller firmware dies
+ *  o	Smart mode without RAID doesn't clear all the necessary identify
+ *	bits to reduce the command set to the one used
+ *
+ *  This has a few impacts on the driver
+ *  - In pass through mode we do all the work you would expect
+ *  - In smart mode the clocking set up is done by the controller generally
+ *    but we must watch the other limits and filter.
+ *  - There are a few extra vendor commands that actually talk to the
+ *    controller but only work PIO with no IRQ.
+ *
+ *  Vendor areas of the identify block in smart mode are used for the
+ *  timing and policy set up. Each HDD in raid mode also has a serial
+ *  block on the disk. The hardware extra commands are get/set chip status,
+ *  rebuild, get rebuild status.
+ *
+ *  In Linux the driver supports pass through mode as if the device was
+ *  just another IDE controller. If the smart mode is running then
+ *  volumes are managed by the controller firmware and each IDE "disk"
+ *  is a raid volume. Even more cute - the controller can do automated
+ *  hotplug and rebuild.
+ *
+ *  The pass through controller itself is a little demented. It has a
+ *  flaw that it has a single set of PIO/MWDMA timings per channel so
+ *  non UDMA devices restrict each others performance. It also has a
+ *  single clock source per channel so mixed UDMA100/133 performance
+ *  isn't perfect and we have to pick a clock. Thankfully none of this
+ *  matters in smart mode. ATAPI DMA is not currently supported.
+ *
+ *  It seems the smart mode is a win for RAID1/RAID10 but otherwise not.
+ */
+
+struct it821x_dev {
+	unsigned int smart:1,		/* Are we in smart raid mode */
+		timing10:1;		/* Rev 0x10 */
+	u8	clock_mode;		/* 0, ATA_50 or ATA_66 */
+	u8	want[2][2];		/* Mode/Pri log for master slave */
+	/* We need these for switching the clock when DMA goes on/off
+	   The high byte is the 66Mhz timing */
+	u16	pio[2];			/* Cached PIO values */
+	u16	mwdma[2];		/* Cached MWDMA values */
+	u16	udma[2];		/* Cached UDMA values (per drive) */
+	u16	last_device;		/* Master or slave loaded ? */
+};
+
+#define ATA_66		0
+#define ATA_50		1
+#define ATA_ANY		2
+
+#define UDMA_OFF	0
+#define MWDMA_OFF	0
+
+/*
+ *	We allow users to force the card into non raid mode without
+ *	flashing the alternative BIOS. This is also necessary right now
+ *	for embedded platforms that cannot run a PC BIOS but are using this
+ *	device.
+ */
+
+static int it8212_noraid;
+
+/**
+ *	it821x_program	-	program the PIO/MWDMA registers
+ *	@ap: ATA port
+ *	@adev: Device to program
+ *	@timing: Timing value (66Mhz in top 8bits, 50 in the low 8)
+ *
+ *	Program the PIO/MWDMA timing for this channel according to the
+ *	current clock. These share the same register so are managed by
+ *	the DMA start/stop sequence as with the old driver.
+ */
+
+static void it821x_program(struct ata_port *ap, struct ata_device *adev, u16 timing)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	struct it821x_dev *itdev = ap->private_data;
+	int channel = ap->port_no;
+	u8 conf;
+
+	/* Program PIO/MWDMA timing bits */
+	if (itdev->clock_mode == ATA_66)
+		conf = timing >> 8;
+	else
+		conf = timing & 0xFF;
+	pci_write_config_byte(pdev, 0x54 + 4 * channel, conf);
+}
+
+
+/**
+ *	it821x_program_udma	-	program the UDMA registers
+ *	@ap: ATA port
+ *	@adev: ATA device to update
+ *	@timing: Timing bits. Top 8 are for 66Mhz bottom for 50Mhz
+ *
+ *	Program the UDMA timing for this drive according to the
+ *	current clock. Handles the dual clocks and also knows about
+ *	the errata on the 0x10 revision. The UDMA errata is partly handled
+ *	here and partly in start_dma.
+ */
+
+static void it821x_program_udma(struct ata_port *ap, struct ata_device *adev, u16 timing)
+{
+	struct it821x_dev *itdev = ap->private_data;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	int channel = ap->port_no;
+	int unit = adev->devno;
+	u8 conf;
+
+	/* Program UDMA timing bits */
+	if (itdev->clock_mode == ATA_66)
+		conf = timing >> 8;
+	else
+		conf = timing & 0xFF;
+	if (itdev->timing10 == 0)
+		pci_write_config_byte(pdev, 0x56 + 4 * channel + unit, conf);
+	else {
+		/* Early revision must be programmed for both together */
+		pci_write_config_byte(pdev, 0x56 + 4 * channel, conf);
+		pci_write_config_byte(pdev, 0x56 + 4 * channel + 1, conf);
+	}
+}
+
+/**
+ *	it821x_clock_strategy
+ *	@ap: ATA interface
+ *	@adev: ATA device being updated
+ *
+ *	Select between the 50 and 66Mhz base clocks to get the best
+ *	results for this interface.
+ */
+
+static void it821x_clock_strategy(struct ata_port *ap, struct ata_device *adev)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	struct it821x_dev *itdev = ap->private_data;
+	u8 unit = adev->devno;
+	struct ata_device *pair = ata_dev_pair(adev);
+
+	int clock, altclock;
+	u8 v;
+	int sel = 0;
+
+	/* Look for the most wanted clocking */
+	if (itdev->want[0][0] > itdev->want[1][0]) {
+		clock = itdev->want[0][1];
+		altclock = itdev->want[1][1];
+	} else {
+		clock = itdev->want[1][1];
+		altclock = itdev->want[0][1];
+	}
+
+	/* Master doesn't care does the slave ? */
+	if (clock == ATA_ANY)
+		clock = altclock;
+
+	/* Nobody cares - keep the same clock */
+	if (clock == ATA_ANY)
+		return;
+	/* No change */
+	if (clock == itdev->clock_mode)
+		return;
+
+	/* Load this into the controller */
+	if (clock == ATA_66)
+		itdev->clock_mode = ATA_66;
+	else {
+		itdev->clock_mode = ATA_50;
+		sel = 1;
+	}
+	pci_read_config_byte(pdev, 0x50, &v);
+	v &= ~(1 << (1 + ap->port_no));
+	v |= sel << (1 + ap->port_no);
+	pci_write_config_byte(pdev, 0x50, v);
+
+	/*
+	 *	Reprogram the UDMA/PIO of the pair drive for the switch
+	 *	MWDMA will be dealt with by the dma switcher
+	 */
+	if (pair && itdev->udma[1-unit] != UDMA_OFF) {
+		it821x_program_udma(ap, pair, itdev->udma[1-unit]);
+		it821x_program(ap, pair, itdev->pio[1-unit]);
+	}
+	/*
+	 *	Reprogram the UDMA/PIO of our drive for the switch.
+	 *	MWDMA will be dealt with by the dma switcher
+	 */
+	if (itdev->udma[unit] != UDMA_OFF) {
+		it821x_program_udma(ap, adev, itdev->udma[unit]);
+		it821x_program(ap, adev, itdev->pio[unit]);
+	}
+}
+
+/**
+ *	it821x_passthru_set_piomode	-	set PIO mode data
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *
+ *	Configure for PIO mode. This is complicated as the register is
+ *	shared by PIO and MWDMA and for both channels.
+ */
+
+static void it821x_passthru_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	/* Spec says 89 ref driver uses 88 */
+	static const u16 pio[]	= { 0xAA88, 0xA382, 0xA181, 0x3332, 0x3121 };
+	static const u8 pio_want[]    = { ATA_66, ATA_66, ATA_66, ATA_66, ATA_ANY };
+
+	struct it821x_dev *itdev = ap->private_data;
+	int unit = adev->devno;
+	int mode_wanted = adev->pio_mode - XFER_PIO_0;
+
+	/* We prefer 66Mhz clock for PIO 0-3, don't care for PIO4 */
+	itdev->want[unit][1] = pio_want[mode_wanted];
+	itdev->want[unit][0] = 1;	/* PIO is lowest priority */
+	itdev->pio[unit] = pio[mode_wanted];
+	it821x_clock_strategy(ap, adev);
+	it821x_program(ap, adev, itdev->pio[unit]);
+}
+
+/**
+ *	it821x_passthru_set_dmamode	-	set initial DMA mode data
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *
+ *	Set up the DMA modes. The actions taken depend heavily on the mode
+ *	to use. If UDMA is used as is hopefully the usual case then the
+ *	timing register is private and we need only consider the clock. If
+ *	we are using MWDMA then we have to manage the setting ourself as
+ *	we switch devices and mode.
+ */
+
+static void it821x_passthru_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	static const u16 dma[]	= 	{ 0x8866, 0x3222, 0x3121 };
+	static const u8 mwdma_want[] =  { ATA_ANY, ATA_66, ATA_ANY };
+	static const u16 udma[]	= 	{ 0x4433, 0x4231, 0x3121, 0x2121, 0x1111, 0x2211, 0x1111 };
+	static const u8 udma_want[] =   { ATA_ANY, ATA_50, ATA_ANY, ATA_66, ATA_66, ATA_50, ATA_66 };
+
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	struct it821x_dev *itdev = ap->private_data;
+	int channel = ap->port_no;
+	int unit = adev->devno;
+	u8 conf;
+
+	if (adev->dma_mode >= XFER_UDMA_0) {
+		int mode_wanted = adev->dma_mode - XFER_UDMA_0;
+
+		itdev->want[unit][1] = udma_want[mode_wanted];
+		itdev->want[unit][0] = 3;	/* UDMA is high priority */
+		itdev->mwdma[unit] = MWDMA_OFF;
+		itdev->udma[unit] = udma[mode_wanted];
+		if (mode_wanted >= 5)
+			itdev->udma[unit] |= 0x8080;	/* UDMA 5/6 select on */
+
+		/* UDMA on. Again revision 0x10 must do the pair */
+		pci_read_config_byte(pdev, 0x50, &conf);
+		if (itdev->timing10)
+			conf &= channel ? 0x9F : 0xE7;
+		else
+			conf &= ~(1 << (3 + 2 * channel + unit));
+		pci_write_config_byte(pdev, 0x50, conf);
+		it821x_clock_strategy(ap, adev);
+		it821x_program_udma(ap, adev, itdev->udma[unit]);
+	} else {
+		int mode_wanted = adev->dma_mode - XFER_MW_DMA_0;
+
+		itdev->want[unit][1] = mwdma_want[mode_wanted];
+		itdev->want[unit][0] = 2;	/* MWDMA is low priority */
+		itdev->mwdma[unit] = dma[mode_wanted];
+		itdev->udma[unit] = UDMA_OFF;
+
+		/* UDMA bits off - Revision 0x10 do them in pairs */
+		pci_read_config_byte(pdev, 0x50, &conf);
+		if (itdev->timing10)
+			conf |= channel ? 0x60 : 0x18;
+		else
+			conf |= 1 << (3 + 2 * channel + unit);
+		pci_write_config_byte(pdev, 0x50, conf);
+		it821x_clock_strategy(ap, adev);
+	}
+}
+
+static void it821x_disable_raid(struct pci_dev *pdev)
+{
+	/* Neither the RDC nor the IT8211 */
+	if (pdev->vendor != PCI_VENDOR_ID_ITE ||
+			pdev->device != PCI_DEVICE_ID_ITE_8212)
+			return;
+
+	/* Reset local CPU, and set BIOS not ready */
+	pci_write_config_byte(pdev, 0x5E, 0x01);
+
+	/* Set to bypass mode, and reset PCI bus */
+	pci_write_config_byte(pdev, 0x50, 0x00);
+	pci_write_config_word(pdev, PCI_COMMAND,
+			      PCI_COMMAND_PARITY | PCI_COMMAND_IO |
+			      PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER);
+	pci_write_config_word(pdev, 0x40, 0xA0F3);
+
+	pci_write_config_dword(pdev, 0x4C, 0x02040204);
+	pci_write_config_byte(pdev, 0x42, 0x36);
+	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x20);
+}
