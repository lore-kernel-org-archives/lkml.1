Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbZDQCla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbZDQCla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 22:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758290AbZDQClS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 22:41:18 -0400
Received: from havoc.gtf.org ([69.61.125.42]:43565 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759860AbZDQClO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 22:41:14 -0400
Date: Thu, 16 Apr 2009 22:41:11 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/3] mv-ahci: Add Marvell PATA support
Message-ID: <20090417024111.GB15475@havoc.gtf.org>
References: <20090417023949.GA14469@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417023949.GA14469@havoc.gtf.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit b789e972e23509ab27312b9cf7273b611feb25cb
Author: Jeff Garzik <jeff@garzik.org>
Date:   Thu Apr 16 22:13:27 2009 -0400

    [libata] mv-ahci: Add Marvell PATA support
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/ata/ahci.h    |   12 
 drivers/ata/libahci.c |   92 ++----
 drivers/ata/mv-ahci.c |  748 +++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 782 insertions(+), 70 deletions(-)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index cf5b9d8..57c792a 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -129,7 +129,6 @@ enum {
 	AHCI_HFLAG_IGN_IRQ_IF_ERR	= (1 << 1), /* ignore IRQ_IF_ERR */
 	AHCI_HFLAG_IGN_SERR_INTERNAL	= (1 << 2), /* ignore SERR_INTERNAL */
 	AHCI_HFLAG_32BIT_ONLY		= (1 << 3), /* force 32bit */
-	AHCI_HFLAG_MV_PATA		= (1 << 4), /* PATA port */
 	AHCI_HFLAG_NO_MSI		= (1 << 5), /* no PCI MSI */
 	AHCI_HFLAG_NO_PMP		= (1 << 6), /* no PMP */
 	AHCI_HFLAG_NO_HOTPLUG		= (1 << 7), /* ignore PxSERR.DIAG.N */
@@ -149,6 +148,8 @@ enum {
 	EM_CTL_RST			= (1 << 9), /* Reset */
 	EM_CTL_TM			= (1 << 8), /* Transmit Message */
 	EM_CTL_ALHD			= (1 << 26), /* Activity LED */
+
+	AHCI_FLAG_MV_PATA		= (1 << 30),
 };
 
 enum {
@@ -211,6 +212,9 @@ struct ahci_port_priv {
 	unsigned int		ncq_saw_dmas:1;
 	unsigned int		ncq_saw_sdb:1;
 	u32 			intr_mask;	/* interrupts to enable */
+
+	int			mvp_selected;
+
 	struct ahci_em_priv	em_priv[AHCI_MAX_SLOTS];
 				     /* enclosure management info per PM slot */
 };
@@ -273,6 +277,12 @@ extern ssize_t ahci_activity_store(struct ata_device *dev, enum sw_activity val)
 extern ssize_t ahci_activity_show(struct ata_device *dev, char *buf);
 extern void ahci_print_info(struct ata_host *host);
 extern void ahci_port_intr(struct ata_port *ap);
+extern void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag, u32 opts);
+extern unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl);
+extern int ahci_deinit_port(struct ata_port *ap, const char **emsg);
+extern void ahci_port_init(struct pci_dev *pdev, struct ata_port *ap,
+			   int port_no, void __iomem *mmio,
+			   void __iomem *port_mmio);
 
 #ifdef CONFIG_PM
 extern int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg);
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 929d555..280638a 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -13,8 +13,6 @@ static int ahci_skip_host_reset;
 static void ahci_init_sw_activity(struct ata_link *link);
 static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
 					ssize_t size);
-static void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
-			       u32 opts);
 static void ahci_enable_ahci(void __iomem *mmio);
 
 module_param_named(skip_host_reset, ahci_skip_host_reset, int, 0444);
@@ -190,12 +188,7 @@ static void ahci_start_fis_rx(struct ata_port *ap)
 	struct ahci_port_priv *pp = ap->private_data;
 	u32 tmp;
 
-	/* set FIS registers */
-	if (hpriv->cap & HOST_CAP_64)
-		writel((pp->cmd_slot_dma >> 16) >> 16,
-		       port_mmio + PORT_LST_ADDR_HI);
-	writel(pp->cmd_slot_dma & 0xffffffff, port_mmio + PORT_LST_ADDR);
-
+	/* program DMA data structures address */
 	if (hpriv->cap & HOST_CAP_64)
 		writel((pp->rx_fis_dma >> 16) >> 16,
 		       port_mmio + PORT_FIS_ADDR_HI);
@@ -231,14 +224,23 @@ static int ahci_stop_fis_rx(struct ata_port *ap)
 
 static void ahci_start_port(struct ata_port *ap)
 {
+	struct ahci_host_priv *hpriv = ap->host->private_data;
 	struct ahci_port_priv *pp = ap->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
 	struct ata_link *link;
 	struct ahci_em_priv *emp;
 	ssize_t rc;
 	int i;
 
+	/* program command list DMA data structure addresses */
+	if (hpriv->cap & HOST_CAP_64)
+		writel((pp->cmd_slot_dma >> 16) >> 16,
+		       port_mmio + PORT_LST_ADDR_HI);
+	writel(pp->cmd_slot_dma & 0xffffffff, port_mmio + PORT_LST_ADDR);
+
 	/* enable FIS reception */
-	ahci_start_fis_rx(ap);
+	if (!(ap->flags & AHCI_FLAG_MV_PATA))
+		ahci_start_fis_rx(ap);
 
 	/* enable DMA */
 	ahci_start_engine(ap);
@@ -267,7 +269,7 @@ static void ahci_start_port(struct ata_port *ap)
 
 }
 
-static int ahci_deinit_port(struct ata_port *ap, const char **emsg)
+int ahci_deinit_port(struct ata_port *ap, const char **emsg)
 {
 	int rc;
 
@@ -279,16 +281,19 @@ static int ahci_deinit_port(struct ata_port *ap, const char **emsg)
 	}
 
 	/* disable FIS reception */
-	rc = ahci_stop_fis_rx(ap);
-	if (rc) {
-		*emsg = "failed stop FIS RX";
-		return rc;
+	if (!(ap->flags & AHCI_FLAG_MV_PATA)) {
+		rc = ahci_stop_fis_rx(ap);
+		if (rc) {
+			*emsg = "failed stop FIS RX";
+			return rc;
+		}
 	}
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ahci_deinit_port);
 
-static void ahci_port_init(struct pci_dev *pdev, struct ata_port *ap,
+void ahci_port_init(struct pci_dev *pdev, struct ata_port *ap,
 			   int port_no, void __iomem *mmio,
 			   void __iomem *port_mmio)
 {
@@ -309,12 +314,14 @@ static void ahci_port_init(struct pci_dev *pdev, struct ata_port *ap,
 
 	/* clear port IRQ */
 	tmp = readl(port_mmio + PORT_IRQ_STAT);
-	VPRINTK("PORT_IRQ_STAT 0x%x\n", tmp);
-	if (tmp)
+	if (tmp) {
+		VPRINTK("PORT_IRQ_STAT 0x%x\n", tmp);
 		writel(tmp, port_mmio + PORT_IRQ_STAT);
+	}
 
 	writel(1 << port_no, mmio + HOST_IRQ_STAT);
 }
+EXPORT_SYMBOL_GPL(ahci_port_init);
 
 int ahci_port_start(struct ata_port *ap)
 {
@@ -419,29 +426,11 @@ EXPORT_SYMBOL_GPL(ahci_configure_dma_masks);
 
 void ahci_init_controller(struct ata_host *host)
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
@@ -482,7 +471,6 @@ void ahci_save_initial_config(struct pci_dev *pdev,
 	void __iomem *mmio = pcim_iomap_table(pdev)[AHCI_PCI_BAR];
 	u32 cap, port_map;
 	int i;
-	int mv;
 
 	/* make sure AHCI mode is enabled before accessing CAP */
 	ahci_enable_ahci(mmio);
@@ -526,26 +514,6 @@ void ahci_save_initial_config(struct pci_dev *pdev,
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
@@ -693,6 +661,9 @@ static void ahci_power_up(struct ata_port *ap)
 	void __iomem *port_mmio = ahci_port_base(ap);
 	u32 cmd;
 
+	if (ap->flags & AHCI_FLAG_MV_PATA)
+		return;
+
 	cmd = readl(port_mmio + PORT_CMD) & ~PORT_CMD_ICC_MASK;
 
 	/* spin up device */
@@ -712,6 +683,8 @@ static void ahci_power_down(struct ata_port *ap)
 	void __iomem *port_mmio = ahci_port_base(ap);
 	u32 cmd, scontrol;
 
+	if (ap->flags & AHCI_FLAG_MV_PATA)
+		return;
 	if (!(hpriv->cap & HOST_CAP_SSS))
 		return;
 
@@ -1173,8 +1146,7 @@ static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
 	return size;
 }
 
-static void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
-			       u32 opts)
+void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag, u32 opts)
 {
 	dma_addr_t cmd_tbl_dma;
 
@@ -1185,8 +1157,9 @@ static void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
 	pp->cmd_slot[tag].tbl_addr = cpu_to_le32(cmd_tbl_dma & 0xffffffff);
 	pp->cmd_slot[tag].tbl_addr_hi = cpu_to_le32((cmd_tbl_dma >> 16) >> 16);
 }
+EXPORT_SYMBOL_GPL(ahci_fill_cmd_slot);
 
-static unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl)
+unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl)
 {
 	struct scatterlist *sg;
 	struct ahci_sg *ahci_sg = cmd_tbl + AHCI_CMD_TBL_HDR_SZ;
@@ -1208,6 +1181,7 @@ static unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl)
 
 	return si;
 }
+EXPORT_SYMBOL_GPL(ahci_fill_sg);
 
 void ahci_qc_prep(struct ata_queued_cmd *qc)
 {
diff --git a/drivers/ata/mv-ahci.c b/drivers/ata/mv-ahci.c
index 0a3ac6c..a19b979 100644
--- a/drivers/ata/mv-ahci.c
+++ b/drivers/ata/mv-ahci.c
@@ -55,6 +55,69 @@ enum {
 	board_ahci_mv		= 0,
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
+
+	MVATA_REG_DATA		= ATA_REG_DATA + 0x08,
+	MVATA_REG_ERR		= ATA_REG_ERR + 0x08,
+	MVATA_REG_NSECT		= ATA_REG_NSECT + 0x08,
+	MVATA_REG_LBAL		= ATA_REG_LBAL + 0x08,
+	MVATA_REG_LBAM		= ATA_REG_LBAM + 0x08,
+	MVATA_REG_LBAH		= ATA_REG_LBAH + 0x08,
+	MVATA_REG_DEVICE	= ATA_REG_DEVICE + 0x08,
+	MVATA_REG_STATUS	= ATA_REG_STATUS + 0x08,
+	MVATA_REG_DEVCTL	= 0x16,
+	MVATA_REG_ALTSTATUS	= MVATA_REG_DEVCTL,
+};
+
+static void mvp_dev_select(struct ata_port *ap, unsigned int device);
+static u8 mvp_check_status(struct ata_port *ap);
+static void mvp_tf_read(struct ata_port *ap, struct ata_taskfile *tf);
+static void mvp_qc_prep(struct ata_queued_cmd *qc);
+static int mvp_hardreset(struct ata_link *link, unsigned int *class,
+			 unsigned long deadline);
+static int mvp_softreset(struct ata_link *link, unsigned int *class,
+			 unsigned long deadline);
+static int mvp_port_start(struct ata_port *ap);
+
 static struct device_attribute *mv_ahci_shost_attrs[] = {
 	&dev_attr_link_power_management_policy,
 	&dev_attr_em_message_type,
@@ -77,7 +140,7 @@ static struct scsi_host_template mv_ahci_sht = {
 	.sdev_attrs		= mv_ahci_sdev_attrs,
 };
 
-static struct ata_port_operations mv_ahci_ops = {
+static struct ata_port_operations mv_sata_ops = {
 	.inherits		= &sata_pmp_port_ops,
 
 	.qc_defer		= sata_pmp_qc_defer_cmd_switch,
@@ -113,16 +176,41 @@ static struct ata_port_operations mv_ahci_ops = {
 	.port_stop		= ahci_port_stop,
 };
 
+static struct ata_port_operations mv_pata_ops = {
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
+	.port_start		= mvp_port_start,
+	.port_stop		= ahci_port_stop,
+};
+
 static const struct ata_port_info mv_ahci_port_info[] = {
 	[board_ahci_mv] =
 	{
-		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ | AHCI_HFLAG_NO_MSI |
-				 AHCI_HFLAG_MV_PATA | AHCI_HFLAG_NO_PMP),
+		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ | AHCI_HFLAG_NO_MSI),
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
-		.port_ops	= &mv_ahci_ops,
+		.port_ops	= &mv_sata_ops,
 	},
 };
 
@@ -151,6 +239,590 @@ module_param(ahci_em_messages, int, 0444);
 MODULE_PARM_DESC(ahci_em_messages,
 	"Set AHCI Enclosure Management Message type (0 = disabled, 1 = LED");
 
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
+static void ahci_dump_port_common(struct ata_port *ap)
+{
+	void __iomem *mmio = ahci_port_base(ap);
+
+	printk(KERN_ERR
+	       "%s %x, "
+	       "%s %x, "
+	       "%s %x, "
+	       "%s %x, "
+	       "%s %x, "
+	       "%s %x, "
+	       "%s %x\n"
+	       ,
+	       "PORT_LST_ADDR",	readl(mmio + PORT_LST_ADDR),
+	       "PORT_LST_ADDR_HI", readl(mmio + PORT_LST_ADDR_HI),
+	       "PORT_IRQ_STAT",	readl(mmio + PORT_IRQ_STAT),
+	       "PORT_IRQ_MASK",	readl(mmio + PORT_IRQ_MASK),
+	       "PORT_CMD",	readl(mmio + PORT_CMD),
+	       "PORT_CMD_ISSUE",readl(mmio + PORT_CMD_ISSUE),
+	       "PORT_SIG",	readl(mmio + PORT_SIG));
+}
+
+static void mvp_dump_port(struct ata_port *ap)
+{
+	void __iomem *mmio = ahci_port_base(ap);
+
+	printk(KERN_ERR
+	       "TF dev0 %x %x %x, dev1 %x %x %x\n",
+	       readl(mmio + MVP_D0_TF0),
+	       readl(mmio + MVP_D0_TF1),
+	       readl(mmio + MVP_D0_TF2),
+
+	       readl(mmio + MVP_D1_TF0),
+	       readl(mmio + MVP_D1_TF1),
+	       readl(mmio + MVP_D1_TF2)
+
+	       );
+}
+
+static void ahci_dump_port_sata(struct ata_port *ap)
+{
+	void __iomem *mmio = ahci_port_base(ap);
+
+	printk(KERN_ERR
+	       "%s %x, "
+	       "%s %x, "
+	       "%s %x, "
+	       "%s %x, "
+	       "%s %x\n"
+	       ,
+	       "PORT_SCR_STAT",
+	       readl(mmio + PORT_SCR_STAT),
+	       "PORT_SCR_CTL",
+	       readl(mmio + PORT_SCR_CTL),
+	       "PORT_SCR_ERR",
+	       readl(mmio + PORT_SCR_ERR),
+	       "PORT_SCR_ACT",
+	       readl(mmio + PORT_SCR_ACT),
+	       "PORT_SCR_NTF",
+	       readl(mmio + PORT_SCR_NTF)
+	       );
+}
+
+static void mv_ahci_dump_port(struct ata_port *ap)
+{
+	ahci_dump_port_common(ap);
+
+	if (ap->flags & AHCI_FLAG_MV_PATA) {
+		mvp_dump_port(ap);
+	} else {
+		ahci_dump_port_sata(ap);
+	}
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
+
+	if (qc->tf.command == ATA_CMD_DEV_RESET)
+		opts |= MVP_CMD_ATAPI_RST;
+	else if (qc->tf.command == ATA_CMD_EDD)
+		opts |= MVP_CMD_EDD;
+
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
+
+	if (is_multi_taskfile(&qc->tf))
+		opts |= (qc->dev->multi_count & 0x1f);
+	else
+		opts |= 1;
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
+	DPRINTK("ENTER\n");
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
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 status, qc_active;
+	int rc;
+
+	VPRINTK("ENTER, port == %u\n", ap->port_no);
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
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 tmp;
+
+	DPRINTK("ENTER\n");
+
+#if 0
+	ahci_stop_engine(ap);
+#endif
+
+	tmp = readl(port_mmio + PORT_CMD);
+	tmp |= MVP_CMD_HW_RST;
+	writel(tmp, port_mmio + PORT_CMD);
+	readl(port_mmio + PORT_CMD);	/* flush */
+
+	udelay(20);	/* paranoia - give bit time to assert? */
+
+	tmp = ata_wait_register(port_mmio + PORT_CMD,
+				MVP_CMD_HW_RST, MVP_CMD_HW_RST, 1, 500);
+	if (tmp & MVP_CMD_HW_RST) {
+		ata_port_printk(ap, KERN_ERR,
+				"hard reset timed out (errno=%d)\n", -EIO);
+		return -EIO;
+	}
+
+	msleep(2);
+
+#if 0
+	ahci_start_engine(ap);
+#endif
+
+	mv_ahci_dump_port(ap);
+
+	DPRINTK("EXIT EAGAIN (force softreset)\n");
+	return -EAGAIN;
+}
+
+static void mvp_mk_ctrl_cmd(void *cmd_block, int cmd_idx, bool read_tf,
+			    bool is_slave, u8 tf_addr, u8 tf_data)
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
+static bool mvp_ctrl_cmd(struct ata_port *ap, struct ahci_port_priv *pp,
+			 void __iomem *mmio, void __iomem *port_mmio,
+			 bool is_slave, u8 tf_addr, u8 tf_data,
+			 unsigned long timeout_msecs)
+{
+	void *cmd_tbl;
+	u32 opts, tmp;
+	void __iomem *poll_mmio = port_mmio;
+	int i;
+
+	cmd_tbl = pp->cmd_tbl + (0 * AHCI_CMD_TBL_SZ);
+	opts = MVP_CMD_CONTROLLER | 1;
+
+	/* fill in controller cmd #0, in slot #0 */
+	mvp_mk_ctrl_cmd(cmd_tbl, 0, false, is_slave, tf_addr, tf_data);
+	ahci_fill_cmd_slot(pp, 0, opts);
+
+	/* issue PATA controller command */
+	writel(1, port_mmio + PORT_CMD_ISSUE);
+	readl(port_mmio + PORT_CMD_ISSUE);	/* flush */
+
+	/* wait for bit 0 to clear */
+	tmp = ata_wait_register(port_mmio + PORT_CMD_ISSUE, 0x1, 0x1,
+				1, timeout_msecs);
+	if (tmp) {
+		ata_port_printk(ap, KERN_WARNING,
+				"PATA ctrl cmd issue timeout (%x, %s)\n",
+				tmp,
+				is_slave ? "slave" : "master");
+
+		return false;
+	}
+
+	tmp = readl(port_mmio + PORT_IRQ_STAT);
+	writel(tmp, port_mmio + PORT_IRQ_STAT);
+	writel(1 << ap->port_no, mmio + HOST_IRQ_STAT);
+
+	if (is_slave)
+		poll_mmio += MVP_D1_TF0;
+	else
+		poll_mmio += MVP_D0_TF0;
+
+	for (i = 0; i < 1000; i++) {
+		tmp = readl(poll_mmio) & 0xff;
+		if ((tmp & ATA_BUSY) == 0)
+			return true;
+
+		msleep(1);
+	}
+
+	ata_port_printk(ap, KERN_INFO, "PATA ctrl cmd BSY timeout (%x, %s)\n",
+			tmp,
+			is_slave ? "slave" : "master");
+
+	/* if any bits remain set, the operation has not completed (fail) */
+	return false;
+}
+
+static int mvp_softreset(struct ata_link *link, unsigned int *class,
+			 unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
+#if 0
+	const char *reason = NULL;
+	int rc;
+#endif
+	unsigned long now, msecs;
+	int i, j;
+	u8 err = 0;
+	bool is_slave;
+
+	DPRINTK("ENTER\n");
+
+#if 0
+	/* prepare for SRST (AHCI-1.1 10.4.1) */
+	rc = ahci_kick_engine(ap, 1);
+	if (rc && rc != -EOPNOTSUPP)
+		ata_link_printk(link, KERN_WARNING,
+				"failed to reset engine (errno=%d)\n", rc);
+#endif
+
+	msecs = 0;
+	now = jiffies;
+	if (time_after(now, deadline))
+		msecs = jiffies_to_msecs(deadline - now);
+	else
+		msecs = 1000;
+
+	/* issue SRST=1 */
+	mvp_ctrl_cmd(ap, pp, mmio, port_mmio, false, MVATA_REG_DEVCTL, ATA_SRST,
+		     msecs);
+	udelay(20);
+
+	/* issue SRST=0 */
+	mvp_ctrl_cmd(ap, pp, mmio, port_mmio, false, MVATA_REG_DEVCTL, 0,
+		     msecs);
+	msleep(150);
+
+	is_slave = false;
+	for (i = 0; i < 2; i++) {
+		bool ccrc;
+
+		for (j = 0; j < 5; j++) {
+			ccrc = mvp_ctrl_cmd(ap, pp, mmio, port_mmio, is_slave,
+				    MVATA_REG_DEVICE,
+				    ATA_DEVICE_OBS | (is_slave ? ATA_DEV1 : 0),
+			    	    1000);
+			if (ccrc)
+				break;
+		}
+
+		is_slave = true;
+	}
+
+	mv_ahci_dump_port(ap);
+
+	class[0] = ata_sff_dev_classify(&link->device[0], 1, &err);
+	if (err != 0x81)
+		class[1] = ata_sff_dev_classify(&link->device[1], 1, &err);
+
+	DPRINTK("EXIT success, class=%u,%u\n", class[0], class[1]);
+	return 0;
+
+#if 0
+ fail:
+	ata_link_printk(link, KERN_ERR, "softreset failed (%s)\n", reason);
+	return rc;
+#endif
+}
+
+static void mvp_dev_select(struct ata_port *ap, unsigned int device)
+{
+	struct ahci_port_priv *pp = ap->private_data;
+	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
+	void __iomem *port_mmio = ahci_port_base(ap);
+	bool ccrc;
+
+	DPRINTK("ENTER\n");
+
+	pp->mvp_selected = device;
+
+	ccrc = mvp_ctrl_cmd(ap, pp, mmio, port_mmio, device ? true : false,
+			    MVATA_REG_DEVICE,
+			    ATA_DEVICE_OBS | (device ? ATA_DEV1 : 0),
+			    500);
+	if (!ccrc)
+		ata_port_printk(ap, KERN_ERR, "mvp_dev_select dev%u "
+				"failed\n", device);
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
+	VPRINTK("ENTER, port_no == %d\n", port_no);
+
+	/* make sure port is not active */
+	rc = ahci_deinit_port(ap, &emsg);
+	if (rc)
+		dev_printk(KERN_WARNING, &pdev->dev,
+			   "%s (%d)\n", emsg, rc);
+
+	/* clear port IRQ */
+	tmp = readl(port_mmio + PORT_IRQ_STAT);
+	if (tmp) {
+		VPRINTK("PORT_IRQ_STAT 0x%x\n", tmp);
+		writel(tmp, port_mmio + PORT_IRQ_STAT);
+	}
+
+	writel(1 << port_no, mmio + HOST_IRQ_STAT);
+
+	/* select the IRQ events we're interested in */
+	writel(DEF_MVP_IRQ, port_mmio + PORT_IRQ_MASK);
+
+	/* init PATA port setup */
+	tmp = MVP_CMD_DEV_INT_EN;
+	tmp |= (12 << MVP_CMD_CDB_LEN);		/* TODO: un-hardcode cdb len */
+	writel(tmp, port_mmio + PORT_CMD);
+
+	msleep(100);	/* Marvell driver does this after writing PORT_CMD */
+}
+
+static int mvp_port_start(struct ata_port *ap)
+{
+	struct device *dev = ap->host->dev;
+	struct ahci_port_priv *pp;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	void *mem;
+	dma_addr_t mem_dma;
+
+	DPRINTK("ENTER\n");
+
+	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
+	if (!pp)
+		return -ENOMEM;
+
+	mem = dmam_alloc_coherent(dev, AHCI_PORT_PRIV_DMA_SZ, &mem_dma,
+				  GFP_KERNEL);
+	if (!mem)
+		return -ENOMEM;
+	memset(mem, 0, AHCI_PORT_PRIV_DMA_SZ);
+
+	/*
+	 * First item in chunk of DMA memory: 32-slot command table,
+	 * 32 bytes each in size
+	 */
+	pp->cmd_slot = mem;
+	pp->cmd_slot_dma = mem_dma;
+
+	mem += AHCI_CMD_SLOT_SZ;
+	mem_dma += AHCI_CMD_SLOT_SZ;
+
+	/*
+	 * Second item: Received-FIS area
+	 */
+	pp->rx_fis = mem;
+	pp->rx_fis_dma = mem_dma;
+
+	mem += AHCI_RX_FIS_SZ;
+	mem_dma += AHCI_RX_FIS_SZ;
+
+	/*
+	 * Third item: data area for storing a single command
+	 * and its scatter-gather table
+	 */
+	pp->cmd_tbl = mem;
+	pp->cmd_tbl_dma = mem_dma;
+
+	/*
+	 * Save off initial list of interrupts to be enabled.
+	 * This could be changed later
+	 */
+	pp->intr_mask = DEF_MVP_IRQ;
+
+	ap->private_data = pp;
+
+	/* program command list DMA data structure addresses */
+	writel((pp->cmd_slot_dma >> 16) >> 16, port_mmio + PORT_LST_ADDR_HI);
+	writel(pp->cmd_slot_dma & 0xffffffff, port_mmio + PORT_LST_ADDR);
+
+	/* enable DMA */
+	ahci_start_engine(ap);
+
+	msleep(100);	/* Marvell driver does this after writing PORT_CMD */
+
+	DPRINTK("EXIT(0)\n");
+	return 0;
+}
+
 static irqreturn_t mv_ahci_interrupt(int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
@@ -159,8 +831,6 @@ static irqreturn_t mv_ahci_interrupt(int irq, void *dev_instance)
 	void __iomem *mmio;
 	u32 irq_stat, irq_masked;
 
-	VPRINTK("ENTER\n");
-
 	hpriv = host->private_data;
 	mmio = host->iomap[AHCI_PCI_BAR];
 
@@ -169,6 +839,8 @@ static irqreturn_t mv_ahci_interrupt(int irq, void *dev_instance)
 	if (!irq_stat)
 		return IRQ_NONE;
 
+	VPRINTK("ENTER, irq_stat 0x%x\n", irq_stat);
+
 	irq_masked = irq_stat & hpriv->port_map;
 
 	spin_lock(&host->lock);
@@ -181,7 +853,10 @@ static irqreturn_t mv_ahci_interrupt(int irq, void *dev_instance)
 
 		ap = host->ports[i];
 		if (ap) {
-			ahci_port_intr(ap);
+			if (ap->flags & AHCI_FLAG_MV_PATA)
+				mvp_port_intr(ap);
+			else
+				ahci_port_intr(ap);
 			VPRINTK("port %u\n", i);
 		} else {
 			VPRINTK("port %u (no irq)\n", i);
@@ -211,6 +886,34 @@ static irqreturn_t mv_ahci_interrupt(int irq, void *dev_instance)
 	return IRQ_RETVAL(handled);
 }
 
+static void mv_ahci_init_controller(struct ata_host *host)
+{
+	struct pci_dev *pdev = to_pci_dev(host->dev);
+	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
+	int i;
+	void __iomem *port_mmio;
+	u32 tmp;
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		port_mmio = ahci_port_base(ap);
+		if (ata_port_is_dummy(ap))
+			continue;
+
+		if (ap->flags & AHCI_FLAG_MV_PATA)
+			mvp_port_init(pdev, ap, i, mmio, port_mmio);
+		else
+			ahci_port_init(pdev, ap, i, mmio, port_mmio);
+	}
+
+	tmp = readl(mmio + HOST_CTL);
+	VPRINTK("HOST_CTL 0x%x\n", tmp);
+	writel(tmp | HOST_IRQ_EN, mmio + HOST_CTL);
+	tmp = readl(mmio + HOST_CTL);
+	VPRINTK("HOST_CTL 0x%x\n", tmp);
+}
+
 static int mv_ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
@@ -220,7 +923,7 @@ static int mv_ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *en
 	struct device *dev = &pdev->dev;
 	struct ahci_host_priv *hpriv;
 	struct ata_host *host;
-	int n_ports, i, rc;
+	int n_ports, i, rc, mvp_port;
 
 	VPRINTK("ENTER\n");
 
@@ -306,6 +1009,15 @@ static int mv_ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *en
 	if (pi.flags & ATA_FLAG_EM)
 		ahci_reset_em(host);
 
+	switch (pdev->device) {
+	case 0x6121:
+		mvp_port = 2;		/* count starts from zero */
+		break;
+	default:
+		mvp_port = 4;		/* count starts from zero */
+		break;
+	}
+
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 
@@ -320,10 +1032,26 @@ static int mv_ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *en
 		if (ap->flags & ATA_FLAG_EM)
 			ap->em_message_type = ahci_em_messages;
 
+		/* switch to Marvell PATA port operations, flags */
+		if ((i == mvp_port) && (hpriv->port_map & (1 << i))) {
+			ap->flags = ATA_FLAG_SLAVE_POSS |
+				    ATA_FLAG_NO_LEGACY |
+				    ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
+				    AHCI_FLAG_MV_PATA;
+			ap->ops = &mv_pata_ops;
+
+			VPRINTK("set up PATA port %d\n", i);
+		}
 
 		/* disabled/not-implemented port */
-		if (!(hpriv->port_map & (1 << i)))
+		else if (!(hpriv->port_map & (1 << i))) {
 			ap->ops = &ata_dummy_port_ops;
+			VPRINTK("set up dummy port %d\n", i);
+		}
+
+		else {
+			VPRINTK("set up SATA port %d\n", i);
+		}
 	}
 
 	/* initialize adapter */
@@ -335,7 +1063,7 @@ static int mv_ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *en
 	if (rc)
 		return rc;
 
-	ahci_init_controller(host);
+	mv_ahci_init_controller(host);
 	ahci_print_info(host);
 
 	pci_set_master(pdev);
