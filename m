Return-Path: <linux-kernel-owner+w=401wt.eu-S1752180AbYLYBGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbYLYBGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 20:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYLYBGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 20:06:25 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:32701 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbYLYBGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 20:06:24 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=5YrmAi_uVXungbTfkTkA:9 a=WWw7c-qyAchouf6lQbwA:7 a=26EZz-KEYBBrUPZUx6_zUNemB-UA:4 a=WQH3iRwWeA4A:10 a=TTB6PySG2qUA:10
Message-ID: <4952DC7E.2050909@shaw.ca>
Date: Wed, 24 Dec 2008 19:06:06 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>
Subject: [PATCH v2] sata_sil: add Large Block Transfer support
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements support for the Large Block Transfer feature found in Silicon
Image 311x controllers. This allows transferring bigger contiguous chunks of
data from system memory and avoids the 64KB boundary restriction of standard
SFF controllers.

This is based on a patch from Jeff Garzik (from the sii-lbt branch of
libata-dev) but includes a few bug fixes: Since the bmdma2 register does not
implement the status bits, the original bmdma register must be used except
where the bmdma2 register is required. As well the DMA boundary should be
31-bit instead of 32-bit since the top bit of the length field is still
required for the PRD end-of-table flag.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

---

This should go into -next for a while for testing. I've done some testing with
a DVD drive connected to this controller and verified that reading off an
entire DVD returns correct data (and that the controller is actually getting
requests that cross 64K boundaries). More testing would certainly be useful..

Changes from first version: use iowrite instead of writeX to write to iomapped
memory, remove unnecessary memory barrier (from code adapted from
libata-sff.c).

diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index 031d7b7..7376a32 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -46,7 +46,9 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_sil"
-#define DRV_VERSION	"2.3"
+#define DRV_VERSION	"2.4"
+
+#define SIL_DMA_BOUNDARY	0x7fffffffUL
 
 enum {
 	SIL_MMIO_BAR		= 5,
@@ -118,6 +120,10 @@ static void sil_dev_config(struct ata_device *dev);
 static int sil_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
 static int sil_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 static int sil_set_mode(struct ata_link *link, struct ata_device **r_failed);
+static void sil_qc_prep(struct ata_queued_cmd *qc);
+static void sil_bmdma_setup(struct ata_queued_cmd *qc);
+static void sil_bmdma_start(struct ata_queued_cmd *qc);
+static void sil_bmdma_stop(struct ata_queued_cmd *qc);
 static void sil_freeze(struct ata_port *ap);
 static void sil_thaw(struct ata_port *ap);
 
@@ -167,13 +173,22 @@ static struct pci_driver sil_pci_driver = {
 };
 
 static struct scsi_host_template sil_sht = {
-	ATA_BMDMA_SHT(DRV_NAME),
+	ATA_BASE_SHT(DRV_NAME),
+	/** These controllers support Large Block Transfer which allows
+	    transfer chunks up to 2GB and which cross 64KB boundaries,
+	    therefore the DMA limits are more relaxed than standard ATA SFF. */
+	.dma_boundary		= SIL_DMA_BOUNDARY,
+	.sg_tablesize		= ATA_MAX_PRD
 };
 
 static struct ata_port_operations sil_ops = {
 	.inherits		= &ata_bmdma_port_ops,
 	.dev_config		= sil_dev_config,
 	.set_mode		= sil_set_mode,
+	.bmdma_setup            = sil_bmdma_setup,
+	.bmdma_start            = sil_bmdma_start,
+	.bmdma_stop		= sil_bmdma_stop,
+	.qc_prep		= sil_qc_prep,
 	.freeze			= sil_freeze,
 	.thaw			= sil_thaw,
 	.scr_read		= sil_scr_read,
@@ -249,6 +264,83 @@ module_param(slow_down, int, 0444);
 MODULE_PARM_DESC(slow_down, "Sledgehammer used to work around random problems, by limiting commands to 15 sectors (0=off, 1=on)");
 
 
+static void sil_bmdma_stop(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	void __iomem *mmio_base = ap->host->iomap[SIL_MMIO_BAR];
+	void __iomem *bmdma2 = mmio_base + sil_port[ap->port_no].bmdma2;
+
+	/* clear start/stop bit - can safely always write 0 */
+	iowrite8(0, bmdma2);
+
+	/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
+	ata_sff_dma_pause(ap);
+}
+
+static void sil_bmdma_setup(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	void __iomem *bmdma = ap->ioaddr.bmdma_addr;
+
+	/* load PRD table addr. */
+	iowrite32(ap->prd_dma, bmdma + ATA_DMA_TABLE_OFS);
+
+	/* issue r/w command */
+	ap->ops->sff_exec_command(ap, &qc->tf);
+}
+
+static void sil_bmdma_start(struct ata_queued_cmd *qc)
+{
+	unsigned int rw = (qc->tf.flags & ATA_TFLAG_WRITE);
+	struct ata_port *ap = qc->ap;
+	void __iomem *mmio_base = ap->host->iomap[SIL_MMIO_BAR];
+	void __iomem *bmdma2 = mmio_base + sil_port[ap->port_no].bmdma2;
+	u8 dmactl = ATA_DMA_START;
+
+	/* set transfer direction, start host DMA transaction
+	   Note: For Large Block Transfer to work, the DMA must be started
+	   using the bmdma2 register. */
+	if (!rw)
+		dmactl |= ATA_DMA_WR;
+	iowrite8(dmactl, bmdma2);
+}
+
+/* The way God intended PCI IDE scatter/gather lists to look and behave... */
+static void sil_fill_sg(struct ata_queued_cmd *qc)
+{
+	struct scatterlist *sg;
+	struct ata_port *ap = qc->ap;
+	struct ata_prd *prd, *last_prd = NULL;
+	unsigned int si;
+
+	prd = &ap->prd[0];
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
+		/* Note h/w doesn't support 64-bit, so we unconditionally
+		 * truncate dma_addr_t to u32.
+		 */
+		u32 addr = (u32) sg_dma_address(sg);
+		u32 sg_len = sg_dma_len(sg);
+
+		prd->addr = cpu_to_le32(addr);
+		prd->flags_len = cpu_to_le32(sg_len);
+		VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", pi, addr, sg_len);
+
+		last_prd = prd;
+		prd++;
+	}
+
+	if (likely(last_prd))
+		last_prd->flags_len |= cpu_to_le32(ATA_PRD_EOT);
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

