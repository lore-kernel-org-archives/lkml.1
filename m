Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087AbZAMPjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbZAMPjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 10:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZAMPjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 10:39:36 -0500
Received: from havoc.gtf.org ([69.61.125.42]:56110 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbZAMPjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 10:39:35 -0500
Date: Tue, 13 Jan 2009 10:39:34 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20090113153934.GA24208@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-sff.c  |    9 ++++++---
 drivers/ata/pata_it821x.c |   17 +++++++++++++----
 2 files changed, 19 insertions(+), 7 deletions(-)

Alan Cox (1):
      pata_it821x: Update RDC UDMA handling

Christian Borntraeger (1):
      ata: fix wrong WARN_ON_ONCE

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 0eae9b4..5a4aad1 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1013,9 +1013,12 @@ next_sg:
 		qc->cursg_ofs = 0;
 	}
 
-	/* consumed can be larger than count only for the last transfer */
-	WARN_ON_ONCE(qc->cursg && count != consumed);
-
+	/*
+	 * There used to be a  WARN_ON_ONCE(qc->cursg && count != consumed);
+	 * Unfortunately __atapi_pio_bytes doesn't know enough to do the WARN
+	 * check correctly as it doesn't know if it is the last request being
+	 * made. Somebody should implement a proper sanity check.
+	 */
 	if (bytes)
 		goto next_sg;
 	return 0;
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index f828a29..f1bb2f9 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -80,7 +80,7 @@
 
 
 #define DRV_NAME "pata_it821x"
-#define DRV_VERSION "0.4.0"
+#define DRV_VERSION "0.4.2"
 
 struct it821x_dev
 {
@@ -494,8 +494,6 @@ static int it821x_smart_set_mode(struct ata_link *link, struct ata_device **unus
  *	special. In our case we need to lock the sector count to avoid
  *	blowing the brains out of the firmware with large LBA48 requests
  *
- *	FIXME: When FUA appears we need to block FUA too. And SMART and
- *	basically we need to filter commands for this chip.
  */
 
 static void it821x_dev_config(struct ata_device *adev)
@@ -890,6 +888,13 @@ static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
+		.udma_mask = ATA_UDMA6,
+		.port_ops = &it821x_rdc_port_ops
+	};
+	static const struct ata_port_info info_rdc_11 = {
+		.flags = ATA_FLAG_SLAVE_POSS,
+		.pio_mask = 0x1f,
+		.mwdma_mask = 0x07,
 		/* No UDMA */
 		.port_ops = &it821x_rdc_port_ops
 	};
@@ -903,7 +908,11 @@ static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		return rc;
 		
 	if (pdev->vendor == PCI_VENDOR_ID_RDC) {
-		ppi[0] = &info_rdc;
+		/* Deal with Vortex86SX */
+		if (pdev->revision == 0x11)
+			ppi[0] = &info_rdc_11;
+		else
+			ppi[0] = &info_rdc;
 	} else {
 		/* Force the card into bypass mode if so requested */
 		if (it8212_noraid) {
