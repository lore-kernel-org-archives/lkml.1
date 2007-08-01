Return-Path: <linux-kernel-owner+w=401wt.eu-S1763789AbXHAQTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763789AbXHAQTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 12:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692AbXHAQTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 12:19:37 -0400
Received: from havoc.gtf.org ([69.61.125.42]:47911 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544AbXHAQTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 12:19:35 -0400
Date: Wed, 1 Aug 2007 12:19:32 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070801161932.GA15959@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The only notable: GregKH wanted the pci_reenable_device() change
associated with ata_piix to go in before the release, to avoiding
release with an imperfect API.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ata_piix.c    |   74 +++++++++++++++++++++++++--------------------
 drivers/ata/libata-core.c |    1 +
 drivers/ata/libata-sff.c  |    4 ++
 drivers/ata/pata_cmd64x.c |    8 ++--
 drivers/ata/pata_sis.c    |   20 +++++-------
 drivers/pci/pci-driver.c  |    2 +-
 drivers/pci/pci.c         |    7 ++--
 include/linux/pci.h       |    2 +-
 8 files changed, 64 insertions(+), 54 deletions(-)

Alan Cox (2):
      pata_cmd64x: Correct the speed ranges
      libata-sff; Unbreak non DMA capable controllers again

Bartlomiej Zolnierkiewicz (1):
      pata_sis: fix MWDMA for <= UDMA66 chipsets and UDMA for UDMA33 chipsets

Tejun Heo (4):
      pci: rename __pci_reenable_device() to pci_reenable_device()
      ata_piix: implement piix_borken_suspend()
      ata_piix: add Tecra M3 to broken suspend blacklist
      libata: blacklist SAMSUNG HD401LJ / ZZ100-15 for NCQ

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index ad07086..a78832e 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -890,37 +890,46 @@ static void ich_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 }
 
 #ifdef CONFIG_PM
-static struct dmi_system_id piix_broken_suspend_dmi_table[] = {
-	{
-		.ident = "TECRA M5",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "TECRA M5"),
-		},
-	},
-	{
-		.ident = "Satellite U200",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Satellite U200"),
+static int piix_broken_suspend(void)
+{
+	static struct dmi_system_id sysids[] = {
+		{
+			.ident = "TECRA M5",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "TECRA M5"),
+			},
 		},
-	},
-	{
-		.ident = "Satellite U205",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Satellite U205"),
+		{
+			.ident = "Satellite U205",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "Satellite U205"),
+			},
 		},
-	},
-	{
-		.ident = "Portege M500",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "PORTEGE M500"),
+		{
+			.ident = "Portege M500",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "PORTEGE M500"),
+			},
 		},
-	},
-	{ }
-};
+		{ }
+	};
+	static const char *oemstrs[] = {
+		"Tecra M3,",
+	};
+	int i;
+
+	if (dmi_check_system(sysids))
+		return 1;
+
+	for (i = 0; i < ARRAY_SIZE(oemstrs); i++)
+		if (dmi_find_device(DMI_DEV_TYPE_OEM_STRING, oemstrs[i], NULL))
+			return 1;
+
+	return 0;
+}
 
 static int piix_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
@@ -937,8 +946,7 @@ static int piix_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
 	 * cycles and power trying to do something to the sleeping
 	 * beauty.
 	 */
-	if (dmi_check_system(piix_broken_suspend_dmi_table) &&
-	    mesg.event == PM_EVENT_SUSPEND) {
+	if (piix_broken_suspend() && mesg.event == PM_EVENT_SUSPEND) {
 		pci_save_state(pdev);
 
 		/* mark its power state as "unknown", since we don't
@@ -973,10 +981,10 @@ static int piix_pci_device_resume(struct pci_dev *pdev)
 		pci_restore_state(pdev);
 
 		/* PCI device wasn't disabled during suspend.  Use
-		 * __pci_reenable_device() to avoid affecting the
-		 * enable count.
+		 * pci_reenable_device() to avoid affecting the enable
+		 * count.
 		 */
-		rc = __pci_reenable_device(pdev);
+		rc = pci_reenable_device(pdev);
 		if (rc)
 			dev_printk(KERN_ERR, &pdev->dev, "failed to enable "
 				   "device after resume (%d)\n", rc);
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 6001aae..60e78be 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3788,6 +3788,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "WDC WD740ADFD-00NLR1", NULL,		ATA_HORKAGE_NONCQ, },
 	{ "FUJITSU MHV2080BH",	"00840028",	ATA_HORKAGE_NONCQ, },
 	{ "ST9160821AS",	"3.CLF",	ATA_HORKAGE_NONCQ, },
+	{ "SAMSUNG HD401LJ",	"ZZ100-15",	ATA_HORKAGE_NONCQ, },
 
 	/* Devices with NCQ limits */
 
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 6c289c7..1cce219 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -573,6 +573,10 @@ int ata_pci_init_bmdma(struct ata_host *host)
 	struct pci_dev *pdev = to_pci_dev(gdev);
 	int i, rc;
 
+	/* No BAR4 allocation: No DMA */
+	if (pci_resource_start(pdev, 4) == 0)
+		return 0;
+
 	/* TODO: If we get no DMA mask we should fall back to PIO */
 	rc = pci_set_dma_mask(pdev, ATA_DMA_MASK);
 	if (rc)
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index dc443e7..e34b632 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -31,7 +31,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_cmd64x"
-#define DRV_VERSION "0.2.3"
+#define DRV_VERSION "0.2.4"
 
 /*
  * CMD64x specific registers definition.
@@ -397,7 +397,7 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = ATA_UDMA1,
+			.udma_mask = ATA_UDMA2,
 			.port_ops = &cmd64x_port_ops
 		},
 		{	/* CMD 646 rev 1  */
@@ -412,7 +412,7 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = ATA_UDMA2,
+			.udma_mask = ATA_UDMA4,
 			.port_ops = &cmd648_port_ops
 		},
 		{	/* CMD 649 */
@@ -420,7 +420,7 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.flags = ATA_FLAG_SLAVE_POSS,
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
-			.udma_mask = ATA_UDMA3,
+			.udma_mask = ATA_UDMA5,
 			.port_ops = &cmd648_port_ops
 		}
 	};
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 9a829a7..66bd0e8 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -2,6 +2,7 @@
  *    pata_sis.c - SiS ATA driver
  *
  *	(C) 2005 Red Hat <alan@redhat.com>
+ *	(C) 2007 Bartlomiej Zolnierkiewicz
  *
  *    Based upon linux/drivers/ide/pci/sis5513.c
  * Copyright (C) 1999-2000	Andre Hedrick <andre@linux-ide.org>
@@ -35,7 +36,7 @@
 #include "sis.h"
 
 #define DRV_NAME	"pata_sis"
-#define DRV_VERSION	"0.5.1"
+#define DRV_VERSION	"0.5.2"
 
 struct sis_chipset {
 	u16 device;				/* PCI host ID */
@@ -237,7 +238,7 @@ static void sis_old_set_piomode (struct ata_port *ap, struct ata_device *adev)
 }
 
 /**
- *	sis_100_set_pioode - Initialize host controller PATA PIO timings
+ *	sis_100_set_piomode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Device we are configuring for.
  *
@@ -262,7 +263,7 @@ static void sis_100_set_piomode (struct ata_port *ap, struct ata_device *adev)
 }
 
 /**
- *	sis_133_set_pioode - Initialize host controller PATA PIO timings
+ *	sis_133_set_piomode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Device we are configuring for.
  *
@@ -334,7 +335,7 @@ static void sis_old_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	int drive_pci = sis_old_port_base(adev);
 	u16 timing;
 
-	const u16 mwdma_bits[] = { 0x707, 0x202, 0x202 };
+	const u16 mwdma_bits[] = { 0x008, 0x302, 0x301 };
 	const u16 udma_bits[]  = { 0xE000, 0xC000, 0xA000 };
 
 	pci_read_config_word(pdev, drive_pci, &timing);
@@ -342,15 +343,15 @@ static void sis_old_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	if (adev->dma_mode < XFER_UDMA_0) {
 		/* bits 3-0 hold recovery timing bits 8-10 active timing and
 		   the higer bits are dependant on the device */
-		timing &= ~ 0x870F;
+		timing &= ~0x870F;
 		timing |= mwdma_bits[speed];
-		pci_write_config_word(pdev, drive_pci, timing);
 	} else {
 		/* Bit 15 is UDMA on/off, bit 13-14 are cycle time */
 		speed = adev->dma_mode - XFER_UDMA_0;
 		timing &= ~0x6000;
 		timing |= udma_bits[speed];
 	}
+	pci_write_config_word(pdev, drive_pci, timing);
 }
 
 /**
@@ -373,7 +374,7 @@ static void sis_66_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	int drive_pci = sis_old_port_base(adev);
 	u16 timing;
 
-	const u16 mwdma_bits[] = { 0x707, 0x202, 0x202 };
+	const u16 mwdma_bits[] = { 0x008, 0x302, 0x301 };
 	const u16 udma_bits[]  = { 0xF000, 0xD000, 0xB000, 0xA000, 0x9000};
 
 	pci_read_config_word(pdev, drive_pci, &timing);
@@ -432,8 +433,7 @@ static void sis_100_set_dmamode (struct ata_port *ap, struct ata_device *adev)
  *	@adev: Device to program
  *
  *	Set UDMA/MWDMA mode for device, in host controller PCI config space.
- *	Handles early SiS 961 bridges. Supports MWDMA as well unlike
- *	the old ide/pci driver.
+ *	Handles early SiS 961 bridges.
  *
  *	LOCKING:
  *	None (inherited from caller).
@@ -467,8 +467,6 @@ static void sis_133_early_set_dmamode (struct ata_port *ap, struct ata_device *a
  *	@adev: Device to program
  *
  *	Set UDMA/MWDMA mode for device, in host controller PCI config space.
- *	Handles early SiS 961 bridges. Supports MWDMA as well unlike
- *	the old ide/pci driver.
  *
  *	LOCKING:
  *	None (inherited from caller).
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 8e58ea3..004bc24 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -310,7 +310,7 @@ static int pci_default_resume(struct pci_dev *pci_dev)
 	/* restore the PCI config space */
 	pci_restore_state(pci_dev);
 	/* if the device was enabled before suspend, reenable */
-	retval = __pci_reenable_device(pci_dev);
+	retval = pci_reenable_device(pci_dev);
 	/* if the device was busmaster before the suspend, make it busmaster again */
 	if (pci_dev->is_busmaster)
 		pci_set_master(pci_dev);
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 1ee9cd9..37c00f6 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -695,14 +695,13 @@ static int do_pci_enable_device(struct pci_dev *dev, int bars)
 }
 
 /**
- * __pci_reenable_device - Resume abandoned device
+ * pci_reenable_device - Resume abandoned device
  * @dev: PCI device to be resumed
  *
  *  Note this function is a backend of pci_default_resume and is not supposed
  *  to be called by normal code, write proper resume handler and use it instead.
  */
-int
-__pci_reenable_device(struct pci_dev *dev)
+int pci_reenable_device(struct pci_dev *dev)
 {
 	if (atomic_read(&dev->enable_cnt))
 		return do_pci_enable_device(dev, (1 << PCI_NUM_RESOURCES) - 1);
@@ -1604,7 +1603,7 @@ early_param("pci", pci_setup);
 device_initcall(pci_init);
 
 EXPORT_SYMBOL_GPL(pci_restore_bars);
-EXPORT_SYMBOL(__pci_reenable_device);
+EXPORT_SYMBOL(pci_reenable_device);
 EXPORT_SYMBOL(pci_enable_device_bars);
 EXPORT_SYMBOL(pci_enable_device);
 EXPORT_SYMBOL(pcim_enable_device);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index d8f8a3a..e7d8d4e 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -534,7 +534,7 @@ static inline int pci_write_config_dword(struct pci_dev *dev, int where, u32 val
 
 int __must_check pci_enable_device(struct pci_dev *dev);
 int __must_check pci_enable_device_bars(struct pci_dev *dev, int mask);
-int __must_check __pci_reenable_device(struct pci_dev *);
+int __must_check pci_reenable_device(struct pci_dev *);
 int __must_check pcim_enable_device(struct pci_dev *pdev);
 void pcim_pin_device(struct pci_dev *pdev);
 
