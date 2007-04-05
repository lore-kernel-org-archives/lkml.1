Return-Path: <linux-kernel-owner+w=401wt.eu-S1766978AbXDENJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766978AbXDENJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 09:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766981AbXDENJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 09:09:14 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45352 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766978AbXDENJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 09:09:12 -0400
Date: Thu, 5 Apr 2007 14:11:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cable setup: Put the -mm tree back in sync with the cable
 changes
Message-ID: <20070405141132.2f6f25ed@the-village.bc.nu>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'll generate any patches for Jeff versus his git tree once I get a
moment.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc5-mm4/drivers/ata/ata_piix.c linux-2.6.21-rc5-mm4/drivers/ata/ata_piix.c
--- linux.vanilla-2.6.21-rc5-mm4/drivers/ata/ata_piix.c	2007-04-03 16:52:15.000000000 +0100
+++ linux-2.6.21-rc5-mm4/drivers/ata/ata_piix.c	2007-04-03 17:13:20.000000000 +0100
@@ -93,7 +93,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"ata_piix"
-#define DRV_VERSION	"2.10ac1"
+#define DRV_VERSION	"2.10ac2"
 
 enum {
 	PIIX_IOCFG		= 0x54, /* IDE I/O configuration register */
@@ -155,11 +155,11 @@
 static int piix_init_one (struct pci_dev *pdev,
 				    const struct pci_device_id *ent);
 static void piix_pata_error_handler(struct ata_port *ap);
-static void ich_pata_error_handler(struct ata_port *ap);
 static void piix_sata_error_handler(struct ata_port *ap);
 static void piix_set_piomode (struct ata_port *ap, struct ata_device *adev);
 static void piix_set_dmamode (struct ata_port *ap, struct ata_device *adev);
 static void ich_set_dmamode (struct ata_port *ap, struct ata_device *adev);
+static int ich_pata_cable_detect(struct ata_port *ap);
 
 static unsigned int in_module_init = 1;
 
@@ -305,6 +305,7 @@
 	.thaw			= ata_bmdma_thaw,
 	.error_handler		= piix_pata_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= ata_cable_40wire,
 
 	.irq_handler		= ata_interrupt,
 	.irq_clear		= ata_bmdma_irq_clear,
@@ -336,8 +337,9 @@
 
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= ich_pata_error_handler,
+	.error_handler		= piix_pata_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= ich_pata_cable_detect,
 
 	.irq_handler		= ata_interrupt,
 	.irq_clear		= ata_bmdma_irq_clear,
@@ -585,7 +587,7 @@
 };
 
 /**
- *	piix_pata_cbl_detect - Probe host controller cable detect info
+ *	ich_pata_cable_detect - Probe host controller cable detect info
  *	@ap: Port for which cable detect info is desired
  *
  *	Read 80c cable indicator from ATA PCI device's PCI config
@@ -595,23 +597,18 @@
  *	None (inherited from caller).
  */
 
-static void ich_pata_cbl_detect(struct ata_port *ap)
+static int ich_pata_cable_detect(struct ata_port *ap)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	const struct ich_laptop *lap = &ich_laptop[0];
 	u8 tmp, mask;
 
-	/* no 80c support in host controller? */
-	if ((ap->udma_mask & ~ATA_UDMA_MASK_40C) == 0)
-		goto cbl40;
-
 	/* Check for specials - Acer Aspire 5602WLMi */
 	while (lap->device) {
 		if (lap->device == pdev->device &&
 		    lap->subvendor == pdev->subsystem_vendor &&
 		    lap->subdevice == pdev->subsystem_device) {
-			ap->cbl = ATA_CBL_PATA40_SHORT;
-		    	return;
+			return ATA_CBL_PATA40_SHORT;
 		}
 		lap++;
 	}
@@ -620,20 +617,14 @@
 	mask = ap->port_no == 0 ? PIIX_80C_PRI : PIIX_80C_SEC;
 	pci_read_config_byte(pdev, PIIX_IOCFG, &tmp);
 	if ((tmp & mask) == 0)
-		goto cbl40;
-
-	ap->cbl = ATA_CBL_PATA80;
-	return;
-
-cbl40:
-	ap->cbl = ATA_CBL_PATA40;
+		return ATA_CBL_PATA40;
+	return ATA_CBL_PATA80;
 }
 
 /**
  *	piix_pata_prereset - prereset for PATA host controller
  *	@ap: Target port
  *
- *
  *	LOCKING:
  *	None (inherited from caller).
  */
@@ -643,8 +634,6 @@
 
 	if (!pci_test_config_bits(pdev, &piix_enable_bits[ap->port_no]))
 		return -ENOENT;
-
-	ap->cbl = ATA_CBL_PATA40;
 	return ata_std_prereset(ap);
 }
 
@@ -655,30 +644,6 @@
 }
 
 
-/**
- *	ich_pata_prereset - prereset for PATA host controller
- *	@ap: Target port
- *
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-static int ich_pata_prereset(struct ata_port *ap)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-
-	if (!pci_test_config_bits(pdev, &piix_enable_bits[ap->port_no]))
-		return -ENOENT;
-	ich_pata_cbl_detect(ap);
-	return ata_std_prereset(ap);
-}
-
-static void ich_pata_error_handler(struct ata_port *ap)
-{
-	ata_bmdma_drive_eh(ap, ich_pata_prereset, ata_std_softreset, NULL,
-			   ata_std_postreset);
-}
-
 static void piix_sata_error_handler(struct ata_port *ap)
 {
 	ata_bmdma_drive_eh(ap, ata_std_prereset, ata_std_softreset, NULL,
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc5-mm4/drivers/ata/pata_acpi.c linux-2.6.21-rc5-mm4/drivers/ata/pata_acpi.c
--- linux.vanilla-2.6.21-rc5-mm4/drivers/ata/pata_acpi.c	2007-04-03 16:56:32.000000000 +0100
+++ linux-2.6.21-rc5-mm4/drivers/ata/pata_acpi.c	2007-04-03 17:12:52.000000000 +0100
@@ -40,7 +40,6 @@
 /**
  *	pacpi_pre_reset	-	check for 40/80 pin
  *	@ap: Port
- *	@deadline: deadline jiffies for the operation
  *
  *	Perform the PATA port setup we need.
  */
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc5-mm4/drivers/ata/pata_amd.c linux-2.6.21-rc5-mm4/drivers/ata/pata_amd.c
--- linux.vanilla-2.6.21-rc5-mm4/drivers/ata/pata_amd.c	2007-04-03 16:56:32.000000000 +0100
+++ linux-2.6.21-rc5-mm4/drivers/ata/pata_amd.c	2007-04-03 17:13:31.000000000 +0100
@@ -222,7 +222,6 @@
 /**
  *	nv_probe_init	-	cable detection
  *	@ap: ATA port
- *	@deadline: deadline jiffies for the operation
  *
  *	Perform cable detection. The BIOS stores this in PCI config
  *	space for us.
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc5-mm4/drivers/ata/pata_cs5535.c linux-2.6.21-rc5-mm4/drivers/ata/pata_cs5535.c
--- linux.vanilla-2.6.21-rc5-mm4/drivers/ata/pata_cs5535.c	2007-04-03 16:52:15.000000000 +0100
+++ linux-2.6.21-rc5-mm4/drivers/ata/pata_cs5535.c	2007-04-03 22:49:33.000000000 +0100
@@ -70,36 +70,23 @@
 #define CS5535_BAD_PIO(timings) ( (timings&~0x80000000UL)==0x00009172 )
 
 /**
- *	cs5535_pre_reset	-	detect cable type
+ *	cs5535_cable_detect	-	detect cable type
  *	@ap: Port to detect on
  *
  *	Perform cable detection for ATA66 capable cable. Return a libata
  *	cable type.
  */
 
-static int cs5535_pre_reset(struct ata_port *ap)
+static int cs5535_cable_detect(struct ata_port *ap)
 {
 	u8 cable;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
 	pci_read_config_byte(pdev, CS5535_CABLE_DETECT, &cable);
 	if (cable & 1)
-		ap->cbl = ATA_CBL_PATA80;
+		return ATA_CBL_PATA80;
 	else
-		ap->cbl = ATA_CBL_PATA40;
-	return ata_std_prereset(ap);
-}
-
-/**
- *	cs5535_error_handler		-	reset/probe
- *	@ap: Port to reset
- *
- *	Reset and configure a port
- */
-
-static void cs5535_error_handler(struct ata_port *ap)
-{
-	ata_bmdma_drive_eh(ap, cs5535_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
+		return ATA_CBL_PATA40;
 }
 
 /**
@@ -205,8 +192,9 @@
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= cs5535_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= cs5535_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc5-mm4/drivers/ata/pata_hpt3x2n.c linux-2.6.21-rc5-mm4/drivers/ata/pata_hpt3x2n.c
--- linux.vanilla-2.6.21-rc5-mm4/drivers/ata/pata_hpt3x2n.c	2007-04-03 16:56:32.000000000 +0100
+++ linux-2.6.21-rc5-mm4/drivers/ata/pata_hpt3x2n.c	2007-04-03 17:13:46.000000000 +0100
@@ -142,7 +142,6 @@
 /**
  *	hpt3x2n_pre_reset	-	reset the hpt3x2n bus
  *	@ap: ATA port to reset
- *	@deadline: deadline jiffies for the operation
  *
  *	Perform the initial reset handling for the 3x2n series controllers.
  *	Reset the hardware and state machine,
