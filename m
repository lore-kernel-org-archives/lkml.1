Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870Ab0A2QRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0A2QRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937Ab0A2QR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:17:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:23261 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab0A2QGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:06:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=jQKnuWJ+WGMNVZk+QafRxPRYn0QO6na3WumRxlxB+ObWIYeflQhDwpHuV6sqCqY9cR
         PT95CxgfKT8+yG3xzEk6+0/wiForLATd71LOE14lzBef5mxlSRudmWHvGBa6HpP0rdYq
         cIMBw9diaug719vp8eHKpLvught+XhMck/CGs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:06:16 +0100
Message-Id: <20100129160616.21495.19482.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 29/68] ata_piix: move code to be re-used by ide2libata to ata_piix.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ata_piix: move code to be re-used by ide2libata to ata_piix.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/ata_piix.c |  220 -----------------------------------------------
 drivers/ata/ata_piix.h |  226 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 226 insertions(+), 220 deletions(-)

Index: b/drivers/ata/ata_piix.c
===================================================================
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -629,178 +629,6 @@ static int piix_pata_prereset(struct ata
 	return ata_sff_prereset(link, deadline);
 }
 
-static DEFINE_SPINLOCK(piix_lock);
-
-static void piix_set_timings(struct ata_port *ap, struct ata_device *adev,
-			     u8 pio, bool use_mwdma)
-{
-	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
-	unsigned long flags;
-	unsigned int is_slave	= (adev->devno != 0);
-	unsigned int master_port= ap->port_no ? 0x42 : 0x40;
-	unsigned int slave_port	= 0x44;
-	u16 master_data;
-	u8 slave_data;
-	u8 udma_enable;
-	int control = 0;
-
-	/*
-	 *	See Intel Document 298600-004 for the timing programing rules
-	 *	for ICH controllers.
-	 */
-
-	static const	 /* ISP  RTC */
-	u8 timings[][2]	= { { 0, 0 },
-			    { 0, 0 },
-			    { 1, 0 },
-			    { 2, 1 },
-			    { 2, 3 }, };
-
-	if (pio >= 2 || use_mwdma)
-		control |= 1;	/* TIME1 enable */
-	if (ata_pio_need_iordy(adev) || use_mwdma)
-		control |= 2;	/* IE enable */
-	/* Intel specifies that the PPE functionality is for disk only */
-	if (adev->class == ATA_DEV_ATA)
-		control |= 4;	/* PPE enable */
-	/* If the drive MWDMA is faster than it can do PIO then
-	   we must force PIO into PIO0 */
-	if (use_mwdma && adev->pio_mode < (XFER_PIO_0 + pio))
-		/* Enable DMA timing only */
-		control |= 8;	/* PIO cycles in PIO0 */
-
-	spin_lock_irqsave(&piix_lock, flags);
-
-	/* PIO configuration clears DTE unconditionally.  It will be
-	 * programmed in set_dmamode which is guaranteed to be called
-	 * after set_piomode if any DMA mode is available.
-	 */
-	pci_read_config_word(dev, master_port, &master_data);
-	if (is_slave) {
-		/* clear TIME1|IE1|PPE1|DTE1 */
-		master_data &= 0xff0f;
-		/* Enable SITRE (separate slave timing register) */
-		master_data |= 0x4000;
-		/* enable PPE1, IE1 and TIME1 as needed */
-		master_data |= (control << 4);
-		pci_read_config_byte(dev, slave_port, &slave_data);
-		slave_data &= (ap->port_no ? 0x0f : 0xf0);
-		/* Load the timing nibble for this slave */
-		slave_data |= ((timings[pio][0] << 2) | timings[pio][1])
-						<< (ap->port_no ? 4 : 0);
-	} else {
-		/* clear ISP|RCT|TIME0|IE0|PPE0|DTE0 */
-		master_data &= 0xccf0;
-		/* Enable PPE, IE and TIME as appropriate */
-		master_data |= control;
-		/* load ISP and RCT */
-		master_data |=
-			(timings[pio][0] << 12) |
-			(timings[pio][1] << 8);
-	}
-	pci_write_config_word(dev, master_port, master_data);
-	if (is_slave)
-		pci_write_config_byte(dev, slave_port, slave_data);
-
-	/* Ensure the UDMA bit is off - it will be turned back on if
-	   UDMA is selected */
-
-	if (ap->udma_mask) {
-		pci_read_config_byte(dev, 0x48, &udma_enable);
-		udma_enable &= ~(1 << (2 * ap->port_no + adev->devno));
-		pci_write_config_byte(dev, 0x48, udma_enable);
-	}
-
-	spin_unlock_irqrestore(&piix_lock, flags);
-}
-
-/**
- *	piix_set_piomode - Initialize host controller PATA PIO timings
- *	@ap: Port whose timings we are configuring
- *	@adev: Drive in question
- *
- *	Set PIO mode for device, in host controller PCI config space.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	piix_set_timings(ap, adev, adev->pio_mode - XFER_PIO_0, 0);
-}
-
-/**
- *	do_pata_set_dmamode - Initialize host controller PATA PIO timings
- *	@ap: Port whose timings we are configuring
- *	@adev: Drive in question
- *	@isich: set if the chip is an ICH device
- *
- *	Set UDMA mode for device, in host controller PCI config space.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void do_pata_set_dmamode(struct ata_port *ap, struct ata_device *adev, int isich)
-{
-	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
-	unsigned long flags;
-	u8 speed		= adev->dma_mode;
-	int devid		= adev->devno + 2 * ap->port_no;
-	u8 udma_enable		= 0;
-
-	if (speed >= XFER_UDMA_0) {
-		unsigned int udma = speed - XFER_UDMA_0;
-		u16 udma_timing;
-		u16 ideconf;
-		int u_clock, u_speed;
-
-		spin_lock_irqsave(&piix_lock, flags);
-
-		pci_read_config_byte(dev, 0x48, &udma_enable);
-
-		/*
-		 * UDMA is handled by a combination of clock switching and
-		 * selection of dividers
-		 *
-		 * Handy rule: Odd modes are UDMATIMx 01, even are 02
-		 *	       except UDMA0 which is 00
-		 */
-		u_speed = min(2 - (udma & 1), udma);
-		if (udma == 5)
-			u_clock = 0x1000;	/* 100Mhz */
-		else if (udma > 2)
-			u_clock = 1;		/* 66Mhz */
-		else
-			u_clock = 0;		/* 33Mhz */
-
-		udma_enable |= (1 << devid);
-
-		/* Load the CT/RP selection */
-		pci_read_config_word(dev, 0x4A, &udma_timing);
-		udma_timing &= ~(3 << (4 * devid));
-		udma_timing |= u_speed << (4 * devid);
-		pci_write_config_word(dev, 0x4A, udma_timing);
-
-		if (isich) {
-			/* Select a 33/66/100Mhz clock */
-			pci_read_config_word(dev, 0x54, &ideconf);
-			ideconf &= ~(0x1001 << devid);
-			ideconf |= u_clock << devid;
-			/* For ICH or later we should set bit 10 for better
-			   performance (WR_PingPong_En) */
-			pci_write_config_word(dev, 0x54, ideconf);
-		}
-
-		pci_write_config_byte(dev, 0x48, udma_enable);
-
-		spin_unlock_irqrestore(&piix_lock, flags);
-	} else
-		/* MWDMA is driven by the PIO timings. */
-		piix_set_timings(ap, adev, ata_mwdma_to_pio(speed), 1);
-}
-
 /**
  *	piix_set_dmamode - Initialize host controller PATA DMA timings
  *	@ap: Port whose timings we are configuring
@@ -817,22 +645,6 @@ static void piix_set_dmamode(struct ata_
 	do_pata_set_dmamode(ap, adev, 0);
 }
 
-/**
- *	ich_set_dmamode - Initialize host controller PATA DMA timings
- *	@ap: Port whose timings we are configuring
- *	@adev: um
- *
- *	Set MW/UDMA mode for device, in host controller PCI config space.
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-static void ich_set_dmamode(struct ata_port *ap, struct ata_device *adev)
-{
-	do_pata_set_dmamode(ap, adev, 1);
-}
-
 /*
  * Serial ATA Index/Data Pair Superset Registers access
  *
@@ -1145,38 +957,6 @@ static int piix_disable_ahci(struct pci_
 	return rc;
 }
 
-/**
- *	piix_check_450nx_errata	-	Check for problem 450NX setup
- *	@ata_dev: the PCI device to check
- *
- *	Check for the present of 450NX errata #19 and errata #25. If
- *	they are found return an error code so we can turn off DMA
- */
-
-static int __devinit piix_check_450nx_errata(struct pci_dev *ata_dev)
-{
-	struct pci_dev *pdev = NULL;
-	u16 cfg;
-	int no_piix_dma = 0;
-
-	while ((pdev = pci_get_device(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82454NX, pdev)) != NULL) {
-		/* Look for 450NX PXB. Check for problem configurations
-		   A PCI quirk checks bit 6 already */
-		pci_read_config_word(pdev, 0x41, &cfg);
-		/* Only on the original revision: IDE DMA can hang */
-		if (pdev->revision == 0x00)
-			no_piix_dma = 1;
-		/* On all revisions below 5 PXB bus lock must be disabled for IDE */
-		else if (cfg & (1<<14) && pdev->revision < 5)
-			no_piix_dma = 2;
-	}
-	if (no_piix_dma)
-		dev_printk(KERN_WARNING, &ata_dev->dev, "450NX errata present, disabling IDE DMA.\n");
-	if (no_piix_dma == 2)
-		dev_printk(KERN_WARNING, &ata_dev->dev, "A BIOS update may resolve this.\n");
-	return no_piix_dma;
-}
-
 static void __devinit piix_init_pcs(struct ata_host *host,
 				    const struct piix_map_db *map_db)
 {
Index: b/drivers/ata/ata_piix.h
===================================================================
--- a/drivers/ata/ata_piix.h
+++ b/drivers/ata/ata_piix.h
@@ -43,3 +43,229 @@ static int ich_short_ata40(struct pci_de
 
 	return 0;
 }
+
+#ifdef __LINUX_LIBATA_H__
+static DEFINE_SPINLOCK(piix_lock);
+
+static void piix_set_timings(struct ata_port *ap, struct ata_device *adev,
+			     u8 pio, bool use_mwdma)
+{
+	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
+	unsigned long flags;
+	unsigned int is_slave	= (adev->devno != 0);
+	unsigned int master_port = ap->port_no ? 0x42 : 0x40;
+	unsigned int slave_port	 = 0x44;
+	u16 master_data;
+	u8 slave_data;
+	u8 udma_enable;
+	int control = 0;
+
+	/*
+	 *	See Intel Document 298600-004 for the timing programing rules
+	 *	for ICH controllers.
+	 */
+
+	static const	 /* ISP  RTC */
+	u8 timings[][2]	= { { 0, 0 },
+			    { 0, 0 },
+			    { 1, 0 },
+			    { 2, 1 },
+			    { 2, 3 }, };
+
+	if (pio >= 2 || use_mwdma)
+		control |= 1;	/* TIME1 enable */
+	if (ata_pio_need_iordy(adev) || use_mwdma)
+		control |= 2;	/* IE enable */
+	/* Intel specifies that the PPE functionality is for disk only */
+	if (adev->class == ATA_DEV_ATA)
+		control |= 4;	/* PPE enable */
+	/* If the drive MWDMA is faster than it can do PIO then
+	   we must force PIO into PIO0 */
+	if (use_mwdma && adev->pio_mode < (XFER_PIO_0 + pio))
+		/* Enable DMA timing only */
+		control |= 8;	/* PIO cycles in PIO0 */
+
+	spin_lock_irqsave(&piix_lock, flags);
+
+	/* PIO configuration clears DTE unconditionally.  It will be
+	 * programmed in set_dmamode which is guaranteed to be called
+	 * after set_piomode if any DMA mode is available.
+	 */
+	pci_read_config_word(dev, master_port, &master_data);
+	if (is_slave) {
+		/* clear TIME1|IE1|PPE1|DTE1 */
+		master_data &= 0xff0f;
+		/* Enable SITRE (separate slave timing register) */
+		master_data |= 0x4000;
+		/* enable PPE1, IE1 and TIME1 as needed */
+		master_data |= (control << 4);
+		pci_read_config_byte(dev, slave_port, &slave_data);
+		slave_data &= (ap->port_no ? 0x0f : 0xf0);
+		/* Load the timing nibble for this slave */
+		slave_data |= ((timings[pio][0] << 2) | timings[pio][1])
+						<< (ap->port_no ? 4 : 0);
+	} else {
+		/* clear ISP|RCT|TIME0|IE0|PPE0|DTE0 */
+		master_data &= 0xccf0;
+		/* Enable PPE, IE and TIME as appropriate */
+		master_data |= control;
+		/* load ISP and RCT */
+		master_data |=
+			(timings[pio][0] << 12) |
+			(timings[pio][1] << 8);
+	}
+	pci_write_config_word(dev, master_port, master_data);
+	if (is_slave)
+		pci_write_config_byte(dev, slave_port, slave_data);
+
+	/* Ensure the UDMA bit is off - it will be turned back on if
+	   UDMA is selected */
+
+	if (ap->udma_mask) {
+		pci_read_config_byte(dev, 0x48, &udma_enable);
+		udma_enable &= ~(1 << (2 * ap->port_no + adev->devno));
+		pci_write_config_byte(dev, 0x48, udma_enable);
+	}
+
+	spin_unlock_irqrestore(&piix_lock, flags);
+}
+
+/**
+ *	piix_set_piomode - Initialize host controller PATA PIO timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: Drive in question
+ *
+ *	Set PIO mode for device, in host controller PCI config space.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	piix_set_timings(ap, adev, adev->pio_mode - XFER_PIO_0, 0);
+}
+
+/**
+ *	do_pata_set_dmamode - Initialize host controller PATA PIO timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: Drive in question
+ *	@isich: set if the chip is an ICH device
+ *
+ *	Set UDMA mode for device, in host controller PCI config space.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void do_pata_set_dmamode(struct ata_port *ap, struct ata_device *adev,
+				int isich)
+{
+	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
+	unsigned long flags;
+	u8 speed		= adev->dma_mode;
+	int devid		= adev->devno + 2 * ap->port_no;
+	u8 udma_enable		= 0;
+
+	if (speed >= XFER_UDMA_0) {
+		unsigned int udma = speed - XFER_UDMA_0;
+		u16 udma_timing;
+		u16 ideconf;
+		int u_clock, u_speed;
+
+		spin_lock_irqsave(&piix_lock, flags);
+
+		pci_read_config_byte(dev, 0x48, &udma_enable);
+
+		/*
+		 * UDMA is handled by a combination of clock switching and
+		 * selection of dividers
+		 *
+		 * Handy rule: Odd modes are UDMATIMx 01, even are 02
+		 *	       except UDMA0 which is 00
+		 */
+		u_speed = min(2 - (udma & 1), udma);
+		if (udma == 5)
+			u_clock = 0x1000;	/* 100Mhz */
+		else if (udma > 2)
+			u_clock = 1;		/* 66Mhz */
+		else
+			u_clock = 0;		/* 33Mhz */
+
+		udma_enable |= (1 << devid);
+
+		/* Load the CT/RP selection */
+		pci_read_config_word(dev, 0x4A, &udma_timing);
+		udma_timing &= ~(3 << (4 * devid));
+		udma_timing |= u_speed << (4 * devid);
+		pci_write_config_word(dev, 0x4A, udma_timing);
+
+		if (isich) {
+			/* Select a 33/66/100Mhz clock */
+			pci_read_config_word(dev, 0x54, &ideconf);
+			ideconf &= ~(0x1001 << devid);
+			ideconf |= u_clock << devid;
+			/* For ICH or later we should set bit 10 for better
+			   performance (WR_PingPong_En) */
+			pci_write_config_word(dev, 0x54, ideconf);
+		}
+
+		pci_write_config_byte(dev, 0x48, udma_enable);
+
+		spin_unlock_irqrestore(&piix_lock, flags);
+	} else
+		/* MWDMA is driven by the PIO timings. */
+		piix_set_timings(ap, adev, ata_mwdma_to_pio(speed), 1);
+}
+
+/**
+ *	ich_set_dmamode - Initialize host controller PATA DMA timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: um
+ *
+ *	Set MW/UDMA mode for device, in host controller PCI config space.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void ich_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	do_pata_set_dmamode(ap, adev, 1);
+}
+
+/**
+ *	piix_check_450nx_errata	-	Check for problem 450NX setup
+ *	@ata_dev: the PCI device to check
+ *
+ *	Check for the present of 450NX errata #19 and errata #25. If
+ *	they are found return an error code so we can turn off DMA
+ */
+
+static int __devinit piix_check_450nx_errata(struct pci_dev *ata_dev)
+{
+	struct pci_dev *pdev = NULL;
+	u16 cfg;
+	int no_piix_dma = 0;
+
+	while ((pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
+				PCI_DEVICE_ID_INTEL_82454NX, pdev)) != NULL) {
+		/* Look for 450NX PXB. Check for problem configurations
+		   A PCI quirk checks bit 6 already */
+		pci_read_config_word(pdev, 0x41, &cfg);
+		/* Only on the original revision: IDE DMA can hang */
+		if (pdev->revision == 0x00)
+			no_piix_dma = 1;
+		/* On all revs below 5 PXB bus lock must be disabled for IDE */
+		else if (cfg & (1<<14) && pdev->revision < 5)
+			no_piix_dma = 2;
+	}
+	if (no_piix_dma)
+		dev_printk(KERN_WARNING, &ata_dev->dev,
+			   "450NX errata present, disabling IDE DMA.\n");
+	if (no_piix_dma == 2)
+		dev_printk(KERN_WARNING, &ata_dev->dev,
+			   "A BIOS update may resolve this.\n");
+	return no_piix_dma;
+}
+#endif
