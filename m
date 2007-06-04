Return-Path: <linux-kernel-owner+w=401wt.eu-S1758757AbXFDUya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757AbXFDUya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbXFDUyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:54:22 -0400
Received: from havoc.gtf.org ([69.61.125.42]:37346 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbXFDUyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:54:20 -0400
Date: Mon, 4 Jun 2007 16:54:16 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patch] libata fix
Message-ID: <20070604205416.GG20299@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-core.c |   13 ++++---------
 drivers/ata/pata_via.c    |   12 ++++++------
 include/linux/libata.h    |    1 -
 3 files changed, 10 insertions(+), 16 deletions(-)

Tejun Heo (1):
      libata: always use polling SETXFER

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index af62514..4733f00 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3933,10 +3933,13 @@ static unsigned int ata_dev_set_xfermode(struct ata_device *dev)
 	/* set up set-features taskfile */
 	DPRINTK("set features - xfer mode\n");
 
+	/* Some controllers and ATAPI devices show flaky interrupt
+	 * behavior after setting xfer mode.  Use polling instead.
+	 */
 	ata_tf_init(dev, &tf);
 	tf.command = ATA_CMD_SET_FEATURES;
 	tf.feature = SETFEATURES_XFER;
-	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE | ATA_TFLAG_POLLING;
 	tf.protocol = ATA_PROT_NODATA;
 	tf.nsect = dev->xfer_mode;
 
@@ -5414,14 +5417,6 @@ unsigned int ata_qc_issue_prot(struct ata_queued_cmd *qc)
 		}
 	}
 
-	/* Some controllers show flaky interrupt behavior after
-	 * setting xfer mode.  Use polling instead.
-	 */
-	if (unlikely(qc->tf.command == ATA_CMD_SET_FEATURES &&
-		     qc->tf.feature == SETFEATURES_XFER) &&
-	    (ap->flags & ATA_FLAG_SETXFER_POLLING))
-		qc->tf.flags |= ATA_TFLAG_POLLING;
-
 	/* select the device */
 	ata_dev_select(ap, qc->dev->devno, 1, 0);
 
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index a8462f1..63eca29 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -452,7 +452,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Early VIA without UDMA support */
 	static const struct ata_port_info via_mwdma_info = {
 		.sht = &via_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SETXFER_POLLING,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.port_ops = &via_port_ops
@@ -460,7 +460,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Ditto with IRQ masking required */
 	static const struct ata_port_info via_mwdma_info_borked = {
 		.sht = &via_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SETXFER_POLLING,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.port_ops = &via_port_ops_noirq,
@@ -468,7 +468,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* VIA UDMA 33 devices (and borked 66) */
 	static const struct ata_port_info via_udma33_info = {
 		.sht = &via_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SETXFER_POLLING,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = 0x7,
@@ -477,7 +477,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* VIA UDMA 66 devices */
 	static const struct ata_port_info via_udma66_info = {
 		.sht = &via_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SETXFER_POLLING,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = 0x1f,
@@ -486,7 +486,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* VIA UDMA 100 devices */
 	static const struct ata_port_info via_udma100_info = {
 		.sht = &via_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SETXFER_POLLING,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = 0x3f,
@@ -495,7 +495,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* UDMA133 with bad AST (All current 133) */
 	static const struct ata_port_info via_udma133_info = {
 		.sht = &via_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SETXFER_POLLING,
+		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.udma_mask = 0x7f,	/* FIXME: should check north bridge */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 85f7b1b..a6a3113 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -171,7 +171,6 @@ enum {
 	ATA_FLAG_SKIP_D2H_BSY	= (1 << 12), /* can't wait for the first D2H
 					      * Register FIS clearing BSY */
 	ATA_FLAG_DEBUGMSG	= (1 << 13),
-	ATA_FLAG_SETXFER_POLLING= (1 << 14), /* use polling for SETXFER */
 	ATA_FLAG_IGN_SIMPLEX	= (1 << 15), /* ignore SIMPLEX */
 	ATA_FLAG_NO_IORDY	= (1 << 16), /* controller lacks iordy */
 	ATA_FLAG_ACPI_SATA	= (1 << 17), /* need native SATA ACPI layout */
