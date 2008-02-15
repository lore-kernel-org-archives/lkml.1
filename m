Return-Path: <linux-kernel-owner+w=401wt.eu-S1763383AbYBOVUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763383AbYBOVUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756899AbYBOVUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 16:20:44 -0500
Received: from havoc.gtf.org ([69.61.125.42]:35966 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755197AbYBOVUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 16:20:42 -0500
Date: Fri, 15 Feb 2008 16:20:41 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20080215212041.GA32043@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Got another couple sata_mv fixes pending too...  coming soon.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ata_piix.c     |    2 +-
 drivers/ata/libata-core.c  |    1 -
 drivers/ata/libata-scsi.c  |    2 +-
 drivers/ata/pata_acpi.c    |    4 ++--
 drivers/ata/pata_amd.c     |    7 ++-----
 drivers/ata/pata_cs5536.c  |   10 +++++-----
 drivers/ata/pata_jmicron.c |    3 ++-
 drivers/ata/pata_legacy.c  |    2 --
 drivers/ata/pata_marvell.c |    4 ++--
 drivers/ata/pata_scc.c     |    2 ++
 drivers/ata/sata_mv.c      |    4 ++--
 drivers/ata/sata_promise.c |    2 +-
 drivers/ata/sata_via.c     |    4 ++--
 13 files changed, 22 insertions(+), 25 deletions(-)

Akira Iguchi (1):
      pata_scc.c: add thaw ops

Harvey Harrison (11):
      ata: make ata_scsiop_inq_89 static in libata-scsi.c
      ata: fix sparse warning in libata-core.c
      ata: fix sparse warning in ata_piix.c
      ata: fix sparse warning in sata_promise.c
      ata: fix sparse warning in sata_via.c
      ata: fix sparse warnings in sata_mv.c
      ata: sparse fixes for pata_amd.c
      ata: fix sparse warning in pata_cs5536.c
      ata: fix sparse warning in pata_jmicron.c
      ata: fix sparse warning in pata_marvell.c
      ata: fix sparse warning in pata_acpi.c

Martin K. Petersen (1):
      pata_cs5536.c bugfix

Tejun Heo (1):
      pata_legacy: don't call ata_host_detach() after initialization failure

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 9c2515f..752e7d2 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1652,7 +1652,7 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 		u8 tmp;
 		pci_read_config_byte(pdev, PIIX_SCC, &tmp);
 		if (tmp == PIIX_AHCI_DEVICE) {
-			int rc = piix_disable_ahci(pdev);
+			rc = piix_disable_ahci(pdev);
 			if (rc)
 				return rc;
 		}
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 004dae4..beaa3a9 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -7086,7 +7086,6 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 	DPRINTK("probe begin\n");
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
-		int rc;
 
 		/* probe */
 		if (ap->ops->error_handler) {
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index c02c490..1cea18f 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1862,7 +1862,7 @@ unsigned int ata_scsiop_inq_83(struct ata_scsi_args *args, u8 *rbuf,
  *	spin_lock_irqsave(host lock)
  */
 
-unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf,
+static unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf,
 			      unsigned int buflen)
 {
 	u8 pbuf[60];
diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index 244098a..bdc3b9d 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -77,8 +77,8 @@ static int pacpi_cable_detect(struct ata_port *ap)
 
 static void pacpi_error_handler(struct ata_port *ap)
 {
-	return ata_bmdma_drive_eh(ap, pacpi_pre_reset, ata_std_softreset,
-				  NULL, ata_std_postreset);
+	ata_bmdma_drive_eh(ap, pacpi_pre_reset, ata_std_softreset, NULL,
+			   ata_std_postreset);
 }
 
 /**
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index ea567e2..4b8d9b5 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -146,9 +146,8 @@ static int amd_pre_reset(struct ata_link *link, unsigned long deadline)
 
 static void amd_error_handler(struct ata_port *ap)
 {
-	return ata_bmdma_drive_eh(ap, amd_pre_reset,
-				      ata_std_softreset, NULL,
-				      ata_std_postreset);
+	ata_bmdma_drive_eh(ap, amd_pre_reset, ata_std_softreset, NULL,
+			   ata_std_postreset);
 }
 
 static int amd_cable_detect(struct ata_port *ap)
@@ -506,7 +505,6 @@ static struct ata_port_operations amd133_port_ops = {
 static struct ata_port_operations nv100_port_ops = {
 	.set_piomode	= nv100_set_piomode,
 	.set_dmamode	= nv100_set_dmamode,
-	.mode_filter	= ata_pci_default_filter,
 	.tf_load	= ata_tf_load,
 	.tf_read	= ata_tf_read,
 	.check_status 	= ata_check_status,
@@ -541,7 +539,6 @@ static struct ata_port_operations nv100_port_ops = {
 static struct ata_port_operations nv133_port_ops = {
 	.set_piomode	= nv133_set_piomode,
 	.set_dmamode	= nv133_set_dmamode,
-	.mode_filter	= ata_pci_default_filter,
 	.tf_load	= ata_tf_load,
 	.tf_read	= ata_tf_read,
 	.check_status 	= ata_check_status,
diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index d753e56..1c4ff9b 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -40,7 +40,7 @@
 #include <asm/msr.h>
 
 #define DRV_NAME	"pata_cs5536"
-#define DRV_VERSION	"0.0.6"
+#define DRV_VERSION	"0.0.7"
 
 enum {
 	CFG			= 0,
@@ -85,7 +85,7 @@ static const u8 pci_reg[4] = {
 	PCI_IDE_CFG, PCI_IDE_DTC, PCI_IDE_CAST, PCI_IDE_ETC,
 };
 
-static inline int cs5536_read(struct pci_dev *pdev, int reg, int *val)
+static inline int cs5536_read(struct pci_dev *pdev, int reg, u32 *val)
 {
 	if (unlikely(use_msr)) {
 		u32 dummy;
@@ -153,8 +153,8 @@ static void cs5536_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	struct ata_device *pair = ata_dev_pair(adev);
 	int mode = adev->pio_mode - XFER_PIO_0;
 	int cmdmode = mode;
-	int dshift = ap->port_no ? IDE_D1_SHIFT : IDE_D0_SHIFT;
-	int cshift = ap->port_no ? IDE_CAST_D1_SHIFT : IDE_CAST_D0_SHIFT;
+	int dshift = adev->devno ? IDE_D1_SHIFT : IDE_D0_SHIFT;
+	int cshift = adev->devno ? IDE_CAST_D1_SHIFT : IDE_CAST_D0_SHIFT;
 	u32 dtc, cast, etc;
 
 	if (pair)
@@ -201,7 +201,7 @@ static void cs5536_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u32 dtc, etc;
 	int mode = adev->dma_mode;
-	int dshift = ap->port_no ? IDE_D1_SHIFT : IDE_D0_SHIFT;
+	int dshift = adev->devno ? IDE_D1_SHIFT : IDE_D0_SHIFT;
 
 	if (mode >= XFER_UDMA_0) {
 		cs5536_read(pdev, ETC, &etc);
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index 5b8174d..00bbbbd 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -115,7 +115,8 @@ static int jmicron_pre_reset(struct ata_link *link, unsigned long deadline)
 
 static void jmicron_error_handler(struct ata_port *ap)
 {
-	return ata_bmdma_drive_eh(ap, jmicron_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
+	ata_bmdma_drive_eh(ap, jmicron_pre_reset, ata_std_softreset, NULL,
+			   ata_std_postreset);
 }
 
 /* No PIO or DMA methods needed for this device */
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 6c59969..d2177f7 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -1278,8 +1278,6 @@ static __init int legacy_init_one(struct legacy_probe *probe)
 		}
 	}
 fail:
-	if (host)
-		ata_host_detach(host);
 	platform_device_unregister(pdev);
 	return ret;
 }
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index 9afc8a3..a81f25d 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -85,8 +85,8 @@ static int marvell_cable_detect(struct ata_port *ap)
 
 static void marvell_error_handler(struct ata_port *ap)
 {
-	return ata_bmdma_drive_eh(ap, marvell_pre_reset, ata_std_softreset,
-				  NULL, ata_std_postreset);
+	ata_bmdma_drive_eh(ap, marvell_pre_reset, ata_std_softreset, NULL,
+			   ata_std_postreset);
 }
 
 /* No PIO or DMA methods needed for this device */
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index 55055b2..6c016de 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -1007,6 +1007,8 @@ static const struct ata_port_operations scc_pata_ops = {
 	.qc_issue		= ata_qc_issue_prot,
 
 	.freeze			= scc_bmdma_freeze,
+	.thaw			= ata_bmdma_thaw,
+
 	.error_handler		= scc_error_handler,
 	.post_internal_cmd	= scc_bmdma_stop,
 
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 04b5717..2ecd44d 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1542,7 +1542,7 @@ static void mv_err_intr(struct ata_port *ap, struct ata_queued_cmd *qc)
 		eh_freeze_mask = EDMA_EH_FREEZE_5;
 
 		if (edma_err_cause & EDMA_ERR_SELF_DIS_5) {
-			struct mv_port_priv *pp	= ap->private_data;
+			pp = ap->private_data;
 			pp->pp_flags &= ~MV_PP_FLAG_EDMA_EN;
 			ata_ehi_push_desc(ehi, "EDMA self-disable");
 		}
@@ -1550,7 +1550,7 @@ static void mv_err_intr(struct ata_port *ap, struct ata_queued_cmd *qc)
 		eh_freeze_mask = EDMA_EH_FREEZE;
 
 		if (edma_err_cause & EDMA_ERR_SELF_DIS) {
-			struct mv_port_priv *pp	= ap->private_data;
+			pp = ap->private_data;
 			pp->pp_flags &= ~MV_PP_FLAG_EDMA_EN;
 			ata_ehi_push_desc(ehi, "EDMA self-disable");
 		}
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index a07d319..f251a5f 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -543,7 +543,7 @@ static void pdc_fill_sg(struct ata_queued_cmd *qc)
 	idx = 0;
 	for_each_sg(qc->sg, sg, qc->n_elem, si) {
 		u32 addr, offset;
-		u32 sg_len, len;
+		u32 sg_len;
 
 		/* determine if physical DMA addr spans 64K boundary.
 		 * Note h/w doesn't support 64-bit, so we unconditionally
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 30caa03..0d03f44 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -333,8 +333,8 @@ static int vt6420_prereset(struct ata_link *link, unsigned long deadline)
 
 static void vt6420_error_handler(struct ata_port *ap)
 {
-	return ata_bmdma_drive_eh(ap, vt6420_prereset, ata_std_softreset,
-				  NULL, ata_std_postreset);
+	ata_bmdma_drive_eh(ap, vt6420_prereset, ata_std_softreset, NULL,
+			   ata_std_postreset);
 }
 
 static int vt6421_pata_cable_detect(struct ata_port *ap)
