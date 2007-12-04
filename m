Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbXLDUKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbXLDUKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 15:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbXLDUKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 15:10:10 -0500
Received: from havoc.gtf.org ([69.61.125.42]:54254 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbXLDUKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 15:10:08 -0500
Date: Tue, 4 Dec 2007 15:10:07 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20071204201007.GA20326@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c     |    4 ++++
 drivers/ata/pata_amd.c |    5 +++--
 drivers/ata/pata_via.c |    4 ++--
 drivers/ata/sata_mv.c  |    9 +++++++++
 drivers/ata/sata_nv.c  |   32 +++++++++++++++++++++++---------
 5 files changed, 41 insertions(+), 13 deletions(-)

Bartlomiej Zolnierkiewicz (1):
      pata_amd/pata_via: de-couple programming of PIO/MWDMA and UDMA timings

Mark Lord (1):
      sata_mv:  Warn about HPT RocketRAID BIOS treatment of "Legacy" drives

Robert Hancock (1):
      sata_nv: don't use legacy DMA in ADMA mode (v3)

peerchen (1):
      ahci: add the Device IDs of MCP79 AHCI controller to ahci.c

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index ed9b407..4688dbf 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -536,6 +536,10 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(NVIDIA, 0x0ad9), board_ahci },		/* MCP77 */
 	{ PCI_VDEVICE(NVIDIA, 0x0ada), board_ahci },		/* MCP77 */
 	{ PCI_VDEVICE(NVIDIA, 0x0adb), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab4), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab5), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab6), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab7), board_ahci },		/* MCP79 */
 	{ PCI_VDEVICE(NVIDIA, 0x0ab8), board_ahci },		/* MCP79 */
 	{ PCI_VDEVICE(NVIDIA, 0x0ab9), board_ahci },		/* MCP79 */
 	{ PCI_VDEVICE(NVIDIA, 0x0aba), board_ahci },		/* MCP79 */
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index c5779ad..3cc27b5 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -25,7 +25,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_amd"
-#define DRV_VERSION "0.3.9"
+#define DRV_VERSION "0.3.10"
 
 /**
  *	timing_setup		-	shared timing computation and load
@@ -115,7 +115,8 @@ static void timing_setup(struct ata_port *ap, struct ata_device *adev, int offse
 	}
 
 	/* UDMA timing */
-	pci_write_config_byte(pdev, offset + 0x10 + (3 - dn), t);
+	if (at.udma)
+		pci_write_config_byte(pdev, offset + 0x10 + (3 - dn), t);
 }
 
 /**
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index a4175fb..453d72b 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -63,7 +63,7 @@
 #include <linux/dmi.h>
 
 #define DRV_NAME "pata_via"
-#define DRV_VERSION "0.3.2"
+#define DRV_VERSION "0.3.3"
 
 /*
  *	The following comes directly from Vojtech Pavlik's ide/pci/via82cxxx
@@ -296,7 +296,7 @@ static void via_do_set_mode(struct ata_port *ap, struct ata_device *adev, int mo
 	}
 
 	/* Set UDMA unless device is not UDMA capable */
-	if (udma_type) {
+	if (udma_type && t.udma) {
 		u8 cable80_status;
 
 		/* Get 80-wire cable detection bit */
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 8d864e5..fe0105d 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -2503,6 +2503,15 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 
 	case chip_7042:
 		hp_flags |= MV_HP_PCIE;
+		if (pdev->vendor == PCI_VENDOR_ID_TTI &&
+		    (pdev->device == 0x2300 || pdev->device == 0x2310))
+		{
+			printk(KERN_WARNING "sata_mv: Highpoint RocketRAID BIOS"
+				" will CORRUPT DATA on attached drives when"
+				" configured as \"Legacy\".  BEWARE!\n");
+			printk(KERN_WARNING "sata_mv: Use BIOS \"JBOD\" volumes"
+				" instead for safety.\n");
+		}
 	case chip_6042:
 		hpriv->ops = &mv6xxx_ops;
 		hp_flags |= MV_HP_GEN_IIE;
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 44f9e5d..ed5dc7c 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -791,11 +791,13 @@ static int nv_adma_check_atapi_dma(struct ata_queued_cmd *qc)
 
 static void nv_adma_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
 {
-	/* Since commands where a result TF is requested are not
-	   executed in ADMA mode, the only time this function will be called
-	   in ADMA mode will be if a command fails. In this case we
-	   don't care about going into register mode with ADMA commands
-	   pending, as the commands will all shortly be aborted anyway. */
+	/* Other than when internal or pass-through commands are executed,
+	   the only time this function will be called in ADMA mode will be
+	   if a command fails. In the failure case we don't care about going
+	   into register mode with ADMA commands pending, as the commands will
+	   all shortly be aborted anyway. We assume that NCQ commands are not
+	   issued via passthrough, which is the only way that switching into
+	   ADMA mode could abort outstanding commands. */
 	nv_adma_register_mode(ap);
 
 	ata_tf_read(ap, tf);
@@ -1359,11 +1361,9 @@ static int nv_adma_use_reg_mode(struct ata_queued_cmd *qc)
 	struct nv_adma_port_priv *pp = qc->ap->private_data;
 
 	/* ADMA engine can only be used for non-ATAPI DMA commands,
-	   or interrupt-driven no-data commands, where a result taskfile
-	   is not required. */
+	   or interrupt-driven no-data commands. */
 	if ((pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) ||
-	   (qc->tf.flags & ATA_TFLAG_POLLING) ||
-	   (qc->flags & ATA_QCFLAG_RESULT_TF))
+	   (qc->tf.flags & ATA_TFLAG_POLLING))
 		return 1;
 
 	if ((qc->flags & ATA_QCFLAG_DMAMAP) ||
@@ -1381,6 +1381,8 @@ static void nv_adma_qc_prep(struct ata_queued_cmd *qc)
 		       NV_CPB_CTL_IEN;
 
 	if (nv_adma_use_reg_mode(qc)) {
+		BUG_ON(!(pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) &&
+			(qc->flags & ATA_QCFLAG_DMAMAP));
 		nv_adma_register_mode(qc->ap);
 		ata_qc_prep(qc);
 		return;
@@ -1425,9 +1427,21 @@ static unsigned int nv_adma_qc_issue(struct ata_queued_cmd *qc)
 
 	VPRINTK("ENTER\n");
 
+	/* We can't handle result taskfile with NCQ commands, since
+	   retrieving the taskfile switches us out of ADMA mode and would abort
+	   existing commands. */
+	if (unlikely(qc->tf.protocol == ATA_PROT_NCQ &&
+		     (qc->flags & ATA_QCFLAG_RESULT_TF))) {
+		ata_dev_printk(qc->dev, KERN_ERR,
+			"NCQ w/ RESULT_TF not allowed\n");
+		return AC_ERR_SYSTEM;
+	}
+
 	if (nv_adma_use_reg_mode(qc)) {
 		/* use ATA register mode */
 		VPRINTK("using ATA register mode: 0x%lx\n", qc->flags);
+		BUG_ON(!(pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) &&
+			(qc->flags & ATA_QCFLAG_DMAMAP));
 		nv_adma_register_mode(qc->ap);
 		return ata_qc_issue_prot(qc);
 	} else
