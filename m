Return-Path: <linux-kernel-owner+w=401wt.eu-S932491AbZHLKf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491AbZHLKf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 06:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932465AbZHLKf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 06:35:58 -0400
Received: from havoc.gtf.org ([69.61.125.42]:37891 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932434AbZHLKf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 06:35:56 -0400
Date: Wed, 12 Aug 2009 06:35:56 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20090812103556.GA5789@havoc.gtf.org>
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

 Documentation/kernel-parameters.txt |    4 ++
 drivers/ata/ahci.c                  |   79 ++++++++++++++++++++++++++++++++--
 drivers/ata/libata-core.c           |    3 +
 drivers/ata/pata_at91.c             |   17 ++------
 drivers/ata/pata_atiixp.c           |   19 ++++----
 drivers/ata/sata_nv.c               |    8 ++++
 6 files changed, 103 insertions(+), 27 deletions(-)

Bartlomiej Zolnierkiewicz (1):
      pata_atiixp: fix second channel support

Michael Prokop (1):
      Documentation/kernel-parameters.txt: document libata's ignore_hpa option

Shane Huang (1):
      ahci: Soften up the dmesg on SB600 PMP softreset failure recovery

Tejun Heo (3):
      pata_at91: fix resource release
      libata: OCZ Vertex can't do HPA
      ahci: add workaround for on-board 5723s on some gigabyte boards

Tony Vroon (1):
      sata_nv: MSI support, disabled by default

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index dd1a6d4..7936b80 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1115,6 +1115,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			libata.dma=4	  Compact Flash DMA only 
 			Combinations also work, so libata.dma=3 enables DMA
 			for disks and CDROMs, but not CFs.
+	
+	libata.ignore_hpa=	[LIBATA] Ignore HPA limit
+			libata.ignore_hpa=0	  keep BIOS limits (default)
+			libata.ignore_hpa=1	  ignore limits, using full disk
 
 	libata.noacpi	[LIBATA] Disables use of ACPI in libata suspend/resume
 			when set.
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 958c1fa..fe3eba5 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -219,6 +219,8 @@ enum {
 	AHCI_HFLAG_SECT255		= (1 << 8), /* max 255 sectors */
 	AHCI_HFLAG_YES_NCQ		= (1 << 9), /* force NCQ cap on */
 	AHCI_HFLAG_NO_SUSPEND		= (1 << 10), /* don't suspend */
+	AHCI_HFLAG_SRST_TOUT_IS_OFFLINE	= (1 << 11), /* treat SRST timeout as
+							link offline */
 
 	/* ap->flags bits */
 
@@ -1663,6 +1665,7 @@ static int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 			     int (*check_ready)(struct ata_link *link))
 {
 	struct ata_port *ap = link->ap;
+	struct ahci_host_priv *hpriv = ap->host->private_data;
 	const char *reason = NULL;
 	unsigned long now, msecs;
 	struct ata_taskfile tf;
@@ -1701,12 +1704,21 @@ static int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 
 	/* wait for link to become ready */
 	rc = ata_wait_after_reset(link, deadline, check_ready);
-	/* link occupied, -ENODEV too is an error */
-	if (rc) {
+	if (rc == -EBUSY && hpriv->flags & AHCI_HFLAG_SRST_TOUT_IS_OFFLINE) {
+		/*
+		 * Workaround for cases where link online status can't
+		 * be trusted.  Treat device readiness timeout as link
+		 * offline.
+		 */
+		ata_link_printk(link, KERN_INFO,
+				"device not ready, treating as offline\n");
+		*class = ATA_DEV_NONE;
+	} else if (rc) {
+		/* link occupied, -ENODEV too is an error */
 		reason = "device not ready";
 		goto fail;
-	}
-	*class = ahci_dev_classify(ap);
+	} else
+		*class = ahci_dev_classify(ap);
 
 	DPRINTK("EXIT, class=%u\n", *class);
 	return 0;
@@ -1773,7 +1785,8 @@ static int ahci_sb600_softreset(struct ata_link *link, unsigned int *class,
 		irq_sts = readl(port_mmio + PORT_IRQ_STAT);
 		if (irq_sts & PORT_IRQ_BAD_PMP) {
 			ata_link_printk(link, KERN_WARNING,
-					"failed due to HW bug, retry pmp=0\n");
+					"applying SB600 PMP SRST workaround "
+					"and retrying\n");
 			rc = ahci_do_softreset(link, class, 0, deadline,
 					       ahci_check_ready);
 		}
@@ -2726,6 +2739,56 @@ static bool ahci_broken_suspend(struct pci_dev *pdev)
 	return !ver || strcmp(ver, dmi->driver_data) < 0;
 }
 
+static bool ahci_broken_online(struct pci_dev *pdev)
+{
+#define ENCODE_BUSDEVFN(bus, slot, func)			\
+	(void *)(unsigned long)(((bus) << 8) | PCI_DEVFN((slot), (func)))
+	static const struct dmi_system_id sysids[] = {
+		/*
+		 * There are several gigabyte boards which use
+		 * SIMG5723s configured as hardware RAID.  Certain
+		 * 5723 firmware revisions shipped there keep the link
+		 * online but fail to answer properly to SRST or
+		 * IDENTIFY when no device is attached downstream
+		 * causing libata to retry quite a few times leading
+		 * to excessive detection delay.
+		 *
+		 * As these firmwares respond to the second reset try
+		 * with invalid device signature, considering unknown
+		 * sig as offline works around the problem acceptably.
+		 */
+		{
+			.ident = "EP45-DQ6",
+			.matches = {
+				DMI_MATCH(DMI_BOARD_VENDOR,
+					  "Gigabyte Technology Co., Ltd."),
+				DMI_MATCH(DMI_BOARD_NAME, "EP45-DQ6"),
+			},
+			.driver_data = ENCODE_BUSDEVFN(0x0a, 0x00, 0),
+		},
+		{
+			.ident = "EP45-DS5",
+			.matches = {
+				DMI_MATCH(DMI_BOARD_VENDOR,
+					  "Gigabyte Technology Co., Ltd."),
+				DMI_MATCH(DMI_BOARD_NAME, "EP45-DS5"),
+			},
+			.driver_data = ENCODE_BUSDEVFN(0x03, 0x00, 0),
+		},
+		{ }	/* terminate list */
+	};
+#undef ENCODE_BUSDEVFN
+	const struct dmi_system_id *dmi = dmi_first_match(sysids);
+	unsigned int val;
+
+	if (!dmi)
+		return false;
+
+	val = (unsigned long)dmi->driver_data;
+
+	return pdev->bus->number == (val >> 8) && pdev->devfn == (val & 0xff);
+}
+
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
@@ -2841,6 +2904,12 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			   "BIOS update required for suspend/resume\n");
 	}
 
+	if (ahci_broken_online(pdev)) {
+		hpriv->flags |= AHCI_HFLAG_SRST_TOUT_IS_OFFLINE;
+		dev_info(&pdev->dev,
+			 "online status unreliable, applying workaround\n");
+	}
+
 	/* CAP.NP sometimes indicate the index of the last enabled
 	 * port, at other times, that of the last possible port, so
 	 * determining the maximum port number requires looking at
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 8ac98ff..072ba5e 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4302,6 +4302,9 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "WDC WD2500JD-00HBB0", "WD-WMAL71490727", ATA_HORKAGE_BROKEN_HPA },
 	{ "MAXTOR 6L080L4",	"A93.0500",	ATA_HORKAGE_BROKEN_HPA },
 
+	/* this one allows HPA unlocking but fails IOs on the area */
+	{ "OCZ-VERTEX",		    "1.30",	ATA_HORKAGE_BROKEN_HPA },
+
 	/* Devices which report 1 sector over size HPA */
 	{ "ST340823A",		NULL,		ATA_HORKAGE_HPA_SIZE, },
 	{ "ST320413A",		NULL,		ATA_HORKAGE_HPA_SIZE, },
diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
index 5702aff..41c94b1 100644
--- a/drivers/ata/pata_at91.c
+++ b/drivers/ata/pata_at91.c
@@ -250,7 +250,7 @@ static int __devinit pata_at91_probe(struct platform_device *pdev)
 		ata_port_desc(ap, "no IRQ, using PIO polling");
 	}
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	info = devm_kzalloc(dev, sizeof(*info), GFP_KERNEL);
 
 	if (!info) {
 		dev_err(dev, "failed to allocate memory for private data\n");
@@ -275,7 +275,7 @@ static int __devinit pata_at91_probe(struct platform_device *pdev)
 	if (!info->ide_addr) {
 		dev_err(dev, "failed to map IO base\n");
 		ret = -ENOMEM;
-		goto err_ide_ioremap;
+		goto err_put;
 	}
 
 	info->alt_addr = devm_ioremap(dev,
@@ -284,7 +284,7 @@ static int __devinit pata_at91_probe(struct platform_device *pdev)
 	if (!info->alt_addr) {
 		dev_err(dev, "failed to map CTL base\n");
 		ret = -ENOMEM;
-		goto err_alt_ioremap;
+		goto err_put;
 	}
 
 	ap->ioaddr.cmd_addr = info->ide_addr;
@@ -303,13 +303,8 @@ static int __devinit pata_at91_probe(struct platform_device *pdev)
 			irq ? ata_sff_interrupt : NULL,
 			irq_flags, &pata_at91_sht);
 
-err_alt_ioremap:
-	devm_iounmap(dev, info->ide_addr);
-
-err_ide_ioremap:
+err_put:
 	clk_put(info->mck);
-	kfree(info);
-
 	return ret;
 }
 
@@ -317,7 +312,6 @@ static int __devexit pata_at91_remove(struct platform_device *pdev)
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
 	struct at91_ide_info *info;
-	struct device *dev = &pdev->dev;
 
 	if (!host)
 		return 0;
@@ -328,11 +322,8 @@ static int __devexit pata_at91_remove(struct platform_device *pdev)
 	if (!info)
 		return 0;
 
-	devm_iounmap(dev, info->ide_addr);
-	devm_iounmap(dev, info->alt_addr);
 	clk_put(info->mck);
 
-	kfree(info);
 	return 0;
 }
 
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index bec0b8a..4591556 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -1,6 +1,7 @@
 /*
  * pata_atiixp.c 	- ATI PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
+ *			  (C) 2009 Bartlomiej Zolnierkiewicz
  *
  * Based on
  *
@@ -61,20 +62,19 @@ static void atiixp_set_pio_timing(struct ata_port *ap, struct ata_device *adev,
 
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	int dn = 2 * ap->port_no + adev->devno;
-
-	/* Check this is correct - the order is odd in both drivers */
 	int timing_shift = (16 * ap->port_no) + 8 * (adev->devno ^ 1);
-	u16 pio_mode_data, pio_timing_data;
+	u32 pio_timing_data;
+	u16 pio_mode_data;
 
 	pci_read_config_word(pdev, ATIIXP_IDE_PIO_MODE, &pio_mode_data);
 	pio_mode_data &= ~(0x7 << (4 * dn));
 	pio_mode_data |= pio << (4 * dn);
 	pci_write_config_word(pdev, ATIIXP_IDE_PIO_MODE, pio_mode_data);
 
-	pci_read_config_word(pdev, ATIIXP_IDE_PIO_TIMING, &pio_timing_data);
+	pci_read_config_dword(pdev, ATIIXP_IDE_PIO_TIMING, &pio_timing_data);
 	pio_timing_data &= ~(0xFF << timing_shift);
 	pio_timing_data |= (pio_timings[pio] << timing_shift);
-	pci_write_config_word(pdev, ATIIXP_IDE_PIO_TIMING, pio_timing_data);
+	pci_write_config_dword(pdev, ATIIXP_IDE_PIO_TIMING, pio_timing_data);
 }
 
 /**
@@ -119,16 +119,17 @@ static void atiixp_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 		udma_mode_data |= dma << (4 * dn);
 		pci_write_config_word(pdev, ATIIXP_IDE_UDMA_MODE, udma_mode_data);
 	} else {
-		u16 mwdma_timing_data;
-		/* Check this is correct - the order is odd in both drivers */
 		int timing_shift = (16 * ap->port_no) + 8 * (adev->devno ^ 1);
+		u32 mwdma_timing_data;
 
 		dma -= XFER_MW_DMA_0;
 
-		pci_read_config_word(pdev, ATIIXP_IDE_MWDMA_TIMING, &mwdma_timing_data);
+		pci_read_config_dword(pdev, ATIIXP_IDE_MWDMA_TIMING,
+				      &mwdma_timing_data);
 		mwdma_timing_data &= ~(0xFF << timing_shift);
 		mwdma_timing_data |= (mwdma_timings[dma] << timing_shift);
-		pci_write_config_word(pdev, ATIIXP_IDE_MWDMA_TIMING, mwdma_timing_data);
+		pci_write_config_dword(pdev, ATIIXP_IDE_MWDMA_TIMING,
+				       mwdma_timing_data);
 	}
 	/*
 	 *	We must now look at the PIO mode situation. We may need to
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index b2d11f3..86a4058 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -602,6 +602,7 @@ MODULE_VERSION(DRV_VERSION);
 
 static int adma_enabled;
 static int swncq_enabled = 1;
+static int msi_enabled;
 
 static void nv_adma_register_mode(struct ata_port *ap)
 {
@@ -2459,6 +2460,11 @@ static int nv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	} else if (type == SWNCQ)
 		nv_swncq_host_init(host);
 
+	if (msi_enabled) {
+		dev_printk(KERN_NOTICE, &pdev->dev, "Using MSI\n");
+		pci_enable_msi(pdev);
+	}
+
 	pci_set_master(pdev);
 	return ata_host_activate(host, pdev->irq, ipriv->irq_handler,
 				 IRQF_SHARED, ipriv->sht);
@@ -2558,4 +2564,6 @@ module_param_named(adma, adma_enabled, bool, 0444);
 MODULE_PARM_DESC(adma, "Enable use of ADMA (Default: false)");
 module_param_named(swncq, swncq_enabled, bool, 0444);
 MODULE_PARM_DESC(swncq, "Enable use of SWNCQ (Default: true)");
+module_param_named(msi, msi_enabled, bool, 0444);
+MODULE_PARM_DESC(msi, "Enable use of MSI (Default: false)");
 
