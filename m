Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbYFSA7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbYFSA7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 20:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbYFSA7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 20:59:35 -0400
Received: from havoc.gtf.org ([69.61.125.42]:33741 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117AbYFSA7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 20:59:34 -0400
Date: Wed, 18 Jun 2008 20:59:33 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20080619005933.GA6253@havoc.gtf.org>
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

 drivers/ata/Kconfig       |   10 +++++++++-
 drivers/ata/ahci.c        |   23 ++++++++++++++++++++---
 drivers/ata/ata_piix.c    |    7 +++++++
 drivers/ata/libata-core.c |    4 ++--
 drivers/ata/libata-scsi.c |   16 +++++++---------
 drivers/ata/libata.h      |    2 +-
 drivers/ata/sata_mv.c     |   21 +++++++++++++++++++++
 7 files changed, 67 insertions(+), 16 deletions(-)

Ben Dooks (1):
      LIBATA: Add HAVE_PATA_PLATFORM to select PATA_PLATFORM driver

Mark Lord (2):
      sata_mv: enable async_notify for 60x1 Rev.C0 and higher
      sata_mv: warn on PIO with multiple DRQs

Tejun Heo (4):
      ahci: jmb361 has only one port
      libata: don't check whether to use DMA or not for no data commands
      ata_piix: add TECRA M4 to broken suspend list
      ahci: sis can't do PMP

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 9bf2986..ae84949 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -651,9 +651,17 @@ config PATA_WINBOND_VLB
 	  Support for the Winbond W83759A controller on Vesa Local Bus
 	  systems.
 
+config HAVE_PATA_PLATFORM
+	bool
+	help
+	  This is an internal configuration node for any machine that
+	  uses pata-platform driver to enable the relevant driver in the
+	  configuration structure without having to submit endless patches
+	  to update the PATA_PLATFORM entry.
+
 config PATA_PLATFORM
 	tristate "Generic platform device PATA support"
-	depends on EMBEDDED || ARCH_RPC || PPC
+	depends on EMBEDDED || ARCH_RPC || PPC || HAVE_PATA_PLATFORM
 	help
 	  This option enables support for generic directly connected ATA
 	  devices commonly found on embedded systems.
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 966ab40..6a4a2a2 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -90,6 +90,7 @@ enum {
 	board_ahci_mv		= 4,
 	board_ahci_sb700	= 5,
 	board_ahci_mcp65	= 6,
+	board_ahci_nopmp	= 7,
 
 	/* global controller registers */
 	HOST_CAP		= 0x00, /* host capabilities */
@@ -401,6 +402,14 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
+	/* board_ahci_nopmp */
+	{
+		AHCI_HFLAGS	(AHCI_HFLAG_NO_PMP),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= 0x1f, /* pio0-4 */
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
 };
 
 static const struct pci_device_id ahci_pci_tbl[] = {
@@ -525,9 +534,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(NVIDIA, 0x0bc7), board_ahci },		/* MCP7B */
 
 	/* SiS */
-	{ PCI_VDEVICE(SI, 0x1184), board_ahci }, /* SiS 966 */
-	{ PCI_VDEVICE(SI, 0x1185), board_ahci }, /* SiS 966 */
-	{ PCI_VDEVICE(SI, 0x0186), board_ahci }, /* SiS 968 */
+	{ PCI_VDEVICE(SI, 0x1184), board_ahci_nopmp },		/* SiS 966 */
+	{ PCI_VDEVICE(SI, 0x1185), board_ahci_nopmp },		/* SiS 968 */
+	{ PCI_VDEVICE(SI, 0x0186), board_ahci_nopmp },		/* SiS 968 */
 
 	/* Marvell */
 	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
@@ -653,6 +662,14 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 		cap &= ~HOST_CAP_PMP;
 	}
 
+	if (pdev->vendor == PCI_VENDOR_ID_JMICRON && pdev->device == 0x2361 &&
+	    port_map != 1) {
+		dev_printk(KERN_INFO, &pdev->dev,
+			   "JMB361 has only one port, port_map 0x%x -> 0x%x\n",
+			   port_map, 1);
+		port_map = 1;
+	}
+
 	/*
 	 * Temporary Marvell 6145 hack: PATA port presence
 	 * is asserted through the standard AHCI port
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 81b7ae3..a90ae03 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1043,6 +1043,13 @@ static int piix_broken_suspend(void)
 			},
 		},
 		{
+			.ident = "TECRA M4",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "TECRA M4"),
+			},
+		},
+		{
 			.ident = "TECRA M5",
 			.matches = {
 				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index cc816ca..303fc0d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4297,7 +4297,7 @@ void ata_sg_clean(struct ata_queued_cmd *qc)
 }
 
 /**
- *	ata_check_atapi_dma - Check whether ATAPI DMA can be supported
+ *	atapi_check_dma - Check whether ATAPI DMA can be supported
  *	@qc: Metadata associated with taskfile to check
  *
  *	Allow low-level driver to filter ATA PACKET commands, returning
@@ -4310,7 +4310,7 @@ void ata_sg_clean(struct ata_queued_cmd *qc)
  *	RETURNS: 0 when ATAPI DMA can be used
  *               nonzero otherwise
  */
-int ata_check_atapi_dma(struct ata_queued_cmd *qc)
+int atapi_check_dma(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 2e6e162..57a4364 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2343,8 +2343,8 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 {
 	struct scsi_cmnd *scmd = qc->scsicmd;
 	struct ata_device *dev = qc->dev;
-	int using_pio = (dev->flags & ATA_DFLAG_PIO);
 	int nodata = (scmd->sc_data_direction == DMA_NONE);
+	int using_pio = !nodata && (dev->flags & ATA_DFLAG_PIO);
 	unsigned int nbytes;
 
 	memset(qc->cdb, 0, dev->cdb_len);
@@ -2362,7 +2362,7 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	ata_qc_set_pc_nbytes(qc);
 
 	/* check whether ATAPI DMA is safe */
-	if (!using_pio && ata_check_atapi_dma(qc))
+	if (!nodata && !using_pio && atapi_check_dma(qc))
 		using_pio = 1;
 
 	/* Some controller variants snoop this value for Packet
@@ -2402,13 +2402,11 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	qc->tf.lbam = (nbytes & 0xFF);
 	qc->tf.lbah = (nbytes >> 8);
 
-	if (using_pio || nodata) {
-		/* no data, or PIO data xfer */
-		if (nodata)
-			qc->tf.protocol = ATAPI_PROT_NODATA;
-		else
-			qc->tf.protocol = ATAPI_PROT_PIO;
-	} else {
+	if (nodata)
+		qc->tf.protocol = ATAPI_PROT_NODATA;
+	else if (using_pio)
+		qc->tf.protocol = ATAPI_PROT_PIO;
+	else {
 		/* DMA data xfer */
 		qc->tf.protocol = ATAPI_PROT_DMA;
 		qc->tf.feature |= ATAPI_PKT_DMA;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 4514283..1cf803a 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -106,7 +106,7 @@ extern void ata_sg_clean(struct ata_queued_cmd *qc);
 extern void ata_qc_free(struct ata_queued_cmd *qc);
 extern void ata_qc_issue(struct ata_queued_cmd *qc);
 extern void __ata_qc_complete(struct ata_queued_cmd *qc);
-extern int ata_check_atapi_dma(struct ata_queued_cmd *qc);
+extern int atapi_check_dma(struct ata_queued_cmd *qc);
 extern void swap_buf_le16(u16 *buf, unsigned int buf_words);
 extern void ata_dev_init(struct ata_device *dev);
 extern void ata_link_init(struct ata_port *ap, struct ata_link *link, int pmp);
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 60391e9..28092bc 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1322,6 +1322,9 @@ static int mv_port_start(struct ata_port *ap)
 		goto out_port_free_dma_mem;
 	memset(pp->crpb, 0, MV_CRPB_Q_SZ);
 
+	/* 6041/6081 Rev. "C0" (and newer) are okay with async notify */
+	if (hpriv->hp_flags & MV_HP_ERRATA_60X1C0)
+		ap->flags |= ATA_FLAG_AN;
 	/*
 	 * For GEN_I, there's no NCQ, so we only allocate a single sg_tbl.
 	 * For later hardware, we need one unique sg_tbl per NCQ tag.
@@ -1592,6 +1595,24 @@ static unsigned int mv_qc_issue(struct ata_queued_cmd *qc)
 
 	if ((qc->tf.protocol != ATA_PROT_DMA) &&
 	    (qc->tf.protocol != ATA_PROT_NCQ)) {
+		static int limit_warnings = 10;
+		/*
+		 * Errata SATA#16, SATA#24: warn if multiple DRQs expected.
+		 *
+		 * Someday, we might implement special polling workarounds
+		 * for these, but it all seems rather unnecessary since we
+		 * normally use only DMA for commands which transfer more
+		 * than a single block of data.
+		 *
+		 * Much of the time, this could just work regardless.
+		 * So for now, just log the incident, and allow the attempt.
+		 */
+		if (limit_warnings && (qc->nbytes / qc->sect_size) > 1) {
+			--limit_warnings;
+			ata_link_printk(qc->dev->link, KERN_WARNING, DRV_NAME
+					": attempting PIO w/multiple DRQ: "
+					"this may fail due to h/w errata\n");
+		}
 		/*
 		 * We're about to send a non-EDMA capable command to the
 		 * port.  Turn off EDMA so there won't be problems accessing
