Return-Path: <linux-kernel-owner+w=401wt.eu-S1761772AbYCAAdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761772AbYCAAdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 19:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbYCAAdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 19:33:03 -0500
Received: from havoc.gtf.org ([69.61.125.42]:40394 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbYCAAdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 19:33:00 -0500
Date: Fri, 29 Feb 2008 19:32:59 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes, and release notes
Message-ID: <20080301003259.GA12378@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


RELEASE NOTES:

There remains an outstanding CD/DVD burning regression, which
is IMO a release blocker.  A fix exists[1], but it is still being
discussed[2].

A data corruptor fix on ATI SB600 (AHCI clone) also exists[3], and is
waiting on confirmation/feedback from AMD, but the existing workaround
(AHCI_HFLAG_32BIT_ONLY) seems to work _most_ of the time, if only by
luck.

[1] http://marc.info/?l=linux-ide&m=120418865825486&w=2
[2] http://marc.info/?t=120418867400002&r=1&w=2
[3] http://marc.info/?l=linux-ide&m=120423157501944&w=2


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-scsi.c |   10 ++++++
 drivers/ata/sata_svw.c    |   77 ++++++++++++++++++++++++++++++++++++--------
 2 files changed, 73 insertions(+), 14 deletions(-)

Anantha Subramanyam (1):
      sata_svw: Add support for HT1100 SATA controller

Jeff Garzik (1):
      [libata] wrap kmap_atomic(KM_IRQ0) with local_irq_save/restore()

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0562b0a..7b1f1ee 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1694,12 +1694,17 @@ void ata_scsi_rbuf_fill(struct ata_scsi_args *args,
 	u8 *rbuf;
 	unsigned int buflen, rc;
 	struct scsi_cmnd *cmd = args->cmd;
+	unsigned long flags;
+
+	local_irq_save(flags);
 
 	buflen = ata_scsi_rbuf_get(cmd, &rbuf);
 	memset(rbuf, 0, buflen);
 	rc = actor(args, rbuf, buflen);
 	ata_scsi_rbuf_put(cmd, rbuf);
 
+	local_irq_restore(flags);
+
 	if (rc == 0)
 		cmd->result = SAM_STAT_GOOD;
 	args->done(cmd);
@@ -2473,6 +2478,9 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
 		if ((scsicmd[0] == INQUIRY) && ((scsicmd[1] & 0x03) == 0)) {
 			u8 *buf = NULL;
 			unsigned int buflen;
+			unsigned long flags;
+
+			local_irq_save(flags);
 
 			buflen = ata_scsi_rbuf_get(cmd, &buf);
 
@@ -2490,6 +2498,8 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
 			}
 
 			ata_scsi_rbuf_put(cmd, buf);
+
+			local_irq_restore(flags);
 		}
 
 		cmd->result = SAM_STAT_GOOD;
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index 69f651e..840d1c4 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -45,6 +45,8 @@
 #include <linux/interrupt.h>
 #include <linux/device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi.h>
 #include <linux/libata.h>
 
 #ifdef CONFIG_PPC_OF
@@ -59,6 +61,7 @@ enum {
 	/* ap->flags bits */
 	K2_FLAG_SATA_8_PORTS		= (1 << 24),
 	K2_FLAG_NO_ATAPI_DMA		= (1 << 25),
+	K2_FLAG_BAR_POS_3			= (1 << 26),
 
 	/* Taskfile registers offsets */
 	K2_SATA_TF_CMD_OFFSET		= 0x00,
@@ -88,8 +91,10 @@ enum {
 	/* Port stride */
 	K2_SATA_PORT_OFFSET		= 0x100,
 
-	board_svw4			= 0,
-	board_svw8			= 1,
+	chip_svw4			= 0,
+	chip_svw8			= 1,
+	chip_svw42			= 2,	/* bar 3 */
+	chip_svw43			= 3,	/* bar 5 */
 };
 
 static u8 k2_stat_check_status(struct ata_port *ap);
@@ -97,10 +102,25 @@ static u8 k2_stat_check_status(struct ata_port *ap);
 
 static int k2_sata_check_atapi_dma(struct ata_queued_cmd *qc)
 {
+	u8 cmnd = qc->scsicmd->cmnd[0];
+
 	if (qc->ap->flags & K2_FLAG_NO_ATAPI_DMA)
 		return -1;	/* ATAPI DMA not supported */
+	else {
+		switch (cmnd) {
+		case READ_10:
+		case READ_12:
+		case READ_16:
+		case WRITE_10:
+		case WRITE_12:
+		case WRITE_16:
+			return 0;
+
+		default:
+			return -1;
+		}
 
-	return 0;
+	}
 }
 
 static int k2_sata_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
@@ -354,7 +374,7 @@ static const struct ata_port_operations k2_sata_ops = {
 };
 
 static const struct ata_port_info k2_port_info[] = {
-	/* board_svw4 */
+	/* chip_svw4 */
 	{
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 				  ATA_FLAG_MMIO | K2_FLAG_NO_ATAPI_DMA,
@@ -363,7 +383,7 @@ static const struct ata_port_info k2_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &k2_sata_ops,
 	},
-	/* board_svw8 */
+	/* chip_svw8 */
 	{
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 				  ATA_FLAG_MMIO | K2_FLAG_NO_ATAPI_DMA |
@@ -373,6 +393,24 @@ static const struct ata_port_info k2_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &k2_sata_ops,
 	},
+	/* chip_svw42 */
+	{
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
+				  ATA_FLAG_MMIO | K2_FLAG_BAR_POS_3,
+		.pio_mask	= 0x1f,
+		.mwdma_mask	= 0x07,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &k2_sata_ops,
+	},
+	/* chip_svw43 */
+	{
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
+				  ATA_FLAG_MMIO,
+		.pio_mask	= 0x1f,
+		.mwdma_mask	= 0x07,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &k2_sata_ops,
+	},
 };
 
 static void k2_sata_setup_port(struct ata_ioports *port, void __iomem *base)
@@ -402,7 +440,7 @@ static int k2_sata_init_one(struct pci_dev *pdev, const struct pci_device_id *en
 		{ &k2_port_info[ent->driver_data], NULL };
 	struct ata_host *host;
 	void __iomem *mmio_base;
-	int n_ports, i, rc;
+	int n_ports, i, rc, bar_pos;
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
@@ -416,6 +454,9 @@ static int k2_sata_init_one(struct pci_dev *pdev, const struct pci_device_id *en
 	if (!host)
 		return -ENOMEM;
 
+	bar_pos = 5;
+	if (ppi[0]->flags & K2_FLAG_BAR_POS_3)
+		bar_pos = 3;
 	/*
 	 * If this driver happens to only be useful on Apple's K2, then
 	 * we should check that here as it has a normal Serverworks ID
@@ -428,17 +469,23 @@ static int k2_sata_init_one(struct pci_dev *pdev, const struct pci_device_id *en
 	 * Check if we have resources mapped at all (second function may
 	 * have been disabled by firmware)
 	 */
-	if (pci_resource_len(pdev, 5) == 0)
+	if (pci_resource_len(pdev, bar_pos) == 0) {
+		/* In IDE mode we need to pin the device to ensure that
+			pcim_release does not clear the busmaster bit in config
+			space, clearing causes busmaster DMA to fail on
+			ports 3 & 4 */
+		pcim_pin_device(pdev);
 		return -ENODEV;
+	}
 
 	/* Request and iomap PCI regions */
-	rc = pcim_iomap_regions(pdev, 1 << 5, DRV_NAME);
+	rc = pcim_iomap_regions(pdev, 1 << bar_pos, DRV_NAME);
 	if (rc == -EBUSY)
 		pcim_pin_device(pdev);
 	if (rc)
 		return rc;
 	host->iomap = pcim_iomap_table(pdev);
-	mmio_base = host->iomap[5];
+	mmio_base = host->iomap[bar_pos];
 
 	/* different controllers have different number of ports - currently 4 or 8 */
 	/* All ports are on the same function. Multi-function device is no
@@ -483,11 +530,13 @@ static int k2_sata_init_one(struct pci_dev *pdev, const struct pci_device_id *en
  * controller
  * */
 static const struct pci_device_id k2_sata_pci_tbl[] = {
-	{ PCI_VDEVICE(SERVERWORKS, 0x0240), board_svw4 },
-	{ PCI_VDEVICE(SERVERWORKS, 0x0241), board_svw4 },
-	{ PCI_VDEVICE(SERVERWORKS, 0x0242), board_svw8 },
-	{ PCI_VDEVICE(SERVERWORKS, 0x024a), board_svw4 },
-	{ PCI_VDEVICE(SERVERWORKS, 0x024b), board_svw4 },
+	{ PCI_VDEVICE(SERVERWORKS, 0x0240), chip_svw4 },
+	{ PCI_VDEVICE(SERVERWORKS, 0x0241), chip_svw4 },
+	{ PCI_VDEVICE(SERVERWORKS, 0x0242), chip_svw8 },
+	{ PCI_VDEVICE(SERVERWORKS, 0x024a), chip_svw4 },
+	{ PCI_VDEVICE(SERVERWORKS, 0x024b), chip_svw4 },
+	{ PCI_VDEVICE(SERVERWORKS, 0x0410), chip_svw42 },
+	{ PCI_VDEVICE(SERVERWORKS, 0x0411), chip_svw43 },
 
 	{ }
 };
