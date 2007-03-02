Return-Path: <linux-kernel-owner+w=401wt.eu-S1422670AbXCBCIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422670AbXCBCIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 21:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422669AbXCBCIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 21:08:36 -0500
Received: from havoc.gtf.org ([69.61.125.42]:56164 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422667AbXCBCIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 21:08:35 -0500
Date: Thu, 1 Mar 2007 21:08:33 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070302020833.GA6105@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Does not include Alan's stuff, per recent email thread.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c          |   55 ++++++++++++++--------------
 drivers/ata/libata-core.c   |    5 ++-
 drivers/ata/pata_cs5520.c   |    1 -
 drivers/ata/pata_isapnp.c   |    1 -
 drivers/ata/pata_jmicron.c  |   51 ++++++--------------------
 drivers/ata/pata_platform.c |    1 -
 drivers/ata/sata_sil24.c    |    3 --
 drivers/pci/quirks.c        |   83 +++++++++++++++++++++++++++---------------
 8 files changed, 95 insertions(+), 105 deletions(-)

Tejun Heo (7):
      libata: clear drvdata in ata_host_release(), take#2
      sata_sil24: kill unused local variable idx in sil24_fill_sg()
      libata: blacklist FUJITSU MHT2060BH for NCQ
      pata_jmicron: drop unnecessary device programming in [re]init
      jmicron ATA: reimplement jmicron ATA quirk
      ahci/pata_jmicron: match class not function number
      ahci: improve spurious SDB FIS handling

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 6d93240..1539734 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -200,6 +200,7 @@ struct ahci_port_priv {
 	/* for NCQ spurious interrupt analysis */
 	unsigned int		ncq_saw_d2h:1;
 	unsigned int		ncq_saw_dmas:1;
+	unsigned int		ncq_saw_sdb:1;
 };
 
 static u32 ahci_scr_read (struct ata_port *ap, unsigned int sc_reg);
@@ -384,12 +385,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x294d), board_ahci_pi }, /* ICH9 */
 	{ PCI_VDEVICE(INTEL, 0x294e), board_ahci_pi }, /* ICH9M */
 
-	/* JMicron */
-	{ PCI_VDEVICE(JMICRON, 0x2360), board_ahci_ign_iferr }, /* JMB360 */
-	{ PCI_VDEVICE(JMICRON, 0x2361), board_ahci_ign_iferr }, /* JMB361 */
-	{ PCI_VDEVICE(JMICRON, 0x2363), board_ahci_ign_iferr }, /* JMB363 */
-	{ PCI_VDEVICE(JMICRON, 0x2365), board_ahci_ign_iferr }, /* JMB365 */
-	{ PCI_VDEVICE(JMICRON, 0x2366), board_ahci_ign_iferr }, /* JMB366 */
+	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
+	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
+	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci_ign_iferr },
 
 	/* ATI */
 	{ PCI_VDEVICE(ATI, 0x4380), board_ahci }, /* ATI SB600 non-raid */
@@ -1160,23 +1158,31 @@ static void ahci_host_intr(struct ata_port *ap)
 	}
 
 	if (status & PORT_IRQ_SDB_FIS) {
-		/* SDB FIS containing spurious completions might be
-		 * dangerous, whine and fail commands with HSM
-		 * violation.  EH will turn off NCQ after several such
-		 * failures.
-  		 */
 		const __le32 *f = pp->rx_fis + RX_FIS_SDB;
 
-		ata_ehi_push_desc(ehi, "spurious completion during NCQ "
-				  "issue=0x%x SAct=0x%x FIS=%08x:%08x",
-				  readl(port_mmio + PORT_CMD_ISSUE),
-				  readl(port_mmio + PORT_SCR_ACT),
-				  le32_to_cpu(f[0]), le32_to_cpu(f[1]));
-
-		ehi->err_mask |= AC_ERR_HSM;
-		ehi->action |= ATA_EH_SOFTRESET;
-		ata_port_freeze(ap);
-
+		if (le32_to_cpu(f[1])) {
+			/* SDB FIS containing spurious completions
+			 * might be dangerous, whine and fail commands
+			 * with HSM violation.  EH will turn off NCQ
+			 * after several such failures.
+			 */
+			ata_ehi_push_desc(ehi,
+				"spurious completions during NCQ "
+				"issue=0x%x SAct=0x%x FIS=%08x:%08x",
+				readl(port_mmio + PORT_CMD_ISSUE),
+				readl(port_mmio + PORT_SCR_ACT),
+				le32_to_cpu(f[0]), le32_to_cpu(f[1]));
+			ehi->err_mask |= AC_ERR_HSM;
+			ehi->action |= ATA_EH_SOFTRESET;
+			ata_port_freeze(ap);
+		} else {
+			if (!pp->ncq_saw_sdb)
+				ata_port_printk(ap, KERN_INFO,
+					"spurious SDB FIS %08x:%08x during NCQ, "
+					"this message won't be printed again\n",
+					le32_to_cpu(f[0]), le32_to_cpu(f[1]));
+			pp->ncq_saw_sdb = 1;
+		}
 		known_irq = 1;
 	}
 
@@ -1665,13 +1671,6 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
 
-	if (pdev->vendor == PCI_VENDOR_ID_JMICRON) {
-		/* Function 1 is the PATA controller except on the 368, where
-		   we are not AHCI anyway */
-		if (PCI_FUNC(pdev->devfn))
-			return -ENODEV;
-	}
-
 	rc = pcim_enable_device(pdev);
 	if (rc)
 		return rc;
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c8d44a7..ac3d120 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3346,6 +3346,8 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	/* Devices where NCQ should be avoided */
 	/* NCQ is slow */
         { "WDC WD740ADFD-00",   NULL,		ATA_HORKAGE_NONCQ },
+	/* http://thread.gmane.org/gmane.linux.ide/14907 */
+	{ "FUJITSU MHT2060BH",	NULL,		ATA_HORKAGE_NONCQ },
 
 	/* Devices with NCQ limits */
 
@@ -5680,6 +5682,8 @@ static void ata_host_release(struct device *gendev, void *res)
 
 	if (host->ops->host_stop)
 		host->ops->host_stop(host);
+
+	dev_set_drvdata(gendev, NULL);
 }
 
 /**
@@ -5902,7 +5906,6 @@ int ata_device_add(const struct ata_probe_ent *ent)
 
  err_out:
 	devres_release_group(dev, ata_device_add);
-	dev_set_drvdata(dev, NULL);
 	VPRINTK("EXIT, returning %d\n", rc);
 	return 0;
 }
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index c1334c6..8ff2d58 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -306,7 +306,6 @@ static void __devexit cs5520_remove_one(struct pci_dev *pdev)
 	struct ata_host *host = dev_get_drvdata(dev);
 
 	ata_host_detach(host);
-	dev_set_drvdata(dev, NULL);
 }
 
 /**
diff --git a/drivers/ata/pata_isapnp.c b/drivers/ata/pata_isapnp.c
index d5f2e85..1a61cc8 100644
--- a/drivers/ata/pata_isapnp.c
+++ b/drivers/ata/pata_isapnp.c
@@ -128,7 +128,6 @@ static void isapnp_remove_one(struct pnp_dev *idev)
 	struct ata_host *host = dev_get_drvdata(dev);
 
 	ata_host_detach(host);
-	dev_set_drvdata(dev, NULL);
 }
 
 static struct pnp_device_id isapnp_devices[] = {
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index 7a635dd..47d0f94 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -202,49 +202,20 @@ static int jmicron_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 	};
 	struct ata_port_info *port_info[2] = { &info, &info };
 
-	u32 reg;
-
-	/* PATA controller is fn 1, AHCI is fn 0 */
-	if (id->driver_data != 368 && PCI_FUNC(pdev->devfn) != 1)
-		return -ENODEV;
-
-	/* The 365/66 have two PATA channels, redirect the second */
-	if (id->driver_data == 365 || id->driver_data == 366) {
-		pci_read_config_dword(pdev, 0x80, &reg);
-		reg |= (1 << 24);	/* IDE1 to PATA IDE secondary */
-		pci_write_config_dword(pdev, 0x80, reg);
-	}
-
 	return ata_pci_init_one(pdev, port_info, 2);
 }
 
-static int jmicron_reinit_one(struct pci_dev *pdev)
-{
-	u32 reg;
-
-	switch(pdev->device) {
-		case PCI_DEVICE_ID_JMICRON_JMB368:
-			break;
-		case PCI_DEVICE_ID_JMICRON_JMB365:
-		case PCI_DEVICE_ID_JMICRON_JMB366:
-			/* Restore mapping or disks swap and boy does it get ugly */
-			pci_read_config_dword(pdev, 0x80, &reg);
-			reg |= (1 << 24);	/* IDE1 to PATA IDE secondary */
-			pci_write_config_dword(pdev, 0x80, reg);
-			/* Fall through */
-		default:
-			/* Make sure AHCI is turned back on */
-			pci_write_config_byte(pdev, 0x41, 0xa1);
-	}
-	return ata_pci_device_resume(pdev);
-}
-
 static const struct pci_device_id jmicron_pci_tbl[] = {
-	{ PCI_VDEVICE(JMICRON, PCI_DEVICE_ID_JMICRON_JMB361), 361},
-	{ PCI_VDEVICE(JMICRON, PCI_DEVICE_ID_JMICRON_JMB363), 363},
-	{ PCI_VDEVICE(JMICRON, PCI_DEVICE_ID_JMICRON_JMB365), 365},
-	{ PCI_VDEVICE(JMICRON, PCI_DEVICE_ID_JMICRON_JMB366), 366},
-	{ PCI_VDEVICE(JMICRON, PCI_DEVICE_ID_JMICRON_JMB368), 368},
+	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361,
+	  PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_STORAGE_IDE << 8, 0xffff00, 361 },
+	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB363,
+	  PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_STORAGE_IDE << 8, 0xffff00, 363 },
+	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365,
+	  PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_STORAGE_IDE << 8, 0xffff00, 365 },
+	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366,
+	  PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_STORAGE_IDE << 8, 0xffff00, 366 },
+	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB368,
+	  PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_STORAGE_IDE << 8, 0xffff00, 368 },
 
 	{ }	/* terminate list */
 };
@@ -255,7 +226,7 @@ static struct pci_driver jmicron_pci_driver = {
 	.probe			= jmicron_init_one,
 	.remove			= ata_pci_remove_one,
 	.suspend		= ata_pci_device_suspend,
-	.resume			= jmicron_reinit_one,
+	.resume			= ata_pci_device_resume,
 };
 
 static int __init jmicron_init(void)
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 02ea95f..4b82a54 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -228,7 +228,6 @@ static int __devexit pata_platform_remove(struct platform_device *pdev)
 	struct ata_host *host = dev_get_drvdata(dev);
 
 	ata_host_detach(host);
-	dev_set_drvdata(dev, NULL);
 
 	return 0;
 }
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 5d083f4..b1bab82 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -647,7 +647,6 @@ static inline void sil24_fill_sg(struct ata_queued_cmd *qc,
 				 struct sil24_sge *sge)
 {
 	struct scatterlist *sg;
-	unsigned int idx = 0;
 
 	ata_for_each_sg(sg, qc) {
 		sge->addr = cpu_to_le64(sg_dma_address(sg));
@@ -656,9 +655,7 @@ static inline void sil24_fill_sg(struct ata_queued_cmd *qc,
 			sge->flags = cpu_to_le32(SGE_TRM);
 		else
 			sge->flags = 0;
-
 		sge++;
-		idx++;
 	}
 }
 
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 1e6eda2..1bf5482 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1218,45 +1218,68 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_VIA,	PCI_DEVICE_ID_VIA_8237, asus_hides_a
  *	do this early on to make the additional device appear during
  *	the PCI scanning.
  */
-
-static void quirk_jmicron_dualfn(struct pci_dev *pdev)
+static void quirk_jmicron_ata(struct pci_dev *pdev)
 {
-	u32 conf;
+	u32 conf1, conf5, class;
 	u8 hdr;
 
 	/* Only poke fn 0 */
 	if (PCI_FUNC(pdev->devfn))
 		return;
 
-	switch(pdev->device) {
-		case PCI_DEVICE_ID_JMICRON_JMB365:
-		case PCI_DEVICE_ID_JMICRON_JMB366:
-			/* Redirect IDE second PATA port to the right spot */
-			pci_read_config_dword(pdev, 0x80, &conf);
-			conf |= (1 << 24);
-			/* Fall through */
-			pci_write_config_dword(pdev, 0x80, conf);
-		case PCI_DEVICE_ID_JMICRON_JMB361:
-		case PCI_DEVICE_ID_JMICRON_JMB363:
-			pci_read_config_dword(pdev, 0x40, &conf);
-			/* Enable dual function mode, AHCI on fn 0, IDE fn1 */
-			/* Set the class codes correctly and then direct IDE 0 */
-			conf &= ~0x000FF200; /* Clear bit 9 and 12-19 */
-			conf |=  0x00C2A102; /* Set 1, 8, 13, 15, 17, 22, 23 */
-			pci_write_config_dword(pdev, 0x40, conf);
-
-			/* Reconfigure so that the PCI scanner discovers the
-			   device is now multifunction */
-
-			pci_read_config_byte(pdev, PCI_HEADER_TYPE, &hdr);
-			pdev->hdr_type = hdr & 0x7f;
-			pdev->multifunction = !!(hdr & 0x80);
+	pci_read_config_dword(pdev, 0x40, &conf1);
+	pci_read_config_dword(pdev, 0x80, &conf5);
 
-			break;
+	conf1 &= ~0x00CFF302; /* Clear bit 1, 8, 9, 12-19, 22, 23 */
+	conf5 &= ~(1 << 24);  /* Clear bit 24 */
+
+	switch (pdev->device) {
+	case PCI_DEVICE_ID_JMICRON_JMB360:
+		/* The controller should be in single function ahci mode */
+		conf1 |= 0x0002A100; /* Set 8, 13, 15, 17 */
+		break;
+
+	case PCI_DEVICE_ID_JMICRON_JMB365:
+	case PCI_DEVICE_ID_JMICRON_JMB366:
+		/* Redirect IDE second PATA port to the right spot */
+		conf5 |= (1 << 24);
+		/* Fall through */
+	case PCI_DEVICE_ID_JMICRON_JMB361:
+	case PCI_DEVICE_ID_JMICRON_JMB363:
+		/* Enable dual function mode, AHCI on fn 0, IDE fn1 */
+		/* Set the class codes correctly and then direct IDE 0 */
+		conf1 |= 0x00C2A102; /* Set 1, 8, 13, 15, 17, 22, 23 */
+		break;
+
+	case PCI_DEVICE_ID_JMICRON_JMB368:
+		/* The controller should be in single function IDE mode */
+		conf1 |= 0x00C00000; /* Set 22, 23 */
+		break;
 	}
-}
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, quirk_jmicron_dualfn);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, quirk_jmicron_dualfn);
+
+	pci_write_config_dword(pdev, 0x40, conf1);
+	pci_write_config_dword(pdev, 0x80, conf5);
+
+	/* Update pdev accordingly */
+	pci_read_config_byte(pdev, PCI_HEADER_TYPE, &hdr);
+	pdev->hdr_type = hdr & 0x7f;
+	pdev->multifunction = !!(hdr & 0x80);
+
+	pci_read_config_dword(pdev, PCI_CLASS_REVISION, &class);
+	pdev->class = class >> 8;
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB360, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB363, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB368, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB360, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB363, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB368, quirk_jmicron_ata);
 
 #endif
 
