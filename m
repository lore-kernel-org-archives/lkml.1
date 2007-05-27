Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbXE0DKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbXE0DKQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 23:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbXE0DKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 23:10:00 -0400
Received: from havoc.gtf.org ([69.61.125.42]:60777 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258AbXE0DJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 23:09:58 -0400
Date: Sat, 26 May 2007 23:09:54 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] Add Marvell 6141 PATA support to AHCI driver
Message-ID: <20070527030954.GA18974@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Here is a patch against 2.6.22-rc3 that adds support for both the PATA
and SATA portions of the Marvell AHCI-like chip.

The architecture for PATA is quite nice, mimicing AHCI very closely.
Basic port scanning, interrupt handling, freezing and thawing is the
same, and uses the same register offets.

This is completely untested code.  But it looks like it should work :)

Engineering questions I need to bounce back to Marvell:
* do I need to worry about PIO/UDMA timing?  I don't see any registers
  or other knobs dealing with timing.  Maybe the controller snoops?
* it appears that I don't have to worry about device selection, that
  the controller will handle this for me.  But I want to make sure.
* figure out controller commands. these are poorly documented.
  controller commands are how one directly accesses the PATA device's
  command and control registers, and are necessary to do things like
  SRST.  Currently the driver only does hard reset.

This is checked into the 'mv-ahci-pata' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git


 drivers/ata/ahci.c  |  496 +++++++++++++++++++++++++++++++++++++++++++++++-----
 include/linux/ata.h |    1 
 2 files changed, 453 insertions(+), 44 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 7baeaff..5bbca8f 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -81,6 +81,7 @@ enum {
 	board_ahci_vt8251	= 2,
 	board_ahci_ign_iferr	= 3,
 	board_ahci_sb600	= 4,
+	board_ahci_mv		= 5,
 
 	/* global controller registers */
 	HOST_CAP		= 0x00, /* host capabilities */
@@ -171,6 +172,7 @@ enum {
 	AHCI_FLAG_HONOR_PI		= (1 << 26), /* honor PORTS_IMPL */
 	AHCI_FLAG_IGN_SERR_INTERNAL	= (1 << 27), /* ignore SERR_INTERNAL */
 	AHCI_FLAG_32BIT_ONLY		= (1 << 28), /* force 32bit */
+	AHCI_FLAG_MV_PATA		= (1 << 29), /* PATA port */
 
 	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 					  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
@@ -178,6 +180,46 @@ enum {
 					  ATA_FLAG_ACPI_SATA,
 };
 
+enum mvp_specific_registers {
+	MVP_D0_TF0		= 0x20,		/* dev0 taskfile part 1 */
+	MVP_D0_TF1		= 0x24,		/* dev0 taskfile part 2 */
+	MVP_D0_TF2		= 0x28,		/* dev0 taskfile part 3 */
+	MVP_D1_TF0		= 0x2C,		/* dev1 taskfile part 1 */
+	MVP_D1_TF1		= 0x30,		/* dev1 taskfile part 2 */
+	MVP_D1_TF2		= 0x3C,		/* dev1 taskfile part 3 */
+};
+
+enum mvp_specific_bits {
+	/* PORT_CMD register */
+	MVP_CMD_HW_RST		= (1 << 3), /* Generate H_RESET_N to
+					     * attached devices.
+					     * Self de-asserting.
+					     */
+
+	/* PORT_IRQ_[STAT,MASK] registers */
+	MVP_IRQ_D0_INTRQ	= (1 << 0),	/* dev0 INTRQ line */
+	MVP_IRQ_D0_ERR		= (1 << 1),	/* ERR in dev0 Status reg */
+	MVP_IRQ_D1_INTRQ	= (1 << 2),	/* dev1 INTRQ line */
+	MVP_IRQ_D1_ERR		= (1 << 3),	/* ERR in dev1 Status reg */
+	MVP_IRQ_FREEZE		= 0,
+	MVP_IRQ_ERROR		= MVP_IRQ_FREEZE |
+				  MVP_IRQ_D0_ERR | MVP_IRQ_D1_ERR,
+	DEF_MVP_IRQ		= MVP_IRQ_ERROR |
+				  MVP_IRQ_D0_INTRQ | MVP_IRQ_D1_INTRQ,
+
+	MVP_CMD_DEV1		= (1 << 15),	/* dev0 == 0, dev1 == 1 */
+	MVP_CMD_ATAPI_RST	= (1 << 14),	/* cmd==ATA_CMD_DEV_RESET */
+	MVP_CMD_EDD		= (1 << 13),	/* cmd==ATA_CMD_EDD */
+	MVP_CMD_LBA48		= (1 << 12),	/* is an LBA48 cmd */
+	MVP_CMD_PIO_SECT	= (1 << 11),	/* PIO single/mult sector cmd */
+	MVP_CMD_NODATA		= (1 << 10),	/* is a non-data cmd */
+	MVP_CMD_READ		= (1 << 9),	/* data-in (dev->host) */
+	MVP_CMD_DMA		= (1 << 8),	/* ATA or ATAPI DMA */
+	MVP_CMD_ATAPI		= (1 << 7),	/* is a PACKET cmd */
+	MVP_CMD_TCQ		= (1 << 6),	/* is a legacy TCQ cmd */
+	MVP_CMD_CONTROLLER	= (1 << 5),	/* PATA controller command */
+};
+
 struct ahci_cmd_hdr {
 	u32			opts;
 	u32			status;
@@ -211,6 +253,8 @@ struct ahci_port_priv {
 	unsigned int		ncq_saw_d2h:1;
 	unsigned int		ncq_saw_dmas:1;
 	unsigned int		ncq_saw_sdb:1;
+
+	int			mvp_selected;
 };
 
 static u32 ahci_scr_read (struct ata_port *ap, unsigned int sc_reg);
@@ -228,13 +272,22 @@ static void ahci_thaw(struct ata_port *ap);
 static void ahci_error_handler(struct ata_port *ap);
 static void ahci_vt8251_error_handler(struct ata_port *ap);
 static void ahci_post_internal_cmd(struct ata_queued_cmd *qc);
+static int ahci_port_resume(struct ata_port *ap);
+static unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl);
+static void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
+			       u32 opts);
 #ifdef CONFIG_PM
 static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg);
-static int ahci_port_resume(struct ata_port *ap);
 static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
 static int ahci_pci_device_resume(struct pci_dev *pdev);
 #endif
 
+static void mvp_dev_select(struct ata_port *ap, unsigned int device);
+static u8 mvp_check_status(struct ata_port *ap);
+static void mvp_tf_read(struct ata_port *ap, struct ata_taskfile *tf);
+static void mvp_qc_prep(struct ata_queued_cmd *qc);
+static void mvp_error_handler(struct ata_port *ap);
+
 static struct scsi_host_template ahci_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -322,6 +375,36 @@ static const struct ata_port_operations ahci_vt8251_ops = {
 	.port_stop		= ahci_port_stop,
 };
 
+static const struct ata_port_operations mvp_ops = {
+	.port_disable		= ata_port_disable,
+
+	.check_status		= mvp_check_status,
+	.check_altstatus	= mvp_check_status,
+	.dev_select		= mvp_dev_select,
+
+	.tf_read		= mvp_tf_read,
+
+	.qc_prep		= mvp_qc_prep,
+	.qc_issue		= ahci_qc_issue,
+
+	.irq_clear		= ahci_irq_clear,
+	.irq_on			= ata_dummy_irq_on,
+	.irq_ack		= ata_dummy_irq_ack,
+
+	.freeze			= ahci_freeze,
+	.thaw			= ahci_thaw,
+
+	.error_handler		= mvp_error_handler,
+
+#ifdef CONFIG_PM
+	.port_suspend		= ahci_port_suspend,
+	.port_resume		= ahci_port_resume,
+#endif
+
+	.port_start		= ahci_port_start,
+	.port_stop		= ahci_port_stop,
+};
+
 static const struct ata_port_info ahci_port_info[] = {
 	/* board_ahci */
 	{
@@ -361,6 +444,16 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
 		.port_ops	= &ahci_ops,
 	},
+	/* board_ahci_mv */
+	{
+		.sht		= &ahci_sht,
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
+				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
+				  ATA_FLAG_SKIP_D2H_BSY | AHCI_FLAG_HONOR_PI,
+		.pio_mask	= 0x1f, /* pio0-4 */
+		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.port_ops	= &ahci_ops,
+	},
 };
 
 static const struct pci_device_id ahci_pci_tbl[] = {
@@ -432,6 +525,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(SI, 0x1185), board_ahci }, /* SiS 966 */
 	{ PCI_VDEVICE(SI, 0x0186), board_ahci }, /* SiS 968 */
 
+	/* Marvell */
+	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
+
 	/* Generic, PCI class code for AHCI */
 	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci },
@@ -457,11 +553,17 @@ static inline int ahci_nr_ports(u32 cap)
 	return (cap & 0x1f) + 1;
 }
 
-static inline void __iomem *ahci_port_base(struct ata_port *ap)
+static inline void __iomem *__ahci_port_base(struct ata_host *host,
+					     unsigned int port_no)
 {
-	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
+	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
 
-	return mmio + 0x100 + (ap->port_no * 0x80);
+	return mmio + 0x100 + (port_no * 0x80);
+}
+
+static inline void __iomem *ahci_port_base(struct ata_port *ap)
+{
+	return __ahci_port_base(ap->host, ap->port_no);
 }
 
 /**
@@ -716,7 +818,7 @@ static void ahci_power_down(struct ata_port *ap)
 }
 #endif
 
-static void ahci_init_port(struct ata_port *ap)
+static void ahci_start_port(struct ata_port *ap)
 {
 	/* enable FIS reception */
 	ahci_start_fis_rx(ap);
@@ -737,7 +839,8 @@ static int ahci_deinit_port(struct ata_port *ap, const char **emsg)
 	}
 
 	/* disable FIS reception */
-	rc = ahci_stop_fis_rx(ap);
+	if (!(ap->flags & AHCI_FLAG_MV_PATA))
+		rc = ahci_stop_fis_rx(ap);
 	if (rc) {
 		*emsg = "failed stop FIS RX";
 		return rc;
@@ -790,39 +893,322 @@ static int ahci_reset_controller(struct ata_host *host)
 	return 0;
 }
 
+static void mvp_dev_select(struct ata_port *ap, unsigned int device)
+{
+	struct ahci_port_priv *pp = ap->private_data;
+
+	pp->mvp_selected = device;
+}
+
+/* WARNING: the following doesn't clear the interrupt, it's
+ * a read-only view of the device's ATA shadow registers
+ */
+static u8 mvp_check_status(struct ata_port *ap)
+{
+	void __iomem *mmio = ahci_port_base(ap);
+	struct ahci_port_priv *pp = ap->private_data;
+
+	if (pp->mvp_selected == 0)
+		mmio += MVP_D0_TF0;
+	else
+		mmio += MVP_D1_TF0;
+
+	return readl(mmio);	/* lower 8 bits are Status */
+}
+
+/* WARNING: the following doesn't clear the interrupt, it's
+ * a read-only view of the device's ATA shadow registers
+ */
+static void mvp_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
+{
+	void __iomem *mmio = ahci_port_base(ap);
+	struct ahci_port_priv *pp = ap->private_data;
+	u32 val;
+
+	if (pp->mvp_selected == 0)
+		val = readl(mmio + MVP_D0_TF0);
+	else
+		val = readl(mmio + MVP_D1_TF0);
+	tf->feature	= val >> 24;
+	tf->device	= val >> 8;
+	tf->command	= val;
+
+	if (pp->mvp_selected == 0)
+		val = readl(mmio + MVP_D0_TF1);
+	else
+		val = readl(mmio + MVP_D1_TF1);
+	tf->nsect	= val >> 24;
+	tf->hob_nsect	= val >> 16;
+	tf->lbal	= val >> 8;
+	tf->hob_lbal	= val;
+
+	if (pp->mvp_selected == 0)
+		val = readl(mmio + MVP_D0_TF2);
+	else
+		val = readl(mmio + MVP_D1_TF2);
+	tf->lbam	= val >> 24;
+	tf->hob_lbam	= val >> 16;
+	tf->lbah	= val >> 8;
+	tf->hob_lbah	= val;
+}
+
+static void mvp_qc_prep(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	int is_atapi = is_atapi_taskfile(&qc->tf);
+	void *cmd_tbl;
+	u32 *cmd_block;
+	u32 opts;
+	unsigned int n_elem;
+
+	/*
+	 * Fill in command table information.  First, the header,
+	 * a SATA Register - Host to Device command FIS.
+	 */
+	cmd_tbl = pp->cmd_tbl + qc->tag * AHCI_CMD_TBL_SZ;
+
+	/* FIXME: this hardcodes use of the ATA CDB format,
+	 * excluding the "controller command" feature that
+	 * we will need to use for direct PATA signal twiddling
+	 */
+	cmd_block = cmd_tbl;
+	cmd_block[0] =
+		((u32)qc->tf.feature) |
+		(((u32)qc->tf.hob_feature) << 8) |
+		(((u32)qc->tf.nsect) << 16) |
+		(((u32)qc->tf.hob_nsect) << 24);
+	cmd_block[1] =
+		((u32)qc->tf.lbal) |
+		(((u32)qc->tf.hob_lbal) << 8) |
+		(((u32)qc->tf.lbam) << 16) |
+		(((u32)qc->tf.hob_lbam) << 24);
+	cmd_block[2] =
+		((u32)qc->tf.command) |
+		(((u32)qc->tf.device) << 8) |
+		(((u32)qc->tf.lbah) << 16) |
+		(((u32)qc->tf.hob_lbah) << 24);
+
+	if (is_atapi) {
+		memset(cmd_tbl + AHCI_CMD_TBL_CDB, 0, 32);
+		memcpy(cmd_tbl + AHCI_CMD_TBL_CDB, qc->cdb, qc->dev->cdb_len);
+	}
+
+	n_elem = 0;
+	if (qc->flags & ATA_QCFLAG_DMAMAP)
+		n_elem = ahci_fill_sg(qc, cmd_tbl);
+
+	/*
+	 * Fill in command slot information.
+	 */
+	opts = n_elem << 16;
+	if (qc->dev->devno == 1)
+		opts |= MVP_CMD_DEV1;
+	if (qc->tf.command == ATA_CMD_DEV_RESET)
+		opts |= MVP_CMD_ATAPI_RST;
+	if (qc->tf.command == ATA_CMD_EDD)
+		opts |= MVP_CMD_EDD;
+	if (qc->tf.flags & ATA_TFLAG_LBA48)
+		opts |= MVP_CMD_LBA48;
+	if (qc->tf.protocol == ATA_PROT_PIO)
+		opts |= MVP_CMD_PIO_SECT;
+	if ((qc->tf.protocol == ATA_PROT_NODATA) ||
+	    (qc->tf.protocol == ATA_PROT_ATAPI_NODATA))
+		opts |= MVP_CMD_NODATA;
+	if (!(qc->tf.flags & ATA_TFLAG_WRITE))
+		opts |= MVP_CMD_READ;
+	if ((qc->tf.protocol == ATA_PROT_DMA) ||
+	    (qc->tf.protocol == ATA_PROT_ATAPI_DMA))
+		opts |= MVP_CMD_DMA;
+	if (is_atapi)
+		opts |= MVP_CMD_ATAPI;
+	opts |= (qc->dev->multi_count & 0x1f);
+
+	ahci_fill_cmd_slot(pp, qc->tag, opts);
+}
+
+static void mvp_error_intr(struct ata_port *ap, u32 irq_stat)
+{
+	struct ata_queued_cmd *qc;
+	struct ata_eh_info *ehi = &ap->eh_info;
+	unsigned int err_mask = 0, action = 0;
+
+	ata_ehi_clear_desc(ehi);
+
+	/* analyze @irq_stat */
+	ata_ehi_push_desc(ehi, "irq_stat 0x%08x", irq_stat);
+
+	if (irq_stat & (MVP_IRQ_D0_ERR | MVP_IRQ_D1_ERR))
+		err_mask |= AC_ERR_DEV;
+
+	ehi->action |= action;
+
+	qc = ata_qc_from_tag(ap, ap->active_tag);
+	if (qc)
+		qc->err_mask |= err_mask;
+	else
+		ehi->err_mask |= err_mask;
+
+	if (irq_stat & MVP_IRQ_FREEZE)
+		ata_port_freeze(ap);
+	else
+		ata_port_abort(ap);
+}
+
+static void mvp_port_intr(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ap->ioaddr.cmd_addr;
+	u32 status, qc_active;
+	int rc;
+
+	status = readl(port_mmio + PORT_IRQ_STAT);
+	writel(status, port_mmio + PORT_IRQ_STAT);
+
+	if (unlikely(status & MVP_IRQ_ERROR)) {
+		mvp_error_intr(ap, status);
+		return;
+	}
+
+	qc_active = readl(port_mmio + PORT_CMD_ISSUE);
+
+	rc = ata_qc_complete_multiple(ap, qc_active, NULL);
+	if (rc > 0)
+		return;
+	if (rc < 0) {
+		struct ata_eh_info *ehi = &ap->eh_info;
+		ehi->err_mask |= AC_ERR_HSM;
+		ehi->action |= ATA_EH_SOFTRESET;
+		ata_port_freeze(ap);
+		return;
+	}
+
+	/* if we get here... spurious interrupt? */
+}
+
+static int mvp_hardreset(struct ata_port *ap, unsigned int *class,
+			  unsigned long deadline)
+{
+	void __iomem *port_mmio = ap->ioaddr.cmd_addr;
+	u32 tmp;
+	int rc;
+
+	tmp = readl(port_mmio + PORT_CMD);
+	tmp |= MVP_CMD_HW_RST;
+	writel(tmp, port_mmio + PORT_CMD);
+
+	msleep(150);	/* paranoia... guessing that it might take
+			 * a tiny bit of time for MVP_CMD_HW_RST
+			 * to appear asserted in the register?
+			 */
+
+	tmp = ata_wait_register(port_mmio + PORT_CMD,
+				MVP_CMD_HW_RST, MVP_CMD_HW_RST, 2, 500);
+	if (tmp & MVP_CMD_HW_RST) {
+		ata_port_printk(ap, KERN_ERR,
+				"hard reset timed out (errno=%d)\n", -EIO);
+		return -EIO;
+	}
+
+	rc = ata_wait_ready(ap, deadline);
+	if (rc) {
+		ata_port_printk(ap, KERN_ERR,
+				"hard reset failed (errno=%d)\n", rc);
+		return rc;
+	}
+
+	*class = ata_dev_try_classify(ap, 0, NULL);
+
+	return 0;
+}
+
+static void mvp_error_handler(struct ata_port *ap)
+{
+	if (!(ap->pflags & ATA_PFLAG_FROZEN)) {
+		/* restart engine */
+		ahci_stop_engine(ap);
+		ahci_start_engine(ap);
+	}
+
+	/* perform recovery */
+	ata_do_eh(ap, ata_std_prereset, NULL, mvp_hardreset, ata_std_postreset);
+}
+
+static void mvp_port_init(struct pci_dev *pdev, struct ata_port *ap,
+			   int port_no, void __iomem *mmio,
+			   void __iomem *port_mmio)
+{
+	int rc;
+	u32 tmp;
+	const char *emsg = NULL;
+
+	/* make sure port is not active */
+	rc = ahci_deinit_port(ap, &emsg);
+	if (rc)
+		dev_printk(KERN_WARNING, &pdev->dev,
+			   "%s (%d)\n", emsg, rc);
+
+	/* select the IRQ events we're interested in */
+	writel(DEF_MVP_IRQ, port_mmio + PORT_IRQ_MASK);
+
+	/* clear port IRQ */
+	tmp = readl(port_mmio + PORT_IRQ_STAT);
+	VPRINTK("PORT_IRQ_STAT 0x%x\n", tmp);
+	if (tmp)
+		writel(tmp, port_mmio + PORT_IRQ_STAT);
+
+	writel(1 << port_no, mmio + HOST_IRQ_STAT);
+}
+
+static void ahci_port_init(struct pci_dev *pdev, struct ata_port *ap,
+			   int port_no, void __iomem *mmio,
+			   void __iomem *port_mmio)
+{
+	int rc;
+	u32 tmp;
+	const char *emsg = NULL;
+
+	/* make sure port is not active */
+	rc = ahci_deinit_port(ap, &emsg);
+	if (rc)
+		dev_printk(KERN_WARNING, &pdev->dev,
+			   "%s (%d)\n", emsg, rc);
+
+	/* clear SError */
+	tmp = readl(port_mmio + PORT_SCR_ERR);
+	VPRINTK("PORT_SCR_ERR 0x%x\n", tmp);
+	writel(tmp, port_mmio + PORT_SCR_ERR);
+
+	/* select the IRQ events we're interested in */
+	writel(DEF_PORT_IRQ, port_mmio + PORT_IRQ_MASK);
+
+	/* clear port IRQ */
+	tmp = readl(port_mmio + PORT_IRQ_STAT);
+	VPRINTK("PORT_IRQ_STAT 0x%x\n", tmp);
+	if (tmp)
+		writel(tmp, port_mmio + PORT_IRQ_STAT);
+
+	writel(1 << port_no, mmio + HOST_IRQ_STAT);
+}
+
 static void ahci_init_controller(struct ata_host *host)
 {
 	struct pci_dev *pdev = to_pci_dev(host->dev);
 	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
-	int i, rc;
+	void __iomem *port_mmio;
+	int i;
 	u32 tmp;
 
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
-		void __iomem *port_mmio = ahci_port_base(ap);
-		const char *emsg = NULL;
 
+		port_mmio = ahci_port_base(ap);
 		if (ata_port_is_dummy(ap))
 			continue;
 
-		/* make sure port is not active */
-		rc = ahci_deinit_port(ap, &emsg);
-		if (rc)
-			dev_printk(KERN_WARNING, &pdev->dev,
-				   "%s (%d)\n", emsg, rc);
-
-		/* clear SError */
-		tmp = readl(port_mmio + PORT_SCR_ERR);
-		VPRINTK("PORT_SCR_ERR 0x%x\n", tmp);
-		writel(tmp, port_mmio + PORT_SCR_ERR);
-
-		/* clear port IRQ */
-		tmp = readl(port_mmio + PORT_IRQ_STAT);
-		VPRINTK("PORT_IRQ_STAT 0x%x\n", tmp);
-		if (tmp)
-			writel(tmp, port_mmio + PORT_IRQ_STAT);
-
-		writel(1 << i, mmio + HOST_IRQ_STAT);
+		if (ap->flags & AHCI_FLAG_MV_PATA)
+			mvp_port_init(pdev, ap, i, mmio, port_mmio);
+		else
+			ahci_port_init(pdev, ap, i, mmio, port_mmio);
 	}
 
 	tmp = readl(mmio + HOST_CTL);
@@ -1208,7 +1594,7 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 		ata_port_abort(ap);
 }
 
-static void ahci_host_intr(struct ata_port *ap)
+static void ahci_port_intr(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ap->ioaddr.cmd_addr;
 	struct ata_eh_info *ehi = &ap->eh_info;
@@ -1334,7 +1720,10 @@ static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 
 		ap = host->ports[i];
 		if (ap) {
-			ahci_host_intr(ap);
+			if (ap->flags & AHCI_FLAG_MV_PATA)
+				mvp_port_intr(ap);
+			else
+				ahci_port_intr(ap);
 			VPRINTK("port %u\n", i);
 		} else {
 			VPRINTK("port %u (no irq)\n", i);
@@ -1442,7 +1831,7 @@ static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
 		ahci_power_down(ap);
 	else {
 		ata_port_printk(ap, KERN_ERR, "%s (%d)\n", emsg, rc);
-		ahci_init_port(ap);
+		ahci_start_port(ap);
 	}
 
 	return rc;
@@ -1451,7 +1840,7 @@ static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
 static int ahci_port_resume(struct ata_port *ap)
 {
 	ahci_power_up(ap);
-	ahci_init_port(ap);
+	ahci_start_port(ap);
 
 	return 0;
 }
@@ -1549,13 +1938,8 @@ static int ahci_port_start(struct ata_port *ap)
 
 	ap->private_data = pp;
 
-	/* power up port */
-	ahci_power_up(ap);
-
-	/* initialize port */
-	ahci_init_port(ap);
-
-	return 0;
+	/* engage engines, captain */
+	return ahci_port_resume(ap);
 }
 
 static void ahci_port_stop(struct ata_port *ap)
@@ -1680,7 +2064,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct device *dev = &pdev->dev;
 	struct ahci_host_priv *hpriv;
 	struct ata_host *host;
-	int i, rc;
+	int i, rc, mvp_port;
 
 	VPRINTK("ENTER\n");
 
@@ -1720,15 +2104,39 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	host->iomap = pcim_iomap_table(pdev);
 	host->private_data = hpriv;
 
+	switch(ent->driver_data) {
+	case board_ahci_mv:
+		mvp_port = 4;		/* count starts from zero */
+		break;
+
+	default:
+		mvp_port = -1;
+		break;
+	}
+
 	for (i = 0; i < host->n_ports; i++) {
-		if (hpriv->port_map & (1 << i)) {
-			struct ata_port *ap = host->ports[i];
-			void __iomem *port_mmio = ahci_port_base(ap);
+		struct ata_port *ap = host->ports[i];
+		void __iomem *port_mmio = ahci_port_base(ap);
 
+		/* switch to Marvell PATA port operations, flags */
+		if ((i == mvp_port) && (hpriv->port_map & (1 << i))) {
+			ap->ioaddr.cmd_addr = port_mmio;
+
+			ap->flags &= ~(ATA_FLAG_NCQ | ATA_FLAG_SKIP_D2H_BSY |
+				       ATA_FLAG_ACPI_SATA | ATA_FLAG_SATA);
+			ap->flags |= ATA_FLAG_SLAVE_POSS;
+			ap->ops = &mvp_ops;
+		}
+		
+		/* standard SATA port setup */
+		else if (hpriv->port_map & (1 << i)) {
 			ap->ioaddr.cmd_addr = port_mmio;
 			ap->ioaddr.scr_addr = port_mmio + PORT_SCR;
-		} else
-			host->ports[i]->ops = &ata_dummy_port_ops;
+		}
+
+		/* disabled/not-implemented port */
+		else
+			ap->ops = &ata_dummy_port_ops;
 	}
 
 	/* initialize adapter */
diff --git a/include/linux/ata.h b/include/linux/ata.h
index edb31bf..2e3542a 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -126,6 +126,7 @@ enum {
 	ATA_REG_IRQ		= ATA_REG_NSECT,
 
 	/* ATA device commands */
+	ATA_CMD_DEV_RESET	= 0x08, /* ATAPI device reset */
 	ATA_CMD_CHK_POWER	= 0xE5, /* check power mode */
 	ATA_CMD_STANDBY		= 0xE2, /* place in standby power mode */
 	ATA_CMD_IDLE		= 0xE3, /* place in idle power mode */
