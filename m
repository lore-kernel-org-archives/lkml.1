Return-Path: <linux-kernel-owner+w=401wt.eu-S1762149AbXIKCQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762149AbXIKCQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 22:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757143AbXIKCPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 22:15:54 -0400
Received: from havoc.gtf.org ([69.61.125.42]:48703 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756628AbXIKCPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 22:15:53 -0400
Date: Mon, 10 Sep 2007 22:15:52 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070911021552.GA10490@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-core.c   |    1 +
 drivers/ata/pata_it821x.c   |    4 ++++
 drivers/ata/pata_via.c      |   14 +++++++++++---
 drivers/ide/pci/via82cxxx.c |    1 +
 include/linux/pci_ids.h     |    1 +
 5 files changed, 18 insertions(+), 3 deletions(-)

Jeff Norden (1):
      pata_it821x: fix lost interrupt with atapi devices

Joseph Chan (1):
      [libata, IDE] add new VIA bridge to VIA PATA drivers

Laurent Riffard (1):
      Fix broken pata_via cable detection

Tejun Heo (1):
      libata clear horkage on ata_dev_init()

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index a3ee087..c43de9a 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6035,6 +6035,7 @@ void ata_dev_init(struct ata_device *dev)
 	 */
 	spin_lock_irqsave(ap->lock, flags);
 	dev->flags &= ~ATA_DFLAG_INIT_MASK;
+	dev->horkage = 0;
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	memset((void *)dev + ATA_DEVICE_CLEAR_OFFSET, 0,
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index ed637ae..5d8b91e 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -533,6 +533,10 @@ static int it821x_check_atapi_dma(struct ata_queued_cmd *qc)
 	struct ata_port *ap = qc->ap;
 	struct it821x_dev *itdev = ap->private_data;
 
+	/* Only use dma for transfers to/from the media. */
+	if (qc->nbytes < 2048)
+		return -EOPNOTSUPP;
+
 	/* No ATAPI DMA in smart mode */
 	if (itdev->smart)
 		return -EOPNOTSUPP;
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index ea18e33..636c4f1 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -97,6 +97,7 @@ static const struct via_isa_bridge {
 	u8 rev_max;
 	u16 flags;
 } via_isa_bridges[] = {
+	{ "vx800",	PCI_DEVICE_ID_VIA_VX800,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8237s",	PCI_DEVICE_ID_VIA_8237S,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8251",	PCI_DEVICE_ID_VIA_8251,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
@@ -243,7 +244,6 @@ static void via_do_set_mode(struct ata_port *ap, struct ata_device *adev, int mo
 	int ut;
 	int offset = 3 - (2*ap->port_no) - adev->devno;
 
-
 	/* Calculate the timing values we require */
 	ata_timing_compute(adev, mode, &t, T, UT);
 
@@ -290,9 +290,17 @@ static void via_do_set_mode(struct ata_port *ap, struct ata_device *adev, int mo
 			ut = t.udma ? (0xe0 | (FIT(t.udma, 2, 9) - 2)) : 0x07;
 			break;
 	}
+
 	/* Set UDMA unless device is not UDMA capable */
-	if (udma_type)
-		pci_write_config_byte(pdev, 0x50 + offset, ut);
+	if (udma_type) {
+		u8 cable80_status;
+
+		/* Get 80-wire cable detection bit */
+		pci_read_config_byte(pdev, 0x50 + offset, &cable80_status);
+		cable80_status &= 0x10;
+
+		pci_write_config_byte(pdev, 0x50 + offset, ut | cable80_status);
+	}
 }
 
 static void via_set_piomode(struct ata_port *ap, struct ata_device *adev)
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index 581316f..8c53938 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -74,6 +74,7 @@ static struct via_isa_bridge {
 	u8 udma_mask;
 	u8 flags;
 } via_isa_bridges[] = {
+	{ "vx800",	PCI_DEVICE_ID_VIA_VX800,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
 	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
 	{ "vt8237s",	PCI_DEVICE_ID_VIA_8237S,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
 	{ "vt6410",	PCI_DEVICE_ID_VIA_6410,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 17168f3..d41747b 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1343,6 +1343,7 @@
 #define PCI_DEVICE_ID_VIA_8231_4	0x8235
 #define PCI_DEVICE_ID_VIA_8365_1	0x8305
 #define PCI_DEVICE_ID_VIA_CX700		0x8324
+#define PCI_DEVICE_ID_VIA_VX800		0x8353
 #define PCI_DEVICE_ID_VIA_8371_1	0x8391
 #define PCI_DEVICE_ID_VIA_82C598_1	0x8598
 #define PCI_DEVICE_ID_VIA_838X_1	0xB188
