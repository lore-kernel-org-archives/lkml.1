Return-Path: <linux-kernel-owner+w=401wt.eu-S1761147AbXESFfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761147AbXESFfo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 01:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbXESFff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 01:35:35 -0400
Received: from havoc.gtf.org ([69.61.125.42]:39392 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbXESFfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 01:35:34 -0400
Date: Sat, 19 May 2007 01:35:32 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] sata_sil: Greatly improve DMA support
Message-ID: <20070519053532.GA32522@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Since Alan expressed a desire to see Large Block Transfer (LBT) support
in pata_sil680, I though I would re-post my patch for adding LBT support
to sata_sil.

Silicon Image's Large Block Transfer (LBT) support is a vendor-specific
DMA scatter/gather engine, which enables 64-bit DMA addresses (where
supported by platform) and eliminates the annoying 64k DMA boundary
found in legacy PCI IDE BMDMA engines.

This hardware is open hardware.  Docs for both PATA and SATA can be
found at http://gkernel.sourceforge.net/specs/sii/

LBT support works the same way in both pata_sil680 and sata_sil, so
maybe a motivated individual could take use this patch as an inspiration
for doing the same thing with pata_sil680.

NOTE:  This patch works for me on x86 and x86-64.  However, other
testers reported problems, which is why it is not upstream.

These changes can be found in the 'sii-lbt' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

commit cde8d26737acdb5d8b00f6f0952a0241863ca5fa
    [libata sii-lbt] sata_sil: warning fix
    
commit 22c63ef4beb7c0a09ecfa61b4d3a884cb4eadfa0
    [libata] sata_sil sii-lbt: iomap build fix
    
commit b2a4d29570403f611689e786372e8a4afbdf8891
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Dec 1 22:58:31 2006 -0500

    [libata sata_sil] Greatly improve DMA handling
    
    311x hardware includes a vendor-specific scatter/gather format which
    eliminates the traditional 64k boundary limit found in PCI IDE DMA.
    
    Since implementing this feature required custom implementations of the
    bmdma_xxx hooks, I took the opportunity to eliminate a few unnecessary
    MMIO register reads/writes.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/ata/sata_sil.c |  111 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 101 insertions(+), 10 deletions(-)

diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index e8483aa..c44c398 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -46,7 +46,11 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_sil"
-#define DRV_VERSION	"2.2"
+#define DRV_VERSION	"2.2lbt"
+
+enum {
+	SIL_DMA_BOUNDARY	= 0xffffffffU,
+};
 
 enum {
 	SIL_MMIO_BAR		= 5,
@@ -118,6 +122,11 @@ static void sil_dev_config(struct ata_device *dev);
 static u32 sil_scr_read (struct ata_port *ap, unsigned int sc_reg);
 static void sil_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
 static int sil_set_mode (struct ata_port *ap, struct ata_device **r_failed);
+static void sil_qc_prep(struct ata_queued_cmd *qc);
+static void sil_bmdma_setup (struct ata_queued_cmd *qc);
+static void sil_bmdma_start (struct ata_queued_cmd *qc);
+static void sil_bmdma_stop(struct ata_queued_cmd *qc);
+static irqreturn_t sil_interrupt(int irq, void *dev_instance);
 static void sil_freeze(struct ata_port *ap);
 static void sil_thaw(struct ata_port *ap);
 
@@ -173,12 +182,12 @@ static struct scsi_host_template sil_sht = {
 	.queuecommand		= ata_scsi_queuecmd,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
-	.sg_tablesize		= LIBATA_MAX_PRD,
+	.sg_tablesize		= ATA_MAX_PRD,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
 	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
 	.proc_name		= DRV_NAME,
-	.dma_boundary		= ATA_DMA_BOUNDARY,
+	.dma_boundary		= SIL_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
@@ -193,11 +202,11 @@ static const struct ata_port_operations sil_ops = {
 	.exec_command		= ata_exec_command,
 	.dev_select		= ata_std_dev_select,
 	.set_mode		= sil_set_mode,
-	.bmdma_setup            = ata_bmdma_setup,
-	.bmdma_start            = ata_bmdma_start,
-	.bmdma_stop		= ata_bmdma_stop,
+	.bmdma_setup            = sil_bmdma_setup,
+	.bmdma_start            = sil_bmdma_start,
+	.bmdma_stop		= sil_bmdma_stop,
 	.bmdma_status		= ata_bmdma_status,
-	.qc_prep		= ata_qc_prep,
+	.qc_prep		= sil_qc_prep,
 	.qc_issue		= ata_qc_issue_prot,
 	.data_xfer		= ata_data_xfer,
 	.freeze			= sil_freeze,
@@ -262,8 +271,9 @@ static const struct {
 	unsigned long sfis_cfg;	/* SATA FIS reception config register */
 } sil_port[] = {
 	/* port 0 ... */
-	{ 0x80, 0x8A, 0x00, 0x10, 0x40, 0x100, 0x148, 0xb4, 0x14c },
-	{ 0xC0, 0xCA, 0x08, 0x18, 0x44, 0x180, 0x1c8, 0xf4, 0x1cc },
+	/*   tf    ctl  bmdma  bmdma2  fifo    scr   sien   mode   sfis */
+	{  0x80,  0x8A,   0x0,  0x10,  0x40, 0x100, 0x148,  0xb4, 0x14c },
+	{  0xC0,  0xCA,   0x8,  0x18,  0x44, 0x180, 0x1c8,  0xf4, 0x1cc },
 	{ 0x280, 0x28A, 0x200, 0x210, 0x240, 0x300, 0x348, 0x2b4, 0x34c },
 	{ 0x2C0, 0x2CA, 0x208, 0x218, 0x244, 0x380, 0x3c8, 0x2f4, 0x3cc },
 	/* ... port 3 */
@@ -280,6 +290,87 @@ module_param(slow_down, int, 0444);
 MODULE_PARM_DESC(slow_down, "Sledgehammer used to work around random problems, by limiting commands to 15 sectors (0=off, 1=on)");
 
 
+static void sil_bmdma_stop(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	void __iomem *mmio = (void __iomem *) ap->ioaddr.bmdma_addr;
+	u32 val;
+
+	/* clear start/stop bit */
+	if (ap->port_no == 2)
+		val = SIL_INTR_STEERING;
+	else
+		val = 0;
+	writeb(val, mmio + ATA_DMA_CMD);
+
+	/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
+	ata_altstatus(ap);        /* dummy read */
+}
+
+static void sil_bmdma_setup (struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	void __iomem *mmio_base = ap->host->iomap[SIL_MMIO_BAR];
+	void __iomem *mmio;
+
+	mmio = mmio_base + sil_port[ap->port_no].bmdma;
+
+	/* load PRD table addr. */
+	mb();	/* make sure PRD table writes are visible to controller */
+	writel(ap->prd_dma, mmio + ATA_DMA_TABLE_OFS);
+
+	/* issue r/w command */
+	ata_exec_command(ap, &qc->tf);
+}
+
+static void sil_bmdma_start (struct ata_queued_cmd *qc)
+{
+	unsigned int rw = (qc->tf.flags & ATA_TFLAG_WRITE);
+	struct ata_port *ap = qc->ap;
+	void __iomem *mmio_base = ap->host->iomap[SIL_MMIO_BAR];
+	void __iomem *mmio;
+	u8 dmactl;
+
+	mmio = mmio_base + sil_port[ap->port_no].bmdma2;
+
+	/* set transfer direction, start host DMA transaction */
+	dmactl = readb(mmio + ATA_DMA_CMD);
+	dmactl &= ~ATA_DMA_WR;
+	if (!rw)
+		dmactl |= ATA_DMA_WR;
+	writeb(dmactl | ATA_DMA_START, mmio + ATA_DMA_CMD);
+}
+
+/* The way God intended PCI IDE scatter/gather lists to look and behave... */
+static inline void sil_fill_sg(struct ata_queued_cmd *qc)
+{
+	struct scatterlist *sg;
+	struct ata_port *ap = qc->ap;
+	struct ata_prd *prd;
+
+	prd = &ap->prd[0];
+	ata_for_each_sg(sg, qc) {
+		u32 addr = sg_dma_address(sg);
+		u32 sg_len = sg_dma_len(sg);
+
+		prd->addr = cpu_to_le32(addr);
+		prd->flags_len = cpu_to_le32(sg_len);
+
+		if (ata_sg_is_last(sg, qc))
+			prd->flags_len |= cpu_to_le32(ATA_PRD_EOT);
+
+		prd++;
+	}
+}
+
+static void sil_qc_prep(struct ata_queued_cmd *qc)
+{
+	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
+		return;
+
+	sil_fill_sg(qc);
+}
+
 static unsigned char sil_get_device_cache_line(struct pci_dev *pdev)
 {
 	u8 cache_line = 0;
@@ -683,7 +774,7 @@ static int sil_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 		ioaddr->cmd_addr = mmio_base + sil_port[i].tf;
 		ioaddr->altstatus_addr =
 		ioaddr->ctl_addr = mmio_base + sil_port[i].ctl;
-		ioaddr->bmdma_addr = mmio_base + sil_port[i].bmdma;
+		ioaddr->bmdma_addr = mmio_base + sil_port[i].bmdma2;
 		ioaddr->scr_addr = mmio_base + sil_port[i].scr;
 		ata_std_ports(ioaddr);
 	}
