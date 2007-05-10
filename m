Return-Path: <linux-kernel-owner+w=401wt.eu-S1759683AbXEJAlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759683AbXEJAlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 20:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756376AbXEJAlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 20:41:04 -0400
Received: from havoc.gtf.org ([69.61.125.42]:42902 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471AbXEJAlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 20:41:01 -0400
Date: Wed, 9 May 2007 20:40:59 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes, minor updates
Message-ID: <20070510004059.GA1784@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 Documentation/kernel-parameters.txt |    8 ---
 drivers/ata/libata-acpi.c           |    3 +-
 drivers/ata/libata-core.c           |    2 +
 drivers/ata/pata_pcmcia.c           |    1 +
 drivers/ata/pata_qdi.c              |    2 +-
 drivers/ata/pata_scc.c              |    4 +-
 drivers/ata/sata_nv.c               |   92 +++++++++++++++++++++++++++++-----
 drivers/ata/sata_promise.c          |   24 ++++++++--
 drivers/ata/sata_via.c              |    8 +++
 9 files changed, 113 insertions(+), 31 deletions(-)

Alexey Dobriyan (1):
      pata_scc: fix compilation

Jesse Barnes (1):
      Doc Fix: remove mention of combined mode-related kernel parameters

Mikael Pettersson (2):
      sata_promise: fix another error decode regression
      sata_promise: SATAII-150/300 TX4 port numbering fix

Randy Dunlap (1):
      libata: fix kernel-doc parameters

Richard Kennedy (1):
      pata_pcmcia.c: add card ident for jvc cdrom

Robert Hancock (1):
      sata_nv: fix ADMA freeze/thaw/irq_clear issues

Samuel Thibault (1):
      Fix pata_qdi.c probe code

Tejun Heo (2):
      libata-acpi: fix _GTF command protocol for ATAPI devices
      sata_via: add missing PM hooks

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6b8ad06..09220a1 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -754,14 +754,6 @@ and is between 256 and 4096 characters. It is defined in the file
 	inport.irq=	[HW] Inport (ATI XL and Microsoft) busmouse driver
 			Format: <irq>
 
-	combined_mode=	[HW] control which driver uses IDE ports in combined
-			mode: legacy IDE driver, libata, or both
-			(in the libata case, libata.atapi_enabled=1 may be
-			useful as well).  Note that using the ide or libata
-			options may affect your device naming (e.g. by
-			changing hdc to sdb).
-			Format: combined (default), ide, or libata
-
 	inttest=	[IA64]
 
 	io7=		[HW] IO7 for Marvel based alpha systems
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 03a0acf..cb3eab6 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -489,8 +489,7 @@ static void taskfile_load_raw(struct ata_port *ap,
 
 	/* convert gtf to tf */
 	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE; /* TBD */
-	tf.protocol = atadev->class == ATA_DEV_ATAPI ?
-		ATA_PROT_ATAPI_NODATA : ATA_PROT_NODATA;
+	tf.protocol = ATA_PROT_NODATA;
 	tf.feature = gtf->tfa[0];	/* 0x1f1 */
 	tf.nsect   = gtf->tfa[1];	/* 0x1f2 */
 	tf.lbal    = gtf->tfa[2];	/* 0x1f3 */
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index fef87dd..4595d1f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -895,6 +895,7 @@ static u64 ata_read_native_max_address(struct ata_device *dev)
 /**
  *	ata_set_native_max_address_ext	-	LBA48 native max set
  *	@dev: Device to query
+ *	@new_sectors: new max sectors value to set for the device
  *
  *	Perform an LBA48 size set max upon the device in question. Return the
  *	actual LBA48 size or zero if the command fails.
@@ -932,6 +933,7 @@ static u64 ata_set_native_max_address_ext(struct ata_device *dev, u64 new_sector
 /**
  *	ata_set_native_max_address	-	LBA28 native max set
  *	@dev: Device to query
+ *	@new_sectors: new max sectors value to set for the device
  *
  *	Perform an LBA28 size set max upon the device in question. Return the
  *	actual LBA28 size or zero if the command fails.
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 75dc847..11245e3 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -357,6 +357,7 @@ static struct pcmcia_device_id pcmcia_devices[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x000a, 0x0000),	/* I-O Data CFA */
 	PCMCIA_DEVICE_MANF_CARD(0x001c, 0x0001),	/* Mitsubishi CFA */
 	PCMCIA_DEVICE_MANF_CARD(0x0032, 0x0704),
+	PCMCIA_DEVICE_MANF_CARD(0x0032, 0x2904),
 	PCMCIA_DEVICE_MANF_CARD(0x0045, 0x0401),	/* SanDisk CFA */
 	PCMCIA_DEVICE_MANF_CARD(0x0098, 0x0000),	/* Toshiba */
 	PCMCIA_DEVICE_MANF_CARD(0x00a4, 0x002d),
diff --git a/drivers/ata/pata_qdi.c b/drivers/ata/pata_qdi.c
index 27685ce..fb8c9e1 100644
--- a/drivers/ata/pata_qdi.c
+++ b/drivers/ata/pata_qdi.c
@@ -375,7 +375,7 @@ static __init int qdi_init(void)
 				res = inb(port + 3);
 				if (res & 1) {
 					/* Single channel mode */
-					if (qdi_init_one(port, 6580, ide_port[r & 0x01], ide_irq[r & 0x01], r & 0x04))
+					if (qdi_init_one(port, 6580, ide_port[r & 0x01], ide_irq[r & 0x01], r & 0x04) == 0)
 						ct++;
 				} else {
 					/* Dual channel mode */
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index 5df354d..203f463 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -1142,14 +1142,14 @@ static int scc_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	static int printed_version;
 	unsigned int board_idx = (unsigned int) ent->driver_data;
 	const struct ata_port_info *ppi[] = { &scc_port_info[board_idx], NULL };
-	struct device *dev = &pdev->dev;
+	struct ata_host *host;
 	int rc;
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	host = ata_port_alloc_pinfo(&pdev->dev, ppi, 1);
+	host = ata_host_alloc_pinfo(&pdev->dev, ppi, 1);
 	if (!host)
 		return -ENOMEM;
 
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index e2e795e..a097595 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -257,6 +257,8 @@ static void nv_adma_port_stop(struct ata_port *ap);
 static int nv_adma_port_suspend(struct ata_port *ap, pm_message_t mesg);
 static int nv_adma_port_resume(struct ata_port *ap);
 #endif
+static void nv_adma_freeze(struct ata_port *ap);
+static void nv_adma_thaw(struct ata_port *ap);
 static void nv_adma_error_handler(struct ata_port *ap);
 static void nv_adma_host_stop(struct ata_host *host);
 static void nv_adma_post_internal_cmd(struct ata_queued_cmd *qc);
@@ -444,8 +446,8 @@ static const struct ata_port_operations nv_adma_ops = {
 	.bmdma_status		= ata_bmdma_status,
 	.qc_prep		= nv_adma_qc_prep,
 	.qc_issue		= nv_adma_qc_issue,
-	.freeze			= nv_ck804_freeze,
-	.thaw			= nv_ck804_thaw,
+	.freeze			= nv_adma_freeze,
+	.thaw			= nv_adma_thaw,
 	.error_handler		= nv_adma_error_handler,
 	.post_internal_cmd	= nv_adma_post_internal_cmd,
 	.data_xfer		= ata_data_xfer,
@@ -815,8 +817,16 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
 			u16 status;
 			u32 gen_ctl;
 			u32 notifier, notifier_error;
+			
+			/* if ADMA is disabled, use standard ata interrupt handler */
+			if (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) {
+				u8 irq_stat = readb(host->iomap[NV_MMIO_BAR] + NV_INT_STATUS_CK804)
+					>> (NV_INT_PORT_SHIFT * i);
+				handled += nv_host_intr(ap, irq_stat);
+				continue;
+			}
 
-			/* if in ATA register mode, use standard ata interrupt handler */
+			/* if in ATA register mode, check for standard interrupts */
 			if (pp->flags & NV_ADMA_PORT_REGISTER_MODE) {
 				u8 irq_stat = readb(host->iomap[NV_MMIO_BAR] + NV_INT_STATUS_CK804)
 					>> (NV_INT_PORT_SHIFT * i);
@@ -826,7 +836,6 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
 					    command is active, to prevent losing interrupts. */
 					irq_stat |= NV_INT_DEV;
 				handled += nv_host_intr(ap, irq_stat);
-				continue;
 			}
 
 			notifier = readl(mmio + NV_ADMA_NOTIFIER);
@@ -912,22 +921,77 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
 	return IRQ_RETVAL(handled);
 }
 
+static void nv_adma_freeze(struct ata_port *ap)
+{
+	struct nv_adma_port_priv *pp = ap->private_data;
+	void __iomem *mmio = pp->ctl_block;
+	u16 tmp;
+
+	nv_ck804_freeze(ap);
+
+	if (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE)
+		return;
+
+	/* clear any outstanding CK804 notifications */
+	writeb( NV_INT_ALL << (ap->port_no * NV_INT_PORT_SHIFT),
+		ap->host->iomap[NV_MMIO_BAR] + NV_INT_STATUS_CK804);
+
+	/* Disable interrupt */
+	tmp = readw(mmio + NV_ADMA_CTL);
+	writew( tmp & ~(NV_ADMA_CTL_AIEN | NV_ADMA_CTL_HOTPLUG_IEN),
+		mmio + NV_ADMA_CTL);
+	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
+}
+
+static void nv_adma_thaw(struct ata_port *ap)
+{
+	struct nv_adma_port_priv *pp = ap->private_data;
+	void __iomem *mmio = pp->ctl_block;
+	u16 tmp;
+
+	nv_ck804_thaw(ap);
+
+	if (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE)
+		return;
+
+	/* Enable interrupt */
+	tmp = readw(mmio + NV_ADMA_CTL);
+	writew( tmp | (NV_ADMA_CTL_AIEN | NV_ADMA_CTL_HOTPLUG_IEN),
+		mmio + NV_ADMA_CTL);
+	readw( mmio + NV_ADMA_CTL );	/* flush posted write */
+}
+
 static void nv_adma_irq_clear(struct ata_port *ap)
 {
 	struct nv_adma_port_priv *pp = ap->private_data;
 	void __iomem *mmio = pp->ctl_block;
-	u16 status = readw(mmio + NV_ADMA_STAT);
-	u32 notifier = readl(mmio + NV_ADMA_NOTIFIER);
-	u32 notifier_error = readl(mmio + NV_ADMA_NOTIFIER_ERROR);
-	void __iomem *dma_stat_addr = ap->ioaddr.bmdma_addr + ATA_DMA_STATUS;
+	u32 notifier_clears[2];
 
-	/* clear ADMA status */
-	writew(status, mmio + NV_ADMA_STAT);
-	writel(notifier | notifier_error,
-	       pp->notifier_clear_block);
+	if (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) {
+		ata_bmdma_irq_clear(ap);
+		return;
+	}
+
+	/* clear any outstanding CK804 notifications */
+	writeb( NV_INT_ALL << (ap->port_no * NV_INT_PORT_SHIFT),
+		ap->host->iomap[NV_MMIO_BAR] + NV_INT_STATUS_CK804);
 
-	/** clear legacy status */
-	iowrite8(ioread8(dma_stat_addr), dma_stat_addr);
+	/* clear ADMA status */
+	writew(0xffff, mmio + NV_ADMA_STAT);
+	
+	/* clear notifiers - note both ports need to be written with
+	   something even though we are only clearing on one */
+	if (ap->port_no == 0) {
+		notifier_clears[0] = 0xFFFFFFFF;
+		notifier_clears[1] = 0;
+	} else {
+		notifier_clears[0] = 0;
+		notifier_clears[1] = 0xFFFFFFFF;
+	}
+	pp = ap->host->ports[0]->private_data;
+	writel(notifier_clears[0], pp->notifier_clear_block);
+	pp = ap->host->ports[1]->private_data;
+	writel(notifier_clears[1], pp->notifier_clear_block);
 }
 
 static void nv_adma_post_internal_cmd(struct ata_queued_cmd *qc)
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index f56549b..3a7d9b5 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -45,7 +45,7 @@
 #include "sata_promise.h"
 
 #define DRV_NAME	"sata_promise"
-#define DRV_VERSION	"2.05"
+#define DRV_VERSION	"2.07"
 
 
 enum {
@@ -653,6 +653,8 @@ static void pdc_error_intr(struct ata_port *ap, struct ata_queued_cmd *qc,
 	qc->err_mask |= ac_err_mask;
 
 	pdc_reset_port(ap);
+
+	ata_port_abort(ap);
 }
 
 static inline unsigned int pdc_host_intr( struct ata_port *ap,
@@ -924,6 +926,7 @@ static int pdc_ata_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 	struct ata_host *host;
 	void __iomem *base;
 	int n_ports, i, rc;
+	int is_sataii_tx4;
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
@@ -962,10 +965,23 @@ static int pdc_ata_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 	}
 	host->iomap = pcim_iomap_table(pdev);
 
-	for (i = 0; i < host->n_ports; i++)
+	is_sataii_tx4 = 0;
+	if ((pi->flags & (PDC_FLAG_GEN_II|PDC_FLAG_4_PORTS)) == (PDC_FLAG_GEN_II|PDC_FLAG_4_PORTS)) {
+		is_sataii_tx4 = 1;
+		dev_printk(KERN_INFO, &pdev->dev, "applying SATAII TX4 port numbering workaround\n");
+	}
+	for (i = 0; i < host->n_ports; i++) {
+		static const unsigned char sataii_tx4_port_remap[4] = { 3, 1, 0, 2};
+		int ata_nr;
+
+		ata_nr = i;
+		if (is_sataii_tx4)
+			ata_nr = sataii_tx4_port_remap[i];
+
 		pdc_ata_setup_port(host->ports[i],
-				   base + 0x200 + i * 0x80,
-				   base + 0x400 + i * 0x100);
+				   base + 0x200 + ata_nr * 0x80,
+				   base + 0x400 + ata_nr * 0x100);
+	}
 
 	/* initialize adapter */
 	pdc_host_init(host);
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 305ab7c..939c924 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -93,6 +93,10 @@ static struct pci_driver svia_pci_driver = {
 	.name			= DRV_NAME,
 	.id_table		= svia_pci_tbl,
 	.probe			= svia_init_one,
+#ifdef CONFIG_PM
+	.suspend		= ata_pci_device_suspend,
+	.resume			= ata_pci_device_resume,
+#endif
 	.remove			= ata_pci_remove_one,
 };
 
@@ -112,6 +116,10 @@ static struct scsi_host_template svia_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+#ifdef CONFIG_PM
+	.suspend		= ata_scsi_device_suspend,
+	.resume			= ata_scsi_device_resume,
+#endif
 };
 
 static const struct ata_port_operations vt6420_sata_ops = {
