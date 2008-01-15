Return-Path: <linux-kernel-owner+w=401wt.eu-S1755809AbYAODoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbYAODoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 22:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbYAODoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 22:44:12 -0500
Received: from havoc.gtf.org ([69.61.125.42]:42017 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbYAODoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 22:44:10 -0500
Date: Mon, 14 Jan 2008 22:44:09 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20080115034409.GA3457@havoc.gtf.org>
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

 drivers/ata/ata_piix.c    |   51 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata-scsi.c |    6 ++--
 drivers/ata/sata_sil24.c  |    5 +++-
 3 files changed, 58 insertions(+), 4 deletions(-)

Tejun Heo (4):
      ata_piix: ignore ATA_DMA_ERR on vmware ich4
      sata_sil24: fix stupid typo
      sata_sil24: freeze on non-dev errors reported via CERR
      libata: relocate sdev->manage_start_stop configuration

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index bb62a58..b406b39 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -132,6 +132,7 @@ enum {
 	ich8_2port_sata,
 	ich8m_apple_sata_ahci,		/* locks up on second port enable */
 	tolapai_sata_ahci,
+	piix_pata_vmw,			/* PIIX4 for VMware, spurious DMA_ERR */
 
 	/* constants for mapping table */
 	P0			= 0,  /* port 0 */
@@ -165,6 +166,7 @@ static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev);
 static void piix_set_dmamode(struct ata_port *ap, struct ata_device *adev);
 static void ich_set_dmamode(struct ata_port *ap, struct ata_device *adev);
 static int ich_pata_cable_detect(struct ata_port *ap);
+static u8 piix_vmw_bmdma_status(struct ata_port *ap);
 #ifdef CONFIG_PM
 static int piix_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
 static int piix_pci_device_resume(struct pci_dev *pdev);
@@ -175,6 +177,8 @@ static unsigned int in_module_init = 1;
 static const struct pci_device_id piix_pci_tbl[] = {
 	/* Intel PIIX3 for the 430HX etc */
 	{ 0x8086, 0x7010, PCI_ANY_ID, PCI_ANY_ID, 0, 0, piix_pata_mwdma },
+	/* VMware ICH4 */
+	{ 0x8086, 0x7111, 0x15ad, 0x1976, 0, 0, piix_pata_vmw },
 	/* Intel PIIX4 for the 430TX/440BX/MX chipset: UDMA 33 */
 	/* Also PIIX4E (fn3 rev 2) and PIIX4M (fn3 rev 3) */
 	{ 0x8086, 0x7111, PCI_ANY_ID, PCI_ANY_ID, 0, 0, piix_pata_33 },
@@ -383,6 +387,38 @@ static const struct ata_port_operations piix_sata_ops = {
 	.port_start		= ata_port_start,
 };
 
+static const struct ata_port_operations piix_vmw_ops = {
+	.set_piomode		= piix_set_piomode,
+	.set_dmamode		= piix_set_dmamode,
+	.mode_filter		= ata_pci_default_filter,
+
+	.tf_load		= ata_tf_load,
+	.tf_read		= ata_tf_read,
+	.check_status		= ata_check_status,
+	.exec_command		= ata_exec_command,
+	.dev_select		= ata_std_dev_select,
+
+	.bmdma_setup		= ata_bmdma_setup,
+	.bmdma_start		= ata_bmdma_start,
+	.bmdma_stop		= ata_bmdma_stop,
+	.bmdma_status		= piix_vmw_bmdma_status,
+	.qc_prep		= ata_qc_prep,
+	.qc_issue		= ata_qc_issue_prot,
+	.data_xfer		= ata_data_xfer,
+
+	.freeze			= ata_bmdma_freeze,
+	.thaw			= ata_bmdma_thaw,
+	.error_handler		= piix_pata_error_handler,
+	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.cable_detect		= ata_cable_40wire,
+
+	.irq_handler		= ata_interrupt,
+	.irq_clear		= ata_bmdma_irq_clear,
+	.irq_on			= ata_irq_on,
+
+	.port_start		= ata_port_start,
+};
+
 static const struct piix_map_db ich5_map_db = {
 	.mask = 0x7,
 	.port_enable = 0x3,
@@ -623,6 +659,16 @@ static struct ata_port_info piix_port_info[] = {
 		.port_ops	= &piix_sata_ops,
 	},
 
+	[piix_pata_vmw] =
+	{
+		.sht		= &piix_sht,
+		.flags		= PIIX_PATA_FLAGS,
+		.pio_mask	= 0x1f,	/* pio0-4 */
+		.mwdma_mask	= 0x06, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
+		.udma_mask	= ATA_UDMA_MASK_40C,
+		.port_ops	= &piix_vmw_ops,
+	},
+
 };
 
 static struct pci_bits piix_enable_bits[] = {
@@ -1135,6 +1181,11 @@ static int piix_pci_device_resume(struct pci_dev *pdev)
 }
 #endif
 
+static u8 piix_vmw_bmdma_status(struct ata_port *ap)
+{
+	return ata_bmdma_status(ap) & ~ATA_DMA_ERR;
+}
+
 #define AHCI_PCI_BAR 5
 #define AHCI_GLOBAL_CTL 0x04
 #define AHCI_ENABLE (1 << 31)
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 264ae60..14daf48 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -841,6 +841,9 @@ static void ata_scsi_dev_config(struct scsi_device *sdev,
 		blk_queue_max_hw_segments(q, q->max_hw_segments - 1);
 	}
 
+	if (dev->class == ATA_DEV_ATA)
+		sdev->manage_start_stop = 1;
+
 	if (dev->flags & ATA_DFLAG_AN)
 		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
 
@@ -872,9 +875,6 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
 
 	ata_scsi_sdev_config(sdev);
 
-	if (dev->class == ATA_DEV_ATA)
-		sdev->manage_start_stop = 1;
-
 	if (dev)
 		ata_scsi_dev_config(sdev, dev);
 
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index b4c674d..864c1c1 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -301,7 +301,7 @@ static struct sil24_cerr_info {
 	[PORT_CERR_PKT_PROT]	= { AC_ERR_HSM, ATA_EH_SOFTRESET,
 				    "invalid data directon for ATAPI CDB" },
 	[PORT_CERR_SGT_BOUNDARY] = { AC_ERR_SYSTEM, ATA_EH_SOFTRESET,
-				     "SGT no on qword boundary" },
+				     "SGT not on qword boundary" },
 	[PORT_CERR_SGT_TGTABRT]	= { AC_ERR_HOST_BUS, ATA_EH_SOFTRESET,
 				    "PCI target abort while fetching SGT" },
 	[PORT_CERR_SGT_MSTABRT]	= { AC_ERR_HOST_BUS, ATA_EH_SOFTRESET,
@@ -1094,10 +1094,13 @@ static void sil24_error_intr(struct ata_port *ap)
 		if (ci && ci->desc) {
 			err_mask |= ci->err_mask;
 			action |= ci->action;
+			if (action & ATA_EH_RESET_MASK)
+				freeze = 1;
 			ata_ehi_push_desc(ehi, "%s", ci->desc);
 		} else {
 			err_mask |= AC_ERR_OTHER;
 			action |= ATA_EH_SOFTRESET;
+			freeze = 1;
 			ata_ehi_push_desc(ehi, "unknown command error %d",
 					  cerr);
 		}
