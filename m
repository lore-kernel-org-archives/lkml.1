Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbZEOS2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbZEOS2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbZEOS1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:27:54 -0400
Received: from havoc.gtf.org ([69.61.125.42]:46547 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbZEOS1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:27:52 -0400
Date: Fri, 15 May 2009 14:27:52 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes and updates
Message-ID: <20090515182752.GA449@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This push is larger than average, because sata_sx4 is brought back from
the dead.  It was non-functional for at least a kernel release.

Additionally, this adds reporting logical/physical sector size, and
moves the form factor / rotation rate determination from libata-scsi.c
to linux/ata.h.  This prepares for upcoming SSD and non-standard sector
size work.

Plus other minor fixes.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-scsi.c |   34 +++++++--
 drivers/ata/sata_fsl.c    |   15 ++--
 drivers/ata/sata_sx4.c    |  180 +++++++++++++++++++++++++++++++--------------
 include/linux/ata.h       |   28 +++++++
 4 files changed, 191 insertions(+), 66 deletions(-)

Dave Liu (1):
      sata_fsl: Fix the command description of FSL SATA controller

David Milburn (1):
      [libata] sata_sx4: fixup interrupt handling

Jeff Garzik (1):
      [libata] sata_sx4: convert to new exception handling methods

Kumar Gala (1):
      sata_fsl: Fix compile warnings

Martin K. Petersen (2):
      libata: Report disk alignment and physical block size
      libata: Media rotation rate and form factor heuristics

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 68d9132..3423160 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2142,13 +2142,14 @@ static unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf)
 
 static unsigned int ata_scsiop_inq_b1(struct ata_scsi_args *args, u8 *rbuf)
 {
+	int form_factor = ata_id_form_factor(args->id);
+	int media_rotation_rate = ata_id_rotation_rate(args->id);
+
 	rbuf[1] = 0xb1;
 	rbuf[3] = 0x3c;
-	if (ata_id_major_version(args->id) > 7) {
-		rbuf[4] = args->id[217] >> 8;
-		rbuf[5] = args->id[217];
-		rbuf[7] = args->id[168] & 0xf;
-	}
+	rbuf[4] = media_rotation_rate >> 8;
+	rbuf[5] = media_rotation_rate;
+	rbuf[7] = form_factor;
 
 	return 0;
 }
@@ -2376,7 +2377,23 @@ saving_not_supp:
  */
 static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
 {
-	u64 last_lba = args->dev->n_sectors - 1; /* LBA of the last block */
+	struct ata_device *dev = args->dev;
+	u64 last_lba = dev->n_sectors - 1; /* LBA of the last block */
+	u8 log_per_phys = 0;
+	u16 lowest_aligned = 0;
+	u16 word_106 = dev->id[106];
+	u16 word_209 = dev->id[209];
+
+	if ((word_106 & 0xc000) == 0x4000) {
+		/* Number and offset of logical sectors per physical sector */
+		if (word_106 & (1 << 13))
+			log_per_phys = word_106 & 0xf;
+		if ((word_209 & 0xc000) == 0x4000) {
+			u16 first = dev->id[209] & 0x3fff;
+			if (first > 0)
+				lowest_aligned = (1 << log_per_phys) - first;
+		}
+	}
 
 	VPRINTK("ENTER\n");
 
@@ -2407,6 +2424,11 @@ static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
 		/* sector size */
 		rbuf[10] = ATA_SECT_SIZE >> 8;
 		rbuf[11] = ATA_SECT_SIZE & 0xff;
+
+		rbuf[12] = 0;
+		rbuf[13] = log_per_phys;
+		rbuf[14] = (lowest_aligned >> 8) & 0x3f;
+		rbuf[15] = lowest_aligned;
 	}
 
 	return 0;
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index c2e90e1..36b8629 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -205,6 +205,7 @@ struct cmdhdr_tbl_entry {
  * Description information bitdefs
  */
 enum {
+	CMD_DESC_RES = (1 << 11),
 	VENDOR_SPECIFIC_BIST = (1 << 10),
 	CMD_DESC_SNOOP_ENABLE = (1 << 9),
 	FPDMA_QUEUED_CMD = (1 << 8),
@@ -332,13 +333,14 @@ static unsigned int sata_fsl_fill_sg(struct ata_queued_cmd *qc, void *cmd_desc,
 		dma_addr_t sg_addr = sg_dma_address(sg);
 		u32 sg_len = sg_dma_len(sg);
 
-		VPRINTK("SATA FSL : fill_sg, sg_addr = 0x%x, sg_len = %d\n",
-			sg_addr, sg_len);
+		VPRINTK("SATA FSL : fill_sg, sg_addr = 0x%llx, sg_len = %d\n",
+			(unsigned long long)sg_addr, sg_len);
 
 		/* warn if each s/g element is not dword aligned */
 		if (sg_addr & 0x03)
 			ata_port_printk(qc->ap, KERN_ERR,
-					"s/g addr unaligned : 0x%x\n", sg_addr);
+					"s/g addr unaligned : 0x%llx\n",
+					(unsigned long long)sg_addr);
 		if (sg_len & 0x03)
 			ata_port_printk(qc->ap, KERN_ERR,
 					"s/g len unaligned : 0x%x\n", sg_len);
@@ -387,7 +389,7 @@ static void sata_fsl_qc_prep(struct ata_queued_cmd *qc)
 	void __iomem *hcr_base = host_priv->hcr_base;
 	unsigned int tag = sata_fsl_tag(qc->tag, hcr_base);
 	struct command_desc *cd;
-	u32 desc_info = CMD_DESC_SNOOP_ENABLE;
+	u32 desc_info = CMD_DESC_RES | CMD_DESC_SNOOP_ENABLE;
 	u32 num_prde = 0;
 	u32 ttl_dwords = 0;
 	dma_addr_t cd_paddr;
@@ -840,7 +842,7 @@ issue_srst:
 
 	/* device reset/SRST is a control register update FIS, uses tag0 */
 	sata_fsl_setup_cmd_hdr_entry(pp, 0,
-				     SRST_CMD | CMD_DESC_SNOOP_ENABLE, 0, 0, 5);
+		SRST_CMD | CMD_DESC_RES | CMD_DESC_SNOOP_ENABLE, 0, 0, 5);
 
 	tf.ctl |= ATA_SRST;	/* setup SRST bit in taskfile control reg */
 	ata_tf_to_fis(&tf, pmp, 0, cfis);
@@ -886,7 +888,8 @@ issue_srst:
 	 * using ATA signature D2H register FIS to the host controller.
 	 */
 
-	sata_fsl_setup_cmd_hdr_entry(pp, 0, CMD_DESC_SNOOP_ENABLE, 0, 0, 5);
+	sata_fsl_setup_cmd_hdr_entry(pp, 0, CMD_DESC_RES | CMD_DESC_SNOOP_ENABLE,
+				      0, 0, 5);
 
 	tf.ctl &= ~ATA_SRST;	/* 2nd H2D Ctl. register FIS */
 	ata_tf_to_fis(&tf, pmp, 0, cfis);
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index dce3dcc..eb05a3c 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -213,8 +213,9 @@ struct pdc_host_priv {
 
 
 static int pdc_sata_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
-static void pdc_eng_timeout(struct ata_port *ap);
-static void pdc_20621_phy_reset(struct ata_port *ap);
+static void pdc_error_handler(struct ata_port *ap);
+static void pdc_freeze(struct ata_port *ap);
+static void pdc_thaw(struct ata_port *ap);
 static int pdc_port_start(struct ata_port *ap);
 static void pdc20621_qc_prep(struct ata_queued_cmd *qc);
 static void pdc_tf_load_mmio(struct ata_port *ap, const struct ata_taskfile *tf);
@@ -233,6 +234,10 @@ static void pdc20621_put_to_dimm(struct ata_host *host,
 				 void *psource, u32 offset, u32 size);
 static void pdc20621_irq_clear(struct ata_port *ap);
 static unsigned int pdc20621_qc_issue(struct ata_queued_cmd *qc);
+static int pdc_softreset(struct ata_link *link, unsigned int *class,
+			 unsigned long deadline);
+static void pdc_post_internal_cmd(struct ata_queued_cmd *qc);
+static int pdc_check_atapi_dma(struct ata_queued_cmd *qc);
 
 
 static struct scsi_host_template pdc_sata_sht = {
@@ -243,20 +248,24 @@ static struct scsi_host_template pdc_sata_sht = {
 
 /* TODO: inherit from base port_ops after converting to new EH */
 static struct ata_port_operations pdc_20621_ops = {
-	.sff_tf_load		= pdc_tf_load_mmio,
-	.sff_tf_read		= ata_sff_tf_read,
-	.sff_check_status	= ata_sff_check_status,
-	.sff_exec_command	= pdc_exec_command_mmio,
-	.sff_dev_select		= ata_sff_dev_select,
-	.phy_reset		= pdc_20621_phy_reset,
+	.inherits		= &ata_sff_port_ops,
+
+	.check_atapi_dma	= pdc_check_atapi_dma,
 	.qc_prep		= pdc20621_qc_prep,
 	.qc_issue		= pdc20621_qc_issue,
-	.qc_fill_rtf		= ata_sff_qc_fill_rtf,
-	.sff_data_xfer		= ata_sff_data_xfer,
-	.eng_timeout		= pdc_eng_timeout,
-	.sff_irq_clear		= pdc20621_irq_clear,
-	.sff_irq_on		= ata_sff_irq_on,
+
+	.freeze			= pdc_freeze,
+	.thaw			= pdc_thaw,
+	.softreset		= pdc_softreset,
+	.error_handler		= pdc_error_handler,
+	.lost_interrupt		= ATA_OP_NULL,
+	.post_internal_cmd	= pdc_post_internal_cmd,
+
 	.port_start		= pdc_port_start,
+
+	.sff_tf_load		= pdc_tf_load_mmio,
+	.sff_exec_command	= pdc_exec_command_mmio,
+	.sff_irq_clear		= pdc20621_irq_clear,
 };
 
 static const struct ata_port_info pdc_port_info[] = {
@@ -310,14 +319,6 @@ static int pdc_port_start(struct ata_port *ap)
 	return 0;
 }
 
-static void pdc_20621_phy_reset(struct ata_port *ap)
-{
-	VPRINTK("ENTER\n");
-	ap->cbl = ATA_CBL_SATA;
-	ata_port_probe(ap);
-	ata_bus_reset(ap);
-}
-
 static inline void pdc20621_ata_sg(struct ata_taskfile *tf, u8 *buf,
 				   unsigned int portno,
 					   unsigned int total_len)
@@ -686,8 +687,11 @@ static void pdc20621_packet_start(struct ata_queued_cmd *qc)
 static unsigned int pdc20621_qc_issue(struct ata_queued_cmd *qc)
 {
 	switch (qc->tf.protocol) {
-	case ATA_PROT_DMA:
 	case ATA_PROT_NODATA:
+		if (qc->tf.flags & ATA_TFLAG_POLLING)
+			break;
+		/*FALLTHROUGH*/
+	case ATA_PROT_DMA:
 		pdc20621_packet_start(qc);
 		return 0;
 
@@ -786,12 +790,7 @@ static inline unsigned int pdc20621_host_intr(struct ata_port *ap,
 
 static void pdc20621_irq_clear(struct ata_port *ap)
 {
-	struct ata_host *host = ap->host;
-	void __iomem *mmio = host->iomap[PDC_MMIO_BAR];
-
-	mmio += PDC_CHIP0_OFS;
-
-	readl(mmio + PDC_20621_SEQMASK);
+	ioread8(ap->ioaddr.status_addr);
 }
 
 static irqreturn_t pdc20621_interrupt(int irq, void *dev_instance)
@@ -859,46 +858,119 @@ static irqreturn_t pdc20621_interrupt(int irq, void *dev_instance)
 	return IRQ_RETVAL(handled);
 }
 
-static void pdc_eng_timeout(struct ata_port *ap)
+static void pdc_freeze(struct ata_port *ap)
 {
-	u8 drv_stat;
-	struct ata_host *host = ap->host;
-	struct ata_queued_cmd *qc;
-	unsigned long flags;
+	void __iomem *mmio = ap->ioaddr.cmd_addr;
+	u32 tmp;
 
-	DPRINTK("ENTER\n");
+	/* FIXME: if all 4 ATA engines are stopped, also stop HDMA engine */
 
-	spin_lock_irqsave(&host->lock, flags);
+	tmp = readl(mmio + PDC_CTLSTAT);
+	tmp |= PDC_MASK_INT;
+	tmp &= ~PDC_DMA_ENABLE;
+	writel(tmp, mmio + PDC_CTLSTAT);
+	readl(mmio + PDC_CTLSTAT); /* flush */
+}
 
-	qc = ata_qc_from_tag(ap, ap->link.active_tag);
+static void pdc_thaw(struct ata_port *ap)
+{
+	void __iomem *mmio = ap->ioaddr.cmd_addr;
+	u32 tmp;
 
-	switch (qc->tf.protocol) {
-	case ATA_PROT_DMA:
-	case ATA_PROT_NODATA:
-		ata_port_printk(ap, KERN_ERR, "command timeout\n");
-		qc->err_mask |= __ac_err_mask(ata_wait_idle(ap));
-		break;
+	/* FIXME: start HDMA engine, if zero ATA engines running */
 
-	default:
-		drv_stat = ata_sff_busy_wait(ap, ATA_BUSY | ATA_DRQ, 1000);
+	/* clear IRQ */
+	ioread8(ap->ioaddr.status_addr);
 
-		ata_port_printk(ap, KERN_ERR,
-				"unknown timeout, cmd 0x%x stat 0x%x\n",
-				qc->tf.command, drv_stat);
+	/* turn IRQ back on */
+	tmp = readl(mmio + PDC_CTLSTAT);
+	tmp &= ~PDC_MASK_INT;
+	writel(tmp, mmio + PDC_CTLSTAT);
+	readl(mmio + PDC_CTLSTAT); /* flush */
+}
 
-		qc->err_mask |= ac_err_mask(drv_stat);
-		break;
+static void pdc_reset_port(struct ata_port *ap)
+{
+	void __iomem *mmio = ap->ioaddr.cmd_addr + PDC_CTLSTAT;
+	unsigned int i;
+	u32 tmp;
+
+	/* FIXME: handle HDMA copy engine */
+
+	for (i = 11; i > 0; i--) {
+		tmp = readl(mmio);
+		if (tmp & PDC_RESET)
+			break;
+
+		udelay(100);
+
+		tmp |= PDC_RESET;
+		writel(tmp, mmio);
 	}
 
-	spin_unlock_irqrestore(&host->lock, flags);
-	ata_eh_qc_complete(qc);
-	DPRINTK("EXIT\n");
+	tmp &= ~PDC_RESET;
+	writel(tmp, mmio);
+	readl(mmio);	/* flush */
+}
+
+static int pdc_softreset(struct ata_link *link, unsigned int *class,
+			 unsigned long deadline)
+{
+	pdc_reset_port(link->ap);
+	return ata_sff_softreset(link, class, deadline);
+}
+
+static void pdc_error_handler(struct ata_port *ap)
+{
+	if (!(ap->pflags & ATA_PFLAG_FROZEN))
+		pdc_reset_port(ap);
+
+	ata_std_error_handler(ap);
+}
+
+static void pdc_post_internal_cmd(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+
+	/* make DMA engine forget about the failed command */
+	if (qc->flags & ATA_QCFLAG_FAILED)
+		pdc_reset_port(ap);
+}
+
+static int pdc_check_atapi_dma(struct ata_queued_cmd *qc)
+{
+	u8 *scsicmd = qc->scsicmd->cmnd;
+	int pio = 1; /* atapi dma off by default */
+
+	/* Whitelist commands that may use DMA. */
+	switch (scsicmd[0]) {
+	case WRITE_12:
+	case WRITE_10:
+	case WRITE_6:
+	case READ_12:
+	case READ_10:
+	case READ_6:
+	case 0xad: /* READ_DVD_STRUCTURE */
+	case 0xbe: /* READ_CD */
+		pio = 0;
+	}
+	/* -45150 (FFFF4FA2) to -1 (FFFFFFFF) shall use PIO mode */
+	if (scsicmd[0] == WRITE_10) {
+		unsigned int lba =
+			(scsicmd[2] << 24) |
+			(scsicmd[3] << 16) |
+			(scsicmd[4] << 8) |
+			scsicmd[5];
+		if (lba >= 0xFFFF4FA2)
+			pio = 1;
+	}
+	return pio;
 }
 
 static void pdc_tf_load_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
 {
 	WARN_ON(tf->protocol == ATA_PROT_DMA ||
-		tf->protocol == ATA_PROT_NODATA);
+		tf->protocol == ATAPI_PROT_DMA);
 	ata_sff_tf_load(ap, tf);
 }
 
@@ -906,7 +978,7 @@ static void pdc_tf_load_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
 static void pdc_exec_command_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
 {
 	WARN_ON(tf->protocol == ATA_PROT_DMA ||
-		tf->protocol == ATA_PROT_NODATA);
+		tf->protocol == ATAPI_PROT_DMA);
 	ata_sff_exec_command(ap, tf);
 }
 
diff --git a/include/linux/ata.h b/include/linux/ata.h
index cb79b7a..915da43 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -730,6 +730,34 @@ static inline int ata_id_has_unload(const u16 *id)
 	return 0;
 }
 
+static inline int ata_id_form_factor(const u16 *id)
+{
+	u16 val = id[168];
+
+	if (ata_id_major_version(id) < 7 || val == 0 || val == 0xffff)
+		return 0;
+
+	val &= 0xf;
+
+	if (val > 5)
+		return 0;
+
+	return val;
+}
+
+static inline int ata_id_rotation_rate(const u16 *id)
+{
+	u16 val = id[217];
+
+	if (ata_id_major_version(id) < 7 || val == 0 || val == 0xffff)
+		return 0;
+
+	if (val > 1 && val < 0x401)
+		return 0;
+
+	return val;
+}
+
 static inline int ata_id_has_trim(const u16 *id)
 {
 	if (ata_id_major_version(id) >= 7 &&
