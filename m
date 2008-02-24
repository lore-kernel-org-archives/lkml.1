Return-Path: <linux-kernel-owner+w=401wt.eu-S1760090AbYBXFf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090AbYBXFf0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 00:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbYBXFfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 00:35:12 -0500
Received: from havoc.gtf.org ([69.61.125.42]:44461 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910AbYBXFfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 00:35:09 -0500
Date: Sun, 24 Feb 2008 00:35:08 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20080224053508.GA17530@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c        |   23 +++++++++++++++++------
 drivers/ata/libata-core.c |   16 ++++++++++------
 drivers/ata/libata-pmp.c  |    4 ++--
 drivers/ata/libata-scsi.c |    3 ++-
 drivers/ata/pata_atiixp.c |    4 ++--
 drivers/ata/sata_fsl.c    |    8 +++++---
 include/linux/ata.h       |    5 +++++
 include/linux/libata.h    |    1 +
 8 files changed, 44 insertions(+), 20 deletions(-)

Alan Cox (1):
      pata_atiixp: Use 255 sector limit

Anton Vorontsov (1):
      sata_fsl: fix build with ATA_VERBOSE_DEBUG

Mark Lord (1):
      libata-pmp: clear hob for pmp register accesses

Pavel Machek (1):
      power_state: get rid of write-only variable in SATA

Randy Dunlap (1):
      libata-core: fix kernel-doc warning

Shane Huang (1):
      [libata] ahci: AMD SB700/SB800 SATA support 64bit DMA

Tejun Heo (1):
      libata: automatically use DMADIR if drive/bridge requires it

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 6dd12f7..1db93b6 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -85,6 +85,7 @@ enum {
 	board_ahci_ign_iferr	= 2,
 	board_ahci_sb600	= 3,
 	board_ahci_mv		= 4,
+	board_ahci_sb700	= 5,
 
 	/* global controller registers */
 	HOST_CAP		= 0x00, /* host capabilities */
@@ -442,6 +443,16 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
+	/* board_ahci_sb700 */
+	{
+		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL |
+				 AHCI_HFLAG_NO_PMP),
+		.flags		= AHCI_FLAG_COMMON,
+		.link_flags	= AHCI_LFLAG_COMMON,
+		.pio_mask	= 0x1f, /* pio0-4 */
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
 };
 
 static const struct pci_device_id ahci_pci_tbl[] = {
@@ -484,12 +495,12 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 
 	/* ATI */
 	{ PCI_VDEVICE(ATI, 0x4380), board_ahci_sb600 }, /* ATI SB600 */
-	{ PCI_VDEVICE(ATI, 0x4390), board_ahci_sb600 }, /* ATI SB700/800 */
-	{ PCI_VDEVICE(ATI, 0x4391), board_ahci_sb600 }, /* ATI SB700/800 */
-	{ PCI_VDEVICE(ATI, 0x4392), board_ahci_sb600 }, /* ATI SB700/800 */
-	{ PCI_VDEVICE(ATI, 0x4393), board_ahci_sb600 }, /* ATI SB700/800 */
-	{ PCI_VDEVICE(ATI, 0x4394), board_ahci_sb600 }, /* ATI SB700/800 */
-	{ PCI_VDEVICE(ATI, 0x4395), board_ahci_sb600 }, /* ATI SB700/800 */
+	{ PCI_VDEVICE(ATI, 0x4390), board_ahci_sb700 }, /* ATI SB700/800 */
+	{ PCI_VDEVICE(ATI, 0x4391), board_ahci_sb700 }, /* ATI SB700/800 */
+	{ PCI_VDEVICE(ATI, 0x4392), board_ahci_sb700 }, /* ATI SB700/800 */
+	{ PCI_VDEVICE(ATI, 0x4393), board_ahci_sb700 }, /* ATI SB700/800 */
+	{ PCI_VDEVICE(ATI, 0x4394), board_ahci_sb700 }, /* ATI SB700/800 */
+	{ PCI_VDEVICE(ATI, 0x4395), board_ahci_sb700 }, /* ATI SB700/800 */
 
 	/* VIA */
 	{ PCI_VDEVICE(VIA, 0x3349), board_ahci_vt8251 }, /* VIA VT8251 */
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4cf8662..fbc2435 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -153,7 +153,7 @@ MODULE_VERSION(DRV_VERSION);
 
 /**
  *	ata_force_cbl - force cable type according to libata.force
- *	@link: ATA link of interest
+ *	@ap: ATA port of interest
  *
  *	Force cable type according to libata.force and whine about it.
  *	The last entry which has matching port number is used, so it
@@ -2396,6 +2396,7 @@ int ata_dev_configure(struct ata_device *dev)
 	else if (dev->class == ATA_DEV_ATAPI) {
 		const char *cdb_intr_string = "";
 		const char *atapi_an_string = "";
+		const char *dma_dir_string = "";
 		u32 sntf;
 
 		rc = atapi_cdb_len(id);
@@ -2436,13 +2437,19 @@ int ata_dev_configure(struct ata_device *dev)
 			cdb_intr_string = ", CDB intr";
 		}
 
+		if (atapi_dmadir || atapi_id_dmadir(dev->id)) {
+			dev->flags |= ATA_DFLAG_DMADIR;
+			dma_dir_string = ", DMADIR";
+		}
+
 		/* print device info to dmesg */
 		if (ata_msg_drv(ap) && print_info)
 			ata_dev_printk(dev, KERN_INFO,
-				       "ATAPI: %s, %s, max %s%s%s\n",
+				       "ATAPI: %s, %s, max %s%s%s%s\n",
 				       modelbuf, fwrevbuf,
 				       ata_mode_string(xfer_mask),
-				       cdb_intr_string, atapi_an_string);
+				       cdb_intr_string, atapi_an_string,
+				       dma_dir_string);
 	}
 
 	/* determine max_sectors */
@@ -6560,8 +6567,6 @@ int ata_host_suspend(struct ata_host *host, pm_message_t mesg)
 	ata_lpm_enable(host);
 
 	rc = ata_host_request_pm(host, mesg, 0, ATA_EHI_QUIET, 1);
-	if (rc == 0)
-		host->dev->power.power_state = mesg;
 	return rc;
 }
 
@@ -6580,7 +6585,6 @@ void ata_host_resume(struct ata_host *host)
 {
 	ata_host_request_pm(host, PMSG_ON, ATA_EH_SOFTRESET,
 			    ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 0);
-	host->dev->power.power_state = PMSG_ON;
 
 	/* reenable link pm */
 	ata_lpm_disable(host);
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index caef2bb..d91f509 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -35,7 +35,7 @@ static unsigned int sata_pmp_read(struct ata_link *link, int reg, u32 *r_val)
 	ata_tf_init(pmp_dev, &tf);
 	tf.command = ATA_CMD_PMP_READ;
 	tf.protocol = ATA_PROT_NODATA;
-	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE | ATA_TFLAG_LBA48;
 	tf.feature = reg;
 	tf.device = link->pmp;
 
@@ -71,7 +71,7 @@ static unsigned int sata_pmp_write(struct ata_link *link, int reg, u32 val)
 	ata_tf_init(pmp_dev, &tf);
 	tf.command = ATA_CMD_PMP_WRITE;
 	tf.protocol = ATA_PROT_NODATA;
-	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE | ATA_TFLAG_LBA48;
 	tf.feature = reg;
 	tf.device = link->pmp;
 	tf.nsect = val & 0xff;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index f888bab..0562b0a 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2582,7 +2582,8 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 		qc->tf.protocol = ATAPI_PROT_DMA;
 		qc->tf.feature |= ATAPI_PKT_DMA;
 
-		if (atapi_dmadir && (scmd->sc_data_direction != DMA_TO_DEVICE))
+		if ((dev->flags & ATA_DFLAG_DMADIR) &&
+		    (scmd->sc_data_direction != DMA_TO_DEVICE))
 			/* some SATA bridges need us to indicate data xfer direction */
 			qc->tf.feature |= ATAPI_DMADIR;
 	}
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index 9623f52..408bdc1 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -227,7 +227,7 @@ static struct scsi_host_template atiixp_sht = {
 	.queuecommand		= ata_scsi_queuecmd,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
-	.sg_tablesize		= LIBATA_MAX_PRD,
+	.sg_tablesize		= LIBATA_DUMB_MAX_PRD,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
 	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
@@ -259,7 +259,7 @@ static struct ata_port_operations atiixp_port_ops = {
 	.bmdma_stop	= atiixp_bmdma_stop,
 	.bmdma_status 	= ata_bmdma_status,
 
-	.qc_prep 	= ata_qc_prep,
+	.qc_prep 	= ata_dumb_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
 
 	.data_xfer	= ata_data_xfer,
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 9323dd0..07791a7 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -335,7 +335,7 @@ static unsigned int sata_fsl_fill_sg(struct ata_queued_cmd *qc, void *cmd_desc,
 	dma_addr_t indirect_ext_segment_paddr;
 	unsigned int si;
 
-	VPRINTK("SATA FSL : cd = 0x%x, prd = 0x%x\n", cmd_desc, prd);
+	VPRINTK("SATA FSL : cd = 0x%p, prd = 0x%p\n", cmd_desc, prd);
 
 	indirect_ext_segment_paddr = cmd_desc_paddr +
 	    SATA_FSL_CMD_DESC_OFFSET_TO_PRDT + SATA_FSL_MAX_PRD_DIRECT * 16;
@@ -459,7 +459,8 @@ static unsigned int sata_fsl_qc_issue(struct ata_queued_cmd *qc)
 	VPRINTK("CE=0x%x, DE=0x%x, CC=0x%x, CmdStat = 0x%x\n",
 		ioread32(CE + hcr_base),
 		ioread32(DE + hcr_base),
-		ioread32(CC + hcr_base), ioread32(COMMANDSTAT + csr_base));
+		ioread32(CC + hcr_base),
+		ioread32(COMMANDSTAT + host_priv->csr_base));
 
 	return 0;
 }
@@ -522,7 +523,8 @@ static void sata_fsl_freeze(struct ata_port *ap)
 		ioread32(CQ + hcr_base),
 		ioread32(CA + hcr_base),
 		ioread32(CE + hcr_base), ioread32(DE + hcr_base));
-	VPRINTK("CmdStat = 0x%x\n", ioread32(csr_base + COMMANDSTAT));
+	VPRINTK("CmdStat = 0x%x\n",
+		ioread32(host_priv->csr_base + COMMANDSTAT));
 
 	/* disable interrupts on the controller/port */
 	temp = ioread32(hcr_base + HCONTROL);
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 78bbaca..1c622e2 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -659,6 +659,11 @@ static inline int atapi_command_packet_set(const u16 *dev_id)
 	return (dev_id[0] >> 8) & 0x1f;
 }
 
+static inline int atapi_id_dmadir(const u16 *dev_id)
+{
+	return ata_id_major_version(dev_id) >= 7 && (dev_id[62] & 0x8000);
+}
+
 static inline int is_multi_taskfile(struct ata_taskfile *tf)
 {
 	return (tf->command == ATA_CMD_READ_MULTI) ||
diff --git a/include/linux/libata.h b/include/linux/libata.h
index ce7603a..a05f600 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -138,6 +138,7 @@ enum {
 	ATA_DFLAG_AN		= (1 << 7), /* AN configured */
 	ATA_DFLAG_HIPM		= (1 << 8), /* device supports HIPM */
 	ATA_DFLAG_DIPM		= (1 << 9), /* device supports DIPM */
+	ATA_DFLAG_DMADIR	= (1 << 10), /* device requires DMADIR */
 	ATA_DFLAG_CFG_MASK	= (1 << 12) - 1,
 
 	ATA_DFLAG_PIO		= (1 << 12), /* device limited to PIO mode */
