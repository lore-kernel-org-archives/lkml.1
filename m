Return-Path: <linux-kernel-owner+w=401wt.eu-S934863AbZKYRNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934863AbZKYRNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934831AbZKYRN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:13:26 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52976 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934827AbZKYRNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:13:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=bWsGJ/KK2al7VonzQ9dg7sLz23+CQeCnXTc4ox0Z2ESfrZ0NvBGocaH70S9lkwwOHz
         PFYbSgvOZ+Vdln9b6xR0q1VlJW88ZJRBZVGePnTMnuOpDKWQ7T9hoHx1HHKHKDo1O5R0
         gyvCif5ggm12mxNOZV5R2M3amaN8gXmAz3mVM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:12:40 +0100
Message-Id: <20091125171240.5446.31841.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 85/86] libata: add ->init_host method
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] libata: add ->init_host method

Add ->init_host method for re-initialization of the controller
in ata_pci_device_resume().

Then teach ata_pci_sff_init_one() and host drivers about it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/libata-core.c   |   14 ++++++++++---
 drivers/ata/libata-sff.c    |   10 ++++++---
 drivers/ata/pata_ali.c      |   29 ++++++++-------------------
 drivers/ata/pata_amd.c      |   45 +++++++++++++++++--------------------------
 drivers/ata/pata_artop.c    |   30 ++++++++--------------------
 drivers/ata/pata_cmd640.c   |   27 +++++++------------------
 drivers/ata/pata_cmd64x.c   |   29 +++++++--------------------
 drivers/ata/pata_cs5530.c   |   31 ++++++-----------------------
 drivers/ata/pata_hpt366.c   |   30 +++++++++-------------------
 drivers/ata/pata_hpt3x3.c   |   32 ++++++++++--------------------
 drivers/ata/pata_it821x.c   |   31 +++++++++++------------------
 drivers/ata/pata_ninja32.c  |   30 ++++++++++------------------
 drivers/ata/pata_ns87415.c  |   30 ++++++++--------------------
 drivers/ata/pata_pdc2027x.c |   46 ++++++++++++++------------------------------
 drivers/ata/pata_sl82c105.c |   29 +++++++--------------------
 drivers/ata/sata_sil.c      |   33 ++++++++-----------------------
 include/linux/libata.h      |   14 ++++++++++---
 17 files changed, 173 insertions(+), 317 deletions(-)

Index: b/drivers/ata/libata-core.c
===================================================================
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6426,9 +6426,17 @@ int ata_pci_device_resume(struct pci_dev
 	int rc;
 
 	rc = ata_pci_device_do_resume(pdev);
-	if (rc == 0)
-		ata_host_resume(host);
-	return rc;
+	if (rc)
+		return rc;
+
+	if (host->init_host) {
+		rc = host->init_host(&pdev->dev);
+		if (rc)
+			return rc;
+	}
+
+	ata_host_resume(host);
+	return 0;
 }
 #endif /* CONFIG_PM */
 
Index: b/drivers/ata/libata-sff.c
===================================================================
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -3003,11 +3003,12 @@ out:
 EXPORT_SYMBOL_GPL(ata_pci_sff_activate_host);
 
 /**
- *	ata_pci_sff_init_one - Initialize/register PCI IDE host controller
+ *	__ata_pci_sff_init_one - Initialize/register PCI IDE host controller
  *	@pdev: Controller to be initialized
  *	@ppi: array of port_info, must be enough for two ports
  *	@sht: scsi_host_template to use when registering the host
  *	@host_priv: host private_data
+ *	@init_host: host initialization method (optional)
  *
  *	This is a helper function which can be called from a driver's
  *	xxx_init_one() probe function if the hardware uses traditional
@@ -3027,9 +3028,10 @@ EXPORT_SYMBOL_GPL(ata_pci_sff_activate_h
  *	RETURNS:
  *	Zero on success, negative on errno-based value on error.
  */
-int ata_pci_sff_init_one(struct pci_dev *pdev,
+int __ata_pci_sff_init_one(struct pci_dev *pdev,
 			 const struct ata_port_info * const *ppi,
-			 struct scsi_host_template *sht, void *host_priv)
+			 struct scsi_host_template *sht, void *host_priv,
+			 int (*init_host)(struct device *dev))
 {
 	struct device *dev = &pdev->dev;
 	const struct ata_port_info *pi = NULL;
@@ -3063,7 +3065,9 @@ int ata_pci_sff_init_one(struct pci_dev
 	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
 	if (rc)
 		goto out;
+
 	host->private_data = host_priv;
+	host->init_host = init_host;
 
 	pci_set_master(pdev);
 	rc = ata_pci_sff_activate_host(host, ata_sff_interrupt, sht);
Index: b/drivers/ata/pata_ali.c
===================================================================
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -424,14 +424,15 @@ static struct ata_port_operations ali_c5
 
 /**
  *	ali_init_chipset	-	chip setup function
- *	@pdev: PCI device of ATA controller
+ *	@dev: device of ATA controller
  *
  *	Perform the setup on the device that must be done both at boot
  *	and at resume time.
  */
 
-static void ali_init_chipset(struct pci_dev *pdev)
+static int ali_init_chipset(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	u8 tmp;
 	struct pci_dev *north;
 
@@ -478,7 +479,9 @@ static void ali_init_chipset(struct pci_
 	}
 	pci_dev_put(north);
 	ata_pci_bmdma_clear_simplex(pdev);
+	return 0;
 }
+
 /**
  *	ali_init_one		-	discovery callback
  *	@pdev: PCI device ID
@@ -574,7 +577,7 @@ static int ali_init_one(struct pci_dev *
 	} else
         	ppi[0] = &info_c5;
 
-	ali_init_chipset(pdev);
+	ali_init_chipset(&pdev->dev);
 
 	if (ali_isa_bridge && pdev->revision >= 0x20 && pdev->revision < 0xC2) {
 		/* Are we paired with a UDMA capable chip */
@@ -583,23 +586,9 @@ static int ali_init_one(struct pci_dev *
 	        	ppi[0] = &info_20_udma;
 	}
 
-	return ata_pci_sff_init_one(pdev, ppi, &ali_sht, NULL);
-}
-
-#ifdef CONFIG_PM
-static int ali_reinit_one(struct pci_dev *pdev)
-{
-	struct ata_host *host = dev_get_drvdata(&pdev->dev);
-	int rc;
-
-	rc = ata_pci_device_do_resume(pdev);
-	if (rc)
-		return rc;
-	ali_init_chipset(pdev);
-	ata_host_resume(host);
-	return 0;
+	return __ata_pci_sff_init_one(pdev, ppi, &ali_sht, NULL,
+				      ali_init_chipset);
 }
-#endif
 
 static const struct pci_device_id ali[] = {
 	{ PCI_VDEVICE(AL, PCI_DEVICE_ID_AL_M5228), },
@@ -615,7 +604,7 @@ static struct pci_driver ali_pci_driver
 	.remove		= ata_pci_remove_one,
 #ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
-	.resume		= ali_reinit_one,
+	.resume		= ata_pci_device_resume,
 #endif
 };
 
Index: b/drivers/ata/pata_amd.c
===================================================================
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -455,6 +455,20 @@ static void amd_clear_fifo(struct pci_de
 	pci_write_config_byte(pdev, 0x41, fifo);
 }
 
+static int amd_fixup(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (pdev->vendor == PCI_VENDOR_ID_AMD) {
+		amd_clear_fifo(pdev);
+		if (pdev->device == PCI_DEVICE_ID_AMD_VIPER_7409 ||
+		    pdev->device == PCI_DEVICE_ID_AMD_COBRA_7401)
+			ata_pci_bmdma_clear_simplex(pdev);
+	}
+
+	return 0;
+}
+
 static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info[10] = {
@@ -559,10 +573,8 @@ static int amd_init_one(struct pci_dev *
 	 */
 	ppi[0] = &info[type];
 
-	if (type < 3)
-		ata_pci_bmdma_clear_simplex(pdev);
-	if (pdev->vendor == PCI_VENDOR_ID_AMD)
-		amd_clear_fifo(pdev);
+	amd_fixup(&pdev->dev);
+
 	/* Cable detection on Nvidia chips doesn't work too well,
 	 * cache BIOS programmed UDMA mode.
 	 */
@@ -574,30 +586,9 @@ static int amd_init_one(struct pci_dev *
 	}
 
 	/* And fire it up */
-	return ata_pci_sff_init_one(pdev, ppi, &amd_sht, hpriv);
+	return __ata_pci_sff_init_one(pdev, ppi, &amd_sht, hpriv, amd_fixup);
 }
 
-#ifdef CONFIG_PM
-static int amd_reinit_one(struct pci_dev *pdev)
-{
-	struct ata_host *host = dev_get_drvdata(&pdev->dev);
-	int rc;
-
-	rc = ata_pci_device_do_resume(pdev);
-	if (rc)
-		return rc;
-
-	if (pdev->vendor == PCI_VENDOR_ID_AMD) {
-		amd_clear_fifo(pdev);
-		if (pdev->device == PCI_DEVICE_ID_AMD_VIPER_7409 ||
-		    pdev->device == PCI_DEVICE_ID_AMD_COBRA_7401)
-			ata_pci_bmdma_clear_simplex(pdev);
-	}
-	ata_host_resume(host);
-	return 0;
-}
-#endif
-
 static const struct pci_device_id amd[] = {
 	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_COBRA_7401),		0 },
 	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_VIPER_7409),		1 },
@@ -630,7 +621,7 @@ static struct pci_driver amd_pci_driver
 	.remove		= ata_pci_remove_one,
 #ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
-	.resume		= amd_reinit_one,
+	.resume		= ata_pci_device_resume,
 #endif
 };
 
Index: b/drivers/ata/pata_artop.c
===================================================================
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -302,8 +302,10 @@ static struct ata_port_operations atp86x
 	.prereset		= atp8xx_prereset,
 };
 
-static void atp8xx_fixup(struct pci_dev *pdev)
+static int atp8xx_fixup(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
+
 	if (pdev->device == 0x0005)
 		/* BIOS may have left us in UDMA, clear it before probe */
 		pci_write_config_byte(pdev, 0x54, 0);
@@ -328,6 +330,8 @@ static void atp8xx_fixup(struct pci_dev
 		pci_read_config_byte(pdev, 0x4a, &reg);
 		pci_write_config_byte(pdev, 0x4a, (reg & ~0x01) | 0x80);
 	}
+
+	return 0;
 }
 
 /**
@@ -400,28 +404,12 @@ static int artop_init_one (struct pci_de
 
 	BUG_ON(ppi[0] == NULL);
 
-	atp8xx_fixup(pdev);
+	atp8xx_fixup(&pdev->dev);
 
-	return ata_pci_sff_init_one(pdev, ppi, &artop_sht, NULL);
+	return __ata_pci_sff_init_one(pdev, ppi, &artop_sht, NULL,
+				      atp8xx_fixup);
 }
 
-#ifdef CONFIG_PM
-static int atp8xx_reinit_one(struct pci_dev *pdev)
-{
-	struct ata_host *host = dev_get_drvdata(&pdev->dev);
-	int rc;
-
-	rc = ata_pci_device_do_resume(pdev);
-	if (rc)
-		return rc;
-
-	atp8xx_fixup(pdev);
-
-	ata_host_resume(host);
-	return 0;
-}
-#endif
-
 static const struct pci_device_id artop_pci_tbl[] = {
 	{ PCI_VDEVICE(ARTOP, 0x0005), 0 },
 	{ PCI_VDEVICE(ARTOP, 0x0006), 1 },
@@ -439,7 +427,7 @@ static struct pci_driver artop_pci_drive
 	.remove			= ata_pci_remove_one,
 #ifdef CONFIG_PM
 	.suspend		= ata_pci_device_suspend,
-	.resume			= atp8xx_reinit_one,
+	.resume			= ata_pci_device_resume,
 #endif
 };
 
Index: b/drivers/ata/pata_cmd640.c
===================================================================
--- a/drivers/ata/pata_cmd640.c
+++ b/drivers/ata/pata_cmd640.c
@@ -178,8 +178,9 @@ static struct ata_port_operations cmd640
 	.port_start	= cmd640_port_start,
 };
 
-static void cmd640_hardware_init(struct pci_dev *pdev)
+static int cmd640_hardware_init(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	u8 r;
 	u8 ctrl;
 
@@ -205,6 +206,8 @@ static void cmd640_hardware_init(struct
 	pci_read_config_byte(pdev, ARTIM23, &ctrl);
 	ctrl |= 0x0C;
 	pci_write_config_byte(pdev, ARTIM23, ctrl);
+
+	return 0;
 }
 
 static int cmd640_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
@@ -221,25 +224,11 @@ static int cmd640_init_one(struct pci_de
 	if (rc)
 		return rc;
 
-	cmd640_hardware_init(pdev);
-
-	return ata_pci_sff_init_one(pdev, ppi, &cmd640_sht, NULL);
-}
-
-#ifdef CONFIG_PM
-static int cmd640_reinit_one(struct pci_dev *pdev)
-{
-	struct ata_host *host = dev_get_drvdata(&pdev->dev);
-	int rc;
+	cmd640_hardware_init(&pdev->dev);
 
-	rc = ata_pci_device_do_resume(pdev);
-	if (rc)
-		return rc;
-	cmd640_hardware_init(pdev);
-	ata_host_resume(host);
-	return 0;
+	return __ata_pci_sff_init_one(pdev, ppi, &cmd640_sht, NULL,
+				      cmd640_hardware_init);
 }
-#endif
 
 static const struct pci_device_id cmd640[] = {
 	{ PCI_VDEVICE(CMD, 0x640), 0 },
@@ -253,7 +242,7 @@ static struct pci_driver cmd640_pci_driv
 	.remove		= ata_pci_remove_one,
 #ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
-	.resume		= cmd640_reinit_one,
+	.resume		= ata_pci_device_resume,
 #endif
 };
 
Index: b/drivers/ata/pata_cmd64x.c
===================================================================
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -328,8 +328,9 @@ static struct ata_port_operations cmd648
 	.cable_detect	= cmd648_cable_detect,
 };
 
-static void cmd64x_fixup(struct pci_dev *pdev)
+static int cmd64x_fixup(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	u8 mrdmode;
 
 	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 64);
@@ -342,6 +343,8 @@ static void cmd64x_fixup(struct pci_dev
 #ifdef CONFIG_PPC
 	pci_write_config_byte(pdev, UDIDETCR0, 0xF0);
 #endif
+
+	return 0;
 }
 
 static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
@@ -411,27 +414,11 @@ static int cmd64x_init_one(struct pci_de
 			ppi[0] = &cmd_info[3];
 	}
 
-	cmd64x_fixup(pdev);
-
-	return ata_pci_sff_init_one(pdev, ppi, &cmd64x_sht, NULL);
-}
-
-#ifdef CONFIG_PM
-static int cmd64x_reinit_one(struct pci_dev *pdev)
-{
-	struct ata_host *host = dev_get_drvdata(&pdev->dev);
-	int rc;
-
-	rc = ata_pci_device_do_resume(pdev);
-	if (rc)
-		return rc;
+	cmd64x_fixup(&pdev->dev);
 
-	cmd64x_fixup(pdev);
-
-	ata_host_resume(host);
-	return 0;
+	return __ata_pci_sff_init_one(pdev, ppi, &cmd64x_sht, NULL,
+				      cmd64x_fixup);
 }
-#endif
 
 static const struct pci_device_id cmd64x[] = {
 	{ PCI_VDEVICE(CMD, PCI_DEVICE_ID_CMD_643), 0 },
@@ -449,7 +436,7 @@ static struct pci_driver cmd64x_pci_driv
 	.remove		= ata_pci_remove_one,
 #ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
-	.resume		= cmd64x_reinit_one,
+	.resume		= ata_pci_device_resume,
 #endif
 };
 
Index: b/drivers/ata/pata_cs5530.c
===================================================================
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -198,12 +198,13 @@ static int cs5530_is_palmax(void)
 
 /**
  *	cs5530_init_chip	-	Chipset init
+ *	@gendev: device
  *
  *	Perform the chip initialisation work that is shared between both
  *	setup and resume paths
  */
 
-static int cs5530_init_chip(void)
+static int cs5530_init_chip(struct device *gendev)
 {
 	struct pci_dev *master_0 = NULL, *cs5530_0 = NULL, *dev = NULL;
 
@@ -281,7 +282,7 @@ fail_put:
 		pci_dev_put(master_0);
 	if (cs5530_0)
 		pci_dev_put(cs5530_0);
-	return -ENODEV;
+	return -EIO;
 }
 
 /**
@@ -317,35 +318,17 @@ static int cs5530_init_one(struct pci_de
 		return rc;
 
 	/* Chip initialisation */
-	if (cs5530_init_chip())
+	if (cs5530_init_chip(NULL))
 		return -ENODEV;
 
 	if (cs5530_is_palmax())
 		ppi[1] = &info_palmax_secondary;
 
 	/* Now kick off ATA set up */
-	return ata_pci_sff_init_one(pdev, ppi, &cs5530_sht, NULL);
+	return __ata_pci_sff_init_one(pdev, ppi, &cs5530_sht, NULL,
+				      cs5530_init_chip);
 }
 
-#ifdef CONFIG_PM
-static int cs5530_reinit_one(struct pci_dev *pdev)
-{
-	struct ata_host *host = dev_get_drvdata(&pdev->dev);
-	int rc;
-
-	rc = ata_pci_device_do_resume(pdev);
-	if (rc)
-		return rc;
-
-	/* If we fail on resume we are doomed */
-	if (cs5530_init_chip())
-		return -EIO;
-
-	ata_host_resume(host);
-	return 0;
-}
-#endif /* CONFIG_PM */
-
 static const struct pci_device_id cs5530[] = {
 	{ PCI_VDEVICE(CYRIX, PCI_DEVICE_ID_CYRIX_5530_IDE), },
 
@@ -359,7 +342,7 @@ static struct pci_driver cs5530_pci_driv
 	.remove		= ata_pci_remove_one,
 #ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
-	.resume		= cs5530_reinit_one,
+	.resume		= ata_pci_device_resume,
 #endif
 };
 
Index: b/drivers/ata/pata_hpt366.c
===================================================================
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -292,15 +292,17 @@ static struct ata_port_operations hpt366
 
 /**
  *	hpt36x_init_chipset	-	common chip setup
- *	@dev: PCI device
+ *	@gendev: device
  *
  *	Perform the chip setup work that must be done at both init and
  *	resume time
  */
 
-static void hpt36x_init_chipset(struct pci_dev *dev)
+static int hpt36x_init_chipset(struct device *gendev)
 {
+	struct pci_dev *dev = to_pci_dev(gendev);
 	u8 drive_fast;
+
 	pci_write_config_byte(dev, PCI_CACHE_LINE_SIZE, (L1_CACHE_BYTES / 4));
 	pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x78);
 	pci_write_config_byte(dev, PCI_MIN_GNT, 0x08);
@@ -309,6 +311,8 @@ static void hpt36x_init_chipset(struct p
 	pci_read_config_byte(dev, 0x51, &drive_fast);
 	if (drive_fast & 0x80)
 		pci_write_config_byte(dev, 0x51, drive_fast & ~0x80);
+
+	return 0;
 }
 
 /**
@@ -360,7 +364,7 @@ static int hpt36x_init_one(struct pci_de
 	if (class_rev > 2)
 			return -ENODEV;
 
-	hpt36x_init_chipset(dev);
+	hpt36x_init_chipset(&dev->dev);
 
 	pci_read_config_dword(dev, 0x40,  &reg1);
 
@@ -378,23 +382,9 @@ static int hpt36x_init_one(struct pci_de
 			break;
 	}
 	/* Now kick off ATA set up */
-	return ata_pci_sff_init_one(dev, ppi, &hpt36x_sht, hpriv);
-}
-
-#ifdef CONFIG_PM
-static int hpt36x_reinit_one(struct pci_dev *dev)
-{
-	struct ata_host *host = dev_get_drvdata(&dev->dev);
-	int rc;
-
-	rc = ata_pci_device_do_resume(dev);
-	if (rc)
-		return rc;
-	hpt36x_init_chipset(dev);
-	ata_host_resume(host);
-	return 0;
+	return __ata_pci_sff_init_one(dev, ppi, &hpt36x_sht, hpriv,
+				      hpt36x_init_chipset);
 }
-#endif
 
 static const struct pci_device_id hpt36x[] = {
 	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT366), },
@@ -408,7 +398,7 @@ static struct pci_driver hpt36x_pci_driv
 	.remove		= ata_pci_remove_one,
 #ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
-	.resume		= hpt36x_reinit_one,
+	.resume		= ata_pci_device_resume,
 #endif
 };
 
Index: b/drivers/ata/pata_hpt3x3.c
===================================================================
--- a/drivers/ata/pata_hpt3x3.c
+++ b/drivers/ata/pata_hpt3x3.c
@@ -156,14 +156,16 @@ static struct ata_port_operations hpt3x3
 
 /**
  *	hpt3x3_init_chipset	-	chip setup
- *	@dev: PCI device
+ *	@gendev: device
  *
  *	Perform the setup required at boot and on resume.
  */
 
-static void hpt3x3_init_chipset(struct pci_dev *dev)
+static int hpt3x3_init_chipset(struct device *gendev)
 {
+	struct pci_dev *dev = to_pci_dev(gendev);
 	u16 cmd;
+
 	/* Initialize the board */
 	pci_write_config_word(dev, 0x80, 0x00);
 	/* Check if it is a 343 or a 363. 363 has COMMAND_MEMORY set */
@@ -172,6 +174,8 @@ static void hpt3x3_init_chipset(struct p
 		pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0xF0);
 	else
 		pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x20);
+
+	return 0;
 }
 
 /**
@@ -204,7 +208,7 @@ static int hpt3x3_init_one(struct pci_de
 	int i, rc;
 	void __iomem *base;
 
-	hpt3x3_init_chipset(pdev);
+	hpt3x3_init_chipset(&pdev->dev);
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
@@ -212,6 +216,9 @@ static int hpt3x3_init_one(struct pci_de
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, 2);
 	if (!host)
 		return -ENOMEM;
+
+	host->init_host = hpt3x3_init_chipset;
+
 	/* acquire resources and fill host */
 	rc = pcim_enable_device(pdev);
 	if (rc)
@@ -252,23 +259,6 @@ static int hpt3x3_init_one(struct pci_de
 				 IRQF_SHARED, &hpt3x3_sht);
 }
 
-#ifdef CONFIG_PM
-static int hpt3x3_reinit_one(struct pci_dev *dev)
-{
-	struct ata_host *host = dev_get_drvdata(&dev->dev);
-	int rc;
-
-	rc = ata_pci_device_do_resume(dev);
-	if (rc)
-		return rc;
-
-	hpt3x3_init_chipset(dev);
-
-	ata_host_resume(host);
-	return 0;
-}
-#endif
-
 static const struct pci_device_id hpt3x3[] = {
 	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT343), },
 
@@ -282,7 +272,7 @@ static struct pci_driver hpt3x3_pci_driv
 	.remove		= ata_pci_remove_one,
 #ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
-	.resume		= hpt3x3_reinit_one,
+	.resume		= ata_pci_device_resume,
 #endif
 };
 
Index: b/drivers/ata/pata_it821x.c
===================================================================
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -868,6 +868,15 @@ static void it821x_disable_raid(struct p
 	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x20);
 }
 
+static int it821x_fixup(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (pdev->vendor != PCI_VENDOR_ID_RDC && it8212_noraid)
+		it821x_disable_raid(pdev);
+
+	return 0;
+}
 
 static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
@@ -932,26 +941,10 @@ static int it821x_init_one(struct pci_de
 		else
 			ppi[0] = &info_smart;
 	}
-	return ata_pci_sff_init_one(pdev, ppi, &it821x_sht, NULL);
+	return __ata_pci_sff_init_one(pdev, ppi, &it821x_sht, NULL,
+				      it821x_fixup);
 }
 
-#ifdef CONFIG_PM
-static int it821x_reinit_one(struct pci_dev *pdev)
-{
-	struct ata_host *host = dev_get_drvdata(&pdev->dev);
-	int rc;
-
-	rc = ata_pci_device_do_resume(pdev);
-	if (rc)
-		return rc;
-	/* Resume - turn raid back off if need be */
-	if (it8212_noraid)
-		it821x_disable_raid(pdev);
-	ata_host_resume(host);
-	return rc;
-}
-#endif
-
 static const struct pci_device_id it821x[] = {
 	{ PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8211), },
 	{ PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8212), },
@@ -967,7 +960,7 @@ static struct pci_driver it821x_pci_driv
 	.remove		= ata_pci_remove_one,
 #ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
-	.resume		= it821x_reinit_one,
+	.resume		= ata_pci_device_resume,
 #endif
 };
 
Index: b/drivers/ata/pata_ninja32.c
===================================================================
--- a/drivers/ata/pata_ninja32.c
+++ b/drivers/ata/pata_ninja32.c
@@ -89,8 +89,11 @@ static struct ata_port_operations ninja3
 	.sff_data_xfer	= ata_sff_data_xfer32
 };
 
-static void ninja32_program(void __iomem *base)
+static int ninja32_program(struct device *dev)
 {
+	struct ata_host *host = dev_get_drvdata(dev);
+	void __iomem *base = host->iomap[0];
+
 	iowrite8(0x05, base + 0x01);	/* Enable interrupt lines */
 	iowrite8(0xBE, base + 0x02);	/* Burst, ?? setup */
 	iowrite8(0x01, base + 0x03);	/* Unknown */
@@ -98,6 +101,8 @@ static void ninja32_program(void __iomem
 	iowrite8(0x8f, base + 0x05);	/* Unknown */
 	iowrite8(0xa4, base + 0x1c);	/* Unknown */
 	iowrite8(0x83, base + 0x1d);	/* BMDMA control: WAIT0 */
+
+	return 0;
 }
 
 static int ninja32_init_one(struct pci_dev *dev, const struct pci_device_id *id)
@@ -110,6 +115,8 @@ static int ninja32_init_one(struct pci_d
 	host = ata_host_alloc(&dev->dev, 1);
 	if (!host)
 		return -ENOMEM;
+
+	host->init_host = ninja32_program;
 	ap = host->ports[0];
 
 	/* Set up the PCI device */
@@ -147,28 +154,13 @@ static int ninja32_init_one(struct pci_d
 	ata_sff_std_ports(&ap->ioaddr);
 	ap->pflags = ATA_PFLAG_PIO32 | ATA_PFLAG_PIO32CHANGE;
 
-	ninja32_program(base);
+	ninja32_program(&dev->dev);
+
 	/* FIXME: Should we disable them at remove ? */
 	return ata_host_activate(host, dev->irq, ata_sff_interrupt,
 				 IRQF_SHARED, &ninja32_sht);
 }
 
-#ifdef CONFIG_PM
-
-static int ninja32_reinit_one(struct pci_dev *pdev)
-{
-	struct ata_host *host = dev_get_drvdata(&pdev->dev);
-	int rc;
-
-	rc = ata_pci_device_do_resume(pdev);
-	if (rc)
-		return rc;
-	ninja32_program(host->iomap[0]);
-	ata_host_resume(host);
-	return 0;			
-}
-#endif
-
 static const struct pci_device_id ninja32[] = {
 	{ 0x10FC, 0x0003, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ 0x1145, 0x8008, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
@@ -186,7 +178,7 @@ static struct pci_driver ninja32_pci_dri
 	.remove		= ata_pci_remove_one,
 #ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
-	.resume		= ninja32_reinit_one,
+	.resume		= ata_pci_device_resume,
 #endif
 };
 
Index: b/drivers/ata/pata_ns87415.c
===================================================================
--- a/drivers/ata/pata_ns87415.c
+++ b/drivers/ata/pata_ns87415.c
@@ -325,12 +325,16 @@ static struct scsi_host_template ns87415
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
-static void ns87415_fixup(struct pci_dev *pdev)
+static int ns87415_fixup(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
+
 	/* Select 512 byte sectors */
 	pci_write_config_byte(pdev, 0x55, 0xEE);
 	/* Select PIO0 8bit clocking */
 	pci_write_config_byte(pdev, 0x54, 0xB7);
+
+	return 0;
 }
 
 /**
@@ -378,9 +382,10 @@ static int ns87415_init_one (struct pci_
 	if (rc)
 		return rc;
 
-	ns87415_fixup(pdev);
+	ns87415_fixup(&pdev->dev);
 
-	return ata_pci_sff_init_one(pdev, ppi, &ns87415_sht, NULL);
+	return __ata_pci_sff_init_one(pdev, ppi, &ns87415_sht, NULL,
+				      ns87415_fixup);
 }
 
 static const struct pci_device_id ns87415_pci_tbl[] = {
@@ -389,23 +394,6 @@ static const struct pci_device_id ns8741
 	{ }	/* terminate list */
 };
 
-#ifdef CONFIG_PM
-static int ns87415_reinit_one(struct pci_dev *pdev)
-{
-	struct ata_host *host = dev_get_drvdata(&pdev->dev);
-	int rc;
-
-	rc = ata_pci_device_do_resume(pdev);
-	if (rc)
-		return rc;
-
-	ns87415_fixup(pdev);
-
-	ata_host_resume(host);
-	return 0;
-}
-#endif
-
 static struct pci_driver ns87415_pci_driver = {
 	.name			= DRV_NAME,
 	.id_table		= ns87415_pci_tbl,
@@ -413,7 +401,7 @@ static struct pci_driver ns87415_pci_dri
 	.remove			= ata_pci_remove_one,
 #ifdef CONFIG_PM
 	.suspend		= ata_pci_device_suspend,
-	.resume			= ns87415_reinit_one,
+	.resume			= ata_pci_device_resume,
 #endif
 };
 
Index: b/drivers/ata/pata_pdc2027x.c
===================================================================
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -63,7 +63,6 @@ enum {
 };
 
 static int pdc2027x_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
-static int pdc2027x_reinit_one(struct pci_dev *pdev);
 static int pdc2027x_prereset(struct ata_link *link, unsigned long deadline);
 static void pdc2027x_set_piomode(struct ata_port *ap, struct ata_device *adev);
 static void pdc2027x_set_dmamode(struct ata_port *ap, struct ata_device *adev);
@@ -129,7 +128,7 @@ static struct pci_driver pdc2027x_pci_dr
 	.remove			= ata_pci_remove_one,
 #ifdef CONFIG_PM
 	.suspend		= ata_pci_device_suspend,
-	.resume			= pdc2027x_reinit_one,
+	.resume			= ata_pci_device_resume,
 #endif
 };
 
@@ -647,13 +646,21 @@ static long pdc_detect_pll_input_clock(s
 
 /**
  * pdc_hardware_init - Initialize the hardware.
- * @host: target ATA host
- * @board_idx: board identifier
+ * @dev: device
  */
-static int pdc_hardware_init(struct ata_host *host, unsigned int board_idx)
+static int pdc_hardware_init(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct ata_host *host = dev_get_drvdata(dev);
+	unsigned int board_idx;
 	long pll_clock;
 
+	if (pdev->device == PCI_DEVICE_ID_PROMISE_20268 ||
+	    pdev->device == PCI_DEVICE_ID_PROMISE_20270)
+		board_idx = PDC_UDMA_100;
+	else
+		board_idx = PDC_UDMA_133;
+
 	/*
 	 * Detect PLL input clock rate.
 	 * On some system, where PCI bus is running at non-standard clock rate.
@@ -722,6 +729,8 @@ static int __devinit pdc2027x_init_one(s
 	if (!host)
 		return -ENOMEM;
 
+	host->init_host = pdc_hardware_init;
+
 	/* acquire resources and fill host */
 	rc = pcim_enable_device(pdev);
 	if (rc)
@@ -755,7 +764,7 @@ static int __devinit pdc2027x_init_one(s
 	//pci_enable_intx(pdev);
 
 	/* initialize adapter */
-	if (pdc_hardware_init(host, board_idx) != 0)
+	if (pdc_hardware_init(&pdev->dev))
 		return -EIO;
 
 	pci_set_master(pdev);
@@ -763,31 +772,6 @@ static int __devinit pdc2027x_init_one(s
 				 IRQF_SHARED, &pdc2027x_sht);
 }
 
-#ifdef CONFIG_PM
-static int pdc2027x_reinit_one(struct pci_dev *pdev)
-{
-	struct ata_host *host = dev_get_drvdata(&pdev->dev);
-	unsigned int board_idx;
-	int rc;
-
-	rc = ata_pci_device_do_resume(pdev);
-	if (rc)
-		return rc;
-
-	if (pdev->device == PCI_DEVICE_ID_PROMISE_20268 ||
-	    pdev->device == PCI_DEVICE_ID_PROMISE_20270)
-		board_idx = PDC_UDMA_100;
-	else
-		board_idx = PDC_UDMA_133;
-
-	if (pdc_hardware_init(host, board_idx))
-		return -EIO;
-
-	ata_host_resume(host);
-	return 0;
-}
-#endif
-
 /**
  * pdc2027x_init - Called after this module is loaded into the kernel.
  */
Index: b/drivers/ata/pata_sl82c105.c
===================================================================
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -279,13 +279,16 @@ static int sl82c105_bridge_revision(stru
 	return bridge->revision;
 }
 
-static void sl82c105_fixup(struct pci_dev *pdev)
+static int sl82c105_fixup(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	u32 val;
 
 	pci_read_config_dword(pdev, 0x40, &val);
 	val |= CTRL_P0EN | CTRL_P0F16 | CTRL_P1F16;
 	pci_write_config_dword(pdev, 0x40, val);
+
+	return 0;
 }
 
 static int sl82c105_init_one(struct pci_dev *dev, const struct pci_device_id *id)
@@ -320,27 +323,11 @@ static int sl82c105_init_one(struct pci_
 	else
 		ppi[0] = &info_dma;
 
-	sl82c105_fixup(dev);
-
-	return ata_pci_sff_init_one(dev, ppi, &sl82c105_sht, NULL);
-}
-
-#ifdef CONFIG_PM
-static int sl82c105_reinit_one(struct pci_dev *pdev)
-{
-	struct ata_host *host = dev_get_drvdata(&pdev->dev);
-	int rc;
-
-	rc = ata_pci_device_do_resume(pdev);
-	if (rc)
-		return rc;
+	sl82c105_fixup(&dev->dev);
 
-	sl82c105_fixup(pdev);
-
-	ata_host_resume(host);
-	return 0;
+	return __ata_pci_sff_init_one(dev, ppi, &sl82c105_sht, NULL,
+				      sl82c105_fixup);
 }
-#endif
 
 static const struct pci_device_id sl82c105[] = {
 	{ PCI_VDEVICE(WINBOND, PCI_DEVICE_ID_WINBOND_82C105), },
@@ -355,7 +342,7 @@ static struct pci_driver sl82c105_pci_dr
 	.remove		= ata_pci_remove_one,
 #ifdef CONFIG_PM
 	.suspend	= ata_pci_device_suspend,
-	.resume		= sl82c105_reinit_one,
+	.resume		= ata_pci_device_resume,
 #endif
 };
 
Index: b/drivers/ata/sata_sil.c
===================================================================
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -114,9 +114,6 @@ enum {
 };
 
 static int sil_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
-#ifdef CONFIG_PM
-static int sil_pci_device_resume(struct pci_dev *pdev);
-#endif
 static void sil_dev_config(struct ata_device *dev);
 static int sil_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
 static int sil_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
@@ -169,7 +166,7 @@ static struct pci_driver sil_pci_driver
 	.remove			= ata_pci_remove_one,
 #ifdef CONFIG_PM
 	.suspend		= ata_pci_device_suspend,
-	.resume			= sil_pci_device_resume,
+	.resume			= ata_pci_device_resume,
 #endif
 };
 
@@ -663,9 +660,10 @@ static void sil_dev_config(struct ata_de
 	}
 }
 
-static void sil_init_controller(struct ata_host *host)
+static int sil_init_controller(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(host->dev);
+	struct ata_host *host = dev_get_drvdata(dev);
+	struct pci_dev *pdev = to_pci_dev(dev);
 	void __iomem *mmio_base = host->iomap[SIL_MMIO_BAR];
 	u8 cls;
 	u32 tmp;
@@ -707,6 +705,8 @@ static void sil_init_controller(struct a
 			writel(tmp | SIL_INTR_STEERING,
 			       mmio_base + sil_port[2].bmdma);
 	}
+
+	return 0;
 }
 
 static bool sil_broken_system_poweroff(struct pci_dev *pdev)
@@ -765,6 +765,8 @@ static int sil_init_one(struct pci_dev *
 	if (!host)
 		return -ENOMEM;
 
+	host->init_host = sil_init_controller;
+
 	/* acquire resources and fill host */
 	rc = pcim_enable_device(pdev);
 	if (rc)
@@ -802,30 +804,13 @@ static int sil_init_one(struct pci_dev *
 	}
 
 	/* initialize and activate */
-	sil_init_controller(host);
+	sil_init_controller(&pdev->dev);
 
 	pci_set_master(pdev);
 	return ata_host_activate(host, pdev->irq, sil_interrupt, IRQF_SHARED,
 				 &sil_sht);
 }
 
-#ifdef CONFIG_PM
-static int sil_pci_device_resume(struct pci_dev *pdev)
-{
-	struct ata_host *host = dev_get_drvdata(&pdev->dev);
-	int rc;
-
-	rc = ata_pci_device_do_resume(pdev);
-	if (rc)
-		return rc;
-
-	sil_init_controller(host);
-	ata_host_resume(host);
-
-	return 0;
-}
-#endif
-
 static int __init sil_init(void)
 {
 	return pci_register_driver(&sil_pci_driver);
Index: b/include/linux/libata.h
===================================================================
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -526,6 +526,7 @@ struct ata_host {
 	unsigned int		n_ports;
 	void			*private_data;
 	struct ata_port_operations *ops;
+	int			(*init_host)(struct device *dev);
 	unsigned long		flags;
 #ifdef CONFIG_ATA_ACPI
 	acpi_handle		acpi_handle;
@@ -1637,9 +1638,16 @@ extern int ata_pci_sff_prepare_host(stru
 extern int ata_pci_sff_activate_host(struct ata_host *host,
 				     irq_handler_t irq_handler,
 				     struct scsi_host_template *sht);
-extern int ata_pci_sff_init_one(struct pci_dev *pdev,
-				const struct ata_port_info * const * ppi,
-				struct scsi_host_template *sht, void *host_priv);
+extern int __ata_pci_sff_init_one(struct pci_dev *pdev,
+				const struct ata_port_info * const *ppi,
+				struct scsi_host_template *sht, void *host_priv,
+				int (*init_host)(struct device *dev));
+static inline int ata_pci_sff_init_one(struct pci_dev *pdev,
+				const struct ata_port_info * const *ppi,
+				struct scsi_host_template *sht, void *host_priv)
+{
+	return __ata_pci_sff_init_one(pdev, ppi, sht, host_priv, NULL);
+}
 #endif /* CONFIG_PCI */
 
 /**
