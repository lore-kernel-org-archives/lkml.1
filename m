Return-Path: <linux-kernel-owner+w=401wt.eu-S1762304AbZDHF4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762304AbZDHF4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757004AbZDHF41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:56:27 -0400
Received: from havoc.gtf.org ([69.61.125.42]:45390 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbZDHF40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:56:26 -0400
Date: Wed, 8 Apr 2009 01:56:25 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, jameshsu@acard.com,
       jason_wu@acard.com, derwei@acard.com, laurence@acard.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ahci: add ACard 8620 support (rough draft)
Message-ID: <20090408055625.GA27810@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds support for a 99% compatible AHCI clone, ACard 8620.

Its datasheet has been public for quite a while, contributed by ACard
themselves:
http://gkernel.sourceforge.net/specs/acard/ATP8620pub_Rev0.98.pdf

These changes are guesses based on the PDF and notes from an ACard
engineer.  I do not have hardware, and have no way of testing this
patch.


diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 57be6be..dea25e0 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -114,6 +114,7 @@ enum {
 	board_ahci_sb700	= 5, /* for SB700 and SB800 */
 	board_ahci_mcp65	= 6,
 	board_ahci_nopmp	= 7,
+	board_ahci_acard	= 8,
 
 	/* global controller registers */
 	HOST_CAP		= 0x00, /* host capabilities */
@@ -156,6 +157,7 @@ enum {
 	PORT_SCR_ERR		= 0x30, /* SATA phy register: SError */
 	PORT_SCR_ACT		= 0x34, /* SATA phy register: SActive */
 	PORT_SCR_NTF		= 0x3c, /* SATA phy register: SNotification */
+	PORT_SDB_FISBITS	= 0x44,	/* ACard: SDB FIS bits, RW1C */
 
 	/* PORT_IRQ_{STAT,MASK} bits */
 	PORT_IRQ_COLD_PRES	= (1 << 31), /* cold presence detect */
@@ -250,6 +252,13 @@ struct ahci_sg {
 	__le32			flags_size;
 };
 
+struct acard_sg {
+	__le32			addr;
+	__le32			addr_hi;
+	__le32			flags;		/* bit 31 == EOT */
+	__le32			size;		/* max==0x10000 (64k) */
+};
+
 struct ahci_em_priv {
 	enum sw_activity blink_policy;
 	struct timer_list timer;
@@ -292,6 +301,7 @@ static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc);
 static int ahci_port_start(struct ata_port *ap);
 static void ahci_port_stop(struct ata_port *ap);
 static void ahci_qc_prep(struct ata_queued_cmd *qc);
+static void acard_qc_prep(struct ata_queued_cmd *qc);
 static void ahci_freeze(struct ata_port *ap);
 static void ahci_thaw(struct ata_port *ap);
 static void ahci_pmp_attach(struct ata_port *ap);
@@ -311,7 +321,6 @@ static void ahci_error_handler(struct ata_port *ap);
 static void ahci_post_internal_cmd(struct ata_queued_cmd *qc);
 static int ahci_port_resume(struct ata_port *ap);
 static void ahci_dev_config(struct ata_device *dev);
-static unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl);
 static void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
 			       u32 opts);
 #ifdef CONFIG_PM
@@ -346,6 +355,19 @@ static struct scsi_host_template ahci_sht = {
 	.sdev_attrs		= ahci_sdev_attrs,
 };
 
+static struct scsi_host_template acard_sht = {
+	ATA_NCQ_SHT(DRV_NAME),
+	.can_queue		= AHCI_MAX_CMDS - 1,
+	.sg_tablesize		= AHCI_MAX_SG,
+
+	/* we don't really care about the DMA boundary... we use this
+	 * to limit our DMA segment size to 64k
+	 */
+	.dma_boundary		= ATA_DMA_BOUNDARY,
+	.shost_attrs		= ahci_shost_attrs,
+	.sdev_attrs		= ahci_sdev_attrs,
+};
+
 static struct ata_port_operations ahci_ops = {
 	.inherits		= &sata_pmp_port_ops,
 
@@ -399,6 +421,11 @@ static struct ata_port_operations ahci_sb600_ops = {
 	.pmp_softreset		= ahci_sb600_softreset,
 };
 
+static struct ata_port_operations acard_ops = {
+	.inherits		= &ahci_ops,
+	.qc_prep		= acard_qc_prep,
+};
+
 #define AHCI_HFLAGS(flags)	.private_data	= (void *)(flags)
 
 static const struct ata_port_info ahci_port_info[] = {
@@ -469,6 +496,13 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
+	/* board_ahci_acard */
+	{
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &acard_ops,
+	},
 };
 
 static const struct pci_device_id ahci_pci_tbl[] = {
@@ -608,6 +642,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	/* Promise */
 	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */
 
+	/* ACard */
+	{ PCI_VDEVICE(ARTOP, 0x000D), board_ahci_acard },
+
 	/* Generic, PCI class code for AHCI */
 	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci },
@@ -1948,6 +1985,78 @@ static void ahci_qc_prep(struct ata_queued_cmd *qc)
 	ahci_fill_cmd_slot(pp, qc->tag, opts);
 }
 
+static unsigned int acard_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl)
+{
+	struct scatterlist *sg;
+	struct acard_sg *acard_sg = cmd_tbl + AHCI_CMD_TBL_HDR_SZ;
+	unsigned int si, last_si = 0;
+
+	VPRINTK("ENTER\n");
+
+	/*
+	 * Next, the S/G list.
+	 */
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
+		dma_addr_t addr = sg_dma_address(sg);
+		u32 sg_len = sg_dma_len(sg);
+
+		/* ACard note: flags and size are different
+		 * fields, rather than AHCI's flags_size,
+		 * we must set an end-of-table (EOT) bit,
+		 * and the segment cannot exceed 64k (0x10000)
+		 */
+		acard_sg[si].addr = cpu_to_le32(addr & 0xffffffff);
+		acard_sg[si].addr_hi = cpu_to_le32((addr >> 16) >> 16);
+		acard_sg[si].flags = 0;
+		acard_sg[si].size = cpu_to_le32(sg_len);
+		last_si = si;
+	}
+
+	acard_sg[last_si].flags |= cpu_to_le32(1 << 31);	/* set EOT */
+
+	return si;
+}
+
+static void acard_qc_prep(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	int is_atapi = ata_is_atapi(qc->tf.protocol);
+	void *cmd_tbl;
+	u32 opts;
+	const u32 cmd_fis_len = 5; /* five dwords */
+	unsigned int n_elem;
+
+	/*
+	 * Fill in command table information.  First, the header,
+	 * a SATA Register - Host to Device command FIS.
+	 */
+	cmd_tbl = pp->cmd_tbl + qc->tag * AHCI_CMD_TBL_SZ;
+
+	ata_tf_to_fis(&qc->tf, qc->dev->link->pmp, 1, cmd_tbl);
+	if (is_atapi) {
+		memset(cmd_tbl + AHCI_CMD_TBL_CDB, 0, 32);
+		memcpy(cmd_tbl + AHCI_CMD_TBL_CDB, qc->cdb, qc->dev->cdb_len);
+	}
+
+	n_elem = 0;
+	if (qc->flags & ATA_QCFLAG_DMAMAP)
+		n_elem = acard_fill_sg(qc, cmd_tbl);
+
+	/*
+	 * Fill in command slot information.
+	 *
+	 * ACard note: prd table length not filled in
+	 */
+	opts = cmd_fis_len | (qc->dev->link->pmp << 12);
+	if (qc->tf.flags & ATA_TFLAG_WRITE)
+		opts |= AHCI_CMD_WRITE;
+	if (is_atapi)
+		opts |= AHCI_CMD_ATAPI | AHCI_CMD_PREFETCH;
+
+	ahci_fill_cmd_slot(pp, qc->tag, opts);
+}
+
 static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 {
 	struct ahci_host_priv *hpriv = ap->host->private_data;
@@ -2610,6 +2719,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct device *dev = &pdev->dev;
 	struct ahci_host_priv *hpriv;
 	struct ata_host *host;
+	struct scsi_host_template *sht;
 	int n_ports, i, rc;
 
 	VPRINTK("ENTER\n");
@@ -2762,9 +2872,14 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ahci_init_controller(host);
 	ahci_print_info(host);
 
+	if (pdev->vendor == PCI_VENDOR_ID_ARTOP)
+		sht = &acard_sht;
+	else
+		sht = &ahci_sht;
+
 	pci_set_master(pdev);
 	return ata_host_activate(host, pdev->irq, ahci_interrupt, IRQF_SHARED,
-				 &ahci_sht);
+				 sht);
 }
 
 static int __init ahci_init(void)
