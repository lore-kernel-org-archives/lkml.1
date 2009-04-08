Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbZDHFJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbZDHFJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbZDHFJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:09:10 -0400
Received: from havoc.gtf.org ([69.61.125.42]:36761 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822AbZDHFJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:09:08 -0400
Date: Wed, 8 Apr 2009 01:09:04 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] ahci: Add Marvell PATA support
Message-ID: <20090408050904.GA26598@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is an extensive refresh of libata-dev.git#mv-ahci-pata 
including
- PATA controller command support (finally! needed for reset, basic
  operation)
- caught several more places where ahci driver touched
  registers that did not exist in AHCI PATA mode
- several bug fixes


It still needs some work, particularly in the master/slave area.



commit 70cc17955a74acb77128b62429964244726fecb6
Author: Jeff Garzik <jeff@garzik.org>
Date:   Wed Apr 8 01:04:44 2009 -0400

    [libata] ahci: Initial Marvell PATA support (rough draft)
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 57be6be..059baab 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -235,6 +235,48 @@ enum {
 	EM_CTL_ALHD			= (1 << 26), /* Activity LED */
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
+	MVP_CMD_CDB_LEN		= 24,		/* CDB length offset (5 bits) */
+	MVP_CMD_HW_RST		= (1 << 3),	/* Generate H_RESET_N to
+						 * attached devices.
+						 * Self de-asserting.
+						 */
+	MVP_CMD_DMA_STAT_CK	= (1 << 2),	/* chk status after DMA cmd */
+	MVP_CMD_DEV_INT_EN	= (1 << 1),	/* device interrupt enabled */
+
+	/* PORT_IRQ_[STAT,MASK] register bits */
+	MVP_IRQ_D0_INTRQ	= (1 << 0),	/* dev0 INTRQ line */
+	MVP_IRQ_D0_ERR		= (1 << 1),	/* ERR in dev0 Status reg */
+	MVP_IRQ_D1_INTRQ	= (1 << 2),	/* dev1 INTRQ line */
+	MVP_IRQ_D1_ERR		= (1 << 3),	/* ERR in dev1 Status reg */
+	MVP_IRQ_ERROR		= MVP_IRQ_D0_ERR | MVP_IRQ_D1_ERR,
+	DEF_MVP_IRQ		= MVP_IRQ_ERROR |
+				  MVP_IRQ_D0_INTRQ | MVP_IRQ_D1_INTRQ,
+
+	/* command slot options */
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
 	__le32			opts;
 	__le32			status;
@@ -265,6 +307,7 @@ struct ahci_host_priv {
 	u32			saved_cap;	/* saved initial cap */
 	u32			saved_port_map;	/* saved initial port_map */
 	u32 			em_loc; /* enclosure management location */
+	int			mvp_port;
 };
 
 struct ahci_port_priv {
@@ -282,6 +325,8 @@ struct ahci_port_priv {
 	u32 			intr_mask;	/* interrupts to enable */
 	struct ahci_em_priv	em_priv[MAX_SLOTS];/* enclosure management info
 					 	 * per PM slot */
+
+	int			mvp_selected;
 };
 
 static int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
@@ -323,6 +368,8 @@ static ssize_t ahci_activity_show(struct ata_device *dev, char *buf);
 static ssize_t ahci_activity_store(struct ata_device *dev,
 				   enum sw_activity val);
 static void ahci_init_sw_activity(struct ata_link *link);
+static int ahci_kick_engine(struct ata_port *ap, int force_restart);
+static int ahci_check_ready(struct ata_link *link);
 
 static struct device_attribute *ahci_shost_attrs[] = {
 	&dev_attr_link_power_management_policy,
@@ -337,6 +384,15 @@ static struct device_attribute *ahci_sdev_attrs[] = {
 	NULL
 };
 
+static void mvp_dev_select(struct ata_port *ap, unsigned int device);
+static u8 mvp_check_status(struct ata_port *ap);
+static void mvp_tf_read(struct ata_port *ap, struct ata_taskfile *tf);
+static void mvp_qc_prep(struct ata_queued_cmd *qc);
+static int mvp_hardreset(struct ata_link *link, unsigned int *class,
+			 unsigned long deadline);
+static int mvp_softreset(struct ata_link *link, unsigned int *class,
+			 unsigned long deadline);
+
 static struct scsi_host_template ahci_sht = {
 	ATA_NCQ_SHT(DRV_NAME),
 	.can_queue		= AHCI_MAX_CMDS - 1,
@@ -399,6 +455,32 @@ static struct ata_port_operations ahci_sb600_ops = {
 	.pmp_softreset		= ahci_sb600_softreset,
 };
 
+static struct ata_port_operations mvp_ops = {
+	.inherits		= &ata_sff_port_ops,
+
+	.qc_prep		= mvp_qc_prep,
+	.qc_issue		= ahci_qc_issue,
+
+	.freeze			= ahci_freeze,
+	.thaw			= ahci_thaw,
+	.hardreset		= mvp_hardreset,
+	.softreset		= mvp_softreset,
+	.error_handler		= ahci_error_handler,
+	.post_internal_cmd	= ahci_post_internal_cmd,
+
+	.sff_dev_select		= mvp_dev_select,
+	.sff_check_status	= mvp_check_status,
+	.sff_check_altstatus	= mvp_check_status,
+	.sff_tf_read		= mvp_tf_read,
+
+#ifdef CONFIG_PM
+	.port_suspend		= ahci_port_suspend,
+	.port_resume		= ahci_port_resume,
+#endif
+	.port_start		= ahci_port_start,
+	.port_stop		= ahci_port_stop,
+};
+
 #define AHCI_HFLAGS(flags)	.private_data	= (void *)(flags)
 
 static const struct ata_port_info ahci_port_info[] = {
@@ -438,7 +520,7 @@ static const struct ata_port_info ahci_port_info[] = {
 	/* board_ahci_mv */
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ | AHCI_HFLAG_NO_MSI |
-				 AHCI_HFLAG_MV_PATA | AHCI_HFLAG_NO_PMP),
+				 AHCI_HFLAG_MV_PATA),
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA,
 		.pio_mask	= ATA_PIO4,
@@ -706,7 +788,6 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 	void __iomem *mmio = pcim_iomap_table(pdev)[AHCI_PCI_BAR];
 	u32 cap, port_map;
 	int i;
-	int mv;
 
 	/* make sure AHCI mode is enabled before accessing CAP */
 	ahci_enable_ahci(mmio);
@@ -750,26 +831,6 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 		port_map = 1;
 	}
 
-	/*
-	 * Temporary Marvell 6145 hack: PATA port presence
-	 * is asserted through the standard AHCI port
-	 * presence register, as bit 4 (counting from 0)
-	 */
-	if (hpriv->flags & AHCI_HFLAG_MV_PATA) {
-		if (pdev->device == 0x6121)
-			mv = 0x3;
-		else
-			mv = 0xf;
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "MV_AHCI HACK: port_map %x -> %x\n",
-			   port_map,
-			   port_map & mv);
-		dev_printk(KERN_ERR, &pdev->dev,
-			  "Disabling your PATA port. Use the boot option 'ahci.marvell_enable=0' to avoid this.\n");
-
-		port_map &= mv;
-	}
-
 	/* cross check port_map and cap.n_ports */
 	if (port_map) {
 		int map_ports = 0;
@@ -953,6 +1014,9 @@ static void ahci_power_up(struct ata_port *ap)
 	void __iomem *port_mmio = ahci_port_base(ap);
 	u32 cmd;
 
+	if (ap->flags & AHCI_HFLAG_MV_PATA)
+		return;
+
 	cmd = readl(port_mmio + PORT_CMD) & ~PORT_CMD_ICC_MASK;
 
 	/* spin up device */
@@ -1096,6 +1160,8 @@ static void ahci_power_down(struct ata_port *ap)
 	void __iomem *port_mmio = ahci_port_base(ap);
 	u32 cmd, scontrol;
 
+	if (ap->flags & AHCI_HFLAG_MV_PATA)
+		return;
 	if (!(hpriv->cap & HOST_CAP_SSS))
 		return;
 
@@ -1119,8 +1185,9 @@ static void ahci_start_port(struct ata_port *ap)
 	ssize_t rc;
 	int i;
 
-	/* enable FIS reception */
-	ahci_start_fis_rx(ap);
+	/* enable SATA FIS reception */
+	if (!(ap->flags & AHCI_HFLAG_MV_PATA))
+		ahci_start_fis_rx(ap);
 
 	/* enable DMA */
 	ahci_start_engine(ap);
@@ -1161,7 +1228,8 @@ static int ahci_deinit_port(struct ata_port *ap, const char **emsg)
 	}
 
 	/* disable FIS reception */
-	rc = ahci_stop_fis_rx(ap);
+	if (!(ap->flags & AHCI_HFLAG_MV_PATA))
+		rc = ahci_stop_fis_rx(ap);
 	if (rc) {
 		*emsg = "failed stop FIS RX";
 		return rc;
@@ -1457,6 +1525,364 @@ static ssize_t ahci_activity_show(struct ata_device *dev, char *buf)
 	return sprintf(buf, "%d\n", emp->blink_policy);
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
+	int is_atapi = ata_is_atapi(qc->tf.protocol);
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
+	cmd_block = cmd_tbl;
+	cmd_block[0] = cpu_to_le32(
+		((u32)qc->tf.feature) |
+		(((u32)qc->tf.hob_feature) << 8) |
+		(((u32)qc->tf.nsect) << 16) |
+		(((u32)qc->tf.hob_nsect) << 24));
+	cmd_block[1] = cpu_to_le32(
+		((u32)qc->tf.lbal) |
+		(((u32)qc->tf.hob_lbal) << 8) |
+		(((u32)qc->tf.lbam) << 16) |
+		(((u32)qc->tf.hob_lbam) << 24));
+	cmd_block[2] = cpu_to_le32(
+		((u32)qc->tf.command) |
+		(((u32)qc->tf.device) << 8) |
+		(((u32)qc->tf.lbah) << 16) |
+		(((u32)qc->tf.hob_lbah) << 24));
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
+	if (ata_is_nodata(qc->tf.protocol))
+		opts |= MVP_CMD_NODATA;
+	if (!(qc->tf.flags & ATA_TFLAG_WRITE))
+		opts |= MVP_CMD_READ;
+	if (ata_is_dma(qc->tf.protocol))
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
+	struct ata_eh_info *ehi = &ap->link.eh_info;
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
+	qc = ata_qc_from_tag(ap, ap->link.active_tag);
+	if (qc)
+		qc->err_mask |= err_mask;
+	else
+		ehi->err_mask |= err_mask;
+
+	ata_port_abort(ap);
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
+	rc = ata_qc_complete_multiple(ap, qc_active);
+	if (rc > 0)
+		return;
+	if (rc < 0) {
+		struct ata_eh_info *ehi = &ap->link.eh_info;
+		ehi->err_mask |= AC_ERR_HSM;
+		ehi->action |= ATA_EH_SOFTRESET;
+		ata_port_freeze(ap);
+		return;
+	}
+
+	/* if we get here... spurious interrupt? */
+}
+
+static int mvp_hardreset(struct ata_link *link, unsigned int *class,
+			 unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
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
+	rc = ata_sff_wait_ready(link, deadline);
+	if (rc) {
+		ata_port_printk(ap, KERN_ERR,
+				"hard reset failed (errno=%d)\n", rc);
+		return rc;
+	}
+
+	*class = ata_sff_dev_classify(ap->link.device, 0, NULL);
+
+	return 0;
+}
+
+static void mvp_ctrl_cmd(void *cmd_block, int cmd_idx, bool read_tf,
+			 bool is_slave, u8 tf_addr, u8 tf_data)
+{
+	int dw_idx = cmd_idx / 2;
+	u32 tmp, *dw;
+	u32 new_val = 0, tmp_mask = 0xffff0000;
+
+	/* initialize 16-bit controller command */
+	if (read_tf)
+		new_val |= (1 << 14);		/* 0=write tf, 1=read tf */
+	if (is_slave)
+		new_val |= (1 << 13);		/* 0=master, 1=slave */
+	new_val |= ((tf_addr & 0x1f) << 8);	/* TF register address */
+	new_val |= tf_data;			/* TF register data */
+
+	/* determine if value is stored in upper or lower 16 bits */
+	if (cmd_idx & 1) {
+		new_val <<= 16;
+		tmp_mask = 0x0000ffff;
+	}
+
+	/* store in command block */
+	dw = cmd_block;
+	tmp = le32_to_cpu(dw[dw_idx]);
+	tmp = (tmp & tmp_mask) | new_val;
+	dw[dw_idx] = cpu_to_le32(tmp);
+}
+
+static int mvp_softreset(struct ata_link *link, unsigned int *class,
+			 unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	const char *reason = NULL;
+	void *cmd_tbl;
+	unsigned long now, msecs;
+	int rc;
+	u32 opts, tmp;
+
+	DPRINTK("ENTER\n");
+
+	/* prepare for SRST (AHCI-1.1 10.4.1) */
+	rc = ahci_kick_engine(ap, 1);
+	if (rc && rc != -EOPNOTSUPP)
+		ata_link_printk(link, KERN_WARNING,
+				"failed to reset engine (errno=%d)\n", rc);
+
+	/* reference cmd slot #0 */
+	cmd_tbl = pp->cmd_tbl + (0 * AHCI_CMD_TBL_SZ);
+
+	/* 1 controller command */
+	opts = MVP_CMD_CONTROLLER | 1;
+
+	msecs = 0;
+	now = jiffies;
+	if (time_after(now, deadline))
+		msecs = jiffies_to_msecs(deadline - now);
+
+	/* issue SRST=1 */
+	mvp_ctrl_cmd(cmd_tbl, 0, false, false, 0x16, ATA_SRST);
+	ahci_fill_cmd_slot(pp, 0, opts);
+	writel(1, port_mmio + PORT_CMD_ISSUE);
+
+	/* wait for completion of PATA ctrl cmd, via CMD_ISSUE register */
+	tmp = ata_wait_register(port_mmio + PORT_CMD_ISSUE, 0x1, 0x1,
+				1, msecs);
+	if (tmp & 0x1) {
+		ahci_kick_engine(ap, 1);
+		rc = -EBUSY;
+		goto fail;
+	}
+
+	msleep(1);
+
+	/* issue SRST=0 */
+	mvp_ctrl_cmd(cmd_tbl, 0, false, false, 0x16, 0);
+	ahci_fill_cmd_slot(pp, 0, opts);
+	writel(1, port_mmio + PORT_CMD_ISSUE);
+
+	/* wait for completion of PATA ctrl cmd, via CMD_ISSUE register */
+	tmp = ata_wait_register(port_mmio + PORT_CMD_ISSUE, 0x1, 0x1,
+				1, msecs);
+	if (tmp & 0x1) {
+		ahci_kick_engine(ap, 1);
+		rc = -EBUSY;
+		goto fail;
+	}
+
+	/* wait for link to become ready */
+	rc = ata_wait_after_reset(link, deadline, ahci_check_ready);
+	if (rc)
+		goto fail;
+
+	/* FIXME: this is wrong, as we might have two devices */
+
+	*class = ata_sff_dev_classify(ap->link.device, 0, NULL);
+
+	DPRINTK("EXIT, class=%u\n", *class);
+	return 0;
+
+ fail:
+	ata_link_printk(link, KERN_ERR, "softreset failed (%s)\n", reason);
+	return rc;
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
+	/* init PATA port setup */
+	tmp = readl(port_mmio + PORT_CMD);
+	tmp = MVP_CMD_DEV_INT_EN;
+	tmp |= (12 << MVP_CMD_CDB_LEN);		/* TODO: un-hardcode cdb len */
+	writel(tmp, port_mmio + PORT_CMD);
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
 static void ahci_port_init(struct pci_dev *pdev, struct ata_port *ap,
 			   int port_no, void __iomem *mmio,
 			   void __iomem *port_mmio)
@@ -1487,29 +1913,11 @@ static void ahci_port_init(struct pci_dev *pdev, struct ata_port *ap,
 
 static void ahci_init_controller(struct ata_host *host)
 {
-	struct ahci_host_priv *hpriv = host->private_data;
 	struct pci_dev *pdev = to_pci_dev(host->dev);
 	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
 	int i;
 	void __iomem *port_mmio;
 	u32 tmp;
-	int mv;
-
-	if (hpriv->flags & AHCI_HFLAG_MV_PATA) {
-		if (pdev->device == 0x6121)
-			mv = 2;
-		else
-			mv = 4;
-		port_mmio = __ahci_port_base(host, mv);
-
-		writel(0, port_mmio + PORT_IRQ_MASK);
-
-		/* clear port IRQ */
-		tmp = readl(port_mmio + PORT_IRQ_STAT);
-		VPRINTK("PORT_IRQ_STAT 0x%x\n", tmp);
-		if (tmp)
-			writel(tmp, port_mmio + PORT_IRQ_STAT);
-	}
 
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
@@ -1518,7 +1926,10 @@ static void ahci_init_controller(struct ata_host *host)
 		if (ata_port_is_dummy(ap))
 			continue;
 
-		ahci_port_init(pdev, ap, i, mmio, port_mmio);
+		if (ap->flags & AHCI_HFLAG_MV_PATA)
+			mvp_port_init(pdev, ap, i, mmio, port_mmio);
+		else
+			ahci_port_init(pdev, ap, i, mmio, port_mmio);
 	}
 
 	tmp = readl(mmio + HOST_CTL);
@@ -2142,7 +2553,10 @@ static irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 
 		ap = host->ports[i];
 		if (ap) {
-			ahci_port_intr(ap);
+			if (ap->flags & AHCI_HFLAG_MV_PATA)
+				mvp_port_intr(ap);
+			else
+				ahci_port_intr(ap);
 			VPRINTK("port %u\n", i);
 		} else {
 			VPRINTK("port %u (no irq)\n", i);
@@ -2499,7 +2913,7 @@ static void ahci_print_info(struct ata_host *host)
 		"flags: "
 		"%s%s%s%s%s%s%s"
 		"%s%s%s%s%s%s%s"
-		"%s\n"
+		"%s%s\n"
 		,
 
 		cap & (1 << 31) ? "64bit " : "",
@@ -2517,7 +2931,8 @@ static void ahci_print_info(struct ata_host *host)
 		cap & (1 << 15) ? "pio " : "",
 		cap & (1 << 14) ? "slum " : "",
 		cap & (1 << 13) ? "part " : "",
-		cap & (1 << 6) ? "ems ": ""
+		cap & (1 << 6) ? "ems ": "",
+		hpriv->mvp_port >= 0 ? "pata " : ""
 		);
 }
 
@@ -2610,7 +3025,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct device *dev = &pdev->dev;
 	struct ahci_host_priv *hpriv;
 	struct ata_host *host;
-	int n_ports, i, rc;
+	int n_ports, i, rc, mvp_port;
 
 	VPRINTK("ENTER\n");
 
@@ -2619,9 +3034,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
 
-	/* The AHCI driver can only drive the SATA ports, the PATA driver
-	   can drive them all so if both drivers are selected make sure
-	   AHCI stays out of the way */
+	/* prevent conflict with pata_marvell */
 	if (pdev->vendor == PCI_VENDOR_ID_MARVELL && !marvell_enable)
 		return -ENODEV;
 
@@ -2727,6 +3140,21 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (pi.flags & ATA_FLAG_EM)
 		ahci_reset_em(host);
 
+	switch (ent->driver_data) {
+	case board_ahci_mv:
+		if (pdev->device == 0x6121)
+			mvp_port = 2;		/* count starts from zero */
+		else
+			mvp_port = 4;		/* count starts from zero */
+		break;
+
+	default:
+		mvp_port = -1;
+		break;
+	}
+
+	hpriv->mvp_port = mvp_port;
+
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 
@@ -2741,9 +3169,17 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		if (ap->flags & ATA_FLAG_EM)
 			ap->em_message_type = ahci_em_messages;
 
+		/* switch to Marvell PATA port operations, flags */
+		if ((i == mvp_port) && (hpriv->port_map & (1 << i))) {
+			ap->flags = ATA_FLAG_SLAVE_POSS |
+				    ATA_FLAG_NO_LEGACY |
+				    ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA;
+			hpriv->flags |= AHCI_HFLAG_MV_PATA;
+			ap->ops = &mvp_ops;
+		}
 
 		/* disabled/not-implemented port */
-		if (!(hpriv->port_map & (1 << i)))
+		else if (!(hpriv->port_map & (1 << i)))
 			ap->ops = &ata_dummy_port_ops;
 	}
 
