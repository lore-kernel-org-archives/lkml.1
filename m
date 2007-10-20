Return-Path: <linux-kernel-owner+w=401wt.eu-S936716AbXJTDIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936716AbXJTDIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 23:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756572AbXJTDIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 23:08:22 -0400
Received: from havoc.gtf.org ([69.61.125.42]:49691 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755245AbXJTDIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 23:08:21 -0400
Date: Fri, 19 Oct 2007 23:08:20 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20071020030820.GA20260@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-core.c |    2 +-
 drivers/ata/pata_cs5536.c |    4 ++--
 drivers/ata/sata_sis.c    |   15 +++++++++------
 3 files changed, 12 insertions(+), 9 deletions(-)

Bartlomiej Zolnierkiewicz (1):
      pata_cs5536: MWDMA fix

Jeff Garzik (1):
      [libata] sata_sis: use correct S/G table size

Randy Dunlap (1):
      libata: fix kernel-doc param name

Tejun Heo (1):
      sata_sis: fix SCR read breakage

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index bbaa545..629eadb 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1392,7 +1392,7 @@ static void ata_qc_complete_internal(struct ata_queued_cmd *qc)
  *	@tf: Taskfile registers for the command and the result
  *	@cdb: CDB for packet command
  *	@dma_dir: Data tranfer direction of the command
- *	@sg: sg list for the data buffer of the command
+ *	@sgl: sg list for the data buffer of the command
  *	@n_elem: Number of sg entries
  *	@timeout: Timeout in msecs (0 for default)
  *
diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index 53070f6..d753e56 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -40,7 +40,7 @@
 #include <asm/msr.h>
 
 #define DRV_NAME	"pata_cs5536"
-#define DRV_VERSION	"0.0.5"
+#define DRV_VERSION	"0.0.6"
 
 enum {
 	CFG			= 0,
@@ -214,7 +214,7 @@ static void cs5536_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 		cs5536_read(pdev, DTC, &dtc);
 
 		dtc &= ~(IDE_DRV_MASK << dshift);
-		dtc |= mwdma_timings[mode] << dshift;
+		dtc |= mwdma_timings[mode - XFER_MW_DMA_0] << dshift;
 
 		cs5536_write(pdev, DTC, dtc);
 	}
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index 8d98a9f..f147dc7 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -92,7 +92,7 @@ static struct scsi_host_template sis_sht = {
 	.queuecommand		= ata_scsi_queuecmd,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
-	.sg_tablesize		= ATA_MAX_PRD,
+	.sg_tablesize		= LIBATA_MAX_PRD,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
 	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
@@ -166,11 +166,11 @@ static unsigned int get_scr_cfg_addr(struct ata_port *ap, unsigned int sc_reg)
 	return addr;
 }
 
-static u32 sis_scr_cfg_read (struct ata_port *ap, unsigned int sc_reg)
+static u32 sis_scr_cfg_read (struct ata_port *ap, unsigned int sc_reg, u32 *val)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	unsigned int cfg_addr = get_scr_cfg_addr(ap, sc_reg);
-	u32 val, val2 = 0;
+	u32 val2 = 0;
 	u8 pmr;
 
 	if (sc_reg == SCR_ERROR) /* doesn't exist in PCI cfg space */
@@ -178,13 +178,16 @@ static u32 sis_scr_cfg_read (struct ata_port *ap, unsigned int sc_reg)
 
 	pci_read_config_byte(pdev, SIS_PMR, &pmr);
 
-	pci_read_config_dword(pdev, cfg_addr, &val);
+	pci_read_config_dword(pdev, cfg_addr, val);
 
 	if ((pdev->device == 0x0182) || (pdev->device == 0x0183) ||
 	    (pdev->device == 0x1182) || (pmr & SIS_PMR_COMBINED))
 		pci_read_config_dword(pdev, cfg_addr+0x10, &val2);
 
-	return (val|val2) &  0xfffffffb; /* avoid problems with powerdowned ports */
+	*val |= val2;
+	*val &= 0xfffffffb;	/* avoid problems with powerdowned ports */
+
+	return 0;
 }
 
 static void sis_scr_cfg_write (struct ata_port *ap, unsigned int sc_reg, u32 val)
@@ -214,7 +217,7 @@ static int sis_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 		return -EINVAL;
 
 	if (ap->flags & SIS_FLAG_CFGSCR)
-		return sis_scr_cfg_read(ap, sc_reg);
+		return sis_scr_cfg_read(ap, sc_reg, val);
 
 	pci_read_config_byte(pdev, SIS_PMR, &pmr);
 
