Return-Path: <linux-kernel-owner+w=401wt.eu-S1759565AbXGBOwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565AbXGBOwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbXGBOw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:52:27 -0400
Received: from havoc.gtf.org ([69.61.125.42]:48909 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbXGBOw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:52:26 -0400
Date: Mon, 2 Jul 2007 10:52:24 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070702145224.GA9959@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/Kconfig         |    5 ++++
 drivers/ata/libata-core.c   |    3 +-
 drivers/ata/pata_pdc2027x.c |   11 ++++++++-
 drivers/ata/pata_sis.c      |   46 +++++++++++++++++++++++++++++++++++++++++-
 drivers/ata/sata_inic162x.c |    7 ++++++
 drivers/ata/sata_nv.c       |    2 +
 drivers/ata/sata_sis.c      |   39 +++++++++++++++++------------------
 drivers/ata/sis.h           |    2 +-
 drivers/scsi/Kconfig        |    1 +
 9 files changed, 89 insertions(+), 27 deletions(-)

Albert Lee (2):
      libata: pata_pdc2027x PLL input clock fix
      libata: remove reading alt_status from ata_hsm_qc_complete()

Randy Dunlap (1):
      scsi disk help file is not complete

Robert Hancock (1):
      sata_nv: allow changing queue depth

Tejun Heo (2):
      sata_inic162x: disable LBA48 devices
      libata: add HTS541616J9SA00 to NCQ blacklist

Uwe Koziolek (1):
      libata: PATA-mode fixes for sis_sata

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index b4a8d60..4ad8675 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -16,6 +16,11 @@ menuconfig ATA
 	  that "speaks" the ATA protocol, also called ATA controller),
 	  because you will be asked for it.
 
+	  NOTE: ATA enables basic SCSI support; *however*,
+	  'SCSI disk support', 'SCSI tape support', or
+	  'SCSI CDROM support' may also be needed,
+	  depending on your hardware configuration.
+
 if ATA
 
 config ATA_NONSTANDARD
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index bfc59a1..2407f84 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3798,6 +3798,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	/* Drives which do spurious command completion */
 	{ "HTS541680J9SA00",	"SB2IC7EP",	ATA_HORKAGE_NONCQ, },
 	{ "HTS541612J9SA00",	"SBDIC7JP",	ATA_HORKAGE_NONCQ, },
+	{ "Hitachi HTS541616J9SA00", "SB4OC70P", ATA_HORKAGE_NONCQ, },
 	{ "WDC WD740ADFD-00NLR1", NULL,		ATA_HORKAGE_NONCQ, },
 
 	/* Devices with NCQ limits */
@@ -4781,8 +4782,6 @@ static void ata_hsm_qc_complete(struct ata_queued_cmd *qc, int in_wq)
 		} else
 			ata_qc_complete(qc);
 	}
-
-	ata_altstatus(ap); /* flush */
 }
 
 /**
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index 0d2cc49..69a5aa4 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -689,10 +689,12 @@ static long pdc_detect_pll_input_clock(struct ata_host *host)
 	void __iomem *mmio_base = host->iomap[PDC_MMIO_BAR];
 	u32 scr;
 	long start_count, end_count;
-	long pll_clock;
+	struct timeval start_time, end_time;
+	long pll_clock, usec_elapsed;
 
 	/* Read current counter value */
 	start_count = pdc_read_counter(host);
+	do_gettimeofday(&start_time);
 
 	/* Start the test mode */
 	scr = readl(mmio_base + PDC_SYS_CTL);
@@ -705,6 +707,7 @@ static long pdc_detect_pll_input_clock(struct ata_host *host)
 
 	/* Read the counter values again */
 	end_count = pdc_read_counter(host);
+	do_gettimeofday(&end_time);
 
 	/* Stop the test mode */
 	scr = readl(mmio_base + PDC_SYS_CTL);
@@ -713,7 +716,11 @@ static long pdc_detect_pll_input_clock(struct ata_host *host)
 	readl(mmio_base + PDC_SYS_CTL); /* flush */
 
 	/* calculate the input clock in Hz */
-	pll_clock = (start_count - end_count) * 10;
+	usec_elapsed = (end_time.tv_sec - start_time.tv_sec) * 1000000 +
+		(end_time.tv_usec - start_time.tv_usec);
+
+	pll_clock = (start_count - end_count) / 100 *
+		(100000000 / usec_elapsed);
 
 	PDPRINTK("start[%ld] end[%ld] \n", start_count, end_count);
 	PDPRINTK("PLL input clock[%ld]Hz\n", pll_clock);
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index ec3ae93..cfe4ec6 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -560,6 +560,40 @@ static const struct ata_port_operations sis_133_ops = {
 	.port_start		= ata_port_start,
 };
 
+static const struct ata_port_operations sis_133_for_sata_ops = {
+	.port_disable		= ata_port_disable,
+	.set_piomode		= sis_133_set_piomode,
+	.set_dmamode		= sis_133_set_dmamode,
+	.mode_filter		= ata_pci_default_filter,
+
+	.tf_load		= ata_tf_load,
+	.tf_read		= ata_tf_read,
+	.check_status		= ata_check_status,
+	.exec_command		= ata_exec_command,
+	.dev_select		= ata_std_dev_select,
+
+	.freeze			= ata_bmdma_freeze,
+	.thaw			= ata_bmdma_thaw,
+	.error_handler		= ata_bmdma_error_handler,
+	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= sis_133_cable_detect,
+
+	.bmdma_setup		= ata_bmdma_setup,
+	.bmdma_start		= ata_bmdma_start,
+	.bmdma_stop		= ata_bmdma_stop,
+	.bmdma_status		= ata_bmdma_status,
+	.qc_prep		= ata_qc_prep,
+	.qc_issue		= ata_qc_issue_prot,
+	.data_xfer		= ata_data_xfer,
+
+	.irq_handler		= ata_interrupt,
+	.irq_clear		= ata_bmdma_irq_clear,
+	.irq_on			= ata_irq_on,
+	.irq_ack		= ata_irq_ack,
+
+	.port_start		= ata_port_start,
+};
+
 static const struct ata_port_operations sis_133_early_ops = {
 	.port_disable		= ata_port_disable,
 	.set_piomode		= sis_100_set_piomode,
@@ -733,13 +767,20 @@ static const struct ata_port_info sis_info100_early = {
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.port_ops	= &sis_66_ops,
 };
-const struct ata_port_info sis_info133 = {
+static const struct ata_port_info sis_info133 = {
 	.sht		= &sis_sht,
 	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.udma_mask	= ATA_UDMA6,
 	.port_ops	= &sis_133_ops,
 };
+const struct ata_port_info sis_info133_for_sata = {
+	.sht		= &sis_sht,
+	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+	.pio_mask	= 0x1f,	/* pio0-4 */
+	.udma_mask	= ATA_UDMA6,
+	.port_ops	= &sis_133_for_sata_ops,
+};
 static const struct ata_port_info sis_info133_early = {
 	.sht		= &sis_sht,
 	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
@@ -749,7 +790,7 @@ static const struct ata_port_info sis_info133_early = {
 };
 
 /* Privately shared with the SiS180 SATA driver, not for use elsewhere */
-EXPORT_SYMBOL_GPL(sis_info133);
+EXPORT_SYMBOL_GPL(sis_info133_for_sata);
 
 static void sis_fixup(struct pci_dev *pdev, struct sis_chipset *sis)
 {
@@ -975,6 +1016,7 @@ static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 static const struct pci_device_id sis_pci_tbl[] = {
 	{ PCI_VDEVICE(SI, 0x5513), },	/* SiS 5513 */
 	{ PCI_VDEVICE(SI, 0x5518), },	/* SiS 5518 */
+	{ PCI_VDEVICE(SI, 0x1180), },	/* SiS 1180 */
 
 	{ }
 };
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 2d80c9d..dc3bbce 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -496,6 +496,13 @@ static void inic_dev_config(struct ata_device *dev)
 	/* inic can only handle upto LBA28 max sectors */
 	if (dev->max_sectors > ATA_MAX_SECTORS)
 		dev->max_sectors = ATA_MAX_SECTORS;
+
+	if (dev->n_sectors >= 1 << 28) {
+		ata_dev_printk(dev, KERN_ERR,
+	"ERROR: This driver doesn't support LBA48 yet and may cause\n"
+	"                data corruption on such devices.  Disabling.\n");
+		ata_dev_disable(dev);
+	}
 }
 
 static void init_port(struct ata_port *ap)
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index adfa693..d53cb8c 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -307,6 +307,7 @@ static struct scsi_host_template nv_sht = {
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
+	.change_queue_depth	= ata_scsi_change_queue_depth,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= LIBATA_MAX_PRD,
@@ -325,6 +326,7 @@ static struct scsi_host_template nv_adma_sht = {
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
+	.change_queue_depth	= ata_scsi_change_queue_depth,
 	.can_queue		= NV_ADMA_MAX_CPBS,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= NV_ADMA_SGTBL_TOTAL_LEN,
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index 221099d..f111c98 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -72,8 +72,8 @@ static const struct pci_device_id sis_pci_tbl[] = {
 	{ PCI_VDEVICE(SI, 0x0181), sis_180 },		/* SiS 964/180 */
 	{ PCI_VDEVICE(SI, 0x0182), sis_180 },		/* SiS 965/965L */
 	{ PCI_VDEVICE(SI, 0x0183), sis_180 },		/* SiS 965/965L */
-	{ PCI_VDEVICE(SI, 0x1182), sis_180 },		/* SiS 966/966L */
-	{ PCI_VDEVICE(SI, 0x1183), sis_180 },		/* SiS 966/966L */
+	{ PCI_VDEVICE(SI, 0x1182), sis_180 },		/* SiS 966/680 */
+	{ PCI_VDEVICE(SI, 0x1183), sis_180 },		/* SiS 966/966L/968/680 */
 
 	{ }	/* terminate list */
 };
@@ -161,7 +161,6 @@ static unsigned int get_scr_cfg_addr(struct ata_port *ap, unsigned int sc_reg)
 			case 0x0182:
 			case 0x0183:
 			case 0x1182:
-			case 0x1183:
 				addr += SIS182_SATA1_OFS;
 				break;
 		}
@@ -183,8 +182,8 @@ static u32 sis_scr_cfg_read (struct ata_port *ap, unsigned int sc_reg)
 
 	pci_read_config_dword(pdev, cfg_addr, &val);
 
-	if ((pdev->device == 0x0182) || (pdev->device == 0x0183) || (pdev->device == 0x1182) ||
-	    (pdev->device == 0x1183) || (pmr & SIS_PMR_COMBINED))
+	if ((pdev->device == 0x0182) || (pdev->device == 0x0183) ||
+	    (pdev->device == 0x1182) || (pmr & SIS_PMR_COMBINED))
 		pci_read_config_dword(pdev, cfg_addr+0x10, &val2);
 
 	return (val|val2) &  0xfffffffb; /* avoid problems with powerdowned ports */
@@ -203,8 +202,8 @@ static void sis_scr_cfg_write (struct ata_port *ap, unsigned int sc_reg, u32 val
 
 	pci_write_config_dword(pdev, cfg_addr, val);
 
-	if ((pdev->device == 0x0182) || (pdev->device == 0x0183) || (pdev->device == 0x1182) ||
-	    (pdev->device == 0x1183) || (pmr & SIS_PMR_COMBINED))
+	if ((pdev->device == 0x0182) || (pdev->device == 0x0183) ||
+	    (pdev->device == 0x1182) || (pmr & SIS_PMR_COMBINED))
 		pci_write_config_dword(pdev, cfg_addr+0x10, val);
 }
 
@@ -224,8 +223,8 @@ static u32 sis_scr_read (struct ata_port *ap, unsigned int sc_reg)
 
 	val = ioread32(ap->ioaddr.scr_addr + (sc_reg * 4));
 
-	if ((pdev->device == 0x0182) || (pdev->device == 0x0183) || (pdev->device == 0x1182) ||
-	    (pdev->device == 0x1183) || (pmr & SIS_PMR_COMBINED))
+	if ((pdev->device == 0x0182) || (pdev->device == 0x0183) ||
+	    (pdev->device == 0x1182) || (pmr & SIS_PMR_COMBINED))
 		val2 = ioread32(ap->ioaddr.scr_addr + (sc_reg * 4) + 0x10);
 
 	return (val | val2) &  0xfffffffb;
@@ -245,8 +244,8 @@ static void sis_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val)
 		sis_scr_cfg_write(ap, sc_reg, val);
 	else {
 		iowrite32(val, ap->ioaddr.scr_addr + (sc_reg * 4));
-		if ((pdev->device == 0x0182) || (pdev->device == 0x0183) || (pdev->device == 0x1182) ||
-		    (pdev->device == 0x1183) || (pmr & SIS_PMR_COMBINED))
+		if ((pdev->device == 0x0182) || (pdev->device == 0x0183) ||
+		    (pdev->device == 0x1182) || (pmr & SIS_PMR_COMBINED))
 			iowrite32(val, ap->ioaddr.scr_addr + (sc_reg * 4)+0x10);
 	}
 }
@@ -293,11 +292,11 @@ static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 		/* The PATA-handling is provided by pata_sis */
 		switch (pmr & 0x30) {
 		case 0x10:
-			ppi[1] = &sis_info133;
+			ppi[1] = &sis_info133_for_sata;
 			break;
 
 		case 0x30:
-			ppi[0] = &sis_info133;
+			ppi[0] = &sis_info133_for_sata;
 			break;
 		}
 		if ((pmr & SIS_PMR_COMBINED) == 0) {
@@ -324,14 +323,14 @@ static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 		break;
 
 	case 0x1182:
+		dev_printk(KERN_INFO, &pdev->dev, "Detected SiS 1182/966/680 SATA controller\n");
+		pi.flags |= ATA_FLAG_SLAVE_POSS;
+		break;
+
 	case 0x1183:
-		pci_read_config_dword(pdev, 0x64, &val);
-		if (val & 0x10000000) {
-			dev_printk(KERN_INFO, &pdev->dev, "Detected SiS 1182/1183/966L SATA controller\n");
-		} else {
-			dev_printk(KERN_INFO, &pdev->dev, "Detected SiS 1182/1183/966 SATA controller\n");
-			pi.flags |= ATA_FLAG_SLAVE_POSS;
-		}
+		dev_printk(KERN_INFO, &pdev->dev, "Detected SiS 1183/966/966L/968/680 controller in PATA mode\n");
+		ppi[0] = &sis_info133_for_sata;
+		ppi[1] = &sis_info133_for_sata;
 		break;
 	}
 
diff --git a/drivers/ata/sis.h b/drivers/ata/sis.h
index 0f2208d..f7f3eeb 100644
--- a/drivers/ata/sis.h
+++ b/drivers/ata/sis.h
@@ -2,4 +2,4 @@
 struct ata_port_info;
 
 /* pata_sis.c */
-extern const struct ata_port_info sis_info133;
+extern const struct ata_port_info sis_info133_for_sata;
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 2b2f5c1..eb46cb0 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -60,6 +60,7 @@ config BLK_DEV_SD
 	depends on SCSI
 	---help---
 	  If you want to use SCSI hard disks, Fibre Channel disks,
+	  Serial ATA (SATA) or Parallel ATA (PATA) hard disks,
 	  USB storage or the SCSI or parallel port version of
 	  the IOMEGA ZIP drive, say Y and read the SCSI-HOWTO,
 	  the Disk-HOWTO and the Multi-Disk-HOWTO, available from
