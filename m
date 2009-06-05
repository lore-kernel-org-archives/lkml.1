Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbZFESqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbZFESqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZFESqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:46:09 -0400
Received: from havoc.gtf.org ([69.61.125.42]:59911 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbZFESqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:46:08 -0400
Date: Fri, 5 Jun 2009 14:46:08 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20090605184608.GA29250@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c        |   72 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/ata_piix.c    |    9 +++++
 drivers/ata/pata_efar.c   |   17 +++++-----
 drivers/ata/pata_legacy.c |    2 +
 4 files changed, 91 insertions(+), 9 deletions(-)

James Bottomley (1):
      pata_legacy: wait for async probing

Sergei Shtylyov (1):
      pata_efar: fix PIO2 underclocking

Tejun Heo (1):
      ahci: add warning messages for hp laptops with broken suspend

Ville Syrjala (1):
      ata_piix: Add HP Compaq nc6000 to the broken poweroff list

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 08186ec..6b91c26 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -220,6 +220,7 @@ enum {
 	AHCI_HFLAG_NO_HOTPLUG		= (1 << 7), /* ignore PxSERR.DIAG.N */
 	AHCI_HFLAG_SECT255		= (1 << 8), /* max 255 sectors */
 	AHCI_HFLAG_YES_NCQ		= (1 << 9), /* force NCQ cap on */
+	AHCI_HFLAG_NO_SUSPEND		= (1 << 10), /* don't suspend */
 
 	/* ap->flags bits */
 
@@ -2316,9 +2317,17 @@ static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
 static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	struct ahci_host_priv *hpriv = host->private_data;
 	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
 	u32 ctl;
 
+	if (mesg.event & PM_EVENT_SUSPEND &&
+	    hpriv->flags & AHCI_HFLAG_NO_SUSPEND) {
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "BIOS update required for suspend/resume\n");
+		return -EIO;
+	}
+
 	if (mesg.event & PM_EVENT_SLEEP) {
 		/* AHCI spec rev1.1 section 8.3.3:
 		 * Software must disable interrupts prior to requesting a
@@ -2610,6 +2619,63 @@ static bool ahci_broken_system_poweroff(struct pci_dev *pdev)
 	return false;
 }
 
+static bool ahci_broken_suspend(struct pci_dev *pdev)
+{
+	static const struct dmi_system_id sysids[] = {
+		/*
+		 * On HP dv[4-6] and HDX18 with earlier BIOSen, link
+		 * to the harddisk doesn't become online after
+		 * resuming from STR.  Warn and fail suspend.
+		 */
+		{
+			.ident = "dv4",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+				DMI_MATCH(DMI_PRODUCT_NAME,
+					  "HP Pavilion dv4 Notebook PC"),
+			},
+			.driver_data = "F.30", /* cutoff BIOS version */
+		},
+		{
+			.ident = "dv5",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+				DMI_MATCH(DMI_PRODUCT_NAME,
+					  "HP Pavilion dv5 Notebook PC"),
+			},
+			.driver_data = "F.16", /* cutoff BIOS version */
+		},
+		{
+			.ident = "dv6",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+				DMI_MATCH(DMI_PRODUCT_NAME,
+					  "HP Pavilion dv6 Notebook PC"),
+			},
+			.driver_data = "F.21",	/* cutoff BIOS version */
+		},
+		{
+			.ident = "HDX18",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+				DMI_MATCH(DMI_PRODUCT_NAME,
+					  "HP HDX18 Notebook PC"),
+			},
+			.driver_data = "F.23",	/* cutoff BIOS version */
+		},
+		{ }	/* terminate list */
+	};
+	const struct dmi_system_id *dmi = dmi_first_match(sysids);
+	const char *ver;
+
+	if (!dmi || pdev->bus->number || pdev->devfn != PCI_DEVFN(0x1f, 2))
+		return false;
+
+	ver = dmi_get_system_info(DMI_BIOS_VERSION);
+
+	return !ver || strcmp(ver, dmi->driver_data) < 0;
+}
+
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
@@ -2715,6 +2781,12 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			"quirky BIOS, skipping spindown on poweroff\n");
 	}
 
+	if (ahci_broken_suspend(pdev)) {
+		hpriv->flags |= AHCI_HFLAG_NO_SUSPEND;
+		dev_printk(KERN_WARNING, &pdev->dev,
+			   "BIOS update required for suspend/resume\n");
+	}
+
 	/* CAP.NP sometimes indicate the index of the last enabled
 	 * port, at other times, that of the last possible port, so
 	 * determining the maximum port number requires looking at
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index d51a17c..1aeb708 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1455,6 +1455,15 @@ static bool piix_broken_system_poweroff(struct pci_dev *pdev)
 			/* PCI slot number of the controller */
 			.driver_data = (void *)0x1FUL,
 		},
+		{
+			.ident = "HP Compaq nc6000",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nc6000"),
+			},
+			/* PCI slot number of the controller */
+			.driver_data = (void *)0x1FUL,
+		},
 
 		{ }	/* terminate list */
 	};
diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index 2085e0a..2a6412f 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -22,7 +22,7 @@
 #include <linux/ata.h>
 
 #define DRV_NAME	"pata_efar"
-#define DRV_VERSION	"0.4.4"
+#define DRV_VERSION	"0.4.5"
 
 /**
  *	efar_pre_reset	-	Enable bits
@@ -98,18 +98,17 @@ static void efar_set_piomode (struct ata_port *ap, struct ata_device *adev)
 			    { 2, 1 },
 			    { 2, 3 }, };
 
-	if (pio > 2)
-		control |= 1;	/* TIME1 enable */
+	if (pio > 1)
+		control |= 1;	/* TIME */
 	if (ata_pio_need_iordy(adev))	/* PIO 3/4 require IORDY */
-		control |= 2;	/* IE enable */
-	/* Intel specifies that the PPE functionality is for disk only */
+		control |= 2;	/* IE */
+	/* Intel specifies that the prefetch/posting is for disk only */
 	if (adev->class == ATA_DEV_ATA)
-		control |= 4;	/* PPE enable */
+		control |= 4;	/* PPE */
 
 	pci_read_config_word(dev, idetm_port, &idetm_data);
 
-	/* Enable PPE, IE and TIME as appropriate */
-
+	/* Set PPE, IE, and TIME as appropriate */
 	if (adev->devno == 0) {
 		idetm_data &= 0xCCF0;
 		idetm_data |= control;
@@ -129,7 +128,7 @@ static void efar_set_piomode (struct ata_port *ap, struct ata_device *adev)
 		pci_write_config_byte(dev, 0x44, slave_data);
 	}
 
-	idetm_data |= 0x4000;	/* Ensure SITRE is enabled */
+	idetm_data |= 0x4000;	/* Ensure SITRE is set */
 	pci_write_config_word(dev, idetm_port, idetm_data);
 }
 
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index f72c6c5..6932e56 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -48,6 +48,7 @@
  *
  */
 
+#include <linux/async.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -1028,6 +1029,7 @@ static __init int legacy_init_one(struct legacy_probe *probe)
 				&legacy_sht);
 	if (ret)
 		goto fail;
+	async_synchronize_full();
 	ld->platform_dev = pdev;
 
 	/* Nothing found means we drop the port as its probably not there */
