Return-Path: <linux-kernel-owner+w=401wt.eu-S1761992AbZAHVqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761992AbZAHVqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 16:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbZAHVqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 16:46:24 -0500
Received: from havoc.gtf.org ([69.61.125.42]:58392 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbZAHVqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 16:46:21 -0500
Date: Thu, 8 Jan 2009 16:46:19 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20090108214619.GA14570@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Lots of little bits.  The only notable piece is Alan's 32-bit PIO
support; but even that is small and nicely contained, thanks to the
nifty inheritance system from Tejun.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c          |   10 ++-
 drivers/ata/ata_piix.c      |   51 ++++++++----
 drivers/ata/libata-core.c   |    5 +
 drivers/ata/libata-sff.c    |  185 ++++++++++++++++++++++++++++---------------
 drivers/ata/pata_ali.c      |  107 ++++++++++++++++---------
 drivers/ata/pata_amd.c      |    4 +-
 drivers/ata/pata_hpt366.c   |  109 ++++++++++---------------
 drivers/ata/pata_hpt3x3.c   |   49 ++++++++++-
 drivers/ata/pata_mpiix.c    |    3 +-
 drivers/ata/pata_platform.c |    2 +-
 drivers/ata/pata_sil680.c   |    4 +-
 drivers/ata/sata_sil24.c    |    7 --
 include/linux/libata.h      |    3 +
 13 files changed, 336 insertions(+), 203 deletions(-)

Alan Cox (5):
      pata_hpt3x3: Workarounds for chipset
      pata_ali: force initialise a few bits
      pata_ali: Fix and workaround for FIFO DMA bug
      libata: Add 32bit PIO support
      libata: clean up the SFF code for coding style

David Daney (1):
      libata: Add special ata_pio_need_iordy() handling for Compact Flash.

Grant Grundler (1):
      sata_sil24: remove unused sil24_port_multiplier

Jeff Garzik (1):
      [libata] pata_hpt3x3: correct _freeze() function declaration

Shane Huang (2):
      [libata] ahci: Add SATA GEN3 related messages
      [libata] ahci: Withdraw IGN_SERR_INTERNAL for SB800 SATA

Sonic Zhang (1):
      pata_platform: __pata_platform_remove() shouldn't be in discard section

Tejun Heo (2):
      ata_piix: save, use saved and restore IOCFG
      pata_hpt366: reimplement mode programming

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 656448c..7f701cb 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -105,7 +105,7 @@ enum {
 	board_ahci_ign_iferr	= 2,
 	board_ahci_sb600	= 3,
 	board_ahci_mv		= 4,
-	board_ahci_sb700	= 5,
+	board_ahci_sb700	= 5, /* for SB700 and SB800 */
 	board_ahci_mcp65	= 6,
 	board_ahci_nopmp	= 7,
 
@@ -439,7 +439,7 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
-	/* board_ahci_sb700 */
+	/* board_ahci_sb700, for SB700 and SB800 */
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL),
 		.flags		= AHCI_FLAG_COMMON,
@@ -2446,6 +2446,8 @@ static void ahci_print_info(struct ata_host *host)
 		speed_s = "1.5";
 	else if (speed == 2)
 		speed_s = "3";
+	else if (speed == 3)
+		speed_s = "6";
 	else
 		speed_s = "?";
 
@@ -2610,6 +2612,10 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	    (pdev->revision == 0xa1 || pdev->revision == 0xa2))
 		hpriv->flags |= AHCI_HFLAG_NO_MSI;
 
+	/* SB800 does NOT need the workaround to ignore SERR_INTERNAL */
+	if (board_id == board_ahci_sb700 && pdev->revision >= 0x40)
+		hpriv->flags &= ~AHCI_HFLAG_IGN_SERR_INTERNAL;
+
 	if ((hpriv->flags & AHCI_HFLAG_NO_MSI) || pci_enable_msi(pdev))
 		pci_intx(pdev, 1);
 
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 5fdf167..887d8f4 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -154,11 +154,13 @@ struct piix_map_db {
 
 struct piix_host_priv {
 	const int *map;
+	u32 saved_iocfg;
 	void __iomem *sidpr;
 };
 
 static int piix_init_one(struct pci_dev *pdev,
 			 const struct pci_device_id *ent);
+static void piix_remove_one(struct pci_dev *pdev);
 static int piix_pata_prereset(struct ata_link *link, unsigned long deadline);
 static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev);
 static void piix_set_dmamode(struct ata_port *ap, struct ata_device *adev);
@@ -296,7 +298,7 @@ static struct pci_driver piix_pci_driver = {
 	.name			= DRV_NAME,
 	.id_table		= piix_pci_tbl,
 	.probe			= piix_init_one,
-	.remove			= ata_pci_remove_one,
+	.remove			= piix_remove_one,
 #ifdef CONFIG_PM
 	.suspend		= piix_pci_device_suspend,
 	.resume			= piix_pci_device_resume,
@@ -308,7 +310,7 @@ static struct scsi_host_template piix_sht = {
 };
 
 static struct ata_port_operations piix_pata_ops = {
-	.inherits		= &ata_bmdma_port_ops,
+	.inherits		= &ata_bmdma32_port_ops,
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= piix_set_piomode,
 	.set_dmamode		= piix_set_dmamode,
@@ -610,8 +612,9 @@ static const struct ich_laptop ich_laptop[] = {
 static int ich_pata_cable_detect(struct ata_port *ap)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	struct piix_host_priv *hpriv = ap->host->private_data;
 	const struct ich_laptop *lap = &ich_laptop[0];
-	u8 tmp, mask;
+	u8 mask;
 
 	/* Check for specials - Acer Aspire 5602WLMi */
 	while (lap->device) {
@@ -625,8 +628,7 @@ static int ich_pata_cable_detect(struct ata_port *ap)
 
 	/* check BIOS cable detect results */
 	mask = ap->port_no == 0 ? PIIX_80C_PRI : PIIX_80C_SEC;
-	pci_read_config_byte(pdev, PIIX_IOCFG, &tmp);
-	if ((tmp & mask) == 0)
+	if ((hpriv->saved_iocfg & mask) == 0)
 		return ATA_CBL_PATA40;
 	return ATA_CBL_PATA80;
 }
@@ -1350,7 +1352,7 @@ static int __devinit piix_init_sidpr(struct ata_host *host)
 	return 0;
 }
 
-static void piix_iocfg_bit18_quirk(struct pci_dev *pdev)
+static void piix_iocfg_bit18_quirk(struct ata_host *host)
 {
 	static const struct dmi_system_id sysids[] = {
 		{
@@ -1367,7 +1369,8 @@ static void piix_iocfg_bit18_quirk(struct pci_dev *pdev)
 
 		{ }	/* terminate list */
 	};
-	u32 iocfg;
+	struct pci_dev *pdev = to_pci_dev(host->dev);
+	struct piix_host_priv *hpriv = host->private_data;
 
 	if (!dmi_check_system(sysids))
 		return;
@@ -1376,12 +1379,11 @@ static void piix_iocfg_bit18_quirk(struct pci_dev *pdev)
 	 * seem to use it to disable a channel.  Clear the bit on the
 	 * affected systems.
 	 */
-	pci_read_config_dword(pdev, PIIX_IOCFG, &iocfg);
-	if (iocfg & (1 << 18)) {
+	if (hpriv->saved_iocfg & (1 << 18)) {
 		dev_printk(KERN_INFO, &pdev->dev,
 			   "applying IOCFG bit18 quirk\n");
-		iocfg &= ~(1 << 18);
-		pci_write_config_dword(pdev, PIIX_IOCFG, iocfg);
+		pci_write_config_dword(pdev, PIIX_IOCFG,
+				       hpriv->saved_iocfg & ~(1 << 18));
 	}
 }
 
@@ -1430,6 +1432,17 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 	if (rc)
 		return rc;
 
+	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
+	if (!hpriv)
+		return -ENOMEM;
+
+	/* Save IOCFG, this will be used for cable detection, quirk
+	 * detection and restoration on detach.  This is necessary
+	 * because some ACPI implementations mess up cable related
+	 * bits on _STM.  Reported on kernel bz#11879.
+	 */
+	pci_read_config_dword(pdev, PIIX_IOCFG, &hpriv->saved_iocfg);
+
 	/* ICH6R may be driven by either ata_piix or ahci driver
 	 * regardless of BIOS configuration.  Make sure AHCI mode is
 	 * off.
@@ -1441,10 +1454,6 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 	}
 
 	/* SATA map init can change port_info, do it before prepping host */
-	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
-	if (!hpriv)
-		return -ENOMEM;
-
 	if (port_flags & ATA_FLAG_SATA)
 		hpriv->map = piix_init_sata_map(pdev, port_info,
 					piix_map_db_table[ent->driver_data]);
@@ -1463,7 +1472,7 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 	}
 
 	/* apply IOCFG bit18 quirk */
-	piix_iocfg_bit18_quirk(pdev);
+	piix_iocfg_bit18_quirk(host);
 
 	/* On ICH5, some BIOSen disable the interrupt using the
 	 * PCI_COMMAND_INTX_DISABLE bit added in PCI 2.3.
@@ -1488,6 +1497,16 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 	return ata_pci_sff_activate_host(host, ata_sff_interrupt, &piix_sht);
 }
 
+static void piix_remove_one(struct pci_dev *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	struct piix_host_priv *hpriv = host->private_data;
+
+	pci_write_config_dword(pdev, PIIX_IOCFG, hpriv->saved_iocfg);
+
+	ata_pci_remove_one(pdev);
+}
+
 static int __init piix_init(void)
 {
 	int rc;
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index f178a45..175df54 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1007,6 +1007,7 @@ static const char *sata_spd_string(unsigned int spd)
 	static const char * const spd_str[] = {
 		"1.5 Gbps",
 		"3.0 Gbps",
+		"6.0 Gbps",
 	};
 
 	if (spd == 0 || (spd - 1) >= ARRAY_SIZE(spd_str))
@@ -2000,6 +2001,10 @@ unsigned int ata_pio_need_iordy(const struct ata_device *adev)
 	   as the caller should know this */
 	if (adev->link->ap->flags & ATA_FLAG_NO_IORDY)
 		return 0;
+	/* CF spec. r4.1 Table 22 says no iordy on PIO5 and PIO6.  */
+	if (ata_id_is_cfa(adev->id)
+	    && (adev->pio_mode == XFER_PIO_5 || adev->pio_mode == XFER_PIO_6))
+		return 0;
 	/* PIO3 and higher it is mandatory */
 	if (adev->pio_mode > XFER_PIO_2)
 		return 1;
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 9033d16..c59ad76 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -66,6 +66,7 @@ const struct ata_port_operations ata_sff_port_ops = {
 
 	.port_start		= ata_sff_port_start,
 };
+EXPORT_SYMBOL_GPL(ata_sff_port_ops);
 
 const struct ata_port_operations ata_bmdma_port_ops = {
 	.inherits		= &ata_sff_port_ops,
@@ -77,6 +78,14 @@ const struct ata_port_operations ata_bmdma_port_ops = {
 	.bmdma_stop		= ata_bmdma_stop,
 	.bmdma_status		= ata_bmdma_status,
 };
+EXPORT_SYMBOL_GPL(ata_bmdma_port_ops);
+
+const struct ata_port_operations ata_bmdma32_port_ops = {
+	.inherits		= &ata_bmdma_port_ops,
+
+	.sff_data_xfer		= ata_sff_data_xfer32,
+};
+EXPORT_SYMBOL_GPL(ata_bmdma32_port_ops);
 
 /**
  *	ata_fill_sg - Fill PCI IDE PRD table
@@ -166,8 +175,9 @@ static void ata_fill_sg_dumb(struct ata_queued_cmd *qc)
 			blen = len & 0xffff;
 			ap->prd[pi].addr = cpu_to_le32(addr);
 			if (blen == 0) {
-			   /* Some PATA chipsets like the CS5530 can't
-			      cope with 0x0000 meaning 64K as the spec says */
+				/* Some PATA chipsets like the CS5530 can't
+				   cope with 0x0000 meaning 64K as the spec
+				   says */
 				ap->prd[pi].flags_len = cpu_to_le32(0x8000);
 				blen = 0x8000;
 				ap->prd[++pi].addr = cpu_to_le32(addr + 0x8000);
@@ -200,6 +210,7 @@ void ata_sff_qc_prep(struct ata_queued_cmd *qc)
 
 	ata_fill_sg(qc);
 }
+EXPORT_SYMBOL_GPL(ata_sff_qc_prep);
 
 /**
  *	ata_sff_dumb_qc_prep - Prepare taskfile for submission
@@ -217,6 +228,7 @@ void ata_sff_dumb_qc_prep(struct ata_queued_cmd *qc)
 
 	ata_fill_sg_dumb(qc);
 }
+EXPORT_SYMBOL_GPL(ata_sff_dumb_qc_prep);
 
 /**
  *	ata_sff_check_status - Read device status reg & clear interrupt
@@ -233,6 +245,7 @@ u8 ata_sff_check_status(struct ata_port *ap)
 {
 	return ioread8(ap->ioaddr.status_addr);
 }
+EXPORT_SYMBOL_GPL(ata_sff_check_status);
 
 /**
  *	ata_sff_altstatus - Read device alternate status reg
@@ -275,7 +288,7 @@ static u8 ata_sff_irq_status(struct ata_port *ap)
 		status = ata_sff_altstatus(ap);
 		/* Not us: We are busy */
 		if (status & ATA_BUSY)
-		    	return status;
+			return status;
 	}
 	/* Clear INTRQ latch */
 	status = ap->ops->sff_check_status(ap);
@@ -319,6 +332,7 @@ void ata_sff_pause(struct ata_port *ap)
 	ata_sff_sync(ap);
 	ndelay(400);
 }
+EXPORT_SYMBOL_GPL(ata_sff_pause);
 
 /**
  *	ata_sff_dma_pause	-	Pause before commencing DMA
@@ -327,7 +341,7 @@ void ata_sff_pause(struct ata_port *ap)
  *	Perform I/O fencing and ensure sufficient cycle delays occur
  *	for the HDMA1:0 transition
  */
- 
+
 void ata_sff_dma_pause(struct ata_port *ap)
 {
 	if (ap->ops->sff_check_altstatus || ap->ioaddr.altstatus_addr) {
@@ -341,6 +355,7 @@ void ata_sff_dma_pause(struct ata_port *ap)
 	   corruption. */
 	BUG();
 }
+EXPORT_SYMBOL_GPL(ata_sff_dma_pause);
 
 /**
  *	ata_sff_busy_sleep - sleep until BSY clears, or timeout
@@ -396,6 +411,7 @@ int ata_sff_busy_sleep(struct ata_port *ap,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ata_sff_busy_sleep);
 
 static int ata_sff_check_ready(struct ata_link *link)
 {
@@ -422,6 +438,7 @@ int ata_sff_wait_ready(struct ata_link *link, unsigned long deadline)
 {
 	return ata_wait_ready(link, deadline, ata_sff_check_ready);
 }
+EXPORT_SYMBOL_GPL(ata_sff_wait_ready);
 
 /**
  *	ata_sff_dev_select - Select device 0/1 on ATA bus
@@ -449,6 +466,7 @@ void ata_sff_dev_select(struct ata_port *ap, unsigned int device)
 	iowrite8(tmp, ap->ioaddr.device_addr);
 	ata_sff_pause(ap);	/* needed; also flushes, for mmio */
 }
+EXPORT_SYMBOL_GPL(ata_sff_dev_select);
 
 /**
  *	ata_dev_select - Select device 0/1 on ATA bus
@@ -513,6 +531,7 @@ u8 ata_sff_irq_on(struct ata_port *ap)
 
 	return tmp;
 }
+EXPORT_SYMBOL_GPL(ata_sff_irq_on);
 
 /**
  *	ata_sff_irq_clear - Clear PCI IDE BMDMA interrupt.
@@ -534,6 +553,7 @@ void ata_sff_irq_clear(struct ata_port *ap)
 
 	iowrite8(ioread8(mmio + ATA_DMA_STATUS), mmio + ATA_DMA_STATUS);
 }
+EXPORT_SYMBOL_GPL(ata_sff_irq_clear);
 
 /**
  *	ata_sff_tf_load - send taskfile registers to host controller
@@ -593,6 +613,7 @@ void ata_sff_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
 
 	ata_wait_idle(ap);
 }
+EXPORT_SYMBOL_GPL(ata_sff_tf_load);
 
 /**
  *	ata_sff_tf_read - input device's ATA taskfile shadow registers
@@ -633,6 +654,7 @@ void ata_sff_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
 			WARN_ON(1);
 	}
 }
+EXPORT_SYMBOL_GPL(ata_sff_tf_read);
 
 /**
  *	ata_sff_exec_command - issue ATA command to host controller
@@ -652,6 +674,7 @@ void ata_sff_exec_command(struct ata_port *ap, const struct ata_taskfile *tf)
 	iowrite8(tf->command, ap->ioaddr.command_addr);
 	ata_sff_pause(ap);
 }
+EXPORT_SYMBOL_GPL(ata_sff_exec_command);
 
 /**
  *	ata_tf_to_host - issue ATA taskfile to host controller
@@ -717,6 +740,53 @@ unsigned int ata_sff_data_xfer(struct ata_device *dev, unsigned char *buf,
 
 	return words << 1;
 }
+EXPORT_SYMBOL_GPL(ata_sff_data_xfer);
+
+/**
+ *	ata_sff_data_xfer32 - Transfer data by PIO
+ *	@dev: device to target
+ *	@buf: data buffer
+ *	@buflen: buffer length
+ *	@rw: read/write
+ *
+ *	Transfer data from/to the device data register by PIO using 32bit
+ *	I/O operations.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ *
+ *	RETURNS:
+ *	Bytes consumed.
+ */
+
+unsigned int ata_sff_data_xfer32(struct ata_device *dev, unsigned char *buf,
+			       unsigned int buflen, int rw)
+{
+	struct ata_port *ap = dev->link->ap;
+	void __iomem *data_addr = ap->ioaddr.data_addr;
+	unsigned int words = buflen >> 2;
+	int slop = buflen & 3;
+
+	/* Transfer multiple of 4 bytes */
+	if (rw == READ)
+		ioread32_rep(data_addr, buf, words);
+	else
+		iowrite32_rep(data_addr, buf, words);
+
+	if (unlikely(slop)) {
+		__le32 pad;
+		if (rw == READ) {
+			pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
+			memcpy(buf + buflen - slop, &pad, slop);
+		} else {
+			memcpy(&pad, buf + buflen - slop, slop);
+			iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
+		}
+		words++;
+	}
+	return words << 2;
+}
+EXPORT_SYMBOL_GPL(ata_sff_data_xfer32);
 
 /**
  *	ata_sff_data_xfer_noirq - Transfer data by PIO
@@ -746,6 +816,7 @@ unsigned int ata_sff_data_xfer_noirq(struct ata_device *dev, unsigned char *buf,
 
 	return consumed;
 }
+EXPORT_SYMBOL_GPL(ata_sff_data_xfer_noirq);
 
 /**
  *	ata_pio_sector - Transfer a sector of data.
@@ -922,13 +993,15 @@ next_sg:
 		buf = kmap_atomic(page, KM_IRQ0);
 
 		/* do the actual data transfer */
-		consumed = ap->ops->sff_data_xfer(dev,  buf + offset, count, rw);
+		consumed = ap->ops->sff_data_xfer(dev,  buf + offset,
+								count, rw);
 
 		kunmap_atomic(buf, KM_IRQ0);
 		local_irq_restore(flags);
 	} else {
 		buf = page_address(page);
-		consumed = ap->ops->sff_data_xfer(dev,  buf + offset, count, rw);
+		consumed = ap->ops->sff_data_xfer(dev,  buf + offset,
+								count, rw);
 	}
 
 	bytes -= min(bytes, consumed);
@@ -1013,18 +1086,19 @@ static void atapi_pio_bytes(struct ata_queued_cmd *qc)
  *	RETURNS:
  *	1 if ok in workqueue, 0 otherwise.
  */
-static inline int ata_hsm_ok_in_wq(struct ata_port *ap, struct ata_queued_cmd *qc)
+static inline int ata_hsm_ok_in_wq(struct ata_port *ap,
+						struct ata_queued_cmd *qc)
 {
 	if (qc->tf.flags & ATA_TFLAG_POLLING)
 		return 1;
 
 	if (ap->hsm_task_state == HSM_ST_FIRST) {
 		if (qc->tf.protocol == ATA_PROT_PIO &&
-		    (qc->tf.flags & ATA_TFLAG_WRITE))
+		   (qc->tf.flags & ATA_TFLAG_WRITE))
 		    return 1;
 
 		if (ata_is_atapi(qc->tf.protocol) &&
-		    !(qc->dev->flags & ATA_DFLAG_CDB_INTR))
+		   !(qc->dev->flags & ATA_DFLAG_CDB_INTR))
 			return 1;
 	}
 
@@ -1338,6 +1412,7 @@ fsm_start:
 
 	return poll_next;
 }
+EXPORT_SYMBOL_GPL(ata_sff_hsm_move);
 
 void ata_pio_task(struct work_struct *work)
 {
@@ -1507,6 +1582,7 @@ unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ata_sff_qc_issue);
 
 /**
  *	ata_sff_qc_fill_rtf - fill result TF using ->sff_tf_read
@@ -1526,6 +1602,7 @@ bool ata_sff_qc_fill_rtf(struct ata_queued_cmd *qc)
 	qc->ap->ops->sff_tf_read(qc->ap, &qc->result_tf);
 	return true;
 }
+EXPORT_SYMBOL_GPL(ata_sff_qc_fill_rtf);
 
 /**
  *	ata_sff_host_intr - Handle host interrupt for given (port, task)
@@ -1623,6 +1700,7 @@ idle_irq:
 #endif
 	return 0;	/* irq not handled */
 }
+EXPORT_SYMBOL_GPL(ata_sff_host_intr);
 
 /**
  *	ata_sff_interrupt - Default ATA host interrupt handler
@@ -1667,6 +1745,7 @@ irqreturn_t ata_sff_interrupt(int irq, void *dev_instance)
 
 	return IRQ_RETVAL(handled);
 }
+EXPORT_SYMBOL_GPL(ata_sff_interrupt);
 
 /**
  *	ata_sff_freeze - Freeze SFF controller port
@@ -1695,6 +1774,7 @@ void ata_sff_freeze(struct ata_port *ap)
 
 	ap->ops->sff_irq_clear(ap);
 }
+EXPORT_SYMBOL_GPL(ata_sff_freeze);
 
 /**
  *	ata_sff_thaw - Thaw SFF controller port
@@ -1712,6 +1792,7 @@ void ata_sff_thaw(struct ata_port *ap)
 	ap->ops->sff_irq_clear(ap);
 	ap->ops->sff_irq_on(ap);
 }
+EXPORT_SYMBOL_GPL(ata_sff_thaw);
 
 /**
  *	ata_sff_prereset - prepare SFF link for reset
@@ -1753,6 +1834,7 @@ int ata_sff_prereset(struct ata_link *link, unsigned long deadline)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ata_sff_prereset);
 
 /**
  *	ata_devchk - PATA device presence detection
@@ -1865,6 +1947,7 @@ unsigned int ata_sff_dev_classify(struct ata_device *dev, int present,
 
 	return class;
 }
+EXPORT_SYMBOL_GPL(ata_sff_dev_classify);
 
 /**
  *	ata_sff_wait_after_reset - wait for devices to become ready after reset
@@ -1941,6 +2024,7 @@ int ata_sff_wait_after_reset(struct ata_link *link, unsigned int devmask,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ata_sff_wait_after_reset);
 
 static int ata_bus_softreset(struct ata_port *ap, unsigned int devmask,
 			     unsigned long deadline)
@@ -2013,6 +2097,7 @@ int ata_sff_softreset(struct ata_link *link, unsigned int *classes,
 	DPRINTK("EXIT, classes[0]=%u [1]=%u\n", classes[0], classes[1]);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ata_sff_softreset);
 
 /**
  *	sata_sff_hardreset - reset host port via SATA phy reset
@@ -2045,6 +2130,7 @@ int sata_sff_hardreset(struct ata_link *link, unsigned int *class,
 	DPRINTK("EXIT, class=%u\n", *class);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(sata_sff_hardreset);
 
 /**
  *	ata_sff_postreset - SFF postreset callback
@@ -2080,6 +2166,7 @@ void ata_sff_postreset(struct ata_link *link, unsigned int *classes)
 	if (ap->ioaddr.ctl_addr)
 		iowrite8(ap->ctl, ap->ioaddr.ctl_addr);
 }
+EXPORT_SYMBOL_GPL(ata_sff_postreset);
 
 /**
  *	ata_sff_error_handler - Stock error handler for BMDMA controller
@@ -2152,6 +2239,7 @@ void ata_sff_error_handler(struct ata_port *ap)
 	ata_do_eh(ap, ap->ops->prereset, softreset, hardreset,
 		  ap->ops->postreset);
 }
+EXPORT_SYMBOL_GPL(ata_sff_error_handler);
 
 /**
  *	ata_sff_post_internal_cmd - Stock post_internal_cmd for SFF controller
@@ -2174,6 +2262,7 @@ void ata_sff_post_internal_cmd(struct ata_queued_cmd *qc)
 
 	spin_unlock_irqrestore(ap->lock, flags);
 }
+EXPORT_SYMBOL_GPL(ata_sff_post_internal_cmd);
 
 /**
  *	ata_sff_port_start - Set port up for dma.
@@ -2194,6 +2283,7 @@ int ata_sff_port_start(struct ata_port *ap)
 		return ata_port_start(ap);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ata_sff_port_start);
 
 /**
  *	ata_sff_std_ports - initialize ioaddr with standard port offsets.
@@ -2219,6 +2309,7 @@ void ata_sff_std_ports(struct ata_ioports *ioaddr)
 	ioaddr->status_addr = ioaddr->cmd_addr + ATA_REG_STATUS;
 	ioaddr->command_addr = ioaddr->cmd_addr + ATA_REG_CMD;
 }
+EXPORT_SYMBOL_GPL(ata_sff_std_ports);
 
 unsigned long ata_bmdma_mode_filter(struct ata_device *adev,
 				    unsigned long xfer_mask)
@@ -2230,6 +2321,7 @@ unsigned long ata_bmdma_mode_filter(struct ata_device *adev,
 		xfer_mask &= ~(ATA_MASK_MWDMA | ATA_MASK_UDMA);
 	return xfer_mask;
 }
+EXPORT_SYMBOL_GPL(ata_bmdma_mode_filter);
 
 /**
  *	ata_bmdma_setup - Set up PCI IDE BMDMA transaction
@@ -2258,6 +2350,7 @@ void ata_bmdma_setup(struct ata_queued_cmd *qc)
 	/* issue r/w command */
 	ap->ops->sff_exec_command(ap, &qc->tf);
 }
+EXPORT_SYMBOL_GPL(ata_bmdma_setup);
 
 /**
  *	ata_bmdma_start - Start a PCI IDE BMDMA transaction
@@ -2290,6 +2383,7 @@ void ata_bmdma_start(struct ata_queued_cmd *qc)
 	 * unneccessarily delayed for MMIO
 	 */
 }
+EXPORT_SYMBOL_GPL(ata_bmdma_start);
 
 /**
  *	ata_bmdma_stop - Stop PCI IDE BMDMA transfer
@@ -2314,6 +2408,7 @@ void ata_bmdma_stop(struct ata_queued_cmd *qc)
 	/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
 	ata_sff_dma_pause(ap);
 }
+EXPORT_SYMBOL_GPL(ata_bmdma_stop);
 
 /**
  *	ata_bmdma_status - Read PCI IDE BMDMA status
@@ -2330,6 +2425,7 @@ u8 ata_bmdma_status(struct ata_port *ap)
 {
 	return ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
 }
+EXPORT_SYMBOL_GPL(ata_bmdma_status);
 
 /**
  *	ata_bus_reset - reset host port and associated ATA channel
@@ -2422,6 +2518,7 @@ err_out:
 
 	DPRINTK("EXIT\n");
 }
+EXPORT_SYMBOL_GPL(ata_bus_reset);
 
 #ifdef CONFIG_PCI
 
@@ -2449,6 +2546,7 @@ int ata_pci_bmdma_clear_simplex(struct pci_dev *pdev)
 		return -EOPNOTSUPP;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ata_pci_bmdma_clear_simplex);
 
 /**
  *	ata_pci_bmdma_init - acquire PCI BMDMA resources and init ATA host
@@ -2501,11 +2599,12 @@ int ata_pci_bmdma_init(struct ata_host *host)
 			host->flags |= ATA_HOST_SIMPLEX;
 
 		ata_port_desc(ap, "bmdma 0x%llx",
-			(unsigned long long)pci_resource_start(pdev, 4) + 8 * i);
+		    (unsigned long long)pci_resource_start(pdev, 4) + 8 * i);
 	}
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ata_pci_bmdma_init);
 
 static int ata_resources_present(struct pci_dev *pdev, int port)
 {
@@ -2513,7 +2612,7 @@ static int ata_resources_present(struct pci_dev *pdev, int port)
 
 	/* Check the PCI resources for this channel are enabled */
 	port = port * 2;
-	for (i = 0; i < 2; i ++) {
+	for (i = 0; i < 2; i++) {
 		if (pci_resource_start(pdev, port + i) == 0 ||
 		    pci_resource_len(pdev, port + i) == 0)
 			return 0;
@@ -2598,6 +2697,7 @@ int ata_pci_sff_init_host(struct ata_host *host)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ata_pci_sff_init_host);
 
 /**
  *	ata_pci_sff_prepare_host - helper to prepare native PCI ATA host
@@ -2615,7 +2715,7 @@ int ata_pci_sff_init_host(struct ata_host *host)
  *	0 on success, -errno otherwise.
  */
 int ata_pci_sff_prepare_host(struct pci_dev *pdev,
-			     const struct ata_port_info * const * ppi,
+			     const struct ata_port_info * const *ppi,
 			     struct ata_host **r_host)
 {
 	struct ata_host *host;
@@ -2645,17 +2745,18 @@ int ata_pci_sff_prepare_host(struct pci_dev *pdev,
 	*r_host = host;
 	return 0;
 
- err_bmdma:
+err_bmdma:
 	/* This is necessary because PCI and iomap resources are
 	 * merged and releasing the top group won't release the
 	 * acquired resources if some of those have been acquired
 	 * before entering this function.
 	 */
 	pcim_iounmap_regions(pdev, 0xf);
- err_out:
+err_out:
 	devres_release_group(&pdev->dev, NULL);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(ata_pci_sff_prepare_host);
 
 /**
  *	ata_pci_sff_activate_host - start SFF host, request IRQ and register it
@@ -2741,7 +2842,7 @@ int ata_pci_sff_activate_host(struct ata_host *host,
 	}
 
 	rc = ata_host_register(host, sht);
- out:
+out:
 	if (rc == 0)
 		devres_remove_group(dev, NULL);
 	else
@@ -2749,6 +2850,7 @@ int ata_pci_sff_activate_host(struct ata_host *host,
 
 	return rc;
 }
+EXPORT_SYMBOL_GPL(ata_pci_sff_activate_host);
 
 /**
  *	ata_pci_sff_init_one - Initialize/register PCI IDE host controller
@@ -2776,7 +2878,7 @@ int ata_pci_sff_activate_host(struct ata_host *host,
  *	Zero on success, negative on errno-based value on error.
  */
 int ata_pci_sff_init_one(struct pci_dev *pdev,
-			 const struct ata_port_info * const * ppi,
+			 const struct ata_port_info * const *ppi,
 			 struct scsi_host_template *sht, void *host_priv)
 {
 	struct device *dev = &pdev->dev;
@@ -2815,7 +2917,7 @@ int ata_pci_sff_init_one(struct pci_dev *pdev,
 
 	pci_set_master(pdev);
 	rc = ata_pci_sff_activate_host(host, ata_sff_interrupt, sht);
- out:
+out:
 	if (rc == 0)
 		devres_remove_group(&pdev->dev, NULL);
 	else
@@ -2823,54 +2925,7 @@ int ata_pci_sff_init_one(struct pci_dev *pdev,
 
 	return rc;
 }
+EXPORT_SYMBOL_GPL(ata_pci_sff_init_one);
 
 #endif /* CONFIG_PCI */
 
-EXPORT_SYMBOL_GPL(ata_sff_port_ops);
-EXPORT_SYMBOL_GPL(ata_bmdma_port_ops);
-EXPORT_SYMBOL_GPL(ata_sff_qc_prep);
-EXPORT_SYMBOL_GPL(ata_sff_dumb_qc_prep);
-EXPORT_SYMBOL_GPL(ata_sff_dev_select);
-EXPORT_SYMBOL_GPL(ata_sff_check_status);
-EXPORT_SYMBOL_GPL(ata_sff_dma_pause);
-EXPORT_SYMBOL_GPL(ata_sff_pause);
-EXPORT_SYMBOL_GPL(ata_sff_busy_sleep);
-EXPORT_SYMBOL_GPL(ata_sff_wait_ready);
-EXPORT_SYMBOL_GPL(ata_sff_tf_load);
-EXPORT_SYMBOL_GPL(ata_sff_tf_read);
-EXPORT_SYMBOL_GPL(ata_sff_exec_command);
-EXPORT_SYMBOL_GPL(ata_sff_data_xfer);
-EXPORT_SYMBOL_GPL(ata_sff_data_xfer_noirq);
-EXPORT_SYMBOL_GPL(ata_sff_irq_on);
-EXPORT_SYMBOL_GPL(ata_sff_irq_clear);
-EXPORT_SYMBOL_GPL(ata_sff_hsm_move);
-EXPORT_SYMBOL_GPL(ata_sff_qc_issue);
-EXPORT_SYMBOL_GPL(ata_sff_qc_fill_rtf);
-EXPORT_SYMBOL_GPL(ata_sff_host_intr);
-EXPORT_SYMBOL_GPL(ata_sff_interrupt);
-EXPORT_SYMBOL_GPL(ata_sff_freeze);
-EXPORT_SYMBOL_GPL(ata_sff_thaw);
-EXPORT_SYMBOL_GPL(ata_sff_prereset);
-EXPORT_SYMBOL_GPL(ata_sff_dev_classify);
-EXPORT_SYMBOL_GPL(ata_sff_wait_after_reset);
-EXPORT_SYMBOL_GPL(ata_sff_softreset);
-EXPORT_SYMBOL_GPL(sata_sff_hardreset);
-EXPORT_SYMBOL_GPL(ata_sff_postreset);
-EXPORT_SYMBOL_GPL(ata_sff_error_handler);
-EXPORT_SYMBOL_GPL(ata_sff_post_internal_cmd);
-EXPORT_SYMBOL_GPL(ata_sff_port_start);
-EXPORT_SYMBOL_GPL(ata_sff_std_ports);
-EXPORT_SYMBOL_GPL(ata_bmdma_mode_filter);
-EXPORT_SYMBOL_GPL(ata_bmdma_setup);
-EXPORT_SYMBOL_GPL(ata_bmdma_start);
-EXPORT_SYMBOL_GPL(ata_bmdma_stop);
-EXPORT_SYMBOL_GPL(ata_bmdma_status);
-EXPORT_SYMBOL_GPL(ata_bus_reset);
-#ifdef CONFIG_PCI
-EXPORT_SYMBOL_GPL(ata_pci_bmdma_clear_simplex);
-EXPORT_SYMBOL_GPL(ata_pci_bmdma_init);
-EXPORT_SYMBOL_GPL(ata_pci_sff_init_host);
-EXPORT_SYMBOL_GPL(ata_pci_sff_prepare_host);
-EXPORT_SYMBOL_GPL(ata_pci_sff_activate_host);
-EXPORT_SYMBOL_GPL(ata_pci_sff_init_one);
-#endif /* CONFIG_PCI */
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 73c466e..a7999c1 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -19,7 +19,9 @@
  *
  *  TODO/CHECK
  *	Cannot have ATAPI on both master & slave for rev < c2 (???) but
- *	otherwise should do atapi DMA.
+ *	otherwise should do atapi DMA (For now for old we do PIO only for
+ *	ATAPI)
+ *	Review Sunblade workaround.
  */
 
 #include <linux/kernel.h>
@@ -33,12 +35,14 @@
 #include <linux/dmi.h>
 
 #define DRV_NAME "pata_ali"
-#define DRV_VERSION "0.7.5"
+#define DRV_VERSION "0.7.8"
 
 static int ali_atapi_dma = 0;
 module_param_named(atapi_dma, ali_atapi_dma, int, 0644);
 MODULE_PARM_DESC(atapi_dma, "Enable ATAPI DMA (0=disable, 1=enable)");
 
+static struct pci_dev *isa_bridge;
+
 /*
  *	Cable special cases
  */
@@ -147,8 +151,7 @@ static void ali_fifo_control(struct ata_port *ap, struct ata_device *adev, int o
 
 	pci_read_config_byte(pdev, pio_fifo, &fifo);
 	fifo &= ~(0x0F << shift);
-	if (on)
-		fifo |= (on << shift);
+	fifo |= (on << shift);
 	pci_write_config_byte(pdev, pio_fifo, fifo);
 }
 
@@ -337,6 +340,23 @@ static int ali_check_atapi_dma(struct ata_queued_cmd *qc)
 	return 0;
 }
 
+static void ali_c2_c3_postreset(struct ata_link *link, unsigned int *classes)
+{
+	u8 r;
+	int port_bit = 4 << link->ap->port_no;
+
+	/* If our bridge is an ALI 1533 then do the extra work */
+	if (isa_bridge) {
+		/* Tristate and re-enable the bus signals */
+		pci_read_config_byte(isa_bridge, 0x58, &r);
+		r &= ~port_bit;
+		pci_write_config_byte(isa_bridge, 0x58, r);
+		r |= port_bit;
+		pci_write_config_byte(isa_bridge, 0x58, r);
+	}
+	ata_sff_postreset(link, classes);
+}
+
 static struct scsi_host_template ali_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
@@ -349,10 +369,11 @@ static struct ata_port_operations ali_early_port_ops = {
 	.inherits	= &ata_sff_port_ops,
 	.cable_detect	= ata_cable_40wire,
 	.set_piomode	= ali_set_piomode,
+	.sff_data_xfer  = ata_sff_data_xfer32,
 };
 
 static const struct ata_port_operations ali_dma_base_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits	= &ata_bmdma32_port_ops,
 	.set_piomode	= ali_set_piomode,
 	.set_dmamode	= ali_set_dmamode,
 };
@@ -377,6 +398,17 @@ static struct ata_port_operations ali_c2_port_ops = {
 	.check_atapi_dma = ali_check_atapi_dma,
 	.cable_detect	= ali_c2_cable_detect,
 	.dev_config	= ali_lock_sectors,
+	.postreset	= ali_c2_c3_postreset,
+};
+
+/*
+ *	Port operations for DMA capable ALi with cable detect
+ */
+static struct ata_port_operations ali_c4_port_ops = {
+	.inherits	= &ali_dma_base_ops,
+	.check_atapi_dma = ali_check_atapi_dma,
+	.cable_detect	= ali_c2_cable_detect,
+	.dev_config	= ali_lock_sectors,
 };
 
 /*
@@ -401,52 +433,49 @@ static struct ata_port_operations ali_c5_port_ops = {
 static void ali_init_chipset(struct pci_dev *pdev)
 {
 	u8 tmp;
-	struct pci_dev *north, *isa_bridge;
+	struct pci_dev *north;
 
 	/*
 	 * The chipset revision selects the driver operations and
 	 * mode data.
 	 */
 
-	if (pdev->revision >= 0x20 && pdev->revision < 0xC2) {
-		/* 1543-E/F, 1543C-C, 1543C-D, 1543C-E */
-		pci_read_config_byte(pdev, 0x4B, &tmp);
-		/* Clear CD-ROM DMA write bit */
-		tmp &= 0x7F;
-		pci_write_config_byte(pdev, 0x4B, tmp);
-	} else if (pdev->revision >= 0xC2) {
-		/* Enable cable detection logic */
+	if (pdev->revision <= 0x20) {
+		pci_read_config_byte(pdev, 0x53, &tmp);
+		tmp |= 0x03;
+		pci_write_config_byte(pdev, 0x53, tmp);
+	} else {
+		pci_read_config_byte(pdev, 0x4a, &tmp);
+		pci_write_config_byte(pdev, 0x4a, tmp | 0x20);
 		pci_read_config_byte(pdev, 0x4B, &tmp);
-		pci_write_config_byte(pdev, 0x4B, tmp | 0x08);
-	}
-	north = pci_get_bus_and_slot(0, PCI_DEVFN(0,0));
-	isa_bridge = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533, NULL);
-
-	if (north && north->vendor == PCI_VENDOR_ID_AL && isa_bridge) {
-		/* Configure the ALi bridge logic. For non ALi rely on BIOS.
-		   Set the south bridge enable bit */
-		pci_read_config_byte(isa_bridge, 0x79, &tmp);
-		if (pdev->revision == 0xC2)
-			pci_write_config_byte(isa_bridge, 0x79, tmp | 0x04);
-		else if (pdev->revision > 0xC2 && pdev->revision < 0xC5)
-			pci_write_config_byte(isa_bridge, 0x79, tmp | 0x02);
-	}
-	if (pdev->revision >= 0x20) {
+		if (pdev->revision < 0xC2)
+			/* 1543-E/F, 1543C-C, 1543C-D, 1543C-E */
+			/* Clear CD-ROM DMA write bit */
+			tmp &= 0x7F;
+		/* Cable and UDMA */
+		pci_write_config_byte(pdev, 0x4B, tmp | 0x09);
 		/*
 		 * CD_ROM DMA on (0x53 bit 0). Enable this even if we want
 		 * to use PIO. 0x53 bit 1 (rev 20 only) - enable FIFO control
 		 * via 0x54/55.
 		 */
 		pci_read_config_byte(pdev, 0x53, &tmp);
-		if (pdev->revision <= 0x20)
-			tmp &= ~0x02;
 		if (pdev->revision >= 0xc7)
 			tmp |= 0x03;
 		else
 			tmp |= 0x01;	/* CD_ROM enable for DMA */
 		pci_write_config_byte(pdev, 0x53, tmp);
 	}
-	pci_dev_put(isa_bridge);
+	north = pci_get_bus_and_slot(0, PCI_DEVFN(0,0));
+	if (north && north->vendor == PCI_VENDOR_ID_AL && isa_bridge) {
+		/* Configure the ALi bridge logic. For non ALi rely on BIOS.
+		   Set the south bridge enable bit */
+		pci_read_config_byte(isa_bridge, 0x79, &tmp);
+		if (pdev->revision == 0xC2)
+			pci_write_config_byte(isa_bridge, 0x79, tmp | 0x04);
+		else if (pdev->revision > 0xC2 && pdev->revision < 0xC5)
+			pci_write_config_byte(isa_bridge, 0x79, tmp | 0x02);
+	}
 	pci_dev_put(north);
 	ata_pci_bmdma_clear_simplex(pdev);
 }
@@ -503,7 +532,7 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = ATA_UDMA5,
-		.port_ops = &ali_c2_port_ops
+		.port_ops = &ali_c4_port_ops
 	};
 	/* Revision 0xC5 is UDMA133 with LBA48 DMA */
 	static const struct ata_port_info info_c5 = {
@@ -516,7 +545,6 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	const struct ata_port_info *ppi[] = { NULL, NULL };
 	u8 tmp;
-	struct pci_dev *isa_bridge;
 	int rc;
 
 	rc = pcim_enable_device(pdev);
@@ -543,14 +571,12 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ali_init_chipset(pdev);
 
-	isa_bridge = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533, NULL);
 	if (isa_bridge && pdev->revision >= 0x20 && pdev->revision < 0xC2) {
 		/* Are we paired with a UDMA capable chip */
 		pci_read_config_byte(isa_bridge, 0x5E, &tmp);
 		if ((tmp & 0x1E) == 0x12)
 	        	ppi[0] = &info_20_udma;
 	}
-	pci_dev_put(isa_bridge);
 
 	return ata_pci_sff_init_one(pdev, ppi, &ali_sht, NULL);
 }
@@ -590,13 +616,20 @@ static struct pci_driver ali_pci_driver = {
 
 static int __init ali_init(void)
 {
-	return pci_register_driver(&ali_pci_driver);
+	int ret;
+	isa_bridge = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533, NULL);
+
+	ret = pci_register_driver(&ali_pci_driver);
+	if (ret < 0)
+		pci_dev_put(isa_bridge);
+	return ret;
 }
 
 
 static void __exit ali_exit(void)
 {
 	pci_unregister_driver(&ali_pci_driver);
+	pci_dev_put(isa_bridge);
 }
 
 
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 0ec9c7d..63719ab 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -24,7 +24,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_amd"
-#define DRV_VERSION "0.3.10"
+#define DRV_VERSION "0.3.11"
 
 /**
  *	timing_setup		-	shared timing computation and load
@@ -345,7 +345,7 @@ static struct scsi_host_template amd_sht = {
 };
 
 static const struct ata_port_operations amd_base_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits	= &ata_bmdma32_port_ops,
 	.prereset	= amd_pre_reset,
 };
 
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index e0c4f05..65c28e5 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -30,7 +30,7 @@
 #define DRV_VERSION	"0.6.2"
 
 struct hpt_clock {
-	u8	xfer_speed;
+	u8	xfer_mode;
 	u32	timing;
 };
 
@@ -189,28 +189,6 @@ static unsigned long hpt366_filter(struct ata_device *adev, unsigned long mask)
 	return ata_bmdma_mode_filter(adev, mask);
 }
 
-/**
- *	hpt36x_find_mode	-	reset the hpt36x bus
- *	@ap: ATA port
- *	@speed: transfer mode
- *
- *	Return the 32bit register programming information for this channel
- *	that matches the speed provided.
- */
-
-static u32 hpt36x_find_mode(struct ata_port *ap, int speed)
-{
-	struct hpt_clock *clocks = ap->host->private_data;
-
-	while(clocks->xfer_speed) {
-		if (clocks->xfer_speed == speed)
-			return clocks->timing;
-		clocks++;
-	}
-	BUG();
-	return 0xffffffffU;	/* silence compiler warning */
-}
-
 static int hpt36x_cable_detect(struct ata_port *ap)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
@@ -226,25 +204,16 @@ static int hpt36x_cable_detect(struct ata_port *ap)
 	return ATA_CBL_PATA80;
 }
 
-/**
- *	hpt366_set_piomode		-	PIO setup
- *	@ap: ATA interface
- *	@adev: device on the interface
- *
- *	Perform PIO mode setup.
- */
-
-static void hpt366_set_piomode(struct ata_port *ap, struct ata_device *adev)
+static void hpt366_set_mode(struct ata_port *ap, struct ata_device *adev,
+			    u8 mode)
 {
+	struct hpt_clock *clocks = ap->host->private_data;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u32 addr1, addr2;
-	u32 reg;
-	u32 mode;
+	u32 addr1 = 0x40 + 4 * (adev->devno + 2 * ap->port_no);
+	u32 addr2 = 0x51 + 4 * ap->port_no;
+	u32 mask, reg;
 	u8 fast;
 
-	addr1 = 0x40 + 4 * (adev->devno + 2 * ap->port_no);
-	addr2 = 0x51 + 4 * ap->port_no;
-
 	/* Fast interrupt prediction disable, hold off interrupt disable */
 	pci_read_config_byte(pdev, addr2, &fast);
 	if (fast & 0x80) {
@@ -252,12 +221,43 @@ static void hpt366_set_piomode(struct ata_port *ap, struct ata_device *adev)
 		pci_write_config_byte(pdev, addr2, fast);
 	}
 
+	/* determine timing mask and find matching clock entry */
+	if (mode < XFER_MW_DMA_0)
+		mask = 0xc1f8ffff;
+	else if (mode < XFER_UDMA_0)
+		mask = 0x303800ff;
+	else
+		mask = 0x30070000;
+
+	while (clocks->xfer_mode) {
+		if (clocks->xfer_mode == mode)
+			break;
+		clocks++;
+	}
+	if (!clocks->xfer_mode)
+		BUG();
+
+	/*
+	 * Combine new mode bits with old config bits and disable
+	 * on-chip PIO FIFO/buffer (and PIO MST mode as well) to avoid
+	 * problems handling I/O errors later.
+	 */
 	pci_read_config_dword(pdev, addr1, &reg);
-	mode = hpt36x_find_mode(ap, adev->pio_mode);
-	mode &= ~0x8000000;	/* No FIFO in PIO */
-	mode &= ~0x30070000;	/* Leave config bits alone */
-	reg &= 0x30070000;	/* Strip timing bits */
-	pci_write_config_dword(pdev, addr1, reg | mode);
+	reg = ((reg & ~mask) | (clocks->timing & mask)) & ~0xc0000000;
+	pci_write_config_dword(pdev, addr1, reg);
+}
+
+/**
+ *	hpt366_set_piomode		-	PIO setup
+ *	@ap: ATA interface
+ *	@adev: device on the interface
+ *
+ *	Perform PIO mode setup.
+ */
+
+static void hpt366_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	hpt366_set_mode(ap, adev, adev->pio_mode);
 }
 
 /**
@@ -271,28 +271,7 @@ static void hpt366_set_piomode(struct ata_port *ap, struct ata_device *adev)
 
 static void hpt366_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u32 addr1, addr2;
-	u32 reg;
-	u32 mode;
-	u8 fast;
-
-	addr1 = 0x40 + 4 * (adev->devno + 2 * ap->port_no);
-	addr2 = 0x51 + 4 * ap->port_no;
-
-	/* Fast interrupt prediction disable, hold off interrupt disable */
-	pci_read_config_byte(pdev, addr2, &fast);
-	if (fast & 0x80) {
-		fast &= ~0x80;
-		pci_write_config_byte(pdev, addr2, fast);
-	}
-
-	pci_read_config_dword(pdev, addr1, &reg);
-	mode = hpt36x_find_mode(ap, adev->dma_mode);
-	mode |= 0x8000000;	/* FIFO in MWDMA or UDMA */
-	mode &= ~0xC0000000;	/* Leave config bits alone */
-	reg &= 0xC0000000;	/* Strip timing bits */
-	pci_write_config_dword(pdev, addr1, reg | mode);
+	hpt366_set_mode(ap, adev, adev->dma_mode);
 }
 
 static struct scsi_host_template hpt36x_sht = {
diff --git a/drivers/ata/pata_hpt3x3.c b/drivers/ata/pata_hpt3x3.c
index f11a320..f19cc64 100644
--- a/drivers/ata/pata_hpt3x3.c
+++ b/drivers/ata/pata_hpt3x3.c
@@ -23,7 +23,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt3x3"
-#define DRV_VERSION	"0.5.3"
+#define DRV_VERSION	"0.6.1"
 
 /**
  *	hpt3x3_set_piomode		-	PIO setup
@@ -80,14 +80,48 @@ static void hpt3x3_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	r2 &= ~(0x11 << dn);	/* Clear MWDMA and UDMA bits */
 
 	if (adev->dma_mode >= XFER_UDMA_0)
-		r2 |= (0x10 << dn);	/* Ultra mode */
+		r2 |= (0x01 << dn);	/* Ultra mode */
 	else
-		r2 |= (0x01 << dn);	/* MWDMA */
+		r2 |= (0x10 << dn);	/* MWDMA */
 
 	pci_write_config_dword(pdev, 0x44, r1);
 	pci_write_config_dword(pdev, 0x48, r2);
 }
-#endif /* CONFIG_PATA_HPT3X3_DMA */
+
+/**
+ *	hpt3x3_freeze		-	DMA workaround
+ *	@ap: port to freeze
+ *
+ *	When freezing an HPT3x3 we must stop any pending DMA before
+ *	writing to the control register or the chip will hang
+ */
+
+static void hpt3x3_freeze(struct ata_port *ap)
+{
+	void __iomem *mmio = ap->ioaddr.bmdma_addr;
+
+	iowrite8(ioread8(mmio + ATA_DMA_CMD) & ~ ATA_DMA_START,
+			mmio + ATA_DMA_CMD);
+	ata_sff_dma_pause(ap);
+	ata_sff_freeze(ap);
+}
+
+/**
+ *	hpt3x3_bmdma_setup	-	DMA workaround
+ *	@qc: Queued command
+ *
+ *	When issuing BMDMA we must clean up the error/active bits in
+ *	software on this device
+ */
+
+static void hpt3x3_bmdma_setup(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	u8 r = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
+	r |= ATA_DMA_INTR | ATA_DMA_ERR;
+	iowrite8(r, ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
+	return ata_bmdma_setup(qc);
+}
 
 /**
  *	hpt3x3_atapi_dma	-	ATAPI DMA check
@@ -101,18 +135,23 @@ static int hpt3x3_atapi_dma(struct ata_queued_cmd *qc)
 	return 1;
 }
 
+#endif /* CONFIG_PATA_HPT3X3_DMA */
+
 static struct scsi_host_template hpt3x3_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
 static struct ata_port_operations hpt3x3_port_ops = {
 	.inherits	= &ata_bmdma_port_ops,
-	.check_atapi_dma= hpt3x3_atapi_dma,
 	.cable_detect	= ata_cable_40wire,
 	.set_piomode	= hpt3x3_set_piomode,
 #if defined(CONFIG_PATA_HPT3X3_DMA)
 	.set_dmamode	= hpt3x3_set_dmamode,
+	.bmdma_setup	= hpt3x3_bmdma_setup,
+	.check_atapi_dma= hpt3x3_atapi_dma,
+	.freeze		= hpt3x3_freeze,
 #endif
+	
 };
 
 /**
diff --git a/drivers/ata/pata_mpiix.c b/drivers/ata/pata_mpiix.c
index 7c8faa4..aa576ca 100644
--- a/drivers/ata/pata_mpiix.c
+++ b/drivers/ata/pata_mpiix.c
@@ -35,7 +35,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_mpiix"
-#define DRV_VERSION "0.7.6"
+#define DRV_VERSION "0.7.7"
 
 enum {
 	IDETIM = 0x6C,		/* IDE control register */
@@ -146,6 +146,7 @@ static struct ata_port_operations mpiix_port_ops = {
 	.cable_detect	= ata_cable_40wire,
 	.set_piomode	= mpiix_set_piomode,
 	.prereset	= mpiix_pre_reset,
+	.sff_data_xfer	= ata_sff_data_xfer32,
 };
 
 static int mpiix_init_one(struct pci_dev *dev, const struct pci_device_id *id)
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 6afa07a..d8d743a 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -186,7 +186,7 @@ EXPORT_SYMBOL_GPL(__pata_platform_probe);
  *	A platform bus ATA device has been unplugged. Perform the needed
  *	cleanup. Also called on module unload for any active devices.
  */
-int __devexit __pata_platform_remove(struct device *dev)
+int __pata_platform_remove(struct device *dev)
 {
 	struct ata_host *host = dev_get_drvdata(dev);
 
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index 83580a5..9e764e5 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -32,7 +32,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_sil680"
-#define DRV_VERSION "0.4.8"
+#define DRV_VERSION "0.4.9"
 
 #define SIL680_MMIO_BAR		5
 
@@ -195,7 +195,7 @@ static struct scsi_host_template sil680_sht = {
 };
 
 static struct ata_port_operations sil680_port_ops = {
-	.inherits	= &ata_bmdma_port_ops,
+	.inherits	= &ata_bmdma32_port_ops,
 	.cable_detect	= sil680_cable_detect,
 	.set_piomode	= sil680_set_piomode,
 	.set_dmamode	= sil680_set_dmamode,
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index ccee930..2590c22 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -51,13 +51,6 @@ struct sil24_sge {
 	__le32	flags;
 };
 
-/*
- * Port multiplier
- */
-struct sil24_port_multiplier {
-	__le32	diag;
-	__le32	sactive;
-};
 
 enum {
 	SIL24_HOST_BAR		= 0,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 3449de5..4f7c8fb 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1518,6 +1518,7 @@ extern void sata_pmp_error_handler(struct ata_port *ap);
 
 extern const struct ata_port_operations ata_sff_port_ops;
 extern const struct ata_port_operations ata_bmdma_port_ops;
+extern const struct ata_port_operations ata_bmdma32_port_ops;
 
 /* PIO only, sg_tablesize and dma_boundary limits can be removed */
 #define ATA_PIO_SHT(drv_name)					\
@@ -1545,6 +1546,8 @@ extern void ata_sff_exec_command(struct ata_port *ap,
 				 const struct ata_taskfile *tf);
 extern unsigned int ata_sff_data_xfer(struct ata_device *dev,
 			unsigned char *buf, unsigned int buflen, int rw);
+extern unsigned int ata_sff_data_xfer32(struct ata_device *dev,
+			unsigned char *buf, unsigned int buflen, int rw);
 extern unsigned int ata_sff_data_xfer_noirq(struct ata_device *dev,
 			unsigned char *buf, unsigned int buflen, int rw);
 extern u8 ata_sff_irq_on(struct ata_port *ap);
